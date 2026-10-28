using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using GorillaLocomotion;
using Photon.Pun;
using Photon.Realtime;
using Photon.Voice.PUN;
using Photon.Voice.Unity;
using TMPro;
using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevNetworkingPlayer : MonoBehaviourPunCallbacks, IPunObservable, IPunInstantiateMagicCallback, IPoolLifecycle
	{
		public sealed class AppearanceSnapshot
		{
			public readonly string Name;

			public readonly string ColourJson;

			public readonly Dictionary<string, string> Cosmetics;

			public AppearanceSnapshot(string name, string colourJson, Dictionary<string, string> cosmetics)
			{
				Name = name ?? "";
				ColourJson = colourJson;
				Cosmetics = cosmetics ?? new Dictionary<string, string>();
			}
		}

		[Serializable]
		private class SerializableDictionary
		{
			public List<string> keys = new List<string>();

			public List<string> values = new List<string>();

			public SerializableDictionary()
			{
			}

			public SerializableDictionary(Dictionary<string, string> dict)
			{
				if (dict == null)
				{
					return;
				}
				foreach (KeyValuePair<string, string> item in dict)
				{
					keys.Add(item.Key);
					values.Add(item.Value);
				}
			}

			public Dictionary<string, string> ToDictionary()
			{
				Dictionary<string, string> dictionary = new Dictionary<string, string>();
				for (int i = 0; i < keys.Count && i < values.Count; i++)
				{
					dictionary[keys[i]] = values[i];
				}
				return dictionary;
			}
		}

		[Serializable]
		public class CosmeticSlot
		{
			public string SlotName;

			public Transform Object;
		}

		[Serializable]
		public class PlayerModelEntry
		{
			public string ModelName;

			public GameObject ModelGameObject;

			[Tooltip("Whether cosmetics should be shown on this player model")]
			public bool cosmeticsEnabled = true;

			[Tooltip("OPTIONAL: Renderers for this model (for skins/colors). Leave EMPTY to use global playerRenderers or if model doesn't support skins.")]
			public List<Renderer> ModelRenderers = new List<Renderer>();

			[Tooltip("OPTIONAL: Eye renderers for this model. Leave EMPTY to use global playerEyeRenderers or if model doesn't support eyes.")]
			public List<Renderer> ModelEyeRenderers = new List<Renderer>();
		}

		[Header("Tracking")]
		public Transform Head;

		[Header("Tracking")]
		public Transform LeftHand;

		[Header("Tracking")]
		public Transform RightHand;

		[Header("Appearance")]
		public List<Renderer> playerRenderers;

		public List<Renderer> playerEyeRenderers;

		public List<CosmeticSlot> CosmeticSlots = new List<CosmeticSlot>();

		public List<Material> Skins;

		public List<Material> Eyes;

		public TextMeshPro NameText;

		[Header("GameMode")]
		public GameModePlayer gameModePlayer;

		[Header("Player Models")]
		[Tooltip("Available player models (ApeRig and Robot). One must always be active.")]
		public List<PlayerModelEntry> availablePlayerModels = new List<PlayerModelEntry>();

		private string selectedPlayerModel = "ApeRig";

		[Header("Optimization")]
		public LODGroup PlayerLOD;

		public Action<int> OnLODChange;

		[Tooltip("Drag BODY/FUR renderers for LOD1, LOD2, etc. here. Do NOT include eye renderers. Leave empty if no LOD system.")]
		public List<Renderer> lodBodyRenderers = new List<Renderer>();

		private float playerScale = 1f;

		private bool isBeingGrabbed;

		private Transform grabberHand;

		private int grabberActorId = -1;

		private Vector3 grabLocalPos;

		private Quaternion grabLocalRot = Quaternion.identity;

		private Vector3 grabLeftHandPos;

		private Vector3 grabRightHandPos;

		private Quaternion grabLeftHandRot = Quaternion.identity;

		private Quaternion grabRightHandRot = Quaternion.identity;

		private float grabbedAt;

		private bool grabByStaff;

		private const float GrabFailsafeSeconds = 12f;

		private const float MaxGrabFollowStep = 6f;

		private bool _rigHeld;

		private bool _ownRigTeleport;

		private bool isRainbowActive;

		public const string InvisibleKey = "Invis";

		private bool _networkHidden;

		private Renderer[] _hideCache;

		private string lastUsername = "";

		private string lastColorJson = "";

		private string lastCosmeticsJson = "";

		private int _lastLODIndex = -1;

		public Color currentPlayerColor = Color.white;

		[Header("Damage Flash")]
		[Tooltip("Colour the body flashes to when this player is shot.")]
		public Color damageFlashColor = new Color(1f, 0.12f, 0.1f, 1f);

		[Tooltip("Seconds for the red hit-flash to fade back to the normal colour.")]
		public float damageFlashDuration = 0.25f;

		private float _damageFlashT;

		private bool _damageFlashActive;

		private static int _colorID = -1;

		private static bool _colorIDInitialized;

		private static WaitForSeconds _waitPointOne;

		private static WaitForSeconds _waitPointTwo;

		private static WaitForSeconds _waitPointFive;

		private static WaitForSeconds _waitOne;

		private static bool _waitsInitialized;

		private static readonly string[] _emptyStringArray = new string[0];

		private readonly HashSet<string> _enabledCosmeticsSet = new HashSet<string>(StringComparer.Ordinal);

		private bool _isActivatingModel;

		private bool _isUpdatingCosmetics;

		private bool _pendingInit;

		private AppearanceSnapshot _appearanceOverride;

		private Material _eyeOverride;

		private bool _restoringOwnLook;

		public const float VoiceRange = 35f;

		private static readonly (float metres, float gain)[] VoiceFalloffPoints = new (float metres, float gain)[7] { (0f, 1f), (2f, 1f), (5f, 0.7f), (10f, 0.42f), (20f, 0.15f), (30f, 0.04f), (35f, 0f) };

		private static AnimationCurve _voiceFalloff;

		private const string DefaultSkinName = "APE";

		private const string DefaultEyeName = "DEFAULT_EYE";

		private const string DefaultModelName = "ApeRig";

		private static readonly Func<int, int> BodyMaterialSlot = (int rendererIndex) => (rendererIndex > 0) ? 1 : 0;

		private static readonly Func<int, int> FirstMaterialSlot = (int _) => 0;

		private static readonly string[] _randomNamePrefixes = new string[10] { "APE", "PRIMATE", "CHIMP", "GORILLA", "MONKEY", "BABOON", "BONOBO", "ORANG", "MACAQUE", "SIMIAN" };

		private Coroutine _rainbowRoutine;

		private MaterialPropertyBlock _mpb;

		private Renderer[] _cachedRainbowRenderers;

		private int[] _cachedRainbowMatIndices;

		private CosmeticDistanceCuller _cosmeticCuller;

		private PlayerAnimationLOD _animationLod;

		private bool _cosmeticCullerLooked;

		private FingerAnimations[] _hands;

		private int _lastSentLeftHand = -1;

		private int _lastSentRightHand = -1;

		private float _lastHandSendTime = -999f;

		private const float HandChangeThreshold = 0.02f;

		private const float HandMaxSendInterval = 0.12f;

		public bool IsBeingGrabbed => isBeingGrabbed;

		public int GrabberActorId => isBeingGrabbed ? grabberActorId : (-1);

		public bool canTrack { get; set; }

		public bool NetworkHidden => _networkHidden;

		public Speaker PhotonVoiceSpeaker { get; set; }

		public PhotonVoiceView PhotonVoiceView { get; private set; }

		public bool HasAppearanceOverride => _appearanceOverride != null;

		private static AnimationCurve VoiceFalloff
		{
			get
			{
				if (_voiceFalloff != null)
				{
					return _voiceFalloff;
				}
				(float metres, float gain)[] voiceFalloffPoints = VoiceFalloffPoints;
				Keyframe[] array = new Keyframe[voiceFalloffPoints.Length];
				for (int i = 0; i < voiceFalloffPoints.Length; i++)
				{
					float num = ((i > 0) ? Slope(voiceFalloffPoints[i - 1], voiceFalloffPoints[i]) : Slope(voiceFalloffPoints[0], voiceFalloffPoints[1]));
					float num2 = ((i < voiceFalloffPoints.Length - 1) ? Slope(voiceFalloffPoints[i], voiceFalloffPoints[i + 1]) : num);
					float num3 = ((num * num2 > 0f) ? ((num + num2) * 0.5f) : 0f);
					array[i] = new Keyframe(voiceFalloffPoints[i].metres / VoiceRange, voiceFalloffPoints[i].gain, num3, num3);
				}
				_voiceFalloff = new AnimationCurve(array);
				return _voiceFalloff;
			}
		}

		int IPoolLifecycle.PoolCallbackOrder => 100;

		public float NetLeftTrigger { get; private set; }

		public float NetRightTrigger { get; private set; }

		public float NetLeftGrip { get; private set; }

		public float NetRightGrip { get; private set; }

		public float NetLeftButton { get; private set; }

		public float NetRightButton { get; private set; }

		public static void SetLocalInvisible(bool invisible)
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null)
			{
				PhotonNetwork.LocalPlayer.SetCustomProperties(new ExitGames.Client.Photon.Hashtable { { "Invis", invisible } });
			}
		}

		private void ApplyNetworkHidden(bool hidden)
		{
			_networkHidden = hidden;
			if (base.photonView != null && base.photonView.IsMine)
			{
				return;
			}
			_hideCache = GetComponentsInChildren<Renderer>(true);
			for (int i = 0; i < _hideCache.Length; i++)
			{
				if (_hideCache[i] != null)
				{
					_hideCache[i].enabled = !hidden;
				}
			}
		}

		private void SyncNetworkHiddenFromProps()
		{
			if (base.photonView == null || base.photonView.Owner == null)
			{
				return;
			}
			if (base.photonView.Owner.CustomProperties != null && base.photonView.Owner.CustomProperties.TryGetValue("Invis", out object value))
			{
				ApplyNetworkHidden(value is bool flag && flag);
			}
			else if (_networkHidden)
			{
				ApplyNetworkHidden(false);
			}
		}

		private static int GetColorID()
		{
			if (!_colorIDInitialized)
			{
				_colorID = Shader.PropertyToID("_Color");
				_colorIDInitialized = true;
			}
			return _colorID;
		}

		private static void InitWaits()
		{
			if (!_waitsInitialized)
			{
				_waitPointOne = new WaitForSeconds(0.1f);
				_waitPointTwo = new WaitForSeconds(0.2f);
				_waitPointFive = new WaitForSeconds(0.5f);
				_waitOne = new WaitForSeconds(1f);
				_waitsInitialized = true;
			}
		}

		public void OnPhotonInstantiate(PhotonMessageInfo info)
		{
			InitWaits();
			if (base.photonView == null)
			{
				Debug.LogError("[MonkeDevNetworkingPlayer] PhotonView is null on instantiate!");
				return;
			}
			RefreshHandCache();
			SyncNetworkHiddenFromProps();
			PhotonVoiceView = GetComponent<PhotonVoiceView>();
			if (PhotonVoiceView == null)
			{
				PhotonVoiceView = base.gameObject.AddComponent<PhotonVoiceView>();
			}
			BindVoiceToCurrentView();
			StartCoroutine(DelayedInit());
		}

		private static float Slope((float metres, float gain) a, (float metres, float gain) b)
		{
			return (b.gain - a.gain) / ((b.metres - a.metres) / VoiceRange);
		}

		private void SetupPhotonVoiceSpeaker()
		{
			PhotonVoiceSpeaker = GetComponentInChildren<Speaker>(true);
			if (PhotonVoiceSpeaker == null)
			{
				return;
			}
			AudioSource component = PhotonVoiceSpeaker.GetComponent<AudioSource>();
			if (component != null)
			{
				component.spatialBlend = 1f;
				component.minDistance = 1f;
				component.maxDistance = VoiceRange;
				component.volume = 1f;
				component.rolloffMode = AudioRolloffMode.Custom;
				component.SetCustomCurve(AudioSourceCurveType.CustomRolloff, VoiceFalloff);
			}
			if (PhotonVoiceSpeaker != null && PhotonVoiceSpeaker.enabled)
			{
				PhotonVoiceSpeaker.RestartPlayback();
			}
		}

		private void ForceCompleteReset()
		{
			StopAllCoroutines();
			CancelInvoke();
			ResetState();
			if (base.photonView != null && !base.photonView.IsMine)
			{
				lastUsername = "";
				lastColorJson = "";
				lastCosmeticsJson = "";
			}
		}

		private void ResetState()
		{
			ReleaseRig(true);
			isBeingGrabbed = false;
			grabberHand = null;
			grabberActorId = -1;
			grabByStaff = false;
			playerScale = 1f;
			canTrack = true;
			isRainbowActive = false;
			lastUsername = "";
			lastColorJson = "";
			lastCosmeticsJson = "";
			_appearanceOverride = null;
			currentPlayerColor = Color.white;
			_eyeOverride = null;
			if (gameModePlayer != null)
			{
				gameModePlayer.ResetSkinState();
			}
			ResetVisualAppearance();
		}

		void IPoolLifecycle.OnPoolReleased()
		{
			ResetForPool();
			LeaveRoster();
		}

		void IPoolLifecycle.OnPoolAcquired()
		{
		}

		private void LeaveRoster()
		{
			ResetState();
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			manager.Players.Remove(this);
			if (manager.LocalPlayer == this)
			{
				manager.LocalPlayer = null;
			}
		}

		public void ResetForPool()
		{
			ResetVisualAppearance();
			if (PhotonVoiceSpeaker != null)
			{
				AudioSource component = PhotonVoiceSpeaker.GetComponent<AudioSource>();
				if (component != null)
				{
					component.Stop();
					component.clip = null;
				}
			}
		}

		private void ResetVisualAppearance()
		{
			if (NameText != null)
			{
				NameText.text = "";
			}
			for (int i = 0; i < CosmeticSlots.Count; i++)
			{
				Transform transform = CosmeticSlots[i]?.Object;
				if (transform == null)
				{
					continue;
				}
				foreach (Transform item in transform)
				{
					item.gameObject.SetActive(false);
				}
			}
			if (Skins != null && Skins.Count > 0 && HasRenderers(playerRenderers))
			{
				Material material = FindMaterial(Skins, "APE") ?? Skins[0];
				ApplyMaterialToList(playerRenderers, material, BodyMaterialSlot);
				ApplySkinToLODRenderers(material);
			}
			if (Eyes != null && Eyes.Count > 0 && HasRenderers(playerEyeRenderers))
			{
				Material mat = FindMaterial(Eyes, "DEFAULT_EYE") ?? Eyes[0];
				ApplyMaterialToList(playerEyeRenderers, mat, FirstMaterialSlot);
			}
			if (availablePlayerModels != null && availablePlayerModels.Count > 0)
			{
				HideAllPlayerModels();
				PlayerModelEntry playerModelEntry = FindPlayerModel("ApeRig");
				if (playerModelEntry?.ModelGameObject == null)
				{
					playerModelEntry = availablePlayerModels[0];
				}
				GameObject gameObject = playerModelEntry?.ModelGameObject;
				if (gameObject != null)
				{
					gameObject.SetActive(true);
				}
				selectedPlayerModel = "ApeRig";
			}
			ResetColorToDefault();
		}

		private static bool HasRenderers(List<Renderer> list)
		{
			if (list != null)
			{
				return list.Count > 0;
			}
			return false;
		}

		private static Material FindMaterial(List<Material> pool, string materialName)
		{
			for (int i = 0; i < pool.Count; i++)
			{
				if (pool[i].name == materialName)
				{
					return pool[i];
				}
			}
			return null;
		}

		public void GetApeAppearance(out Material skin, out Color colour)
		{
			colour = currentPlayerColor;
			skin = null;
			if (selectedPlayerModel == "ApeRig" && HasRenderers(playerRenderers) && playerRenderers[0] != null)
			{
				Material[] sharedMaterials = playerRenderers[0].sharedMaterials;
				if (sharedMaterials.Length != 0)
				{
					skin = sharedMaterials[0];
				}
			}
			if (skin == null && Skins != null && Skins.Count > 0)
			{
				skin = FindMaterial(Skins, "APE") ?? Skins[0];
			}
		}

		public Material SkinMaterialFor(Dictionary<string, string> cosmetics)
		{
			if (Skins == null || Skins.Count == 0)
			{
				return null;
			}
			Material material = null;
			if (cosmetics != null && cosmetics.TryGetValue("Skin", out string value) && !string.IsNullOrEmpty(value))
			{
				material = FindMaterial(Skins, value);
			}
			if (material != null)
			{
				return material;
			}
			return FindMaterial(Skins, "APE") ?? Skins[0];
		}

		public AppearanceSnapshot CaptureAppearance()
		{
			ReadOwnValues(out string username, out string colorJson, out Dictionary<string, string> cosmetics);
			string name = ((NameText != null && !string.IsNullOrEmpty(NameText.text)) ? NameText.text : username);
			return new AppearanceSnapshot(name, colorJson, new Dictionary<string, string>(cosmetics));
		}

		public void SetAppearanceOverride(AppearanceSnapshot look, Material eyeOverride)
		{
			if (look != null)
			{
				_appearanceOverride = look;
				_eyeOverride = eyeOverride;
				ResetVisualAppearance();
				RefreshPlayerValuesLocal();
			}
		}

		public void ClearAppearanceOverride()
		{
			if (_appearanceOverride == null && _eyeOverride == null)
			{
				return;
			}
			_appearanceOverride = null;
			_eyeOverride = null;
			ResetVisualAppearance();
			_restoringOwnLook = true;
			try
			{
				RefreshPlayerValuesLocal();
			}
			finally
			{
				_restoringOwnLook = false;
			}
		}

		private void ReadOwnValues(out string username, out string colorJson, out Dictionary<string, string> cosmetics)
		{
			username = "";
			colorJson = "";
			cosmetics = null;
			if (base.photonView.IsMine)
			{
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				username = PlayerPrefs.GetString("Username", "Player");
				if (manager != null)
				{
					colorJson = JsonUtility.ToJson(manager.Colour);
					cosmetics = manager.Cosmetics;
				}
			}
			else if (base.photonView.Owner != null)
			{
				username = base.photonView.Owner.NickName;
				if (base.photonView.Owner.CustomProperties.TryGetValue("Colour", out object value))
				{
					colorJson = value as string;
				}
				if (base.photonView.Owner.CustomProperties.TryGetValue("Cosmetics", out object value2))
				{
					cosmetics = value2 as Dictionary<string, string>;
				}
			}
			if (string.IsNullOrEmpty(colorJson))
			{
				colorJson = JsonUtility.ToJson(Color.white);
			}
			if (cosmetics == null)
			{
				cosmetics = new Dictionary<string, string>();
			}
		}

		private PlayerModelEntry FindPlayerModel(string modelName)
		{
			if (availablePlayerModels == null)
			{
				return null;
			}
			for (int i = 0; i < availablePlayerModels.Count; i++)
			{
				PlayerModelEntry playerModelEntry = availablePlayerModels[i];
				if (playerModelEntry != null && playerModelEntry.ModelName == modelName)
				{
					return playerModelEntry;
				}
			}
			return null;
		}

		private void HideAllPlayerModels()
		{
			for (int i = 0; i < availablePlayerModels.Count; i++)
			{
				GameObject gameObject = availablePlayerModels[i]?.ModelGameObject;
				if (gameObject != null)
				{
					gameObject.SetActive(false);
				}
			}
		}

		private void ResetColorToDefault()
		{
			if (playerRenderers == null || playerRenderers.Count == 0)
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] Cannot reset color - playerRenderers is empty.");
				return;
			}
			for (int i = 0; i < playerRenderers.Count; i++)
			{
				Renderer renderer = playerRenderers[i];
				if (renderer == null)
				{
					continue;
				}
				SafeSetColor(renderer, (i > 0) ? 1 : 0, Color.white);
			}
		}

		private IEnumerator DelayedInit()
		{
			if (base.photonView == null || MonkeDevNetworkingManager.Manager == null)
			{
				Debug.LogError("[MonkeDevNetworkingPlayer] Critical components missing during DelayedInit!");
				yield break;
			}
			if (base.photonView.IsMine)
			{
				MonkeDevNetworkingManager.Manager.LocalPlayer = this;
				ForceUpdateFromManager();
				yield return _waitPointOne;
				RefreshPlayerValuesLocal();
				yield break;
			}
			yield return new WaitForSeconds(UnityEngine.Random.Range(0.2f, 0.8f));
			if (Camera.main != null)
			{
				InvokeRepeating("CheckLODType", UnityEngine.Random.Range(2f, 4f), 2f);
			}
			RequestLatestValues();
			StartCoroutine(RetryRefreshPlayerValues());
		}

		private IEnumerator RetryRefreshPlayerValues()
		{
			int attempts = 0;
			int maxAttempts = 2;
			while (attempts < maxAttempts && (base.photonView.Owner == null || !base.photonView.Owner.CustomProperties.ContainsKey("Colour") || !base.photonView.Owner.CustomProperties.ContainsKey("Cosmetics")))
			{
				attempts++;
				yield return _waitOne;
			}
			RefreshPlayerValuesLocal();
		}

		private void Awake()
		{
			InitWaits();
			canTrack = true;
			PhotonVoiceView = GetComponent<PhotonVoiceView>();
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
		private static void EnsureFirstRunUsername()
		{
			if (!PlayerPrefs.HasKey("HasPlayedBefore"))
			{
				if (string.IsNullOrEmpty(PlayerPrefs.GetString("Username", "")))
				{
					PlayerPrefs.SetString("Username", GenerateRandomPrimateName());
				}
				PlayerPrefs.SetInt("HasPlayedBefore", 1);
				PlayerPrefs.Save();
			}
		}

		public static string GenerateRandomPrimateName()
		{
			return _randomNamePrefixes[UnityEngine.Random.Range(0, _randomNamePrefixes.Length)] + UnityEngine.Random.Range(100000, 1000000).ToString();
		}

		private new void OnEnable()
		{
			if (MonkeDevNetworkingManager.Manager != null)
			{
				if (base.photonView != null && base.photonView.OwnerActorNr > 0)
				{
					for (int num = MonkeDevNetworkingManager.Manager.Players.Count - 1; num >= 0; num--)
					{
						MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = MonkeDevNetworkingManager.Manager.Players[num];
						if (monkeDevNetworkingPlayer != null && monkeDevNetworkingPlayer != this && monkeDevNetworkingPlayer.photonView != null && monkeDevNetworkingPlayer.photonView.OwnerActorNr == base.photonView.OwnerActorNr)
						{
							Debug.LogWarning(string.Format("[MonkeDevNetworkingPlayer] Removing duplicate entry for actor {0} — old={1} new={2}", base.photonView.OwnerActorNr, monkeDevNetworkingPlayer.name, base.name));
							MonkeDevNetworkingManager.Manager.Players.RemoveAt(num);
						}
					}
				}
				if (!MonkeDevNetworkingManager.Manager.Players.Contains(this))
				{
					MonkeDevNetworkingManager.Manager.Players.Add(this);
				}
			}
			if (base.photonView != null && base.photonView.ViewID != 0 && !base.photonView.IsMine && PhotonVoiceSpeaker == null)
			{
				SetupPhotonVoiceSpeaker();
			}
		}

		public override void OnPlayerPropertiesUpdate(Photon.Realtime.Player targetPlayer, ExitGames.Client.Photon.Hashtable changedProps)
		{
			if (base.photonView.Owner == targetPlayer && !base.photonView.IsMine)
			{
				if (changedProps.ContainsKey("Colour") || changedProps.ContainsKey("Cosmetics"))
				{
					RefreshPlayerValuesLocal();
				}
				if (changedProps.TryGetValue("Invis", out object value))
				{
					ApplyNetworkHidden(value is bool flag && flag);
				}
			}
		}

		private void BindVoiceToCurrentView()
		{
			PunVoiceClient instance = PunVoiceClient.Instance;
			if (base.photonView.IsMine)
			{
				if (!(instance == null))
				{
					Recorder recorder = instance.PrimaryRecorder;
					if (recorder == null && PhotonVoiceView != null)
					{
						recorder = PhotonVoiceView.RecorderInUse;
					}
					if (recorder == null)
					{
						recorder = GetComponentInChildren<Recorder>(true);
					}
					if (recorder != null)
					{
						recorder.UserData = base.photonView.ViewID;
					}
				}
			}
			else
			{
				SetupPhotonVoiceSpeaker();
				if (instance != null && PhotonVoiceSpeaker != null)
				{
					instance.AddSpeaker(PhotonVoiceSpeaker, base.photonView.ViewID);
				}
			}
		}

		private new void OnDisable()
		{
			StopAllCoroutines();
			_rainbowRoutine = null;
			CancelInvoke();
			ReleaseRig(true);
			if (base.gameObject == null || !base.gameObject.scene.IsValid())
			{
				LeaveRoster();
			}
		}

		private void RequestLatestValues()
		{
			if (!base.photonView.IsMine && base.photonView.Owner != null)
			{
				base.photonView.RPC("RPC_RequestValues", base.photonView.Owner, PhotonNetwork.LocalPlayer.ActorNumber);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestValues(int requesterId)
		{
			if (base.photonView.IsMine)
			{
				SendValuesToPlayer(requesterId);
			}
		}

		private void SendValuesToPlayer(int targetActorId)
		{
			if (base.photonView.IsMine && !(MonkeDevNetworkingManager.Manager == null))
			{
				string nickName = PhotonNetwork.LocalPlayer.NickName;
				string text = JsonUtility.ToJson(MonkeDevNetworkingManager.Manager.Colour);
				string text2 = SerializeCosmetics(MonkeDevNetworkingManager.Manager.Cosmetics);
				Photon.Realtime.Player player = PhotonNetwork.CurrentRoom.GetPlayer(targetActorId);
				if (player != null)
				{
					base.photonView.RPC("RPC_ReceiveValues", player, nickName, text, text2);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReceiveValues(string username, string colorJson, string cosmeticsJson)
		{
			if (!base.photonView.IsMine && _appearanceOverride == null)
			{
				ApplyPlayerValues(username, colorJson, DeserializeCosmetics(cosmeticsJson));
			}
		}

		private string SerializeCosmetics(Dictionary<string, string> cosmetics)
		{
			if (cosmetics == null)
			{
				return "{}";
			}
			return JsonUtility.ToJson(new SerializableDictionary(cosmetics));
		}

		private Dictionary<string, string> DeserializeCosmetics(string json)
		{
			if (string.IsNullOrEmpty(json))
			{
				return new Dictionary<string, string>();
			}
			try
			{
				return JsonUtility.FromJson<SerializableDictionary>(json)?.ToDictionary() ?? new Dictionary<string, string>();
			}
			catch (Exception)
			{
				return new Dictionary<string, string>();
			}
		}

		private void Update()
		{
			TickDamageFlash();
			if (base.photonView.IsMine && canTrack && MonkeDevNetworkingManager.Manager != null)
			{
				CopyTransform(MonkeDevNetworkingManager.Manager.Head, Head);
				CopyTransform(MonkeDevNetworkingManager.Manager.RightHand, RightHand);
				CopyTransform(MonkeDevNetworkingManager.Manager.LeftHand, LeftHand);
				playerScale = ((GorillaLocomotion.Player.Instance != null) ? GorillaLocomotion.Player.Instance.targetScale : 1f);
				Head.localScale = Vector3.one * playerScale;
			}
		}

		private void LateUpdate()
		{
			if (isBeingGrabbed)
			{
				FollowGrabber();
			}
		}

		private void FixedUpdate()
		{
			if (_rigHeld)
			{
				Rigidbody rigidbody = ((GorillaLocomotion.Player.Instance != null) ? GorillaLocomotion.Player.Instance.playerRigidBody : null);
				if (rigidbody != null && !rigidbody.isKinematic)
				{
					rigidbody.linearVelocity = Vector3.zero;
				}
			}
		}

		private void FollowGrabber()
		{
			bool isMine = base.photonView.IsMine;
			if (grabberHand == null || !grabberHand.gameObject.activeInHierarchy)
			{
				DropGrab();
				if (isMine)
				{
					ReleasePlayer();
				}
				return;
			}
			if (isMine && !grabByStaff && Time.time - grabbedAt > GrabFailsafeSeconds)
			{
				DropGrab();
				ReleasePlayer();
				return;
			}
			Vector3 vector = grabberHand.position + grabberHand.rotation * grabLocalPos;
			Quaternion quaternion = grabberHand.rotation * grabLocalRot;
			Head.SetPositionAndRotation(vector, quaternion);
			if ((bool)LeftHand)
			{
				LeftHand.SetPositionAndRotation(vector + quaternion * grabLeftHandPos, quaternion * grabLeftHandRot);
			}
			if ((bool)RightHand)
			{
				RightHand.SetPositionAndRotation(vector + quaternion * grabRightHandPos, quaternion * grabRightHandRot);
			}
			if (!isMine || !_rigHeld)
			{
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null || instance.headCollider == null)
			{
				return;
			}
			Vector3 vector2 = vector - instance.headCollider.transform.position;
			if (float.IsNaN(vector2.x) || (!grabByStaff && vector2.sqrMagnitude > MaxGrabFollowStep * MaxGrabFollowStep))
			{
				DropGrab();
				ReleasePlayer();
				return;
			}
			Vector3 position = instance.transform.position + vector2;
			instance.transform.position = position;
			if (instance.playerRigidBody != null)
			{
				instance.playerRigidBody.position = position;
			}
			instance.AcceptExternalHeadPosition();
		}

		private void DropGrab()
		{
			grabberHand = null;
			isBeingGrabbed = false;
			grabberActorId = -1;
			grabByStaff = false;
			if (base.photonView.IsMine)
			{
				canTrack = true;
				ReleaseRig(true);
			}
		}

		private void HoldRig()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null) && !_rigHeld)
			{
				TeleportRigInPlace(instance);
				LethalApeR.Gameplay.RigHold.Take(this, LethalApeR.Gameplay.RigHold.What.All);
				_rigHeld = true;
				GorillaLocomotion.Player.Teleported -= OnRigTeleported;
				GorillaLocomotion.Player.Teleported += OnRigTeleported;
			}
		}

		private void ReleaseRig(bool stopInPlace)
		{
			if (_rigHeld)
			{
				_rigHeld = false;
				GorillaLocomotion.Player.Teleported -= OnRigTeleported;
				LethalApeR.Gameplay.RigHold.Give(this, LethalApeR.Gameplay.RigHold.What.All);
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (!(instance == null) && stopInPlace)
				{
					TeleportRigInPlace(instance);
				}
			}
		}

		private void TeleportRigInPlace(GorillaLocomotion.Player rig)
		{
			_ownRigTeleport = true;
			try
			{
				rig.TeleportPlayerRaw(rig.transform.position, rig.transform.rotation, false, true);
			}
			finally
			{
				_ownRigTeleport = false;
			}
		}

		private void OnRigTeleported(GorillaLocomotion.Player rig)
		{
			if (!_ownRigTeleport && _rigHeld)
			{
				ReleaseRig(false);
				DropGrab();
				ReleasePlayer();
			}
		}

		private bool GrabAllowed(int grabberActor)
		{
			LethalApeR.Gameplay.BeTheMonster.BTMGameManager instance = LethalApeR.Gameplay.BeTheMonster.BTMGameManager.Instance;
			if (instance == null || base.photonView.Owner == null)
			{
				return true;
			}
			LethalApeR.Gameplay.BeTheMonster.RoundProperties roomProperties = instance.roomProperties;
			if (!roomProperties.roundActive || roomProperties.activePlayers == null)
			{
				return true;
			}
			int[] currentMonsters = roomProperties.currentMonsters;
			if (Array.IndexOf(roomProperties.activePlayers, base.photonView.OwnerActorNr) < 0)
			{
				return true;
			}
			if (currentMonsters != null)
			{
				return Array.IndexOf(currentMonsters, grabberActor) >= 0;
			}
			return false;
		}

		private void CopyTransform(Transform src, Transform dst)
		{
			if (!(src == null) && !(dst == null))
			{
				dst.position = src.position;
				dst.rotation = src.rotation;
			}
		}

		private void ForceUpdateFromManager()
		{
			if (base.photonView.IsMine && !(MonkeDevNetworkingManager.Manager == null) && PhotonNetwork.IsConnectedAndReady)
			{
				Color colour = MonkeDevNetworkingManager.Manager.Colour;
				Dictionary<string, string> dictionary = MonkeDevNetworkingManager.Manager.Cosmetics ?? new Dictionary<string, string>();
				currentPlayerColor = colour;
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable["Colour"] = JsonUtility.ToJson(colour);
				hashtable["Cosmetics"] = dictionary;
				PhotonNetwork.LocalPlayer.SetCustomProperties(hashtable);
				ApplyPlayerValues(PlayerPrefs.GetString("Username", "Player"), JsonUtility.ToJson(colour), dictionary);
			}
		}

		public void RefreshPlayerValues()
		{
			if (base.photonView.IsMine && !(MonkeDevNetworkingManager.Manager == null) && PhotonNetwork.IsConnectedAndReady)
			{
				Color colour = MonkeDevNetworkingManager.Manager.Colour;
				currentPlayerColor = colour;
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable["Colour"] = JsonUtility.ToJson(colour);
				hashtable["Cosmetics"] = new Dictionary<string, string>(MonkeDevNetworkingManager.Manager.Cosmetics);
				PhotonNetwork.LocalPlayer.SetCustomProperties(hashtable);
				base.photonView.RPC("RPC_RefreshPlayerValues", RpcTarget.All);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RefreshPlayerValues()
		{
			RefreshPlayerValuesLocal();
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_UpdateSingleCosmetic(string type, string value)
		{
			if (!base.photonView.IsMine && base.photonView.Owner.CustomProperties.TryGetValue("Cosmetics", out object value2) && value2 is Dictionary<string, string> dictionary && dictionary.TryGetValue(type, out string value3))
			{
				value = value3;
			}
			UpdateSingleCosmetic(type, value);
		}

		private void ApplyPlayerValues(string username, string colorJson, Dictionary<string, string> cosmetics)
		{
			lastUsername = username;
			lastColorJson = colorJson;
			Color color = Color.white;
			if (!string.IsNullOrEmpty(colorJson))
			{
				try
				{
					color = JsonUtility.FromJson<Color>(colorJson);
				}
				catch (Exception)
				{
					color = Color.white;
				}
			}
			currentPlayerColor = color;
			if (NameText != null && !string.IsNullOrEmpty(username))
			{
				NameText.text = username;
				if (base.photonView.Owner != null && _appearanceOverride == null)
				{
					TryFetchOculusUsername();
				}
			}
			bool flag = cosmetics == null || !cosmetics.ContainsKey("Skin") || string.IsNullOrEmpty(cosmetics["Skin"]);
			bool flag2 = _appearanceOverride != null || _restoringOwnLook;
			bool flag3 = gameModePlayer == null;
			if ((flag2 || flag3 || (!gameModePlayer.isEliminated && !gameModePlayer.isMonster)) && cosmetics != null && (flag2 || flag3 || !gameModePlayer.isInfected))
			{
				UpdateCosmetics(cosmetics);
			}
			if (_eyeOverride != null && HasRenderers(playerEyeRenderers))
			{
				ApplyMaterialToList(playerEyeRenderers, _eyeOverride, FirstMaterialSlot);
			}
			if (flag && Skins != null && Skins.Count > 0)
			{
				Material material = FindMaterial(Skins, DefaultSkinName);
				if (material == null)
				{
					material = Skins[0];
				}
				ApplySkinToLODRenderers(material);
			}
			ApplyColor(currentPlayerColor);
			if (gameModePlayer != null && gameModePlayer.isInfected && gameModePlayer.taggedMaterial != null)
			{
				// RE: unsure - this block compiled to only a null-checked reload of gameModePlayer; the original statement (likely an inlined no-op) is not recoverable
			}
		}

		private void TryFetchOculusUsername()
		{
			if (base.photonView.Owner != null)
			{
				StartCoroutine(DeferredOculusUsernameFetch());
			}
		}

		private IEnumerator DeferredOculusUsernameFetch()
		{
			yield return new WaitForSeconds(2f);
			if (!(base.photonView == null) && base.photonView.Owner != null && base.photonView.Owner.CustomProperties.TryGetValue("OculusUsername", out object value) && value is string text && !string.IsNullOrEmpty(text))
			{
				UpdateNameWithOculusInfo(text);
			}
		}

		private void UpdateNameWithOculusInfo(string oculusUsername)
		{
			if (!(NameText == null) && _appearanceOverride == null && !string.IsNullOrEmpty(oculusUsername) && !(oculusUsername == lastUsername))
			{
				NameText.text = lastUsername + "\n(" + oculusUsername + ")";
			}
		}

		private void ApplyColor(Color c)
		{
			if (playerRenderers != null && playerRenderers.Count > 0)
			{
				for (int i = 0; i < playerRenderers.Count; i++)
				{
					Renderer renderer = playerRenderers[i];
					if (!(renderer == null))
					{
						SafeSetColor(renderer, (i != 0) ? 1 : 0, c);
					}
				}
			}
			ApplyColorToLODRenderers(c);
		}

		public void PreviewColour(Color c)
		{
			if (base.photonView.IsMine && _appearanceOverride == null && !isRainbowActive && (!(gameModePlayer != null) || (!gameModePlayer.isEliminated && !gameModePlayer.isMonster && !gameModePlayer.isInfected)))
			{
				ApplyColor(c);
			}
		}

		public void FlashDamage()
		{
			_damageFlashT = 1f;
			_damageFlashActive = true;
		}

		private void TickDamageFlash()
		{
			if (_damageFlashActive)
			{
				float num = Mathf.Max(damageFlashDuration, 0.01f);
				_damageFlashT -= Time.deltaTime / num;
				if (_damageFlashT <= 0f)
				{
					_damageFlashT = 0f;
					_damageFlashActive = false;
					ApplyColor(currentPlayerColor);
				}
				else
				{
					ApplyColor(Color.Lerp(currentPlayerColor, damageFlashColor, _damageFlashT));
				}
			}
		}

		private LODGroup GetLODGroup()
		{
			if (PlayerLOD != null)
			{
				return PlayerLOD;
			}
			LODGroup component = GetComponent<LODGroup>();
			if (component != null)
			{
				return component;
			}
			return GetComponentInChildren<LODGroup>();
		}

		private void ApplyColorToLODRenderers(Color c)
		{
			int colorID = GetColorID();
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			if (lodBodyRenderers != null && lodBodyRenderers.Count > 0)
			{
				foreach (Renderer lodBodyRenderer in lodBodyRenderers)
				{
					if (!(lodBodyRenderer == null) && lodBodyRenderer.sharedMaterials.Length != 0)
					{
						lodBodyRenderer.GetPropertyBlock(_mpb);
						_mpb.SetColor(colorID, c);
						lodBodyRenderer.SetPropertyBlock(_mpb);
					}
				}
				return;
			}
			LODGroup lODGroup = GetLODGroup();
			if (lODGroup == null)
			{
				return;
			}
			LOD[] lODs = lODGroup.GetLODs();
			for (int i = 0; i < lODs.Length; i++)
			{
				Renderer[] renderers = lODs[i].renderers;
				foreach (Renderer renderer in renderers)
				{
					if (!(renderer == null) && (playerRenderers == null || !playerRenderers.Contains(renderer)) && (playerEyeRenderers == null || !playerEyeRenderers.Contains(renderer)) && renderer.sharedMaterials.Length != 0)
					{
						renderer.GetPropertyBlock(_mpb);
						_mpb.SetColor(colorID, c);
						renderer.SetPropertyBlock(_mpb);
					}
				}
			}
		}

		private void ApplySkinToLODRenderers(Material skin)
		{
			if (skin == null)
			{
				return;
			}
			int colorID = GetColorID();
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			if (lodBodyRenderers != null && lodBodyRenderers.Count > 0)
			{
				foreach (Renderer lodBodyRenderer in lodBodyRenderers)
				{
					if (lodBodyRenderer == null)
					{
						continue;
					}
					Material[] sharedMaterials = lodBodyRenderer.sharedMaterials;
					if (sharedMaterials.Length != 0)
					{
						if (sharedMaterials[0] != skin)
						{
							sharedMaterials[0] = skin;
							lodBodyRenderer.sharedMaterials = sharedMaterials;
						}
						lodBodyRenderer.GetPropertyBlock(_mpb);
						_mpb.SetColor(colorID, currentPlayerColor);
						lodBodyRenderer.SetPropertyBlock(_mpb);
					}
				}
				return;
			}
			LODGroup lODGroup = GetLODGroup();
			if (lODGroup == null)
			{
				return;
			}
			LOD[] lODs = lODGroup.GetLODs();
			for (int i = 0; i < lODs.Length; i++)
			{
				Renderer[] renderers = lODs[i].renderers;
				foreach (Renderer renderer in renderers)
				{
					if (renderer == null || (playerRenderers != null && playerRenderers.Contains(renderer)) || (playerEyeRenderers != null && playerEyeRenderers.Contains(renderer)))
					{
						continue;
					}
					Material[] sharedMaterials2 = renderer.sharedMaterials;
					if (sharedMaterials2.Length != 0)
					{
						if (sharedMaterials2[0] != skin)
						{
							sharedMaterials2[0] = skin;
							renderer.sharedMaterials = sharedMaterials2;
						}
						renderer.GetPropertyBlock(_mpb);
						_mpb.SetColor(colorID, currentPlayerColor);
						renderer.SetPropertyBlock(_mpb);
					}
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void SetRGBMonkey(bool isTrue)
		{
			isRainbowActive = isTrue;
			if (isTrue && _rainbowRoutine == null)
			{
				_rainbowRoutine = StartCoroutine(AnimateRainbow());
			}
		}

		private void CacheRainbowMaterials()
		{
			List<Renderer> list = new List<Renderer>();
			List<int> list2 = new List<int>();
			if (playerRenderers != null)
			{
				for (int i = 0; i < playerRenderers.Count; i++)
				{
					Renderer renderer = playerRenderers[i];
					if (!(renderer == null))
					{
						int num = PropertyBlockSlotCount(renderer);
						if (num >= 1)
						{
							int item = Mathf.Min((i != 0) ? 1 : 0, num - 1);
							list.Add(renderer);
							list2.Add(item);
						}
					}
				}
			}
			if (lodBodyRenderers != null && lodBodyRenderers.Count > 0)
			{
				foreach (Renderer lodBodyRenderer in lodBodyRenderers)
				{
					if (!(lodBodyRenderer == null) && lodBodyRenderer.sharedMaterials.Length != 0)
					{
						list.Add(lodBodyRenderer);
						list2.Add(0);
					}
				}
			}
			else
			{
				LODGroup lODGroup = GetLODGroup();
				if (lODGroup != null)
				{
					LOD[] lODs = lODGroup.GetLODs();
					for (int j = 0; j < lODs.Length; j++)
					{
						Renderer[] renderers = lODs[j].renderers;
						foreach (Renderer renderer2 in renderers)
						{
							if (!(renderer2 == null) && (playerRenderers == null || !playerRenderers.Contains(renderer2)) && (playerEyeRenderers == null || !playerEyeRenderers.Contains(renderer2)) && renderer2.sharedMaterials.Length != 0)
							{
								list.Add(renderer2);
								list2.Add(0);
							}
						}
					}
				}
			}
			_cachedRainbowRenderers = list.ToArray();
			_cachedRainbowMatIndices = list2.ToArray();
		}

		private IEnumerator AnimateRainbow()
		{
			float duration = 5f;
			float elapsed = 0f;
			int colorID = GetColorID();
			CacheRainbowMaterials();
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			while (isRainbowActive)
			{
				elapsed += Time.deltaTime;
				Color value = Color.HSVToRGB(Mathf.Repeat(elapsed / duration, 1f), 1f, 1f);
				for (int i = 0; i < _cachedRainbowRenderers.Length; i++)
				{
					Renderer renderer = _cachedRainbowRenderers[i];
					if (!(renderer == null))
					{
						int num = _cachedRainbowMatIndices[i];
						if (num >= 0 && num < PropertyBlockSlotCount(renderer))
						{
							renderer.GetPropertyBlock(_mpb, num);
							_mpb.SetColor(colorID, value);
							renderer.SetPropertyBlock(_mpb, num);
						}
					}
				}
				yield return null;
			}
			_rainbowRoutine = null;
		}

		private IEnumerator delay(float time, Action done)
		{
			if (Mathf.Approximately(time, 1f))
			{
				yield return _waitOne;
			}
			else if (Mathf.Approximately(time, 0.5f))
			{
				yield return _waitPointFive;
			}
			else if (Mathf.Approximately(time, 0.1f))
			{
				yield return _waitPointOne;
			}
			else if (Mathf.Approximately(time, 0.2f))
			{
				yield return _waitPointTwo;
			}
			else
			{
				yield return new WaitForSeconds(time);
			}
			done?.Invoke();
		}

		public void RefreshPlayerValuesLocal()
		{
			if (base.photonView.Owner == null)
			{
				StartCoroutine(delay(1f, delegate
				{
					RefreshPlayerValuesLocal();
				}));
				return;
			}
			if (base.photonView.IsMine && MonkeDevNetworkingManager.Manager == null)
			{
				return;
			}
			string username;
			string colorJson;
			Dictionary<string, string> cosmetics;
			if (_appearanceOverride != null)
			{
				username = _appearanceOverride.Name;
				colorJson = (string.IsNullOrEmpty(_appearanceOverride.ColourJson) ? JsonUtility.ToJson(Color.white) : _appearanceOverride.ColourJson);
				cosmetics = _appearanceOverride.Cosmetics;
			}
			else
			{
				ReadOwnValues(out username, out colorJson, out cosmetics);
			}
			ApplyPlayerValues(username, colorJson, cosmetics);
			if (gameModePlayer != null && gameModePlayer.isMonster && LethalApeR.Gameplay.BeTheMonster.BTMGameManager.Instance != null)
			{
				gameModePlayer.ApplyRigVisibility();
			}
		}

		private void SafeSetColor(Renderer r, int idx, Color c)
		{
			if (!(r == null) && idx >= 0 && idx < PropertyBlockSlotCount(r))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				r.GetPropertyBlock(_mpb, idx);
				_mpb.SetColor(GetColorID(), c);
				r.SetPropertyBlock(_mpb, idx);
			}
		}

		private static int PropertyBlockSlotCount(Renderer r)
		{
			Material[] sharedMaterials = r.sharedMaterials;
			if (sharedMaterials == null)
			{
				return 0;
			}
			int num = sharedMaterials.Length;
			if (num < 2)
			{
				return num;
			}
			if (r is SkinnedMeshRenderer skinnedMeshRenderer)
			{
				if (skinnedMeshRenderer.sharedMesh != null)
				{
					return Mathf.Min(num, skinnedMeshRenderer.sharedMesh.subMeshCount);
				}
				return 0;
			}
			if (r is MeshRenderer)
			{
				if (r.TryGetComponent<MeshFilter>(out MeshFilter component) && component.sharedMesh != null)
				{
					return Mathf.Min(num, component.sharedMesh.subMeshCount);
				}
				return 0;
			}
			return 1;
		}

		private string GetCosmeticsHash(Dictionary<string, string> cosmetics)
		{
			if (cosmetics == null || cosmetics.Count == 0)
			{
				return "EMPTY";
			}
			System.Text.StringBuilder stringBuilder = new System.Text.StringBuilder(cosmetics.Count * 20);
			foreach (KeyValuePair<string, string> cosmetic in cosmetics)
			{
				stringBuilder.Append(cosmetic.Key);
				stringBuilder.Append(':');
				stringBuilder.Append(cosmetic.Value);
				stringBuilder.Append(';');
			}
			return stringBuilder.ToString();
		}

		private void UpdateCosmetics(Dictionary<string, string> cosmetics)
		{
			if (cosmetics == null)
			{
				return;
			}
			if (_isUpdatingCosmetics)
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] Already updating cosmetics, skipping to prevent recursion");
				return;
			}
			_isUpdatingCosmetics = true;
			try
			{
				if (cosmetics.TryGetValue("PlayerModel", out var value) && !string.IsNullOrEmpty(value))
				{
					ActivateSelectedPlayerModel(value);
				}
				bool cosmeticsAllowed = CosmeticsAllowedOnModel();
				bool flag = _appearanceOverride != null || _restoringOwnLook;
				Color c = currentPlayerColor;
				foreach (KeyValuePair<string, string> cosmetic in cosmetics)
				{
					if (!(cosmetic.Key == "PlayerModel") && (!flag || !(cosmetic.Key == "MonsterSkin")))
					{
						ApplyCosmetic(cosmetic.Key, cosmetic.Value ?? "", cosmeticsAllowed);
					}
				}
				ApplyColor(c);
				InvalidateCosmeticCull();
			}
			finally
			{
				_isUpdatingCosmetics = false;
			}
		}

		public void UpdateSingleCosmetic(string type, string value)
		{
			if (string.IsNullOrEmpty(type) || (_appearanceOverride != null && !(type == "MonsterSkin")))
			{
				return;
			}
			bool cosmeticsAllowed = CosmeticsAllowedOnModel();
			Color c = currentPlayerColor;
			if (type == "PlayerModel")
			{
				ActivateSelectedPlayerModel(value);
			}
			else if (!ApplyCosmetic(type, value, cosmeticsAllowed))
			{
				return;
			}
			ApplyColor(c);
			InvalidateCosmeticCull();
		}

		private bool CosmeticsAllowedOnModel()
		{
			return FindPlayerModel(selectedPlayerModel)?.cosmeticsEnabled ?? true;
		}

		private bool ApplyCosmetic(string key, string value, bool cosmeticsAllowed)
		{
			if (key == "Skin")
			{
				ApplySkin(value);
				return true;
			}
			if (key == "Eye")
			{
				ApplyEyes(value);
				return true;
			}
			if (key == "MonsterSkin")
			{
				if (gameModePlayer != null)
				{
					gameModePlayer.SetSelectedMonsterSkin(value);
				}
				return true;
			}
			return ApplySlot(key, value, cosmeticsAllowed);
		}

		private void ApplySkin(string value)
		{
			if (!HasRenderers(playerRenderers))
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] Cannot apply skin '" + value + "' - playerRenderers is empty. Model may not support skins.");
				return;
			}
			Material material = FindMaterial(Skins, string.IsNullOrEmpty(value) ? "APE" : value);
			if (!(material == null))
			{
				ApplyMaterialToList(playerRenderers, material, BodyMaterialSlot);
				ApplySkinToLODRenderers(material);
			}
		}

		private void ApplyEyes(string value)
		{
			if (!HasRenderers(playerEyeRenderers))
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] Cannot apply eyes '" + value + "' - playerEyeRenderers is empty. Model may not support eyes.");
				return;
			}
			Material material = FindMaterial(Eyes, string.IsNullOrEmpty(value) ? "DEFAULT_EYE" : value);
			if (material != null)
			{
				ApplyMaterialToList(playerEyeRenderers, material, FirstMaterialSlot);
			}
		}

		private bool ApplySlot(string slotName, string csvIds, bool cosmeticsAllowed)
		{
			Transform transform = null;
			for (int i = 0; i < CosmeticSlots.Count; i++)
			{
				if (CosmeticSlots[i].SlotName == slotName)
				{
					transform = CosmeticSlots[i].Object;
					break;
				}
			}
			if (transform == null)
			{
				return false;
			}
			if (cosmeticsAllowed || slotName == "Pet")
			{
				FillEnabledSet(csvIds);
				foreach (Transform item in transform)
				{
					item.gameObject.SetActive(_enabledCosmeticsSet.Contains(item.name));
				}
			}
			else
			{
				foreach (Transform item2 in transform)
				{
					item2.gameObject.SetActive(false);
				}
			}
			return true;
		}

		private void FillEnabledSet(string csvIds)
		{
			_enabledCosmeticsSet.Clear();
			if (string.IsNullOrEmpty(csvIds))
			{
				return;
			}
			int num = 0;
			int num2;
			do
			{
				num2 = csvIds.IndexOf(',', num);
				int num3 = ((num2 < 0) ? csvIds.Length : num2);
				while (num < num3 && char.IsWhiteSpace(csvIds[num]))
				{
					num++;
				}
				while (num3 > num && char.IsWhiteSpace(csvIds[num3 - 1]))
				{
					num3--;
				}
				if (num3 > num)
				{
					_enabledCosmeticsSet.Add(csvIds.Substring(num, num3 - num));
				}
				num = num2 + 1;
			}
			while (num2 >= 0);
		}

		private void InvalidateCosmeticCull()
		{
			if (!_cosmeticCullerLooked)
			{
				_cosmeticCullerLooked = true;
				_cosmeticCuller = GetComponent<CosmeticDistanceCuller>();
				_animationLod = GetComponent<PlayerAnimationLOD>();
			}
			if (_cosmeticCuller != null)
			{
				_cosmeticCuller.InvalidateCache();
			}
			if (_animationLod != null)
			{
				_animationLod.InvalidateCache();
			}
		}

		public void ApplyMaterialToList(List<Renderer> list, Material mat, Func<int, int> defaultIndexForRenderer)
		{
			if (list == null || (mat == null && list.Count != 0))
			{
				return;
			}
			if (list.Count == 0)
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] Cannot apply material - renderer list is empty.");
				return;
			}
			for (int i = 0; i < list.Count; i++)
			{
				Renderer renderer = list[i];
				if (!(renderer == null))
				{
					int num = defaultIndexForRenderer(i);
					Material[] sharedMaterials = renderer.sharedMaterials;
					if (num >= 0 && num < sharedMaterials.Length)
					{
						sharedMaterials[num] = mat;
						renderer.sharedMaterials = sharedMaterials;
					}
				}
			}
		}

		public void ChangeMaterial(Renderer renderer, int materialIndex, Material newMaterial)
		{
			ApplyMaterialToList(new List<Renderer> { renderer }, newMaterial, (int _) => materialIndex);
		}

		public void GrabPlayer(int grabberActorId, bool isLeftHand, bool byStaff = false)
		{
			base.photonView.RPC("RPC_GrabPlayer", RpcTarget.All, grabberActorId, isLeftHand, byStaff);
		}

		public void ReleasePlayer()
		{
			base.photonView.RPC("RPC_ReleasePlayer", RpcTarget.All);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_GrabPlayer(int grabberActorId, bool isLeftHand, bool byStaff, PhotonMessageInfo info)
		{
			if (isBeingGrabbed || info.Sender == null || info.Sender.ActorNumber != grabberActorId || MonkeDevNetworkingManager.Manager == null || (!byStaff && !GrabAllowed(grabberActorId)))
			{
				return;
			}
			MonkeDevNetworkingPlayer playerByActorId = MonkeDevNetworkingManager.Manager.GetPlayerByActorId(grabberActorId);
			if (playerByActorId == null)
			{
				return;
			}
			Transform transform = (isLeftHand ? playerByActorId.LeftHand : playerByActorId.RightHand);
			if (!(transform == null))
			{
				float num = Mathf.Max(1f, transform.lossyScale.x);
				Quaternion quaternion = Quaternion.Inverse(transform.rotation);
				if (byStaff)
				{
					grabLocalPos = Vector3.zero;
				}
				else
				{
					num *= 0.6f;
					grabLocalPos = Vector3.ClampMagnitude(quaternion * (Head.position - transform.position), num);
				}
				grabLocalRot = quaternion * Head.rotation;
				Quaternion quaternion2 = Quaternion.Inverse(Head.rotation);
				if ((bool)LeftHand)
				{
					grabLeftHandPos = quaternion2 * (LeftHand.position - Head.position);
					grabLeftHandRot = quaternion2 * LeftHand.rotation;
				}
				if ((bool)RightHand)
				{
					grabRightHandPos = quaternion2 * (RightHand.position - Head.position);
					grabRightHandRot = quaternion2 * RightHand.rotation;
				}
				grabberHand = transform;
				this.grabberActorId = grabberActorId;
				grabByStaff = byStaff;
				grabbedAt = Time.time;
				isBeingGrabbed = true;
				if (base.photonView.IsMine)
				{
					canTrack = false;
					HoldRig();
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReleasePlayer(PhotonMessageInfo info)
		{
			int num = ((info.Sender != null) ? info.Sender.ActorNumber : (-1));
			if (!isBeingGrabbed || num == grabberActorId || num == base.photonView.OwnerActorNr || GrabAllowed(num))
			{
				DropGrab();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void KickPlayer()
		{
			if (base.photonView.IsMine)
			{
				PhotonNetwork.LeaveRoom();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_HammerKickQuit()
		{
			if (base.photonView.IsMine)
			{
				Application.Quit();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_TeleportToPosition(float x, float y, float z)
		{
			if (base.photonView.IsMine)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if ((object)instance != null)
				{
					instance.TeleportPlayerRaw(new Vector3(x, y, z), instance.transform.rotation, false, false);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_TeleportToSpawn()
		{
			if (base.photonView.IsMine && !(GorillaLocomotion.Player.Instance == null) && !(GorillaLocomotion.Player.Instance.spawnPosition == null))
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				instance.TeleportPlayerRaw(instance.spawnPosition.position, GorillaLocomotion.Player.Instance.transform.rotation);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_SetMonsterSkinMod(bool enabled, string monsterSkinId)
		{
			if (base.photonView.IsMine || gameModePlayer == null)
			{
				return;
			}
			if (enabled)
			{
				gameModePlayer.SetMonsterRigsActive(true);
				gameModePlayer.apeRig.SetActive(false);
				GameModePlayer.MonsterEntry[] availableMonsters = gameModePlayer.availableMonsters;
				if (availableMonsters == null)
				{
					return;
				}
				foreach (GameModePlayer.MonsterEntry monsterEntry in availableMonsters)
				{
					if (monsterEntry.MonsterGameObject != null)
					{
						bool active = (!string.IsNullOrEmpty(monsterSkinId) && monsterEntry.MonsterName == monsterSkinId) || (string.IsNullOrEmpty(monsterSkinId) && monsterEntry == gameModePlayer.availableMonsters[0]);
						monsterEntry.MonsterGameObject.SetActive(active);
					}
				}
				return;
			}
			gameModePlayer.SetMonsterRigsActive(false);
			gameModePlayer.apeRig.SetActive(true);
			GameModePlayer.MonsterEntry[] availableMonsters2 = gameModePlayer.availableMonsters;
			if (availableMonsters2 == null)
			{
				return;
			}
			foreach (GameModePlayer.MonsterEntry monsterEntry2 in availableMonsters2)
			{
				if (monsterEntry2.MonsterGameObject != null)
				{
					monsterEntry2.MonsterGameObject.SetActive(false);
				}
			}
		}

		private void ActivateSelectedPlayerModel(string modelName)
		{
			if (_isActivatingModel)
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] Already activating model, skipping to prevent recursion");
				return;
			}
			if (availablePlayerModels == null || availablePlayerModels.Count == 0)
			{
				Debug.LogWarning("[MonkeDevNetworkingPlayer] No player models configured!");
				return;
			}
			_isActivatingModel = true;
			try
			{
				HideAllPlayerModels();
				if (string.IsNullOrEmpty(modelName))
				{
					modelName = "ApeRig";
				}
				selectedPlayerModel = modelName;
				if (!UsePlayerModel(FindPlayerModel(modelName)))
				{
					Debug.LogWarning("[MonkeDevNetworkingPlayer] Player model '" + modelName + "' not found, forcing ApeRig fallback");
					if (!UsePlayerModel(FindPlayerModel("ApeRig")))
					{
						Debug.LogError("[MonkeDevNetworkingPlayer] CRITICAL: ApeRig model not found! Activating first available model");
						for (int i = 0; i < availablePlayerModels.Count && !UsePlayerModel(availablePlayerModels[i]); i++)
						{
						}
					}
				}
				if (!AnyPlayerModelActive())
				{
					Debug.LogError("[MonkeDevNetworkingPlayer] CRITICAL: No player model is active! Player will be invisible!");
				}
			}
			finally
			{
				_isActivatingModel = false;
			}
			RefreshPlayerValuesLocal();
		}

		private bool UsePlayerModel(PlayerModelEntry model)
		{
			if (model?.ModelGameObject == null)
			{
				return false;
			}
			model.ModelGameObject.SetActive(true);
			selectedPlayerModel = model.ModelName;
			if (HasRenderers(model.ModelRenderers))
			{
				playerRenderers = model.ModelRenderers;
			}
			if (HasRenderers(model.ModelEyeRenderers))
			{
				playerEyeRenderers = model.ModelEyeRenderers;
			}
			return true;
		}

		private bool AnyPlayerModelActive()
		{
			for (int i = 0; i < availablePlayerModels.Count; i++)
			{
				GameObject gameObject = availablePlayerModels[i]?.ModelGameObject;
				if (gameObject != null && gameObject.activeSelf)
				{
					return true;
				}
			}
			return false;
		}

		private void CheckLODType()
		{
			LODGroup lODGroup = GetLODGroup();
			if (!(lODGroup == null) && !(Camera.main == null))
			{
				int currentLODIndex = LODUtils.GetCurrentLODIndex(lODGroup, Camera.main);
				if (currentLODIndex != _lastLODIndex)
				{
					_lastLODIndex = currentLODIndex;
					OnLODChange?.Invoke(currentLODIndex);
				}
			}
		}

		public void RefreshHandCache()
		{
			_hands = GetComponentsInChildren<FingerAnimations>(true);
		}

		private FingerAnimations FindLiveHand(HandType type)
		{
			if (_hands == null)
			{
				return null;
			}
			for (int i = 0; i < _hands.Length; i++)
			{
				FingerAnimations fingerAnimations = _hands[i];
				if (fingerAnimations != null && fingerAnimations.handType == type && fingerAnimations.isActiveAndEnabled)
				{
					return fingerAnimations;
				}
			}
			return null;
		}

		private int PackLiveHand(HandType type)
		{
			FingerAnimations fingerAnimations = FindLiveHand(type);
			if (fingerAnimations != null)
			{
				return FingerAnimations.PackThreeFloats(fingerAnimations.CurrentButton, fingerAnimations.CurrentTrigger, fingerAnimations.CurrentGrip);
			}
			LethalApeR.Gameplay.BeTheMonster.VRInputController instance = LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance;
			if (instance == null)
			{
				return 0;
			}
			float b;
			float c;
			if (type == HandType.Left)
			{
				b = instance.LeftTriggerValue;
				c = instance.LeftGripValue;
			}
			else
			{
				b = instance.RightTriggerValue;
				c = instance.RightGripValue;
			}
			return FingerAnimations.PackThreeFloats(0f, b, c);
		}

		private void DistributeHand(HandType type, int packed)
		{
			FingerAnimations.UnpackToTargets(packed, out var a, out var b, out var c);
			if (type == HandType.Left)
			{
				NetLeftTrigger = b;
				NetLeftGrip = c;
				NetLeftButton = a;
			}
			else
			{
				NetRightTrigger = b;
				NetRightGrip = c;
				NetRightButton = a;
			}
			if (_hands == null)
			{
				return;
			}
			for (int i = 0; i < _hands.Length; i++)
			{
				FingerAnimations fingerAnimations = _hands[i];
				if (fingerAnimations != null && fingerAnimations.handType == type)
				{
					fingerAnimations.ApplyNetworkValues(a, b, c);
				}
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (_hands == null)
			{
				RefreshHandCache();
			}
			if (stream.IsWriting)
			{
				stream.SendNext(playerScale);
				int num = PackLiveHand(HandType.Left);
				int num2 = PackLiveHand(HandType.Right);
				if (HandDelta(num, _lastSentLeftHand) > 0.02f || HandDelta(num2, _lastSentRightHand) > 0.02f || Time.time - _lastHandSendTime >= 0.12f)
				{
					_lastSentLeftHand = num;
					_lastSentRightHand = num2;
					_lastHandSendTime = Time.time;
				}
				stream.SendNext(_lastSentLeftHand);
				stream.SendNext(_lastSentRightHand);
			}
			else
			{
				playerScale = (float)stream.ReceiveNext();
				DistributeHand(HandType.Left, (int)stream.ReceiveNext());
				DistributeHand(HandType.Right, (int)stream.ReceiveNext());
			}
			if ((bool)Head)
			{
				Head.localScale = Vector3.one * playerScale;
			}
		}

		private static float HandDelta(int a, int b)
		{
			if (b < 0)
			{
				return float.MaxValue;
			}
			if (a == b)
			{
				return 0f;
			}
			int val = Math.Abs(((a >> 16) & 0xFF) - ((b >> 16) & 0xFF));
			int val2 = Math.Abs(((a >> 8) & 0xFF) - ((b >> 8) & 0xFF));
			int val3 = Math.Abs((a & 0xFF) - (b & 0xFF));
			return (float)Math.Max(val, Math.Max(val2, val3)) * 0.003921569f;
		}
	}
}
