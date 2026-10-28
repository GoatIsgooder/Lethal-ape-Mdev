using UnityEngine;

namespace LethalApeR.SpiderApe
{
	[DisallowMultipleComponent]
	public class SpiderApeReticle : MonoBehaviour
	{
		public enum BillboardMode
		{
			MatchCameraRotation = 0,
			FaceCameraPosition = 1
		}

		[Header("Source")]
		[Tooltip("Shooter whose aim this crosshair shows. Auto-found on the parent if left empty.")]
		[SerializeField]
		private SpiderApeWebShooter shooter;

		[Header("Placement")]
		[Tooltip("Off = shrinks with distance like a real object. On = same apparent size at any range, which is what you want from a crosshair.")]
		[SerializeField]
		private bool constantScreenSize = true;

		[Tooltip("Constant-screen-size: quad size per metre of distance. Otherwise: metres.")]
		[SerializeField]
		private float size = 0.035f;

		[SerializeField]
		private BillboardMode billboard;

		[Tooltip("Exponential smoothing on the crosshair position, per second. Hand tracking jitter is ~1mm at the wrist but centimetres at 40m — without this the crosshair visibly shivers. 0 disables.")]
		[SerializeField]
		private float positionSmoothing = 25f;

		[Tooltip("Pull the crosshair this far off the surface along its normal, so it doesn't z-fight or look half-buried in the wall.")]
		[SerializeField]
		private float surfaceOffset = 0.01f;

		[Header("Colours")]
		[Tooltip("Nothing webbable in range — the crosshair hides. Turn off to keep it visible at max range instead.")]
		[SerializeField]
		private bool hideOnMiss = true;

		[Tooltip("Valid target, ready to fire.")]
		[SerializeField]
		private Color readyColor = new Color(1f, 1f, 1f, 0.95f);

		[Tooltip("This hand's web is already stuck — dimmed, because you're looking for the NEXT anchor.")]
		[SerializeField]
		private Color attachedColor = new Color(0.45f, 0.85f, 1f, 0.5f);

		[Tooltip("Colour/alpha property on the reticle material. Matches Slop/WebReticle.")]
		[SerializeField]
		private string colorProperty = "_Color";

		[Header("Feedback")]
		[Tooltip("Size punch when a web lands, in fractions of normal size. 0 disables.")]
		[SerializeField]
		private float attachPunch = 0.6f;

		[SerializeField]
		private float punchDecay = 7f;

		private Renderer _renderer;

		private MaterialPropertyBlock _mpb;

		private int _colorId;

		private Camera _cam;

		private bool _camIsFallback;

		private Vector3 _smoothed;

		private bool _smoothValid;

		private float _punch;

		private bool _wasAttached;

		private float _scaleComp = 1f;

		private Collider _lastAimCollider;

		private void Awake()
		{
			_renderer = GetComponentInChildren<Renderer>();
			_mpb = new MaterialPropertyBlock();
			_colorId = Shader.PropertyToID(string.IsNullOrEmpty(colorProperty) ? "_Color" : colorProperty);
			if (shooter == null)
			{
				shooter = GetComponentInParent<SpiderApeWebShooter>();
			}
			SetVisible(false);
		}

		private void OnEnable()
		{
			Transform transform = ((GorillaLocomotion.Player.HasInstance && GorillaLocomotion.Player.Instance != null) ? GorillaLocomotion.Player.Instance.transform : null);
			if (base.transform.parent != transform)
			{
				base.transform.SetParent(transform, true);
			}
			Vector3 vector = ((base.transform.parent != null) ? base.transform.parent.lossyScale : Vector3.one);
			_scaleComp = ((Mathf.Abs(vector.x) > 0.0001f) ? (1f / vector.x) : 1f);
			CacheCamera();
		}

		private void OnDisable()
		{
			SetVisible(false);
		}

		private void LateUpdate()
		{
			if (shooter == null || !shooter.isActiveAndEnabled)
			{
				SetVisible(false);
				return;
			}
			if (_cam == null || _camIsFallback)
			{
				CacheCamera();
			}
			if (_cam == null)
			{
				SetVisible(false);
				return;
			}
			if (!shooter.TryGetAim(out var point, out var normal, out var _))
			{
				if (hideOnMiss)
				{
					SetVisible(false);
					_smoothValid = false;
					return;
				}
				point = shooter.AimOrigin + shooter.AimDirection * shooter.MaxRange;
				normal = -_cam.transform.forward;
			}
			Vector3 vector = point + normal * surfaceOffset;
			Collider aimCollider = shooter.AimCollider;
			if (aimCollider != _lastAimCollider)
			{
				_smoothValid = false;
				_lastAimCollider = aimCollider;
			}
			if (positionSmoothing > 0f && _smoothValid)
			{
				_smoothed = Vector3.Lerp(_smoothed, vector, 1f - Mathf.Exp((0f - positionSmoothing) * Time.deltaTime));
			}
			else
			{
				_smoothed = vector;
			}
			_smoothValid = true;
			SetVisible(true);
			base.transform.position = _smoothed;
			base.transform.rotation = ((billboard == BillboardMode.MatchCameraRotation) ? _cam.transform.rotation : Quaternion.LookRotation(_smoothed - _cam.transform.position, _cam.transform.up));
			bool isAttached = shooter.IsAttached;
			if (isAttached && !_wasAttached)
			{
				_punch = attachPunch;
			}
			_wasAttached = isAttached;
			if (_punch > 0f)
			{
				_punch = Mathf.MoveTowards(_punch, 0f, punchDecay * Time.deltaTime);
			}
			float num = size;
			if (constantScreenSize)
			{
				num *= Vector3.Distance(_cam.transform.position, _smoothed);
			}
			float num2 = num * ((1f + _punch) * _scaleComp);
			base.transform.localScale = new Vector3(num2, num2, num2);
			SetColor(isAttached ? attachedColor : readyColor);
		}

		private void SetColor(Color c)
		{
			if (!(_renderer == null))
			{
				_renderer.GetPropertyBlock(_mpb);
				_mpb.SetColor(_colorId, c);
				_renderer.SetPropertyBlock(_mpb);
			}
		}

		private void SetVisible(bool on)
		{
			if (_renderer != null && _renderer.enabled != on)
			{
				_renderer.enabled = on;
			}
		}

		private void CacheCamera()
		{
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
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
	}
}
