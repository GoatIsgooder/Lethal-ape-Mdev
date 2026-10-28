using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Gameplay.Backrooms.Ragdoll
{
	[Obfuscation(Exclude = true)]
	public class BackroomsRagdollSpawner : MonoBehaviour
	{
		private readonly Dictionary<int, GameObject> _corpses = new Dictionary<int, GameObject>();

		private readonly HashSet<int> _pending = new HashSet<int>();

		private readonly HashSet<int> _debugCorpses = new HashSet<int>();

		private readonly List<int> _reconcile = new List<int>();

		private readonly List<int> _pendingScratch = new List<int>();

		public static BackroomsRagdollSpawner Instance { get; private set; }

		private int LocalActor
		{
			get
			{
				if (!PhotonNetwork.InRoom)
				{
					return 1;
				}
				return PhotonNetwork.LocalPlayer.ActorNumber;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(Instance != null))
			{
				GameObject gameObject = new GameObject("BackroomsRagdollSpawner (auto)");
				DontDestroyOnLoad(gameObject);
				gameObject.AddComponent<BackroomsRagdollSpawner>();
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Destroy(gameObject);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnEnable()
		{
			BackroomsEvents.OnPlayerDownedChanged += OnPlayerDowned;
			BackroomsEvents.OnPlayerDied += OnPlayerDied;
			BackroomsEvents.OnStateChanged += OnStateChanged;
			SceneManager.sceneLoaded += OnSceneLoaded;
		}

		private void OnDisable()
		{
			BackroomsEvents.OnPlayerDownedChanged -= OnPlayerDowned;
			BackroomsEvents.OnPlayerDied -= OnPlayerDied;
			BackroomsEvents.OnStateChanged -= OnStateChanged;
			SceneManager.sceneLoaded -= OnSceneLoaded;
		}

		private void OnPlayerDied(int actor)
		{
			if (!_debugCorpses.Contains(actor))
			{
				_pending.Remove(actor);
				Despawn(actor);
			}
		}

		private void OnSceneLoaded(Scene s, LoadSceneMode m)
		{
			_corpses.Clear();
			_pending.Clear();
			_debugCorpses.Clear();
		}

		private void OnStateChanged(BackroomsState s)
		{
			if (s == BackroomsState.Lobby || s == BackroomsState.Spawn || s == BackroomsState.End)
			{
				DespawnAll();
			}
		}

		private void OnPlayerDowned(int actor, bool downed)
		{
			try
			{
				if (downed)
				{
					if (!TrySpawn(actor))
					{
						_pending.Add(actor);
					}
				}
				else
				{
					_pending.Remove(actor);
					Despawn(actor);
				}
			}
			catch (Exception ex)
			{
				Debug.LogError(string.Format("[RagdollSpawner] {0} actor {1} failed: {2}", downed ? "spawn" : "despawn", actor, ex));
			}
		}

		private void Update()
		{
			if (_pending.Count > 0)
			{
				_pendingScratch.Clear();
				_pendingScratch.AddRange(_pending);
				for (int i = 0; i < _pendingScratch.Count; i++)
				{
					if (TrySpawn(_pendingScratch[i]))
					{
						_pending.Remove(_pendingScratch[i]);
					}
				}
			}
			BackroomsDownedManager instance = BackroomsDownedManager.Instance;
			if (instance == null || _corpses.Count <= 0)
			{
				return;
			}
			_reconcile.Clear();
			foreach (KeyValuePair<int, GameObject> corpse in _corpses)
			{
				int key = corpse.Key;
				if (!_debugCorpses.Contains(key) && !instance.IsDowned(key))
				{
					_reconcile.Add(key);
				}
			}
			for (int j = 0; j < _reconcile.Count; j++)
			{
				Despawn(_reconcile[j]);
			}
		}

		private bool TrySpawn(int actor, bool forceNoDeathCam = false)
		{
			if (_corpses.ContainsKey(actor))
			{
				return true;
			}
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = ResolveAvatar(actor);
			if (monkeDevNetworkingPlayer == null)
			{
				return false;
			}
			Transform transform = PlayerRagdoll.FindDeepByName(monkeDevNetworkingPlayer.transform, "PlayerModels");
			if (transform == null)
			{
				SkinnedMeshRenderer componentInChildren = monkeDevNetworkingPlayer.GetComponentInChildren<SkinnedMeshRenderer>();
				transform = ((componentInChildren != null) ? componentInChildren.transform.parent : null);
				if (transform == null)
				{
					Debug.LogWarning(string.Format("[RagdollSpawner] No PlayerModels found on actor {0}'s avatar.", actor));
					return false;
				}
			}
			GameObject gameObject = Instantiate(transform.gameObject);
			gameObject.name = string.Format("Corpse_{0}", actor);
			gameObject.transform.SetParent(null, false);
			gameObject.transform.SetPositionAndRotation(transform.position, transform.rotation);
			gameObject.transform.localScale = transform.lossyScale;
			string text = TrimToActiveModel(gameObject.transform, monkeDevNetworkingPlayer);
			Transform transform2 = ((!string.IsNullOrEmpty(text)) ? PlayerRagdoll.FindDeepByName(gameObject.transform, text) : gameObject.transform);
			if (transform2 == null)
			{
				transform2 = gameObject.transform;
			}
			FlattenLODs(gameObject);
			StripScripts(gameObject);
			CleanupChaseMe(gameObject);
			float bleedSeconds = ((BackroomsDownedManager.Instance != null) ? BackroomsDownedManager.Instance.BleedOutSeconds : 30f);
			gameObject.AddComponent<PlayerRagdoll>().BuildAtRuntime(monkeDevNetworkingPlayer, transform2, LocalActor == actor && !forceNoDeathCam, actor, bleedSeconds);
			_corpses[actor] = gameObject;
			return true;
		}

		private static string TrimToActiveModel(Transform corpse, MonkeDevNetworkingPlayer avatar)
		{
			string text = null;
			if (avatar.availablePlayerModels != null)
			{
				foreach (MonkeDevNetworkingPlayer.PlayerModelEntry availablePlayerModel in avatar.availablePlayerModels)
				{
					if (availablePlayerModel != null && availablePlayerModel.ModelGameObject != null && availablePlayerModel.ModelGameObject.activeInHierarchy)
					{
						text = availablePlayerModel.ModelGameObject.name;
						break;
					}
				}
			}
			if (avatar.availablePlayerModels != null)
			{
				foreach (MonkeDevNetworkingPlayer.PlayerModelEntry availablePlayerModel2 in avatar.availablePlayerModels)
				{
					if (availablePlayerModel2 == null || availablePlayerModel2.ModelGameObject == null || availablePlayerModel2.ModelGameObject.name == text)
					{
						continue;
					}
					Transform transform = PlayerRagdoll.FindDeepByName(corpse, availablePlayerModel2.ModelGameObject.name);
					if (transform != null && transform != corpse)
					{
						Destroy(transform.gameObject);
					}
				}
			}
			return text;
		}

		private static void FlattenLODs(GameObject go)
		{
			LODGroup[] componentsInChildren = go.GetComponentsInChildren<LODGroup>(true);
			foreach (LODGroup lODGroup in componentsInChildren)
			{
				if (lODGroup == null)
				{
					continue;
				}
				LOD[] lODs = lODGroup.GetLODs();
				HashSet<Renderer> hashSet = new HashSet<Renderer>();
				if (lODs != null && lODs.Length != 0)
				{
					Renderer[] renderers = lODs[0].renderers;
					if (renderers != null)
					{
						foreach (Renderer renderer in renderers)
						{
							if (renderer != null)
							{
								hashSet.Add(renderer);
							}
						}
					}
					for (int k = 1; k < lODs.Length; k++)
					{
						Renderer[] renderers2 = lODs[k].renderers;
						if (renderers2 == null)
						{
							continue;
						}
						foreach (Renderer renderer2 in renderers2)
						{
							if (renderer2 != null && !hashSet.Contains(renderer2) && renderer2.gameObject != go)
							{
								Destroy(renderer2.gameObject);
							}
						}
					}
				}
				Destroy(lODGroup);
			}
		}

		private static void CleanupChaseMe(GameObject go)
		{
			int num = LayerMask.NameToLayer("ChaseMe");
			Transform[] componentsInChildren = go.GetComponentsInChildren<Transform>(true);
			foreach (Transform transform in componentsInChildren)
			{
				if (!(transform == null))
				{
					if (num >= 0 && transform.gameObject.layer == num)
					{
						transform.gameObject.layer = 0;
					}
					if (transform.name.IndexOf("ChaseMe", StringComparison.OrdinalIgnoreCase) >= 0)
					{
						transform.name = "DeadMarker";
					}
				}
			}
		}

		private static void StripScripts(GameObject go)
		{
			Transform[] componentsInChildren = go.GetComponentsInChildren<Transform>(true);
			foreach (Transform transform in componentsInChildren)
			{
				if (transform != null && transform.name.IndexOf("IKRig", StringComparison.OrdinalIgnoreCase) >= 0)
				{
					Destroy(transform.gameObject);
				}
			}
			Animator[] componentsInChildren2 = go.GetComponentsInChildren<Animator>(true);
			foreach (Animator animator in componentsInChildren2)
			{
				if (animator != null)
				{
					animator.enabled = false;
					Destroy(animator);
				}
			}
			LODGroup[] componentsInChildren3 = go.GetComponentsInChildren<LODGroup>(true);
			foreach (LODGroup lODGroup in componentsInChildren3)
			{
				if (lODGroup != null)
				{
					Destroy(lODGroup);
				}
			}
			PhotonView[] componentsInChildren4 = go.GetComponentsInChildren<PhotonView>(true);
			foreach (PhotonView photonView in componentsInChildren4)
			{
				if (photonView != null)
				{
					Destroy(photonView);
				}
			}
			int num = 0;
			MonoBehaviour[] componentsInChildren5 = go.GetComponentsInChildren<MonoBehaviour>(true);
			foreach (MonoBehaviour monoBehaviour in componentsInChildren5)
			{
				if (!(monoBehaviour == null))
				{
					string text = monoBehaviour.GetType().Namespace;
					if (text != null && text.StartsWith("RootMotion"))
					{
						num++;
					}
					monoBehaviour.enabled = false;
					Destroy(monoBehaviour);
				}
			}
			Joint[] componentsInChildren6 = go.GetComponentsInChildren<Joint>(true);
			foreach (Joint joint in componentsInChildren6)
			{
				if (joint != null)
				{
					Destroy(joint);
				}
			}
			Collider[] componentsInChildren7 = go.GetComponentsInChildren<Collider>(true);
			foreach (Collider collider in componentsInChildren7)
			{
				if (collider != null)
				{
					Destroy(collider);
				}
			}
			Rigidbody[] componentsInChildren8 = go.GetComponentsInChildren<Rigidbody>(true);
			foreach (Rigidbody rigidbody in componentsInChildren8)
			{
				if (rigidbody != null)
				{
					Destroy(rigidbody);
				}
			}
			if (num > 0)
			{
				Debug.Log(string.Format("[RagdollSpawner] Stripped {0} FinalIK component(s) from the corpse.", num));
			}
		}

		private MonkeDevNetworkingPlayer ResolveAvatar(int actor)
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return null;
			}
			if (LocalActor == actor && manager.LocalPlayer != null)
			{
				return manager.LocalPlayer;
			}
			for (int i = 0; i < manager.Players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = manager.Players[i];
				if (monkeDevNetworkingPlayer != null && monkeDevNetworkingPlayer.photonView != null && monkeDevNetworkingPlayer.photonView.OwnerActorNr == actor)
				{
					return monkeDevNetworkingPlayer;
				}
			}
			if (!PhotonNetwork.InRoom)
			{
				return manager.LocalPlayer;
			}
			return null;
		}

		private void Despawn(int actor)
		{
			if (_corpses.TryGetValue(actor, out var value))
			{
				_corpses.Remove(actor);
				_debugCorpses.Remove(actor);
				if (value != null)
				{
					Destroy(value);
				}
				Debug.Log(string.Format("[RagdollSpawner] Despawned corpse for actor {0} (avatar restored).", actor));
			}
		}

		private void DespawnAll()
		{
			foreach (KeyValuePair<int, GameObject> corpse in _corpses)
			{
				if (corpse.Value != null)
				{
					Destroy(corpse.Value);
				}
			}
			_corpses.Clear();
			_pending.Clear();
			_debugCorpses.Clear();
		}
	}
}
