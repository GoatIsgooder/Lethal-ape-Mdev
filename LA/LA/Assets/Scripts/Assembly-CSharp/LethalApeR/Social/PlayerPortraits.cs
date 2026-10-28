using System.Collections.Generic;
using System.Runtime.CompilerServices;
using LethalApeR.Networking;
using LethalApeR.Social.UI;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Social
{
	public sealed class PlayerPortraits : MonoBehaviour
	{
		private sealed class Slot
		{
			public int Index;

			public MonkeDevNetworkingPlayer Player;

			public int Signature;

			public bool Rendered;

			public float DueAt = -1f;

			public float LastUsed;
		}

		private const string LayerName = "Portrait";

		private const int AtlasSize = 1024;

		private const int CellSize = 128;

		private const int Columns = 8;

		private const int CellCount = 64;

		private const int Gutter = 4;

		private const int FramesBetweenRenders = 3;

		private const float SettleSeconds = 0.6f;

		private const float WatchInterval = 1f;

		private const float CameraDistance = 0.62f;

		private const float FieldOfView = 26f;

		private static readonly Color VolumeBase = new Color(0.4f, 0.39f, 0.4f, 1f);

		private static readonly Color VolumeTowardsKey = new Color(0.27f, 0.26f, 0.25f, 1f);

		private static readonly int Volume0 = Shader.PropertyToID("_Volume0");

		private static readonly int Volume1 = Shader.PropertyToID("_Volume1");

		private static readonly int Volume2 = Shader.PropertyToID("_Volume2");

		private static readonly int VolumeMask = Shader.PropertyToID("_VolumeMask");

		private static readonly int GlobalVolumeMin = Shader.PropertyToID("_GlobalVolumeMin");

		private static readonly int GlobalVolumeInvSize = Shader.PropertyToID("_GlobalVolumeInvSize");

		private static PlayerPortraits _instance;

		private static bool _quitting;

		private readonly Slot[] _slots = new Slot[64];

		private readonly Dictionary<MonkeDevNetworkingPlayer, Slot> _byPlayer = new Dictionary<MonkeDevNetworkingPlayer, Slot>(64);

		private readonly List<Renderer> _renderers = new List<Renderer>(64);

		private readonly List<int> _layers = new List<int>(64);

		private readonly List<LightProbeUsage> _probes = new List<LightProbeUsage>(64);

		private readonly List<ReflectionProbeUsage> _reflections = new List<ReflectionProbeUsage>(64);

		private readonly Color[] _voxels = new Color[8];

		private RenderTexture _atlas;

		private Camera _camera;

		private Material _alphaMaterial;

		private Mesh _alphaQuad;

		private Light _key;

		private Light _fill;

		private Light _rim;

		private Texture3D _volume0;

		private Texture3D _volume1;

		private Texture3D _volume2;

		private Texture3D _volumeMask;

		private SphericalHarmonicsL2 _ambient;

		private int _layer = -1;

		private int _nextRenderFrame;

		private float _nextWatch;

		private readonly List<MonkeDevNetworkingPlayer> _dead = new List<MonkeDevNetworkingPlayer>(4);

		public static PlayerPortraits Instance
		{
			get
			{
				if (_instance == null && !_quitting)
				{
					GameObject gameObject = new GameObject("[Social] Portraits");
					Object.DontDestroyOnLoad(gameObject);
					_instance = gameObject.AddComponent<PlayerPortraits>();
				}
				return _instance;
			}
		}

		public Texture Atlas => _atlas;

		public bool Usable
		{
			get
			{
				if (_atlas != null)
				{
					return _layer >= 0;
				}
				return false;
			}
		}

		private void Awake()
		{
			for (int i = 0; i < CellCount; i++)
			{
				_slots[i] = new Slot
				{
					Index = i
				};
			}
			_layer = LayerMask.NameToLayer(LayerName);
			if (_layer < 0)
			{
				Debug.LogError("[Social] No 'Portrait' layer: portraits are off. Add it in Tags and Layers.");
				return;
			}
			_atlas = new RenderTexture(AtlasSize, AtlasSize, 16, RenderTextureFormat.ARGB32)
			{
				name = "Social Portrait Atlas",
				useMipMap = true,
				autoGenerateMips = true,
				filterMode = FilterMode.Trilinear,
				wrapMode = TextureWrapMode.Clamp,
				antiAliasing = 1
			};
			_atlas.Create();
			Clear();
			GameObject gameObject = new GameObject("Portrait Camera");
			gameObject.transform.SetParent(base.transform, worldPositionStays: false);
			_camera = gameObject.AddComponent<Camera>();
			_camera.enabled = false;
			_camera.cullingMask = 1 << _layer;
			_camera.clearFlags = CameraClearFlags.Color;
			_camera.backgroundColor = SocialStyle.Tile;
			_camera.fieldOfView = FieldOfView;
			_camera.nearClipPlane = 0.05f;
			_camera.farClipPlane = 2f;
			_camera.allowHDR = false;
			_camera.allowMSAA = false;
			_camera.useOcclusionCulling = false;
			_camera.stereoTargetEye = StereoTargetEyeMask.None;
			_camera.renderingPath = RenderingPath.Forward;
			_camera.targetTexture = _atlas;
			AddAlphaPass();
			_key = StudioLight("Portrait Key", new Color(1f, 0.95f, 0.88f, 1f), 1.25f);
			_fill = StudioLight("Portrait Fill", new Color(0.72f, 0.8f, 1f, 1f), 0.45f);
			_rim = StudioLight("Portrait Rim", new Color(0.82f, 0.82f, 1f, 1f), 1f);
			_volume0 = Volume("Portrait Volume 0");
			_volume1 = Volume("Portrait Volume 1");
			_volume2 = Volume("Portrait Volume 2");
			_volumeMask = Volume("Portrait Volume Mask");
			FillVolume(_volumeMask, Color.white);
			_ambient = default(SphericalHarmonicsL2);
			_ambient.AddAmbientLight(new Color(0.14f, 0.14f, 0.16f));
			_ambient.AddDirectionalLight(Vector3.up, new Color(0.28f, 0.27f, 0.3f), 0.8f);
			_ambient.AddDirectionalLight(Vector3.down, new Color(0.08f, 0.06f, 0.04f), 0.6f);
		}

		private void AddAlphaPass()
		{
			SocialAssets instance = SocialAssets.Instance;
			Shader shader = ((instance != null) ? instance.portraitAlphaShader : null);
			if (shader == null)
			{
				Debug.LogWarning("[Social] SocialAssets has no portrait alpha shader: some eyes will show as holes. Run Slop > Social > Build Social UI.");
				return;
			}
			_alphaMaterial = new Material(shader)
			{
				name = "Portrait Alpha",
				hideFlags = HideFlags.HideAndDontSave
			};
			_alphaQuad = new Mesh
			{
				name = "Portrait Alpha Quad",
				hideFlags = HideFlags.HideAndDontSave
			};
			_alphaQuad.SetVertices(new List<Vector3>
			{
				new Vector3(-1f, -1f, 0f),
				new Vector3(-1f, 1f, 0f),
				new Vector3(1f, 1f, 0f),
				new Vector3(1f, -1f, 0f)
			});
			_alphaQuad.SetTriangles(new int[6] { 0, 1, 2, 0, 2, 3 }, 0);
			CommandBuffer commandBuffer = new CommandBuffer
			{
				name = "Portrait Alpha"
			};
			commandBuffer.DrawMesh(_alphaQuad, Matrix4x4.identity, _alphaMaterial, 0, -1);
			_camera.AddCommandBuffer(CameraEvent.AfterEverything, commandBuffer);
		}

		private Light StudioLight(string name, Color colour, float intensity)
		{
			GameObject gameObject = new GameObject(name);
			gameObject.transform.SetParent(base.transform, worldPositionStays: false);
			Light light = gameObject.AddComponent<Light>();
			light.type = LightType.Directional;
			light.color = colour;
			light.intensity = intensity;
			light.cullingMask = 1 << _layer;
			light.shadows = LightShadows.None;
			light.renderMode = LightRenderMode.ForcePixel;
			light.enabled = false;
			return light;
		}

		private static Texture3D Volume(string name)
		{
			return new Texture3D(2, 2, 2, TextureFormat.RGBAHalf, mipChain: false)
			{
				name = name,
				wrapMode = TextureWrapMode.Clamp,
				filterMode = FilterMode.Bilinear
			};
		}

		private void FillVolume(Texture3D volume, Color c)
		{
			for (int i = 0; i < _voxels.Length; i++)
			{
				_voxels[i] = c;
			}
			volume.SetPixels(_voxels);
			volume.Apply(updateMipmaps: false);
		}

		private void OnApplicationQuit()
		{
			_quitting = true;
		}

		private void OnDestroy()
		{
			if (_atlas != null)
			{
				_atlas.Release();
			}
			if (_volume0 != null)
			{
				Object.Destroy(_volume0);
			}
			if (_volume1 != null)
			{
				Object.Destroy(_volume1);
			}
			if (_volume2 != null)
			{
				Object.Destroy(_volume2);
			}
			if (_volumeMask != null)
			{
				Object.Destroy(_volumeMask);
			}
			if (_alphaMaterial != null)
			{
				Object.Destroy(_alphaMaterial);
			}
			if (_alphaQuad != null)
			{
				Object.Destroy(_alphaQuad);
			}
		}

		private void Clear()
		{
			RenderTexture active = RenderTexture.active;
			RenderTexture.active = _atlas;
			GL.Clear(clearDepth: true, clearColor: true, Color.clear);
			RenderTexture.active = active;
		}

		public bool TryGet(MonkeDevNetworkingPlayer player, out Rect uv)
		{
			uv = default(Rect);
			if (!Usable || player == null)
			{
				return false;
			}
			Slot slot = SlotFor(player);
			slot.LastUsed = Time.unscaledTime;
			if (!slot.Rendered && slot.DueAt < 0f)
			{
				slot.DueAt = Time.unscaledTime;
			}
			uv = UvOf(slot.Index);
			return slot.Rendered;
		}

		private void Update()
		{
			if (!Usable)
			{
				return;
			}
			float unscaledTime = Time.unscaledTime;
			if (unscaledTime >= _nextWatch)
			{
				_nextWatch = unscaledTime + WatchInterval;
				Watch(unscaledTime);
			}
			if (Time.frameCount < _nextRenderFrame)
			{
				return;
			}
			Slot slot = null;
			for (int i = 0; i < CellCount; i++)
			{
				Slot slot2 = _slots[i];
				if (!(slot2.Player == null) && !(slot2.DueAt < 0f) && !(slot2.DueAt > unscaledTime) && (slot == null || slot2.DueAt < slot.DueAt))
				{
					slot = slot2;
				}
			}
			if (slot != null)
			{
				_nextRenderFrame = Time.frameCount + FramesBetweenRenders;
				slot.DueAt = -1f;
				Render(slot);
			}
		}

		private void Watch(float now)
		{
			float dueAt = now + SettleSeconds;
			for (int i = 0; i < CellCount; i++)
			{
				Slot slot = _slots[i];
				if (slot.Player == null)
				{
					continue;
				}
				if (!slot.Player || slot.Player.photonView == null || slot.Player.photonView.Owner == null)
				{
					Free(slot);
				}
				else if (slot.Rendered && slot.DueAt < 0f && Signature(slot.Player) != slot.Signature)
				{
					slot.DueAt = dueAt;
				}
			}
		}

		private Slot SlotFor(MonkeDevNetworkingPlayer player)
		{
			if (_byPlayer.TryGetValue(player, out var value))
			{
				return value;
			}
			Slot slot = null;
			for (int i = 0; i < CellCount; i++)
			{
				Slot slot2 = _slots[i];
				if (slot2.Player == null)
				{
					slot = slot2;
					break;
				}
				if (slot == null || slot2.LastUsed < slot.LastUsed)
				{
					slot = slot2;
				}
			}
			if (slot.Player != null)
			{
				Free(slot);
			}
			slot.Player = player;
			slot.Rendered = false;
			slot.DueAt = -1f;
			_byPlayer[player] = slot;
			return slot;
		}

		private void Free(Slot s)
		{
			if (s != null)
			{
				if (s.Player != null)
				{
					_byPlayer.Remove(s.Player);
				}
				if (!s.Player)
				{
					PurgeDestroyedKeys();
				}
				s.Player = null;
				s.Rendered = false;
				s.DueAt = -1f;
			}
		}

		private void PurgeDestroyedKeys()
		{
			_dead.Clear();
			foreach (MonkeDevNetworkingPlayer key in _byPlayer.Keys)
			{
				if (!key)
				{
					_dead.Add(key);
				}
			}
			for (int i = 0; i < _dead.Count; i++)
			{
				_byPlayer.Remove(_dead[i]);
			}
		}

		private static Rect UvOf(int index)
		{
			int num = index % Columns;
			int num2 = index / Columns;
			float num3 = (float)Gutter / (float)AtlasSize;
			float num4 = (float)(CellSize - Gutter * 2) / (float)AtlasSize;
			return new Rect((float)num / (float)Columns + num3, (float)num2 / (float)Columns + num3, num4, num4);
		}

		private static int Signature(MonkeDevNetworkingPlayer p)
		{
			int num = p.currentPlayerColor.GetHashCode();
			if (p.photonView != null && p.photonView.Owner != null && p.photonView.Owner.CustomProperties.TryGetValue("Cosmetics", out var value) && value != null)
			{
				// RE: unsure - binary inlines il2cpp's identity hash ((ptr >> 3) * 0x9E3779B1); source may have been value.GetHashCode()
				num = num * 31 + RuntimeHelpers.GetHashCode(value);
			}
			return num;
		}

		private void Render(Slot slot)
		{
			MonkeDevNetworkingPlayer player = slot.Player;
			if (player == null || !player.isActiveAndEnabled || player.NetworkHidden || player.Head == null)
			{
				return;
			}
			_renderers.Clear();
			player.GetComponentsInChildren(includeInactive: false, _renderers);
			for (int num = _renderers.Count - 1; num >= 0; num--)
			{
				Renderer renderer = _renderers[num];
				if (!renderer.enabled || renderer is ParticleSystemRenderer || renderer is LineRenderer || renderer is TrailRenderer || renderer.GetComponent<TMP_Text>() != null)
				{
					_renderers.RemoveAt(num);
				}
			}
			if (_renderers.Count == 0)
			{
				return;
			}
			_layers.Clear();
			_probes.Clear();
			_reflections.Clear();
			for (int i = 0; i < _renderers.Count; i++)
			{
				Renderer renderer2 = _renderers[i];
				_layers.Add(renderer2.gameObject.layer);
				_probes.Add(renderer2.lightProbeUsage);
				_reflections.Add(renderer2.reflectionProbeUsage);
				renderer2.gameObject.layer = _layer;
				renderer2.lightProbeUsage = LightProbeUsage.Off;
				renderer2.reflectionProbeUsage = ReflectionProbeUsage.Off;
			}
			SphericalHarmonicsL2 ambientProbe = RenderSettings.ambientProbe;
			bool fog = RenderSettings.fog;
			float shadowDistance = QualitySettings.shadowDistance;
			Texture globalTexture = Shader.GetGlobalTexture(Volume0);
			Texture globalTexture2 = Shader.GetGlobalTexture(Volume1);
			Texture globalTexture3 = Shader.GetGlobalTexture(Volume2);
			Texture globalTexture4 = Shader.GetGlobalTexture(VolumeMask);
			Vector4 globalVector = Shader.GetGlobalVector(GlobalVolumeMin);
			Vector4 globalVector2 = Shader.GetGlobalVector(GlobalVolumeInvSize);
			try
			{
				Transform head = player.Head;
				Vector3 forward = head.forward;
				Vector3 up = head.up;
				Vector3 vector = head.position + up * 0.04f;
				Quaternion quaternion = Quaternion.LookRotation(-forward, up);
				_camera.transform.SetPositionAndRotation(vector + forward * CameraDistance, quaternion);
				_camera.rect = UvOf(slot.Index);
				_key.transform.rotation = quaternion * Quaternion.Euler(32f, 34f, 0f);
				_fill.transform.rotation = quaternion * Quaternion.Euler(6f, -48f, 0f);
				_rim.transform.rotation = quaternion * Quaternion.Euler(22f, 152f, 0f);
				RenderSettings.ambientProbe = _ambient;
				RenderSettings.fog = false;
				QualitySettings.shadowDistance = 0f;
				SetStudioVolume(vector, -_key.transform.forward);
				_key.enabled = (_fill.enabled = (_rim.enabled = true));
				_camera.Render();
			}
			finally
			{
				_key.enabled = (_fill.enabled = (_rim.enabled = false));
				RenderSettings.ambientProbe = ambientProbe;
				RenderSettings.fog = fog;
				QualitySettings.shadowDistance = shadowDistance;
				Shader.SetGlobalTexture(Volume0, globalTexture);
				Shader.SetGlobalTexture(Volume1, globalTexture2);
				Shader.SetGlobalTexture(Volume2, globalTexture3);
				Shader.SetGlobalTexture(VolumeMask, globalTexture4);
				Shader.SetGlobalVector(GlobalVolumeMin, globalVector);
				Shader.SetGlobalVector(GlobalVolumeInvSize, globalVector2);
				for (int j = 0; j < _renderers.Count; j++)
				{
					Renderer renderer3 = _renderers[j];
					if (!(renderer3 == null))
					{
						renderer3.gameObject.layer = _layers[j];
						renderer3.lightProbeUsage = _probes[j];
						renderer3.reflectionProbeUsage = _reflections[j];
					}
				}
			}
			slot.Signature = Signature(player);
			slot.Rendered = true;
		}

		private void SetStudioVolume(Vector3 focus, Vector3 towardsKey)
		{
			Color volumeTowardsKey = VolumeTowardsKey;
			FillVolume(_volume0, new Color(VolumeBase.r, VolumeBase.g, VolumeBase.b, towardsKey.z * volumeTowardsKey.r));
			FillVolume(_volume1, new Color(towardsKey.x * volumeTowardsKey.r, towardsKey.x * volumeTowardsKey.g, towardsKey.x * volumeTowardsKey.b, towardsKey.z * volumeTowardsKey.g));
			FillVolume(_volume2, new Color(towardsKey.y * volumeTowardsKey.r, towardsKey.y * volumeTowardsKey.g, towardsKey.y * volumeTowardsKey.b, towardsKey.z * volumeTowardsKey.b));
			Shader.SetGlobalTexture(Volume0, _volume0);
			Shader.SetGlobalTexture(Volume1, _volume1);
			Shader.SetGlobalTexture(Volume2, _volume2);
			Shader.SetGlobalTexture(VolumeMask, _volumeMask);
			Shader.SetGlobalVector(GlobalVolumeMin, focus - Vector3.one * 10f);
			Shader.SetGlobalVector(GlobalVolumeInvSize, Vector3.one / 20f);
		}
	}
}
