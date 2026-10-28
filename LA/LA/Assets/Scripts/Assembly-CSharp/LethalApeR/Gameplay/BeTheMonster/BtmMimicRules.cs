using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmMimicRules
	{
		public const int RevealTarget = -1;

		public const int NoKill = 0;

		public static int ResolveTarget(int ownActor, int lastKillActor)
		{
			if (lastKillActor == ownActor || lastKillActor < 1)
			{
				return ownActor;
			}
			return lastKillActor;
		}

		public static bool IsValidTarget(int target, int ownActor, int lastKillActor)
		{
			if (target < 1)
			{
				return false;
			}
			if (target != ownActor)
			{
				return target == lastKillActor;
			}
			return true;
		}

		public static bool AcceptsShift(MimicPhase phase)
		{
			return phase == MimicPhase.Monster;
		}

		public static bool AcceptsReveal(MimicPhase phase)
		{
			if (phase != MimicPhase.MorphingIn)
			{
				return phase == MimicPhase.Disguised;
			}
			return true;
		}

		public static bool CooldownReady(double sentAt, double readyAt, double tolerance)
		{
			return sentAt + tolerance >= readyAt;
		}

		public static float Progress(double now, double start, float duration)
		{
			if (!(duration > 0f))
			{
				return 1f;
			}
			return Mathf.Clamp01((float)((now - start) / (double)duration));
		}

		public static MimicPose MorphInPose(float t)
		{
			return new MimicPose(Ramp(0.1f, 0.92f, t), Ramp(0.05f, 0.85f, t), Mathf.Pow(Ramp(0.75f, 1f, t), 3f), t >= 0.45f);
		}

		public static MimicPose RevealPose(float t)
		{
			return new MimicPose(1f - Ramp(0f, 0.8f, t), 1f - Ramp(0.05f, 0.75f, t), 1f - Ramp(0f, 0.35f, t), t < 0.9f);
		}

		public static float Ramp(float from, float to, float t)
		{
			if (to <= from)
			{
				if (!(t >= to))
				{
					return 0f;
				}
				return 1f;
			}
			float num = Mathf.Clamp01((t - from) / (to - from));
			return num * num * (3f - 2f * num);
		}

		public static bool ShiftPressed(bool secondaryNow, bool secondaryBefore, bool primaryHeld)
		{
			if (secondaryNow && !secondaryBefore)
			{
				return !primaryHeld;
			}
			return false;
		}
	}
}
