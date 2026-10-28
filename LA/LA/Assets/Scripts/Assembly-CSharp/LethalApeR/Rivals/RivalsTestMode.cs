using System.Collections.Generic;
using LethalApeR.Rivals.Testing;
using UnityEngine;
using UnityEngine.InputSystem;

namespace LethalApeR.Rivals
{
	public class RivalsTestMode : MonoBehaviour
	{
		[Header("Enable")]
		[Tooltip("Master switch. Turn OFF for shipping device builds.")]
		public bool enableTestMode = true;

		[Header("Dummy")]
		[Tooltip("Optional. A prefab with a RivalsDummy + collider(s). If empty, a capsule target is built at runtime.")]
		public GameObject dummyPrefab;

		[Tooltip("Team the spawned dummies belong to (TeamB = shootable by a TeamA tester).")]
		public Team dummyTeam = Team.TeamB;

		public float dummyHealth = 100f;

		[Tooltip("Metres in front of the camera to place a spawned dummy.")]
		public float spawnDistance = 3f;

		[Tooltip("Drop the spawn point to this Y (floor height). Set to the arena floor; leave as-is to keep camera height.")]
		public bool snapToCameraHeight;

		[Header("Hotkeys (new Input System)")]
		[Tooltip("Spawn a dummy in front of you.")]
		public Key spawnKey = Key.T;

		[Tooltip("Remove all spawned dummies.")]
		public Key clearKey = Key.Y;

		[Tooltip("Start a solo match vs a freshly-spawned TeamB dummy (walks the whole flow alone).")]
		public Key startSoloMatchKey = Key.G;

		private readonly List<GameObject> _spawned = new List<GameObject>();

		private Camera _cam;

		public static RivalsTestMode Instance { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Update()
		{
			if (!enableTestMode)
			{
				return;
			}
			Keyboard current = Keyboard.current;
			if (current == null)
			{
				return;
			}
			if (spawnKey != Key.None && current[spawnKey].wasPressedThisFrame)
			{
				SpawnDummy();
			}
			if (clearKey != Key.None && current[clearKey].wasPressedThisFrame)
			{
				ClearDummies();
			}
			if (startSoloMatchKey != Key.None && current[startSoloMatchKey].wasPressedThisFrame)
			{
				StartSoloMatch();
			}
		}

		[ContextMenu("Start Solo Match")]
		public void StartSoloMatch()
		{
			dummyTeam = Team.TeamB;
			SpawnDummy();
			if (GamemodeManager.Instance != null)
			{
				GamemodeManager.Instance.ForceSoloStart();
			}
			else
			{
				Debug.LogWarning("[RivalsTestMode] No GamemodeManager in the scene to start a match.");
			}
		}

		[ContextMenu("Spawn Dummy")]
		public GameObject SpawnDummy()
		{
			Transform view = ResolveView();
			Vector3 pos;
			Quaternion rot;
			if (view != null)
			{
				Vector3 forward = view.forward;
				forward.y = 0f;
				if (forward.sqrMagnitude < 0.0001f)
				{
					forward = Vector3.forward;
				}
				forward.Normalize();
				pos = view.position + forward * spawnDistance;
				if (!snapToCameraHeight)
				{
					pos.y = view.position.y;
				}
				rot = Quaternion.LookRotation(-forward, Vector3.up);
			}
			else
			{
				pos = base.transform.position + base.transform.forward * spawnDistance;
				rot = Quaternion.identity;
			}
			GameObject go = (dummyPrefab != null) ? Object.Instantiate(dummyPrefab, pos, rot) : BuildCapsuleDummy(pos, rot);
			RivalsDummy dummy = go.GetComponent<RivalsDummy>();
			if (dummy == null)
			{
				dummy = go.AddComponent<RivalsDummy>();
			}
			dummy.team = dummyTeam;
			dummy.logHits = true;
			dummy.maxHealth = dummyHealth;
			dummy.Revive();
			go.name = string.Format("RivalsDummy ({0}) #{1}", dummyTeam, _spawned.Count + 1);
			_spawned.Add(go);
			return go;
		}

		[ContextMenu("Clear Dummies")]
		public void ClearDummies()
		{
			foreach (GameObject item in _spawned)
			{
				if (item != null)
				{
					Object.Destroy(item);
				}
			}
			_spawned.Clear();
		}

		private GameObject BuildCapsuleDummy(Vector3 pos, Quaternion rot)
		{
			GameObject root = new GameObject("Dummy");
			root.transform.SetPositionAndRotation(pos, rot);
			GameObject body = GameObject.CreatePrimitive(PrimitiveType.Capsule);
			body.name = "Body";
			body.transform.SetParent(root.transform, false);
			body.transform.localPosition = new Vector3(0f, 1f, 0f);
			TintRenderer(body, dummyTeam.ToColor());
			GameObject head = GameObject.CreatePrimitive(PrimitiveType.Sphere);
			head.name = "Head";
			head.transform.SetParent(root.transform, false);
			head.transform.localPosition = new Vector3(0f, 2.05f, 0f);
			head.transform.localScale = Vector3.one * 0.6f;
			TintRenderer(head, dummyTeam.ToColor());
			RivalsDummy dummy = root.AddComponent<RivalsDummy>();
			dummy.flashRenderer = body.GetComponent<Renderer>();
			return root;
		}

		private static void TintRenderer(GameObject go, Color c)
		{
			Renderer component = go.GetComponent<Renderer>();
			if (component != null)
			{
				component.material.color = c;
			}
		}

		private Transform ResolveView()
		{
			if (_cam == null)
			{
				_cam = Camera.main;
			}
			if (_cam != null)
			{
				return _cam.transform;
			}
			if (GorillaLocomotion.Player.Instance != null && GorillaLocomotion.Player.Instance.headCollider != null)
			{
				return GorillaLocomotion.Player.Instance.headCollider.transform;
			}
			return null;
		}
	}
}
