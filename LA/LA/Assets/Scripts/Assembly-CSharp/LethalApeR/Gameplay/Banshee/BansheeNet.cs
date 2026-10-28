using System;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	public sealed class BansheeNet : MonoBehaviourPunCallbacks, IOnEventCallback
	{
		public struct State
		{
			public int epoch;

			public BansheePhase phase;

			public BansheeForm form;

			public byte grave;

			public int target;

			public int phaseStartMs;

			public BansheeExit exit;
		}

		public enum Target
		{
			Others = 0,
			Master = 1,
			Actor = 2
		}

		public const byte EventCode = 134;

		private const byte OpState = 0;

		private const byte OpMotion = 1;

		private const byte OpMeters = 2;

		private const byte OpCaught = 3;

		private static BansheeNet _instance;

		private static readonly RaiseEventOptions ToOthers = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.Others
		};

		private static readonly RaiseEventOptions ToMaster = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.MasterClient
		};

		private static readonly RaiseEventOptions ToActor = new RaiseEventOptions
		{
			TargetActors = new int[1]
		};

		private static readonly object[] MotionPayload = new object[5];

		public static Action<object[], Target, int, bool> SendOverride { get; set; }

		public static State? LastState { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Auto] BansheeNet");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<BansheeNet>();
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
			LastState = null;
			SendOverride = null;
		}

		public static void SendState(in State s, int toActor = 0)
		{
			LastState = s;
			Send(new object[8]
			{
				(byte)0,
				s.epoch,
				(byte)s.phase,
				(byte)s.form,
				s.grave,
				s.target,
				s.phaseStartMs,
				(byte)s.exit
			}, (toActor > 0) ? Target.Actor : Target.Others, toActor, reliable: true);
		}

		public static void SendMotion(int epoch, Vector3 position, float yaw, int serverMs)
		{
			MotionPayload[0] = (byte)1;
			MotionPayload[1] = epoch;
			MotionPayload[2] = position;
			MotionPayload[3] = (byte)Math.Round(Mathf.Repeat(yaw, 360f) / 360f * 255f);
			MotionPayload[4] = serverMs;
			Send(MotionPayload, Target.Others, 0, reliable: false);
		}

		public static void SendMeters(byte[] meters, int toActor = 0)
		{
			Send(new object[2]
			{
				(byte)2,
				meters
			}, (toActor > 0) ? Target.Actor : Target.Others, toActor, reliable: true);
		}

		public static void SendCaught(int epoch)
		{
			Send(new object[2]
			{
				(byte)3,
				epoch
			}, Target.Master, 0, reliable: true);
		}

		private static void Send(object[] payload, Target target, int actor, bool reliable)
		{
			if (SendOverride != null)
			{
				SendOverride(payload, target, actor, reliable);
			}
			else if (PhotonNetwork.InRoom)
			{
				RaiseEventOptions raiseEventOptions;
				switch (target)
				{
				case Target.Actor:
					ToActor.TargetActors[0] = actor;
					raiseEventOptions = ToActor;
					break;
				case Target.Master:
					raiseEventOptions = ToMaster;
					break;
				default:
					raiseEventOptions = ToOthers;
					break;
				}
				PhotonNetwork.RaiseEvent(134, payload, raiseEventOptions, reliable ? SendOptions.SendReliable : SendOptions.SendUnreliable);
			}
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code == 134 && photonEvent.CustomData is object[] data)
			{
				Receive(data, photonEvent.Sender);
			}
		}

		public static void Receive(object[] data, int sender)
		{
			if (data == null || data.Length < 2 || !(data[0] is byte b))
			{
				return;
			}
			BansheeDirector instance = BansheeDirector.Instance;
			try
			{
				switch (b)
				{
				case 0:
				{
					if (!FromMaster(sender) || data.Length < 8)
					{
						break;
					}
					State s = new State
					{
						epoch = (int)data[1],
						phase = (BansheePhase)(byte)data[2],
						form = (BansheeForm)(byte)data[3],
						grave = (byte)data[4],
						target = (int)data[5],
						phaseStartMs = (int)data[6],
						exit = (BansheeExit)(byte)data[7]
					};
					LastState = s;
					if (instance != null)
					{
						instance.OnRemoteState(in s);
					}
					break;
				}
				case 1:
					if (FromMaster(sender) && data.Length >= 5 && !(instance == null))
					{
						instance.OnRemoteMotion((int)data[1], (Vector3)data[2], (float)(byte)data[3] / 255f * 360f, (int)data[4]);
					}
					break;
				case 2:
					if (FromMaster(sender) && !(instance == null) && data[1] is byte[] meters)
					{
						instance.OnRemoteMeters(meters);
					}
					break;
				case 3:
					if (instance != null && instance.IsAuthority)
					{
						instance.OnCaughtReport(sender, (int)data[1]);
					}
					break;
				}
			}
			catch (InvalidCastException)
			{
			}
		}

		private static bool FromMaster(int sender)
		{
			if (SendOverride != null)
			{
				return true;
			}
			Player masterClient = PhotonNetwork.MasterClient;
			if (masterClient != null)
			{
				return masterClient.ActorNumber == sender;
			}
			return false;
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			BansheeDirector instance = BansheeDirector.Instance;
			if (instance != null && instance.IsAuthority)
			{
				instance.OnPlayerJoined(newPlayer.ActorNumber);
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			BansheeDirector instance = BansheeDirector.Instance;
			if (instance != null)
			{
				instance.OnMasterSwitched();
			}
		}

		public override void OnLeftRoom()
		{
			LastState = null;
			BansheeDirector instance = BansheeDirector.Instance;
			if (instance != null)
			{
				instance.OnLeftRoom();
			}
		}

		public override void OnJoinedRoom()
		{
			BansheeDirector instance = BansheeDirector.Instance;
			if (instance != null)
			{
				instance.OnJoinedRoom();
			}
		}
	}
}
