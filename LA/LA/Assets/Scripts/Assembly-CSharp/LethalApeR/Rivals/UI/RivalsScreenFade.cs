using GorillaLocomotion;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Rivals.UI
{
	public class RivalsScreenFade : MonoBehaviour
	{
		[Header("Look (material wired by the scaffolder)")]
		[SerializeField]
		private Material fadeMaterial;

		public Color fadeColor = new Color(0f, 0f, 0f, 1f);

		[Header("Quad")]
		[Tooltip("Distance of the fade quad from the camera (meters).")]
		public float quadDistance = 0.4f;

		[Tooltip("Safety factor on the frustum-fitted quad size.")]
		public float coverageMargin = 1.1f;

		[Tooltip("Layer for the quad — move it if mirror/secondary cameras pick it up.")]
		public int quadLayer;

		private GameObject _quad;

		private MeshRenderer _quadRenderer;

		private Camera _cam;

		private MaterialPropertyBlock _mpb;

		private bool _warnedNoMaterial;

		private float _alpha;

		private float _target;

		private float _speed = 10f;

		private float _delayLeft = -1f;

		private float _delayedTarget;

		private float _delayedDuration;

		private static readonly int IntensityId = Shader.PropertyToID("_Intensity");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		public static RivalsScreenFade Instance { get; private set; }

		public bool IsDark => _alpha >= 0.95f;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void FadeTo(float target, float duration)
		{
			CancelScheduled();
			StartFade(target, duration);
		}

		public void FadeOut(float duration)
		{
			FadeTo(1f, duration);
		}

		public void FadeIn(float duration)
		{
			FadeTo(0f, duration);
		}

		public void ScheduleFade(float delay, float target, float duration)
		{
			_delayLeft = Mathf.Max(0f, delay);
			_delayedTarget = target;
			_delayedDuration = duration;
		}

		public void ScheduleFadeOut(float delay, float duration)
		{
			ScheduleFade(delay, 1f, duration);
		}

		public void CancelScheduled()
		{
			_delayLeft = -1f;
		}

		public void Clear(float duration = 0.4f)
		{
			FadeIn(duration);
		}

		private void StartFade(float target, float duration)
		{
			_target = Mathf.Clamp01(target);
			_speed = 1f / Mathf.Max(duration, 0.01f);
		}

		private void Update()
		{
			if (_delayLeft >= 0f)
			{
				_delayLeft -= Time.deltaTime;
				if (_delayLeft < 0f)
				{
					StartFade(_delayedTarget, _delayedDuration);
				}
			}
			_alpha = Mathf.MoveTowards(_alpha, _target, _speed * Time.deltaTime);
			if (!EnsureRig())
			{
				return;
			}
			bool visible = _alpha > 0.002f;
			if (_quadRenderer.enabled != visible)
			{
				_quadRenderer.enabled = visible;
			}
			if (visible)
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				_quadRenderer.GetPropertyBlock(_mpb);
				_mpb.SetFloat(IntensityId, _alpha);
				_mpb.SetColor(ColorId, fadeColor);
				_quadRenderer.SetPropertyBlock(_mpb);
			}
		}

		private bool EnsureRig()
		{
			if (_quad != null && _cam != null)
			{
				return true;
			}
			Player player = (Player.HasInstance ? Player.Instance : null);
			_cam = ((player != null && player.mainCamera != null) ? player.mainCamera : Camera.main);
			if (_cam == null)
			{
				return false;
			}
			Material material = ResolveMaterial();
			if (material == null)
			{
				return false;
			}
			_quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
			_quad.name = "ScreenFade";
			_quad.layer = quadLayer;
			Collider collider = _quad.GetComponent<Collider>();
			if (collider != null)
			{
				collider.enabled = false;
				Object.Destroy(collider);
			}
			_quad.transform.SetParent(_cam.transform, worldPositionStays: false);
			_quad.transform.localPosition = new Vector3(0f, 0f, quadDistance);
			_quad.transform.localRotation = Quaternion.identity;
			float height = 2f * quadDistance * Mathf.Tan(_cam.fieldOfView * 0.5f * Mathf.Deg2Rad);
			float size = Mathf.Max(height * _cam.aspect + 0.07f, height);
			float margin = Mathf.Max(coverageMargin, 1f);
			_quad.transform.localScale = new Vector3(margin * size, margin * size, 1f);
			_quadRenderer = _quad.GetComponent<MeshRenderer>();
			_quadRenderer.material = material;
			_quadRenderer.shadowCastingMode = ShadowCastingMode.Off;
			_quadRenderer.receiveShadows = false;
			_quadRenderer.lightProbeUsage = LightProbeUsage.Off;
			_quadRenderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			_quadRenderer.enabled = false;
			return true;
		}

		private Material ResolveMaterial()
		{
			if (fadeMaterial != null)
			{
				return fadeMaterial;
			}
			Shader shader = Shader.Find("LethalApeR/Rivals/ScreenFade");
			if (shader != null)
			{
				fadeMaterial = new Material(shader);
				return fadeMaterial;
			}
			if (!_warnedNoMaterial)
			{
				_warnedNoMaterial = true;
				Debug.LogWarning("[RivalsScreenFade] No fade material assigned and the ScreenFade shader wasn't found — round transitions will cut instead of fade.", this);
			}
			return null;
		}
	}
}
