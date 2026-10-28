using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[ExecuteAlways]
[DisallowMultipleComponent]
public class BackroomsFlickerLight : MonoBehaviour
{
	public static readonly List<BackroomsFlickerLight> Active = new List<BackroomsFlickerLight>();

	[Header("Influence Region (ellipsoid centred on this fixture)")]
	[Tooltip("Full size of the dimmed ellipsoid in local units (x transform scale) along X/Y/Z. Make it roughly the light pool the fixture casts. Rotation is ignored (region is axis-aligned).")]
	public Vector3 size = new Vector3(4f, 3f, 4f);

	[Tooltip("Edge softness as a fraction of the radius. 0 = crisp ellipsoid edge, 1 = fades all the way from the centre. Higher = softer, less defined region.")]
	[Range(0f, 1f)]
	[FormerlySerializedAs("edgeFade")]
	public float softness = 0.6f;

	[Header("Flicker Curve (independent per fixture)")]
	[Tooltip("Start flickering on Start(). Off = drive manually via StartFlicker()/StopFlicker().")]
	public bool playOnStart = true;

	[Tooltip("Darkest this fixture gets (0 = black, 1 = no change).")]
	[Range(0f, 1f)]
	public float minBrightness = 0.04f;

	[Tooltip("Brightest this fixture gets. Below 1 keeps it permanently dimmer while it flickers.")]
	[Range(0f, 1f)]
	public float maxBrightness = 1f;

	[Tooltip("Flicker rate. Higher = faster/frantic; lower = slower. Go small for a slow, ominous flicker (try 0.2-1). 0 = frozen.")]
	[Min(0f)]
	public float speed = 2f;

	[Tooltip("0 = smooth sine pulse, 1 = chaotic broken-bulb noise.")]
	[Range(0f, 1f)]
	public float irregularity = 0.8f;

	[Tooltip("Contrast of the curve. Higher = snappier on/off, more time spent dark.")]
	[Range(0.25f, 6f)]
	public float sharpness = 2f;

	[Tooltip("Phase seed. 0 = auto-desync from world position (recommended — duplicated fixtures stay out of sync automatically). Set non-zero to pin a specific phase.")]
	public float seed;

	[Header("Fixture Emission (optional — near free)")]
	[Tooltip("If set, this renderer's emission is pulsed with the same flicker via a MaterialPropertyBlock — the visible tube buzzing. Its material needs Emission enabled.")]
	public Renderer emissiveRenderer;

	[Tooltip("Full-brightness emission colour (HDR). Multiplied by the flicker value each frame.")]
	[ColorUsage(false, true)]
	public Color emissionColor = Color.white;

	[Tooltip("Shader colour property to drive (Standard/Bakery use _EmissionColor).")]
	public string emissionProperty = "_EmissionColor";

	[Header("Editor")]
	[Tooltip("Animate the flicker in the Scene view / edit mode for previewing.")]
	public bool previewInEditor = true;

	private bool _flickering;

	private MaterialPropertyBlock _mpb;

	private int _emissionId = -1;

	public float CurrentBrightness { get; private set; } = 1f;

	public Vector3 HalfExtents
	{
		get
		{
			Vector3 lossyScale = base.transform.lossyScale;
			return Vector3.Scale(size, new Vector3(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z))) * 0.5f;
		}
	}

	private void OnEnable()
	{
		if (!Active.Contains(this))
		{
			Active.Add(this);
		}
		BackroomsFlickerManager.Ensure();
		_flickering = !Application.isPlaying || playOnStart;
	}

	private void OnDisable()
	{
		Active.Remove(this);
		CurrentBrightness = 1f;
		ApplyEmission(1f);
	}

	public void StartFlicker()
	{
		_flickering = true;
	}

	public void StopFlicker()
	{
		_flickering = false;
		CurrentBrightness = 1f;
		ApplyEmission(1f);
	}

	private void Update()
	{
		if (!(Application.isPlaying ? _flickering : previewInEditor))
		{
			CurrentBrightness = 1f;
		}
		else
		{
			float num = Time.time * speed * Mathf.Max(BackroomsFlickerManager.SpeedScale, 0f);
			float num2 = ResolveSeed();
			float a = Mathf.Sin(num2 + num * (Mathf.PI * 2f)) * 0.5f + 0.5f;
			float b = Mathf.PerlinNoise(num2, num) * 0.65f + Mathf.PerlinNoise(num2 * 2.137f + 5.3f, num * 2.6f) * 0.35f;
			float f = Mathf.Clamp01(Mathf.Lerp(a, b, irregularity));
			CurrentBrightness = Mathf.Lerp(minBrightness, maxBrightness, Mathf.Pow(f, sharpness));
		}
		ApplyEmission(CurrentBrightness);
	}

	private void ApplyEmission(float mul)
	{
		if (!(emissiveRenderer == null))
		{
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			if (_emissionId < 0)
			{
				_emissionId = Shader.PropertyToID(string.IsNullOrEmpty(emissionProperty) ? "_EmissionColor" : emissionProperty);
			}
			emissiveRenderer.GetPropertyBlock(_mpb);
			_mpb.SetColor(_emissionId, emissionColor * mul);
			emissiveRenderer.SetPropertyBlock(_mpb);
		}
	}

	private float ResolveSeed()
	{
		if (seed != 0f)
		{
			return seed;
		}
		Vector3 position = base.transform.position;
		float num = Mathf.Repeat(Mathf.Abs(position.x * 73.13f + position.y * 179.27f + position.z * 311.79f), 100f);
		if (num > 0.0001f)
		{
			return num;
		}
		return Mathf.Repeat((float)GetInstanceID() * 0.618034f, 100f);
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.matrix = Matrix4x4.TRS(base.transform.position, Quaternion.identity, HalfExtents);
		Gizmos.color = new Color(1f, 0.9f, 0.3f, 0.9f);
		Gizmos.DrawWireSphere(Vector3.zero, 1f);
		Gizmos.color = new Color(1f, 0.9f, 0.3f, 0.25f);
		Gizmos.DrawWireSphere(Vector3.zero, Mathf.Max(1f - softness, 0f));
	}
}
