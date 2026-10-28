using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.Autumn
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class AutumnBush : MonoBehaviour
	{
		[Header("Volume (local space, scaled by the transform)")]
		[Tooltip("Centre of the detection volume relative to this transform.")]
		public Vector3 centerOffset = new Vector3(0f, 0.6f, 0f);

		[Tooltip("Horizontal radius of the detection cylinder, in metres before scale.")]
		public float radius = 0.9f;

		[Tooltip("Half-height of the detection cylinder, in metres before scale.")]
		public float halfHeight = 0.6f;

		[Header("Retrigger")]
		[Tooltip("Seconds before this bush can pop again for the same player. Stops a player bobbing on the edge of the volume from machine-gunning leaves at the room.")]
		public float reEntryCooldown = 2.5f;

		[Header("Overrides (optional — system defaults are used when empty)")]
		[Tooltip("Leaf burst prefab for this bush only. Leave empty to use the system's.")]
		public GameObject burstPrefabOverride;

		[Tooltip("Tint multiplied into the leaf burst for this bush only. Alpha is ignored.")]
		public Color tint = Color.white;

		[Header("Gizmos")]
		[SerializeField]
		private bool alwaysDrawGizmo;

		public Vector3 WorldCenter { get; private set; }

		public float WorldRadius { get; private set; }

		public float WorldHalfHeight { get; private set; }

		private void OnEnable()
		{
			RefreshCachedVolume();
			AutumnBushSystem.Register(this);
		}

		private void OnDisable()
		{
			AutumnBushSystem.Unregister(this);
		}

		public void RefreshCachedVolume()
		{
			Vector3 lossyScale = base.transform.lossyScale;
			WorldCenter = base.transform.TransformPoint(centerOffset);
			WorldRadius = Mathf.Max(0.01f, radius * Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.z)));
			WorldHalfHeight = Mathf.Max(0.01f, halfHeight * Mathf.Abs(lossyScale.y));
		}

		[ContextMenu("Fit Volume To Renderers")]
		public void FitVolumeToRenderers()
		{
			FitVolumeToRenderers(0.85f, 0.35f);
		}

		public bool FitVolumeToRenderers(float horizontalFill, float topBite)
		{
			Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>(true);
			bool flag = false;
			Bounds bounds = default(Bounds);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				Renderer renderer = componentsInChildren[i];
				if (!(renderer == null) && !(renderer is ParticleSystemRenderer))
				{
					if (!flag)
					{
						bounds = renderer.bounds;
						flag = true;
					}
					else
					{
						bounds.Encapsulate(renderer.bounds);
					}
				}
			}
			if (!flag)
			{
				return false;
			}
			Vector3 lossyScale = base.transform.lossyScale;
			float b = Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.z));
			float b2 = Mathf.Abs(lossyScale.y);
			float num = Mathf.Clamp01(topBite);
			float num2 = bounds.max.y - bounds.size.y * num;
			float y = bounds.min.y;
			centerOffset = base.transform.InverseTransformPoint(new Vector3(bounds.center.x, (y + num2) * 0.5f, bounds.center.z));
			radius = Mathf.Max(0.15f, Mathf.Max(bounds.extents.x, bounds.extents.z) * Mathf.Clamp01(horizontalFill) / Mathf.Max(0.0001f, b));
			halfHeight = Mathf.Max(0.15f, (num2 - y) * 0.5f / Mathf.Max(0.0001f, b2));
			RefreshCachedVolume();
			return true;
		}
	}
}
