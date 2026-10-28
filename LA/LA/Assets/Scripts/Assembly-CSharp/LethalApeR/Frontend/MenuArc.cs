using UnityEngine;

namespace LethalApeR.Frontend
{
	[ExecuteAlways]
	public sealed class MenuArc : MonoBehaviour
	{
		[SerializeField]
		[Min(0.5f)]
		private float radius = 2f;

		public float Radius => radius;

		public Vector3 LocalPoint(float angleDeg, float height, float radiusOffset)
		{
			float num = angleDeg * Mathf.Deg2Rad;
			float num2 = radius + radiusOffset;
			return new Vector3(Mathf.Sin(num) * num2, height, Mathf.Cos(num) * num2);
		}

		public float ArcLength(float degrees)
		{
			return degrees * Mathf.Deg2Rad * radius;
		}

		public void ApplyAll()
		{
			MenuArcItem[] componentsInChildren = GetComponentsInChildren<MenuArcItem>(true);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].Apply();
			}
			MenuArcRail[] componentsInChildren2 = GetComponentsInChildren<MenuArcRail>(true);
			for (int j = 0; j < componentsInChildren2.Length; j++)
			{
				componentsInChildren2[j].Rebuild();
			}
		}
	}
}
