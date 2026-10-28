using System;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DefaultExecutionOrder(10320)]
	public sealed class BtmHandCurl : MonoBehaviour
	{
		[Serializable]
		public class Joint
		{
			public Transform bone;

			public Quaternion open = Quaternion.identity;

			public Quaternion closed = Quaternion.identity;
		}

		[Serializable]
		public class Hand
		{
			public Joint[] button = Array.Empty<Joint>();

			public Joint[] trigger = Array.Empty<Joint>();

			public Joint[] grip = Array.Empty<Joint>();
		}

		[SerializeField]
		private MonkeDevNetworkingPlayer player;

		[Tooltip("Optional: a component on the skin implementing IHandCurlSource (the Lumberjack's axe).")]
		[SerializeField]
		private MonoBehaviour source;

		[SerializeField]
		private Hand left = new Hand();

		[SerializeField]
		private Hand right = new Hand();

		[Tooltip("How quickly fingers follow (per second); the ape hands use about the same.")]
		[SerializeField]
		private float sharpness = 15f;

		private IHandCurlSource _source;

		private Vector3 _left;

		private Vector3 _right;

		private void Awake()
		{
			_source = source as IHandCurlSource;
		}

		private void OnDisable()
		{
			_left = (_right = Vector3.zero);
			Pose(left, Vector3.zero);
			Pose(right, Vector3.zero);
		}

		private void LateUpdate()
		{
			float t = 1f - Mathf.Exp((0f - sharpness) * Time.deltaTime);
			_left = Vector3.Lerp(_left, Target(true), t);
			_right = Vector3.Lerp(_right, Target(false), t);
			Pose(left, _left);
			Pose(right, _right);
		}

		private Vector3 Target(bool isLeft)
		{
			if (_source != null && _source.TryGetCurl(isLeft, out var curl))
			{
				return curl;
			}
			if ((bool)player && player.photonView != null && !player.photonView.IsMine)
			{
				if (isLeft)
				{
					return new Vector3(player.NetLeftButton, player.NetLeftTrigger, player.NetLeftGrip);
				}
				return new Vector3(player.NetRightButton, player.NetRightTrigger, player.NetRightGrip);
			}
			VRInputController instance = VRInputController.Instance;
			if (!instance)
			{
				return Vector3.zero;
			}
			if (isLeft)
			{
				return new Vector3((instance.LeftPrimaryButton || instance.LeftSecondaryButton) ? 1f : 0f, instance.LeftTriggerValue, instance.LeftGripValue);
			}
			return new Vector3((instance.RightPrimaryButton || instance.RightSecondaryButton) ? 1f : 0f, instance.RightTriggerValue, instance.RightGripValue);
		}

		private static void Pose(Hand hand, Vector3 curl)
		{
			if (hand != null)
			{
				Pose(hand.button, curl.x);
				Pose(hand.trigger, curl.y);
				Pose(hand.grip, curl.z);
			}
		}

		private static void Pose(Joint[] joints, float curl)
		{
			for (int i = 0; i < joints.Length; i++)
			{
				Joint joint = joints[i];
				if ((bool)joint.bone)
				{
					joint.bone.localRotation = Quaternion.LerpUnclamped(joint.open, joint.closed, curl);
				}
			}
		}
	}
}
