using RootMotion.FinalIK;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmGrabReach
	{
		public const float GripOn = 0.6f;

		public const float GripOff = 0.35f;

		public const float ContactGrace = 0.15f;

		public const float MaxSweep = 1f;

		private const int MaxWristDepth = 4;

		public static bool Gripping(bool wasGripping, float grip)
		{
			return grip > (wasGripping ? GripOff : GripOn);
		}

		public static Vector3 FistAtTarget(Vector3 fist, Vector3 wrist, Quaternion wristRotation, Vector3 target, Quaternion targetRotation)
		{
			return target + targetRotation * (Quaternion.Inverse(wristRotation) * (fist - wrist));
		}

		public static bool FindReachTarget(Transform root, Transform trigger, out Transform wrist, out Transform target)
		{
			wrist = null;
			target = null;
			if (!root || !trigger)
			{
				return false;
			}
			VRIK[] componentsInChildren = root.GetComponentsInChildren<VRIK>(true);
			ArmIK[] componentsInChildren2 = root.GetComponentsInChildren<ArmIK>(true);
			Transform parent = trigger.parent;
			int num = 0;
			while ((bool)parent && num < MaxWristDepth)
			{
				foreach (VRIK vRIK in componentsInChildren)
				{
					if (vRIK.references.leftHand == parent)
					{
						wrist = parent;
						target = vRIK.solver.leftArm.target;
						break;
					}
					if (vRIK.references.rightHand == parent)
					{
						wrist = parent;
						target = vRIK.solver.rightArm.target;
						break;
					}
				}
				if (!wrist)
				{
					foreach (ArmIK armIK in componentsInChildren2)
					{
						if (armIK.solver.hand.transform == parent)
						{
							wrist = parent;
							target = armIK.solver.arm.target;
							break;
						}
					}
				}
				if ((bool)wrist)
				{
					return target;
				}
				parent = parent.parent;
				num++;
			}
			return false;
		}

		public static bool Touches(Vector3 from, Vector3 to, float radius, Vector3 bodyA, Vector3 bodyB, float bodyRadius)
		{
			float num = radius + bodyRadius;
			return SegmentDistanceSqr(from, to, bodyA, bodyB) <= num * num;
		}

		public static void Segment(CapsuleCollider capsule, out Vector3 a, out Vector3 b, out float radius)
		{
			Transform transform = capsule.transform;
			Vector3 lossyScale = transform.lossyScale;
			float num = Mathf.Abs(lossyScale.x);
			float num2 = Mathf.Abs(lossyScale.y);
			float num3 = Mathf.Abs(lossyScale.z);
			Vector3 direction;
			float num4;
			float num5;
			switch (capsule.direction)
			{
			case 0:
				direction = Vector3.right;
				num4 = Mathf.Max(num2, num3);
				num5 = num;
				break;
			case 2:
				direction = Vector3.forward;
				num4 = Mathf.Max(num, num2);
				num5 = num3;
				break;
			default:
				direction = Vector3.up;
				num4 = Mathf.Max(num, num3);
				num5 = num2;
				break;
			}
			radius = capsule.radius * num4;
			float num6 = Mathf.Max(0f, num5 * (capsule.height * 0.5f) - radius);
			Vector3 vector = transform.TransformPoint(capsule.center);
			Vector3 vector2 = transform.TransformDirection(direction) * num6;
			a = vector + vector2;
			b = vector - vector2;
		}

		public static float SegmentDistanceSqr(Vector3 p1, Vector3 q1, Vector3 p2, Vector3 q2)
		{
			Vector3 vector = q1 - p1;
			Vector3 vector2 = q2 - p2;
			Vector3 vector3 = p1 - p2;
			float num = Vector3.Dot(vector, vector);
			float num2 = Vector3.Dot(vector2, vector2);
			float num3 = Vector3.Dot(vector2, vector3);
			if (num <= 1E-08f && num2 <= 1E-08f)
			{
				return vector3.sqrMagnitude;
			}
			float num4;
			float num5;
			if (num <= 1E-08f)
			{
				num4 = 0f;
				num5 = Mathf.Clamp01(num3 / num2);
			}
			else
			{
				float num6 = Vector3.Dot(vector, vector3);
				if (num2 <= 1E-08f)
				{
					num5 = 0f;
					num4 = Mathf.Clamp01((0f - num6) / num);
				}
				else
				{
					float num7 = Vector3.Dot(vector, vector2);
					float num8 = num * num2 - num7 * num7;
					num4 = ((num8 > 1E-08f) ? Mathf.Clamp01((num7 * num3 - num6 * num2) / num8) : 0f);
					num5 = (num7 * num4 + num3) / num2;
					if (num5 < 0f)
					{
						num5 = 0f;
						num4 = Mathf.Clamp01((0f - num6) / num);
					}
					else if (num5 > 1f)
					{
						num5 = 1f;
						num4 = Mathf.Clamp01((num7 - num6) / num);
					}
				}
			}
			return (p1 + vector * num4 - (p2 + vector2 * num5)).sqrMagnitude;
		}
	}
}
