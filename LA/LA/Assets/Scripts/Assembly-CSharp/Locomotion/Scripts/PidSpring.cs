using UnityEngine;

namespace Locomotion.Scripts
{
	internal static class PidSpring
	{
		public static void ComputeGains(float frequency, float damping, float dt, out float ks, out float kd)
		{
			float kp = 6f * frequency * (6f * frequency) * 0.25f;
			float kdRaw = 4.5f * frequency * damping;
			float g = 1f / (1f + kdRaw * dt + kp * dt * dt);
			ks = kp * g;
			kd = (kdRaw + kp * dt) * g;
		}

		public static Vector3 PositionAcceleration(Vector3 current, Vector3 target, Vector3 velocity, float frequency, float damping, float dt)
		{
			ComputeGains(frequency, damping, dt, out var ks, out var kd);
			return (target - current) * ks - velocity * kd;
		}

		public static Vector3 RotationAcceleration(Quaternion current, Quaternion target, Vector3 angularVelocity, float frequency, float damping, float dt)
		{
			Quaternion delta = target * Quaternion.Inverse(current);
			if (delta.w < 0f)
			{
				delta = new Quaternion(-delta.x, -delta.y, -delta.z, -delta.w);
			}
			delta.ToAngleAxis(out var angle, out var axis);
			if (!IsAxisValid(axis))
			{
				return Vector3.zero;
			}
			ComputeGains(frequency, damping, dt, out var ks, out var kd);
			axis.Normalize();
			return axis * (ks * (angle * Mathf.Deg2Rad)) - angularVelocity * kd;
		}

		private static bool IsAxisValid(Vector3 axis)
		{
			return float.IsFinite(axis.x);
		}
	}
}
