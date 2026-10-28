using System;
using System.Collections;
using GorillaLocomotion;
using LethalApe.SDK;
using LethalApeR.SceneFlow;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[DefaultExecutionOrder(-300)]
	[DisallowMultipleComponent]
	public sealed class CustomMapHost : MonoBehaviour
	{
		public enum HostState
		{
			Idle = 0,
			Loading = 1,
			Loaded = 2,
			Unloading = 3
		}

		[Header("Sandbox")]
		[SerializeField]
		[Tooltip("Sandbox's own content, hidden while a custom map is loaded.")]
		private GameObject[] defaultArea = Array.Empty<GameObject>();

		[SerializeField]
		[Tooltip("Where players return to when they leave a custom map.")]
		private Transform sandboxSpawn;

		[SerializeField]
		[Tooltip("Sandbox's directional light. Map Settings drives it while a map is loaded.")]
		private Light sun;

		[Header("Assets")]
		[SerializeField]
		private MapShaderLibrary shaders;

		[SerializeField]
		private PlacementPrefabSet placements;

		[SerializeField]
		private MapFeatureAssets featureAssets;

		[Header("Transitions")]
		[SerializeField]
		[Min(0f)]
		private float fadeOut = 0.35f;

		[SerializeField]
		[Min(0f)]
		private float fadeIn = 0.5f;

		private readonly MapEnvironment _environment = new MapEnvironment();

		public static CustomMapHost Instance { get; private set; }

		public HostState State { get; private set; }

		public LoadedMap Current { get; private set; }

		public MapRuntime Runtime { get; private set; }

		public MapPackage CurrentPackage => Current?.Package;

		public bool IsBusy
		{
			get
			{
				if (State != HostState.Loading)
				{
					return State == HostState.Unloading;
				}
				return true;
			}
		}

		public MapFeatureAssets FeatureAssets => featureAssets;

		public string LastError { get; private set; }

		public MapEnvironment Environment => _environment;

		public bool RuntimePending
		{
			get
			{
				if (State == HostState.Loaded && Current != null)
				{
					return Runtime == null;
				}
				return false;
			}
		}

		public event Action<MapPackage> MapLoaded;

		public event Action MapUnloaded;

		public event Action<string> LoadFailed;

		public event Action StateChanged;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Debug.LogError("[CustomMaps] Two CustomMapHosts in the scene; disabling this one.", this);
				base.enabled = false;
				return;
			}
			Instance = this;
			if (sun == null)
			{
				sun = RenderSettings.sun;
			}
		}

		private void Start()
		{
			if (MapCompatibility.PlatformSupportsCustomMaps)
			{
				MapCatalog.Refresh();
			}
		}

		private void OnDestroy()
		{
			if (Instance != this)
			{
				return;
			}
			Instance = null;
			if (Runtime != null)
			{
				Runtime.Shutdown();
			}
			_environment.Restore();
			if (Current != null && Current.Bundle != null)
			{
				Current.Bundle.Unload(true);
			}
			Current = null;
			MapShaderRemapper.Forget();
		}

		public bool IsLoaded(string key)
		{
			if (State == HostState.Loaded && Current != null)
			{
				return Current.Key == key;
			}
			return false;
		}

		public bool LoadMap(MapPackage package, Action<bool, string> done = null, bool startRuntime = true)
		{
			if (package == null)
			{
				return false;
			}
			if (IsBusy || SceneTransition.IsBusy)
			{
				return false;
			}
			StartCoroutine(LoadRoutine(package, done, startRuntime));
			return true;
		}

		public void StartRuntime()
		{
			if (RuntimePending)
			{
				StartCoroutine(StartRuntimeRoutine());
			}
		}

		private IEnumerator StartRuntimeRoutine()
		{
			Runtime = MapRuntime.Create(Current, this);
			yield return null;
			Runtime.SendToSpawn();
			Freeze(false);
			yield return Fade(0f, fadeIn);
		}

		public bool ReloadMap(Action<bool, string> done = null, bool startRuntime = true)
		{
			if (Current == null || IsBusy)
			{
				return false;
			}
			return LoadMap(Current.Package, done, startRuntime);
		}

		public bool UnloadMap(Action done = null)
		{
			if (IsBusy || Current == null)
			{
				return false;
			}
			StartCoroutine(UnloadRoutine(done, true));
			return true;
		}

		private IEnumerator LoadRoutine(MapPackage package, Action<bool, string> done, bool startRuntime)
		{
			SetState(HostState.Loading);
			LastError = null;
			yield return Fade(1f, fadeOut);
			Freeze(true);
			if (Current != null)
			{
				yield return Teardown();
			}
			LoadedMap loaded = null;
			string error = null;
			yield return MapLoader.Load(package, shaders, delegate(LoadedMap m, string e)
			{
				loaded = m;
				error = e;
			});
			if (loaded == null)
			{
				LastError = error ?? "The map failed to load.";
				Debug.LogWarning(string.Format("[CustomMaps] Couldn't load {0}: {1}", package, LastError));
				SetDefaultArea(true);
				Freeze(false);
				SetState(HostState.Idle);
				yield return Fade(0f, fadeIn);
				this.LoadFailed?.Invoke(LastError);
				done?.Invoke(false, LastError);
				yield break;
			}
			Current = loaded;
			SetDefaultArea(false);
			Material skybox = MapShaderRemapper.RemapSkybox(loaded.Settings.Skybox, shaders);
			_environment.Apply(loaded.Settings, skybox, sun, MapCamera());
			MapPlacementResolver.Spawn(loaded, placements);
			yield return null;
			yield return null;
			SetState(HostState.Loaded);
			this.MapLoaded?.Invoke(package);
			done?.Invoke(true, null);
			if (startRuntime)
			{
				yield return StartRuntimeRoutine();
			}
		}

		private IEnumerator UnloadRoutine(Action done, bool teleportHome)
		{
			SetState(HostState.Unloading);
			yield return Fade(1f, fadeOut);
			Freeze(true);
			yield return Teardown();
			if (teleportHome)
			{
				SendHome();
			}
			Freeze(false);
			SetState(HostState.Idle);
			this.MapUnloaded?.Invoke();
			done?.Invoke();
			yield return Fade(0f, fadeIn);
		}

		private IEnumerator Teardown()
		{
			if (Runtime != null)
			{
				Runtime.Shutdown();
				Runtime = null;
			}
			_environment.Restore();
			LoadedMap current = Current;
			Current = null;
			yield return MapLoader.Unload(current);
			SetDefaultArea(true);
		}

		private void SendHome()
		{
			if (MapPlayer.Ready)
			{
				if (sandboxSpawn != null)
				{
					MapPlayer.TeleportFeet(sandboxSpawn.position, sandboxSpawn.eulerAngles.y);
				}
				else
				{
					Player.Instance.TeleportToSpawn();
				}
			}
		}

		private void SetDefaultArea(bool visible)
		{
			for (int i = 0; i < defaultArea.Length; i++)
			{
				GameObject gameObject = defaultArea[i];
				if (gameObject != null)
				{
					gameObject.SetActive(visible);
				}
			}
		}

		private void SetState(HostState state)
		{
			State = state;
			this.StateChanged?.Invoke();
		}

		private static void Freeze(bool frozen)
		{
			if (!MapPlayer.Ready)
			{
				return;
			}
			Player instance = Player.Instance;
			instance.disableMovement = frozen;
			if (frozen)
			{
				Rigidbody playerRigidBody = instance.playerRigidBody;
				if (playerRigidBody != null && !playerRigidBody.isKinematic)
				{
					playerRigidBody.linearVelocity = Vector3.zero;
					playerRigidBody.angularVelocity = Vector3.zero;
				}
			}
		}

		private static IEnumerator Fade(float target, float seconds)
		{
			SceneFadeOverlay sceneFadeOverlay = SceneFadeOverlay.Ensure();
			if (!(sceneFadeOverlay == null))
			{
				yield return sceneFadeOverlay.FadeTo(target, seconds);
			}
		}

		private Camera MapCamera()
		{
			Transform head = MapPlayer.Head;
			Camera camera = ((head != null) ? head.GetComponent<Camera>() : null);
			if (camera != null)
			{
				return camera;
			}
			return Camera.main;
		}

		public SpawnPoint PickSpawn(SpawnPoint[] spawns)
		{
			if (spawns == null || spawns.Length == 0)
			{
				return null;
			}
			return spawns[UnityEngine.Random.Range(0, spawns.Length)];
		}
	}
}
