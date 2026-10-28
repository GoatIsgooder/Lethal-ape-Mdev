using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	public static class RivalsRankedQueue
	{
		public const string QueuePrefix = "RVLS_RANKED_";

		public static int LocalLevel()
		{
			if (RivalsProgression.Instance != null)
			{
				return RivalsProgression.Instance.Level;
			}
			return RivalsProgression.LoadSavedLevel();
		}

		public static RivalsRank LocalRank()
		{
			return RivalsRanked.Rank;
		}

		public static string CurrentQueue()
		{
			return "RVLS_RANKED_" + RankDefs.MatchmakingBand(LocalRank());
		}

		public static void JoinRankedHub()
		{
			string text = CurrentQueue();
			Debug.Log("[RivalsRankedQueue] Joining ranked hub queue '" + text + "' " + string.Format("({0}, {1} RP).", RankDefs.DisplayName(LocalRank()), RivalsRanked.Rp));
			MonkeDevNetworkingManager.JoinRandomRoom(text);
		}
	}
}
