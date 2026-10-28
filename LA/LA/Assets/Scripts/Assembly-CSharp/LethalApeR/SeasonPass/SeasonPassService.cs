using System;
using System.Collections.Generic;
using LethalApeR.Gameplay;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public sealed class SeasonPassService
	{
		public static int DevDayOffset;

		private readonly List<SeasonQuestDefinition> _dailyLineup = new List<SeasonQuestDefinition>();

		private readonly List<SeasonQuestDefinition> _drawScratch = new List<SeasonQuestDefinition>();

		private readonly Dictionary<string, SeasonQuestProgress> _dailyIndex = new Dictionary<string, SeasonQuestProgress>(StringComparer.Ordinal);

		private readonly Dictionary<string, SeasonQuestProgress> _challengeIndex = new Dictionary<string, SeasonQuestProgress>(StringComparer.Ordinal);

		private readonly List<SeasonQuestDefinition> _visibleChallenges = new List<SeasonQuestDefinition>();

		private SeasonPassSeason _visibleFor;

		private int _visibleCount = -1;

		private int _visibleGates = -1;

		private static SeasonPassService _instance;

		private static bool _missingSeasonLogged;

		public static bool DevIgnoreDates;

		public static bool DevActAsRelease;

		private SeasonPassSaveData _data;

		public const string DevIgnoreDatesPref = "SeasonPass.DevIgnoreDates";

		public const string DevActAsReleasePref = "SeasonPass.DevActAsRelease";

		public IReadOnlyList<SeasonQuestDefinition> DailyQuests => _dailyLineup;

		public IReadOnlyList<SeasonQuestDefinition> Challenges
		{
			get
			{
				SeasonPassSeason season = Season;
				if (season == null)
				{
					_visibleChallenges.Clear();
					return _visibleChallenges;
				}
				List<SeasonQuestDefinition> challenges = season.challenges;
				if ((object)_visibleFor == season && _visibleCount == challenges.Count && _visibleGates == FeatureGates.Version)
				{
					return _visibleChallenges;
				}
				_visibleFor = season;
				_visibleCount = challenges.Count;
				_visibleGates = FeatureGates.Version;
				_visibleChallenges.Clear();
				for (int i = 0; i < challenges.Count; i++)
				{
					if (challenges[i] != null && challenges[i].IsAvailable)
					{
						_visibleChallenges.Add(challenges[i]);
					}
				}
				return _visibleChallenges;
			}
		}

		public int DayNumber => SeasonPassClock.DayNumber + DevDayOffset;

		public int ClaimableQuestCount
		{
			get
			{
				int count = 0;
				for (int i = 0; i < _dailyLineup.Count; i++)
				{
					if (CanClaimQuest(_dailyLineup[i]))
					{
						count++;
					}
				}
				IReadOnlyList<SeasonQuestDefinition> challenges = Challenges;
				for (int j = 0; j < challenges.Count; j++)
				{
					if (CanClaimQuest(challenges[j]))
					{
						count++;
					}
				}
				return count;
			}
		}

		public int CompletedChallengeCount
		{
			get
			{
				int count = 0;
				IReadOnlyList<SeasonQuestDefinition> challenges = Challenges;
				for (int i = 0; i < challenges.Count; i++)
				{
					SeasonQuestProgress progress = GetProgress(challenges[i]);
					if (progress != null && progress.claimed)
					{
						count++;
					}
				}
				return count;
			}
		}

		public static bool IsDevEnvironment => Debug.isDebugBuild;

		public static SeasonPassService Instance
		{
			get
			{
				if (_instance != null)
				{
					return _instance;
				}
				if (_missingSeasonLogged)
				{
					return null;
				}
				SeasonPassSeason season = Resources.Load<SeasonPassSeason>(SeasonPassSeason.ResourcePath);
				if (season == null)
				{
					if (!_missingSeasonLogged)
					{
						Debug.LogWarning("[SeasonPass] No season at Resources/SeasonPass/ActiveSeason.");
					}
					_missingSeasonLogged = true;
					return null;
				}
				_instance = new SeasonPassService(season);
				return _instance;
			}
		}

		public SeasonPassSeason Season { get; }

		public bool PreviewAccess { get; private set; }

		public bool ReleaseLocked
		{
			get
			{
				if (!Season.releaseReady && !IsDevEnvironment)
				{
					return !PreviewAccess;
				}
				return false;
			}
		}

		public bool PremiumSaleLocked
		{
			get
			{
				if (!Season.releaseReady)
				{
					return !IsDevEnvironment;
				}
				return false;
			}
		}

		public bool IsPreview
		{
			get
			{
				if (PreviewAccess)
				{
					return PremiumSaleLocked;
				}
				return false;
			}
		}

		public SeasonPassPhase Phase
		{
			get
			{
				if (ReleaseLocked)
				{
					return SeasonPassPhase.Upcoming;
				}
				if (DevIgnoreDates && IsDevEnvironment)
				{
					return SeasonPassPhase.Live;
				}
				DateTime now = SeasonPassClock.UtcNow;
				if (now < Season.StartUtc)
				{
					return SeasonPassPhase.Upcoming;
				}
				if (now >= Season.EndUtc)
				{
					return SeasonPassPhase.Ended;
				}
				return SeasonPassPhase.Live;
			}
		}

		public bool CountsLocalXp => IsDevEnvironment;

		public int LocalXp => _data.xp;

		public int ServerXp => _data.serverXp;

		public int Xp
		{
			get
			{
				if (CountsLocalXp)
				{
					return (int)Math.Min((long)_data.xp + (long)_data.serverXp, 2147483647L);
				}
				return _data.serverXp;
			}
		}

		public int BoughtLevels => _data.boughtLevels;

		public int EarnedLevel => Season.LevelForXp(Xp);

		public int Level => Mathf.Min(Season.LevelCap, EarnedLevel + Mathf.Max(0, _data.boughtLevels));

		public int MaxLevel => Season.MaxLevel;

		public int LevelCap => Season.LevelCap;

		public bool IsCapped => Season.LevelCap < Season.MaxLevel;

		public bool IsMaxLevel => Level >= Season.LevelCap;

		public int XpForNextLevel => Season.XpForLevelUp(EarnedLevel);

		public int XpIntoLevel => Xp - Season.XpToReach(EarnedLevel);

		public float LevelProgress
		{
			get
			{
				if (IsMaxLevel)
				{
					return 1f;
				}
				if (XpForNextLevel <= 0)
				{
					return 1f;
				}
				return Mathf.Clamp01((float)XpIntoLevel / (float)XpForNextLevel);
			}
		}

		public bool ServerPremium { get; private set; }

		public bool HasPremium
		{
			get
			{
				if (!_data.premium)
				{
					return ServerPremium;
				}
				return true;
			}
		}

		public int ClaimableRewardCount
		{
			get
			{
				int count = 0;
				for (int i = 1; i <= Season.MaxLevel; i++)
				{
					if (GetClaimBlock(i) == SeasonClaimBlock.None)
					{
						count++;
					}
				}
				return count;
			}
		}

		public event Action<SeasonQuestDefinition> QuestCompleted;

		public event Action<SeasonQuestDefinition> QuestClaimed;

		public event Action Changed;

		public event Action<int> LevelReached;

		public event Action<int> RewardClaimed;

		public event Action PremiumChanged;

		public SeasonQuestProgress GetProgress(SeasonQuestDefinition quest)
		{
			if (quest == null || string.IsNullOrEmpty(quest.questId))
			{
				return null;
			}
			if (_dailyLineup.Contains(quest))
			{
				return GetOrCreate(_dailyIndex, _data.daily, quest.questId);
			}
			if (Season.challenges.Contains(quest))
			{
				return GetOrCreate(_challengeIndex, _data.challenges, quest.questId);
			}
			return null;
		}

		public bool IsQuestComplete(SeasonQuestDefinition quest)
		{
			SeasonQuestProgress progress = GetProgress(quest);
			if (progress != null)
			{
				return progress.progress >= quest.target;
			}
			return false;
		}

		public bool CanClaimQuest(SeasonQuestDefinition quest)
		{
			SeasonQuestProgress progress = GetProgress(quest);
			if (progress != null && !progress.claimed && progress.progress >= quest.target)
			{
				return Phase == SeasonPassPhase.Live;
			}
			return false;
		}

		public bool TryClaimQuest(SeasonQuestDefinition quest)
		{
			if (!CanClaimQuest(quest))
			{
				return false;
			}
			GetProgress(quest).claimed = true;
			int level = Level;
			_data.xp = (int)Math.Min((long)_data.xp + (long)quest.xpReward, 2147483647L);
			Save();
			QuestClaimed?.Invoke(quest);
			AnnounceLevels(level);
			Changed?.Invoke();
			return true;
		}

		internal void MarkQuestClaimed(SeasonQuestDefinition quest)
		{
			SeasonQuestProgress progress = GetProgress(quest);
			if (progress != null && !progress.claimed)
			{
				progress.claimed = true;
				progress.progress = Mathf.Max(progress.progress, quest.target);
				Save();
				QuestClaimed?.Invoke(quest);
				Changed?.Invoke();
			}
		}

		internal void ApplyServerQuests(int serverDay, IList<string> daily, IList<string> challenges)
		{
			bool changed = false;
			if (challenges != null)
			{
				foreach (string id in challenges)
				{
					changed |= MarkClaimedById(Season.challenges, _challengeIndex, _data.challenges, id);
				}
			}
			if (daily != null && DayNumber == serverDay)
			{
				foreach (string id2 in daily)
				{
					changed |= MarkClaimedById(_dailyLineup, _dailyIndex, _data.daily, id2);
				}
			}
			if (changed)
			{
				Save();
				Changed?.Invoke();
			}
		}

		private static bool MarkClaimedById(IList<SeasonQuestDefinition> quests, Dictionary<string, SeasonQuestProgress> index, List<SeasonQuestProgress> store, string id)
		{
			if (string.IsNullOrEmpty(id))
			{
				return false;
			}
			for (int i = 0; i < quests.Count; i++)
			{
				SeasonQuestDefinition quest = quests[i];
				if (!(quest == null) && !(quest.questId != id))
				{
					SeasonQuestProgress progress = GetOrCreate(index, store, id);
					if (progress.claimed)
					{
						return false;
					}
					progress.claimed = true;
					progress.progress = Mathf.Max(progress.progress, quest.target);
					return true;
				}
			}
			return false;
		}

		public void DevProgressQuest(SeasonQuestDefinition quest, int amount)
		{
			SeasonQuestProgress progress = GetProgress(quest);
			if (progress != null && !progress.claimed)
			{
				int before = progress.progress;
				progress.progress = Mathf.Clamp(before + amount, 0, quest.target);
				Save();
				if (before < quest.target && progress.progress >= quest.target)
				{
					QuestCompleted?.Invoke(quest);
				}
				Changed?.Invoke();
			}
		}

		private void RestoreQuests()
		{
			_challengeIndex.Clear();
			foreach (SeasonQuestProgress progress in _data.challenges)
			{
				if (progress != null && !string.IsNullOrEmpty(progress.id))
				{
					_challengeIndex[progress.id] = progress;
				}
			}
			_dailyIndex.Clear();
			foreach (SeasonQuestProgress progress2 in _data.daily)
			{
				if (progress2 != null && !string.IsNullOrEmpty(progress2.id))
				{
					_dailyIndex[progress2.id] = progress2;
				}
			}
			DrawDaily(_data.dailyDay);
		}

		private void RollDailyIfDue()
		{
			if (!SeasonPassClock.Settled)
			{
				return;
			}
			int day = DayNumber;
			if (day <= _data.dailyDay)
			{
				return;
			}
			_data.dailyDay = day;
			_data.daily.Clear();
			_dailyIndex.Clear();
			DrawDaily(day);
			foreach (SeasonQuestDefinition quest in _dailyLineup)
			{
				GetOrCreate(_dailyIndex, _data.daily, quest.questId);
			}
			int lastLogin = _data.loginDay;
			_data.loginDay = day;
			Save();
			if (day > lastLogin)
			{
				OnQuestEvent(SeasonQuestEvent.DailyLogin, 1);
			}
			Changed?.Invoke();
		}

		private void DrawDaily(int day)
		{
			_dailyLineup.Clear();
			if (day < 0)
			{
				return;
			}
			Season.GetDailyDrawPool(_drawScratch);
			uint seed = Hash(Season.seasonId) ^ ((uint)day * 2654435761u);
			if (seed == 0)
			{
				seed = 2654435769u;
			}
			for (int i = _drawScratch.Count - 1; i > 0; i--)
			{
				seed ^= seed << 13;
				seed ^= seed >> 17;
				seed ^= seed << 5;
				int j = (int)(seed % (uint)(i + 1));
				SeasonQuestDefinition temp = _drawScratch[i];
				_drawScratch[i] = _drawScratch[j];
				_drawScratch[j] = temp;
			}
			int count = Mathf.Min(Season.dailyCount, _drawScratch.Count);
			for (int k = 0; k < count; k++)
			{
				_dailyLineup.Add(_drawScratch[k]);
			}
		}

		private void OnQuestEvent(SeasonQuestEvent e, int amount)
		{
			if (Phase != SeasonPassPhase.Live)
			{
				return;
			}
			bool changed = false;
			for (int i = 0; i < _dailyLineup.Count; i++)
			{
				changed |= Advance(_dailyLineup[i], _dailyIndex, _data.daily, e, amount);
			}
			List<SeasonQuestDefinition> challenges = Season.challenges;
			for (int j = 0; j < challenges.Count; j++)
			{
				changed |= Advance(challenges[j], _challengeIndex, _data.challenges, e, amount);
			}
			if (changed)
			{
				Save();
				Changed?.Invoke();
			}
		}

		private void OnQuestTotal(SeasonQuestEvent e, int total)
		{
			if (Phase != SeasonPassPhase.Live)
			{
				return;
			}
			bool changed = false;
			for (int i = 0; i < _dailyLineup.Count; i++)
			{
				changed |= Reach(_dailyLineup[i], _dailyIndex, _data.daily, e, total);
			}
			List<SeasonQuestDefinition> challenges = Season.challenges;
			for (int j = 0; j < challenges.Count; j++)
			{
				changed |= Reach(challenges[j], _challengeIndex, _data.challenges, e, total);
			}
			if (changed)
			{
				Save();
				Changed?.Invoke();
			}
		}

		private bool Reach(SeasonQuestDefinition quest, Dictionary<string, SeasonQuestProgress> index, List<SeasonQuestProgress> store, SeasonQuestEvent e, int total)
		{
			if (quest != null && !quest.IsAvailable)
			{
				return false;
			}
			if (quest == null || quest.trigger != e || string.IsNullOrEmpty(quest.questId))
			{
				return false;
			}
			SeasonQuestProgress progress = GetOrCreate(index, store, quest.questId);
			int value = Mathf.Min(total, quest.target);
			if (progress.claimed || value <= progress.progress)
			{
				return false;
			}
			progress.progress = value;
			if (total >= quest.target)
			{
				QuestCompleted?.Invoke(quest);
			}
			return true;
		}

		private bool Advance(SeasonQuestDefinition quest, Dictionary<string, SeasonQuestProgress> index, List<SeasonQuestProgress> store, SeasonQuestEvent e, int amount)
		{
			if (quest != null && !quest.IsAvailable)
			{
				return false;
			}
			if (quest == null || quest.trigger != e || string.IsNullOrEmpty(quest.questId))
			{
				return false;
			}
			SeasonQuestProgress progress = GetOrCreate(index, store, quest.questId);
			if (progress.claimed || progress.progress >= quest.target)
			{
				return false;
			}
			int next = progress.progress + amount;
			progress.progress = Mathf.Min(next, quest.target);
			if (next >= quest.target)
			{
				QuestCompleted?.Invoke(quest);
			}
			return true;
		}

		private static SeasonQuestProgress GetOrCreate(Dictionary<string, SeasonQuestProgress> index, List<SeasonQuestProgress> store, string id)
		{
			if (!index.TryGetValue(id, out var value))
			{
				value = new SeasonQuestProgress
				{
					id = id
				};
				index[id] = value;
				store.Add(value);
			}
			return value;
		}

		private static uint Hash(string s)
		{
			uint hash = 2166136261u;
			if (s != null)
			{
				for (int i = 0; i < s.Length; i++)
				{
					hash ^= s[i];
					hash *= 16777619;
				}
			}
			return hash;
		}

		private SeasonPassService(SeasonPassSeason season)
		{
			Season = season;
			_data = SeasonPassStore.Load(season.seasonId);
			RestoreQuests();
			SeasonQuestEvents.Raised += OnQuestEvent;
			SeasonQuestEvents.Reached += OnQuestTotal;
		}

		internal void SetPreviewAccess(bool on)
		{
			if (PreviewAccess != on)
			{
				PreviewAccess = on;
				Debug.Log(on ? "[SeasonPass] Preview access: this account sees the season before launch." : "[SeasonPass] Preview access off.");
				Changed?.Invoke();
			}
		}

		internal void ApplyServerState(IList<int> claimedLevels, int serverXp, bool serverPremium)
		{
			long mask = 0L;
			if (claimedLevels != null)
			{
				foreach (int level in claimedLevels)
				{
					if (level >= 1 && level < 64)
					{
						mask |= 1L << level - 1;
					}
				}
			}
			int xp = Mathf.Max(0, serverXp);
			bool premiumChanged = ServerPremium != serverPremium;
			if (mask != _data.claimedMask || xp != _data.serverXp || premiumChanged)
			{
				int before = Level;
				_data.claimedMask = mask;
				_data.serverXp = xp;
				ServerPremium = serverPremium;
				Save();
				AnnounceLevels(before);
				if (premiumChanged)
				{
					PremiumChanged?.Invoke();
				}
				Changed?.Invoke();
			}
		}

		public bool AddXp(int amount, string source)
		{
			if (amount <= 0 || Phase != SeasonPassPhase.Live)
			{
				return false;
			}
			int level = Level;
			_data.xp = (int)Math.Min((long)_data.xp + (long)amount, 2147483647L);
			Save();
			AnnounceLevels(level);
			Changed?.Invoke();
			return true;
		}

		public bool IsClaimed(int level)
		{
			if (level < 1 || level > 64)
			{
				return false;
			}
			return (_data.claimedMask & (1L << level - 1)) != 0;
		}

		public SeasonClaimBlock GetClaimBlock(int level)
		{
			SeasonPassLevel passLevel = Season.GetLevel(level);
			if (passLevel == null || passLevel.reward == null)
			{
				return SeasonClaimBlock.NoReward;
			}
			if (IsClaimed(level))
			{
				return SeasonClaimBlock.Claimed;
			}
			if (passLevel.reward.comingSoon)
			{
				return SeasonClaimBlock.ComingSoon;
			}
			if (level > Season.LevelCap)
			{
				return SeasonClaimBlock.LockedUntilUpdate;
			}
			if (Level < level)
			{
				return SeasonClaimBlock.NotReached;
			}
			if (passLevel.track == SeasonTrack.Premium && !HasPremium)
			{
				return SeasonClaimBlock.NeedsPremium;
			}
			if (Phase == SeasonPassPhase.Upcoming)
			{
				return SeasonClaimBlock.SeasonClosed;
			}
			return SeasonClaimBlock.None;
		}

		public bool TryClaim(int level)
		{
			if (GetClaimBlock(level) != SeasonClaimBlock.None)
			{
				return false;
			}
			_data.claimedMask |= 1L << level - 1;
			Save();
			RewardClaimed?.Invoke(level);
			SeasonPassReward reward = Season.GetLevel(level).reward;
			if (reward.kind == SeasonRewardKind.Xp && reward.amount > 0)
			{
				AddXp(reward.amount, "pass level " + level);
			}
			Changed?.Invoke();
			return true;
		}

		public int FirstClaimableLevel()
		{
			for (int i = 1; i <= Season.MaxLevel; i++)
			{
				if (GetClaimBlock(i) == SeasonClaimBlock.None)
				{
					return i;
				}
			}
			return 0;
		}

		public void SetBoughtLevels(int count)
		{
			count = Mathf.Max(0, count);
			if (_data.boughtLevels != count)
			{
				int level = Level;
				_data.boughtLevels = count;
				Save();
				AnnounceLevels(level);
				Changed?.Invoke();
			}
		}

		public void SetPremium(bool owned)
		{
			if (_data.premium != owned)
			{
				_data.premium = owned;
				Save();
				PremiumChanged?.Invoke();
				Changed?.Invoke();
			}
		}

		public void Tick()
		{
			RollDailyIfDue();
		}

		private void AnnounceLevels(int before)
		{
			int level = Level;
			for (int i = before + 1; i <= level; i++)
			{
				LevelReached?.Invoke(i);
			}
		}

		private void Save()
		{
			SeasonPassStore.Save(_data);
		}

		public void DevSetXp(int xp)
		{
			int level = Level;
			_data.xp = Mathf.Max(0, xp - _data.serverXp);
			Save();
			AnnounceLevels(level);
			Changed?.Invoke();
		}

		public void DevResetProgress()
		{
			SeasonPassStore.Delete(Season.seasonId);
			_data = new SeasonPassSaveData
			{
				seasonId = Season.seasonId
			};
			RestoreQuests();
			RollDailyIfDue();
			Changed?.Invoke();
		}

		public void DevUnclaimAll()
		{
			_data.claimedMask = 0L;
			Save();
			Changed?.Invoke();
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			if (_instance != null)
			{
				SeasonQuestEvents.Raised -= _instance.OnQuestEvent;
				SeasonQuestEvents.Reached -= _instance.OnQuestTotal;
			}
			_instance = null;
			_missingSeasonLogged = false;
		}
	}
}
