using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteAlways]
[ImageEffectAllowedInSceneView]
[DisallowMultipleComponent]
[AddComponentMenu("Slop/Slop Color Grade")]
public class SlopColorGrade : MonoBehaviour
{
	[Header("Tone")]
	[Tooltip("Post exposure in EV stops, same units as the PPv2 slider. 0 = unchanged.")]
	[Range(-5f, 5f)]
	public float postExposure = 1f;

	[Tooltip("PPv2 slider units (-100..100). 0 = neutral.")]
	[Range(-100f, 100f)]
	public float contrast = 5f;

	[Tooltip("PPv2 slider units (-100..100). 0 = neutral, -100 = greyscale.")]
	[Range(-100f, 100f)]
	public float saturation = 5f;

	[Tooltip("0 = off. How much strong reds (blood, a red sign) keep their colour when saturation drains the rest. Driven at runtime by the BTM death cam.")]
	[Range(0f, 1f)]
	public float keepRed;

	[Tooltip("Multiplied into the image. White = neutral. Driven at runtime by effects like the landmine flashbang.")]
	[ColorUsage(false)]
	public Color colorFilter = Color.white;

	[Header("White Balance")]
	[Tooltip("PPv2 slider units (-100..100). Negative = cooler.")]
	[Range(-100f, 100f)]
	public float temperature = -3.5f;

	[Tooltip("PPv2 slider units (-100..100). Green <-> magenta.")]
	[Range(-100f, 100f)]
	public float tint = 0.3f;

	[Header("Scare FX")]
	[Tooltip("0 = off. Reproduces the monster proximity Vignette (old profile used 0.309).")]
	[Range(0f, 1f)]
	public float vignetteIntensity;

	[Range(0.01f, 1f)]
	public float vignetteSmoothness = 1f;

	[ColorUsage(false)]
	public Color vignetteColor = Color.black;

	[Tooltip("0 = off. Reproduces the monster proximity Grain (old profile used 1).")]
	[Range(0f, 1f)]
	public float grainIntensity;

	[Header("Debug")]
	[Tooltip("Bypass the effect without removing the component, for A/B comparison.")]
	public bool bypass;

	[SerializeField]
	[Tooltip("Leave null to auto-find Slop/ColorGrade.")]
	private Shader shader;

	private Material _mat;

	private bool _playerOff;

	private int _hiddenBy;

	private static readonly int IdExposure = Shader.PropertyToID("_Exposure");

	private static readonly int IdContrast = Shader.PropertyToID("_Contrast");

	private static readonly int IdSaturation = Shader.PropertyToID("_Saturation");

	private static readonly int IdKeepRed = Shader.PropertyToID("_KeepRed");

	private static readonly int IdColorBalance = Shader.PropertyToID("_ColorBalance");

	private static readonly int IdColorFilter = Shader.PropertyToID("_ColorFilter");

	private static readonly int IdVigIntensity = Shader.PropertyToID("_VignetteIntensity");

	private static readonly int IdVigSmooth = Shader.PropertyToID("_VignetteSmoothness");

	private static readonly int IdVigColor = Shader.PropertyToID("_VignetteColor");

	private static readonly int IdGrain = Shader.PropertyToID("_GrainIntensity");

	private static readonly int IdGrainTime = Shader.PropertyToID("_GrainTime");

	public bool PlayerWantsGrade
	{
		get
		{
			return !_playerOff;
		}
		set
		{
			_playerOff = !value;
			ApplyEnabled();
		}
	}

	public void Hide()
	{
		_hiddenBy++;
		ApplyEnabled();
	}

	public void Unhide()
	{
		if (_hiddenBy > 0)
		{
			_hiddenBy--;
		}
		ApplyEnabled();
	}

	private void ApplyEnabled()
	{
		base.enabled = !_playerOff && _hiddenBy == 0;
	}

	private void Awake()
	{
		_playerOff = !base.enabled;
	}

	public void CopyFrom(SlopColorGrade other)
	{
		if (!(other == null))
		{
			postExposure = other.postExposure;
			contrast = other.contrast;
			saturation = other.saturation;
			keepRed = other.keepRed;
			colorFilter = other.colorFilter;
			temperature = other.temperature;
			tint = other.tint;
			vignetteIntensity = other.vignetteIntensity;
			vignetteSmoothness = other.vignetteSmoothness;
			vignetteColor = other.vignetteColor;
			grainIntensity = other.grainIntensity;
			bypass = other.bypass;
			if (shader == null)
			{
				shader = other.shader;
			}
		}
	}

	private void OnDisable()
	{
		if (_mat != null)
		{
			if (Application.isPlaying)
			{
				Object.Destroy(_mat);
			}
			else
			{
				Object.DestroyImmediate(_mat);
			}
			_mat = null;
		}
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		if (bypass)
		{
			Graphics.Blit(src, dst);
			return;
		}
		if (shader == null)
		{
			shader = Shader.Find("Slop/ColorGrade");
		}
		if (shader == null || !shader.isSupported)
		{
			Graphics.Blit(src, dst);
			return;
		}
		if (_mat == null)
		{
			_mat = new Material(shader);
			_mat.hideFlags = HideFlags.HideAndDontSave;
		}
		_mat.SetFloat(IdExposure, Mathf.Pow(2f, postExposure));
		_mat.SetFloat(IdContrast, contrast / 100f + 1f);
		_mat.SetFloat(IdSaturation, saturation / 100f + 1f);
		_mat.SetFloat(IdKeepRed, keepRed);
		_mat.SetVector(IdColorBalance, ComputeColorBalance(temperature, tint));
		_mat.SetColor(IdColorFilter, colorFilter);
		_mat.SetFloat(IdVigIntensity, vignetteIntensity);
		_mat.SetFloat(IdVigSmooth, vignetteSmoothness);
		_mat.SetColor(IdVigColor, vignetteColor);
		_mat.SetFloat(IdGrain, grainIntensity);
		_mat.SetFloat(IdGrainTime, (grainIntensity > 0f) ? (Time.unscaledTime * 37f) : 0f);
		Graphics.Blit(src, dst, _mat);
	}

	private static Vector3 ComputeColorBalance(float temperature, float tint)
	{
		float num = temperature / 65f;
		float num2 = tint / 65f;
		float x = 0.31271f - num * ((num < 0f) ? 0.1f : 0.05f);
		float y = StandardIlluminantY(x) + num2 * 0.05f;
		Vector3 vector = new Vector3(0.949237f, 1.03542f, 1.08728f);
		Vector3 vector2 = CIExyToLMS(x, y);
		return new Vector3(vector.x / vector2.x, vector.y / vector2.y, vector.z / vector2.z);
	}

	private static float StandardIlluminantY(float x)
	{
		return 2.87f * x - 3f * x * x - 0.27509507f;
	}

	private static Vector3 CIExyToLMS(float x, float y)
	{
		float num = 1f;
		float num2 = num * x / y;
		float num3 = num * (1f - x - y) / y;
		float x2 = 0.7328f * num2 + 0.4296f * num - 0.1624f * num3;
		float y2 = -0.7036f * num2 + 1.6975f * num + 0.0061f * num3;
		float z = 0.003f * num2 + 0.0136f * num + 0.9834f * num3;
		return new Vector3(x2, y2, z);
	}
}
