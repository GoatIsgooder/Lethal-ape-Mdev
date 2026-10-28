using System;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
[DisallowMultipleComponent]
[DefaultExecutionOrder(10000)]
public class BackroomsFlickerManager : MonoBehaviour
{
	public struct FlickerSample
	{
		public Vector3 center;

		public Vector3 halfExtents;

		public float softness;

		public float brightness;

		public float sqrDist;
	}

	public const int MAX_LIGHTS = 100;

	[Tooltip("Max fixtures dimmed at once (the nearest to the viewer). This is the per-pixel shader loop length — higher = heavier on Quest. You can place far more fixtures than this; only the nearest this-many dim their light pool.")]
	[Range(1f, 100f)]
	public int maxActiveLights = 32;

	[Tooltip("MASTER speed multiplier over every group AND standalone light. Below 1 = slower whole game (0.25 = quarter speed); stacks on top of each group's own Speed. 0 = frozen.")]
	[Range(0f, 2f)]
	public float globalSpeedScale = 1f;

	[Tooltip("Optional viewer transform. Defaults to Camera.main (the HMD). The nearest fixtures to this are the ones uploaded.")]
	public Transform viewer;

	public static float SpeedScale = 1f;

	private static BackroomsFlickerManager _instance;

	private static readonly int IdCount = Shader.PropertyToID("_FlkCount");

	private static readonly int IdCenter = Shader.PropertyToID("_FlkCenter");

	private static readonly int IdExtents = Shader.PropertyToID("_FlkExtents");

	private readonly Vector4[] _center = new Vector4[100];

	private readonly Vector4[] _extents = new Vector4[100];

	private readonly List<FlickerSample> _all = new List<FlickerSample>(256);

	private static readonly Comparison<FlickerSample> SampleCompare = (FlickerSample a, FlickerSample b) => a.sqrDist.CompareTo(b.sqrDist);

	public static void Ensure()
	{
		if (!(_instance != null))
		{
			_instance = UnityEngine.Object.FindFirstObjectByType<BackroomsFlickerManager>();
			if (!(_instance != null))
			{
				_instance = new GameObject("BackroomsFlickerManager").AddComponent<BackroomsFlickerManager>();
			}
		}
	}

	private void OnEnable()
	{
		if (_instance == null)
		{
			_instance = this;
		}
		SpeedScale = globalSpeedScale;
	}

	private void OnValidate()
	{
		SpeedScale = globalSpeedScale;
	}

	private void OnDisable()
	{
		Shader.SetGlobalFloat(IdCount, 0f);
		if (_instance == this)
		{
			_instance = null;
		}
	}

	private void LateUpdate()
	{
		if (_instance == null)
		{
			_instance = this;
		}
		if (_instance != this)
		{
			return;
		}
		SpeedScale = globalSpeedScale;
		Vector3 vector = ViewerPos();
		_all.Clear();
		for (int i = 0; i < BackroomsFlickerGroup.Groups.Count; i++)
		{
			if (BackroomsFlickerGroup.Groups[i] != null)
			{
				BackroomsFlickerGroup.Groups[i].AppendSamples(_all, vector);
			}
		}
		for (int j = 0; j < BackroomsFlickerLight.Active.Count; j++)
		{
			BackroomsFlickerLight backroomsFlickerLight = BackroomsFlickerLight.Active[j];
			if (!(backroomsFlickerLight == null))
			{
				Vector3 position = backroomsFlickerLight.transform.position;
				_all.Add(new FlickerSample
				{
					center = position,
					halfExtents = backroomsFlickerLight.HalfExtents,
					softness = backroomsFlickerLight.softness,
					brightness = backroomsFlickerLight.CurrentBrightness,
					sqrDist = (position - vector).sqrMagnitude
				});
			}
		}
		int count = _all.Count;
		if (count == 0)
		{
			Shader.SetGlobalFloat(IdCount, 0f);
			return;
		}
		int num = Mathf.Clamp(maxActiveLights, 1, 100);
		if (count > num)
		{
			_all.Sort(SampleCompare);
		}
		int num2 = Mathf.Min(num, count);
		for (int k = 0; k < num2; k++)
		{
			FlickerSample flickerSample = _all[k];
			_center[k] = new Vector4(flickerSample.center.x, flickerSample.center.y, flickerSample.center.z, flickerSample.brightness);
			_extents[k] = new Vector4(flickerSample.halfExtents.x, flickerSample.halfExtents.y, flickerSample.halfExtents.z, Mathf.Clamp01(flickerSample.softness));
		}
		for (int l = num2; l < 100; l++)
		{
			_center[l] = new Vector4(0f, 0f, 0f, 1f);
			_extents[l] = new Vector4(0f, 0f, 0f, 1f);
		}
		Shader.SetGlobalVectorArray(IdCenter, _center);
		Shader.SetGlobalVectorArray(IdExtents, _extents);
		Shader.SetGlobalFloat(IdCount, num2);
	}

	private Vector3 ViewerPos()
	{
		if (viewer != null)
		{
			return viewer.position;
		}
		Camera main = Camera.main;
		if (main != null)
		{
			return main.transform.position;
		}
		return base.transform.position;
	}
}
