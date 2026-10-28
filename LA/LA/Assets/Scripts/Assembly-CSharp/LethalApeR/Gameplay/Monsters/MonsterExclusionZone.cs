using System.Collections.Generic;
using Unity.AI.Navigation;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	[RequireComponent(typeof(NavMeshModifierVolume))]
	public sealed class MonsterExclusionZone : MonoBehaviour
	{
		private static readonly List<MonsterExclusionZone> s_zones = new List<MonsterExclusionZone>();

		private NavMeshModifierVolume _volume;

		private void OnEnable()
		{
			if (_volume == null)
			{
				_volume = GetComponent<NavMeshModifierVolume>();
			}
			if (!s_zones.Contains(this))
			{
				s_zones.Add(this);
			}
		}

		private void OnDisable()
		{
			s_zones.Remove(this);
		}

		public static bool Contains(Vector3 worldPoint)
		{
			for (int i = 0; i < s_zones.Count; i++)
			{
				if (s_zones[i].ContainsPoint(worldPoint))
				{
					return true;
				}
			}
			return false;
		}

		public static bool Entering(Vector3 from, Vector3 to)
		{
			if (!Contains(from))
			{
				return Contains(to);
			}
			return false;
		}

		public static bool DistanceToNearest(Vector3 worldPoint, out float distance, out Vector3 centre)
		{
			distance = float.MaxValue;
			centre = default(Vector3);
			for (int i = 0; i < s_zones.Count; i++)
			{
				if (s_zones[i].TryDistance(worldPoint, out float d, out Vector3 c) && d < distance)
				{
					distance = d;
					centre = c;
				}
			}
			return distance < float.MaxValue;
		}

		private bool TryDistance(Vector3 point, out float distance, out Vector3 centre)
		{
			distance = 0f;
			centre = default(Vector3);
			if (_volume == null)
			{
				return false;
			}
			Transform t = base.transform;
			centre = t.TransformPoint(_volume.center);
			Vector3 local = Quaternion.Inverse(t.rotation) * (point - centre);
			Vector3 half = Vector3.Scale(_volume.size, Abs(t.lossyScale)) * 0.5f;
			Vector3 outside = Abs(local) - half;
			distance = new Vector3(Mathf.Max(outside.x, 0f), Mathf.Max(outside.y, 0f), Mathf.Max(outside.z, 0f)).magnitude;
			return true;
		}

		private static Vector3 Abs(Vector3 v)
		{
			return new Vector3(Mathf.Abs(v.x), Mathf.Abs(v.y), Mathf.Abs(v.z));
		}

		private bool ContainsPoint(Vector3 point)
		{
			if (_volume == null)
			{
				return false;
			}
			Transform t = base.transform;
			Vector3 local = Quaternion.Inverse(t.rotation) * (point - t.TransformPoint(_volume.center));
			Vector3 half = Vector3.Scale(Abs(t.lossyScale), _volume.size) * 0.5f;
			if (Mathf.Abs(local.x) <= half.x && Mathf.Abs(local.y) <= half.y)
			{
				return Mathf.Abs(local.z) <= half.z;
			}
			return false;
		}
	}
}
