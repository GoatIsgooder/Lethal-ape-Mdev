using System.Collections;
using Photon.Pun;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Networking
{
	public class PlayerSpawner : MonoBehaviourPunCallbacks
	{
		[Tooltip("Resources path of the networked player prefab")]
		public string PrefabLocation = "NetworkPlayer";

		private static PlayerSpawner _instance;

		private GameObject _avatar;

		private bool _poolReady;

		private void Awake()
		{
			if (_instance != null && _instance != this)
			{
				StandDown();
				return;
			}
			_instance = this;
			base.transform.SetParent(null);
			Object.DontDestroyOnLoad(base.gameObject);
			Debug.Log("[PlayerSpawner] Awake — DDOL applied");
		}

		private void StandDown()
		{
			if (string.IsNullOrEmpty(PrefabLocation) || _instance.PrefabLocation == PrefabLocation)
			{
				Debug.Log("[PlayerSpawner] Duplicate detected — disabling component only");
			}
			else
			{
				Debug.Log("[PlayerSpawner] Duplicate detected — handing PrefabLocation '" + _instance.PrefabLocation + "' -> '" + PrefabLocation + "' to the surviving spawner");
				_instance.PrefabLocation = PrefabLocation;
			}
			base.enabled = false;
		}

		private void Start()
		{
			NetworkPrefabPool instance = NetworkPrefabPool.Instance;
			if (instance == null)
			{
				Debug.LogWarning("[PlayerSpawner] No NetworkPrefabPool in Start — spawning without warm-up");
				_poolReady = true;
			}
			else if (!instance.IsReady)
			{
				instance.Ready += OnPoolReady;
			}
			else
			{
				_poolReady = true;
			}
			SceneManager.sceneLoaded += OnSceneLoaded;
		}

		private void OnDestroy()
		{
			SceneManager.sceneLoaded -= OnSceneLoaded;
			if (NetworkPrefabPool.Instance != null)
			{
				NetworkPrefabPool.Instance.Ready -= OnPoolReady;
			}
			if (_instance == this)
			{
				_instance = null;
			}
		}

		private void OnPoolReady()
		{
			Debug.Log("[PlayerSpawner] Pool ready");
			_poolReady = true;
			TrySpawn();
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			Debug.Log(string.Format("[PlayerSpawner] OnSceneLoaded — scene={0}  InRoom={1}  handoff={2}  _poolReady={3}", scene.name, PhotonNetwork.InRoom, MonkeDevNetworkingManager.SceneHandoffPending, _poolReady));
			_avatar = null;
			if (PhotonNetwork.InRoom)
			{
				StartCoroutine(SpawnAfterOneFrame());
			}
		}

		private IEnumerator SpawnAfterOneFrame()
		{
			yield return null;
			TrySpawn();
		}

		public override void OnJoinedRoom()
		{
			Debug.Log(string.Format("[PlayerSpawner] OnJoinedRoom — _poolReady={0}", _poolReady));
			TrySpawn();
		}

		public override void OnLeftRoom()
		{
			_avatar = null;
		}

		private void TrySpawn()
		{
			Debug.Log(string.Format("[PlayerSpawner] TrySpawn — _poolReady={0}  InRoom={1}  hasPlayer={2}  scene={3}", _poolReady, PhotonNetwork.InRoom, _avatar != null, SceneManager.GetActiveScene().name));
			if (!_poolReady || !PhotonNetwork.InRoom || MonkeDevNetworkingManager.SceneHandoffPending)
			{
				return;
			}
			if (_avatar != null)
			{
				if (IsOwnedLiveView(_avatar))
				{
					return;
				}
				Debug.LogWarning("[PlayerSpawner] _playerObj reference is stale — clearing and respawning");
				_avatar = null;
			}
			_avatar = PhotonNetwork.Instantiate(PrefabLocation, Vector3.zero, Quaternion.identity);
			Debug.Log("[PlayerSpawner] Spawned '" + PrefabLocation + "' in scene: " + SceneManager.GetActiveScene().name);
		}

		private static bool IsOwnedLiveView(GameObject avatar)
		{
			PhotonView component = avatar.GetComponent<PhotonView>();
			if (component != null && component.IsMine)
			{
				return component.ViewID != 0;
			}
			return false;
		}
	}
}
