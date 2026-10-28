using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR
{
	public static class GlobalLeaderboardSystem
	{
		public static void AddPlayerStatistic(string statisticName)
		{
			if (statisticName == BTMLeaderboard.StatisticName)
			{
				BTMLeaderboard.AddWin();
			}
			else
			{
				Debug.LogWarning("[GlobalLeaderboardSystem] Unknown statistic '" + statisticName + "' — nothing recorded.");
			}
		}

		public static void GetPlayfabStatistics(string statisticName, int maxResults = 10)
		{
			if (statisticName == BTMLeaderboard.StatisticName)
			{
				BTMLeaderboard.PushStatistic();
				BTMLeaderboard.RequestRefresh();
			}
			else
			{
				Debug.LogWarning("[GlobalLeaderboardSystem] Unknown statistic '" + statisticName + "' — no board to refresh.");
			}
		}
	}
}
