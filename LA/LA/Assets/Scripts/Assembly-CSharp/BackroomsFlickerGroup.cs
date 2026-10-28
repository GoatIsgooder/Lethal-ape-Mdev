using System;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
[DisallowMultipleComponent]
public class BackroomsFlickerGroup : MonoBehaviour
{
	private class Fixture
	{
		public Transform transform;

		public Renderer emissive;

		public Color baseEmission;

		public float phase;

		public float speedMul = 1f;

		public float brightness = 1f;
	}

	public static readonly List<BackroomsFlickerGroup> Groups = new List<BackroomsFlickerGroup>();

	[Header("Which children are fixtures")]
	[Tooltip("Treat objects with a Renderer under this transform as fixtures (the light meshes). Off = use every child transform instead.")]
	public bool requireRenderer = true;

	[Tooltip("Include inactive children when scanning.")]
	public bool includeInactive;

	[Tooltip("If set, only children whose name contains this string become fixtures (e.g. \"Light\"). Empty = all of them.")]
	public string nameContains = "";

	[Header("Influence region per fixture (ellipsoid)")]
	[Tooltip("Full size of each fixture's dimmed ellipsoid (local units x that fixture's scale). Roughly the light pool it casts.")]
	public Vector3 size = new Vector3(4f, 3f, 4f);

	[Tooltip("Edge softness, 0..1 of the radius. 0 = crisp rounded edge, 1 = fades from the centre.")]
	[Range(0f, 1f)]
	public float softness = 0.6f;

	[Header("Flicker curve (shared; phase is per-fixture)")]
	public bool playOnStart = true;

	[Tooltip("Darkest a fixture gets (0 = black, 1 = no change).")]
	[Range(0f, 1f)]
	public float minBrightness = 0.04f;

	[Range(0f, 1f)]
	public float maxBrightness = 1f;

	[Tooltip("Flicker rate for the whole group. Lower = slower (try 0.2-1 for a slow, ominous flicker). 0 = frozen.")]
	[Min(0f)]
	public float speed = 2f;

	[Tooltip("Random +/- variation in rate per fixture so they drift apart over time (0 = all the same rate).")]
	[Range(0f, 1f)]
	public float speedJitter = 0.15f;

	[Tooltip("0 = smooth pulse, 1 = chaotic broken-bulb noise.")]
	[Range(0f, 1f)]
	public float irregularity = 0.8f;

	[Tooltip("Contrast of the curve. Higher = snappier on/off, more time spent dark.")]
	[Range(0.25f, 6f)]
	public float sharpness = 2f;

	[Header("Fixture emission (optional)")]
	[Tooltip("Pulse each fixture's emission with its flicker (the visible tube buzzing). Reads each material's base emission colour. Materials need Emission enabled.")]
	public bool driveEmission = true;

	public string emissionProperty = "_EmissionColor";

	[Header("Editor")]
	public bool previewInEditor = true;

	private readonly List<Fixture> _fixtures = new List<Fixture>();

	private MaterialPropertyBlock _mpb;

	private int _emissionId = -1;

	private bool _flickering;

	public int FixtureCount => _fixtures.Count;

	private void OnEnable()
	{
		if (!Groups.Contains(this))
		{
			Groups.Add(this);
		}
		BackroomsFlickerManager.Ensure();
		_flickering = !Application.isPlaying || playOnStart;
		RebuildFixtures();
	}

	private void OnDisable()
	{
		Groups.Remove(this);
		RestoreEmission();
	}

	public void StartFlicker()
	{
		_flickering = true;
	}

	public void StopFlicker()
	{
		_flickering = false;
		ResetBrightness();
		RestoreEmission();
	}

	private void ResetBrightness()
	{
		for (int i = 0; i < _fixtures.Count; i++)
		{
			_fixtures[i].brightness = 1f;
		}
	}

