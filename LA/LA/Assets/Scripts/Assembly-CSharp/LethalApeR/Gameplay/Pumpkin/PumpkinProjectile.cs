using System.Collections.Generic;
using LethalApeR.Gameplay.Monsters;
using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	[DefaultExecutionOrder(-200)]
	[DisallowMultipleComponent]
	public class PumpkinProjectile : MonoBehaviour
	{
		public enum State
		{
			Pooled = 0,
			Docked = 1,
			Flying = 2,
			Bursting = 3
		}

		[Header("Network")]
		[Tooltip("A copy on another client leaves the nose where that client sees it and eases onto the shooter's line over this much of its flight (m), so a wall further away bursts it where it burst the shooter's.")]
		public float convergeDistance = 3f;

		[Tooltip("A copy on another client starts behind the shooter's clock and catches up over at least this long; longer for a bigger lag, so it never flies more than twice as fast.")]
		public float catchUpTime = 0.3f;

		[Tooltip("Seen by everyone else, a ridden pumpkin slides onto the rider's hand over this long.")]
		public float rideBlendTime = 0.2f;

		[Tooltip("Another player's hand this close to the round's surface when it fires is taken to be riding it, until they confirm or the timeout runs out.")]
		public float ridePredictReach = 0.12f;

		public float ridePredictTimeout = 0.5f;

		[Tooltip("A ridden pumpkin waits this long past the wall or the fuse for its rider to say where it burst, then bursts on its own.")]
		public float authorityWait = 0.75f;

		private const int MaxTouching = 4;

		private const float VictimBodyReach = 1.5f;

		private const float VictimPathReach = 2.5f;

		private const float RiderPathReach = 3f;

		private static readonly List<PumpkinAvatar> AvatarScratch = new List<PumpkinAvatar>(16);

		private PumpkinShot _shot;

		private Vector3 _lineStart;

		private Vector3 _direction = Vector3.forward;

		private float _lag;

		private float _lagWindow;

		private Vector3 _converge;

		private float _convergeFrom;

		private float _convergeTime;

		private bool _anchored;

		private bool _anchorConfirmed;

		private int _anchorActor;

		private bool _anchorLeft;

		private Vector3 _anchorOffset;

		private Vector3 _anchorDelta;

		private float _anchorBlend;

		private bool _holding;

		private float _holdLeft;

		private Vector3 _holdPoint;

		private Vector3 _holdNormal;

		private readonly int[] _touching = new int[4];

		private int _touchingCount;

		private static readonly List<IPumpkinSweepTarget> SweepTargets = new List<IPumpkinSweepTarget>(2);

		[Header("Spiral")]
		[Tooltip("Visual root that circles the flight line. Its children are the pumpkin and everything that trails it.")]
		public Transform spiral;

		[Tooltip("World-space lines drawn as the helix, spread evenly round it.")]
		public LineRenderer[] spiralRibbons = new LineRenderer[0];

		[Tooltip("How far the pumpkin itself swings off the line (m). Small: at full speed a big swing reads as shaking.")]
		public float spiralRadius = 0.05f;

		[Tooltip("Radius of the ribbons' helix (m).")]
		public float ribbonRadius = 0.2f;

		[Tooltip("Turns round the flight line per second. At 30 m/s, 3.5 turns is one twist every 8.6 m.")]
		public float spiralTurns = 3.5f;

		[Tooltip("Turns of the pumpkin about the flight line per second (the drill spin).")]
		public float spinTurns = 2f;

		[Tooltip("The corkscrew opens out over this long after leaving the nose, and closes again when someone rides it.")]
		public float spiralRamp = 0.15f;

		[Tooltip("How far behind the pumpkin's centre the ribbons start (m).")]
		public float ribbonBack = 0.36f;

		[Tooltip("Length of the ribbons, in seconds of flight. Keep spiralTurns x ribbonTime above ~1.5 so a full twist shows.")]
		public float ribbonTime = 0.45f;

		[Tooltip("Turn between two points of a smooth ribbon (degrees). Used when ribbonJag is 0.")]
		public float ribbonStepDegrees = 15f;

		[Tooltip("How jagged the ribbons are: 0 is a smooth helix, 1 is crackling lightning.")]
		[Range(0f, 1f)]
		public float ribbonJag = 1f;

		[Tooltip("Length of one straight lightning segment (m).")]
		public float jagLength = 0.5f;

		[Tooltip("How far each lightning kink swings round the line from the helix (degrees).")]
		public float jagAngle = 110f;

		[Tooltip("How far each lightning kink swings in or out from the helix, as a fraction of ribbonRadius.")]
		public float jagRadius = 0.5f;

		[Tooltip("Every other kink falls back along the flight by up to this many segments. Past 1 the ribbon doubles back on itself, which draws the sharp hairpin blades.")]
		public float jagBack = 3f;

		[Tooltip("Points along each long lightning run, which then sweeps round the helix in an arc. 1 keeps runs straight.")]
		public int jagArcSteps = 4;

		private const int RibbonHistory = 96;

		private const int MaxRibbonPoints = 128;

		private readonly float[] _historyAge = new float[96];

		private readonly Vector3[] _historyCentre = new Vector3[96];

		private int _historyHead;

		private int _historyCount;

		private Vector3[] _ribbonPoints;

		private float _spiralOpen;

		private float _spin;

		private int _jagSeed;

		[Header("Parts")]
		[Tooltip("Hit and ride collider, on a layer hands can plant on. It never turns, so riders aren't spun.")]
		public SphereCollider body;

		[Tooltip("Visual root: popped in on reload, wobbled in flight, hidden on the burst.")]
		public Transform model;

		[Header("Flight")]
		public float speed = 14f;

		[Tooltip("Bursts in mid-air after flying this long.")]
		public float fuse = 3f;

		[Tooltip("Sweep radius against the world.")]
		public float hitRadius = 0.17f;

		public LayerMask hitMask = 2883841;

		public float wobbleAngle = 7f;

		public float wobbleSpeed = 6f;

		[Header("Blast")]
		[Tooltip("Full strength out to here.")]
		public float innerRadius = 0.75f;

		public float radius = 4.5f;

		[Tooltip("Speed a player at full strength is knocked away with (m/s).")]
		public float knockbackSpeed = 11f;

		public float maxKnockbackSpeed = 16f;

		[Range(0f, 1f)]
		public float upwardBias = 0.35f;

		[Tooltip("Planted hands let go for this long, so they can't cancel the push.")]
		public float letGoSeconds = 0.2f;

		[Tooltip("Stun at full strength, for receivers that can be stunned (monsters).")]
		public float stunSeconds = 2f;

		[Tooltip("How hard your own blast pushes you (1 = full rocket jumps).")]
		[Range(0f, 2f)]
		public float selfKnockbackScale = 1f;

		[Tooltip("Impulse (N s) for loose props; their speed is capped below.")]
		public float propImpulse = 45f;

		public float maxPropSpeed = 12f;

		public LayerMask blastMask = -37;

		[Tooltip("Walls on these layers shelter whatever is behind them.")]
		public LayerMask occluderMask = 1;

		[Tooltip("The blast centre sits this far off the surface it hit.")]
		public float surfaceOffset = 0.2f;

		[Header("Flight effects")]
		[Tooltip("Exhaust streak behind the pumpkin: a cone along -Z, 1 m long, scaled to the tail's current length.")]
		public Transform tail;

		public float tailLength = 4f;

		[Tooltip("Thickness of the streak (scales the cone's radius).")]
		public float tailWidth = 1f;

		[Tooltip("Width of the tail while it is still short, as a share of its full width.")]
		[Range(0.1f, 1f)]
		public float tailStartWidth = 0.45f;

		[Tooltip("World-space systems (sparks): play on launch, stop emitting on the burst.")]
		public ParticleSystem[] trailEffects = new ParticleSystem[0];

		[Tooltip("Local-space glows around the pumpkin while it flies (one particle each).")]
		public ParticleSystem[] glows = new ParticleSystem[0];

		[Header("Burst effects")]
		[Tooltip("Placed at the hit and turned to face out of the surface.")]
		public Transform burst;

		public ParticleSystem[] burstEffects = new ParticleSystem[0];

		[Tooltip("Only when it hits a surface (dust thrown along it), not on a mid-air burst.")]
		public ParticleSystem[] surfaceEffects = new ParticleSystem[0];

		public Light burstLight;

		public float burstLightIntensity = 6f;

		public float burstLightDuration = 0.4f;

		public Gradient burstLightColor = new Gradient();

		[Tooltip("Back to the pool after this long at the latest.")]
		public float burstLifetime = 4f;

		[Header("Audio")]
		public AudioSource flightAudio;

		public Vector2 flightPitch = new Vector2(0.95f, 1.05f);

		public AudioSource burstAudio;

		public AudioClip burstClip;

		[Range(0f, 1f)]
		public float burstVolume = 1f;

		public Vector2 burstPitch = new Vector2(0.92f, 1.06f);

		[Tooltip("Wet pumpkin layer under the boom.")]
		public AudioClip splatClip;

		[Range(0f, 1f)]
		public float splatVolume = 0.3f;

		private static readonly Dictionary<PumpkinProjectile, Stack<PumpkinProjectile>> Pools = new Dictionary<PumpkinProjectile, Stack<PumpkinProjectile>>();

		private static readonly RaycastHit[] Hits = new RaycastHit[16];

		private static readonly Collider[] Overlaps = new Collider[8];

		private static Transform _poolRoot;

		private PumpkinProjectile _prefab;

		private Vector3 _modelScale = Vector3.one;

		private Quaternion _modelRotation = Quaternion.identity;

		private Quaternion _tailRotation = Quaternion.identity;

		private float _age;

		private float _popTime;

		private float _popDuration;

		private float _burstAge;

		private float _nextAliveCheck;

		private float _wobblePhase;

		private float _tail;

		private Transform _ignoreRoot;

		private Object _instigator;

		private bool _ridden;

		public PumpkinShot Shot => _shot;

		public bool IsRiddenRemotely => _anchored;

		private bool CanHitLocalBody
		{
			get
			{
				if (_shot != null && !_shot.isLocal)
				{
					return !_ridden;
				}
				return false;
			}
		}

		public State Current { get; private set; }

		public bool IsReady
		{
			get
			{
				if (Current == State.Docked)
				{
					return _popTime >= _popDuration;
				}
				return false;
			}
		}

		public bool IsFlying => Current == State.Flying;

		public bool HasRiders => _ridden;

		private static Transform PoolRoot
		{
			get
			{
				if (_poolRoot == null)
				{
					_poolRoot = new GameObject("Pumpkin Projectile Pool").transform;
				}
				return _poolRoot;
			}
		}

		private void ResetFlight()
		{
			if (_shot != null)
			{
				PumpkinNet.Forget(_shot);
			}
			_shot = null;
			_lag = 0f;
			_convergeTime = 0f;
			_holding = false;
			_anchored = false;
			_anchorConfirmed = false;
			_anchorActor = 0;
			_converge = Vector3.zero;
			_touchingCount = 0;
		}

		public void Launch(Vector3 direction, Vector3 checkFrom, Transform ignoreRoot, Object instigator, PumpkinShot shot = null)
		{
			if (Current != State.Docked)
			{
				return;
			}
			if (direction.sqrMagnitude < 1E-06f)
			{
				direction = transform.forward;
			}
			direction = direction.normalized;
			_ridden = body != null && body.enabled && PumpkinRig.IsPinnedTo(body);
			Vector3 position = transform.position;
			BeginFlight(shot, ignoreRoot, instigator, position, direction, 0f, Vector3.zero);
			CollectTouching((shot != null) ? shot.shooter : 0);
			CheckMuzzle(checkFrom, position, direction);
		}

		public void LaunchRemote(PumpkinShot shot, Transform ignoreRoot)
		{
			if (shot == null || Current != State.Docked)
			{
				return;
			}
			Vector3 position = transform.position;
			bool left = false;
			_ridden = body != null && body.enabled && PumpkinRig.PinnedHand(body, out left);
			if (_ridden)
			{
				BeginFlight(shot, ignoreRoot, null, position, shot.direction, 0f, Vector3.zero);
				Transform hand = PumpkinRig.SyncedHand(left);
				Vector3 offset = (hand != null) ? (position - hand.position) : Vector3.zero;
				PumpkinNet.SendRide(shot, left, offset);
			}
			else
			{
				float lag = Mathf.Clamp((float)(GorillaLocomotion.PlatformClock.NowMs - shot.serverMs) / 1000f, 0f, 0.5f);
				BeginFlight(shot, ignoreRoot, null, shot.origin, shot.direction, lag, position - shot.origin);
			}
			CollectTouching(shot.shooter);
			CheckMuzzle(shot.breech, shot.origin, shot.direction);
		}

		private void BeginFlight(PumpkinShot shot, Transform ignoreRoot, Object instigator, Vector3 lineStart, Vector3 direction, float lag, Vector3 converge)
		{
			_shot = shot;
			if (shot != null)
			{
				shot.projectile = this;
			}
			_ignoreRoot = ignoreRoot;
			_instigator = instigator;
			_lineStart = lineStart;
			_direction = direction;
			_lag = lag;
			_lagWindow = Mathf.Max(catchUpTime, lag * 1.5f);
			_converge = converge;
			_convergeFrom = 0f;
			_convergeTime = ((converge.sqrMagnitude > 1E-08f) ? Mathf.Max(convergeDistance / Mathf.Max(speed, 1f), 0.02f) : 0f);
			_holding = false;
			_anchored = false;
			_anchorConfirmed = false;
			_age = 0f;
			transform.SetParent(null, worldPositionStays: true);
			transform.position = lineStart + converge;
			if (tail != null)
			{
				tail.rotation = Quaternion.LookRotation(direction, Vector3.up) * _tailRotation;
			}
			_popTime = _popDuration;
			UpdatePop(0f);
			Current = State.Flying;
			if (body != null)
			{
				body.enabled = _ridden;
			}
			for (int i = 0; i < trailEffects.Length; i++)
			{
				if (trailEffects[i] != null)
				{
					trailEffects[i].Play(withChildren: true);
				}
			}
			for (int j = 0; j < glows.Length; j++)
			{
				ParticleSystem glow = glows[j];
				if (!(glow == null))
				{
					glow.Clear(withChildren: true);
					glow.Play(withChildren: true);
					glow.Emit(1);
				}
			}
			SetTail(0f);
			if (flightAudio != null)
			{
				flightAudio.pitch = Random.Range(flightPitch.x, flightPitch.y);
				flightAudio.Play();
			}
		}

		private void CheckMuzzle(Vector3 checkFrom, Vector3 start, Vector3 direction)
		{
			Vector3 back = checkFrom - start;
			if (back.sqrMagnitude > 1E-06f && FirstHit(checkFrom, -back, back.magnitude, hitRadius * 0.5f, out var best, out var startedInside))
			{
				if (startedInside)
				{
					Explode(checkFrom, -direction, _ridden);
				}
				else
				{
					Explode(best.point, best.normal, _ridden);
				}
			}
			else if (Overlapping(start))
			{
				Explode(start, -direction, _ridden);
			}
		}

		private void CollectTouching(int shooter)
		{
			_touchingCount = 0;
			if (body == null)
			{
				return;
			}
			PumpkinRig.Avatars.Collect(AvatarScratch);
			if (AvatarScratch.Count == 0)
			{
				return;
			}
			Vector3 position = transform.position;
			float reachBase = body.radius * MaxAbs(body.transform.lossyScale);
			float best = float.MaxValue;
			bool bestLeft = false;
			int bestIndex = -1;
			for (int i = 0; i < AvatarScratch.Count; i++)
			{
				PumpkinAvatar avatar = AvatarScratch[i];
				if (avatar.actor == shooter)
				{
					continue;
				}
				for (int h = 0; h < 2; h++)
				{
					bool left = h == 0;
					Transform hand = avatar.Hand(left);
					if (hand == null)
					{
						continue;
					}
					float reach = reachBase + avatar.scale * ridePredictReach;
					float sqr = (hand.position - position).sqrMagnitude;
					if (!(sqr > reach * reach))
					{
						AddTouching(avatar.actor);
						if (sqr < best)
						{
							best = sqr;
							bestLeft = left;
							bestIndex = i;
						}
					}
				}
			}
			if (bestIndex >= 0 && !_ridden)
			{
				PumpkinAvatar avatar2 = AvatarScratch[bestIndex];
				Anchor(avatar2.actor, bestLeft, position - avatar2.Hand(bestLeft).position, confirmed: false);
			}
			AvatarScratch.Clear();
		}

		private void AddTouching(int actor)
		{
			for (int i = 0; i < _touchingCount; i++)
			{
				if (_touching[i] == actor)
				{
					return;
				}
			}
			if (_touchingCount < MaxTouching)
			{
				_touching[_touchingCount++] = actor;
			}
		}

		private bool IsTouching(int actor)
		{
			for (int i = 0; i < _touchingCount; i++)
			{
				if (_touching[i] == actor)
				{
					return true;
				}
			}
			return false;
		}

		private void Fly(float dt)
		{
			_age += dt;
			Vector3 from = transform.position;
			if (_holding)
			{
				_holdLeft -= dt;
				if (!(_holdLeft > 0f))
				{
					Explode(_holdPoint, _holdNormal, tell: false);
				}
				return;
			}
			Vector3 to = (_anchored ? AnchoredPosition(dt) : LinePosition(_age));
			bool anchored = _anchored;
			bool live = true;
			if (!anchored && TrueAge(_age) >= fuse)
			{
				to = LineAt(fuse, _age);
				live = false;
			}
			Vector3 delta = to - from;
			float distance = delta.magnitude;
			Vector3 dir = ((distance > 1E-06f) ? (delta / distance) : _direction);
			float first = float.MaxValue;
			Vector3 normal = Vector3.zero;
			Vector3 point = Vector3.zero;
			int hitKind = 0;
			if (FirstHit(from, dir, distance, hitRadius, out var hit, out var startedInside))
			{
				if (startedInside)
				{
					first = 0f;
					point = from;
					normal = -dir;
				}
				else
				{
					first = hit.distance / Mathf.Max(distance, 1E-06f);
					point = hit.point;
					normal = hit.normal;
				}
				hitKind = 1;
			}
			if (!anchored)
			{
				if (CanHitLocalBody && PumpkinRig.TryGetLocalBody(out var localBody) && PumpkinRig.Sweep(from, delta, hitRadius, in localBody, out var t, out var bodyNormal) && t < first)
				{
					first = t;
					normal = bodyNormal;
					hitKind = 2;
				}
				if (SweepAvatars(from, delta, ref first, ref normal))
				{
					hitKind = 3;
				}
				if (SweepMonsters(from, delta, ref first, ref normal))
				{
					hitKind = 3;
				}
			}
			if (hitKind == 0)
			{
				transform.position = to;
				SetTail(distance + _tail);
				if (!live)
				{
					Explode(to, Vector3.zero, _ridden);
				}
				else if (anchored && TrueAge(_age) >= fuse + authorityWait)
				{
					Explode(to, Vector3.zero, tell: false);
				}
				else
				{
					PoseInFlight(dt);
				}
				return;
			}
			Vector3 at = from + delta * Mathf.Clamp01(first);
			transform.position = at;
			SetTail(_tail + distance * Mathf.Clamp01(first));
			switch (hitKind)
			{
			case 2:
				Explode(at, normal, tell: true);
				break;
			case 1:
				if (anchored)
				{
					Hold(point, normal);
				}
				else
				{
					Explode(point, normal, _ridden);
				}
				break;
			default:
				Explode(at, normal, _ridden);
				break;
			}
		}

		private bool SweepAvatars(Vector3 from, Vector3 delta, ref float first, ref Vector3 normal)
		{
			bool result = false;
			PumpkinRig.Avatars.Collect(AvatarScratch);
			int shooter = ((_shot != null) ? _shot.shooter : 0);
			for (int i = 0; i < AvatarScratch.Count; i++)
			{
				PumpkinAvatar avatar = AvatarScratch[i];
				if (avatar.actor != shooter && !IsTouching(avatar.actor))
				{
					PumpkinBody body = avatar.Body;
					if (PumpkinRig.Sweep(from, delta, hitRadius, in body, out var t, out var hitNormal) && t < first)
					{
						first = t;
						normal = hitNormal;
						result = true;
					}
				}
			}
			AvatarScratch.Clear();
			return result;
		}

		private float TrueAge(float age)
		{
			if (_lag <= 0f)
			{
				return age;
			}
			return age + _lag * Smooth01(age / Mathf.Max(_lagWindow, 0.01f));
		}

		private Vector3 LinePosition(float age)
		{
			return LineAt(TrueAge(age), age);
		}

		private Vector3 LineAt(float trueAge, float age)
		{
			Vector3 result = _lineStart + _direction * (speed * trueAge);
			if (_convergeTime > 0f)
			{
				result += _converge * (1f - Smooth01((age - _convergeFrom) / _convergeTime));
			}
			return result;
		}

		private static float Smooth01(float t)
		{
			t = Mathf.Clamp01(t);
			return t * t * (3f - 2f * t);
		}

		private static float MaxAbs(Vector3 v)
		{
			return Mathf.Max(Mathf.Abs(v.x), Mathf.Max(Mathf.Abs(v.y), Mathf.Abs(v.z)));
		}

		private void Anchor(int actor, bool left, Vector3 offset, bool confirmed)
		{
			if (PumpkinRig.Avatars.TryFind(actor, out var avatar))
			{
				Transform hand = avatar.Hand(left);
				if (!(hand == null))
				{
					_anchored = true;
					_anchorConfirmed = confirmed;
					_anchorActor = actor;
					_anchorLeft = left;
					_anchorOffset = offset;
					_anchorDelta = transform.position - (hand.position + offset);
					_anchorBlend = 0f;
				}
			}
		}

		private Vector3 AnchoredPosition(float dt)
		{
			if (!PumpkinRig.Avatars.TryFind(_anchorActor, out var avatar) || avatar.Hand(_anchorLeft) == null || (!_anchorConfirmed && _age >= ridePredictTimeout))
			{
				ReleaseAnchor();
				return LinePosition(_age);
			}
			_anchorBlend = ((rideBlendTime > 0f) ? Mathf.Min(dt / rideBlendTime + _anchorBlend, 1f) : 1f);
			return avatar.Hand(_anchorLeft).position + _anchorOffset + _anchorDelta * (1f - Smooth01(_anchorBlend));
		}

		private void ReleaseAnchor()
		{
			_anchored = false;
			_anchorConfirmed = false;
			_anchorActor = 0;
			_convergeTime = 0f;
			_converge = transform.position - LinePosition(_age);
			_convergeFrom = _age;
			_convergeTime = Mathf.Max(catchUpTime * 1.5f, _converge.magnitude * 1.5f / Mathf.Max(speed, 1f));
		}

		private void Hold(Vector3 point, Vector3 normal)
		{
			_holding = true;
			_holdLeft = authorityWait;
			_holdPoint = point;
			_holdNormal = normal;
		}

		public void OnRideClaim(int actor, bool left, Vector3 offset)
		{
			if (Current == State.Flying)
			{
				AddTouching(actor);
				if (!_ridden && (!_anchored || !_anchorConfirmed || _anchorActor == actor))
				{
					Anchor(actor, left, offset, confirmed: true);
				}
			}
		}

		public bool AcceptsBurstFrom(int actor, Vector3 point)
		{
			if (Current != State.Flying || _ridden)
			{
				return false;
			}
			if (_anchored && _anchorConfirmed)
			{
				if (_anchorActor == actor)
				{
					return NearPath(point, RiderPathReach);
				}
				return false;
			}
			if (!PumpkinRig.Avatars.TryFind(actor, out var avatar))
			{
				return false;
			}
			PumpkinBody body = avatar.Body;
			if (PumpkinRig.DistanceTo(in body, point) > avatar.scale * VictimBodyReach)
			{
				return false;
			}
			return NearPath(point, VictimPathReach);
		}

		public void BurstFromNetwork(Vector3 point, Vector3 normal)
		{
			if (Current == State.Flying)
			{
				transform.position = point;
				Explode(point, normal, tell: false);
			}
		}

		private bool NearPath(Vector3 point, float reach)
		{
			Vector3 end = _lineStart + _direction * (speed * (fuse + authorityWait));
			return (point - PumpkinRig.ClosestOnSegment(point, _lineStart, end)).sqrMagnitude <= reach * reach;
		}

		public static void AddSweepTarget(IPumpkinSweepTarget target)
		{
			if (target != null && !SweepTargets.Contains(target))
			{
				SweepTargets.Add(target);
			}
		}

		public static void RemoveSweepTarget(IPumpkinSweepTarget target)
		{
			SweepTargets.Remove(target);
		}

		private bool SweepMonsters(Vector3 from, Vector3 delta, ref float first, ref Vector3 normal)
		{
			bool result = false;
			for (int num = SweepTargets.Count - 1; num >= 0; num--)
			{
				IPumpkinSweepTarget target = SweepTargets[num];
				if (target is Object obj && obj == null)
				{
					SweepTargets.RemoveAt(num);
				}
				else
				{
					result |= target.SweepPumpkin(from, delta, hitRadius, ref first, ref normal);
				}
			}
			MonsterManager instance = MonsterManager.Instance;
			if (instance == null)
			{
				return result;
			}
			List<BaseMonster> monsters = instance.Monsters;
			float reach = delta.magnitude + 4f;
			for (int i = 0; i < monsters.Count; i++)
			{
				BaseMonster monster = monsters[i];
				if (monster == null || !monster.isActiveAndEnabled)
				{
					continue;
				}
				Bounds bounds = monster.BodyBounds;
				if (!((bounds.center - from).sqrMagnitude > reach * reach))
				{
					PumpkinBody body = BodyOf(in bounds);
					if (PumpkinRig.Sweep(from, delta, hitRadius, in body, out var t, out var hitNormal) && t < first)
					{
						first = t;
						normal = hitNormal;
						result = true;
					}
				}
			}
			return result;
		}

		private static PumpkinBody BodyOf(in Bounds b)
		{
			Vector3 center = b.center;
			Vector3 extents = b.extents;
			float radius = Mathf.Min(extents.x, extents.z);
			Vector3 half = Vector3.up * Mathf.Max(0f, extents.y - radius);
			Vector3 top = center + half;
			return new PumpkinBody
			{
				head = top,
				headRadius = radius,
				torsoTop = top,
				torsoBottom = center - half,
				torsoRadius = radius
			};
		}

		private void ResetSpiral()
		{
			_spiralOpen = 0f;
			_spin = 0f;
			_historyCount = 0;
			_jagSeed = Random.Range(0, 1048576);
			if (spiral != null)
			{
				spiral.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
			}
			StopSpiral();
		}

		private void StopSpiral()
		{
			for (int i = 0; i < spiralRibbons.Length; i++)
			{
				LineRenderer lineRenderer = spiralRibbons[i];
				if (!(lineRenderer == null))
				{
					lineRenderer.enabled = false;
					lineRenderer.positionCount = 0;
				}
			}
		}

		private void PoseInFlight(float dt)
		{
			float target = ((_ridden || _anchored) ? 0f : 1f);
			_spiralOpen = Mathf.MoveTowards(_spiralOpen, target, dt / Mathf.Max(spiralRamp, 0.001f));
			float open = Smooth01(_spiralOpen);
			Vector3 axis = ((_direction.sqrMagnitude > 1E-06f) ? _direction.normalized : transform.forward);
			Vector3 side = Vector3.Cross(axis, (Mathf.Abs(axis.y) > 0.95f) ? Vector3.right : Vector3.up).normalized;
			_spin = Mathf.Repeat(_spin + spinTurns * 360f * open * dt, 360f);
			if (model != null)
			{
				float w = (_age + _wobblePhase) * wobbleSpeed;
				Quaternion wobble = Quaternion.Euler(wobbleAngle * Mathf.Sin(w), wobbleAngle * Mathf.Sin(w * 0.73f + 1.3f), wobbleAngle * Mathf.Sin(w * 0.51f) * 1.4f);
				Vector3 localAxis = ((model.parent != null) ? model.parent.InverseTransformDirection(axis) : axis);
				model.localRotation = Quaternion.AngleAxis(_spin, localAxis) * wobble * _modelRotation;
			}
			if (spiral != null)
			{
				spiral.position = transform.position + Quaternion.AngleAxis(_age * spiralTurns * 360f, axis) * side * (open * spiralRadius);
			}
			Record(_age, transform.position - axis * ribbonBack);
			DrawRibbons(axis, side, open * ribbonRadius);
		}

		private void Record(float age, Vector3 centre)
		{
			_historyHead = (_historyHead + 1) % RibbonHistory;
			_historyAge[_historyHead] = age;
			_historyCentre[_historyHead] = centre;
			if (_historyCount < RibbonHistory)
			{
				_historyCount++;
			}
		}

		private void DrawRibbons(Vector3 axis, Vector3 side, float radius)
		{
			int back = 0;
			int count = spiralRibbons.Length;
			if (count == 0 || _historyCount == 0)
			{
				return;
			}
			if (_ribbonPoints == null)
			{
				_ribbonPoints = new Vector3[MaxRibbonPoints];
			}
			float tailAge = Mathf.Max(_historyAge[(_historyHead - _historyCount + 1 + RibbonHistory) % RibbonHistory], _age - ribbonTime);
			float jag = ribbonJag;
			float step = ((jag > 0f) ? Mathf.Max(jagLength, 0.05f) : Mathf.Max(ribbonStepDegrees, 1f)) / Mathf.Max((jag > 0f) ? speed : (spiralTurns * 360f), 1f);
			int newest = Mathf.CeilToInt(_age / step);
			int oldest = Mathf.Max(Mathf.FloorToInt(tailAge / step), newest - 125);
			for (int r = 0; r < count; r++)
			{
				LineRenderer ribbon = spiralRibbons[r];
				if (ribbon == null)
				{
					continue;
				}
				float turn = (float)r * 360f / (float)count;
				back = 0;
				_ribbonPoints[0] = HelixPoint(_age, turn, radius, axis, side, ref back);
				int points = 1;
				float prevAge = _age;
				float prevTurn = turn;
				float prevRadius = radius;
				for (int k = newest; k >= oldest && points < MaxRibbonPoints - 1; k--)
				{
					float kinkAge = step * (float)k;
					float kinkTurn = turn;
					float kinkRadius = radius;
					if (jag > 0f)
					{
						uint h = KinkHash(_jagSeed, k, r);
						kinkAge += (((k & 1) == 0) ? (step * 0.3f * HashSigned(h, 0)) : (-step * jagBack * ribbonJag * (0.65f + 0.35f * HashSigned(h, 0))));
						if (!(kinkAge > tailAge) || !(kinkAge < _age))
						{
							continue;
						}
						kinkTurn = turn + jagAngle * ribbonJag * HashSigned(h, 1);
						kinkRadius = (1f + ribbonJag * jagRadius * HashSigned(h, 2)) * radius;
						if (prevAge - kinkAge > step * 1.5f)
						{
							for (int s = 1; s < jagArcSteps && points < MaxRibbonPoints - 2; s++)
							{
								float t = (float)s / (float)jagArcSteps;
								_ribbonPoints[points++] = HelixPoint(Mathf.Lerp(prevAge, kinkAge, t), Mathf.Lerp(prevTurn, kinkTurn, t), Mathf.Lerp(prevRadius, kinkRadius, t), axis, side, ref back);
							}
						}
					}
					else if (!(kinkAge > tailAge) || !(kinkAge < _age))
					{
						continue;
					}
					_ribbonPoints[points++] = HelixPoint(kinkAge, kinkTurn, kinkRadius, axis, side, ref back);
					prevAge = kinkAge;
					prevTurn = kinkTurn;
					prevRadius = kinkRadius;
				}
				_ribbonPoints[points] = HelixPoint(tailAge, turn, radius, axis, side, ref back);
				ribbon.positionCount = points + 1;
				ribbon.SetPositions(_ribbonPoints);
				ribbon.enabled = true;
			}
		}

		private Vector3 HelixPoint(float age, float turn, float radius, Vector3 axis, Vector3 side, ref int back)
		{
			return CentreAt(age, ref back) + Quaternion.AngleAxis(spiralTurns * age * 360f + turn, axis) * side * radius;
		}

		private static uint KinkHash(int seed, int kink, int ribbon)
		{
			uint h = ((uint)kink * 0x85EBCA77u) ^ ((uint)seed * 0x9E3779B1u) ^ ((uint)ribbon * 0xC2B2AE3Du);
			h ^= h >> 15;
			h *= 0x2C1B3C6Du;
			h ^= h >> 12;
			h *= 0x297A2D39u;
			return h ^ (h >> 15);
		}

		private static float HashSigned(uint h, int slot)
		{
			return (float)((h >> slot * 10) & 0x3FF) / 511.5f - 1f;
		}

		private Vector3 CentreAt(float age, ref int back)
		{
			while (back > 0 && _historyAge[(_historyHead - back + RibbonHistory) % RibbonHistory] < age)
			{
				back--;
			}
			while (back < _historyCount - 1)
			{
				int newer = (_historyHead - back + RibbonHistory) % RibbonHistory;
				int older = (newer + RibbonHistory - 1) % RibbonHistory;
				float olderAge = _historyAge[older];
				if (olderAge <= age)
				{
					float span = _historyAge[newer] - olderAge;
					float t = ((span > 1E-06f) ? ((age - olderAge) / span) : 1f);
					return Vector3.Lerp(_historyCentre[older], _historyCentre[newer], t);
				}
				back++;
			}
			return _historyCentre[(_historyHead - back + RibbonHistory) % RibbonHistory];
		}

		public static PumpkinProjectile Take(PumpkinProjectile prefab)
		{
			if (prefab == null)
			{
				return null;
			}
			if (!Pools.TryGetValue(prefab, out var value))
			{
				value = new Stack<PumpkinProjectile>();
				Pools[prefab] = value;
			}
			while (value.Count > 0)
			{
				PumpkinProjectile pumpkinProjectile = value.Pop();
				if (!(pumpkinProjectile == null))
				{
					pumpkinProjectile.gameObject.SetActive(value: true);
					return pumpkinProjectile;
				}
			}
			PumpkinProjectile pumpkinProjectile2 = Object.Instantiate(prefab);
			pumpkinProjectile2.name = prefab.name;
			pumpkinProjectile2._prefab = prefab;
			return pumpkinProjectile2;
		}

		public static void Prewarm(PumpkinProjectile prefab, int count)
		{
			if (prefab == null)
			{
				return;
			}
			if (!Pools.TryGetValue(prefab, out var value))
			{
				value = new Stack<PumpkinProjectile>();
				Pools[prefab] = value;
			}
			for (int num = count - value.Count; num > 0; num--)
			{
				PumpkinProjectile pumpkinProjectile = Object.Instantiate(prefab);
				pumpkinProjectile.name = prefab.name;
				pumpkinProjectile._prefab = prefab;
				pumpkinProjectile.Recycle();
			}
		}

		public void Recycle()
		{
			ResetState();
			Current = State.Pooled;
			if (_prefab == null)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			base.transform.SetParent(PoolRoot, false);
			base.gameObject.SetActive(false);
			Pools[_prefab].Push(this);
		}

		private void Awake()
		{
			if (model != null)
			{
				_modelScale = model.localScale;
				_modelRotation = model.localRotation;
			}
			if (tail != null)
			{
				_tailRotation = tail.localRotation;
			}
			_wobblePhase = Random.value * 10f;
		}

		private void OnEnable()
		{
			if (body != null && Current == State.Docked)
			{
				body.enabled = _popTime >= _popDuration;
			}
		}

		private void OnDisable()
		{
			if (body != null)
			{
				body.enabled = false;
			}
		}

		private void ResetState()
		{
			ResetFlight();
			_ridden = false;
			_ignoreRoot = null;
			_instigator = null;
			_burstAge = 0f;
			_age = 0f;
			if (body != null)
			{
				body.enabled = false;
			}
			if (model != null)
			{
				model.gameObject.SetActive(true);
				model.localScale = _modelScale;
				model.localRotation = _modelRotation;
			}
			for (int i = 0; i < trailEffects.Length; i++)
			{
				if (trailEffects[i] != null)
				{
					trailEffects[i].Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
				}
			}
			StopAll(burstEffects);
			StopAll(surfaceEffects);
			ClearGlows();
			ResetSpiral();
			SetTail(0f);
			if (tail != null)
			{
				tail.localRotation = _tailRotation;
			}
			if (burstLight != null)
			{
				burstLight.enabled = false;
			}
			if (flightAudio != null)
			{
				flightAudio.Stop();
			}
			if (burstAudio != null)
			{
				burstAudio.Stop();
			}
		}

		public void Dock(Transform socket, float popDuration)
		{
			ResetState();
			base.transform.SetParent(socket, false);
			base.transform.localPosition = Vector3.zero;
			base.transform.localRotation = Quaternion.identity;
			Current = State.Docked;
			_popTime = 0f;
			_popDuration = Mathf.Max(0f, popDuration);
			UpdatePop(0f);
		}

		private void Update()
		{
			float deltaTime = Time.deltaTime;
			if (deltaTime <= 0f)
			{
				return;
			}
			switch (Current)
			{
			case State.Docked:
				if (_popTime < _popDuration)
				{
					UpdatePop(deltaTime);
				}
				break;
			case State.Flying:
				Fly(deltaTime);
				break;
			case State.Bursting:
				UpdateBurst(deltaTime);
				break;
			}
		}

		private void UpdatePop(float dt)
		{
			_popTime = Mathf.Min(_popTime + dt, _popDuration);
			float t = (_popDuration > 0f) ? (_popTime / _popDuration) : 1f;
			if (model != null)
			{
				model.localScale = _modelScale * BackOut(t);
			}
			if (body != null && Current == State.Docked)
			{
				body.enabled = t >= 1f;
			}
		}

		public static float BackOut(float t)
		{
			t -= 1f;
			return t * t * (3.2f * t + 2.2f) + 1f;
		}

		private bool FirstHit(Vector3 from, Vector3 direction, float distance, float sweepRadius, out RaycastHit best, out bool startedInside)
		{
			best = default(RaycastHit);
			startedInside = false;
			if (distance <= 0f)
			{
				return false;
			}
			int count = Physics.SphereCastNonAlloc(from, sweepRadius, direction.normalized, Hits, distance, hitMask, QueryTriggerInteraction.Ignore);
			bool found = false;
			for (int i = 0; i < count; i++)
			{
				RaycastHit hit = Hits[i];
				if (Ignored(hit.collider))
				{
					continue;
				}
				bool inside = hit.distance <= 0f && hit.point == Vector3.zero;
				if (!found || hit.distance < best.distance)
				{
					best = hit;
					startedInside = inside;
				}
				found = true;
			}
			return found;
		}

		private bool Overlapping(Vector3 at)
		{
			int count = Physics.OverlapSphereNonAlloc(at, hitRadius, Overlaps, hitMask, QueryTriggerInteraction.Ignore);
			bool any = false;
			for (int i = 0; i < count; i++)
			{
				any |= !Ignored(Overlaps[i]);
			}
			System.Array.Clear(Overlaps, 0, count);
			return any;
		}

		private bool Ignored(Collider c)
		{
			if (c == null || c == body)
			{
				return true;
			}
			if (_ignoreRoot != null && c.transform.IsChildOf(_ignoreRoot))
			{
				return true;
			}
			if (c.TryGetComponent<PumpkinProjectile>(out var _))
			{
				return true;
			}
			return c.GetComponentInParent<PumpkinLauncher>() != null;
		}

		public void Burst(Vector3 point, Vector3 normal)
		{
			Explode(point, normal, _ridden);
		}

		private void Explode(Vector3 point, Vector3 normal, bool tell)
		{
			if (Current == State.Pooled || Current == State.Bursting)
			{
				return;
			}
			if (Current == State.Docked)
			{
				base.transform.SetParent(null, true);
			}
			if (tell && _shot != null)
			{
				PumpkinNet.SendBurst(_shot, point, normal);
			}
			Current = State.Bursting;
			_burstAge = 0f;
			_nextAliveCheck = 0.5f;
			_ridden = false;
			if (body != null)
			{
				body.enabled = false;
			}
			if (model != null)
			{
				model.gameObject.SetActive(false);
			}
			for (int i = 0; i < trailEffects.Length; i++)
			{
				if (trailEffects[i] != null)
				{
					trailEffects[i].Stop(true, ParticleSystemStopBehavior.StopEmitting);
				}
			}
			ClearGlows();
			StopSpiral();
			if (flightAudio != null)
			{
				flightAudio.Stop();
			}
			bool surface = normal.sqrMagnitude >= 0.25f;
			if (surface)
			{
				normal = normal.normalized;
				point += normal * surfaceOffset;
			}
			else
			{
				normal = Vector3.up;
			}
			if (burst != null)
			{
				burst.SetPositionAndRotation(point, Quaternion.LookRotation(normal, (Mathf.Abs(normal.y) > 0.9f) ? Vector3.forward : Vector3.up));
				PlayAll(burstEffects);
				if (surface)
				{
					PlayAll(surfaceEffects);
				}
			}
			if (burstLight != null)
			{
				burstLight.enabled = true;
				UpdateBurstLight();
			}
			if (burstAudio != null)
			{
				burstAudio.pitch = Random.Range(burstPitch.x, burstPitch.y);
				if (burstClip != null)
				{
					burstAudio.PlayOneShot(burstClip, burstVolume);
				}
				if (splatClip != null && splatVolume > 0f)
				{
					burstAudio.PlayOneShot(splatClip, splatVolume);
				}
			}
			BlastInfo blast = new BlastInfo
			{
				center = point,
				innerRadius = innerRadius,
				radius = radius,
				knockbackSpeed = knockbackSpeed,
				maxSpeed = maxKnockbackSpeed,
				upwardBias = upwardBias,
				letGoSeconds = letGoSeconds,
				stunSeconds = stunSeconds,
				selfScale = selfKnockbackScale,
				propImpulse = propImpulse,
				maxPropSpeed = maxPropSpeed,
				instigator = _instigator,
				source = this
			};
			Blast.Explode(in blast, blastMask, occluderMask);
		}

		private void UpdateBurst(float dt)
		{
			_burstAge += dt;
			if (burstLight != null && burstLight.enabled)
			{
				UpdateBurstLight();
			}
			if (_tail > 0f)
			{
				SetTail(_tail - speed * 1.5f * dt);
			}
			if (_burstAge >= burstLifetime)
			{
				Recycle();
			}
			else if (_burstAge >= _nextAliveCheck)
			{
				_nextAliveCheck = _burstAge + 0.25f;
				if (!EffectsAlive())
				{
					Recycle();
				}
			}
		}

		private void UpdateBurstLight()
		{
			float t = (burstLightDuration > 0f) ? (_burstAge / burstLightDuration) : 1f;
			if (t >= 1f)
			{
				burstLight.enabled = false;
				return;
			}
			float fade = 1f - t;
			burstLight.intensity = fade * (fade * burstLightIntensity);
			burstLight.color = burstLightColor.Evaluate(t);
		}

		private void SetTail(float length)
		{
			_tail = Mathf.Clamp(length, 0f, tailLength);
			if (tail == null)
			{
				return;
			}
			bool visible = _tail > 0.02f;
			if (tail.gameObject.activeSelf != visible)
			{
				tail.gameObject.SetActive(visible);
			}
			if (visible)
			{
				float t = (tailLength > 0f) ? (_tail / tailLength) : 1f;
				float width = Mathf.Lerp(tailStartWidth, 1f, t) * tailWidth;
				tail.localScale = new Vector3(width, width, _tail);
			}
		}

		private void ClearGlows()
		{
			for (int i = 0; i < glows.Length; i++)
			{
				if (glows[i] != null)
				{
					glows[i].Clear(true);
				}
			}
		}

		private bool EffectsAlive()
		{
			if (_tail > 0f)
			{
				return true;
			}
			if (burstAudio != null && burstAudio.isPlaying)
			{
				return true;
			}
			if (burstLight != null && burstLight.enabled)
			{
				return true;
			}
			for (int i = 0; i < trailEffects.Length; i++)
			{
				if (trailEffects[i] != null && trailEffects[i].IsAlive(true))
				{
					return true;
				}
			}
			for (int j = 0; j < burstEffects.Length; j++)
			{
				if (burstEffects[j] != null && burstEffects[j].IsAlive(false))
				{
					return true;
				}
			}
			for (int k = 0; k < surfaceEffects.Length; k++)
			{
				if (surfaceEffects[k] != null && surfaceEffects[k].IsAlive(false))
				{
					return true;
				}
			}
			return false;
		}

		private static void PlayAll(ParticleSystem[] systems)
		{
			foreach (ParticleSystem system in systems)
			{
				if (!(system == null))
				{
					system.Clear(false);
					system.Play(false);
				}
			}
		}

		private static void StopAll(ParticleSystem[] systems)
		{
			for (int i = 0; i < systems.Length; i++)
			{
				if (systems[i] != null)
				{
					systems[i].Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
				}
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(0.4f, 1f, 0.2f, 0.6f);
			Gizmos.DrawWireSphere(base.transform.position, hitRadius);
			Gizmos.color = new Color(1f, 0.6f, 0.1f, 0.35f);
			Gizmos.DrawWireSphere(base.transform.position, innerRadius);
			Gizmos.DrawWireSphere(base.transform.position, radius);
		}
	}
}
