using System;
using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Gameplay.Pumpkin;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	[Obfuscation(Exclude = true)]
	public sealed class ZombieView : MonoBehaviour, IBlastReceiver
	{
		private struct Snap
		{
			public int ms;

			public Vector3 position;

			public float yaw;

			public float speed;

			public ZombieState state;

			public byte hit;

			public float health;
		}

		private static readonly int IdleHash = Animator.StringToHash("Idle");

		private static readonly int EmergeHash = Animator.StringToHash("Emerge");

		private static readonly int WalkHash = Animator.StringToHash("Walk");

		private static readonly int RunHash = Animator.StringToHash("Run");

		private static readonly int WindupHash = Animator.StringToHash("Windup");

		private static readonly int AttackHash = Animator.StringToHash("Attack");

		private static readonly int RecoverHash = Animator.StringToHash("Recover");

		private static readonly int StunnedHash = Animator.StringToHash("Stunned");

		private static readonly int DeathHash = Animator.StringToHash("Death");

		private static readonly int SinkHash = Animator.StringToHash("Sink");

		private static readonly int PaceId = Animator.StringToHash("Pace");

		private static readonly int DissolveId = Shader.PropertyToID("_Dissolve");

		private static readonly int HitFlashId = Shader.PropertyToID("_HitFlash");

		[Header("Parts")]
		public Animator animator;

		public Renderer[] renderers = new Renderer[0];

		[Tooltip("Per renderer: the opaque material (no clip, keeps early-Z).")]
		public Material[] opaqueMaterials = new Material[0];

		[Tooltip("Per renderer: the _DISSOLVE_ON twin, swapped in only while emerging or dissolving.")]
		public Material[] dissolveMaterials = new Material[0];

		public AudioSource voice;

		public AudioSource foley;

		[Header("Body (local to the root, which sits on the ground)")]
		public float bodyBottom = 0.25f;

		public float bodyTop = 0.62f;

		public float bodyRadius = 0.32f;

		public float headHeight = 0.78f;

		public float headForward = 0.18f;

		public float headRadius = 0.22f;

		[Tooltip("Where the attack's swipe ends up, from the root: forward, up (m). A legless crawler leaps at the torso: a standing ape's head is ~1.2-2 m up, its torso 0.4 m below that.")]
		public Vector2 reach = new Vector2(0.75f, 1f);

		[Tooltip("The swipe catches a player whose body is this close to the reach point (m).")]
		public float reachRadius = 0.6f;

		[Header("Gait")]
		[Tooltip("Ground speed the Walk clip covers at Pace 1 (m/s), so the hands don't skate.")]
		public float walkClipSpeed = 1.45f;

		public float runClipSpeed = 3.7f;

		[Tooltip("Normalised times a hand plants in the Walk / Run clip (knuckle thumps).")]
		public float[] walkPlants = new float[2] { 0.02f, 0.52f };

		public float[] runPlants = new float[2] { 0.02f, 0.14f };

		[Header("Sound")]
		public AudioClip[] groans = new AudioClip[0];

		public AudioClip[] hurts = new AudioClip[0];

		public AudioClip[] knuckles = new AudioClip[0];

		public AudioClip windupClip;

		public AudioClip attackClip;

		public AudioClip deathClip;

		public AudioClip emergeClip;

		[Tooltip("Knuckle thumps only play this close to the listener (m).")]
		public float footstepRange = 14f;

		private const int SnapCapacity = 10;

		private const float DyingDissolveStart = 0.85f;

		private const float DyingDissolveTime = 0.9f;

		private const float RetireTime = 0.35f;

		private static readonly float[] GroanEnds = new float[3];

		private readonly Snap[] _snaps = new Snap[10];

		private int _snapCount;

		private ZombieHorde _horde;

		private MaterialPropertyBlock _block;

		private bool _dissolving;

		private float _flash;

		private float _dissolve;

		private float _stateTime;

		private byte _lastHit;

		private bool _hitInit;

		private bool _struck;

		private bool _retiring;

		private float _retireTime;

		private float _retireFrom;

		private bool _localSink;

		private float _nextGroan;

		private float _lastPlantPhase;

		private int _locoHash;

		public int Slot { get; private set; }

		public byte Generation { get; private set; }

		public bool Active { get; private set; }

		public ZombieState State { get; private set; }

		public float Speed { get; private set; }

		public float Health { get; private set; } = 1f;

		public byte NetId => (byte)(Slot | (Generation << 3));

		public bool Alive
		{
			get
			{
				if (!Active || _retiring || _localSink)
				{
					return false;
				}
				if (State != ZombieState.None && State != ZombieState.Dying)
				{
					return State != ZombieState.Sinking;
				}
				return false;
			}
		}

		public Vector3 Centre => base.transform.position + Vector3.up * ((bodyBottom + bodyTop) * 0.5f);

		public PumpkinBody Body
		{
			get
			{
				Vector3 position = base.transform.position;
				return new PumpkinBody
				{
					head = position + Vector3.up * headHeight + base.transform.forward * headForward,
					headRadius = headRadius,
					torsoTop = position + Vector3.up * bodyTop,
					torsoBottom = position + Vector3.up * bodyBottom,
					torsoRadius = bodyRadius
				};
			}
		}

		public Vector3 BlastPivot => Centre;

		public float BlastBodyRadius => bodyRadius;

		public void Init(ZombieHorde horde, int slot)
		{
			_horde = horde;
			Slot = slot;
			_block = new MaterialPropertyBlock();
			Active = false;
			base.gameObject.SetActive(false);
		}

		public void SetFromHost(byte generation, Vector3 position, float yaw, float speed, ZombieState state, byte hit, float health)
		{
			if (!Active || Generation != generation)
			{
				Begin(generation, position, yaw, state);
			}
			base.transform.SetPositionAndRotation(position, Quaternion.Euler(0f, yaw, 0f));
			Speed = speed;
			Health = health;
			if (State != state)
			{
				Enter(state);
			}
			TakeHit(hit);
		}

		public void PushSnapshot(byte generation, int serverMs, Vector3 position, float yaw, float speed, ZombieState state, byte hit, float health)
		{
			if (!Active || Generation != generation || _retiring)
			{
				Begin(generation, position, yaw, state);
				_snapCount = 0;
			}
			else if (_snapCount > 0)
			{
				if (serverMs - _snaps[_snapCount - 1].ms <= 0)
				{
					return;
				}
				if (_snapCount == SnapCapacity)
				{
					Array.Copy(_snaps, 1, _snaps, 0, SnapCapacity - 1);
					_snapCount--;
				}
			}
			_snaps[_snapCount++] = new Snap
			{
				ms = serverMs,
				position = position,
				yaw = yaw,
				speed = speed,
				state = state,
				hit = hit,
				health = health
			};
		}

		private void Begin(byte generation, Vector3 position, float yaw, ZombieState state)
		{
			Generation = generation;
			Active = true;
			_retiring = false;
			_localSink = false;
			_hitInit = false;
			_struck = false;
			_flash = 0f;
			_snapCount = 0;
			_nextGroan = Time.time + UnityEngine.Random.Range(1.5f, 4f);
			base.transform.SetPositionAndRotation(position, Quaternion.Euler(0f, yaw, 0f));
			base.gameObject.SetActive(true);
			State = ZombieState.None;
			Enter(state);
			if (animator != null)
			{
				animator.Update(0f);
			}
		}

		public void Retire()
		{
			if (Active && !_retiring)
			{
				_retiring = true;
				_retireTime = 0f;
				_retireFrom = _dissolve;
			}
		}

		public void ForceSink()
		{
			if (Active && State != ZombieState.Dying && State != ZombieState.Sinking && !_localSink)
			{
				_localSink = true;
				Enter(ZombieState.Sinking);
			}
		}

		public void EndNow()
		{
			Active = false;
			_retiring = false;
			_localSink = false;
			if (base.gameObject.activeSelf)
			{
				base.gameObject.SetActive(false);
			}
		}

		private void Update()
		{
			if (!Active)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			if ((!(_horde != null) || !(_horde.director != null) || !_horde.director.IsAuthority) && !_localSink)
			{
				PlayBack();
			}
			_stateTime += deltaTime;
			UpdateLocomotion();
			UpdateLook(deltaTime);
			UpdateSound();
			CheckLocalStrike();
			if (_retiring)
			{
				_retireTime += deltaTime;
				if (State != ZombieState.Dying && State != ZombieState.Sinking)
				{
					_dissolve = Mathf.Lerp(_retireFrom, 1f, _retireTime / RetireTime);
				}
				if (_dissolve >= 0.999f || _retireTime > 2.5f)
				{
					EndNow();
				}
			}
			else if (_localSink && _stateTime > 1.5f)
			{
				EndNow();
			}
		}

		private void PlayBack()
		{
			if (_snapCount == 0)
			{
				return;
			}
			int delay = Mathf.RoundToInt(1500f / (float)Mathf.Max(1, PhotonNetwork.SerializationRate));
			int renderMs = PlatformClock.NowMs - delay;
			int i = 0;
			while (i < _snapCount - 1 && _snaps[i + 1].ms <= renderMs)
			{
				i++;
			}
			Snap snap = _snaps[i];
			Vector3 position = snap.position;
			float yaw = snap.yaw;
			if (i < _snapCount - 1)
			{
				Snap next = _snaps[i + 1];
				float t = Mathf.Clamp01((float)(renderMs - snap.ms) / (float)Mathf.Max(next.ms - snap.ms, 1));
				position = Vector3.Lerp(snap.position, next.position, t);
				yaw = Mathf.LerpAngle(snap.yaw, next.yaw, t);
			}
			else if (_snapCount - 2 >= 0)
			{
				Snap prev = _snaps[_snapCount - 2];
				float ahead = Mathf.Clamp(renderMs - snap.ms, 0f, 200f);
				position += (snap.position - prev.position) * (ahead / (float)Mathf.Max(snap.ms - prev.ms, 1));
			}
			base.transform.SetPositionAndRotation(position, Quaternion.Euler(0f, yaw, 0f));
			Speed = snap.speed;
			Health = snap.health;
			if (snap.state != State)
			{
				Enter(snap.state);
			}
			TakeHit(snap.hit);
		}

		private void TakeHit(byte hit)
		{
			if (!_hitInit)
			{
				_lastHit = hit;
				_hitInit = true;
			}
			else if (_lastHit != hit)
			{
				_lastHit = hit;
				_flash = 1f;
				if (Alive && hurts.Length != 0 && voice != null)
				{
					voice.PlayOneShot(hurts[UnityEngine.Random.Range(0, hurts.Length)], 0.9f);
				}
			}
		}

		public void LocalHitFlash()
		{
			_flash = Mathf.Max(_flash, 0.8f);
		}

		private void Enter(ZombieState state)
		{
			ZombieState state2 = State;
			State = state;
			_stateTime = 0f;
			if (state != ZombieState.Attack)
			{
				_struck = false;
			}
			if (animator == null)
			{
				return;
			}
			switch (state)
			{
			case ZombieState.Emerge:
				animator.Play(EmergeHash, 0, 0f);
				_dissolve = 0.8f;
				Play(foley, emergeClip, 1f);
				if (_horde != null)
				{
					_horde.OnViewEmerge(base.transform.position);
				}
				return;
			case ZombieState.Walk:
			case ZombieState.Run:
			case ZombieState.Idle:
				_locoHash = 0;
				UpdateLocomotion();
				break;
			case ZombieState.Windup:
				animator.CrossFadeInFixedTime(WindupHash, 0.1f);
				Play(voice, windupClip, 1f);
				break;
			case ZombieState.Attack:
				animator.CrossFadeInFixedTime(AttackHash, 0.05f);
				Play(foley, attackClip, 1f);
				break;
			case ZombieState.Recover:
				animator.CrossFadeInFixedTime(RecoverHash, 0.15f);
				break;
			case ZombieState.Stunned:
				animator.CrossFadeInFixedTime(StunnedHash, 0.06f, 0);
				break;
			case ZombieState.Dying:
				animator.CrossFadeInFixedTime(DeathHash, 0.08f);
				if (voice != null)
				{
					voice.Stop();
				}
				Play(voice, deathClip, 1f);
				break;
			case ZombieState.Sinking:
				animator.CrossFadeInFixedTime(SinkHash, 0.15f);
				break;
			}
			if (state2 == ZombieState.None)
			{
				_dissolve = 0f;
			}
		}

		private void UpdateLocomotion()
		{
			if (animator == null)
			{
				return;
			}
			int num;
			float value;
			switch (State)
			{
			default:
				return;
			case ZombieState.Run:
				if (Speed > 0.4f)
				{
					num = RunHash;
					value = Speed / Mathf.Max(runClipSpeed, 0.1f);
					break;
				}
				goto case ZombieState.Walk;
			case ZombieState.Walk:
				if (Speed > 0.15f)
				{
					num = WalkHash;
					value = Speed / Mathf.Max(walkClipSpeed, 0.1f);
					break;
				}
				goto case ZombieState.Idle;
			case ZombieState.Idle:
				num = IdleHash;
				value = 1f;
				break;
			}
			animator.SetFloat(PaceId, Mathf.Clamp(value, 0.55f, 1.7f));
			if (num != _locoHash)
			{
				_locoHash = num;
				animator.CrossFadeInFixedTime(num, 0.22f);
			}
		}

		private void UpdateLook(float dt)
		{
			switch (State)
			{
			case ZombieState.Emerge:
				_dissolve = Mathf.Max(0f, 0.8f - _stateTime / 0.6f * 0.8f);
				break;
			case ZombieState.Dying:
				_dissolve = Mathf.Clamp01((_stateTime - DyingDissolveStart) / DyingDissolveTime);
				break;
			case ZombieState.Sinking:
				_dissolve = Mathf.Clamp01(_stateTime / 1.3f);
				break;
			default:
				if (!_retiring)
				{
					_dissolve = 0f;
				}
				break;
			}
			_flash = Mathf.Max(0f, _flash - dt * 7f);
			bool flag = _dissolve > 0.001f;
			if (_dissolving != flag)
			{
				_dissolving = flag;
				for (int i = 0; i < renderers.Length; i++)
				{
					Material[] array = ((_dissolve > 0.001f) ? dissolveMaterials : opaqueMaterials);
					Material material = ((i < array.Length) ? array[i] : null);
					if (renderers[i] != null && material != null)
					{
						renderers[i].sharedMaterial = material;
					}
				}
			}
			for (int j = 0; j < renderers.Length; j++)
			{
				Renderer renderer = renderers[j];
				if (renderer == null)
				{
					continue;
				}
				bool flag2 = _dissolve < 0.999f;
				if (renderer.enabled != flag2)
				{
					renderer.enabled = flag2;
				}
				if (_dissolve < 0.999f)
				{
					renderer.GetPropertyBlock(_block);
					_block.SetFloat(DissolveId, _dissolve);
					_block.SetFloat(HitFlashId, _flash);
					renderer.SetPropertyBlock(_block);
				}
			}
		}

		private void UpdateSound()
		{
			if (!Alive)
			{
				return;
			}
			float sqrMagnitude = (ListenerPosition() - base.transform.position).sqrMagnitude;
			if (Time.time >= _nextGroan && State != ZombieState.Emerge)
			{
				_nextGroan = Time.time + UnityEngine.Random.Range(2.8f, 6.5f);
				if (groans.Length != 0 && voice != null && !voice.isPlaying && ClaimGroan(sqrMagnitude))
				{
					AudioClip clip = groans[UnityEngine.Random.Range(0, groans.Length)];
					voice.pitch = UnityEngine.Random.Range(0.88f, 1.08f);
					voice.PlayOneShot(clip, 0.85f);
					voice.pitch = 1f;
				}
			}
			if (animator == null || knuckles.Length == 0 || foley == null || (State != ZombieState.Walk && State != ZombieState.Run) || sqrMagnitude > footstepRange * footstepRange)
			{
				return;
			}
			AnimatorStateInfo currentAnimatorStateInfo = animator.GetCurrentAnimatorStateInfo(0);
			float[] array;
			if (currentAnimatorStateInfo.shortNameHash == RunHash)
			{
				array = runPlants;
			}
			else
			{
				if (currentAnimatorStateInfo.shortNameHash != WalkHash)
				{
					return;
				}
				array = walkPlants;
			}
			if (array == null)
			{
				return;
			}
			float normalizedTime = currentAnimatorStateInfo.normalizedTime;
			float num = normalizedTime - Mathf.Floor(normalizedTime);
			foreach (float num2 in array)
			{
				if ((_lastPlantPhase <= num) ? (num2 > _lastPlantPhase && num2 <= num) : (num2 > _lastPlantPhase || num2 <= num))
				{
					foley.PlayOneShot(knuckles[UnityEngine.Random.Range(0, knuckles.Length)], UnityEngine.Random.Range(0.3f, 0.45f));
					break;
				}
			}
			_lastPlantPhase = num;
		}

		private static bool ClaimGroan(float listenerSqr)
		{
			if (listenerSqr > 784f)
			{
				return false;
			}
			float time = Time.time;
			for (int i = 0; i < GroanEnds.Length; i++)
			{
				if (GroanEnds[i] <= time)
				{
					GroanEnds[i] = time + 1.8f;
					return true;
				}
			}
			return false;
		}

		private static void Play(AudioSource source, AudioClip clip, float volume)
		{
			if (!(source == null) && !(clip == null))
			{
				source.PlayOneShot(clip, volume);
			}
		}

		private Vector3 ListenerPosition()
		{
			if (RiftPlayers.TryGetLocal(out var avatar))
			{
				return avatar.head;
			}
			Camera main = Camera.main;
			return ((main != null) ? main.transform : base.transform).position;
		}

		private void CheckLocalStrike()
		{
			if (State != ZombieState.Attack || _struck || _horde == null || _horde.LocalImmune || _stateTime < 0.05f || _stateTime > 0.38f || !RiftPlayers.TryGetLocal(out var avatar))
			{
				return;
			}
			Vector3 vector = base.transform.position + base.transform.forward * reach.x + Vector3.up * reach.y;
			RiftPlayers.Body(avatar.head, out var top, out var bottom, out var radius);
			float a = (vector - avatar.head).magnitude - 0.2f;
			float b = (vector - PumpkinRig.ClosestOnSegment(vector, top, bottom)).magnitude - radius;
			if (!(Mathf.Min(a, b) > reachRadius))
			{
				_struck = true;
				_horde.OnViewStruck(this);
			}
		}

		void IBlastReceiver.OnBlast(in BlastInfo blast, in BlastHit hit)
		{
			if (Alive && !(_horde == null))
			{
				_horde.HostBlast(this, in blast, in hit);
			}
		}
	}
}
