using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgBed : MonoBehaviour
	{
		public Vector3 positionOffset = new Vector3(0f, 0.5f, 0f);

		public Vector3 rotationOffset;

		public bool forceLook = true;

		[Header("Gizmo")]
		[SerializeField]
		private float gizmoRadius = 0.15f;

		[SerializeField]
		private float gizmoArrowLength = 0.6f;

		public Vector3 SpawnPosition => base.transform.TransformPoint(positionOffset);

		public Quaternion SpawnRotation => base.transform.rotation * Quaternion.Euler(rotationOffset);

		public Quaternion LookRotation()
		{
			Vector3 vector = SpawnRotation * Vector3.forward;
			if (vector.x * vector.x + vector.z * vector.z > 0.0001f)
			{
				return Quaternion.LookRotation(new Vector3(vector.x, 0f, vector.z), Vector3.up);
			}
			return Quaternion.identity;
		}
	}
}
