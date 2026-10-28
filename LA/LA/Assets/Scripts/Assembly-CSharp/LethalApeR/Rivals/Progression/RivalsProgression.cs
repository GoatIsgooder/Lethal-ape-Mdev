using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Rivals.Combat;
using LethalApeR.Rivals.Economy;
using Photon.Pun;
using Photon.Realtime;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	[Obfuscation(Exclude = true)]
	public class RivalsProgression : MonoBehaviourPunCallbacks
	{
		public const string LevelProp = "rivalsLevel";

		public const string KillsStatistic = "RivalsKills";

		public const string LevelStatistic = "RivalsLevel";

		private const string XpKey = "Progression.TotalXp";

		private const string KillsKey = "Progression.Kills";

		[Header("XP awards")]
		[Tooltip("XP per kill during a match.")]
		public int xpPerKill = 15;

		[Tooltip("Extra XP when the kill was a headshot.")]
		public int xpHeadshotBonus = 5;

		[Tooltip("XP for being on the round-winning team.")]
		public int xpPerRoundWin = 25;

		[Tooltip("XP for winning the match.")]
		public int xpPerMatchWin = 75;

		[Tooltip("Participation XP for finishing a match you lost.")]
		public int xpPerMatchLoss = 20;

		[Header("Qauth")]
		[Tooltip("Minimum seconds between statistic pushes (changes are batched).")]
		public float statPushInterval = 30f;

		[Header("Level-up rewards")]
		[Tooltip("Keys granted per level gained, paid the moment the level-up happens.")]
		[SerializeField]
		private int keysPerLevel = 50;

		private int _totalXp;

		private int _level = 1;

		private int _lifetimeKills;

		private bool _statsDirty;

		private float _lastStatPush = -999f;

		private int _lastPushedKills = -1;

		private int _lastPushedLevel = -1;

		private bool _trackingMatch;

		private int _trackXpStart;

		private int _trackLevelStart;

		private int _trackRpStart;

		private RivalsRank _trackRankStart;

		private int _trackKeysGranted;

		public static RivalsProgression Instance { get; private set; }

		public int TotalXp => _totalXp;

		public int Level => _level;

		public RivalsRank Rank => RivalsRanked.Rank;

		public int LifetimeKills => _lifetimeKills;

		public int XpIntoLevel => RankDefs.XpIntoLevel(_totalXp);

		public int XpForNextLevel => RankDefs.XpForLevelUp(_level);

		private int LocalActor
		{
			get
			{
				if (!PhotonNetwork.InRoom)
				{
					return 1;
				}
				return PhotonNetwork.LocalPlayer.ActorNumber;
			}
		}

		public event Action<int, string> OnXpGained;

		public event Action<int, RivalsRank> OnLevelChanged;

		public event Action<int, int> OnKeysGranted;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
			_totalXp = Mathf.Max(0, SaveWrapper.GetInt(XpKey, 0));
			_lifetimeKills = Mathf.Max(0, SaveWrapper.GetInt(KillsKey, 0));
			_level = RankDefs.LevelFromTotalXp(_totalXp);
		}

		public override void OnEnable()
		{
			base.OnEnable();
			RivalsEvents.OnPlayerKilled += HandlePlayerKilled;
		}

		public override void OnDisable()
		{
			base.OnDisable();
			RivalsEvents.OnPlayerKilled -= HandlePlayerKilled;
		}

		private void Start()
		{
			PushLevelProp();
			RivalsRanked.PushRpProp();
			StartCoroutine(StatPushLoop());
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
			PushLevelProp();
			RivalsRanked.PushRpProp();
		}

		private void HandlePlayerKilled(KillInfo info)
		{
			if (info.KillerActorNumber != LocalActor || info.VictimActorNumber == info.KillerActorNumber)
			{
				return;
			}
			GamemodeManager instance = GamemodeManager.Instance;
			if (!(instance == null))
			{
				GameState state = instance.State;
				if (state == GameState.RoundActive || state == GameState.RoundEnd)
				{
					_lifetimeKills++;
					SaveWrapper.SetInt(KillsKey, _lifetimeKills);
					_statsDirty = true;
					int amount = xpPerKill;
					if (info.WasHeadshot)
					{
						AddXp(amount + xpHeadshotBonus, "headshot kill");
					}
					else
					{
						AddXp(amount, "kill");
					}
				}
			}
		}

		public void AwardRoundWin()
		{
			AddXp(xpPerRoundWin, "round win");
		}

		public void AwardMatchEnd(bool won)
		{
			CompleteMatch(won);
		}

		public void BeginMatchTracking()
		{
			SnapshotTrackingBaseline();
			_trackKeysGranted = 0;
			_trackingMatch = true;
		}

		public MatchXpSummary CompleteMatch(bool won)
		{
			if (!_trackingMatch)
			{
				SnapshotTrackingBaseline();
			}
			AddXp(won ? xpPerMatchWin : xpPerMatchLoss, won ? "match win" : "match played");
			int rpDelta = RivalsRanked.ApplyMatchResult(won);
			MatchXpSummary result = new MatchXpSummary
			{
				Won = won,
				XpStart = _trackXpStart,
				XpEnd = _totalXp,
				LevelStart = _trackLevelStart,
				LevelEnd = _level,
				KeysGranted = _trackKeysGranted,
				RpStart = _trackRpStart,
				RpEnd = RivalsRanked.Rp,
				RpDelta = rpDelta,
				RankStart = _trackRankStart,
				RankEnd = RivalsRanked.Rank
			};
			_trackingMatch = false;
			_trackKeysGranted = 0;
			FlushStatsNow();
			return result;
		}

		private void SnapshotTrackingBaseline()
		{
			_trackXpStart = _totalXp;
			_trackLevelStart = _level;
			_trackRpStart = RivalsRanked.Rp;
			_trackRankStart = RivalsRanked.Rank;
		}

		public void AddXp(int amount, string reason = "")
		{
			if (amount <= 0)
			{
				return;
			}
			_totalXp += amount;
			SaveWrapper.SetInt(XpKey, _totalXp);
			this.OnXpGained?.Invoke(amount, reason);
			int newLevel = RankDefs.LevelFromTotalXp(_totalXp);
			int levelsGained = newLevel - _level;
			if (levelsGained > 0)
			{
				_level = newLevel;
				_statsDirty = true;
				PushLevelProp();
				int keys = GrantLevelUpKeys(levelsGained);
				this.OnLevelChanged?.Invoke(_level, Rank);
				Debug.Log(string.Format("[RivalsProgression] LEVEL UP → {0} (+{1} keys)", _level, keys));
			}
		}

		private int GrantLevelUpKeys(int levelsGained)
		{
			int keys = keysPerLevel * levelsGained;
			if (keys <= 0)
			{
				return 0;
			}
			if (KeyManager.Instance != null)
			{
				KeyManager.Instance.Add(keys);
			}
			else
			{
				Debug.LogWarning("[RivalsProgression] Level-up keys earned with no KeyManager alive — reward lost.");
			}
			_trackKeysGranted += keys;
			this.OnKeysGranted?.Invoke(keys, levelsGained);
			return keys;
		}

		private void PushLevelProp()
		{
			if (PhotonNetwork.IsConnectedAndReady)
			{
				Player localPlayer = PhotonNetwork.LocalPlayer;
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable.Add(LevelProp, _level);
				localPlayer.SetCustomProperties(hashtable);
			}
		}

		public static int LoadSavedLevel()
		{
			return RankDefs.LevelFromTotalXp(SaveWrapper.GetInt(XpKey, 0));
		}

		public static bool TryGetLevel(Player player, out int level)
		{
			level = 0;
			object value;
			if (player?.CustomProperties == null || !player.CustomProperties.TryGetValue(LevelProp, out value) || !(value is int num))
			{
				return false;
			}
			level = num;
			return true;
		}

		private IEnumerator StatPushLoop()
		{
			WaitForSeconds wait = new WaitForSeconds(5f);
			while (true)
			{
				yield return wait;
				if ((_statsDirty || RivalsRanked.StatPushPending) && Time.unscaledTime - _lastStatPush >= statPushInterval)
				{
					FlushStatsNow();
				}
			}
		}

		public void FlushStatsNow()
		{
			_lastStatPush = Time.unscaledTime;
			RivalsRanked.PushStatistic();
			_statsDirty = false;
			if (!Qauth.IsLoggedIn || (_lifetimeKills == _lastPushedKills && _level == _lastPushedLevel))
			{
				return;
			}
			SubmitStats(_lifetimeKills, _level);
		}

		private async void SubmitStats(int kills, int level)
		{
			string error = "rejected by Qauth";
			bool ok;
			try
			{
				ok = await Qauth.Leaderboards.SubmitAsync(new Dictionary<string, long>
				{
					{ KillsStatistic, kills },
					{ LevelStatistic, level }
				});
			}
			catch (Exception ex)
			{
				ok = false;
				error = ex.Message;
			}
			if (ok)
			{
				_lastPushedKills = kills;
				_lastPushedLevel = level;
			}
			else
			{
				_statsDirty = true;
				Debug.LogWarning("[RivalsProgression] Statistic push failed: " + error);
			}
		}
	}
}
