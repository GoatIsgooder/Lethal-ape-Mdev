using System;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	[CreateAssetMenu(menuName = "Slop/Season Pass/Season", fileName = "Season")]
	public class SeasonPassSeason : ScriptableObject
	{
		public const string ResourcePath = "SeasonPass/ActiveSeason";

		[Tooltip("Save-key namespace. Never change it once players have progress.")]
		public string seasonId = "S1";

		public string displayName = "SEASON 1";

		[Tooltip("UTC, ISO 8601 (2026-10-15T00:00:00Z).")]
		public string startUtc = "2026-10-01T00:00:00Z";

		[Tooltip("UTC, ISO 8601. XP stops here; reached rewards stay claimable.")]
		public string endUtc = "2026-12-01T00:00:00Z";

		[Tooltip("Off = release builds show the season as STARTING SOON with XP and claims shut. Players with Player Data (Read Only) SeasonPassPreview = true see it live and can buy GD levels, but get no claims or premium sale. Editor and development builds ignore this.")]
		public bool releaseReady;

		[Tooltip("XP from level 1 to level 2.")]
		[Min(1f)]
		public int xpPerLevel = 1000;

		[Tooltip("Each level-up costs this much more than the one before (1.05 = +5%). Above 1, costs round to 50 XP.")]
		[Range(1f, 1.5f)]
		public float xpGrowth = 1f;

		[Tooltip("Durable Meta IAP SKU that unlocks the premium track. Case-sensitive.")]
		public string premiumSku = "SEASON1_PASS";

		[Tooltip("Qauth catalog item priced in GD; one purchase = one level. Its GD price is read from the catalog. Exact case.")]
		public string levelItemId = "SEASONPASS_S1_LEVEL";

		public List<SeasonPassLevel> levels = new List<SeasonPassLevel>();

		[Header("Quests")]
		[Tooltip("Each UTC day draws dailyCount of these, the same draw on every client.")]
		public List<SeasonQuestDefinition> dailyPool = new List<SeasonQuestDefinition>();

		[Min(1f)]
		public int dailyCount = 3;

		[Tooltip("One-time challenges, live all season.")]
		public List<SeasonQuestDefinition> challenges = new List<SeasonQuestDefinition>();

		[NonSerialized]
		private string _parsedStart;

		[NonSerialized]
		private string _parsedEnd;

		[NonSerialized]
		private DateTime _start;

		[NonSerialized]
		private DateTime _end;

		[NonSerialized]
		private int[] _xpTable;

		[NonSerialized]
		private int _tableBase;

		[NonSerialized]
		private float _tableGrowth;

		public int MaxLevel => Mathf.Max(1, levels.Count);

		public int MaxXp => XpToReach(MaxLevel);

		public int LevelCap
		{
			get
			{
				for (int i = 0; i < levels.Count; i++)
				{
					if (levels[i] != null && levels[i].reward != null && levels[i].reward.comingSoon)
					{
						return Mathf.Max(1, i);
					}
				}
				return MaxLevel;
			}
		}

		public IReadOnlyList<int> XpTable
		{
			get
			{
				int maxLevel = MaxLevel;
				if (_xpTable != null && _xpTable.Length == maxLevel && _tableBase == xpPerLevel && _tableGrowth == xpGrowth)
				{
					return _xpTable;
				}
				int[] array = new int[maxLevel];
				for (int i = 1; i < maxLevel; i++)
				{
					array[i] = (int)Math.Min((long)array[i - 1] + (long)LevelUpCost(i), 2147483647L);
				}
				_xpTable = array;
				_tableBase = xpPerLevel;
				_tableGrowth = xpGrowth;
				return _xpTable;
			}
		}

		public DateTime StartUtc
		{
			get
			{
				if ((object)_parsedStart != startUtc)
				{
					_start = Parse(startUtc, DateTime.MinValue);
					_parsedStart = startUtc;
				}
				return _start;
			}
		}

		public DateTime EndUtc
		{
			get
			{
				if ((object)_parsedEnd != endUtc)
				{
					_end = Parse(endUtc, DateTime.MaxValue);
					_parsedEnd = endUtc;
				}
				return _end;
			}
		}

		private int LevelUpCost(int level)
		{
			int num = Mathf.Max(1, xpPerLevel);
			if (level < 2 || xpGrowth <= 1f)
			{
				return num;
			}
			double num2 = Math.Pow((double)(decimal)xpGrowth, level - 1) * (double)num;
			double val = Math.Round(num2 / 50.0, MidpointRounding.AwayFromZero) * 50.0;
			return (int)Math.Max(1.0, Math.Min(val, 2147483647.0));
		}

		public void GetDailyDrawPool(List<SeasonQuestDefinition> into)
		{
			into.Clear();
			foreach (SeasonQuestDefinition item in dailyPool)
			{
				if (item != null && !string.IsNullOrEmpty(item.questId) && !into.Contains(item))
				{
					into.Add(item);
				}
			}
		}

		public SeasonPassLevel GetLevel(int level)
		{
			if (level < 1 || level > levels.Count)
			{
				return null;
			}
			return levels[level - 1];
		}

		public int XpToReach(int level)
		{
			return XpTable[Mathf.Clamp(level, 1, MaxLevel) - 1];
		}

		public int XpForLevelUp(int level)
		{
			if (level < 1 || level >= MaxLevel)
			{
				return 0;
			}
			return XpTable[level] - XpTable[level - 1];
		}

		public int LevelForXp(int xp)
		{
			IReadOnlyList<int> xpTable = XpTable;
			int i;
			for (i = 1; i < xpTable.Count && xpTable[i] <= xp; i++)
			{
			}
			return i;
		}

		public static DateTime Parse(string iso, DateTime fallback)
		{
			if (!string.IsNullOrEmpty(iso) && DateTime.TryParse(iso, CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal | DateTimeStyles.AssumeUniversal, out var result))
			{
				return DateTime.SpecifyKind(result, DateTimeKind.Utc);
			}
			return fallback;
		}

		public void Validate(List<string> problems)
		{
			if (string.IsNullOrEmpty(seasonId))
			{
				problems.Add("seasonId is empty.");
			}
			if (string.IsNullOrEmpty(premiumSku))
			{
				problems.Add("premiumSku is empty: PURCHASE can't open the store.");
			}
			if (string.IsNullOrEmpty(levelItemId))
			{
				problems.Add("levelItemId is empty: levels can't be bought with GD.");
			}
			if (Parse(startUtc, DateTime.MinValue) == DateTime.MinValue)
			{
				problems.Add("startUtc '" + startUtc + "' is not a valid UTC date.");
			}
			if (Parse(endUtc, DateTime.MaxValue) == DateTime.MaxValue)
			{
				problems.Add("endUtc '" + endUtc + "' is not a valid UTC date.");
			}
			else if (EndUtc <= StartUtc)
			{
				problems.Add("endUtc is not after startUtc.");
			}
			if (levels.Count == 0)
			{
				problems.Add("No levels.");
			}
			if (levels.Count > 64)
			{
				problems.Add("More than 64 levels: the claimed-level mask only holds 64.");
			}
			if (xpGrowth < 1f)
			{
				problems.Add("xpGrowth is below 1: later levels would get cheaper.");
			}
			int levelCap = LevelCap;
			for (int i = 0; i < levels.Count; i++)
			{
				SeasonPassLevel seasonPassLevel = levels[i];
				string text = string.Format("Level {0}", i + 1);
				SeasonPassReward seasonPassReward = seasonPassLevel?.reward;
				if (seasonPassReward == null)
				{
					problems.Add(text + ": empty.");
					continue;
				}
				if (seasonPassReward.comingSoon)
				{
					if (i == levelCap)
					{
						problems.Add(string.Format("{0}: COMING SOON. Levels {1}+ stay locked (shown as ???) until an update fills it.", text, i + 1));
					}
					else
					{
						problems.Add(text + ": COMING SOON.");
					}
					continue;
				}
				if (seasonPassReward.kind == SeasonRewardKind.Cosmetic && string.IsNullOrEmpty(seasonPassReward.itemId))
				{
					problems.Add(text + ": cosmetic with no itemId.");
				}
				if (seasonPassReward.kind == SeasonRewardKind.Gold && seasonPassReward.amount <= 0)
				{
					problems.Add(text + ": gold reward with amount 0.");
				}
				if (seasonPassReward.kind == SeasonRewardKind.Xp && seasonPassReward.amount <= 0)
				{
					problems.Add(text + ": XP reward with amount 0.");
				}
				if (seasonPassReward.kind == SeasonRewardKind.Cosmetic && seasonPassReward.icon == null)
				{
					problems.Add(text + ": no icon.");
				}
				if (seasonPassReward.featured && seasonPassLevel.track == SeasonTrack.Free)
				{
					problems.Add(text + ": featured skin sits on the free track.");
				}
			}
			HashSet<string> ids = new HashSet<string>(StringComparer.Ordinal);
			CheckQuests(dailyPool, "Daily", ids, problems);
			CheckQuests(challenges, "Challenge", ids, problems);
			if (dailyPool.Count > 0 && dailyPool.Count < dailyCount)
			{
				problems.Add(string.Format("dailyPool has {0} quests but dailyCount is {1}.", dailyPool.Count, dailyCount));
			}
		}

		private static void CheckQuests(List<SeasonQuestDefinition> list, string label, HashSet<string> ids, List<string> problems)
		{
			for (int i = 0; i < list.Count; i++)
			{
				SeasonQuestDefinition seasonQuestDefinition = list[i];
				if (seasonQuestDefinition == null)
				{
					problems.Add(string.Format("{0} {1}: missing asset.", label, i + 1));
					continue;
				}
				if (string.IsNullOrEmpty(seasonQuestDefinition.questId))
				{
					problems.Add(label + " '" + seasonQuestDefinition.name + "': empty questId.");
				}
				else if (!ids.Add(seasonQuestDefinition.questId))
				{
					problems.Add(label + " '" + seasonQuestDefinition.name + "': questId '" + seasonQuestDefinition.questId + "' is used twice.");
				}
				if (seasonQuestDefinition.trigger == SeasonQuestEvent.None)
				{
					problems.Add(label + " '" + seasonQuestDefinition.name + "': no trigger, it can never progress.");
				}
			}
		}
	}
}
