using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnPuppet : FnPuppetBase
	{
		private struct Servo
		{
			public float Value;

			public float Velocity;

			public float HoldUntil;

			public bool Active;

			public bool Primed;
		}

		private struct Servo3
		{
			public Vector3 Value;

			public float HoldUntil;

			public bool Active;

			public bool Primed;

			public bool World;
		}

		private struct Spring
		{
			public float X;

			public float V;
		}

		private struct HandState
		{
			public bool Planted;

			public Vector3 Plant;

			public bool Swinging;

			public bool GaitSwing;

			public Vector3 From;

			public Vector3 To;

			public float SwingT;

			public float Weight;

			public Vector3 Target;

			public Vector3 Pole;

			public Vector3 Along;

			public Vector3 Palm;

			public float Curl;

			public bool HasPosed;

			public bool PosedWorld;

			public Vector3 PosedAt;

			public Vector3 PosedAlong;

			public Vector3 PosedPalm;

			public Vector3 PosedPole;

			public float PosedCurl;
		}

		private struct HandPose
		{
			public bool Posed;

			public bool World;

			public Vector3 Local;

			public Vector3 Along;

			public Vector3 Palm;

			public Vector3 Pole;

			public float Curl;
		}

		private struct Posture
		{
			public float Height;

			public float Sway;

			public float Surge;

			public float Pitch;

			public float Roll;

			public float Yaw;

			public float HeadYaw;

			public float HeadPitch;

			public float HeadRoll;

			public float Spread;

			public float Forward;

			public HandPose Left;

			public HandPose Right;
		}

		private enum Activity : byte
		{
			Stand = 0,
			Walk = 1,
			Perform = 2,
			Search = 3,
			Peek = 4,
			Bang = 5,
			Lunge = 6,
			Slump = 7,
			MusicBox = 8,
			Jump = 9
		}

		private Servo _sHeight;

		private Servo _sPitch;

		private Servo _sRoll;

		private Servo _sYaw;

		private Servo _sHeadYaw;

		private Servo _sHeadPitch;

		private Servo _sHeadRoll;

		private Servo _sSpread;

		private Servo _sForward;

		private Servo3 _sLeft;

		private Servo3 _sRight;

		private Spring _twHeadYaw;

		private Spring _twHeadPitch;

		private Spring _twHeadRoll;

		private Spring _twRoll;

		private Vector3 _twHandL;

		private Vector3 _twHandLV;

		private Vector3 _twHandR;

		private Vector3 _twHandRV;

		private float _nextTwitch;

		private float _noiseSeed;

		private const float StepDrift = 0.26f;

		private const float MaxStretch = 0.95f;

		private const float StepSeconds = 0.32f;

		private const float PoseBlendSeconds = 0.3f;

		private const float JumpPoseBlendSeconds = 0.1f;

		private HandState _left;

		private HandState _right;

		private Vector3 _lastRoot;

		private bool _hasLastRoot;

		private const float PalmThickness = 0.035f;

		private const float FistClearance = 0.001f;

		private const float ReadyGap = 0.11f;

		private const float RestGap = 0.26f;

		private const float RapHoldSeconds = 0.03f;

		private const float RapReturnSeconds = 0.13f;

		private const float SlamRecoilSeconds = 0.45f;

		private const float SettleSeconds = 0.5f;

		private const float GripReach = 0.93f;

		private bool _doorLatched;

		private Vector3 _doorLatchRoot;

		private Vector3 _doorCentre;

		private Vector3 _doorFoot;

		private Vector3 _doorN;

		private Vector3 _doorAcross;

		private float _doorFloor;

		private float _doorHalfWidth;

		private float _rapLurch;

		private const float WalkSpeed = 0.2f;

		private const float ChargeSinkSeconds = 0.3f;

		private const float ChargeBuildSeconds = 0.8f;

		private const float LandSeconds = 0.45f;

		private const float LandSinkShare = 0.2f;

		[Tooltip("Scene object: the mic, guitar or cupcake. Shared by both variants of one animatronic.")]
		public Transform propObject;

		public FnPropGrip propGrip;

		[Tooltip("Grip offset in the holding bone's space (bone units), and its rotation.")]
		public Vector3 propOffset;

		public Vector3 propEuler;

		[Tooltip("Where the prop waits on the stage while its animatronic is away. Empty = hidden while away.")]
		public Transform propRest;

		private bool _propHeld;

		private bool _propPlaced;

		private const float NeckShare = 0.35f;

		private static readonly string[] FingerNames = new string[6] { "index1", "index2", "index3", "pinkie1", "pinkie2", "pinkie3" };

		[SerializeField]
		[HideInInspector]
		private Transform[] restBones = new Transform[0];

		[SerializeField]
		[HideInInspector]
		private Quaternion[] restRotations = new Quaternion[0];

		private Transform _neck;

		private Transform _neckJoint;

		private Transform _head;

		private Transform _eyeL;

		private Transform _eyeR;

		private Transform _upperL;

		private Transform _lowerL;

		private Transform _handL;

		private Transform _upperR;

		private Transform _lowerR;

		private Transform _handR;

		private Transform _thumbL;

		private Transform _thumbR;

		private readonly Transform[] _fingersL = new Transform[6];

		private readonly Transform[] _fingersR = new Transform[6];

		private readonly Quaternion[] _fingerRestL = new Quaternion[6];

		private readonly Quaternion[] _fingerRestR = new Quaternion[6];

		private Quaternion _thumbRestL;

		private Quaternion _thumbRestR;

		private Quaternion _neckRest;

		private Quaternion _neckJointRest;

		private Quaternion _headRest;

		private Quaternion _eyeRestL;

		private Quaternion _eyeRestR;

		private Quaternion _upperOffL;

		private Quaternion _lowerOffL;

		private Quaternion _handOffL;

		private Quaternion _upperOffR;

		private Quaternion _lowerOffR;

		private Quaternion _handOffR;

		private float _shoulderAboveModel = 0.5f;

		private float _headAboveModel = 0.71f;

		private float _fistFront = 0.16f;

		private float _armLength = 1.2f;

		private const float FrustumMargin = 0.05f;

		[Tooltip("The scaled model root. Its local height is animated.")]
		public Transform model;

		public FnPuppetStyle style = new FnPuppetStyle();

		private bool _init;

		private Activity _activity;

		private float _now;

		private float _dt;

		private float _watchFor;

		private float _unwatchedFor = 10f;

		private float _stareTilt;

		private bool _watched;

		private Vector3 _lens;

		private float _lensCloseness;

		private float ShoulderHeight => style.bodyHeight + _shoulderAboveModel;

		private float HeadHeight => style.bodyHeight + _headAboveModel;

		private float KnockSide => style.knockLeft ? (-1f) : 1f;

		public override float HeadServoScale => (variant == FnDifficulty.Nightmare) ? 1.7f : 1f;

		public override bool Staring => _watched && _watchFor >= style.stareDelay;

		public override bool RaisesPlants => true;

		public override Vector3 LensPosition => _lens;

		private void ResetFeel()
		{
			_sHeight = default(Servo);
			_sPitch = default(Servo);
			_sRoll = default(Servo);
			_sYaw = default(Servo);
			_sHeadYaw = default(Servo);
			_sHeadPitch = default(Servo);
			_sHeadRoll = default(Servo);
			_sSpread = default(Servo);
			_sForward = default(Servo);
			_sLeft = default(Servo3);
			_sRight = default(Servo3);
			_twHeadYaw = default(Spring);
			_twHeadPitch = default(Spring);
			_twHeadRoll = default(Spring);
			_twRoll = default(Spring);
			_twHandL = (_twHandLV = (_twHandR = (_twHandRV = Vector3.zero)));
			_nextTwitch = Time.time + Random.Range(0.5f, 2f);
			_noiseSeed = Random.value * 100f;
		}

		private void StepFeel(in FnPuppetInput input, ref Posture p)
		{
			bool direct = _activity == Activity.Lunge || _activity == Activity.Jump || input.ShriekLeft > 0f;
			p.Height = Filter(ref _sHeight, p.Height, 100f, direct);
			p.Pitch = Filter(ref _sPitch, p.Pitch, 1f, direct);
			p.Roll = Filter(ref _sRoll, p.Roll, 1f, direct);
			p.Yaw = Filter(ref _sYaw, p.Yaw, 1f, direct);
			p.HeadYaw = Filter(ref _sHeadYaw, p.HeadYaw, 1f, direct);
			p.HeadPitch = Filter(ref _sHeadPitch, p.HeadPitch, 1f, direct);
			p.HeadRoll = Filter(ref _sHeadRoll, p.HeadRoll, 1f, direct);
			p.Spread = Filter(ref _sSpread, p.Spread, 100f, direct);
			p.Forward = Filter(ref _sForward, p.Forward, 100f, direct);
			p.Left.Local = Filter3(ref _sLeft, p.Left.Local, p.Left.Posed, p.Left.World, direct);
			p.Right.Local = Filter3(ref _sRight, p.Right.Local, p.Right.Posed, p.Right.World, direct);
			GaitSway(ref p, in input);
			Overlays(ref p, in input);
			Twitch(ref p);
			Tremor(ref p);
		}

		private float Filter(ref Servo c, float target, float unit, bool direct)
		{
			if (!c.Primed || direct)
			{
				c.Value = target;
				c.Velocity = 0f;
				c.Active = false;
				c.Primed = true;
				return target;
			}
			if (style.hitch < 0.05f)
			{
				c.Value = Mathf.SmoothDamp(c.Value, target, ref c.Velocity, 0.15f, float.PositiveInfinity, _dt);
				return c.Value;
			}
			if (!c.Active)
			{
				if (_now < c.HoldUntil || Mathf.Abs(target - c.Value) < style.hitch * 2.5f / unit)
				{
					return c.Value;
				}
				c.Active = true;
			}
			c.Value = Mathf.MoveTowards(c.Value, target, style.servoSpeed / unit * _dt);
			if (Mathf.Abs(target - c.Value) <= 0.0001f)
			{
				c.Active = false;
				c.HoldUntil = _now + Random.Range(style.servoHold.x, style.servoHold.y) * style.hitch;
			}
			return c.Value;
		}

		private Vector3 Filter3(ref Servo3 c, Vector3 target, bool posed, bool world, bool direct)
		{
			if (!posed || !c.Primed || direct || c.World != world)
			{
				c.World = world;
				c.Primed = posed;
				c.Value = target;
				c.Active = false;
				return target;
			}
			if (!c.Active)
			{
				if (_now < c.HoldUntil || (target - c.Value).sqrMagnitude < Sq(style.hitch * 0.025f))
				{
					return c.Value;
				}
				c.Active = true;
			}
			c.Value = Vector3.MoveTowards(c.Value, target, style.servoSpeed * 0.012f * _dt);
			if ((target - c.Value).sqrMagnitude <= 1E-08f)
			{
				c.Active = false;
				c.HoldUntil = _now + Random.Range(style.servoHold.x, style.servoHold.y) * style.hitch;
			}
			return c.Value;
		}

		private void GaitSway(ref Posture p, in FnPuppetInput input)
		{
			if (_activity == Activity.Walk)
			{
				float num = Mathf.Clamp01(input.Speed / 1.2f);
				float num2 = Mathf.Repeat(input.Gait * (float)style.cadence, 1f) * Mathf.PI * 2f;
				if (style.gallop)
				{
					p.Height -= style.bob * (Mathf.Cos(num2) * 0.5f + 0.5f) * num;
					p.Pitch += Hitch(Mathf.Sin(num2)) * 4f * num;
					return;
				}
				float num3 = Mathf.Cos(num2 * 2f) * 0.5f + 0.5f;
				p.Height -= style.bob * num3 * num;
				float x = Mathf.Sin(num2);
				p.Roll -= style.roll * Hitch(x) * num;
				p.Yaw += style.twist * Hitch(x) * num;
				p.HeadPitch -= style.plantNod * num3 * num;
			}
		}

		private float Hitch(float x)
		{
			return Mathf.Lerp(x, Mathf.Round(x * 4f) * 0.25f, style.hitch * 0.5f);
		}

		private void Twitch(ref Posture p)
		{
			if (style.twitchRate > 0f && _now >= _nextTwitch)
			{
				_nextTwitch = _now + Mathf.Clamp((0f - Mathf.Log(1f - Random.value * 0.999f)) / style.twitchRate, 0.15f, 8f);
				float num = style.twitchStrength * 14f * Random.Range(0.6f, 1f);
				if (Random.value < 0.5f)
				{
					num = 0f - num;
				}
				switch (Random.Range(0, 6))
				{
				case 0:
					_twHeadYaw.V += num;
					break;
				case 1:
					_twHeadPitch.V += num * 0.7f;
					break;
				case 2:
					_twHeadRoll.V += num;
					break;
				case 3:
					_twRoll.V += num * 0.35f;
					break;
				case 4:
					_twHandLV += Random.onUnitSphere * 1.1f;
					break;
				default:
					_twHandRV += Random.onUnitSphere * 1.1f;
					break;
				}
			}
			float num2 = _dt;
			while (num2 > 0f)
			{
				float h = Mathf.Min(num2, 0.02f);
				num2 -= h;
				StepSpring(ref _twHeadYaw, h);
				StepSpring(ref _twHeadPitch, h);
				StepSpring(ref _twHeadRoll, h);
				StepSpring(ref _twRoll, h);
				StepSpring3(ref _twHandL, ref _twHandLV, h);
				StepSpring3(ref _twHandR, ref _twHandRV, h);
			}
			p.HeadYaw += _twHeadYaw.X;
			p.HeadPitch += _twHeadPitch.X;
			p.HeadRoll += _twHeadRoll.X;
			p.Roll += _twRoll.X;
			if (p.Left.Posed)
			{
				p.Left.Local += _twHandL;
			}
			if (p.Right.Posed)
			{
				p.Right.Local += _twHandR;
			}
		}

		private static void StepSpring(ref Spring s, float h)
		{
			s.V += (s.X * -320f + s.V * -16f) * h;
			s.X += s.V * h;
		}

		private static void StepSpring3(ref Vector3 x, ref Vector3 v, float h)
		{
			v += (x * -280f + v * -15f) * h;
			x += v * h;
		}

		private void Tremor(ref Posture p)
		{
			float tremor = style.tremor;
			if (!(tremor <= 0f))
			{
				float t = _now * 9f;
				p.HeadYaw += tremor * Noise(t, 0f);
				p.HeadPitch += tremor * Noise(t, 17f);
				p.HeadRoll += tremor * 0.6f * Noise(t, 31f);
				float num = tremor * 0.004f;
				if (p.Left.Posed)
				{
					p.Left.Local += new Vector3(Noise(t, 43f), Noise(t, 59f), Noise(t, 71f)) * num;
				}
				if (p.Right.Posed)
				{
					p.Right.Local += new Vector3(Noise(t, 83f), Noise(t, 97f), Noise(t, 101f)) * num;
				}
			}
		}

		private float Noise(float t, float offset)
		{
			return (Mathf.PerlinNoise(t, _noiseSeed + offset) - 0.5f) * 2f;
		}

		private static float Sq(float x)
		{
			return x * x;
		}

		private void SnapHands()
		{
			Posture p = new Posture
			{
				Height = style.bodyHeight,
				Spread = style.handSpread,
				Forward = style.handForward
			};
			SnapHand(ref _left, -1f, in p);
			SnapHand(ref _right, 1f, in p);
			_lastRoot = base.transform.position;
			_hasLastRoot = true;
		}

		private void SnapHand(ref HandState h, float side, in Posture p)
		{
			h.Planted = true;
			h.Plant = Neutral(side, in p);
			h.Swinging = false;
			h.GaitSwing = false;
			h.Weight = 0f;
			h.Target = h.Plant;
		}

		private Vector3 Neutral(float side, in Posture p)
		{
			float num = Mathf.Clamp(p.Pitch, -30f, 60f);
			return base.transform.position + base.transform.rotation * new Vector3(p.Spread * side, style.wristHeight, p.Forward + Mathf.Sin(num * (Mathf.PI / 180f)) * 0.5f);
		}

		private void UpdateHands(in FnPuppetInput input, in Posture p)
		{
			Vector3 position = base.transform.position;
			if (!_hasLastRoot || (position - _lastRoot).sqrMagnitude > 4f)
			{
				SnapHands();
			}
			_lastRoot = position;
			Vector3 velocity = input.Velocity;
			velocity.y = 0f;
			Vector3 heading = ((velocity.sqrMagnitude > 0.09f) ? velocity.normalized : base.transform.forward);
			bool walking = _activity == Activity.Walk;
			Hand(ref _left, -1f, in input, in p, in p.Left, walking, heading, ref _right);
			Hand(ref _right, 1f, in input, in p, in p.Right, walking, heading, ref _left);
		}

		private void Hand(ref HandState h, float side, in FnPuppetInput input, in Posture p, in HandPose pose, bool walking, Vector3 heading, ref HandState other)
		{
			FnPuppetStyle fnPuppetStyle = style;
			float lift = 0f;
			Vector3 vector = Neutral(side, in p);
			Vector3 fistAlong = base.transform.rotation * new Vector3(0f, -1f, 0.15f);
			Vector3 a = base.transform.rotation * Vector3.back;
			Vector3 a2 = base.transform.rotation * new Vector3(side * 0.55f, -0.15f, -0.8f);
			if (h.Weight > 0.5f)
			{
				h.Planted = true;
				h.Swinging = false;
				h.GaitSwing = false;
				h.Plant = vector;
			}
			else if (walking)
			{
				Gait(ref h, side, in input, vector, heading, ref lift, ref fistAlong);
			}
			else
			{
				if (h.GaitSwing)
				{
					h.GaitSwing = false;
					StartStep(ref h, h.Target, vector);
				}
				Stand(ref h, vector, ref other, ref lift);
			}
			Vector3 vector2 = (h.Swinging ? Arc(h.From, h.To, h.SwingT, lift) : h.Plant);
			if (!h.Swinging && (vector2 - vector).sqrMagnitude > MaxStretch * MaxStretch)
			{
				h.Plant = vector;
				vector2 = vector;
			}
			if (pose.Posed)
			{
				Vector3 vector3 = ((side < 0f) ? ((_upperL != null) ? _upperL.position : base.transform.position) : ((_upperR != null) ? _upperR.position : base.transform.position));
				Vector3 vector4 = (pose.World ? pose.Local : (vector3 + base.transform.rotation * pose.Local));
				h.HasPosed = true;
				h.PosedWorld = pose.World;
				h.PosedAt = (h.PosedWorld ? vector4 : (Quaternion.Inverse(base.transform.rotation) * (vector4 - base.transform.position)));
				h.PosedAlong = pose.Along;
				h.PosedPalm = pose.Palm;
				h.PosedPole = pose.Pole;
				h.PosedCurl = pose.Curl;
			}
			float target = (pose.Posed ? 1f : 0f);
			h.Weight = Mathf.MoveTowards(h.Weight, target, _dt / ((_activity == Activity.Jump) ? JumpPoseBlendSeconds : PoseBlendSeconds));
			float num = (h.HasPosed ? Mathf.SmoothStep(0f, 1f, h.Weight) : 0f);
			Quaternion quaternion = (h.PosedWorld ? Quaternion.identity : base.transform.rotation);
			Vector3 b = (h.PosedWorld ? h.PosedAt : (base.transform.position + base.transform.rotation * h.PosedAt));
			h.Target = Vector3.Lerp(vector2, b, num) + ((num > 0f && num < 1f) ? (Vector3.up * (Mathf.Sin(num * Mathf.PI) * 0.12f)) : Vector3.zero);
			h.Pole = Vector3.Slerp(a2, quaternion * h.PosedPole, num);
			h.Along = Vector3.Slerp(fistAlong, quaternion * h.PosedAlong, num);
			h.Palm = Vector3.Slerp(a, quaternion * h.PosedPalm, num);
			h.Curl = Mathf.Lerp(fnPuppetStyle.fistCurl, h.PosedCurl, num);
		}

		private void Gait(ref HandState h, float side, in FnPuppetInput input, Vector3 neutral, Vector3 heading, ref float lift, ref Vector3 fistAlong)
		{
			float num = Mathf.Repeat(input.Gait * (float)style.cadence, 1f);
			float num2 = (style.gallop ? 0.42f : 0.5f);
			float num3 = (style.gallop ? ((side < 0f) ? 0f : 0.06f) : ((side < 0f) ? 0f : 0.5f));
			float num4 = Mathf.Max(input.StrideLength, 0.3f) / (float)style.cadence * (1f - num2) * 0.5f;
			Vector3 vector = neutral + heading * num4;
			float num5 = Mathf.Repeat(num - num3, 1f);
			if (num5 < num2)
			{
				if (!h.GaitSwing)
				{
					h.From = (h.Planted ? h.Plant : h.Target);
					h.Planted = false;
					h.Swinging = true;
					h.GaitSwing = true;
				}
				h.To = vector;
				h.SwingT = Hitch01(num5 / num2);
				lift = style.liftHeight * (Mathf.Clamp01(input.Speed / Mathf.Max(style.runSpeed, 0.5f)) * 0.4f + 0.6f);
				fistAlong = base.transform.rotation * new Vector3(0f, -1f, Mathf.Sin(h.SwingT * Mathf.PI) * 0.55f + 0.15f);
			}
			else if (h.GaitSwing)
			{
				h.Swinging = false;
				h.GaitSwing = false;
				h.Planted = true;
				h.Plant = vector;
				OnPlant?.Invoke(vector, Mathf.Clamp01(input.Speed / Mathf.Max(style.runSpeed, 0.5f)) * 0.5f + 0.5f);
			}
			else if (!h.Planted)
			{
				h.Planted = true;
				h.Plant = neutral;
			}
		}

		private void Stand(ref HandState h, Vector3 neutral, ref HandState other, ref float lift)
		{
			if (h.Swinging)
			{
				h.To = neutral;
				h.SwingT = Mathf.Min(h.SwingT + _dt / StepSeconds, 1f);
				lift = 0.09f;
				if (h.SwingT >= 1f)
				{
					h.Plant = neutral;
					h.Swinging = false;
					h.Planted = true;
					OnPlant?.Invoke(neutral, 0.3f);
				}
				return;
			}
			if (!h.Planted)
			{
				h.Planted = true;
				h.Plant = neutral;
			}
			if ((h.Plant - neutral).sqrMagnitude > StepDrift * StepDrift && !other.Swinging)
			{
				StartStep(ref h, h.Plant, neutral);
			}
		}

		private static void StartStep(ref HandState h, Vector3 from, Vector3 to)
		{
			h.Planted = false;
			h.Swinging = true;
			h.From = from;
			h.To = to;
			h.SwingT = 0f;
		}

		private static Vector3 Arc(Vector3 from, Vector3 to, float t, float lift)
		{
			return Vector3.Lerp(from, to, Mathf.SmoothStep(0f, 1f, t)) + Vector3.up * (Mathf.Sin(t * Mathf.PI) * lift);
		}

		private float Hitch01(float t)
		{
			return Mathf.Lerp(t, Mathf.Round(t * 5f) / 5f, style.hitch * 0.35f);
		}

		private void LatchDoor(in FnPuppetInput input)
		{
			Vector3 position = base.transform.position;
			if (!_doorLatched || !((position - _doorLatchRoot).sqrMagnitude < 0.0009f) || !((input.DoorNormal - _doorN).sqrMagnitude < 0.0001f) || !((input.DoorPoint - _doorCentre).sqrMagnitude < 0.0001f))
			{
				_doorLatched = true;
				_doorLatchRoot = position;
				_doorCentre = input.DoorPoint;
				_doorN = input.DoorNormal;
				_doorFloor = input.DoorPoint.y;
				_doorHalfWidth = Mathf.Max(input.DoorHalfWidth, 0.3f);
				_doorFoot = position - _doorN * Vector3.Dot(_doorN, position - input.DoorPoint);
				_doorFoot.y = _doorFloor;
				Vector3 vector = Vector3.Cross(Vector3.up, _doorN);
				_doorAcross = ((Vector3.Dot(vector, base.transform.right) < 0f) ? (-vector) : vector);
			}
		}

		private Vector3 OnDoor(float across, float height, float outward)
		{
			return _doorFoot + _doorAcross * across + Vector3.up * height + _doorN * outward;
		}

		private void KnockPosture(ref Posture p, in FnPuppetInput input)
		{
			FnPuppetStyle fnPuppetStyle = style;
			if (!input.HasDoor)
			{
				_doorLatched = false;
				p.Height += 0.12f;
				p.Pitch = 8f;
				p.Left = Posed(new Vector3(0.1f, 0.15f, 0.72f), new Vector3(0f, 0.3f, 1f), new Vector3(1f, 0f, 0f), new Vector3(-0.7f, -0.6f, -0.2f), fnPuppetStyle.fistCurl);
				p.Right = Posed(new Vector3(-0.1f, 0.15f, 0.72f), new Vector3(0f, 0.3f, 1f), new Vector3(-1f, 0f, 0f), new Vector3(0.7f, -0.6f, -0.2f), fnPuppetStyle.fistCurl);
				return;
			}
			LatchDoor(in input);
			float knockSide = KnockSide;
			bool flag = input.BangAge > BurstSeconds(in input) + 0.4f;
			p.HeadPitch -= (flag ? 5f : 0f);
			p.HeadRoll += knockSide * (flag ? 18f : 11f);
			p.Height = fnPuppetStyle.bodyHeight + 0.05f;
			p.Pitch = fnPuppetStyle.standLean * 0.5f + 7f + (flag ? 3f : 0f);
			p.Roll = knockSide * -3f;
			p.Surge = (flag ? 0.03f : 0f);
			float num = knockSide * -0.3f;
			Vector3 wrist = OnDoor(num, ShoulderHeight + 0.1f, PalmThickness);
			HandPose handPose2 = WorldPosed(wrist, Vector3.up * 0.95f + _doorAcross * num, -_doorN, _doorAcross * (knockSide * -0.7f) + Vector3.up * -0.55f + _doorN * 0.45f, fnPuppetStyle.relaxedCurl * 0.35f);
			HandPose handPose = WorldPosed(KnockRest(), _doorN * -0.9f + Vector3.up * -0.15f - _doorAcross * (knockSide * 0.2f), -_doorAcross * (knockSide * 0.8f) - Vector3.up * 0.35f, _doorAcross * (knockSide * 0.55f) + Vector3.up * -0.75f + _doorN * 0.35f, fnPuppetStyle.fistCurl + 12f);
			if (knockSide < 0f)
			{
				p.Left = handPose;
				p.Right = handPose2;
			}
			else
			{
				p.Left = handPose2;
				p.Right = handPose;
			}
		}

		private Vector3 KnockRest()
		{
			return OnDoor(KnockSide * 0.24f, ShoulderHeight - 0.1f, _fistFront + RestGap);
		}

		private Vector3 KnockReady()
		{
			return OnDoor(KnockSide * 0.16f, HeadHeight - 0.08f, _fistFront + ReadyGap);
		}

		private float BurstSeconds(in FnPuppetInput input)
		{
			return (input.BangHeavy ? 0.36f : (0.07f + RapHoldSeconds + RapReturnSeconds)) + input.KnockInterval * (float)(Mathf.Max(input.KnockRaps, 1) - 1) + (input.BangHeavy ? SlamRecoilSeconds : (RapHoldSeconds + RapReturnSeconds));
		}

		private void KnockOverlay(ref Posture p, in FnPuppetInput input)
		{
			_rapLurch = Mathf.MoveTowards(_rapLurch, 0f, _dt / 0.12f);
			if (!input.HasDoor || !_doorLatched)
			{
				LegacyStrike(ref p, in input);
				return;
			}
			float num = BurstSeconds(in input);
			if (!(input.BangAge < 0f) && !(input.BangAge > num + SettleSeconds))
			{
				if (input.BangHeavy)
				{
					Slam(ref p, in input, input.BangAge, num);
				}
				else
				{
					Raps(ref p, in input, input.BangAge, num);
				}
				p.Pitch += _rapLurch * 2f;
				p.HeadPitch += _rapLurch * -2.5f;
			}
		}

		private void Raps(ref Posture p, in FnPuppetInput input, float age, float total)
		{
			float num = Mathf.Max(input.KnockInterval, 0.1f);
			float a = Mathf.Min(num - 0.07f - RapHoldSeconds, RapReturnSeconds);
			int num2 = Mathf.Max(input.KnockRaps, 1);
			float num3 = ((age > total) ? (1f - Mathf.SmoothStep(0f, 1f, (age - total) / SettleSeconds)) : Mathf.SmoothStep(0f, 1f, age / 0.16f));
			Vector3 vector = (KnockReady() - KnockRest()) * num3;
			float num4 = age - 0.16f;
			int num5 = Mathf.Min(num2 - 1, Mathf.FloorToInt(num4 / num));
			if (num5 >= 0)
			{
				float num6 = num4 - num * (float)num5;
				float num7 = ((num6 < 0.07f) ? Sq(num6 / 0.07f) : ((num6 < 0.07f + RapHoldSeconds) ? 1f : (1f - Mathf.SmoothStep(0f, 1f, (num6 - 0.07f - RapHoldSeconds) / Mathf.Max(a, 0.02f)))));
				if (num6 >= 0.07f && num6 < _dt + 0.07f + 0.001f)
				{
					_rapLurch = 1f;
				}
				ref HandPose reference = ref KnockHand(ref p);
				vector += Vector3.down * (num7 * 0.02f) - _doorN * (num7 * 0.11f);
				reference.Along += Vector3.up * (num3 * ((1f - num7) * 0.25f)) - _doorN * (num7 * 0.25f);
			}
			KnockHand(ref p).Local += vector;
		}

		private void Slam(ref Posture p, in FnPuppetInput input, float age, float total)
		{
			float num = Mathf.Max(input.KnockInterval, 0.2f);
			int num2 = Mathf.Max(input.KnockRaps, 1);
			float num3 = 1f;
			if (age > total)
			{
				num3 = 1f - Mathf.SmoothStep(0f, 1f, (age - total) / SettleSeconds);
			}
			float b = HeadHeight + 0.3f;
			float a = ShoulderHeight + 0.05f;
			int num4 = Mathf.Clamp(Mathf.FloorToInt((age - 0.3f - 0.06f) / num) + 1, 0, num2 - 1);
			float num5 = 0.3f + 0.06f + num * (float)num4;
			float num6 = ((num4 == 0) ? 0f : (num5 - num + 0.05f));
			float num7 = 0f;
			float num8;
			if (num6 > age)
			{
				num8 = 1f;
			}
			else
			{
				float num9 = num5 - 0.06f;
				if (num9 > age)
				{
					float num10 = Mathf.SmoothStep(0f, 1f, (age - num6) / Mathf.Max(num9 - num6, 0.05f));
					num7 = ((num4 == 0) ? num10 : (num10 * 0.6f));
					num8 = 1f - num10;
				}
				else if (num5 > age)
				{
					num8 = Sq((age - num9) / 0.06f);
					num7 = ((num4 == 0) ? 1f : 0.6f) * (1f - num8);
				}
				else
				{
					float num11 = age - num5;
					num8 = Mathf.Sin(Mathf.Clamp01(num11 / SlamRecoilSeconds) * (0f - Mathf.PI) * 0.5f) * 0.5f + 1f;
					if (num11 < _dt + 0.001f)
					{
						_rapLurch = 1f;
					}
					num7 = 0f;
				}
			}
			float height = Mathf.Lerp(a, b, num7);
			float outward = _fistFront + Mathf.Lerp(0.45f, 0f, num8) + num7 * 0.1f;
			float t = num3 * Mathf.SmoothStep(0f, 1f, age / 0.12f);
			for (int i = -1; i <= 1; i += 2)
			{
				ref HandPose reference = ref ((i < 0) ? ref p.Left : ref p.Right);
				Vector3 vector = OnDoor((num7 * 0.12f + 0.2f) * (float)i, height, outward);
				Vector3 a2 = (reference.World ? reference.Local : vector);
				reference.Posed = true;
				reference.World = true;
				reference.Local = Vector3.Lerp(a2, vector, num3);
				reference.Along = Vector3.Slerp(reference.Along, (_doorN * -0.8f - Vector3.up * (0.5f - num7)).normalized, t);
				reference.Palm = Vector3.Slerp(reference.Palm, (-_doorAcross * ((float)i * 0.8f) + Vector3.up * -0.3f).normalized, t);
				reference.Pole = Vector3.Slerp(reference.Pole, (_doorAcross * ((float)i * 0.6f) + Vector3.up * -0.6f + _doorN * 0.4f).normalized, t);
				reference.Curl = Mathf.Lerp(reference.Curl, style.fistCurl + 14f, t);
			}
			p.Height += num3 * 0.05f * num7;
			p.Pitch += num3 * (num8 * 11f * (1f - num7) + num7 * -7f);
			p.Surge += num3 * 0.07f * num8 * (1f - num7);
			p.HeadPitch += num3 * (num7 * 6f + num8 * -4f);
		}

		private void LegacyStrike(ref Posture p, in FnPuppetInput input)
		{
			if (_activity == Activity.Bang && !(input.BangAge < 0f) && !(input.BangAge >= 0.32f))
			{
				float bangAge = input.BangAge;
				float num = ((bangAge < 0.12f) ? (bangAge / 0.12f * -0.3f) : ((!(bangAge < 0.18f)) ? (0.08f - Mathf.Clamp01((bangAge - 0.18f) / 0.14f) * 0.08f) : (Mathf.Clamp01((bangAge - 0.12f) / 0.06f) * 0.38f - 0.3f)));
				if (input.BangHeavy)
				{
					p.Left.Local.z += num;
					p.Right.Local.z += num;
				}
				else if ((input.BangCount & 1) == 1)
				{
					p.Left.Local.z += num;
				}
				else
				{
					p.Right.Local.z += num;
				}
			}
		}

		private ref HandPose KnockHand(ref Posture p)
		{
			if (style.knockLeft)
			{
				return ref p.Left;
			}
			return ref p.Right;
		}

		private void PeekPosture(ref Posture p, in FnPuppetInput input)
		{
			p.Surge = 0.08f;
			p.Height -= 0.04f;
			p.Pitch += 14f;
			if (!input.HasDoor)
			{
				p.Roll = 6f;
				p.HeadRoll += 12f;
				p.Right = Posed(new Vector3(0.05f, 0.12f, 0.62f), new Vector3(0.1f, 1f, 0.35f), new Vector3(0f, 0f, 1f), new Vector3(0.7f, -0.6f, -0.3f), 18f);
				return;
			}
			LatchDoor(in input);
			float num = Vector3.Dot(base.transform.position - _doorCentre, _doorAcross);
			float num2 = ((Mathf.Abs(num) > 0.05f) ? ((num < 0f) ? (-1f) : 1f) : KnockSide);
			p.HeadRoll += num2 * -12f;
			p.Roll = num2 * 4f;
			Transform transform2 = ((num2 < 0f) ? _upperL : _upperR);
			if (!(transform2 == null))
			{
				Vector3 vector = _doorCentre + _doorAcross * (num2 * (_doorHalfWidth - 0.03f)) + _doorN * 0.06f;
				vector.y = _doorFloor + ShoulderHeight + 0.15f;
				if (!((vector - transform2.position).sqrMagnitude > Sq(_armLength * GripReach)))
				{
					HandPose handPose = WorldPosed(vector, _doorN * -0.5f - _doorAcross * (num2 * 0.6f) + Vector3.up * 0.2f, _doorN * -0.7f - _doorAcross * (num2 * 0.3f), _doorAcross * (num2 * 0.6f) + Vector3.up * -0.7f + _doorN * 0.3f, 55f);
					if (num2 < 0f)
					{
						p.Left = handPose;
					}
					else
					{
						p.Right = handPose;
					}
				}
			}
		}

		private void ClampHandsToDoor()
		{
			if (_activity == Activity.Bang && _doorLatched)
			{
				ClampToDoor(ref _left);
				ClampToDoor(ref _right);
			}
		}

		private void ClampToDoor(ref HandState h)
		{
			if (!(h.Weight <= 0f))
			{
				Vector3 vector = ((h.Along.sqrMagnitude > 1E-06f) ? h.Along.normalized : (-_doorN));
				float num = Vector3.Dot(h.Target + vector * _fistFront - _doorFoot, _doorN);
				if (num < FistClearance)
				{
					h.Target += _doorN * (FistClearance - num);
				}
				float num2 = Vector3.Dot(h.Target - _doorFoot, _doorN);
				if (num2 < 0.028f)
				{
					h.Target += _doorN * (0.028f - num2);
				}
			}
		}

		private static HandPose WorldPosed(Vector3 wrist, Vector3 along, Vector3 palm, Vector3 pole, float curl)
		{
			return new HandPose
			{
				Posed = true,
				World = true,
				Local = wrist,
				Along = along.normalized,
				Palm = palm.normalized,
				Pole = pole.normalized,
				Curl = curl
			};
		}

		private Posture BasePosture(in FnPuppetInput input)
		{
			FnPuppetStyle s = style;
			Posture p = new Posture
			{
				Height = s.bodyHeight,
				Pitch = s.standLean,
				HeadRoll = s.headTilt,
				Spread = s.handSpread,
				Forward = s.handForward,
				Left = Planted(s),
				Right = Planted(s)
			};
			switch (_activity)
			{
			case Activity.Stand:
				p.HeadYaw = s.idleSway * Wave(_now / Mathf.Max(s.idleSwayPeriod, 0.5f));
				p.Height += Wave(_now / 3.2f) * 0.008f;
				break;
			case Activity.Walk:
			{
				float t = Mathf.Clamp01(input.Speed / Mathf.Max(s.runSpeed, 0.5f));
				p.Pitch = Mathf.Lerp(s.walkLean, s.runLean, t);
				p.Height -= t * 0.04f;
				break;
			}
			case Activity.Perform:
				Perform(ref p, s, _now * s.tempo / 60f);
				break;
			case Activity.Search:
				p.Yaw = Wave(_now * 0.25f) * 12f;
				p.Pitch = s.standLean + 4f;
				break;
			case Activity.Peek:
				PeekPosture(ref p, in input);
				break;
			case Activity.Bang:
				KnockPosture(ref p, in input);
				break;
			case Activity.Lunge:
				p.Pitch = s.standLean + 16f;
				p.Height = s.bodyHeight + 0.12f;
				p.HeadPitch = 6f;
				p.Left = Posed(new Vector3(0.12f, 0.06f, 0.95f), new Vector3(0f, 0.1f, 1f), new Vector3(0f, -1f, 0f), new Vector3(-0.7f, -0.6f, 0f), s.spreadCurl);
				p.Right = Posed(new Vector3(-0.12f, 0.06f, 0.95f), new Vector3(0f, 0.1f, 1f), new Vector3(0f, -1f, 0f), new Vector3(0.7f, -0.6f, 0f), s.spreadCurl);
				break;
			case Activity.Slump:
				p.Height = s.bodyHeight - 0.1f;
				p.Pitch = s.standLean + 16f;
				p.Roll = 10f;
				p.HeadPitch = -28f;
				p.HeadRoll = s.headTilt + 14f;
				p.Spread = s.handSpread * 0.82f;
				p.Forward = s.handForward * 0.65f;
				p.Left.Curl = s.relaxedCurl;
				p.Right.Curl = s.relaxedCurl;
				break;
			case Activity.MusicBox:
			{
				p.Pitch = 3f;
				p.Height = s.bodyHeight + 0.1f;
				float t = _now * 0.4f;
				p.HeadYaw = Wave(t) * 18f;
				p.HeadRoll = s.headTilt + Wave(t + 0.2f) * 8f;
				p.Right = Posed(new Vector3(-0.12f, -0.05f, 0.32f), new Vector3(-0.35f, 0.3f, 0.88f), new Vector3(-1f, 0f, 0f), new Vector3(0.6f, -0.7f, -0.2f), 70f);
				break;
			}
			case Activity.Jump:
				JumpPosture(ref p, in input, s);
				break;
			}
			return p;
		}

		private void JumpPosture(ref Posture p, in FnPuppetInput input, FnPuppetStyle s)
		{
			if (input.Airborne)
			{
				AirPosture(ref p, in input, s);
				return;
			}
			if (input.JumpCharge)
			{
				float sink = Mathf.SmoothStep(0f, 1f, input.JumpChargeAge / ChargeSinkSeconds);
				float build = Mathf.Clamp01(input.JumpChargeAge / ChargeBuildSeconds);
				p.Height -= sink * 0.2f - build * 0.012f * Mathf.Sin(_now * Mathf.PI * 2f * 17f);
				p.Pitch = s.standLean + sink * 22f;
				p.Roll += build * 1.5f * Mathf.Sin(_now * Mathf.PI * 2f * 11f);
				p.HeadPitch += sink * 12f;
				p.Spread = s.handSpread * (1f + sink * 0.25f);
				p.Forward = s.handForward * (1f + sink * 0.2f);
				return;
			}
			float t = Mathf.Clamp01(input.LandAge / LandSeconds);
			float squash = input.LandImpact * ((t < LandSinkShare) ? Mathf.SmoothStep(0f, 1f, t / LandSinkShare) : (1f - Mathf.SmoothStep(0f, 1f, (t - LandSinkShare) / (1f - LandSinkShare))));
			p.Height -= squash * 0.26f;
			p.Pitch = s.standLean + squash * 20f;
			p.HeadPitch -= squash * 8f;
			p.Spread = s.handSpread * (1f + squash * 0.3f);
			p.Forward = s.handForward * (1f + squash * 0.15f);
		}

		private void AirPosture(ref Posture p, in FnPuppetInput input, FnPuppetStyle s)
		{
			float rise = Mathf.Clamp01(input.VerticalSpeed / 3f);
			float fall = Mathf.Clamp01(input.VerticalSpeed / -3f);
			float apex = 1f - rise - fall;
			float lift = Mathf.Clamp01(input.Lift * 2f);
			p.Height += (rise * 0.16f + apex * 0.12f + fall * 0.04f) * lift;
			p.Pitch = s.standLean - rise * 14f + apex * 12f + fall * 6f;
			p.Surge += apex * 0.1f;
			p.HeadPitch += rise * 10f + apex * 4f;
			Vector3 grabL = new Vector3(0.1f, 0.5f, 0.82f);
			Vector3 grabR = new Vector3(-0.1f, 0.5f, 0.82f);
			if (apex > 0.01f && input.HasLook)
			{
				Quaternion inverseFrame = Quaternion.Inverse(transform.rotation);
				Vector3 apart = transform.right * 0.15f;
				grabL = ReachFor(inverseFrame, input.LookPoint - apart, _upperL);
				grabR = ReachFor(inverseFrame, input.LookPoint + apart, _upperR);
			}
			p.Left = AirHand(-1f, grabL, rise, apex, fall, s);
			p.Right = AirHand(1f, grabR, rise, apex, fall, s);
		}

		private HandPose AirHand(float side, Vector3 grab, float up, float top, float down, FnPuppetStyle s)
		{
			Vector3 local = grab * top + new Vector3(side * 0.12f, 0.95f, 0.25f) * up + new Vector3(0f, -0.55f, 0.45f) * down;
			Vector3 along = new Vector3(0f, 0.1f, 1f) * top + new Vector3(0f, 1f, 0.3f) * up + new Vector3(0f, -0.6f, 0.8f) * down;
			Vector3 palm = new Vector3(0f, -1f, 0f) * top + new Vector3(0f, 0f, 1f) * up + new Vector3(0f, -0.8f, -0.6f) * down;
			Vector3 pole = new Vector3(side * 0.7f, -0.6f, 0f) * top + new Vector3(side * 0.8f, 0.1f, -0.5f) * up + new Vector3(side * 0.6f, 0f, -0.8f) * down;
			float curl = Mathf.Lerp(s.spreadCurl, s.fistCurl, 0.6f) * top + s.spreadCurl * up + s.relaxedCurl * down;
			return Posed(local, along, palm, pole, curl);
		}

		private Vector3 ReachFor(Quaternion inverseFrame, Vector3 point, Transform shoulder)
		{
			Vector3 origin = ((shoulder != null) ? shoulder.position : (transform.position + Vector3.up * _shoulderAboveModel));
			Vector3 local = inverseFrame * (point - origin);
			float reach = _armLength * MaxStretch;
			if (local.sqrMagnitude > reach * reach)
			{
				local = local.normalized * reach;
			}
			return local;
		}

		private static void Perform(ref Posture p, FnPuppetStyle s, float beat)
		{
			switch (s.perform)
			{
			case FnPerform.Mic:
			{
				p.Pitch = 2f;
				p.Height += 0.12f;
				p.HeadYaw = Wave(beat * 0.25f) * 12f;
				float sway = Wave(beat * 0.5f);
				p.HeadRoll += sway * 5f;
				p.Right = Posed(new Vector3(-0.14f, Wave(beat) * 0.02f + 0.1f, 0.36f), new Vector3(-0.35f, 0.3f, 0.88f), new Vector3(-1f, 0f, 0f), new Vector3(0.6f, -0.7f, -0.2f), 70f);
				p.Left = Posed(new Vector3(sway * 0.08f - 0.25f, 0.35f, 0.3f), new Vector3(-0.2f, 1f, 0.2f), new Vector3(0f, 0f, 1f), new Vector3(-0.8f, -0.5f, -0.2f), s.spreadCurl);
				break;
			}
			case FnPerform.Guitar:
				p.Pitch = 4f;
				p.Height += 0.1f;
				p.HeadPitch = Mathf.Abs(Wave(beat * 0.5f)) * 6f;
				p.Right = Posed(new Vector3(-0.22f, Wave(beat * 2f) * 0.06f - 0.28f, 0.36f), new Vector3(-0.5f, -0.5f, 0.5f), new Vector3(0f, 0f, -1f), new Vector3(0.6f, -0.7f, 0f), 45f);
				p.Left = Posed(new Vector3(-0.15f, -0.05f, 0.42f), new Vector3(0.2f, 0.4f, 0.9f), new Vector3(1f, 0f, 0f), new Vector3(-0.7f, -0.6f, -0.1f), (Mathf.Repeat(beat, 2f) < 1f) ? 40f : 60f);
				break;
			case FnPerform.Present:
			{
				p.Height += 0.1f;
				p.HeadRoll += Wave(beat * 0.5f) * 10f;
				float lift = Mathf.Max(0f, Wave(beat)) * 0.04f - 0.18f;
				p.Left = Posed(new Vector3(0.13f, lift, 0.5f), new Vector3(0f, 0.1f, 1f), new Vector3(0f, 1f, 0f), new Vector3(-0.7f, -0.7f, 0f), 12f);
				p.Right = Posed(new Vector3(-0.13f, lift, 0.5f), new Vector3(0f, 0.1f, 1f), new Vector3(0f, 1f, 0f), new Vector3(0.7f, -0.7f, 0f), 12f);
				break;
			}
			case FnPerform.Crouch:
				p.Pitch = 34f;
				p.HeadPitch = 18f;
				p.Height -= 0.16f;
				p.Spread = s.handSpread * 1.15f;
				p.Forward = s.handForward * 1.2f;
				break;
			}
		}

		private void Overlays(ref Posture p, in FnPuppetInput input)
		{
			float t = _now;
			if (_activity == Activity.Bang)
			{
				KnockOverlay(ref p, in input);
			}
			if (input.LaughLeft > 0f)
			{
				float k = Mathf.Clamp01(input.LaughLeft / 0.3f);
				float w = Mathf.Sin(t * Mathf.PI * 7f);
				p.Pitch -= k * 5f;
				p.HeadPitch += (w * 5f + 16f) * k;
				p.Height += Mathf.Abs(w) * 0.015f * k;
			}
			if (input.ShriekLeft > 0f)
			{
				float k2 = Mathf.Clamp01(input.ShriekLeft * 4f);
				p.Pitch -= k2 * 12f;
				float w2 = Mathf.Sin(t * Mathf.PI * 14f);
				p.HeadYaw += w2 * 7f * k2;
				p.HeadPitch += 10f * k2;
				p.Left = Posed(new Vector3(-0.5f, 0.15f, 0.25f), new Vector3(-0.6f, 0.6f, 0.4f), new Vector3(0f, 0f, 1f), new Vector3(-0.3f, -0.9f, -0.2f), style.spreadCurl);
				p.Right = Posed(new Vector3(0.5f, 0.15f, 0.25f), new Vector3(0.6f, 0.6f, 0.4f), new Vector3(0f, 0f, 1f), new Vector3(0.3f, -0.9f, -0.2f), style.spreadCurl);
			}
			if (input.StareLeft > 0f)
			{
				float k3 = Mathf.Clamp01(input.StareLeft / 0.4f);
				p.HeadRoll += k3 * 12f;
				p.Pitch += k3 * 6f;
			}
			if (!Staring)
			{
				return;
			}
			p.HeadRoll += ((style.headTilt < 0f) ? (0f - _stareTilt) : _stareTilt);
			if (_lensCloseness > 0f && _activity != Activity.Walk && _activity != Activity.Lunge && _activity != Activity.Jump)
			{
				Vector3 d = transform.InverseTransformDirection(_lens - transform.position);
				p.Yaw += Mathf.Clamp(Mathf.Atan2(d.x, d.z) * Mathf.Rad2Deg, -30f, 30f) * 0.5f * _lensCloseness;
				p.Pitch += style.lensLean * _lensCloseness;
				p.Surge += _lensCloseness * 0.12f;
			}
		}

		private static HandPose Planted(FnPuppetStyle s)
		{
			return new HandPose
			{
				Curl = s.fistCurl
			};
		}

		private static HandPose Posed(Vector3 local, Vector3 along, Vector3 palm, Vector3 pole, float curl)
		{
			return new HandPose
			{
				Posed = true,
				World = false,
				Local = local,
				Along = along,
				Palm = palm,
				Pole = pole,
				Curl = curl
			};
		}

		private static float Wave(float cycles)
		{
			return Mathf.Sin(cycles * Mathf.PI * 2f);
		}

		private void UpdateProp(in FnPuppetInput input)
		{
			if (propObject == null)
			{
				return;
			}
			if (_activity == Activity.Perform || (_activity == Activity.MusicBox && propGrip == FnPropGrip.RightHand))
			{
				_propHeld = true;
				_propPlaced = true;
				if (!propObject.gameObject.activeSelf)
				{
					propObject.gameObject.SetActive(true);
				}
				switch (propGrip)
				{
				case FnPropGrip.Chest:
					if (!(_neck == null))
					{
						propObject.SetPositionAndRotation(_neck.TransformPoint(propOffset), _neck.rotation * Quaternion.Euler(propEuler));
					}
					break;
				case FnPropGrip.BothHands:
					if (!(_handL == null) && !(_handR == null))
					{
						Vector3 mid = (_handL.position + _handR.position) * 0.5f;
						propObject.SetPositionAndRotation(mid + transform.rotation * propOffset, transform.rotation * Quaternion.Euler(propEuler));
					}
					break;
				default:
					if (!(_handR == null))
					{
						propObject.SetPositionAndRotation(_handR.TransformPoint(propOffset), _handR.rotation * Quaternion.Euler(propEuler));
					}
					break;
				}
			}
			else if (_propHeld || !_propPlaced)
			{
				RestProp();
			}
		}

		private void RestProp()
		{
			_propHeld = false;
			_propPlaced = true;
			if (propRest == null)
			{
				if (propObject.gameObject.activeSelf)
				{
					propObject.gameObject.SetActive(false);
				}
				return;
			}
			if (!propObject.gameObject.activeSelf)
			{
				propObject.gameObject.SetActive(true);
			}
			propObject.SetPositionAndRotation(propRest.position, propRest.rotation);
		}

		public void BakeRest()
		{
			restBones = model.GetComponentsInChildren<Transform>(true);
			restRotations = new Quaternion[restBones.Length];
			for (int i = 0; i < restBones.Length; i++)
			{
				restRotations[i] = restBones[i].localRotation;
			}
		}

		private void RestoreRest()
		{
			if (restBones == null || restRotations == null)
			{
				return;
			}
			for (int i = 0; i < restBones.Length && i < restRotations.Length; i++)
			{
				if (restBones[i] != null)
				{
					restBones[i].localRotation = restRotations[i];
				}
			}
		}

		private void BindRig()
		{
			_neck = Find(model, "neck");
			_neckJoint = Find(model, "Bone.001");
			_head = Find(model, "head");
			_eyeL = Find(model, "eye.L");
			_eyeR = Find(model, "eye.R");
			_upperL = Find(model, "upperarm.L");
			_lowerL = Find(model, "lowerarm.L");
			_handL = Find(model, "hand.L");
			_upperR = Find(model, "upperarm.R");
			_lowerR = Find(model, "lowerarm.R");
			_handR = Find(model, "hand.R");
			_thumbL = Find(model, "thumb1.L");
			_thumbR = Find(model, "thumb1.R");
			for (int i = 0; i < FingerNames.Length; i++)
			{
				_fingersL[i] = Find(model, FingerNames[i] + ".L");
				_fingersR[i] = Find(model, FingerNames[i] + ".R");
			}
			if (_neck == null || _head == null || _handL == null || _handR == null)
			{
				Debug.LogError("[FnPuppet] " + base.name + ": the model is missing ape bones (neck, head, hands); it won't animate.", this);
			}
		}

		private static Transform Find(Transform t, string bone)
		{
			if (t.name == bone)
			{
				return t;
			}
			for (int i = 0; i < t.childCount; i++)
			{
				Transform found = Find(t.GetChild(i), bone);
				if (found != null)
				{
					return found;
				}
			}
			return null;
		}

		private void CaptureRig()
		{
			Quaternion inverseRoot = Quaternion.Inverse(transform.rotation);
			if (_neck != null)
			{
				_neckRest = inverseRoot * _neck.rotation;
			}
			if (_neckJoint != null)
			{
				_neckJointRest = inverseRoot * _neckJoint.rotation;
			}
			if (_head != null)
			{
				_headRest = inverseRoot * _head.rotation;
			}
			if (_eyeL != null)
			{
				_eyeRestL = _eyeL.localRotation;
			}
			if (_eyeR != null)
			{
				_eyeRestR = _eyeR.localRotation;
			}
			CaptureArm(_upperL, _lowerL, _handL, transform.right, out _upperOffL, out _lowerOffL, out _handOffL);
			CaptureArm(_upperR, _lowerR, _handR, -transform.right, out _upperOffR, out _lowerOffR, out _handOffR);
			for (int i = 0; i < 6; i++)
			{
				if (_fingersL[i] != null)
				{
					_fingerRestL[i] = _fingersL[i].localRotation;
				}
				if (_fingersR[i] != null)
				{
					_fingerRestR[i] = _fingersR[i].localRotation;
				}
			}
			if (_thumbL != null)
			{
				_thumbRestL = _thumbL.localRotation;
			}
			if (_thumbR != null)
			{
				_thumbRestR = _thumbR.localRotation;
			}
			float modelY = model.position.y;
			if (_upperR != null)
			{
				_shoulderAboveModel = _upperR.position.y - modelY;
			}
			if (_head != null)
			{
				_headAboveModel = _head.position.y - modelY;
			}
			if (_upperR != null && _lowerR != null && _handR != null)
			{
				_armLength = Vector3.Distance(_upperR.position, _lowerR.position) + Vector3.Distance(_lowerR.position, _handR.position);
			}
			if (_handR != null && _fingersR[0] != null)
			{
				float knuckle = ((_fingersR[2] != null) ? (Vector3.Distance(_fingersR[0].position, _fingersR[2].position) * 0.35f) : 0.03f);
				_fistFront = knuckle + Vector3.Distance(_handR.position, _fingersR[0].position);
			}
		}

		private void CaptureArm(Transform upper, Transform lower, Transform hand, Vector3 inward, out Quaternion upperOff, out Quaternion lowerOff, out Quaternion handOff)
		{
			upperOff = (lowerOff = (handOff = Quaternion.identity));
			if (upper == null || lower == null || hand == null)
			{
				return;
			}
			Vector3 shoulder = upper.position;
			Vector3 elbow = lower.position;
			Vector3 wrist = hand.position;
			Vector3 limb = wrist - shoulder;
			Vector3 toElbow = elbow - shoulder;
			Vector3 bend = toElbow - Vector3.Project(toElbow, limb);
			if (bend.sqrMagnitude < 1E-10f)
			{
				bend = -transform.forward;
			}
			Vector3 pole = bend.normalized;
			upperOff = Quaternion.Inverse(Frame(toElbow.normalized, pole)) * upper.rotation;
			lowerOff = Quaternion.Inverse(Frame((wrist - elbow).normalized, pole)) * lower.rotation;
			handOff = Quaternion.Inverse(Frame(hand.up, inward)) * hand.rotation;
		}

		private static Quaternion Frame(Vector3 along, Vector3 normal)
		{
			Vector3 up = normal - along * Vector3.Dot(along, normal);
			if (up.sqrMagnitude < 1E-08f)
			{
				up = ((Mathf.Abs(along.y) < 0.9f) ? Vector3.up : Vector3.forward);
			}
			return Quaternion.LookRotation(along, up);
		}

		private void ApplyBody(in Posture p)
		{
			model.localPosition = new Vector3(p.Sway, p.Height, p.Surge);
			if (_neck != null)
			{
				_neck.rotation = transform.rotation * Quaternion.Euler(p.Pitch, p.Yaw, p.Roll) * _neckRest;
			}
		}

		private void ApplyHead(in FnPuppetInput input, in Posture p)
		{
			Quaternion root = transform.rotation;
			Quaternion head = Quaternion.Euler(0f - (input.HeadPitch + p.HeadPitch), input.HeadYaw + p.HeadYaw, p.HeadRoll);
			Quaternion body = Quaternion.Euler(p.Pitch, p.Yaw, p.Roll);
			if (_neckJoint != null)
			{
				_neckJoint.rotation = root * Quaternion.Slerp(body, head, NeckShare) * _neckJointRest;
			}
			if (_head != null)
			{
				_head.rotation = root * head * _headRest;
			}
		}

		private void ApplyEyes(in FnPuppetInput input)
		{
			bool has = Staring || input.HasLook;
			Vector3 look = (Staring ? _lens : input.LookPoint);
			AimEye(_eyeL, _eyeRestL, look, has);
			AimEye(_eyeR, _eyeRestR, look, has);
		}

		private void AimEye(Transform eye, Quaternion restLocal, Vector3 look, bool has)
		{
			if (eye == null)
			{
				return;
			}
			Quaternion rest = eye.parent.rotation * restLocal;
			Vector3 to = look - eye.position;
			if (!has || to.sqrMagnitude < 1E-06f)
			{
				eye.rotation = rest;
				return;
			}
			Quaternion.FromToRotation(rest * Vector3.up, to).ToAngleAxis(out var angle, out var axis);
			if (angle > 180f)
			{
				angle -= 360f;
			}
			eye.rotation = Quaternion.AngleAxis(Mathf.Clamp(angle, 0f - style.eyeRange, style.eyeRange), axis) * rest;
		}

		private void SolveArms()
		{
			SolveArm(_upperL, _lowerL, _handL, _upperOffL, _lowerOffL, _left.Target, _left.Pole);
			SolveArm(_upperR, _lowerR, _handR, _upperOffR, _lowerOffR, _right.Target, _right.Pole);
			if (_handL != null)
			{
				_handL.rotation = Frame(_left.Along, _left.Palm) * _handOffL;
			}
			if (_handR != null)
			{
				_handR.rotation = Frame(_right.Along, _right.Palm) * _handOffR;
			}
			Curl(_fingersL, _fingerRestL, _thumbL, _thumbRestL, _left.Curl);
			Curl(_fingersR, _fingerRestR, _thumbR, _thumbRestR, _right.Curl);
		}

		private static void SolveArm(Transform upper, Transform lower, Transform hand, Quaternion upperOff, Quaternion lowerOff, Vector3 target, Vector3 pole)
		{
			if (upper == null || lower == null || hand == null)
			{
				return;
			}
			Vector3 position = upper.position;
			Vector3 toTarget = target - position;
			float dist = toTarget.magnitude;
			if (dist < 0.0001f)
			{
				return;
			}
			float upperLen = Vector3.Distance(position, lower.position);
			if (upperLen < 0.0001f)
			{
				return;
			}
			float lowerLen = Vector3.Distance(lower.position, hand.position);
			if (lowerLen < 0.0001f)
			{
				return;
			}
			float reach = Mathf.Clamp(dist, Mathf.Abs(upperLen - lowerLen) + 0.001f, (upperLen + lowerLen) * 0.999f);
			Vector3 dir = toTarget / dist;
			float cos = Mathf.Clamp((upperLen * upperLen + reach * reach - lowerLen * lowerLen) / (2f * upperLen * reach), -1f, 1f);
			Vector3 bend = pole - dir * Vector3.Dot(pole, dir);
			if (bend.sqrMagnitude < 1E-08f)
			{
				bend = Vector3.Cross(dir, Vector3.right);
			}
			float sin = Mathf.Sqrt(1f - cos * cos);
			Vector3 normal = bend.normalized;
			Vector3 elbow = position + dir * (upperLen * cos) + normal * (upperLen * sin);
			upper.rotation = Frame((elbow - position).normalized, normal) * upperOff;
			lower.rotation = Frame((position + dir * reach - elbow).normalized, normal) * lowerOff;
		}

		private static void Curl(Transform[] fingers, Quaternion[] rest, Transform thumb, Quaternion thumbRest, float curl)
		{
			for (int i = 0; i < fingers.Length; i++)
			{
				if (!(fingers[i] == null))
				{
					fingers[i].localRotation = rest[i] * Quaternion.Euler((i % 3 == 0) ? curl : (curl * 0.8f), 0f, 0f);
				}
			}
			if (thumb != null)
			{
				thumb.localRotation = thumbRest * Quaternion.Euler(curl * 0.35f, 0f, 0f);
			}
		}

		private bool FeedSees(out Vector3 lens, out float closeness)
		{
			lens = default(Vector3);
			closeness = 0f;
			FnCameraSystem instance = FnCameraSystem.Instance;
			if (instance == null || instance.Mode != FnCameraSystem.FeedMode.Live)
			{
				return false;
			}
			if (!FnStations.TryGet(instance.ShownStation, out var station) || station.AudioOnly)
			{
				return false;
			}
			Vector3 vector = ((_head != null) ? _head.position : (base.transform.position + Vector3.up * 1.5f));
			Vector3 vector2 = vector - station.Pose.position;
			float magnitude = vector2.magnitude;
			if (magnitude < 0.05f || magnitude > station.Range)
			{
				return false;
			}
			Vector3 vector3 = station.Pose.InverseTransformDirection(vector2 / magnitude);
			if (vector3.z <= 0.05f)
			{
				return false;
			}
			float num = station.VerticalFov * 0.5f * Mathf.Deg2Rad;
			if (Mathf.Abs(Mathf.Atan2(vector3.y, vector3.z)) > num + 0.05f)
			{
				return false;
			}
			float num2 = Mathf.Atan(Mathf.Tan(num) * Mathf.Max(station.Aspect, 0.5f));
			if (Mathf.Abs(Mathf.Atan2(vector3.x, vector3.z)) > num2 + 0.05f)
			{
				return false;
			}
			lens = station.Pose.position;
			closeness = Mathf.Clamp01(1f - magnitude / Mathf.Max(style.lensLeanWithin, 0.5f));
			return true;
		}

		private void Awake()
		{
			EnsureInit();
		}

		public override void EnsureInit()
		{
			if (!_init && !(model == null))
			{
				_init = true;
				RestoreRest();
				BindRig();
				CaptureRig();
				Snap();
			}
		}

		public override void Snap()
		{
			if (_init)
			{
				ResetFeel();
				SnapHands();
				_doorLatched = false;
				_rapLurch = 0f;
				_watchFor = 0f;
				_unwatchedFor = 10f;
				_stareTilt = 0f;
			}
		}

		public override void Drive(in FnPuppetInput input)
		{
			EnsureInit();
			if (!_init)
			{
				return;
			}
			_dt = Mathf.Min(input.Dt, 0.1f);
			_now = Time.time;
			UpdateWatch(_dt);
			if (input.Frozen)
			{
				ApplyEyes(in input);
				return;
			}
			_activity = Pick(in input);
			Posture p = BasePosture(in input);
			StepFeel(in input, ref p);
			ApplyBody(in p);
			UpdateHands(in input, in p);
			ClampHandsToDoor();
			ApplyHead(in input, in p);
			SolveArms();
			ApplyEyes(in input);
			UpdateProp(in input);
		}

		private Activity Pick(in FnPuppetInput input)
		{
			if (input.PoweredDown || input.Droop > 0.5f)
			{
				return Activity.Slump;
			}
			if (input.Lunging || input.Lunge > 0.3f || input.State == FnAiState.DoorEnter || input.State == FnAiState.Attack)
			{
				return Activity.Lunge;
			}
			if (input.JumpCharge || input.Airborne || input.LandAge < 0.45f)
			{
				return Activity.Jump;
			}
			if (input.Speed > 0.2f)
			{
				return Activity.Walk;
			}
			switch (input.State)
			{
			case FnAiState.Dormant:
				if (input.Home)
				{
					return Activity.Perform;
				}
				return Activity.Stand;
			case FnAiState.Search:
				return Activity.Search;
			case FnAiState.DoorWait:
				return Activity.Peek;
			case FnAiState.DoorBang:
				return Activity.Bang;
			case FnAiState.Blackout:
				if (input.Music)
				{
					return Activity.MusicBox;
				}
				return Activity.Stand;
			default:
				return Activity.Stand;
			}
		}

		private void UpdateWatch(float dt)
		{
			if (FeedSees(out var lens, out var closeness))
			{
				_watched = true;
				_lens = lens;
				_lensCloseness = closeness;
				_watchFor += dt;
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
			float target = 0f;
			if (Staring)
			{
				target = style.stareTilt * Mathf.Clamp01((_watchFor - style.stareDelay) / 3f);
			}
			_stareTilt = Mathf.MoveTowards(_stareTilt, target, (Staring ? 6f : 30f) * dt);
		}
	}
}
