using System;
using System.Collections;
using System.Collections.Generic;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.Events;

namespace LALocomotion
{
	[DefaultExecutionOrder(-120)]
	[DisallowMultipleComponent]
	public class LAGrabbable : MonoBehaviour
	{
		private struct BodySettings
		{
			public float mass;

			public float linearDamping;

			public float angularDamping;

			public float maxAngularVelocity;

			public bool useGravity;

			public bool isKinematic;

			public bool automaticCenterOfMass;

			public bool automaticInertiaTensor;

			public RigidbodyInterpolation interpolation;

			public CollisionDetectionMode collisionDetection;

			public RigidbodyConstraints constraints;
		}

		[Serializable]
		public struct TwoHandGrip
		{
			public Vector3 anchor;

			public Vector3 aim;

			public Vector3 roll;

			public Vector3 rollInHand;
		}

		[Tooltip("Colliders that act as part of your hand while held. Empty = every solid collider on the item.")]
		public List<Collider> handColliders = new List<Collider>();

		[Tooltip("Optional: this point snaps into the palm on grab. Empty = the item keeps the pose it had.")]
		public Transform grabPoint;

		[Tooltip("A second hand can grab it anywhere to aim it with both hands.")]
		public bool allowTwoHands = true;

		[Tooltip("The second hand has to be at least this far from the first to steer.")]
		public float minTwoHandSpan = 0.08f;

		public UnityEvent onGrab = new UnityEvent();

		public UnityEvent onDrop = new UnityEvent();

		private static readonly Dictionary<Type, bool> NeedsBody = new Dictionary<Type, bool>();

		private static readonly List<Collider> ColliderScratch = new List<Collider>();

		private static readonly List<Component> ComponentScratch = new List<Component>();

		private static readonly List<IGrabbable> CallbackScratch = new List<IGrabbable>();

		private readonly List<Collider> _hand = new List<Collider>();

		private readonly List<GameObject> _layered = new List<GameObject>();

		private readonly List<int> _layers = new List<int>();

		private Transform _parent;

		private int _heldLayer;

		private BodySettings _saved;

		private bool _hadBody;

		private bool _restorePending;

		private TwoHandGrip _grip;

		private Vector3 _oneHandPosition;

		private Quaternion _oneHandRotation = Quaternion.identity;

		public LAGrabber Holder { get; private set; }

		public bool IsHeld => Holder != null;

		public LAGrabber Support { get; private set; }

		public bool IsTwoHanded => Holder != null && Support != null;

		public Rigidbody Body { get; private set; }

		public TwoHandGrip Grip => _grip;

		private void Awake()
		{
			Body = GetComponent<Rigidbody>();
		}

		private void Update()
		{
			if (IsTwoHanded)
			{
				Transform anchor = Holder.AttachPoint;
				Pose pose = TwoHandedPose(in _grip, anchor.position, anchor.rotation, Support.AttachPoint.position);
				transform.SetPositionAndRotation(pose.position, pose.rotation);
			}
		}

		public Pose TwoHandedPose(in TwoHandGrip grip, Vector3 anchorPosition, Quaternion anchorRotation, Vector3 supportPosition)
		{
			Quaternion rotation = transform.rotation;
			Vector3 span = supportPosition - anchorPosition;
			if (span.sqrMagnitude > 1E-06f)
			{
				Vector3 aim = span.normalized;
				Vector3 up = anchorRotation * grip.rollInHand;
				if (Mathf.Abs(Vector3.Dot(aim, up)) >= 0.95f)
				{
					up = rotation * grip.roll;
				}
				rotation = Quaternion.LookRotation(aim, up) * Quaternion.Inverse(Quaternion.LookRotation(grip.aim, grip.roll));
			}
			Vector3 offset = rotation * Vector3.Scale(grip.anchor, transform.lossyScale);
			return new Pose(anchorPosition - offset, rotation);
		}

		internal bool AddSupport(LAGrabber by)
		{
			if (!allowTwoHands || Holder == null || by == null || by == Holder || Support != null)
			{
				return false;
			}
			Transform anchor = Holder.AttachPoint;
			Vector3 aim = by.AttachPoint.position - anchor.position;
			if (aim.magnitude < minTwoHandSpan)
			{
				return false;
			}
			aim.Normalize();
			Vector3 roll = Vector3.up;
			float best = Mathf.Abs(Vector3.Dot(anchor.up, aim));
			float forward = Mathf.Abs(Vector3.Dot(anchor.forward, aim));
			if (forward < best)
			{
				roll = Vector3.forward;
				best = forward;
			}
			if (Mathf.Abs(Vector3.Dot(anchor.right, aim)) < best)
			{
				roll = Vector3.right;
			}
			_oneHandPosition = transform.localPosition;
			_oneHandRotation = transform.localRotation;
			Quaternion inverse = Quaternion.Inverse(transform.rotation);
			_grip = new TwoHandGrip
			{
				anchor = transform.InverseTransformPoint(anchor.position),
				aim = inverse * aim,
				roll = inverse * anchor.TransformDirection(roll),
				rollInHand = roll
			};
			Support = by;
			return true;
		}

