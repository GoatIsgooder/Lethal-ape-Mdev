using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Rendering;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Interaction.Toolkit.Interactors;

namespace LethalApeR.Cosmetics
{
	[DefaultExecutionOrder(10500)]
	public sealed class DetachableHead : MonoBehaviour
	{
		private enum State : byte
		{
			OnHead = 0,
			Held = 1,
			Returning = 2
		}

		private const string GrabLayerName = "XRGrabbable";

		private const float ManagerSearchInterval = 1f;

		private const float MaxReturnSeconds = 4f;

		[Header("Rest pose, local to the parent bone (written by the builder)")]
		[SerializeField]
		private Vector3 restLocalPosition;

		[SerializeField]
		private Quaternion restLocalRotation = Quaternion.identity;

		[Header("The avatar's hand bones it rides on")]
		[SerializeField]
		private Transform leftHand;

		[SerializeField]
		private Transform rightHand;

		[Header("Grab, in this transform's local units")]
		[SerializeField]
		private Vector3 grabCenter;

		[SerializeField]
		[Min(0.01f)]
		private float grabRadius = 0.5f;

		[Tooltip("The wearer's own camera can't see the head while the camera is this close to the grab centre.")]
		[SerializeField]
		[Min(0.01f)]
		private float ownerHideRadius = 0.7f;

		[Header("Return (CosmeticStandPurchaseTag's feel)")]
		[SerializeField]
		[Min(0.1f)]
		private float returnSpeed = 5f;

		[SerializeField]
		[Min(0.001f)]
		private float seatDistance = 0.01f;

		[SerializeField]
		[Min(0.1f)]
		private float seatAngle = 3f;

		[Header("Look")]
		[SerializeField]
		private Renderer[] renderers = System.Array.Empty<Renderer>();

		[SerializeField]
		private int visibleLayer;

		[Header("Cosmetic slots that come off with the head")]
		[SerializeField]
		private Transform[] ridingSlots = System.Array.Empty<Transform>();

		[SerializeField]
		private Vector3[] ridingSlotRestPositions = System.Array.Empty<Vector3>();

		[SerializeField]
		private Quaternion[] ridingSlotRestRotations = System.Array.Empty<Quaternion>();

		private DetachableHeadSync _sync;

		private Transform _ownerHead;

		private bool _isOwner;

		private State _state;

		private bool _left;

		private Vector3 _heldPosition;

		private Quaternion _heldRotation = Quaternion.identity;

		private float _returnStarted;

		private bool _hiddenFromOwner;

		private int _mirrorLayer = -1;

		private int _grabLayer = -1;

		private Vector3[] _slotPositions;

		private Quaternion[] _slotRotations;

		private XRGrabInteractable _grab;

		private SphereCollider _grabSphere;

		private float _nextManagerSearch;

		private bool _grabPending;

		private bool _grabPendingLeft;

		private bool _releasePending;

		private void Awake()
		{
			_mirrorLayer = MirrorLayer.Index;
			_grabLayer = LayerMask.NameToLayer(GrabLayerName);
			if (ridingSlots != null)
			{
				_slotPositions = new Vector3[ridingSlots.Length];
				_slotRotations = new Quaternion[ridingSlots.Length];
			}
		}

		private void OnEnable()
		{
			_sync = GetComponentInParent<DetachableHeadSync>();
			_isOwner = _sync != null && _sync.IsLocalOwner;
			_ownerHead = _isOwner ? _sync.Head : null;
			_releasePending = false;
			_grabPending = false;
			Seat();
			ApplyLayer(_isOwner);
			if (_sync == null)
			{
				return;
			}
			_sync.Register(this);
			if (!_isOwner)
			{
				ApplyRemoteState();
			}
		}

		private void OnDisable()
		{
			if (_isOwner)
			{
				DestroyGrab();
				if (_state != State.OnHead && _sync != null)
				{
					_sync.PublishReleased();
					_sync.Flush(true);
				}
			}
			if (_sync != null)
			{
				_sync.Unregister(this);
			}
			_releasePending = false;
			_grabPending = false;
			Seat();
			ApplyLayer(false);
			_isOwner = false;
		}

		private void OnDestroy()
		{
			DestroyGrab();
		}

		private void LateUpdate()
		{
			Tick(Time.deltaTime);
		}

