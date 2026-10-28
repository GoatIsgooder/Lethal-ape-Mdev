using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.XR;

namespace Locomotion.Scripts
{
	public class GrabInteractor : MonoBehaviour
	{
		private class HeldEntry
		{
			public readonly List<GrabInteractor> hands = new List<GrabInteractor>(2);

			public Transform originalParent;

			public bool reparented;

			public bool savedUseGravity;

			public int savedSolverIter;

			public int savedSolverVelIter;

			public float savedMaxAngularVel;

			public RigidbodyInterpolation savedInterpolation;
		}

		[Header("Hand pose")]
		[Tooltip("Controller-tracked transform this GameObject snaps to in LateUpdate. The old PhysicHand.target. Leave null to leave the hand stationary.")]
		public Transform handFollowSource;

		[Header("Hierarchy")]
		[Tooltip("Held objects are reparented under this transform on grab and restored to their original parent on drop. Cuts locomotion-induced jitter because the held body inherits rig motion. Defaults to transform.root if left null.")]
		public Transform rigTransform;

		[Header("Detection")]
		public LayerMask interactableLayer;

		[Tooltip("World-space grab anchor (typically a child of this GameObject). The pose the held object's grab point chases.")]
		public Transform palm;

		public float sphereRadius = 0.05f;

		[Header("Input")]
		public XRNode node = XRNode.LeftHand;

		[Range(0f, 1f)]
		public float gripThreshold = 0.7f;

		[Tooltip("Editor debug override. Tick this to force a grab without controller input. The live grip still works while this is off.")]
		public bool testGrab;

		[Header("IK")]
		[Tooltip("Optional. The hand IK target pose-follows the held object while holding.")]
		public HandIKTargetDriver ikDriver;

		[Header("PID — position")]
		[Tooltip("Higher = snappier chase. ~50 feels Boneworks-tight; ~25 feels Alyx-soft.")]
		public float positionFrequency = 50f;

		[Tooltip("1 = critically damped (no overshoot). >1 = overdamped. <1 = bouncy.")]
		public float positionDamping = 1f;

		[Header("PID — rotation")]
		public float rotationFrequency = 25f;

		public float rotationDamping = 0.9f;

		[Header("Hold tuning")]
		[Tooltip("Gravity is disabled on the held body while held so it doesn't sag against the spring. Restored on drop.")]
		public bool disableGravityWhileHeld = true;

		[Tooltip("Solver iterations on the held body while held. Higher = stiffer contact with the rest of the world.")]
		public int heldSolverIterations = 10;

		[Tooltip("Velocity solver iterations on the held body while held.")]
		public int heldSolverVelocityIterations = 4;

		[Tooltip("Raise the held body's max angular velocity so fast spins don't get clipped.")]
		public float heldMaxAngularVelocity = 25f;

		[Header("Haptics")]
		[Range(0f, 1f)]
		public float grabHapticAmplitude = 0.5f;

		public float grabHapticDuration = 0.08f;

		[Range(0f, 1f)]
		public float dropHapticAmplitude = 0.3f;

		public float dropHapticDuration = 0.05f;

		[Tooltip("Peak amplitude of the motion haptic while held. 0 disables it.")]
		[Range(0f, 1f)]
		public float motionHapticAmplitude = 0.6f;

		[Tooltip("Palm speed (m/s) below which the motion haptic is silent. Avoids buzzing while holding still.")]
		public float motionHapticMinSpeed = 0.6f;

		[Tooltip("Palm speed (m/s) at which the motion haptic peaks.")]
		public float motionHapticMaxSpeed = 3f;

		[Header("Audio")]
		public AudioClip grabSound;

		public AudioClip dropSound;

		[Range(0f, 2f)]
		public float soundVolume = 1f;

		private InputDevice _inputDevice;

		private Rigidbody _heldRigidbody;

		private Transform _heldTransform;

		private Transform _heldRoot;

		private IGrabbable _heldInterface;

		private Vector3 _grabLocalPos;

		private Quaternion _grabLocalRot;

		private bool _liveGrip;

		private Vector3 _lastPalmPos;

		private float _palmSpeed;

		private bool _palmSpeedSeeded;

		private static readonly Collider[] OverlapBuffer = new Collider[16];

		private static readonly Dictionary<Rigidbody, HeldEntry> ActiveHolds = new Dictionary<Rigidbody, HeldEntry>();

		public bool IsGrabbing { get; private set; }

