using UnityEngine;

namespace LethalApeR.Networking
{
	public static class PlayerLodRank
	{
		public const int RankHysteresis = 2;

		public const int UnlimitedBudget = 999;

		public static float RuntimeBudgetScale = 1f;

		public static int Scale(int budget)
		{
			if (RuntimeBudgetScale < 0f)
			{
				return budget;
			}
			if (RuntimeBudgetScale == 0f)
			{
				return 999;
			}
			return Mathf.Max(1, Mathf.RoundToInt(budget * RuntimeBudgetScale));
		}

		public static Transform LocalHead()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager != null && manager.Head != null)
			{
				return manager.Head;
			}
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform;
			}
			return null;
		}

		public static bool Resolve(bool currentlyOff, float sqrDistance, float offDistance, float onDistance, int rank, int budget)
		{
			if (currentlyOff)
			{
				if (budget < 999 && rank >= budget - 2)
				{
					return true;
				}
				return sqrDistance >= onDistance * onDistance;
			}
			if (budget < 999 && rank >= budget)
			{
				return true;
			}
			return sqrDistance > offDistance * offDistance;
		}
	}
}
