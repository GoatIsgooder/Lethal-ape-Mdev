using System.Collections;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Rivals.Combat;
using LethalApeR.Rivals.Pooling;
using Locomotion.Scripts;
using Photon.Pun;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;

namespace LethalApeR.Rivals.Weapons
{
	[RequireComponent(typeof(Grabbable))]
	[RequireComponent(typeof(Rigidbody))]
	public class Weapon : MonoBehaviour
	{
		[Header("Data")]
		[Tooltip("The ScriptableObject that defines this weapon. Required.")]
		[SerializeField]
		private WeaponData data;

		[Header("Transforms")]
		[Tooltip("Barrel tip — shots originate here and travel along its forward (+Z). Defaults to this transform.")]
		[SerializeField]
		private Transform muzzle;

		[Tooltip("Visual child that recoil is applied to (so kick doesn't fight the grab PID). Optional.")]
		[SerializeField]
		private Transform recoilPivot;

		[Tooltip("Melee/contact point for swing hit-tests (Melee type). Defaults to muzzle.")]
		[SerializeField]
		private Transform meleeHead;

		[Tooltip("Where spent casings eject from. Point its +Z (blue arrow) in the eject direction (e.g. up/right out of the breech). Falls back to the muzzle if unset.")]
		[SerializeField]
		private Transform casingPort;

		[Header("Hit detection")]
		[Tooltip("Layers a shot/beam can hit. Should include players and environment.")]
		[SerializeField]
		private LayerMask hitMask = -1;

		[Header("Optional feedback")]
		[SerializeField]
		private LineRenderer beamLine;

		[SerializeField]
		private GameObject shieldRoot;

		[Header("Debug / Testing")]
		[Tooltip("Editor-only: press this key in Play mode to fire ONCE even when the weapon isn't grabbed. Lets you verify the projectile/tracer spawns without putting the headset on. Leave at None to disable.")]
		[SerializeField]
		private Key testFireKey;

		private Rigidbody _rb;

		private Grabbable _grabbable;

		private GrabInteractor[] _interactorsCache;

		private GrabInteractor _holder;

		private bool _isHeld;

		private XRNode _node = XRNode.RightHand;

		private AudioSource _audio;

		private int _currentAmmo;

		private int _reserveAmmo;

		private bool _isReloading;

		private float _nextFireTime;

		private int _burstRemaining;

		private bool _triggerWasDown;

		private bool _emptyClickPlayed;

		private float _nextMeleeTime;

		private Vector3 _recoilPosVel;

		private Vector3 _recoilRotVel;

		private Vector3 _recoilPivotRestPos;

		private Quaternion _recoilPivotRestRot;

		private const float TriggerThreshold = 0.5f;

		private float _nextInteractorRescan;

		private Vector3 _lastShotEnd;

		private bool _syncPublished;

		private XRNode _syncNode;

		private float _syncGrabTime;

		private static readonly Collider[] _meleeOverlap = new Collider[16];

		public WeaponData Data => data;

		public int CurrentAmmo => _currentAmmo;

		public int ReserveAmmo => _reserveAmmo;

		public bool IsReloading => _isReloading;

		public bool IsHeld => _isHeld;

		public Transform Muzzle => (muzzle != null) ? muzzle : base.transform;

		public LayerMask HitMask => hitMask;

		public float Range => (data != null) ? data.range : 100f;

		private int LocalActor => PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : (-1);

		private Team LocalTeam
		{
			get
			{
				if (PlayerHealth.TryGet(LocalActor, out var health) && health != null)
				{
					return health.Team;
				}
				return Team.None;
			}
		}

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_grabbable = GetComponent<Grabbable>();
			_audio = GetComponent<AudioSource>();
			if (muzzle == null)
			{
				muzzle = base.transform;
			}
			if (meleeHead == null)
			{
				meleeHead = muzzle;
			}
			if (recoilPivot != null)
			{
				_recoilPivotRestPos = recoilPivot.localPosition;
				_recoilPivotRestRot = recoilPivot.localRotation;
			}
			if (data != null)
			{
				_currentAmmo = data.magazineSize;
				_reserveAmmo = data.reserveAmmo;
			}
			if (shieldRoot != null)
			{
				shieldRoot.SetActive(false);
			}
		}

