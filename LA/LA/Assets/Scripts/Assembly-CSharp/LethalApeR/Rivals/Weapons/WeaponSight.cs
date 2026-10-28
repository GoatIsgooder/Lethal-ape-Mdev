using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	public class WeaponSight : MonoBehaviour
	{
		public enum BillboardMode
		{
			FaceCameraPosition = 0,
			MatchCameraRotation = 1
		}

		[Header("Source")]
		[Tooltip("Weapon this sight belongs to. Auto-found on this GameObject / parent if left empty.")]
		[SerializeField]
		private Weapon weapon;

		[Tooltip("Override the ray origin. Defaults to the Weapon's Muzzle, else this transform.")]
		[SerializeField]
		private Transform muzzleOverride;

		[Tooltip("Layers the aim ray can land on. If empty (Nothing), falls back to the Weapon's hit mask.")]
		[SerializeField]
		private LayerMask aimMask = 0;

		[Tooltip("Max aim distance. <= 0 uses the Weapon's range.")]
		[SerializeField]
		private float maxDistance;

		[Tooltip("Only show the visuals while the weapon is held. Off = always on (handy for testing).")]
		[SerializeField]
		private bool onlyWhenHeld = true;

		[Header("Aim Reticle (optional)")]
		[Tooltip("Mesh placed at the aim point. A Quad with the Slop/AimReticle material.")]
		[SerializeField]
		private Transform reticle;

		[Tooltip("Face the reticle toward the player camera each frame.")]
		[SerializeField]
		private bool reticleBillboard = true;

		[Tooltip("How it faces the camera. MatchCameraRotation keeps it perfectly square-on to your view from any angle (best looking).")]
		[SerializeField]
		private BillboardMode reticleBillboardMode = BillboardMode.MatchCameraRotation;

		[Tooltip("Keep the reticle a constant on-screen size regardless of distance.")]
		[SerializeField]
		private bool reticleConstantScreenSize = true;

		[Tooltip("Reticle size. Constant-screen-size: size per metre of distance. Else: fixed world size.")]
		[SerializeField]
		private float reticleSize = 0.03f;

		[Header("Laser Pointer (optional)")]
		[Tooltip("Beam mesh that simply appears while the weapon is held. Place, aim, scale and length it in the prefab (as a child pointing out the barrel) — the script does NOT move, rotate or scale it, it only shows/hides it. Leave empty for no laser.")]
		[SerializeField]
		private Transform laser;

		private Camera _cam;

		private bool _camIsFallback;

		private void Awake()
		{
			if (weapon == null)
			{
				weapon = GetComponentInParent<Weapon>();
			}
			SetVisible(on: false);
		}

		private void OnEnable()
		{
			CacheCamera();
		}

		private void OnDisable()
		{
			SetVisible(on: false);
		}

		private void LateUpdate()
		{
			bool flag = !onlyWhenHeld || (weapon != null && weapon.IsHeld) || weapon == null;
			if (!flag)
			{
				SetVisible(on: false);
				return;
			}
			Transform transform = ResolveMuzzle();
			if (transform == null)
			{
				SetVisible(on: false);
				return;
			}
			if (_cam == null || _camIsFallback)
			{
				CacheCamera();
			}
			float range = ((maxDistance > 0f) ? maxDistance : ((weapon != null) ? weapon.Range : 100f));
			LayerMask layerMask = ((aimMask.value != 0) ? aimMask : ((weapon != null) ? weapon.HitMask : ((LayerMask)(-1))));
			Vector3 position = transform.position;
			Vector3 forward = transform.forward;
			if (laser != null && !laser.gameObject.activeSelf)
			{
				laser.gameObject.SetActive(value: true);
			}
			if (RaycastIgnoringSelf(position, forward, range, (int)layerMask & -5, out var best))
			{
				if (reticle != null && !reticle.gameObject.activeSelf)
				{
					reticle.gameObject.SetActive(value: true);
				}
				UpdateReticle(best.point);
			}
			else if (reticle != null && reticle.gameObject.activeSelf)
			{
				reticle.gameObject.SetActive(value: false);
			}
		}

		private void UpdateReticle(Vector3 at)
		{
			if (reticle == null)
			{
				return;
			}
			reticle.position = at;
			if (reticleBillboard && _cam != null)
			{
				reticle.rotation = FaceCamera(at, reticleBillboardMode);
			}
			float num = reticleSize;
			if (reticleConstantScreenSize && _cam != null)
			{
				num = reticleSize * Vector3.Distance(_cam.transform.position, at);
			}
			reticle.localScale = new Vector3(num, num, num);
		}

		private Quaternion FaceCamera(Vector3 worldPos, BillboardMode mode)
		{
			if (mode == BillboardMode.MatchCameraRotation)
			{
				return _cam.transform.rotation;
			}
			return Quaternion.LookRotation(worldPos - _cam.transform.position, _cam.transform.up);
		}

		private Transform ResolveMuzzle()
		{
			if (muzzleOverride != null)
			{
				return muzzleOverride;
			}
			if (weapon != null)
			{
				return weapon.Muzzle;
			}
			return base.transform;
		}

		private bool RaycastIgnoringSelf(Vector3 from, Vector3 dir, float range, LayerMask mask, out RaycastHit best)
		{
			best = default(RaycastHit);
			Transform transform = ((weapon != null) ? weapon.transform : base.transform);
			Transform transform2 = ((Player.HasInstance && Player.Instance != null) ? Player.Instance.transform : null);
			float num = 0f;
			int num2 = 0;
			while (num < range)
			{
				if (!Physics.Raycast(from, dir, out var hitInfo, range - num, mask, QueryTriggerInteraction.Ignore))
				{
					return false;
				}
				Transform transform3 = hitInfo.collider.transform;
				if (!transform3.IsChildOf(transform) && (!(transform2 != null) || !transform3.IsChildOf(transform2)))
				{
					best = hitInfo;
					best.distance = num + hitInfo.distance;
					return true;
				}
				if (num2 > 10)
				{
					return false;
				}
				num2++;
				float num3 = hitInfo.distance + 0.01f;
				from += dir * num3;
				num += num3;
			}
			return false;
		}

		private void CacheCamera()
		{
			Player player = (Player.HasInstance ? Player.Instance : null);
			if (player != null && player.mainCamera != null)
			{
				_cam = player.mainCamera;
				_camIsFallback = false;
				return;
			}
			_camIsFallback = true;
			_cam = Camera.main;
			if (_cam != null)
			{
				return;
			}
			Camera[] array = Object.FindObjectsByType<Camera>(FindObjectsSortMode.None);
			foreach (Camera camera in array)
			{
				if (camera.isActiveAndEnabled && camera.targetTexture == null)
				{
					_cam = camera;
					break;
				}
			}
		}

		private void SetVisible(bool on)
		{
			if (reticle != null && reticle.gameObject.activeSelf != on)
			{
				reticle.gameObject.SetActive(on);
			}
			if (laser != null && laser.gameObject.activeSelf != on)
			{
				laser.gameObject.SetActive(on);
			}
		}
	}
}
