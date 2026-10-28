using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BTMGameManager : MonoBehaviourPunCallbacks
	{
		private sealed class RoundTally
		{
			public int kills;

			public float crankPoints;

			public bool escaped;

			public byte[] declared;

			public readonly int[] usedCharges = new int[3];

			public int undeclaredUses;

			public double crankBoostUntil;

			public float crankBoostMagnitude = 1f;
		}

		private readonly Dictionary<int, RoundTally> _tallies = new Dictionary<int, RoundTally>();

		private double _talliesStamp = double.NaN;

		private const float MaxUseRange = 30f;

		public const string GameQueue = "BeTheMonster";

		[Header("Configuration")]
		public RoundSettings roomSettings;

		[Header("Runtime data")]
		public RoundProperties roomProperties;

		public Action<int[], int[], bool, string> OnRoundStarted;

		public Action<int[], string> OnRoundEnded;

		public Action<RoundProperties> OnRoundPropertiesChanged;

		public Action OnLocalPlayerEliminated;

		public Action OnLocalPlayerBackInLobby;

		public Action<int, int> OnGeneratorProgressChanged;

		public Action OnAllGeneratorsPowered;

		private bool _isStartingGame;

		private float _roundStartRetryTime;

		private readonly System.Random _monsterRng = new System.Random();

		private const float LobbyClockResendSeconds = 3f;

		private float _lobbyClockSentAt = -1f;

		private double _teamsStamp = -1.0;

		private HashSet<int> _apAuth = new HashSet<int>();

		private HashSet<int> _cmAuth = new HashSet<int>();

		private HashSet<int> _escAuth = new HashSet<int>();

		private float _monsterAppearanceHoldUntil;

		private Coroutine _heldMonsterReveal;

		private bool _localEliminationApplied;

		private float _localEliminationTime;

		private int[] _prevMonsters = Array.Empty<int>();

		private int[] _prevActive = Array.Empty<int>();

		private int[] _prevEscaped = Array.Empty<int>();

		private double _prevRoundStartTime;

		private Coroutine _deferredRefresh;

		[Header("Death sounds")]
		[Tooltip("One random clip plays for everyone each time a survivor dies (caught or fell). Mid-round lobby joiners never trigger these (their join can't appear as a death edge).")]
		[SerializeField]
		private AudioClip[] deathSounds;

		[SerializeField]
		[Range(0f, 1f)]
		private float deathSoundVolume = 0.9f;

		private bool _generatorsDirty;

		private bool _generatorsCompleteFired;

		private bool _isVotingStarted;

		private bool _testRoundActive;

		private bool _deathKnown;

		private Vector3 _deathAt;

		private Vector3 _deathThrown;

		private Vector3 _deathKillerAt;

		private string _deathKiller;

		private const float CrankDegreesPerPoint = 28f;

		private const float CrankMaxDegreesPerReport = 400f;

		private const float CrankSynergyWindow = 1.25f;

		private const float CrankSynergyPerExtra = 0.35f;

		private const float CrankMaxSynergy = 2.05f;

		private const double CrankMasterPace = 0.25;

		private readonly float[] _crankCharge = new float[32];

		private int _crankPoweredMask;

		private readonly Dictionary<long, double> _crankContribTimes = new Dictionary<long, double>();

		private double _crankRoundStamp;

		private float _lastEscapeRequestTime;

		public BtmSalvageReceipt LastReceipt { get; private set; }

		public static BTMGameManager Instance { get; private set; }

		public event Action<BtmSalvageReceipt> OnSalvageAwarded;

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_AxeThrow(Vector3 origin, Quaternion rotation, Vector3 velocity, PhotonMessageInfo info)
		{
			BtmLumberjackAxe axe = AxeOf(info.Sender);
			if ((bool)axe)
			{
				axe.ReceiveThrow(origin, rotation, velocity, info.SentServerTime);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_AxeStick(Vector3 position, Quaternion rotation, PhotonMessageInfo info)
		{
			BtmLumberjackAxe axe = AxeOf(info.Sender);
			if ((bool)axe)
			{
				axe.ReceiveStick(position, rotation);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_AxeRecall(Vector3 from, Quaternion rotation, PhotonMessageInfo info)
		{
			BtmLumberjackAxe axe = AxeOf(info.Sender);
			if ((bool)axe)
			{
				axe.ReceiveRecall(from, rotation, info.SentServerTime);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_AxeCaught(PhotonMessageInfo info)
		{
			BtmLumberjackAxe axe = AxeOf(info.Sender);
			if ((bool)axe)
			{
				axe.ReceiveCaught();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_AxeKill(int actorId, int monsterActorId, Vector3 cutNormal, Vector3 hitPoint, Vector3 hitDirection, PhotonMessageInfo info)
		{
			if (info.Sender == null || info.Sender.ActorNumber != monsterActorId)
			{
				return;
			}
			BtmLumberjackAxe axe = AxeOf(info.Sender);
			if ((bool)axe)
			{
				if (cutNormal == Vector3.zero)
				{
					cutNormal = Vector3.right;
				}
				HandleEliminatePlayer(actorId, monsterActorId, false, cutNormal, hitPoint, hitDirection);
				axe.Chopped(hitPoint);
			}
		}

		private static BtmLumberjackAxe AxeOf(Player sender)
		{
			if (sender == null)
			{
				return null;
			}
			MonkeDevNetworkingPlayer player = MonkeDevNetworkingManager.Manager ? MonkeDevNetworkingManager.Manager.GetPlayerByActorId(sender.ActorNumber) : null;
			if (!player || !player.gameModePlayer)
			{
				return null;
			}
			GameModePlayer.MonsterEntry entry = player.gameModePlayer.CurrentMonsterEntry;
			if (entry == null || !entry.MonsterGameObject)
			{
				return null;
			}
			return entry.MonsterGameObject.GetComponent<BtmLumberjackAxe>();
		}

		private RoundTally Tally(int actor, double stamp)
		{
			if (!_talliesStamp.Equals(stamp))
			{
				_tallies.Clear();
				_talliesStamp = stamp;
			}
			if (!_tallies.TryGetValue(actor, out var tally))
			{
				tally = new RoundTally();
				_tallies[actor] = tally;
			}
			return tally;
		}

		private RoundTally PeekTally(int actor, double stamp)
		{
			if (!_talliesStamp.Equals(stamp))
			{
				return null;
			}
			if (!_tallies.TryGetValue(actor, out var tally))
			{
				return null;
			}
			return tally;
		}

		private void MasterCreditKill(int monsterActor)
		{
			Tally(monsterActor, _teamsStamp).kills++;
		}

		private void MasterCreditEscape(int actor)
		{
			Tally(actor, _teamsStamp).escaped = true;
		}

		private void MasterCreditCrank(int actor, float points)
		{
			if (points > 0f)
			{
				Tally(actor, _crankRoundStamp).crankPoints += points;
			}
		}

		private float MasterCrankPerkMultiplier(int actor)
		{
			RoundTally tally = PeekTally(actor, _crankRoundStamp);
			if (tally == null || !(PhotonNetwork.Time < tally.crankBoostUntil))
			{
				return 1f;
			}
			return Mathf.Clamp(tally.crankBoostMagnitude, 1f, 2f);
		}

		private void MasterPaySalvage(int[] winners, RoundProperties prop)
		{
			if (RoundProps.IsPrivateRound())
			{
				return;
			}
			BtmTechTreeCatalog catalog = BtmTechTreeCatalog.Instance;
			if (catalog == null)
			{
				return;
			}
			HashSet<int> winnerSet = new HashSet<int>(winners ?? Array.Empty<int>());
			HashSet<int> monsterSet = new HashSet<int>(prop.originalMonsters ?? Array.Empty<int>());
			HashSet<int> activeSet = new HashSet<int>(prop.originalActivePlayers ?? Array.Empty<int>());
			Player[] playerList = PhotonNetwork.PlayerList;
			foreach (Player player in playerList)
			{
				int actor = player.ActorNumber;
				bool asMonster = monsterSet.Contains(actor);
				if (!asMonster && !activeSet.Contains(actor))
				{
					continue;
				}
				RoundTally tally = PeekTally(actor, prop.startTime);
				bool won = winnerSet.Contains(actor);
				int outcome = 0;
				int generators = 0;
				int escape = 0;
				if (won)
				{
					outcome = (asMonster ? catalog.monsterWin : catalog.survivorWin);
				}
				if (!asMonster && tally != null)
				{
					generators = Mathf.Min(catalog.crankCap, Mathf.RoundToInt(tally.crankPoints * catalog.perCrankPoint));
					escape = (tally.escaped ? catalog.escapeBonus : 0);
				}
				int catches = ((asMonster && tally != null) ? tally.kills : 0);
				base.photonView.RPC("RPC_SalvageAwarded", player, asMonster, catalog.participation, outcome, generators, escape, catches, catalog.monsterKill * catches);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SalvageAwarded(bool asMonster, int participation, int outcome, int generators, int escape, int catches, int catchSalvage, PhotonMessageInfo info)
		{
			if (info.Sender == null || !info.Sender.IsMasterClient || RoundProps.IsPrivateRound())
			{
				return;
			}
			BtmTechTreeCatalog catalog = BtmTechTreeCatalog.Instance;
			if (!(catalog == null))
			{
				participation = Math.Max(0, participation);
				outcome = Math.Max(0, outcome);
				generators = Math.Max(0, generators);
				escape = Math.Max(0, escape);
				catches = Math.Max(0, catches);
				catchSalvage = Math.Max(0, catchSalvage);
				int total = (int)Math.Min((long)participation + outcome + generators + escape + catchSalvage, catalog.roundCap);
				BtmProgress.AddSalvage(total);
				LastReceipt = new BtmSalvageReceipt
				{
					asMonster = asMonster,
					participation = participation,
					outcome = outcome,
					generators = generators,
					escape = escape,
					catches = catches,
					catchSalvage = catchSalvage,
					total = total
				};
				this.OnSalvageAwarded?.Invoke(LastReceipt);
			}
		}

		private void OnRoundStartedTechTree(int[] monsters, int[] activePlayers)
		{
			if (PhotonNetwork.LocalPlayer == null)
			{
				return;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			bool isMonster = Array.IndexOf(monsters ?? Array.Empty<int>(), actorNumber) >= 0;
			if (isMonster || Array.IndexOf(activePlayers ?? Array.Empty<int>(), actorNumber) >= 0)
			{
				BtmItemRuntime.BeginRoundPrep(isMonster ? BtmRole.Monster : BtmRole.Survivor, RoundProps.PlayStartTime(in roomProperties), roomProperties.startTime);
			}
		}

		public void DeclareLoadout(byte[] itemIndices)
		{
			if (PhotonNetwork.InRoom && itemIndices != null)
			{
				base.photonView.RPC("RPC_DeclareLoadout", RpcTarget.MasterClient, new object[1] { itemIndices });
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_DeclareLoadout(byte[] itemIndices, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.IsMasterClient || itemIndices == null || info.Sender == null || !RoundProps.TryRead(out var p) || !p.roundActive)
			{
				return;
			}
			SeedTeamsIfNeeded(p);
			int actorNumber = info.Sender.ActorNumber;
			BtmRole? role = null;
			if (_cmAuth.Contains(actorNumber))
			{
				role = BtmRole.Monster;
			}
			else if (_apAuth.Contains(actorNumber))
			{
				role = BtmRole.Survivor;
			}
			if (!role.HasValue)
			{
				return;
			}
			RoundTally tally = Tally(actorNumber, p.startTime);
			if (tally.declared != null)
			{
				return;
			}
			BtmTechTreeCatalog catalog = BtmTechTreeCatalog.Instance;
			List<byte> accepted = new List<byte>(3);
			for (int i = 0; i < itemIndices.Length && accepted.Count < 3; i++)
			{
				byte index = itemIndices[i];
				BtmItemDefinition item = ((catalog != null) ? catalog.Get(index) : null);
				if (!(item == null) && item.kind != BtmItemKind.SlotUnlock && item.role == role.Value && !accepted.Contains(index))
				{
					accepted.Add(index);
				}
			}
			tally.declared = accepted.ToArray();
		}

		public void RequestItemUse(BtmItemDefinition item, Vector3 position)
		{
			BtmTechTreeCatalog catalog = BtmTechTreeCatalog.Instance;
			if (catalog != null)
			{
				int index = catalog.IndexOf(item);
				if (index >= 0 && index <= 255 && PhotonNetwork.InRoom)
				{
					base.photonView.RPC("RPC_RequestItemUse", RpcTarget.MasterClient, (byte)index, position);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestItemUse(byte itemIndex, Vector3 position, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.IsMasterClient || info.Sender == null || !RoundProps.TryRead(out var props) || !props.roundActive || PhotonNetwork.Time < RoundProps.PlayStartTime(in props) - 0.5 || !float.IsFinite(position.x) || !float.IsFinite(position.y) || !float.IsFinite(position.z))
			{
				return;
			}
			SeedTeamsIfNeeded(props);
			BtmItemDefinition item = ((BtmTechTreeCatalog.Instance != null) ? BtmTechTreeCatalog.Instance.Get(itemIndex) : null);
			if (item == null || item.kind == BtmItemKind.SlotUnlock)
			{
				return;
			}
			int actor = info.Sender.ActorNumber;
			if (!((item.role == BtmRole.Monster) ? _cmAuth : _apAuth).Contains(actor))
			{
				return;
			}
			MonkeDevNetworkingPlayer player = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.GetPlayerByActorId(actor) : null);
			if (player != null && player.Head != null && (player.Head.position - position).sqrMagnitude > 900f)
			{
				return;
			}
			RoundTally tally = Tally(actor, props.startTime);
			if (tally.declared != null)
			{
				int slot = Array.IndexOf(tally.declared, itemIndex);
				if (slot < 0 || slot >= tally.usedCharges.Length || tally.usedCharges[slot] >= Math.Max(1, item.chargesPerRound))
				{
					return;
				}
				tally.usedCharges[slot]++;
			}
			else if (++tally.undeclaredUses > 3)
			{
				return;
			}
			if (item.effect == BtmEffect.CrankSpeed)
			{
				tally.crankBoostUntil = PhotonNetwork.Time + (double)item.duration;
				tally.crankBoostMagnitude = item.magnitude;
			}
			base.photonView.RPC("RPC_ItemUsed", RpcTarget.All, actor, itemIndex, position);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ItemUsed(int actor, byte itemIndex, Vector3 position, PhotonMessageInfo info)
		{
			if (info.Sender != null && info.Sender.IsMasterClient && (PhotonNetwork.LocalPlayer == null || PhotonNetwork.LocalPlayer.ActorNumber != actor))
			{
				BtmItemDefinition item = ((BtmTechTreeCatalog.Instance != null) ? BtmTechTreeCatalog.Instance.Get(itemIndex) : null);
				if (item != null)
				{
					BtmItemRuntime.PlayRemoteUse(actor, item, position);
				}
			}
		}

		public void BroadcastThrow(BtmItemDefinition item, Vector3 position, Vector3 velocity)
		{
			if (BtmTechTreeCatalog.Instance != null)
			{
				int index = BtmTechTreeCatalog.Instance.IndexOf(item);
				if (index >= 0 && index <= 255 && PhotonNetwork.InRoom)
				{
					base.photonView.RPC("RPC_ItemThrown", RpcTarget.Others, (byte)index, position, velocity);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ItemThrown(byte itemIndex, Vector3 position, Vector3 velocity, PhotonMessageInfo info)
		{
			if (info.Sender == null || !roomProperties.roundActive)
			{
				return;
			}
			float speedSq = velocity.sqrMagnitude;
			if (!(speedSq > 1600f) && float.IsFinite(speedSq))
			{
				BtmItemDefinition item = ((BtmTechTreeCatalog.Instance != null) ? BtmTechTreeCatalog.Instance.Get(itemIndex) : null);
				if (item != null)
				{
					BtmItemRuntime.SpawnRemoteGhost(info.Sender.ActorNumber, item, position, velocity);
				}
			}
		}

		private void SeedTeamsIfNeeded(RoundProperties props)
		{
			if (!_teamsStamp.Equals(props.startTime))
			{
				_teamsStamp = props.startTime;
				_apAuth = new HashSet<int>(props.activePlayers ?? Array.Empty<int>());
				_cmAuth = new HashSet<int>(props.currentMonsters ?? Array.Empty<int>());
				_escAuth = new HashSet<int>(props.escapedPlayers ?? Array.Empty<int>());
			}
		}

		private void SeedTeamsFromRoundStart(double startTime, int[] monsters, int[] activePlayers)
		{
			_teamsStamp = startTime;
			_apAuth = new HashSet<int>(activePlayers ?? Array.Empty<int>());
			_cmAuth = new HashSet<int>(monsters ?? Array.Empty<int>());
			_escAuth = new HashSet<int>();
		}

		private void HoldMonsterAppearanceForSpawnDelay()
		{
			float hold = RoundProps.PrepRemaining(in roomProperties) + Mathf.Max(0f, roomSettings.monsterSpawnDelay);
			if (hold > 0f)
			{
				_monsterAppearanceHoldUntil = Time.time + hold;
				if (_heldMonsterReveal != null)
				{
					StopCoroutine(_heldMonsterReveal);
				}
				_heldMonsterReveal = StartCoroutine(RevealMonstersAfterHold(hold));
			}
		}

		private IEnumerator RevealMonstersAfterHold(float delay)
		{
			yield return new WaitForSeconds(delay);
			_heldMonsterReveal = null;
			RefreshAllAppearances();
		}

		private void Awake()
		{
			Instance = this;
		}

		private void Start()
		{
			foreach (MapData map in roomSettings.maps)
			{
				map.mapObject.SetActive(false);
			}
			Mods.TurnOffEverywhere();
		}

		private void Update()
		{
			if (roomProperties.queue != GameQueue || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_generatorsDirty)
			{
				_generatorsDirty = false;
				EvaluateGenerators(playFx: false);
			}
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			double remaining = RoundProps.GetRemainingTime();
			if (roomProperties.roundActive)
			{
				bool hasTeams = roomProperties.activePlayers.Length != 0 && roomProperties.currentMonsters.Length != 0;
				if (!(remaining > 0.0) || (!hasTeams && !_testRoundActive))
				{
					MasterEndGame();
					return;
				}
			}
			else if (!(roomProperties.endTime > 0.0) && !_isStartingGame)
			{
				if (PhotonNetwork.CurrentRoom.PlayerCount >= 2 && (_lobbyClockSentAt < 0f || !(Time.unscaledTime - _lobbyClockSentAt < 3f)))
				{
					_lobbyClockSentAt = Time.unscaledTime;
					RoundProps.OpenLobbyClock();
				}
				return;
			}
			if (!_isVotingStarted)
			{
				EnsureMapVotingStarted();
			}
			if (roomProperties.roundActive || _isStartingGame || Time.time - _roundStartRetryTime < (float)roomSettings.roundRetryDuration)
			{
				return;
			}
			double intermissionRemaining = RoundProps.GetRemainingIntermissionDuration();
			double votingRemaining = RoundProps.GetRemainingVotingDuration();
			if (intermissionRemaining >= 1.0 || votingRemaining >= 1.0)
			{
				return;
			}
			if (PhotonNetwork.CurrentRoom.PlayerCount <= 1)
			{
				_roundStartRetryTime = Time.time;
				return;
			}
			_isStartingGame = true;
			Log("Map voting ended, checking votes...");
			Dictionary<string, int> voteCounts = new Dictionary<string, int>();
			foreach (KeyValuePair<int, Player> player in PhotonNetwork.CurrentRoom.Players)
			{
				if (player.Value.CustomProperties.TryGetValue("mv", out var vote) && vote is string votedMap && !voteCounts.TryAdd(votedMap, 1))
				{
					voteCounts[votedMap]++;
				}
			}
			base.photonView.RPC("RPCResetMapVote", RpcTarget.All);
			string[] votingMaps = RoundProps.GetVotingMaps();
			string selectedMap = roomSettings.maps[UnityEngine.Random.Range(0, roomSettings.maps.Count)].sceneId;
			if (votingMaps.Length != 0)
			{
				Dictionary<string, int> validVoteCounts = new Dictionary<string, int>();
				for (int i = 0; i < votingMaps.Length; i++)
				{
					validVoteCounts[votingMaps[i]] = 0;
				}
				foreach (KeyValuePair<string, int> entry in voteCounts.Where((KeyValuePair<string, int> kv) => validVoteCounts.ContainsKey(kv.Key)))
				{
					validVoteCounts[entry.Key] += entry.Value;
				}
				int highestVotes = validVoteCounts.Values.Max();
				if (highestVotes > 0)
				{
					string[] topMaps = validVoteCounts.Where((KeyValuePair<string, int> _) => _.Value == highestVotes).Select((KeyValuePair<string, int> _) => _.Key).ToArray();
					selectedMap = topMaps[UnityEngine.Random.Range(0, topMaps.Length)];
				}
				else
				{
					selectedMap = votingMaps[UnityEngine.Random.Range(0, votingMaps.Length)];
				}
			}
			_isVotingStarted = false;
			MasterStartGame(selectedMap);
		}

		private void EnsureMapVotingStarted()
		{
			if (PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom && !roomProperties.roundActive && PhotonNetwork.CurrentRoom.PlayerCount >= 2 && RoundProps.IsVotingActive())
			{
				_isVotingStarted = true;
				if (RoundProps.GetVotingMaps().Length == 0)
				{
					IEnumerable<MapData> candidates = ((roomSettings.maps.Count <= RoundProps.MaxVoteMaps) ? ((IEnumerable<MapData>)roomSettings.maps) : ((IEnumerable<MapData>)roomSettings.maps.OrderBy((MapData _) => UnityEngine.Random.value).Take(RoundProps.MaxVoteMaps)));
					string[] mapIds = candidates.Select((MapData _) => _.sceneId).ToArray();
					RoundProps.SetVotingMaps(mapIds);
					Log("Started map voting with: " + string.Join(", ", mapIds));
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPCResetMapVote()
		{
			MonkeDevNetworkingPlayer localPlayer = MonkeDevNetworkingManager.Manager.LocalPlayer;
			if (!(localPlayer == null))
			{
				Player owner = localPlayer.photonView.Owner;
				ExitGames.Client.Photon.Hashtable props = new ExitGames.Client.Photon.Hashtable();
				props["mv"] = null;
				owner.SetCustomProperties(props);
			}
		}

		private void MasterStartGame(string selectedMap)
		{
			if (!PhotonNetwork.IsMasterClient || roomProperties.roundActive || roomProperties.queue != GameQueue)
			{
				Log(string.Format("FAILED: IsMasterClient={0}, IsRoundActive={1}, RoomQueue={2}", PhotonNetwork.IsMasterClient, roomProperties.roundActive, roomProperties.queue), isError: true);
			}
			else if (!roomProperties.roundActive && !(RoundProps.GetRemainingIntermissionDuration() > 0.0) && PhotonNetwork.CurrentRoom.PlayerCount >= 2)
			{
				Log("Staring match");
				_testRoundActive = false;
				Player[] players = PhotonNetwork.PlayerList;
				int[] actorIds = new int[players.Length];
				string[] turnKeys = new string[players.Length];
				for (int i = 0; i < players.Length; i++)
				{
					actorIds[i] = players[i].ActorNumber;
					turnKeys[i] = MonsterTurnKey(players[i]);
				}
				RoundProps.TryRead(out var props);
				Dictionary<string, int> turns = RoundProps.ReadMonsterTurns();
				int[] monsters = BtmMonsterPicker.Pick(actorIds, turnKeys, turns, props.originalMonsters, BtmMonsterPicker.MonsterCount(actorIds.Length, roomSettings.maxMonsters), _monsterRng);
				BtmMonsterPicker.Forget(turns, turnKeys, 48);
				int[] activePlayers = actorIds.Where((int id) => Array.IndexOf(monsters, id) < 0).ToArray();
				int[] generatorSpawnPoints = PickGeneratorSpawnPoints(selectedMap);
				double startTime = RoundProps.StartRound(roomSettings.roundDuration, roomSettings.prepDuration, monsters, activePlayers, selectedMap, generatorSpawnPoints, turns);
				SeedTeamsFromRoundStart(startTime, monsters, activePlayers);
				Log(string.Format("Started match: monsters [{0}] of {1}", string.Join(",", monsters), actorIds.Length));
				base.photonView.RPC("RPC_RoundStarted", RpcTarget.All, monsters, activePlayers, true, selectedMap);
			}
		}

		private static string MonsterTurnKey(Player player)
		{
			if (!string.IsNullOrEmpty(player.UserId))
			{
				return player.UserId;
			}
			return "#" + player.ActorNumber;
		}

		public void DebugStartTestRound(bool asMonster)
		{
			if (!PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom)
			{
				Log("TEST round: not master / not in a room.", isError: true);
				return;
			}
			if (roomProperties.queue != GameQueue)
			{
				Log("TEST round: room queue '" + roomProperties.queue + "' != 'BeTheMonster' — join the BTM queue first.", isError: true);
				return;
			}
			if (roomProperties.roundActive || _isStartingGame)
			{
				Log("TEST round: a round is already active/starting — end it first.", isError: true);
				return;
			}
			int me = PhotonNetwork.LocalPlayer.ActorNumber;
			int[] others = PhotonNetwork.PlayerList.Select((Player p) => p.ActorNumber).Where((int id) => id != me).ToArray();
			int[] monsters;
			int[] activePlayers;
			if (asMonster)
			{
				monsters = new int[1] { me };
				activePlayers = others;
			}
			else
			{
				monsters = others.Take(1).ToArray();
				activePlayers = new int[1] { me }.Concat(others.Skip(1)).ToArray();
			}
			List<MapData> validMaps = roomSettings.maps.Where((MapData m) => m.mapObject != null && !string.IsNullOrEmpty(m.sceneId)).ToList();
			if (validMaps.Count == 0)
			{
				Log("TEST round: no valid maps in roomSettings.", isError: true);
				return;
			}
			string mapId = validMaps[UnityEngine.Random.Range(0, validMaps.Count)].sceneId;
			_testRoundActive = true;
			_isStartingGame = false;
			int[] generatorSpawnPoints = PickGeneratorSpawnPoints(mapId);
			double startTime = RoundProps.StartRound(roomSettings.roundDuration, roomSettings.prepDuration, monsters, activePlayers, mapId, generatorSpawnPoints);
			SeedTeamsFromRoundStart(startTime, monsters, activePlayers);
			base.photonView.RPC("RPC_RoundStarted", RpcTarget.All, monsters, activePlayers, true, mapId);
			Log("TEST round started on '" + mapId + "' — local player is " + (asMonster ? "the MONSTER" : "a SURVIVOR") + " " + string.Format("({0} monster(s) / {1} survivor(s)).", monsters.Length, activePlayers.Length));
		}

		public void DebugEndRound()
		{
			if (PhotonNetwork.IsMasterClient && roomProperties.roundActive)
			{
				MasterEndGame();
			}
		}

		private void MasterEndGame()
		{
			if (!PhotonNetwork.IsMasterClient || roomProperties.queue != GameQueue || !RoundProps.TryRead(out var props) || !props.roundActive)
			{
				return;
			}
			bool wasTestRound = _testRoundActive;
			_isStartingGame = false;
			_testRoundActive = false;
			Log("Ending match");
			SeedTeamsIfNeeded(props);
			int[] escaped = _escAuth.ToArray();
			int[] survivors = _apAuth.ToArray();
			int[] winners = ((survivors.Length + escaped.Length > 0) ? survivors.Concat(escaped).Distinct().ToArray() : ((props.originalMonsters == null || props.originalMonsters.Length <= 0) ? _cmAuth.ToArray() : props.originalMonsters));
			string mapId = props.currentMap;
			if (wasTestRound)
			{
				Log("TEST round ended — win NOT recorded to the leaderboard.");
			}
			else
			{
				base.photonView.RPC("AddWin", RpcTarget.All, winners);
			}
			props.activePlayers = Array.Empty<int>();
			props.currentMonsters = Array.Empty<int>();
			props.roundActive = false;
			props.endTime = PhotonNetwork.Time;
			roomProperties = props;
			RoundProps.Write(props);
			RoundProps.ClearVotingMaps();
			base.photonView.RPC("RPC_RoundEnded", RpcTarget.All, winners, mapId);
			if (!wasTestRound)
			{
				MasterPaySalvage(winners, props);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_RoundStarted(int[] monsters, int[] activePlayers, bool roundActive, string mapId)
		{
			BtmMimicKills.Clear();
			ResetGore();
			if (roundActive)
			{
				Mods.RestoreProjectPhysics();
				if ((bool)BtmGore.Instance)
				{
					BtmGore.Instance.RoundStarting();
				}
			}
			_localEliminationApplied = false;
			_deathKnown = false;
			_generatorsDirty = true;
			_generatorsCompleteFired = false;
			foreach (MonkeDevNetworkingPlayer player in MonkeDevNetworkingManager.Manager.Players)
			{
				GameModePlayer gameModePlayer = player.gameModePlayer;
				if (!(gameModePlayer == null))
				{
					gameModePlayer.IsEliminated = false;
				}
			}
			RoundProps.TryRead(out roomProperties);
			OnRoundStarted?.Invoke(monsters, activePlayers, roundActive, mapId);
			if (roundActive)
			{
				HoldMonsterAppearanceForSpawnDelay();
			}
			RoundProps.TryRead(out roomProperties);
			double playStart = RoundProps.PlayStartTime(in roomProperties);
			HandleTeleport(monsters, activePlayers, roundActive, mapId, playStart + (double)roomSettings.monsterSpawnDelay, playStart);
			StartCoroutine(MonsterRevealCoroutine(RoundProps.PrepRemaining(in roomProperties)));
			if (roundActive)
			{
				OnRoundStartedTechTree(monsters, activePlayers);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_RoundEnded(int[] winners, string mapId)
		{
			BtmMimicKills.Clear();
			ResetGore();
			_localEliminationApplied = false;
			_deathKnown = false;
			_generatorsDirty = true;
			_generatorsCompleteFired = false;
			HandleTeleport(Array.Empty<int>(), Array.Empty<int>(), roundActive: false, mapId);
			OnRoundEnded?.Invoke(winners, mapId);
			Log("OnRoundEnded Action Invoked");
		}

		private static void ResetGore()
		{
			if ((bool)BtmGore.Instance)
			{
				BtmGore.Instance.ClearCorpses();
			}
		}

		private IEnumerator MonsterRevealCoroutine(float prep)
		{
			if (!RoundProps.TryRead(out var props) || props.currentMonsters.Contains(PhotonNetwork.LocalPlayer.ActorNumber))
			{
				yield break;
			}
			yield return new WaitForSeconds(prep + Mathf.Max(0f, roomSettings.monsterSpawnDelay) + 0.5f);
			List<GameModePlayer> monsterPlayers = MonkeDevNetworkingManager.Manager.Players.Where((MonkeDevNetworkingPlayer p) => props.currentMonsters.Contains(p.photonView.OwnerActorNr)).Select((MonkeDevNetworkingPlayer p) => p.gameModePlayer).Where((GameModePlayer gmp) => gmp).ToList();
			if (monsterPlayers.Count == 0)
			{
				yield break;
			}
			for (int i = 0; i < 3; i++)
			{
				foreach (GameModePlayer monsterPlayer in monsterPlayers)
				{
					monsterPlayer.IsHighlighted = true;
				}
				yield return new WaitForSeconds(0.5f);
				foreach (GameModePlayer monsterPlayer2 in monsterPlayers)
				{
					monsterPlayer2.IsHighlighted = false;
				}
				yield return new WaitForSeconds(0.3f);
			}
		}

		public static void SetMapVote(string mapName)
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				MonkeDevNetworkingPlayer localPlayer = MonkeDevNetworkingManager.Manager.LocalPlayer;
				if (!(localPlayer == null))
				{
					ExitGames.Client.Photon.Hashtable customProperties = localPlayer.photonView.Owner.CustomProperties;
					customProperties["mv"] = mapName;
					localPlayer.photonView.Owner.SetCustomProperties(customProperties);
				}
			}
		}

		private void LocalUpdateAppearance(int actorId, bool isMonster = false, bool isDead = false)
		{
			MonkeDevNetworkingPlayer player = MonkeDevNetworkingManager.Manager.Players.FirstOrDefault((MonkeDevNetworkingPlayer x) => x.photonView.OwnerActorNr == actorId);
			if ((bool)player && !(player.gameModePlayer == null))
			{
				GameModePlayer gameModePlayer = player.gameModePlayer;
				gameModePlayer.IsMonster = isMonster && Time.time >= _monsterAppearanceHoldUntil;
				gameModePlayer.IsEliminated = isDead;
				if (player.photonView.IsMine && GorillaLocomotion.Player.HasInstance)
				{
					GorillaLocomotion.Player.Instance.targetScale = gameModePlayer.RoundScale(roomSettings.monsterSize);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_EliminatePlayer(int actorId, int monsterActorId, PhotonMessageInfo info)
		{
			if (info.Sender != null && info.Sender.ActorNumber == monsterActorId)
			{
				HandleEliminatePlayer(actorId, monsterActorId);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_SawKill(int actorId, int monsterActorId, PhotonMessageInfo info)
		{
			if (info.Sender != null && info.Sender.ActorNumber == monsterActorId)
			{
				HandleEliminatePlayer(actorId, monsterActorId, bySaw: true);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_PickUpPart(int victim, int key, int bone, bool left, Vector3 offset, Quaternion turn, float size, PhotonMessageInfo info)
		{
			if (info.Sender != null)
			{
				BtmBodyPart.PickedUp(info.Sender.ActorNumber, victim, key, bone, left, offset, turn, size);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_DropPart(int victim, int key, Vector3 position, Quaternion rotation, Vector3 velocity, Vector3 spin, PhotonMessageInfo info)
		{
			if (info.Sender != null)
			{
				BtmBodyPart.Dropped(info.Sender.ActorNumber, victim, key, position, rotation, velocity, spin);
			}
		}

		private void HandleEliminatePlayer(int actorId, int monsterActorId, bool bySaw = false, Vector3 cutNormal = default(Vector3), Vector3 hitPoint = default(Vector3), Vector3 hitDirection = default(Vector3))
		{
			MonkeDevNetworkingPlayer victim = MonkeDevNetworkingManager.Manager.Players.FirstOrDefault((MonkeDevNetworkingPlayer x) => x.photonView.OwnerActorNr == actorId);
			MonkeDevNetworkingPlayer monster = MonkeDevNetworkingManager.Manager.Players.FirstOrDefault((MonkeDevNetworkingPlayer x) => x.photonView.OwnerActorNr == monsterActorId);
			if (victim == null || monster == null || !RoundProps.TryRead(out RoundProperties props) || !props.roundActive)
			{
				return;
			}
			if (!props.currentMonsters.Contains(monsterActorId) && !(monster.gameModePlayer != null && monster.gameModePlayer.isMonster))
			{
				return;
			}
			if (props.activePlayers.Contains(actorId) && (victim.gameModePlayer == null || !victim.gameModePlayer.isMonster) && (bool)BtmGore.Instance)
			{
				if (cutNormal != Vector3.zero)
				{
					BtmGore.Instance.SurvivorChopped(victim, monster, props.startTime, cutNormal, hitPoint, hitDirection);
				}
				else
				{
					BtmGore.Instance.SurvivorKilled(victim, monster, props.startTime, bySaw);
				}
			}
			if (PhotonNetwork.IsMasterClient && MasterEliminatePlayer(actorId))
			{
				MasterCreditKill(monsterActorId);
				base.photonView.RPC("RPC_CatchConfirmed", RpcTarget.All, actorId, monsterActorId);
			}
			if (victim.photonView.IsMine)
			{
				_deathKnown = true;
				_deathAt = victim.Head.position;
				_deathThrown = (BtmGore.Instance ? BtmGore.Instance.VelocityOf(victim) : Vector3.zero);
				_deathKillerAt = (monster.Head ? monster.Head.position : (_deathAt - victim.Head.forward));
				_deathKiller = ((monster.photonView.Owner != null) ? monster.photonView.Owner.NickName : null);
				LocalApplyElimination();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_CatchConfirmed(int actorId, int monsterActorId, PhotonMessageInfo info)
		{
			if (info.Sender != null && info.Sender.IsMasterClient && !(MonkeDevNetworkingManager.Manager == null))
			{
				MonkeDevNetworkingPlayer victim = MonkeDevNetworkingManager.Manager.GetPlayerByActorId(actorId);
				if (victim != null)
				{
					BtmMimicKills.Record(monsterActorId, victim);
				}
			}
		}

		private bool MasterEliminatePlayer(int actorId)
		{
			if (!PhotonNetwork.IsMasterClient || !RoundProps.TryRead(out RoundProperties props) || !props.roundActive)
			{
				return false;
			}
			SeedTeamsIfNeeded(props);
			if (!_apAuth.Remove(actorId))
			{
				return false;
			}
			RoundProps.WriteTeams(_apAuth.ToArray());
			Log(string.Format("Eliminated player {0} ({1} survivors left)", actorId, _apAuth.Count));
			return true;
		}

		private void LocalApplyElimination(bool fromPropsEdge = false)
		{
			if (!RoundProps.TryRead(out RoundProperties props) || !props.roundActive)
			{
				return;
			}
			int me = PhotonNetwork.LocalPlayer.ActorNumber;
			if (props.currentMonsters.Contains(me))
			{
				return;
			}
			if (fromPropsEdge)
			{
				if (_localEliminationApplied && Time.time - _localEliminationTime < 3f)
				{
					return;
				}
			}
			else if (!props.activePlayers.Contains(me) || _localEliminationApplied)
			{
				return;
			}
			_localEliminationApplied = true;
			_localEliminationTime = Time.time;
			StartCoroutine(EliminationTeleportCoroutine());
			OnLocalPlayerEliminated?.Invoke();
		}

		private IEnumerator EliminationTeleportCoroutine()
		{
			MonkeDevNetworkingPlayer me = MonkeDevNetworkingManager.Manager.LocalPlayer;
			float waited = 0f;
			while (me != null && me.IsBeingGrabbed && waited < 12f)
			{
				waited += Time.deltaTime;
				yield return null;
			}
			BtmDeathCam cam = (_deathKnown ? BtmDeathCam.Begin(_deathAt, _deathThrown, _deathKillerAt, _deathKiller) : null);
			_deathKnown = false;
			while ((bool)cam && cam.Watching)
			{
				yield return null;
			}
			yield return TeleportPlayer(roomSettings.spawnPoint);
			if ((bool)cam)
			{
				cam.Finish();
			}
			if (roomProperties.roundActive)
			{
				OnLocalPlayerBackInLobby?.Invoke();
			}
		}

		public static bool IsLocalSurvivor()
		{
			if (Instance == null || !PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			if (Instance.roomProperties.roundActive && Instance.roomProperties.activePlayers != null)
			{
				return Instance.roomProperties.activePlayers.Contains(PhotonNetwork.LocalPlayer.ActorNumber);
			}
			return false;
		}

		public void ContributeCrankSpin(int generatorId, float clockwiseDegrees)
		{
			if (generatorId >= 0 && generatorId < 32 && !(clockwiseDegrees <= 0f) && float.IsFinite(clockwiseDegrees) && PhotonNetwork.InRoom && IsLocalSurvivor() && RoundProps.TryRead(out RoundProperties props) && ((props.poweredGenerators >> generatorId) & 1) == 0)
			{
				base.photonView.RPC("RPC_CrankGenerator", RpcTarget.MasterClient, generatorId, clockwiseDegrees);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_CrankGenerator(int generatorId, float clockwiseDegrees, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.IsMasterClient || generatorId < 0 || generatorId >= 32 || !float.IsFinite(clockwiseDegrees) || !RoundProps.TryRead(out RoundProperties props) || !props.roundActive)
			{
				return;
			}
			Player sender = info.Sender;
			if (sender == null || props.activePlayers == null || !props.activePlayers.Contains(sender.ActorNumber))
			{
				return;
			}
			if (!_crankRoundStamp.Equals(props.startTime))
			{
				_crankRoundStamp = props.startTime;
				for (int i = 0; i < _crankCharge.Length; i++)
				{
					_crankCharge[i] = ProgressAt(props.generatorProgress, i);
				}
				_crankPoweredMask = props.poweredGenerators;
				_crankContribTimes.Clear();
			}
			int bit = 1 << generatorId;
			if ((_crankPoweredMask & bit) != 0)
			{
				return;
			}
			double now = PhotonNetwork.Time;
			float degrees = Mathf.Clamp(clockwiseDegrees, 0f, 400f);
			long key = ((long)generatorId << 32) | (uint)sender.ActorNumber;
			if (_crankContribTimes.TryGetValue(key, out var last))
			{
				degrees = Mathf.Min(degrees, Mathf.Clamp01((float)((now - last) / 0.25)) * 400f);
			}
			_crankContribTimes[key] = now;
			if (degrees <= 0f)
			{
				return;
			}
			int crankers = 0;
			foreach (KeyValuePair<long, double> kv in _crankContribTimes)
			{
				if ((int)(kv.Key >> 32) == generatorId && !(now - kv.Value > 1.25))
				{
					crankers++;
				}
			}
			float perk = MasterCrankPerkMultiplier(sender.ActorNumber);
			float before = _crankCharge[generatorId];
			int beforePct = Mathf.FloorToInt(before);
			float multiplier = Mathf.Min(1f + 0.35f * (float)Mathf.Max(0, crankers - 1), 2.05f) * perk;
			float after = Mathf.Min(before + degrees / 28f * multiplier, 100f);
			_crankCharge[generatorId] = after;
			MasterCreditCrank(sender.ActorNumber, after - before);
			int afterPct = Mathf.FloorToInt(_crankCharge[generatorId]);
			if (afterPct == beforePct)
			{
				return;
			}
			byte[] progress = new byte[32];
			for (int j = 0; j < progress.Length; j++)
			{
				progress[j] = (byte)Mathf.Clamp(Mathf.FloorToInt(_crankCharge[j]), 0, 100);
			}
			ExitGames.Client.Photon.Hashtable ht = new ExitGames.Client.Photon.Hashtable();
			ht["gpp"] = progress;
			if (afterPct >= 100)
			{
				_crankPoweredMask |= bit;
				ht["gp"] = _crankPoweredMask;
				Log(string.Format("Generator {0} fully charged ({1} cranker(s), x{2:0.00})", generatorId, crankers, multiplier));
			}
			PhotonNetwork.CurrentRoom.SetCustomProperties(ht);
		}

		private static int ProgressAt(int[] progress, int generatorId)
		{
			if (progress == null || generatorId < 0 || generatorId >= progress.Length)
			{
				return 0;
			}
			return progress[generatorId];
		}

		private int[] PickGeneratorSpawnPoints(string mapId)
		{
			MapData map = null;
			foreach (MapData m in roomSettings.maps)
			{
				if (m != null && m.sceneId == mapId)
				{
					map = m;
					break;
				}
			}
			if (map?.mapObject == null)
			{
				return Array.Empty<int>();
			}
			BtmGeneratorSpawnPoint[] all = map.mapObject.GetComponentsInChildren<BtmGeneratorSpawnPoint>(true);
			if (all.Length == 0)
			{
				Log("Map '" + mapId + "' has no BtmGeneratorSpawnPoints — generator task disabled this round.", isError: true);
				return Array.Empty<int>();
			}
			BtmGeneratorSpawnPoint[] candidates = all;
			if (map.monsterTp != null)
			{
				Vector3 monsterSpawn = map.monsterTp.transform.position;
				BtmGeneratorSpawnPoint[] clear = all.Where((BtmGeneratorSpawnPoint p) => (p.transform.position - monsterSpawn).sqrMagnitude > 36f).ToArray();
				if (clear.Length != 0)
				{
					candidates = clear;
				}
				else
				{
					Log("Map '" + mapId + "': every generator spawn point is within 6 m of the monster spawn — clearance skipped.", isError: true);
				}
			}
			List<BtmGeneratorSpawnPoint> usable = (from p in candidates
				where p.pointId >= 0 && p.pointId < 32
				group p by p.pointId into g
				select g.First()).OrderBy((BtmGeneratorSpawnPoint _) => UnityEngine.Random.value).ToList();
			if (usable.Count < candidates.Length)
			{
				Log(string.Format("Map '{0}': some spawn points have invalid/duplicate pointIds — {1} usable of {2}.", mapId, usable.Count, candidates.Length), isError: true);
			}
			if (usable.Count == 0)
			{
				return Array.Empty<int>();
			}
			int count = Mathf.Clamp(roomSettings.generatorsPerRound, 1, usable.Count);
			int deep = Mathf.Min(map.minDeepGenerators, count);
			List<BtmGeneratorSpawnPoint> picked = usable.Where((BtmGeneratorSpawnPoint p) => p.deep).Take(deep).ToList();
			if (picked.Count < deep)
			{
				Log(string.Format("Map '{0}': wants {1} deep generators but only {2} deep spawn points are usable.", mapId, deep, picked.Count), isError: true);
			}
			picked.AddRange(usable.Where((BtmGeneratorSpawnPoint p) => !picked.Contains(p)).Take(count - picked.Count));
			return picked.Select((BtmGeneratorSpawnPoint p) => p.pointId).ToArray();
		}

		public void RequestEscape()
		{
			if (!(Time.time - _lastEscapeRequestTime < 1f) && PhotonNetwork.InRoom && IsLocalSurvivor() && _generatorsCompleteFired && (!RoundProps.TryRead(out RoundProperties props) || props.escapedPlayers == null || !props.escapedPlayers.Contains(PhotonNetwork.LocalPlayer.ActorNumber)))
			{
				_lastEscapeRequestTime = Time.time;
				base.photonView.RPC("RPC_EscapeSurvivor", RpcTarget.MasterClient, PhotonNetwork.LocalPlayer.ActorNumber);
			}
		}

		private IEnumerator EscapeExitCoroutine()
		{
			MonkeDevNetworkingPlayer localPlayer = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.LocalPlayer : null);
			float deadline = Time.time + 12f;
			while (localPlayer != null && localPlayer.IsBeingGrabbed && Time.time < deadline)
			{
				yield return null;
			}
			yield return TeleportPlayer(roomSettings.spawnPoint);
			BtmItemRuntime.ClearLocalRound();
			BtmSelectedRole role = UnityEngine.Object.FindFirstObjectByType<BtmSelectedRole>(FindObjectsInactive.Include);
			if (role != null)
			{
				role.ShowEscapeWin();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_EscapeSurvivor(int actorId, PhotonMessageInfo info)
		{
			if (PhotonNetwork.IsMasterClient && info.Sender != null && info.Sender.ActorNumber == actorId && RoundProps.TryRead(out RoundProperties props) && props.roundActive && _generatorsCompleteFired)
			{
				SeedTeamsIfNeeded(props);
				if (_apAuth.Remove(actorId))
				{
					_escAuth.Add(actorId);
					RoundProps.WriteTeams(_apAuth.ToArray(), null, _escAuth.ToArray());
					MasterCreditEscape(actorId);
					Log(string.Format("Actor {0} ESCAPED ({1} out, {2} still in)", actorId, _escAuth.Count, _apAuth.Count));
				}
			}
		}

		private void PlayDeathSound(int victimActorId)
		{
			if (deathSounds == null || deathSounds.Length == 0)
			{
				return;
			}
			AudioClip clip = deathSounds[UnityEngine.Random.Range(0, deathSounds.Length)];
			if (!(clip == null))
			{
				MonkeDevNetworkingPlayer victim = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.GetPlayerByActorId(victimActorId) : null);
				Vector3 position = ((victim != null && victim.Head != null) ? victim.Head.position : ((Camera.main != null) ? Camera.main.transform.position : Vector3.zero));
				AudioSource.PlayClipAtPoint(clip, position, deathSoundVolume);
			}
		}

		public void NotifyGeneratorRegistryChanged()
		{
			_generatorsDirty = true;
		}

		public bool TryGetGeneratorProgress(out int powered, out int total)
		{
			powered = 0;
			total = BtmGenerator.ActiveGenerators.Count;
			if (total == 0)
			{
				return false;
			}
			foreach (BtmGenerator generator in BtmGenerator.ActiveGenerators)
			{
				if (generator != null && generator.IsPowered)
				{
					powered++;
				}
			}
			return true;
		}

		private void EvaluateGenerators(bool playFx)
		{
			IReadOnlyList<BtmGenerator> generators = BtmGenerator.ActiveGenerators;
			if (generators.Count == 0)
			{
				return;
			}
			RoundProps.TryRead(out RoundProperties props);
			int poweredMask = (props.roundActive ? props.poweredGenerators : 0);
			int[] progress = (props.roundActive ? props.generatorProgress : null);
			int powered = 0;
			foreach (BtmGenerator generator in generators)
			{
				if (!(generator == null))
				{
					int id = generator.generatorId;
					bool isPowered = id >= 0 && id < 32 && ((poweredMask >> id) & 1) != 0;
					generator.ApplyProgress(isPowered ? 100 : ProgressAt(progress, id));
					generator.ApplyPowered(isPowered, playFx);
					if (isPowered)
					{
						powered++;
					}
				}
			}
			OnGeneratorProgressChanged?.Invoke(powered, generators.Count);
			if (props.roundActive && powered == generators.Count && !_generatorsCompleteFired)
			{
				_generatorsCompleteFired = true;
				Log(string.Format("All {0} generators powered!", generators.Count));
				OnAllGeneratorsPowered?.Invoke();
			}
		}

		public void HandleSuicide()
		{
			base.photonView.RPC("RPCSuicide", RpcTarget.All, PhotonNetwork.LocalPlayer.ActorNumber);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPCSuicide(int actorId, PhotonMessageInfo info)
		{
			if (info.Sender == null || info.Sender.ActorNumber != actorId)
			{
				return;
			}
			MonkeDevNetworkingPlayer player = MonkeDevNetworkingManager.Manager.Players.FirstOrDefault((MonkeDevNetworkingPlayer x) => x.photonView.OwnerActorNr == actorId);
			if (player == null || !RoundProps.TryRead(out RoundProperties props))
			{
				return;
			}
			bool wasSurvivor = props.roundActive && props.activePlayers.Contains(actorId);
			if (PhotonNetwork.IsMasterClient && wasSurvivor)
			{
				MasterEliminatePlayer(actorId);
			}
			if (player.photonView.IsMine)
			{
				if (wasSurvivor)
				{
					LocalApplyElimination();
				}
				else
				{
					HandleTeleport(props.currentMonsters, props.activePlayers, props.roundActive, props.currentMap);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_Teleport(int[] monsters, int[] activePlayers, bool roundActive, string mapId, PhotonMessageInfo info)
		{
			if (info.Sender != null && info.Sender.IsMasterClient)
			{
				HandleTeleport(monsters, activePlayers, roundActive, mapId);
			}
		}

		private void HandleTeleport(int[] monsters, int[] activePlayers, bool roundActive, string mapId, double monsterArriveAt = 0.0, double survivorArriveAt = 0.0)
		{
			RoundSettings settings = Instance.roomSettings;
			MonkeDevNetworkingPlayer localPlayer = MonkeDevNetworkingManager.Manager.LocalPlayer;
			MapData map = settings.maps.Find((MapData m) => m.sceneId == mapId);
			if (map == null || !roundActive || localPlayer == null)
			{
				if (!roundActive && BtmTechTreeRoom.Instance != null && (BtmTechTreeRoom.Instance.LocalPlayerInside || BtmTechTreeRoom.Instance.IsEntering))
				{
					return;
				}
				StartCoroutine(TeleportPlayer(settings.spawnPoint));
				return;
			}
			foreach (MapData m2 in roomSettings.maps)
			{
				m2.mapObject.SetActive(false);
			}
			map.mapObject.SetActive(true);
			if (monsters != null && monsters.Contains(localPlayer.photonView.OwnerActorNr))
			{
				StartCoroutine(TeleportPlayer(map.monsterTp, monsterArriveAt));
			}
			else if (activePlayers == null || activePlayers.Contains(localPlayer.photonView.OwnerActorNr))
			{
				StartCoroutine(TeleportPlayer(map.survivoursTp, survivorArriveAt));
			}
			else
			{
				StartCoroutine(TeleportPlayer(settings.spawnPoint));
			}
		}

		private IEnumerator TeleportPlayer(RandomizeSpawnPoint randomSpawnPoint, double arriveAt = 0.0)
		{
			if (!randomSpawnPoint)
			{
				yield break;
			}
			double wait = arriveAt - PhotonNetwork.Time;
			if (wait > 0.0)
			{
				double round = roomProperties.startTime;
				float giveUpAt = Time.realtimeSinceStartup + (float)wait + 1f;
				while (PhotonNetwork.Time < arriveAt && Time.realtimeSinceStartup < giveUpAt)
				{
					yield return null;
					if (!roomProperties.roundActive || !roomProperties.startTime.Equals(round))
					{
						yield break;
					}
				}
			}
			Vector3 point = randomSpawnPoint.GetRandomPointInDisc();
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(point, Quaternion.identity);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void AddWin(int[] winnerActorIds, PhotonMessageInfo info)
		{
			if (info.Sender != null && info.Sender.IsMasterClient && !RoundProps.IsPrivateRound())
			{
				if (winnerActorIds.Contains(PhotonNetwork.LocalPlayer.ActorNumber))
				{
					GlobalLeaderboardSystem.AddPlayerStatistic(BTMLeaderboard.StatisticName);
					Log("[WON] Added win to leaderboard");
				}
				else
				{
					GlobalLeaderboardSystem.GetPlayfabStatistics(BTMLeaderboard.StatisticName);
					Log("[LOST] Refreshing leaderboard stats");
				}
			}
		}

		public override void OnLeftRoom()
		{
			_testRoundActive = false;
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player.Instance.targetScale = 1f;
			}
			roomProperties = default(RoundProperties);
			BtmMimicKills.Clear();
			ResetGore();
			_localEliminationApplied = false;
			_deathKnown = false;
			_prevMonsters = Array.Empty<int>();
			_prevActive = Array.Empty<int>();
			_prevEscaped = Array.Empty<int>();
			_prevRoundStartTime = 0.0;
			if (_deferredRefresh != null)
			{
				StopCoroutine(_deferredRefresh);
				_deferredRefresh = null;
			}
			_generatorsCompleteFired = false;
			EvaluateGenerators(playFx: false);
		}

		public override void OnRoomPropertiesUpdate(ExitGames.Client.Photon.Hashtable propertiesThatChanged)
		{
			if (!RoundProps.TryRead(out roomProperties))
			{
				return;
			}
			if (propertiesThatChanged != null && propertiesThatChanged.Count > 0)
			{
				bool onlyGenerators = true;
				foreach (object key in propertiesThatChanged.Keys)
				{
					if (!"gpp".Equals(key))
					{
						onlyGenerators = false;
						break;
					}
				}
				if (onlyGenerators)
				{
					EvaluateGenerators(true);
					OnRoundPropertiesChanged?.Invoke(roomProperties);
					return;
				}
			}
			if (roomProperties.roundActive && !_prevRoundStartTime.Equals(roomProperties.startTime))
			{
				HoldMonsterAppearanceForSpawnDelay();
			}
			RefreshAllAppearances();
			int[] monsters = roomProperties.currentMonsters ?? Array.Empty<int>();
			int[] active = roomProperties.activePlayers ?? Array.Empty<int>();
			int[] escaped = roomProperties.escapedPlayers ?? Array.Empty<int>();
			if (roomProperties.roundActive && _prevRoundStartTime.Equals(roomProperties.startTime))
			{
				foreach (int id in _prevActive)
				{
					if (active.Contains(id) || monsters.Contains(id) || escaped.Contains(id))
					{
						continue;
					}
					if (PhotonNetwork.CurrentRoom != null && PhotonNetwork.CurrentRoom.GetPlayer(id) != null)
					{
						if (id == PhotonNetwork.LocalPlayer.ActorNumber)
						{
							LocalApplyElimination(true);
						}
						PlayDeathSound(id);
					}
				}
				if (PhotonNetwork.LocalPlayer != null)
				{
					foreach (int id2 in escaped)
					{
						if (!_prevEscaped.Contains(id2) && id2 == PhotonNetwork.LocalPlayer.ActorNumber)
						{
							StartCoroutine(EscapeExitCoroutine());
						}
					}
				}
			}
			_prevMonsters = monsters;
			_prevRoundStartTime = roomProperties.startTime;
			_prevActive = roomProperties.activePlayers ?? Array.Empty<int>();
			_prevEscaped = escaped;
			EvaluateGenerators(true);
			OnRoundPropertiesChanged?.Invoke(roomProperties);
		}

		private void RefreshAllAppearances()
		{
			if (PhotonNetwork.CurrentRoom == null)
			{
				return;
			}
			foreach (KeyValuePair<int, Player> player in PhotonNetwork.CurrentRoom.Players)
			{
				int actorNumber = player.Value.ActorNumber;
				bool isMonster = roomProperties.currentMonsters.Contains(actorNumber);
				bool isActive = roomProperties.activePlayers.Contains(actorNumber);
				bool isDead = roomProperties.activePlayers != null && roomProperties.currentMonsters != null && (roomProperties.activePlayers.Length != 0 || roomProperties.currentMonsters.Length != 0) && roomProperties.roundActive && !(isMonster || isActive);
				LocalUpdateAppearance(actorNumber, isMonster, isDead);
			}
		}

		public override void OnJoinedRoom()
		{
			_localEliminationApplied = false;
			_deathKnown = false;
			_generatorsCompleteFired = false;
			_lobbyClockSentAt = -1f;
			Mods.TurnOffEverywhere();
			ClaimPrivateRoom();
			if (!RoundProps.TryRead(out roomProperties))
			{
				return;
			}
			if (roomProperties.roundActive && !string.IsNullOrEmpty(roomProperties.currentMap))
			{
				MapData mapData = roomSettings.maps.Find((MapData m) => m.sceneId == roomProperties.currentMap);
				if (mapData != null && mapData.mapObject != null && !mapData.mapObject.activeSelf)
				{
					foreach (MapData map in roomSettings.maps)
					{
						if (map.mapObject != null)
						{
							map.mapObject.SetActive(false);
						}
					}
					mapData.mapObject.SetActive(true);
				}
			}
			_generatorsDirty = true;
			KickDeferredAppearanceRefresh();
			_prevRoundStartTime = roomProperties.startTime;
			_prevMonsters = roomProperties.currentMonsters ?? Array.Empty<int>();
			_prevActive = roomProperties.activePlayers ?? Array.Empty<int>();
			_prevEscaped = roomProperties.escapedPlayers ?? Array.Empty<int>();
		}

		private void ClaimPrivateRoom()
		{
			if (!PhotonNetwork.InRoom || !PhotonNetwork.IsMasterClient)
			{
				return;
			}
			Room currentRoom = PhotonNetwork.CurrentRoom;
			if (currentRoom == null || currentRoom.IsVisible)
			{
				return;
			}
			if (currentRoom.CustomProperties.TryGetValue("queue", out object value) && value is string text && !string.IsNullOrEmpty(text))
			{
				return;
			}
			currentRoom.SetCustomProperties(new ExitGames.Client.Photon.Hashtable { ["queue"] = "BeTheMonster" });
			Log("Claimed private room '" + currentRoom.Name + "' for BeTheMonster");
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			_lobbyClockSentAt = -1f;
			ClaimPrivateRoom();
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			RoundProps.TryRead(out roomProperties);
			KickDeferredAppearanceRefresh();
		}

		private void KickDeferredAppearanceRefresh()
		{
			if (_deferredRefresh != null)
			{
				StopCoroutine(_deferredRefresh);
			}
			_deferredRefresh = StartCoroutine(DeferredRefreshAppearances());
		}

		private IEnumerator DeferredRefreshAppearances()
		{
			for (int attempt = 0; attempt < 20; attempt++)
			{
				if (!PhotonNetwork.InRoom)
				{
					yield break;
				}
				RoundProps.TryRead(out roomProperties);
				RefreshAllAppearances();
				HashSet<int> known = MonkeDevNetworkingManager.Manager.Players.Where((MonkeDevNetworkingPlayer p) => p != null && p.photonView != null).Select((MonkeDevNetworkingPlayer p) => p.photonView.OwnerActorNr).ToHashSet();
				if (PhotonNetwork.CurrentRoom.Players.Values.All((Player p) => known.Contains(p.ActorNumber)))
				{
					yield break;
				}
				yield return new WaitForSeconds(0.5f);
			}
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			OnPlayerLeft(otherPlayer);
		}

		private void OnPlayerLeft(Player player)
		{
			if (!PhotonNetwork.IsMasterClient || !RoundProps.TryRead(out RoundProperties props) || !props.roundActive)
			{
				return;
			}
			SeedTeamsIfNeeded(props);
			int actorNumber = player.ActorNumber;
			bool apRemoved = _apAuth.Remove(actorNumber);
			bool cmRemoved = _cmAuth.Remove(actorNumber);
			if (apRemoved || cmRemoved)
			{
				RoundProps.WriteTeams(apRemoved ? _apAuth.ToArray() : null, cmRemoved ? _cmAuth.ToArray() : null);
			}
		}

		private static void Log(string msg, bool isError = false)
		{
			string text = "<color=green><b>[BTM]</b></color>: " + msg;
			if (isError)
			{
				text += " <color=red>IsError</color>";
			}
			Debug.Log(text);
		}
	}
}
