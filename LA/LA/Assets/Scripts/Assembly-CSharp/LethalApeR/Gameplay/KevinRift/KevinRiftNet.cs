using System;
using System.Reflection;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	[Obfuscation(Exclude = true)]
	public sealed class KevinRiftNet : MonoBehaviourPunCallbacks, IOnEventCallback
	{
		public enum Target : byte
		{
			Others = 0,
			Master = 1,
			Everyone = 2,
			Actor = 3
		}

		public struct State
		{
			public int epoch;

			public RiftPhase phase;

			public int anchor;

			public int wave;

			public int phaseStartMs;

			public int[] summoners;

			public int[] participants;
		}

		public const byte EventCode = 133;

		public const byte OpState = 0;

		public const byte OpSummon = 1;

		public const byte OpMelee = 2;

		public const byte OpHit = 3;

		public const byte OpKill = 4;

		private static KevinRiftNet _instance;

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

		public static Action<object[], Target, int> SendOverride { get; set; }

		public static State? LastState { get; private set; }

		public static bool Online
		{
			get
			{
				if (SendOverride != null)
				{
					return true;
				}
				return PhotonNetwork.InRoom;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Auto] KevinRiftNet");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<KevinRiftNet>();
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
			LastState = null;
			SendOverride = null;
		}

		public static void ForgetState()
		{
			LastState = null;
		}

		public static void SendState(in State s, int toActor = 0)
		{
			LastState = s;
			if (Online)
			{
				object[] payload = new object[8]
				{
					(byte)0,
					s.epoch,
					(byte)s.phase,
					(byte)s.anchor,
					(byte)s.wave,
					s.phaseStartMs,
					s.summoners ?? Array.Empty<int>(),
					s.participants ?? Array.Empty<int>()
				};
				if (toActor > 0)
				{
					Send(payload, Target.Actor, toActor);
				}
				else
				{
					Send(payload, Target.Others, 0);
				}
			}
		}

		public static void SendSummon(int epoch, bool left)
		{
			Send(new object[3]
			{
				(byte)1,
				epoch,
				left
			}, Target.Master, 0);
		}

		public static void SendMelee(int epoch, byte zombie, byte damage, ZombieDamage cause, bool left, Vector3 point, Vector3 direction)
		{
			Send(new object[8]
			{
				(byte)2,
				epoch,
				zombie,
				damage,
				(byte)cause,
				left,
				point,
				direction
			}, Target.Master, 0);
		}

		public static void SendHit(int epoch, byte zombie)
		{
			Send(new object[3]
			{
				(byte)3,
				epoch,
				zombie
			}, Target.Master, 0);
		}

		public static void SendKill(int epoch, byte zombie, int killer, ZombieDamage cause)
		{
			Send(new object[5]
			{
				(byte)4,
				epoch,
				zombie,
				killer,
				(byte)cause
			}, Target.Others, 0);
		}

		private static void Send(object[] payload, Target target, int actor)
		{
			if (SendOverride != null)
			{
				SendOverride(payload, target, actor);
			}
			else if (PhotonNetwork.InRoom)
			{
				RaiseEventOptions raiseEventOptions;
				if (target == Target.Actor)
				{
					ToActor.TargetActors[0] = actor;
					raiseEventOptions = ToActor;
				}
				else if (target == Target.Master)
				{
					raiseEventOptions = ToMaster;
				}
				else
				{
					raiseEventOptions = ToOthers;
				}
				PhotonNetwork.RaiseEvent(133, payload, raiseEventOptions, SendOptions.SendReliable);
			}
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code == 133 && photonEvent.CustomData is object[] data)
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
			KevinRiftDirector instance = KevinRiftDirector.Instance;
			try
			{
				switch (b)
				{
				case 0:
				{
					if (FromMaster(sender) && data.Length >= 8)
					{
						State state = new State
						{
							epoch = (int)data[1],
							phase = (RiftPhase)(byte)data[2],
							anchor = (byte)data[3],
							wave = (byte)data[4],
							phaseStartMs = (int)data[5],
							summoners = (data[6] as int[]) ?? Array.Empty<int>(),
							participants = (data[7] as int[]) ?? Array.Empty<int>()
						};
						LastState = state;
						if (instance != null)
						{
							instance.OnRemoteState(in state);
						}
					}
					break;
				}
				case 1:
					if (instance != null && instance.IsAuthority)
					{
						instance.OnSummonRequest(sender, (int)data[1], (bool)data[2]);
					}
					break;
				case 2:
					if (instance != null && instance.IsAuthority && data.Length >= 8)
					{
						instance.OnMeleeReport(sender, (int)data[1], (byte)data[2], (byte)data[3], (ZombieDamage)(byte)data[4], (bool)data[5], (Vector3)data[6], (Vector3)data[7]);
					}
					break;
				case 3:
					if (instance != null && instance.IsAuthority && data.Length >= 3)
					{
						instance.OnHitReport(sender, (int)data[1], (byte)data[2]);
					}
					break;
				case 4:
					if (FromMaster(sender) && data.Length >= 5 && instance != null)
					{
						instance.OnKill((int)data[1], (byte)data[2], (int)data[3], (ZombieDamage)(byte)data[4]);
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
			KevinRiftDirector instance = KevinRiftDirector.Instance;
			if (instance != null && instance.IsAuthority)
			{
				instance.OnPlayerJoined(newPlayer.ActorNumber);
			}
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			KevinRiftDirector instance = KevinRiftDirector.Instance;
			if (instance != null && instance.IsAuthority)
			{
				instance.OnPlayerLeft(otherPlayer.ActorNumber);
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			KevinRiftDirector instance = KevinRiftDirector.Instance;
			if (instance != null)
			{
				instance.OnMasterSwitched();
			}
		}

		public override void OnLeftRoom()
		{
			LastState = null;
			KevinRiftDirector instance = KevinRiftDirector.Instance;
			if (instance != null)
			{
				instance.OnLeftRoom();
			}
		}

		public override void OnJoinedRoom()
		{
			KevinRiftDirector instance = KevinRiftDirector.Instance;
			if (instance != null)
			{
				instance.OnJoinedRoom();
			}
		}
	}
}
