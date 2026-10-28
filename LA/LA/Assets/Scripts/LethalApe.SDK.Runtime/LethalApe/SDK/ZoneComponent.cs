using UnityEngine;

namespace LethalApe.SDK
{
	public abstract class ZoneComponent : MapComponent
	{
		[SerializeField]
		[Tooltip("Centre of the zone box, in this object's local space.")]
		private Vector3 zoneCenter = new Vector3(0f, 1f, 0f);

		[SerializeField]
		[Tooltip("Size of the zone box, in this object's local space.")]
		private Vector3 zoneSize = new Vector3(2f, 2f, 2f);

		public Vector3 ZoneCenter => zoneCenter;

		public Vector3 ZoneSize => zoneSize;

		public Bounds WorldBounds
		{
			get
			{
				Vector3 half = zoneSize * 0.5f;
				Bounds bounds = new Bounds(transform.TransformPoint(zoneCenter), Vector3.zero);
				for (int i = 0; i < 8; i++)
				{
					Vector3 corner = new Vector3((i & 1) == 0 ? -half.x : half.x, (i & 2) == 0 ? -half.y : half.y, (i & 4) == 0 ? -half.z : half.z);
					bounds.Encapsulate(transform.TransformPoint(zoneCenter + corner));
				}
				return bounds;
			}
		}

		public float TopY => transform.TransformPoint(zoneCenter + new Vector3(0f, zoneSize.y * 0.5f, 0f)).y;

		public bool Contains(Vector3 worldPoint)
		{
			Vector3 local = transform.InverseTransformPoint(worldPoint);
			if (Mathf.Abs(local.x - zoneCenter.x) <= zoneSize.x * 0.5f && Mathf.Abs(local.y - zoneCenter.y) <= zoneSize.y * 0.5f)
			{
				return Mathf.Abs(local.z - zoneCenter.z) <= zoneSize.z * 0.5f;
			}
			return false;
		}
	}
}
