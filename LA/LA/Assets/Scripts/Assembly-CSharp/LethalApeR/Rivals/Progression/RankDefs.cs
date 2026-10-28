using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	public static class RankDefs
	{
		public const int RankCount = 10;

		public const int MaxLevel = 999;

		private static readonly int[] MinLevel = new int[10] { 1, 20, 50, 100, 150, 200, 250, 300, 350, 400 };

		public const int BaseXpPerLevel = 60;

		public const int XpGrowthPerLevel = 4;

		public static readonly int[] RpMin = new int[10] { 0, 100, 250, 450, 700, 1000, 1400, 1900, 2550, 3300 };

		public static int XpForLevelUp(int level)
		{
			return BaseXpPerLevel + XpGrowthPerLevel * (Mathf.Max(1, level) - 1);
		}

		public static int LevelFromTotalXp(int totalXp)
		{
			int xp = Mathf.Max(0, totalXp);
			int level = 1;
			while (level < MaxLevel)
			{
				int need = XpForLevelUp(level);
				if (xp < need)
				{
					break;
				}
				xp -= need;
				level++;
			}
			return level;
		}

		public static int XpIntoLevel(int totalXp)
		{
			int xp = Mathf.Max(0, totalXp);
			for (int level = 1; level < MaxLevel; level++)
			{
				int need = XpForLevelUp(level);
				if (xp < need)
				{
					break;
				}
				xp -= need;
			}
			return xp;
		}

		public static RivalsRank RankForLevel(int level)
		{
			for (int i = MinLevel.Length - 1; i >= 0; i--)
			{
				if (level >= MinLevel[i])
				{
					return (RivalsRank)i;
				}
			}
			return RivalsRank.Rookie;
		}

		public static void LevelSpan(RivalsRank rank, out int min, out int max)
		{
			int i = (int)rank;
			min = MinLevel[i];
			max = ((i + 1 < MinLevel.Length) ? (MinLevel[i + 1] - 1) : MaxLevel);
		}

		public static RivalsRank RankForRp(int rp)
		{
			for (int i = RpMin.Length - 1; i >= 0; i--)
			{
				if (rp >= RpMin[i])
				{
					return (RivalsRank)i;
				}
			}
			return RivalsRank.Rookie;
		}

		public static int RpIntoRank(int rp)
		{
			rp = Mathf.Max(0, rp);
			return rp - RpMin[(int)RankForRp(rp)];
		}

		public static int RpForNextRank(int rp)
		{
			int i = (int)RankForRp(rp);
			if (i + 1 >= RpMin.Length)
			{
				return 0;
			}
			return RpMin[i + 1] - RpMin[i];
		}

		public static int WinRp(RivalsRank r)
		{
			return Mathf.Max(15, 24 - (int)r);
		}

		public static int LossRp(RivalsRank r)
		{
			return Mathf.Min(21, 12 + (int)r);
		}

		public static string DisplayName(RivalsRank rank)
		{
			return rank.ToString().ToUpperInvariant();
		}

		public static int MatchmakingBand(RivalsRank rank)
		{
			return (int)rank / 2;
		}

		public static Color RankColor(RivalsRank rank)
		{
			return rank switch
			{
				RivalsRank.Rookie => new Color(0.62f, 0.65f, 0.68f), 
				RivalsRank.Bronze => new Color(0.8f, 0.5f, 0.2f), 
				RivalsRank.Silver => new Color(0.78f, 0.81f, 0.85f), 
				RivalsRank.Gold => new Color(1f, 0.84f, 0f), 
				RivalsRank.Platinum => new Color(0.25f, 0.88f, 0.82f), 
				RivalsRank.Diamond => new Color(0.45f, 0.75f, 1f), 
				RivalsRank.Master => new Color(0.72f, 0.35f, 1f), 
				RivalsRank.Elite => new Color(1f, 0.3f, 0.3f), 
				RivalsRank.Legend => new Color(1f, 0.55f, 0.1f), 
				RivalsRank.Champion => new Color(1f, 0.1f, 0.45f), 
				_ => Color.white, 
			};
		}

		public static string RankColorHex(RivalsRank rank)
		{
			return ColorUtility.ToHtmlStringRGB(RankColor(rank));
		}
	}
}