		public Rigidbody HeldRigidbody => _heldRigidbody;

		public Transform HeldTransform => _heldTransform;

		private HeldEntry CurrentEntry
		{
			get
			{
				if (_heldRigidbody != null && ActiveHolds.TryGetValue(_heldRigidbody, out var value))
				{
					return value;
				}
				return null;
			}
		}

		private bool IsPrimaryHand
		{
			get
			{
				HeldEntry currentEntry = CurrentEntry;
				if (currentEntry != null && currentEntry.hands.Count > 0)
				{
					return currentEntry.hands[0] == this;
				}
				return false;
			}
		}

		private bool HoldRequested
		{
			get
			{
				if (!_liveGrip)
				{
					return testGrab;
				}
				return true;
			}
		}

		private void Update()
		{
			PollInput();
			UpdatePalmSpeed();
			if (IsGrabbing)
			{
				if (_heldRoot == null)
				{
					Drop();
				}
				if (IsGrabbing && !HoldRequested)
				{
					Drop();
				}
			}
			else if (HoldRequested)
			{
				TryGrab();
			}
			if (IsGrabbing)
			{
				UpdateMotionHaptics();
			}
		}

		private void LateUpdate()
		{
			if (handFollowSource != null)
			{
				base.transform.SetPositionAndRotation(handFollowSource.position, handFollowSource.rotation);
			}
		}

		private void FixedUpdate()
		{
			if (IsGrabbing && !(_heldRigidbody == null) && !(palm == null) && IsPrimaryHand)
			{
				ComputeCombinedTarget(out var pos, out var rot);
				float fixedDeltaTime = Time.fixedDeltaTime;
				if (_heldRigidbody.isKinematic)
				{
					_heldRigidbody.MovePosition(pos);
					_heldRigidbody.MoveRotation(rot);
					return;
				}
				Vector3 force = PidSpring.PositionAcceleration(_heldRigidbody.position, pos, _heldRigidbody.linearVelocity, positionFrequency, positionDamping, fixedDeltaTime);
				_heldRigidbody.AddForce(force, ForceMode.Acceleration);
				Vector3 torque = PidSpring.RotationAcceleration(_heldRigidbody.rotation, rot, _heldRigidbody.angularVelocity, rotationFrequency, rotationDamping, fixedDeltaTime);
				_heldRigidbody.AddTorque(torque, ForceMode.Acceleration);
			}
		}

		private void SoloTarget(out Vector3 pos, out Quaternion rot)
		{
			rot = palm.rotation * Quaternion.Inverse(_grabLocalRot);
			pos = palm.position - rot * _grabLocalPos;
		}

		private void ComputeCombinedTarget(out Vector3 pos, out Quaternion rot)
		{
			HeldEntry currentEntry = CurrentEntry;
			if (currentEntry == null || currentEntry.hands.Count <= 1)
			{
				SoloTarget(out pos, out rot);
				return;
			}
			GrabInteractor grabInteractor = currentEntry.hands[0];
			GrabInteractor grabInteractor2 = currentEntry.hands[1];
			if (grabInteractor.palm == null || grabInteractor2.palm == null)
			{
				SoloTarget(out pos, out rot);
				return;
			}
			Quaternion a = grabInteractor.palm.rotation * Quaternion.Inverse(grabInteractor._grabLocalRot);
			Quaternion b = grabInteractor2.palm.rotation * Quaternion.Inverse(grabInteractor2._grabLocalRot);
			rot = Quaternion.Slerp(a, b, 0.5f);
			Vector3 vector = grabInteractor2._grabLocalPos - grabInteractor._grabLocalPos;
			Vector3 vector2 = grabInteractor2.palm.position - grabInteractor.palm.position;
			if (vector.sqrMagnitude > 1E-06f && vector2.sqrMagnitude > 1E-06f)
			{
				rot = Quaternion.FromToRotation(rot * vector, vector2) * rot;
			}
			Vector3 vector3 = (grabInteractor._grabLocalPos + grabInteractor2._grabLocalPos) * 0.5f;
			pos = (grabInteractor.palm.position + grabInteractor2.palm.position) * 0.5f - rot * vector3;
		}

		private void PollInput()
		{
			if (_inputDevice.isValid)
			{
				if (_inputDevice.TryGetFeatureValue(CommonUsages.grip, out float value))
				{
					_liveGrip = value > gripThreshold;
				}
			}
			else
			{
				_inputDevice = InputDevices.GetDeviceAtXRNode(node);
			}
		}

