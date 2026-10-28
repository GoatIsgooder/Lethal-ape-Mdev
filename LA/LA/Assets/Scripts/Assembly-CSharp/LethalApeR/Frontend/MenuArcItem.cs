using UnityEngine;

namespace LethalApeR.Frontend
{
	[ExecuteAlways]
	public sealed class MenuArcItem : MonoBehaviour
	{
		[Tooltip("Degrees from the menu's forward. Positive is to the viewer's right.")]
		public float angle;

		[Tooltip("Metres above (or below) eye height.")]
		public float height;

		[Tooltip("Metres added to the arc radius. Negative moves toward the viewer.")]
		public float radiusOffset;

		[Tooltip("Pitch toward the eye as well as yaw. Off keeps the item upright.")]
		public bool faceEye = true;

		private MenuArc _arc;

		public MenuArc Arc
		{
			get
			{
				if (!_arc)
				{
					_arc = GetComponentInParent<MenuArc>(true);
				}
				return _arc;
			}
		}

		private void OnEnable()
		{
			Apply();
		}

		public void Apply()
		{
			MenuArc arc = Arc;
			if (arc)
			{
				Vector3 vector = arc.LocalPoint(angle, height, radiusOffset);
				Vector3 vector2 = new Vector3(vector.x, faceEye ? height : 0f, vector.z);
				if (vector2.sqrMagnitude < 1E-06f)
				{
					vector2 = Vector3.forward;
				}
				Transform transform = arc.transform;
				base.transform.SetPositionAndRotation(transform.TransformPoint(vector), transform.rotation * Quaternion.LookRotation(vector2.normalized, Vector3.up));
			}
		}
	}
}
