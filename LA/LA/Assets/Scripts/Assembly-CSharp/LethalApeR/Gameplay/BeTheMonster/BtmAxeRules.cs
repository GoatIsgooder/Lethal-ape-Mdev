using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmAxeRules
	{
		public const float MinHandSpeed = 2.4f;

		public const float ThrowGain = 1.9f;

		public const float MinThrowSpeed = 11f;

		public const float MaxThrowSpeed = 24f;

		public const float LiftDegrees = 4f;

		public const float Gravity = 7.5f;

		public const float MaxFlightSeconds = 3.5f;

		public const float AssistConeDegrees = 7f;

		public const float AssistRange = 26f;

		public const float BaseSpinDegrees = 560f;

		public const float SpinDegreesPerMetre = 22f;

		public const float ReturnSpeed = 21f;

		public const float MinReturnSeconds = 0.32f;

		public const float MaxReturnSeconds = 1.25f;

		public const float ReturnArcShare = 0.18f;

		public const float MaxReturnArc = 2.2f;

		public const float CatchRadius = 0.3f;

		public const string BodyTag = "BTMKillTrigger";

		public const float BladeRadius = 0.28f;

		public const float HeadRadius = 0.07f;

		public const float BiteDepth = 0.035f;

		public const float ChopMinSpeed = 1.5f;

		public const float ChopSpeedWindow = 0.06f;

		public const float ChopMaxStep = 1f;

		public static Vector3 ThrowVelocity(Vector3 handVelocity, float scale)
		{
			float magnitude = handVelocity.magnitude;
			if (magnitude < MinHandSpeed * Mathf.Max(0.5f, scale))
			{
				return Vector3.zero;
			}
			Vector3 vector = handVelocity / magnitude;
			Vector3 vector2 = Vector3.Cross(Vector3.up, vector);
			if (vector2.sqrMagnitude > 0.0001f)
			{
				vector = Quaternion.AngleAxis(0f - LiftDegrees, vector2.normalized) * vector;
			}
			return vector * Mathf.Clamp(magnitude * ThrowGain, MinThrowSpeed, MaxThrowSpeed);
		}

		public static Vector3 Assist(Vector3 origin, Vector3 velocity, IReadOnlyList<Vector3> targets, IReadOnlyList<Vector3> targetVelocities)
		{
			if (targets == null)
			{
				return velocity;
			}
			float magnitude = velocity.magnitude;
			if (magnitude < 0.001f)
			{
				return velocity;
			}
			Vector3 vector = velocity / magnitude;
			Vector3 vector2 = vector;
			float num = AssistConeDegrees;
			for (int i = 0; i < targets.Count; i++)
			{
				float num2 = Vector3.Distance(targets[i], origin);
				if (!(num2 < 1f) && !(num2 > AssistRange))
				{
					float num3 = num2 / magnitude;
					Vector3 vector3 = targets[i] + ((targetVelocities != null && i < targetVelocities.Count) ? (targetVelocities[i] * num3) : Vector3.zero);
					vector3.y += 0.5f * Gravity * num3 * num3;
					Vector3 normalized = (vector3 - origin).normalized;
					float num4 = Vector3.Angle(vector, normalized);
					if (num4 < num)
					{
						num = num4;
						vector2 = normalized;
					}
				}
			}
			return vector2 * magnitude;
		}

		public static Vector3 SpinAxis(Vector3 velocity)
		{
			Vector3 vector = Vector3.Cross(velocity, Vector3.up);
			if (vector.sqrMagnitude < 1E-06f)
			{
				vector = Vector3.right;
			}
			return vector.normalized;
		}

		public static float SpinRate(float speed)
		{
			return speed * SpinDegreesPerMetre + BaseSpinDegrees;
		}

		public static Vector3 ThrowPosition(Vector3 origin, Vector3 velocity, float t)
		{
			return origin + velocity * t + Vector3.down * (0.5f * Gravity * t * t);
		}

		public static Vector3 ThrowHeading(Vector3 velocity, float t)
		{
			return velocity + Vector3.down * (Gravity * t);
		}

		public static Quaternion Spin(Quaternion start, Vector3 axis, float degreesPerSecond, float t)
		{
			return Quaternion.AngleAxis(degreesPerSecond * t, axis) * start;
		}

		public static float ReturnSeconds(float distance)
		{
			return Mathf.Clamp(distance / ReturnSpeed, MinReturnSeconds, MaxReturnSeconds);
		}

		public static Vector3 ReturnPosition(Vector3 from, Vector3 hand, float u)
		{
			float num = Mathf.Clamp01(u);
			float t = num * num * (2.2f - 1.2f * num);
			Vector3 vector = Vector3.Lerp(from, hand, 0.35f) + Vector3.up * Mathf.Min(Vector3.Distance(from, hand) * ReturnArcShare, MaxReturnArc);
			Vector3 a = Vector3.Lerp(from, vector, t);
			Vector3 b = Vector3.Lerp(vector, hand, t);
			return Vector3.Lerp(a, b, t);
		}

		public static Vector3 CutNormal(Vector3 spinAxis, Vector3 heading)
		{
			if (spinAxis.sqrMagnitude > 1E-06f)
			{
				return spinAxis.normalized;
			}
			Vector3 vector = Vector3.Cross(heading, Vector3.up);
			if (vector.sqrMagnitude > 1E-06f)
			{
				return vector.normalized;
			}
			return Vector3.right;
		}

		public static Vector3 ChopNormal(Vector3 handle, Vector3 motion, Vector3 bladeFlat)
		{
			Vector3 vector = Vector3.Cross(handle.normalized, motion.normalized);
			if (vector.sqrMagnitude > 0.01f)
			{
				return vector.normalized;
			}
			if (bladeFlat.sqrMagnitude > 1E-06f)
			{
				return bladeFlat.normalized;
			}
			return Vector3.right;
		}
	}
}