		internal void Tick(float dt)
		{
			if (_isOwner)
			{
				TickOwnerInput();
			}
			if (_state == State.Held)
			{
				ApplyHeld();
			}
			else if (_state == State.Returning)
			{
				StepReturn(dt);
			}
			if (_state != State.OnHead)
			{
				CarrySlots();
			}
			if (_isOwner)
			{
				UpdateOwnerVisibility();
				PlaceGrab();
				_sync.Flush();
			}
		}

		internal void ApplyRemoteState()
		{
			if (_isOwner || _sync == null)
			{
				return;
			}
			if (_sync.Held)
			{
				if (_state == State.OnHead)
				{
					CaptureSlots();
				}
				_left = _sync.LeftHand;
				_heldPosition = _sync.HeldPosition;
				_heldRotation = _sync.HeldRotation;
				_state = State.Held;
				ApplyHeld();
			}
			else if (_state == State.Held)
			{
				BeginReturn();
			}
		}

		private void TickOwnerInput()
		{
			EnsureGrab();
			if (_grabPending)
			{
				_grabPending = false;
				_releasePending = false;
				BeginHeld(_grabPendingLeft);
				_sync.PublishHeld(_left, _heldPosition, _heldRotation);
			}
			else if (_releasePending)
			{
				_releasePending = false;
				if (_state == State.Held)
				{
					BeginReturn();
					_sync.PublishReleased();
				}
			}
		}

		private void BeginHeld(bool left)
		{
			if (_state == State.OnHead)
			{
				CaptureSlots();
			}
			Transform hand = left ? leftHand : rightHand;
			_left = left;
			_heldPosition = hand.InverseTransformPoint(transform.position);
			_heldRotation = Quaternion.Inverse(hand.rotation) * transform.rotation;
			_state = State.Held;
		}

		private void OnGrabbed(SelectEnterEventArgs args)
		{
			_releasePending = false;
			_grabPending = true;
			_grabPendingLeft = IsLeft(args.interactorObject);
			Pulse(_grabPendingLeft, 0.35f, 0.06f);
		}

		private void OnReleased(SelectExitEventArgs args)
		{
			if (_grab != null && _grab.isSelected)
			{
				return;
			}
			_releasePending = true;
		}

		private bool IsLeft(IXRSelectInteractor interactor)
		{
			if (interactor.handedness == InteractorHandedness.Left)
			{
				return true;
			}
			if (interactor.handedness == InteractorHandedness.Right)
			{
				return false;
			}
			Vector3 position = interactor.transform.position;
			return (position - leftHand.position).sqrMagnitude <= (position - rightHand.position).sqrMagnitude;
		}

		private void UpdateOwnerVisibility()
		{
			bool hidden;
			if (_state == State.OnHead)
			{
				hidden = true;
			}
			else if (_ownerHead != null)
			{
				float radius = ownerHideRadius * transform.lossyScale.x;
				Vector3 center = transform.TransformPoint(grabCenter);
				hidden = (center - _ownerHead.position).sqrMagnitude < radius * radius;
			}
			else
			{
				hidden = false;
			}
			if (hidden != _hiddenFromOwner)
			{
				ApplyLayer(hidden);
			}
		}

		private void EnsureGrab()
		{
			if (_grab != null)
			{
				if (_grab.interactionManager != null)
				{
					return;
				}
				DestroyGrab();
			}
			if (Time.unscaledTime < _nextManagerSearch)
			{
				return;
			}
			_nextManagerSearch = Time.unscaledTime + ManagerSearchInterval;
			if (leftHand == null || rightHand == null || _grabLayer < 0)
			{
				return;
			}
			XRInteractionManager manager = LocalInteractionManager();
			if (manager == null)
			{
				return;
			}
			GameObject go = new GameObject(base.name + " Grab");
			go.layer = _grabLayer;
			go.SetActive(false);
			if (Application.isPlaying)
			{
				Object.DontDestroyOnLoad(go);
			}
			_grabSphere = go.AddComponent<SphereCollider>();
			_grabSphere.isTrigger = true;
			Rigidbody body = go.AddComponent<Rigidbody>();
			body.isKinematic = true;
			body.useGravity = false;
			_grab = go.AddComponent<XRGrabInteractable>();
			_grab.interactionManager = manager;
			_grab.colliders.Add(_grabSphere);
			_grab.trackPosition = false;
			_grab.trackRotation = false;
			_grab.trackScale = false;
			_grab.throwOnDetach = false;
			_grab.retainTransformParent = false;
			_grab.selectEntered.AddListener(OnGrabbed);
			_grab.selectExited.AddListener(OnReleased);
			PlaceGrab();
			go.SetActive(true);
		}

