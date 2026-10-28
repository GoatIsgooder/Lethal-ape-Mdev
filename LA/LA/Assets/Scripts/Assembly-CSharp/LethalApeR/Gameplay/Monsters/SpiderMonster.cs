using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.AI;

namespace LethalApeR.Gameplay.Monsters
{
	public class SpiderMonster : FOVMonster
	{
		private enum LeapKind : byte
		{
			ToSurface = 0,
			Pounce = 1,
			Drop = 2
		}

		private enum LeapPath : byte
		{
			Arc = 0,
			Rise = 1,
			Dive = 2
		}

		private enum SpiderState : byte
		{
			Ground = 0,
			Crawl = 1,
			Leap = 2,
			Fall = 3
		}

		private enum CrawlIntent : byte
		{
			Chase = 0,
			Direct = 1,
			Patrol = 2,
			Climb = 3,
			Lurk = 4,
			Descend = 5
		}

		private const float PlayerRadius = 0.3f;

		private const float PlayerHeadroom = 0.35f;

		private const float MaxPlayerBody = 1.2f;

		private bool _leaping;

		private LeapKind _leapKind;

		private LeapPath _leapPath;

		private CrawlIntent _leapIntentAfter;

		private Vector3 _leapFrom;

		private Vector3 _leapTo;

		private Vector3 _blendPos;

		private Quaternion _leapFromRot;

		private Quaternion _leapToRot;

		private Quaternion _blendRot;

		private float _leapStart;

		private float _leapAnticipation;

		private float _leapDuration;

		private float _leapApex;

		private Vector3 _fallVelocity;

		private float _fallStart;

		private const float CornerReach = 2.5f;

		private const float RouteRefreshChase = 0.4f;

		private const float RouteRefreshPatrol = 3f;

		private const float TravelStallTime = 3f;

		private NavMeshPath _routePath;

		private readonly Vector3[] _corners = new Vector3[48];

		private int _cornerCount;

		private int _cornerIndex;

		private float _nextRouteRefresh;

		private bool _travelOnWalls;

		private bool _travelChasing;

		private float _cruiseHeight = 3f;

		private int _escalations;

		private int _reclimbs;

		private float _travelBest = float.MaxValue;

		private float _travelBestAt;

		private const float MaxCrawlStep = 0.2f;

		private const float StickDepth = 0.45f;

		private const float WrapDepth = 0.25f;

		private const float FanLift = 0.45f;

		private const float FanSpread = 0.75f;

		private Vector3 _simPos;

		private Vector3 _up = Vector3.up;

		private Vector3 _fwd = Vector3.forward;

		private bool _cornering;

		private Vector3 _fanNormal;

		private Vector3 _fanPoint;

		private float _fanWeight;

		private Vector3 _stuckAnchor;

		private float _stuckTimer;

		[Header("Spider: Surfaces")]
		[Tooltip("Colliders it may walk, climb and leap onto. Rigidbodies and other monsters are always skipped.")]
		[SerializeField]
		private LayerMask surfaceMask = 1;

		[SerializeField]
		private float crawlChaseSpeed = 5.5f;

		[SerializeField]
		private float crawlPatrolSpeed = 2.2f;

		[SerializeField]
		private float crawlTurnSpeed = 300f;

		[Tooltip("How fast (degrees per metre walked) it rolls onto a new surface. Lower = wider, smoother corners.")]
		[SerializeField]
		private float surfaceTurnRate = 110f;

