using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using LethalApeR.Quests;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.Autumn
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class AutumnBushSystem : MonoBehaviour, IOnEventCallback
	{
		private struct Volume
		{
			public Vector3 center;

			public float radiusSq;

			public float halfHeight;

			public float cooldown;

			public float nextAllowedTime;

			public bool inside;
		}

		private class Fx
		{
			public GameObject go;

			public ParticleSystem[] systems;

			public AudioSource source;

			public float freeAt;

			public bool busy;
		}

		public const byte EvtBushRustle = 120;

		public const string SystemResourcePath = "Systems/AutumnBushSystem";

		[Header("Leaf Burst")]
		[Tooltip("Particle prefab spawned at the bush centre. Pooled — never instantiated at runtime.")]
		[SerializeField]
		private GameObject burstPrefab;

		[Tooltip("Concurrent bursts. Beyond this the one finishing soonest is stolen.")]
		[SerializeField]
		private int poolSize = 6;

		[Header("Audio")]
		[Tooltip("One is picked at random per burst. 3D-positioned but NOT Meta-spatialized (spatialize = 1 sources go silent in the editor — see the project agreement).")]
		[SerializeField]
		private AudioClip[] rustleClips;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.85f;

		[SerializeField]
		private Vector2 pitchRange = new Vector2(0.92f, 1.08f);

		[SerializeField]
		private float audioMinDistance = 2f;

		[SerializeField]
		private float audioMaxDistance = 22f;

		[Header("Burst Placement")]
		[Tooltip("Vertical offset in metres applied to the burst spawn, on top of the bush's detection-volume centre. The volume centre sits about a third of the way up the canopy, which puts the emitter inside/below the mesh on these bushes.")]
		[SerializeField]
		private float burstYOffset = -2.29f;

		[Tooltip("Uniform scale for the leaf burst. Applied to the particle system's OWN transform, not the pool root — the system's scalingMode is Local, so a parent scale would be silently ignored and the leaves would stay tiny.")]
		[SerializeField]
		private float burstScale = 4.202765f;

		[Tooltip("Local Y of the leaf-burst clone INSIDE its pool slot, in metres. Separate from Burst Y Offset, which moves the whole slot (burst + audio source) together. This one lifts only the emitter, so the leaves start above the canopy while the rustle still plays from the bush itself.")]
		[SerializeField]
		private float burstLocalY = 3.551f;

		[Header("Detection")]
		[Tooltip("Minimum seconds between two LOCAL bush pops, across all bushes. Stops one dive through overlapping hedges reading as three separate events.")]
		[SerializeField]
		private float localEntryThrottle = 0.35f;

		[Header("Networking")]
		[SerializeField]
		private bool broadcast = true;

		[Tooltip("Remote bursts further than this from your head are dropped before they touch the pool.")]
		[SerializeField]
		private float remoteCullDistance = 35f;

		[Tooltip("Flood guard: at most this many sends per window, per client.")]
		[SerializeField]
		private int maxSendsPerWindow = 8;

		[SerializeField]
		private float sendWindowSeconds = 3f;

		[Header("Feel")]
		[SerializeField]
		private bool hapticsOnEntry = true;

		[SerializeField]
		[Range(0f, 1f)]
		private float hapticAmplitude = 0.35f;

		[SerializeField]
		private float hapticDuration = 0.09f;

		private static readonly List<AutumnBush> _bushes = new List<AutumnBush>(160);

		private static readonly List<Volume> _volumes = new List<Volume>(160);

		private static bool _quitting;

		private readonly List<Fx> _pool = new List<Fx>();

		private float _fxLife = 2.5f;

		private float _nextLocalEntryAllowed;

		private int _sendsThisWindow;

		private float _sendWindowEndsAt;

		private bool _warnedNoAssets;

		private bool _warnedOverride;

		public static AutumnBushSystem Instance { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_bushes.Clear();
			_volumes.Clear();
			_quitting = false;
			Instance = null;
		}

		public static void Register(AutumnBush bush)
		{
			if (bush == null || _quitting || _bushes.Contains(bush))
			{
				return;
			}
			_bushes.Add(bush);
			_volumes.Add(new Volume
			{
				center = bush.WorldCenter,
				radiusSq = bush.WorldRadius * bush.WorldRadius,
				halfHeight = bush.WorldHalfHeight,
				cooldown = Mathf.Max(0.1f, bush.reEntryCooldown),
				nextAllowedTime = 0f,
				inside = false
			});
			EnsureInstance();
		}

		public static void Unregister(AutumnBush bush)
		{
			if (bush == null)
			{
				return;
			}
			int num = _bushes.IndexOf(bush);
			if (num >= 0)
			{
				int index = _bushes.Count - 1;
				_bushes[num] = _bushes[index];
				_volumes[num] = _volumes[index];
				_bushes.RemoveAt(index);
				_volumes.RemoveAt(index);
			}
		}

		public static void RefreshVolume(AutumnBush bush)
		{
			if (bush == null)
			{
				return;
			}
			int num = _bushes.IndexOf(bush);
			if (num >= 0)
			{
				bush.RefreshCachedVolume();
				Volume value = _volumes[num];
				value.center = bush.WorldCenter;
				value.radiusSq = bush.WorldRadius * bush.WorldRadius;
				value.halfHeight = bush.WorldHalfHeight;
				_volumes[num] = value;
			}
		}

		private static void EnsureInstance()
		{
			if (Instance != null || _quitting)
			{
				return;
			}
			AutumnBushSystem autumnBushSystem = Object.FindAnyObjectByType<AutumnBushSystem>(FindObjectsInactive.Include);
			if (autumnBushSystem == null)
			{
				GameObject gameObject = Resources.Load<GameObject>(SystemResourcePath);
				GameObject gameObject2 = ((gameObject != null) ? Object.Instantiate(gameObject) : new GameObject("AutumnBushSystem (auto)"));
				gameObject2.name = "AutumnBushSystem";
				autumnBushSystem = gameObject2.GetComponent<AutumnBushSystem>();
				if (autumnBushSystem == null)
				{
					autumnBushSystem = gameObject2.AddComponent<AutumnBushSystem>();
				}
			}
			autumnBushSystem.Claim();
		}

		private void Claim()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
			base.transform.SetParent(null, worldPositionStays: true);
			Object.DontDestroyOnLoad(base.gameObject);
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			Claim();
			BuildPool();
		}

		private void OnEnable()
		{
			PhotonNetwork.AddCallbackTarget(this);
		}

		private void OnDisable()
		{
			PhotonNetwork.RemoveCallbackTarget(this);
		}

		private void OnApplicationQuit()
		{
			_quitting = true;
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
			ReleaseFinishedFx();
			int count = _volumes.Count;
			if (count == 0 || !TryGetHeadPosition(out var head))
			{
				return;
			}
			float time = Time.time;
			bool flag = time < _nextLocalEntryAllowed;
			for (int i = 0; i < count; i++)
			{
				Volume value = _volumes[i];
				bool flag2 = false;
				float num = head.y - value.center.y;
				if (num <= value.halfHeight && num >= 0f - value.halfHeight)
				{
					float num2 = head.x - value.center.x;
					float num3 = head.z - value.center.z;
					flag2 = num2 * num2 + num3 * num3 <= value.radiusSq;
				}
				if (!value.inside && flag2 && !flag && time >= value.nextAllowedTime)
				{
					value.inside = true;
					value.nextAllowedTime = time + value.cooldown;
					_volumes[i] = value;
					_nextLocalEntryAllowed = time + Mathf.Max(0f, localEntryThrottle);
					HandleLocalEntry(i);
					flag = true;
				}
				else if (value.inside != flag2)
				{
					value.inside = flag2;
					_volumes[i] = value;
				}
			}
		}

		private void HandleLocalEntry(int index)
		{
			if (index >= 0 && index < _bushes.Count)
			{
				AutumnBush autumnBush = _bushes[index];
				if (!(autumnBush == null))
				{
					Vector3 center = _volumes[index].center;
					PlayEffect(center, autumnBush.burstPrefabOverride, autumnBush.tint);
					Broadcast(center);
					if (hapticsOnEntry)
					{
						PulseBothHands();
					}
					QuestEvents.RaiseLocalPlayerJumpedInBush(center);
				}
			}
		}

		private static bool TryGetHeadPosition(out Vector3 head)
		{
			head = default(Vector3);
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (instance != null)
				{
					if (instance.headCollider != null)
					{
						head = instance.headCollider.transform.position;
						return true;
					}
					if (instance.mainCamera != null)
					{
						head = instance.mainCamera.transform.position;
						return true;
					}
				}
			}
			Camera main = Camera.main;
			if (main == null)
			{
				return false;
			}
			head = main.transform.position;
			return true;
		}

		private void PulseBothHands()
		{
			InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(XRNode.LeftHand);
			InputDevice deviceAtXRNode2 = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);
			float amplitude = Mathf.Clamp01(hapticAmplitude);
			float duration = Mathf.Max(0f, hapticDuration);
			if (deviceAtXRNode.isValid)
			{
				deviceAtXRNode.SendHapticImpulse(0u, amplitude, duration);
			}
			if (deviceAtXRNode2.isValid)
			{
				deviceAtXRNode2.SendHapticImpulse(0u, amplitude, duration);
			}
		}

		private void Broadcast(Vector3 center)
		{
			if (!broadcast || !PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			float time = Time.time;
			if (time >= _sendWindowEndsAt)
			{
				_sendWindowEndsAt = time + Mathf.Max(0.5f, sendWindowSeconds);
				_sendsThisWindow = 0;
			}
			else if (_sendsThisWindow >= Mathf.Max(1, maxSendsPerWindow))
			{
				return;
			}
			_sendsThisWindow++;
			PhotonNetwork.RaiseEvent(EvtBushRustle, center, new RaiseEventOptions
			{
				Receivers = ReceiverGroup.Others,
				CachingOption = EventCaching.DoNotCache
			}, SendOptions.SendReliable);
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent != null && photonEvent.Code == EvtBushRustle && photonEvent.CustomData is Vector3)
			{
				Vector3 vector = (Vector3)photonEvent.CustomData;
				if (!TryGetHeadPosition(out var head) || !((head - vector).sqrMagnitude > Mathf.Max(1f, remoteCullDistance) * Mathf.Max(1f, remoteCullDistance)))
				{
					PlayEffect(vector, null, Color.white);
				}
			}
		}

		private void BuildPool()
		{
			int num = Mathf.Clamp(poolSize, 1, 24);
			for (int i = 0; i < num; i++)
			{
				_pool.Add(CreateFx(i));
			}
			float num2 = 0.6f;
			for (int j = 0; j < _pool.Count; j++)
			{
				ParticleSystem[] systems = _pool[j].systems;
				foreach (ParticleSystem particleSystem in systems)
				{
					if (!(particleSystem == null))
					{
						ParticleSystem.MainModule main = particleSystem.main;
						num2 = Mathf.Max(num2, main.duration + main.startLifetime.constantMax);
					}
				}
			}
			if (rustleClips != null)
			{
				for (int l = 0; l < rustleClips.Length; l++)
				{
					if (rustleClips[l] != null)
					{
						num2 = Mathf.Max(num2, rustleClips[l].length);
					}
				}
			}
			_fxLife = Mathf.Clamp(num2, 0.6f, 8f);
		}

		private Fx CreateFx(int index)
		{
			GameObject gameObject = new GameObject("BushFx_" + index);
			gameObject.transform.SetParent(base.transform, worldPositionStays: false);
			ParticleSystem[] array;
			if (burstPrefab != null)
			{
				GameObject gameObject2 = Object.Instantiate(burstPrefab, gameObject.transform);
				gameObject2.transform.localPosition = new Vector3(0f, burstLocalY, 0f);
				gameObject2.transform.localRotation = Quaternion.identity;
				gameObject2.transform.localScale = Vector3.one * Mathf.Max(0.01f, burstScale);
				array = gameObject2.GetComponentsInChildren<ParticleSystem>(includeInactive: true);
				for (int i = 0; i < array.Length; i++)
				{
					ParticleSystem.MainModule main = array[i].main;
					main.playOnAwake = false;
				}
			}
			else
			{
				array = new ParticleSystem[0];
			}
			AudioSource audioSource = gameObject.AddComponent<AudioSource>();
			audioSource.playOnAwake = false;
			audioSource.loop = false;
			audioSource.spatialBlend = 1f;
			audioSource.spatialize = false;
			audioSource.rolloffMode = AudioRolloffMode.Linear;
			audioSource.minDistance = Mathf.Max(0.1f, audioMinDistance);
			audioSource.maxDistance = Mathf.Max(audioSource.minDistance + 0.1f, audioMaxDistance);
			audioSource.dopplerLevel = 0f;
			gameObject.SetActive(value: false);
			return new Fx
			{
				go = gameObject,
				systems = array,
				source = audioSource,
				freeAt = 0f,
				busy = false
			};
		}

		public void PlayEffect(Vector3 worldPosition, GameObject prefabOverride, Color tint)
		{
			if (_pool.Count == 0)
			{
				return;
			}
			if (burstPrefab == null && PickClip() == null)
			{
				if (!_warnedNoAssets)
				{
					_warnedNoAssets = true;
					Debug.LogWarning("[AutumnBushSystem] No burst prefab and no rustle clips assigned — bush entries still count for quests but produce no feedback. Run Tools ▸ Autumn ▸ Wire Bush System, then drop a rustle clip on the system prefab.");
				}
				return;
			}
			if (prefabOverride != null && prefabOverride != burstPrefab && !_warnedOverride)
			{
				_warnedOverride = true;
				Debug.LogWarning("[AutumnBushSystem] burstPrefabOverride is ignored — the burst pool is shared. Use the bush's tint, or change the system's burstPrefab.");
			}
			Fx fx = TakeFx();
			fx.go.transform.position = worldPosition + new Vector3(0f, burstYOffset, 0f);
			fx.go.transform.rotation = Quaternion.identity;
			fx.go.SetActive(value: true);
			ParticleSystem[] systems = fx.systems;
			foreach (ParticleSystem particleSystem in systems)
			{
				if (!(particleSystem == null))
				{
					ApplyTint(particleSystem, tint);
					particleSystem.Clear(withChildren: true);
					particleSystem.Play(withChildren: true);
				}
			}
			AudioClip audioClip = PickClip();
			if (audioClip != null)
			{
				fx.source.clip = audioClip;
				fx.source.pitch = Random.Range(pitchRange.x, pitchRange.y);
				fx.source.volume = Mathf.Clamp01(volume);
				fx.source.Play();
			}
			fx.busy = true;
			fx.freeAt = Time.time + _fxLife;
		}

		private AudioClip PickClip()
		{
			if (rustleClips == null || rustleClips.Length == 0)
			{
				return null;
			}
			int num = 0;
			for (int i = 0; i < rustleClips.Length; i++)
			{
				if (rustleClips[i] != null)
				{
					num++;
				}
			}
			if (num == 0)
			{
				return null;
			}
			int num2 = Random.Range(0, num);
			for (int j = 0; j < rustleClips.Length; j++)
			{
				if (!(rustleClips[j] == null))
				{
					if (num2 == 0)
					{
						return rustleClips[j];
					}
					num2--;
				}
			}
			return null;
		}

		private static void ApplyTint(ParticleSystem ps, Color tint)
		{
			if (!(tint == Color.white))
			{
				ParticleSystem.MainModule main = ps.main;
				if (main.startColor.mode == ParticleSystemGradientMode.Color)
				{
					main.startColor = new ParticleSystem.MinMaxGradient(tint * main.startColor.color);
				}
			}
		}

		private Fx TakeFx()
		{
			for (int i = 0; i < _pool.Count; i++)
			{
				if (!_pool[i].busy)
				{
					return _pool[i];
				}
			}
			int index = 0;
			for (int j = 1; j < _pool.Count; j++)
			{
				if (_pool[j].freeAt < _pool[index].freeAt)
				{
					index = j;
				}
			}
			Fx fx = _pool[index];
			if (fx.source != null)
			{
				fx.source.Stop();
			}
			for (int k = 0; k < fx.systems.Length; k++)
			{
				if (fx.systems[k] != null)
				{
					fx.systems[k].Clear(withChildren: true);
				}
			}
			return fx;
		}

		private void ReleaseFinishedFx()
		{
			float time = Time.time;
			for (int i = 0; i < _pool.Count; i++)
			{
				Fx fx = _pool[i];
				if (fx.busy && !(time < fx.freeAt))
				{
					fx.busy = false;
					if (fx.source != null)
					{
						fx.source.Stop();
					}
					if (fx.go != null)
					{
						fx.go.SetActive(value: false);
					}
				}
			}
		}
	}
}
