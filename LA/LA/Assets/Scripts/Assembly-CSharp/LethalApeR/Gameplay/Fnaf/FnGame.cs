using System;
using ExitGames.Client.Photon;
using LethalApeR.Gameplay.ApeGames;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(-200)]
	public class FnGame : MonoBehaviourPunCallbacks
	{
		public FnSettings settings = new FnSettings();

		public FnAudioBank audioBank;

		[Header("Roots (switched by room kind)")]
		[Tooltip("Front-of-house: pads, board, keypad, portal. Active outside night rooms.")]
		public GameObject hubRoot;

		[Tooltip("Pizzeria systems: animatronics, office logic, cameras, tasks. Active only in a night room.")]
		public GameObject nightRoot;

		[Header("Arrival points")]
		[Tooltip("Hub arrivals stand here (spread by a small random offset).")]
		public Transform hubSpawn;

		public float hubSpawnSpread = 1.2f;

		private static readonly FnSettings Fallback = new FnSettings();

		public static FnGame Instance { get; private set; }

		public FnRoomKind RoomKind { get; private set; }

		public static FnSettings Settings => (Instance != null) ? Instance.settings : Fallback;

		public static int LocalActor => (PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1);

		public static string LocalUserId => (PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.UserId : null;

		public static FnAudioBank Audio => (Instance != null) ? Instance.audioBank : null;

		public float HubArrivalYaw => (hubSpawn != null) ? hubSpawn.eulerAngles.y : 0f;

		public event Action<FnRoomKind> RoomKindChanged;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		public static AgNetSync Avatar(int actor)
		{
			return AgNetSync.Get(actor);
		}

		public static Player PlayerOf(int actor)
		{
			if (PhotonNetwork.CurrentRoom == null)
			{
				return null;
			}
			return PhotonNetwork.CurrentRoom.GetPlayer(actor);
		}

		public static bool TryGetHead(int actor, out Vector3 head)
		{
			if (LocalActor == actor && FnPlatform.Head != null)
			{
				head = FnPlatform.Head.position;
				return true;
			}
			AgNetSync agNetSync = Avatar(actor);
			if (agNetSync != null && agNetSync.Head != null)
			{
				head = agNetSync.Head.position;
				return true;
			}
			head = default(Vector3);
			return false;
		}

		protected virtual void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Debug.LogError("[FnGame] Two FnGame roots in the scene; disabling the second.", this);
				base.enabled = false;
			}
			else
			{
				Instance = this;
				ApplyRoomKind(FnRoomKind.None, force: true);
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public override void OnJoinedRoom()
		{
			Refresh();
		}

		public override void OnLeftRoom()
		{
			Refresh();
		}

		public override void OnRoomPropertiesUpdate(Hashtable changed)
		{
			if (changed != null && (changed.ContainsKey("fnKind") || changed.ContainsKey("queue")))
			{
				Refresh();
			}
		}

		private void Start()
		{
			Refresh();
		}

		public void Refresh()
		{
			ApplyRoomKind(FnProps.CurrentRoomKind(), force: false);
		}

		private void ApplyRoomKind(FnRoomKind kind, bool force)
		{
			if (force || RoomKind != kind)
			{
				RoomKind = kind;
				if (hubRoot != null && hubRoot.activeSelf != (kind != FnRoomKind.Night))
				{
					hubRoot.SetActive(kind != FnRoomKind.Night);
				}
				if (nightRoot != null && nightRoot.activeSelf != (kind == FnRoomKind.Night))
				{
					nightRoot.SetActive(kind == FnRoomKind.Night);
				}
				this.RoomKindChanged?.Invoke(kind);
			}
		}

		public Vector3 HubArrivalPoint()
		{
			Vector3 position = ((hubSpawn != null) ? hubSpawn : base.transform).position;
			Vector2 vector = UnityEngine.Random.insideUnitCircle * hubSpawnSpread;
			return position + new Vector3(vector.x, 0f, vector.y);
		}
	}
}
