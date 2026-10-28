using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmPingSystem : MonoBehaviour
	{
		private sealed class CloneEntry
		{
			public Renderer source;

			public Renderer clone;

			public Color color;
		}

		[Header("Schedule")]
		[SerializeField]
		private float pingInterval = 30f;

		[SerializeField]
		private float blinkDuration = 3f;

		[Tooltip("Full bright-dark pulses within one blink window.")]
		[SerializeField]
		private float pulsesPerBlink = 3f;

		[Header("Look")]
		[Tooltip("Material using Slop/BtmXrayPulse. Wired by the editor tool; a runtime instance is created from Shader.Find as a fallback.")]
		[SerializeField]
		private Material xrayMaterial;

		[SerializeField]
		[Range(0f, 1f)]
		private float maxIntensity = 0.8f;

		[SerializeField]
		private Color playerPingColor = new Color(1f, 0.07f, 0.05f, 1f);

		[SerializeField]
		private Color generatorPingColor = new Color(1f, 0.6f, 0.05f, 1f);

		private static readonly int XrayIntensityId = Shader.PropertyToID("_XrayIntensity");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private readonly Dictionary<Renderer, CloneEntry> _pool = new Dictionary<Renderer, CloneEntry>();

		private readonly List<CloneEntry> _active = new List<CloneEntry>(48);

		private static readonly List<Renderer> RendererScratch = new List<Renderer>(64);

		private static readonly List<CloneEntry> PruneScratch = new List<CloneEntry>(16);

		private MaterialPropertyBlock _mpb;

		private long _lastWindowIndex = -1L;

		private double _roundStamp;

		private bool _windowActive;

		private float _revealStart;

		private float _revealUntil;

		private Color _revealColor;

		private bool _revealing;

		public static BtmPingSystem Instance { get; private set; }

		public Material XrayMaterial => xrayMaterial;

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			if (xrayMaterial == null)
			{
				Shader shader = Shader.Find("Slop/BtmXrayPulse");
				if (shader != null)
				{
					xrayMaterial = new Material(shader);
					Debug.LogWarning("[BtmPingSystem] xrayMaterial not wired — using a runtime instance. Run Tools ▸ Be The Monster ▸ Build Scene so the material is serialized (build-safe).");
				}
				else
				{
					Debug.LogError("[BtmPingSystem] Slop/BtmXrayPulse shader missing — pings disabled.");
					base.enabled = false;
				}
			}
		}

		private void OnEnable()
		{
			Instance = this;
		}

		private void OnDisable()
		{
			EndWindow();
			_revealUntil = 0f;
			_revealing = false;
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void BeginLocalReveal(float duration, Color color)
		{
			if (!(duration > 0f))
			{
				return;
			}
			float time = Time.time;
			if (!_revealing || time >= _revealUntil)
			{
				_revealStart = time;
			}
			_revealColor = color;
			_revealing = false;
			_revealUntil = Mathf.Max(_revealUntil, time + duration);
		}

		private bool UpdateLocalReveal(RoundProperties props, int localActor)
		{
			float time = Time.time;
			if (time >= _revealUntil)
			{
				if (_revealing)
				{
					_revealing = false;
					EndWindow();
					_lastWindowIndex = -1L;
				}
				return false;
			}
			if (!_revealing)
			{
				EndWindow();
				_windowActive = true;
				_revealing = true;
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				if (manager != null && manager.Players != null)
				{
					foreach (MonkeDevNetworkingPlayer player in manager.Players)
					{
						if (!(player == null) && !(player.photonView == null) && !player.photonView.IsMine && Contains(props.activePlayers, player.photonView.OwnerActorNr))
						{
							RendererScratch.Clear();
							CollectPlayerRenderers(player, RendererScratch);
							ActivateClones(RendererScratch, _revealColor);
						}
					}
				}
				RendererScratch.Clear();
				PrunePool();
			}
			float num = time - _revealStart;
			float num2 = Mathf.Clamp01(num / 0.3f);
			float num3 = Mathf.Clamp01((_revealUntil - time) / 0.8f);
			float value = maxIntensity * num2 * num3 * (0.8f + 0.2f * Mathf.Sin(num * 5f));
			for (int num4 = _active.Count - 1; num4 >= 0; num4--)
			{
				CloneEntry cloneEntry = _active[num4];
				if (cloneEntry.source == null || cloneEntry.clone == null || !cloneEntry.source.gameObject.activeInHierarchy || !cloneEntry.source.enabled)
				{
					if (cloneEntry.clone != null)
					{
						cloneEntry.clone.enabled = false;
					}
					_active.RemoveAt(num4);
				}
				else
				{
					cloneEntry.clone.GetPropertyBlock(_mpb);
					_mpb.SetColor(ColorId, cloneEntry.color);
					_mpb.SetFloat(XrayIntensityId, value);
					cloneEntry.clone.SetPropertyBlock(_mpb);
				}
			}
			return time < _revealUntil;
		}

		private void Update()
		{
			if (BTMGameManager.Instance == null)
			{
				return;
			}
			RoundProperties props = BTMGameManager.Instance.roomProperties;
			if (PhotonNetwork.InRoom && props.roundActive && props.startTime > 0.0)
			{
				if (_roundStamp != props.startTime)
				{
					_roundStamp = props.startTime;
					_lastWindowIndex = -1L;
				}
				int localActor = ((PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
				bool flag = Contains(props.activePlayers, localActor);
				if (flag || Contains(props.currentMonsters, localActor))
				{
					if (UpdateLocalReveal(props, localActor))
					{
						return;
					}
					double num = PhotonNetwork.Time - RoundProps.PlayStartTime(in props);
					if (!(num < 0.0))
					{
						long num2 = (long)(num / (double)pingInterval);
						if (num2 >= 1)
						{
							double num3 = num - (double)(pingInterval * (float)num2);
							if (num3 < (double)blinkDuration)
							{
								if (num2 != _lastWindowIndex)
								{
									_lastWindowIndex = num2;
									StartWindow(props, localActor, flag);
								}
								float num4 = (float)(num3 / (double)blinkDuration);
								float f = Mathf.Sin(pulsesPerBlink * num4 * Mathf.PI);
								float num5 = Mathf.Clamp01((1f - num4) * 4f);
								float value = maxIntensity * Mathf.Abs(f) * num5;
								for (int num6 = _active.Count - 1; num6 >= 0; num6--)
								{
									CloneEntry cloneEntry = _active[num6];
									if (cloneEntry.source == null || !cloneEntry.source.gameObject.activeInHierarchy || !cloneEntry.source.enabled || cloneEntry.clone == null)
									{
										if (cloneEntry.clone != null)
										{
											cloneEntry.clone.enabled = false;
										}
										_active.RemoveAt(num6);
									}
									else
									{
										cloneEntry.clone.GetPropertyBlock(_mpb);
										_mpb.SetColor(ColorId, cloneEntry.color);
										_mpb.SetFloat(XrayIntensityId, value);
										cloneEntry.clone.SetPropertyBlock(_mpb);
									}
								}
								return;
							}
						}
					}
				}
			}
			if (_windowActive)
			{
				EndWindow();
			}
		}

		private void StartWindow(RoundProperties props, int localActor, bool localIsSurvivor)
		{
			EndWindow();
			_windowActive = true;
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager != null && manager.Players != null)
			{
				foreach (MonkeDevNetworkingPlayer player in manager.Players)
				{
					if (!(player == null) && !(player.photonView == null) && !player.photonView.IsMine)
					{
						int ownerActorNr = player.photonView.OwnerActorNr;
						if (Contains(props.activePlayers, ownerActorNr) || Contains(props.currentMonsters, ownerActorNr))
						{
							RendererScratch.Clear();
							CollectPlayerRenderers(player, RendererScratch);
							ActivateClones(RendererScratch, playerPingColor);
						}
					}
				}
			}
			if (localIsSurvivor)
			{
				foreach (BtmGenerator activeGenerator in BtmGenerator.ActiveGenerators)
				{
					if (!(activeGenerator == null) && !activeGenerator.IsPowered)
					{
						RendererScratch.Clear();
						activeGenerator.GetPingRenderers(RendererScratch);
						ActivateClones(RendererScratch, generatorPingColor);
					}
				}
			}
			RendererScratch.Clear();
			PrunePool();
		}

		private void EndWindow()
		{
			_windowActive = false;
			foreach (CloneEntry item in _active)
			{
				if (item.clone != null)
				{
					item.clone.enabled = false;
				}
			}
			_active.Clear();
		}

		private static void CollectPlayerRenderers(MonkeDevNetworkingPlayer player, List<Renderer> into)
		{
			GameModePlayer gameModePlayer = player.gameModePlayer;
			GameObject gameObject = null;
			if (gameModePlayer != null)
			{
				if (gameModePlayer.ShowsMonsterRig && gameModePlayer.availableMonsters != null)
				{
					GameObject gameObject2 = null;
					GameModePlayer.MonsterEntry[] availableMonsters = gameModePlayer.availableMonsters;
					foreach (GameModePlayer.MonsterEntry monsterEntry in availableMonsters)
					{
						if (monsterEntry?.MonsterGameObject != null && monsterEntry.MonsterGameObject.activeSelf)
						{
							gameObject2 = monsterEntry.MonsterGameObject;
							break;
						}
					}
					gameObject = ((gameObject2 != null) ? gameObject2 : gameModePlayer.monsterRigsParent);
				}
				else
				{
					gameObject = gameModePlayer.apeRig;
				}
			}
			if (gameObject == null)
			{
				gameObject = player.gameObject;
			}
			Renderer[] componentsInChildren = gameObject.GetComponentsInChildren<Renderer>();
			foreach (Renderer renderer in componentsInChildren)
			{
				if (!(renderer == null) && renderer.enabled && (renderer is SkinnedMeshRenderer || renderer is MeshRenderer) && !(renderer.GetComponent<TMP_Text>() != null))
				{
					LODGroup componentInParent = renderer.GetComponentInParent<LODGroup>();
					if (!(componentInParent != null) || IsInLod0(componentInParent, renderer))
					{
						into.Add(renderer);
					}
				}
			}
		}

		private static bool IsInLod0(LODGroup group, Renderer renderer)
		{
			LOD[] lODs = group.GetLODs();
			if (lODs == null || lODs.Length == 0)
			{
				return true;
			}
			Renderer[] renderers = lODs[0].renderers;
			if (renderers == null)
			{
				return true;
			}
			for (int i = 0; i < renderers.Length; i++)
			{
				if (renderers[i] == renderer)
				{
					return true;
				}
			}
			return false;
		}

		private void ActivateClones(List<Renderer> sources, Color color)
		{
			foreach (Renderer source in sources)
			{
				if (source == null)
				{
					continue;
				}
				if (!_pool.TryGetValue(source, out var value) || value.clone == null)
				{
					Renderer renderer = BuildClone(source);
					if (renderer == null)
					{
						continue;
					}
					value = new CloneEntry
					{
						source = source,
						clone = renderer
					};
					_pool[source] = value;
				}
				value.color = color;
				value.clone.enabled = true;
				value.clone.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, color);
				_mpb.SetFloat(XrayIntensityId, 0f);
				value.clone.SetPropertyBlock(_mpb);
				_active.Add(value);
			}
		}

		private Renderer BuildClone(Renderer source)
		{
			if (xrayMaterial == null)
			{
				return null;
			}
			GameObject gameObject = new GameObject("XrayPing");
			gameObject.layer = source.gameObject.layer;
			gameObject.transform.SetParent(source.transform, false);
			Renderer renderer;
			Mesh sharedMesh;
			if (source is SkinnedMeshRenderer skinnedMeshRenderer && skinnedMeshRenderer.sharedMesh != null)
			{
				SkinnedMeshRenderer skinnedMeshRenderer2 = gameObject.AddComponent<SkinnedMeshRenderer>();
				skinnedMeshRenderer2.sharedMesh = skinnedMeshRenderer.sharedMesh;
				skinnedMeshRenderer2.bones = skinnedMeshRenderer.bones;
				skinnedMeshRenderer2.rootBone = skinnedMeshRenderer.rootBone;
				skinnedMeshRenderer2.localBounds = skinnedMeshRenderer.localBounds;
				skinnedMeshRenderer2.updateWhenOffscreen = skinnedMeshRenderer.updateWhenOffscreen;
				skinnedMeshRenderer2.quality = SkinQuality.Bone2;
				renderer = skinnedMeshRenderer2;
				sharedMesh = skinnedMeshRenderer.sharedMesh;
			}
			else
			{
				MeshFilter component;
				if (!(source is MeshRenderer) || (component = source.GetComponent<MeshFilter>()) == null || component.sharedMesh == null)
				{
					Object.Destroy(gameObject);
					return null;
				}
				gameObject.AddComponent<MeshFilter>().sharedMesh = component.sharedMesh;
				renderer = gameObject.AddComponent<MeshRenderer>();
				sharedMesh = component.sharedMesh;
			}
			Material[] array = new Material[Mathf.Max(1, sharedMesh.subMeshCount)];
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = xrayMaterial;
			}
			renderer.sharedMaterials = array;
			renderer.shadowCastingMode = ShadowCastingMode.Off;
			renderer.receiveShadows = false;
			renderer.lightProbeUsage = LightProbeUsage.Off;
			renderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			renderer.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
			renderer.enabled = false;
			return renderer;
		}

		private void PrunePool()
		{
			PruneScratch.Clear();
			foreach (KeyValuePair<Renderer, CloneEntry> item in _pool)
			{
				if (item.Key == null || item.Value.clone == null)
				{
					PruneScratch.Add(item.Value);
				}
			}
			if (PruneScratch.Count == 0)
			{
				return;
			}
			foreach (CloneEntry item2 in PruneScratch)
			{
				if (item2.clone != null)
				{
					Object.Destroy(item2.clone.gameObject);
				}
				if ((object)item2.source != null)
				{
					_pool.Remove(item2.source);
				}
			}
			PruneScratch.Clear();
		}

		private static bool Contains(int[] arr, int value)
		{
			if (arr == null)
			{
				return false;
			}
			for (int i = 0; i < arr.Length; i++)
			{
				if (arr[i] == value)
				{
					return true;
				}
			}
			return false;
		}
	}
}
