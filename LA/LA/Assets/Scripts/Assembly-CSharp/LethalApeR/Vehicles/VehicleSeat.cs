using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.SpiderApe;
using UnityEngine;

namespace LethalApeR.Vehicles
{
	[Obfuscation(Exclude = true)]
	public abstract class VehicleSeat : MonoBehaviour
	{
		[Header("Seat")]
		[Tooltip("Where the driver's eyes go when seated. Also the centre of the seat volume. Forward = vehicle forward.")]
		[SerializeField]
		protected Transform headAnchor;

		[Tooltip("Ground-level points to step out to, tried in order until one is clear.")]
		[SerializeField]
		protected Transform[] exitPoints;

		[Header("Entry")]
		[Tooltip("Head must be inside this box (metres, centred on the head anchor) to sit.")]
		[SerializeField]
		private Vector3 seatVolumeSize = new Vector3(0.7f, 0.9f, 0.7f);

		[Tooltip("Head must stay inside for this long before snapping - brushing the volume while climbing doesn't seat you.")]
		[SerializeField]
		[Min(0f)]
		private float enterDwell = 0.2f;

		[Tooltip("After getting out, ignore the volume for this long.")]
		[SerializeField]
		[Min(0f)]
		private float reenterCooldown = 1f;

		[Header("Exit")]
		[Tooltip("Ignore the exit button for this long after sitting (debounces a press that was already held).")]
		[SerializeField]
		[Min(0f)]
		private float exitLockout = 0.4f;

		[Tooltip("Clearance sphere radius tested at the exit head position.")]
		[SerializeField]
		[Min(0.05f)]
		private float exitClearanceRadius = 0.3f;

		[SerializeField]
		private LayerMask exitClearanceMask = 1;

		[Tooltip("Head height above ground used on exit if the entry height couldn't be measured.")]
		[SerializeField]
		[Min(0.3f)]
		private float fallbackHeadHeight = 1.2f;

		[Header("Layers")]
		[Tooltip("Layer the vehicle's colliders use while someone is seated. Must collide with Player (hand triggers) and be OUTSIDE Player.locomotionEnabledLayers.")]
		[SerializeField]
		private int seatedLayer = 16;

		[Header("Feel")]
		[SerializeField]
		[Range(0f, 1f)]
		private float seatHapticAmplitude = 0.5f;

		[SerializeField]
		[Min(0f)]
		private float seatHapticDuration = 0.08f;

		private Player _player;

		private Transform _rig;

		private Transform _head;

		private Vector3 _rigLocalPos;

		private Quaternion _rigLocalRot;

		private float _headHeightAboveGround;

		private float _dwell;

		private float _seatedAt = -999f;

		private float _exitedAt = -999f;

		private bool _prevExitButton;

		private readonly List<GameObject> _relayered = new List<GameObject>(32);

		private readonly List<int> _originalLayers = new List<int>(32);

		private readonly List<Transform> _extraRoots = new List<Transform>(2);

		private readonly List<SpiderApeWebShooter> _disabledShooters = new List<SpiderApeWebShooter>(2);

		private readonly Collider[] _overlap = new Collider[8];

		private readonly RaycastHit[] _rayHits = new RaycastHit[8];

		private const float ExternalTeleportDistance = 25f;

		private Vector3 _lastWeldPos;

		public bool IsSeated { get; private set; }

		public Transform HeadAnchor => headAnchor;

		protected abstract IVehicleSeatHost Host { get; }

		protected virtual void Awake()
		{
			if (headAnchor == null)
			{
				Debug.LogError("[" + GetType().Name + "] No head anchor assigned.", this);
			}
		}

		protected virtual void OnDisable()
		{
			if (IsSeated)
			{
				Debug.Log("[" + GetType().Name + "] releasing driver: seat disabled", this);
				Exit(false);
			}
		}

		protected virtual bool CanEnter()
		{
			return true;
		}

		protected virtual bool CanExit()
		{
			return true;
		}

		private void Update()
		{
			if (ResolvePlayer())
			{
				if (IsSeated)
				{
					TryExit();
				}
				else
				{
					TryEnter();
				}
			}
		}

		private void LateUpdate()
		{
			if (!IsSeated || _rig == null)
			{
				return;
			}
			if ((_rig.position - _lastWeldPos).sqrMagnitude > ExternalTeleportDistance * ExternalTeleportDistance)
			{
				Debug.Log("[" + GetType().Name + "] releasing driver: rig moved " + Vector3.Distance(_rig.position, _lastWeldPos).ToString("F1") + " m since the last weld without a teleport event", this);
				Exit(false);
			}
			else
			{
				Weld();
			}
		}