		[Header("Spider: Roaming")]
		[Tooltip("Chance that a patrol leg is travelled on the walls or ceiling instead of the floor.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float surfaceRoamChance = 0.75f;

		[Tooltip("Of the surface legs, the share taken across the ceiling; the rest run along the walls.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float ceilingRoamShare = 0.45f;

		[Tooltip("Height band (metres above the floor) it cruises at when travelling along walls.")]
		[SerializeField]
		private Vector2 wallCruiseHeight = new Vector2(2.2f, 4.5f);

		[SerializeField]
		private Vector2 roamCheckInterval = new Vector2(1.5f, 4f);

		[Tooltip("How far it looks for a wall to climb when it decides to go up.")]
		[SerializeField]
		private float wallSearchRange = 8f;

		[Header("Spider: Leaps")]
		[Tooltip("Highest ceiling it jumps straight up to, measured from the floor it stands on.")]
		[SerializeField]
		private float maxLeapHeight = 12f;

		[Tooltip("Ceilings lower than this above the floor are not worth climbing.")]
		[SerializeField]
		private float minCeilingHeight = 2.6f;

		[Tooltip("Players closer than this on open floor are chased on the floor, not from above.")]
		[SerializeField]
		private float minChaseClimbDistance = 4f;

		[SerializeField]
		private float leapAnticipation = 0.3f;

		[SerializeField]
		private float riseGravity = 26f;

		[SerializeField]
		private float diveGravity = 24f;

		[SerializeField]
		private float arcSpeed = 10f;

		[SerializeField]
		private float climbCooldown = 3f;

		[Header("Spider: Pounce")]
		[Tooltip("The tell before a pounce: it turns to face the victim and crouches. This is the dodge window.")]
		[SerializeField]
		private float pounceAnticipation = 0.35f;

		[SerializeField]
		private float maxDropHeight = 11f;

		[Tooltip("Horizontal reach of a drop from the ceiling = this + Drop Reach Per Metre x drop height, capped.")]
		[SerializeField]
		private float dropReach = 1.5f;

		[SerializeField]
		private float dropReachPerMetre = 0.3f;

		[SerializeField]
		private float maxDropReach = 4.5f;

		[SerializeField]
		private float wallPounceRange = 6.5f;

		[SerializeField]
		private float ledgePounceRange = 5f;

		[Tooltip("A player standing this much higher or lower than the spider, with no navmesh route to them, is climbed to.")]
		[SerializeField]
		private float ledgeHeight = 1f;

		[Tooltip("Body radius (metres) for the catch test against the victim's capsule.")]
		[SerializeField]
		private float killRadius = 0.8f;

		[SerializeField]
		private float missRecoverTime = 0.7f;

		[SerializeField]
		private float maxLead = 1.5f;

		[Header("Spider: Behaviour")]
		[SerializeField]
		private float maxCeilingChaseDistance = 30f;

		[SerializeField]
		private Vector2 lurkTime = new Vector2(2.5f, 5f);

		[SerializeField]
		private float stuckTime = 1.4f;

		[Header("Spider: Presentation")]
		[SerializeField]
		private Animator bodyAnimator;

		[SerializeField]
		private Transform bodyModel;

		[SerializeField]
		private float airborneAnimSpeed = 2.2f;

		[Tooltip("How far (local units) the body dips during a leap's tell and on landing.")]
		[SerializeField]
		private float crouchDepth = 0.2f;

		[SerializeField]
		private AudioSource sfxSource;

		[SerializeField]
		private AudioClip leapClip;

		[SerializeField]
		private AudioClip landClip;

		private const int Floor = 0;

		private const int Wall = 1;

		private const int Ceiling = 2;

		private const float DecisionInterval = 0.2f;

		private const float PounceInterval = 0.1f;

		private const float HangHeight = 1.7f;

		private const float HangConfirm = 0.75f;

		private const float DirectRange = 14f;

		private const float GroundTurnRate = 420f;

		private SpiderState _state;

		private CrawlIntent _intent;

		private float _ride = 0.5f;

		private float _nextDecision;

		private float _nextPounceCheck;

		private float _nextClimbAllowed;

		private float _nextRoamCheck;

		private float _intentSince;

		private float _lurkUntil;

		private float _floorSince = -1f;

		private float _recoverUntil;

		private float _hangSince = -1f;

		private bool _holdingAgent;

		private int _climbFailures;

		private float _lastClimbFailure = -100f;

		private Vector3 _patrolGoal;

		private Vector3 _climbWallPoint;

		private Vector3 _lastTargetPos;

		private Transform _trackedTarget;

		private Vector3 _targetPrevPos;

		private Vector3 _targetVel;

		private Vector3 _homeNav;

		private bool _hasHome;

		private float _lastFloorY = float.NaN;

		private Vector3 _groundAnchor;

		private Vector3 _failedGroundAt;

		private float _groundAnchorAt;

		private float _failedGroundTime = -10f;

		private byte _epoch;

		private byte _netEpoch;

		private SpiderState _netState;

		private bool _awaitEpoch;

		private bool _catchPosePending;

		private bool _catching;

		private float _awaitSince;

		private float _catchPoseAt = -10f;

		private Vector3 _modelRest;

		private Vector3 _lastAnimPos;

		private float _metresToAnimSpeed = 1f;

		private float _landPulse;

		private float _settleUntil;

		private Quaternion _visualRot = Quaternion.identity;

		private NavMeshPath _navPath;

		private readonly Dictionary<EntityId, bool> _colliderIsMonster = new Dictionary<EntityId, bool>();

		private static readonly RaycastHit[] _hits = new RaycastHit[32];

		protected override bool AgentDriven => _state == SpiderState.Ground;

		private static bool IsAuthority => PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom;

		private bool Hunting => CurrentTarget != null && (canSeePlayer || IsTrackingLostPlayer) && !MonsterExclusionZone.Contains(CurrentTarget.position);

		private float ClimbCooldownNow => climbCooldown * ((Time.time - _lastClimbFailure < 30f) ? ((float)_climbFailures + 1f) : 1f);

		private void StartLeap(LeapKind kind, LeapPath path, Vector3 to, Quaternion toRot, float anticipation, CrawlIntent after)
		{
			Vector3 from = transform.position;
			Vector3 up = _state != SpiderState.Ground ? _up : Vector3.up;
			Vector3 dir = Vector3.ProjectOnPlane(to - from, up);
			if (dir.sqrMagnitude < 0.01f)
			{
				dir = Vector3.ProjectOnPlane(transform.forward, up);
			}
			if (dir.sqrMagnitude < 1E-06f)
			{
				dir = Vector3.ProjectOnPlane((Mathf.Abs(up.y) < 0.9f) ? Vector3.up : Vector3.forward, up);
			}
			Quaternion fromRot = Quaternion.LookRotation(dir.normalized, up);
			float duration = LeapDuration(path, from, to);
			float apex = (path == LeapPath.Arc) ? ArcApex(from, to) : 0f;
			DisableAgent();
			_cornering = false;
			_epoch++;
			if (PhotonNetwork.InRoom)
			{
				base.photonView.RPC("RPC_SpiderLeap", RpcTarget.All, (byte)kind, (byte)path, (byte)after, from, fromRot, to, toRot, anticipation, duration, apex, _epoch);
			}
			else
			{
				RPC_SpiderLeap((byte)kind, (byte)path, (byte)after, from, fromRot, to, toRot, anticipation, duration, apex, _epoch);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_SpiderLeap(byte kind, byte path, byte after, Vector3 from, Quaternion fromRot, Vector3 to, Quaternion toRot, float anticipation, float duration, float apex, byte epoch)
		{
			_leaping = true;
			_leapKind = (LeapKind)kind;
			_leapPath = (LeapPath)path;
			_leapIntentAfter = (CrawlIntent)after;
			_leapFrom = from;
			_leapFromRot = fromRot;
			_leapTo = to;
			_leapToRot = toRot;
			_leapAnticipation = Mathf.Max(anticipation, 0.05f);
			_leapDuration = Mathf.Max(duration, 0.05f);
			_leapApex = apex;
			_leapStart = Time.time;
			_blendPos = transform.position;
			_blendRot = transform.rotation;
			_epoch = epoch;
			_awaitEpoch = false;
			_state = SpiderState.Leap;
			_cornering = false;
			PlaySfx(leapClip);
		}

		private void TickLeap(bool master)
		{
			float t = Time.time - _leapStart;
			if (t < _leapAnticipation)
			{
				float k = Smooth01(t / (_leapAnticipation * 0.6f));
				transform.SetPositionAndRotation(Vector3.Lerp(_blendPos, _leapFrom, k), Quaternion.Slerp(_blendRot, _leapFromRot, k));
				return;
			}
			float s = Mathf.Clamp01((t - _leapAnticipation) / _leapDuration);
			Vector3 pos = EvaluateLeap(_leapPath, _leapFrom, _leapTo, _leapApex, s);
			Quaternion rot = Quaternion.Slerp(_leapFromRot, _leapToRot, Smooth01((s - 0.1f) / 0.75f));
			transform.SetPositionAndRotation(pos, rot);
			if (master && _leapKind == LeapKind.Pounce)
			{
				Transform target = base.CurrentTarget;
				if (CanCatch(target) && BodyTouches(target, 1f))
				{
					Catch(target);
					return;
				}
			}
			if (s >= 1f)
			{
				FinishLeap(master);
			}
		}

		private void FinishLeap(bool master)
		{
			_leaping = false;
			RaycastHit hit;
			transform.SetPositionAndRotation(_leapTo, _leapToRot);
			_landPulse = 1f;
			PlaySfx(landClip);
			if (!master)
			{
				_awaitEpoch = true;
				_state = (_leapKind == LeapKind.ToSurface) ? SpiderState.Crawl : SpiderState.Ground;
				_awaitSince = Time.time;
				return;
			}
			Vector3 up = _leapToRot * Vector3.up;
			Vector3 fwd = _leapToRot * Vector3.forward;
			if (_leapKind == LeapKind.Pounce)
			{
				Transform target = base.CurrentTarget;
				if (CanCatch(target) && BodyTouches(target, 1.3f))
				{
					Catch(target);
					return;
				}
				_nextClimbAllowed = Time.time + ClimbCooldownNow;
				_nextPounceCheck = Time.time + missRecoverTime;
			}
			else if (_leapKind == LeapKind.ToSurface)
			{
				EnterSurface(_leapTo, up, fwd, _leapIntentAfter);
				return;
			}
			if (EnterGround(_leapTo - up * _ride, fwd))
			{
				if (_leapKind == LeapKind.Pounce)
				{
					_recoverUntil = Time.time + missRecoverTime;
					SetAgentHeld(true);
				}
			}
			else if (CastSurface(_leapTo, -up, _ride + 0.3f, out hit))
			{
				EnterSurface(_leapTo, up, fwd, Hunting ? CrawlIntent.Direct : CrawlIntent.Descend);
			}
			else
			{
				StartFall();
			}
		}

		private void EnterSurface(Vector3 pos, Vector3 up, Vector3 fwd, CrawlIntent intent)
		{
			_simPos = pos;
			_up = up;
			_fwd = fwd;
			_cornering = false;
			Orthonormalise();
			SetState(SpiderState.Crawl);
			SetIntent(intent);
		}

		private float LeapDuration(LeapPath path, Vector3 from, Vector3 to)
		{
			float dy = Mathf.Abs(to.y - from.y);
			switch (path)
			{
			case LeapPath.Rise:
				return Mathf.Clamp(Mathf.Sqrt(2f * dy / riseGravity), 0.3f, 1.2f);
			case LeapPath.Dive:
				return Mathf.Clamp(Mathf.Sqrt(2f * dy / diveGravity), 0.25f, 1.1f);
			default:
				return Mathf.Clamp(Vector3.Distance(from, to) / arcSpeed, 0.3f, 0.9f);
			}
		}

		private static float ArcApex(Vector3 from, Vector3 to)
		{
			return Vector3.Distance(from, to) * 0.08f + 0.4f + Mathf.Max(0f, to.y - from.y) * 0.5f;
		}

		private static Vector3 EvaluateLeap(LeapPath path, Vector3 a, Vector3 b, float apex, float s)
		{
			switch (path)
			{
			case LeapPath.Rise:
				return Vector3.Lerp(a, b, 1f - (1f - s) * (1f - s));
			case LeapPath.Dive:
			{
				float k = 1f - (1f - s) * (1f - s);
				return new Vector3(Mathf.Lerp(a.x, b.x, k), Mathf.Lerp(a.y, b.y, s * s), Mathf.Lerp(a.z, b.z, k));
			}
			default:
				return Vector3.Lerp(a, b, s) + Vector3.up * (4f * s * (1f - s) * apex);
			}
		}

		private bool ArcClear(LeapPath path, Vector3 from, Vector3 to, float apex)
		{
			Vector3 prev = from;
			for (int i = 1; i <= 6; i++)
			{
				Vector3 p = EvaluateLeap(path, from, to, apex, (float)i / 6f);
				if (SphereBlocked(prev, p) || MonsterExclusionZone.Entering(prev, p))
				{
					return false;
				}
				prev = p;
			}
			return true;
		}

		private bool TryPounce(bool relaxed)
		{
			Transform target = base.CurrentTarget;
			RaycastHit hit;
			if (target == null || base.IsFrozen || base.IsJumpscaring)
			{
				return false;
			}
			Vector3 pos = transform.position;
			Vector3 tPos = target.position;
			float scale = relaxed ? 1.4f : 1f;
			Vector3 flat = new Vector3(tPos.x - pos.x, 0f, tPos.z - pos.z);
			int surface = (_state == SpiderState.Ground) ? Floor : Classify(_up);
			LeapPath path;
			if (surface == Ceiling)
			{
				float drop = pos.y - tPos.y;
				if (drop < 0.5f || drop > maxDropHeight)
				{
					return false;
				}
				float reach = Mathf.Min(dropReach + drop * dropReachPerMetre, maxDropReach);
				if (flat.magnitude > scale * reach)
				{
					return false;
				}
				path = LeapPath.Dive;
			}
			else
			{
				float range = scale * ((surface == Floor) ? ledgePounceRange : wallPounceRange);
				if (Vector3.Distance(pos, tPos) > range)
				{
					return false;
				}
				path = LeapPath.Arc;
			}
			if (SphereBlocked(pos, tPos, 0.25f))
			{
				return false;
			}
			float lookahead = pounceAnticipation + LeapDuration(path, pos, tPos);
			Vector3 lead = new Vector3(_targetVel.x, 0f, _targetVel.z) * lookahead;
			lead = Vector3.ClampMagnitude(lead, maxLead);
			Vector3 aim = tPos + lead;
			Vector3 up = Vector3.up;
			if (CastSurface(aim + Vector3.up * 0.2f, Vector3.down, 1.7f, out hit) && hit.normal.y > 0.6f)
			{
				up = hit.normal;
				aim = hit.point + hit.normal * _ride;
			}
			float apex = (path == LeapPath.Arc) ? ArcApex(pos, aim) : 0f;
			if (!ArcClear(path, pos, aim, apex))
			{
				return false;
			}
			Vector3 face = (flat.sqrMagnitude > 0.0001f) ? flat : FlatForward();
			Quaternion rot = Quaternion.LookRotation(Vector3.ProjectOnPlane(face, up).normalized, up);
			StartLeap(LeapKind.Pounce, path, aim, rot, pounceAnticipation, CrawlIntent.Direct);
			return true;
		}

		private static bool CanCatch(Transform target)
		{
			if (target != null)
			{
				return !MonsterExclusionZone.Contains(target.position);
			}
			return false;
		}

		private bool BodyTouches(Transform target, float slack)
		{
			RaycastHit hit;
			Vector3 head = target.position + Vector3.up * PlayerHeadroom;
			float height = CastSurface(target.position, Vector3.down, MaxPlayerBody, out hit) ? hit.distance : MaxPlayerBody;
			Vector3 feet = target.position - Vector3.up * height;
			Vector3 body = transform.position + transform.up * (_ride * 0.8f);
			float reach = (killRadius + PlayerRadius) * slack;
			return SqrDistanceToSegment(body, feet, head) <= reach * reach;
		}

		private void Catch(Transform victim)
		{
			_leaping = false;
			_climbFailures = 0;
			PlaceForCatch(transform.position, victim.position - transform.position);
			_epoch++;
			SendCatchPose();
			_catching = true;
			TryJumpscare(victim);
			_catching = false;
		}

		private void PlaceForCatch(Vector3 near, Vector3 face)
		{
			Vector3 flat = (face.x * face.x + face.z * face.z < 0.0001f) ? FlatForward() : new Vector3(face.x, 0f, face.z);
			RaycastHit hit;
			Vector3 floor = near - Vector3.up * _ride;
			if (CastSurface(near, Vector3.down, 20f, out hit) && hit.normal.y > 0.6f)
			{
				floor = hit.point;
			}
			if (!EnterGround(floor, flat, false, false))
			{
				_up = Vector3.up;
				_fwd = flat.normalized;
				_cornering = false;
				_simPos = floor + Vector3.up * _ride;
				transform.SetPositionAndRotation(_simPos, Quaternion.LookRotation(_fwd, _up));
				SetState(SpiderState.Crawl);
				SetIntent(CrawlIntent.Lurk);
			}
		}

		private void SendCatchPose()
		{
			if (PhotonNetwork.InRoom)
			{
				base.photonView.RPC("RPC_SpiderCatchPose", RpcTarget.Others, transform.position, transform.rotation, (byte)_state, _epoch);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_SpiderCatchPose(Vector3 position, Quaternion rotation, byte state, byte epoch)
		{
			if (!IsAuthority)
			{
				_leaping = false;
				transform.SetPositionAndRotation(position, rotation);
				_state = (SpiderState)state;
				_epoch = epoch;
				_catchPoseAt = Time.time;
				_awaitEpoch = true;
				_awaitSince = Time.time;
			}
		}

		private bool TryDropToFloor()
		{
			Vector3 floor;
			NavMeshHit hit;
			Vector3 pos = transform.position;
			Vector3 from = (Classify(_up) == Wall) ? (pos + _up * 0.6f) : pos;
			if (!FloorBelow(from, 40f, out floor))
			{
				return false;
			}
			for (float r = 0f; r <= 3f; r += 1.5f)
			{
				for (int i = 0; i < ((r > 0f) ? 8 : 1); i++)
				{
					Vector3 probe = floor + Quaternion.AngleAxis((float)i * 45f, Vector3.up) * Vector3.forward * r;
					if (NavMesh.SamplePosition(probe, out hit, 1.2f, -1))
					{
						Vector3 stand = hit.position + Vector3.up * _ride;
						if (!(stand.y > pos.y - 0.5f) && ArcClear(LeapPath.Dive, pos, stand, 0f) && IsConnected(hit.position))
						{
							StartLeap(LeapKind.Drop, LeapPath.Dive, stand, Quaternion.LookRotation(FlatForward(), Vector3.up), 0.15f, CrawlIntent.Lurk);
							return true;
						}
					}
				}
			}
			return false;
		}

		private void StartFall()
		{
			DisableAgent();
			_leaping = false;
			_cornering = false;
			_fallVelocity = Vector3.zero;
			_fallStart = Time.time;
			SetState(SpiderState.Fall);
		}

		private void TickFall(float dt)
		{
			RaycastHit hit;
			_fallVelocity += Physics.gravity * dt;
			Vector3 pos = transform.position;
			Vector3 step = _fallVelocity * dt;
			float dist = step.magnitude;
			if (dist > 1E-05f && PickNearest(Physics.SphereCastNonAlloc(pos, 0.25f, step / dist, _hits, dist + _ride, surfaceMask, QueryTriggerInteraction.Ignore), out hit))
			{
				if (hit.normal.y > 0.6f)
				{
					_landPulse = 1f;
					PlaySfx(landClip);
					if (!EnterGround(hit.point, FlatForward()))
					{
						EnterSurface(hit.point + hit.normal * _ride, hit.normal, FlatForward(), CrawlIntent.Descend);
					}
					return;
				}
				_fallVelocity = Vector3.ProjectOnPlane(_fallVelocity, hit.normal);
				step = _fallVelocity * dt;
			}
			transform.SetPositionAndRotation(pos + step, Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(FlatForward(), Vector3.up), 540f * dt));
			if (Time.time - _fallStart > 4f)
			{
				EnterGround(transform.position, FlatForward(), true);
			}
		}

		private static float SqrDistanceToSegment(Vector3 p, Vector3 a, Vector3 b)
		{
			Vector3 ab = b - a;
			float t = Mathf.Clamp01(Vector3.Dot(p - a, ab) / Mathf.Max(ab.sqrMagnitude, 1E-06f));
			return (p - (a + ab * t)).sqrMagnitude;
		}

		private bool StartSurfaceTravel(bool chasing, bool preferCeiling)
		{
			_travelChasing = chasing;
			_escalations = 0;
			_reclimbs = 0;
			Vector3 destination = chasing ? base.CurrentTarget.position : _patrolGoal;
			float refresh = chasing ? RouteRefreshChase : RouteRefreshPatrol;
			CrawlIntent after = chasing ? CrawlIntent.Chase : CrawlIntent.Patrol;
			_cornerCount = 0;
			RefreshRoute(destination);
			_nextRouteRefresh = Time.time + refresh;
			Vector3 heading = RouteHeading(destination);
			if (chasing && preferCeiling && TryLeapToCeiling(heading, after))
			{
				return true;
			}
			if (TryClimbNearestWall(heading, preferCeiling))
			{
				return true;
			}
			return TryLeapToCeiling(heading, after);
		}

		private bool TryLeapToCeiling(Vector3 heading, CrawlIntent after)
		{
			RaycastHit hit;
			Vector3 pos = transform.position;
			Vector3 dir = (heading.sqrMagnitude > 0.0001f) ? heading.normalized : FlatForward();
			Vector3 ahead = dir * 1.5f;
			for (int pass = 0; pass < 2; pass++)
			{
				Vector3 from = (pass == 0) ? (pos + ahead) : pos;
				if (ProbeCeiling(from, maxLeapHeight - _ride, out hit) && !(hit.point.y - (pos.y - _ride) < minCeilingHeight))
				{
					Vector3 stand = hit.point + hit.normal * _ride;
					if (ArcClear(LeapPath.Rise, pos, stand, 0f))
					{
						Vector3 fwd = Vector3.ProjectOnPlane(dir, hit.normal);
						if (fwd.sqrMagnitude < 0.01f)
						{
							fwd = Vector3.ProjectOnPlane(FlatForward(), hit.normal);
						}
						_travelOnWalls = false;
						StartLeap(LeapKind.ToSurface, LeapPath.Rise, stand, Quaternion.LookRotation(fwd.normalized, hit.normal), leapAnticipation, after);
						return true;
					}
				}
			}
			return false;
		}

		private bool TryClimbNearestWall(Vector3 heading, bool thenCeiling)
		{
			RaycastHit hit;
			RaycastHit ceiling;
			Vector3 origin = transform.position + Vector3.up * 0.8f;
			Vector3 dir = (heading.sqrMagnitude > 0.0001f) ? heading.normalized : FlatForward();
			float minDot = _travelChasing ? (-0.05f) : (-0.6f);
			Vector3 wallPoint = Vector3.zero;
			Vector3 wallNormal = Vector3.zero;
			float bestScore = float.MaxValue;
			for (int i = 0; i < 12; i++)
			{
				Vector3 d = Quaternion.AngleAxis((float)i * 30f, Vector3.up) * dir;
				float dot = Vector3.Dot(dir, d);
				if (!(dot < minDot) && CastSurface(origin, d, wallSearchRange, out hit) && !(Mathf.Abs(hit.normal.y) > 0.5f))
				{
					float score = (1f - dot) * 2f + hit.distance;
					if (score < bestScore)
					{
						bestScore = score;
						wallPoint = hit.point;
						wallNormal = hit.normal;
					}
				}
			}
			if (bestScore == float.MaxValue)
			{
				return false;
			}
			_travelOnWalls = !thenCeiling || !ProbeCeiling(wallPoint + wallNormal * (_ride + 0.4f), maxLeapHeight + 6f, out ceiling);
			_cruiseHeight = Random.Range(wallCruiseHeight.x, wallCruiseHeight.y);
			_climbWallPoint = wallPoint;
			EnterCrawl(CrawlIntent.Climb, wallPoint - transform.position);
			return true;
		}

		private bool ContinueRoam()
		{
			Transform[] points = base.PatrolPoints;
			if (points == null || points.Length == 0 || Random.value > surfaceRoamChance)
			{
				return false;
			}
			Transform goal = null;
			for (int i = 0; i < 4; i++)
			{
				if (!(goal == null))
				{
					break;
				}
				Transform candidate = points[Random.Range(0, points.Length)];
				if (candidate != null && !(FlatDistance(candidate.position, _simPos) < 6f))
				{
					goal = candidate;
				}
			}
			if (goal == null)
			{
				return false;
			}
			_patrolGoal = goal.position;
			_travelChasing = false;
			_escalations = 0;
			_reclimbs = 0;
			_travelOnWalls = Random.value >= ceilingRoamShare;
			_cruiseHeight = Random.Range(wallCruiseHeight.x, wallCruiseHeight.y);
			_cornerCount = 0;
			RefreshRoute(_patrolGoal);
			_nextRouteRefresh = Time.time + RouteRefreshPatrol;
			SetIntent(CrawlIntent.Patrol);
			return true;
		}

		private void SwitchToWalls()
		{
			if (!_travelOnWalls)
			{
				_travelOnWalls = true;
				_cruiseHeight = Random.Range(wallCruiseHeight.x, wallCruiseHeight.y);
				ResetTravelProgress();
			}
		}

		private void RefreshRoute(Vector3 destination)
		{
			NavMeshHit hit;
			Vector3 dest = GroundUnder(destination);
			if (RouteStart(out var start) && NavMesh.SamplePosition(dest, out hit, 3f, -1) && NavMesh.CalculatePath(start, hit.position, -1, _routePath) && _routePath.status != NavMeshPathStatus.PathInvalid)
			{
				int count = _routePath.GetCornersNonAlloc(_corners);
				if (count >= 1)
				{
					_cornerCount = count;
					_cornerIndex = (count != 1) ? 1 : 0;
					return;
				}
			}
			if (_cornerCount <= 0 || !(FlatDistance(_corners[_cornerCount - 1], dest) < 4f))
			{
				_corners[0] = dest;
				_cornerCount = 1;
				_cornerIndex = 0;
			}
		}

		private bool RouteStart(out Vector3 start)
		{
			NavMeshHit hit;
			if (SpiderFloor(out var floor) && NavMesh.SamplePosition(floor, out hit, 3f, -1))
			{
				_lastFloorY = hit.position.y;
				start = hit.position;
				return true;
			}
			if (!float.IsNaN(_lastFloorY) && NavMesh.SamplePosition(new Vector3(_simPos.x, _lastFloorY, _simPos.z), out hit, 4f, -1))
			{
				start = hit.position;
				return true;
			}
			start = default(Vector3);
			return false;
		}

		private void PickRoamGoal()
		{
			Transform[] points = base.PatrolPoints;
			if (points == null || points.Length == 0)
			{
				return;
			}
			for (int i = 0; i < 4; i++)
			{
				Transform candidate = points[Random.Range(0, points.Length)];
				if (!(candidate == null) && !(FlatDistance(candidate.position, transform.position) < 10f))
				{
					_patrolGoal = candidate.position;
					break;
				}
			}
		}

		private Vector3 GroundUnder(Vector3 point)
		{
			if (FloorBelow(point + Vector3.up * 0.3f, 8f, out var floor))
			{
				return floor;
			}
			return point;
		}

		private Vector3 RouteHeading(Vector3 destination)
		{
			Vector3 position = transform.position;
			for (int i = 0; i < _cornerCount; i++)
			{
				Vector3 toCorner = _corners[i] - position;
				toCorner.y = 0f;
				if (toCorner.sqrMagnitude > 1f)
				{
					return toCorner.normalized;
				}
			}
			Vector3 flat = destination - position;
			flat.y = 0f;
			if (flat.sqrMagnitude > 0.0001f)
			{
				return flat.normalized;
			}
			return FlatForward();
		}

		private Vector3 RouteGuide()
		{
			if (_cornerCount >= 2 && _cornerIndex < _cornerCount)
			{
				int best = _cornerIndex;
				float bestDistance = float.MaxValue;
				for (int i = Mathf.Max(_cornerIndex, 1); i < _cornerCount; i++)
				{
					float d = FlatDistanceToSegment(_simPos, _corners[i - 1], _corners[i]);
					if (d < bestDistance - 0.25f)
					{
						bestDistance = d;
						best = i;
					}
				}
				if (best > _cornerIndex)
				{
					AdvanceCorner(best);
				}
			}
			while (_cornerIndex < _cornerCount - 1 && FlatDistance(_simPos, _corners[_cornerIndex]) < CornerReach)
			{
				AdvanceCorner(_cornerIndex + 1);
			}
			return _corners[_cornerIndex];
		}

		private void AdvanceCorner(int index)
		{
			_cornerIndex = index;
			if (!_travelChasing)
			{
				ResetTravelProgress();
			}
		}

		private float RouteDeviation()
		{
			if (_cornerCount < 2)
			{
				return 0f;
			}
			int i = Mathf.Clamp(_cornerIndex, 1, _cornerCount - 1);
			return FlatDistanceToSegment(_simPos, _corners[i - 1], _corners[i]);
		}

		private static float FlatDistanceToSegment(Vector3 p, Vector3 a, Vector3 b)
		{
			float abx = b.x - a.x;
			float abz = b.z - a.z;
			float t = Mathf.Clamp01(((p.x - a.x) * abx + (p.z - a.z) * abz) / Mathf.Max(abx * abx + abz * abz, 1E-06f));
			float dx = p.x - (a.x + abx * t);
			float dz = p.z - (a.z + abz * t);
			return Mathf.Sqrt(dx * dx + dz * dz);
		}

		private bool RouteArrived()
		{
			if (_cornerCount == 0 || _cornerIndex < _cornerCount - 1)
			{
				return false;
			}
			if (FlatDistance(_simPos, _corners[_cornerCount - 1]) >= CornerReach)
			{
				return false;
			}
			if (_cornerCount == _corners.Length)
			{
				RefreshRoute(_patrolGoal);
				return false;
			}
			return true;
		}

		private Vector3 TravelGoal()
		{
			if (_cornerCount == 0)
			{
				RefreshRoute((_travelChasing && CurrentTarget != null) ? CurrentTarget.position : _patrolGoal);
			}
			Vector3 guide = RouteGuide();
			if (_travelOnWalls)
			{
				guide.y += _cruiseHeight;
			}
			else
			{
				guide += Vector3.up * 100f;
			}
			return guide - _simPos;
		}

		private bool TravelStalled(float now)
		{
			float metric = TravelMetric();
			if (metric < _travelBest - 0.4f)
			{
				_travelBest = metric;
				_travelBestAt = now;
				return false;
			}
			if (_cornering || now - _travelBestAt < TravelStallTime)
			{
				return false;
			}
			ResetTravelProgress();
			return true;
		}

		private float TravelMetric()
		{
			Vector3 corner = (_cornerCount > 0) ? _corners[_cornerIndex] : _simPos;
			Vector3 target = corner;
			if (_travelChasing && CurrentTarget != null)
			{
				target = CurrentTarget.position;
			}
			float vertical = _travelOnWalls ? Mathf.Abs(_simPos.y - (corner.y + _cruiseHeight)) : -_simPos.y;
			return vertical + FlatDistance(_simPos, target);
		}

		private void ResetTravelProgress()
		{
			_travelBest = float.MaxValue;
			_travelBestAt = Time.time;
		}

		private void EnterCrawl(CrawlIntent intent, Vector3 faceDir)
		{
			DisableAgent();
			Vector3 position = transform.position;
			_up = Vector3.up;
			if (CastSurface(position + Vector3.up * 0.25f, Vector3.down, _ride + 1f, out var hit))
			{
				_up = hit.normal;
				position = hit.point + hit.normal * _ride;
			}
			_simPos = position;
			Vector3 face = Vector3.ProjectOnPlane(faceDir, _up);
			_fwd = (face.sqrMagnitude > 0.0001f) ? face.normalized : transform.forward;
			Orthonormalise();
			_cornering = false;
			SetState(SpiderState.Crawl);
			SetIntent(intent);
		}

		private void SetIntent(CrawlIntent intent)
		{
			_intent = intent;
			_intentSince = Time.time;
			_nextDecision = Time.time + DecisionInterval;
			ResetStuck();
			ResetTravelProgress();
			if (intent == CrawlIntent.Lurk)
			{
				_lurkUntil = Time.time + Random.Range(lurkTime.x, lurkTime.y);
			}
		}

		private void TickCrawl(float dt)
		{
			if (IsFrozen)
			{
				ResetStuck();
				return;
			}
			UpdateCrawlIntent();
			if (_state != SpiderState.Crawl || _leaping)
			{
				return;
			}
			Vector3 goal = GoalVector();
			if (Vector3.ProjectOnPlane(goal, _up).sqrMagnitude < 0.0001f)
			{
				FaceLastTarget(dt);
				if (!Hunting)
				{
					ResetStuck();
				}
				else
				{
					CheckStuck(dt);
				}
			}
			else
			{
				CrawlMove(goal, Hunting ? crawlChaseSpeed : crawlPatrolSpeed, dt);
				CheckStuck(dt);
			}
			if (_state == SpiderState.Crawl && !_leaping)
			{
				ApplyCrawlPose(dt);
			}
		}

		private void UpdateCrawlIntent()
		{
			float now = Time.time;
			bool hunting = Hunting;
			if (hunting)
			{
				_lastTargetPos = CurrentTarget.position;
			}
			if (_up.y > 0.7f && !_cornering)
			{
				if (_floorSince < 0f)
				{
					_floorSince = now;
				}
			}
			else
			{
				_floorSince = -1f;
			}
			bool settled = _floorSince >= 0f && now - _floorSince > 0.35f;
			if (hunting)
			{
				if (_intent == CrawlIntent.Lurk || _intent == CrawlIntent.Patrol)
				{
					_nextRouteRefresh = 0f;
					_travelChasing = true;
					SetIntent(CrawlIntent.Chase);
				}
			}
			else if (_intent == CrawlIntent.Chase || _intent == CrawlIntent.Direct)
			{
				SetIntent(CrawlIntent.Lurk);
			}
			switch (_intent)
			{
			case CrawlIntent.Chase:
			{
				if (TryPounceThrottled(now) || (settled && ReturnToGround()))
				{
					break;
				}
				if (now >= _nextRouteRefresh)
				{
					_nextRouteRefresh = now + RouteRefreshChase;
					RefreshRoute(CurrentTarget.position);
				}
				if (now >= _nextDecision)
				{
					_nextDecision = now + DecisionInterval;
					Vector3 targetPos = CurrentTarget.position;
					float distance = FlatDistance(_simPos, targetPos);
					if (distance < DirectRange && TargetOutOfReach(targetPos))
					{
						SetIntent(CrawlIntent.Direct);
						break;
					}
					if (distance > maxCeilingChaseDistance)
					{
						BeginDescend();
						break;
					}
					if (!_travelOnWalls && !ProbeCeiling(targetPos, maxDropHeight + 1f, out _))
					{
						SwitchToWalls();
					}
				}
				if (TravelStalled(now))
				{
					OnCrawlStuck();
				}
				break;
			}
			case CrawlIntent.Direct:
				if (TryPounceThrottled(now) || now < _nextDecision)
				{
					break;
				}
				_nextDecision = now + DecisionInterval;
				if (TargetOutOfReach(CurrentTarget.position))
				{
					if (now - _intentSince > 10f)
					{
						NoteClimbFailure();
						BeginDescend();
					}
				}
				else if (_up.y > 0.7f)
				{
					if (!ReturnToGround())
					{
						SetIntent(CrawlIntent.Descend);
					}
				}
				else
				{
					SetIntent(CrawlIntent.Chase);
				}
				break;
			case CrawlIntent.Patrol:
				if (settled && now - _intentSince > 1f)
				{
					if (_reclimbs <= 1 && TryClimbNearestWall(RouteHeading(_patrolGoal), !_travelOnWalls))
					{
						_reclimbs++;
						break;
					}
					if (ReturnToGround())
					{
						break;
					}
				}
				if (now >= _nextRouteRefresh)
				{
					_nextRouteRefresh = now + RouteRefreshPatrol;
					if (_cornerCount == 0 || RouteDeviation() > 6f)
					{
						RefreshRoute(_patrolGoal);
					}
				}
				if (RouteArrived())
				{
					if (!ContinueRoam())
					{
						BeginDescend();
					}
				}
				else if (TravelStalled(now))
				{
					OnCrawlStuck();
				}
				break;
			case CrawlIntent.Climb:
				if (_up.y < 0.4f && !_cornering)
				{
					_nextRouteRefresh = 0f;
					SetIntent((hunting && _travelChasing) ? CrawlIntent.Chase : CrawlIntent.Patrol);
				}
				else if (now - _intentSince > 6f && !ReturnToGround())
				{
					SetIntent(CrawlIntent.Descend);
				}
				break;
			case CrawlIntent.Lurk:
				if (settled && ReturnToGround())
				{
					break;
				}
				if (now >= _lurkUntil && !ContinueRoam())
				{
					BeginDescend();
				}
				break;
			case CrawlIntent.Descend:
				if (settled)
				{
					ReturnToGround();
				}
				break;
			}
		}

		private bool TryPounceThrottled(float now)
		{
			if (_nextPounceCheck > now)
			{
				return false;
			}
			_nextPounceCheck = now + PounceInterval;
			return TryPounce(false);
		}

		private bool ReturnToGround()
		{
			return EnterGround(_simPos - _up * _ride, _fwd);
		}

		private void BeginDescend()
		{
			if (!TryDropToFloor() && _intent != CrawlIntent.Descend)
			{
				SetIntent(CrawlIntent.Descend);
			}
		}

		private Vector3 GoalVector()
		{
			Vector3 target = (CurrentTarget != null && Hunting) ? CurrentTarget.position : _lastTargetPos;
			switch (_intent)
			{
			case CrawlIntent.Chase:
			case CrawlIntent.Patrol:
				return TravelGoal();
			case CrawlIntent.Direct:
				return target - _simPos;
			case CrawlIntent.Descend:
				return Vector3.ClampMagnitude(new Vector3(target.x - _simPos.x, 0f, target.z - _simPos.z), 20f) + Vector3.down * 100f;
			case CrawlIntent.Climb:
				return _climbWallPoint + Vector3.up * 100f - _simPos;
			default:
				return Vector3.zero;
			}
		}

		private void CrawlMove(Vector3 goal, float speed, float dt)
		{
			float remaining = speed * dt;
			if (remaining <= 0.0001f)
			{
				return;
			}
			float invSpeed = 1f / Mathf.Max(speed, 0.01f);
			int guard = 0;
			do
			{
				float step = Mathf.Min(remaining, MaxCrawlStep);
				Steer(goal, invSpeed * step);
				if ((!CrawlStep(goal, step) && !FeelAround(goal, step)) || guard > 10)
				{
					break;
				}
				remaining -= step;
				guard++;
			}
			while (remaining > 0.0001f);
		}

		private bool FeelAround(Vector3 goal, float ds)
		{
			Vector3 fwd = _fwd;
			float side = (Vector3.SignedAngle(fwd, Vector3.ProjectOnPlane(goal, _up), _up) < 0f) ? (-1f) : 1f;
			for (int i = 0; i < 2; i++)
			{
				_fwd = Quaternion.AngleAxis(side * 70f, _up) * fwd;
				Orthonormalise();
				if (CrawlStep(goal, ds))
				{
					return true;
				}
				side = -side;
			}
			_fwd = fwd;
			return false;
		}

		private void Steer(Vector3 goal, float dt)
		{
			Vector3 flat = Vector3.ProjectOnPlane(goal, _up);
			if (flat.sqrMagnitude < 1E-06f)
			{
				return;
			}
			float maxTurn = crawlTurnSpeed * dt;
			float angle = Mathf.Clamp(Vector3.SignedAngle(_fwd, flat, _up), -maxTurn, maxTurn);
			_fwd = Quaternion.AngleAxis(angle, _up) * _fwd;
			Orthonormalise();
		}

		private bool CrawlStep(Vector3 goal, float ds)
		{
			float reach = _ride + transform.lossyScale.y * 0.9f;
			bool climbing = false;
			Vector3 stepDir;
			if (CastSurface(_simPos, _fwd, reach + ds, out var wall) && Vector3.Angle(_up, wall.normal) > 35f)
			{
				if (AcceptTransition(goal, wall.normal))
				{
					stepDir = _fwd;
					if (wall.distance < _ride + 0.15f)
					{
						Vector3 along = Vector3.ProjectOnPlane(_fwd, wall.normal);
						if (along.sqrMagnitude < 0.05f)
						{
							along = Vector3.ProjectOnPlane(_up, wall.normal);
						}
						if (along.sqrMagnitude > 0.0001f)
						{
							stepDir = along.normalized;
						}
					}
					climbing = true;
				}
				else
				{
					Vector3 slide = Vector3.ProjectOnPlane(Vector3.ProjectOnPlane(_fwd, wall.normal), _up);
					if (slide.sqrMagnitude < 0.04f)
					{
						return false;
					}
					_fwd = slide.normalized;
					stepDir = _fwd;
				}
			}
			else
			{
				stepDir = _fwd;
			}
			Vector3 next = _simPos + stepDir * ds;
			if (MonsterExclusionZone.Entering(_simPos, next))
			{
				return false;
			}
			_fanNormal = Vector3.zero;
			_fanPoint = Vector3.zero;
			_fanWeight = 0f;
			Vector3 right = Vector3.Cross(_up, _fwd);
			Vector3 origin = next + _up * FanLift;
			float depth = _ride + FanLift + StickDepth;
			Probe(goal, origin, -_up, depth, 1.5f);
			depth *= 1.3f;
			bool ahead = Probe(goal, origin, (_fwd * FanSpread - _up).normalized, depth, 1f);
			Probe(goal, origin, (_fwd * -FanSpread - _up).normalized, depth, 1f);
			Probe(goal, origin, (right * FanSpread - _up).normalized, depth, 1f);
			Probe(goal, origin, (-_up - right * FanSpread).normalized, depth, 1f);
			if (climbing)
			{
				AddSample(wall.point, wall.normal, Mathf.Clamp01(1f - (wall.distance - _ride) / reach) * 3f);
			}
			if (!ahead && CastSurface(next + _fwd * 0.4f - _up * (_ride + WrapDepth), -_fwd, _ride + 1.2f, out var wrap) && Vector3.Angle(_up, wrap.normal) > 20f && AcceptTransition(goal, wrap.normal))
			{
				AddSample(wrap.point, wrap.normal, 2f);
			}
			if (_fanWeight <= 0f)
			{
				return false;
			}
			Vector3 normal = (_fanNormal / _fanWeight).normalized;
			Vector3 point = _fanPoint / _fanWeight;
			_cornering = Vector3.Angle(_up, normal) > 12f;
			_up = Vector3.RotateTowards(_up, normal, Mathf.Max(ds, 0.02f) * (surfaceTurnRate * Mathf.Deg2Rad), 0f);
			Orthonormalise();
			float offset = Mathf.Clamp(_ride + Vector3.Dot(point - next, _up), -0.15f, 0.15f);
			_simPos = next + _up * offset;
			return true;
		}

		private bool Probe(Vector3 goal, Vector3 origin, Vector3 dir, float length, float weight)
		{
			if (!CastSurface(origin, dir, length, out var hit))
			{
				return false;
			}
			if (Vector3.Angle(_up, hit.normal) > 75f && !AcceptTransition(goal, hit.normal))
			{
				return false;
			}
			AddSample(hit.point, hit.normal, weight / (hit.distance + 0.5f));
			return true;
		}

		private void AddSample(Vector3 point, Vector3 normal, float weight)
		{
			_fanNormal += normal * weight;
			_fanPoint += point * weight;
			_fanWeight += weight;
		}

		private bool AcceptTransition(Vector3 goal, Vector3 newNormal)
		{
			if (_intent == CrawlIntent.Descend && newNormal.y > 0.7f)
			{
				return true;
			}
			Vector3 onSurface = Vector3.ProjectOnPlane(goal, newNormal);
			if (onSurface.sqrMagnitude < 0.0001f)
			{
				return true;
			}
			Vector3 carried = Quaternion.FromToRotation(_up, newNormal) * _fwd;
			return Vector3.Dot(carried, onSurface.normalized) > -0.2f;
		}

		private void Orthonormalise()
		{
			_up = _up.normalized;
			Vector3 fwd = Vector3.ProjectOnPlane(_fwd, _up);
			if (fwd.sqrMagnitude < 1E-06f)
			{
				fwd = Vector3.ProjectOnPlane((Mathf.Abs(_up.y) < 0.9f) ? Vector3.up : Vector3.forward, _up);
			}
			_fwd = fwd.normalized;
		}

		private void ApplyCrawlPose(float dt)
		{
			float k = 1f - Mathf.Exp(-dt / 0.05f);
			Quaternion target = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(_fwd, _up), k);
			transform.SetPositionAndRotation(Vector3.Lerp(transform.position, _simPos, k), Quaternion.RotateTowards(transform.rotation, target, 20f));
		}

		private void FaceLastTarget(float dt)
		{
			Vector3 toTarget = Vector3.ProjectOnPlane(_lastTargetPos - _simPos, _up);
			if (toTarget.sqrMagnitude < 0.01f)
			{
				return;
			}
			float angle = Mathf.Clamp(Vector3.SignedAngle(_fwd, toTarget, _up), -dt * 60f, dt * 60f);
			_fwd = Quaternion.AngleAxis(angle, _up) * _fwd;
			Orthonormalise();
		}

		private void CheckStuck(float dt)
		{
			if ((_simPos - _stuckAnchor).sqrMagnitude > 0.36f)
			{
				ResetStuck();
				return;
			}
			_stuckTimer += dt;
			if (_stuckTimer < stuckTime)
			{
				return;
			}
			ResetStuck();
			OnCrawlStuck();
		}

		private void ResetStuck()
		{
			_stuckTimer = 0f;
			_stuckAnchor = _simPos;
		}

		private void OnCrawlStuck()
		{
			if ((_intent == CrawlIntent.Chase || _intent == CrawlIntent.Patrol) && _escalations <= 1)
			{
				_escalations++;
				if (!_travelOnWalls)
				{
					_travelOnWalls = true;
					_cruiseHeight = Random.Range(wallCruiseHeight.x, wallCruiseHeight.y);
					_escalations = 2;
				}
				else if (_escalations == 1)
				{
					_cruiseHeight += 2.5f;
				}
				else
				{
					_travelOnWalls = false;
				}
				ResetStuck();
				ResetTravelProgress();
				return;
			}
			NoteClimbFailure();
			if ((!Hunting || !TryPounce(true)) && !TryDropToFloor())
			{
				if (_intent == CrawlIntent.Descend)
				{
					StartFall();
				}
				else
				{
					SetIntent(CrawlIntent.Descend);
				}
			}
		}

		private void Awake()
		{
			_navPath = new NavMeshPath();
			_routePath = new NavMeshPath();
			_ride = ((agent != null) ? Mathf.Max(0.2f, agent.baseOffset * transform.lossyScale.y) : 0.5f);
			LethalApeR.Gameplay.Animation.AnimSpeed animSpeed = GetComponentInChildren<LethalApeR.Gameplay.Animation.AnimSpeed>(true);
			if (animSpeed != null)
			{
				_metresToAnimSpeed = animSpeed.speedMultiplier;
				if (bodyAnimator == null)
				{
					bodyAnimator = animSpeed.animator;
				}
				animSpeed.enabled = false;
			}
			if (bodyModel != null)
			{
				_modelRest = bodyModel.localPosition;
			}
			_lastAnimPos = _simPos = transform.position;
			_up = transform.up;
			_fwd = transform.forward;
			_nextRoamCheck = Time.time + Random.Range(roamCheckInterval.x, roamCheckInterval.y);
		}

		protected override void OnMonsterUpdate(bool isMaster)
		{
			if (!isMaster)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			TrackTarget(deltaTime);
			if (_catchPosePending)
			{
				_catchPosePending = false;
				SendCatchPose();
			}
			if (_leaping)
			{
				TickLeap(true);
			}
			else if (!IsJumpscaring)
			{
				switch (_state)
				{
				case SpiderState.Ground:
					TickGround();
					break;
				case SpiderState.Crawl:
					TickCrawl(deltaTime);
					break;
				case SpiderState.Fall:
					TickFall(deltaTime);
					break;
				default:
					StartFall();
					break;
				}
			}
		}

		private void TickGround()
		{
			if (_holdingAgent && Time.time >= _recoverUntil)
			{
				SetAgentHeld(false);
			}
			if (_holdingAgent || IsFrozen || Time.time < _nextDecision)
			{
				return;
			}
			_nextDecision = Time.time + DecisionInterval;
			SampleRideHeight();
			NoteGround();
			if (!CheckGroundStuck())
			{
				if (Hunting)
				{
					ConsiderChaseClimb();
				}
				else
				{
					ConsiderRoam();
				}
			}
		}

		private void NoteGround()
		{
			if (agent == null || !agent.enabled || !agent.isOnNavMesh)
			{
				return;
			}
			_lastFloorY = transform.position.y - _ride;
			if (!_hasHome && NavMesh.SamplePosition(transform.position - Vector3.up * _ride, out var hit, 1.5f, NavMesh.AllAreas))
			{
				_hasHome = true;
				_homeNav = hit.position;
			}
		}

		private bool CheckGroundStuck()
		{
			bool idle = agent == null || !agent.enabled || !agent.isOnNavMesh || !agent.hasPath || agent.pathPending;
			bool close = Hunting && (CurrentTarget.position - transform.position).sqrMagnitude < 6.25f;
			if (idle || close || (transform.position - _groundAnchor).sqrMagnitude > 0.25f)
			{
				_groundAnchor = transform.position;
				_groundAnchorAt = Time.time;
				return false;
			}
			if (Time.time - _groundAnchorAt < 3f)
			{
				return false;
			}
			_groundAnchor = transform.position;
			_groundAnchorAt = Time.time;
			if (!Hunting)
			{
				PickRoamGoal();
			}
			if (StartSurfaceTravel(Hunting, Hunting || Random.value < ceilingRoamShare))
			{
				return true;
			}
			_travelOnWalls = true;
			_reclimbs = 2;
			_cruiseHeight = 0.6f;
			_escalations = 2;
			EnterCrawl(Hunting ? CrawlIntent.Chase : CrawlIntent.Patrol, RouteHeading(Hunting ? CurrentTarget.position : _patrolGoal));
			return true;
		}

		private bool IsConnected(Vector3 navPoint)
		{
			if (!_hasHome)
			{
				return true;
			}
			if (!NavMesh.CalculatePath(navPoint, _homeNav, NavMesh.AllAreas, _navPath))
			{
				return false;
			}
			return _navPath.status == NavMeshPathStatus.PathComplete;
		}

		private void ConsiderChaseClimb()
		{
			Vector3 position = transform.position;
			Vector3 targetPos = CurrentTarget.position;
			_lastTargetPos = targetPos;
			bool outOfReach = TargetOutOfReach(targetPos);
			if (Time.time < _nextClimbAllowed)
			{
				return;
			}
			float distance = FlatDistance(position, targetPos);
			if (outOfReach)
			{
				if (!TryPounce(false) && distance < DirectRange)
				{
					EnterCrawl(CrawlIntent.Direct, targetPos - position);
				}
			}
			else if (distance >= minChaseClimbDistance)
			{
				StartSurfaceTravel(true, true);
			}
		}

		private void ConsiderRoam()
		{
			if (Time.time < _nextRoamCheck || Time.time < _nextClimbAllowed)
			{
				return;
			}
			_nextRoamCheck = Time.time + Random.Range(roamCheckInterval.x, roamCheckInterval.y);
			if (agent == null || !agent.enabled || !agent.isOnNavMesh || agent.pathPending || !agent.hasPath || agent.remainingDistance < 8f)
			{
				return;
			}
			if (Random.value > surfaceRoamChance)
			{
				return;
			}
			_patrolGoal = agent.destination;
			StartSurfaceTravel(false, Random.value < ceilingRoamShare);
		}

		private bool TargetOutOfReach(Vector3 tPos)
		{
			if (CastSurface(tPos, Vector3.down, 6f, out RaycastHit hit) && hit.distance <= HangHeight)
			{
				_hangSince = -1f;
				if (!SpiderFloor(out Vector3 floor) || Mathf.Abs(hit.point.y - floor.y) <= ledgeHeight)
				{
					return false;
				}
				if (!NavMesh.SamplePosition(hit.point, out NavMeshHit targetHit, 0.6f, -1) || !NavMesh.SamplePosition(floor, out NavMeshHit selfHit, 2f, -1) || !NavMesh.CalculatePath(selfHit.position, targetHit.position, -1, _navPath))
				{
					return true;
				}
				return _navPath.status != NavMeshPathStatus.PathComplete;
			}
			if (_targetVel.sqrMagnitude > 4f)
			{
				_hangSince = -1f;
				return false;
			}
			if (_hangSince < 0f)
			{
				_hangSince = Time.time;
			}
			return Time.time - _hangSince > HangConfirm;
		}

		private bool SpiderFloor(out Vector3 point)
		{
			if (_state == SpiderState.Ground)
			{
				point = transform.position - Vector3.up * _ride;
				return true;
			}
			if (_state == SpiderState.Crawl && Classify(_up) == Wall)
			{
				return FloorBelow(transform.position + _up * 0.6f, 30f, out point);
			}
			return FloorBelow(transform.position, 30f, out point);
		}

		private bool FloorBelow(Vector3 from, float range, out Vector3 point)
		{
			int count = Physics.RaycastNonAlloc(from, Vector3.down, _hits, range, surfaceMask, QueryTriggerInteraction.Ignore);
			point = from;
			if (count < 1)
			{
				return false;
			}
			float best = float.MaxValue;
			for (int i = 0; i < count; i++)
			{
				RaycastHit hit = _hits[i];
				if (!(hit.normal.y < 0.6f) && hit.distance < best && IsSurface(hit.collider))
				{
					best = hit.distance;
					point = hit.point;
				}
			}
			return best < float.MaxValue;
		}

		private void SampleRideHeight()
		{
			if (agent == null || !agent.enabled || !agent.isOnNavMesh)
			{
				return;
			}
			if (CastSurface(transform.position + Vector3.up * 0.25f, Vector3.down, 2.5f, out RaycastHit hit))
			{
				float height = Mathf.Clamp(hit.distance - 0.25f, 0.2f, 2f);
				_ride = Mathf.Lerp(_ride, height, 0.25f);
			}
		}

		private void SetAgentHeld(bool held)
		{
			_holdingAgent = held;
			if (agent == null || !agent.enabled || !agent.isOnNavMesh)
			{
				return;
			}
			agent.isStopped = held;
			if (held)
			{
				agent.velocity = Vector3.zero;
			}
		}

		private void DisableAgent()
		{
			_holdingAgent = false;
			if (agent != null && agent.enabled)
			{
				agent.enabled = false;
			}
		}

		private bool EnterGround(Vector3 floorPoint, Vector3 face, bool force = false, bool settle = true)
		{
			NavMeshHit hit;
			Vector3 ground;
			bool onNavMesh;
			if (force)
			{
				if (NavMesh.SamplePosition(floorPoint, out hit, 1.2f, -1))
				{
					ground = hit.position;
					onNavMesh = true;
				}
				else
				{
					ground = floorPoint;
					onNavMesh = false;
				}
			}
			else
			{
				if (Time.time - _failedGroundTime < 0.5f && (floorPoint - _failedGroundAt).sqrMagnitude < 1f)
				{
					return false;
				}
				if (!NavMesh.SamplePosition(floorPoint, out hit, 1.2f, -1) || Mathf.Abs(hit.position.y - floorPoint.y) >= 0.6f || !IsConnected(hit.position))
				{
					_failedGroundTime = Time.time;
					_failedGroundAt = floorPoint;
					return false;
				}
				ground = hit.position;
				onNavMesh = true;
			}
			Vector3 flat = new Vector3(face.x, 0f, face.z);
			_fwd = ((flat.sqrMagnitude > 0.0001f) ? flat.normalized : FlatForward());
			_leaping = false;
			_cornering = false;
			_up = Vector3.up;
			SetState(SpiderState.Ground);
			_simPos = ground + Vector3.up * _ride;
			if (agent != null)
			{
				agent.enabled = true;
				if (onNavMesh)
				{
					agent.Warp(ground);
				}
				if (agent.isOnNavMesh)
				{
					agent.isStopped = false;
				}
			}
			if (settle)
			{
				_settleUntil = Time.time + 0.35f;
				_visualRot = transform.rotation;
			}
			else
			{
				_settleUntil = 0f;
				_visualRot = Quaternion.LookRotation(_fwd, Vector3.up);
			}
			transform.SetPositionAndRotation(_simPos, _visualRot);
			_holdingAgent = false;
			_nextClimbAllowed = Mathf.Max(_nextClimbAllowed, Time.time + ClimbCooldownNow);
			_nextDecision = Time.time + DecisionInterval;
			return true;
		}

		private void SetState(SpiderState state)
		{
			_state = state;
			_floorSince = -1f;
		}

		private void NoteClimbFailure()
		{
			_climbFailures = ((Time.time - _lastClimbFailure < 30f) ? (_climbFailures + 1) : 1);
			_lastClimbFailure = Time.time;
		}

		private void TrackTarget(float dt)
		{
			Transform target = CurrentTarget;
			if (target != _trackedTarget)
			{
				_trackedTarget = target;
				_targetVel = Vector3.zero;
				_hangSince = -1f;
				if (target != null)
				{
					_targetPrevPos = target.position;
				}
			}
			else if (!(target == null) && !(dt <= 0f))
			{
				Vector3 position = target.position;
				Vector3 velocity = (position - _targetPrevPos) / dt;
				_targetPrevPos = position;
				if (velocity.sqrMagnitude > 900f)
				{
					velocity = Vector3.zero;
				}
				_targetVel = Vector3.Lerp(_targetVel, velocity, 1f - Mathf.Exp(-dt / 0.15f));
			}
		}

		protected override void OnJumpscareStarted()
		{
			if (IsAuthority)
			{
				if (_catching || (_state == SpiderState.Ground && !_leaping))
				{
					return;
				}
				_leaping = false;
				PlaceForCatch(transform.position, JumpscareLungeDirection);
				if (agent != null && agent.enabled && agent.isOnNavMesh)
				{
					agent.isStopped = true;
					agent.velocity = Vector3.zero;
				}
				_catchPosePending = true;
				_epoch++;
			}
			else
			{
				if (Time.time - _catchPoseAt < 1f || (_state == SpiderState.Ground && !_leaping))
				{
					return;
				}
				_leaping = false;
				Vector3 position = transform.position;
				if (CastSurface(position, Vector3.down, 20f, out RaycastHit hit) && hit.normal.y > 0.6f)
				{
					position = hit.point + Vector3.up * _ride;
				}
				Vector3 lunge = JumpscareLungeDirection;
				Vector3 flat = new Vector3(lunge.x, 0f, lunge.z);
				transform.SetPositionAndRotation(position, Quaternion.LookRotation((flat.sqrMagnitude > 0.0001f) ? flat.normalized : FlatForward(), Vector3.up));
				_state = SpiderState.Ground;
			}
		}

		protected override void OnJumpscareEnded()
		{
			if (IsAuthority)
			{
				_nextClimbAllowed = Mathf.Max(_nextClimbAllowed, Time.time + climbCooldown);
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			base.OnMasterClientSwitched(newMasterClient);
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			_awaitEpoch = false;
			if (_leaping)
			{
				return;
			}
			if (_state == SpiderState.Crawl)
			{
				_simPos = transform.position;
				_up = transform.up;
				_fwd = transform.forward;
				_cornering = false;
				_travelChasing = Hunting;
				_travelOnWalls = Classify(_up) == Wall;
				_cornerCount = 0;
				SetIntent(Hunting ? CrawlIntent.Chase : CrawlIntent.Lurk);
			}
			else if (_state == SpiderState.Leap || _state == SpiderState.Fall)
			{
				StartFall();
			}
		}

		protected override void FollowNetwork()
		{
			if (_leaping)
			{
				TickLeap(false);
				return;
			}
			if (_awaitEpoch)
			{
				if ((_netEpoch != _epoch || _netState == SpiderState.Leap) && Time.time - _awaitSince < 1.5f)
				{
					return;
				}
				_awaitEpoch = false;
			}
			_epoch = _netEpoch;
			if (_netState != SpiderState.Leap)
			{
				_state = _netState;
			}
			float t = RemoteLerp;
			transform.SetPositionAndRotation(Vector3.Lerp(transform.position, MasterPosition, t), Quaternion.Slerp(transform.rotation, MasterRotation, t));
		}

		protected override void WriteExtraSync(PhotonStream stream)
		{
			stream.SendNext((byte)_state);
			stream.SendNext(_epoch);
		}

		protected override void ReadExtraSync(PhotonStream stream)
		{
			_netState = (SpiderState)(byte)stream.ReceiveNext();
			_netEpoch = (byte)stream.ReceiveNext();
		}

		private void AwaitEpoch()
		{
			_awaitEpoch = true;
			_awaitSince = Time.time;
		}

		protected override void LateUpdate()
		{
			base.LateUpdate();
			float deltaTime = Time.deltaTime;
			if (_state == SpiderState.Ground && IsAuthority && !IsJumpscaring)
			{
				Quaternion rotation = transform.rotation;
				_visualRot = ((Time.time < _settleUntil) ? Quaternion.Slerp(_visualRot, rotation, 1f - Mathf.Exp(-deltaTime / 0.08f)) : Quaternion.RotateTowards(_visualRot, rotation, GroundTurnRate * deltaTime));
				transform.rotation = _visualRot;
			}
			else
			{
				_visualRot = transform.rotation;
			}
			StabiliseHead();
			if (deltaTime <= 0f)
			{
				return;
			}
			Vector3 position = transform.position;
			Vector3 lastAnimPos = _lastAnimPos;
			_lastAnimPos = position;
			bool inTell = _leaping && Time.time - _leapStart < _leapAnticipation;
			bool airborne = (_leaping && !inTell) || _state == SpiderState.Fall;
			if (bodyAnimator != null)
			{
				bodyAnimator.speed = (inTell ? 0f : (airborne ? airborneAnimSpeed : Mathf.Min(Vector3.Distance(position, lastAnimPos) / deltaTime * _metresToAnimSpeed, 4f)));
			}
			if (bodyModel == null)
			{
				return;
			}
			float dip;
			if (inTell)
			{
				dip = Smooth01((Time.time - _leapStart) / _leapAnticipation);
			}
			else
			{
				_landPulse = Mathf.MoveTowards(_landPulse, 0f, deltaTime * 4f);
				dip = _landPulse * _landPulse;
			}
			Vector3 offset = Vector3.down * (dip * crouchDepth);
			if (inTell)
			{
				offset += Random.insideUnitSphere * (dip * 0.012f);
			}
			bodyModel.localPosition = _modelRest + offset;
		}

		private void StabiliseHead()
		{
			if (headTransform != null)
			{
				headTransform.rotation = Quaternion.LookRotation(FlatForward(), Vector3.up);
			}
		}

		private void PlaySfx(AudioClip clip)
		{
			if (clip != null && sfxSource != null && sfxSource.isActiveAndEnabled)
			{
				sfxSource.PlayOneShot(clip);
			}
		}

		private static int Classify(Vector3 normal)
		{
			if (normal.y > 0.7f)
			{
				return Floor;
			}
			if (normal.y < -0.5f)
			{
				return Ceiling;
			}
			return Wall;
		}

		private Vector3 FlatForward()
		{
			Vector3 flat = Vector3.ProjectOnPlane(transform.forward, Vector3.up);
			if (flat.sqrMagnitude < 0.04f)
			{
				flat = Vector3.ProjectOnPlane(transform.up, Vector3.up);
			}
			if (!(flat.sqrMagnitude > 1E-06f))
			{
				return Vector3.forward;
			}
			return flat.normalized;
		}

		private static float FlatDistance(Vector3 a, Vector3 b)
		{
			float dx = a.x - b.x;
			float dz = a.z - b.z;
			return Mathf.Sqrt(dx * dx + dz * dz);
		}

		private bool ProbeCeiling(Vector3 from, float range, out RaycastHit hit)
		{
			if (CastSurface(from, Vector3.up, range, out hit))
			{
				return hit.normal.y < -0.7f;
			}
			return false;
		}

		private Vector3 CeilingStand(RaycastHit ceiling)
		{
			return ceiling.point + ceiling.normal * _ride;
		}

		private bool CastSurface(Vector3 origin, Vector3 dir, float distance, out RaycastHit best)
		{
			int count = Physics.RaycastNonAlloc(origin, dir, _hits, distance, surfaceMask, QueryTriggerInteraction.Ignore);
			return PickNearest(count, out best);
		}

		private bool SphereBlocked(Vector3 from, Vector3 to, float radius = 0.3f)
		{
			Vector3 delta = to - from;
			float magnitude = delta.magnitude;
			if (magnitude < 0.001f)
			{
				return false;
			}
			int count = Physics.SphereCastNonAlloc(from, radius, delta / magnitude, _hits, magnitude, surfaceMask, QueryTriggerInteraction.Ignore);
			RaycastHit best;
			return PickNearest(count, out best);
		}

		private bool PickNearest(int count, out RaycastHit best)
		{
			best = default(RaycastHit);
			if (count < 1)
			{
				return false;
			}
			float bestDistance = float.MaxValue;
			for (int i = 0; i < count; i++)
			{
				RaycastHit hit = _hits[i];
				if ((!(hit.distance <= 0f) || !(hit.point == Vector3.zero)) && hit.distance < bestDistance && IsSurface(hit.collider))
				{
					bestDistance = hit.distance;
					best = hit;
				}
			}
			return bestDistance < float.MaxValue;
		}

		private bool IsSurface(Collider c)
		{
			if (c.attachedRigidbody != null)
			{
				return false;
			}
			EntityId entityId = c.GetEntityId();
			if (!_colliderIsMonster.TryGetValue(entityId, out bool isMonster))
			{
				isMonster = c.GetComponentInParent<BaseMonster>() != null;
				_colliderIsMonster[entityId] = isMonster;
			}
			return !isMonster;
		}

		private static float Smooth01(float t)
		{
			t = Mathf.Clamp01(t);
			return t * t * (3f - 2f * t);
		}
	}
}
