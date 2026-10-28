using System;
using System.Collections.Generic;
using UnityEngine;

public static class LODUtils
{
	private static readonly Dictionary<LODGroup, float[]> TransitionCache = new Dictionary<LODGroup, float[]>();

	public static int GetCurrentLODIndex(LODGroup lodGroup, Camera camera)
	{
		float[] transitions = Transitions(lodGroup);
		float height = RelativeHeight(lodGroup, camera);
		for (int i = 0; i < transitions.Length; i++)
		{
			if (height >= transitions[i])
			{
				return i;
			}
		}
		return lodGroup.lodCount - 1;
	}

	public static void Invalidate(LODGroup lodGroup)
	{
		TransitionCache.Remove(lodGroup);
	}

	private static float[] Transitions(LODGroup group)
	{
		if (TransitionCache.TryGetValue(group, out var value))
		{
			return value;
		}
		LOD[] lODs = group.GetLODs();
		value = new float[lODs.Length];
		for (int i = 0; i < lODs.Length; i++)
		{
			value[i] = lODs[i].screenRelativeTransitionHeight;
		}
		if (TransitionCache.Count > 256)
		{
			List<LODGroup> dead = new List<LODGroup>();
			foreach (LODGroup key in TransitionCache.Keys)
			{
				if (key == null)
				{
					dead.Add(key);
				}
			}
			foreach (LODGroup item in dead)
			{
				TransitionCache.Remove(item);
			}
		}
		TransitionCache[group] = value;
		return value;
	}

	private static float RelativeHeight(LODGroup group, Camera camera)
	{
		Transform transform = group.transform;
		float size = LargestAxis(transform.lossyScale) * group.size;
		if (camera.orthographic)
		{
			return size * 0.5f / camera.orthographicSize;
		}
		float distance = Vector3.Distance(transform.TransformPoint(group.localReferencePoint), camera.transform.position) / QualitySettings.lodBias;
		return size * 0.5f / (distance * MathF.Tan(camera.fieldOfView * 0.5f * Mathf.Deg2Rad));
	}

	private static float LargestAxis(Vector3 scale)
	{
		return Mathf.Max(Mathf.Abs(scale.x), Mathf.Max(Mathf.Abs(scale.y), Mathf.Abs(scale.z)));
	}
}