		internal void RemoveSupport(LAGrabber by)
		{
			if (Support != by)
			{
				return;
			}
			Support = null;
			if (Holder != null && transform.parent == Holder.AttachPoint)
			{
				transform.SetLocalPositionAndRotation(_oneHandPosition, _oneHandRotation);
			}
		}

		internal void HandOver()
		{
			LAGrabber holder = Holder;
			LAGrabber support = Support;
			if (holder == null || support == null)
			{
				return;
			}
			if (holder.player != null)
			{
				for (int i = 0; i < _hand.Count; i++)
				{
					holder.player.RemoveHandCollider(holder.isLeft, _hand[i]);
				}
			}
			if (support.player != null)
			{
				for (int j = 0; j < _hand.Count; j++)
				{
					support.player.AddHandCollider(support.isLeft, _hand[j]);
				}
			}
			Holder = support;
			Support = null;
			transform.SetParent(support.AttachPoint, true);
			if (support.player != null)
			{
				support.player.SettleGrabbed(support.isLeft, _hand, false);
			}
		}

		private void OnEnable()
		{
			if (_restorePending)
			{
				StartCoroutine(RestoreNextFrame());
			}
		}

		private IEnumerator RestoreNextFrame()
		{
			yield return null;
			if (!_restorePending || Holder != null)
			{
				yield break;
			}
			_restorePending = false;
			RestoreBody(Vector3.zero, Vector3.zero);
		}

		private void OnDisable()
		{
			if (Support != null)
			{
				Support.Forget(this);
			}
			if (Holder != null)
			{
				Holder.Forget(this);
			}
		}

		internal void Grab(LAGrabber by, Transform attach, int heldLayer)
		{
			Holder = by;
			Support = null;
			_heldLayer = heldLayer;
			CollectHandColliders();
			_parent = transform.parent;
			transform.SetParent(attach, true);
			if (grabPoint != null)
			{
				SnapIntoPalm(attach);
			}
			Rigidbody rb = GetComponent<Rigidbody>();
			_hadBody = rb != null;
			if (_hadBody)
			{
				_saved = Capture(rb);
				if (CanRemove(rb))
				{
					UnityEngine.Object.DestroyImmediate(rb);
					rb = null;
				}
				else
				{
					rb.isKinematic = true;
					rb.interpolation = RigidbodyInterpolation.None;
				}
			}
			Body = rb;
			_layered.Clear();
			_layers.Clear();
			GetComponentsInChildren(true, ColliderScratch);
			for (int i = 0; i < ColliderScratch.Count; i++)
			{
				GameObject go = ColliderScratch[i].gameObject;
				if (!_layered.Contains(go))
				{
					_layered.Add(go);
					_layers.Add(go.layer);
					go.layer = heldLayer;
				}
			}
			LAPlayer player = by.player;
			if (player != null)
			{
				for (int j = 0; j < _hand.Count; j++)
				{
					player.AddHandCollider(by.isLeft, _hand[j]);
				}
			}
			Notify(grabbed: true);
			if (player != null && Holder == by)
			{
				player.SettleGrabbed(by.isLeft, _hand);
			}
		}

		public void AddPart(Transform part)
		{
			if (Holder == null || part == null)
			{
				return;
			}
			LAPlayer player = Holder.player;
			part.GetComponentsInChildren(true, ColliderScratch);
			for (int i = 0; i < ColliderScratch.Count; i++)
			{
				Collider c = ColliderScratch[i];
				GameObject go = c.gameObject;
				if (!_layered.Contains(go))
				{
					_layered.Add(go);
					_layers.Add(go.layer);
					go.layer = _heldLayer;
				}
				if (!c.isTrigger && !_hand.Contains(c) && (handColliders.Count <= 0 || handColliders.Contains(c)))
				{
					_hand.Add(c);
					if (player != null)
					{
						player.AddHandCollider(Holder.isLeft, c);
					}
				}
			}
		}

		public void RemovePart(Transform part)
		{
			if (Holder == null || part == null)
			{
				return;
			}
			LAPlayer player = Holder.player;
			part.GetComponentsInChildren(true, ColliderScratch);
			for (int i = 0; i < ColliderScratch.Count; i++)
			{
				Collider c = ColliderScratch[i];
				if (_hand.Remove(c) && player != null)
				{
					player.RemoveHandCollider(Holder.isLeft, c);
				}
				int index = _layered.IndexOf(c.gameObject);
				if (index >= 0)
				{
					c.gameObject.layer = _layers[index];
					_layered.RemoveAt(index);
					_layers.RemoveAt(index);
				}
			}
		}

		public void SetReleasedKinematic(bool kinematic)
		{
			if (Holder != null && _hadBody)
			{
				_saved.isKinematic = kinematic;
			}
		}

		public void Drop()
		{
			if (Support != null)
			{
				Support.Release(false);
			}
			if (Holder != null)
			{
				Holder.Release(false);
			}
		}

