using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class KevinRiftAnchor : MonoBehaviour
	{
		public const float PadRing = 1.55f;

		public const float PadRadius = 0.55f;

		public const int PadCount = 3;

		public const int MaxVortexes = 5;

		[Tooltip("Ground under each pad, as a local Y offset from the anchor (baked).")]
		public float[] padHeights = new float[3];

		[Tooltip("Where zombies climb out (world space, on the navmesh; baked).")]
		public Vector3[] vortexPoints = new Vector3[0];

		[Tooltip("Optional display name for logs and the dev panel.")]
		public string label;

		private static readonly List<KevinRiftAnchor> Live = new List<KevinRiftAnchor>();

		private static readonly List<KevinRiftAnchor> Sorted = new List<KevinRiftAnchor>();

		private static bool _dirty = true;

		public static List<KevinRiftAnchor> All
		{
			get
			{
				if (_dirty)
				{
					_dirty = false;
					Sorted.Clear();
					Sorted.AddRange(Live);
					Sorted.Sort((KevinRiftAnchor a, KevinRiftAnchor b) => string.CompareOrdinal(a.name, b.name));
				}
				return Sorted;
			}
		}

		public int VortexCount
		{
			get
			{
				if (vortexPoints == null)
				{
					return 0;
				}
				return Mathf.Min(vortexPoints.Length, 5);
			}
		}

		public string Label
		{
			get
			{
				if (!string.IsNullOrEmpty(label))
				{
					return label;
				}
				return name;
			}
		}

		private void OnEnable()
		{
			if (!Live.Contains(this))
			{
				Live.Add(this);
			}
			_dirty = true;
		}

		private void OnDisable()
		{
			Live.Remove(this);
			_dirty = true;
		}

		public static KevinRiftAnchor Get(int index)
		{
			List<KevinRiftAnchor> all = All;
			if (index < 0 || index >= all.Count)
			{
				return null;
			}
			return all[index];
		}

		public Vector3 PadPosition(int pad)
		{
			Vector3 vector = Quaternion.Euler(0f, (float)pad * 120f, 0f) * Vector3.forward;
			float y = 0f;
			if (padHeights != null && pad < padHeights.Length)
			{
				y = padHeights[pad];
			}
			return transform.TransformPoint(new Vector3(vector.x * 1.55f, y, vector.z * 1.55f));
		}

		public Quaternion PadRotation(int pad)
		{
			return transform.rotation * Quaternion.Euler(0f, (float)pad * 120f, 0f);
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Live.Clear();
			Sorted.Clear();
			_dirty = true;
		}
	}
}
