using UnityEngine;

namespace LethalApeR.Rivals
{
	public static class RivalsPodiumBuilder
	{
		private const float StageRadius = 3f;

		private const float StageHeight = 0.55f;

		private const float StepRadius = 3.8f;

		private const float StepHeight = 0.28f;

		public static RivalsPodium CreateDefault(Transform anchor)
		{
			Vector3 vector = ((anchor != null) ? anchor.position : Vector3.zero);
			Vector3 vector2 = ((anchor != null) ? Flat(anchor.forward) : Vector3.forward);
			Vector3 vector3 = vector + vector2 * 8f;
			Quaternion rotation = Quaternion.LookRotation(Flat(vector - vector3), Vector3.up);
			GameObject gameObject = new GameObject("RivalsPodium (Auto)");
			gameObject.transform.SetPositionAndRotation(vector3, rotation);
			RivalsPodium rivalsPodium = gameObject.AddComponent<RivalsPodium>();
			FillMissing(rivalsPodium);
			return rivalsPodium;
		}

		public static void FillMissing(RivalsPodium podium)
		{
			if (!(podium == null))
			{
				if (podium.stageRoot == null)
				{
					BuildStage(podium);
				}
				if (podium.cameraOrbitCenter == null)
				{
					BuildOrbitCenter(podium);
				}
				if (podium.winnerSpawnPoints == null || podium.winnerSpawnPoints.Length == 0)
				{
					BuildWinnerSpots(podium);
				}
			}
		}

		private static void BuildStage(RivalsPodium podium)
		{
			Transform transform = new GameObject("Stage (Auto)").transform;
			transform.SetParent(podium.transform, false);
			podium.stageRoot = transform;
			BuildDisc(transform, "StageTop", StageRadius, StageHeight, new Color(0.85f, 0.7f, 0.22f, 1f), 0.7f, 0.6f);
			BuildDisc(transform, "StageStep", StepRadius, StepHeight, new Color(0.55f, 0.42f, 0.18f, 1f), 0.5f, 0.4f);
		}

		private static void BuildDisc(Transform parent, string name, float radius, float height, Color color, float metallic, float smoothness)
		{
			Transform transform = GameObject.CreatePrimitive(PrimitiveType.Cylinder).transform;
			transform.name = name;
			Collider component = transform.GetComponent<Collider>();
			if (component != null)
			{
				RivalsBuildUtil.Destroy(component);
			}
			MeshCollider meshCollider = transform.gameObject.AddComponent<MeshCollider>();
			MeshFilter component2 = transform.GetComponent<MeshFilter>();
			if (component2 != null)
			{
				meshCollider.sharedMesh = component2.sharedMesh;
			}
			transform.SetParent(parent, false);
			transform.localScale = new Vector3(radius * 2f, height * 0.5f, radius * 2f);
			transform.localPosition = new Vector3(0f, height * 0.5f, 0f);
			Tint(transform, color, metallic, smoothness);
		}

		private static void BuildOrbitCenter(RivalsPodium podium)
		{
			Transform transform = new GameObject("CameraOrbitCenter").transform;
			transform.SetParent(podium.transform, false);
			transform.localPosition = new Vector3(0f, StageHeight, 0f);
			podium.cameraOrbitCenter = transform;
		}

		private static void BuildWinnerSpots(RivalsPodium podium)
		{
			Transform parent = ((podium.stageRoot != null) ? podium.stageRoot : podium.transform);
			Vector2[] array = new Vector2[4]
			{
				new Vector2(0f, 0.4f),
				new Vector2(-1.2f, -0.5f),
				new Vector2(1.2f, -0.5f),
				new Vector2(0f, -1.4f)
			};
			Transform[] array2 = new Transform[array.Length];
			for (int i = 0; i < array.Length; i++)
			{
				Transform transform = new GameObject(string.Format("WinnerSpot{0}", i)).transform;
				transform.SetParent(parent, false);
				transform.localPosition = new Vector3(array[i].x, 0.6f, array[i].y);
				transform.localRotation = Quaternion.identity;
				array2[i] = transform;
			}
			podium.winnerSpawnPoints = array2;
		}

		private static Vector3 Flat(Vector3 v)
		{
			v.y = 0f;
			if (!(v.sqrMagnitude > 0.0001f))
			{
				return Vector3.forward;
			}
			return v.normalized;
		}

		private static void Tint(Transform t, Color c, float metallic = 0f, float smoothness = 0.5f)
		{
			Renderer component = t.GetComponent<Renderer>();
			if (!(component == null) && !(component.material == null))
			{
				component.material.color = c;
				if (component.material.HasProperty("_Metallic"))
				{
					component.material.SetFloat("_Metallic", metallic);
				}
				if (component.material.HasProperty("_Glossiness"))
				{
					component.material.SetFloat("_Glossiness", smoothness);
				}
			}
		}
	}
}
