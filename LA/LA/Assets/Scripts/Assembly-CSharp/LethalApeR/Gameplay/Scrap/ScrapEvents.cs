using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public static class ScrapEvents
	{
		public static event Action<int> OnBalanceChanged;

		public static event Action<int, Vector3, int> OnScrapSold;

		public static void RaiseBalanceChanged(int balance)
		{
			ScrapEvents.OnBalanceChanged?.Invoke(balance);
		}

		public static void RaiseScrapSold(int payout, Vector3 worldPos, int sellerActor)
		{
			ScrapEvents.OnScrapSold?.Invoke(payout, worldPos, sellerActor);
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			ScrapEvents.OnBalanceChanged = null;
			ScrapEvents.OnScrapSold = null;
		}
	}
}
