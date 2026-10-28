using System;
using System.Collections;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using Hashtable = ExitGames.Client.Photon.Hashtable;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnMatchmaker : MonoBehaviourPunCallbacks
	{
		[Tooltip("If a move is still dark this long (a join that never lands), fade back in anyway (s).")]
		public float blackoutSafetySeconds = 20f;

		private bool _moving;

		private bool _returning;

		private float _movingSince;

		private float _nextArrivalPublish;

		private bool _arrivalConfirmed;

		private Coroutine _move;

		public static FnMatchmaker Instance { get; private set; }

		public bool Busy => _moving;

		public static bool InParty
		{
			get
			{
				Hashtable roomProps = FnProps.RoomProps;
				if (roomProps != null)
				{
					return FnProps.GetBool(roomProps, "fnPty");
				}
				return false;
			}
		}

		public static string PartyCode
		{
			get
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				if (currentRoom == null || !InParty)
				{
					return "";
				}
				string text = CrossplayProfiles.UnsaltedRoomName(CrossplayProfiles.Fnaf, currentRoom.Name);
				if (!text.StartsWith("FNP-"))
				{
					return text;
				}
				return text.Substring("FNP-".Length);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		private void Awake()
		{
			Instance = this;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			FnNet.On(FnRpc.MoveToNight, OnMoveToNight);
		}

		public override void OnDisable()
		{
			base.OnDisable();
			FnNet.Off(FnRpc.MoveToNight, OnMoveToNight);
		}

		private void OnMoveToNight(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 4 || info.Sender == null || (!info.Sender.IsMasterClient && !info.Sender.IsLocal))
			{
				return;
			}
			string room = FnNet.S(a[0]);
			byte night = FnNet.B(a[1]);
			byte teamSize = FnNet.B(a[2]);
			string[] array = a[3] as string[];
			FnDifficulty fnDifficulty = ((a.Length >= 5 && FnNet.B(a[4]) == 1) ? FnDifficulty.Nightmare : FnDifficulty.Default);
			string localUserId = FnGame.LocalUserId;
			if (array != null && !string.IsNullOrEmpty(room) && Array.IndexOf(array, localUserId) >= 0)
			{
				Hashtable props = new Hashtable
				{
					["fnKind"] = (byte)1,
					["fnN"] = night,
					["fnDf"] = (byte)fnDifficulty,
					["fnTS"] = teamSize,
					["fnRos"] = array
				};
				Debug.Log(string.Format("[FnMatchmaker] Heading into night room {0} (night {1}, {2}, team {3}).", room, night, fnDifficulty, teamSize));
				BeginMove(delegate
				{
					MonkeDevNetworkingManager.JoinCrossplayPrivateRoom(room, Mathf.Max(teamSize, 1), props);
				});
			}
		}

		public void JoinParty(string code)
		{
			if (!_moving && !string.IsNullOrEmpty(code))
			{
				Hashtable props = new Hashtable
				{
					["fnKind"] = (byte)0,
					["fnPty"] = true
				};
				BeginMove(delegate
				{
					MonkeDevNetworkingManager.JoinCrossplayPrivateRoom("FNP-" + code, CrossplayProfiles.Fnaf.HubRoomLimit, props);
				});
			}
		}

		public void JoinPublicHub()
		{
			if (!_moving)
			{
				BeginMove(FnPlatform.JoinPublicHub);
			}
		}

		public void ReturnToHub()
		{
			if (!_returning)
			{
				_returning = true;
				BeginMove(FnPlatform.JoinPublicHub);
			}
		}

		private void BeginMove(Action join)
		{
			if (_move != null)
			{
				StopCoroutine(_move);
			}
			_move = StartCoroutine(Move(join));
		}

		private IEnumerator Move(Action join)
		{
			_moving = true;
			_movingSince = Time.unscaledTime;
			yield return FnPlatform.FadeOut(FnGame.Settings.hub.migrateFadeSeconds);
			join();
			_move = null;
		}

		public override void OnJoinedRoom()
		{
			_returning = false;
			FnRoomKind fnRoomKind = FnProps.CurrentRoomKind();
			if (fnRoomKind != FnRoomKind.None)
			{
				FnProps.WriteLocal(new Hashtable
				{
					["fnCam"] = (byte)255,
					["fnFl"] = false,
					["fnTm"] = ((fnRoomKind == FnRoomKind.Night) ? FnNight.RoomShortName : "")
				});
				FnProgress.Publish();
				_arrivalConfirmed = fnRoomKind != FnRoomKind.Night;
				_nextArrivalPublish = Time.unscaledTime + 1f;
				PlaceOnArrival(fnRoomKind);
				if (_moving)
				{
					StartCoroutine(ArriveFade());
				}
			}
		}

		public override void OnLeftRoom()
		{
			FnProps.WriteLocal(new Hashtable
			{
				["fnCam"] = (byte)255,
				["fnFl"] = false,
				["fnTm"] = ""
			});
		}

		private void PlaceOnArrival(FnRoomKind kind)
		{
			FnGame instance = FnGame.Instance;
			if (instance == null)
			{
				return;
			}
			if (kind == FnRoomKind.Night)
			{
				FnOffice instance2 = FnOffice.Instance;
				if (!(instance2 == null))
				{
					Transform transform = instance2.SlotSpawn(Mathf.Max(0, RosterSlot()));
					FnPlatform.Teleport(transform.position, transform.eulerAngles.y);
				}
				return;
			}
			Transform head = FnPlatform.Head;
			if (_moving || !(head != null) || !(instance.hubSpawn != null) || !((head.position - instance.hubSpawn.position).sqrMagnitude < 36f))
			{
				FnPlatform.Teleport(instance.HubArrivalPoint(), instance.HubArrivalYaw);
			}
		}

		private static int RosterSlot()
		{
			string[] array = FnProps.GetArray<string[]>(FnProps.RoomProps, "fnRos");
			if (array == null)
			{
				return -1;
			}
			return Array.IndexOf(array, FnGame.LocalUserId);
		}

		private IEnumerator ArriveFade()
		{
			yield return null;
			yield return null;
			_moving = false;
			yield return FnPlatform.FadeIn(FnGame.Settings.hub.arriveFadeSeconds);
		}

		private void Update()
		{
			if (_moving && _move == null && Time.unscaledTime - _movingSince > blackoutSafetySeconds)
			{
				_moving = false;
				StartCoroutine(FnPlatform.FadeIn(FnGame.Settings.hub.arriveFadeSeconds));
			}
			if (!_arrivalConfirmed && PhotonNetwork.InRoom && !(Time.unscaledTime < _nextArrivalPublish))
			{
				_nextArrivalPublish = Time.unscaledTime + 1f;
				string roomShortName = FnNight.RoomShortName;
				if (FnProps.PlayerString(PhotonNetwork.LocalPlayer, "fnTm") == roomShortName)
				{
					_arrivalConfirmed = true;
					return;
				}
				FnProps.WriteLocal(new Hashtable { ["fnTm"] = roomShortName });
			}
		}
	}
}