		private void UpdatePalmSpeed()
		{
			if (palm == null)
			{
				return;
			}
			Vector3 position = palm.position;
			if (!_palmSpeedSeeded)
			{
				_lastPalmPos = position;
				_palmSpeed = 0f;
				_palmSpeedSeeded = true;
				return;
			}
			float deltaTime = Time.deltaTime;
			float b = ((deltaTime > 0f) ? (Vector3.Distance(position, _lastPalmPos) / deltaTime) : 0f);
			_lastPalmPos = position;
			_palmSpeed = Mathf.Lerp(_palmSpeed, b, 0.4f);
		}

		private void TryGrab()
		{
			if (palm == null)
			{
				return;
			}
			int num = Physics.OverlapSphereNonAlloc(palm.position, sphereRadius, OverlapBuffer, interactableLayer, QueryTriggerInteraction.Collide);
			if (num == 0)
			{
				return;
			}
			Collider collider = null;
			float num2 = float.PositiveInfinity;
			for (int i = 0; i < num; i++)
			{
				Collider collider2 = OverlapBuffer[i];
				if (collider2 == null)
				{
					continue;
				}
				IRemoteGrabGuard componentInParent = collider2.GetComponentInParent<IRemoteGrabGuard>();
				if (componentInParent != null && componentInParent.HeldByRemoteOwner)
				{
					continue;
				}
				ILocalGrabGate componentInParent2 = collider2.GetComponentInParent<ILocalGrabGate>();
				if (componentInParent2 == null || componentInParent2.LocalCanGrab)
				{
					float sqrMagnitude = (collider2.ClosestPoint(palm.position) - palm.position).sqrMagnitude;
					if (sqrMagnitude < num2)
					{
						num2 = sqrMagnitude;
						collider = collider2;
					}
				}
			}
			if (!(collider == null))
			{
				BeginHold(collider);
			}
		}

		private void BeginHold(Collider col)
		{
			_heldTransform = col.transform;
			col.transform.TryGetComponent<IGrabbable>(out _heldInterface);
			_heldRigidbody = col.attachedRigidbody;
			if (_heldRigidbody == null)
			{
				col.transform.TryGetComponent<Rigidbody>(out _heldRigidbody);
			}
			_heldRoot = ((_heldRigidbody != null) ? _heldRigidbody.transform : _heldTransform);
			Transform originalParentSnapshot = ((_heldRoot != null) ? _heldRoot.parent : null);
			_heldInterface?.OnGrab();
			IsGrabbing = true;
			CaptureGrabPose();
			RegisterWithEntry(originalParentSnapshot);
			if (ikDriver != null)
			{
				ikDriver.AttachTo(_heldRoot);
			}
			PulseHaptic(grabHapticAmplitude, grabHapticDuration);
			PlayClip(grabSound, _heldTransform.position);
		}

		private void RegisterWithEntry(Transform originalParentSnapshot)
		{
			if (_heldRigidbody == null)
			{
				return;
			}
			if (!ActiveHolds.TryGetValue(_heldRigidbody, out var value))
			{
				value = new HeldEntry
				{
					originalParent = originalParentSnapshot,
					savedUseGravity = _heldRigidbody.useGravity,
					savedSolverIter = _heldRigidbody.solverIterations,
					savedSolverVelIter = _heldRigidbody.solverVelocityIterations,
					savedMaxAngularVel = _heldRigidbody.maxAngularVelocity,
					savedInterpolation = _heldRigidbody.interpolation
				};
				ActiveHolds[_heldRigidbody] = value;
				ApplyHeldRigidbodyState();
				if (_heldRoot == null || _heldRoot.GetComponentInParent<INoReparentOnGrab>() == null)
				{
					ReparentToRig(value);
				}
			}
			value.hands.Add(this);
		}

		private void ReparentToRig(HeldEntry entry)
		{
			if (!(_heldRoot == null) && entry != null && !entry.reparented)
			{
				Transform transform = ((rigTransform != null) ? rigTransform : base.transform.root);
				if (!(transform == null) && !(transform == entry.originalParent))
				{
					_heldRoot.SetParent(transform, worldPositionStays: true);
					entry.reparented = true;
				}
			}
		}

