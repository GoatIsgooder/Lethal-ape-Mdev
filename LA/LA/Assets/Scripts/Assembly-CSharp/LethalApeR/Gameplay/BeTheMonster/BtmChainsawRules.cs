using System;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmChainsawRules
	{
		[Serializable]
		public class Tuning
		{
			public float idleVolume = 0.55f;

			public float idleVolumeAtFullRev = 0.2f;

			public float idlePitchRise = 0.12f;

			public float revVolume = 0.95f;

			public float revPitchLow = 0.8f;

			public float revPitchHigh = 1.2f;

			public float idleSmokeRate = 4f;

			public float revSmokeRate = 26f;

			public float revSparkRate = 70f;

			public float chainTeethPerSecond = 22f;

			public float idleChainSpeed = 0.3f;

			public float idleChainGlow = 0.4f;

			public float idleShakeDegrees = 0.25f;

			public float revShakeDegrees = 1.1f;

			public float revHaptic = 0.55f;
		}

		public struct EngineMix
		{
			public float IdleVolume;

			public float IdlePitch;

			public float RevVolume;

			public float RevPitch;

			public float SmokeRate;

			public float SparkRate;

			public float ChainGlow;

			public float ChainSpeed;

			public float ShakeDegrees;

			public float Haptic;
		}

		public const float TriggerDeadzone = 0.08f;

		public const float SparkThreshold = 0.45f;

		public const float ClutchStart = 0.12f;

		public const float ClutchFull = 0.55f;

		public static float Throttle(float trigger)
		{
			return Mathf.Clamp01((trigger - TriggerDeadzone) / (1f - TriggerDeadzone));
		}

		public static float Spin(float rev, float throttle, float deltaTime, float spinUpPerSecond, float spinDownPerSecond)
		{
			float num = ((throttle > rev) ? spinUpPerSecond : spinDownPerSecond);
			return Mathf.Clamp01(Mathf.MoveTowards(rev, throttle, num * deltaTime));
		}

		public static EngineMix Mix(float rev, Tuning tuning)
		{
			rev = Mathf.Clamp01(rev);
			float t = Mathf.Clamp01((rev - ClutchStart) / (ClutchFull - ClutchStart));
			float num = ((rev > SparkThreshold) ? ((rev - SparkThreshold) / (1f - SparkThreshold)) : 0f);
			return new EngineMix
			{
				IdleVolume = Mathf.Lerp(tuning.idleVolume, tuning.idleVolumeAtFullRev, rev),
				IdlePitch = 1f + rev * tuning.idlePitchRise,
				RevVolume = tuning.revVolume * Mathf.SmoothStep(0f, 1f, rev),
				RevPitch = Mathf.Lerp(tuning.revPitchLow, tuning.revPitchHigh, rev),
				SmokeRate = Mathf.Lerp(tuning.idleSmokeRate, tuning.revSmokeRate, rev),
				SparkRate = num * tuning.revSparkRate,
				ChainGlow = Mathf.Max(tuning.idleChainGlow, Mathf.SmoothStep(0f, 1f, t)),
				ChainSpeed = tuning.chainTeethPerSecond * Mathf.Lerp(tuning.idleChainSpeed, 1f, rev),
				ShakeDegrees = Mathf.Lerp(tuning.idleShakeDegrees, tuning.revShakeDegrees, rev),
				Haptic = rev * tuning.revHaptic
			};
		}
	}
}
