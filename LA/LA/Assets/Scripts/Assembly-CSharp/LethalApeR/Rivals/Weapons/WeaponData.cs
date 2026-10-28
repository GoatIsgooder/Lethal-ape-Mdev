using System;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	[CreateAssetMenu(fileName = "WeaponData", menuName = "LethalApeR/Rivals/Weapon")]
	public class WeaponData : ScriptableObject
	{
		[Serializable]
		public struct RecoilProfile
		{
			[Tooltip("Local-space positional kick applied to the weapon per shot (m).")]
			public Vector3 positionKick;

			[Tooltip("Local-space rotational kick per shot (degrees).")]
			public Vector3 rotationKick;

			[Tooltip("How fast the weapon recovers to rest after a kick (higher = snappier).")]
			public float recoverySpeed;
		}

		[Header("Identity")]
		public string displayName = "New Weapon";

		[Tooltip("Behaviour category — decides how a shot resolves.")]
		public WeaponType type;

		[Tooltip("Which loadout slot this weapon occupies.")]
		public LoadoutSlot slot;

		[Tooltip("Trigger-to-shot behaviour. Ignored by Melee/Shield.")]
		public FireMode fireMode;

		[Header("Store")]
		[Tooltip("Coins required to permanently unlock. 0 = free/starter weapon.")]
		[Min(0f)]
		public int unlockPrice = 100;

		[Tooltip("If true, the player owns this from the start (price ignored).")]
		public bool unlockedByDefault;

		public Sprite storeIcon;

		[Header("Damage")]
		[Tooltip("Damage per hit (per pellet for shotguns; per tick for beams).")]
		public float damage = 20f;

		[Tooltip("Multiplier applied on a head hit.")]
		public float headshotMultiplier = 2f;

		[Header("Firing")]
		[Tooltip("Rounds per minute. Drives the delay between shots / beam ticks.")]
		[Min(1f)]
		public float fireRate = 600f;

		[Tooltip("Shots in a burst (FireMode.Burst only).")]
		[Min(1f)]
		public int burstCount = 3;

		[Tooltip("Effective range in metres (hitscan/beam raycast length).")]
		[Min(0f)]
		public float range = 100f;

		[Header("Spread (Shotgun / hip-fire)")]
		[Tooltip("Pellets fired per shot. 1 for normal firearms; >1 for shotguns.")]
		[Min(1f)]
		public int pelletCount = 1;

		[Tooltip("Max cone half-angle of spread, in degrees.")]
		[Min(0f)]
		public float spreadDegrees;

		[Header("Ammo")]
		[Tooltip("Rounds per magazine. 0 = no reload needed (melee / infinite).")]
		[Min(0f)]
		public int magazineSize = 30;

		[Tooltip("Total reserve ammo carried. -1 = infinite reserve.")]
		public int reserveAmmo = 120;

		[Tooltip("Seconds to reload a magazine.")]
		[Min(0f)]
		public float reloadTime = 2f;

		[Header("Recoil")]
		public RecoilProfile recoil;

		[Header("Projectile / Explosive (WeaponType.Projectile)")]
		[Tooltip("Pooled projectile prefab — must have a Projectile component.")]
		public GameObject projectilePrefab;

		[Tooltip("Launch speed of the projectile (m/s).")]
		public float projectileSpeed = 30f;

		[Tooltip("Area-of-effect radius for explosion damage (m).")]
		[Min(0f)]
		public float explosionRadius;

		[Header("Beam (WeaponType.Beam)")]
		[Tooltip("Thickness of the beam cast (m). 0 = thin raycast.")]
		[Min(0f)]
		public float beamRadius;

		[Tooltip("Number of additional forks the beam splits into on hit (Lazer Splitter).")]
		[Min(0f)]
		public int beamForkCount;

		[Header("Melee (WeaponType.Melee)")]
		[Tooltip("Minimum controller speed (m/s) for a swing to register a hit.")]
		public float meleeSwingSpeed = 2.5f;

		[Tooltip("Reach of the melee hit check from the weapon head (m).")]
		public float meleeReach = 0.4f;

		[Header("Heal (WeaponType.Heal)")]
		[Tooltip("Heal applied per shot/tick to a friendly target.")]
		public float healAmount = 25f;

		[Header("VR / Feel")]
		[Tooltip("Requires two hands to wield steadily (informational + future stabilisation).")]
		public bool twoHanded;

		[Tooltip("Haptic pulse strength on fire (0-1).")]
		[Range(0f, 1f)]
		public float hapticStrength = 0.5f;

		[Tooltip("Haptic pulse duration on fire (seconds).")]
		public float hapticDuration = 0.06f;

		[Header("Model & Muzzle")]
		[Tooltip("Visual model prefab spawned/equipped for this weapon.")]
		public GameObject modelPrefab;

		[Tooltip("The FUNCTIONAL, grabbable weapon prefab handed to the player at round start (Rigidbody + Grabbable + Collider on the interactable layer + Weapon). If null, the loadout can't physically give this gun — it falls back to modelPrefab and warns.")]
		public GameObject grabbablePrefab;

		[Header("VFX (pooled, local)")]
		public GameObject muzzleFlashPrefab;

		public GameObject impactVfxPrefab;

		public GameObject casingPrefab;

		[Tooltip("Speed (m/s) casings are flung from the casing port. Eject direction = the port transform's forward (+Z).")]
		public float casingEjectSpeed = 2.5f;

		[Tooltip("Random tumble spin applied to ejected casings (deg/s).")]
		public float casingEjectSpin = 720f;

		[Tooltip("Hitscan bullet/streak visual. A mesh flies muzzle→impact; a LineRenderer draws a streak. Damage is still instant.")]
		public GameObject tracerPrefab;

		[Tooltip("How fast the tracer/bullet visual travels (m/s). Higher = snappier. Damage is unaffected (hitscan is instant).")]
		public float tracerSpeed = 150f;

		[Tooltip("Seconds before a spawned one-shot VFX returns to the pool.")]
		public float vfxLifetime = 1.5f;

		[Header("Audio (default Spatialize=0 per project audio rules)")]
		public AudioClip fireSfx;

		public AudioClip reloadSfx;

		public AudioClip emptySfx;

		[Range(0f, 1f)]
		public float sfxVolume = 1f;

		public float SecondsBetweenShots => 60f / Mathf.Max(1f, fireRate);

		public bool IsInfiniteAmmo => magazineSize <= 0 || reserveAmmo < 0;

		public bool UsesAmmo => type != WeaponType.Melee && type != WeaponType.Shield && magazineSize > 0;

		private void OnValidate()
		{
			if (unlockPrice <= 0 && !unlockedByDefault)
			{
				Debug.LogWarning("[WeaponData] '" + base.name + "' has unlockPrice 0 but is not 'unlockedByDefault' — it will be free in the store.", this);
			}
			if (modelPrefab == null)
			{
				Debug.LogWarning("[WeaponData] '" + base.name + "' has no modelPrefab assigned.", this);
			}
			if (type == WeaponType.Projectile && projectilePrefab == null)
			{
				Debug.LogWarning("[WeaponData] '" + base.name + "' is Projectile type but has no projectilePrefab.", this);
			}
			if (type != WeaponType.Projectile && type != WeaponType.Gimmick && projectilePrefab != null)
			{
				Debug.LogWarning(string.Format("[WeaponData] '{0}' is {1} (hitscan) — its 'Projectile Prefab' is IGNORED. ", base.name, type) + "To make a bullet fly, assign that model to 'Tracer Prefab' instead (or change type to Projectile).", this);
			}
			if (type == WeaponType.Shotgun && pelletCount <= 1)
			{
				Debug.LogWarning(string.Format("[WeaponData] '{0}' is Shotgun type but pelletCount is {1}. Set it >1 for spread.", base.name, pelletCount), this);
			}
			if (type == WeaponType.Heal && healAmount <= 0f)
			{
				Debug.LogWarning(string.Format("[WeaponData] '{0}' is Heal type but healAmount is {1}.", base.name, healAmount), this);
			}
			if (fireRate < 1f)
			{
				fireRate = 1f;
			}
		}
	}
}