	[ContextMenu("Rebuild Fixture List")]
	public void RebuildFixtures()
	{
		_fixtures.Clear();
		if (_emissionId < 0)
		{
			_emissionId = Shader.PropertyToID(string.IsNullOrEmpty(emissionProperty) ? "_EmissionColor" : emissionProperty);
		}
		if (requireRenderer)
		{
			Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>(includeInactive);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				TryAdd(componentsInChildren[i].transform, componentsInChildren[i]);
			}
		}
		else
		{
			Transform[] componentsInChildren2 = GetComponentsInChildren<Transform>(includeInactive);
			foreach (Transform transform in componentsInChildren2)
			{
				TryAdd(transform, transform.GetComponent<Renderer>());
			}
		}
		for (int k = 0; k < _fixtures.Count; k++)
		{
			Fixture fixture = _fixtures[k];
			Vector3 position = fixture.transform.position;
			fixture.phase = Hash01(position, (float)k * 1.37f) * 100f;
			fixture.speedMul = 1f + (Hash01(position, (float)k * 1.37f + 50f) - 0.5f) * 2f * speedJitter;
		}
	}

	private void TryAdd(Transform t, Renderer r)
	{
		if (t == base.transform || t.GetComponent<BackroomsFlickerLight>() != null || (!string.IsNullOrEmpty(nameContains) && t.name.IndexOf(nameContains, StringComparison.Ordinal) < 0))
		{
			return;
		}
		Fixture fixture = new Fixture
		{
			transform = t
		};
		if (driveEmission && r != null)
		{
			fixture.emissive = r;
			Material sharedMaterial = r.sharedMaterial;
			fixture.baseEmission = ((sharedMaterial != null && sharedMaterial.HasProperty(_emissionId)) ? sharedMaterial.GetColor(_emissionId) : Color.black);
		}
		_fixtures.Add(fixture);
	}

	private void Update()
	{
		if (!(Application.isPlaying ? _flickering : previewInEditor))
		{
			ResetBrightness();
			RestoreEmission();
			return;
		}
		if (!Application.isPlaying && _fixtures.Count == 0)
		{
			RebuildFixtures();
		}
		float time = Time.time;
		for (int i = 0; i < _fixtures.Count; i++)
		{
			Fixture fixture = _fixtures[i];
			if (!(fixture.transform == null))
			{
				float num = time * speed * fixture.speedMul * Mathf.Max(BackroomsFlickerManager.SpeedScale, 0f);
				float num2 = Mathf.Sin(fixture.phase + num * (Mathf.PI * 2f)) * 0.5f + 0.5f;
				float num3 = Mathf.PerlinNoise(fixture.phase, num) * 0.65f + Mathf.PerlinNoise(fixture.phase * 2.137f + 5.3f, num * 2.6f) * 0.35f;
				float f = Mathf.Clamp01(Mathf.Lerp(num2, num3, irregularity));
				fixture.brightness = Mathf.Lerp(minBrightness, maxBrightness, Mathf.Pow(f, sharpness));
				DriveEmission(fixture, fixture.brightness);
			}
		}
	}

	private void DriveEmission(Fixture f, float mul)
	{
		if (!(f.emissive == null))
		{
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			f.emissive.GetPropertyBlock(_mpb);
			_mpb.SetColor(_emissionId, f.baseEmission * mul);
			f.emissive.SetPropertyBlock(_mpb);
		}
	}

	private void RestoreEmission()
	{
		if (_fixtures.Count == 0)
		{
			return;
		}
		if (_mpb == null)
		{
			_mpb = new MaterialPropertyBlock();
		}
		for (int i = 0; i < _fixtures.Count; i++)
		{
			Fixture fixture = _fixtures[i];
			if (!(fixture.emissive == null) && !(fixture.transform == null))
			{
				fixture.emissive.GetPropertyBlock(_mpb);
				_mpb.SetColor(_emissionId, fixture.baseEmission);
				fixture.emissive.SetPropertyBlock(_mpb);
			}
		}
	}

	public void AppendSamples(List<BackroomsFlickerManager.FlickerSample> into, Vector3 viewer)
	{
		for (int i = 0; i < _fixtures.Count; i++)
		{
			Fixture fixture = _fixtures[i];
			if (!(fixture.transform == null))
			{
				Vector3 position = fixture.transform.position;
				Vector3 lossyScale = fixture.transform.lossyScale;
				into.Add(new BackroomsFlickerManager.FlickerSample
				{
					center = position,
					halfExtents = Vector3.Scale(new Vector3(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z)), size) * 0.5f,
					softness = softness,
					brightness = fixture.brightness,
					sqrDist = (position - viewer).sqrMagnitude
				});
			}
		}
	}

	private static float Hash01(Vector3 p, float salt)
	{
		float num = Mathf.Abs(p.x * 73.13f + p.y * 179.27f + p.z * 311.79f + salt * 97.41f);
		return num - Mathf.Floor(num);
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.color = new Color(1f, 0.9f, 0.3f, 0.5f);
		for (int i = 0; i < _fixtures.Count; i++)
		{
			Fixture fixture = _fixtures[i];
			if (!(fixture.transform == null))
			{
				Vector3 lossyScale = fixture.transform.lossyScale;
				Vector3 s = Vector3.Scale(new Vector3(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z)), size) * 0.5f;
				Gizmos.matrix = Matrix4x4.TRS(fixture.transform.position, Quaternion.identity, s);
				Gizmos.DrawWireSphere(Vector3.zero, 1f);
			}
		}
	}
}
