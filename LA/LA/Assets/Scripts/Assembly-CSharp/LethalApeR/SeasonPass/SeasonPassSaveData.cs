using System;
using System.Collections.Generic;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonPassSaveData
	{
		public int version = 1;

		public string seasonId;

		public int xp;

		public int serverXp;

		public int boughtLevels;

		public long claimedMask;

		public bool premium;

		public int dailyDay = -1;

		public int loginDay = -1;

		public List<SeasonQuestProgress> daily = new List<SeasonQuestProgress>();

		public List<SeasonQuestProgress> challenges = new List<SeasonQuestProgress>();
	}
}