		public void AllowShoot()
		{
		}

		public void StopAllowShoot()
		{
		}

		private void OnPickedUp()
		{
			_triggerWasDown = false;
			_emptyClickPlayed = false;
			if (data != null && data.type == WeaponType.Shield && shieldRoot != null)
			{
				shieldRoot.SetActive(true);
			}
		}

		private void OnReleased()
		{
			_holder = null;
			_burstRemaining = 0;
			_emptyClickPlayed = false;
			if (beamLine != null)
			{
				beamLine.enabled = false;
			}
			if (shieldRoot != null)
			{
				shieldRoot.SetActive(false);
			}
			if (_syncPublished)
			{
				RivalsHeldWeaponSync.LocalReleased(this);
			}
			_syncPublished = false;
			_syncGrabTime = 0f;
		}

		private void OnDestroy()
		{
			if (_syncPublished)
			{
				RivalsHeldWeaponSync.LocalReleased(this);
			}
		}

		private GrabInteractor FindHoldingInteractor()
		{
			bool flag = _interactorsCache == null || _interactorsCache.Length == 0;
			if (!flag)
			{
				for (int i = 0; i < _interactorsCache.Length; i++)
				{
					if (_interactorsCache[i] == null)
					{
						flag = true;
						break;
					}
				}
			}
			if (flag && Time.time >= _nextInteractorRescan)
			{
				_nextInteractorRescan = Time.time + 1f;
				_interactorsCache = UnityEngine.Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			}
			if (_interactorsCache == null)
			{
				return null;
			}
			for (int j = 0; j < _interactorsCache.Length; j++)
			{
				GrabInteractor grabInteractor = _interactorsCache[j];
				if (!(grabInteractor == null) && grabInteractor.IsGrabbing)
				{
					if (grabInteractor.HeldRigidbody == _rb || grabInteractor.HeldTransform == base.transform)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform != null && grabInteractor.HeldTransform.IsChildOf(base.transform))
					{
						return grabInteractor;
					}
				}
			}
			return null;
		}

		private void Update()
		{
			RecoverRecoil();
			if (data == null)
			{
				return;
			}
			if (PlayerHealth.TryGet(LocalActor, out var health) && health != null && !health.IsAlive)
			{
				if (beamLine != null)
				{
					beamLine.enabled = false;
				}
				_triggerWasDown = false;
				return;
			}
			GrabInteractor grabInteractor = FindHoldingInteractor();
			bool flag = grabInteractor != null;
			if (flag != _isHeld)
			{
				_isHeld = flag;
				if (!flag)
				{
					OnReleased();
					return;
				}
				OnPickedUp();
			}
			else if (!flag)
			{
				return;
			}
			_holder = grabInteractor;
			_node = grabInteractor.node;
			if (_syncPublished)
			{
				if (_syncNode != _node)
				{
					RivalsHeldWeaponSync.LocalGrabbed(this, _node);
					_syncNode = _node;
				}
			}
			else
			{
				if (_syncGrabTime <= 0f)
				{
					_syncGrabTime = Time.time;
				}
				if (Time.time - _syncGrabTime >= 0.35f)
				{
					RivalsHeldWeaponSync.LocalGrabbed(this, _node);
					_syncPublished = true;
					_syncNode = _node;
				}
			}
			float num = ReadTrigger();
			bool flag2 = num >= TriggerThreshold;
			bool rising = flag2 && !_triggerWasDown;
			switch (data.type)
			{
			case WeaponType.Beam:
				TickBeam(flag2);
				break;
			case WeaponType.Melee:
				TickMelee();
				break;
			case WeaponType.Shield:
				break;
			default:
				TickTriggerWeapon(flag2, rising);
				break;
			}
			if (data.UsesAmmo && !_isReloading && _currentAmmo < data.magazineSize && ReadSecondaryButton())
			{
				StartCoroutine(Reload());
			}
			if (!flag2)
			{
				_emptyClickPlayed = false;
			}
			_triggerWasDown = flag2;
		}

		private void TickTriggerWeapon(bool triggerDown, bool rising)
		{
			if (_isReloading)
			{
				return;
			}
			switch (data.fireMode)
			{
			case FireMode.Semi:
				if (rising)
				{
					TryFire();
				}
				break;
			case FireMode.Auto:
				if (triggerDown)
				{
					TryFire();
				}
				break;
			case FireMode.Burst:
				if (rising && _burstRemaining == 0)
				{
					_burstRemaining = data.burstCount;
				}
				if (_burstRemaining > 0)
				{
					TryFire();
				}
				break;
			}
		}

		private void TryFire()
		{
			if (Time.time < _nextFireTime)
			{
				return;
			}
			if (data.UsesAmmo && _currentAmmo <= 0)
			{
				if (!_emptyClickPlayed)
				{
					PlayClip(data.emptySfx);
					_emptyClickPlayed = true;
				}
				if (!_isReloading)
				{
					StartCoroutine(Reload());
				}
				_burstRemaining = 0;
				return;
			}
			_nextFireTime = Time.time + data.SecondsBetweenShots;
			if (data.UsesAmmo)
			{
				_currentAmmo--;
			}
			if (_burstRemaining > 0)
			{
				_burstRemaining--;
			}
			FireOnce();
		}

		[ContextMenu("Test Fire")]
		public void TestFire()
		{
			if (data == null)
			{
				Debug.LogWarning("[Weapon] Test Fire: no WeaponData assigned.", this);
			}
			else
			{
				FireOnce();
			}
		}

		private void FireOnce()
		{
			_lastShotEnd = muzzle.position;
			switch (data.type)
			{
			case WeaponType.HitscanFirearm:
				FireHitscan(1);
				break;
			case WeaponType.Shotgun:
				FireHitscan(Mathf.Max(1, data.pelletCount));
				break;
			case WeaponType.Projectile:
			case WeaponType.Gimmick:
				FireProjectile();
				break;
			case WeaponType.Heal:
				FireHeal();
				break;
			}
			ApplyRecoil();
			PlayMuzzle();
			EjectCasing();
			PlayClip(data.fireSfx);
			Pulse(data.hapticStrength, data.hapticDuration);
			RivalsRemoteFire.NotifyFired(data, muzzle.position, _lastShotEnd);
		}

		private void FireHitscan(int pellets)
		{
			RaycastHit hitInfo = default(RaycastHit);
			for (int i = 0; i < pellets; i++)
			{
				Vector3 vector = ApplySpread(muzzle.forward, data.spreadDegrees);
				if (Physics.Raycast(muzzle.position, vector, out hitInfo, data.range, hitMask, QueryTriggerInteraction.Ignore))
				{
					ResolveDamageHit(hitInfo, vector);
					SpawnTracer(muzzle.position, hitInfo.point);
					_lastShotEnd = hitInfo.point;
					if (data.impactVfxPrefab != null)
					{
						SimplePool.SpawnTimed(data.impactVfxPrefab, hitInfo.point, Quaternion.LookRotation(hitInfo.normal), data.vfxLifetime);
					}
				}
				else
				{
					_lastShotEnd = muzzle.position + vector * data.range;
					SpawnTracer(muzzle.position, _lastShotEnd);
				}
			}
		}

		private void ResolveDamageHit(RaycastHit hit, Vector3 dir)
		{
			IDamageable componentInParent = hit.collider.GetComponentInParent<IDamageable>();
			if (componentInParent != null && componentInParent.IsAlive)
			{
				bool headshot = IsHeadCollider(hit.collider);
				DamageInfo info = DamageInfo.Create(data.damage, LocalActor, data.type, data.displayName, hit.point, hit.normal, headshot, data.headshotMultiplier);
				componentInParent.ApplyDamage(in info);
			}
		}

		private void FireProjectile()
		{
			if (data.projectilePrefab == null)
			{
				return;
			}
			GameObject gameObject = SimplePool.Spawn(data.projectilePrefab, muzzle.position, muzzle.rotation);
			if (!(gameObject == null))
			{
				Projectile component = gameObject.GetComponent<Projectile>();
				if (component == null)
				{
					Debug.LogWarning("[Weapon] projectilePrefab '" + data.projectilePrefab.name + "' has no Projectile component.", this);
					SimplePool.Release(gameObject);
				}
				else
				{
					component.Launch(data, muzzle.position, muzzle.forward, LocalActor, LocalTeam);
				}
			}
		}

		private void FireHeal()
		{
			RaycastHit hitInfo = default(RaycastHit);
			if (!Physics.Raycast(muzzle.position, muzzle.forward, out hitInfo, data.range, hitMask, QueryTriggerInteraction.Ignore))
			{
				return;
			}
			IDamageable componentInParent = hitInfo.collider.GetComponentInParent<IDamageable>();
			if (componentInParent != null && componentInParent.IsAlive && componentInParent.Team.IsSameTeam(LocalTeam))
			{
				componentInParent.ApplyHeal(data.healAmount, LocalActor);
			}
			if (data.impactVfxPrefab != null)
			{
				SimplePool.SpawnTimed(data.impactVfxPrefab, hitInfo.point, Quaternion.LookRotation(hitInfo.normal), data.vfxLifetime);
			}
		}

		private void TickBeam(bool firing)
		{
			RaycastHit hitInfo = default(RaycastHit);
			if (beamLine != null)
			{
				beamLine.enabled = firing;
			}
			if (!firing)
			{
				return;
			}
			Vector3 position = muzzle.position;
			Vector3 forward = muzzle.forward;
			Vector3 position2 = position + forward * data.range;
			if ((data.beamRadius > 0f) ? Physics.SphereCast(position, data.beamRadius, forward, out hitInfo, data.range, hitMask, QueryTriggerInteraction.Ignore) : Physics.Raycast(position, forward, out hitInfo, data.range, hitMask, QueryTriggerInteraction.Ignore))
			{
				position2 = hitInfo.point;
				if (Time.time >= _nextFireTime)
				{
					_nextFireTime = Time.time + data.SecondsBetweenShots;
					ResolveDamageHit(hitInfo, forward);
					Pulse(data.hapticStrength * 0.5f, data.hapticDuration);
					ForkBeam(hitInfo.point, forward);
				}
			}
			if (beamLine != null)
			{
				beamLine.positionCount = 2;
				beamLine.SetPosition(0, position);
				beamLine.SetPosition(1, position2);
			}
		}

		private void ForkBeam(Vector3 from, Vector3 baseDir)
		{
			RaycastHit hitInfo = default(RaycastHit);
			for (int i = 0; i < data.beamForkCount; i++)
			{
				Vector3 vector = ApplySpread(baseDir, 35f);
				if (Physics.Raycast(from, vector, out hitInfo, data.range * 0.5f, hitMask, QueryTriggerInteraction.Ignore))
				{
					ResolveDamageHit(hitInfo, vector);
				}
			}
		}

		private void TickMelee()
		{
			if (Time.time < _nextMeleeTime || ReadControllerSpeed() < data.meleeSwingSpeed)
			{
				return;
			}
			int num = Physics.OverlapSphereNonAlloc(meleeHead.position, data.meleeReach, _meleeOverlap, hitMask, QueryTriggerInteraction.Ignore);
			for (int i = 0; i < num; i++)
			{
				Collider collider = _meleeOverlap[i];
				if (collider == null)
				{
					continue;
				}
				IDamageable componentInParent = collider.GetComponentInParent<IDamageable>();
				if (componentInParent != null && componentInParent.IsAlive)
				{
					bool headshot = IsHeadCollider(collider);
					DamageInfo info = DamageInfo.Create(data.damage, LocalActor, data.type, data.displayName, meleeHead.position, -meleeHead.forward, headshot, data.headshotMultiplier);
					componentInParent.ApplyDamage(in info);
					_nextMeleeTime = Time.time + 0.4f;
					Pulse(data.hapticStrength, data.hapticDuration);
					if (data.impactVfxPrefab != null)
					{
						SimplePool.SpawnTimed(data.impactVfxPrefab, meleeHead.position, Quaternion.identity, data.vfxLifetime);
					}
					break;
				}
			}
		}

		private IEnumerator Reload()
		{
			if (!_isReloading && data.UsesAmmo && _currentAmmo < data.magazineSize && _reserveAmmo != 0)
			{
				_isReloading = true;
				PlayClip(data.reloadSfx);
				yield return new WaitForSeconds(data.reloadTime);
				if (_reserveAmmo < 0)
				{
					_currentAmmo = data.magazineSize;
				}
				else
				{
					int num = Mathf.Min(data.magazineSize - _currentAmmo, _reserveAmmo);
					_reserveAmmo -= num;
					_currentAmmo += num;
				}
				_isReloading = false;
			}
		}

		public void RefillAmmo()
		{
			if (!(data == null))
			{
				_currentAmmo = data.magazineSize;
				_reserveAmmo = data.reserveAmmo;
				_isReloading = false;
			}
		}

		private void ApplyRecoil()
		{
			_recoilPosVel += data.recoil.positionKick;
			_recoilRotVel += data.recoil.rotationKick;
		}

		private void RecoverRecoil()
		{
			if (!(recoilPivot == null))
			{
				float num = ((data != null) ? Mathf.Max(0.01f, data.recoil.recoverySpeed) : 12f);
				_recoilPosVel = Vector3.Lerp(_recoilPosVel, Vector3.zero, num * Time.deltaTime);
				_recoilRotVel = Vector3.Lerp(_recoilRotVel, Vector3.zero, num * Time.deltaTime);
				recoilPivot.localPosition = _recoilPivotRestPos + _recoilPosVel;
				recoilPivot.localRotation = _recoilPivotRestRot * Quaternion.Euler(_recoilRotVel);
			}
		}

		private float ReadTrigger()
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return 0f;
			}
			if (_node != XRNode.LeftHand)
			{
				return instance.RightTriggerValue;
			}
			return instance.LeftTriggerValue;
		}

		private bool ReadSecondaryButton()
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return false;
			}
			if (_node != XRNode.LeftHand)
			{
				return instance.RightSecondaryButton;
			}
			return instance.LeftSecondaryButton;
		}

		private float ReadControllerSpeed()
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return 0f;
			}
			return ((_node == XRNode.LeftHand) ? instance.LeftControllerVelocity : instance.RightControllerVelocity).magnitude;
		}

		private void Pulse(float amp, float dur)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null) && !(amp <= 0f))
			{
				if (_node == XRNode.LeftHand)
				{
					instance.PulseLeft(amp, dur);
				}
				else
				{
					instance.PulseRight(amp, dur);
				}
			}
		}

		private void PlayMuzzle()
		{
			if (data.muzzleFlashPrefab != null)
			{
				SimplePool.SpawnTimed(data.muzzleFlashPrefab, muzzle.position, muzzle.rotation, 0.1f);
			}
		}

		private void EjectCasing()
		{
			if (data.casingPrefab == null)
			{
				return;
			}
			Transform transform = ((casingPort != null) ? casingPort : muzzle);
			GameObject gameObject = SimplePool.SpawnTimed(data.casingPrefab, transform.position, transform.rotation, data.vfxLifetime);
			if (!(gameObject == null))
			{
				Rigidbody component = gameObject.GetComponent<Rigidbody>();
				if (!(component == null))
				{
					component.isKinematic = false;
					component.linearVelocity = (transform.forward + UnityEngine.Random.insideUnitSphere * 0.15f).normalized * data.casingEjectSpeed;
					component.angularVelocity = UnityEngine.Random.insideUnitSphere * (data.casingEjectSpin * Mathf.Deg2Rad);
				}
			}
		}

		private void SpawnTracer(Vector3 from, Vector3 to)
		{
			if (data.tracerPrefab == null)
			{
				return;
			}
			Vector3 vector = to - from;
			Quaternion rotation = ((vector.sqrMagnitude > 1E-06f) ? Quaternion.LookRotation(vector.normalized) : Quaternion.identity);
			GameObject gameObject = UnityEngine.Object.Instantiate(data.tracerPrefab, from, rotation);
			if (!(gameObject == null))
			{
				Tracer tracer = gameObject.GetComponent<Tracer>();
				if (tracer == null)
				{
					tracer = gameObject.AddComponent<Tracer>();
				}
				tracer.Fly(from, to, data.tracerSpeed);
			}
		}

		private void PlayClip(AudioClip clip)
		{
			if (!(clip == null))
			{
				if (_audio != null)
				{
					_audio.PlayOneShot(clip, data.sfxVolume);
				}
				else
				{
					AudioSource.PlayClipAtPoint(clip, muzzle.position, data.sfxVolume);
				}
			}
		}

		private static Vector3 ApplySpread(Vector3 forward, float degrees)
		{
			if (degrees <= 0f)
			{
				return forward;
			}
			float f = degrees * Mathf.Deg2Rad;
			Vector2 vector = UnityEngine.Random.insideUnitCircle * Mathf.Tan(f);
			return Quaternion.LookRotation(forward) * new Vector3(vector.x, vector.y, 1f).normalized;
		}

		public static bool IsHeadCollider(Collider col)
		{
			if (col == null)
			{
				return false;
			}
			if (col.CompareTag("Head"))
			{
				return true;
			}
			return col.name.ToLowerInvariant().Contains("head");
		}

		private void OnDrawGizmosSelected()
		{
			if (data == null)
			{
				return;
			}
			Transform transform = ((muzzle != null) ? muzzle : base.transform);
			switch (data.type)
			{
			case WeaponType.HitscanFirearm:
			case WeaponType.Beam:
				Gizmos.color = Color.red;
				Gizmos.DrawLine(transform.position, transform.position + transform.forward * data.range);
				break;
			case WeaponType.Shotgun:
				DrawSpreadCone(transform, data.spreadDegrees, data.range, Color.red);
				break;
			case WeaponType.Projectile:
			case WeaponType.Gimmick:
				Gizmos.color = Color.red;
				Gizmos.DrawLine(transform.position, transform.position + transform.forward * Mathf.Min(data.range, 20f));
				if (data.explosionRadius > 0f)
				{
					Gizmos.color = new Color(1f, 0.85f, 0f, 0.7f);
					Gizmos.DrawWireSphere(transform.position + transform.forward * 5f, data.explosionRadius);
				}
				break;
			case WeaponType.Melee:
			{
				Transform transform2 = ((meleeHead != null) ? meleeHead : transform);
				Gizmos.color = Color.red;
				Gizmos.DrawWireSphere(transform2.position, data.meleeReach);
				break;
			}
			case WeaponType.Heal:
				Gizmos.color = Color.green;
				Gizmos.DrawLine(transform.position, transform.position + transform.forward * data.range);
				break;
			}
			if (data.casingPrefab != null)
			{
				Transform transform3 = ((casingPort != null) ? casingPort : transform);
				Gizmos.color = Color.cyan;
				Gizmos.DrawWireSphere(transform3.position, 0.012f);
				Gizmos.DrawLine(transform3.position, transform3.position + transform3.forward * 0.12f);
			}
		}

		private static void DrawSpreadCone(Transform m, float halfAngleDeg, float range, Color color)
		{
			Gizmos.color = color;
			float num = Mathf.Tan(halfAngleDeg * Mathf.Deg2Rad);
			for (int i = 0; i < 12; i++)
			{
				float f = (float)i / 12f * Mathf.PI * 2f;
				Vector3 vector = new Vector3(Mathf.Cos(f) * num, Mathf.Sin(f) * num, 1f);
				Vector3 normalized = (Quaternion.LookRotation(m.forward) * vector).normalized;
				Gizmos.DrawLine(m.position, m.position + normalized * range);
			}
		}

		private void OnValidate()
		{
			if (data == null)
			{
				Debug.LogWarning("[Weapon] No WeaponData assigned on '" + base.name + "'.", this);
			}
		}
	}
}
