using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Rivals.Pooling
{
	public static class SimplePool
	{
		private static readonly Dictionary<GameObject, Queue<GameObject>> _pools = new Dictionary<GameObject, Queue<GameObject>>();

		private static readonly Dictionary<GameObject, GameObject> _instanceToPrefab = new Dictionary<GameObject, GameObject>();

		private static Transform _root;

		private static Transform Root
		{
			get
			{
				if (_root == null)
				{
					GameObject go = new GameObject("[Rivals SimplePool]");
					Object.DontDestroyOnLoad(go);
					_root = go.transform;
				}
				return _root;
			}
		}

		public static GameObject Spawn(GameObject prefab, Vector3 position, Quaternion rotation)
		{
			if (prefab == null)
			{
				return null;
			}
			if (!_pools.TryGetValue(prefab, out var queue))
			{
				queue = new Queue<GameObject>();
				_pools[prefab] = queue;
			}
			GameObject go = null;
			while (queue.Count > 0 && go == null)
			{
				go = queue.Dequeue();
			}
			if (go == null)
			{
				go = Object.Instantiate(prefab, position, rotation, Root);
				_instanceToPrefab[go] = prefab;
			}
			else
			{
				go.transform.SetParent(Root, false);
				go.transform.SetPositionAndRotation(position, rotation);
			}
			go.SetActive(true);
			return go;
		}

		public static void Release(GameObject instance)
		{
			if (instance == null)
			{
				return;
			}
			if (!_instanceToPrefab.TryGetValue(instance, out var prefab))
			{
				Object.Destroy(instance);
				return;
			}
			instance.SetActive(false);
			instance.transform.SetParent(Root, false);
			if (!_pools.TryGetValue(prefab, out var queue))
			{
				queue = new Queue<GameObject>();
				_pools[prefab] = queue;
			}
			queue.Enqueue(instance);
		}

		public static GameObject SpawnTimed(GameObject prefab, Vector3 position, Quaternion rotation, float lifetime)
		{
			GameObject go = Spawn(prefab, position, rotation);
			if (go != null)
			{
				PooledReleaser releaser = go.GetComponent<PooledReleaser>();
				if (releaser == null)
				{
					releaser = go.AddComponent<PooledReleaser>();
				}
				releaser.Begin(lifetime);
			}
			return go;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void Reset()
		{
			_pools.Clear();
			_instanceToPrefab.Clear();
			_root = null;
		}
	}
}
