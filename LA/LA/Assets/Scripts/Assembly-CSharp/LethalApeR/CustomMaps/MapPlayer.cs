using GorillaLocomotion;
using LethalApeR.SpiderApe;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	public static class MapPlayer
	{
		public static bool Ready => Player.HasInstance && Player.Instance != null && Player.Instance.headCollider != null;

		public static Transform Head => Ready ? Player.Instance.headCollider.transform : null;

		public static Transform LeftHand => Ready ? Player.Instance.leftHandTransform : null;

		public static Transform RightHand => Ready ? Player.Instance.rightHandTransform : null;

		public static Rigidbody Body => Ready ? Player.Instance.playerRigidBody : null;

		public static void TeleportFeet(Vector3 feet, float yaw, bool keepMomentum = false)
		{
			if (!Ready)
			{
				return;
			}
			if (SpiderApeSwing.Instance != null)
			{
				SpiderApeSwing.Instance.DetachAll();
			}
			Player player = Player.Instance;
			Transform root = player.transform;
			Rigidbody body = player.playerRigidBody;
			Vector3 velocity = (body != null) ? body.linearVelocity : Vector3.zero;
			float headYaw = HeadYaw();
			Vector3 headLocal = root.InverseTransformPoint(player.headCollider.transform.position);
			Vector3 headForward = Flatten(root.InverseTransformDirection(player.headCollider.transform.forward));
			float headLocalYaw = Quaternion.LookRotation(headForward, Vector3.up).eulerAngles.y;
			Quaternion rotation = Quaternion.Euler(0f, yaw - headLocalYaw, 0f);
			Vector3 offset = rotation * new Vector3(headLocal.x, 0f, headLocal.z);
			player.TeleportPlayerRaw(new Vector3(feet.x - offset.x, feet.y, feet.z - offset.z), rotation, true, true);
			if (keepMomentum && body != null && !body.isKinematic)
			{
				body.linearVelocity = Quaternion.Euler(0f, yaw - headYaw, 0f) * velocity;
			}
		}

		public static float HeadYaw()
		{
			if (!Ready)
			{
				return 0f;
			}
			return Player.Instance.headCollider.transform.eulerAngles.y;
		}

		private static Vector3 Flatten(Vector3 v)
		{
			v.y = 0f;
			if (v.sqrMagnitude < 1E-06f)
			{
				return Vector3.forward;
			}
			return v.normalized;
		}
	}
}