		private void Weld()
		{
			Vector3 position = transform.TransformPoint(_rigLocalPos);
			Quaternion rotation = transform.rotation * _rigLocalRot;
			_rig.SetPositionAndRotation(position, rotation);
			Rigidbody playerRigidBody = _player.playerRigidBody;
			if (playerRigidBody != null)
			{
				playerRigidBody.position = position;
				playerRigidBody.rotation = rotation;
			}
			_player.AcceptExternalHeadPosition();
			_lastWeldPos = position;
		}

		private void OnPlayerTeleported(Player p)
		{
			if (IsSeated && !(p != _player))
			{
				Debug.Log("[" + GetType().Name + "] releasing driver: Player was teleported", this);
				Exit(false);
			}
		}

		private bool ResolvePlayer()
		{
			if (_player != null)
			{
				return true;
			}
			if (!Player.HasInstance || Player.Instance == null)
			{
				return false;
			}
			_player = Player.Instance;
			_rig = _player.transform;
			_head = ((_player.headCollider != null) ? _player.headCollider.transform : ((_player.mainCamera != null) ? _player.mainCamera.transform : null));
			return _head != null;
		}

		private void TryEnter()
		{
			if (headAnchor == null)
			{
				return;
			}
			if (Time.time - _exitedAt < reenterCooldown || _player.disableMovement || _player.playerRigidBody == null || _player.playerRigidBody.isKinematic || !CanEnter() || !HeadInsideVolume())
			{
				_dwell = 0f;
				return;
			}
			_dwell += Time.deltaTime;
			if (!(_dwell < enterDwell))
			{
				Enter();
			}
		}

		private bool HeadInsideVolume()
		{
			Vector3 local = headAnchor.InverseTransformPoint(_head.position);
			if (Mathf.Abs(local.x) <= seatVolumeSize.x * 0.5f && Mathf.Abs(local.y) <= seatVolumeSize.y * 0.5f)
			{
				return Mathf.Abs(local.z) <= seatVolumeSize.z * 0.5f;
			}
			return false;
		}

		private void Enter()
		{
			IsSeated = true;
			_dwell = 0f;
			_seatedAt = Time.time;
			_prevExitButton = ReadExitButton();
			_headHeightAboveGround = MeasureHeadHeight();
			float headYaw = FlatYaw(_head.forward);
			float anchorYaw = FlatYaw(headAnchor.forward);
			_rig.RotateAround(_head.position, Vector3.up, Mathf.DeltaAngle(headYaw, anchorYaw));
			_rig.position = _rig.position + (headAnchor.position - _head.position);
			Physics.SyncTransforms();
			Rigidbody playerRigidBody = _player.playerRigidBody;
			playerRigidBody.linearVelocity = Vector3.zero;
			playerRigidBody.angularVelocity = Vector3.zero;
			playerRigidBody.isKinematic = true;
			_player.disableMovement = true;
			_rigLocalPos = transform.InverseTransformPoint(_rig.position);
			_rigLocalRot = Quaternion.Inverse(transform.rotation) * _rig.rotation;
			Weld();
			Player.Teleported -= OnPlayerTeleported;
			Player.Teleported += OnPlayerTeleported;
			RelayerVehicle(true);
			SetWebShooters(false);
			Host?.OnDriverSeated();
			VRInputController instance = VRInputController.Instance;
			if (instance != null && seatHapticAmplitude > 0f)
			{
				instance.PulseLeft(seatHapticAmplitude, seatHapticDuration);
				instance.PulseRight(seatHapticAmplitude, seatHapticDuration);
			}
		}

		private float MeasureHeadHeight()
		{
			int count = Physics.RaycastNonAlloc(_head.position, Vector3.down, _rayHits, 6f, exitClearanceMask, QueryTriggerInteraction.Ignore);
			float best = float.MaxValue;
			for (int i = 0; i < count; i++)
			{
				RaycastHit hit = _rayHits[i];
				if ((!(hit.rigidbody != null) || hit.rigidbody.isKinematic) && hit.distance < best)
				{
					best = hit.distance;
				}
			}
			if (best == float.MaxValue)
			{
				return fallbackHeadHeight;
			}
			return Mathf.Clamp(best, 0.6f, 2.2f);
		}

		private void TryExit()
		{
			bool pressed = ReadExitButton();
			bool wasPressed = _prevExitButton;
			_prevExitButton = pressed;
			if (pressed && !wasPressed && !(Time.time - _seatedAt < exitLockout) && CanExit())
			{
				Debug.Log("[" + GetType().Name + "] driver pressed exit", this);
				Exit(true);
			}
		}

