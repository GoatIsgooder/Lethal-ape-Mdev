using UnityEngine;

namespace Locomotion.Scripts
{
	[RequireComponent(typeof(Rigidbody))]
	public class MechArm : MonoBehaviour
	{
		[Header("Refs")]
		[Tooltip("The arm's own Rigidbody (auto-filled).")]
		public Rigidbody body;

		[Tooltip("The frame the mapping is computed in — the cockpit/torso. Falls back to restPose.parent, then WORLD (never the arm itself).")]
		public Transform cockpit;

		[Tooltip("Where the arm idles when no hand drives it. Out in front of the cockpit on this side — the visible reach.")]
		public Transform restPose;

		[Tooltip("The point the climb system grips the world at (the fist). Defaults to this transform.")]
		public Transform gripPoint;

		[Header("Mapping")]
		[Tooltip("Hand-to-arm position scale. 1 = 1:1. ~2 gives a longer reach so a normal arm-down plants the fist on the floor.")]
		public float positionGain = 2f;

		[Tooltip("Hand-to-arm rotation scale. 1 = the arm twists exactly as much as your wrist.")]
		public float rotationGain = 1f;

		[Header("PID — position")]
		[Tooltip("Shapes the final-approach settle. The punch/arm WEIGHT is set by maxForce / mass, not this.")]
		public float positionFrequency = 8f;

		[Range(0.2f, 2f)]
		public float positionDamping = 1f;

		[Tooltip("Cap on motor force (N). The weight knob: maxForce / mass = the arm's max acceleration.")]
		public float maxForce = 600f;

		[Header("PID — rotation")]
		public float rotationFrequency = 10f;

		[Range(0.2f, 2f)]
		public float rotationDamping = 1f;

		[Tooltip("Cap on angular acceleration (rad/s^2).")]
		public float maxAngularAccel = 40f;

		[Header("PC test (right-click ▸ Test Punch in Play mode)")]
		public float testPunchDuration = 0.25f;

		public float testPunchReach = 0.6f;

		private bool _engaged;

		private Transform _command;

		private Vector3 _neutralLocalPos;

		private Quaternion _neutralLocalRot;

		private float _testPunchTimer;

		public Transform GripPoint
		{
			get
			{
				if (!(gripPoint != null))
				{
					return base.transform;
				}
				return gripPoint;
			}
		}

		public bool Engaged => _engaged;

		private Transform Frame
		{
			get
			{
				Transform transform = ((cockpit != null) ? cockpit : ((restPose != null) ? restPose.parent : null));
				if (!(transform == base.transform))
				{
					return transform;
				}
				return null;
			}
		}

		private void Reset()
		{
			body = GetComponent<Rigidbody>();
		}

		private void Awake()
		{
			if (body == null)
			{
				body = GetComponent<Rigidbody>();
			}
			if (gripPoint == null)
			{
				gripPoint = base.transform;
			}
			if (body != null)
			{
				body.useGravity = false;
			}
		}

		public void Engage(Transform commandPose)
		{
			_command = commandPose;
			_engaged = commandPose != null;
			if (_engaged)
			{
				Transform frame = Frame;
				_neutralLocalPos = ToLocalPoint(frame, commandPose.position);
				_neutralLocalRot = Quaternion.Inverse(FrameRot(frame)) * commandPose.rotation;
			}
		}

		public void Disengage()
		{
			_engaged = false;
			_command = null;
		}

		private void FixedUpdate()
		{
			if (!(body == null) && !(restPose == null))
			{
				float fixedDeltaTime = Time.fixedDeltaTime;
				ComputeTarget(out var pos, out var rot);
				Vector3 vector = PidSpring.PositionAcceleration(body.position, pos, body.linearVelocity, positionFrequency, positionDamping, fixedDeltaTime) * body.mass;
				vector = Vector3.ClampMagnitude(vector, maxForce);
				body.AddForce(vector, ForceMode.Force);
				Vector3 vector2 = PidSpring.RotationAcceleration(body.rotation, rot, body.angularVelocity, rotationFrequency, rotationDamping, fixedDeltaTime);
				vector2 = Vector3.ClampMagnitude(vector2, maxAngularAccel);
				body.AddTorque(vector2, ForceMode.Acceleration);
			}
		}

		private void ComputeTarget(out Vector3 pos, out Quaternion rot)
		{
			Transform frame = Frame;
			Quaternion quaternion = FrameRot(frame);
			Vector3 vector = ToLocalPoint(frame, restPose.position);
			Quaternion quaternion2 = Quaternion.Inverse(quaternion) * restPose.rotation;
			if (_testPunchTimer > 0f)
			{
				_testPunchTimer -= Time.fixedDeltaTime;
				vector += Vector3.forward * testPunchReach;
			}
			if (_engaged && _command != null)
			{
				Vector3 vector2 = (ToLocalPoint(frame, _command.position) - _neutralLocalPos) * positionGain;
				Quaternion b = Quaternion.Inverse(quaternion) * _command.rotation * Quaternion.Inverse(_neutralLocalRot);
				vector += vector2;
				quaternion2 = Quaternion.SlerpUnclamped(Quaternion.identity, b, rotationGain) * quaternion2;
			}
			pos = ToWorldPoint(frame, vector);
			rot = quaternion * quaternion2;
		}

		private static Vector3 ToLocalPoint(Transform f, Vector3 wp)
		{
			if (!(f != null))
			{
				return wp;
			}
			return f.InverseTransformPoint(wp);
		}

		private static Vector3 ToWorldPoint(Transform f, Vector3 lp)
		{
			if (!(f != null))
			{
				return lp;
			}
			return f.TransformPoint(lp);
		}

		private static Quaternion FrameRot(Transform f)
		{
			if (!(f != null))
			{
				return Quaternion.identity;
			}
			return f.rotation;
		}

		[ContextMenu("Test Punch")]
		private void TestPunch()
		{
			_testPunchTimer = testPunchDuration;
		}

		private void OnDrawGizmosSelected()
		{
			if (restPose != null)
			{
				Gizmos.color = Color.cyan;
				Gizmos.DrawWireSphere(restPose.position, 0.1f);
				Gizmos.DrawLine(base.transform.position, restPose.position);
			}
		}
	}
}
