using System;
using System.Collections.Generic;
using Locomotion.Scripts;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LALocomotion
{
	[DefaultExecutionOrder(-50)]
	[DisallowMultipleComponent]
	public class LAGrabber : MonoBehaviour
	{
		public LAPlayer player;

		public bool isLeft;

		[Tooltip("Held items hang from this wrist.")]
		public LAWrist wrist;

		[Tooltip("Where items are picked up from. Empty = the wrist.")]
		public Transform grabPoint;

		public float grabRadius = 0.06f;

		public LayerMask grabLayers = 321;

		[Tooltip("Layer held items move to. Must collide with the world and stay out of the locomotion layers.")]
		public int heldLayer = 6;

		[Range(0.05f, 1f)]
		public float gripPress = 0.7f;

		[Range(0f, 0.95f)]
		public float gripRelease = 0.35f;

		public float throwMultiplier = 1f;

		[Tooltip("A held handle lets go once the hand is this far from it (scaled with the rig).")]
		public float handleBreakDistance = 0.35f;

		[Header("Feedback")]
		public AudioSource audioSource;

		public AudioClip grabSound;

		public AudioClip dropSound;

		[Range(0f, 2f)]
		public float soundVolume = 1f;

		[Range(0f, 1f)]
		public float grabHapticAmplitude = 0.5f;

		public float grabHapticDuration = 0.08f;

		[Range(0f, 1f)]
		public float dropHapticAmplitude = 0.3f;

		public float dropHapticDuration = 0.05f;

		[NonSerialized]
		public float simulatedGrip = -1f;

		[NonSerialized]
		public float simulatedTrigger = -1f;

		public static Func<LAGrabber, bool> GrabBlocked;

		private readonly HashSet<object> _grabBlocks = new HashSet<object>();

		private static readonly Collider[] Overlaps = new Collider[32];

		private bool _gripDown;

		private Vector3 _velocity;

		private Vector3 _angularVelocity;

		private Vector3 _lastPosition;

		private Quaternion _lastRotation = Quaternion.identity;

		private Collider _handleCollider;

		private HandIKTargetDriver _ikDriver;

		private bool _ikResolved;

		public LAGrabbable Held { get; private set; }

		public LAGrabbable Supporting { get; private set; }

		public Component HeldHandle { get; private set; }

		public bool Busy => Held != null || Supporting != null || HeldHandle != null;

		public Transform AttachPoint => Attach;

		public Vector3 GrabPosition => Point.position;

		public Vector3 TrackedVelocity => _velocity;

		public Vector3 TrackedAngularVelocity => _angularVelocity;

		public bool GripDown => _gripDown;

		public float Grip => ReadGrip();

		public float Trigger
		{
			get
			{
				if (simulatedTrigger >= 0f)
				{
					return simulatedTrigger;
				}
				VRInputController instance = VRInputController.Instance;
				if (instance == null)
				{
					return 0f;
				}
				return isLeft ? instance.LeftTriggerValue : instance.RightTriggerValue;
			}
		}

		private Transform Attach => (wrist != null) ? wrist.transform : transform;

		private Transform Point => (grabPoint != null) ? grabPoint : Attach;

		public void BlockGrabs(object owner)
		{
			if (owner != null)
			{
				_grabBlocks.Add(owner);
			}
		}

		public void UnblockGrabs(object owner)
		{
			if (owner != null)
			{
				_grabBlocks.Remove(owner);
			}
		}

		private void OnEnable()
		{
			LAPlayer.Teleported += OnTeleported;
		}

		private void OnDisable()
		{
			LAPlayer.Teleported -= OnTeleported;
			LetGoOfSupported();
			ReleaseHandle(true);
			if (Held == null)
			{
				return;
			}
			if (Held.gameObject.activeInHierarchy)
			{
				Release(false);
			}
			else
			{
				Forget(Held);
			}
		}

		private void Update()
		{
			float grip = ReadGrip();
			if (_gripDown)
			{
				if (grip < gripRelease)
				{
					_gripDown = false;
					Release(true);
				}
			}
			else if (grip >= gripPress)
			{
				_gripDown = true;
			}
			KeepHandle();
			if (_gripDown && !Busy && !HandBusyElsewhere() && _grabBlocks.Count == 0 && (GrabBlocked == null || !GrabBlocked(this)))
			{
				TryGrab();
			}
			TrackVelocity();
		}

		private bool HandBusyElsewhere()
		{
			if (player != null)
			{
				return player.IsHandSuspended(isLeft);
			}
			return false;
		}

		private float ReadGrip()
		{
			if (simulatedGrip >= 0f)
			{
				return simulatedGrip;
			}
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return 0f;
			}
			return isLeft ? instance.LeftGripValue : instance.RightGripValue;
		}

		public bool TryGrab()
		{
			if (Busy)
			{
				return false;
			}
			int n = OverlapGrabSphere();
			LAGrabbable best = BestGrabbable(n);
			if (best == null)
			{
				return TryGrabHandle(n);
			}
			if (best.Holder != null && best.allowTwoHands)
			{
				return Support(best);
			}
			Grab(best);
			return true;
		}

		private int OverlapGrabSphere()
		{
			return Physics.OverlapSphereNonAlloc(Point.position, grabRadius, Overlaps, grabLayers, QueryTriggerInteraction.Collide);
		}

		private bool TryGrabHandle(int n)
		{
			Vector3 position = Point.position;
			Collider bestCollider = null;
			Component bestHandle = null;
			float bestDistance = float.MaxValue;
			for (int i = 0; i < n; i++)
			{
				Collider collider = Overlaps[i];
				if (!collider.TryGetComponent(out IStaticGrabbable component))
				{
					continue;
				}
				Component handle = (Component)component;
				if (handle is Behaviour behaviour && !behaviour.isActiveAndEnabled)
				{
					continue;
				}
				ILocalGrabGate gate = collider.GetComponentInParent<ILocalGrabGate>();
				if (gate != null && !gate.LocalCanGrab)
				{
					continue;
				}
				Vector3 closest = (!(collider is MeshCollider meshCollider) || meshCollider.convex) ? collider.ClosestPoint(position) : collider.bounds.ClosestPoint(position);
				float distance = (closest - position).sqrMagnitude;
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestCollider = collider;
					bestHandle = handle;
				}
			}
			if (bestHandle == null)
			{
				return false;
			}
			HeldHandle = bestHandle;
			_handleCollider = bestCollider;
			if (player != null)
			{
				player.SuspendHand(isLeft, this);
			}
			((IGrabbable)bestHandle).OnGrab();
			HandIKTargetDriver ik = HandleIk();
			if (ik != null)
			{
				ik.AttachTo(bestHandle.transform);
			}
			Feedback(grabSound, grabHapticAmplitude, grabHapticDuration);
			return true;
		}

		private void KeepHandle()
		{
			if (HeldHandle is null)
			{
				return;
			}
			if (HeldHandle == null)
			{
				ReleaseHandle(false);
				return;
			}
			bool active = (HeldHandle is Behaviour behaviour) ? behaviour.isActiveAndEnabled : HeldHandle.gameObject.activeInHierarchy;
			Collider handleCollider = _handleCollider;
			bool tooFar = false;
			if (handleCollider != null && handleCollider.enabled)
			{
				Vector3 position = Point.position;
				float breakDistance = handleBreakDistance * ((player != null) ? player.Scale : 1f);
				Vector3 closest = (!(handleCollider is MeshCollider meshCollider) || meshCollider.convex) ? handleCollider.ClosestPoint(position) : handleCollider.bounds.ClosestPoint(position);
				tooFar = (closest - position).sqrMagnitude > breakDistance * breakDistance;
			}
			if (!active || tooFar)
			{
				ReleaseHandle(true);
			}
		}

		private void ReleaseHandle(bool notify)
		{
			Component heldHandle = HeldHandle;
			if (heldHandle is null)
			{
				return;
			}
			HeldHandle = null;
			_handleCollider = null;
			if (_ikDriver != null)
			{
				_ikDriver.Detach();
			}
			if (player != null)
			{
				player.ResumeHand(isLeft, this);
			}
			if (notify && heldHandle != null)
			{
				((IGrabbable)heldHandle).OnDrop();
			}
			Feedback(dropSound, dropHapticAmplitude, dropHapticDuration);
		}

		public void ReleaseHandleUnder(Transform root)
		{
			if (!(root == null) && !(HeldHandle == null) && (HeldHandle.transform == root || HeldHandle.transform.IsChildOf(root)))
			{
				ReleaseHandle(true);
			}
		}

		private HandIKTargetDriver HandleIk()
		{
			if (_ikResolved)
			{
				return _ikDriver;
			}
			_ikResolved = true;
			Transform root = (player != null) ? player.transform : transform.root;
			HandIKTargetDriver[] drivers = root.GetComponentsInChildren<HandIKTargetDriver>(true);
			for (int i = 0; i < drivers.Length; i++)
			{
				HandIKTargetDriver driver = drivers[i];
				if (!(driver.kinematicSource == null) && driver.kinematicSource.IsChildOf(Attach))
				{
					_ikDriver = driver;
					break;
				}
			}
			return _ikDriver;
		}

		public bool Support(LAGrabbable item)
		{
			if (item == null || Held != null || Supporting != null)
			{
				return false;
			}
			if (!item.AddSupport(this))
			{
				return false;
			}
			Supporting = item;
			Feedback(grabSound, grabHapticAmplitude, grabHapticDuration);
			return true;
		}

		private void LetGoOfSupported()
		{
			LAGrabbable supporting = Supporting;
			Supporting = null;
			if (supporting != null)
			{
				supporting.RemoveSupport(this);
			}
		}

		public LAGrabbable FindGrabbable()
		{
			return BestGrabbable(OverlapGrabSphere());
		}

		private LAGrabbable BestGrabbable(int n)
		{
			Vector3 position = Point.position;
			LAGrabbable best = null;
			float bestDistance = float.MaxValue;
			for (int i = 0; i < n; i++)
			{
				Collider collider = Overlaps[i];
				LAGrabbable grabbable = collider.GetComponentInParent<LAGrabbable>();
				if (grabbable == null || grabbable.Holder == this || !grabbable.isActiveAndEnabled || !LocalMayGrab(grabbable))
				{
					continue;
				}
				Vector3 closest = (!(collider is MeshCollider meshCollider) || meshCollider.convex) ? collider.ClosestPoint(position) : collider.bounds.ClosestPoint(position);
				float distance = (closest - position).sqrMagnitude;
				if (distance < bestDistance)
				{
					bestDistance = distance;
					best = grabbable;
				}
			}
			return best;
		}

		private static bool LocalMayGrab(LAGrabbable g)
		{
			if (g.TryGetComponent(out IRemoteGrabGuard guard) && guard.HeldByRemoteOwner)
			{
				return false;
			}
			if (g.TryGetComponent(out ILocalGrabGate gate) && !gate.LocalCanGrab)
			{
				return false;
			}
			return true;
		}

		public void Grab(LAGrabbable item)
		{
			if (item == null)
			{
				return;
			}
			if (Held != null)
			{
				Release(false);
			}
			if (item.Holder != null)
			{
				item.Holder.Release(false);
			}
			item.Grab(this, Attach, heldLayer);
			Held = item;
			_velocity = Vector3.zero;
			_angularVelocity = Vector3.zero;
			_lastPosition = item.transform.position;
			_lastRotation = item.transform.rotation;
			Feedback(grabSound, grabHapticAmplitude, grabHapticDuration);
		}

		public void Release(bool throwIt)
		{
			if (HeldHandle is not null)
			{
				ReleaseHandle(true);
				return;
			}
			if (Supporting != null)
			{
				LetGoOfSupported();
				Feedback(dropSound, dropHapticAmplitude, dropHapticDuration);
				return;
			}
			LAGrabbable held = Held;
			Held = null;
			if (held == null)
			{
				return;
			}
			LAGrabber support = held.Support;
			if (support != null)
			{
				held.HandOver();
				support.TakeOver(held);
			}
			else if (throwIt)
			{
				held.Release(_velocity * throwMultiplier, _angularVelocity);
			}
			else
			{
				held.Release(Vector3.zero, Vector3.zero);
			}
			Feedback(dropSound, dropHapticAmplitude, dropHapticDuration);
		}

		private void TakeOver(LAGrabbable item)
		{
			Supporting = null;
			Held = item;
			_velocity = Vector3.zero;
			_angularVelocity = Vector3.zero;
			_lastPosition = item.transform.position;
			_lastRotation = item.transform.rotation;
		}

		internal void Forget(LAGrabbable item)
		{
			if (item == null)
			{
				return;
			}
			if (Supporting == item)
			{
				Supporting = null;
			}
			else if (!(Held != item))
			{
				Held = null;
				item.ReleaseWhileDeactivating();
			}
		}

		private void TrackVelocity()
		{
			if (Held == null)
			{
				return;
			}
			Transform heldTransform = Held.transform;
			float deltaTime = Time.deltaTime;
			if (deltaTime > 0f)
			{
				float t = 1f - MathF.Exp(-72f * deltaTime);
				_velocity = Vector3.LerpUnclamped(_velocity, (heldTransform.position - _lastPosition) / deltaTime, t);
				(heldTransform.rotation * Quaternion.Inverse(_lastRotation)).ToAngleAxis(out var angle, out var axis);
				if (angle > 180f)
				{
					angle -= 360f;
				}
				if (axis.sqrMagnitude > 1E-10f && float.IsFinite(axis.x))
				{
					_angularVelocity = Vector3.LerpUnclamped(_angularVelocity, axis.normalized * (angle * Mathf.Deg2Rad / deltaTime), t);
				}
			}
			_lastPosition = heldTransform.position;
			_lastRotation = heldTransform.rotation;
		}

		private void OnTeleported(LAPlayer p)
		{
			if (!(p != player))
			{
				ReleaseHandle(true);
				if (!(Held == null))
				{
					_velocity = Vector3.zero;
					_angularVelocity = Vector3.zero;
					_lastPosition = Held.transform.position;
					_lastRotation = Held.transform.rotation;
				}
			}
		}

		private void Feedback(AudioClip clip, float amplitude, float duration)
		{
			if (audioSource != null && clip != null && soundVolume > 0f)
			{
				audioSource.PlayOneShot(clip, soundVolume);
			}
			Haptic(amplitude, duration);
		}

		public void Haptic(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null || amplitude <= 0f || duration <= 0f)
			{
				return;
			}
			if (isLeft)
			{
				instance.PulseLeft(amplitude, duration);
			}
			else
			{
				instance.PulseRight(amplitude, duration);
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(1f, 0.6f, 0.1f, 1f);
			Gizmos.DrawWireSphere(Point.position, grabRadius);
		}
	}
}