		private bool ReadExitButton()
		{
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				return instance.RightPrimaryButton;
			}
			return false;
		}

		public void Exit(bool reposition)
		{
			if (!IsSeated)
			{
				return;
			}
			IsSeated = false;
			_exitedAt = Time.time;
			_dwell = 0f;
			Player.Teleported -= OnPlayerTeleported;
			Host?.OnDriverLeft();
			RelayerVehicle(false);
			SetWebShooters(true);
			if (!(_player == null) && !(_rig == null))
			{
				if (reposition)
				{
					Vector3 headPos = PickExitHeadPosition();
					_rig.position = _rig.position + (headPos - _head.position);
					Physics.SyncTransforms();
				}
				Rigidbody playerRigidBody = _player.playerRigidBody;
				if (playerRigidBody != null)
				{
					playerRigidBody.isKinematic = false;
				}
				_player.disableMovement = false;
				_player.TeleportPlayerRaw(_rig.position, _rig.rotation);
			}
		}

		private Vector3 PickExitHeadPosition()
		{
			float height = ((_headHeightAboveGround > 0f) ? _headHeightAboveGround : fallbackHeadHeight);
			Vector3 fallback = _head.position;
			if (exitPoints != null)
			{
				for (int i = 0; i < exitPoints.Length; i++)
				{
					Transform exitPoint = exitPoints[i];
					if (!(exitPoint == null))
					{
						Vector3 candidate = exitPoint.position + Vector3.up * height;
						if (!Blocked(candidate))
						{
							return candidate;
						}
						if (i == 0)
						{
							fallback = candidate;
						}
					}
				}
			}
			return fallback;
		}

		private bool Blocked(Vector3 headPos)
		{
			IVehicleSeatHost host = Host;
			int count = Physics.OverlapSphereNonAlloc(headPos, exitClearanceRadius, _overlap, exitClearanceMask, QueryTriggerInteraction.Ignore);
			for (int i = 0; i < count; i++)
			{
				Collider collider = _overlap[i];
				if ((host == null || !host.IsOwnCollider(collider)) && (!(collider.attachedRigidbody != null) || collider.attachedRigidbody.isKinematic))
				{
					return true;
				}
			}
			return !Physics.Raycast(headPos, Vector3.down, 6f, exitClearanceMask, QueryTriggerInteraction.Ignore);
		}

		private void RelayerVehicle(bool seated)
		{
			if (seated)
			{
				_relayered.Clear();
				_originalLayers.Clear();
				Relayer(transform);
				_extraRoots.Clear();
				Host?.CollectColliderRoots(_extraRoots);
				for (int i = 0; i < _extraRoots.Count; i++)
				{
					if (_extraRoots[i] != null)
					{
						Relayer(_extraRoots[i]);
					}
				}
				return;
			}
			for (int j = 0; j < _relayered.Count; j++)
			{
				if (_relayered[j] != null)
				{
					_relayered[j].layer = _originalLayers[j];
				}
			}
			_relayered.Clear();
			_originalLayers.Clear();
		}

		private void Relayer(Transform root)
		{
			Collider[] componentsInChildren = root.GetComponentsInChildren<Collider>(true);
			foreach (Collider collider in componentsInChildren)
			{
				GameObject go = collider.gameObject;
				if (go.layer != seatedLayer && !_relayered.Contains(go))
				{
					_relayered.Add(go);
					_originalLayers.Add(go.layer);
					go.layer = seatedLayer;
				}
			}
		}

		private void SetWebShooters(bool on)
		{
			if (on)
			{
				for (int i = 0; i < _disabledShooters.Count; i++)
				{
					if (_disabledShooters[i] != null)
					{
						_disabledShooters[i].enabled = true;
					}
				}
				_disabledShooters.Clear();
				return;
			}
			_disabledShooters.Clear();
			if (SpiderApeSwing.Instance != null)
			{
				SpiderApeSwing.Instance.DetachAll();
			}
			if (_rig == null)
			{
				return;
			}
			SpiderApeWebShooter[] componentsInChildren = _rig.GetComponentsInChildren<SpiderApeWebShooter>();
			foreach (SpiderApeWebShooter shooter in componentsInChildren)
			{
				if (shooter.enabled)
				{
					shooter.enabled = false;
					_disabledShooters.Add(shooter);
				}
			}
		}

		private static float FlatYaw(Vector3 forward)
		{
			if (forward.x * forward.x + forward.z * forward.z < 1E-06f)
			{
				return 0f;
			}
			return Mathf.Atan2(forward.x, forward.z) * 57.29578f;
		}
	}
}
