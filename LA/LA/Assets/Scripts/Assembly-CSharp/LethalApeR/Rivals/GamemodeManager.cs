using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Rivals.Combat;
using LethalApeR.Rivals.Economy;
using LethalApeR.Rivals.Progression;
using LethalApeR.Rivals.Testing;
using LethalApeR.Rivals.UI;
using LethalApeR.Rivals.Weapons;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Rivals
{
	[Obfuscation(Exclude = true)]
	public class GamemodeManager : MonoBehaviourPunCallbacks
	{
		[Header("Match rules")]
		[Tooltip("Round wins needed to win the match.")]
		[Min(1f)]
		public int roundWinsToWinMatch = 3;

		[Tooltip("Online matches may only start in rooms whose 'queue' room property starts with this (covers RVLS and the RVLS_RANKED_* bands). Offline/solo always works. Leave empty to allow any room.")]
		public string requiredQueuePrefix = "RVLS";

		[Header("State durations (seconds)")]
		public float voteDuration = 20f;

		public float roundPrepDuration = 8f;

		public float roundDuration = 120f;

		public float roundEndDuration = 5f;

		public float matchEndDuration = 18f;

		[Header("Round transition fade")]
		[Tooltip("Fade-to-black at the tail of the round-end pause; the next round's teleport happens behind it. 0 disables.")]
		public float roundFadeDuration = 0.7f;

		[Tooltip("Seconds to hold black after the new round places you, before fading back in.")]
		public float roundFadeHold = 0.25f;

		[Header("Spawn")]
		public float spawnProtection = 3f;

		public float spawnHealth = 100f;

		[Header("Scene anchors (assign in the Rivalry scene)")]
		[Tooltip("Where players are returned to in the hub.")]
		[SerializeField]
		private Transform hubReturnPoint;

		[Tooltip("Where participants stand to vote (the map-select room).")]
		[SerializeField]
		private Transform mapSelectPoint;

		[Tooltip("The frozen loadout box shown during RoundPrep.")]
		[SerializeField]
		private LoadoutBox loadoutBox;

		[Tooltip("The end-of-match podium.")]
		[SerializeField]
		private RivalsPodium podium;

		[Header("References (auto-found if null)")]
		[SerializeField]
		private GunUnlocker gunUnlocker;

		[SerializeField]
		private KeyManager keyManager;

		[SerializeField]
		private RivalsReadyPads readyPads;

		[Header("Loadout giving")]
		[Tooltip("Local offset from the spawn where chosen weapons are placed to grab.")]
		public Vector3 weaponGiveOffset = new Vector3(0f, 1f, 0.6f);

		public float weaponGiveSpread = 0.35f;

		private GameState _state;

		private float _stateEndTime;

		private bool _timerRunning;

		private int _teamARoundWins;

		private int _teamBRoundWins;

		private int _activeMapIndex = -1;

		private Team _lastRoundWinner;

		private Team _localTeam;

		private int _localTeamIndex;

		private int _matchTeamSize = 1;

		private readonly HashSet<int> _participantsA = new HashSet<int>();

		private readonly HashSet<int> _participantsB = new HashSet<int>();

		private bool _bothTeamsWereAlive;

		private readonly Dictionary<int, int> _votesByActor = new Dictionary<int, int>();

		private RivalsLocalCombatant _localCombatant;

		private RivalsXpPanel _xpPanel;

		private readonly List<GameObject> _givenWeapons = new List<GameObject>();

		public static GamemodeManager Instance { get; private set; }

		public GameState State => _state;

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

		public int TeamARoundWins => _teamARoundWins;

		public int TeamBRoundWins => _teamBRoundWins;

		public Team LocalTeam => _localTeam;

		public Transform HubReturnPoint => hubReturnPoint;

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority
		{
			get
			{
				if (Connected)
				{
					return PhotonNetwork.IsMasterClient;
				}
				return true;
			}
		}

		private int LocalActor
		{
			get
			{
				if (Connected)
				{
					return PhotonNetwork.LocalPlayer.ActorNumber;
				}
				return 1;
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Destroy(base.gameObject);
				return;
			}
			Instance = this;
			if (gunUnlocker == null)
			{
				gunUnlocker = Object.FindObjectOfType<GunUnlocker>();
			}
			if (keyManager == null)
			{
				keyManager = Object.FindObjectOfType<KeyManager>();
			}
			if (readyPads == null)
			{
				readyPads = Object.FindObjectOfType<RivalsReadyPads>();
			}
			if (podium == null)
			{
				podium = Object.FindObjectOfType<RivalsPodium>();
			}
			if (podium == null)
			{
				podium = RivalsPodiumBuilder.CreateDefault(hubReturnPoint);
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			RivalsEvents.OnPlayerKilled += HandlePlayerKilled;
		}

		private void Start()
		{
			if (readyPads == null)
			{
				readyPads = Object.FindObjectOfType<RivalsReadyPads>();
			}
			if (readyPads != null)
			{
				readyPads.OnMatchReady += HandleMatchReady;
			}
			EnterHubLocal();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			RivalsEvents.OnPlayerKilled -= HandlePlayerKilled;
			if (readyPads != null)
			{
				readyPads.OnMatchReady -= HandleMatchReady;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public GameState GetState()
		{
			return _state;
		}

		public void RegisterPlayer(PlayerHealth p)
		{
		}

		public void UnregisterPlayer(PlayerHealth p)
		{
		}

		public void CastMapVote(int mapIndex)
		{
			if (_state == GameState.MapVote)
			{
				if (Connected)
				{
					base.photonView.RPC("RPC_CastVote", RpcTarget.MasterClient, LocalActor, mapIndex);
				}
				else
				{
					RPC_CastVote(LocalActor, mapIndex);
				}
			}
		}

		private void HandleMatchReady(RivalsReadyPads.MatchReadyInfo info)
		{
			if (!IsAuthority || _state != GameState.Hub)
			{
				return;
			}
			if (!InAllowedQueue())
			{
				Debug.LogWarning("[GamemodeManager] Pads full but match NOT started — this room's queue isn't '" + requiredQueuePrefix + "*'. Join the Rivals queue (RVLS) to play.");
				return;
			}
			if (Connected && RivalsMatchmaker.Instance != null && RivalsMatchmaker.Instance.TryBeginMatchMigration(info))
			{
				return;
			}
			StartMatchmadeMatch(info.TeamAActors, info.TeamBActors);
		}

		public void StartMatchmadeMatch(List<int> teamAActors, List<int> teamBActors)
		{
			if (!IsAuthority || _state != GameState.Hub)
			{
				return;
			}
			_participantsA.Clear();
			_participantsB.Clear();
			foreach (int teamAActor in teamAActors)
			{
				_participantsA.Add(teamAActor);
			}
			foreach (int teamBActor in teamBActors)
			{
				_participantsB.Add(teamBActor);
			}
			_teamARoundWins = 0;
			_teamBRoundWins = 0;
			_lastRoundWinner = Team.None;
			AssignTeamsAndAnnounce();
			EnterState(GameState.MapVote, voteDuration);
		}

		private void AssignTeamsAndAnnounce()
		{
			List<int> actors = new List<int>();
			List<int> teams = new List<int>();
			foreach (int item in _participantsA)
			{
				actors.Add(item);
				teams.Add(1);
			}
			foreach (int item2 in _participantsB)
			{
				actors.Add(item2);
				teams.Add(2);
			}
			if (Connected)
			{
				base.photonView.RPC("RPC_AssignTeams", RpcTarget.AllBuffered, actors.ToArray(), teams.ToArray());
			}
			else
			{
				RPC_AssignTeams(actors.ToArray(), teams.ToArray());
			}
			for (int i = 0; i < actors.Count; i++)
			{
				if (PlayerHealth.TryGet(actors[i], out PlayerHealth health) && health != null && health.photonView != null)
				{
					health.SetTeam((Team)teams[i]);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_AssignTeams(int[] actors, int[] teams)
		{
			_localTeam = Team.None;
			_localTeamIndex = 0;
			int countA = 0;
			int countB = 0;
			for (int i = 0; i < actors.Length && i < teams.Length; i++)
			{
				if (actors[i] == LocalActor)
				{
					_localTeam = (Team)teams[i];
					_localTeamIndex = ((teams[i] == 1) ? countA : countB);
				}
				if (teams[i] == 1)
				{
					countA++;
				}
				else if (teams[i] == 2)
				{
					countB++;
				}
			}
			_matchTeamSize = Mathf.Max(1, Mathf.Max(countA, countB));
			if (_localTeam != Team.None && RivalsProgression.Instance != null)
			{
				RivalsProgression.Instance.BeginMatchTracking();
			}
		}

		private void Update()
		{
			if (_state == GameState.RoundPrep && loadoutBox != null && _localTeam != Team.None)
			{
				loadoutBox.Tick(StateTimeRemaining);
			}
			if (!IsAuthority)
			{
				return;
			}
			if (_state == GameState.MapVote && AllRealParticipantsVoted())
			{
				_activeMapIndex = ResolveVotedMap();
				EnterState(GameState.RoundPrep, roundPrepDuration);
				return;
			}
			if (_state == GameState.RoundActive)
			{
				if (!_bothTeamsWereAlive && CombatantRegistry.AliveCount(Team.TeamA) >= 1 && CombatantRegistry.AliveCount(Team.TeamB) >= 1)
				{
					_bothTeamsWereAlive = true;
				}
				if (_bothTeamsWereAlive && CombatantRegistry.TryGetSoleSurvivingTeam(out _))
				{
					ResolveRoundWinner();
					EnterState(GameState.RoundEnd, roundEndDuration);
					return;
				}
			}
			if (_timerRunning && Time.time >= _stateEndTime)
			{
				AdvanceFrom(_state);
			}
		}

		private void AdvanceFrom(GameState current)
		{
			switch (current)
			{
			case GameState.MapVote:
				_activeMapIndex = ResolveVotedMap();
				EnterState(GameState.RoundPrep, roundPrepDuration);
				break;
			case GameState.RoundPrep:
				EnterState(GameState.RoundActive, roundDuration);
				break;
			case GameState.RoundActive:
				ResolveRoundWinner();
				EnterState(GameState.RoundEnd, roundEndDuration);
				break;
			case GameState.RoundEnd:
				if (_teamARoundWins >= roundWinsToWinMatch || _teamBRoundWins >= roundWinsToWinMatch)
				{
					EnterState(GameState.MatchEnd, Mathf.Max(matchEndDuration, 15f));
				}
				else
				{
					EnterState(GameState.RoundPrep, roundPrepDuration);
				}
				break;
			case GameState.MatchEnd:
				EndMatchReturnToHub();
				break;
			}
		}

		private void EnterState(GameState next, float duration)
		{
			if (IsAuthority)
			{
				if (Connected)
				{
					base.photonView.RPC("RPC_SetState", RpcTarget.All, (int)next, duration, _teamARoundWins, _teamBRoundWins, _activeMapIndex, (int)_lastRoundWinner);
				}
				else
				{
					RPC_SetState((int)next, duration, _teamARoundWins, _teamBRoundWins, _activeMapIndex, (int)_lastRoundWinner);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetState(int state, float duration, int aWins, int bWins, int mapIndex, int lastRoundWinner)
		{
			_state = (GameState)state;
			_teamARoundWins = aWins;
			_teamBRoundWins = bWins;
			_activeMapIndex = mapIndex;
			_lastRoundWinner = (Team)lastRoundWinner;
			_timerRunning = duration > 0f;
			_stateEndTime = Time.time + duration;
			RivalsEvents.RaiseRoundStateChanged(_state);
			RivalsEvents.RaiseScoreChanged(_teamARoundWins, _teamBRoundWins);
			OnEnterStateLocal(_state);
		}

		private void OnEnterStateLocal(GameState state)
		{
			switch (state)
			{
			case GameState.Hub:
				EnterHubLocal();
				break;
			case GameState.MapVote:
				EnterVoteLocal();
				break;
			case GameState.RoundPrep:
				EnterPrepLocal();
				break;
			case GameState.RoundActive:
				EnterRoundLocal();
				break;
			case GameState.RoundEnd:
				EnterRoundEndLocal();
				break;
			case GameState.MatchEnd:
				EnterMatchEndLocal();
				break;
			}
		}

		private void EnterHubLocal()
		{
			SetLocalFrozen(frozen: false);
			if (gunUnlocker != null)
			{
				gunUnlocker.SetPurchasingAllowed(allowed: true);
			}
			if (loadoutBox != null)
			{
				loadoutBox.Hide();
			}
			if (podium != null)
			{
				podium.Hide();
			}
			DismissXpPanel();
			ClearGivenWeapons();
			DisableLocalCombatant();
			_localTeam = Team.None;
			if (hubReturnPoint != null)
			{
				TeleportLocal(hubReturnPoint);
			}
			RivalsScreenFade.Instance?.Clear();
		}

		private void EnterVoteLocal()
		{
			if (IsAuthority)
			{
				_votesByActor.Clear();
			}
			if (gunUnlocker != null)
			{
				gunUnlocker.SetPurchasingAllowed(allowed: true);
			}
			if (_localTeam != Team.None && mapSelectPoint != null)
			{
				TeleportLocal(mapSelectPoint);
			}
		}

		private void EnterPrepLocal()
		{
			if (RivalsWeaponOrbs.Instance != null)
			{
				RivalsWeaponOrbs.Instance.ClearAll();
			}
			ActivateChosenMap();
			ReviveAllLocalDummies();
			if (IsAuthority)
			{
				foreach (KeyValuePair<int, PlayerHealth> item in PlayerHealth.All)
				{
					PlayerHealth value = item.Value;
					if (value == null)
					{
						continue;
					}
					Team team = (_participantsA.Contains(item.Key) ? Team.TeamA : (_participantsB.Contains(item.Key) ? Team.TeamB : Team.None));
					if (team != Team.None && value.Team != team && value.photonView != null)
					{
						value.SetTeam(team);
					}
					value.Revive(spawnHealth);
					value.SetSpawnProtection(spawnProtection);
				}
			}
			if (_localTeam == Team.None)
			{
				return;
			}
			EnsureLocalCombatant();
			Transform transform = PickLocalSpawn();
			if (transform != null)
			{
				GorillaLocomotion.Player.Instance?.TeleportPlayerRaw(transform.position, transform.rotation, setRotation: true, resetVelocity: true);
			}
			SetLocalFrozen(frozen: true);
			if (gunUnlocker != null)
			{
				gunUnlocker.SetPurchasingAllowed(allowed: true);
			}
			if (loadoutBox != null && GorillaLocomotion.Player.Instance != null)
			{
				Transform transform2 = ((GorillaLocomotion.Player.Instance.headCollider != null) ? GorillaLocomotion.Player.Instance.headCollider.transform : GorillaLocomotion.Player.Instance.transform);
				loadoutBox.Show(transform2.position, Quaternion.Euler(0f, transform2.eulerAngles.y, 0f));
			}
			if (RivalsScreenFade.Instance != null)
			{
				RivalsScreenFade.Instance.ScheduleFade(roundFadeHold, 0f, Mathf.Max(roundFadeDuration, 0.01f));
			}
		}

		private void EnterRoundLocal()
		{
			_bothTeamsWereAlive = false;
			SetLocalFrozen(frozen: false);
			if (gunUnlocker != null)
			{
				gunUnlocker.SetPurchasingAllowed(allowed: false);
			}
			if (loadoutBox != null)
			{
				loadoutBox.Hide();
			}
			if (_localTeam != Team.None)
			{
				GiveLoadoutWeapons();
				if (PlayerHealth.TryGet(LocalActor, out PlayerHealth health) && health != null && health.photonView != null && health.photonView.IsMine)
				{
					health.SetSpawnProtection(spawnProtection);
				}
			}
		}

		private void EnterRoundEndLocal()
		{
			if (gunUnlocker != null)
			{
				gunUnlocker.SetPurchasingAllowed(allowed: false);
			}
			AwardRoundWinCoinsIfLocalWinner();
			if (_teamARoundWins < roundWinsToWinMatch && _teamBRoundWins < roundWinsToWinMatch && _localTeam != Team.None && roundFadeDuration > 0f && RivalsScreenFade.Instance != null)
			{
				RivalsScreenFade.Instance.ScheduleFadeOut(StateTimeRemaining - roundFadeDuration, roundFadeDuration);
			}
		}

		private void EnterMatchEndLocal()
		{
			RivalsScreenFade.Instance?.Clear();
			ClearGivenWeapons();
			SetLocalFrozen(frozen: false);
			Team team = ((_teamARoundWins >= roundWinsToWinMatch) ? Team.TeamA : ((_teamBRoundWins >= roundWinsToWinMatch) ? Team.TeamB : Team.None));
			if (podium != null)
			{
				podium.Show(team, _localTeam, _localTeamIndex);
			}
			HandleMatchEndAwards(team);
		}

		private void ResolveRoundWinner()
		{
			Team team;
			if (CombatantRegistry.TryGetSoleSurvivingTeam(out var survivor))
			{
				team = survivor;
			}
			else
			{
				int num = CombatantRegistry.AliveCount(Team.TeamA);
				int num2 = CombatantRegistry.AliveCount(Team.TeamB);
				team = ((num > num2) ? Team.TeamA : ((num2 > num) ? Team.TeamB : Team.None));
			}
			switch (team)
			{
			case Team.TeamA:
				_teamARoundWins++;
				break;
			case Team.TeamB:
				_teamBRoundWins++;
				break;
			}
			_lastRoundWinner = team;
		}

		private void EndMatchReturnToHub()
		{
			_participantsA.Clear();
			_participantsB.Clear();
			_teamARoundWins = 0;
			_teamBRoundWins = 0;
			_activeMapIndex = -1;
			_lastRoundWinner = Team.None;
			EnterState(GameState.Hub, 0f);
			if (RivalsMatchmaker.Instance != null && RivalsMatchmaker.Instance.InMatchRoom)
			{
				RivalsMatchmaker.Instance.ReturnEveryoneToHub();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_CastVote(int actor, int mapIndex)
		{
			if (IsAuthority)
			{
				_votesByActor[actor] = mapIndex;
			}
		}

		private int ResolveVotedMap()
		{
			int count = RivalsMap.All.Count;
			if (count == 0)
			{
				return -1;
			}
			if (_votesByActor.Count == 0)
			{
				return Random.Range(0, count);
			}
			int[] array = new int[count];
			foreach (KeyValuePair<int, int> item in _votesByActor)
			{
				if (item.Value >= 0 && item.Value < count)
				{
					array[item.Value]++;
				}
			}
			List<int> list = new List<int>();
			int num = -1;
			int result = 0;
			for (int i = 0; i < count; i++)
			{
				if (array[i] > num)
				{
					list.Clear();
					list.Add(i);
					num = array[i];
					result = i;
				}
				else if (array[i] == num)
				{
					list.Add(i);
				}
			}
			if (list.Count > 1)
			{
				return list[Random.Range(0, list.Count)];
			}
			return result;
		}

		private bool AllRealParticipantsVoted()
		{
			int num = 0;
			foreach (int item in _participantsA)
			{
				if (item >= 0)
				{
					if (!_votesByActor.ContainsKey(item))
					{
						return false;
					}
					num++;
				}
			}
			foreach (int item2 in _participantsB)
			{
				if (item2 >= 0)
				{
					if (!_votesByActor.ContainsKey(item2))
					{
						return false;
					}
					num++;
				}
			}
			return num > 0;
		}

		private void ActivateChosenMap()
		{
			IReadOnlyList<RivalsMap> all = RivalsMap.All;
			for (int i = 0; i < all.Count; i++)
			{
				if (all[i] != null)
				{
					all[i].SetActiveMap(i == _activeMapIndex);
				}
			}
		}

		private Transform PickLocalSpawn()
		{
			RivalsMap rivalsMap = RivalsMap.Get(_activeMapIndex);
			List<LethalApeR.Rivals.Maps.SpawnPoint> list = ((rivalsMap != null) ? rivalsMap.GetSpawns(_localTeam) : LethalApeR.Rivals.Maps.SpawnPoint.ForTeam(_localTeam));
			if (list != null && list.Count != 0)
			{
				return list[Random.Range(0, list.Count)].transform;
			}
			Debug.LogWarning(string.Format("[GamemodeManager] No spawns for team {0} on map {1}.", _localTeam, _activeMapIndex));
			return null;
		}

		private void GiveLoadoutWeapons()
		{
			if (RivalsWeaponOrbs.Instance != null)
			{
				RivalsWeaponOrbs.Instance.StockFromLoadout(gunUnlocker);
				return;
			}
			ClearGivenWeapons();
			if (gunUnlocker == null || GorillaLocomotion.Player.Instance == null)
			{
				return;
			}
			Transform transform = ((GorillaLocomotion.Player.Instance.headCollider != null) ? GorillaLocomotion.Player.Instance.headCollider.transform : GorillaLocomotion.Player.Instance.transform);
			Vector3 vector = transform.position + transform.rotation * weaponGiveOffset;
			int num = 0;
			foreach (LoadoutSlot value in System.Enum.GetValues(typeof(LoadoutSlot)))
			{
				WeaponData equipped = gunUnlocker.GetEquipped(value);
				GameObject gameObject = ((equipped != null) ? ((equipped.grabbablePrefab != null) ? equipped.grabbablePrefab : equipped.modelPrefab) : null);
				if (!(gameObject == null))
				{
					Vector3 position = vector + transform.right * (weaponGiveSpread * (float)(num - 1));
					_givenWeapons.Add(Instantiate(gameObject, position, transform.rotation));
					num++;
				}
			}
		}

		private void ClearGivenWeapons()
		{
			if (RivalsWeaponOrbs.Instance != null)
			{
				RivalsWeaponOrbs.Instance.ClearAll();
			}
			foreach (GameObject givenWeapon in _givenWeapons)
			{
				if (givenWeapon != null)
				{
					RivalsWeaponOrbs.ForceDropIfHeld(givenWeapon);
					Object.Destroy(givenWeapon);
				}
			}
			_givenWeapons.Clear();
		}

		private void AwardRoundWinCoinsIfLocalWinner()
		{
			if (_lastRoundWinner != Team.None && _localTeam == _lastRoundWinner)
			{
				if (keyManager != null)
				{
					keyManager.AwardRoundWin();
				}
				RivalsProgression.Instance?.AwardRoundWin();
				RivalsEvents.RaiseLocalRoundWon();
			}
		}

		private void HandleMatchEndAwards(Team winner)
		{
			bool won = winner != Team.None && _localTeam == winner;
			if (won && keyManager != null)
			{
				keyManager.AwardMatchWin();
			}
			if (_localTeam == Team.None)
			{
				return;
			}
			RivalsProgression instance = RivalsProgression.Instance;
			if (instance != null)
			{
				MatchXpSummary summary = instance.CompleteMatch(won);
				DismissXpPanel();
				_xpPanel = RivalsXpPanel.Spawn(summary);
				if (_xpPanel != null && podium != null && podium.CinematicCamera != null)
				{
					_xpPanel.SetViewCamera(podium.CinematicCamera);
				}
			}
			RivalsEvents.RaiseMatchCompleted(new MatchResultInfo
			{
				Won = won,
				TeamSize = _matchTeamSize
			});
		}

		private void DismissXpPanel()
		{
			if (!(_xpPanel == null))
			{
				_xpPanel.Dismiss();
				_xpPanel = null;
			}
		}

		private void HandlePlayerKilled(KillInfo info)
		{
			if (info.KillerActorNumber == LocalActor && keyManager != null)
			{
				keyManager.AwardKill();
			}
			if (info.VictimActorNumber == LocalActor && (_state == GameState.RoundActive || _state == GameState.RoundEnd))
			{
				SetLocalFrozen(true);
				if (RivalsWeaponOrbs.Instance != null)
				{
					RivalsWeaponOrbs.Instance.ClearAll();
				}
			}
		}

		private bool InAllowedQueue()
		{
			if (!Connected || string.IsNullOrEmpty(requiredQueuePrefix))
			{
				return true;
			}
			if (PhotonNetwork.CurrentRoom == null)
			{
				return false;
			}
			ExitGames.Client.Photon.Hashtable customProperties = PhotonNetwork.CurrentRoom.CustomProperties;
			if (customProperties == null)
			{
				return false;
			}
			if (customProperties.TryGetValue("queue", out object value) && value is string text)
			{
				return text.StartsWith(requiredQueuePrefix, System.StringComparison.OrdinalIgnoreCase);
			}
			return false;
		}

		private void SetLocalFrozen(bool frozen)
		{
			if (GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.disableMovement = frozen;
			}
			if (PlayerHealth.TryGet(LocalActor, out PlayerHealth health) && health != null)
			{
				health.SetSafeZone(frozen);
			}
		}

		private void EnsureLocalCombatant()
		{
			if ((PlayerHealth.TryGet(LocalActor, out PlayerHealth health) && health != null) || GorillaLocomotion.Player.Instance == null)
			{
				return;
			}
			if (_localCombatant == null)
			{
				_localCombatant = GorillaLocomotion.Player.Instance.GetComponent<RivalsLocalCombatant>() ?? GorillaLocomotion.Player.Instance.gameObject.AddComponent<RivalsLocalCombatant>();
			}
			_localCombatant.SetTeam((_localTeam != Team.None) ? _localTeam : Team.TeamA);
			_localCombatant.enabled = true;
			_localCombatant.ReviveFull();
		}

		private void DisableLocalCombatant()
		{
			if (_localCombatant != null)
			{
				_localCombatant.enabled = false;
			}
		}

		private void ReviveAllLocalDummies()
		{
			RivalsDummy[] array = Object.FindObjectsOfType<RivalsDummy>();
			foreach (RivalsDummy rivalsDummy in array)
			{
				if (rivalsDummy != null)
				{
					rivalsDummy.Revive();
				}
			}
		}

		private void TeleportLocal(Transform to)
		{
			if (GorillaLocomotion.Player.Instance != null && to != null)
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(to.position, to.rotation, true, true);
			}
		}

		private void ResetScores()
		{
			_teamARoundWins = 0;
			_teamBRoundWins = 0;
			_lastRoundWinner = Team.None;
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				base.photonView.RPC("RPC_SetState", newPlayer, (int)_state, StateTimeRemaining, _teamARoundWins, _teamBRoundWins, _activeMapIndex, (int)_lastRoundWinner);
			}
		}

		public void ForceSoloStart()
		{
			if (_state != GameState.Hub)
			{
				Debug.LogWarning(string.Format("[GamemodeManager] ForceSoloStart ignored — not in Hub (state={0}).", _state));
				return;
			}
			HandleMatchReady(new RivalsReadyPads.MatchReadyInfo
			{
				GroupId = "solo",
				TeamAActors = new List<int> { LocalActor },
				TeamBActors = new List<int> { -2 }
			});
		}

		[ContextMenu("TEST: Win match (local team) → podium")]
		public void DebugTestWin()
		{
			if (!IsAuthority)
			{
				Debug.LogWarning("[GamemodeManager] TEST Win ignored — not the authority.");
				return;
			}
			if (_localTeam == Team.None)
			{
				_localTeam = Team.TeamA;
			}
			if (_localTeam == Team.TeamA)
			{
				_teamARoundWins = roundWinsToWinMatch;
				_teamBRoundWins = 0;
			}
			else
			{
				_teamARoundWins = 0;
				_teamBRoundWins = roundWinsToWinMatch;
			}
			_lastRoundWinner = _localTeam;
			EnterState(GameState.MatchEnd, Mathf.Max(matchEndDuration, 15f));
		}

		[ContextMenu("TEST: Start round (solo vs dummy)")]
		public void DebugTestStartRound()
		{
			if (!IsAuthority)
			{
				Debug.LogWarning("[GamemodeManager] TEST Start Round ignored — not the authority.");
				return;
			}
			_participantsA.Clear();
			_participantsB.Clear();
			_participantsA.Add(LocalActor);
			_participantsB.Add(-2);
			ResetScores();
			AssignTeamsAndAnnounce();
			if (RivalsTestMode.Instance != null)
			{
				RivalsTestMode.Instance.SpawnDummy();
			}
			else
			{
				Debug.LogWarning("[GamemodeManager] No RivalsTestMode in the scene — round may auto-resolve with no enemy to fight.");
			}
			_activeMapIndex = ((RivalsMap.All.Count > 0) ? 0 : (-1));
			EnterState(GameState.RoundPrep, roundPrepDuration);
		}

		[ContextMenu("TEST: Get shot (hurt feedback)")]
		public void DebugTestGetShot()
		{
			RivalsEvents.RaiseLocalDamaged(20f, false, -1);
		}

		[ContextMenu("TEST: Die (death consequence)")]
		public void DebugTestDie()
		{
			KillInfo info = new KillInfo
			{
				VictimActorNumber = LocalActor,
				KillerActorNumber = -1,
				WeaponName = "DEBUG"
			};
			RivalsEvents.RaisePlayerKilled(in info);
		}
	}
}