		private void CaptureGrabPose()
		{
			if (_heldRigidbody != null)
			{
				_grabLocalPos = Quaternion.Inverse(_heldRigidbody.rotation) * (palm.position - _heldRigidbody.position);
				_grabLocalRot = Quaternion.Inverse(_heldRigidbody.rotation) * palm.rotation;
			}
			else
			{
				_grabLocalPos = Quaternion.Inverse(_heldTransform.rotation) * (palm.position - _heldTransform.position);
				_grabLocalRot = Quaternion.Inverse(_heldTransform.rotation) * palm.rotation;
			}
		}

		private void ApplyHeldRigidbodyState()
		{
			if (!(_heldRigidbody == null))
			{
				if (disableGravityWhileHeld)
				{
					_heldRigidbody.useGravity = false;
				}
				_heldRigidbody.solverIterations = heldSolverIterations;
				_heldRigidbody.solverVelocityIterations = heldSolverVelocityIterations;
				_heldRigidbody.maxAngularVelocity = Mathf.Max(_heldRigidbody.maxAngularVelocity, heldMaxAngularVelocity);
				_heldRigidbody.interpolation = RigidbodyInterpolation.None;
			}
		}

		public void ForceRelease()
		{
			if (IsGrabbing)
			{
				Drop();
			}
		}

		public static void ForceReleaseHoldersOf(Rigidbody rb)
		{
			if ((object)rb == null || !ActiveHolds.TryGetValue(rb, out var value))
			{
				return;
			}
			GrabInteractor[] array = value.hands.ToArray();
			for (int i = 0; i < array.Length; i++)
			{
				GrabInteractor grabInteractor = array[i];
				if (grabInteractor != null && grabInteractor.IsGrabbing)
				{
					grabInteractor.Drop();
				}
			}
		}

		private void Drop()
		{
			if (IsGrabbing)
			{
				Vector3 pos = ((_heldTransform != null) ? _heldTransform.position : base.transform.position);
				if (ikDriver != null)
				{
					ikDriver.Detach();
				}
				UnregisterFromEntry();
				_heldInterface?.OnDrop();
				_heldInterface = null;
				_heldRigidbody = null;
				_heldTransform = null;
				_heldRoot = null;
				IsGrabbing = false;
				PulseHaptic(dropHapticAmplitude, dropHapticDuration);
				PlayClip(dropSound, pos);
			}
		}

		private void UnregisterFromEntry()
		{
			if ((object)_heldRigidbody == null || !ActiveHolds.TryGetValue(_heldRigidbody, out var value))
			{
				return;
			}
			value.hands.Remove(this);
			if (value.hands.Count <= 0)
			{
				if (value.reparented && _heldRoot != null)
				{
					_heldRoot.SetParent((value.originalParent != null) ? value.originalParent : null, worldPositionStays: true);
				}
				if (_heldRigidbody != null)
				{
					_heldRigidbody.useGravity = value.savedUseGravity;
					_heldRigidbody.solverIterations = value.savedSolverIter;
					_heldRigidbody.solverVelocityIterations = value.savedSolverVelIter;
					_heldRigidbody.maxAngularVelocity = value.savedMaxAngularVel;
					_heldRigidbody.interpolation = value.savedInterpolation;
				}
				ActiveHolds.Remove(_heldRigidbody);
			}
		}

		private void UpdateMotionHaptics()
		{
			if (!(motionHapticAmplitude <= 0f) && !(motionHapticMaxSpeed <= motionHapticMinSpeed))
			{
				float num = motionHapticAmplitude * Mathf.InverseLerp(motionHapticMinSpeed, motionHapticMaxSpeed, _palmSpeed);
				if (!(num < 0.05f))
				{
					PulseHaptic(num, 0.05f);
				}
			}
		}

		private void PulseHaptic(float amplitude, float duration)
		{
			if (amplitude <= 0f || duration <= 0f)
			{
				return;
			}
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				if (node == XRNode.LeftHand)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		private void PlayClip(AudioClip clip, Vector3 pos)
		{
			if (!(clip == null) && !(soundVolume <= 0f))
			{
				AudioSource.PlayClipAtPoint(clip, pos, soundVolume);
			}
		}

		private void OnDisable()
		{
			if (IsGrabbing)
			{
				Drop();
			}
		}

		private void OnDrawGizmosSelected()
		{
			if (!(palm == null) && !(sphereRadius <= 0f))
			{
				Gizmos.color = Color.red;
				Gizmos.DrawWireSphere(palm.position, sphereRadius);
			}
		}
	}
}
