using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmVisualCopy
	{
		private static Transform _staging;

		public static readonly int LiquidColorId = Shader.PropertyToID("_LiquidColor");

		private static MaterialPropertyBlock _tintBlock;

		public static GameObject Create(GameObject prefab, Vector3 position, Quaternion rotation, Transform parent = null)
		{
			if (prefab == null)
			{
				return null;
			}
			if (_staging == null)
			{
				GameObject gameObject = new GameObject("BtmVisualStaging");
				gameObject.SetActive(false);
				Object.DontDestroyOnLoad(gameObject);
				_staging = gameObject.transform;
			}
			GameObject gameObject2 = Object.Instantiate(prefab, position, rotation, _staging);
			MonoBehaviour[] componentsInChildren = gameObject2.GetComponentsInChildren<MonoBehaviour>(true);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				Object.DestroyImmediate(componentsInChildren[i]);
			}
			Joint[] componentsInChildren2 = gameObject2.GetComponentsInChildren<Joint>(true);
			for (int i = 0; i < componentsInChildren2.Length; i++)
			{
				Object.DestroyImmediate(componentsInChildren2[i]);
			}
			AudioSource[] componentsInChildren3 = gameObject2.GetComponentsInChildren<AudioSource>(true);
			for (int i = 0; i < componentsInChildren3.Length; i++)
			{
				Object.DestroyImmediate(componentsInChildren3[i]);
			}
			Collider[] componentsInChildren4 = gameObject2.GetComponentsInChildren<Collider>(true);
			for (int i = 0; i < componentsInChildren4.Length; i++)
			{
				componentsInChildren4[i].enabled = false;
			}
			Rigidbody[] componentsInChildren5 = gameObject2.GetComponentsInChildren<Rigidbody>(true);
			foreach (Rigidbody obj in componentsInChildren5)
			{
				obj.isKinematic = true;
				obj.detectCollisions = false;
			}
			ParticleSystem[] componentsInChildren6 = gameObject2.GetComponentsInChildren<ParticleSystem>(true);
			for (int i = 0; i < componentsInChildren6.Length; i++)
			{
				componentsInChildren6[i].gameObject.SetActive(false);
			}
			gameObject2.transform.SetParent(parent, true);
			return gameObject2;
		}

		public static void ApplyTint(GameObject go, Color tint)
		{
			if (go == null)
			{
				return;
			}
			if (_tintBlock == null)
			{
				_tintBlock = new MaterialPropertyBlock();
			}
			Renderer[] componentsInChildren = go.GetComponentsInChildren<Renderer>(true);
			foreach (Renderer renderer in componentsInChildren)
			{
				Material sharedMaterial = renderer.sharedMaterial;
				if (!(sharedMaterial == null) && sharedMaterial.HasProperty(LiquidColorId))
				{
					renderer.GetPropertyBlock(_tintBlock);
					_tintBlock.SetColor(LiquidColorId, tint);
					renderer.SetPropertyBlock(_tintBlock);
				}
			}
		}

		public static void FitTo(GameObject go, float size)
		{
			if (go == null)
			{
				return;
			}
			Bounds bounds = new Bounds(go.transform.position, Vector3.zero);
			bool flag = false;
			Renderer[] componentsInChildren = go.GetComponentsInChildren<Renderer>(true);
			foreach (Renderer renderer in componentsInChildren)
			{
				if (renderer is MeshRenderer || renderer is SkinnedMeshRenderer)
				{
					if (!flag)
					{
						bounds = renderer.bounds;
					}
					else
					{
						bounds.Encapsulate(renderer.bounds);
					}
					flag = true;
				}
			}
			if (flag)
			{
				float num = Mathf.Max(bounds.size.x, bounds.size.y, bounds.size.z);
				if (num > 0.0001f)
				{
					go.transform.localScale *= size / num;
				}
			}
		}
	}
}
