using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnSpecimenTube : MonoBehaviour
	{
		private enum Stage : byte
		{
			Intact = 0,
			Cracking = 1,
			Broken = 2
		}

		[Tooltip("The animatronic that sleeps in this tube (its home is the centre of the tube's floor).")]
		public FnAnimatronic occupant;

		[Header("Parts")]
		public Renderer glass;

		[Tooltip("Keeps players out of the tank; off once it bursts.")]
		public Collider glassCollider;

		[Tooltip("The glass in pieces: remnants on the root bone, one bone per flying shard. Hidden until the burst.")]
		public SkinnedMeshRenderer shards;

		public Transform[] shardBones = new Transform[0];

		[Tooltip("Takes the settled shards, baked, so the skinned mesh can stop. Sits at the same place as Shards.")]
		public MeshFilter shardsBaked;

		[Tooltip("Half a shard's thickness: how far above the ground a settled shard's centre rests (m).")]
		public float shardRestHeight = 0.008f;

		public Renderer fluid;

		public Renderer fluidSurface;

		public Renderer puddle;

		[Tooltip("The stand. Its first material's emission is the status lamps and the light in the tank's floor.")]
		public Renderer body;

		[Header("Shape (local metres)")]
		[Tooltip("The tank's floor, where the occupant stands.")]
		public float pedestalHeight = 0.44f;

		[Tooltip("Where falling shards land on the stand, outward from the axis: x = out to this radius, y = at this height. Sorted by radius; beyond the last step is the room floor.")]
		public Vector2[] deck = new Vector2[3]
		{
			new Vector2(0.64f, 0.44f),
			new Vector2(0.82f, 0.53f),
			new Vector2(0.97f, 0.32f)
		};

		public float glassRadius = 0.66f;

		public float glassTop = 2.67f;

		public float fluidTop = 2.55f;

		[Tooltip("Height of the impact, where the occupant presses through (local).")]
		public float impactHeight = 1.5f;

		[Header("Timing")]
		[Tooltip("The slam that bursts the tube (the ones before it each crack it further), unless the body walks off first.")]
		public int slamsToBurst = 4;

		[Tooltip("The occupant moving this far from home bursts the tube at once (m).")]
		public float burstDistance = 0.1f;

		public float drainSeconds = 0.7f;

		public float spreadSeconds = 2.2f;

		[Header("Look")]
		[Tooltip("Asleep: the fluid's green, so the lamps belong to the tank.")]
		[ColorUsage(false, true)]
		public Color statusIdle = new Color(0.144f, 1.2f, 0.384f, 1.2f);

		[ColorUsage(false, true)]
		public Color statusAlarm = new Color(2.2f, 0.176f, 0.088f, 2.2f);

		[ColorUsage(false, true)]
		public Color statusDead = new Color(0.3f, 0.02f, 0.01f, 0.5f);

		[Tooltip("Lamp emission per unit of status colour.")]
		public float lampGain = 2.5f;

		public float fluidGlow = 0.6f;

		[Header("Audio")]
		public float crackVolume = 0.8f;

		public float shatterVolume = 1f;

		[Tooltip("The burst carries this far (m): it is a cue, players across the building should hear it.")]
		public float shatterAudible = 38f;

		public const float SlamPeriod = 0.95f;

		private const float FirstWindup = 0.35f;

		private const float Gravity = 9.81f;

		private const float RestSpeed = 0.6f;

		private const float SimSeconds = 4f;

		private static readonly float[] CrackAfterSlam = new float[4] { 0.32f, 0.58f, 0.82f, 1f };

		private static readonly int CrackId = Shader.PropertyToID("_Crack");

		private static readonly int LevelId = Shader.PropertyToID("_LevelY");

		private static readonly int GlowId = Shader.PropertyToID("_Glow");

		private static readonly int SpreadId = Shader.PropertyToID("_Spread");

		private static readonly int SeedId = Shader.PropertyToID("_Seed");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private Stage _stage;

		private bool _observed;

		private float _crack;

		private float _crackClock;

		private int _slams;

		private float _brokenClock;

		private bool _simulating;

		private float _seed;

		private MaterialPropertyBlock _block;

		private Mesh _baked;

		private Renderer _bakedRenderer;

		private Vector3[] _restPos;

		private Quaternion[] _restRot;

		private Vector3[] _pos;

		private Vector3[] _vel;

		private Quaternion[] _rot;

		private Vector3[] _spin;

		private byte[] _bounces;

		private bool[] _resting;

		public bool Holds => _stage != Stage.Broken;

		private float Scale => base.transform.lossyScale.y;

		public float GlassRadiusWorld => glassRadius * Scale;

		private static float SlamLands => 0.36f;

		private Vector3 ImpactPoint => base.transform.TransformPoint(new Vector3(0f, impactHeight, glassRadius));

		private float FluidTopY => base.transform.position.y + fluidTop * Scale;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			_bakedRenderer = ((shardsBaked != null) ? shardsBaked.GetComponent<Renderer>() : null);
			int num = shardBones.Length;
			_restPos = new Vector3[num];
			_restRot = new Quaternion[num];
			_pos = new Vector3[num];
			_vel = new Vector3[num];
			_rot = new Quaternion[num];
			_spin = new Vector3[num];
			_bounces = new byte[num];
			_resting = new bool[num];
			for (int i = 0; i < num; i++)
			{
				if (!(shardBones[i] == null))
				{
					_restPos[i] = shardBones[i].localPosition;
					_restRot[i] = shardBones[i].localRotation;
				}
			}
			Restore();
		}

		private void Start()
		{
			if (occupant != null)
			{
				occupant.Tank = this;
			}
		}

		private void OnDestroy()
		{
			if (occupant != null && occupant.Tank == this)
			{
				occupant.Tank = null;
			}
			if (_baked != null)
			{
				Object.Destroy(_baked);
			}
		}

		public void GlassFace(out Vector3 point, out Vector3 normal, out float halfWidth)
		{
			normal = -base.transform.forward;
			point = base.transform.TransformPoint(new Vector3(0f, pedestalHeight, glassRadius * 0.9f));
			halfWidth = glassRadius * Scale * 0.8f;
		}

		public void Slam(out float age, out int count)
		{
			float num = _crackClock - FirstWindup;
			if (_stage != Stage.Cracking || num < 0f)
			{
				count = 0;
				age = 99f;
				return;
			}
			int num2 = Mathf.FloorToInt(num / SlamPeriod);
			count = num2 + 1;
			age = num - (float)num2 * SlamPeriod;
		}

		private void OnEnable()
		{
			if (_block != null)
			{
				Restore();
			}
		}

		private void Update()
		{
			float deltaTime = Time.deltaTime;
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.Active || instance.Phase <= FnPhase.Briefing)
			{
				if (_stage != Stage.Intact || _observed)
				{
					Restore();
				}
				IdleLook();
				return;
			}
			if (occupant != null && occupant.HasPose)
			{
				FnPoseSample rendered = occupant.Rendered;
				Vector3 homePosition = occupant.HomePosition;
				float num = rendered.Position.x - homePosition.x;
				float num2 = rendered.Position.z - homePosition.z;
				float num3 = num * num + num2 * num2;
				bool flag = num3 > burstDistance * burstDistance;
				if (!_observed)
				{
					_observed = true;
					if (flag && _stage == Stage.Intact)
					{
						BreakSilently();
						return;
					}
				}
				if (_stage == Stage.Intact && (flag || rendered.State != FnAiState.Dormant))
				{
					BeginCracking();
				}
				if (flag && _stage == Stage.Cracking)
				{
					Burst();
				}
			}
			switch (_stage)
			{
			case Stage.Intact:
				IdleLook();
				break;
			case Stage.Cracking:
				StepCracking(deltaTime);
				break;
			case Stage.Broken:
				StepBroken(deltaTime);
				break;
			}
		}

		private void Restore()
		{
			_stage = Stage.Intact;
			_observed = false;
			_crack = 0f;
			_crackClock = 0f;
			_slams = 0;
			_simulating = false;
			_seed = Random.Range(0f, 100f);
			if (glass != null)
			{
				glass.enabled = true;
			}
			if (glassCollider != null)
			{
				glassCollider.enabled = true;
			}
			if (shards != null)
			{
				shards.enabled = false;
			}
			if (_bakedRenderer != null)
			{
				_bakedRenderer.enabled = false;
			}
			for (int i = 0; i < shardBones.Length; i++)
			{
				if (!(shardBones[i] == null))
				{
					shardBones[i].localPosition = _restPos[i];
					shardBones[i].localRotation = _restRot[i];
				}
			}
			if (fluidSurface != null)
			{
				fluidSurface.enabled = true;
			}
			if (puddle != null)
			{
				puddle.enabled = false;
			}
			SetCrack(0f);
			SetFluid(FluidTopY, fluidGlow);
		}

		private void IdleLook()
		{
			float num = Time.time + _seed;
			SetFluid(FluidTopY, fluidGlow * (Mathf.Sin(num * 0.7f) * 0.1f + 0.9f));
			SetStatus(statusIdle);
		}

		private void BeginCracking()
		{
			_stage = Stage.Cracking;
			_crackClock = 0f;
			_slams = 0;
		}

		private void StepCracking(float dt)
		{
			_crackClock += dt;
			int num = ((!(_crackClock < FirstWindup + SlamLands)) ? (Mathf.FloorToInt((_crackClock - FirstWindup - SlamLands) / SlamPeriod) + 1) : 0);
			while (_slams < num)
			{
				_slams++;
				if (_slams >= Mathf.Max(1, slamsToBurst))
				{
					Burst();
					return;
				}
				PlayCrack(_slams - 1);
			}
			float num2 = ((_slams > 0) ? CrackAfterSlam[Mathf.Min(_slams - 1, CrackAfterSlam.Length - 1)] : 0f);
			float num3 = ((_slams > 0) ? (Mathf.Clamp01((_crackClock - ((float)(_slams - 1) * SlamPeriod + (FirstWindup + SlamLands))) / SlamPeriod) * 0.05f) : 0f);
			_crack = Mathf.MoveTowards(_crack, Mathf.Max(_crack, num2 + num3), dt * 4f);
			SetCrack(_crack);
			SetStatus(statusAlarm * (Mathf.Sin(_crackClock * Mathf.PI * 2.8f) * 0.45f + 0.55f));
			float num4 = Mathf.PerlinNoise(_crackClock * 3f, _seed);
			SetFluid(FluidTopY, fluidGlow * (num4 * 0.6f + 0.7f));
		}

		private void Burst()
		{
			BreakState();
			LaunchShards();
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				Vector3 impactPoint = ImpactPoint;
				FnAudio.Play(FnAudioBank.Pick(audio.tubeShatter), impactPoint, shatterVolume, 1f, shatterAudible, Random.Range(0.94f, 1.04f));
				FnAudio.Play(audio.tubeSplash, base.transform.position + Vector3.up * 0.4f, shatterVolume * 0.8f, 1f, shatterAudible * 0.6f, Random.Range(0.9f, 1.05f));
			}
		}

		private void BreakSilently()
		{
			BreakState();
			LaunchShards();
			for (float num = 0f; _simulating && num < SimSeconds; num += 1f / 60f)
			{
				StepShards(1f / 60f);
			}
			_simulating = false;
			BakeShards();
			_brokenClock = 100f;
			ApplyBroken();
		}

		private void BreakState()
		{
			_stage = Stage.Broken;
			_brokenClock = 0f;
			_crack = 1f;
			if (glass != null)
			{
				glass.enabled = false;
			}
			if (glassCollider != null)
			{
				glassCollider.enabled = false;
			}
			if (shards != null)
			{
				shards.enabled = true;
				shards.GetPropertyBlock(_block);
				_block.SetFloat(CrackId, 1f);
				shards.SetPropertyBlock(_block);
			}
			if (puddle != null)
			{
				puddle.enabled = true;
				puddle.GetPropertyBlock(_block);
				_block.SetFloat(SeedId, _seed);
				puddle.SetPropertyBlock(_block);
			}
		}

		private void StepBroken(float dt)
		{
			_brokenClock += dt;
			if (_simulating)
			{
				StepShards(Mathf.Min(dt, 1f / 30f));
				if (!_simulating)
				{
					BakeShards();
				}
			}
			ApplyBroken();
		}

		private void ApplyBroken()
		{
			float num = Mathf.Clamp01(_brokenClock / Mathf.Max(drainSeconds, 0.05f));
			float fluidTopY = FluidTopY;
			float b = base.transform.position.y + pedestalHeight * Scale - 0.02f;
			float num2 = 1f - num;
			float num3 = Mathf.Lerp(fluidTopY, b, 1f - num2 * num2);
			SetFluid(num3, num2 * fluidGlow);
			if (fluidSurface != null)
			{
				Transform obj = fluidSurface.transform;
				Vector3 position = obj.position;
				position.y = num3;
				obj.position = position;
				if (num >= 1f && fluidSurface.enabled)
				{
					fluidSurface.enabled = false;
				}
			}
			if (puddle != null)
			{
				float num4 = Mathf.Clamp01((_brokenClock - 0.1f) / Mathf.Max(spreadSeconds, 0.05f));
				puddle.GetPropertyBlock(_block);
				float num5 = 1f - num4;
				_block.SetFloat(SpreadId, 1f - num5 * num5 * num5);
				puddle.SetPropertyBlock(_block);
			}
			if (_brokenClock < 1.2f && Mathf.PerlinNoise(_brokenClock * 9f, _seed) > 0.55f)
			{
				SetStatus(statusAlarm * 0.6f);
			}
			else
			{
				SetStatus(statusDead);
			}
		}

		private void LaunchShards()
		{
			Vector3 position = base.transform.position;
			Vector3 forward = base.transform.forward;
			Vector3 impactPoint = ImpactPoint;
			for (int i = 0; i < shardBones.Length; i++)
			{
				Transform bone = shardBones[i];
				if (!(bone == null))
				{
					bone.localPosition = _restPos[i];
					bone.localRotation = _restRot[i];
					_pos[i] = bone.position;
					_rot[i] = bone.rotation;
					Vector3 vector = new Vector3(_pos[i].x - position.x, 0f, _pos[i].z - position.z);
					Vector3 vector2 = forward;
					if (vector.sqrMagnitude > 1E-06f)
					{
						vector2 = vector.normalized;
					}
					float num = Mathf.Clamp01(Vector3.Dot(forward, vector2) * 0.5f + 0.5f);
					float num2 = Mathf.Clamp01(1f - Vector3.Distance(_pos[i], impactPoint) / 1.6f);
					float num3 = (Mathf.Clamp01(num * num) * 3.7f + 0.5f) * (num2 * 0.55f + 0.8f) * Random.Range(0.75f, 1.2f);
					_vel[i] = vector2 * num3 + forward * (num * num2 * 1.2f) + Vector3.up * Random.Range(0.2f, 1.6f) * num;
					_spin[i] = Random.onUnitSphere * Random.Range(5f, 16f);
					_bounces[i] = 0;
					_resting[i] = false;
				}
			}
			_simulating = shardBones.Length != 0;
		}

		private void StepShards(float dt)
		{
			Vector3 position = base.transform.position;
			float scale = Scale;
			float num = scale * shardRestHeight;
			bool flag = false;
			for (int i = 0; i < shardBones.Length; i++)
			{
				Transform bone = shardBones[i];
				if (bone == null || _resting[i])
				{
					continue;
				}
				_vel[i].y -= Gravity * dt;
				_pos[i] += _vel[i] * dt;
				float magnitude = _spin[i].magnitude;
				if (magnitude > 0.0001f)
				{
					_rot[i] = Quaternion.AngleAxis(magnitude * dt * 57.29578f, _spin[i] / magnitude) * _rot[i];
				}
				float num2 = _pos[i].x - position.x;
				float num3 = _pos[i].z - position.z;
				float num4 = position.y + DeckHeight((num2 * num2 + num3 * num3) / (scale * scale)) * scale + num;
				if (_pos[i].y < num4)
				{
					_pos[i].y = num4;
					if (_vel[i].y < -RestSpeed && _bounces[i] < 2)
					{
						_bounces[i]++;
						Vector3 vector = _vel[i];
						_vel[i] = new Vector3(vector.x * 0.45f, vector.y * -0.22f, vector.z * 0.45f);
						_spin[i] *= 0.4f;
					}
					else
					{
						Vector3 vector2 = _rot[i] * Vector3.forward;
						_rot[i] = Quaternion.FromToRotation(vector2, (vector2.y >= 0f) ? Vector3.up : Vector3.down) * _rot[i];
						_vel[i] = Vector3.zero;
						_spin[i] = Vector3.zero;
						_resting[i] = true;
					}
				}
				bone.SetPositionAndRotation(_pos[i], _rot[i]);
				flag = true;
			}
			if (!flag || _brokenClock > SimSeconds)
			{
				_simulating = false;
			}
		}

		private void BakeShards()
		{
			if (!(shards == null) && !(shardsBaked == null) && !(_bakedRenderer == null))
			{
				if (_baked == null)
				{
					_baked = new Mesh
					{
						name = "ShardsBaked"
					};
					_baked.MarkDynamic();
				}
				shards.BakeMesh(_baked, true);
				_baked.RecalculateBounds();
				shardsBaked.sharedMesh = _baked;
				_bakedRenderer.enabled = true;
				shards.enabled = false;
			}
		}

		private float DeckHeight(float r2)
		{
			for (int i = 0; i < deck.Length; i++)
			{
				if (deck[i].x * deck[i].x > r2)
				{
					return deck[i].y;
				}
			}
			return 0f;
		}

		private void PlayCrack(int slam)
		{
			FnAudioBank audio = FnGame.Audio;
			if (!(audio == null))
			{
				float volume = crackVolume * (Mathf.Clamp01((float)slam / 3f) * 0.3f + 0.7f);
				FnAudio.Play(FnAudioBank.Pick(audio.tubeCrack), ImpactPoint, volume, 1f, 22f, Random.Range(0.92f, 1.1f));
			}
		}

		private void SetCrack(float reach)
		{
			if (!(glass == null))
			{
				glass.GetPropertyBlock(_block);
				_block.SetFloat(CrackId, reach);
				glass.SetPropertyBlock(_block);
			}
		}

		private void SetFluid(float levelY, float glow)
		{
			for (int i = 0; i < 2; i++)
			{
				Renderer renderer = ((i == 0) ? fluid : fluidSurface);
				if (!(renderer == null))
				{
					renderer.GetPropertyBlock(_block);
					_block.SetFloat(LevelId, ((i == 0) ? 0f : 0.05f) + levelY);
					_block.SetFloat(GlowId, glow);
					renderer.SetPropertyBlock(_block);
				}
			}
		}

		private void SetStatus(Color c)
		{
			if (!(body == null))
			{
				body.GetPropertyBlock(_block, 0);
				_block.SetColor(EmissionId, c * lampGain);
				body.SetPropertyBlock(_block, 0);
			}
		}
	}
}