		internal void Release(Vector3 velocity, Vector3 angularVelocity)
		{
			Detach();
			RestoreBody(velocity, angularVelocity);
			Notify(grabbed: false);
		}

		internal void ReleaseWhileDeactivating()
		{
			Detach();
			_restorePending = true;
			Notify(grabbed: false);
		}

		private void Detach()
		{
			LAGrabber holder = Holder;
			LAGrabber support = Support;
			Holder = null;
			Support = null;
			if (support != null)
			{
				support.Forget(this);
			}
			if (holder != null && holder.player != null)
			{
				for (int i = 0; i < _hand.Count; i++)
				{
					holder.player.RemoveHandCollider(holder.isLeft, _hand[i]);
				}
			}
			for (int j = 0; j < _layered.Count; j++)
			{
				if (_layered[j] != null)
				{
					_layered[j].layer = _layers[j];
				}
			}
			_layered.Clear();
			_layers.Clear();
		}

		private void RestoreBody(Vector3 velocity, Vector3 angularVelocity)
		{
			transform.SetParent(_parent, true);
			Rigidbody rb = GetComponent<Rigidbody>();
			if (_hadBody)
			{
				if (rb == null)
				{
					rb = gameObject.AddComponent<Rigidbody>();
				}
				Apply(_saved, rb);
			}
			Body = rb;
			if (rb != null && !rb.isKinematic)
			{
				rb.linearVelocity = velocity;
				rb.angularVelocity = angularVelocity;
			}
		}

		private void CollectHandColliders()
		{
			_hand.Clear();
			if (handColliders.Count > 0)
			{
				for (int i = 0; i < handColliders.Count; i++)
				{
					if (handColliders[i] != null && !handColliders[i].isTrigger)
					{
						_hand.Add(handColliders[i]);
					}
				}
				return;
			}
			GetComponentsInChildren(true, ColliderScratch);
			for (int j = 0; j < ColliderScratch.Count; j++)
			{
				if (!ColliderScratch[j].isTrigger)
				{
					_hand.Add(ColliderScratch[j]);
				}
			}
		}

		private void SnapIntoPalm(Transform palm)
		{
			Quaternion localRotation = Quaternion.Inverse(transform.rotation) * grabPoint.rotation;
			Vector3 localPoint = transform.InverseTransformPoint(grabPoint.position);
			transform.rotation = palm.rotation * Quaternion.Inverse(localRotation);
			transform.position = palm.position - transform.TransformVector(localPoint);
		}

		private void Notify(bool grabbed)
		{
			GetComponents(CallbackScratch);
			for (int i = 0; i < CallbackScratch.Count; i++)
			{
				if (grabbed)
				{
					CallbackScratch[i].OnGrab();
				}
				else
				{
					CallbackScratch[i].OnDrop();
				}
			}
			(grabbed ? onGrab : onDrop).Invoke();
		}

		private static bool CanRemove(Rigidbody rb)
		{
			rb.GetComponents(ComponentScratch);
			for (int i = 0; i < ComponentScratch.Count; i++)
			{
				Component c = ComponentScratch[i];
				if (c == null || c == rb)
				{
					continue;
				}
				Type type = c.GetType();
				if (!NeedsBody.TryGetValue(type, out bool needs))
				{
					needs = false;
					foreach (RequireComponent require in type.GetCustomAttributes(typeof(RequireComponent), true))
					{
						if (require.m_Type0 == typeof(Rigidbody) || require.m_Type1 == typeof(Rigidbody) || require.m_Type2 == typeof(Rigidbody))
						{
							needs = true;
						}
					}
					NeedsBody[type] = needs;
				}
				if (needs)
				{
					return false;
				}
			}
			return true;
		}

		private static BodySettings Capture(Rigidbody rb)
		{
			return new BodySettings
			{
				mass = rb.mass,
				linearDamping = rb.linearDamping,
				angularDamping = rb.angularDamping,
				maxAngularVelocity = rb.maxAngularVelocity,
				useGravity = rb.useGravity,
				isKinematic = rb.isKinematic,
				automaticCenterOfMass = rb.automaticCenterOfMass,
				automaticInertiaTensor = rb.automaticInertiaTensor,
				interpolation = rb.interpolation,
				collisionDetection = rb.collisionDetectionMode,
				constraints = rb.constraints
			};
		}

		private static void Apply(BodySettings s, Rigidbody rb)
		{
			rb.mass = s.mass;
			rb.linearDamping = s.linearDamping;
			rb.angularDamping = s.angularDamping;
			rb.maxAngularVelocity = s.maxAngularVelocity;
			rb.useGravity = s.useGravity;
			rb.automaticCenterOfMass = s.automaticCenterOfMass;
			rb.automaticInertiaTensor = s.automaticInertiaTensor;
			rb.interpolation = s.interpolation;
			rb.collisionDetectionMode = s.collisionDetection;
			rb.constraints = s.constraints;
			rb.isKinematic = s.isKinematic;
		}
	}
}
