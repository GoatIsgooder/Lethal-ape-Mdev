using System.Reflection;
using UnityEngine;

namespace GorillaLocomotion
{
	[DefaultExecutionOrder(-200)]
	[DisallowMultipleComponent]
	[RequireComponent(typeof(Rigidbody))]
	[Obfuscation(Exclude = true)]
	public class MovingPlatform : MonoBehaviour
	{
		public enum PathMode
		{
			Direction = 0,
			Waypoints = 1
		}

		[Tooltip("Direction: travel 'distance' along localMoveDirection. Waypoints: visit each waypoint in order.")]
		public PathMode pathMode;

		public Vector3 localMoveDirection = Vector3.forward;

		[Min(0f)]
		public float distance = 3f;

		public Transform[] waypoints;

		[Header("Motion")]
		[Min(0.01f)]
		public float speed = 1.5f;

		[Tooltip("m/s². Keep it gentle: riders feel every change of speed in VR.")]
		[Min(0.01f)]
		public float acceleration = 2f;

		[Tooltip("Back and forth along the path. Off: loop from the last point back to the first.")]
		public bool pingPong = true;

		[Min(0f)]
		public float pauseAtEnds = 0.5f;

		[Header("Rotation")]
		public bool rotate;

		public Vector3 rotationAxis = Vector3.up;

		[Tooltip("Degrees per second.")]
		public float rotationSpeed = 45f;

		[Tooltip("Posed by another script through MoveNow (e.g. Elevator); the path above is ignored.")]
		public bool externallyDriven;

		private const float TeleportDistance = 2f;

		private Rigidbody _body;

		private Vector3[] _stops;

		private int[] _legFrom;

		private int[] _legTo;

		private TravelProfile[] _legs;

		private double _cycle;

		private Quaternion _baseRotation;

		public Vector3 Velocity { get; private set; }

		public static int ActiveCount { get; private set; }

		public Rigidbody Body => _body;

		private void Awake()
		{
			_body = GetComponent<Rigidbody>();
			_body.isKinematic = true;
			_body.useGravity = false;
			_body.interpolation = RigidbodyInterpolation.None;
			_baseRotation = transform.rotation;
			BuildPath();
		}

		private void OnEnable()
		{
			ActiveCount++;
		}

		private void OnDisable()
		{
			ActiveCount--;
			Velocity = Vector3.zero;
		}

		public void BuildPath()
		{
			_stops = CollectStops();
			int stopCount = _stops.Length;
			int legCount = ((stopCount >= 2) ? (pingPong ? (stopCount * 2 - 2) : stopCount) : 0);
			_legFrom = new int[legCount];
			_legTo = new int[legCount];
			_legs = new TravelProfile[legCount];
			_cycle = 0.0;
			for (int i = 0; i < legCount; i++)
			{
				int from;
				int to;
				if (pingPong)
				{
					if (i < stopCount - 1)
					{
						from = i;
						to = i + 1;
					}
					else
					{
						from = 2 * (stopCount - 1) - i;
						to = from - 1;
					}
				}
				else
				{
					from = i;
					to = (i + 1) % stopCount;
				}
				_legFrom[i] = from;
				_legTo[i] = to;
				_legs[i] = new TravelProfile(Vector3.Distance(_stops[from], _stops[to]), speed, acceleration);
				_cycle += _legs[i].Duration + pauseAtEnds;
			}
		}

		private Vector3[] CollectStops()
		{
			if (pathMode == PathMode.Waypoints && waypoints != null)
			{
				int count = 0;
				for (int i = 0; i < waypoints.Length; i++)
				{
					if (waypoints[i] != null)
					{
						count++;
					}
				}
				if (count >= 2)
				{
					Vector3[] stops = new Vector3[count];
					int index = 0;
					for (int j = 0; j < waypoints.Length; j++)
					{
						if (waypoints[j] != null)
						{
							stops[index++] = waypoints[j].position;
						}
					}
					return stops;
				}
			}
			Vector3 position = transform.position;
			return new Vector3[2]
			{
				position,
				position + Direction() * distance
			};
		}

		private Vector3 Direction()
		{
			if (localMoveDirection.sqrMagnitude > 0f)
			{
				return transform.rotation * localMoveDirection.normalized;
			}
			return transform.forward;
		}

		private void Update()
		{
			if (externallyDriven)
			{
				return;
			}
			double now = PlatformClock.Now;
			if (_legs.Length != 0)
			{
				MoveNow(PoseAt(now));
			}
			else
			{
				Velocity = Vector3.zero;
			}
			if (rotate)
			{
				Vector3 axis = ((rotationAxis.sqrMagnitude > 0f) ? rotationAxis.normalized : Vector3.up);
				float angle = (float)(now * (double)rotationSpeed % 360.0);
				transform.rotation = _baseRotation * Quaternion.AngleAxis(angle, axis);
			}
		}

		public Vector3 PoseAt(double time)
		{
			if (_legs.Length == 0 || _cycle <= 0.0)
			{
				if (_stops.Length == 0)
				{
					return transform.position;
				}
				return _stops[0];
			}
			float t = (float)(time % _cycle);
			if (t < 0f)
			{
				t += (float)_cycle;
			}
			for (int i = 0; i < _legs.Length; i++)
			{
				TravelProfile leg = _legs[i];
				Vector3 from = _stops[_legFrom[i]];
				Vector3 to = _stops[_legTo[i]];
				if (t < leg.Duration)
				{
					if (leg.Distance > 0f)
					{
						return Vector3.LerpUnclamped(from, to, leg.DistanceAt(t) / leg.Distance);
					}
					return from;
				}
				t -= leg.Duration;
				if (t < pauseAtEnds)
				{
					return to;
				}
				t -= pauseAtEnds;
			}
			return _stops[_legFrom[0]];
		}

		public void MoveNow(Vector3 target)
		{
			Vector3 delta = target - transform.position;
			transform.position = target;
			float deltaTime = Time.deltaTime;
			Velocity = ((delta.sqrMagnitude <= TeleportDistance * TeleportDistance && deltaTime > 0f) ? (delta / deltaTime) : Vector3.zero);
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = Color.cyan;
			if (pathMode == PathMode.Waypoints && waypoints != null)
			{
				for (int i = 0; i + 1 < waypoints.Length; i++)
				{
					if (waypoints[i] != null && waypoints[i + 1] != null)
					{
						Gizmos.DrawLine(waypoints[i].position, waypoints[i + 1].position);
					}
				}
			}
			else
			{
				Vector3 start = ((Application.isPlaying && _stops != null && _stops.Length != 0) ? _stops[0] : transform.position);
				Gizmos.DrawLine(start, start + Direction() * distance);
			}
		}
	}
}
