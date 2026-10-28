using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	[DefaultExecutionOrder(100)]
	public sealed class BansheeGhost : MonoBehaviour
	{
		[NonSerialized]
		public BansheeDirector director;

		[Header("Model")]
		[Tooltip("The skeleton rig root (Armature underneath, base at the root, facing +Z).")]
		public Transform model;

		[Tooltip("Her whole body as one skinned mesh: submesh 0 the body atlas (arms, claws, hem), 1 her skull, 2 her robe.")]
		public SkinnedMeshRenderer body;

		[Tooltip("Head height above the model root (m): the director's position is her head.")]
		public float headHeight = 0.6f;

		[Tooltip("The trailing tatters' bone: swung back by her speed and lifted clear of the ground.")]
		public Transform tail;

		[Tooltip("How far the tatters hang below their bone (m).")]
		public float tailLength = 1.05f;

		[Tooltip("What her claws and tatters keep clear of.")]
		public LayerMask groundMask = 1;

		[Header("Face")]
		public int mouthOpen = -1;

		public int mouthO = -1;

		public Renderer[] eyeGlows = new Renderer[0];

		[Header("Glow")]
		public TrailRenderer trail;

		public ParticleSystem embers;

		[Header("Colours")]
		public Color paleTint = new Color(1f, 1f, 1f, 1f);

		[ColorUsage(false, true)]
		public Color paleRim = new Color(0.07f, 0.08f, 0.11f, 1f);

		[ColorUsage(false, true)]
		public Color paleCracks = new Color(1.6f, 0.18f, 0.06f, 1f);

		[ColorUsage(false, true)]
		public Color paleEyes = new Color(2.2f, 0.18f, 0.06f, 1f);

		public Color redTint = new Color(1f, 0.7f, 0.68f, 1f);

		[ColorUsage(false, true)]
		public Color redRim = new Color(0.45f, 0.025f, 0.015f, 1f);

		[ColorUsage(false, true)]
		public Color redCracks = new Color(3.4f, 0.3f, 0.08f, 1f);

		[ColorUsage(false, true)]
		public Color redEyes = new Color(6f, 0.4f, 0.12f, 1f);

		[Header("Audio")]
		public AudioSource voice;

		public AudioSource oneShots;

		public AudioClip wailLoop;

		public AudioClip liftWail;

		public AudioClip giveUp;

		public AudioClip vanish;

		public AudioClip flyBy;

		[NonSerialized]
		public bool overridePose;

		[NonSerialized]
		public Vector3 overrideHead;

		[NonSerialized]
		public Quaternion overrideFacing;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int RimId = Shader.PropertyToID("_RimColor");

		private static readonly int EmitId = Shader.PropertyToID("_EmitColor");

		private static readonly int DissolveId = Shader.PropertyToID("_Dissolve");

		private static readonly int TintId = Shader.PropertyToID("_Tint");

		private const float ClawReach = 0.42f;

		private BansheeRig _rig;

		private MaterialPropertyBlock _block;

		private bool _shown;

		private float _dissolve = 1f;

		private Vector3 _lastHead;

		private Vector3 _velocity;

		private float _nextFlyBy;

		private float _twitchAt;

		private Vector3 _twitch;

		private Vector3 _twitchTarget;

		private float _jaw;

		private float _jawO;

		private Vector2 _tailAngle;

		private Vector2 _tailSpeed;

		private bool _hasGround;

		private float _groundY;

		private float _poseScale = 1f;

		private Vector3 _poseHead;

		private int _materialCount;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			_materialCount = ((body != null) ? body.sharedMaterials.Length : 0);
			if (model != null)
			{
				_rig = new BansheeRig(model);
			}
			if (_rig != null && !_rig.Valid)
			{
				Debug.LogWarning("[Banshee] Her skeleton's bones weren't found; she'll float unposed.", this);
			}
			if (voice != null)
			{
				voice.clip = wailLoop;
				voice.loop = true;
				voice.playOnAwake = false;
			}
			Show(false);
		}

		private void Show(bool on)
		{
			_shown = on;
			if (model != null && model.gameObject.activeSelf != on)
			{
				model.gameObject.SetActive(on);
			}
			if (trail != null)
			{
				if (!on)
				{
					trail.Clear();
				}
				trail.emitting = on;
			}
			if (!(voice != null))
			{
				return;
			}
			if (on)
			{
				if (!voice.isPlaying && voice.clip != null)
				{
					voice.Play();
				}
			}
			else if (voice.isPlaying)
			{
				voice.Stop();
			}
		}

		public void OnPhase(BansheePhase previous, BansheePhase phase)
		{
			if (oneShots == null)
			{
				return;
			}
			switch (phase)
			{
			case BansheePhase.Hunting:
			case BansheePhase.Chasing:
				if (voice != null && !voice.isPlaying && voice.clip != null && _shown)
				{
					voice.Play();
				}
				break;
			case BansheePhase.Grabbing:
				if (liftWail != null)
				{
					if (voice != null)
					{
						voice.Stop();
					}
					oneShots.PlayOneShot(liftWail, 0.9f);
				}
				break;
			case BansheePhase.Leaving:
				if (!(director != null))
				{
					break;
				}
				if (director.Exit == BansheeExit.Escaped && giveUp != null)
				{
					oneShots.PlayOneShot(giveUp);
				}
				else if (director.Exit == BansheeExit.Caught)
				{
					if (vanish != null)
					{
						oneShots.PlayOneShot(vanish);
					}
					if (embers != null)
					{
						ParticleSystem.MainModule main = embers.main;
						bool red = director.Form == BansheeForm.Red;
						main.startColor = new Color(1f, red ? 0.45f : 0.8f, red ? 0.35f : 0.6f, 1f);
						embers.Play();
					}
				}
				break;
			}
		}

		private void LateUpdate()
		{
			if (director == null)
			{
				return;
			}
			BansheePhase phase = director.Phase;
			float t = director.PhaseTime;
			float fade = 0f;
			switch (phase)
			{
			case BansheePhase.Leaving:
				if (director.Exit == BansheeExit.Caught)
				{
					fade = Mathf.Clamp01(t / 0.35f);
				}
				else
				{
					float span = ((director.Exit == BansheeExit.Escaped) ? BansheeTimings.LeaveEscapedFor : BansheeTimings.LeaveNoTargetFor);
					fade = Mathf.Clamp01((t - span * 0.4f) / (span * 0.6f));
				}
				break;
			case BansheePhase.Chasing:
				if (director.chaseSeconds > 0f)
				{
					float left = director.chaseSeconds - t;
					if (left < 5f)
					{
						fade = Mathf.Max(0f, (1f - left / 5f) * 0.2f * (Mathf.Sin(Time.time * 2.5f) * 0.25f + 0.75f));
					}
				}
				break;
			case BansheePhase.Rising:
				fade = 1f - Mathf.Clamp01(t / 0.9f);
				break;
			}
			_dissolve = (director.IsOut ? fade : 1f);
			bool show = director.IsOut && fade < 0.995f;
			if (_shown != show)
			{
				Show(show);
			}
			if (show)
			{
				float bob = Mathf.Sin(Time.time * 2.1f);
				Vector3 head = (overridePose ? overrideHead : (director.Position + Vector3.up * (bob * 0.04f)));
				Quaternion facing = (overridePose ? overrideFacing : Quaternion.Euler(0f, director.Yaw, 0f));
				float dt = Mathf.Max(Time.deltaTime, 0.0001f);
				Vector3 delta = head - _lastHead;
				Vector3 velocity = ((delta.sqrMagnitude > 25f) ? Vector3.zero : (delta / dt));
				_velocity = Vector3.Lerp(_velocity, velocity, 1f - Mathf.Exp(-8f * dt));
				_lastHead = head;
				base.transform.SetPositionAndRotation(head - Vector3.up * headHeight, facing);
				_hasGround = Physics.Raycast(head + Vector3.up * 0.1f, Vector3.down, out var hit, 4f, groundMask, QueryTriggerInteraction.Ignore);
				_groundY = (_hasGround ? hit.point.y : float.NegativeInfinity);
				Pose(phase, t);
				Tatters(dt);
				Face(phase, t, dt);
				Tint(t, phase);
				Sound(phase, head);
			}
		}

		private void Pose(BansheePhase phase, float t)
		{
			BansheeRig.Pose p = default(BansheeRig.Pose);
			if (_rig == null || !_rig.Valid)
			{
				return;
			}
			float time = Time.time;
			Twitch(time);
			_poseScale = 1f / Mathf.Max(model.lossyScale.y, 0.01f);
			_poseHead = new Vector3(0f, headHeight, 0.04f) * _poseScale;
			p.neckTurn = _twitch * 0.5f + new Vector3(0f, 0f, Mathf.Sin(time * 0.9f) * 14f);
			p.headTurn = _twitch;
			p.headPoint = _poseHead;
			bool hasTarget = director.Target != 0 && director.TryGetPlayer(director.Target, out var _);
			Vector3 look = (hasTarget ? model.InverseTransformPoint(TargetHead()) : Vector3.zero);
			switch (phase)
			{
			case BansheePhase.Rising:
			{
				float s = Mathf.Sin(time * 7f);
				float bob = s * 0.12f;
				p.torso = new Vector3(s * 5f - 8f, 0f, s * 4f);
				p.headTurn += new Vector3(-22f, 0f, 0f);
				p.l = Hand(true, FromHead(-0.44f, 0.3f + bob, 0.3f), new Vector3(-0.2f, 0.75f, 0.6f), s * 0.4f + 0.45f, 25f, new Vector3(-1f, -0.6f, 0f));
				p.r = Hand(false, FromHead(0.44f, 0.3f - bob, 0.3f), new Vector3(0.2f, 0.75f, 0.6f), 0.45f - s * 0.4f, 25f, new Vector3(1f, -0.6f, 0f));
				break;
			}
			case BansheePhase.Grabbing:
				p.lookWeight = (hasTarget ? 0.95f : 0f);
				p.lookAt = look;
				if (t < 0.6f)
				{
					p.headTurn += new Vector3(Mathf.Sin(time * 38f) * 4f, Mathf.Sin(time * 31f) * 6f, Mathf.Sin(time * 38f) * 5f);
					p.torso = new Vector3(24f, 0f, 0f);
					p.l = Hand(true, FromHead(-0.52f, 0.14f, 0.28f), new Vector3(-0.3f, 0.55f, 0.75f), 0.05f, 32f, new Vector3(-1f, -0.2f, -0.4f));
					p.r = Hand(false, FromHead(0.52f, 0.14f, 0.28f), new Vector3(0.3f, 0.55f, 0.75f), 0.05f, 32f, new Vector3(1f, -0.2f, -0.4f));
				}
				else
				{
					float j = Mathf.Sin(time * 22f) * 0.012f;
					p.torso = new Vector3(20f, 0f, 0f);
					p.l = Hand(true, FromHead(-0.25f, -0.46f + j, 0.4f), new Vector3(0.15f, -1f, 0.2f), 0.85f, 25f, new Vector3(-1f, 0.1f, -0.3f));
					p.r = Hand(false, FromHead(0.25f, -0.46f - j, 0.4f), new Vector3(-0.15f, -1f, 0.2f), 0.85f, 25f, new Vector3(1f, 0.1f, -0.3f));
				}
				break;
			case BansheePhase.Leaving when t < 0.9f && director.Exit == BansheeExit.Escaped:
			{
				float j = Mathf.Sin(time * 26f) * 0.03f;
				p.torso = new Vector3(-12f, 0f, 0f);
				p.headTurn += new Vector3(-30f, 0f, 0f);
				p.l = Hand(true, FromHead(-0.5f, 0.38f + j, 0.12f), new Vector3(-0.1f, 1f, 0.2f), 0.95f, 30f, new Vector3(-1f, -0.4f, 0f));
				p.r = Hand(false, FromHead(0.5f, 0.38f - j, 0.12f), new Vector3(0.1f, 1f, 0.2f), 0.95f, 30f, new Vector3(1f, -0.4f, 0f));
				break;
			}
			case BansheePhase.Hunting:
			case BansheePhase.Leaving:
			{
				float s = Mathf.Sin(time * 5f);
				float sway = s * 0.05f;
				p.torso = new Vector3(Mathf.Clamp(_velocity.magnitude * 3.5f, 0f, 45f), 0f, s * 6f);
				p.l = Hand(true, FromHead(-0.52f, -0.5f, sway - 0.52f), new Vector3(-0.25f, -0.45f, -1f), 0.15f, 0f, new Vector3(-1f, -0.2f, 0.3f));
				p.r = Hand(false, FromHead(0.52f, -0.5f, -0.52f - sway), new Vector3(0.25f, -0.45f, -1f), 0.15f, 0f, new Vector3(1f, -0.2f, 0.3f));
				p.lookWeight = (hasTarget ? 0.6f : 0f);
				p.lookAt = look;
				break;
			}
			default:
			{
				p.torso = new Vector3(Mathf.Sin(time * 3f) * 4f + 22f, 0f, Mathf.Sin(time * 2.3f) * 5f);
				float cycle = time * 1.3f;
				float reach = ((phase == BansheePhase.Chasing) ? 1f : 0.5f);
				p.l = Swipe(true, cycle, reach);
				p.r = Swipe(false, cycle + 0.5f, reach);
				p.lookWeight = (hasTarget ? 0.9f : 0f);
				p.lookAt = look;
				break;
			}
			}
			KeepClear(ref p.l);
			KeepClear(ref p.r);
			_rig.Apply(in p);
		}

		private BansheeRig.HandPose Swipe(bool left, float cycle, float reach)
		{
			float side = (left ? (-1f) : 1f);
			float f = cycle - Mathf.Floor(cycle);
			Vector3 rest = new Vector3(side * 0.32f, -0.4f, reach * 0.5f + 0.1f);
			Vector3 raised = new Vector3(side * 0.44f, 0.3f, reach * 0.42f + 0.08f);
			Vector3 struck = new Vector3(side * -0.04f, -0.42f, reach * 0.72f + 0.06f);
			Vector3 point;
			float curl;
			if (f < 0.55f)
			{
				float k = Mathf.SmoothStep(0f, 1f, f / 0.55f);
				point = Vector3.Lerp(rest, raised, k);
				curl = Mathf.Lerp(0.5f, 0.05f, k);
			}
			else if (f < 0.72f)
			{
				float u = (f - 0.55f) / 0.17f;
				float k = u * u;
				point = Vector3.Lerp(raised, struck, k);
				curl = Mathf.Lerp(0.05f, 0.7f, k);
			}
			else
			{
				float k = Mathf.SmoothStep(0f, 1f, (f - 0.72f) / 0.28f);
				point = Vector3.Lerp(struck, rest, k);
				curl = Mathf.Lerp(0.7f, 0.5f, k);
			}
			return Hand(left, FromHead(point.x, point.y, point.z), new Vector3(side * -0.15f, 0.2f, 1f), curl, reach * 22f, new Vector3(side, -0.3f, -0.5f));
		}

		private void KeepClear(ref BansheeRig.HandPose h)
		{
			if (_hasGround)
			{
				Vector3 world = model.TransformPoint(h.point);
				float floor = _groundY + ClawReach;
				if (world.y < floor)
				{
					h.point = model.InverseTransformPoint(new Vector3(world.x, floor, world.z));
				}
			}
		}

		private Vector3 FromHead(float right, float up, float forward)
		{
			return _poseHead + new Vector3(right, up, forward) * _poseScale;
		}

		private Vector3 TargetHead()
		{
			if (director.Target == BansheePlayers.LocalActor && BansheePlayers.TryGetLocalHead(out var head))
			{
				return head;
			}
			if (director.TryGetPlayer(director.Target, out var avatar))
			{
				return avatar.head;
			}
			return director.Position + base.transform.forward;
		}

		private static BansheeRig.HandPose Hand(bool left, Vector3 point, Vector3 aim, float curl, float shrug, Vector3 elbow)
		{
			return new BansheeRig.HandPose
			{
				point = point,
				elbow = elbow,
				aim = aim,
				palm = new Vector3(left ? 1f : (-1f), -0.4f, 0.2f),
				curl = curl,
				shrug = shrug
			};
		}

		private void Twitch(float time)
		{
			if (time >= _twitchAt)
			{
				_twitchAt = time + UnityEngine.Random.Range(0.35f, 1.6f);
				_twitchTarget = ((UnityEngine.Random.value < 0.4f) ? Vector3.zero : new Vector3(UnityEngine.Random.Range(-20f, 20f), UnityEngine.Random.Range(-30f, 30f), UnityEngine.Random.Range(-35f, 35f)));
			}
			_twitch = Vector3.Lerp(_twitch, _twitchTarget, 1f - Mathf.Exp(-22f * Time.deltaTime));
		}

		private void Tatters(float dt)
		{
			if (tail == null || model == null)
			{
				return;
			}
			Vector3 local = model.InverseTransformDirection(_velocity);
			float pitch = Mathf.Clamp(local.z * 7f, -20f, 75f) + Mathf.Sin(Time.time * 1.7f) * 6f;
			float roll = Mathf.Clamp(local.x * -6f, -35f, 35f);
			float wave = Mathf.Sin(Time.time * 1.3f + 1f);
			if (_hasGround)
			{
				float clear = tail.position.y - (_groundY + 0.08f);
				if (clear < tailLength)
				{
					pitch = Mathf.Max(pitch, Mathf.Acos(Mathf.Clamp(clear / tailLength, -1f, 1f)) * 57.29578f);
				}
			}
			Vector2 target = new Vector2(pitch, roll + wave * 5f);
			_tailSpeed += ((target - _tailAngle) * 60f + _tailSpeed * -9f) * dt;
			_tailAngle += _tailSpeed * dt;
			tail.rotation = Quaternion.AngleAxis(_tailAngle.y, model.forward) * Quaternion.AngleAxis(_tailAngle.x, model.right) * tail.rotation;
		}

		private void Face(BansheePhase phase, float t, float dt)
		{
			if (body == null || mouthOpen < 0)
			{
				return;
			}
			float time = Time.time;
			Vector2 target = new Vector2(20f, 0f);
			switch (phase)
			{
			case BansheePhase.Rising:
				target = new Vector2(Mathf.Sin(time * 18f) * 15f + 85f, 0f);
				break;
			case BansheePhase.Hunting:
				target = new Vector2(Mathf.Sin(time * 2.3f) * 10f + 30f, 45f);
				break;
			case BansheePhase.Chasing:
				target = new Vector2(Mathf.Abs(Mathf.Sin(time * 4.5f)) * 30f + 50f, 15f);
				break;
			case BansheePhase.Grabbing:
				target = ((t < 0.6f) ? new Vector2(100f, 0f) : new Vector2(Mathf.Sin(time * 6f) * 15f + 65f, 30f));
				break;
			case BansheePhase.Leaving:
				target = ((director.Exit == BansheeExit.Escaped) ? new Vector2(95f, 50f) : new Vector2(70f, 0f));
				break;
			}
			_jaw = Mathf.MoveTowards(_jaw, target.x, 600f * dt);
			_jawO = Mathf.MoveTowards(_jawO, target.y, 300f * dt);
			body.SetBlendShapeWeight(mouthOpen, _jaw);
			if (mouthO >= 0)
			{
				body.SetBlendShapeWeight(mouthO, _jawO);
			}
		}

		private void Tint(float t, BansheePhase phase)
		{
			bool red = director.Form == BansheeForm.Red;
			float pulse = Mathf.Sin(Time.time * 2.2f) * 0.2f + 0.8f;
			bool calm = !(t < 0.6f && phase == BansheePhase.Grabbing);
			Color tint = (red ? redTint : paleTint);
			Color rim = (red ? redRim : paleRim);
			if (body != null)
			{
				float flare = (calm ? 1f : 1.6f);
				Color cracks = (red ? redCracks : paleCracks);
				for (int i = 0; i < _materialCount; i++)
				{
					body.GetPropertyBlock(_block, i);
					_block.SetColor(ColorId, tint);
					_block.SetColor(RimId, rim);
					_block.SetFloat(DissolveId, _dissolve);
					_block.SetColor(EmitId, (i == 0) ? (cracks * pulse * flare) : new Color(0f, 0f, 0f, 1f));
					body.SetPropertyBlock(_block, i);
				}
			}
			Color eyes = (red ? redEyes : paleEyes) * (calm ? (pulse * 0.15f + 0.85f) : 1.8f) * (1f - _dissolve);
			for (int j = 0; j < eyeGlows.Length; j++)
			{
				Renderer glow = eyeGlows[j];
				if (!(glow == null))
				{
					glow.GetPropertyBlock(_block);
					_block.SetColor(TintId, eyes);
					glow.SetPropertyBlock(_block);
				}
			}
			if (trail != null)
			{
				trail.emitting = _velocity.sqrMagnitude > 4f;
				Color c = (red ? new Color(1.2f, 0.15f, 0.08f, (1f - _dissolve) * 0.45f) : new Color(0.55f, 0.55f, 0.65f, (1f - _dissolve) * 0.45f));
				trail.startColor = c * 0.3f;
				trail.endColor = new Color(c.r, c.g, c.b, 0f);
			}
		}

		private void Sound(BansheePhase phase, Vector3 headPos)
		{
			if (voice != null)
			{
				float volume = ((phase == BansheePhase.Grabbing) ? 0f : (((phase == BansheePhase.Chasing) ? 1f : 0.8f) * (1f - _dissolve)));
				voice.volume = Mathf.MoveTowards(voice.volume, volume, Time.deltaTime * 2f);
				voice.pitch = ((director.Form == BansheeForm.Red) ? 0.9f : 1f) * (1f + director.ChaseProgress * 0.12f);
			}
			if (flyBy != null && oneShots != null && !(Time.time < _nextFlyBy) && _velocity.sqrMagnitude > 36f && director.Target != BansheePlayers.LocalActor && BansheePlayers.TryGetLocalHead(out var local) && (local - headPos).sqrMagnitude < 12f)
			{
				_nextFlyBy = Time.time + 3f;
				oneShots.PlayOneShot(flyBy, 0.9f);
			}
		}
	}
}
