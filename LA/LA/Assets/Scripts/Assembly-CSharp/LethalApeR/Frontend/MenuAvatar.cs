using System;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Frontend
{
	public sealed class MenuAvatar : MonoBehaviour
	{
		[Serializable]
		public sealed class Finger
		{
			public Transform[] bones = Array.Empty<Transform>();

			public Quaternion[] open = Array.Empty<Quaternion>();

			public Quaternion[] curl = Array.Empty<Quaternion>();

			public void Apply(float amount)
			{
				int num = Mathf.Min(bones.Length, Mathf.Min(open.Length, curl.Length));
				for (int i = 0; i < num; i++)
				{
					if (bones[i] != null)
					{
						bones[i].localRotation = Quaternion.LerpUnclamped(open[i], curl[i], amount);
					}
				}
			}
		}

		[SerializeField]
		private MenuRig rig;

		[SerializeField]
		private Transform leftTarget;

		[SerializeField]
		private Transform rightTarget;

		[Tooltip("Controller pose to ape hand; the player rig's 'IK Target' offset.")]
		[SerializeField]
		private Vector3 targetOffsetPosition = new Vector3(0f, 0f, -0.036f);

		[SerializeField]
		private Vector3 targetOffsetEuler = new Vector3(270f, 180f, 0f);

		[Tooltip("Head-local controller poses used while a controller isn't tracked, and on desktop.")]
		[SerializeField]
		private Vector3 restLeft = new Vector3(-0.19f, -0.43f, 0.22f);

		[SerializeField]
		private Vector3 restRight = new Vector3(0.19f, -0.43f, 0.22f);

		[SerializeField]
		private Vector3 restEuler = new Vector3(25f, 0f, 0f);

		[Tooltip("Follow the rig's hand transforms even with no tracked controller (capture, tests).")]
		public bool forceRigHands;

		[Header("Fingers")]
		[SerializeField]
		private Finger leftThumb = new Finger();

		[SerializeField]
		private Finger leftIndex = new Finger();

		[SerializeField]
		private Finger leftGrip = new Finger();

		[SerializeField]
		private Finger rightThumb = new Finger();

		[SerializeField]
		private Finger rightIndex = new Finger();

		[SerializeField]
		private Finger rightGrip = new Finger();

		[Tooltip("Same as the in-game FingerAnimations.animationSpeed; higher is snappier.")]
		[SerializeField]
		private float fingerSpeed = 15f;

		private static readonly int OriginId = Shader.PropertyToID("_HoloApeOriginY");

		private Quaternion _offset;

		private float _lThumb;

		private float _lIndex;

		private float _lGrip;

		private float _rThumb;

		private float _rIndex;

		private float _rGrip;

		private float _lThumbVel;

		private float _lIndexVel;

		private float _lGripVel;

		private float _rThumbVel;

		private float _rIndexVel;

		private float _rGripVel;

		private void Awake()
		{
			_offset = Quaternion.Euler(targetOffsetEuler);
		}

		private void Update()
		{
			if (!(rig.Head == null))
			{
				Transform head = rig.Head.transform;
				VRInputController instance = VRInputController.Instance;
				Place(leftTarget, rig.LeftHand, head, restLeft, (instance != null) ? instance.LeftController : default(InputDevice));
				Place(rightTarget, rig.RightHand, head, restRight, (instance != null) ? instance.RightController : default(InputDevice));
			}
		}

		private void Place(Transform target, Transform hand, Transform head, Vector3 rest, InputDevice device)
		{
			if (target == null)
			{
				return;
			}
			Vector3 vector;
			Quaternion quaternion;
			if (hand != null && (forceRigHands || (!rig.IsDesktop && Tracked(device))))
			{
				vector = hand.position;
				quaternion = hand.rotation;
			}
			else
			{
				Quaternion quaternion2 = Quaternion.Euler(0f, head.eulerAngles.y, 0f);
				vector = head.position + quaternion2 * rest;
				quaternion = quaternion2 * Quaternion.Euler(restEuler);
			}
			target.SetPositionAndRotation(vector + quaternion * targetOffsetPosition, quaternion * _offset);
		}

		private static bool Tracked(InputDevice device)
		{
			bool value = false;
			if (device.isValid)
			{
				if (device.TryGetFeatureValue(CommonUsages.isTracked, out value))
				{
					return value;
				}
				return true;
			}
			return false;
		}

		private void LateUpdate()
		{
			VRInputController instance = VRInputController.Instance;
			bool flag = instance == null || rig.IsDesktop;
			float smoothTime = 1f / Mathf.Max(fingerSpeed, 0.01f);
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			_lThumb = Mathf.SmoothDamp(_lThumb, flag ? 0f : ((instance.LeftPrimaryButton || instance.LeftSecondaryButton) ? 1f : 0f), ref _lThumbVel, smoothTime, float.PositiveInfinity, unscaledDeltaTime);
			_rThumb = Mathf.SmoothDamp(_rThumb, flag ? 0f : ((instance.RightPrimaryButton || instance.RightSecondaryButton) ? 1f : 0f), ref _rThumbVel, smoothTime, float.PositiveInfinity, unscaledDeltaTime);
			_lIndex = Mathf.SmoothDamp(_lIndex, flag ? 0f : instance.LeftTriggerValue, ref _lIndexVel, smoothTime, float.PositiveInfinity, unscaledDeltaTime);
			_rIndex = Mathf.SmoothDamp(_rIndex, flag ? 0f : instance.RightTriggerValue, ref _rIndexVel, smoothTime, float.PositiveInfinity, unscaledDeltaTime);
			_lGrip = Mathf.SmoothDamp(_lGrip, flag ? 0f : instance.LeftGripValue, ref _lGripVel, smoothTime, float.PositiveInfinity, unscaledDeltaTime);
			_rGrip = Mathf.SmoothDamp(_rGrip, flag ? 0f : instance.RightGripValue, ref _rGripVel, smoothTime, float.PositiveInfinity, unscaledDeltaTime);
			Shader.SetGlobalFloat(OriginId, base.transform.position.y);
			leftThumb.Apply(_lThumb);
			leftIndex.Apply(_lIndex);
			leftGrip.Apply(_lGrip);
			rightThumb.Apply(_rThumb);
			rightIndex.Apply(_rIndex);
			rightGrip.Apply(_rGrip);
		}
	}
}
