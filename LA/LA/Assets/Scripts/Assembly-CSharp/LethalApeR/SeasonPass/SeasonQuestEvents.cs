using System;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonQuestEvents
	{
		public static event Action<SeasonQuestEvent, int> Raised;

		public static event Action<SeasonQuestEvent, int> Reached;

		public static void Raise(SeasonQuestEvent e, int amount = 1)
		{
			if (e != SeasonQuestEvent.None && amount >= 1)
			{
				Raised?.Invoke(e, amount);
			}
		}

		public static void Reach(SeasonQuestEvent e, int total)
		{
			if (e != SeasonQuestEvent.None && total >= 1)
			{
				Reached?.Invoke(e, total);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Raised = null;
			Reached = null;
		}
	}
}
