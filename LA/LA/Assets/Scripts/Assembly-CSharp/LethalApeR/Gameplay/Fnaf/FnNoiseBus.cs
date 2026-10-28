using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnNoiseBus
	{
		public static event Action<FnNoise, Vector3, float, int> Heard;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			FnNoiseBus.Heard = null;
		}

		public static void Raise(FnNoise kind, Vector3 position, float radius, int sourceActor)
		{
			if (!(radius <= 0f))
			{
				FnNoiseBus.Heard?.Invoke(kind, position, radius, sourceActor);
			}
		}
	}
}
