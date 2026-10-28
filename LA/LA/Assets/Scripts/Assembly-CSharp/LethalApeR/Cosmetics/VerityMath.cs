using System;
using UnityEngine;

namespace LethalApeR.Cosmetics
{
	public static class VerityMath
	{
		public const float MaxStep = 0.05f;

		public static void Spring(ref float value, ref float velocity, float target, float frequency, float damping, float dt)
		{
			if (dt <= 0f)
			{
				return;
			}
			float omega = frequency * (2f * Mathf.PI);
			float k = omega * omega * dt;
			velocity = (velocity - k * (value - target)) / (1f + 2f * damping * omega * dt + k * dt);
			value += velocity * dt;
		}

		public static void Spring(ref Vector3 value, ref Vector3 velocity, Vector3 target, float frequency, float damping, float dt)
		{
			if (dt <= 0f)
			{
				return;
			}
			float omega = frequency * (2f * Mathf.PI);
			float k = omega * omega * dt;
			velocity = (velocity - k * (value - target)) / (1f + 2f * damping * omega * dt + k * dt);
			value += velocity * dt;
		}

		public static float StretchWeight(float speed, float weightPerSpeed, float maxStretch)
		{
			return 0f - Mathf.Min(Mathf.Max(speed, 0f) * weightPerSpeed, maxStretch);
		}

		public static float GroundedExtent(float weight)
		{
			return Mathf.Max(1f + weight * -0.0066f, 0.2f);
		}

		public static VerityMove ChooseMove(float distance, bool hasGround, float hopDistance, float flyDistance, float teleportDistance)
		{
			if (distance > teleportDistance)
			{
				return VerityMove.Teleport;
			}
			if (!hasGround)
			{
				return VerityMove.Fly;
			}
			if (distance > flyDistance)
			{
				return VerityMove.Fly;
			}
			if (distance > hopDistance)
			{
				return VerityMove.Hop;
			}
			return VerityMove.Stay;
		}

		public static Vector3 ClosestOnRing(Vector3 center, Vector3 point, float radius, Vector3 fallbackDir)
		{
			Vector3 dir = point - center;
			dir.y = 0f;
			if (dir.sqrMagnitude < 1E-06f)
			{
				dir = fallbackDir;
				dir.y = 0f;
			}
			if (dir.sqrMagnitude < 1E-06f)
			{
				dir = Vector3.forward;
			}
			return center + dir.normalized * radius;
		}

		public static Vector3 HopArc(Vector3 from, Vector3 to, float height, float t)
		{
			t = Mathf.Clamp01(t);
			return Vector3.LerpUnclamped(from, to, t) + Vector3.up * (4f * height * t * (1f - t));
		}

		public static float HopDuration(float distance, float baseTime)
		{
			return Mathf.Min(Mathf.Max(distance, 0f) * 0.25f + baseTime, baseTime * 3f);
		}

		public static Vector3 ClampHop(Vector3 from, Vector3 to, float maxLength)
		{
			Vector3 flat = to - from;
			flat.y = 0f;
			float length = flat.magnitude;
			if (length <= maxLength || length < 1E-05f)
			{
				return to;
			}
			float k = maxLength / length;
			Vector3 result = from + flat * k;
			result.y = Mathf.Lerp(from.y, to.y, k);
			return result;
		}

		public static bool IsLookingAt(Vector3 eye, Vector3 forward, Vector3 target, float radius, float maxAngle, float maxDistance)
		{
			Vector3 to = target - eye;
			float distance = to.magnitude;
			if (distance < 0.0001f || distance > maxDistance)
			{
				return false;
			}
			if (forward.sqrMagnitude < 1E-06f)
			{
				return false;
			}
			float slack = Mathf.Atan2(radius, distance) * Mathf.Rad2Deg;
			return Vector3.Angle(forward, to) <= slack + maxAngle;
		}

		public static int PickLine(uint seed, int count, int last)
		{
			if (count <= 0)
			{
				return -1;
			}
			if (count == 1)
			{
				return 0;
			}
			int index = (int)(Hash(seed) % (uint)count);
			if (last >= 0 && index == last)
			{
				index = (last + 1 + (int)(Hash(seed ^ 0x9E3779B9u) % (uint)(count - 1))) % count;
			}
			return index;
		}

		public static long TimeSlot(double time, double interval)
		{
			if (interval <= 0.0)
			{
				return 0L;
			}
			return (long)Math.Floor(time / interval);
		}

		public static uint Seed(long slot, int actor)
		{
			return Hash((uint)slot ^ Hash((uint)actor + 0x632BE5ABu));
		}

		public static uint Hash(uint x)
		{
			x ^= x >> 16;
			x *= 0x7FEB352Du;
			x ^= x >> 15;
			x *= 0x846CA68Bu;
			x ^= x >> 16;
			return x;
		}

		public static float Rms(float[] samples)
		{
			if (samples == null || samples.Length == 0)
			{
				return 0f;
			}
			float sum = 0f;
			for (int i = 0; i < samples.Length; i++)
			{
				sum += samples[i] * samples[i];
			}
			return Mathf.Sqrt(sum / (float)samples.Length);
		}
	}
}
