using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Vehicles
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	[RequireComponent(typeof(Rigidbody))]
	public class ForkliftController : MonoBehaviour, IVehicleSeatHost
	{
		[Serializable]
		public class WheelSetup
		{
			[Tooltip("Yaw pivot at the hub. Rotated about local Y for steering.")]
			public Transform steerPivot;

			[Tooltip("Roll pivot under the steer pivot. Rotated about local X for rolling. The mesh sits under this.")]
			public Transform spinPivot;

			[Tooltip("Rolling radius in metres. Used for hub height and spin rate.")]
			public float radius = 0.3f;

			public bool isFront;

			public bool isLeft;

			[NonSerialized]
			public float spinDegrees;

			[NonSerialized]
			public Vector3 hubLocal;
		}

		[Header("References")]
		[SerializeField]
		private ForkliftSeat seat;

		[SerializeField]
		private ForkliftSteeringWheel steeringWheel;

		[SerializeField]
		private ForkliftLiftLever liftLever;

		[Tooltip("The fork carriage rig (own kinematic Rigidbody). Un-parented at runtime - see class notes.")]
		[SerializeField]
		private Transform forkRig;

		[SerializeField]
		private WheelSetup[] wheels = new WheelSetup[4];

		[Header("Drive")]
		[SerializeField]
		[Min(0.1f)]
		private float maxForwardSpeed = 4f;

		[SerializeField]
		[Min(0.1f)]
		private float maxReverseSpeed = 2f;

		[SerializeField]
		[Min(0.1f)]
		private float acceleration = 3f;

		[Tooltip("Deceleration with the brake fully pulled (m/s^2).")]
		[SerializeField]
		[Min(0.1f)]
		private float brakeDeceleration = 7f;

		[Tooltip("Deceleration with nothing pressed (m/s^2) - engine braking / rolling resistance.")]
		[SerializeField]
		[Min(0f)]
		private float coastDeceleration = 1.5f;

		[Tooltip("Squeezing the brake at a standstill (a fresh squeeze, not one held through the stop) for this long starts reversing.")]
		[SerializeField]
		[Min(0f)]
		private float reverseEngageDelay = 0.15f;

		[SerializeField]
		[Range(0f, 0.5f)]
		private float triggerDeadzone = 0.08f;

		[Header("Steering")]
		[Tooltip("Steered-wheel angle at full wheel lock, degrees.")]
		[SerializeField]
		[Range(5f, 60f)]
		private float maxSteerAngle = 35f;

		[Tooltip("True: rear wheels steer, pivot at the front axle (real forklift). False: front steer, pivot at the rear axle.")]
		[SerializeField]
		private bool steerRearWheels = true;

		[Header("Ground")]
		[Tooltip("Layers the wheels ride on and the body sweeps against. Dynamic rigidbodies are always ignored.")]
		[SerializeField]
		private LayerMask groundMask = 1;

		[Tooltip("How far below a hub (beyond the wheel radius) ground still counts as under the wheel. Past this the truck is airborne and falls.")]
		[SerializeField]
		[Min(0.05f)]
		private float groundProbeExtra = 0.6f;

		[Tooltip("Height / pitch / roll follow rate (1/s). Higher = snappier over bumps.")]
		[SerializeField]
		[Min(1f)]
		private float suspensionFollowRate = 12f;

		[SerializeField]
		[Range(0f, 30f)]
		private float maxTiltDegrees = 20f;

		[Header("Blocking")]
		[Tooltip("Body sweep box in root-local space. Keep the bottom above kerb height so kerbs don't count as walls.")]
		[SerializeField]
		private Vector3 bodyBoxCenter = new Vector3(0f, 0.3f, 0.1f);

		[SerializeField]
		private Vector3 bodyBoxSize = new Vector3(1.5f, 1.3f, 2.6f);

		[Tooltip("Fork sweep box in fork-rig-local space (the tines).")]
		[SerializeField]
		private Vector3 forkBoxCenter = new Vector3(0f, 0.02f, 0.85f);

		[SerializeField]
		private Vector3 forkBoxSize = new Vector3(0.55f, 0.04f, 1.5f);

		[SerializeField]
		[Min(0.005f)]
		private float sweepSkin = 0.04f;

		[Header("Fork")]
		[Tooltip("Lowest fork-rig local Y offset from its authored position (tines just off the ground).")]
		[SerializeField]
		private float forkMinOffset = -0.95f;

		[Tooltip("Highest fork-rig local Y offset from its authored position (carriage at the top of the mast).")]
		[SerializeField]
		private float forkMaxOffset = 0.29f;

		[SerializeField]
		[Min(0.05f)]
		private float liftSpeedUp = 0.35f;

		[SerializeField]
		[Min(0.05f)]
		private float liftSpeedDown = 0.45f;

		[Tooltip("If true the lever only works with a driver in the seat.")]
		[SerializeField]
		private bool liftRequiresDriver;

		private Rigidbody _rb;

		private Rigidbody _forkRb;

		private Vector3 _forkRestLocalPos;

		private Quaternion _forkRestLocalRot;

		private readonly HashSet<Collider> _ownColliders = new HashSet<Collider>();

		private readonly RaycastHit[] _hits = new RaycastHit[16];

		private float _speed;

		private float _steerAngle;

		private float _reverseTimer;

		private bool _reverseArmed = true;

		private float _yaw;

		private float _pitch;

		private float _roll;

		private float _forkOffset;

		private float _verticalVelocity;

		private bool _airborne;

		private Vector3 _pivotAxleLocal;

		private float _wheelbase;

		private float _track;

		private bool _wheelsValid;

		public float Speed => _speed;

		public float SteerAngle => _steerAngle;

		public float ForkOffset => _forkOffset;

		public bool IsAirborne => _airborne;

		public bool HasDriver
		{
			get
			{
				if (seat != null)
				{
					return seat.IsSeated;
				}
				return false;
			}
		}

		public Transform ForkRig => forkRig;

		public Rigidbody Body => _rb;

		Transform IVehicleSeatHost.transform => base.transform;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_rb.isKinematic = true;
			_rb.useGravity = false;
			_rb.interpolation = RigidbodyInterpolation.Interpolate;
			_rb.collisionDetectionMode = CollisionDetectionMode.Discrete;
			CacheWheelGeometry();
			CacheOwnColliders();
			SetupForkRig();
			_yaw = _rb.rotation.eulerAngles.y;
			_pitch = 0f;
			_roll = 0f;
		}

		private void OnDestroy()
		{
			if (forkRig != null && forkRig.parent == null)
			{
				UnityEngine.Object.Destroy(forkRig.gameObject);
			}
		}

		private void CacheWheelGeometry()
		{
			_wheelsValid = wheels != null && wheels.Length == 4;
			if (_wheelsValid)
			{
				for (int i = 0; i < 4; i++)
				{
					if (wheels[i] == null || wheels[i].steerPivot == null || wheels[i].spinPivot == null)
					{
						_wheelsValid = false;
						break;
					}
				}
			}
			if (!_wheelsValid)
			{
				Debug.LogError("[ForkliftController] Needs 4 wheels with steer + spin pivots. Run Tools/Slop-Game/Vehicles/Build Forklift Rig.", this);
				base.enabled = false;
				return;
			}
			Vector3 zero = Vector3.zero;
			Vector3 zero2 = Vector3.zero;
			Vector3 zero3 = Vector3.zero;
			Vector3 zero4 = Vector3.zero;
			for (int j = 0; j < 4; j++)
			{
				WheelSetup wheelSetup = wheels[j];
				wheelSetup.hubLocal = base.transform.InverseTransformPoint(wheelSetup.steerPivot.position);
				if (wheelSetup.isFront)
				{
					zero += wheelSetup.hubLocal * 0.5f;
				}
				else
				{
					zero2 += wheelSetup.hubLocal * 0.5f;
				}
				if (wheelSetup.isLeft)
				{
					zero3 += wheelSetup.hubLocal * 0.5f;
				}
				else
				{
					zero4 += wheelSetup.hubLocal * 0.5f;
				}
			}
			_wheelbase = Mathf.Max(Mathf.Abs(zero.z - zero2.z), 0.3f);
			_track = Mathf.Max(Mathf.Abs(zero4.x - zero3.x), 0.3f);
			_pivotAxleLocal = (steerRearWheels ? zero : zero2);
		}

		private void CacheOwnColliders()
		{
			_ownColliders.Clear();
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(includeInactive: true);
			foreach (Collider item in componentsInChildren)
			{
				_ownColliders.Add(item);
			}
			if (forkRig != null)
			{
				componentsInChildren = forkRig.GetComponentsInChildren<Collider>(includeInactive: true);
				foreach (Collider item2 in componentsInChildren)
				{
					_ownColliders.Add(item2);
				}
			}
		}

		private void SetupForkRig()
		{
			if (!(forkRig == null))
			{
				_forkRestLocalPos = base.transform.InverseTransformPoint(forkRig.position);
				_forkRestLocalRot = Quaternion.Inverse(base.transform.rotation) * forkRig.rotation;
				_forkRb = forkRig.GetComponent<Rigidbody>();
				if (_forkRb == null)
				{
					_forkRb = forkRig.gameObject.AddComponent<Rigidbody>();
				}
				_forkRb.isKinematic = true;
				_forkRb.useGravity = false;
				_forkRb.interpolation = RigidbodyInterpolation.Interpolate;
				forkRig.SetParent(null, worldPositionStays: true);
			}
		}

		private void ReadInput(out float throttle, out float brake, out float steer01, out float lift)
		{
			throttle = 0f;
			brake = 0f;
			lift = 0f;
			steer01 = ((steeringWheel != null) ? steeringWheel.Steer01 : 0f);
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				throttle = Deadzone(instance.RightTriggerValue);
				brake = Deadzone(instance.LeftTriggerValue);
			}
			if (liftLever != null)
			{
				lift = liftLever.Value;
			}
		}

		private float Deadzone(float v)
		{
			if (v <= triggerDeadzone)
			{
				return 0f;
			}
			return Mathf.InverseLerp(triggerDeadzone, 1f, v);
		}

		private void FixedUpdate()
		{
			if (!_wheelsValid)
			{
				return;
			}
			float fixedDeltaTime = Time.fixedDeltaTime;
			ReadInput(out var throttle, out var brake, out var steer, out var lift);
			bool hasDriver = HasDriver;
			if (liftRequiresDriver && !hasDriver)
			{
				lift = 0f;
			}
			if (hasDriver)
			{
				UpdateSpeed(throttle, brake, fixedDeltaTime);
			}
			else
			{
				_reverseTimer = 0f;
				_speed = Mathf.MoveTowards(_speed, 0f, brakeDeceleration * fixedDeltaTime);
			}
			_steerAngle = steer * maxSteerAngle;
			Vector3 position = _rb.position;
			Quaternion rotation = _rb.rotation;
			Quaternion quaternion = Quaternion.Euler(0f, _yaw, 0f);
			Vector3 vector = quaternion * Vector3.forward;
			Vector3 vector2 = position + quaternion * _pivotAxleLocal;
			float num = 0f;
			if (Mathf.Abs(_speed) > 0.0001f)
			{
				num = _speed / _wheelbase * Mathf.Tan(_steerAngle * (MathF.PI / 180f));
			}
			Vector3 vector3 = vector * (_speed * fixedDeltaTime);
			float num2 = num * fixedDeltaTime * 57.29578f;
			float magnitude = vector3.magnitude;
			if (magnitude > 1E-06f)
			{
				Vector3 vector4 = vector3 / magnitude;
				if (Sweep(position, rotation, vector4, magnitude, out var allowed))
				{
					_speed = 0f;
					vector3 = vector4 * allowed;
				}
			}
			_yaw += num2;
			if (_yaw > 360f)
			{
				_yaw -= 360f;
			}
			else if (_yaw < -360f)
			{
				_yaw += 360f;
			}
			FollowGround(vector2 + vector3, Quaternion.Euler(0f, _yaw, 0f), fixedDeltaTime, out var newRot, out var newPos);
			_rb.MovePosition(newPos);
			_rb.MoveRotation(newRot);
			if (_forkRb != null)
			{
				if (lift > 0f)
				{
					_forkOffset += lift * liftSpeedUp * fixedDeltaTime;
				}
				else if (lift < 0f)
				{
					_forkOffset += lift * liftSpeedDown * fixedDeltaTime;
				}
				_forkOffset = Mathf.Clamp(_forkOffset, forkMinOffset, forkMaxOffset);
				_forkRb.MovePosition(newPos + newRot * (_forkRestLocalPos + Vector3.up * _forkOffset));
				_forkRb.MoveRotation(newRot * _forkRestLocalRot);
			}
		}

		private void UpdateSpeed(float throttle, float brake, float dt)
		{
			if (throttle > 0f)
			{
				_reverseTimer = 0f;
				if (_speed < 0f)
				{
					_speed = Mathf.MoveTowards(_speed, 0f, brakeDeceleration * dt);
					return;
				}
				float num = maxForwardSpeed * throttle;
				float num2 = ((num > _speed) ? acceleration : coastDeceleration);
				_speed = Mathf.MoveTowards(_speed, num, num2 * dt);
			}
			else if (brake > 0f)
			{
				if (_speed > 0.02f)
				{
					_reverseTimer = 0f;
					_reverseArmed = false;
					_speed = Mathf.MoveTowards(_speed, 0f, brakeDeceleration * brake * dt);
					return;
				}
				if (_speed >= -0.02f)
				{
					if (!_reverseArmed)
					{
						_speed = 0f;
						return;
					}
					_reverseTimer += dt;
					if (_reverseTimer < reverseEngageDelay)
					{
						_speed = 0f;
						return;
					}
				}
				_speed = Mathf.MoveTowards(_speed, (0f - brake) * maxReverseSpeed, acceleration * dt);
			}
			else
			{
				_reverseTimer = 0f;
				_speed = Mathf.MoveTowards(_speed, 0f, coastDeceleration * dt);
				if (Mathf.Abs(_speed) < 0.02f)
				{
					_reverseArmed = true;
				}
			}
		}

		private bool Sweep(Vector3 pos, Quaternion rot, Vector3 dir, float dist, out float allowed)
		{
			allowed = dist;
			bool result = false;
			if (BoxSweep(pos + rot * bodyBoxCenter, bodyBoxSize * 0.5f, rot, dir, dist + sweepSkin, out var hitDist))
			{
				result = true;
				allowed = Mathf.Min(allowed, Mathf.Max(0f, hitDist - sweepSkin));
			}
			if (_forkRb != null)
			{
				Quaternion quaternion = rot * _forkRestLocalRot;
				Vector3 vector = pos + rot * (_forkRestLocalPos + Vector3.up * _forkOffset);
				if (BoxSweep(vector + quaternion * forkBoxCenter, forkBoxSize * 0.5f, quaternion, dir, dist + sweepSkin, out hitDist))
				{
					result = true;
					allowed = Mathf.Min(allowed, Mathf.Max(0f, hitDist - sweepSkin));
				}
			}
			return result;
		}

		private bool BoxSweep(Vector3 center, Vector3 halfExtents, Quaternion rot, Vector3 dir, float dist, out float hitDist)
		{
			hitDist = dist;
			int num = Physics.BoxCastNonAlloc(center, halfExtents, dir, _hits, rot, dist, groundMask, QueryTriggerInteraction.Ignore);
			bool result = false;
			for (int i = 0; i < num; i++)
			{
				RaycastHit raycastHit = _hits[i];
				if (!_ownColliders.Contains(raycastHit.collider))
				{
					Rigidbody rigidbody = raycastHit.rigidbody;
					if ((!(rigidbody != null) || rigidbody.isKinematic) && raycastHit.distance < hitDist)
					{
						result = true;
						hitDist = raycastHit.distance;
					}
				}
			}
			return result;
		}

		private bool GroundUnderHub(Vector3 hubWorld, float radius, out float groundY)
		{
			groundY = 0f;
			int num = Physics.RaycastNonAlloc(hubWorld + Vector3.up * 0.1f, Vector3.down, _hits, groundProbeExtra + radius + 0.1f, groundMask, QueryTriggerInteraction.Ignore);
			if (num <= 0)
			{
				return false;
			}
			float num2 = float.MaxValue;
			for (int i = 0; i < num; i++)
			{
				RaycastHit raycastHit = _hits[i];
				if (!_ownColliders.Contains(raycastHit.collider))
				{
					Rigidbody rigidbody = raycastHit.rigidbody;
					if ((!(rigidbody != null) || rigidbody.isKinematic) && raycastHit.distance < num2)
					{
						num2 = raycastHit.distance;
						groundY = raycastHit.point.y;
					}
				}
			}
			return num2 != float.MaxValue;
		}

		private void FollowGround(Vector3 pivotWorld, Quaternion yawRot, float dt, out Quaternion newRot, out Vector3 newPos)
		{
			Vector3 vector = pivotWorld - yawRot * _pivotAxleLocal;
			float num = 0f;
			float num2 = 0f;
			float num3 = 0f;
			float num4 = 0f;
			float num5 = 0f;
			bool flag = true;
			for (int i = 0; i < 4; i++)
			{
				WheelSetup wheelSetup = wheels[i];
				if (!GroundUnderHub(vector + yawRot * wheelSetup.hubLocal, wheelSetup.radius, out var groundY))
				{
					flag = false;
					break;
				}
				float num6 = groundY + wheelSetup.radius - wheelSetup.hubLocal.y;
				num += num6;
				if (wheelSetup.isFront)
				{
					num2 += num6 * 0.5f;
				}
				else
				{
					num3 += num6 * 0.5f;
				}
				if (wheelSetup.isLeft)
				{
					num4 += num6 * 0.5f;
				}
				else
				{
					num5 += num6 * 0.5f;
				}
			}
			float num7 = 1f - Mathf.Exp((0f - suspensionFollowRate) * dt);
			Vector3 position = _rb.position;
			float y;
			if (flag)
			{
				_airborne = false;
				_verticalVelocity = 0f;
				float b = Mathf.Clamp(Mathf.Atan2(num3 - num2, _wheelbase) * 57.29578f, 0f - maxTiltDegrees, maxTiltDegrees);
				float b2 = Mathf.Clamp(Mathf.Atan2(num5 - num4, _track) * 57.29578f, 0f - maxTiltDegrees, maxTiltDegrees);
				_pitch = Mathf.Lerp(_pitch, b, num7);
				_roll = Mathf.Lerp(_roll, b2, num7);
				float num8 = num * 0.25f;
				float t = ((num8 > position.y) ? (num7 * 2f) : num7);
				newRot = Quaternion.Euler(_pitch, _yaw, _roll);
				y = Mathf.Lerp(position.y, num8, t);
			}
			else
			{
				_airborne = true;
				_verticalVelocity += Physics.gravity.y * dt;
				_pitch = Mathf.Lerp(_pitch, 0f, num7);
				_roll = Mathf.Lerp(_roll, 0f, num7);
				newRot = Quaternion.Euler(_pitch, _yaw, _roll);
				y = position.y + _verticalVelocity * dt;
			}
			newPos = new Vector3(vector.x, y, vector.z);
		}

		private void Update()
		{
			if (!_wheelsValid)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			for (int i = 0; i < 4; i++)
			{
				WheelSetup wheelSetup = wheels[i];
				if (steerRearWheels)
				{
					if (!wheelSetup.isFront)
					{
						wheelSetup.steerPivot.localRotation = Quaternion.Euler(0f, 0f - _steerAngle, 0f);
					}
				}
				else if (wheelSetup.isFront)
				{
					wheelSetup.steerPivot.localRotation = Quaternion.Euler(0f, _steerAngle, 0f);
				}
				if (wheelSetup.radius > 0.01f)
				{
					wheelSetup.spinDegrees += _speed * deltaTime / wheelSetup.radius * 57.29578f;
					if (wheelSetup.spinDegrees > 360f)
					{
						wheelSetup.spinDegrees -= 360f;
					}
					else if (wheelSetup.spinDegrees < -360f)
					{
						wheelSetup.spinDegrees += 360f;
					}
					wheelSetup.spinPivot.localRotation = Quaternion.AngleAxis(wheelSetup.spinDegrees, Vector3.right);
				}
			}
		}

		public void KillMotion()
		{
			_speed = 0f;
			_reverseTimer = 0f;
			_reverseArmed = false;
		}

		public bool IsOwnCollider(Collider c)
		{
			return _ownColliders.Contains(c);
		}

		public void OnDriverSeated()
		{
		}

		public void OnDriverLeft()
		{
			_speed = 0f;
			_reverseTimer = 0f;
			_reverseArmed = false;
		}

		public void CollectColliderRoots(List<Transform> roots)
		{
			if (forkRig != null)
			{
				roots.Add(forkRig);
			}
		}
	}
}
