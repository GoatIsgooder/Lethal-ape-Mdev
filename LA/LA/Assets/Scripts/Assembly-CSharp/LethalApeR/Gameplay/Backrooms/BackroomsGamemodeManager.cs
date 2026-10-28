using System.Reflection;
using LethalApeR.SceneFlow;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class BackroomsGamemodeManager : MonoBehaviourPunCallbacks
	{
		[Header("Config (all tunables)")]
		[SerializeField]
		private BackroomsConfig config;

		private BackroomsConfig _runtimeCfg;

		[Header("Scene anchors (assign in Backrooms.unity)")]
		[Tooltip("Where players are teleported on Spawn. Each client picks a distinct one by its actor index, wrapping if there are more players than points.")]
		[SerializeField]
		private Transform[] spawnPoints = System.Array.Empty<Transform>();

		[Header("References (auto-found if null)")]
		[SerializeField]
		private KeycardManager keycardManager;

		[SerializeField]
		private PowerDoorController powerDoor;

		[SerializeField]
		private EscapeCutscene escapeCutscene;

		[SerializeField]
		private BackroomsDownedManager downedManager;

		[SerializeField]
		private BackroomsMonsterDirector monsterDirector;

		private BackroomsState _state;

		private float _stateEndTime;

		private bool _timerRunning;

		private int _placed;

		private int _total = 3;

		private bool _lastResultWin;

		private bool _lobbyArmed;

		private bool _returningToHub;

		public static BackroomsGamemodeManager Instance { get; private set; }

		public BackroomsConfig Config => config;

		private BackroomsConfig Cfg
		{
			get
			{
				if (config != null)
				{
					return config;
				}
				if (_runtimeCfg == null)
				{
					_runtimeCfg = ScriptableObject.CreateInstance<BackroomsConfig>();
				}
				return _runtimeCfg;
			}
		}

		public BackroomsState State => _state;

		public float StateTimeRemaining
		{
			get
			{
				if (!_timerRunning)
				{
					return 0f;
				}
				return Mathf.Max(0f, _stateEndTime - Time.time);
			}
		}

		public int KeycardsPlaced => _placed;

		public int KeycardsRequired => _total;

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority => !Connected || PhotonNetwork.IsMasterClient;

		private int LocalActor
		{
			get
			{
				if (!Connected)
				{
					return 1;
				}
				return PhotonNetwork.LocalPlayer.ActorNumber;
			}
		}

		private bool CanRpc => Connected && base.photonView != null && base.photonView.ViewID != 0;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
			if (keycardManager == null)
			{
				keycardManager = Object.FindFirstObjectByType<KeycardManager>();
			}
			if (powerDoor == null)
			{
				powerDoor = Object.FindFirstObjectByType<PowerDoorController>();
			}
			if (escapeCutscene == null)
			{
				escapeCutscene = Object.FindFirstObjectByType<EscapeCutscene>();
			}
			if (downedManager == null)
			{
				downedManager = Object.FindFirstObjectByType<BackroomsDownedManager>();
			}
			if (monsterDirector == null)
			{
				monsterDirector = Object.FindFirstObjectByType<BackroomsMonsterDirector>();
			}
			if (config != null)
			{
				_total = Mathf.Max(1, Cfg.keycardCount);
			}
		}

		private void Start()
		{
			EnterLobbyLocal();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Update()
		{
			if (!IsAuthority || _returningToHub)
			{
				return;
			}
			if (_state == BackroomsState.Lobby)
			{
				TickLobby();
			}
			else if ((_state == BackroomsState.Search || _state == BackroomsState.Place || _state == BackroomsState.Powering) && IsTeamWiped())
			{
				EnterState(BackroomsState.End, Cfg.endDwellDuration);
				return;
			}
			if (_timerRunning && Time.time >= _stateEndTime)
			{
				AdvanceTimed(_state);
			}
		}

		private void TickLobby()
		{
			bool flag = !Connected || PhotonNetwork.CurrentRoom == null || PhotonNetwork.CurrentRoom.PlayerCount >= Mathf.Max(1, Cfg.lobbyMin);
			if (flag && !_lobbyArmed)
			{
				_lobbyArmed = true;
				EnterState(BackroomsState.Lobby, Cfg.lobbyCountdown);
			}
			else if (!flag && _lobbyArmed)
			{
				_lobbyArmed = false;
				EnterState(BackroomsState.Lobby, 0f);
			}
			if (_lobbyArmed && _timerRunning && Time.time >= _stateEndTime)
			{
				EnterState(BackroomsState.Spawn, Cfg.spawnSettleDuration);
			}
		}

		private void AdvanceTimed(BackroomsState current)
		{
			switch (current)
			{
			case BackroomsState.Spawn:
				EnterState(BackroomsState.Search, 0f);
				break;
			case BackroomsState.Escape:
				EnterState(BackroomsState.End, Cfg.endDwellDuration, win: true);
				break;
			case BackroomsState.End:
				EnterState(BackroomsState.Spawn, Cfg.spawnSettleDuration);
				break;
			}
		}

		public void MasterNotifyPlaced(int placed, int total)
		{
			_placed = placed;
			_total = total;
			if (IsAuthority)
			{
				if (placed >= 1 && _state == BackroomsState.Search)
				{
					EnterState(BackroomsState.Place, 0f);
				}
				else if (placed >= total && _state == BackroomsState.Place)
				{
					EnterState(BackroomsState.Powering, 0f);
				}
				else
				{
					EnterState(_state, StateTimeRemaining);
				}
			}
		}

		public void MasterBeginEscape()
		{
			if (!IsAuthority)
			{
				if (CanRpc)
				{
					base.photonView.RPC("RPC_RequestEscape", RpcTarget.MasterClient);
				}
			}
			else if (_state == BackroomsState.Powering)
			{
				EnterState(BackroomsState.Escape, Cfg.escapeCutsceneDuration);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestEscape()
		{
			if (IsAuthority)
			{
				MasterBeginEscape();
			}
		}

		private void EnterState(BackroomsState next, float duration, bool win = false)
		{
			if (IsAuthority)
			{
				_lastResultWin = win;
				if (CanRpc)
				{
					base.photonView.RPC("RPC_SetState", RpcTarget.All, (int)next, duration, _placed, _total, win ? 1 : 0);
				}
				else
				{
					RPC_SetState((int)next, duration, _placed, _total, win ? 1 : 0);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetState(int state, float duration, int placed, int total, int resultFlag)
		{
			_state = (BackroomsState)state;
			_placed = placed;
			_total = total;
			_lastResultWin = resultFlag != 0;
			_timerRunning = duration > 0f;
			_stateEndTime = Time.time + duration;
			BackroomsEvents.RaiseStateChanged(_state);
			BackroomsEvents.RaiseKeycardsPlacedChanged(_placed, _total);
			OnEnterStateLocal(_state);
		}

		private void OnEnterStateLocal(BackroomsState state)
		{
			switch (state)
			{
			case BackroomsState.Lobby:
				EnterLobbyLocal();
				break;
			case BackroomsState.Spawn:
				EnterSpawnLocal();
				break;
			case BackroomsState.Search:
				EnterSearchLocal();
				break;
			case BackroomsState.Powering:
				EnterPoweringLocal();
				break;
			case BackroomsState.Escape:
				EnterEscapeLocal();
				break;
			case BackroomsState.End:
				EnterEndLocal();
				break;
			}
		}

		private void EnterLobbyLocal()
		{
			SetLocalFrozen(frozen: false);
		}

		private void EnterSpawnLocal()
		{
			if (IsAuthority)
			{
				keycardManager?.MasterResetForNewRound();
				downedManager?.MasterResetForNewRound();
				monsterDirector?.MasterResetForNewRound();
				powerDoor?.MasterResetForNewRound();
			}
			Transform transform = PickLocalSpawn();
			if (transform != null && GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(transform.position, transform.rotation, setRotation: true);
			}
			SetLocalFrozen(frozen: false);
		}

		private void EnterSearchLocal()
		{
			if (IsAuthority)
			{
				keycardManager?.MasterSpawnKeycards();
			}
			SetLocalFrozen(frozen: false);
		}

		private void EnterPoweringLocal()
		{
			if (IsAuthority)
			{
				powerDoor?.MasterBeginPower();
			}
		}

		private void EnterEscapeLocal()
		{
			SetLocalFrozen(frozen: true);
			escapeCutscene?.Play();
		}

		private void EnterEndLocal()
		{
			SetLocalFrozen(frozen: true);
			BackroomsEvents.RaiseRoundResult(_lastResultWin);
		}

		private void ReturnEveryoneToHub()
		{
			if (!_returningToHub)
			{
				_returningToHub = true;
				if (CanRpc)
				{
					base.photonView.RPC("RPC_ReturnToHub", RpcTarget.All);
				}
				else
				{
					RPC_ReturnToHub();
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReturnToHub()
		{
			string sceneName = ((config != null && !string.IsNullOrEmpty(Cfg.hubSceneName)) ? Cfg.hubSceneName : "MainScene");
			if (GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.disableMovement = false;
			}
			SceneTransition.Go(sceneName);
		}

		private bool IsTeamWiped()
		{
			if (downedManager == null)
			{
				return false;
			}
			int num = downedManager.UpCount();
			if (!Connected || PhotonNetwork.CurrentRoom == null)
			{
				return false;
			}
			if (PhotonNetwork.CurrentRoom.PlayerCount > 0)
			{
				return num == 0;
			}
			return false;
		}

		private void SetLocalFrozen(bool frozen)
		{
			if ((frozen || !(downedManager != null) || !downedManager.IsLocalDownedOrDead()) && GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.disableMovement = frozen;
			}
		}

		private Transform PickLocalSpawn()
		{
			if (spawnPoints == null || spawnPoints.Length == 0)
			{
				return null;
			}
			int num = LocalSpawnIndex() % spawnPoints.Length;
			if (spawnPoints[num] != null)
			{
				return spawnPoints[num];
			}
			return spawnPoints[0];
		}

		private int LocalSpawnIndex()
		{
			if (!Connected || PhotonNetwork.CurrentRoom == null)
			{
				return 0;
			}
			Player[] playerList = PhotonNetwork.PlayerList;
			int localActor = LocalActor;
			int num = 0;
			foreach (Player player in playerList)
			{
				if (player != null && player.ActorNumber < localActor)
				{
					num++;
				}
			}
			return num;
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			if (PhotonNetwork.IsMasterClient && CanRpc)
			{
				base.photonView.RPC("RPC_SetState", newPlayer, (int)_state, StateTimeRemaining, _placed, _total, _lastResultWin ? 1 : 0);
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
		}

		[ContextMenu("TEST: Force start run (skip lobby)")]
		public void DebugForceStart()
		{
			if (!IsAuthority)
			{
				Debug.LogWarning("[Backrooms] Force start ignored — not the authority.");
			}
			else
			{
				EnterState(BackroomsState.Spawn, (config != null) ? Cfg.spawnSettleDuration : 2f);
			}
		}

		[ContextMenu("TEST: Power the door now (skip to escape)")]
		public void DebugForcePower()
		{
			if (IsAuthority)
			{
				EnterState(BackroomsState.Powering, (config != null) ? Cfg.doorPowerRampDuration : 6f);
			}
		}
	}
}
