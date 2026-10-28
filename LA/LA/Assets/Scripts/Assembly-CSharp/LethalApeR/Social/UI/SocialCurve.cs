using UnityEngine;

namespace LethalApeR.Social.UI
{
	public sealed class SocialCurve : MonoBehaviour
	{
		[Tooltip("Side-to-side curve, canvas units. Must match _CurveRadius on the board's materials. 0 = flat.")]
		[SerializeField]
		private float radius;

		[Tooltip("The list's drum, canvas units. Must match _DrumRadius on the list materials. 0 = no drum.")]
		[SerializeField]
		private float drumRadius;

		[Tooltip("Canvas y of the drum's axis (_DrumCentreY).")]
		[SerializeField]
		private float drumCentreY;

		[Tooltip("Canvas units from the middle of the list to its edge (_DrumHalfHeight). Sets how far the drum stands out.")]
		[SerializeField]
		private float drumHalfHeight;

		public float Radius => radius;

		public float DrumRadius => drumRadius;

		public float DrumCentreY => drumCentreY;

		public RectTransform Root => (RectTransform)base.transform;

		public float DrumLift => drumRadius - Mathf.Sqrt(Mathf.Max(drumRadius * drumRadius - drumHalfHeight * drumHalfHeight, 0f));

		public void Surface(Vector3 canvasPoint, bool onDrum, out Vector3 point, out Quaternion turn)
		{
			point = canvasPoint;
			turn = Quaternion.identity;
			if (onDrum && drumRadius > 0f)
			{
				float num = (point.y - drumCentreY) / drumRadius;
				point.y = drumCentreY + drumRadius * Mathf.Sin(num);
				point.z += drumRadius * (1f - Mathf.Cos(num)) - DrumLift;
				turn = Quaternion.Euler(num * 57.29578f, 0f, 0f);
			}
			if (radius > 0f)
			{
				float num2 = point.x / radius;
				point.x = radius * Mathf.Sin(num2);
				point.z -= radius * (1f - Mathf.Cos(num2));
				turn = Quaternion.Euler(0f, (0f - num2) * 57.29578f, 0f) * turn;
			}
		}
	}
}
