using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	public static class BackroomsEvents
	{
		public static event Action<BackroomsState> OnStateChanged;

		public static event Action<int, int> OnKeycardsPlacedChanged;

		public static event Action<int, bool> OnPlayerDownedChanged;

		public static event Action<int> OnPlayerDied;

		public static event Action<bool> OnLocalDownedChanged;

		public static event Action OnLocalDied;

		public static event Action<float> OnLocalReviveProgress;

		public static event Action<int, Vector3> OnWatcherScream;

		public static event Action<bool> OnRoundResult;

		public static void RaiseStateChanged(BackroomsState s)
		{
			BackroomsEvents.OnStateChanged?.Invoke(s);
		}

		public static void RaiseKeycardsPlacedChanged(int placed, int total)
		{
			BackroomsEvents.OnKeycardsPlacedChanged?.Invoke(placed, total);
		}

		public static void RaisePlayerDownedChanged(int actor, bool downed)
		{
			BackroomsEvents.OnPlayerDownedChanged?.Invoke(actor, downed);
		}

		public static void RaisePlayerDied(int actor)
		{
			BackroomsEvents.OnPlayerDied?.Invoke(actor);
		}

		public static void RaiseLocalDownedChanged(bool downed)
		{
			BackroomsEvents.OnLocalDownedChanged?.Invoke(downed);
		}

		public static void RaiseLocalDied()
		{
			BackroomsEvents.OnLocalDied?.Invoke();
		}

		public static void RaiseLocalReviveProgress(float t)
		{
			BackroomsEvents.OnLocalReviveProgress?.Invoke(t);
		}

		public static void RaiseWatcherScream(int watcherIndex, Vector3 pos)
		{
			BackroomsEvents.OnWatcherScream?.Invoke(watcherIndex, pos);
		}

		public static void RaiseRoundResult(bool win)
		{
			BackroomsEvents.OnRoundResult?.Invoke(win);
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			BackroomsEvents.OnStateChanged = null;
			BackroomsEvents.OnKeycardsPlacedChanged = null;
			BackroomsEvents.OnPlayerDownedChanged = null;
			BackroomsEvents.OnPlayerDied = null;
			BackroomsEvents.OnLocalDownedChanged = null;
			BackroomsEvents.OnLocalDied = null;
			BackroomsEvents.OnLocalReviveProgress = null;
			BackroomsEvents.OnWatcherScream = null;
			BackroomsEvents.OnRoundResult = null;
		}
	}
}
