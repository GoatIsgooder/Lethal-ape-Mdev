using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Quests
{
	[RequireComponent(typeof(Collider))]
	public class PushScrollWheel : MonoBehaviour
	{
		[Header("References")]
		[SerializeField]
		private QuestBoard board;

		[Tooltip("Optional visible wheel mesh that we rotate to give physical feedback.")]
		[SerializeField]
		private Transform wheelVisual;

		[Header("Tuning")]
		[Tooltip("World-units of board scroll per world-unit of hand motion along the wheel's local down axis. Tune to taste.")]
		[SerializeField]
		private float scrollGain = 1f;

		[Tooltip("Tick this if the list scrolls the opposite of the direction you flick the wheel.")]
		[SerializeField]
		private bool invertScroll;

		[Tooltip("Degrees of wheel-visual rotation per world-unit of hand motion. Pure cosmetic. Flip the sign to reverse spin direction.")]
		[SerializeField]
		private float wheelDegreesPerUnit = 720f;

		[Tooltip("Local axis the wheel visual rotates around. Flip individual components (e.g. (-1,0,0)) to reverse spin direction.")]
		[SerializeField]
		private Vector3 wheelRotationAxis = Vector3.right;

		[Tooltip("Per-second multiplicative decay applied to coast velocity once the hand leaves. Higher = stops sooner.")]
		[SerializeField]
		private float frictionPerSecond = 4f;

		[Tooltip("Velocities smaller than this (units/sec) get clamped to zero — kills jitter when stationary.")]
		[SerializeField]
		private float velocityDeadzone = 0.02f;

		[Tooltip("Haptic intensity per unit of scroll velocity, capped at 1.")]
		[SerializeField]
		private float hapticPerVelocity = 2f;

		[Header("Axis")]
		[Tooltip("Local axis pointing 'down' on the wheel — positive hand motion along this axis scrolls forward through the list.")]
		[SerializeField]
		private Vector3 localDownAxis = Vector3.down;

		private Transform _activeHand;

		private bool _activeHandIsLeft;

		private Vector3 _lastHandWorldPos;

		private bool _hasLastHandPos;

		private float _coastVelocity;

		private void OnTriggerEnter(Collider other)
		{
			TryAttachHand(other);
		}

		private void OnTriggerStay(Collider other)
		{
			TryAttachHand(other);
		}

		private void OnTriggerExit(Collider other)
		{
			if (_activeHand != null && other.transform == _activeHand)
			{
				_activeHand = null;
				_hasLastHandPos = false;
			}
		}

		private void TryAttachHand(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				if (_activeHand != null && other.transform != _activeHand)
				{
					return;
				}
				_activeHand = other.transform;
				_activeHandIsLeft = FingertipHand.IsLeft(other);
			}
		}

		private void Update()
		{
			float deltaTime = Time.deltaTime;
			if (deltaTime <= 0f)
			{
				return;
			}
			if (_activeHand != null)
			{
				Vector3 position = _activeHand.position;
				if (_hasLastHandPos)
				{
					Vector3 lhs = position - _lastHandWorldPos;
					Vector3 rhs = base.transform.TransformDirection(localDownAxis.normalized);
					_coastVelocity = Vector3.Dot(lhs, rhs) / deltaTime;
				}
				_lastHandWorldPos = position;
				_hasLastHandPos = true;
			}
			else if (_coastVelocity != 0f)
			{
				_coastVelocity *= Mathf.Max(0f, 1f - frictionPerSecond * deltaTime);
				if (Mathf.Abs(_coastVelocity) < velocityDeadzone)
				{
					_coastVelocity = 0f;
				}
			}
			if (Mathf.Approximately(_coastVelocity, 0f))
			{
				return;
			}
			float num = deltaTime * _coastVelocity;
			if (board != null)
			{
				board.Scroll(invertScroll ? ((0f - num) * scrollGain) : (num * scrollGain));
			}
			if (wheelVisual != null)
			{
				wheelVisual.Rotate(wheelRotationAxis, num * wheelDegreesPerUnit, Space.Self);
			}
			if (_activeHand != null)
			{
				float num2 = Mathf.Clamp01(Mathf.Abs(_coastVelocity) * hapticPerVelocity);
				if (num2 > 0.01f)
				{
					InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(_activeHandIsLeft ? XRNode.LeftHand : XRNode.RightHand);
					if (deviceAtXRNode.isValid)
					{
						deviceAtXRNode.SendHapticImpulse(0u, num2, 0.04f);
					}
				}
			}
		}
	}
}
