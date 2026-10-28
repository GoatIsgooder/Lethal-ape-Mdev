using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnClipPuppet : FnPuppetBase
	{
		private struct Touch
		{
			public Transform Point;

			public Transform Anchor;

			public Vector3 Rel;
		}

		private struct BoneCache
		{
			public Quaternion Pre;

			public Quaternion Applied;

			public Vector3 PrePos;

			public Vector3 AppliedPos;

			public bool Valid;
		}

		[Serializable]
		public struct Follower
		{
			public Transform bone;

			public Transform anchor;
		}

		[Serializable]
		public class Form
		{
			public string name = "Walk";

			public GameObject root;

			public Animator animator;

			[Tooltip("Default state of the Animator's controller (the looping clip).")]
			public string state = "Scene";

			[NonSerialized]
			public int stateHash;

			[Tooltip("Seconds in the clip. Used to advance the idle hover.")]
			public float clipLength = 1.6f;

			[Tooltip("Metres the character travels per full clip cycle at this form's scale (measured by the builder).")]
			public float strideLength = 1.5f;

			[Tooltip("Clip cycles per cycle of the pose stream's gait phase: FnAnimatronic.strideLength / this form's strideLength, so the feet stay planted whatever clip is showing.")]
			public float cyclesPerGait = 1f;

			[Tooltip("Used from this speed up (m/s). The forms are ordered slowest to fastest.")]
			public float enterSpeed;

			[Tooltip("Normalised clip time with the limbs level, held when it stands still.")]
			[Range(0f, 1f)]
			public float restTime;

			[Tooltip("The other level frame, half a cycle on (the other side's limbs passing). It settles on whichever is nearer.")]
			[Range(0f, 1f)]
			public float restTimeAlt = 0.5f;

			[Header("Layer bones")]
			public Transform hips;

			public Transform chest;

			public Transform head;

			public Transform armL;

			public Transform armR;

			[Tooltip("The bone below each upper arm (forearm) and the end of the forearm (wrist): the two-bone chain the knock places on the door.")]
			public Transform foreL;

			public Transform foreR;

			public Transform handL;

			public Transform handR;

			[Tooltip("How far the knuckles reach past the wrist along the forearm (m, measured by the builder).")]
			public float knuckleReach = 0.1f;

			[Tooltip("Root-level bones (fingers) that must follow the arm they hang from when the layer moves it.")]
			public Follower[] followers = new Follower[0];
		}

		[Serializable]
		public class Style
		{
			[Header("Stance")]
			public float walkLean = 8f;

			public float runLean = 18f;

			[Tooltip("Speed at which the run lean is reached (m/s).")]
			public float runSpeed = 3.5f;

			[Tooltip("Hover/bob added on top of the clip (metres).")]
			public float bob;

			[Header("Idle")]
			public float breath = 1.6f;

			public float breathPeriod = 4.2f;

			public float idleSway = 7f;

			public float idleSwayPeriod = 6f;

			[Tooltip("How fast the clip breathes about its level frame while it stands still (cycles per second).")]
			public float idleRate = 0.05f;

			[Tooltip("How far the standing clip drifts off its level frame (fraction of a cycle).")]
			public float idleDrift = 0.08f;

			[Header("Doorway")]
			public float peekLean = 20f;

			public float peekRoll = 10f;

			[Tooltip("The arm that strikes the door; the other braces flat on it.")]
			public bool knockLeft;

			[Tooltip("Chest pitch while at the door (negative rears up off the floor: the crawlers prop themselves on the door).")]
			public float knockRear;

			[Tooltip("How hard each rap jolts the shoulders (degrees).")]
			public float knockJolt = 4f;

			[Tooltip("Where the knuckles land: height above the shoulders and distance across from the body's centre, as fractions of the arm's reach and the shoulder width.")]
			public float knockHeight = 0.17f;

			public float knockAcross = 0.42f;

			[Tooltip("A crawler holds itself up on its arms: the brace hand stays planted on the floor (only a slam takes both off it).")]
			public bool braceOnFloor;

			[Tooltip("The elbows bend up and back (a crawler's), not down and out.")]
			public bool elbowsUp;

			[Header("Specimen tube")]
			[Tooltip("How far the tank's fluid lifts the sleeping body off the tube's floor (m).")]
			public float floatHeight = 0.12f;

			[Tooltip("Arm swing forward and spread outward while it floats (degrees): long-armed crawlers draw theirs in to fit the tank.")]
			public float floatRaise = 12f;

			public float floatSpread = 14f;

			[Header("Attack")]
			public float lungeLean = 26f;

			public float lungeArms = 105f;

			public float slumpLean = 38f;

			public float slumpHead = -48f;

			public float slumpDrop = 0.14f;

			[Header("Camera")]
			public float stareDelay = 0.5f;

			public float stareTilt = 9f;

			[Tooltip("Share of the head turn (servo, sway, stare, twitch) the head bone takes. Below 1 for a rig whose head bone also carries the shoulders.")]
			[Range(0f, 1f)]
			public float headShare = 1f;

			public float lensLeanWithin = 2.6f;

			public float lensLean = 16f;

			[Header("Twitch (nightmare)")]
			public float twitchRate;

			public float twitchStrength;

			public float tremor;
		}

		private enum Activity : byte
		{
			Stand = 0,
			Walk = 1,
			Search = 2,
			Peek = 3,
			Bang = 4,
			Lunge = 5,
			Slump = 6,
			Jump = 7,
			Shriek = 8,
			Suspended = 9
		}

		private struct Posture
		{
			public float Height;

			public float Pitch;

			public float Roll;

			public float Yaw;

			public float HeadYaw;

			public float HeadPitch;

			public float HeadRoll;

			public float RaiseL;

			public float RaiseR;

			public float SpreadL;

			public float SpreadR;
		}

		private const float ReadyGap = 0.17f;

		private const float RestGap = 0.32f;

		private const float ComfortReach = 0.72f;

		private const float RapHoldSeconds = 0.03f;

		private const float RapReturnSeconds = 0.13f;

		private const float SlamRecoilSeconds = 0.45f;

		private const float SettleSeconds = 0.5f;

		private const float KnuckleClearance = 0.006f;

		private const float MaxSurge = 0.7f;

		private const float TankPress = 0.32f;

		private float _reach;

		private float _surge;

		private float _rapLurch;

		private float _prevBangAge;

		private int _prevBangCount = -1;

		private float _fistUp;

		private float _fistTravel;

		private bool _slam;

		private bool _inTank;

		private Vector3 _tankCentre;

		private float _tankRadius;

		private float _slamLift;

		private float _slamInto;

		private float _slamSettle;

		private float _oPitch;

		private float _oHeadPitch;

		private float _oHeight;

		private float _oSurge;

		private bool _doorLatched;

		private Vector3 _latchRoot;

		private Vector3 _latchPoint;

		private Vector3 _doorFoot;

		private Vector3 _doorN = Vector3.back;

		private Vector3 _doorAcross = Vector3.right;

		private float _shoulderH;

		private float _shoulderSpan;

		private float _armReach;

		private Touch[] _touchL = new Touch[0];

		private Touch[] _touchR = new Touch[0];

		private int _touchForm = -1;

		private BoneCache _cHips;

		private BoneCache _cChest;

		private BoneCache _cHead;

		private BoneCache _cArmL;

		private BoneCache _cArmR;

		private BoneCache _cForeL;

		private BoneCache _cForeR;

		private Vector3[] _followPos = new Vector3[0];

		private Quaternion[] _followRot = new Quaternion[0];

		public Form[] forms = new Form[0];

		public Style style = new Style();

		private const float WalkStartSpeed = 0.25f;

		private const float WalkStopSpeed = 0.12f;

		private const float FormHysteresis = 0.25f;

		private const float PhasePull = 2.5f;

		private const float PhasePullLimit = 0.45f;

		private const float SettleGain = 3f;

		private const float SettleMinRate = 0.12f;

		private const float ChargeSinkSeconds = 0.3f;

		private const float ChargeBuildSeconds = 0.8f;

		private const float LandSeconds = 0.45f;

		private bool _init;

		private int _form = -1;

		private Activity _activity;

		private FnPuppetInput _input;

		private bool _hasInput;

		private Posture _target;

		private Posture _shown;

		private float _now;

		private float _dt;

		private bool _moving;

		private float _phase;

		private float _phaseRate;

		private float _restPhase;

		private bool _settling;

		private float _idleClock;

		private float _twitchYaw;

		private float _twitchRoll;

		private float _twitchAt;

		private bool _watched;

		private float _watchFor;

		private float _unwatchedFor = 10f;

		private Vector3 _lens;

		private float _lensCloseness;

		private float _stareTilt;

		private float KnockSide => style.knockLeft ? -1f : 1f;

		public override float HeadServoScale => variant == FnDifficulty.Nightmare ? 1.7f : 1f;

		public override bool Staring => _watched && _watchFor >= style.stareDelay;

		public override bool Crawls => style.braceOnFloor;

		public override Vector3 LensPosition => _lens;

		private void ResetKnock()
		{
			_reach = 0f;
			_surge = 0f;
			_rapLurch = 0f;
			_prevBangCount = -1;
			_fistUp = 0f;
			_fistTravel = 0f;
			_slamLift = 0f;
			_slamInto = 0f;
			_slamSettle = 0f;
			_oPitch = 0f;
			_oHeadPitch = 0f;
			_oHeight = 0f;
			_oSurge = 0f;
			_doorLatched = false;
			_touchForm = -1;
		}

		private float BurstSeconds(in FnPuppetInput input)
		{
			return (input.BangHeavy ? 0.36f : 0.23f) + input.KnockInterval * (Mathf.Max(input.KnockRaps, 1) - 1) + (input.BangHeavy ? SlamRecoilSeconds : 0.16f);
		}

		private void KnockTarget(ref Posture p, in FnPuppetInput input)
		{
			float side = KnockSide;
			bool after = input.BangAge > BurstSeconds(in input) + 0.4f;
			p.Pitch += style.knockRear + (after ? 4f : 0f);
			p.Roll = side * -3f;
			p.HeadPitch -= after ? 6f : 2f;
			p.HeadRoll += side * (after ? 18f : 10f);
		}

		private void StepKnock(in FnPuppetInput input, float dt)
		{
			float target = _activity == Activity.Bang ? 1f : 0f;
			_reach = Ease(_reach, target, target > _reach ? 9f : 6f, dt);
			if (_reach < 0.002f && target == 0f)
			{
				_reach = 0f;
			}
			_rapLurch = Mathf.MoveTowards(_rapLurch, 0f, dt / 0.14f);
			_fistUp = 0f;
			_fistTravel = 0f;
			_slamLift = 0f;
			_slamInto = 0f;
			_slamSettle = 0f;
			_oPitch = 0f;
			_oHeadPitch = 0f;
			_oHeight = 0f;
			_oSurge = 0f;
			_slam = input.BangHeavy;
			_inTank = input.InTank;
			_tankCentre = input.TankCentre;
			_tankRadius = input.TankRadius;
			if (input.BangCount != _prevBangCount)
			{
				_prevBangAge = _prevBangCount < 0 ? input.BangAge : 0f;
				_prevBangCount = input.BangCount;
			}
			float age = input.BangAge;
			float total = BurstSeconds(in input);
			if (age >= 0f && age <= total + SettleSeconds)
			{
				if (_slam)
				{
					SlamTimeline(in input, age, total);
				}
				else
				{
					RapTimeline(in input, age, total);
				}
			}
			_prevBangAge = age;
			float jolt = _rapLurch * (style.knockJolt * (_slam ? 2f : 1f));
			_oPitch += jolt;
			_oHeadPitch += jolt * -0.8f;
			_oHeight += _rapLurch * -0.012f;
			_oPitch *= _reach;
			_oHeadPitch *= _reach;
			_oHeight *= _reach;
			_oSurge *= _reach;
		}

		private void RapTimeline(in FnPuppetInput input, float age, float total)
		{
			float interval = Mathf.Max(input.KnockInterval, 0.1f);
			float back = Mathf.Clamp(interval - 0.07f - RapHoldSeconds, 0.02f, RapReturnSeconds);
			int raps = Mathf.Max(input.KnockRaps, 1);
			if (age > total)
			{
				_fistUp = 1f - Mathf.SmoothStep(0f, 1f, (age - total) / SettleSeconds);
			}
			else
			{
				_fistUp = Mathf.SmoothStep(0f, 1f, age / 0.16f);
			}
			float t = age - 0.16f;
			int k = Mathf.FloorToInt(t / interval);
			if (k < 0)
			{
				return;
			}
			k = Mathf.Min(k, raps - 1);
			float start = interval * k;
			float local = t - start;
			if (local < 0.07f)
			{
				_fistTravel = Sq(local / 0.07f);
			}
			else if (local < 0.1f)
			{
				_fistTravel = 1f;
			}
			else
			{
				_fistTravel = 1f - Mathf.SmoothStep(0f, 1f, (local - 0.07f - RapHoldSeconds) / back);
			}
			float hit = start + 0.23f;
			if (hit <= age && _prevBangAge < hit)
			{
				_rapLurch = 1f;
			}
		}

		private void SlamTimeline(in FnPuppetInput input, float age, float total)
		{
			float interval = Mathf.Max(input.KnockInterval, 0.2f);
			int raps = Mathf.Max(input.KnockRaps, 1);
			_slamSettle = age > total ? 1f - Mathf.SmoothStep(0f, 1f, (age - total) / SettleSeconds) : 1f;
			int k = Mathf.FloorToInt((age - 0.3f - 0.06f) / interval);
			int next = Mathf.Clamp(k + 1, 0, raps - 1);
			float hit = interval * next + 0.36f;
			float start = next == 0 ? 0f : hit - interval + 0.05f;
			float lift = next == 0 ? 1f : 0.6f;
			float hold = hit - 0.06f;
			if (start > age)
			{
				_slamInto = 1f;
			}
			else if (hold > age)
			{
				float e = Mathf.SmoothStep(0f, 1f, (age - start) / Mathf.Max(hold - start, 0.05f));
				_slamLift = lift * e;
				_slamInto = 1f - e;
			}
			else if (hit > age)
			{
				float x = (age - hold) / 0.06f;
				_slamLift = lift * (1f - x * x);
				_slamInto = x * x;
			}
			else
			{
				float r = Mathf.Clamp01((age - hit) / SlamRecoilSeconds);
				_slamInto = 1f - (_inTank ? 0.35f : 0.5f) * Mathf.Sin(_inTank ? r * Mathf.PI : r * Mathf.PI * 0.5f);
			}
			if (k >= 0 && k < raps)
			{
				float strike = interval * k + 0.36f;
				if (strike <= age && _prevBangAge < strike)
				{
					_rapLurch = 1f;
				}
			}
			_oPitch += (_slamInto * 12f * (1f - _slamLift) - _slamLift * 9f) * _slamSettle;
			_oHeadPitch += (_slamLift * 8f - _slamInto * 5f) * _slamSettle;
			_oHeight += _slamSettle * 0.06f * _slamLift;
			_oSurge += _slamInto * (_slamSettle * 0.08f) * (1f - _slamLift);
		}

		private void PrepareKnock(Form f)
		{
			if (f.armL == null || f.armR == null || f.foreL == null || f.foreR == null || f.handL == null || f.handR == null)
			{
				return;
			}
			if (_touchForm != _form)
			{
				BuildTouches(f);
			}
			Vector3 shoulders = (f.armL.position + f.armR.position) * 0.5f;
			LatchDoor(f, shoulders);
			Capture(_touchL);
			Capture(_touchR);
			float surge = Mathf.Clamp(Vector3.Dot(shoulders - _doorFoot, _doorN) - _armReach * ComfortReach, 0f, MaxSurge);
			_surge = Ease(_surge, surge * _reach + _oSurge, 6f, _dt);
			if (_surge < 0.001f && _reach <= 0f)
			{
				_surge = 0f;
			}
		}

		private void LatchDoor(Form f, Vector3 shoulders)
		{
			Vector3 root = base.transform.position;
			Vector3 point;
			Vector3 normal;
			if (_input.HasDoor)
			{
				point = _input.DoorPoint;
				normal = _input.DoorNormal;
			}
			else
			{
				normal = -base.transform.forward;
				point = shoulders + base.transform.forward * (Mathf.Max(_armReach, 0.3f) * ComfortReach);
				point.y = root.y;
			}
			if (_doorLatched && (root - _latchRoot).sqrMagnitude < 0.0009f && (point - _latchPoint).sqrMagnitude < 0.0009f)
			{
				return;
			}
			_latchRoot = root;
			_doorLatched = true;
			_latchPoint = point;
			_doorN = normal.normalized;
			_doorFoot = root - _doorN * Vector3.Dot(root - point, _doorN);
			_doorFoot.y = point.y;
			Vector3 across = Vector3.Cross(Vector3.up, _doorN);
			_doorAcross = Vector3.Dot(across, base.transform.right) < 0f ? -across : across;
			_shoulderH = shoulders.y - point.y;
			_shoulderSpan = Mathf.Max(Vector3.Distance(f.armL.position, f.armR.position), 0.2f);
			_armReach = Mathf.Max(Vector3.Distance(f.armL.position, f.foreL.position) + Vector3.Distance(f.foreL.position, f.handL.position) + f.knuckleReach, 0.3f);
		}

		private Vector3 OnDoor(float across, float height, float outward)
		{
			return _doorFoot + _doorAcross * across + Vector3.up * height + _doorN * outward;
		}

		private void PlaceHands(Form f)
		{
			if (f.foreL == null || f.foreR == null || f.handL == null || f.handR == null || !_doorLatched)
			{
				return;
			}
			float side = KnockSide;
			float across = side * _shoulderSpan;
			float strikeAcross = across * style.knockAcross;
			Vector3 rest = OnDoor(strikeAcross * 1.3f, _shoulderH + _armReach * (style.knockHeight - 0.22f), _armReach * RestGap);
			Vector3 ready = OnDoor(strikeAcross, _shoulderH + _armReach * (style.knockHeight + 0.03f), _armReach * ReadyGap);
			Vector3 contact = OnDoor(strikeAcross, _shoulderH + _armReach * style.knockHeight, 0f);
			Vector3 strike = Vector3.Lerp(rest, ready, _fistUp) + (contact - ready) * _fistTravel;
			Vector3 brace = OnDoor(-across * 0.85f, _shoulderH + _armReach * (style.knockHeight - 0.08f), 0f);
			Vector3 strikePole;
			Vector3 bracePole;
			if (style.elbowsUp)
			{
				strikePole = _doorAcross * (side * 0.9f) + Vector3.up * 0.3f + _doorN * 0.25f;
			}
			else
			{
				strikePole = _doorAcross * (side * 0.55f) + Vector3.up * -0.75f + _doorN * 0.35f;
			}
			if (style.elbowsUp)
			{
				bracePole = _doorAcross * (side * -0.9f) + Vector3.up * 0.3f + _doorN * 0.25f;
			}
			else
			{
				bracePole = _doorAcross * (side * -0.7f) + Vector3.up * -0.55f + _doorN * 0.45f;
			}
			float braceWeight = style.braceOnFloor ? (_slam ? _slamSettle : 0f) : 1f;
			if (_inTank)
			{
				strike = OnDoor(across * 0.4f, _armReach * RestGap + _shoulderH, 0f);
				brace = OnDoor(-across * 0.4f, _armReach * RestGap + _shoulderH, 0f);
				strikePole = _doorAcross * (side * 0.1f) + Vector3.up + _doorN * 0.1f;
				bracePole = _doorAcross * (side * -0.1f) + Vector3.up + _doorN * 0.1f;
				braceWeight = 1f;
			}
			Vector3 targetL;
			Vector3 targetR;
			Vector3 poleL;
			Vector3 poleR;
			float weightL;
			float weightR;
			if (style.knockLeft)
			{
				targetL = strike;
				poleL = strikePole;
				weightL = 1f;
				targetR = brace;
				poleR = bracePole;
				weightR = braceWeight;
			}
			else
			{
				targetL = brace;
				poleL = bracePole;
				weightL = braceWeight;
				targetR = strike;
				poleR = strikePole;
				weightR = 1f;
			}
			if (_slam && _slamSettle > 0f)
			{
				float height;
				float spread;
				float outward;
				if (_inTank)
				{
					height = Mathf.Lerp(_armReach * RestGap + _shoulderH, _armReach * 0.42f + _shoulderH, _slamLift);
					spread = _shoulderSpan * 0.4f + _slamLift * 0.04f;
					outward = Mathf.Lerp(_armReach * 0.12f, 0f, _slamInto) + _slamLift * 0.03f;
				}
				else
				{
					height = Mathf.Lerp(_armReach * 0.06f + _shoulderH, _armReach * 0.55f + _shoulderH, _slamLift);
					spread = _shoulderSpan * 0.45f + _slamLift * 0.12f;
					outward = Mathf.Lerp(_armReach * 0.4f, 0f, _slamInto) + _slamLift * 0.1f;
				}
				targetL = Vector3.Lerp(targetL, OnDoor(-spread, height, outward), _slamSettle);
				targetR = Vector3.Lerp(targetR, OnDoor(spread, height, outward), _slamSettle);
				float poleAcross;
				float poleUp;
				float poleOut;
				if (_inTank)
				{
					poleAcross = 0.1f;
					poleUp = 1f;
					poleOut = 0.05f;
				}
				else
				{
					poleAcross = 0.6f;
					poleUp = style.elbowsUp ? 0.3f : -0.6f;
					poleOut = 0.4f;
				}
				poleL = Vector3.Slerp(poleL, Vector3.up * poleUp - _doorAcross * poleAcross + _doorN * poleOut, _slamSettle);
				poleR = Vector3.Slerp(poleR, _doorAcross * poleAcross + Vector3.up * poleUp + _doorN * poleOut, _slamSettle);
			}
			PlaceArm(f.armL, f.foreL, f.handL, f.knuckleReach, targetL, poleL, _touchL, weightL * _reach);
			PlaceArm(f.armR, f.foreR, f.handR, f.knuckleReach, targetR, poleR, _touchR, weightR * _reach);
		}

		private void PlaceArm(Transform upper, Transform fore, Transform hand, float knuckles, Vector3 target, Vector3 pole, Touch[] touch, float weight)
		{
			if (weight <= 0f)
			{
				return;
			}
			Vector3 aim = target + _doorN * KnuckleClearance;
			Reach(upper, fore, hand, knuckles, aim, pole, weight);
			if (touch.Length == 0)
			{
				return;
			}
			float want = Vector3.Dot(target - _doorFoot, _doorN) + KnuckleClearance;
			for (int i = 0; i < 3; i++)
			{
				if (_inTank)
				{
					float press = TankDepth(touch, out Vector3 worst) - KnuckleClearance;
					if (press < 0f)
					{
						Vector3 inward = new Vector3(_tankCentre.x - worst.x, 0f, _tankCentre.z - worst.z).normalized;
						aim -= inward * press;
						Reach(upper, fore, hand, knuckles, aim, pole, weight);
						continue;
					}
				}
				float depth = Depth(touch);
				if (Mathf.Abs(depth - want) < 0.003f)
				{
					return;
				}
				aim -= _doorN * (depth - want);
				Reach(upper, fore, hand, knuckles, aim, pole, weight);
			}
			float final = Depth(touch);
			if (_inTank)
			{
				final = Mathf.Min(final, TankDepth(touch, out Vector3 _));
			}
			if (final < KnuckleClearance)
			{
				Reach(upper, fore, hand, knuckles, aim + _doorN * (KnuckleClearance - final), pole, weight);
			}
		}

		private static void Reach(Transform upper, Transform fore, Transform end, float extra, Vector3 target, Vector3 pole, float weight)
		{
			if (weight <= 0f)
			{
				return;
			}
			Vector3 a = upper.position;
			Vector3 b = fore.position;
			Vector3 c = end.position;
			float upperLen = Vector3.Distance(a, b);
			if (upperLen < 0.0001f)
			{
				return;
			}
			Vector3 lower = c - b;
			float lowerMag = lower.magnitude;
			if (lowerMag < 0.0001f)
			{
				return;
			}
			float lowerLen = lowerMag + extra;
			Vector3 tip = b + lower / lowerMag * lowerLen;
			Vector3 goal = Vector3.Lerp(tip, target, weight);
			Vector3 toGoal = goal - a;
			float dist = toGoal.magnitude;
			if (dist < 0.0001f)
			{
				return;
			}
			float reach = Mathf.Clamp(dist, Mathf.Abs(upperLen - lowerLen) + 0.001f, (upperLen + lowerLen) * 0.999f);
			Vector3 axis = toGoal / dist;
			Vector3 bend = Vector3.ProjectOnPlane(b - a, axis);
			Vector3 poleDir = Vector3.ProjectOnPlane(pole, axis);
			if (poleDir.sqrMagnitude < 1E-08f)
			{
				poleDir = bend;
			}
			if (bend.sqrMagnitude < 1E-08f)
			{
				bend = poleDir;
			}
			if (bend.sqrMagnitude < 1E-08f)
			{
				return;
			}
			Vector3 sideDir = Vector3.Slerp(bend.normalized, poleDir.normalized, weight).normalized;
			float cos = Mathf.Clamp((upperLen * upperLen + reach * reach - lowerLen * lowerLen) / (2f * upperLen * reach), -1f, 1f);
			float sin = Mathf.Sqrt(1f - cos * cos);
			Vector3 elbow = a + (axis * cos + sideDir * sin) * upperLen;
			upper.rotation = Quaternion.FromToRotation(b - a, elbow - a) * upper.rotation;
			Vector3 b2 = fore.position;
			Vector3 c2 = end.position;
			fore.rotation = Quaternion.FromToRotation(c2 - b2, a + axis * reach - b2) * fore.rotation;
		}

		private float Depth(Touch[] touch)
		{
			float min = float.MaxValue;
			for (int i = 0; i < touch.Length; i++)
			{
				if (!(touch[i].Anchor == null))
				{
					min = Mathf.Min(min, Vector3.Dot(touch[i].Anchor.TransformPoint(touch[i].Rel) - _doorFoot, _doorN));
				}
			}
			return min;
		}

		private float TankDepth(Touch[] touch, out Vector3 worst)
		{
			worst = _tankCentre;
			float min = float.MaxValue;
			for (int i = 0; i < touch.Length; i++)
			{
				if (!(touch[i].Anchor == null))
				{
					Vector3 p = touch[i].Anchor.TransformPoint(touch[i].Rel);
					float dx = p.x - _tankCentre.x;
					float dz = p.z - _tankCentre.z;
					float d = _tankRadius - Mathf.Sqrt(dx * dx + dz * dz);
					if (d < min)
					{
						min = d;
						worst = p;
					}
				}
			}
			return min;
		}

		private static void Capture(Touch[] touch)
		{
			for (int i = 0; i < touch.Length; i++)
			{
				if (touch[i].Point != null && touch[i].Anchor != null)
				{
					touch[i].Rel = touch[i].Anchor.InverseTransformPoint(touch[i].Point.position);
				}
			}
		}

		private void BuildTouches(Form f)
		{
			_touchForm = _form;
			_touchL = Touches(f, f.foreL, f.handL);
			_touchR = Touches(f, f.foreR, f.handR);
		}

		private static Touch[] Touches(Form f, Transform fore, Transform hand)
		{
			List<Touch> list = new List<Touch>();
			if (fore == null || hand == null)
			{
				return list.ToArray();
			}
			list.Add(new Touch
			{
				Point = hand,
				Anchor = hand
			});
			Transform[] parts = hand.GetComponentsInChildren<Transform>(true);
			foreach (Transform part in parts)
			{
				if (part != hand)
				{
					list.Add(new Touch
					{
						Point = part,
						Anchor = hand
					});
				}
			}
			if (f.followers != null)
			{
				Follower[] followers = f.followers;
				foreach (Follower follower in followers)
				{
					if (follower.bone == null || follower.anchor == null || (follower.anchor != fore && !follower.anchor.IsChildOf(fore)))
					{
						continue;
					}
					Transform[] bones = follower.bone.GetComponentsInChildren<Transform>(true);
					foreach (Transform bone in bones)
					{
						list.Add(new Touch
						{
							Point = bone,
							Anchor = follower.anchor
						});
					}
				}
			}
			return list.ToArray();
		}

		private static float Sq(float x)
		{
			return x * x;
		}

		private void ResetLayerCache()
		{
			_cHips = default(BoneCache);
			_cChest = default(BoneCache);
			_cHead = default(BoneCache);
			_cArmL = default(BoneCache);
			_cArmR = default(BoneCache);
			_cForeL = default(BoneCache);
			_cForeR = default(BoneCache);
		}

		private Posture Target(in FnPuppetInput input)
		{
			Posture p = new Posture
			{
				Pitch = style.breath * Wave(_now / Mathf.Max(style.breathPeriod, 0.5f)),
				HeadYaw = input.HeadYaw,
				HeadPitch = input.HeadPitch,
				HeadRoll = _stareTilt
			};
			switch (_activity)
			{
			case Activity.Stand:
				p.HeadYaw += style.idleSway * Wave(_now / Mathf.Max(style.idleSwayPeriod, 0.5f));
				p.Height = Wave(_now / 3.1f) * 0.006f;
				break;
			case Activity.Walk:
				p.Pitch += Mathf.Lerp(style.walkLean, style.runLean, input.Speed / Mathf.Max(style.runSpeed, 0.5f));
				p.Height = style.bob * Mathf.Abs(Wave(input.Gait));
				break;
			case Activity.Search:
				p.Yaw = Wave(_now * 0.25f) * 12f;
				p.Pitch += 4f;
				p.HeadYaw += Wave(_now / 3f) * 34f;
				break;
			case Activity.Peek:
				p.Pitch += style.peekLean;
				p.Roll = Wave(_now / 7f) * style.peekRoll;
				p.HeadPitch -= 6f;
				p.HeadRoll += 8f;
				p.RaiseL = 52f;
				p.RaiseR = 52f;
				p.SpreadL = 34f;
				p.SpreadR = 34f;
				break;
			case Activity.Bang:
				KnockTarget(ref p, in input);
				break;
			case Activity.Lunge:
				p.Pitch += style.lungeLean;
				p.HeadPitch += 8f;
				p.RaiseL = style.lungeArms;
				p.RaiseR = style.lungeArms;
				p.SpreadL = 14f;
				p.SpreadR = 14f;
				break;
			case Activity.Slump:
				p.Pitch += style.slumpLean;
				p.Height = -style.slumpDrop;
				p.Roll = 9f;
				p.HeadPitch = style.slumpHead;
				p.HeadRoll += 14f;
				p.SpreadL = 4f;
				p.SpreadR = 4f;
				break;
			case Activity.Jump:
				JumpTarget(ref p, in input);
				break;
			case Activity.Shriek:
				p.Pitch -= 10f;
				p.HeadPitch += 32f;
				p.RaiseL = 25f;
				p.RaiseR = 25f;
				p.SpreadL = 58f;
				p.SpreadR = 58f;
				break;
			case Activity.Suspended:
				p.Height = Wave(_now / 5.5f) * 0.025f + style.floatHeight;
				p.Pitch += 6f;
				p.Yaw = Wave(_now / 11f) * 5f;
				if (input.HasLook)
				{
					p.HeadPitch -= 4f;
				}
				else
				{
					p.HeadYaw = 0f;
					p.HeadPitch = Wave(_now / 7f) * 3f - 26f;
				}
				p.HeadRoll += Wave(_now / 9f) * 5f;
				p.RaiseL = Wave(_now / 6.3f) * 6f + style.floatRaise;
				p.RaiseR = Wave(_now / 5.7f + 0.3f) * 6f + style.floatRaise;
				p.SpreadL = Wave(_now / 7.7f) * 4f + style.floatSpread;
				p.SpreadR = Wave(_now / 8.3f + 0.5f) * 4f + style.floatSpread;
				break;
			}
			if (Staring)
			{
				p.Pitch += style.lensLean * _lensCloseness;
			}
			if (style.twitchRate > 0f && _activity != Activity.Slump)
			{
				if (_now >= _twitchAt)
				{
					_twitchAt = _now + UnityEngine.Random.Range(0.4f, 1.6f) / style.twitchRate;
					_twitchYaw = UnityEngine.Random.Range(-1f, 1f) * style.twitchStrength;
					_twitchRoll = UnityEngine.Random.Range(-1f, 1f) * style.twitchStrength * 0.7f;
				}
				p.HeadYaw += _twitchYaw;
				p.HeadRoll += _twitchRoll;
			}
			if (style.tremor > 0f)
			{
				p.HeadYaw += style.tremor * (Mathf.PerlinNoise(_now * 31f, 0.3f) - 0.5f) * 2f;
				p.HeadRoll += style.tremor * (Mathf.PerlinNoise(_now * 29f, 7.7f) - 0.5f) * 2f;
			}
			return p;
		}

		private void JumpTarget(ref Posture p, in FnPuppetInput input)
		{
			if (input.JumpCharge)
			{
				float sink = Mathf.SmoothStep(0f, 1f, input.JumpChargeAge / ChargeSinkSeconds);
				float build = Mathf.Clamp01(input.JumpChargeAge / ChargeBuildSeconds);
				p.Height = sink * -0.28f;
				p.Pitch += build * 30f;
				p.HeadPitch += build * 10f;
				p.HeadRoll += build * (Wave(_now * 9f) * 6f);
				p.RaiseL = -34f * build;
				p.RaiseR = -34f * build;
				p.SpreadL = 20f * build;
				p.SpreadR = 20f * build;
			}
			else if (input.Airborne)
			{
				p.Pitch -= 6f;
				p.HeadPitch += 14f;
				p.RaiseL = 150f;
				p.RaiseR = 150f;
				p.SpreadL = 18f;
				p.SpreadR = 18f;
			}
			else
			{
				float land = 1f - Mathf.SmoothStep(0f, 1f, input.LandAge / LandSeconds);
				float impact = Mathf.Clamp01(input.LandImpact + 0.25f);
				p.Height = land * (impact * -0.34f);
				p.Pitch += land * 20f;
				p.RaiseL = 40f * land;
				p.RaiseR = 40f * land;
				p.SpreadL = 12f * land;
				p.SpreadR = 12f * land;
			}
		}

		private static float Ease(float current, float target, float rate, float dt)
		{
			return (target - current) * (1f - Mathf.Exp(-rate * dt)) + current;
		}

		private void StepToward(float dt)
		{
			float rate;
			float armRate;
			switch (_activity)
			{
			case Activity.Lunge:
			case Activity.Jump:
			case Activity.Shriek:
				rate = 14f;
				armRate = 16f;
				break;
			case Activity.Slump:
			case Activity.Suspended:
				rate = 2.5f;
				armRate = 2.5f;
				break;
			default:
				rate = 7f;
				armRate = 9f;
				break;
			}
			_shown.Height = Ease(_shown.Height, _target.Height, rate * 1.4f, dt);
			_shown.Pitch = Ease(_shown.Pitch, _target.Pitch, rate, dt);
			_shown.Roll = Ease(_shown.Roll, _target.Roll, rate, dt);
			_shown.Yaw = Ease(_shown.Yaw, _target.Yaw, rate, dt);
			_shown.HeadYaw = Ease(_shown.HeadYaw, _target.HeadYaw, 18f, dt);
			_shown.HeadPitch = Ease(_shown.HeadPitch, _target.HeadPitch, 18f, dt);
			_shown.HeadRoll = Ease(_shown.HeadRoll, _target.HeadRoll, 14f, dt);
			_shown.RaiseL = Ease(_shown.RaiseL, _target.RaiseL, armRate, dt);
			_shown.RaiseR = Ease(_shown.RaiseR, _target.RaiseR, armRate, dt);
			_shown.SpreadL = Ease(_shown.SpreadL, _target.SpreadL, armRate, dt);
			_shown.SpreadR = Ease(_shown.SpreadR, _target.SpreadR, armRate, dt);
		}

		private static void Begin(Transform t, ref BoneCache c, bool position)
		{
			if (t == null)
			{
				return;
			}
			if (c.Valid && Quaternion.Dot(t.localRotation, c.Applied) > 0.999999f && (!position || (t.localPosition - c.AppliedPos).sqrMagnitude < 1E-10f))
			{
				t.localRotation = c.Pre;
				if (position)
				{
					t.localPosition = c.PrePos;
				}
			}
			else
			{
				c.Pre = t.localRotation;
				c.PrePos = t.localPosition;
			}
		}

		private static void End(Transform t, ref BoneCache c)
		{
			if (!(t == null))
			{
				c.Applied = t.localRotation;
				c.AppliedPos = t.localPosition;
				c.Valid = true;
			}
		}

		private void LateUpdate()
		{
			if (!_init || _form < 0 || !_hasInput)
			{
				return;
			}
			Form f = forms[_form];
			if (f.root == null || !f.root.activeInHierarchy)
			{
				return;
			}
			Begin(f.hips, ref _cHips, true);
			Begin(f.chest, ref _cChest, false);
			Begin(f.head, ref _cHead, false);
			Begin(f.armL, ref _cArmL, false);
			Begin(f.armR, ref _cArmR, false);
			Begin(f.foreL, ref _cForeL, false);
			Begin(f.foreR, ref _cForeR, false);
			int count = f.followers != null ? f.followers.Length : 0;
			if (count > _followPos.Length)
			{
				_followPos = new Vector3[count];
				_followRot = new Quaternion[count];
			}
			for (int i = 0; i < count; i++)
			{
				Follower follower = f.followers[i];
				if (!(follower.bone == null) && !(follower.anchor == null))
				{
					_followPos[i] = follower.anchor.InverseTransformPoint(follower.bone.position);
					_followRot[i] = Quaternion.Inverse(follower.anchor.rotation) * follower.bone.rotation;
				}
			}
			if (_reach > 0f || _surge > 0f)
			{
				PrepareKnock(f);
			}
			Vector3 right = base.transform.right;
			Vector3 up = base.transform.up;
			Vector3 forward = base.transform.forward;
			Posture s = _shown;
			if (f.hips != null)
			{
				f.hips.position += up * (s.Height + _oHeight) - _doorN * _surge;
				f.hips.rotation = Quaternion.AngleAxis(s.Yaw, up) * Quaternion.AngleAxis(-s.Roll, forward) * f.hips.rotation;
			}
			if (f.chest != null)
			{
				f.chest.rotation = Quaternion.AngleAxis(s.Pitch + _oPitch, right) * f.chest.rotation;
			}
			if (f.head != null)
			{
				float share = style.headShare;
				float headPitch = s.HeadPitch + _oHeadPitch;
				f.head.rotation = Quaternion.AngleAxis(s.HeadYaw * share, up) * Quaternion.AngleAxis(-headPitch * share, right) * Quaternion.AngleAxis(-s.HeadRoll * share, forward) * f.head.rotation;
			}
			if (f.armL != null)
			{
				f.armL.rotation = Quaternion.AngleAxis(-s.RaiseL, right) * Quaternion.AngleAxis(-s.SpreadL, forward) * f.armL.rotation;
			}
			if (f.armR != null)
			{
				f.armR.rotation = Quaternion.AngleAxis(-s.RaiseR, right) * Quaternion.AngleAxis(s.SpreadR, forward) * f.armR.rotation;
			}
			if (_reach > 0f)
			{
				PlaceHands(f);
			}
			for (int j = 0; j < count; j++)
			{
				Follower follower2 = f.followers[j];
				if (!(follower2.bone == null) && !(follower2.anchor == null))
				{
					follower2.bone.SetPositionAndRotation(follower2.anchor.TransformPoint(_followPos[j]), follower2.anchor.rotation * _followRot[j]);
				}
			}
			End(f.hips, ref _cHips);
			End(f.chest, ref _cChest);
			End(f.head, ref _cHead);
			End(f.armL, ref _cArmL);
			End(f.armR, ref _cArmR);
			End(f.foreL, ref _cForeL);
			End(f.foreR, ref _cForeR);
		}

		private void Awake()
		{
			EnsureInit();
		}

		public override void EnsureInit()
		{
			if (_init || forms == null || forms.Length == 0)
			{
				return;
			}
			_init = true;
			for (int i = 0; i < forms.Length; i++)
			{
				Form f = forms[i];
				if (!(f.root == null))
				{
					f.stateHash = Animator.StringToHash(f.state);
					if (f.animator != null)
					{
						f.animator.speed = 0f;
						f.animator.cullingMode = AnimatorCullingMode.CullUpdateTransforms;
					}
				}
			}
			SelectForm(0);
			Snap();
		}

		public override void Snap()
		{
			if (_init)
			{
				_watched = false;
				_watchFor = 0f;
				_unwatchedFor = 10f;
				_target = default(Posture);
				_shown = default(Posture);
				_stareTilt = 0f;
				_twitchYaw = 0f;
				_twitchRoll = 0f;
				_hasInput = false;
				_moving = false;
				_settling = false;
				_phaseRate = 0f;
				_idleClock = 0f;
				Form f = forms[Mathf.Max(_form, 0)];
				_phase = f.restTime;
				_restPhase = f.restTime;
				ResetKnock();
				ResetLayerCache();
				PoseClip(f, f.restTime);
			}
		}

		public override void Drive(in FnPuppetInput input)
		{
			EnsureInit();
			if (_init)
			{
				_input = input;
				_hasInput = true;
				_now = Time.time;
				float dt = Mathf.Min(input.Dt, 0.1f);
				_dt = dt;
				UpdateWatch(dt);
				if (!input.Frozen)
				{
					_moving = input.Speed > (_moving ? WalkStopSpeed : WalkStartSpeed);
					SelectFormFor(input.Speed);
					_activity = Pick(in input);
					_target = Target(in input);
					StepToward(dt);
					StepKnock(in input, dt);
					PlayClip(in input, dt);
				}
			}
		}

		private Activity Pick(in FnPuppetInput input)
		{
			if (input.PoweredDown || input.Droop > 0.5f)
			{
				return Activity.Slump;
			}
			if (input.Home && input.State == FnAiState.Dormant)
			{
				return Activity.Suspended;
			}
			if (input.InTank)
			{
				return Activity.Bang;
			}
			if (input.ShriekLeft > 0f)
			{
				return Activity.Shriek;
			}
			if (input.Lunging || input.Lunge > 0.3f || input.State == FnAiState.DoorEnter || input.State == FnAiState.Attack)
			{
				return Activity.Lunge;
			}
			if (input.JumpCharge || input.Airborne || input.LandAge < LandSeconds)
			{
				return Activity.Jump;
			}
			if (input.State == FnAiState.DoorBang)
			{
				return _moving ? Activity.Walk : Activity.Bang;
			}
			if (_moving)
			{
				return Activity.Walk;
			}
			if (input.State == FnAiState.DoorWait)
			{
				return Activity.Peek;
			}
			return input.State == FnAiState.Search ? Activity.Search : Activity.Stand;
		}

		private void SelectFormFor(float speed)
		{
			int i = _form;
			while (i + 1 < forms.Length && forms[i + 1].enterSpeed <= speed)
			{
				i++;
			}
			while (i > 0 && forms[i].enterSpeed - FormHysteresis > speed)
			{
				i--;
			}
			if (i != _form)
			{
				SelectForm(i);
			}
		}

		private void SelectForm(int index)
		{
			if (_form == index)
			{
				return;
			}
			for (int i = 0; i < forms.Length; i++)
			{
				Form f = forms[i];
				if (f.root != null && f.root.activeSelf != (i == index))
				{
					f.root.SetActive(i == index);
				}
			}
			_form = index;
			if (_hasInput && _moving)
			{
				_phase = Mathf.Repeat(_input.Gait * forms[index].cyclesPerGait, 1f);
			}
			ResetLayerCache();
		}

		private void PlayClip(in FnPuppetInput input, float dt)
		{
			Form f = forms[_form];
			if (f.animator == null)
			{
				return;
			}
			if (_moving)
			{
				float rate = input.Speed / Mathf.Max(f.strideLength, 0.1f);
				float pull = WrapHalf(input.Gait * f.cyclesPerGait - _phase) * PhasePull;
				_phaseRate = rate + Mathf.Clamp(pull, -rate * PhasePullLimit, rate * PhasePullLimit);
				_phase = Mathf.Repeat(_phase + _phaseRate * dt, 1f);
				_settling = true;
				_idleClock = 0f;
			}
			else if (_settling)
			{
				float toRest = Mathf.Repeat(f.restTime - _phase, 1f);
				float toAlt = Mathf.Repeat(f.restTimeAlt - _phase, 1f);
				float remaining = Mathf.Min(toRest, toAlt);
				_restPhase = toRest > toAlt ? f.restTimeAlt : f.restTime;
				_phaseRate = Mathf.Max(Mathf.Min(_phaseRate, remaining * SettleGain), SettleMinRate);
				float step = _phaseRate * dt;
				if (step >= remaining)
				{
					_phase = _restPhase;
					_settling = false;
					_phaseRate = 0f;
				}
				else
				{
					_phase = Mathf.Repeat(_phase + step, 1f);
				}
			}
			else
			{
				_idleClock += dt;
				_phase = Mathf.Repeat(_restPhase + style.idleDrift * (0.5f - Mathf.Cos(_idleClock * style.idleRate * Mathf.PI * 2f) * 0.5f), 1f);
			}
			PoseClip(f, _phase);
		}

		private static float WrapHalf(float d)
		{
			return Mathf.Repeat(d + 0.5f, 1f) - 0.5f;
		}

		private static void PoseClip(Form f, float normalizedTime)
		{
			if (!(f.animator == null) && f.root.activeInHierarchy)
			{
				f.animator.speed = 0f;
				f.animator.Play(f.stateHash, 0, normalizedTime);
			}
		}

		private void UpdateWatch(float dt)
		{
			Form f = _form >= 0 ? forms[_form] : null;
			Vector3 eye = (f != null && f.head != null) ? f.head.position : (base.transform.position + Vector3.up * 1.5f);
			if (FeedSees(eye, style.lensLeanWithin, 0.05f, out Vector3 lens, out float closeness))
			{
				_watched = true;
				_watchFor += dt;
				_lens = lens;
				_lensCloseness = closeness;
				_unwatchedFor = 0f;
			}
			else
			{
				_unwatchedFor += dt;
				if (_unwatchedFor > 0.4f)
				{
					_watched = false;
					_watchFor = 0f;
					_lensCloseness = 0f;
				}
			}
			float tilt = Staring ? style.stareTilt * Mathf.Clamp01((_watchFor - style.stareDelay) / 3f) : 0f;
			_stareTilt = Mathf.MoveTowards(_stareTilt, tilt, (Staring ? 6f : 30f) * dt);
		}

		private static float Wave(float cycles)
		{
			return Mathf.Sin(cycles * Mathf.PI * 2f);
		}
	}
}
