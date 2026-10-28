using System;
using UnityEngine;
using UnityEngine.Audio;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnAnimatronic : MonoBehaviour
	{
		private const float ServoAudible = 12f;

		private const float BreathAudible = 9f;

		private const float MusicAudible = 32f;

		private const float FootstepAudible = 18f;

		private const float JumpAudible = 20f;

		private const float LandAudible = 24f;

		private FnAudioGate _servoGate;

		private const float ServoHangSeconds = 0.4f;

		private const float JerkSoundGap = 0.6f;

		private float _servoStill;

		private FnAudioGate _breathGate;

		private AudioSource _musicSource;

		private FnAudioGate _musicGate;

		private bool _musicPlaying;

		private const float BangSeconds = 0.32f;

		private const float DroopPitch = 28f;

		private const float NeckShare = 0.35f;

		private const int NoProperty = -1;

		private static readonly int UnlitColorId = Shader.PropertyToID("_Color");

		private static readonly int UnlitBaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int GlowColorId = Shader.PropertyToID("_GlowColor");

		private Renderer[] _glows;

		private Color _glowColor;

		private Transform _frame;

		private Vector3 _bodyRestPosition;

		private Quaternion _bodyRestRotation = Quaternion.identity;

		private Quaternion _headRest;

		private Quaternion _neckRest;

		private Quaternion _jawRest;

		private Quaternion _leftArmRest;

		private Quaternion _rightArmRest;

		private Quaternion _leftLegRest;

		private Quaternion _rightLegRest;

		private float _servoYaw;

		private float _servoPitch;

		private bool _servoActive;

		private float _servoReadyAt;

		private float _nextJerkSound;

		private float _lunge;

		private float _leapArms;

		private float _droop;

		private float _legAngle;

		private float _armAngle;

		private float _bob;

		private float _lean;

		private float _roll;

		private float _bangAt = -10f;

		private bool _bangHeavy;

		private float _laughUntil;

		private float _stareStart;

		private float _stareUntil;

		private float _shriekUntil;

		private MaterialPropertyBlock _eyeBlock;

		private int _eyeProperty = -1;

		private float _eye;

		private float _appliedEye = -1f;

		[Header("Variants")]
		public FnPuppetBase defaultVariant;

		public FnPuppetBase nightmareVariant;

		private const byte NoDifficulty = 255;

		private const float DoorRange = 2.5f;

		private FnPuppetBase _puppet;

		private float _nextPlantSound;

		private byte _shownDifficulty = 255;

		private int _bangCount;

		private int _bangRaps = 1;

		private Action<Vector3, float> _onPlant;

		private float _jumpFloorY;

		private bool _jumpCharging;

		private bool _jumpAirborne;

		private float _jumpChargeAt = -10f;

		private float _jumpLandAt = -10f;

		private float _jumpImpact;

		private float _jumpLastVy;

		public const int InterpolationDelayMs = 100;

		private const int StreamLiveMs = 400;

		private const int CorrectionGlideMs = 200;

		private const int ReliableFresherMs = 250;

		private readonly FnPoseRing _ring = new FnPoseRing();

		private bool _hasReliable;

		private FnAiState _reliableState;

		private int _reliableArg;

		private int _reliableAt;

		[Tooltip("Which animatronic this is (contract section 8). Must match its slot in FnAiDirector.animatronics.")]
		public FnAnim id;

		[Header("Rig (bones must be descendants of Body, or of this transform when Body is empty)")]
		[Tooltip("Takes the bob, sway and lean. Empty = applied to this transform.")]
		public Transform body;

		public Transform head;

		public Transform neck;

		public Transform jaw;

		[Tooltip("Upper arms and thighs, in a hanging (A or down) rest pose. They swing about the body's right axis.")]
		public Transform leftArm;

		public Transform rightArm;

		public Transform leftLeg;

		public Transform rightLeg;

		[Header("Body")]
		[Tooltip("Eye point in this transform's space: sight rays, hearing and the published head position start here.")]
		public Vector3 eyeLocalOffset = new Vector3(0f, 1.85f, 0.12f);

		[Tooltip("Metres per full stride cycle (two footfalls).")]
		public float strideLength = 1.5f;

		[Tooltip("Body turn rate (degrees per second). Low reads heavy.")]
		public float turnSpeed = 200f;

		[Tooltip("Speed change per second (m/s^2).")]
		public float acceleration = 5f;

		[Header("Procedural motion")]
		public float legSwing = 24f;

		public float armSwing = 16f;

		public float bobHeight = 0.05f;

		public float swayDegrees = 3f;

		[Tooltip("0 = smooth swings, 1 = fully stepped (servo ticks).")]
		[Range(0f, 1f)]
		public float hitch = 0.65f;

		[Tooltip("Arm raise while lunging (degrees forward).")]
		public float lungeArmRaise = 95f;

		public float lungeLean = 14f;

		[Tooltip("Arm strike on a door bang (degrees forward).")]
		public float bangStrike = 70f;

		public float jawOpenMax = 32f;

		[Tooltip("Head servo: error in degrees before it snaps to the target.")]
		public float servoDeadband = 5f;

		[Tooltip("Head servo snap speed (degrees per second).")]
		public float servoSpeed = 720f;

		[Tooltip("Head servo hold between snaps (seconds, random in range).")]
		public Vector2 servoHold = new Vector2(0.08f, 0.3f);

		[Header("Eyes")]
		[Tooltip("Eye renderers. Their material must already have emission enabled (MaterialPropertyBlock can't set keywords).")]
		public Renderer[] eyes = new Renderer[0];

		public string eyeColorProperty = "_EmissionColor";

		[ColorUsage(false, true)]
		public Color eyeColor = new Color(2f, 1.7f, 1.2f);

		[Tooltip("Fade out when powering down at 6 AM (seconds).")]
		public float eyeFadeSeconds = 1.5f;

		[Tooltip("Optional point light for the eyes. Off on Quest unless eyeLightOnQuest (a pixel light per animatronic is too costly).")]
		public Light eyeLight;

		public bool eyeLightOnQuest;

		public float eyeLightIntensity = 0.6f;

		[Header("Audio")]
		[Tooltip("Servo whine loop (an FnAudioGate is added when missing). Created at runtime when empty.")]
		public AudioSource servoSource;

		[Tooltip("Breathing loop at an open door (DoorWait). Created at runtime when empty.")]
		public AudioSource breathSource;

		[Tooltip("Mixer group for the loops created at runtime (the game's SFX group).")]
		public AudioMixerGroup loopOutput;

		[Range(0f, 1f)]
		public float footstepVolume = 0.8f;

		private bool _init;

		private Transform _homeParent;

		private Vector3 _homeLocalPosition;

		private Quaternion _homeLocalRotation = Quaternion.identity;

		private FnPoseSample _rendered;

		private Vector3 _renderedVelocity;

		private int _renderedTarget;

		private bool _hasPose;

		internal FnSpecimenTube Tank { get; set; }

		public FnPuppetBase ActivePuppet => _puppet;

		public bool ExternallyPosed { get; set; }

		public FnPoseSample Rendered => _rendered;

		public Vector3 RenderedVelocity => _renderedVelocity;

		public int RenderedTarget => _renderedTarget;

		public bool HasPose => _hasPose;

		public Vector3 EyePosition => EyeAt(_rendered.Position, _rendered.Yaw);

		public Vector3 LookForward => FnAiRules.LookDirection(_rendered.Yaw, _servoYaw, _servoPitch);

		public Vector3 HomePosition => (_homeParent != null) ? _homeParent.TransformPoint(_homeLocalPosition) : _homeLocalPosition;

		public float HomeYaw => ((_homeParent != null) ? (_homeParent.rotation * _homeLocalRotation) : _homeLocalRotation).eulerAngles.y;

		public static event Action<FnAnim, FnCue> CuePlayed;

		private void InitAudio()
		{
			_servoGate = PrepareLoop(ref servoSource, "ServoLoop", ServoAudible, 0.35f);
			_breathGate = PrepareLoop(ref breathSource, "BreathLoop", BreathAudible, 0.8f);
		}

		private FnAudioGate PrepareLoop(ref AudioSource source, string label, float audible, float volume)
		{
			if (source == null)
			{
				GameObject go = new GameObject(label);
				go.transform.SetParent(base.transform, false);
				go.transform.localPosition = eyeLocalOffset;
				source = go.AddComponent<AudioSource>();
				source.volume = volume;
				source.spatialBlend = 1f;
				source.rolloffMode = AudioRolloffMode.Linear;
				source.minDistance = 1f;
				source.maxDistance = audible + 2f;
				source.dopplerLevel = 0f;
				if (loopOutput != null)
				{
					source.outputAudioMixerGroup = loopOutput;
				}
			}
			source.playOnAwake = false;
			source.loop = true;
			source.spatialize = false;
			FnAudioGate gate = source.GetComponent<FnAudioGate>();
			if (gate == null)
			{
				gate = source.gameObject.AddComponent<FnAudioGate>();
				gate.audibleWithin = audible;
			}
			gate.wantedOnStart = false;
			gate.Wanted = false;
			return gate;
		}

		private void UpdateAudio(in FnPoseSample pose, FnAiState cueState, float previousGait)
		{
			FnAudioBank audio = FnGame.Audio;
			if (_servoGate != null && servoSource != null)
			{
				if (servoSource.clip == null && audio != null)
				{
					servoSource.clip = audio.servoLoop;
				}
				bool halted = pose.Has(FnPoseCodec.FlagFrozen | FnPoseCodec.FlagPoweredDown);
				if (!halted && pose.Speed > (_servoGate.Wanted ? 0.08f : 0.2f))
				{
					_servoStill = 0f;
					_servoGate.Wanted = true;
				}
				else
				{
					_servoStill += Time.deltaTime;
					_servoGate.Wanted = !halted && _servoStill < ServoHangSeconds && _servoGate.Wanted;
				}
				servoSource.pitch = 0.85f + Mathf.Clamp01(pose.Speed * 0.25f) * 0.3f;
			}
			if (_breathGate != null && breathSource != null)
			{
				if (breathSource.clip == null && audio != null)
				{
					breathSource.clip = audio.breathingLoop;
				}
				_breathGate.Wanted = !pose.Has(FnPoseCodec.FlagPoweredDown) && cueState == FnAiState.DoorWait;
			}
			if (_musicPlaying && (pose.Has(FnPoseCodec.FlagPoweredDown) || !NightRunning()))
			{
				StopMusic();
			}
			if (audio == null || pose.Has(FnPoseCodec.FlagFrozen | FnPoseCodec.FlagPoweredDown) || pose.Speed < 0.3f || (_puppet != null && _puppet.RaisesPlants) || (!Crossed(previousGait, pose.Gait, 0.25f) && !Crossed(previousGait, pose.Gait, 0.75f)) || !NearLocalHead(pose.Position, FootstepAudible))
			{
				return;
			}
			bool footsteps = _puppet == null || !_puppet.Crawls || audio.crawlDrag.Length == 0;
			if (!(Time.time < _nextPlantSound))
			{
				_nextPlantSound = Time.time + (footsteps ? 0.12f : 0.45f);
				float volume = footstepVolume * (0.5f + Mathf.Clamp01(pose.Speed * 0.25f) * 0.5f);
				FnAudio.Play(FnAudioBank.Pick(footsteps ? audio.footsteps : audio.crawlDrag), pose.Position, volume, 1f, FootstepAudible, UnityEngine.Random.Range(0.93f, 1.05f));
			}
		}

		private static bool Crossed(float from, float to, float mark)
		{
			float span = Mathf.Repeat(to - from, 1f);
			if (span <= 0f || span > 0.5f)
			{
				return false;
			}
			float at = Mathf.Repeat(mark - from, 1f);
			return at > 0f && at <= span;
		}

		private static bool NightRunning()
		{
			FnNight instance = FnNight.Instance;
			return instance != null && instance.Active && instance.Phase == FnPhase.Night;
		}

		private void PlayServoJerk()
		{
			if (!(Time.time < _nextJerkSound))
			{
				_nextJerkSound = Time.time + JerkSoundGap;
				FnAudioBank audio = FnGame.Audio;
				Vector3 eye = EyeAt(_rendered.Position, _rendered.Yaw);
				if (!(audio == null) && NearLocalHead(eye, ServoAudible))
				{
					FnAudio.Play(FnAudioBank.Pick(audio.servoJerk), eye, 0.5f, 1f, ServoAudible, UnityEngine.Random.Range(0.95f, 1.08f));
				}
			}
		}

		private void PlayJumpCharge()
		{
			FnAudioBank audio = FnGame.Audio;
			Vector3 at = _rendered.Position + Vector3.up;
			if (!(audio == null) && NearLocalHead(at, JumpAudible))
			{
				FnAudio.Play(audio.jumpCharge, at, 0.9f, 1f, JumpAudible, UnityEngine.Random.Range(0.97f, 1.03f));
			}
		}

		private void PlayJumpLaunch()
		{
			FnAudioBank audio = FnGame.Audio;
			Vector3 at = _rendered.Position + Vector3.up * 0.5f;
			if (!(audio == null) && NearLocalHead(at, JumpAudible))
			{
				FnAudio.Play(FnAudioBank.Pick(audio.jumpLaunch), at, 1f, 1f, JumpAudible, UnityEngine.Random.Range(0.95f, 1.05f));
			}
		}

		private void PlayJumpLand(float impact)
		{
			FnAudioBank audio = FnGame.Audio;
			Vector3 at = _rendered.Position + Vector3.up * 0.3f;
			if (!(audio == null) && NearLocalHead(at, LandAudible))
			{
				FnAudio.Play(FnAudioBank.Pick(audio.jumpLand), at, 0.55f + Mathf.Clamp01(impact) * 0.45f, 1f, LandAudible, UnityEngine.Random.Range(0.94f, 1.04f));
			}
		}

		private void PlayPowerDown()
		{
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				FnAudio.Play(audio.powerDown, EyeAt(_rendered.Position, _rendered.Yaw), 0.9f, 1f, 20f, 1f);
			}
			StopMusic();
		}

		private void PlayCueAudio(FnCue cue)
		{
			FnAudioBank audio = FnGame.Audio;
			Vector3 eye = EyeAt(_rendered.Position, _rendered.Yaw);
			float time = Time.time;
			switch (cue)
			{
			case FnCue.Laugh:
				_laughUntil = time + 1.4f;
				if (audio != null)
				{
					FnAudio.Play(FnAudioBank.Pick(audio.bearLaugh), eye, 1f, 1f, 26f, 1f);
				}
				break;
			case FnCue.KitchenClatter:
			{
				if (audio == null)
				{
					break;
				}
				AudioClip clip = FnAudioBank.Pick(audio.kitchenClatter);
				Vector3 at = _rendered.Position + Vector3.up;
				FnAudio.Play(clip, at, 0.9f, 1f, 20f, UnityEngine.Random.Range(0.95f, 1.05f));
				FnCameraSystem.RelayToMonitor(clip, at);
				break;
			}
			case FnCue.MusicBoxStart:
				StartMusic((audio != null) ? audio.musicBox : null);
				break;
			case FnCue.MusicBoxStop:
				StopMusic();
				break;
			case FnCue.Stare:
				_stareStart = time;
				_stareUntil = time + 2f;
				if (audio != null)
				{
					FnAudio.Play(audio.stare, eye, 1f, 1f, 16f, 1f);
				}
				break;
			case FnCue.EndoShriek:
				_shriekUntil = time + 0.9f;
				if (audio != null)
				{
					FnAudio.Play(audio.endoShriek, eye, 1f, 1f, 30f, 1f);
				}
				break;
			}
		}

		private void StartMusic(AudioClip clip)
		{
			AudioSource source = null;
			if (!(clip == null))
			{
				if (_musicSource == null)
				{
					_musicGate = PrepareLoop(ref source, "MusicBox", MusicAudible, 0.9f);
					_musicGate.randomStart = false;
					_musicSource = source;
				}
				_musicSource.clip = clip;
				_musicGate.Wanted = true;
				_musicPlaying = true;
			}
		}

		private void StopMusic()
		{
			_musicPlaying = false;
			if (_musicGate != null)
			{
				_musicGate.Wanted = false;
			}
			if (_musicSource != null && _musicSource.isPlaying)
			{
				_musicSource.Stop();
			}
		}

		private void CaptureRest()
		{
			_frame = ((body != null) ? body : base.transform);
			if (body != null)
			{
				_bodyRestPosition = body.localPosition;
				_bodyRestRotation = body.localRotation;
			}
			_headRest = RestOf(ref head);
			_neckRest = RestOf(ref neck);
			_jawRest = RestOf(ref jaw);
			_leftArmRest = RestOf(ref leftArm);
			_rightArmRest = RestOf(ref rightArm);
			_leftLegRest = RestOf(ref leftLeg);
			_rightLegRest = RestOf(ref rightLeg);
		}

		private Quaternion RestOf(ref Transform bone)
		{
			if (bone == null)
			{
				return Quaternion.identity;
			}
			if (bone == _frame || !bone.IsChildOf(_frame))
			{
				Debug.LogWarning("[FnAnimatronic] " + base.name + ": '" + bone.name + "' is not under '" + _frame.name + "'; it won't be animated.", this);
				bone = null;
				return Quaternion.identity;
			}
			Quaternion rest = Quaternion.identity;
			Transform t = bone;
			while (t != null && t != _frame)
			{
				rest = t.localRotation * rest;
				t = t.parent;
			}
			return rest;
		}

		internal void Knock(FnDoorSide side, int raps, bool heavy)
		{
			_bangAt = Time.time;
			_bangHeavy = heavy;
			_bangRaps = Mathf.Max(1, raps);
			_bangCount++;
		}

		private float Hitch(float x)
		{
			return Mathf.Lerp(x, Mathf.Round(x * 4f) / 4f, hitch);
		}

		private void ApplyMotion(in FnPoseSample pose, float dt)
		{
			Quaternion facing = Quaternion.Euler(0f, pose.Yaw, 0f);
			float time = Time.time;
			if (pose.Has(FnPoseCodec.FlagFrozen))
			{
				if (body != null)
				{
					base.transform.SetPositionAndRotation(pose.Position, facing);
				}
				else
				{
					base.transform.SetPositionAndRotation(pose.Position + Vector3.up * _bob, facing * Quaternion.Euler(_lean, 0f, _roll));
				}
				return;
			}
			bool poweredDown = pose.Has(FnPoseCodec.FlagPoweredDown);
			bool lunging = pose.Has(FnPoseCodec.FlagLunging);
			_droop = Mathf.MoveTowards(_droop, poweredDown ? 1f : 0f, dt / 1.2f);
			_lunge = Mathf.MoveTowards(_lunge, lunging ? 1f : 0f, (lunging ? 7f : 3f) * dt);
			_leapArms = Mathf.MoveTowards(_leapArms, _jumpAirborne ? 1f : 0f, 6f * dt);
			float stride = (poweredDown ? 0f : Mathf.Clamp(pose.Speed / 1.4f, 0f, 1.5f));
			float wave = Mathf.Sin(pose.Gait * Mathf.PI * 2f);
			float swing = Hitch(wave);
			if (!poweredDown)
			{
				_legAngle = legSwing * stride * swing;
				_armAngle = armSwing * stride * swing;
				_bob = bobHeight * stride * (Hitch(1f - Mathf.Abs(wave)) - 0.5f);
			}
			float bang = BangCurve(time);
			_roll = (poweredDown ? 0f : (swayDegrees * stride * swing * 0.5f));
			float sprint = (pose.Has(FnPoseCodec.FlagSprinting) ? (Mathf.Clamp01(pose.Speed / 3f) * 6f) : 0f);
			_lean = lungeLean * _lunge + sprint + _droop * 6f + bang * 5f;
			if (body != null)
			{
				base.transform.SetPositionAndRotation(pose.Position, facing);
				body.localPosition = _bodyRestPosition + Vector3.up * _bob;
				body.localRotation = _bodyRestRotation * Quaternion.Euler(_lean, 0f, _roll);
			}
			else
			{
				base.transform.SetPositionAndRotation(pose.Position + Vector3.up * _bob, facing * Quaternion.Euler(_lean, 0f, _roll));
			}
			StepServo(pose.HeadYaw, pose.HeadPitch - _droop * DroopPitch, dt, poweredDown);
			float shake = 0f;
			if (time < _shriekUntil)
			{
				shake = Mathf.Sin(time * Mathf.PI * 14f) * 7f;
			}
			Quaternion frame = _frame.rotation;
			Quaternion look = Quaternion.Euler(0f - _servoPitch, _servoYaw + shake, 0f);
			if (neck != null)
			{
				neck.rotation = frame * Quaternion.Euler((0f - _servoPitch) * NeckShare, (_servoYaw + shake) * NeckShare, 0f) * _neckRest;
			}
			if (head != null)
			{
				head.rotation = frame * look * _headRest;
			}
			if (jaw != null)
			{
				jaw.rotation = frame * look * Quaternion.AngleAxis(JawOpen(in pose, time), Vector3.right) * _jawRest;
			}
			float lift = Mathf.Max(_lunge, _leapArms);
			float raise = lungeArmRaise * lift;
			float sway = 1f - lift;
			float strike = bang * bangStrike;
			SetLimb(leftLeg, _leftLegRest, frame, _legAngle);
			SetLimb(rightLeg, _rightLegRest, frame, 0f - _legAngle);
			SetLimb(leftArm, _leftArmRest, frame, raise - sway * _armAngle + (_bangHeavy ? strike : 0f));
			SetLimb(rightArm, _rightArmRest, frame, raise + sway * _armAngle + strike);
		}

		private static void SetLimb(Transform bone, Quaternion rest, Quaternion frame, float forwardDegrees)
		{
			if (!(bone == null))
			{
				bone.rotation = frame * Quaternion.AngleAxis(0f - forwardDegrees, Vector3.right) * rest;
			}
		}

		private float BangCurve(float now)
		{
			float t = (now - _bangAt) / BangSeconds;
			if (t < 0f || t > 1f)
			{
				return 0f;
			}
			return Mathf.Sin(t * Mathf.PI);
		}

		private float JawOpen(in FnPoseSample pose, float now)
		{
			float open = jawOpenMax * _lunge;
			if (now < _shriekUntil)
			{
				open = Mathf.Max(open, jawOpenMax);
			}
			if (now < _laughUntil)
			{
				open = Mathf.Max(open, jawOpenMax * ((Mathf.Repeat(now * 5f, 1f) < 0.5f) ? 0.45f : 0.1f));
			}
			if (now < _stareUntil)
			{
				open = Mathf.Max(open, jawOpenMax * 0.35f * Mathf.Clamp01((now - _stareStart) / Mathf.Max(0.1f, _stareUntil - _stareStart)));
			}
			if (pose.Speed > 0.3f && !pose.Has(FnPoseCodec.FlagPoweredDown))
			{
				open = Mathf.Max(open, jawOpenMax * 0.06f * Mathf.Abs(Mathf.Sin(pose.Gait * Mathf.PI * 4f)));
			}
			return Mathf.Max(open, jawOpenMax * 0.15f * _droop);
		}

		private void StepServo(float targetYaw, float targetPitch, float dt, bool drift)
		{
			if (drift)
			{
				float maxDelta = dt * 40f;
				_servoYaw = Mathf.MoveTowardsAngle(_servoYaw, targetYaw, maxDelta);
				_servoPitch = Mathf.MoveTowards(_servoPitch, targetPitch, maxDelta);
				_servoActive = false;
				return;
			}
			float yawError = Mathf.DeltaAngle(_servoYaw, targetYaw);
			if (!_servoActive)
			{
				if (Time.time < _servoReadyAt)
				{
					return;
				}
				float pitchError = Mathf.Abs(targetPitch - _servoPitch);
				if (Mathf.Abs(yawError) < servoDeadband && pitchError < servoDeadband)
				{
					return;
				}
				_servoActive = true;
				if (Mathf.Abs(yawError) + pitchError > 18f)
				{
					PlayServoJerk();
				}
			}
			float step = servoSpeed * dt;
			_servoYaw = Mathf.MoveTowardsAngle(_servoYaw, targetYaw, step);
			_servoPitch = Mathf.MoveTowards(_servoPitch, targetPitch, step);
			if (Mathf.Abs(Mathf.DeltaAngle(_servoYaw, targetYaw)) <= 0.5f && Mathf.Abs(targetPitch - _servoPitch) <= 0.5f)
			{
				_servoActive = false;
				_servoReadyAt = Time.time + UnityEngine.Random.Range(Mathf.Min(servoHold.x, servoHold.y), Mathf.Max(servoHold.x, servoHold.y));
			}
		}

		private void InitEyes()
		{
			_eyeBlock = new MaterialPropertyBlock();
			_eyeProperty = (string.IsNullOrEmpty(eyeColorProperty) ? NoProperty : Shader.PropertyToID(eyeColorProperty));
			_eye = 0f;
			_appliedEye = -1f;
			ApplyEyes();
		}

		private void UpdateEyes(in FnPoseSample pose, float dt)
		{
			float target = 0f;
			if (pose.Has(FnPoseCodec.FlagEyesLit) && !pose.Has(FnPoseCodec.FlagPoweredDown))
			{
				target = ((pose.State == FnAiState.Chase || pose.Has(FnPoseCodec.FlagLunging)) ? 1.35f : 1f);
				if (Time.time < _stareUntil)
				{
					target = 1.8f;
				}
				if (_musicPlaying)
				{
					target *= 0.55f + 0.45f * (0.5f + 0.5f * Mathf.Sin(Time.time * Mathf.PI * 1.5f));
				}
			}
			float rate = ((target > _eye) ? 5f : (1f / Mathf.Max(0.05f, eyeFadeSeconds)));
			_eye = Mathf.MoveTowards(_eye, target, rate * dt);
			ApplyEyes();
		}

		private void ApplyEyes()
		{
			if (Mathf.Abs(_eye - _appliedEye) < 0.004f)
			{
				return;
			}
			_appliedEye = _eye;
			if (_eyeProperty != NoProperty && eyes != null)
			{
				Color color = new Color(eyeColor.r * _eye, eyeColor.g * _eye, eyeColor.b * _eye, 1f);
				for (int i = 0; i < eyes.Length; i++)
				{
					Renderer renderer = eyes[i];
					if (!(renderer == null))
					{
						renderer.GetPropertyBlock(_eyeBlock);
						_eyeBlock.SetColor(_eyeProperty, color);
						if (_eyeProperty == UnlitColorId)
						{
							_eyeBlock.SetColor(UnlitBaseColorId, color);
						}
						renderer.SetPropertyBlock(_eyeBlock);
					}
				}
			}
			if (_glows != null && _glows.Length != 0)
			{
				Color glow = new Color(_glowColor.r * _eye, _glowColor.g * _eye, _glowColor.b * _eye, 1f);
				for (int j = 0; j < _glows.Length; j++)
				{
					Renderer renderer2 = _glows[j];
					if (!(renderer2 == null))
					{
						renderer2.GetPropertyBlock(_eyeBlock);
						_eyeBlock.SetColor(GlowColorId, glow);
						renderer2.SetPropertyBlock(_eyeBlock);
					}
				}
			}
			if (!(eyeLight == null))
			{
				bool on = (eyeLightOnQuest || Application.platform != RuntimePlatform.Android) && _eye > 0.02f;
				if (eyeLight.enabled != on)
				{
					eyeLight.enabled = on;
				}
				if (on)
				{
					eyeLight.intensity = _eye * eyeLightIntensity;
				}
			}
		}

		private void SelectVariant()
		{
			if (defaultVariant == null && nightmareVariant == null)
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			FnDifficulty difficulty = ((instance != null && instance.InNightRoom) ? instance.Difficulty : FnDifficulty.Default);
			if (_shownDifficulty == (byte)difficulty)
			{
				return;
			}
			_shownDifficulty = (byte)difficulty;
			FnPuppetBase chosen = ((difficulty == FnDifficulty.Nightmare && nightmareVariant != null) ? nightmareVariant : ((defaultVariant != null) ? defaultVariant : nightmareVariant));
			if (defaultVariant != null && defaultVariant.gameObject.activeSelf != (chosen == defaultVariant))
			{
				defaultVariant.gameObject.SetActive(chosen == defaultVariant);
			}
			if (nightmareVariant != null && nightmareVariant.gameObject.activeSelf != (chosen == nightmareVariant))
			{
				nightmareVariant.gameObject.SetActive(chosen == nightmareVariant);
			}
			_puppet = chosen;
			_puppet.EnsureInit();
			if (_onPlant == null)
			{
				_onPlant = PlayPlant;
			}
			_puppet.OnPlant = _onPlant;
			_puppet.Snap();
			eyes = _puppet.eyeGlows;
			eyeColor = _puppet.eyeColor;
			_glows = _puppet.glowRenderers;
			_glowColor = _puppet.glowColor;
			_appliedEye = -1f;
			_eyeProperty = UnlitColorId;
			ApplyEyes();
		}

		private void ApplyPuppet(in FnPoseSample pose, Vector3 velocity, float dt)
		{
			float time = Time.time;
			base.transform.SetPositionAndRotation(pose.Position, Quaternion.Euler(0f, pose.Yaw, 0f));
			bool frozen = pose.Has(FnPoseCodec.FlagFrozen);
			bool poweredDown = pose.Has(FnPoseCodec.FlagPoweredDown);
			bool lunging = pose.Has(FnPoseCodec.FlagLunging);
			if (!frozen)
			{
				_droop = Mathf.MoveTowards(_droop, poweredDown ? 1f : 0f, dt / 1.2f);
				_lunge = Mathf.MoveTowards(_lunge, lunging ? 1f : 0f, (lunging ? 7f : 3f) * dt);
				float yaw = pose.HeadYaw;
				float pitch = pose.HeadPitch - _droop * DroopPitch;
				if (!pose.Has(FnPoseCodec.FlagPoweredDown | FnPoseCodec.FlagLunging) && _puppet.Staring)
				{
					FnAiRules.LookAngles(EyeAt(pose.Position, pose.Yaw), _puppet.LensPosition, pose.Yaw, 120f, 60f, out yaw, out pitch);
				}
				StepServo(yaw, pitch, _puppet.HeadServoScale * dt, poweredDown);
			}
			bool home = pose.State == FnAiState.Dormant && (pose.Position - HomePosition).sqrMagnitude < 0.36f;
			Vector3 lookPoint = Vector3.zero;
			bool hasLook = _renderedTarget > 0 && FnGame.TryGetHead(_renderedTarget, out lookPoint);
			Vector3 point = Vector3.zero;
			Vector3 normal = Vector3.zero;
			float halfWidth = 1f;
			bool hasDoor = AtDoorState(pose.State) && DoorNear(pose.Position, out point, out normal, out halfWidth);
			float bangAge = time - _bangAt;
			int bangCount = _bangCount;
			bool bangHeavy = _bangHeavy;
			float knockInterval = (_bangHeavy ? ((id == FnAnim.Endo) ? 0.34f : 0.62f) : (id switch
			{
				FnAnim.Bear => 0.27f,
				FnAnim.Bunny => 0.19f,
				FnAnim.Chicken => 0.23f,
				_ => 0.3f,
			}));
			int knockRaps = _bangRaps;
			bool inTank = false;
			Vector3 tankCentre = Vector3.zero;
			float tankRadius = 0f;
			if (Tank != null && Tank.Holds && pose.State != FnAiState.Dormant && !poweredDown)
			{
				Tank.GlassFace(out point, out normal, out halfWidth);
				Tank.Slam(out bangAge, out bangCount);
				tankCentre = Tank.transform.position;
				tankRadius = Tank.GlassRadiusWorld;
				knockInterval = 0.95f;
				knockRaps = 1;
				bangHeavy = true;
				hasDoor = true;
				inTank = true;
			}
			FnPuppetInput input = new FnPuppetInput
			{
				Speed = pose.Speed,
				Velocity = velocity,
				Gait = pose.Gait,
				StrideLength = strideLength,
				State = pose.State,
				Frozen = frozen,
				PoweredDown = poweredDown,
				Lunging = lunging,
				Home = home,
				HeadYaw = _servoYaw,
				HeadPitch = _servoPitch,
				HasLook = hasLook,
				LookPoint = lookPoint,
				Droop = _droop,
				Lunge = _lunge,
				BangAge = bangAge,
				BangCount = bangCount,
				BangHeavy = bangHeavy,
				KnockRaps = knockRaps,
				KnockInterval = knockInterval,
				HasDoor = hasDoor,
				DoorPoint = point,
				DoorNormal = normal,
				DoorHalfWidth = halfWidth,
				LaughLeft = Mathf.Max(0f, _laughUntil - time),
				StareLeft = Mathf.Max(0f, _stareUntil - time),
				ShriekLeft = Mathf.Max(0f, _shriekUntil - time),
				Music = _musicPlaying,
				JumpCharge = _jumpCharging,
				JumpChargeAge = time - _jumpChargeAt,
				Airborne = _jumpAirborne,
				Lift = (_jumpAirborne ? Mathf.Max(0f, pose.Position.y - _jumpFloorY) : 0f),
				VerticalSpeed = velocity.y,
				LandAge = time - _jumpLandAt,
				LandImpact = _jumpImpact,
				InTank = inTank,
				TankCentre = tankCentre,
				TankRadius = tankRadius,
				Dt = dt
			};
			_puppet.Drive(in input);
		}

		private void TrackJump(in FnPoseSample pose, Vector3 velocity, bool hadPose)
		{
			float time = Time.time;
			bool flag = pose.Has(FnPoseCodec.FlagJumpCharge);
			bool flag2 = pose.Has(FnPoseCodec.FlagAirborne);
			if (hadPose)
			{
				if (flag && !_jumpCharging)
				{
					_jumpChargeAt = time;
					PlayJumpCharge();
				}
				if (flag2 && !_jumpAirborne)
				{
					PlayJumpLaunch();
				}
				else if (!flag2 && _jumpAirborne)
				{
					_jumpLandAt = time;
					_jumpImpact = Mathf.Clamp01((-1.5f - _jumpLastVy) / 6f);
					PlayJumpLand(_jumpImpact);
				}
			}
			if (flag2)
			{
				_jumpLastVy = velocity.y;
			}
			else
			{
				_jumpFloorY = pose.Position.y;
			}
			_jumpCharging = flag;
			_jumpAirborne = flag2;
		}

		private void PlaceJump(in FnPoseSample pose)
		{
			_jumpFloorY = pose.Position.y;
			_jumpCharging = pose.Has(FnPoseCodec.FlagJumpCharge);
			_jumpChargeAt = -10f;
			_jumpLandAt = -10f;
			_jumpLastVy = 0f;
			_jumpAirborne = pose.Has(FnPoseCodec.FlagAirborne);
		}

		private static bool AtDoorState(FnAiState state)
		{
			if (state != FnAiState.ApproachOffice && state != FnAiState.DoorWait && state != FnAiState.DoorBang && state != FnAiState.DoorEnter)
			{
				return state == FnAiState.Blackout;
			}
			return true;
		}

		private static bool DoorNear(Vector3 feet, out Vector3 point, out Vector3 normal, out float halfWidth)
		{
			normal = Vector3.zero;
			point = Vector3.zero;
			halfWidth = 1f;
			FnOffice instance = FnOffice.Instance;
			if (instance == null || !instance.NearestDoor(feet, DoorRange, out var side))
			{
				return false;
			}
			halfWidth = instance.doorHalfWidth;
			return instance.DoorFace(side, out point, out normal);
		}

		private void PlayPlant(Vector3 at, float strength)
		{
			FnAudioBank audio = FnGame.Audio;
			if (!(audio == null) && NearLocalHead(at, FootstepAudible) && !(Time.time < _nextPlantSound))
			{
				_nextPlantSound = Time.time + 0.12f;
				AudioClip[] clips = ((_puppet != null && _puppet.Crawls && audio.crawlDrag.Length > 0) ? audio.crawlDrag : audio.footsteps);
				FnAudio.Play(FnAudioBank.Pick(clips), at, footstepVolume * Mathf.Lerp(0.35f, 1f, strength), 1f, FootstepAudible, UnityEngine.Random.Range(0.93f, 1.05f));
			}
		}

		internal void HoldStream(in FnPoseSample pose, int renderTs)
		{
			_ring.Hold(in pose, renderTs);
		}

		internal void ForgetReliable()
		{
			_hasReliable = false;
		}

		internal void PushSnapshot(int ts, in FnPoseSample pose, int sendIntervalMs)
		{
			_ring.Push(ts, in pose, sendIntervalMs, _hasPose, _rendered.Position);
		}

		internal bool SampleStream(int renderTs, out FnPoseSample pose, out Vector3 velocity)
		{
			return _ring.Sample(renderTs, out pose, out velocity);
		}

		internal void ReliableState(FnAiState state, int arg, Vector3 position, int nowTs)
		{
			_hasReliable = true;
			_reliableState = state;
			_reliableArg = arg;
			_reliableAt = nowTs;
			if (_hasPose && (position - _rendered.Position).sqrMagnitude > 9f)
			{
				FnPoseSample pose = _rendered;
				pose.Position = position;
				pose.State = state;
				pose.Speed = 0f;
				_ring.Hold(in pose, nowTs - InterpolationDelayMs);
			}
		}

		internal void CorrectFromSnapshot(Vector3 position, float yaw, FnAiState state, int nowTs)
		{
			if (_hasPose && (!_ring.TryNewest(out var ts) || nowTs - ts >= StreamLiveMs) && ((position - _rendered.Position).sqrMagnitude > 0.0009f || Mathf.Abs(Mathf.DeltaAngle(yaw, _rendered.Yaw)) > 2f))
			{
				FnPoseSample from = _rendered;
				from.Speed = 0f;
				FnPoseSample to = from;
				to.Position = position;
				to.Yaw = yaw;
				to.State = state;
				_ring.Glide(in from, in to, nowTs - InterpolationDelayMs, CorrectionGlideMs);
			}
		}

		internal FnAiState CueState(FnAiState streamed)
		{
			if (!_hasReliable)
			{
				return streamed;
			}
			if (_ring.TryNewest(out var ts) && _reliableAt - ts <= ReliableFresherMs)
			{
				return streamed;
			}
			return _reliableState;
		}

		internal int StreamTarget(FnAiState rendered)
		{
			if (!_hasReliable)
			{
				return 0;
			}
			FnAiState fnAiState = CueState(rendered);
			if ((fnAiState == FnAiState.Attack || fnAiState == FnAiState.Chase) && _reliableState == fnAiState)
			{
				return _reliableArg;
			}
			return 0;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			FnAnimatronic.CuePlayed = null;
		}

		public Vector3 EyeAt(Vector3 feet, float yaw)
		{
			return feet + Quaternion.Euler(0f, yaw, 0f) * eyeLocalOffset;
		}

		private void Awake()
		{
			EnsureInit();
		}

		public void EnsureInit()
		{
			if (!_init)
			{
				_init = true;
				_homeParent = base.transform.parent;
				_homeLocalPosition = base.transform.localPosition;
				_homeLocalRotation = base.transform.localRotation;
				CaptureRest();
				InitEyes();
				InitAudio();
				SelectVariant();
			}
		}

		private void OnDisable()
		{
			StopMusic();
			if (_servoGate != null)
			{
				_servoGate.Wanted = false;
			}
			if (_breathGate != null)
			{
				_breathGate.Wanted = false;
			}
			if (FnAnimView.Root(id) == base.transform)
			{
				FnAnimView.Clear(id);
			}
		}

		internal void Render(in FnPoseSample pose, Vector3 velocity, int target, FnAiState stateForCues, float dt)
		{
			EnsureInit();
			SelectVariant();
			bool hasPose = _hasPose;
			float previousGait = (hasPose ? _rendered.Gait : pose.Gait);
			FnAiState fnAiState = (hasPose ? _rendered.State : pose.State);
			_rendered = pose;
			_renderedVelocity = velocity;
			_renderedTarget = target;
			_hasPose = true;
			if (hasPose && fnAiState != FnAiState.PoweredDown && pose.State == FnAiState.PoweredDown)
			{
				PlayPowerDown();
			}
			TrackJump(in pose, velocity, hasPose);
			FnPoseSample pose2 = pose;
			if (target >= 1 && pose2.Has(FnPoseCodec.FlagLunging) && FnGame.TryGetHead(target, out var head))
			{
				FnAiRules.LookAngles(EyeAt(pose2.Position, pose2.Yaw), head, pose2.Yaw, 80f, 45f, out var yaw, out var pitch);
				pose2.HeadYaw = yaw;
				pose2.HeadPitch = pitch;
			}
			if (ExternallyPosed)
			{
				StepServo(pose2.HeadYaw, pose2.HeadPitch, dt, drift: false);
			}
			else if (_puppet != null)
			{
				ApplyPuppet(in pose2, velocity, dt);
			}
			else
			{
				ApplyMotion(in pose2, dt);
			}
			UpdateEyes(in pose, dt);
			UpdateAudio(in pose, stateForCues, previousGait);
			Publish(in pose, target);
		}

		internal void Place(in FnPoseSample pose)
		{
			EnsureInit();
			SelectVariant();
			_rendered = pose;
			_renderedVelocity = Vector3.zero;
			_renderedTarget = 0;
			_hasPose = true;
			_servoYaw = pose.HeadYaw;
			_servoPitch = pose.HeadPitch;
			_servoActive = false;
			PlaceJump(in pose);
			if (!ExternallyPosed)
			{
				base.transform.SetPositionAndRotation(pose.Position, Quaternion.Euler(0f, pose.Yaw, 0f));
			}
			if (_puppet != null)
			{
				_puppet.Snap();
			}
			Publish(in pose, 0);
		}

		private void Publish(in FnPoseSample p, int target)
		{
			FnAnimPose pose = new FnAnimPose
			{
				Active = true,
				Position = p.Position,
				Yaw = p.Yaw,
				HeadPosition = EyeAt(p.Position, p.Yaw),
				HeadForward = LookForward,
				State = p.State,
				Speed = p.Speed,
				EyesLit = (_eye > 0.05f),
				Frozen = p.Has(FnPoseCodec.FlagFrozen),
				PoweredDown = p.Has(FnPoseCodec.FlagPoweredDown),
				Target = target
			};
			FnAnimView.Set(id, in pose);
			FnAnimView.SetRoot(id, base.transform);
		}

		internal void Unpublish()
		{
			if (FnAnimView.Root(id) == base.transform || !FnAnimView.Get(id).Active)
			{
				FnAnimView.Clear(id);
			}
		}

		internal void PlayCue(FnCue cue)
		{
			PlayCueAudio(cue);
			FnAnimatronic.CuePlayed?.Invoke(id, cue);
		}

		private void OnStateRendered(FnAiState state)
		{
			if (state == FnAiState.PoweredDown)
			{
				PlayPowerDown();
			}
		}

		private static bool NearLocalHead(Vector3 point, float within)
		{
			Transform head = FnPlatform.Head;
			if (head != null)
			{
				return (head.position - point).sqrMagnitude <= within * within;
			}
			return false;
		}
	}
}