		private void PlaceGrab()
		{
			if (_grab == null)
			{
				return;
			}
			float radius = grabRadius * transform.lossyScale.x;
			if (Mathf.Abs(_grabSphere.radius - radius) > 0.0001f)
			{
				_grabSphere.radius = radius;
			}
			_grab.transform.SetPositionAndRotation(transform.TransformPoint(grabCenter), transform.rotation);
		}

		private void DestroyGrab()
		{
			if (_grab == null)
			{
				return;
			}
			_grab.selectEntered.RemoveListener(OnGrabbed);
			_grab.selectExited.RemoveListener(OnReleased);
			XRInteractionManager manager = _grab.interactionManager;
			if (manager != null)
			{
				for (int i = _grab.interactorsSelecting.Count - 1; i >= 0; i--)
				{
					manager.SelectExit(_grab.interactorsSelecting[i], _grab);
				}
			}
			Object.Destroy(_grab.gameObject);
			_grab = null;
			_grabSphere = null;
		}

		private static XRInteractionManager LocalInteractionManager()
		{
			if (!GorillaLocomotion.Player.HasInstance || GorillaLocomotion.Player.Instance == null)
			{
				return null;
			}
			XRBaseInteractor[] interactors = GorillaLocomotion.Player.Instance.GetComponentsInChildren<XRBaseInteractor>(true);
			foreach (XRBaseInteractor interactor in interactors)
			{
				if (interactor.interactionManager != null)
				{
					return interactor.interactionManager;
				}
			}
			return null;
		}

		private static void Pulse(bool left, float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return;
			}
			if (left)
			{
				instance.PulseLeft(amplitude, duration);
			}
			else
			{
				instance.PulseRight(amplitude, duration);
			}
		}

		private void ApplyHeld()
		{
			Transform hand = _left ? leftHand : rightHand;
			if (hand == null)
			{
				return;
			}
			transform.SetPositionAndRotation(hand.TransformPoint(_heldPosition), hand.rotation * _heldRotation);
		}

		private void BeginReturn()
		{
			_state = State.Returning;
			_returnStarted = Time.time;
		}

		private void StepReturn(float dt)
		{
			float t = 1f - Mathf.Exp(-returnSpeed * dt);
			Vector3 position = Vector3.Lerp(transform.localPosition, restLocalPosition, t);
			Quaternion rotation = Quaternion.Slerp(transform.localRotation, restLocalRotation, t);
			if (((position - restLocalPosition).sqrMagnitude <= seatDistance * seatDistance && Quaternion.Angle(rotation, restLocalRotation) <= seatAngle) || Time.time - _returnStarted > MaxReturnSeconds)
			{
				Seat();
			}
			else
			{
				transform.SetLocalPositionAndRotation(position, rotation);
			}
		}

		private void Seat()
		{
			_state = State.OnHead;
			transform.SetLocalPositionAndRotation(restLocalPosition, restLocalRotation);
			RestoreSlots();
		}

		private void CaptureSlots()
		{
			for (int i = 0; i < ridingSlots.Length; i++)
			{
				Transform slot = ridingSlots[i];
				if (slot == null)
				{
					continue;
				}
				_slotPositions[i] = transform.InverseTransformPoint(slot.position);
				_slotRotations[i] = Quaternion.Inverse(transform.rotation) * slot.rotation;
			}
		}

		private void CarrySlots()
		{
			for (int i = 0; i < ridingSlots.Length; i++)
			{
				Transform slot = ridingSlots[i];
				if (slot != null)
				{
					slot.SetPositionAndRotation(transform.TransformPoint(_slotPositions[i]), transform.rotation * _slotRotations[i]);
				}
			}
		}

		private void RestoreSlots()
		{
			int count = Mathf.Min(ridingSlots.Length, Mathf.Min(ridingSlotRestPositions.Length, ridingSlotRestRotations.Length));
			for (int i = 0; i < count; i++)
			{
				if (ridingSlots[i] != null)
				{
					ridingSlots[i].SetLocalPositionAndRotation(ridingSlotRestPositions[i], ridingSlotRestRotations[i]);
				}
			}
		}

		private void ApplyLayer(bool hiddenFromOwner)
		{
			_hiddenFromOwner = hiddenFromOwner;
			int layer = (hiddenFromOwner && _mirrorLayer >= 0) ? _mirrorLayer : visibleLayer;
			for (int i = 0; i < renderers.Length; i++)
			{
				if (renderers[i] != null)
				{
					renderers[i].gameObject.layer = layer;
				}
			}
		}
	}
}
