using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmZipline : MonoBehaviour
	{
		[Header("Path")]
		[SerializeField]
		private Transform[] waypoints;

		[Tooltip("Catmull-Rom through the waypoints. Off = straight segments with hard corners.")]
		[SerializeField]
		private bool smooth = true;

		[SerializeField]
		[Min(0.05f)]
		private float sampleSpacing = 0.2f;

		[Header("Visuals")]
		[SerializeField]
		private LineRenderer beam;

		[SerializeField]
		private Transform endOrbA;

		[SerializeField]
		private Transform endOrbB;

		[Tooltip("Orb that glides along the beam while nobody rides it.")]
		[SerializeField]
		private Transform traveller;

		[SerializeField]
		private float travellerSpeed = 1.4f;

		[Tooltip("Rides at your grip point while you hold the beam.")]
		[SerializeField]
		private Transform riderBead;

		[SerializeField]
		private ParticleSystem riderSparks;

		[SerializeField]
		private ParticleSystem grabFlash;

		[Header("Grab")]
		[SerializeField]
		private float grabRadius = 0.15f;

		[SerializeField]
		[Range(0.3f, 1f)]
		private float gripThreshold = 0.7f;

		[SerializeField]
		[Range(0f, 0.3f)]
		private float releaseHysteresis = 0.12f;

		[Header("Ride (comfort-capped)")]
		[SerializeField]
		[Min(0.5f)]
		private float maxSpeed = 4f;

		[SerializeField]
		[Min(0.5f)]
		private float acceleration = 3.5f;

		[SerializeField]
		[Min(0.5f)]
		private float braking = 6f;

		[Tooltip("Sideways acceleration allowed through bends; sets the corner speed limit.")]
		[SerializeField]
		[Min(0.5f)]
		private float cornerGrip = 5f;

		[SerializeField]
		[Min(0.1f)]
		private float minCornerSpeed = 1.1f;

		[SerializeField]
		[Min(0.2f)]
		private float endBrakeDistance = 1.4f;

		[Tooltip("Facing within this dot of perpendicular gives no drive (you coast).")]
		[SerializeField]
		[Range(0f, 0.6f)]
		private float facingDeadzone = 0.15f;

		[SerializeField]
		[Min(1f)]
		private float pull = 12f;

		[SerializeField]
		[Min(0.5f)]
		private float maxCorrection = 4f;

		[SerializeField]
		[Range(0f, 1f)]
		private float vignetteAtMaxSpeed = 0.5f;

		[Tooltip("Letting go and grabbing back on (or onto another line) within this many seconds keeps your speed.")]
		[SerializeField]
		[Min(0f)]
		private float carryWindow = 1f;

		[Tooltip("Speed along the line below this counts as standing still: you start from zero toward where you look.")]
		[SerializeField]
		[Min(0f)]
		private float carryMinSpeed = 0.5f;

		[Header("Feedback")]
		[SerializeField]
		private AudioSource rollLoop;

		[SerializeField]
		private AudioClip latchClip;

		[SerializeField]
		private AudioClip endClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float clipVolume = 0.6f;

		[SerializeField]
		[Range(0f, 0.5f)]
		private float rideHaptic = 0.12f;

		[Tooltip("Bend sharper than this (degrees per metre) gives a haptic thunk as you pass it.")]
		[SerializeField]
		private float cornerThunkAngle = 45f;

		private static BtmZipline _activeRide;

		private static Vector3 _releaseVelocity;

		private static float _releaseTime = -10f;

		private static readonly int BoostId = Shader.PropertyToID("_Boost");

		private static readonly int FlowId = Shader.PropertyToID("_FlowDirection");

		private Vector3[] _pts;

		private float[] _dist;

		private float[] _vmax;

		private float[] _bend;

		private float _length;

		private readonly bool[] _gripWasDown = new bool[2];

		private BtmHand _hand;

		private float _s;

		private float _speed;

		private int _dir = 1;

		private bool _atEnd;

		private int _lastSample;

		private float _nextHaptic;

		private float _boost;

		private float _travellerS;

		private int _travellerDir = 1;

		private MaterialPropertyBlock _mpb;

		private AudioSource _voice;

		private Bounds _grabBounds;

		public bool IsRiding => _hand != null;

		public static bool AnyRiding => _activeRide != null;

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
			if (rollLoop != null)
			{
				rollLoop.spatialize = false;
				rollLoop.loop = true;
				rollLoop.volume = 0f;
			}
			if (riderBead != null)
			{
				riderBead.gameObject.SetActive(false);
			}
			Rebuild();
		}

		private void OnEnable()
		{
			Player.Teleported += HandleRigTeleported;
		}

		private void OnDisable()
		{
			Player.Teleported -= HandleRigTeleported;
			if (_hand != null)
			{
				EndRide(false);
			}
		}

		private void HandleRigTeleported(Player player)
		{
			if (_hand != null)
			{
				EndRide(false);
			}
		}

		public void Rebuild()
		{
			if (waypoints == null || waypoints.Length < 2)
			{
				return;
			}
			Vector3[] wp = new Vector3[waypoints.Length];
			for (int i = 0; i < wp.Length; i++)
			{
				wp[i] = ((waypoints[i] != null) ? waypoints[i].position : Vector3.zero);
			}
			List<Vector3> pts = new List<Vector3>();
			pts.Add(wp[0]);
			for (int j = 0; j < wp.Length - 1; j++)
			{
				Vector3 p0 = wp[Mathf.Max(j - 1, 0)];
				Vector3 p1 = wp[j];
				Vector3 p2 = wp[j + 1];
				Vector3 p3 = wp[Mathf.Min(j + 2, wp.Length - 1)];
				int n = Mathf.Max(1, Mathf.CeilToInt(Vector3.Distance(p1, p2) / sampleSpacing));
				for (int k = 1; k <= n; k++)
				{
					float t = (float)k / (float)n;
					pts.Add(smooth ? CatmullRom(p0, p1, p2, p3, t) : Vector3.Lerp(p1, p2, t));
				}
			}
			_pts = pts.ToArray();
			_dist = new float[_pts.Length];
			for (int l = 1; l < _pts.Length; l++)
			{
				_dist[l] = _dist[l - 1] + Vector3.Distance(_pts[l - 1], _pts[l]);
			}
			_length = _dist[_pts.Length - 1];
			_bend = new float[_pts.Length];
			_vmax = new float[_pts.Length];
			for (int m = 0; m < _pts.Length; m++)
			{
				Vector3 a = _pts[Mathf.Max(m - 1, 0)];
				Vector3 b = _pts[m];
				Vector3 c = _pts[Mathf.Min(m + 1, _pts.Length - 1)];
				Vector3 d1 = b - a;
				Vector3 d2 = c - b;
				float angle = 0f;
				if (d1.sqrMagnitude > 1E-08f && d2.sqrMagnitude > 1E-08f)
				{
					angle = Vector3.Angle(d1, d2);
				}
				float seg = (d1.magnitude + d2.magnitude) * 0.5f;
				float curvature = ((seg > 0.0001f) ? (angle * Mathf.Deg2Rad / seg) : 0f);
				_bend[m] = ((seg > 0.0001f) ? (angle / seg) : 0f);
				_vmax[m] = ((curvature > 0.0001f) ? Mathf.Clamp(Mathf.Sqrt(cornerGrip / curvature), minCornerSpeed, maxSpeed) : maxSpeed);
			}
			_grabBounds = new Bounds(_pts[0], Vector3.zero);
			Vector3[] array = _pts;
			foreach (Vector3 point in array)
			{
				_grabBounds.Encapsulate(point);
			}
			_grabBounds.Expand(grabRadius * 2f + 0.2f);
			if (beam != null)
			{
				beam.useWorldSpace = true;
				beam.positionCount = _pts.Length;
				beam.SetPositions(_pts);
			}
			if (endOrbA != null)
			{
				endOrbA.position = _pts[0];
			}
			if (endOrbB != null)
			{
				endOrbB.position = _pts[_pts.Length - 1];
			}
		}

		private static Vector3 CatmullRom(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t)
		{
			float t2 = t * t;
			float t3 = t2 * t;
			return 0.5f * (2f * p1 + (-p0 + p2) * t + (2f * p0 - 5f * p1 + 4f * p2 - p3) * t2 + (-p0 + 3f * p1 - 3f * p2 + p3) * t3);
		}

		private int SegmentAt(float s)
		{
			int lo = 0;
			int hi = _dist.Length - 1;
			while (hi - lo > 1)
			{
				int mid = (lo + hi) >> 1;
				if (_dist[mid] <= s)
				{
					lo = mid;
				}
				else
				{
					hi = mid;
				}
			}
			return lo;
		}

		private Vector3 PointAt(float s, out Vector3 tangent)
		{
			int i = SegmentAt(s);
			float seg = _dist[i + 1] - _dist[i];
			float t = ((seg > 1E-05f) ? ((s - _dist[i]) / seg) : 0f);
			tangent = (_pts[i + 1] - _pts[i]).normalized;
			return Vector3.Lerp(_pts[i], _pts[i + 1], t);
		}

		private float Nearest(Vector3 p, out float sqrDist)
		{
			sqrDist = float.MaxValue;
			float best = 0f;
			for (int i = 0; i < _pts.Length - 1; i++)
			{
				Vector3 a = _pts[i];
				Vector3 ab = _pts[i + 1] - a;
				float len2 = ab.sqrMagnitude;
				float t = ((len2 > 1E-08f) ? Mathf.Clamp01(Vector3.Dot(p - a, ab) / len2) : 0f);
				float d = (a + ab * t - p).sqrMagnitude;
				if (d < sqrDist)
				{
					sqrDist = d;
					best = Mathf.Lerp(_dist[i], _dist[i + 1], t);
				}
			}
			return best;
		}

		private float LimitAhead(float s, int dir)
		{
			float horizon = Mathf.Max(_speed * _speed / (2f * braking) + 0.5f, 1.5f);
			float limit = maxSpeed;
			int i = SegmentAt(s);
			float travelled = 0f;
			while (i >= 0 && i < _pts.Length && travelled <= horizon)
			{
				limit = Mathf.Min(limit, Mathf.Sqrt(_vmax[i] * _vmax[i] + 2f * braking * travelled));
				int next = i + dir;
				if (next < 0 || next >= _pts.Length)
				{
					break;
				}
				travelled += Mathf.Abs(_dist[next] - _dist[i]);
				i = next;
			}
			float remaining = ((dir > 0) ? (_length - s) : s);
			return Mathf.Min(limit, maxSpeed * Mathf.Clamp01(remaining / endBrakeDistance));
		}

		private void Update()
		{
			if (_pts == null || (_hand == null && !BtmTechTreeRoom.LocalInTree))
			{
				return;
			}
			if (_hand != null)
			{
				if (!Player.HasInstance || Player.Instance.disableMovement)
				{
					EndRide(false);
				}
				else if (!_hand.Present || _hand.Grip < gripThreshold - releaseHysteresis || _hand.HoldingSomething)
				{
					EndRide(true);
				}
				else
				{
					RideFeedback();
				}
			}
			else if (_activeRide == null && Player.HasInstance && !Player.Instance.disableMovement)
			{
				TryLatch();
			}
			for (int i = 0; i < BtmHands.Count; i++)
			{
				BtmHand hand = BtmHands.At(i);
				_gripWasDown[i] = hand.Present && hand.Grip >= gripThreshold;
			}
			UpdateVisuals();
		}

		private void TryLatch()
		{
			for (int i = 0; i < BtmHands.Count; i++)
			{
				BtmHand hand = BtmHands.At(i);
				if (!hand.Present || hand.HoldingSomething || hand.Grip < gripThreshold || _gripWasDown[i])
				{
					continue;
				}
				Vector3 palm = hand.Palm;
				if (_grabBounds.Contains(palm))
				{
					float s = Nearest(palm, out float sqrDist);
					if (sqrDist <= grabRadius * grabRadius)
					{
						BeginRide(hand, s);
						break;
					}
				}
			}
		}

		private void BeginRide(BtmHand hand, float s)
		{
			_hand = hand;
			hand.Suspend(this);
			_activeRide = this;
			_s = s;
			_atEnd = false;
			_lastSample = SegmentAt(s);
			_boost = 1.5f;
			Vector3 tangent;
			Vector3 point = PointAt(s, out tangent);
			float along = Vector3.Dot(CarriedVelocity(), tangent);
			if (Mathf.Abs(along) < carryMinSpeed)
			{
				_speed = 0f;
				_dir = FacingDir(tangent, _dir);
			}
			else
			{
				_dir = ((along > 0f) ? 1 : (-1));
				_speed = Mathf.Min(Mathf.Abs(along), maxSpeed);
			}
			if (grabFlash != null)
			{
				grabFlash.transform.position = point;
				grabFlash.Play();
			}
			if (latchClip != null)
			{
				_voice.PlayOneShot(latchClip, clipVolume);
			}
			hand.Pulse(0.55f, 0.07f);
			if (riderBead != null)
			{
				riderBead.gameObject.SetActive(true);
			}
			if (riderSparks != null)
			{
				riderSparks.Play();
			}
		}

		private void EndRide(bool keepMomentum)
		{
			Vector3 velocity = Vector3.zero;
			if (_pts != null)
			{
				PointAt(_s, out Vector3 tangent);
				velocity = tangent * (_speed * (float)_dir);
			}
			if (_hand != null)
			{
				_hand.Resume(this);
			}
			_hand = null;
			if (_activeRide == this)
			{
				_activeRide = null;
			}
			_speed = 0f;
			if (rollLoop != null)
			{
				rollLoop.volume = 0f;
			}
			if (riderBead != null)
			{
				riderBead.gameObject.SetActive(false);
			}
			if (riderSparks != null)
			{
				riderSparks.Stop();
			}
			if (BtmScreenFx.Instance != null)
			{
				// RE: unsure - inlined SetEdge with strength 0 drops the tint argument; Color.black assumed (same tint as RideFeedback)
				BtmScreenFx.Instance.SetEdge(Color.black, 0f);
			}
			Rigidbody body = (Player.HasInstance ? Player.Instance.playerRigidBody : null);
			if (!(body == null) && !body.isKinematic)
			{
				if (keepMomentum)
				{
					_releaseVelocity = velocity;
					_releaseTime = Time.time;
				}
				else
				{
					body.linearVelocity = Vector3.zero;
					_releaseTime = -10f;
				}
			}
		}

		private Vector3 CarriedVelocity()
		{
			Rigidbody body = (Player.HasInstance ? Player.Instance.playerRigidBody : null);
			Vector3 current = ((body != null && !body.isKinematic) ? body.linearVelocity : Vector3.zero);
			if (Time.time - _releaseTime > carryWindow)
			{
				return current;
			}
			Vector3 carried = _releaseVelocity + Physics.gravity * (Time.time - _releaseTime);
			if (!(carried.sqrMagnitude > current.sqrMagnitude))
			{
				return current;
			}
			return carried;
		}

		private int FacingDir(Vector3 tangent, int current)
		{
			if (!Player.HasInstance || Player.Instance.headCollider == null)
			{
				return current;
			}
			float facing = Vector3.Dot(tangent, Player.Instance.headCollider.transform.forward);
			if (facing > facingDeadzone)
			{
				return 1;
			}
			if (facing < 0f - facingDeadzone)
			{
				return -1;
			}
			return current;
		}

		private void FixedUpdate()
		{
			if (_hand == null || !_hand.Present || _pts == null || !Player.HasInstance)
			{
				return;
			}
			Rigidbody body = Player.Instance.playerRigidBody;
			if (body == null || body.isKinematic)
			{
				return;
			}
			float dt = Time.fixedDeltaTime;
			PointAt(_s, out Vector3 tangent);
			float facing = ((Player.Instance.headCollider != null) ? Vector3.Dot(Player.Instance.headCollider.transform.forward, tangent) : 1f);
			int want = ((facing > facingDeadzone) ? 1 : ((facing < 0f - facingDeadzone) ? (-1) : 0));
			float drive = Mathf.InverseLerp(facingDeadzone, facingDeadzone + 0.35f, Mathf.Abs(facing));
			if (want != 0 && want != _dir)
			{
				_speed = Mathf.MoveTowards(_speed, 0f, braking * dt);
				if (_speed <= 0.01f)
				{
					_dir = want;
					_atEnd = false;
				}
			}
			else
			{
				float target = ((want == 0) ? 0f : (LimitAhead(_s, _dir) * drive));
				_speed = Mathf.MoveTowards(_speed, target, ((target > _speed) ? acceleration : braking) * dt);
			}
			_s = Mathf.Clamp(_s + _speed * (float)_dir * dt, 0f, _length);
			if (((_dir > 0 && _s >= _length - 0.01f) || (_dir < 0 && _s <= 0.01f)) && !_atEnd)
			{
				_atEnd = true;
				_speed = 0f;
				if (endClip != null)
				{
					_voice.PlayOneShot(endClip, clipVolume);
				}
				_hand.Pulse(0.6f, 0.1f);
				_boost = 1f;
			}
			Vector3 point = PointAt(_s, out tangent);
			Vector3 correction = Vector3.ClampMagnitude(pull * (point - _hand.Palm), maxCorrection);
			body.linearVelocity = correction + tangent * (_speed * (float)_dir);
			int sample = SegmentAt(_s);
			if (sample == _lastSample)
			{
				return;
			}
			int from = Mathf.Min(sample, _lastSample);
			int to = Mathf.Max(sample, _lastSample);
			for (int i = from; i <= to; i++)
			{
				if (_bend[i] >= cornerThunkAngle && _speed > 0.8f)
				{
					_hand.Pulse(Mathf.Clamp01(_speed / maxSpeed * 0.4f + 0.25f), 0.05f);
					_boost = Mathf.Max(_boost, 0.8f);
					break;
				}
			}
			_lastSample = sample;
		}

		private void RideFeedback()
		{
			float k = ((maxSpeed > 0f) ? (_speed / maxSpeed) : 0f);
			if (rollLoop != null)
			{
				rollLoop.volume = Mathf.Lerp(0f, 0.55f, k);
				rollLoop.pitch = Mathf.Lerp(0.8f, 1.3f, k);
				if (!rollLoop.isPlaying)
				{
					rollLoop.Play();
				}
			}
			if (BtmScreenFx.Instance != null)
			{
				BtmScreenFx.Instance.SetEdge(Color.black, k * vignetteAtMaxSpeed);
			}
			if (rideHaptic > 0f && k > 0.05f && Time.time >= _nextHaptic)
			{
				_nextHaptic = Time.time + 0.05f;
				_hand.Pulse(k * rideHaptic, 0.06f);
			}
			if (riderSparks != null)
			{
				ParticleSystem.EmissionModule emission = riderSparks.emission;
				emission.rateOverTimeMultiplier = Mathf.Lerp(4f, 40f, k);
			}
		}

		private void UpdateVisuals()
		{
			float dt = Time.deltaTime;
			_boost = Mathf.MoveTowards(_boost, (_hand != null) ? 0.35f : 0f, dt * 2.5f);
			if (beam != null)
			{
				beam.GetPropertyBlock(_mpb);
				_mpb.SetFloat(BoostId, _boost);
				_mpb.SetFloat(FlowId, (_hand != null) ? ((float)_dir) : 1f);
				beam.SetPropertyBlock(_mpb);
			}
			if (_hand != null)
			{
				if (riderBead != null)
				{
					riderBead.position = PointAt(_s, out Vector3 _);
				}
				if (traveller != null && traveller.gameObject.activeSelf)
				{
					traveller.gameObject.SetActive(false);
				}
			}
			else if (!(traveller == null))
			{
				if (!traveller.gameObject.activeSelf)
				{
					traveller.gameObject.SetActive(true);
				}
				_travellerS += travellerSpeed * (float)_travellerDir * dt;
				if (_travellerS >= _length)
				{
					_travellerS = _length;
					_travellerDir = -1;
				}
				else if (_travellerS <= 0f)
				{
					_travellerS = 0f;
					_travellerDir = 1;
				}
				traveller.position = PointAt(_travellerS, out Vector3 _);
			}
		}

		private void OnDrawGizmos()
		{
			if (waypoints == null)
			{
				return;
			}
			Gizmos.color = new Color(1f, 0.3f, 0.85f, 0.9f);
			for (int i = 0; i < waypoints.Length - 1; i++)
			{
				if (waypoints[i] != null && waypoints[i + 1] != null)
				{
					Gizmos.DrawLine(waypoints[i].position, waypoints[i + 1].position);
				}
			}
		}
	}
}
