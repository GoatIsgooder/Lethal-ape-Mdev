using System.Collections;
using LALocomotion;
using LethalApeR.Gameplay.Monsters;
using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	[DisallowMultipleComponent]
	[RequireComponent(typeof(LAGrabbable))]
	public class PumpkinLauncher : MonoBehaviour
	{
		[Tooltip("Names this launcher on the network; other players' copies are built from its prefab.")]
		public PumpkinLauncherKind kind;

		public PumpkinProjectile projectilePrefab;

		[Tooltip("Where the loaded pumpkin sits; its forward is the firing direction.")]
		public Transform socket;

		[Tooltip("A point inside the launcher behind the socket: a shot is checked from here, so a muzzle poked into a wall bursts at the wall.")]
		public Transform breech;

		[Tooltip("Seconds from one shot to the next pumpkin being ready.")]
		public float reloadTime = 1.2f;

		[Tooltip("The next pumpkin pops onto the nose over the last part of the reload.")]
		public float popDuration = 0.35f;

		[Range(0.05f, 1f)]
		public float triggerPress = 0.6f;

		[Range(0f, 0.95f)]
		public float triggerRelease = 0.3f;

		[Tooltip("Projectiles made up front so the first shots don't instantiate.")]
		public int prewarm = 3;

		[Tooltip("Stands in for the loaded pumpkin in the editor; hidden when the game runs.")]
		public GameObject preview;

		[Header("Return")]
		[Tooltip("Dropped, the launcher goes back to where it started after lying loose this long (0 = never). Nobody else sees a dropped launcher, so it shouldn't lie around.")]
		public float returnDelay = 4f;

		[Tooltip("Closer than this to where it started, it stays put.")]
		public float returnMinDistance = 0.3f;

		[Header("Effects")]
		public ParticleSystem[] muzzleEffects = new ParticleSystem[0];

		[Tooltip("Smoke out of the back of the tube.")]
		public ParticleSystem[] backblastEffects = new ParticleSystem[0];

		[Tooltip("Puff at the nose when the next pumpkin pops on.")]
		public ParticleSystem reloadEffect;

		[Header("Audio")]
		public AudioSource audioSource;

		public AudioClip fireClip;

		[Range(0f, 1f)]
		public float fireVolume = 1f;

		public Vector2 firePitch = new Vector2(0.95f, 1.05f);

		public AudioClip reloadClip;

		[Range(0f, 1f)]
		public float reloadVolume = 0.7f;

		[Tooltip("Trigger pulled while reloading.")]
		public AudioClip dryClip;

		[Range(0f, 1f)]
		public float dryVolume = 0.6f;

		[Header("Haptics")]
		[Range(0f, 1f)]
		public float fireHapticAmplitude = 1f;

		public float fireHapticDuration = 0.18f;

		[Range(0f, 1f)]
		public float reloadHapticAmplitude = 0.3f;

		public float reloadHapticDuration = 0.05f;

		[Range(0f, 1f)]
		public float dryHapticAmplitude = 0.15f;

		public float dryHapticDuration = 0.03f;

		[Header("Safe zone")]
		[Tooltip("Only fires where monsters can go: never while the holder's head is inside a MonsterExclusionZone (MainScene's lobby).")]
		public bool onlyWhereMonstersRoam = true;

		[Range(0f, 1f)]
		public float safeZoneHapticAmplitude = 0.35f;

		public float safeZoneHapticDuration = 0.04f;

		[Tooltip("Gap between the two short buzzes that say the safety is on.")]
		public float safeZoneHapticGap = 0.07f;

		private LAGrabbable _grabbable;

		private PumpkinProjectile _loaded;

		private bool _loadedIsPart;

		private float _reloadLeft;

		private bool _triggerDown;

		private LAGrabber _triggerHand;

		private bool _twoHanded;

		private bool _retired;

		private Transform _homeParent;

		private Vector3 _homePosition;

		private Quaternion _homeRotation;

		private Vector3 _homeScale;

		private float _looseTime;

		private float _returnPop = -1f;

		public PumpkinProjectile Loaded => _loaded;

		public bool IsLoaded => _loaded != null && _loaded.IsReady;

		public LAGrabbable Grabbable => _grabbable != null ? _grabbable : (_grabbable = GetComponent<LAGrabbable>());

		public bool IsProxy { get; private set; }

		public bool FeeDue { get; set; }

		public bool ReturningHome => _returnPop >= 0f;

		public bool InSafeZone
		{
			get
			{
				if (!onlyWhereMonstersRoam || IsProxy)
				{
					return false;
				}
				LAGrabber holder = Grabbable.Holder;
				return MonsterExclusionZone.Contains((holder != null && holder.player != null) ? holder.player.HeadPosition : transform.position);
			}
		}

		private void Awake()
		{
			_grabbable = GetComponent<LAGrabbable>();
			if (preview != null)
			{
				preview.SetActive(false);
			}
			_homeParent = transform.parent;
			_homePosition = transform.localPosition;
			_homeRotation = transform.localRotation;
			_homeScale = transform.localScale;
		}

		private void OnEnable()
		{
			if (!IsProxy)
			{
				PumpkinNet.RegisterKind(kind);
			}
		}

		private void Start()
		{
			PumpkinProjectile.Prewarm(projectilePrefab, prewarm);
			if (_loaded == null && !_retired)
			{
				Load(false);
			}
		}

		private void OnDisable()
		{
			_triggerDown = false;
			if (_triggerHand != null)
			{
				PumpkinNet.LocalReleased(this);
			}
			_triggerHand = null;
		}

		private void Update()
		{
			if (!IsProxy)
			{
				ReadTrigger();
			}
			UpdateReload();
			if (!IsProxy)
			{
				UpdateReturn();
			}
		}

		private void ReadTrigger()
		{
			LAGrabber holder = Grabbable.Holder;
			bool twoHanded = holder != null && Grabbable.IsTwoHanded;
			if (holder != _triggerHand)
			{
				_triggerHand = holder;
				_triggerDown = holder != null && holder.Trigger >= triggerRelease;
				_twoHanded = twoHanded;
				if (holder != null)
				{
					PumpkinNet.LocalGrabbed(this, holder.isLeft);
				}
				else
				{
					PumpkinNet.LocalReleased(this);
				}
			}
			else
			{
				if (!(holder != null))
				{
					return;
				}
				if (_twoHanded != twoHanded)
				{
					_twoHanded = twoHanded;
					PumpkinNet.LocalGrabbed(this, holder.isLeft);
				}
				float trigger = holder.Trigger;
				if (_triggerDown)
				{
					if (trigger < triggerRelease)
					{
						_triggerDown = false;
					}
				}
				else if (trigger >= triggerPress)
				{
					_triggerDown = true;
					PullTrigger(holder);
				}
			}
		}

		private void UpdateReload()
		{
			if (_retired)
			{
				return;
			}
			if (_loaded == null)
			{
				_reloadLeft -= Time.deltaTime;
				if (_reloadLeft <= popDuration)
				{
					Load(true);
				}
			}
			else if (!_loadedIsPart && _loaded.IsReady)
			{
				_loadedIsPart = true;
				Grabbable.AddPart(_loaded.transform);
			}
		}

		private void PullTrigger(LAGrabber hand)
		{
			if (InSafeZone)
			{
				Play(dryClip, dryVolume);
				StartCoroutine(SafetyBuzz(hand));
			}
			else if (Fire(hand.player))
			{
				hand.Haptic(fireHapticAmplitude, fireHapticDuration);
			}
			else
			{
				Play(dryClip, dryVolume);
				hand.Haptic(dryHapticAmplitude, dryHapticDuration);
			}
		}

		private IEnumerator SafetyBuzz(LAGrabber hand)
		{
			hand.Haptic(safeZoneHapticAmplitude, safeZoneHapticDuration);
			yield return new WaitForSeconds(safeZoneHapticDuration + safeZoneHapticGap);
			if (hand != null)
			{
				hand.Haptic(safeZoneHapticAmplitude, safeZoneHapticDuration);
			}
		}

		public bool Fire(UnityEngine.Object instigator)
		{
			if (IsProxy || !IsLoaded || InSafeZone || FeeDue)
			{
				return false;
			}
			PumpkinProjectile loaded = _loaded;
			_loaded = null;
			_loadedIsPart = false;
			_reloadLeft = reloadTime;
			Grabbable.RemovePart(loaded.transform);
			Vector3 checkFrom = (breech != null ? breech : transform).position;
			Vector3 direction = socket.forward;
			LAGrabber holder = Grabbable.Holder;
			bool left = holder != null && holder.isLeft;
			PumpkinShot shot = PumpkinNet.BeginLocalShot(left, loaded.transform.position, checkFrom, direction);
			loaded.Launch(direction, checkFrom, transform, instigator, shot);
			PlayFireEffects();
			return true;
		}

		public void FireRemote(PumpkinShot shot)
		{
			if (!IsProxy || shot == null || _retired)
			{
				return;
			}
			PumpkinProjectile projectile = _loaded;
			if (projectile == null || projectile.Current != PumpkinProjectile.State.Docked)
			{
				projectile = PumpkinProjectile.Take(projectilePrefab);
				if (projectile == null)
				{
					return;
				}
				projectile.Dock(socket, 0f);
			}
			_loaded = null;
			_loadedIsPart = false;
			_reloadLeft = reloadTime;
			projectile.LaunchRemote(shot, transform);
			PlayFireEffects();
		}

		private void PlayFireEffects()
		{
			PlayAll(muzzleEffects);
			PlayAll(backblastEffects);
			if (audioSource != null)
			{
				audioSource.pitch = UnityEngine.Random.Range(firePitch.x, firePitch.y);
			}
			Play(fireClip, fireVolume);
		}

		private void Load(bool animated)
		{
			if (projectilePrefab == null || socket == null)
			{
				return;
			}
			_loaded = PumpkinProjectile.Take(projectilePrefab);
			_loadedIsPart = false;
			if (!animated)
			{
				_loaded.Dock(socket, 0f);
				return;
			}
			_loaded.Dock(socket, popDuration);
			if (reloadEffect != null)
			{
				reloadEffect.Play();
			}
			Play(reloadClip, reloadVolume);
			LAGrabber hand = IsProxy ? null : Grabbable.Holder;
			if (hand != null)
			{
				hand.Haptic(reloadHapticAmplitude, reloadHapticDuration);
			}
		}

		public void MakeProxy()
		{
			IsProxy = true;
			returnDelay = 0f;
			LAGrabbable grabbable = Grabbable;
			if (grabbable != null)
			{
				grabbable.enabled = false;
			}
			Rigidbody body = GetComponent<Rigidbody>();
			if (body != null)
			{
				UnityEngine.Object.DestroyImmediate(body);
			}
			Collider[] colliders = GetComponentsInChildren<Collider>(true);
			foreach (Collider c in colliders)
			{
				c.enabled = false;
			}
		}

		public void Retire()
		{
			_retired = true;
			if (_loaded != null && _loaded.body != null)
			{
				_loaded.body.enabled = false;
			}
		}

		public void ReleaseRounds()
		{
			if (!(_loaded == null))
			{
				PumpkinProjectile loaded = _loaded;
				_loaded = null;
				if (loaded.Current == PumpkinProjectile.State.Docked)
				{
					loaded.Recycle();
				}
			}
		}

		private void UpdateReturn()
		{
			if (_returnPop >= 0f)
			{
				UpdateReturnPop();
			}
			if (returnDelay <= 0f)
			{
				return;
			}
			if (Grabbable.IsHeld)
			{
				_looseTime = 0f;
				return;
			}
			_looseTime += Time.deltaTime;
			if (!(_looseTime < returnDelay))
			{
				_looseTime = 0f;
				Vector3 home = (_homeParent != null) ? _homeParent.TransformPoint(_homePosition) : _homePosition;
				if ((transform.position - home).sqrMagnitude > returnMinDistance * returnMinDistance)
				{
					ReturnHome();
				}
			}
		}

		public void SendHome()
		{
			if (IsProxy)
			{
				return;
			}
			for (int i = 0; i < 2; i++)
			{
				if (!(Grabbable.Holder != null))
				{
					break;
				}
				Grabbable.Holder.Release(false);
			}
			_looseTime = 0f;
			ReturnHome();
		}

		private void ReturnHome()
		{
			transform.SetParent(_homeParent, false);
			transform.localPosition = _homePosition;
			transform.localRotation = _homeRotation;
			Rigidbody body = GetComponent<Rigidbody>();
			if (body != null)
			{
				body.position = transform.position;
				body.rotation = transform.rotation;
				if (!body.isKinematic)
				{
					body.linearVelocity = Vector3.zero;
					body.angularVelocity = Vector3.zero;
				}
			}
			Grabbable.enabled = false;
			_returnPop = 0f;
			UpdateReturnPop();
			if (reloadEffect != null)
			{
				reloadEffect.Play();
			}
			Play(reloadClip, reloadVolume);
		}

		private void UpdateReturnPop()
		{
			_returnPop += Time.deltaTime;
			float t = (popDuration > 0f) ? Mathf.Clamp01(_returnPop / popDuration) : 1f;
			transform.localScale = _homeScale * Mathf.Max(PumpkinProjectile.BackOut(t), 0.05f);
			if (!(t < 1f))
			{
				_returnPop = -1f;
				Grabbable.enabled = true;
			}
		}

		private void Play(AudioClip clip, float volume)
		{
			if (audioSource != null && clip != null && volume > 0f)
			{
				audioSource.PlayOneShot(clip, volume);
			}
		}

		private static void PlayAll(ParticleSystem[] systems)
		{
			foreach (ParticleSystem system in systems)
			{
				if (!(system == null))
				{
					system.Clear(true);
					system.Play(true);
				}
			}
		}
	}
}
