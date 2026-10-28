using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Rivals.Combat
{
	public class LocalDamageFeedback : MonoBehaviour
	{
		[Header("Vignette (material wired by the scaffolder)")]
		[SerializeField]
		private Material vignetteMaterial;

		public Color vignetteColor = new Color(0.75f, 0.02f, 0.02f, 1f);

		[Tooltip("Flash added per hit before the damage bonus.")]
		public float baseFlash = 0.35f;

		[Tooltip("Extra flash per point of damage (50 dmg → +0.5 at 0.01).")]
		public float flashPerDamage = 0.01f;

		[Tooltip("Headshots sting a little extra.")]
		public float headshotBonus = 0.15f;

		[Range(0f, 1f)]
		public float maxIntensity = 1f;

		[Tooltip("Intensity drained per second — higher = shorter 'bleep'.")]
		public float decayPerSecond = 1.8f;

		[Tooltip("Distance of the vignette quad from the camera (meters).")]
		public float quadDistance = 0.45f;

		[Tooltip("Safety factor on the frustum-fitted quad size (the quad is sized from the camera FOV so the vignette gradient lands on the visible screen edge).")]
		public float coverageMargin = 1.1f;

		[Tooltip("Layer for the vignette quad. Move it to a layer mirror/secondary cameras cull if they pick it up.")]
		public int quadLayer;

		[Header("Sound (2D, local only)")]
		[SerializeField]
		private AudioClip hurtClip;

		[Range(0f, 1f)]
		public float volume = 0.85f;

		[Tooltip("Random pitch ± this per hit so repeats don't machine-gun.")]
		public float pitchJitter = 0.06f;

		[Header("Haptics")]
		[Range(0f, 1f)]
		public float hapticAmplitude = 0.4f;

		public float hapticDuration = 0.1f;

		private GameObject _quad;

		private MeshRenderer _quadRenderer;

		private AudioSource _audio;

		private Camera _cam;

		private MaterialPropertyBlock _mpb;

		private float _intensity;

		private bool _warnedNoMaterial;

		private bool _warnedNoClip;

		private static readonly int IntensityId = Shader.PropertyToID("_Intensity");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private void OnEnable()
		{
			RivalsEvents.OnLocalDamaged += HandleDamaged;
		}

		private void OnDisable()
		{
			RivalsEvents.OnLocalDamaged -= HandleDamaged;
			_intensity = 0f;
			if (_quadRenderer != null)
			{
				_quadRenderer.enabled = false;
			}
		}

		private void HandleDamaged(float amount, bool headshot, int attackerActor)
		{
			EnsureRig();
			_intensity = Mathf.Min(_intensity + baseFlash + flashPerDamage * amount + (headshot ? headshotBonus : 0f), maxIntensity);
			if (_audio != null && hurtClip != null)
			{
				_audio.pitch = 1f + Random.Range(0f - pitchJitter, pitchJitter);
				_audio.PlayOneShot(hurtClip, volume);
			}
			else if (hurtClip == null && !_warnedNoClip)
			{
				_warnedNoClip = true;
				Debug.LogWarning("[LocalDamageFeedback] No hurt AudioClip assigned — getting shot is silent. Assign one on RivalsManagers ▸ LocalDamageFeedback.", this);
			}
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				instance.PulseLeft(hapticAmplitude, hapticDuration);
				instance.PulseRight(hapticAmplitude, hapticDuration);
			}
		}

		private void Update()
		{
			if (_intensity > 0f)
			{
				_intensity = Mathf.Max(0f, _intensity - decayPerSecond * Time.deltaTime);
			}
			if (!EnsureRig())
			{
				return;
			}
			bool flag = _intensity > 0.004f;
			if (_quadRenderer.enabled != flag)
			{
				_quadRenderer.enabled = flag;
			}
			if (flag)
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				_quadRenderer.GetPropertyBlock(_mpb);
				_mpb.SetFloat(IntensityId, _intensity);
				_mpb.SetColor(ColorId, vignetteColor);
				_quadRenderer.SetPropertyBlock(_mpb);
			}
		}

		private bool EnsureRig()
		{
			if (_cam != null && _audio != null && (_quad != null || _warnedNoMaterial))
			{
				return _quad != null;
			}
			GorillaLocomotion.Player player = GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null;
			_cam = (player != null && player.mainCamera != null) ? player.mainCamera : Camera.main;
			if (_cam == null)
			{
				return false;
			}
			if (_audio == null)
			{
				GameObject gameObject = new GameObject("DamageFeedbackAudio");
				gameObject.transform.SetParent(_cam.transform, false);
				_audio = gameObject.AddComponent<AudioSource>();
				_audio.playOnAwake = false;
				_audio.spatialBlend = 0f;
				_audio.spatialize = false;
			}
			Material material = ResolveMaterial();
			if (material == null)
			{
				return false;
			}
			_quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
			_quad.name = "DamageVignette";
			_quad.layer = quadLayer;
			Collider component = _quad.GetComponent<Collider>();
			if (component != null)
			{
				component.enabled = false;
				Object.Destroy(component);
			}
			_quad.transform.SetParent(_cam.transform, false);
			_quad.transform.localPosition = new Vector3(0f, 0f, quadDistance);
			_quad.transform.localRotation = Quaternion.identity;
			float num = 2f * quadDistance * Mathf.Tan(_cam.fieldOfView * 0.5f * Mathf.Deg2Rad);
			float num2 = num * _cam.aspect;
			float num3 = Mathf.Max(num2 + 0.07f, num);
			float num4 = Mathf.Max(coverageMargin, 1f);
			_quad.transform.localScale = new Vector3(num4 * num3, num4 * num3, 1f);
			_quadRenderer = _quad.GetComponent<MeshRenderer>();
			_quadRenderer.sharedMaterial = material;
			_quadRenderer.shadowCastingMode = ShadowCastingMode.Off;
			_quadRenderer.receiveShadows = false;
			_quadRenderer.lightProbeUsage = LightProbeUsage.Off;
			_quadRenderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			_quadRenderer.enabled = false;
			return true;
		}

		private Material ResolveMaterial()
		{
			if (vignetteMaterial != null)
			{
				return vignetteMaterial;
			}
			Shader shader = Shader.Find("LethalApeR/Rivals/DamageVignette");
			if (shader != null)
			{
				vignetteMaterial = new Material(shader);
				return vignetteMaterial;
			}
			if (!_warnedNoMaterial)
			{
				_warnedNoMaterial = true;
				Debug.LogWarning("[LocalDamageFeedback] No vignette material assigned and the DamageVignette shader wasn't found — hurt sound/haptics only.", this);
			}
			return null;
		}
	}
}
