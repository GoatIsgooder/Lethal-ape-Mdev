using UnityEngine;

namespace LethalApeR
{
	public class RandomizeSpawnPoint : MonoBehaviour
	{
		public enum SpawnShape
		{
			Circle = 0,
			Box = 1
		}

		public SpawnShape shape;

		public float yOffset = 0.5f;

		[Header("Circle")]
		public float radius = 2f;

		[Header("Box (full width x depth, oriented by this transform's rotation)")]
		public Vector2 boxSize = new Vector2(4f, 4f);

		[Header("Facing")]
		[Tooltip("On: spawned players are turned to face this transform's forward (the arrow gizmo). Off: they keep their current facing.")]
		public bool forceLookDirection;

		public Quaternion LookRotation()
		{
			Vector3 forward = base.transform.forward;
			forward.y = 0f;
			if (forward.sqrMagnitude > 0.0001f)
			{
				return Quaternion.LookRotation(forward);
			}
			return Quaternion.identity;
		}

		public Vector3 GetRandomPoint()
		{
			if (shape == SpawnShape.Box)
			{
				return GetRandomPointInBox();
			}
			return GetRandomPointInDisc();
		}

		public Vector3 GetRandomPointInDisc()
		{
			Vector3 vector = base.transform.position + Vector3.up * yOffset;
			float f = Random.value * Mathf.PI * 2f;
			float num = radius * Mathf.Sqrt(Random.value);
			return vector + new Vector3(Mathf.Cos(f) * num, 0f, Mathf.Sin(f) * num);
		}

		public Vector3 GetRandomPointInBox()
		{
			float num = boxSize.x * 0.5f;
			float num2 = boxSize.y * 0.5f;
			Quaternion rotation = base.transform.rotation;
			Vector3 vector = new Vector3(Random.Range(0f - num, num), 0f, Random.Range(0f - num2, num2));
			return new Vector3(base.transform.position.x, base.transform.position.y + yOffset, base.transform.position.z) + rotation * vector;
		}
	}
}
