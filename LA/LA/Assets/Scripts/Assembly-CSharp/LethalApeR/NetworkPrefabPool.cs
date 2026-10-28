using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using Photon.Pun;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public sealed class NetworkPrefabPool : MonoBehaviour, IPunPrefabPool
	{
		private sealed class PrefabEntry
		{
			public readonly string Key;

			public readonly GameObject Prefab;

			public readonly bool Recycled;

			public readonly int MaxIdle;

			public readonly Vector3 SpawnScale;

			public readonly Stack<PooledNetworkObject> Idle;

			public PrefabEntry(string key, GameObject prefab)
			{
				Key = key;
				Prefab = prefab;
				SpawnScale = prefab.transform.localScale;
				PooledNetworkObject component = prefab.GetComponent<PooledNetworkObject>();
				Recycled = component != null;
				MaxIdle = (Recycled ? component.MaxIdle : 0);
				Idle = (Recycled ? new Stack<PooledNetworkObject>(Mathf.Min(MaxIdle, 16)) : null);
			}
		}

		[Header("Warm-up")]
		[Tooltip("Resources paths of POOLED prefabs to pre-create at startup, so the first spawns in a room skip the instantiate hitch. Prefabs without a PooledNetworkObject are ignored.")]
		[FormerlySerializedAs("prefabIds")]
		[SerializeField]
		private string[] warmupPrefabs = Array.Empty<string>();

		[Tooltip("Idle copies to pre-create per warm-up prefab (capped by that prefab's Max Idle).")]
		[FormerlySerializedAs("preloadCount")]
		[SerializeField]
		[Min(0f)]
		private int warmupCount = 5;

		[Tooltip("Copies created per frame while warming up. Each one is a full prefab instantiate, so 1 keeps the per-frame cost on Quest to a single instantiate.")]
		[SerializeField]
		[Min(1f)]
		private int warmupPerFrame = 1;

		private readonly Dictionary<string, PrefabEntry> _entries = new Dictionary<string, PrefabEntry>(StringComparer.Ordinal);

		private Transform _idleRoot;

		public static NetworkPrefabPool Instance { get; private set; }

		public bool IsReady { get; private set; }

		public event Action Ready;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Destroy(gameObject);
				return;
			}
			Instance = this;
			transform.SetParent(null);
			DontDestroyOnLoad(gameObject);
			GameObject gameObject2 = new GameObject("Idle");
			gameObject2.SetActive(false);
			_idleRoot = gameObject2.transform;
			_idleRoot.SetParent(transform, false);
			PhotonNetwork.PrefabPool = this;
		}

		private void Start()
		{
			StartCoroutine(WarmUp());
		}

		private void OnDestroy()
		{
			if (!(Instance != this))
			{
				Instance = null;
				if (PhotonNetwork.PrefabPool == this)
				{
					PhotonNetwork.PrefabPool = new DefaultPool();
				}
			}
		}

		private IEnumerator WarmUp()
		{
			int madeThisFrame = 0;
			for (int p = 0; p < warmupPrefabs.Length; p++)
			{
				string text = warmupPrefabs[p];
				if (string.IsNullOrEmpty(text))
				{
					continue;
				}
				PrefabEntry entry = GetEntry(text);
				if (entry == null)
				{
					continue;
				}
				if (!entry.Recycled)
				{
					Debug.LogWarning("[NetworkPrefabPool] Warm-up skipped '" + text + "': it has no PooledNetworkObject, so it is never recycled.", this);
					continue;
				}
				int target = Mathf.Min(warmupCount, entry.MaxIdle);
				while (entry.Idle.Count < target)
				{
					PooledNetworkObject component = CreateInstance(entry).GetComponent<PooledNetworkObject>();
					component.IsIdle = true;
					entry.Idle.Push(component);
					madeThisFrame++;
					if (madeThisFrame >= warmupPerFrame)
					{
						madeThisFrame = 0;
						yield return null;
					}
				}
			}
			IsReady = true;
			Action ready = this.Ready;
			this.Ready = null;
			ready?.Invoke();
		}

		GameObject IPunPrefabPool.Instantiate(string prefabId, Vector3 position, Quaternion rotation)
		{
			PrefabEntry entry = GetEntry(prefabId);
			if (entry == null)
			{
				return null;
			}
			PooledNetworkObject pooledNetworkObject = (entry.Recycled ? PopIdle(entry) : null);
			GameObject gameObject;
			if (pooledNetworkObject != null)
			{
				pooledNetworkObject.IsIdle = false;
				pooledNetworkObject.NotifyAcquired();
				gameObject = pooledNetworkObject.gameObject;
			}
			else
			{
				gameObject = CreateInstance(entry);
			}
			Transform obj = gameObject.transform;
			obj.SetParent(null, false);
			SceneManager.MoveGameObjectToScene(gameObject, SceneManager.GetActiveScene());
			obj.SetPositionAndRotation(position, rotation);
			obj.localScale = entry.SpawnScale;
			return gameObject;
		}

		void IPunPrefabPool.Destroy(GameObject go)
		{
			if (go == null)
			{
				return;
			}
			if (!go.TryGetComponent<PooledNetworkObject>(out var component) || component.Owner != this)
			{
				Destroy(go);
			}
			else
			{
				if (component.IsIdle)
				{
					return;
				}
				if (go.activeSelf)
				{
					go.SetActive(false);
				}
				component.NotifyReleased();
				if (_entries.TryGetValue(component.PoolKey, out var value) && value.Idle.Count < value.MaxIdle)
				{
					go.transform.SetParent(_idleRoot, false);
					component.IsIdle = true;
					value.Idle.Push(component);
				}
				else
				{
					Destroy(go);
				}
			}
		}

		private PrefabEntry GetEntry(string key)
		{
			if (_entries.TryGetValue(key, out var value))
			{
				return value;
			}
			GameObject gameObject = Resources.Load<GameObject>(key);
			if (gameObject == null)
			{
				Debug.LogError("[NetworkPrefabPool] No prefab at Resources/" + key, this);
				return null;
			}
			value = new PrefabEntry(key, gameObject);
			_entries.Add(key, value);
			return value;
		}

		private GameObject CreateInstance(PrefabEntry entry)
		{
			GameObject gameObject = Instantiate(entry.Prefab, _idleRoot, false);
			gameObject.SetActive(false);
			if (entry.Recycled)
			{
				gameObject.GetComponent<PooledNetworkObject>().Bind(this, entry.Key);
			}
			return gameObject;
		}

		private static PooledNetworkObject PopIdle(PrefabEntry entry)
		{
			while (entry.Idle.Count > 0)
			{
				PooledNetworkObject pooledNetworkObject = entry.Idle.Pop();
				if (pooledNetworkObject != null)
				{
					return pooledNetworkObject;
				}
			}
			return null;
		}

		[ContextMenu("Log Pool Contents")]
		private void LogContents()
		{
			StringBuilder stringBuilder = new StringBuilder("[NetworkPrefabPool] ");
			stringBuilder.Append(_entries.Count).Append(" prefab(s) seen");
			foreach (PrefabEntry value in _entries.Values)
			{
				stringBuilder.Append("\n  ");
				stringBuilder.Append(value.Key);
				stringBuilder.Append(": ");
				if (value.Recycled)
				{
					stringBuilder.Append(value.Idle.Count).Append('/').Append(value.MaxIdle)
						.Append(" idle");
				}
				else
				{
					stringBuilder.Append("not recycled");
				}
			}
			Debug.Log(stringBuilder.ToString(), this);
		}
	}
}
