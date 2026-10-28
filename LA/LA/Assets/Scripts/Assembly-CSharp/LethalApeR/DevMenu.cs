using System;
using System.Collections.Generic;
using ExitGames.Client.Photon;
using ImGuiNET;
using LethalApeR.Gameplay;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using LethalApeR.Social;
using Photon.Realtime;
using UImGui;
using UImGui.VR;
using Unity.Profiling;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR
{
	public class DevMenu : MonoBehaviour, IInRoomCallbacks
	{
		private sealed class BoxEspEntry
		{
			private readonly MonkeDevNetworkingPlayer _player;

			private readonly LineRenderer _lr;

			private readonly Transform _labelTransform;

			private readonly TextMesh _label;

			private readonly Vector3[] _pts = new Vector3[16];

			private string _cachedLabelName;

			public BoxEspEntry(MonkeDevNetworkingPlayer player)
			{
				_player = player;
				GameObject gameObject = new GameObject(string.Format("[ESP_Box]{0}", player.photonView.OwnerActorNr));
				gameObject.hideFlags = HideFlags.HideAndDontSave;
				_lr = gameObject.AddComponent<LineRenderer>();
				_lr.positionCount = 16;
				_lr.useWorldSpace = true;
				_lr.loop = false;
				_lr.startWidth = 0.008f;
				_lr.endWidth = 0.008f;
				_lr.startColor = Color.red;
				_lr.endColor = Color.red;
				_lr.sharedMaterial = GetUnlitLineMaterial();
				_lr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
				_lr.receiveShadows = false;
				_lr.bounds = new Bounds(Vector3.zero, Vector3.one * 10000f);
				GameObject gameObject2 = new GameObject(string.Format("[ESP_Label]{0}", player.photonView.OwnerActorNr));
				gameObject2.transform.SetParent(player.Head, false);
				gameObject2.transform.localPosition = new Vector3(0f, 0.85f, 0f);
				_label = gameObject2.AddComponent<TextMesh>();
				_label.fontSize = 35;
				_label.characterSize = 0.04f;
				_label.anchor = TextAnchor.MiddleCenter;
				_label.color = Color.white;
				MeshRenderer component = gameObject2.GetComponent<MeshRenderer>();
				component.material = new Material(component.sharedMaterial);
				if (component.material.HasProperty("_ZTest"))
				{
					component.material.SetFloat("_ZTest", 8f);
				}
				component.sortingOrder = 100;
				component.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
				component.receiveShadows = false;
				_labelTransform = gameObject2.transform;
			}

			public bool Tick(Camera cam)
			{
				if (_player == null || _player.Head == null || _player.photonView == null)
				{
					return false;
				}
				UpdateLabel(cam);
				UpdateBox(_player.Head.position);
				_lr.bounds = new Bounds(Vector3.zero, Vector3.one * 10000f);
				return true;
			}

			private void UpdateLabel(Camera cam)
			{
				Player owner = _player.photonView.Owner;
				string text = ((owner != null && !string.IsNullOrEmpty(owner.NickName)) ? owner.NickName : "?");
				Vector3 position = _player.Head.position;
				string text2 = ((owner != null && !string.IsNullOrEmpty(owner.UserId)) ? owner.UserId : "N/A");
				string text3 = string.Format("{0}\n{1:F1}  {2:F1}  {3:F1}\n{4}", text, position.x, position.y, position.z, text2);
				if (text3 != _cachedLabelName)
				{
					_cachedLabelName = text3;
					_label.text = text3;
				}
				if (cam != null)
				{
					_labelTransform.rotation = Quaternion.LookRotation(_labelTransform.position - cam.transform.position);
				}
			}

			private void UpdateBox(Vector3 head)
			{
				float x = _player.Head.lossyScale.x;
				float num = x * 0.47f;
				Vector3 vector = head + Vector3.down * (num * 0.6f);
				float num2 = x * 0.35f;
				float num3 = x * 0.3f;
				Vector3 vector2 = new Vector3(vector.x - num2, vector.y - num, vector.z + num3);
				Vector3 vector3 = new Vector3(vector.x - num2, vector.y - num, vector.z - num3);
				Vector3 vector4 = new Vector3(vector.x + num2, vector.y - num, vector.z - num3);
				Vector3 vector5 = new Vector3(vector.x + num2, vector.y - num, vector.z + num3);
				Vector3 vector6 = new Vector3(vector.x - num2, vector.y + num, vector.z + num3);
				Vector3 vector7 = new Vector3(vector.x - num2, vector.y + num, vector.z - num3);
				Vector3 vector8 = new Vector3(vector.x + num2, vector.y + num, vector.z - num3);
				Vector3 vector9 = new Vector3(vector.x + num2, vector.y + num, vector.z + num3);
				_pts[0] = vector2;
				_pts[1] = vector3;
				_pts[2] = vector4;
				_pts[3] = vector5;
				_pts[4] = vector9;
				_pts[5] = vector8;
				_pts[6] = vector4;
				_pts[7] = vector8;
				_pts[8] = vector7;
				_pts[9] = vector3;
				_pts[10] = vector7;
				_pts[11] = vector6;
				_pts[12] = vector9;
				_pts[13] = vector5;
				_pts[14] = vector2;
				_pts[15] = vector6;
				_lr.SetPositions(_pts);
			}

			public void Destroy()
			{
				if (_lr != null)
				{
					UnityEngine.Object.Destroy(_lr.gameObject);
				}
				if (_labelTransform != null)
				{
					UnityEngine.Object.Destroy(_labelTransform.gameObject);
				}
			}
		}

		[Serializable]
		private struct TpBookmark
		{
			public string Label;

			public Vector3 Pos;
		}

		private struct GameLogEntry
		{
			public string Type;

			public string Message;

			public string StackTrace;

			public DateTime Time;
		}

		[Serializable]
		private class TpBookmarkList
		{
			public List<TpBookmark> Items = new List<TpBookmark>();
		}

		private static class In
		{
			private static VRInputController C => VRInputController.Instance;

			public static float LeftGrip => Mathf.Max((C != null) ? C.LeftGripValue : 0f, OVRInput.Get(OVRInput.Axis1D.PrimaryHandTrigger, OVRInput.Controller.LTouch));

			public static float RightGrip => Mathf.Max((C != null) ? C.RightGripValue : 0f, OVRInput.Get(OVRInput.Axis1D.PrimaryHandTrigger, OVRInput.Controller.RTouch));

			public static float LeftTrigger => Mathf.Max((C != null) ? C.LeftTriggerValue : 0f, OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, OVRInput.Controller.LTouch));

			public static float RightTrigger => Mathf.Max((C != null) ? C.RightTriggerValue : 0f, OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, OVRInput.Controller.RTouch));

			public static bool LeftPrimaryButton => (C != null && C.LeftPrimaryButton) || OVRInput.Get(OVRInput.Button.One, OVRInput.Controller.LTouch);

			public static bool RightPrimaryButton => (C != null && C.RightPrimaryButton) || OVRInput.Get(OVRInput.Button.One, OVRInput.Controller.RTouch);

			public static bool LeftSecondaryButton => (C != null && C.LeftSecondaryButton) || OVRInput.Get(OVRInput.Button.Two, OVRInput.Controller.LTouch);

			public static bool RightSecondaryButton => (C != null && C.RightSecondaryButton) || OVRInput.Get(OVRInput.Button.Two, OVRInput.Controller.RTouch);

			public static Vector2 LeftJoystick
			{
				get
				{
					Vector2 vector = ((C != null) ? C.LeftJoystick : Vector2.zero);
					Vector2 vector2 = OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick, OVRInput.Controller.LTouch);
					if (!(vector.sqrMagnitude < vector2.sqrMagnitude))
					{
						return vector;
					}
					return vector2;
				}
			}

			public static Vector2 RightJoystick
			{
				get
				{
					Vector2 vector = ((C != null) ? C.RightJoystick : Vector2.zero);
					Vector2 vector2 = OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick, OVRInput.Controller.RTouch);
					if (!(vector.sqrMagnitude < vector2.sqrMagnitude))
					{
						return vector;
					}
					return vector2;
				}
			}
		}

		private const int MaxParticles = 120;

		private bool _enableBackgroundParticles;

		private int _particleCount = 60;

		private float _particleDotSize = 1.5f;

		private float _particleLineThickness = 1f;

		private float _particleInteractDist = 55f;

		private float _cursorInteractDist = 52f;

		private Vector4 _particleDotColor = new Vector4(1f, 1f, 1f, 0.6f);

		private Vector4 _particleLineColor = new Vector4(1f, 1f, 1f, 1f);

		private Vector4 _cursorLineColor = new Vector4(1f, 1f, 1f, 1f);

		private readonly System.Random _dotRandom = new System.Random();

		private bool _particlesInitialized;

		private int _windowDotCount;

		private Vector2[] _windowDots;

		private Vector2[] _windowDrift;

		private bool _previewInitialized;

		private int _previewDotCount;

		private Vector2[] _previewDots;

		private Vector2[] _previewDrift;

		private bool _spiralEnabled;

		private int _spiralArmCount = 3;

		private int _spiralParticlesPerArm = 100;

		private float _spiralSpeed = 0.25f;

		private float _spiralTightness = 2.5f;

		private float _spiralRadiusScale = 1f;

		private float _spiralDotSize = 2f;

		private Vector4 _spiralInnerColor = new Vector4(0.55f, 0.8f, 1f, 1f);

		private Vector4 _spiralOuterColor = new Vector4(0.15f, 0.25f, 0.7f, 0f);

		private float _spiralTime;

		private Camera _spyCamera;

		private RenderTexture _spyRenderTexture;

		private int _lastSpyRenderFrame = -1;

		private MonkeDevNetworkingPlayer _spectateTarget;

		private const int SpyWidth = 256;

		private const int SpyHeight = 192;

		private bool _boxEsp;

		private readonly Dictionary<int, BoxEspEntry> _espEntries = new Dictionary<int, BoxEspEntry>();

		private readonly List<int> _espStale = new List<int>();

		private bool _joyStickFly;

		private bool _speedBoost;

		private float _customFlySpeed = 3f;

		private float _customJump = 1.325f;

		private float _previousJumpMultiplier = 1.1f;

		private float _customSize = 1f;

		private float _previousCustomSize = 1f;

		private bool _useCustomGravity;

		private float _customGravity = 10.8f;

		private Vector3 _originalGravity;

		private bool _modLongArms;

		private bool _modInfiniteArms;

		private bool _modNoSlip;

		private bool _modSlippery;

		private bool _modIronGrip;

		private bool _modStickyHands;

		private bool _modInstantStick;

		private bool _modNoFriction;

		private bool _modSuperJump;

		private bool _modSpeedHack;

		private bool _modDoubleJump;

		private bool _modAutoJump;

		private bool _hasDoubleJump;

		private bool _prevDoubleJumpInput;

		private bool _modMoonGravity;

		private bool _modLowGravity;

		private bool _modFlipGravity;

		private bool _modAirSwim;

		private bool _modInvisible;

		private bool _modGhostMonkey;

		private bool _modNoBodyCollider;

		private bool _invisibleSent;

		private bool _modSpinMode;

		private bool _modBouncyMode;

		private bool _modPlatforms;

		private float _bouncyTimer;

		private bool _modDisableMovement;

		private bool _modDebugMovement;

		private GameObject _leftPlatform;

		private GameObject _rightPlatform;

		private GameObject _generatedPlatformPrefab;

		private bool _modGrabPlayers;

		private MonkeDevNetworkingPlayer _leftGrabbedPlayer;

		private MonkeDevNetworkingPlayer _rightGrabbedPlayer;

		private bool _kickGunEnabled;

		private float _kickJiggleTime;

		private MonkeDevNetworkingPlayer _kickGunTarget;

		private LineRenderer _kickGunLine;

		private LineRenderer _kickGunCircle;

		private bool _originalsStored;

		private float _origMaxArmLength;

		private float _origVelocityLimit;

		private float _origSlideVelocityLimit;

		private float _origMaxJumpSpeed;

		private float _origIceThreshold;

		private float _origSlideFactor;

		private float _origSlideControl;

		private float _origFrictionConstant;

		private float _origStickDepth;

		private bool _origBodyColliderState;

		private Vector3 _origHandOffset;

		private bool _handsResolved;

		private Transform _runtimeLeftHand;

		private Transform _runtimeRightHand;

		private const float KickRange = 15f;

		private const float KickAssistCone = 30f;

		private const float KickLockCone = 8f;

		private const int KickBeamSegments = 20;

		private const int KickReticlePoints = 32;

		private static readonly Color BeamIdleStart = new Color(1f, 0.45f, 0f, 1f);

		private static readonly Color BeamIdleEnd = new Color(1f, 0.45f, 0f, 0f);

		private static readonly Color BeamLockedStart = new Color(1f, 0.05f, 0.05f, 1f);

		private static readonly Color BeamLockedEnd = new Color(0.8f, 0f, 0f, 0f);

		private static readonly Color ReticleColor = new Color(1f, 0.05f, 0.05f, 0.9f);

		private static Material _lineMat;

		private static readonly Vector3 LongArmsHandOffset = new Vector3(0f, 0f, 0.25f);

		private string _localUsernameBuffer = "";

		private string _roomPropKey = "";

		private string _roomPropValue = "";

		private int _roomMaxPlayers;

		private string _playerSearch = "";

		private bool _isManagingPlayer;

		private int _selectedActorNumber = -1;

		private readonly HashSet<int> _mutedActors = new HashSet<int>();

		private readonly HashSet<int> _rainbowActors = new HashSet<int>();

		private Vector3 _tpManualPos;

		private string _tpBookmarkName = "Bookmark";

		private readonly List<TpBookmark> _tpBookmarks = new List<TpBookmark>();

		private readonly List<Transform> _discoveredTpPoints = new List<Transform>();

		private bool _spawnersScanned;

		private string[] _spawnerPrefabNames = Array.Empty<string>();

		private string[] _spawnerPrefabPaths = Array.Empty<string>();

		private int _selectedPrefabIndex;

		private int _spawnLimit = 10;

		private float _spawnCooldown = 1f;

		private float _lastSpawnTime = -999f;

		private bool _spamSpawning;

		private bool _showSpamButton;

		private bool _disableSpawnLimit;

		private readonly List<GameObject> _mySpawnedObjects = new List<GameObject>();

		private string _logSearch = "";

		private bool _logShowInfo = true;

		private bool _logShowWarn = true;

		private bool _logShowError = true;

		private bool _soundboardPreviewing;

		private static Dictionary<int, MonkeDevNetworkingPlayer> _remoteLookup = new Dictionary<int, MonkeDevNetworkingPlayer>();

		private static readonly object _logLock = new object();

		private static readonly List<GameLogEntry> _gameLogs = new List<GameLogEntry>();

		private static bool _logListenerStarted;

		private static bool _autoScrollLogs = true;

		private const int MaxLogs = 300;

		private int _currentSoundboardIndex = -1;

		private const float LobbyStatsInterval = 1f;

		private float _lsNextRefresh;

		private int _lsPlayers;

		private int _lsTransforms;

		private int _lsDrawing;

		private int _lsSkinned;

		private int _lsTicking;

		private int _lsAudioTotal;

		private int _lsAudioPlaying;

		private int _lsAudioSpatialized;

		private int _lsCosmeticOn;

		private int _lsCosmeticOff;

		private string _lsTopScripts = "";

		private long _lsGcMb;

		private bool _acousticsOff;

		private bool _devModeRequested;

		private float _dmAppCpuMs;

		private float _dmAppGpuMs;

		private float _dmCompCpuMs;

		private float _dmCompGpuMs;

		private float _dmGpuUtil;

		private float _dmCpuUtil;

		private int _dmDropped;

		private int _dmCpuLevel;

		private int _dmGpuLevel;

		private bool _dmSupported;

		private string _dmVerdict = "";

		private static readonly Dictionary<Type, bool> _loopCache = new Dictionary<Type, bool>();

		private static readonly string[] LoopNames = new string[3] { "Update", "LateUpdate", "FixedUpdate" };

		private ProfilerRecorder _recDrawCalls;

		private ProfilerRecorder _recSetPass;

		private ProfilerRecorder _recTris;

		private ProfilerRecorder _recVerts;

		private bool _recStarted;

		private static readonly Dictionary<DevMenuCap, DevMenuTier> CapTier = new Dictionary<DevMenuCap, DevMenuTier> { { DevMenuCap.PageMovement, DevMenuTier.Trial }, { DevMenuCap.PageWorld, DevMenuTier.Trial }, { DevMenuCap.PageTP, DevMenuTier.Trial }, { DevMenuCap.PageSettings, DevMenuTier.Trial }, { DevMenuCap.PagePlayers, DevMenuTier.Trial }, { DevMenuCap.PageStealth, DevMenuTier.Mod }, { DevMenuCap.PlayerEsp, DevMenuTier.Mod }, { DevMenuCap.PlayerKick, DevMenuTier.Mod }, { DevMenuCap.PlayerSpectate, DevMenuTier.Mod }, { DevMenuCap.PlayerBring, DevMenuTier.Mod }, { DevMenuCap.PlayerGrab, DevMenuTier.Mod }, { DevMenuCap.PlayerSendToSpawn, DevMenuTier.Mod }, { DevMenuCap.PageDebug, DevMenuTier.Admin }, { DevMenuCap.PageSoundboard, DevMenuTier.Admin }, { DevMenuCap.SectionRoom, DevMenuTier.Admin }, { DevMenuCap.PlayerRainbow, DevMenuTier.Admin }, { DevMenuCap.PageSpawners, DevMenuTier.Owner } };

		private bool _themeDirty = true;

		internal const float ThemeRoundingSentinel = 4f;

		private Vector4 _colAccent = new Vector4(0.231f, 0.51f, 0.965f, 1f);

		private Vector4 _colWindowBg = new Vector4(0.039f, 0.039f, 0.059f, 1f);

		private Vector4 _colTitleBg = new Vector4(0.031f, 0.031f, 0.047f, 1f);

		private Vector4 _colTitleBgActive = new Vector4(0.047f, 0.047f, 0.067f, 1f);

		private Vector4 _colTab = new Vector4(0.051f, 0.051f, 0.071f, 1f);

		private Vector4 _colTabHovered = new Vector4(0.231f, 0.51f, 0.965f, 0.4f);

		private Vector4 _colTabActive = new Vector4(0.231f, 0.51f, 0.965f, 0.28f);

		private Vector4 _colHeader = new Vector4(0.231f, 0.51f, 0.965f, 0.25f);

		private Vector4 _colHeaderHovered = new Vector4(0.231f, 0.51f, 0.965f, 0.35f);

		private Vector4 _colHeaderActive = new Vector4(0.231f, 0.51f, 0.965f, 0.45f);

		private Vector4 _colFrameBg = new Vector4(0.078f, 0.078f, 0.098f, 1f);

		private Vector4 _colFrameBgHovered = new Vector4(0.231f, 0.51f, 0.965f, 0.15f);

		private Vector4 _colFrameBgActive = new Vector4(0.231f, 0.51f, 0.965f, 0.25f);

		private Vector4 _colButton = new Vector4(0.231f, 0.51f, 0.965f, 0.7f);

		private Vector4 _colButtonHovered = new Vector4(0.318f, 0.584f, 0.976f, 0.8f);

		private Vector4 _colButtonActive = new Vector4(0.231f, 0.51f, 0.965f, 1f);

		private Vector4 _colSliderGrab = new Vector4(0.231f, 0.51f, 0.965f, 0.8f);

		private Vector4 _colCheckMark = new Vector4(0.231f, 0.51f, 0.965f, 1f);

		private Vector4 _colText = new Vector4(1f, 1f, 1f, 1f);

		private Vector4 _colSidebarBg = new Vector4(0.059f, 0.059f, 0.078f, 1f);

		private Vector4 _colContentBg = new Vector4(0.039f, 0.039f, 0.059f, 1f);

		private bool _panelOnLeftHand;

		private Vector3 _panelPosOffset = new Vector3(0f, 0.05f, 0.1f);

		private Vector3 _panelRotOffset = new Vector3(80f, 0f, 180f);

		private Vector3 _pointerRotOffset = Vector3.zero;

		private float _uiScale = 0.65f;

		private float _panelDistance = 1.25f;

		private bool _vrShowRayLine;

		private bool _vrShowManipulators;

		private ImguiVRManipulator _vrManipulator;

		private static readonly string[] PresetNames = new string[7] { "LAR Blue", "Default Dark", "Midnight Blue", "Crimson", "Forest", "Amethyst", "Gold" };

		[HideInInspector]
		public DevMenuTier Tier = DevMenuTier.Trial;

		[Header("Audio – UI")]
		[SerializeField]
		private AudioClip buttonClickClip;

		[SerializeField]
		private AudioClip hoverClip;

		[SerializeField]
		private AudioSource audioSource;

		[Header("Audio – Notifications")]
		[SerializeField]
		private AudioClip notifJoinClip;

		[SerializeField]
		private AudioClip notifLeaveClip;

		[SerializeField]
		private AudioClip notifErrorClip;

		[Header("Soundboard")]
		[SerializeField]
		private AudioSource soundboardAudioSource;

		[SerializeField]
		private AudioClip[] soundboardClips;

		[Header("Panel / VR")]
		[SerializeField]
		private global::UImGui.UImGui _uimguiComponent;

		[SerializeField]
		private Transform _leftHandTransform;

		[SerializeField]
		private Transform _rightHandTip;

		[Header("Game Mods")]
		[SerializeField]
		private GameObject _platformPrefab;

		[Header("TP Page")]
		[Tooltip("Extra teleport points. Objects tagged 'TPPoint' or named 'TP_<name>' are found automatically as well.")]
		[SerializeField]
		private Transform[] _tpPoints;

		private const int PageMovement = 0;

		private const int PageWorld = 1;

		private const int PageStealth = 2;

		private const int PagePlayers = 3;

		private const int PageTP = 4;

		private const int PageSpawners = 5;

		private const int PageDebug = 6;

		private const int PageSoundboard = 7;

		private const int PageSettings = 8;

		private const uint SidebarBarTweenId = 1397310464u;

		private const float SidebarWidth = 138f;

		private int _selectedPage;

		private int _previousPage = -1;

		private float _pageSwitchTime;

		private const int FPSHistorySize = 128;

		private int _fpsHistoryIdx;

		private float[] _fpsHistory;

		private uint _currentHoveredId;

		private uint _previousHoveredId;

		private bool _visible = true;

		private bool _showStyleEditor;

		private bool _notifSoundEnabled = true;

		private bool _notifVisualEnabled = true;

		private bool _errorSoundEnabled = true;

		private bool _errorVisualEnabled = true;

		private float _lastErrorNotifTime = -99f;

		private bool _prevToggleButton;

		private bool _prevKickTrigger;

		private const ImGuiWindowFlags ShellWindowFlags = ImGuiWindowFlags.NoScrollbar | ImGuiWindowFlags.NoScrollWithMouse | ImGuiWindowFlags.NoCollapse;

		private static readonly Vector2 ShellPivot = new Vector2(0.5f, 0.5f);

		private static readonly Vector2 ShellInitialSize = new Vector2(760f, 540f);

		private static readonly Vector2 ShellMinSize = new Vector2(600f, 400f);

		private static readonly Vector2 ShellMaxSize = new Vector2(1400f, 1000f);

		private static readonly Vector4 PageErrorColor = new Vector4(1f, 0.35f, 0.35f, 1f);

		private static readonly Vector4 FpsColorSmooth = new Vector4(0.42f, 0.9f, 0.52f, 1f);

		private static readonly Vector4 FpsColorDegraded = new Vector4(0.95f, 0.8f, 0.3f, 1f);

		private static readonly Vector4 FpsColorBad = new Vector4(0.96f, 0.42f, 0.38f, 1f);

		private static readonly Vector2 FpsPlotSize = new Vector2(260f, 60f);

		private static readonly Vector4 DangerIdle = new Vector4(0.55f, 0.1f, 0.1f, 1f);

		private static readonly Vector4 DangerHovered = new Vector4(0.7f, 0.15f, 0.15f, 1f);

		private static readonly Vector4 DangerPressed = new Vector4(0.85f, 0.2f, 0.2f, 1f);

		private TouchScreenKeyboard _softKeyboard;

		private string _softKeyboardOwner;

		private int ClampedParticleCount => Mathf.Clamp(_particleCount, 0, 120);

		private int SpiralArms => Mathf.Clamp(_spiralArmCount, 1, 8);

		private int SpiralPointsPerArm => Mathf.Clamp(_spiralParticlesPerArm, 10, 300);

		private int SpiralDrawCost => SpiralArms * SpiralPointsPerArm;

		private Transform LeftHand
		{
			get
			{
				if (!(_leftHandTransform != null))
				{
					return _runtimeLeftHand;
				}
				return _leftHandTransform;
			}
		}

		private Transform RightHandTip
		{
			get
			{
				if (!(_rightHandTip != null))
				{
					return _runtimeRightHand;
				}
				return _rightHandTip;
			}
		}

		private GameObject PlatformSource
		{
			get
			{
				if (_platformPrefab != null)
				{
					return _platformPrefab;
				}
				if (_generatedPlatformPrefab != null)
				{
					return _generatedPlatformPrefab;
				}
				GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Cube);
				gameObject.name = "[DevMenu] GeneratedPlatform";
				gameObject.transform.localScale = new Vector3(0.6f, 0.05f, 0.6f);
				MeshRenderer component = gameObject.GetComponent<MeshRenderer>();
				if (component != null)
				{
					component.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
					component.receiveShadows = false;
				}
				gameObject.SetActive(false);
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				_generatedPlatformPrefab = gameObject;
				return _generatedPlatformPrefab;
			}
		}

		public AudioClip[] SoundboardClips => soundboardClips;

		private void DrawParticleBackground()
		{
			Vector2 windowPos = ImGui.GetWindowPos();
			Vector2 windowSize = ImGui.GetWindowSize();
			int clampedParticleCount = ClampedParticleCount;
			if (!_particlesInitialized || _windowDotCount != clampedParticleCount)
			{
				SeedParticles(out _windowDots, out _windowDrift, clampedParticleCount, windowPos, windowSize);
				_windowDotCount = clampedParticleCount;
				_particlesInitialized = true;
			}
			StepAndDrawParticles(ImGui.GetWindowDrawList(), _windowDots, _windowDrift, _windowDotCount, windowPos, windowSize);
		}

		private void DrawParticlePreview(Vector2 regionPos, Vector2 regionSize, ImDrawListPtr drawList)
		{
			int clampedParticleCount = ClampedParticleCount;
			if (!_previewInitialized || _previewDotCount != clampedParticleCount)
			{
				SeedParticles(out _previewDots, out _previewDrift, clampedParticleCount, regionPos, regionSize);
				_previewDotCount = clampedParticleCount;
				_previewInitialized = true;
			}
			StepAndDrawParticles(drawList, _previewDots, _previewDrift, clampedParticleCount, regionPos, regionSize);
		}

		private void SeedParticles(out Vector2[] dots, out Vector2[] drift, int count, Vector2 origin, Vector2 extent)
		{
			dots = new Vector2[count];
			drift = new Vector2[count];
			for (int i = 0; i < count; i++)
			{
				dots[i] = new Vector2(origin.x + extent.x * (float)_dotRandom.NextDouble(), origin.y + extent.y * (float)_dotRandom.NextDouble());
				drift[i] = new Vector2(_dotRandom.Next(11) - 5, _dotRandom.Next(11) - 5);
			}
		}

		private static float WrapAxis(float value, float min, float max)
		{
			if (value < min)
			{
				return max;
			}
			if (value > max)
			{
				return min;
			}
			return value;
		}

		private static uint FadeByDistance(Vector4 colour, float distSq, float inverseRange)
		{
			colour.w *= 1f - Mathf.Sqrt(distSq) * inverseRange;
			return ImGui.GetColorU32(colour);
		}

		private void StepAndDrawParticles(ImDrawListPtr drawList, Vector2[] dots, Vector2[] drift, int count, Vector2 areaMin, Vector2 areaSize)
		{
			if (dots == null || drift == null || count < 1)
			{
				return;
			}
			ImGuiIOPtr iO = ImGui.GetIO();
			float deltaTime = iO.DeltaTime;
			float num = _particleInteractDist * _particleInteractDist;
			float num2 = _cursorInteractDist * _cursorInteractDist;
			float inverseRange = ((_particleInteractDist > 0f) ? (1f / _particleInteractDist) : 0f);
			float inverseRange2 = ((_cursorInteractDist > 0f) ? (1f / _cursorInteractDist) : 0f);
			Vector2 vector = areaMin + areaSize;
			Vector2 mousePos = iO.MousePos;
			uint colorU = ImGui.GetColorU32(_particleDotColor);
			for (int i = 0; i < count; i++)
			{
				Vector2 vector2 = dots[i] + drift[i] * deltaTime;
				vector2.x = WrapAxis(vector2.x, areaMin.x, vector.x);
				vector2.y = WrapAxis(vector2.y, areaMin.y, vector.y);
				dots[i] = vector2;
				for (int j = i + 1; j < count; j++)
				{
					Vector2 vector3 = dots[j];
					float sqrMagnitude = (vector3 - vector2).sqrMagnitude;
					if (sqrMagnitude < num)
					{
						drawList.AddLine(vector2, vector3, FadeByDistance(_particleLineColor, sqrMagnitude, inverseRange), _particleLineThickness);
					}
				}
				float sqrMagnitude2 = (mousePos - vector2).sqrMagnitude;
				if (sqrMagnitude2 < num2)
				{
					drawList.AddLine(mousePos, vector2, FadeByDistance(_cursorLineColor, sqrMagnitude2, inverseRange2), _particleLineThickness);
				}
				drawList.AddCircleFilled(vector2, _particleDotSize, colorU);
			}
		}

		private void DrawSpiralBackground()
		{
			_spiralTime += ImGui.GetIO().DeltaTime * _spiralSpeed;
			DrawSpiralToList(ImGui.GetWindowDrawList(), ImGui.GetWindowPos(), ImGui.GetWindowSize());
		}

		private void DrawSpiralPreview(Vector2 regionPos, Vector2 regionSize, ImDrawListPtr dl)
		{
			DrawSpiralToList(dl, regionPos, regionSize);
		}

		private void DrawSpiralToList(ImDrawListPtr dl, Vector2 areaPos, Vector2 areaSize)
		{
			Vector2 vector = areaPos + areaSize * 0.5f;
			float num = Mathf.Min(areaSize.x, areaSize.y) * 0.46f * _spiralRadiusScale;
			int spiralArms = SpiralArms;
			int spiralPointsPerArm = SpiralPointsPerArm;
			float num2 = (float)Math.PI * 2f / (float)spiralArms;
			for (int i = 0; i < spiralArms; i++)
			{
				float num3 = num2 * (float)i;
				for (int j = 0; j < spiralPointsPerArm; j++)
				{
					float num4 = (float)j / (float)(spiralPointsPerArm - 1);
					float f = num3 + _spiralTightness * num4 * (float)Math.PI * 2f + _spiralTime;
					float num5 = num * num4;
					Vector2 center = new Vector2(vector.x + Mathf.Cos(f) * num5, vector.y + Mathf.Sin(f) * num5);
					Vector4 col = Vector4.Lerp(_spiralInnerColor, _spiralOuterColor, num4);
					float radius = _spiralDotSize * Mathf.Lerp(2.2f, 0.6f, num4);
					dl.AddCircleFilled(center, radius, ImGui.GetColorU32(col));
				}
			}
		}

		private void EnsureSpyCamera()
		{
			if (_spyRenderTexture == null)
			{
				RenderTexture renderTexture = new RenderTexture(256, 192, 16, RenderTextureFormat.ARGB32);
				renderTexture.name = "[DevMenu] SpyRT";
				renderTexture.antiAliasing = 1;
				renderTexture.bindTextureMS = false;
				renderTexture.useMipMap = false;
				_spyRenderTexture = renderTexture;
			}
			if (!_spyRenderTexture.IsCreated())
			{
				_spyRenderTexture.Create();
			}
			if (!(_spyCamera != null))
			{
				GameObject gameObject = new GameObject("[DevMenu] SpyCamera");
				gameObject.hideFlags = HideFlags.HideAndDontSave;
				_spyCamera = gameObject.AddComponent<Camera>();
				_spyCamera.allowMSAA = false;
				_spyCamera.allowHDR = false;
				_spyCamera.targetTexture = _spyRenderTexture;
				_spyCamera.fieldOfView = 60f;
				_spyCamera.nearClipPlane = 0.1f;
				_spyCamera.farClipPlane = 200f;
				_spyCamera.stereoTargetEye = StereoTargetEyeMask.None;
				_spyCamera.enabled = false;
				if (Camera.main != null)
				{
					_spyCamera.cullingMask = Camera.main.cullingMask;
				}
			}
		}

		private void RenderSpy(MonkeDevNetworkingPlayer target)
		{
			if (!(target == null) && !(target.Head == null))
			{
				EnsureSpyCamera();
				if (!(_spyCamera == null))
				{
					Vector3 position = target.Head.position;
					Vector3 forward = target.Head.forward;
					_spyCamera.transform.position = position + forward * -1.5f + Vector3.up * 0.5f;
					_spyCamera.transform.LookAt(position);
					if (_lastSpyRenderFrame != Time.frameCount)
					{
						_lastSpyRenderFrame = Time.frameCount;
						_spyCamera.Render();
					}
				}
			}
		}

		private void DrawSpyImage(Vector2 size)
		{
			if (!(_spyRenderTexture == null) && _spyRenderTexture.IsCreated())
			{
				ImGui.Image(UImGuiUtility.GetTextureId(_spyRenderTexture), size);
			}
		}

		private void DestroySpyCamera()
		{
			if (!(_spyCamera == null))
			{
				UnityEngine.Object.Destroy(_spyCamera.gameObject);
				_spyCamera = null;
			}
		}

		private void ReleaseSpyResources()
		{
			DestroySpyCamera();
			_spectateTarget = null;
			if (!(_spyRenderTexture == null))
			{
				_spyRenderTexture.Release();
				UnityEngine.Object.Destroy(_spyRenderTexture);
				_spyRenderTexture = null;
			}
		}

		private void Handle_Esp()
		{
			if (!_boxEsp || !Can(DevMenuCap.PlayerEsp))
			{
				if (_espEntries.Count > 0)
				{
					ClearEsp();
				}
				return;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			Camera main = Camera.main;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
				if (!(monkeDevNetworkingPlayer == null) && !(monkeDevNetworkingPlayer.photonView == null) && !monkeDevNetworkingPlayer.photonView.IsMine && !(monkeDevNetworkingPlayer.Head == null))
				{
					int ownerActorNr = monkeDevNetworkingPlayer.photonView.OwnerActorNr;
					if (!_espEntries.ContainsKey(ownerActorNr))
					{
						_espEntries[ownerActorNr] = new BoxEspEntry(monkeDevNetworkingPlayer);
					}
				}
			}
			_espStale.Clear();
			foreach (KeyValuePair<int, BoxEspEntry> espEntry in _espEntries)
			{
				if (!espEntry.Value.Tick(main))
				{
					_espStale.Add(espEntry.Key);
				}
			}
			for (int j = 0; j < _espStale.Count; j++)
			{
				_espEntries[_espStale[j]].Destroy();
				_espEntries.Remove(_espStale[j]);
			}
		}

		private void ClearEsp()
		{
			foreach (BoxEspEntry value in _espEntries.Values)
			{
				value.Destroy();
			}
			_espEntries.Clear();
		}

		private void ResolveHandTransforms()
		{
			if (_handsResolved)
			{
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null))
			{
				_runtimeLeftHand = ((instance.leftHandTransform != null) ? instance.leftHandTransform : instance.leftHandFollower);
				_runtimeRightHand = ((instance.rightHandTransform != null) ? instance.rightHandTransform : instance.rightHandFollower);
				_handsResolved = _runtimeLeftHand != null && _runtimeRightHand != null;
				if (_handsResolved && _panelOnLeftHand)
				{
					ApplyPanelConfig();
				}
			}
		}

		private void Handle_DevMods()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null))
			{
				if (!Mathf.Approximately(_customSize, _previousCustomSize))
				{
					_previousCustomSize = _customSize;
					instance.targetScale = _customSize;
				}
				instance.jumpMultiplier = (_speedBoost ? _customJump : _previousJumpMultiplier);
			}
		}

		private void Handle_Flight()
		{
			if (!_joyStickFly)
			{
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null) && !(instance.playerRigidBody == null))
			{
				Vector2 leftJoystick = In.LeftJoystick;
				Transform transform = ((instance.headCollider != null) ? instance.headCollider.transform : instance.transform);
				Rigidbody playerRigidBody = instance.playerRigidBody;
				if (leftJoystick.sqrMagnitude > 0.01f)
				{
					Vector3 normalized = (transform.forward * leftJoystick.y + transform.right * leftJoystick.x).normalized;
					playerRigidBody.linearVelocity = normalized * _customFlySpeed;
				}
				else
				{
					playerRigidBody.linearVelocity = Vector3.zero;
				}
			}
		}

		private void Handle_GameMods()
		{
			if (!_originalsStored)
			{
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null)
			{
				return;
			}
			if (_modNoBodyCollider && instance.bodyCollider != null && instance.bodyCollider.gameObject.activeSelf)
			{
				instance.bodyCollider.gameObject.SetActive(false);
			}
			if (_modStickyHands || _modInstantStick)
			{
				instance.stickDepth = 0f;
			}
			Handle_Platforms();
			Handle_DoubleJump();
			Handle_AutoJump();
			Handle_SpinMode();
			Handle_BouncyMode();
		}

		private void Handle_DoubleJump()
		{
			if (!_modDoubleJump)
			{
				_hasDoubleJump = false;
				_prevDoubleJumpInput = false;
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null || instance.playerRigidBody == null)
			{
				return;
			}
			if (Physics.Raycast(instance.transform.position, Vector3.down, 0.5f))
			{
				_hasDoubleJump = true;
				return;
			}
			bool flag = In.LeftPrimaryButton && In.RightPrimaryButton;
			if (flag && !_prevDoubleJumpInput && _hasDoubleJump)
			{
				instance.playerRigidBody.AddForce(Vector3.up * 15f, ForceMode.VelocityChange);
				_hasDoubleJump = false;
				SendMenuHaptic(0.4f, 0.06f);
			}
			_prevDoubleJumpInput = flag;
		}

		private void Handle_AutoJump()
		{
			if (_modAutoJump)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (!(instance == null) && !(instance.playerRigidBody == null) && Physics.Raycast(instance.transform.position, Vector3.down, 0.3f))
				{
					instance.playerRigidBody.AddForce(Vector3.up * 8f, ForceMode.Impulse);
				}
			}
		}

		private void Handle_SpinMode()
		{
			if (_modSpinMode && GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.transform.Rotate(0f, Time.deltaTime * 360f, 0f);
			}
		}

		private void Handle_BouncyMode()
		{
			if (!_modBouncyMode)
			{
				return;
			}
			_bouncyTimer += Time.deltaTime;
			if (!(_bouncyTimer < 0.1f))
			{
				_bouncyTimer = 0f;
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (!(instance == null) && !(instance.playerRigidBody == null) && Physics.Raycast(instance.transform.position, Vector3.down, 0.5f))
				{
					instance.playerRigidBody.AddForce(Vector3.up * 15f, ForceMode.Impulse);
				}
			}
		}

		private void Handle_Platforms()
		{
			if (!_modPlatforms)
			{
				DisablePlatforms();
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null || instance.leftHandFollower == null || instance.rightHandFollower == null)
			{
				return;
			}
			GameObject platformSource = PlatformSource;
			if (!(platformSource == null))
			{
				if (_leftPlatform == null)
				{
					_leftPlatform = SpawnPlatform(platformSource, instance.leftHandFollower.position);
				}
				if (_rightPlatform == null)
				{
					_rightPlatform = SpawnPlatform(platformSource, instance.rightHandFollower.position);
				}
				UpdatePlatform(_leftPlatform, instance.leftHandFollower, In.LeftGrip > 0.5f);
				UpdatePlatform(_rightPlatform, instance.rightHandFollower, In.RightGrip > 0.5f);
			}
		}

		private static GameObject SpawnPlatform(GameObject source, Vector3 pos)
		{
			GameObject gameObject = UnityEngine.Object.Instantiate(source, pos, Quaternion.identity);
			gameObject.name = "[DevMenu] Platform";
			Rigidbody component = gameObject.GetComponent<Rigidbody>();
			if (component != null)
			{
				component.isKinematic = true;
				component.useGravity = false;
			}
			gameObject.SetActive(false);
			return gameObject;
		}

		private static void UpdatePlatform(GameObject platform, Transform hand, bool gripping)
		{
			if (platform == null)
			{
				return;
			}
			if (gripping)
			{
				if (!platform.activeSelf)
				{
					platform.SetActive(true);
				}
				platform.transform.position = hand.position;
				platform.transform.rotation = Quaternion.identity;
			}
			else if (platform.activeSelf)
			{
				platform.SetActive(false);
			}
		}

		private void DisablePlatforms()
		{
			if (_leftPlatform != null && _leftPlatform.activeSelf)
			{
				_leftPlatform.SetActive(false);
			}
			if (_rightPlatform != null && _rightPlatform.activeSelf)
			{
				_rightPlatform.SetActive(false);
			}
		}

		private void Handle_GhostMonkey()
		{
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.LocalPlayer : null);
			if (!(monkeDevNetworkingPlayer == null))
			{
				if (_modInvisible != _invisibleSent)
				{
					_invisibleSent = _modInvisible;
					MonkeDevNetworkingPlayer.SetLocalInvisible(_modInvisible);
				}
				monkeDevNetworkingPlayer.canTrack = !_modGhostMonkey || !In.LeftPrimaryButton;
			}
		}

		private void Handle_GrabPlayers()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!_modGrabPlayers || !Can(DevMenuCap.PlayerGrab) || instance == null || MonkeDevNetworkingManager.Manager == null || MonkeDevNetworkingManager.Manager.LocalPlayer == null)
			{
				ReleaseAllGrabs();
				return;
			}
			int ownerActorNr = MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.OwnerActorNr;
			HandleGrabHand(In.LeftGrip > 0.67f, isLeftHand: true, ownerActorNr, 2.5f, instance.leftHandFollower, ref _leftGrabbedPlayer, _rightGrabbedPlayer);
			HandleGrabHand(In.RightGrip > 0.67f, isLeftHand: false, ownerActorNr, 2.5f, instance.rightHandFollower, ref _rightGrabbedPlayer, _leftGrabbedPlayer);
		}

		private static void HandleGrabHand(bool gripping, bool isLeftHand, int myActorId, float range, Transform handFollower, ref MonkeDevNetworkingPlayer held, MonkeDevNetworkingPlayer otherHandHolds)
		{
			if (!gripping)
			{
				ReleaseGrab(ref held);
			}
			else
			{
				if (held != null || handFollower == null)
				{
					return;
				}
				Vector3 position = handFollower.position;
				List<MonkeDevNetworkingPlayer> players = MonkeDevNetworkingManager.Manager.Players;
				for (int i = 0; i < players.Count; i++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
					if (!(monkeDevNetworkingPlayer == null) && !(monkeDevNetworkingPlayer.photonView == null) && !monkeDevNetworkingPlayer.photonView.IsMine && !(monkeDevNetworkingPlayer == otherHandHolds) && !(monkeDevNetworkingPlayer.Head == null) && Vector3.Distance(monkeDevNetworkingPlayer.Head.position, position) <= range)
					{
						monkeDevNetworkingPlayer.GrabPlayer(myActorId, isLeftHand, byStaff: true);
						held = monkeDevNetworkingPlayer;
						break;
					}
				}
			}
		}

		private void ReleaseAllGrabs()
		{
			ReleaseGrab(ref _leftGrabbedPlayer);
			ReleaseGrab(ref _rightGrabbedPlayer);
		}

		private static void ReleaseGrab(ref MonkeDevNetworkingPlayer held)
		{
			if (!(held == null))
			{
				held.ReleasePlayer();
				held = null;
			}
		}

		private void BuildKickGunVisuals()
		{
			if (!(_kickGunLine != null))
			{
				Material unlitLineMaterial = GetUnlitLineMaterial();
				_kickGunLine = CreateOverlayLine("[DevMenu] KickGun_Line", unlitLineMaterial, 0.01f, 0.003f, 5, loop: false);
				_kickGunCircle = CreateOverlayLine("[DevMenu] KickGun_Circle", unlitLineMaterial, 0.007f, 0.007f, KickReticlePoints, loop: true);
			}
		}

		private static LineRenderer CreateOverlayLine(string name, Material mat, float startWidth, float endWidth, int points, bool loop)
		{
			GameObject gameObject = new GameObject(name);
			UnityEngine.Object.DontDestroyOnLoad(gameObject);
			LineRenderer lineRenderer = gameObject.AddComponent<LineRenderer>();
			lineRenderer.useWorldSpace = true;
			lineRenderer.loop = loop;
			lineRenderer.positionCount = points;
			lineRenderer.startWidth = startWidth;
			lineRenderer.endWidth = endWidth;
			lineRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			lineRenderer.receiveShadows = false;
			lineRenderer.sharedMaterial = mat;
			lineRenderer.enabled = false;
			return lineRenderer;
		}

		private void DestroyKickGunVisuals()
		{
			if (_kickGunLine != null)
			{
				UnityEngine.Object.Destroy(_kickGunLine.gameObject);
				_kickGunLine = null;
			}
			if (_kickGunCircle != null)
			{
				UnityEngine.Object.Destroy(_kickGunCircle.gameObject);
				_kickGunCircle = null;
			}
		}

		private void HandleKickGun()
		{
			if (!_kickGunEnabled || !Can(DevMenuCap.PlayerKick))
			{
				StowKickGun();
				return;
			}
			Transform rightHandTip = RightHandTip;
			if (!(rightHandTip == null))
			{
				BuildKickGunVisuals();
				_kickGunLine.enabled = true;
				_kickJiggleTime += Time.deltaTime;
				Vector3 position = rightHandTip.position;
				Vector3 forward = rightHandTip.forward;
				Vector3 aim;
				MonkeDevNetworkingPlayer assisted = FindKickAssistTarget(position, forward, out aim);
				Vector3 vector = ResolveKickEndpoint(position, aim, assisted);
				bool locked = _kickGunTarget != null;
				BeamBasis(position, vector, out var side, out var lift);
				DrawKickBeam(position, vector, side, lift, locked);
				DrawKickReticle(vector, side, lift, locked);
				TryFireKick();
			}
		}

		private void StowKickGun()
		{
			if (_kickGunLine != null)
			{
				_kickGunLine.enabled = false;
			}
			if (_kickGunCircle != null)
			{
				_kickGunCircle.enabled = false;
			}
			_kickGunTarget = null;
		}

		private static bool IsKickable(MonkeDevNetworkingPlayer candidate)
		{
			if (candidate != null && candidate.photonView != null && !candidate.photonView.IsMine)
			{
				return candidate.Head != null;
			}
			return false;
		}

		private static MonkeDevNetworkingPlayer FindKickAssistTarget(Vector3 origin, Vector3 forward, out Vector3 aim)
		{
			aim = forward;
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return null;
			}
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = null;
			float num = KickAssistCone;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer2 = players[i];
				if (IsKickable(monkeDevNetworkingPlayer2))
				{
					Vector3 normalized = (monkeDevNetworkingPlayer2.Head.position - origin).normalized;
					float num2 = Vector3.Angle(forward, normalized);
					if (num2 < num)
					{
						num = num2;
						monkeDevNetworkingPlayer = monkeDevNetworkingPlayer2;
					}
				}
			}
			if (monkeDevNetworkingPlayer == null)
			{
				return null;
			}
			float t = Mathf.Lerp(0.85f, 0.45f, num / KickAssistCone);
			Vector3 normalized2 = (monkeDevNetworkingPlayer.Head.position - origin).normalized;
			aim = Vector3.Slerp(forward, normalized2, t).normalized;
			return monkeDevNetworkingPlayer;
		}

		private Vector3 ResolveKickEndpoint(Vector3 origin, Vector3 aim, MonkeDevNetworkingPlayer assisted)
		{
			_kickGunTarget = null;
			if (assisted != null)
			{
				Vector3 position = assisted.Head.position;
				Vector3 normalized = (position - origin).normalized;
				if (Vector3.Angle(aim, normalized) < KickLockCone)
				{
					_kickGunTarget = assisted;
					return position;
				}
			}
			Vector3 result = origin + aim * KickRange;
			if (Physics.Raycast(origin, aim, out var hitInfo, KickRange))
			{
				MonkeDevNetworkingPlayer componentInParent = hitInfo.collider.GetComponentInParent<MonkeDevNetworkingPlayer>();
				if (componentInParent != null && componentInParent.photonView != null && !componentInParent.photonView.IsMine)
				{
					_kickGunTarget = componentInParent;
					result = hitInfo.point;
				}
			}
			return result;
		}

		private static void BeamBasis(Vector3 from, Vector3 to, out Vector3 side, out Vector3 lift)
		{
			Vector3 normalized = (to - from).normalized;
			side = Vector3.Cross(normalized, Vector3.up).normalized;
			if (side.sqrMagnitude < 0.01f)
			{
				side = Vector3.Cross(normalized, Vector3.right).normalized;
			}
			lift = Vector3.Cross(normalized, side).normalized;
		}

		private static float Wave(float t, float phase, float freq, float speed, float shift, float amp)
		{
			return Mathf.Sin(t * freq + phase * speed + shift) * amp;
		}

		private void DrawKickBeam(Vector3 origin, Vector3 end, Vector3 side, Vector3 lift, bool locked)
		{
			float freq = (locked ? 14f : 9f);
			float freq2 = (locked ? 23f : 15f);
			float freq3 = (locked ? 38f : 22f);
			float num = (locked ? 0.055f : 0.075f);
			float num2 = (locked ? 0.03f : 0.045f);
			float amp = (locked ? 0.015f : 0.022f);
			float kickJiggleTime = _kickJiggleTime;
			_kickGunLine.positionCount = KickBeamSegments + 1;
			for (int i = 0; i <= KickBeamSegments; i++)
			{
				float num3 = (float)i / (float)KickBeamSegments;
				float num4 = num3 * (1f - num3) * 4f;
				float num5 = Wave(num3, kickJiggleTime, freq, 4.1f, 0f, num) + Wave(num3, kickJiggleTime, freq2, 6.7f, 1.2f, num2) + Wave(num3, kickJiggleTime, freq3, 11.3f, 2.5f, amp);
				float num6 = Wave(num3, kickJiggleTime, freq, 3.3f, 0.8f, num) + Wave(num3, kickJiggleTime, freq2, 5.9f, 2.1f, num2) * 0.7f + Wave(num3, kickJiggleTime, freq3, 9.7f, 3.8f, amp);
				Vector3 position = Vector3.Lerp(origin, end, num3) + side * (num5 * num4) + lift * (num6 * num4);
				_kickGunLine.SetPosition(i, position);
			}
			_kickGunLine.startColor = (locked ? BeamLockedStart : BeamIdleStart);
			_kickGunLine.endColor = (locked ? BeamLockedEnd : BeamIdleEnd);
		}

		private void DrawKickReticle(Vector3 centre, Vector3 side, Vector3 lift, bool locked)
		{
			if (_kickGunCircle == null)
			{
				return;
			}
			_kickGunCircle.enabled = locked;
			if (locked)
			{
				float num = Mathf.Sin(_kickJiggleTime * 6f) * 0.008f + 0.06f;
				float num2 = _kickJiggleTime * 1.5f;
				for (int i = 0; i < KickReticlePoints; i++)
				{
					float f = num2 + (float)i / (float)KickReticlePoints * (float)Math.PI * 2f;
					Vector3 position = centre + side * Mathf.Cos(f) * num + lift * Mathf.Sin(f) * num;
					_kickGunCircle.SetPosition(i, position);
				}
				_kickGunCircle.startColor = (_kickGunCircle.endColor = ReticleColor);
			}
		}

		private void TryFireKick()
		{
			bool flag = In.RightTrigger > 0.7f;
			bool flag2 = flag && !_prevKickTrigger;
			_prevKickTrigger = flag;
			if (!flag2 || _kickGunTarget == null)
			{
				return;
			}
			var photonView = _kickGunTarget.photonView;
			var owner = photonView.Owner;
			string content = ((owner != null && !string.IsNullOrEmpty(owner.NickName)) ? owner.NickName : "Player");
			photonView.RPC("KickPlayer", owner);
			ImGuiNotify.Insert(ImGuiNotify.ToastType.Error, "Kicked", content, 3f);
			SendMenuHaptic(0.6f, 0.08f);
			if (_kickGunCircle != null)
			{
				_kickGunCircle.enabled = false;
			}
		}

		private static Material GetUnlitLineMaterial()
		{
			if (_lineMat != null)
			{
				return _lineMat;
			}
			Shader shader = Shader.Find("Hidden/Internal-Colored") ?? Shader.Find("Sprites/Default");
			if (shader == null)
			{
				Debug.LogWarning("[DevMenu] No unlit shader found for line rendering.");
				return null;
			}
			_lineMat = new Material(shader)
			{
				hideFlags = HideFlags.HideAndDontSave
			};
			if (_lineMat.HasProperty("_ZTest"))
			{
				_lineMat.SetFloat("_ZTest", 8f);
			}
			if (_lineMat.HasProperty("_ZWrite"))
			{
				_lineMat.SetFloat("_ZWrite", 0f);
			}
			if (_lineMat.HasProperty("_Cull"))
			{
				_lineMat.SetFloat("_Cull", 0f);
			}
			_lineMat.renderQueue = 5000;
			return _lineMat;
		}

		private void StoreOriginalValues()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null))
			{
				_originalsStored = true;
				_origMaxArmLength = instance.maxArmLength;
				_origVelocityLimit = instance.velocityLimit;
				_origSlideVelocityLimit = instance.slideVelocityLimit;
				_origMaxJumpSpeed = instance.maxJumpSpeed;
				_origIceThreshold = instance.iceThreshold;
				_origSlideFactor = instance.defaultSlideFactor;
				_origSlideControl = instance.slideControl;
				_origFrictionConstant = instance.frictionConstant;
				_origStickDepth = instance.stickDepth;
				_origBodyColliderState = instance.bodyCollider != null && instance.bodyCollider.gameObject.activeSelf;
				_origHandOffset = instance.rightHandOffset;
			}
		}

		private void ApplyLongArms(bool on)
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null))
			{
				Vector3 vector = (on ? LongArmsHandOffset : _origHandOffset);
				instance.rightHandOffset = vector;
				instance.leftHandOffset = vector;
			}
		}

		private void ApplyIceThreshold()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null) && _originalsStored)
			{
				instance.iceThreshold = (_modNoSlip ? 0f : (_modSlippery ? 999f : _origIceThreshold));
			}
		}

		private void ApplyStickDepth()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance == null) && _originalsStored)
			{
				instance.stickDepth = ((_modStickyHands || _modInstantStick) ? 0f : _origStickDepth);
			}
		}

		private void ApplyDevGravityHold()
		{
			if (_joyStickFly || _modAirSwim)
			{
				RigHold.Take(this, RigHold.What.Gravity);
			}
			else
			{
				RigHold.Give(this, RigHold.What.Gravity);
			}
		}

		private void ApplyDevMovementHold()
		{
			if (_modDisableMovement)
			{
				RigHold.Take(this, RigHold.What.Movement);
			}
			else
			{
				RigHold.Give(this, RigHold.What.Movement);
			}
		}

		private void ApplyGravity(int keep)
		{
			if (keep != 0)
			{
				_useCustomGravity = false;
			}
			if (keep != 1)
			{
				_modMoonGravity = false;
			}
			if (keep != 2)
			{
				_modLowGravity = false;
			}
			if (keep != 3)
			{
				_modFlipGravity = false;
			}
			if (_useCustomGravity)
			{
				Physics.gravity = new Vector3(0f, 0f - _customGravity, 0f);
			}
			else if (_modMoonGravity)
			{
				Physics.gravity = new Vector3(0f, -1.62f, 0f);
			}
			else if (_modLowGravity)
			{
				Physics.gravity = new Vector3(0f, -4.9f, 0f);
			}
			else if (_modFlipGravity)
			{
				Physics.gravity = new Vector3(0f, 9.81f, 0f);
			}
			else
			{
				Physics.gravity = _originalGravity;
			}
		}

		private void RestoreAllMods()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			RigHold.Give(this);
			if (_acousticsOff)
			{
				_acousticsOff = false;
				MetaXRAcousticNativeInterface.Interface.SetAcousticModel(MetaXRAcousticSettings.Instance.AcousticModel);
			}
			LethalApeR.Audio.AcousticMapSelector.ForceLive = false;
			if (instance != null && _originalsStored)
			{
				if (_modLongArms)
				{
					ApplyLongArms(on: false);
				}
				instance.debugMovement = false;
				instance.maxArmLength = _origMaxArmLength;
				instance.velocityLimit = _origVelocityLimit;
				instance.slideVelocityLimit = _origSlideVelocityLimit;
				instance.maxJumpSpeed = _origMaxJumpSpeed;
				instance.iceThreshold = _origIceThreshold;
				instance.defaultSlideFactor = _origSlideFactor;
				instance.slideControl = _origSlideControl;
				instance.frictionConstant = _origFrictionConstant;
				instance.stickDepth = _origStickDepth;
				if (instance.bodyCollider != null)
				{
					instance.bodyCollider.gameObject.SetActive(_origBodyColliderState);
				}
				if (!RigHold.Anyone(RigHold.What.Movement))
				{
					instance.disableMovement = false;
				}
				if (instance.playerRigidBody != null && !RigHold.Anyone(RigHold.What.Gravity))
				{
					instance.playerRigidBody.useGravity = true;
				}
			}
			Physics.gravity = _originalGravity;
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.LocalPlayer : null);
			if (monkeDevNetworkingPlayer != null)
			{
				monkeDevNetworkingPlayer.canTrack = true;
			}
			if (_invisibleSent)
			{
				_invisibleSent = false;
				MonkeDevNetworkingPlayer.SetLocalInvisible(invisible: false);
			}
			ReleaseAllGrabs();
			DisablePlatforms();
		}

		private void ResetAllMods()
		{
			_modLongArms = false;
			_modInfiniteArms = false;
			_modNoSlip = false;
			_modSlippery = false;
			_modIronGrip = false;
			_modStickyHands = false;
			_modInstantStick = false;
			_modNoFriction = false;
			_modSuperJump = false;
			_modSpeedHack = false;
			_modDoubleJump = false;
			_modAutoJump = false;
			_modMoonGravity = false;
			_modLowGravity = false;
			_modFlipGravity = false;
			_modAirSwim = false;
			_modInvisible = false;
			_modGhostMonkey = false;
			_modNoBodyCollider = false;
			_modSpinMode = false;
			_modBouncyMode = false;
			_modPlatforms = false;
			_modDisableMovement = false;
			_modDebugMovement = false;
			_modGrabPlayers = false;
			_joyStickFly = false;
			_speedBoost = false;
			_useCustomGravity = false;
			_customSize = 1f;
			RestoreAllMods();
			ImGuiNotify.Insert(ImGuiNotify.ToastType.Info, "Mods Reset", "All values restored.", 2.5f);
		}

		private static void BeginPageScroll(string id)
		{
			ImGui.BeginChild(id, ImGui.GetContentRegionAvail(), ImGuiChildFlags.None, ImGuiWindowFlags.None);
		}

		private static void EndPageScroll()
		{
			ImGui.EndChild();
		}

		private bool RequirePlayer()
		{
			if (GorillaLocomotion.Player.Instance != null && _originalsStored)
			{
				return true;
			}
			ImGui.TextColored(new Vector4(1f, 0.7f, 0.3f, 1f), "Waiting for the local player to spawn…");
			return false;
		}

		private void DrawPage_Movement()
		{
			PageHeader("Movement", "Flight, jump tuning, grip and scale.");
			BeginPageScroll("##scroll_movement");
			if (RequirePlayer())
			{
				if (ImGui.CollapsingHeader("Flight", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					if (ModToggle("Joystick Fly", ref _joyStickFly, "Left stick flies you in the direction you're looking. Velocity is written in FixedUpdate so Player.cs can't overwrite it."))
					{
						ApplyDevGravityHold();
					}
					SliderFloat("Speed##fly", ref _customFlySpeed, 1f, 20f, "%.1f m/s");
					ImGui.Unindent();
				}
				ImGui.Spacing();
				if (ImGui.CollapsingHeader("Jump / Velocity", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					ModToggle("Speed Boost", ref _speedBoost, "Applies the multiplier below to your jump/launch power.");
					if (_speedBoost)
					{
						SliderFloat("Boost Multiplier##mv", ref _customJump, 1f, 5f, "%.2fx");
					}
					if (ModToggle("Super Jump", ref _modSuperJump, "Raises maxJumpSpeed to 50 — very large launches."))
					{
						GorillaLocomotion.Player.Instance.maxJumpSpeed = (_modSuperJump ? 50f : _origMaxJumpSpeed);
					}
					if (ModToggle("Speed Hack", ref _modSpeedHack, "Removes the velocity cap (velocityLimit + slideVelocityLimit = 999)."))
					{
						if (_modSpeedHack)
						{
							GorillaLocomotion.Player.Instance.velocityLimit = 999f;
							GorillaLocomotion.Player.Instance.slideVelocityLimit = 999f;
						}
						else
						{
							GorillaLocomotion.Player.Instance.velocityLimit = _origVelocityLimit;
							GorillaLocomotion.Player.Instance.slideVelocityLimit = _origSlideVelocityLimit;
						}
					}
					ModToggle("Double Jump", ref _modDoubleJump, "Press A and X together while airborne for a second jump. One per grounding.");
					ModToggle("Auto Jump", ref _modAutoJump, "Launches you upward the moment you touch the ground.");
					ImGui.Unindent();
				}
				ImGui.Spacing();
				if (ImGui.CollapsingHeader("Arms / Grip", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					if (ModToggle("Long Arms", ref _modLongArms, "Pushes the hand offset 0.25 m forward."))
					{
						ApplyLongArms(_modLongArms);
					}
					if (ModToggle("Infinite Arms", ref _modInfiniteArms, "maxArmLength = 999. Grab anything, anywhere."))
					{
						GorillaLocomotion.Player.Instance.maxArmLength = (_modInfiniteArms ? 999f : _origMaxArmLength);
					}
					ImGui.Spacing();
					ImGui.TextDisabled("Surface grip — No Slip and Slippery are opposites.");
					if (ModToggle("No Slip", ref _modNoSlip, "iceThreshold = 0. Nothing slides."))
					{
						if (_modNoSlip)
						{
							_modSlippery = false;
						}
						ApplyIceThreshold();
					}
					if (ModToggle("Slippery Mode", ref _modSlippery, "iceThreshold = 999. Every surface behaves like ice."))
					{
						if (_modSlippery)
						{
							_modNoSlip = false;
						}
						ApplyIceThreshold();
					}
					if (ModToggle("Iron Grip", ref _modIronGrip, "Zero slide factor and slide control — hands lock exactly where they land."))
					{
						if (_modIronGrip)
						{
							GorillaLocomotion.Player.Instance.defaultSlideFactor = 0f;
							GorillaLocomotion.Player.Instance.slideControl = 0f;
						}
						else
						{
							GorillaLocomotion.Player.Instance.defaultSlideFactor = _origSlideFactor;
							GorillaLocomotion.Player.Instance.slideControl = _origSlideControl;
						}
					}
					ImGui.Spacing();
					ImGui.TextDisabled("Sticky Hands and Instant Stick both drive stickDepth to 0.");
					if (ModToggle("Sticky Hands", ref _modStickyHands, "stickDepth = 0, re-applied every frame so locomotion can't undo it."))
					{
						if (_modStickyHands)
						{
							_modInstantStick = false;
						}
						ApplyStickDepth();
					}
					if (ModToggle("Instant Stick", ref _modInstantStick, "Same underlying value as Sticky Hands, applied once instead of every frame."))
					{
						if (_modInstantStick)
						{
							_modStickyHands = false;
						}
						ApplyStickDepth();
					}
					if (ModToggle("No Friction", ref _modNoFriction, "frictionConstant = 0."))
					{
						GorillaLocomotion.Player.Instance.frictionConstant = (_modNoFriction ? 0f : _origFrictionConstant);
					}
					ImGui.Unindent();
				}
				ImGui.Spacing();
				if (ImGui.CollapsingHeader("Scale", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					SliderFloat("Player Size", ref _customSize, 0.1f, 5f, "%.3f");
					Tip("Also scales the menu's distance from your face so it stays readable.");
					Btn("Reset Size", FullWidth(), delegate
					{
						_customSize = 1f;
					});
					ImGui.Unindent();
				}
			}
			EndPageScroll();
		}

		private void DrawPage_World()
		{
			PageHeader("World", "Gravity, platforms and player state.");
			BeginPageScroll("##scroll_world");
			if (RequirePlayer())
			{
				if (ImGui.CollapsingHeader("Gravity", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					ImGui.TextColored(new Vector4(1f, 0.75f, 0.35f, 1f), "Physics.gravity is global — this moves every rigidbody in the scene,");
					ImGui.TextColored(new Vector4(1f, 0.75f, 0.35f, 1f), "not just you. Only one gravity mod can be active at a time.");
					ImGui.Spacing();
					if (ModToggle("Custom Gravity", ref _useCustomGravity, "Use the slider below instead of one of the presets."))
					{
						ApplyGravity(0);
					}
					if (SliderFloat("Gravity##grav", ref _customGravity, -30f, 30f, "%.1f m/s²") && _useCustomGravity)
					{
						ApplyGravity(0);
					}
					ImGui.Spacing();
					if (ModToggle("Moon Gravity", ref _modMoonGravity, "-1.62 m/s²."))
					{
						ApplyGravity(1);
					}
					if (ModToggle("Low Gravity", ref _modLowGravity, "-4.9 m/s²."))
					{
						ApplyGravity(2);
					}
					if (ModToggle("Flip Gravity", ref _modFlipGravity, "+9.81 m/s² — everything falls up."))
					{
						ApplyGravity(3);
					}
					ImGui.Spacing();
					if (ModToggle("Air Swim", ref _modAirSwim, "Turns off gravity on your rigidbody only — everyone else is unaffected."))
					{
						ApplyDevGravityHold();
					}
					ImGui.Spacing();
					Btn("Reset Gravity", FullWidth(24f), delegate
					{
						_modFlipGravity = false;
						_modMoonGravity = false;
						_modLowGravity = false;
						_useCustomGravity = false;
						ApplyGravity(-1);
					});
					ImGui.Unindent();
				}
				ImGui.Spacing();
				if (ImGui.CollapsingHeader("Platforms", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					ModToggle("Platforms (grip to place)", ref _modPlatforms, "Hold either grip to hold a solid slab under that hand.");
					if (!_modPlatforms)
					{
						DisablePlatforms();
					}
					if (_platformPrefab == null)
					{
						ImGui.TextDisabled("No prefab assigned — using a generated slab.");
					}
					ImGui.Unindent();
				}
				ImGui.Spacing();
				if (ImGui.CollapsingHeader("Fun", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					ModToggle("Spin Mode", ref _modSpinMode, "Rotates you at 360°/s. This is a forced camera rotation — it will make most people motion sick within seconds.");
					ModToggle("Bouncy Mode", ref _modBouncyMode, "Launches you upward every time you touch the ground.");
					ImGui.Unindent();
				}
				ImGui.Spacing();
				if (ImGui.CollapsingHeader("Player State", ImGuiTreeNodeFlags.DefaultOpen))
				{
					ImGui.Indent();
					if (ModToggle("Disable Movement", ref _modDisableMovement, "Locks locomotion — you stay exactly where you are."))
					{
						ApplyDevMovementHold();
					}
					if (ModToggle("Debug Movement", ref _modDebugMovement, "Sets Player.debugMovement."))
					{
						GorillaLocomotion.Player.Instance.debugMovement = _modDebugMovement;
					}
					ImGui.Spacing();
					DangerBtn("Reset All Mods", FullWidth(28f), ResetAllMods);
					Tip("Turns every mod off and restores the original locomotion values.");
					ImGui.Unindent();
				}
			}
			EndPageScroll();
		}

		private void DrawPage_Stealth()
		{
			PageHeader("Stealth", "Visibility to other players.");
			BeginPageScroll("##scroll_stealth");
			if (!RequirePlayer())
			{
				EndPageScroll();
				return;
			}
			if (ImGui.CollapsingHeader("Visibility", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				ModToggle("Invisible", ref _modInvisible, "Stops broadcasting your transform — you appear frozen in place to everyone else.");
				ModToggle("Ghost Monkey", ref _modGhostMonkey, "Hold LEFT X to stop broadcasting. Release to reappear.");
				if (_modGhostMonkey)
				{
					ImGui.TextDisabled("Hold LEFT X to vanish.");
				}
				if (ModToggle("No Body Collider", ref _modNoBodyCollider, "Disables your body capsule so you pass through players and props. Player.BodyCollider() re-enables it every frame, so this is re-applied every frame."))
				{
					CapsuleCollider bodyCollider = GorillaLocomotion.Player.Instance.bodyCollider;
					if (bodyCollider != null)
					{
						bodyCollider.gameObject.SetActive(!_modNoBodyCollider && _origBodyColliderState);
					}
				}
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (!Can(DevMenuCap.PlayerEsp))
			{
				ImGui.TextDisabled("ESP is not available at your tier.");
			}
			else if (ImGui.CollapsingHeader("ESP", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				bool boxEsp = _boxEsp;
				ModToggle("Box ESP", ref _boxEsp, "Red wireframe box + name / position / user id above every remote player, drawn on top of geometry.");
				if (boxEsp && !_boxEsp)
				{
					ClearEsp();
				}
				if (_boxEsp)
				{
					ImGui.TextColored(new Vector4(1f, 0.45f, 0.45f, 1f), string.Format("Tracking {0} player(s) — 2 extra renderers each.", _espEntries.Count));
				}
				else
				{
					ImGui.TextDisabled("Off.");
				}
				ImGui.Unindent();
			}
			EndPageScroll();
		}

		private void DrawPage_Players()
		{
			PageHeader("Players", Photon.Pun.PhotonNetwork.InRoom ? string.Format("{0} in room — {1}", Photon.Pun.PhotonNetwork.CurrentRoom.PlayerCount, Photon.Pun.PhotonNetwork.CurrentRoom.Name) : "Not connected to a room.");
			BeginPageScroll("##scroll_players");
			if (Photon.Pun.PhotonNetwork.InRoom && MonkeDevNetworkingManager.IdentityHidden)
			{
				ImGui.TextColored(new Vector4(1f, 0.35f, 0.35f, 1f), "This room does not publish user ids — the host is running a patched client.");
				ImGui.Spacing();
			}
			if (ImGui.CollapsingHeader("You"))
			{
				ImGui.Indent();
				ImGui.TextDisabled("Username");
				ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x - 56f);
				ImGui.InputText("##localname", ref _localUsernameBuffer, 64u);
				SoftKeyboard("##localname", ref _localUsernameBuffer, "Username");
				RegisterHover();
				ImGui.SameLine();
				Btn("Apply##name", new Vector2(76f, 0f), delegate
				{
					if (!string.IsNullOrWhiteSpace(_localUsernameBuffer))
					{
						MonkeDevNetworkingManager.SetUsername(_localUsernameBuffer.Trim());
						ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "Username Set", _localUsernameBuffer.Trim(), 2.5f);
					}
				});
				Player localPlayer = Photon.Pun.PhotonNetwork.LocalPlayer;
				ImGui.TextDisabled((localPlayer != null && !string.IsNullOrEmpty(localPlayer.UserId)) ? ("User: " + localPlayer.UserId) : "User: — (not connected)");
				if (GorillaLocomotion.Player.Instance != null)
				{
					GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
					Vector3 position = instance.transform.position;
					float num = 0f;
					if (instance.playerRigidBody != null)
					{
						num = instance.playerRigidBody.linearVelocity.magnitude;
					}
					ImGui.TextDisabled(string.Format("Pos {0:F1}  {1:F1}  {2:F1}    {3:F1} m/s", position.x, position.y, position.z, num));
					ImGui.TextDisabled(string.Format("Scale {0:F2}    Movement {1}", instance.targetScale, instance.disableMovement ? "OFF" : "ON"));
				}
				ImGui.Unindent();
				ImGui.Spacing();
			}
			if (Can(DevMenuCap.SectionRoom) && ImGui.CollapsingHeader("Room"))
			{
				ImGui.Indent();
				DrawRoomSection();
				ImGui.Unindent();
				ImGui.Spacing();
			}
			if (Can(DevMenuCap.PlayerGrab))
			{
				ModToggle("Grab Players (grip)", ref _modGrabPlayers, "Squeeze a grip near a player to carry them with that hand.");
				if (_modGrabPlayers)
				{
					if (_leftGrabbedPlayer != null)
					{
						ImGui.TextColored(new Vector4(0.4f, 1f, 0.4f, 1f), "L: " + SafeName(_leftGrabbedPlayer));
					}
					if (_rightGrabbedPlayer != null)
					{
						ImGui.TextColored(new Vector4(0.4f, 1f, 0.4f, 1f), "R: " + SafeName(_rightGrabbedPlayer));
					}
					if (_leftGrabbedPlayer != null || _rightGrabbedPlayer != null)
					{
						Btn("Release All##grab", FullWidth(24f), ReleaseAllGrabs);
					}
				}
			}
			if (Can(DevMenuCap.PlayerKick))
			{
				ImGui.Spacing();
				bool kickGunEnabled = _kickGunEnabled;
				if (kickGunEnabled)
				{
					ImGui.PushStyleColor(ImGuiCol.Button, new Vector4(0.6f, 0.1f, 0.1f, 1f));
				}
				if (Btn((!_kickGunEnabled) ? "Kick Gun  [OFF]" : ((_kickGunTarget != null) ? "Kick Gun  [LOCKED ON]" : "Kick Gun  [ON]"), FullWidth(28f)))
				{
					_kickGunEnabled = !_kickGunEnabled;
				}
				if (kickGunEnabled)
				{
					ImGui.PopStyleColor();
				}
				if (_kickGunEnabled)
				{
					ImGui.TextDisabled((RightHandTip != null) ? "Point at a player, pull the right trigger." : "Waiting for the right hand transform…");
				}
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			if (!Photon.Pun.PhotonNetwork.InRoom)
			{
				ImGui.TextDisabled("Not in a room.");
				EndPageScroll();
				return;
			}
			ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
			ImGui.InputTextWithHint("##playersearch", "Search players…", ref _playerSearch, 64u);
			RegisterHover();
			if (_spectateTarget != null && Can(DevMenuCap.PlayerSpectate))
			{
				if (_spectateTarget.Head == null)
				{
					_spectateTarget = null;
				}
				else
				{
					RenderSpy(_spectateTarget);
					ImGui.Spacing();
					DrawSpyImage(new Vector2(224f, 168f));
					ImGui.SameLine();
					ImGui.BeginGroup();
					ImGui.TextColored(_colAccent, "Spectating");
					ImGui.TextWrapped(SafeName(_spectateTarget));
					if (Btn("Stop##spy", new Vector2(80f, 24f)))
					{
						_spectateTarget = null;
						DestroySpyCamera();
					}
					ImGui.EndGroup();
				}
			}
			ImGui.Spacing();
			Dictionary<int, MonkeDevNetworkingPlayer> dictionary = BuildRemoteLookup();
			string value = (_playerSearch ?? "").Trim().ToLowerInvariant();
			int num2 = 0;
			Player[] playerList = Photon.Pun.PhotonNetwork.PlayerList;
			foreach (Player player in playerList)
			{
				if (player.IsLocal)
				{
					continue;
				}
				string text = player.NickName;
				if (string.IsNullOrEmpty(text))
				{
					text = string.Format("Actor {0}", player.ActorNumber);
				}
				if (value.Length <= 0 || text.ToLowerInvariant().IndexOf(value, StringComparison.Ordinal) >= 0)
				{
					num2++;
					dictionary.TryGetValue(player.ActorNumber, out var value2);
					ImGui.PushID(player.ActorNumber);
					DrawPlayerRow(player, value2, text);
					ImGui.PopID();
				}
			}
			int num3 = Photon.Pun.PhotonNetwork.PlayerList.Length;
			if (num3 < 2 || num2 == 0)
			{
				ImGui.TextDisabled((num3 < 2) ? "No other players in the room." : "No players match your search.");
			}
			EndPageScroll();
		}

		private void DrawPlayerRow(Player photonPlayer, MonkeDevNetworkingPlayer np, string name)
		{
			bool flag = _selectedActorNumber == photonPlayer.ActorNumber && _isManagingPlayer;
			string text = (photonPlayer.IsMasterClient ? "   (host)" : "");
			if (Btn(name + "   #" + ShortUserId(photonPlayer) + text, FullWidth(24f)))
			{
				_selectedActorNumber = photonPlayer.ActorNumber;
				_isManagingPlayer = !flag;
			}
			if (!flag && _spectateTarget == null && np != null && np.Head != null && Can(DevMenuCap.PlayerSpectate) && ImGui.IsItemHovered())
			{
				RenderSpy(np);
				ImGui.BeginTooltip();
				DrawSpyImage(new Vector2(224f, 168f));
				ImGui.EndTooltip();
			}
			else if (ImGui.IsItemHovered())
			{
				ImGui.BeginTooltip();
				ImGui.Text(name);
				ImGui.TextDisabled(string.Format("Actor {0}", photonPlayer.ActorNumber));
				if (!string.IsNullOrEmpty(photonPlayer.UserId))
				{
					ImGui.TextDisabled(photonPlayer.UserId);
				}
				ImGui.EndTooltip();
			}
			bool flag2 = np != null;
			if (!flag2)
			{
				ImGui.BeginDisabled();
			}
			float x = ImGui.GetStyle().ItemSpacing.x;
			int num = (Can(DevMenuCap.PlayerSpectate) ? 5 : 4);
			Vector2 size = new Vector2((ImGui.GetContentRegionAvail().x - x * (float)(num - 1)) / (float)num, 22f);
			if (Btn(LocalMutes.IsMuted(photonPlayer.UserId) ? "Unmute" : "Mute", size))
			{
				// RE: unsure - the compiler dropped the unused actorNumber argument; photonPlayer.ActorNumber assumed
				ToggleMute(np, photonPlayer.ActorNumber);
			}
			ImGui.SameLine();
			if (Btn("Goto", size))
			{
				TeleportSelfTo(np);
			}
			ImGui.SameLine();
			ImGui.BeginDisabled(!Can(DevMenuCap.PlayerBring));
			if (Btn("Bring", size))
			{
				BringPlayerHere(np);
			}
			ImGui.EndDisabled();
			if (Can(DevMenuCap.PlayerSpectate))
			{
				ImGui.SameLine();
				bool flag3 = _spectateTarget == np;
				if (Btn(flag3 ? "Unspy" : "Spy", size))
				{
					if (flag3)
					{
						_spectateTarget = null;
						DestroySpyCamera();
					}
					else
					{
						_spectateTarget = np;
					}
				}
			}
			ImGui.SameLine();
			ImGui.BeginDisabled(!Can(DevMenuCap.PlayerKick));
			if (DangerBtn("Kick", size))
			{
				KickPlayer(np, photonPlayer);
			}
			ImGui.EndDisabled();
			if (!flag2)
			{
				ImGui.EndDisabled();
				ImGui.TextDisabled("No networked body for this actor yet.");
			}
			if (flag)
			{
				ImGui.Indent();
				ImGui.Spacing();
				if (flag2)
				{
					if (Can(DevMenuCap.PlayerGrab))
					{
						bool isBeingGrabbed = np.IsBeingGrabbed;
						if (Btn(isBeingGrabbed ? "Release" : "Grab", FullWidth(22f)))
						{
							if (isBeingGrabbed)
							{
								np.ReleasePlayer();
							}
							else if (MonkeDevNetworkingManager.Manager?.LocalPlayer != null)
							{
								np.GrabPlayer(MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.OwnerActorNr, isLeftHand: false, byStaff: true);
							}
						}
					}
					if (Can(DevMenuCap.PlayerRainbow))
					{
						bool flag4 = _rainbowActors.Contains(photonPlayer.ActorNumber);
						if (Btn(flag4 ? "Rainbow Off" : "Rainbow", FullWidth(22f)))
						{
							np.photonView.RPC("SetRGBMonkey", np.photonView.Owner, !flag4);
							if (flag4)
							{
								_rainbowActors.Remove(photonPlayer.ActorNumber);
							}
							else
							{
								_rainbowActors.Add(photonPlayer.ActorNumber);
							}
						}
						Tip("MonkeDevNetworkingPlayer.isRainbowActive is private, so this toggle tracks the state locally — it can drift if someone else toggles it.");
					}
					if (Can(DevMenuCap.PlayerSendToSpawn) && Btn("Send to Spawn", FullWidth(22f)))
					{
						np.photonView.RPC("RPC_TeleportToSpawn", np.photonView.Owner);
					}
				}
				if (!string.IsNullOrEmpty(photonPlayer.UserId))
				{
					ImGui.TextDisabled("User: " + photonPlayer.UserId);
					if (Btn("Copy User Id", FullWidth(22f)))
					{
						ImGui.SetClipboardText(photonPlayer.UserId);
						Debug.Log("[DevMenu] User id for '" + name + "': " + photonPlayer.UserId);
						ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "User Id Logged", photonPlayer.UserId);
					}
				}
				else
				{
					ImGui.TextDisabled(MonkeDevNetworkingManager.IdentityHidden ? "User: hidden — this room does not publish user ids" : "User: unavailable for this actor");
				}
				ImGui.Unindent();
			}
			ImGui.Spacing();
		}

		private static Dictionary<int, MonkeDevNetworkingPlayer> BuildRemoteLookup()
		{
			_remoteLookup.Clear();
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if ((object)manager == null || manager.Players == null)
			{
				return _remoteLookup;
			}
			for (int i = 0; i < manager.Players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = manager.Players[i];
				if (!(monkeDevNetworkingPlayer == null) && !(monkeDevNetworkingPlayer.photonView == null) && !monkeDevNetworkingPlayer.photonView.IsMine && monkeDevNetworkingPlayer.photonView.Owner != null)
				{
					_remoteLookup[monkeDevNetworkingPlayer.photonView.Owner.ActorNumber] = monkeDevNetworkingPlayer;
				}
			}
			return _remoteLookup;
		}

		private static string ShortUserId(Player p)
		{
			if (p == null || string.IsNullOrEmpty(p.UserId))
			{
				return "??????";
			}
			if (p.UserId.Length <= 6)
			{
				return p.UserId;
			}
			return p.UserId.Substring(0, 6);
		}

		private void DrawRoomSection()
		{
			Room room = Photon.Pun.PhotonNetwork.CurrentRoom;
			if (room == null)
			{
				ImGui.TextDisabled("Not in a room.");
				return;
			}
			bool isMaster = Photon.Pun.PhotonNetwork.IsMasterClient;
			ImGui.TextDisabled("Name    " + room.Name);
			ImGui.TextDisabled(string.Format("Players {0} / {1}", room.PlayerCount, room.MaxPlayers));
			ImGui.TextDisabled("Master  " + (Photon.Pun.PhotonNetwork.MasterClient?.NickName ?? "-") + (isMaster ? "  (you)" : ""));
			bool publishUserId = room.PublishUserId;
			ImGui.TextColored(publishUserId ? new Vector4(0.45f, 1f, 0.45f, 1f) : new Vector4(1f, 0.4f, 0.4f, 1f), publishUserId ? "PublishUserId  ON  (players identifiable)" : "PublishUserId  OFF (dark room - ids hidden)");
			ImGui.TextDisabled("Creation flag, not a property - cannot be set here.");
			ImGui.Spacing();
			if (!isMaster)
			{
				ImGui.TextColored(new Vector4(1f, 0.75f, 0.3f, 1f), "Only the Master Client can change room state.");
				ImGui.Spacing();
			}
			ImGui.BeginDisabled(!isMaster);
			bool v = room.IsOpen;
			if (Checkbox("Open (joinable)", ref v) && isMaster)
			{
				room.IsOpen = v;
			}
			bool v2 = room.IsVisible;
			if (Checkbox("Visible (listed)", ref v2) && isMaster)
			{
				room.IsVisible = v2;
			}
			if (_roomMaxPlayers <= 0)
			{
				_roomMaxPlayers = room.MaxPlayers;
			}
			ImGui.SetNextItemWidth(120f);
			ImGui.InputInt("Max Players", ref _roomMaxPlayers);
			RegisterHover();
			ImGui.SameLine();
			Btn("Apply##maxp", new Vector2(76f, 0f), delegate
			{
				if (isMaster)
				{
					room.MaxPlayers = Mathf.Clamp(_roomMaxPlayers, 1, 64);
					_roomMaxPlayers = room.MaxPlayers;
					ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "Max Players", _roomMaxPlayers.ToString(), 2f);
				}
			});
			ImGui.EndDisabled();
			ImGui.Spacing();
			ImGui.TextDisabled("Custom Properties");
			Hashtable customProperties = room.CustomProperties;
			if (customProperties == null || customProperties.Count == 0)
			{
				ImGui.TextDisabled("  (none)");
			}
			else
			{
				foreach (object item in new List<object>(customProperties.Keys))
				{
					object obj = customProperties[item];
					ImGui.TextDisabled(string.Format("  {0} = {1}   [{2}]", item, obj ?? "null", obj?.GetType().Name ?? "null"));
					if (isMaster)
					{
						ImGui.SameLine();
						string text = item.ToString();
						if (DangerBtn("X##del_" + text, new Vector2(26f, 0f)))
						{
							room.SetCustomProperties(new Hashtable { { text, null } });
							ImGuiNotify.Insert(ImGuiNotify.ToastType.Info, "Property Removed", text, 2f);
						}
					}
				}
			}
			ImGui.Spacing();
			ImGui.BeginDisabled(!isMaster);
			ImGui.SetNextItemWidth(140f);
			ImGui.InputText("##rpkey", ref _roomPropKey, 64u);
			SoftKeyboard("##rpkey", ref _roomPropKey, "Property Key");
			RegisterHover();
			ImGui.SameLine();
			ImGui.SetNextItemWidth(160f);
			ImGui.InputText("##rpval", ref _roomPropValue, 128u);
			SoftKeyboard("##rpval", ref _roomPropValue, "Property Value");
			RegisterHover();
			ImGui.SameLine();
			Btn("Set##rpset", new Vector2(60f, 0f), delegate
			{
				if (isMaster && !string.IsNullOrWhiteSpace(_roomPropKey))
				{
					string text2 = _roomPropKey.Trim();
					room.SetCustomProperties(new Hashtable { { text2, ParsePropValue(_roomPropValue) } });
					ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "Property Set", text2 + " = " + _roomPropValue, 2.5f);
				}
			});
			ImGui.EndDisabled();
			ImGui.TextDisabled("Typed automatically: true/false, int, float, else string.");
		}

		private static object ParsePropValue(string raw)
		{
			if (string.IsNullOrEmpty(raw))
			{
				return "";
			}
			if (bool.TryParse(raw, out var result))
			{
				return result;
			}
			if (int.TryParse(raw, out var result2))
			{
				return result2;
			}
			if (float.TryParse(raw, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out var result3))
			{
				return result3;
			}
			return raw;
		}

		private static string SafeName(MonkeDevNetworkingPlayer np)
		{
			Player player = np?.photonView?.Owner;
			if (player == null)
			{
				return "Unknown";
			}
			if (string.IsNullOrEmpty(player.NickName))
			{
				return player.UserId;
			}
			return player.NickName;
		}

		private void ToggleMute(MonkeDevNetworkingPlayer np, int actorNumber)
		{
			if (!(np == null) && !(np.photonView == null) && np.photonView.Owner != null)
			{
				LocalMutes.Toggle(np.photonView.Owner.UserId);
			}
		}

		private static void TeleportSelfTo(MonkeDevNetworkingPlayer np)
		{
			if (!(np == null) && !(GorillaLocomotion.Player.Instance == null))
			{
				Vector3 position = ((np.Head != null) ? np.Head.position : np.transform.position);
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(position, GorillaLocomotion.Player.Instance.transform.rotation);
			}
		}

		private static void BringPlayerHere(MonkeDevNetworkingPlayer np)
		{
			if (!(np == null) && !(GorillaLocomotion.Player.Instance == null))
			{
				Vector3 position = GorillaLocomotion.Player.Instance.transform.position;
				np.photonView.RPC("RPC_TeleportToPosition", np.photonView.Owner, position.x, position.y, position.z);
			}
		}

		private void KickPlayer(MonkeDevNetworkingPlayer np, Player photonPlayer)
		{
			if (np == null)
			{
				return;
			}
			np.photonView.RPC("KickPlayer", np.photonView.Owner, Array.Empty<object>());
			_isManagingPlayer = false;
			ImGuiNotify.Insert(ImGuiNotify.ToastType.Error, "Kicked", string.IsNullOrEmpty(photonPlayer.NickName) ? string.Format("Actor {0}", photonPlayer.ActorNumber) : photonPlayer.NickName, 3f);
		}

		private void ForgetPlayer(int actorNumber)
		{
			_mutedActors.Remove(actorNumber);
			_rainbowActors.Remove(actorNumber);
			if (_selectedActorNumber == actorNumber)
			{
				_isManagingPlayer = false;
				_selectedActorNumber = -1;
			}
			if (_spectateTarget != null && (_spectateTarget.photonView == null || _spectateTarget.photonView.Owner == null || _spectateTarget.photonView.Owner.ActorNumber == actorNumber))
			{
				_spectateTarget = null;
				DestroySpyCamera();
			}
		}

		private void RefreshTeleportPoints()
		{
			_discoveredTpPoints.Clear();
			if (_tpPoints != null)
			{
				for (int i = 0; i < _tpPoints.Length; i++)
				{
					Transform t = _tpPoints[i];
					if (t != null)
					{
						_discoveredTpPoints.Add(t);
					}
				}
			}
			try
			{
				GameObject[] tagged = GameObject.FindGameObjectsWithTag("TPPoint");
				foreach (GameObject go in tagged)
				{
					if (go != null && !_discoveredTpPoints.Contains(go.transform))
					{
						_discoveredTpPoints.Add(go.transform);
					}
				}
			}
			catch (UnityException)
			{
			}
			for (int s = 0; s < SceneManager.sceneCount; s++)
			{
				Scene scene = SceneManager.GetSceneAt(s);
				if (!scene.isLoaded)
				{
					continue;
				}
				GameObject[] roots = scene.GetRootGameObjects();
				foreach (GameObject root in roots)
				{
					Transform[] all = root.GetComponentsInChildren<Transform>(true);
					foreach (Transform t in all)
					{
						if (t.name.StartsWith("TP_", StringComparison.OrdinalIgnoreCase) && !_discoveredTpPoints.Contains(t))
						{
							_discoveredTpPoints.Add(t);
						}
					}
				}
			}
		}

		private void DrawPage_TP()
		{
			PageHeader("Teleport", string.Format("{0} map point(s) found.", _discoveredTpPoints.Count));
			BeginPageScroll("##scroll_tp");
			float avail = ImGui.GetContentRegionAvail().x;
			if (ImGui.CollapsingHeader("Map Points", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				if (_discoveredTpPoints.Count != 0)
				{
					float btnW = avail - ImGui.GetStyle().IndentSpacing - 4f;
					for (int i = _discoveredTpPoints.Count - 1; i >= 0; i--)
					{
						Transform t = _discoveredTpPoints[i];
						if (t == null)
						{
							_discoveredTpPoints.RemoveAt(i);
							continue;
						}
						string label = t.name.StartsWith("TP_", StringComparison.OrdinalIgnoreCase) ? t.name.Substring(3) : t.name;
						if (Btn(string.Format("{0}##tp{1}", label, i), new Vector2(btnW, 26f)))
						{
							TeleportSelf(t.position);
						}
						if (ImGui.IsItemHovered())
						{
							ImGui.BeginTooltip();
							ImGui.TextDisabled(string.Format("{0:F1}  {1:F1}  {2:F1}", t.position.x, t.position.y, t.position.z));
							ImGui.EndTooltip();
						}
					}
				}
				else
				{
					ImGui.TextDisabled("None found in this scene.");
					ImGui.TextDisabled("Tag an object 'TPPoint' or name it 'TP_<name>'.");
				}
				ImGui.Spacing();
				Btn("Rescan Scene", new Vector2(avail - ImGui.GetStyle().IndentSpacing - 4f, 22f), RefreshTeleportPoints);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Manual XYZ", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				float third = (avail - ImGui.GetStyle().IndentSpacing - 16f) / 3f;
				ImGui.SetNextItemWidth(third);
				ImGui.DragFloat("X##tpx", ref _tpManualPos.x, 0.5f);
				RegisterHover();
				ImGui.SameLine(0f, 6f);
				ImGui.SetNextItemWidth(third);
				ImGui.DragFloat("Y##tpy", ref _tpManualPos.y, 0.5f);
				RegisterHover();
				ImGui.SameLine(0f, 6f);
				ImGui.SetNextItemWidth(third);
				ImGui.DragFloat("Z##tpz", ref _tpManualPos.z, 0.5f);
				RegisterHover();
				ImGui.Spacing();
				float half = (avail - ImGui.GetStyle().IndentSpacing - 8f) * 0.5f;
				if (Btn("Teleport##manual", new Vector2(half, 26f)))
				{
					TeleportSelf(_tpManualPos);
				}
				ImGui.SameLine(0f, 8f);
				if (Btn("Snap Here##snap", new Vector2(half, 26f)) && GorillaLocomotion.Player.Instance != null)
				{
					_tpManualPos = GorillaLocomotion.Player.Instance.transform.position;
				}
				Tip("Copy your current position into the fields.");
				ImGui.Spacing();
				if (Btn("Teleport to Spawn", new Vector2(avail - ImGui.GetStyle().IndentSpacing - 4f, 24f)) && GorillaLocomotion.Player.Instance != null)
				{
					GorillaLocomotion.Player.Instance.TeleportToSpawn();
				}
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Bookmarks", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				ImGui.SetNextItemWidth(avail - ImGui.GetStyle().IndentSpacing - 90f);
				ImGui.InputText("##bkmkname", ref _tpBookmarkName, 32u);
				RegisterHover();
				ImGui.SameLine(0f, 6f);
				if (Btn("Save Pos##bksave", new Vector2(80f, 0f)) && GorillaLocomotion.Player.Instance != null && !string.IsNullOrWhiteSpace(_tpBookmarkName))
				{
					_tpBookmarks.Add(new TpBookmark
					{
						Label = _tpBookmarkName.Trim(),
						Pos = GorillaLocomotion.Player.Instance.transform.position
					});
					_tpBookmarkName = "Bookmark";
					SaveBookmarks();
				}
				ImGui.Spacing();
				for (int j = _tpBookmarks.Count - 1; j >= 0; j--)
				{
					TpBookmark bk = _tpBookmarks[j];
					if (Btn(string.Format("{0}##bk{1}", bk.Label, j), new Vector2(avail - ImGui.GetStyle().IndentSpacing - 36f, 24f)))
					{
						TeleportSelf(bk.Pos);
					}
					if (ImGui.IsItemHovered())
					{
						ImGui.BeginTooltip();
						ImGui.TextDisabled(string.Format("{0:F1}  {1:F1}  {2:F1}", bk.Pos.x, bk.Pos.y, bk.Pos.z));
						ImGui.EndTooltip();
					}
					ImGui.SameLine(0f, 4f);
					if (DangerBtn(string.Format("X##del{0}", j), new Vector2(28f, 24f)))
					{
						_tpBookmarks.RemoveAt(j);
						SaveBookmarks();
					}
				}
				if (_tpBookmarks.Count == 0)
				{
					ImGui.TextDisabled("No bookmarks yet.");
				}
				ImGui.Unindent();
			}
			EndPageScroll();
		}

		private static void TeleportSelf(Vector3 pos)
		{
			if (!(GorillaLocomotion.Player.Instance == null))
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(pos, GorillaLocomotion.Player.Instance.transform.rotation);
			}
		}

		private void ScanSpawnerPrefabs()
		{
			if (_spawnersScanned)
			{
				return;
			}
			_spawnersScanned = true;
			List<string> names = new List<string>();
			List<string> paths = new List<string>();
			string[] folders = new string[4] { "Prefabs/AI", "Prefabs/Interactables", "Prefabs/Sandbox", "Prefabs" };
			foreach (string folder in folders)
			{
				GameObject[] prefabs = Resources.LoadAll<GameObject>(folder);
				foreach (GameObject prefab in prefabs)
				{
					if (prefab == null || prefab.GetComponent<Photon.Pun.PhotonView>() == null || names.Contains(prefab.name))
					{
						continue;
					}
					string fullPath = folder + "/" + prefab.name;
					string path = (Resources.Load<GameObject>(fullPath) != null) ? fullPath : ((Resources.Load<GameObject>(prefab.name) != null) ? prefab.name : null);
					if (path != null)
					{
						names.Add(prefab.name);
						paths.Add(path);
					}
				}
			}
			_spawnerPrefabNames = names.ToArray();
			_spawnerPrefabPaths = paths.ToArray();
			_selectedPrefabIndex = Mathf.Clamp(_selectedPrefabIndex, 0, Mathf.Max(0, names.Count - 1));
		}

		private void DrawPage_Spawners()
		{
			PageHeader("Spawners", "Networked prefabs from Resources/Prefabs.");
			BeginPageScroll("##scroll_spawners");
			ScanSpawnerPrefabs();
			if (_spawnerPrefabNames.Length == 0)
			{
				ImGui.TextDisabled("No networkable prefabs found under Resources/Prefabs.");
				ImGui.TextDisabled("A prefab needs a PhotonView to be spawnable.");
				EndPageScroll();
				return;
			}
			ImGui.TextUnformatted("Prefab");
			ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
			ImGui.Combo("##prefab", ref _selectedPrefabIndex, _spawnerPrefabNames, _spawnerPrefabNames.Length);
			RegisterHover();
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
			ImGui.SliderInt("##spawnlimit", ref _spawnLimit, 1, 50, "Limit: %d");
			RegisterHover();
			ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
			ImGui.SliderFloat("##spawncooldown", ref _spawnCooldown, 0.1f, 10f, "Cooldown: %.1f s");
			RegisterHover();
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			_mySpawnedObjects.RemoveAll((GameObject o) => o == null);
			float sinceLast = Time.time - _lastSpawnTime;
			bool atLimit = !_disableSpawnLimit && _mySpawnedObjects.Count >= _spawnLimit;
			if (_showSpamButton)
			{
				if (_spamSpawning)
				{
					ImGui.PushStyleColor(ImGuiCol.Button, new Vector4(0.5f, 0.15f, 0.15f, 1f));
				}
				if (Btn(string.Format("Spam Spawn  [{0}]", _mySpawnedObjects.Count), FullWidth(28f)))
				{
					_spamSpawning = !_spamSpawning;
				}
				if (_spamSpawning)
				{
					ImGui.PopStyleColor();
				}
			}
			else
			{
				bool blocked = sinceLast < _spawnCooldown || atLimit;
				if (blocked)
				{
					ImGui.BeginDisabled();
				}
				Btn("Spawn", FullWidth(28f), SpawnSelectedPrefab);
				if (blocked)
				{
					ImGui.EndDisabled();
				}
			}
			if (sinceLast < _spawnCooldown)
			{
				ImGui.TextDisabled(string.Format("Cooldown: {0:F1}s", _spawnCooldown - (Time.time - _lastSpawnTime)));
			}
			else if (atLimit)
			{
				ImGui.TextDisabled("Limit reached.");
			}
			ImGui.Spacing();
			bool none = _mySpawnedObjects.Count == 0;
			if (none)
			{
				ImGui.BeginDisabled();
			}
			Btn("Clean Up Mine", FullWidth(25f), CleanUpMySpawns);
			if (none)
			{
				ImGui.EndDisabled();
			}
			ImGui.Spacing();
			ImGui.TextDisabled(string.Format("Spawned by you: {0}", _mySpawnedObjects.Count));
			ImGui.TextDisabled("Uses Photon.Pun.PhotonNetwork.Instantiate — it bypasses the project's pool,");
			ImGui.TextDisabled("so clean up after yourself rather than leaving spawns in the room.");
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Spawner Options"))
			{
				ImGui.Indent();
				if (Checkbox("Show Spam Button", ref _showSpamButton))
				{
					_spamSpawning = false;
				}
				Tip("Replaces Spawn with a toggle that keeps spawning until you switch it off.");
				Checkbox("Disable Spawn Limit", ref _disableSpawnLimit);
				Tip("Removes the cap. Combined with spam spawning this will happily fill a room with networked objects and tank everyone's frame rate — including yours.");
				ImGui.Spacing();
				Btn("Save Spawner Options", FullWidth(24f), SaveSettings);
				ImGui.Unindent();
			}
			EndPageScroll();
		}

		private void SpawnSelectedPrefab()
		{
			if (_spawnerPrefabPaths.Length == 0)
			{
				return;
			}
			if (!Photon.Pun.PhotonNetwork.InRoom)
			{
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Warning, "Not in a room", "Can't spawn networked objects.", 3f);
			}
			else if ((_disableSpawnLimit || _mySpawnedObjects.Count < _spawnLimit) && !(GorillaLocomotion.Player.Instance == null))
			{
				_selectedPrefabIndex = Mathf.Clamp(_selectedPrefabIndex, 0, _spawnerPrefabPaths.Length - 1);
				string path = _spawnerPrefabPaths[_selectedPrefabIndex];
				Transform head = (GorillaLocomotion.Player.Instance.headCollider != null) ? GorillaLocomotion.Player.Instance.headCollider.transform : GorillaLocomotion.Player.Instance.transform;
				Vector3 pos = head.position + head.forward * 1.5f;
				GameObject spawned = Photon.Pun.PhotonNetwork.Instantiate(path, pos, Quaternion.identity, 0);
				if (spawned != null)
				{
					_mySpawnedObjects.Add(spawned);
				}
				_lastSpawnTime = Time.time;
			}
		}

		private void CleanUpMySpawns()
		{
			_spamSpawning = false;
			foreach (GameObject go in _mySpawnedObjects)
			{
				if (!(go == null))
				{
					Photon.Pun.PhotonView pv = go.GetComponent<Photon.Pun.PhotonView>();
					if (!(pv != null) || pv.IsMine)
					{
						Photon.Pun.PhotonNetwork.Destroy(go);
					}
				}
			}
			_mySpawnedObjects.Clear();
		}

		private void Handle_SpamSpawn()
		{
			if (_spamSpawning && !(Time.time - _lastSpawnTime < _spawnCooldown))
			{
				if (!_disableSpawnLimit && _mySpawnedObjects.Count >= _spawnLimit)
				{
					_spamSpawning = false;
				}
				else
				{
					SpawnSelectedPrefab();
				}
			}
		}

		private static void StartGameLogListener()
		{
			if (!_logListenerStarted)
			{
				Application.logMessageReceivedThreaded += OnGameLogReceived;
				_logListenerStarted = true;
			}
		}

		private static void StopGameLogListener()
		{
			if (_logListenerStarted)
			{
				Application.logMessageReceivedThreaded -= OnGameLogReceived;
				_logListenerStarted = false;
			}
		}

		private static void OnGameLogReceived(string condition, string stackTrace, LogType type)
		{
			lock (_logLock)
			{
				_gameLogs.Add(new GameLogEntry
				{
					Type = type.ToString(),
					Message = condition,
					StackTrace = stackTrace,
					Time = DateTime.Now
				});
				if (_gameLogs.Count > MaxLogs)
				{
					_gameLogs.RemoveAt(0);
				}
			}
		}

		private void DrawPage_Debug()
		{
			int total;
			int errors = 0;
			int warnings = 0;
			lock (_logLock)
			{
				total = _gameLogs.Count;
				for (int i = 0; i < _gameLogs.Count; i++)
				{
					if (_gameLogs[i].Type == "Warning")
					{
						warnings++;
					}
					else if (_gameLogs[i].Type != "Log")
					{
						errors++;
					}
				}
			}
			PageHeader("Debug", string.Format("{0} logs · {1} errors · {2} warnings", total, errors, warnings));
			BeginPageScroll("##scroll_debug");
			if (ImGui.CollapsingHeader("Console###dbg_console", ImGuiTreeNodeFlags.DefaultOpen))
			{
				DrawConsole();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Lobby Cost  (screenshot me)", ImGuiTreeNodeFlags.DefaultOpen))
			{
				DrawLobbyCost();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Performance"))
			{
				float dt = Time.unscaledDeltaTime;
				float fps = 1f / Mathf.Max(dt, 0.0001f);
				float min = float.MaxValue;
				float max = 0f;
				float sum = 0f;
				int samples = 0;
				for (int j = 0; j < FPSHistorySize; j++)
				{
					float v = _fpsHistory[j];
					if (v > 0f)
					{
						sum += v;
						samples++;
						if (v < min)
						{
							min = v;
						}
						if (v > max)
						{
							max = v;
						}
					}
				}
				if (samples == 0)
				{
					min = 0f;
				}
				ImGui.Text(string.Format("FPS {0:0.0}   ({1:0.0} ms)", fps, dt * 1000f));
				ImGui.Text(string.Format("min {0:0} | avg {1:0} | max {2:0}", min, (samples > 0) ? (sum / (float)samples) : 0f, max));
				ImGui.PlotLines("##dbgfps", ref _fpsHistory[0], FPSHistorySize, _fpsHistoryIdx, null, 0f, Mathf.Max(max, 120f), new Vector2(ImGui.GetContentRegionAvail().x, 70f));
				// RE: unsure - managed heap size was inlined from the runtime; read as GC.GetTotalMemory(false)
				ImGui.Text(string.Format("Managed memory: {0} MB", GC.GetTotalMemory(false) / 1048576));
				ImGui.Text(string.Format("Target FPS: {0}   VSync: {1}", Application.targetFrameRate, QualitySettings.vSyncCount));
				ImGui.Spacing();
				ImGui.TextDisabled("Menu overhead:");
				ImGui.TextDisabled(string.Format("  particles {0}", _enableBackgroundParticles ? ClampedParticleCount : 0) + string.Format("   spiral {0} dots", _spiralEnabled ? SpiralDrawCost : 0));
				ImGui.TextDisabled(string.Format("  ESP {0} × 2 renderers", _espEntries.Count) + "   spy cam " + ((_spectateTarget != null) ? "on" : "off"));
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Network"))
			{
				ImGui.Text(string.Format("State:  {0}", Photon.Pun.PhotonNetwork.NetworkClientState));
				ImGui.Text(string.Format("Region: {0}   Ping: {1} ms", Photon.Pun.PhotonNetwork.CloudRegion, Photon.Pun.PhotonNetwork.GetPing()));
				ImGui.Text("Room:   " + (Photon.Pun.PhotonNetwork.CurrentRoom?.Name ?? "none") + "   " + string.Format("Players: {0}", (Photon.Pun.PhotonNetwork.CurrentRoom != null) ? Photon.Pun.PhotonNetwork.CurrentRoom.PlayerCount : 0));
				ImGui.Text(string.Format("Master client: {0}", Photon.Pun.PhotonNetwork.IsMasterClient));
				ImGui.Spacing();
				bool cannotTake = !Photon.Pun.PhotonNetwork.InRoom || Photon.Pun.PhotonNetwork.IsMasterClient;
				if (cannotTake)
				{
					ImGui.BeginDisabled();
				}
				Btn("Take Master Client", FullWidth(26f), delegate
				{
					Photon.Pun.PhotonNetwork.SetMasterClient(Photon.Pun.PhotonNetwork.LocalPlayer);
				});
				if (cannotTake)
				{
					ImGui.EndDisabled();
				}
				if (Photon.Pun.PhotonNetwork.InRoom && Btn("Copy Room Info", FullWidth(24f)))
				{
					ImGui.SetClipboardText(string.Format("Room {0} | {1} players | ", Photon.Pun.PhotonNetwork.CurrentRoom?.Name, Photon.Pun.PhotonNetwork.CurrentRoom?.PlayerCount) + string.Format("region {0} | {1}ms", Photon.Pun.PhotonNetwork.CloudRegion, Photon.Pun.PhotonNetwork.GetPing()));
				}
			}
			ImGui.Spacing();
			if (GorillaLocomotion.Player.Instance != null && ImGui.CollapsingHeader("Player"))
			{
				GorillaLocomotion.Player p = GorillaLocomotion.Player.Instance;
				Rigidbody rb = p.playerRigidBody;
				ImGui.Text(string.Format("Position:  {0}", p.transform.position));
				ImGui.Text(string.Format("Velocity:  {0}", (rb != null) ? rb.linearVelocity : Vector3.zero));
				ImGui.Text(string.Format("Scale:     {0:F3}  (current {1:F3})", p.targetScale, p.CurrentScale));
				ImGui.Text(string.Format("VelLimit:  {0}   JumpMult: {1}", p.velocityLimit, p.jumpMultiplier));
				ImGui.Text(string.Format("ArmLength: {0}   MaxJump: {1}", p.maxArmLength, p.maxJumpSpeed));
				ImGui.Text(string.Format("Gravity:   {0:F2}", Physics.gravity.y));
				ImGui.Text(string.Format("DisableMove: {0}   DebugMove: {1}", p.disableMovement, p.debugMovement));
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("System"))
			{
				ImGui.Text(Application.productName + "  v" + Application.version);
				ImGui.Text("Unity " + Application.unityVersion);
				ImGui.Text(string.Format("Platform: {0}", Application.platform));
				ImGui.Text("Device: " + SystemInfo.deviceModel);
				ImGui.Text("GPU: " + SystemInfo.graphicsDeviceName);
				ImGui.Text("XR: " + (UnityEngine.XR.XRSettings.isDeviceActive ? UnityEngine.XR.XRSettings.loadedDeviceName : "None"));
				ImGui.Text(string.Format("Screen: {0}x{1}", Screen.width, Screen.height));
				ImGui.Spacing();
				if (Btn("Copy Diagnostics", FullWidth(26f)))
				{
					ImGui.SetClipboardText(BuildDiagnostics());
				}
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Sandbox"))
			{
				float timeScale = Time.timeScale;
				ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
				bool changed = ImGui.SliderFloat("##timescale", ref timeScale, 0f, 2f, "Time Scale: %.2f");
				RegisterHover();
				if (changed)
				{
					Time.timeScale = timeScale;
				}
				Btn("Reset Time Scale", FullWidth(24f), delegate
				{
					Time.timeScale = 1f;
				});
				ImGui.TextDisabled("Local only — affects physics and animation timing.");
			}
			EndPageScroll();
		}

		private void DrawConsole()
		{
			Checkbox("Info", ref _logShowInfo);
			ImGui.SameLine();
			Checkbox("Warn", ref _logShowWarn);
			ImGui.SameLine();
			Checkbox("Error", ref _logShowError);
			ImGui.SameLine();
			Checkbox("Auto-scroll", ref _autoScrollLogs);
			ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x - 124f);
			ImGui.InputTextWithHint("##logsearch", "Filter…", ref _logSearch, 128u);
			RegisterHover();
			ImGui.SameLine();
			if (Btn("Clear", new Vector2(56f, 0f)))
			{
				lock (_logLock)
				{
					_gameLogs.Clear();
				}
			}
			ImGui.SameLine();
			if (Btn("Copy", new Vector2(56f, 0f)))
			{
				System.Text.StringBuilder stringBuilder = new System.Text.StringBuilder();
				lock (_logLock)
				{
					foreach (GameLogEntry gameLog in _gameLogs)
					{
						stringBuilder.AppendLine(string.Format("[{0:HH:mm:ss}] [{1}] {2}", gameLog.Time, gameLog.Type, gameLog.Message));
					}
				}
				ImGui.SetClipboardText(stringBuilder.ToString());
			}
			string value = (_logSearch ?? "").Trim().ToLowerInvariant();
			ImGui.BeginChild("##console_scroll", new Vector2(0f, 220f), ImGuiChildFlags.Border);
			lock (_logLock)
			{
				for (int i = 0; i < _gameLogs.Count; i++)
				{
					GameLogEntry gameLogEntry = _gameLogs[i];
					bool flag = gameLogEntry.Type == "Error" || gameLogEntry.Type == "Assert" || gameLogEntry.Type == "Exception";
					bool flag2 = gameLogEntry.Type == "Warning";
					if ((flag && !_logShowError) || (flag2 && !_logShowWarn) || (!flag && !flag2 && !_logShowInfo) || (value.Length > 0 && gameLogEntry.Message.ToLowerInvariant().IndexOf(value, StringComparison.Ordinal) < 0))
					{
						continue;
					}
					Vector4 col = (flag ? new Vector4(1f, 0.35f, 0.35f, 1f) : (flag2 ? new Vector4(1f, 0.8f, 0.2f, 1f) : new Vector4(0.82f, 0.82f, 0.86f, 1f)));
					ImGui.PushStyleColor(ImGuiCol.Text, col);
					ImGui.TextWrapped(string.Format("[{0:HH:mm:ss}] {1}", gameLogEntry.Time, gameLogEntry.Message));
					ImGui.PopStyleColor();
					if (flag && !string.IsNullOrEmpty(gameLogEntry.StackTrace))
					{
						ImGui.PushStyleColor(ImGuiCol.Text, new Vector4(0.55f, 0.55f, 0.6f, 1f));
						ImGui.TextWrapped(gameLogEntry.StackTrace);
						ImGui.PopStyleColor();
					}
				}
			}
			if (_autoScrollLogs && ImGui.GetScrollY() >= ImGui.GetScrollMaxY() - 25f)
			{
				ImGui.SetScrollHereY(1f);
			}
			ImGui.EndChild();
		}

		private static string BuildDiagnostics()
		{
			System.Text.StringBuilder stringBuilder = new System.Text.StringBuilder();
			stringBuilder.AppendLine(string.Format("Slop-Game diagnostics, {0:yyyy-MM-dd HH:mm:ss}", DateTime.Now));
			stringBuilder.AppendLine("App: " + Application.productName + " v" + Application.version);
			stringBuilder.AppendLine("Unity: " + Application.unityVersion);
			stringBuilder.AppendLine(string.Format("Platform: {0}", Application.platform));
			stringBuilder.AppendLine("Device: " + SystemInfo.deviceModel + " (" + SystemInfo.operatingSystem + ")");
			stringBuilder.AppendLine("GPU: " + SystemInfo.graphicsDeviceName);
			stringBuilder.AppendLine("XR: " + (UnityEngine.XR.XRSettings.isDeviceActive ? UnityEngine.XR.XRSettings.loadedDeviceName : "None"));
			stringBuilder.AppendLine(string.Format("Screen: {0}x{1}", Screen.width, Screen.height));
			stringBuilder.AppendLine(string.Format("Managed memory: {0} MB", GC.GetTotalMemory(forceFullCollection: false) / 1048576));
			stringBuilder.AppendLine(string.Format("FPS: {0:0}", 1f / Mathf.Max(Time.unscaledDeltaTime, 0.0001f)));
			stringBuilder.AppendLine("Scene: " + SceneManager.GetActiveScene().name);
			if (Photon.Pun.PhotonNetwork.InRoom)
			{
				stringBuilder.AppendLine(string.Format("Room: {0} ({1} players)", Photon.Pun.PhotonNetwork.CurrentRoom?.Name, Photon.Pun.PhotonNetwork.CurrentRoom?.PlayerCount));
				stringBuilder.AppendLine(string.Format("Region: {0}  Ping: {1} ms", Photon.Pun.PhotonNetwork.CloudRegion, Photon.Pun.PhotonNetwork.GetPing()));
				stringBuilder.AppendLine(string.Format("State: {0}  Master: {1}", Photon.Pun.PhotonNetwork.NetworkClientState, Photon.Pun.PhotonNetwork.IsMasterClient));
			}
			return stringBuilder.ToString();
		}

		private void DrawPage_Soundboard()
		{
			PageHeader("Soundboard", "Play plays for everyone. Preview is local only.");
			if (soundboardClips == null || soundboardClips.Length == 0)
			{
				ImGui.TextDisabled("No clips assigned on the DevMenu component.");
				return;
			}
			DevSoundboardRelay instance = DevSoundboardRelay.Instance;
			ImGui.BeginChild("##soundboard_scroll", new Vector2(0f, Mathf.Max(ImGui.GetContentRegionAvail().y - 96f, 80f)), ImGuiChildFlags.Border, ImGuiWindowFlags.None);
			float x = ImGui.GetStyle().ItemSpacing.x;
			float num = x + x + 148f;
			for (int i = 0; i < soundboardClips.Length; i++)
			{
				int captured = i;
				AudioClip audioClip = soundboardClips[i];
				if (!(audioClip == null))
				{
					bool flag = instance != null && instance.IsPlaying && instance.CurrentIndex == i;
					bool flag2 = _soundboardPreviewing && soundboardAudioSource != null && soundboardAudioSource.isPlaying && _currentSoundboardIndex == i;
					ImGui.PushID(i);
					float cursorPosX = ImGui.GetCursorPosX();
					float num2 = Mathf.Max(ImGui.GetContentRegionAvail().x - num, 40f);
					ImGui.AlignTextToFramePadding();
					bool flag3 = flag || flag2;
					if (flag3)
					{
						ImGui.PushStyleColor(ImGuiCol.Text, flag2 ? new Vector4(0.95f, 0.85f, 0.3f, 1f) : new Vector4(0.4f, 0.9f, 0.45f, 1f));
					}
					ImGui.TextUnformatted(FitText(audioClip.name, num2));
					if (flag3)
					{
						ImGui.PopStyleColor();
					}
					ImGui.SameLine();
					ImGui.SetCursorPosX(cursorPosX + num2 + x);
					Btn("Preview", new Vector2(74f, 26f), delegate
					{
						PreviewSoundboard(captured);
					});
					ImGui.SameLine();
					Btn("Play", new Vector2(74f, 26f), delegate
					{
						PlaySoundboard(captured);
					});
					ImGui.PopID();
				}
			}
			ImGui.EndChild();
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			float v = ((instance != null) ? instance.Volume : ((soundboardAudioSource != null) ? soundboardAudioSource.volume : 1f));
			ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
			bool num3 = ImGui.SliderFloat("##sbvolume", ref v, 0f, 1f, "Volume: %.2f");
			RegisterHover();
			if (num3)
			{
				SetSoundboardVolume(v);
			}
			ImGui.Spacing();
			bool flag4 = !((instance != null && instance.IsPlaying) || (soundboardAudioSource != null && soundboardAudioSource.isPlaying));
			if (flag4)
			{
				ImGui.BeginDisabled();
			}
			Btn("Stop", FullWidth(25f), StopSoundboard);
			if (flag4)
			{
				ImGui.EndDisabled();
			}
			if (!Photon.Pun.PhotonNetwork.InRoom)
			{
				ImGui.TextDisabled("Offline — Play only sounds locally.");
			}
		}

		private void PreviewSoundboard(int index)
		{
			if (!(soundboardAudioSource == null) && index >= 0 && soundboardClips != null && index < soundboardClips.Length && !(soundboardClips[index] == null))
			{
				_currentSoundboardIndex = index;
				_soundboardPreviewing = true;
				soundboardAudioSource.Stop();
				soundboardAudioSource.PlayOneShot(soundboardClips[index]);
			}
		}

		private void PlaySoundboard(int index)
		{
			_soundboardPreviewing = false;
			DevSoundboardRelay.Broadcast(index);
		}

		private void StopSoundboard()
		{
			_soundboardPreviewing = false;
			_currentSoundboardIndex = -1;
			if (soundboardAudioSource != null)
			{
				soundboardAudioSource.Stop();
			}
			DevSoundboardRelay.BroadcastStop();
		}

		private void SetSoundboardVolume(float volume)
		{
			volume = Mathf.Clamp01(volume);
			if (DevSoundboardRelay.Instance != null)
			{
				DevSoundboardRelay.Instance.Volume = volume;
			}
			if (soundboardAudioSource != null)
			{
				soundboardAudioSource.volume = volume;
			}
			PlayerPrefs.SetFloat("LA_SoundboardVolume", volume);
		}

		private static string FitText(string text, float maxWidth)
		{
			if (string.IsNullOrEmpty(text) || ImGui.CalcTextSize(text).x <= maxWidth)
			{
				return text;
			}
			while (text.Length > 1 && ImGui.CalcTextSize(text + "…").x > maxWidth)
			{
				text = text.Substring(0, text.Length - 1);
			}
			return text + "…";
		}

		private void StartPerfRecorders()
		{
			if (_recStarted)
			{
				return;
			}
			_recStarted = true;
			try
			{
				_recDrawCalls = ProfilerRecorder.StartNew(ProfilerCategory.Render, "Draw Calls Count");
				_recSetPass = ProfilerRecorder.StartNew(ProfilerCategory.Render, "SetPass Calls Count");
				_recTris = ProfilerRecorder.StartNew(ProfilerCategory.Render, "Triangles Count");
				_recVerts = ProfilerRecorder.StartNew(ProfilerCategory.Render, "Vertices Count");
			}
			catch (Exception)
			{
			}
		}

		private void StopPerfRecorders()
		{
			if (_recStarted)
			{
				_recStarted = false;
				if (_recDrawCalls.Valid)
				{
					_recDrawCalls.Dispose();
				}
				if (_recSetPass.Valid)
				{
					_recSetPass.Dispose();
				}
				if (_recTris.Valid)
				{
					_recTris.Dispose();
				}
				if (_recVerts.Valid)
				{
					_recVerts.Dispose();
				}
			}
		}

		private static string Rec(ProfilerRecorder r)
		{
			if (!r.Valid || r.LastValue <= 0)
			{
				return "n/a";
			}
			return r.LastValue.ToString("N0");
		}

		private static bool HasPerFrameLoop(Type t)
		{
			if (_loopCache.TryGetValue(t, out var value))
			{
				return value;
			}
			bool flag = false;
			Type type = t;
			while (type != null && !(type == typeof(MonoBehaviour)) && !flag)
			{
				for (int i = 0; i < LoopNames.Length; i++)
				{
					if (type.GetMethod(LoopNames[i], System.Reflection.BindingFlags.DeclaredOnly | System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic) != null)
					{
						flag = true;
						break;
					}
				}
				type = type.BaseType;
			}
			_loopCache[t] = flag;
			return flag;
		}

		private void RefreshLobbyStats()
		{
			_lsPlayers = 0;
			_lsTransforms = 0;
			_lsDrawing = 0;
			_lsSkinned = 0;
			_lsTicking = 0;
			_lsAudioTotal = 0;
			_lsAudioPlaying = 0;
			_lsAudioSpatialized = 0;
			_lsCosmeticOn = 0;
			_lsCosmeticOff = 0;
			Dictionary<string, int> dictionary = new Dictionary<string, int>();
			MonkeDevNetworkingPlayer[] array = UnityEngine.Object.FindObjectsByType<MonkeDevNetworkingPlayer>(FindObjectsSortMode.None);
			_lsPlayers = array.Length;
			for (int i = 0; i < array.Length; i++)
			{
				GameObject gameObject = array[i].gameObject;
				Transform[] componentsInChildren = gameObject.GetComponentsInChildren<Transform>();
				for (int j = 0; j < componentsInChildren.Length; j++)
				{
					if (componentsInChildren[j].gameObject.activeInHierarchy)
					{
						_lsTransforms++;
					}
				}
				Renderer[] componentsInChildren2 = gameObject.GetComponentsInChildren<Renderer>();
				foreach (Renderer renderer in componentsInChildren2)
				{
					if (renderer.gameObject.activeInHierarchy && renderer.enabled)
					{
						_lsDrawing++;
						if (renderer is SkinnedMeshRenderer)
						{
							_lsSkinned++;
						}
					}
				}
				MonoBehaviour[] componentsInChildren3 = gameObject.GetComponentsInChildren<MonoBehaviour>();
				foreach (MonoBehaviour monoBehaviour in componentsInChildren3)
				{
					if (!(monoBehaviour == null) && monoBehaviour.isActiveAndEnabled)
					{
						Type type = monoBehaviour.GetType();
						if (HasPerFrameLoop(type))
						{
							_lsTicking++;
							dictionary[type.Name] = ((!dictionary.TryGetValue(type.Name, out var value)) ? 1 : (value + 1));
						}
					}
				}
				AudioSource[] componentsInChildren4 = gameObject.GetComponentsInChildren<AudioSource>();
				foreach (AudioSource audioSource in componentsInChildren4)
				{
					if (!(audioSource == null) && audioSource.gameObject.activeInHierarchy && audioSource.enabled)
					{
						_lsAudioTotal++;
						if (audioSource.isPlaying)
						{
							_lsAudioPlaying++;
						}
						if (audioSource.spatialize)
						{
							_lsAudioSpatialized++;
						}
					}
				}
				List<MonkeDevNetworkingPlayer.CosmeticSlot> cosmeticSlots = array[i].CosmeticSlots;
				if (cosmeticSlots == null)
				{
					continue;
				}
				for (int l = 0; l < cosmeticSlots.Count; l++)
				{
					MonkeDevNetworkingPlayer.CosmeticSlot cosmeticSlot = cosmeticSlots[l];
					if (cosmeticSlot == null || cosmeticSlot.Object == null)
					{
						continue;
					}
					Renderer[] componentsInChildren5 = cosmeticSlot.Object.GetComponentsInChildren<Renderer>();
					for (int m = 0; m < componentsInChildren5.Length; m++)
					{
						if (componentsInChildren5[m].gameObject.activeInHierarchy)
						{
							if (componentsInChildren5[m].enabled)
							{
								_lsCosmeticOn++;
							}
							else
							{
								_lsCosmeticOff++;
							}
						}
					}
				}
			}
			System.Text.StringBuilder stringBuilder = new System.Text.StringBuilder(160);
			for (int n = 0; n < 5; n++)
			{
				if (dictionary.Count == 0)
				{
					break;
				}
				string text = null;
				int num = -1;
				foreach (KeyValuePair<string, int> item in dictionary)
				{
					if (item.Value > num)
					{
						num = item.Value;
						text = item.Key;
					}
				}
				if (text == null)
				{
					break;
				}
				stringBuilder.Append("  ").Append(num.ToString().PadLeft(4)).Append("  ")
					.Append(text)
					.Append('\n');
				dictionary.Remove(text);
			}
			_lsTopScripts = stringBuilder.ToString();
			_lsGcMb = GC.GetTotalMemory(forceFullCollection: false) / 1048576;
		}

		private static float ToMs(float? v)
		{
			if (!v.HasValue)
			{
				return -1f;
			}
			float value = v.Value;
			if (value <= 0f)
			{
				return 0f;
			}
			if (!(value < 1f))
			{
				return value;
			}
			return value * 1000f;
		}

		private static float ToPercent(float? v)
		{
			if (!v.HasValue)
			{
				return -1f;
			}
			float value = v.Value;
			if (!(value <= 1f))
			{
				return value;
			}
			return value * 100f;
		}

		private void RefreshDeviceMetrics()
		{
			try
			{
				if (!_devModeRequested)
				{
					_devModeRequested = true;
					OVRPlugin.SetDeveloperMode(OVRPlugin.Bool.True);
				}
				_dmSupported = OVRPlugin.IsPerfMetricsSupported(OVRPlugin.PerfMetrics.App_GpuTime_Float);
				if (!_dmSupported)
				{
					_dmVerdict = "";
					return;
				}
				_dmAppCpuMs = ToMs(OVRPlugin.GetPerfMetricsFloat(OVRPlugin.PerfMetrics.App_CpuTime_Float));
				_dmAppGpuMs = ToMs(OVRPlugin.GetPerfMetricsFloat(OVRPlugin.PerfMetrics.App_GpuTime_Float));
				_dmCompCpuMs = ToMs(OVRPlugin.GetPerfMetricsFloat(OVRPlugin.PerfMetrics.Compositor_CpuTime_Float));
				_dmCompGpuMs = ToMs(OVRPlugin.GetPerfMetricsFloat(OVRPlugin.PerfMetrics.Compositor_GpuTime_Float));
				_dmGpuUtil = ToPercent(OVRPlugin.GetPerfMetricsFloat(OVRPlugin.PerfMetrics.System_GpuUtilPercentage_Float));
				_dmCpuUtil = ToPercent(OVRPlugin.GetPerfMetricsFloat(OVRPlugin.PerfMetrics.System_CpuUtilAveragePercentage_Float));
				_dmDropped = OVRPlugin.GetPerfMetricsInt(OVRPlugin.PerfMetrics.Compositor_DroppedFrameCount_Int) ?? (-1);
				_dmCpuLevel = OVRPlugin.GetPerfMetricsInt(OVRPlugin.PerfMetrics.Device_CpuClockLevel_Int) ?? (-1);
				_dmGpuLevel = OVRPlugin.GetPerfMetricsInt(OVRPlugin.PerfMetrics.Device_GpuClockLevel_Int) ?? (-1);
				float appFramerate = OVRPlugin.GetAppFramerate();
				appFramerate = ((appFramerate > 0f) ? appFramerate : 72f);
				float num = 1000f / Mathf.Max(appFramerate, 1f);
				float dmAppCpuMs = _dmAppCpuMs;
				float dmAppGpuMs = _dmAppGpuMs;
				if (Mathf.Max(dmAppCpuMs, dmAppGpuMs) <= num * 0.8f)
				{
					_dmVerdict = string.Format("HEADROOM  (budget {0:0.0} ms)", num);
				}
				else if (dmAppGpuMs > dmAppCpuMs * 1.15f)
				{
					_dmVerdict = string.Format("** GPU BOUND **  (budget {0:0.0} ms)", num);
				}
				else if (dmAppCpuMs > dmAppGpuMs * 1.15f)
				{
					_dmVerdict = string.Format("** CPU BOUND **  (budget {0:0.0} ms)", num);
				}
				else
				{
					_dmVerdict = string.Format("MIXED / both near budget {0:0.0} ms", num);
				}
			}
			catch (Exception)
			{
				_dmSupported = false;
				_dmVerdict = "";
			}
		}

		private void DrawDeviceBottleneck()
		{
			if (!_dmSupported)
			{
				ImGui.TextDisabled("DEVICE  metrics unavailable (Editor / Link — build to the headset)");
				return;
			}
			ImGui.Text("DEVICE " + _dmVerdict);
			ImGui.Text(string.Format("  app  cpu {0,6:0.00} ms   gpu {1,6:0.00} ms", _dmAppCpuMs, _dmAppGpuMs));
			ImGui.Text(string.Format("  comp cpu {0,6:0.00} ms   gpu {1,6:0.00} ms", _dmCompCpuMs, _dmCompGpuMs));
			ImGui.Text(string.Format("  util cpu {0,5:0.0}%    gpu {1,5:0.0}%", _dmCpuUtil, _dmGpuUtil));
			ImGui.Text(string.Format("  clock lvl cpu {0}  gpu {1}   dropped {2}", _dmCpuLevel, _dmGpuLevel, _dmDropped));
		}

		private void DrawLobbyCost()
		{
			StartPerfRecorders();
			if (Time.unscaledTime >= _lsNextRefresh)
			{
				_lsNextRefresh = Time.unscaledTime + LobbyStatsInterval;
				RefreshLobbyStats();
				RefreshDeviceMetrics();
			}
			int num = Mathf.Max(1, _lsPlayers);
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			ImGui.Text(string.Format("FRAME  {0:0.0} fps   {1:0.0} ms", 1f / Mathf.Max(unscaledDeltaTime, 0.0001f), unscaledDeltaTime * 1000f));
			DrawDeviceBottleneck();
			ImGui.Text(string.Format("ROOM   {0} in room · ", Photon.Pun.PhotonNetwork.CurrentRoom?.PlayerCount ?? 0) + string.Format("{0} player objects · {1} ms", _lsPlayers, Photon.Pun.PhotonNetwork.GetPing()));
			ImGui.Separator();
			ImGui.TextDisabled("                    total     per player");
			ImGui.Text(string.Format("Transforms      {0,9}   {1,8}", _lsTransforms, _lsTransforms / num));
			ImGui.Text(string.Format("Drawing rend.   {0,9}   {1,8}", _lsDrawing, _lsDrawing / num));
			ImGui.Text(string.Format("  of which skin {0,9}   {1,8}", _lsSkinned, _lsSkinned / num));
			ImGui.Text(string.Format("Ticking scripts {0,9}   {1,8}", _lsTicking, _lsTicking / num));
			ImGui.Separator();
			ImGui.Text("VOICE / AUDIO");
			ImGui.Text(string.Format("  spatialised (HRTF) {0,6}   <- the expensive one", _lsAudioSpatialized));
			ImGui.Text(string.Format("  playing            {0,6}", _lsAudioPlaying));
			ImGui.Text(string.Format("  enabled sources    {0,6}", _lsAudioTotal));
			ImGui.TextDisabled(string.Format("  real voice cap {0}", AudioSettings.GetConfiguration().numRealVoices) + string.Format(" · DSP buffer {0}", AudioSettings.GetConfiguration().dspBufferSize));
			ImGui.Separator();
			ImGui.Text(string.Format("COSMETICS   {0} drawing · {1} culled", _lsCosmeticOn, _lsCosmeticOff));
			ImGui.Separator();
			ImGui.Text("CROWD LOD   (players holding each tier)");
			ImGui.Text(string.Format("  body IK {0,3}   ", PlayerAnimationLOD.ActiveBody) + string.Format("deform {0,3}   ", PlayerAnimationLOD.ActiveDeform) + string.Format("face {0,3}", PlayerAnimationLOD.ActiveFace));
			ImGui.Text(string.Format("  fingers {0,3}   ", PlayerAnimationLOD.ActiveFingers) + string.Format("trinket {0,3}   ", PlayerAnimationLOD.ActiveTrinkets) + string.Format("names {0,3}", PlayerAnimationLOD.ActiveNameplates));
			ImGui.Separator();
			ImGui.Text("RENDER");
			ImGui.Text("  draw calls " + Rec(_recDrawCalls) + "   setpass " + Rec(_recSetPass));
			ImGui.Text("  tris " + Rec(_recTris) + "   verts " + Rec(_recVerts));
			if (!_recDrawCalls.Valid)
			{
				ImGui.TextDisabled("  (render counters need a Development Build)");
			}
			ImGui.Separator();
			ImGui.Text(string.Format("MEMORY  {0} MB managed", _lsGcMb));
			ImGui.Separator();
			ImGui.TextDisabled("Busiest per-frame scripts (live):");
			if (!string.IsNullOrEmpty(_lsTopScripts))
			{
				ImGui.Text(_lsTopScripts);
			}
			else
			{
				ImGui.TextDisabled("  (none)");
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Text("A/B  voice HRTF cap");
			ImGui.Text("  override: " + ((VoiceDistanceCuller.RuntimeHrtfOverride >= 0) ? VoiceDistanceCuller.RuntimeHrtfOverride.ToString() : "off (using prefab value)") + string.Format("   active: {0}", VoiceDistanceCuller.ActiveHrtfCount));
			if (ImGui.Button("0  (no HRTF)", new Vector2(120f, 26f)))
			{
				VoiceDistanceCuller.RuntimeHrtfOverride = 0;
			}
			ImGui.SameLine();
			if (ImGui.Button("4", new Vector2(60f, 26f)))
			{
				VoiceDistanceCuller.RuntimeHrtfOverride = 4;
			}
			ImGui.SameLine();
			if (ImGui.Button("8", new Vector2(60f, 26f)))
			{
				VoiceDistanceCuller.RuntimeHrtfOverride = 8;
			}
			ImGui.SameLine();
			if (ImGui.Button("16", new Vector2(60f, 26f)))
			{
				VoiceDistanceCuller.RuntimeHrtfOverride = 16;
			}
			ImGui.SameLine();
			if (ImGui.Button("All", new Vector2(60f, 26f)))
			{
				VoiceDistanceCuller.RuntimeHrtfOverride = 999;
			}
			ImGui.SameLine();
			if (ImGui.Button("Reset", new Vector2(80f, 26f)))
			{
				VoiceDistanceCuller.RuntimeHrtfOverride = -1;
			}
			ImGui.Text("A/B  room acoustics: " + (_acousticsOff ? "OFF (direct sound only)" : "on (project setting)"));
			if (ImGui.Button(_acousticsOff ? "Acoustics ON" : "Acoustics OFF", new Vector2(140f, 26f)))
			{
				_acousticsOff = !_acousticsOff;
				MetaXRAcousticNativeInterface.Interface.SetAcousticModel(_acousticsOff ? Meta.XR.Acoustics.AcousticModel.None : MetaXRAcousticSettings.Instance.AcousticModel);
			}
			bool forceLive = LethalApeR.Audio.AcousticMapSelector.ForceLive;
			ImGui.Text("A/B  baked acoustic maps: " + (forceLive ? "OFF (live ray tracing)" : "on"));
			if (ImGui.Button(forceLive ? "Baked maps ON" : "Baked maps OFF", new Vector2(140f, 26f)))
			{
				LethalApeR.Audio.AcousticMapSelector.ForceLive = !forceLive;
			}
			ImGui.Spacing();
			ImGui.Text("A/B  crowd LOD budgets");
			float runtimeBudgetScale = PlayerLodRank.RuntimeBudgetScale;
			ImGui.Text("  scale: " + ((runtimeBudgetScale == 0f) ? "OFF (distance only - the old behaviour)" : (runtimeBudgetScale.ToString("0.##") + "x")));
			if (ImGui.Button("Off", new Vector2(70f, 26f)))
			{
				PlayerLodRank.RuntimeBudgetScale = 0f;
			}
			ImGui.SameLine();
			if (ImGui.Button("0.5x", new Vector2(70f, 26f)))
			{
				PlayerLodRank.RuntimeBudgetScale = 0.5f;
			}
			ImGui.SameLine();
			if (ImGui.Button("1x", new Vector2(70f, 26f)))
			{
				PlayerLodRank.RuntimeBudgetScale = 1f;
			}
			ImGui.SameLine();
			if (ImGui.Button("2x", new Vector2(70f, 26f)))
			{
				PlayerLodRank.RuntimeBudgetScale = 2f;
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Text("A/B  render scale");
			float runtimeScaleOverride = LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride;
			ImGui.Text("  mode: " + ((runtimeScaleOverride > 0f) ? string.Format("forced {0:0.00}", runtimeScaleOverride) : "AUTO (dynamic resolution)") + string.Format("   viewport now: {0:0.00}", LethalApeR.Rendering.SlopRenderTuning.CurrentViewportScale));
			ImGui.Text(string.Format("  foveation supported: {0}", LethalApeR.Rendering.SlopRenderTuning.FoveationSupported));
			ImGui.TextDisabled("  " + LethalApeR.Rendering.SlopRenderTuning.LastStatus);
			float v = ((runtimeScaleOverride > 0f) ? runtimeScaleOverride : 1f);
			if (ImGui.SliderFloat("scale", ref v, 0.6f, 1f))
			{
				LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride = v;
			}
			if (ImGui.Button("Auto", new Vector2(70f, 26f)))
			{
				LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride = -1f;
			}
			ImGui.SameLine();
			if (ImGui.Button("1.0", new Vector2(60f, 26f)))
			{
				LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride = 1f;
			}
			ImGui.SameLine();
			if (ImGui.Button("0.9", new Vector2(60f, 26f)))
			{
				LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride = 0.9f;
			}
			ImGui.SameLine();
			if (ImGui.Button("0.8", new Vector2(60f, 26f)))
			{
				LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride = 0.8f;
			}
			ImGui.SameLine();
			if (ImGui.Button("0.7", new Vector2(60f, 26f)))
			{
				LethalApeR.Rendering.SlopRenderTuning.RuntimeScaleOverride = 0.7f;
			}
			ImGui.Spacing();
			ImGui.TextDisabled(string.Format("refreshes every {0:0.#}s", LobbyStatsInterval));
		}

		public bool Can(DevMenuCap cap)
		{
			if (Tier == DevMenuTier.None)
			{
				return false;
			}
			if (CapTier.TryGetValue(cap, out var value))
			{
				return Tier >= value;
			}
			return false;
		}

		public static DevMenuTier TierFor(DevMenuCap cap)
		{
			if (!CapTier.TryGetValue(cap, out var value))
			{
				return DevMenuTier.Admin;
			}
			return value;
		}

		private static Vector4 ThemeVariant(Vector4 c, float brightness)
		{
			return new Vector4(Mathf.Clamp01(c.x * brightness), Mathf.Clamp01(c.y * brightness), Mathf.Clamp01(c.z * brightness), c.w);
		}

		private void ApplyTheme()
		{
			ImGuiStylePtr style = ImGui.GetStyle();
			style.WindowPadding = new Vector2(10f, 8f);
			style.WindowRounding = 4f;
			style.WindowBorderSize = 1f;
			style.ChildRounding = 4f;
			style.ChildBorderSize = 1f;
			style.FramePadding = new Vector2(8f, 4f);
			style.FrameRounding = 4f;
			style.ItemSpacing = new Vector2(8f, 5f);
			style.ScrollbarSize = 16f;
			style.ScrollbarRounding = 4f;
			style.GrabMinSize = 14f;
			style.GrabRounding = 2f;
			_colSidebarBg = ThemeVariant(_colWindowBg, 1.45f);
			_colContentBg = _colWindowBg;
			RangeAccessor<Vector4> colors = style.Colors;
			Vector4 border = ThemeVariant(_colWindowBg, 2.6f);
			colors[2] = _colWindowBg;
			colors[3] = _colContentBg;
			colors[4] = _colSidebarBg;
			colors[5] = new Vector4(border.x, border.y, border.z, 1f);
			colors[6] = Vector4.zero;
			colors[0] = _colText;
			colors[1] = new Vector4(0.612f, 0.639f, 0.686f, 1f);
			colors[24] = _colHeader;
			colors[25] = _colHeaderHovered;
			colors[26] = _colHeaderActive;
			colors[21] = _colButton;
			colors[22] = _colButtonHovered;
			colors[23] = _colButtonActive;
			colors[7] = _colFrameBg;
			colors[8] = _colFrameBgHovered;
			colors[9] = _colFrameBgActive;
			colors[14] = ThemeVariant(_colWindowBg, 0.8f);
			colors[15] = ThemeVariant(_colWindowBg, 3.4f);
			colors[16] = ThemeVariant(_colWindowBg, 4.8f);
			colors[17] = new Vector4(_colAccent.x, _colAccent.y, _colAccent.z, 0.6f);
			colors[19] = _colSliderGrab;
			colors[20] = ThemeVariant(_colSliderGrab, 1.35f);
			colors[18] = _colCheckMark;
			colors[10] = _colTitleBg;
			colors[11] = _colTitleBgActive;
			colors[12] = ThemeVariant(_colTitleBg, 0.75f);
			colors[27] = new Vector4(border.x, border.y, border.z, 1f);
			colors[28] = new Vector4(_colAccent.x, _colAccent.y, _colAccent.z, 0.6f);
			colors[29] = new Vector4(_colAccent.x, _colAccent.y, _colAccent.z, 0.9f);
			colors[33] = _colTab;
			colors[34] = _colTabHovered;
			colors[35] = _colTabActive;
			colors[36] = ThemeVariant(_colTab, 0.8f);
			colors[37] = _colTitleBgActive;
			colors[40] = _colAccent;
			colors[42] = _colAccent;
		}

		private void DrawPage_Settings()
		{
			PageHeader("Settings", "Menu appearance, panel placement and notifications.");
			if (ImGui.BeginTabBar("##SettingsTabs"))
			{
				if (ImGui.BeginTabItem("Panel"))
				{
					DrawSettingsSub_Panel();
					ImGui.EndTabItem();
				}
				if (ImGui.BeginTabItem("Colors"))
				{
					DrawSettingsSub_Colors();
					ImGui.EndTabItem();
				}
				if (ImGui.BeginTabItem("Background"))
				{
					DrawSettingsSub_Background();
					ImGui.EndTabItem();
				}
				if (ImGui.BeginTabItem("Notifications"))
				{
					DrawSettingsSub_Notifications();
					ImGui.EndTabItem();
				}
				ImGui.EndTabBar();
			}
		}

		private void DrawSettingsSub_Panel()
		{
			ImGui.BeginChild("##scroll_panel", ImGui.GetContentRegionAvail(), ImGuiChildFlags.None, ImGuiWindowFlags.None);
			ImGui.Spacing();
			ImGui.TextDisabled("Bindings");
			ImGui.TextDisabled("  Thumbstick click  —  open / close the ImGui panel");
			ImGui.TextDisabled("  B + Y together    —  hide / show this menu");
			ImGui.TextDisabled("  Grip              —  grab players / place platforms (when enabled)");
			ImGui.TextDisabled("  Right trigger     —  fire the kick gun (when enabled)");
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			ImGui.TextDisabled("Panel Mode");
			ImGui.Spacing();
			bool v = _panelOnLeftHand;
			bool v2 = !_panelOnLeftHand;
			if (Checkbox("Left Hand", ref v) && v)
			{
				_panelOnLeftHand = true;
				ApplyPanelConfig();
			}
			Tip("Mounts the panel on your left hand — flip your wrist to check it.");
			ImGui.SameLine();
			if (Checkbox("Camera (floating)", ref v2) && v2)
			{
				_panelOnLeftHand = false;
				ApplyPanelConfig();
			}
			Tip("Keeps the panel floating in front of your view.");
			if (_panelOnLeftHand && LeftHand == null)
			{
				ImGui.TextColored(new Vector4(1f, 0.5f, 0.3f, 1f), "Waiting for the local player's left hand…");
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			ImGui.TextDisabled("UI Scale");
			if (SliderFloat("Scale##uiscale", ref _uiScale, 0.25f, 1.2f, "%.2f"))
			{
				ImGui.GetIO().FontGlobalScale = _uiScale;
			}
			Tip("Font scale for the whole panel. Below ~0.4 the text stops being readable through a headset lens.");
			ImGui.Spacing();
			ImGui.TextDisabled("Distance From Camera");
			if (SliderFloat("Distance##paneldist", ref _panelDistance, 0.4f, 3f, "%.2f m"))
			{
				UpdatePanelDistance();
			}
			Tip("Scaled by your player size so the panel stays the same apparent size when you shrink or grow.");
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			ImGui.TextDisabled("Position Offset");
			SliderFloat("X##pox", ref _panelPosOffset.x, -0.5f, 0.5f, "%.3f");
			bool flag = ImGui.IsItemDeactivatedAfterEdit();
			SliderFloat("Y##poy", ref _panelPosOffset.y, -0.5f, 0.5f, "%.3f");
			bool flag2 = ImGui.IsItemDeactivatedAfterEdit();
			SliderFloat("Z##poz", ref _panelPosOffset.z, -0.5f, 0.5f, "%.3f");
			bool flag3 = ImGui.IsItemDeactivatedAfterEdit();
			ImGui.Spacing();
			ImGui.TextDisabled("Rotation Offset (degrees)");
			SliderFloat("X##prx", ref _panelRotOffset.x, -180f, 180f, "%.1f");
			bool flag4 = ImGui.IsItemDeactivatedAfterEdit();
			SliderFloat("Y##pry", ref _panelRotOffset.y, -180f, 180f, "%.1f");
			bool flag5 = ImGui.IsItemDeactivatedAfterEdit();
			SliderFloat("Z##prz", ref _panelRotOffset.z, -180f, 180f, "%.1f");
			bool flag6 = ImGui.IsItemDeactivatedAfterEdit();
			ImGui.Spacing();
			ImGui.TextDisabled("Pointer Rotation Offset (degrees)");
			SliderFloat("X##prox", ref _pointerRotOffset.x, -180f, 180f, "%.1f");
			bool flag7 = ImGui.IsItemDeactivatedAfterEdit();
			SliderFloat("Y##proy", ref _pointerRotOffset.y, -180f, 180f, "%.1f");
			bool flag8 = ImGui.IsItemDeactivatedAfterEdit();
			SliderFloat("Z##proz", ref _pointerRotOffset.z, -180f, 180f, "%.1f");
			bool flag9 = ImGui.IsItemDeactivatedAfterEdit();
			if (flag | flag2 | flag3 | flag4 | flag5 | flag6 | flag7 | flag8 | flag9)
			{
				ApplyPanelConfig();
			}
			ImGui.Spacing();
			if (Btn("Reset Offsets", new Vector2(ImGui.GetContentRegionAvail().x * 0.5f, 26f)))
			{
				_panelPosOffset = new Vector3(0f, 0.05f, 0.1f);
				_panelRotOffset = new Vector3(80f, 0f, 180f);
				_pointerRotOffset = Vector3.zero;
				_panelDistance = 1.25f;
				ApplyPanelConfig();
				UpdatePanelDistance();
			}
			ImGui.SameLine();
			Btn("Save##panel", FullWidth(), SaveSettings);
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			ImGui.TextDisabled("VR Visuals");
			ImGui.Spacing();
			if (Checkbox("Ray Line (controller laser)", ref _vrShowRayLine))
			{
				ApplyVRVisuals();
			}
			Tip("The curved beam from your controller to the panel.");
			if (Checkbox("Manipulators (controller phantoms)", ref _vrShowManipulators))
			{
				ApplyVRVisuals();
			}
			Tip("The floating left/right controller models.");
			ImGui.EndChild();
		}

		private void ApplyVRVisuals()
		{
			if (_vrManipulator == null && _uimguiComponent != null)
			{
				_vrManipulator = _uimguiComponent._vrConfiguration?.vrManipulator;
			}
			if (_vrManipulator == null)
			{
				_vrManipulator = UnityEngine.Object.FindAnyObjectByType<ImguiVRManipulator>(FindObjectsInactive.Include);
			}
			if (!(_vrManipulator == null))
			{
				_vrManipulator.ShowRayLine = _vrShowRayLine;
				_vrManipulator.ShowManipulators = _vrShowManipulators;
			}
		}

		private WorldSpaceTransformerConfig GetWorldSpaceConfig()
		{
			if (!(_uimguiComponent != null))
			{
				return null;
			}
			return _uimguiComponent._vrConfiguration?.worldSpaceConfig;
		}

		private void ApplyPanelConfig()
		{
			WorldSpaceTransformerConfig worldSpaceConfig = GetWorldSpaceConfig();
			if (worldSpaceConfig != null)
			{
				Transform leftHand = LeftHand;
				worldSpaceConfig.panelFollowTransform = (_panelOnLeftHand ? leftHand : null);
				worldSpaceConfig.usePanelFollowTransformRotation = _panelOnLeftHand && leftHand != null;
				worldSpaceConfig.panelFollowPositionOffset = _panelPosOffset;
				worldSpaceConfig.panelFollowRotationOffsetEuler = _panelRotOffset;
				worldSpaceConfig.pointerRotationOffsetEuler = _pointerRotOffset;
			}
		}

		private void UpdatePanelDistance()
		{
			WorldSpaceTransformerConfig worldSpaceConfig = GetWorldSpaceConfig();
			if (worldSpaceConfig != null)
			{
				float num = ((GorillaLocomotion.Player.Instance != null) ? Mathf.Max(GorillaLocomotion.Player.Instance.CurrentScale, 0.05f) : 1f);
				worldSpaceConfig.distanceFromCamera = num * _panelDistance;
			}
		}

		private void DrawSettingsSub_Colors()
		{
			ImGui.Spacing();
			ImGui.TextDisabled("Presets");
			ImGui.Spacing();
			float x = (ImGui.GetContentRegionAvail().x - 12f) * 0.25f;
			for (int i = 0; i < PresetNames.Length; i++)
			{
				if (i % 4 != 0)
				{
					ImGui.SameLine(0f, 4f);
				}
				if (Btn($"{PresetNames[i]}##preset{i}", new Vector2(x, 24f)))
				{
					ApplyPreset(i);
					_themeDirty = true;
				}
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			Vector2 contentRegionAvail = ImGui.GetContentRegionAvail();
			ImGui.BeginChild("##color_scroll", new Vector2(contentRegionAvail.x, Mathf.Max(contentRegionAvail.y - 38f, 80f)), ImGuiChildFlags.None, ImGuiWindowFlags.None);
			float hw = (ImGui.GetContentRegionAvail().x - 8f) * 0.5f;
			bool changed = false;
			if (ImGui.CollapsingHeader("Accent", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				ColorSingle("Accent##acc", ref _colAccent);
				ImGui.TextDisabled("Drives the sidebar bar, separators, plots and the MOD badge.");
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Window", ImGuiTreeNodeFlags.DefaultOpen))
			{
				ImGui.Indent();
				ColorRow("Background##wbg", ref _colWindowBg, "Text##wtxt", ref _colText);
				ColorRow("Title Bar##tbg", ref _colTitleBg, "Title (Active)##tba", ref _colTitleBgActive);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Tabs"))
			{
				ImGui.Indent();
				ColorRow("Tab##tab", ref _colTab, "Tab Active##taba", ref _colTabActive);
				ColorSingle("Tab Hovered##tabh", ref _colTabHovered);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Headers / Collapsibles"))
			{
				ImGui.Indent();
				ColorRow("Header##hdr", ref _colHeader, "Hovered##hdrh", ref _colHeaderHovered);
				ColorSingle("Active##hdra", ref _colHeaderActive);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Buttons"))
			{
				ImGui.Indent();
				ColorRow("Button##btn", ref _colButton, "Hovered##btnh", ref _colButtonHovered);
				ColorSingle("Active##btna", ref _colButtonActive);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Frames (sliders / inputs)"))
			{
				ImGui.Indent();
				ColorRow("Frame##frm", ref _colFrameBg, "Hovered##frmh", ref _colFrameBgHovered);
				ColorSingle("Active##frma", ref _colFrameBgActive);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Accents (grab / check)"))
			{
				ImGui.Indent();
				ColorRow("Slider Grab##sg", ref _colSliderGrab, "Check Mark##ck", ref _colCheckMark);
				ImGui.Unindent();
			}
			ImGui.Spacing();
			Btn("Open ImGui Style Editor", FullWidth(24f), delegate
			{
				_showStyleEditor = true;
			});
			ImGui.EndChild();
			if (changed)
			{
				_themeDirty = true;
			}
			Btn("Save Colors", FullWidth(28f), SaveSettings);
			void ColorRow(string labelA, ref Vector4 colA, string labelB, ref Vector4 colB)
			{
				ImGui.SetNextItemWidth(hw);
				changed |= ImGui.ColorEdit4(labelA, ref colA, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
				ImGui.SameLine(0f, 8f);
				ImGui.SetNextItemWidth(hw);
				changed |= ImGui.ColorEdit4(labelB, ref colB, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
			}
			void ColorSingle(string label, ref Vector4 col)
			{
				ImGui.SetNextItemWidth(hw);
				changed |= ImGui.ColorEdit4(label, ref col, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
			}
		}

		private void ApplyPreset(int id)
		{
			switch (id)
			{
			case 0:
				_colAccent = new Vector4(0.231f, 0.51f, 0.965f, 1f);
				_colWindowBg = new Vector4(0.039f, 0.039f, 0.059f, 1f);
				_colTitleBg = new Vector4(0.031f, 0.031f, 0.047f, 1f);
				_colTitleBgActive = new Vector4(0.047f, 0.047f, 0.067f, 1f);
				_colTab = new Vector4(0.051f, 0.051f, 0.071f, 1f);
				_colTabHovered = new Vector4(0.231f, 0.51f, 0.965f, 0.4f);
				_colTabActive = new Vector4(0.231f, 0.51f, 0.965f, 0.28f);
				_colHeader = new Vector4(0.231f, 0.51f, 0.965f, 0.25f);
				_colHeaderHovered = new Vector4(0.231f, 0.51f, 0.965f, 0.35f);
				_colHeaderActive = new Vector4(0.231f, 0.51f, 0.965f, 0.45f);
				_colFrameBg = new Vector4(0.078f, 0.078f, 0.098f, 1f);
				_colFrameBgHovered = new Vector4(0.231f, 0.51f, 0.965f, 0.15f);
				_colFrameBgActive = new Vector4(0.231f, 0.51f, 0.965f, 0.25f);
				_colButton = new Vector4(0.231f, 0.51f, 0.965f, 0.7f);
				_colButtonHovered = new Vector4(0.318f, 0.584f, 0.976f, 0.8f);
				_colButtonActive = new Vector4(0.231f, 0.51f, 0.965f, 1f);
				_colSliderGrab = new Vector4(0.231f, 0.51f, 0.965f, 0.8f);
				_colCheckMark = new Vector4(0.231f, 0.51f, 0.965f, 1f);
				_colText = new Vector4(1f, 1f, 1f, 1f);
				break;
			case 1:
				_colAccent = new Vector4(0.7f, 0.7f, 0.7f, 1f);
				_colWindowBg = new Vector4(0.12f, 0.12f, 0.12f, 0.96f);
				_colTitleBg = new Vector4(0.18f, 0.18f, 0.18f, 1f);
				_colTitleBgActive = new Vector4(0.25f, 0.25f, 0.25f, 1f);
				_colTab = new Vector4(0.2f, 0.2f, 0.2f, 1f);
				_colTabHovered = new Vector4(0.35f, 0.35f, 0.35f, 1f);
				_colTabActive = new Vector4(0.3f, 0.3f, 0.3f, 1f);
				_colHeader = new Vector4(0.28f, 0.28f, 0.28f, 1f);
				_colHeaderHovered = new Vector4(0.38f, 0.38f, 0.38f, 1f);
				_colHeaderActive = new Vector4(0.45f, 0.45f, 0.45f, 1f);
				_colFrameBg = new Vector4(0.2f, 0.2f, 0.2f, 1f);
				_colFrameBgHovered = new Vector4(0.28f, 0.28f, 0.28f, 1f);
				_colFrameBgActive = new Vector4(0.35f, 0.35f, 0.35f, 1f);
				_colButton = new Vector4(0.24f, 0.24f, 0.24f, 1f);
				_colButtonHovered = new Vector4(0.34f, 0.34f, 0.34f, 1f);
				_colButtonActive = new Vector4(0.45f, 0.45f, 0.45f, 1f);
				_colSliderGrab = new Vector4(0.55f, 0.55f, 0.55f, 1f);
				_colCheckMark = new Vector4(0.85f, 0.85f, 0.85f, 1f);
				_colText = new Vector4(1f, 1f, 1f, 1f);
				break;
			case 2:
				_colAccent = new Vector4(0.35f, 0.55f, 0.9f, 1f);
				_colWindowBg = new Vector4(0.08f, 0.1f, 0.16f, 0.96f);
				_colTitleBg = new Vector4(0.12f, 0.16f, 0.28f, 1f);
				_colTitleBgActive = new Vector4(0.18f, 0.24f, 0.42f, 1f);
				_colTab = new Vector4(0.14f, 0.18f, 0.3f, 1f);
				_colTabHovered = new Vector4(0.25f, 0.35f, 0.6f, 1f);
				_colTabActive = new Vector4(0.2f, 0.28f, 0.5f, 1f);
				_colHeader = new Vector4(0.16f, 0.22f, 0.38f, 1f);
				_colHeaderHovered = new Vector4(0.22f, 0.32f, 0.55f, 1f);
				_colHeaderActive = new Vector4(0.28f, 0.4f, 0.68f, 1f);
				_colFrameBg = new Vector4(0.12f, 0.16f, 0.26f, 1f);
				_colFrameBgHovered = new Vector4(0.16f, 0.22f, 0.36f, 1f);
				_colFrameBgActive = new Vector4(0.22f, 0.3f, 0.48f, 1f);
				_colButton = new Vector4(0.16f, 0.2f, 0.34f, 1f);
				_colButtonHovered = new Vector4(0.22f, 0.3f, 0.52f, 1f);
				_colButtonActive = new Vector4(0.28f, 0.38f, 0.65f, 1f);
				_colSliderGrab = new Vector4(0.35f, 0.55f, 0.9f, 1f);
				_colCheckMark = new Vector4(0.6f, 0.8f, 1f, 1f);
				_colText = new Vector4(0.9f, 0.95f, 1f, 1f);
				break;
			case 3:
				_colAccent = new Vector4(0.9f, 0.3f, 0.3f, 1f);
				_colWindowBg = new Vector4(0.12f, 0.08f, 0.08f, 0.96f);
				_colTitleBg = new Vector4(0.22f, 0.1f, 0.1f, 1f);
				_colTitleBgActive = new Vector4(0.35f, 0.15f, 0.15f, 1f);
				_colTab = new Vector4(0.24f, 0.12f, 0.12f, 1f);
				_colTabHovered = new Vector4(0.5f, 0.18f, 0.18f, 1f);
				_colTabActive = new Vector4(0.4f, 0.15f, 0.15f, 1f);
				_colHeader = new Vector4(0.28f, 0.14f, 0.14f, 1f);
				_colHeaderHovered = new Vector4(0.45f, 0.18f, 0.18f, 1f);
				_colHeaderActive = new Vector4(0.58f, 0.22f, 0.22f, 1f);
				_colFrameBg = new Vector4(0.18f, 0.1f, 0.1f, 1f);
				_colFrameBgHovered = new Vector4(0.26f, 0.13f, 0.13f, 1f);
				_colFrameBgActive = new Vector4(0.35f, 0.18f, 0.18f, 1f);
				_colButton = new Vector4(0.26f, 0.12f, 0.12f, 1f);
				_colButtonHovered = new Vector4(0.42f, 0.16f, 0.16f, 1f);
				_colButtonActive = new Vector4(0.55f, 0.2f, 0.2f, 1f);
				_colSliderGrab = new Vector4(0.9f, 0.3f, 0.3f, 1f);
				_colCheckMark = new Vector4(1f, 0.6f, 0.6f, 1f);
				_colText = new Vector4(1f, 0.92f, 0.92f, 1f);
				break;
			case 4:
				_colAccent = new Vector4(0.3f, 0.75f, 0.45f, 1f);
				_colWindowBg = new Vector4(0.08f, 0.12f, 0.1f, 0.96f);
				_colTitleBg = new Vector4(0.1f, 0.2f, 0.14f, 1f);
				_colTitleBgActive = new Vector4(0.14f, 0.3f, 0.2f, 1f);
				_colTab = new Vector4(0.12f, 0.22f, 0.16f, 1f);
				_colTabHovered = new Vector4(0.18f, 0.42f, 0.28f, 1f);
				_colTabActive = new Vector4(0.15f, 0.35f, 0.23f, 1f);
				_colHeader = new Vector4(0.12f, 0.25f, 0.18f, 1f);
				_colHeaderHovered = new Vector4(0.16f, 0.38f, 0.26f, 1f);
				_colHeaderActive = new Vector4(0.2f, 0.48f, 0.32f, 1f);
				_colFrameBg = new Vector4(0.1f, 0.18f, 0.13f, 1f);
				_colFrameBgHovered = new Vector4(0.13f, 0.25f, 0.18f, 1f);
				_colFrameBgActive = new Vector4(0.18f, 0.34f, 0.24f, 1f);
				_colButton = new Vector4(0.12f, 0.22f, 0.16f, 1f);
				_colButtonHovered = new Vector4(0.17f, 0.35f, 0.24f, 1f);
				_colButtonActive = new Vector4(0.22f, 0.45f, 0.3f, 1f);
				_colSliderGrab = new Vector4(0.3f, 0.75f, 0.45f, 1f);
				_colCheckMark = new Vector4(0.55f, 0.95f, 0.65f, 1f);
				_colText = new Vector4(0.92f, 1f, 0.94f, 1f);
				break;
			case 5:
				_colAccent = new Vector4(0.7f, 0.4f, 1f, 1f);
				_colWindowBg = new Vector4(0.1f, 0.08f, 0.14f, 0.96f);
				_colTitleBg = new Vector4(0.18f, 0.12f, 0.28f, 1f);
				_colTitleBgActive = new Vector4(0.28f, 0.18f, 0.42f, 1f);
				_colTab = new Vector4(0.2f, 0.14f, 0.3f, 1f);
				_colTabHovered = new Vector4(0.38f, 0.22f, 0.6f, 1f);
				_colTabActive = new Vector4(0.3f, 0.18f, 0.5f, 1f);
				_colHeader = new Vector4(0.22f, 0.14f, 0.34f, 1f);
				_colHeaderHovered = new Vector4(0.35f, 0.2f, 0.55f, 1f);
				_colHeaderActive = new Vector4(0.45f, 0.26f, 0.68f, 1f);
				_colFrameBg = new Vector4(0.16f, 0.1f, 0.24f, 1f);
				_colFrameBgHovered = new Vector4(0.22f, 0.14f, 0.33f, 1f);
				_colFrameBgActive = new Vector4(0.3f, 0.18f, 0.44f, 1f);
				_colButton = new Vector4(0.2f, 0.13f, 0.3f, 1f);
				_colButtonHovered = new Vector4(0.32f, 0.2f, 0.5f, 1f);
				_colButtonActive = new Vector4(0.42f, 0.26f, 0.65f, 1f);
				_colSliderGrab = new Vector4(0.7f, 0.4f, 1f, 1f);
				_colCheckMark = new Vector4(0.9f, 0.65f, 1f, 1f);
				_colText = new Vector4(0.96f, 0.92f, 1f, 1f);
				break;
			case 6:
				_colAccent = new Vector4(0.95f, 0.72f, 0.2f, 1f);
				_colWindowBg = new Vector4(0.12f, 0.1f, 0.06f, 0.96f);
				_colTitleBg = new Vector4(0.22f, 0.16f, 0.06f, 1f);
				_colTitleBgActive = new Vector4(0.35f, 0.26f, 0.08f, 1f);
				_colTab = new Vector4(0.24f, 0.18f, 0.08f, 1f);
				_colTabHovered = new Vector4(0.5f, 0.36f, 0.1f, 1f);
				_colTabActive = new Vector4(0.4f, 0.28f, 0.08f, 1f);
				_colHeader = new Vector4(0.28f, 0.2f, 0.08f, 1f);
				_colHeaderHovered = new Vector4(0.45f, 0.32f, 0.1f, 1f);
				_colHeaderActive = new Vector4(0.58f, 0.42f, 0.12f, 1f);
				_colFrameBg = new Vector4(0.18f, 0.13f, 0.05f, 1f);
				_colFrameBgHovered = new Vector4(0.26f, 0.19f, 0.07f, 1f);
				_colFrameBgActive = new Vector4(0.35f, 0.25f, 0.08f, 1f);
				_colButton = new Vector4(0.26f, 0.18f, 0.06f, 1f);
				_colButtonHovered = new Vector4(0.45f, 0.3f, 0.08f, 1f);
				_colButtonActive = new Vector4(0.58f, 0.4f, 0.1f, 1f);
				_colSliderGrab = new Vector4(0.95f, 0.72f, 0.2f, 1f);
				_colCheckMark = new Vector4(1f, 0.88f, 0.4f, 1f);
				_colText = new Vector4(1f, 0.97f, 0.88f, 1f);
				break;
			}
		}

		private void DrawSettingsSub_Background()
		{
			Vector2 contentRegionAvail = ImGui.GetContentRegionAvail();
			float x = contentRegionAvail.x * 0.5f - 4f;
			float y = Mathf.Max(contentRegionAvail.y - 38f, 80f);
			ImGui.BeginChild("##bg_controls", new Vector2(x, y), ImGuiChildFlags.None, ImGuiWindowFlags.None);
			ImGui.TextColored(new Vector4(1f, 0.75f, 0.35f, 1f), "Both effects are pure fill cost.");
			ImGui.TextDisabled("Leave them off if you're profiling.");
			ImGui.Spacing();
			Checkbox("Background Particles", ref _enableBackgroundParticles);
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Particle Settings"))
			{
				ImGui.Indent();
				ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
				SliderInt("##pcount", ref _particleCount, 10, 120, "Amount: %d");
				Tip($"Linking is O(n²) — {_particleCount} particles is " + $"{_particleCount * (_particleCount - 1) / 2} distance tests per frame.");
				ImGui.Spacing();
				SliderFloat("Dot Size##pdot", ref _particleDotSize, 0.5f, 6f, "%.1f");
				SliderFloat("Line Thickness##pline", ref _particleLineThickness, 0.5f, 4f, "%.1f");
				SliderFloat("Particle Link Dist##pdist", ref _particleInteractDist, 10f, 200f, "%.0f");
				SliderFloat("Cursor Link Dist##cdist", ref _cursorInteractDist, 10f, 200f, "%.0f");
				ImGui.Spacing();
				ImGui.ColorEdit4("Dot Color##dotcol", ref _particleDotColor, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
				ImGui.ColorEdit4("Line Color##linecol", ref _particleLineColor, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
				ImGui.ColorEdit4("Cursor Line##curcol", ref _cursorLineColor, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
				ImGui.Spacing();
				Btn("Reset Particles", FullWidth(24f), delegate
				{
					_particleCount = 60;
					_particleDotSize = 1.5f;
					_particleLineThickness = 1f;
					_particleInteractDist = 55f;
					_cursorInteractDist = 52f;
					_particleDotColor = new Vector4(1f, 1f, 1f, 0.6f);
					_particleLineColor = new Vector4(1f, 1f, 1f, 1f);
					_cursorLineColor = new Vector4(1f, 1f, 1f, 1f);
					_particlesInitialized = false;
					_previewInitialized = false;
				});
				ImGui.Unindent();
			}
			ImGui.Spacing();
			Checkbox("Spiral Vortex", ref _spiralEnabled);
			ImGui.Spacing();
			if (ImGui.CollapsingHeader("Spiral Settings"))
			{
				ImGui.Indent();
				ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
				SliderInt("##sparms", ref _spiralArmCount, 1, 8, "Arms: %d");
				ImGui.SetNextItemWidth(ImGui.GetContentRegionAvail().x);
				SliderInt("##sppts", ref _spiralParticlesPerArm, 20, 300, "Particles/Arm: %d");
				ImGui.TextDisabled($"{SpiralDrawCost} filled circles per frame.");
				SliderFloat("Speed##spspd", ref _spiralSpeed, 0.02f, 3f, "%.2f");
				SliderFloat("Tightness##sptight", ref _spiralTightness, 0.5f, 8f, "%.1f");
				SliderFloat("Radius##sprad", ref _spiralRadiusScale, 0.2f, 2f, "%.2f");
				SliderFloat("Dot Size##spdot", ref _spiralDotSize, 0.5f, 6f, "%.1f");
				ImGui.Spacing();
				ImGui.ColorEdit4("Inner Color##spinC", ref _spiralInnerColor, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
				ImGui.ColorEdit4("Outer Color##spoutC", ref _spiralOuterColor, ImGuiColorEditFlags.NoInputs | ImGuiColorEditFlags.AlphaBar);
				RegisterHover();
				ImGui.Spacing();
				Btn("Reset Spiral##spreset", FullWidth(24f), delegate
				{
					_spiralArmCount = 3;
					_spiralParticlesPerArm = 100;
					_spiralSpeed = 0.25f;
					_spiralTightness = 2.5f;
					_spiralRadiusScale = 1f;
					_spiralDotSize = 2f;
					_spiralInnerColor = new Vector4(0.55f, 0.8f, 1f, 1f);
					_spiralOuterColor = new Vector4(0.15f, 0.25f, 0.7f, 0f);
				});
				ImGui.Unindent();
			}
			ImGui.EndChild();
			ImGui.SameLine();
			ImGui.BeginChild("##bg_preview", new Vector2(x, y), ImGuiChildFlags.Border, ImGuiWindowFlags.NoScrollbar);
			ImGui.TextDisabled("Live Preview");
			Vector2 cursorScreenPos = ImGui.GetCursorScreenPos();
			Vector2 contentRegionAvail2 = ImGui.GetContentRegionAvail();
			ImDrawListPtr windowDrawList = ImGui.GetWindowDrawList();
			windowDrawList.AddRectFilled(cursorScreenPos, cursorScreenPos + contentRegionAvail2, ImGui.GetColorU32(new Vector4(0.08f, 0.08f, 0.1f, 1f)));
			if (_enableBackgroundParticles)
			{
				DrawParticlePreview(cursorScreenPos, contentRegionAvail2, windowDrawList);
			}
			if (_spiralEnabled)
			{
				DrawSpiralToList(windowDrawList, cursorScreenPos, contentRegionAvail2);
			}
			ImGui.EndChild();
			ImGui.Spacing();
			Btn("Save Changes", FullWidth(28f), SaveSettings);
		}

		private void DrawSettingsSub_Notifications()
		{
			ImGui.BeginChild("##scroll_notif", ImGui.GetContentRegionAvail(), ImGuiChildFlags.None, ImGuiWindowFlags.None);
			ImGui.Spacing();
			ImGui.TextDisabled("Player Join / Leave");
			ModToggle("Show Toast##notifvis", ref _notifVisualEnabled, "On-screen popup when someone joins or leaves the room.");
			Checkbox("Play Sound##notifsnd", ref _notifSoundEnabled);
			ImGui.Spacing();
			ImGui.TextDisabled("Errors / Exceptions");
			ModToggle("Show Toast##errorvis", ref _errorVisualEnabled, "On-screen popup when Unity logs an error or exception. Rate-limited to one every 2 seconds, and repeats collapse into a counter.");
			Checkbox("Play Sound##errorsnd", ref _errorSoundEnabled);
			ImGui.Spacing();
			if (Btn("Test Toasts", FullWidth(24f)))
			{
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Info, "Info", "This is an info toast.");
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "Success", "This is a success toast.");
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Warning, "Warning", "This is a warning toast.");
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Error, "Error", "This is an error toast.");
			}
			ImGui.Spacing();
			Btn("Save Changes##notif", FullWidth(28f), SaveSettings);
			ImGui.EndChild();
		}

		private void LoadSettings()
		{
			_enableBackgroundParticles = PlayerPrefs.GetInt("LA_BackgroundParticles", 0) == 1;
			_particleCount = Mathf.Clamp(PlayerPrefs.GetInt("LA_ParticleCount", 60), 10, 120);
			_particleDotSize = PlayerPrefs.GetFloat("LA_ParticleDotSize", 1.5f);
			_particleLineThickness = PlayerPrefs.GetFloat("LA_ParticleLineThick", 1f);
			_particleInteractDist = PlayerPrefs.GetFloat("LA_ParticleInteract", 55f);
			_cursorInteractDist = PlayerPrefs.GetFloat("LA_CursorInteract", 52f);
			_particleDotColor = LoadColor("LA_DotColor", _particleDotColor);
			_particleLineColor = LoadColor("LA_LineColor", _particleLineColor);
			_cursorLineColor = LoadColor("LA_CursorColor", _cursorLineColor);
			_spiralEnabled = PlayerPrefs.GetInt("LA_SpEnabled", 0) == 1;
			_spiralArmCount = PlayerPrefs.GetInt("LA_SpArms", 3);
			_spiralParticlesPerArm = PlayerPrefs.GetInt("LA_SpPts", 100);
			_spiralSpeed = PlayerPrefs.GetFloat("LA_SpSpeed", 0.25f);
			_spiralTightness = PlayerPrefs.GetFloat("LA_SpTight", 2.5f);
			_spiralRadiusScale = PlayerPrefs.GetFloat("LA_SpRad", 1f);
			_spiralDotSize = PlayerPrefs.GetFloat("LA_SpDot", 2f);
			_spiralInnerColor = LoadColor("LA_SpInner", _spiralInnerColor);
			_spiralOuterColor = LoadColor("LA_SpOuter", _spiralOuterColor);
			_colAccent = LoadColor("LA_TC_Acc", _colAccent);
			_colWindowBg = LoadColor("LA_TC_WBg", _colWindowBg);
			_colText = LoadColor("LA_TC_Txt", _colText);
			_colTitleBg = LoadColor("LA_TC_TBg", _colTitleBg);
			_colTitleBgActive = LoadColor("LA_TC_TBgA", _colTitleBgActive);
			_colTab = LoadColor("LA_TC_Tab", _colTab);
			_colTabHovered = LoadColor("LA_TC_TabH", _colTabHovered);
			_colTabActive = LoadColor("LA_TC_TabA", _colTabActive);
			_colHeader = LoadColor("LA_TC_Hdr", _colHeader);
			_colHeaderHovered = LoadColor("LA_TC_HdrH", _colHeaderHovered);
			_colHeaderActive = LoadColor("LA_TC_HdrA", _colHeaderActive);
			_colFrameBg = LoadColor("LA_TC_Frm", _colFrameBg);
			_colFrameBgHovered = LoadColor("LA_TC_FrmH", _colFrameBgHovered);
			_colFrameBgActive = LoadColor("LA_TC_FrmA", _colFrameBgActive);
			_colButton = LoadColor("LA_TC_Btn", _colButton);
			_colButtonHovered = LoadColor("LA_TC_BtnH", _colButtonHovered);
			_colButtonActive = LoadColor("LA_TC_BtnA", _colButtonActive);
			_colSliderGrab = LoadColor("LA_TC_Sldr", _colSliderGrab);
			_colCheckMark = LoadColor("LA_TC_Chk", _colCheckMark);
			_notifSoundEnabled = PlayerPrefs.GetInt("LA_NotifSound", 1) == 1;
			_errorSoundEnabled = PlayerPrefs.GetInt("LA_ErrorSound", 1) == 1;
			_notifVisualEnabled = PlayerPrefs.GetInt("LA_NotifVisual", 1) == 1;
			_errorVisualEnabled = PlayerPrefs.GetInt("LA_ErrorVisual", 1) == 1;
			_panelOnLeftHand = PlayerPrefs.GetInt("LA_PanelOnHand", 0) == 1;
			_vrShowRayLine = PlayerPrefs.GetInt("LA_VR_RayLine", 0) == 1;
			_vrShowManipulators = PlayerPrefs.GetInt("LA_VR_Manipulators", 0) == 1;
			_uiScale = PlayerPrefs.GetFloat("LA_UIScale", 0.65f);
			_panelDistance = PlayerPrefs.GetFloat("LA_PanelDist", 1.25f);
			_pointerRotOffset = new Vector3(PlayerPrefs.GetFloat("LA_PtrRotX", 0f), PlayerPrefs.GetFloat("LA_PtrRotY", 0f), PlayerPrefs.GetFloat("LA_PtrRotZ", 0f));
			_panelPosOffset = new Vector3(PlayerPrefs.GetFloat("LA_PanelPosX", 0f), PlayerPrefs.GetFloat("LA_PanelPosY", 0.05f), PlayerPrefs.GetFloat("LA_PanelPosZ", 0.1f));
			_panelRotOffset = new Vector3(PlayerPrefs.GetFloat("LA_PanelRotX", 80f), PlayerPrefs.GetFloat("LA_PanelRotY", 0f), PlayerPrefs.GetFloat("LA_PanelRotZ", 180f));
			_showSpamButton = PlayerPrefs.GetInt("LA_ShowSpamButton", 0) == 1;
			_disableSpawnLimit = PlayerPrefs.GetInt("LA_DisableSpawnLimit", 0) == 1;
			_spawnLimit = PlayerPrefs.GetInt("LA_SpawnLimit", 10);
			_spawnCooldown = PlayerPrefs.GetFloat("LA_SpawnCooldown", 1f);
			LoadBookmarks();
		}

		private void SaveSettings()
		{
			PlayerPrefs.SetInt("LA_BackgroundParticles", _enableBackgroundParticles ? 1 : 0);
			PlayerPrefs.SetInt("LA_ParticleCount", _particleCount);
			PlayerPrefs.SetFloat("LA_ParticleDotSize", _particleDotSize);
			PlayerPrefs.SetFloat("LA_ParticleLineThick", _particleLineThickness);
			PlayerPrefs.SetFloat("LA_ParticleInteract", _particleInteractDist);
			PlayerPrefs.SetFloat("LA_CursorInteract", _cursorInteractDist);
			SaveColor("LA_DotColor", _particleDotColor);
			SaveColor("LA_LineColor", _particleLineColor);
			SaveColor("LA_CursorColor", _cursorLineColor);
			PlayerPrefs.SetInt("LA_SpEnabled", _spiralEnabled ? 1 : 0);
			PlayerPrefs.SetInt("LA_SpArms", _spiralArmCount);
			PlayerPrefs.SetInt("LA_SpPts", _spiralParticlesPerArm);
			PlayerPrefs.SetFloat("LA_SpSpeed", _spiralSpeed);
			PlayerPrefs.SetFloat("LA_SpTight", _spiralTightness);
			PlayerPrefs.SetFloat("LA_SpRad", _spiralRadiusScale);
			PlayerPrefs.SetFloat("LA_SpDot", _spiralDotSize);
			SaveColor("LA_SpInner", _spiralInnerColor);
			SaveColor("LA_SpOuter", _spiralOuterColor);
			SaveColor("LA_TC_Acc", _colAccent);
			SaveColor("LA_TC_WBg", _colWindowBg);
			SaveColor("LA_TC_Txt", _colText);
			SaveColor("LA_TC_TBg", _colTitleBg);
			SaveColor("LA_TC_TBgA", _colTitleBgActive);
			SaveColor("LA_TC_Tab", _colTab);
			SaveColor("LA_TC_TabH", _colTabHovered);
			SaveColor("LA_TC_TabA", _colTabActive);
			SaveColor("LA_TC_Hdr", _colHeader);
			SaveColor("LA_TC_HdrH", _colHeaderHovered);
			SaveColor("LA_TC_HdrA", _colHeaderActive);
			SaveColor("LA_TC_Frm", _colFrameBg);
			SaveColor("LA_TC_FrmH", _colFrameBgHovered);
			SaveColor("LA_TC_FrmA", _colFrameBgActive);
			SaveColor("LA_TC_Btn", _colButton);
			SaveColor("LA_TC_BtnH", _colButtonHovered);
			SaveColor("LA_TC_BtnA", _colButtonActive);
			SaveColor("LA_TC_Sldr", _colSliderGrab);
			SaveColor("LA_TC_Chk", _colCheckMark);
			PlayerPrefs.SetInt("LA_NotifSound", _notifSoundEnabled ? 1 : 0);
			PlayerPrefs.SetInt("LA_ErrorSound", _errorSoundEnabled ? 1 : 0);
			PlayerPrefs.SetInt("LA_NotifVisual", _notifVisualEnabled ? 1 : 0);
			PlayerPrefs.SetInt("LA_ErrorVisual", _errorVisualEnabled ? 1 : 0);
			PlayerPrefs.SetInt("LA_PanelOnHand", _panelOnLeftHand ? 1 : 0);
			PlayerPrefs.SetInt("LA_VR_RayLine", _vrShowRayLine ? 1 : 0);
			PlayerPrefs.SetInt("LA_VR_Manipulators", _vrShowManipulators ? 1 : 0);
			PlayerPrefs.SetFloat("LA_UIScale", _uiScale);
			PlayerPrefs.SetFloat("LA_PanelDist", _panelDistance);
			PlayerPrefs.SetFloat("LA_PtrRotX", _pointerRotOffset.x);
			PlayerPrefs.SetFloat("LA_PtrRotY", _pointerRotOffset.y);
			PlayerPrefs.SetFloat("LA_PtrRotZ", _pointerRotOffset.z);
			PlayerPrefs.SetFloat("LA_PanelPosX", _panelPosOffset.x);
			PlayerPrefs.SetFloat("LA_PanelPosY", _panelPosOffset.y);
			PlayerPrefs.SetFloat("LA_PanelPosZ", _panelPosOffset.z);
			PlayerPrefs.SetFloat("LA_PanelRotX", _panelRotOffset.x);
			PlayerPrefs.SetFloat("LA_PanelRotY", _panelRotOffset.y);
			PlayerPrefs.SetFloat("LA_PanelRotZ", _panelRotOffset.z);
			PlayerPrefs.SetInt("LA_ShowSpamButton", _showSpamButton ? 1 : 0);
			PlayerPrefs.SetInt("LA_DisableSpawnLimit", _disableSpawnLimit ? 1 : 0);
			PlayerPrefs.SetInt("LA_SpawnLimit", _spawnLimit);
			PlayerPrefs.SetFloat("LA_SpawnCooldown", _spawnCooldown);
			PlayerPrefs.Save();
			_themeDirty = true;
			ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "Settings Saved", null, 2f);
		}

		private static void SaveColor(string key, Vector4 c)
		{
			PlayerPrefs.SetFloat(key + "_R", c.x);
			PlayerPrefs.SetFloat(key + "_G", c.y);
			PlayerPrefs.SetFloat(key + "_B", c.z);
			PlayerPrefs.SetFloat(key + "_A", c.w);
		}

		private static Vector4 LoadColor(string key, Vector4 fallback)
		{
			if (!PlayerPrefs.HasKey(key + "_R"))
			{
				return fallback;
			}
			return new Vector4(PlayerPrefs.GetFloat(key + "_R", fallback.x), PlayerPrefs.GetFloat(key + "_G", fallback.y), PlayerPrefs.GetFloat(key + "_B", fallback.z), PlayerPrefs.GetFloat(key + "_A", fallback.w));
		}

		private void SaveBookmarks()
		{
			PlayerPrefs.SetString("LA_TpBookmarks", JsonUtility.ToJson(new TpBookmarkList
			{
				Items = _tpBookmarks
			}));
			PlayerPrefs.Save();
		}

		private void LoadBookmarks()
		{
			_tpBookmarks.Clear();
			string json = PlayerPrefs.GetString("LA_TpBookmarks", "");
			if (string.IsNullOrEmpty(json))
			{
				return;
			}
			try
			{
				TpBookmarkList list = JsonUtility.FromJson<TpBookmarkList>(json);
				if (list != null && list.Items != null)
				{
					_tpBookmarks.AddRange(list.Items);
				}
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[DevMenu] Could not parse saved bookmarks: " + ex.Message);
			}
		}

		private void Awake()
		{
			StartGameLogListener();
		}

		private void OnEnable()
		{
			HookCallbacks();
			StartGameLogListener();
			PrepareAudioSources();
			LocateImGuiHost();
			_fpsHistory = new float[FPSHistorySize];
			_localUsernameBuffer = Photon.Pun.PhotonNetwork.LocalPlayer?.NickName ?? "";
			_originalGravity = Physics.gravity;
			LoadSettings();
			_themeDirty = true;
			ApplyVRVisuals();
			ApplyPanelConfig();
			RefreshTeleportPoints();
			SeedFromLocalPlayer();
		}

		private void OnDisable()
		{
			UnhookCallbacks();
			if (_useCustomGravity)
			{
				Physics.gravity = _originalGravity;
			}
			RestoreAllMods();
			ClearEsp();
			ReleaseSpyResources();
			DestroyKickGunVisuals();
			ImAnim.Reset();
			ImGuiNotify.Clear();
		}

		private void OnDestroy()
		{
			StopGameLogListener();
			StopPerfRecorders();
		}

		private void HookCallbacks()
		{
			UImGuiUtility.Layout += OnLayout;
			Application.logMessageReceived += OnUnityLogMessage;
			SceneManager.sceneLoaded += OnSceneLoaded;
			Photon.Pun.PhotonNetwork.AddCallbackTarget(this);
		}

		private void UnhookCallbacks()
		{
			UImGuiUtility.Layout -= OnLayout;
			Application.logMessageReceived -= OnUnityLogMessage;
			SceneManager.sceneLoaded -= OnSceneLoaded;
			Photon.Pun.PhotonNetwork.RemoveCallbackTarget(this);
		}

		private void PrepareAudioSources()
		{
			if (audioSource == null && !TryGetComponent(out audioSource))
			{
				audioSource = base.gameObject.AddComponent<AudioSource>();
			}
			ConfigureUiAudioSource(audioSource);
			EnsureSoundboardSource();
		}

		private void LocateImGuiHost()
		{
			if (!(_uimguiComponent != null))
			{
				_uimguiComponent = UnityEngine.Object.FindAnyObjectByType<global::UImGui.UImGui>(FindObjectsInactive.Include);
				if (_uimguiComponent == null)
				{
					Debug.LogWarning("[DevMenu] No UImGui component found — VR panel settings will be inert.");
				}
			}
		}

		private void SeedFromLocalPlayer()
		{
			GorillaLocomotion.Player player = GorillaLocomotion.Player.Instance;
			if (!(player == null))
			{
				_previousJumpMultiplier = player.jumpMultiplier;
				_customJump = player.jumpMultiplier;
				_previousCustomSize = player.targetScale;
				_customSize = player.targetScale;
				StoreOriginalValues();
			}
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			_handsResolved = false;
			RefreshTeleportPoints();
			ClearEsp();
		}

		private void Update()
		{
			HandleToggleInput();
			if (!_originalsStored)
			{
				StoreOriginalValues();
			}
			ResolveHandTransforms();
			Handle_DevMods();
			Handle_GameMods();
			Handle_GhostMonkey();
			Handle_GrabPlayers();
			Handle_SpamSpawn();
			HandleKickGun();
			Handle_Esp();
			UpdatePanelDistance();
		}

		private void FixedUpdate()
		{
			Handle_Flight();
		}

		private void HandleToggleInput()
		{
			if (In.RightPrimaryButton && In.RightSecondaryButton)
			{
				bool wasDown = _prevToggleButton;
				_prevToggleButton = true;
				if (!wasDown)
				{
					_visible = !_visible;
					SendMenuHaptic(0.25f, 0.04f);
				}
			}
			else
			{
				_prevToggleButton = false;
			}
			if (DesktopToggleKeyDown())
			{
				_visible = !_visible;
			}
		}

		private static bool DesktopToggleKeyDown()
		{
			UnityEngine.InputSystem.Keyboard keyboard = UnityEngine.InputSystem.Keyboard.current;
			if (keyboard == null)
			{
				return false;
			}
			return keyboard[UnityEngine.InputSystem.Key.Tab].wasPressedThisFrame;
		}

		private void OnLayout(global::UImGui.UImGui _)
		{
			ImAnim.NewFrame();
			if (!_visible || Tier == DevMenuTier.None)
			{
				return;
			}
			_currentHoveredId = 0u;
			if (_themeDirty || ImGui.GetStyle().WindowRounding != 4f)
			{
				ApplyTheme();
				_themeDirty = false;
			}
			BeginShellWindow();
			// RE: unsure - exact start of the try region not recoverable; the catch resumes right after DrawShellHeader
			try
			{
				DrawShellHeader();
			}
			catch (Exception exception)
			{
				Debug.LogException(exception);
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
			float y = ImGui.GetContentRegionAvail().y;
			DrawSidebar(y);
			ImGui.SameLine();
			DrawContentPane(y);
			ImGui.End();
			DrawStyleEditorWindow();
			HandleHoverAudio();
			ImGuiNotify.Render();
		}

		private void BeginShellWindow()
		{
			ImGuiIOPtr iO = ImGui.GetIO();
			Vector2 displaySize = iO.DisplaySize;
			iO.FontGlobalScale = _uiScale;
			float num = ((displaySize.x > 1f) ? displaySize.x : ((float)Screen.width));
			float num2 = ((displaySize.y > 1f) ? displaySize.y : ((float)Screen.height));
			ImGui.SetNextWindowPos(new Vector2(num * 0.5f, num2 * 0.5f), ImGuiCond.Once, ShellPivot);
			ImGui.SetNextWindowSize(ShellInitialSize, ImGuiCond.Once);
			ImGui.SetNextWindowSizeConstraints(ShellMinSize, ShellMaxSize);
			ImGui.Begin("   ##SlopDevMenu", ShellWindowFlags);
		}

		private void DrawShellHeader()
		{
			DrawWindowTitle();
			if (_enableBackgroundParticles)
			{
				DrawParticleBackground();
			}
			if (_spiralEnabled)
			{
				DrawSpiralBackground();
			}
			DrawFpsHeader();
		}

		private void DrawSidebar(float height)
		{
			ImGui.PushStyleColor(ImGuiCol.ChildBg, _colSidebarBg);
			ImGui.BeginChild("##sidebar", new Vector2(SidebarWidth, height), ImGuiChildFlags.Border);
			ImGui.TextDisabled("PAGES");
			ImGui.Spacing();
			DrawSidebarItem("Movement", PageMovement);
			DrawSidebarItem("World", PageWorld);
			if (Can(DevMenuCap.PageStealth))
			{
				DrawSidebarItem("Stealth", PageStealth);
			}
			DrawSidebarItem("Players", PagePlayers);
			DrawSidebarItem("TP", PageTP);
			if (Can(DevMenuCap.PageSpawners))
			{
				DrawSidebarItem("Spawners", PageSpawners);
			}
			if (Can(DevMenuCap.PageDebug))
			{
				DrawSidebarItem("Debug", PageDebug);
			}
			if (Can(DevMenuCap.PageSoundboard))
			{
				DrawSidebarItem("Soundboard", PageSoundboard);
			}
			DrawSidebarItem("Settings", PageSettings);
			ImGui.EndChild();
			ImGui.PopStyleColor();
		}

		private void DrawContentPane(float height)
		{
			ImGui.PushStyleColor(ImGuiCol.ChildBg, _colContentBg);
			ImGui.BeginChild("##content", new Vector2(0f, height), ImGuiChildFlags.Border);
			ImGui.PushStyleVar(ImGuiStyleVar.Alpha, ImGui.GetStyle().Alpha * PageFadeIn());
			try
			{
				DrawSelectedPage();
			}
			catch (Exception exception)
			{
				Debug.LogException(exception);
				ImGui.TextColored(PageErrorColor, "Page error - see log.");
			}
			ImGui.PopStyleVar();
			ImGui.EndChild();
			ImGui.PopStyleColor();
		}

		private float PageFadeIn()
		{
			float realtimeSinceStartup = Time.realtimeSinceStartup;
			if (_previousPage != _selectedPage)
			{
				_previousPage = _selectedPage;
				_pageSwitchTime = realtimeSinceStartup;
			}
			return Mathf.Clamp01((realtimeSinceStartup - _pageSwitchTime) / 0.18f);
		}

		private void DrawSelectedPage()
		{
			switch (_selectedPage)
			{
			case PageWorld:
				DrawPage_World();
				break;
			case PageStealth:
				DrawPage_Stealth();
				break;
			case PagePlayers:
				DrawPage_Players();
				break;
			case PageTP:
				DrawPage_TP();
				break;
			case PageSpawners:
				DrawPage_Spawners();
				break;
			case PageDebug:
				DrawPage_Debug();
				break;
			case PageSoundboard:
				DrawPage_Soundboard();
				break;
			case PageSettings:
				DrawPage_Settings();
				break;
			default:
				DrawPage_Movement();
				break;
			}
		}

		private void DrawStyleEditorWindow()
		{
			if (_showStyleEditor)
			{
				ImGui.Begin("Style Editor", ref _showStyleEditor);
				ImGui.ShowStyleEditor();
				ImGui.End();
			}
		}

		private void DrawWindowTitle()
		{
			Vector2 windowPos = ImGui.GetWindowPos();
			float x = ImGui.GetWindowSize().x;
			float num = ImGui.GetFontSize() + ImGui.GetStyle().FramePadding.y * 2f;
			ImDrawListPtr windowDrawList = ImGui.GetWindowDrawList();
			Vector2 vector = ImGui.CalcTextSize("SLOP DEV");
			Vector2 pos = new Vector2(windowPos.x + (x - vector.x) * 0.5f, windowPos.y + (num - vector.y) * 0.5f);
			windowDrawList.AddText(pos, ImGui.GetColorU32(new Vector4(1f, 1f, 1f, 1f)), "SLOP DEV");
			GetTierBadge(out var label, out var color);
			Vector2 vector2 = ImGui.CalcTextSize(label);
			Vector2 pos2 = new Vector2(windowPos.x + x - vector2.x - 34f, windowPos.y + (num - vector2.y) * 0.5f);
			windowDrawList.AddText(pos2, ImGui.GetColorU32(color), label);
		}

		private void GetTierBadge(out string label, out Vector4 color)
		{
			switch (Tier)
			{
			case DevMenuTier.Trial:
				label = "TRIAL";
				color = new Vector4(0.65f, 0.68f, 0.72f, 1f);
				break;
			case DevMenuTier.Mod:
				label = "MOD";
				color = _colAccent;
				break;
			case DevMenuTier.Admin:
				label = "ADMIN";
				color = new Vector4(1f, 0.82f, 0.3f, 1f);
				break;
			case DevMenuTier.Owner:
				label = "OWNER";
				color = new Vector4(1f, 0.35f, 0.35f, 1f);
				break;
			default:
				label = "";
				color = new Vector4(1f, 1f, 1f, 1f);
				break;
			}
		}

		private void DrawSidebarItem(string label, int pageIndex)
		{
			bool flag = _selectedPage == pageIndex;
			ImGui.PushStyleColor(ImGuiCol.Button, flag ? Fade(_colAccent, 0.22f) : Vector4.zero);
			ImGui.PushStyleColor(ImGuiCol.ButtonHovered, Fade(_colAccent, flag ? 0.32f : 0.12f));
			if (ImGui.Button(label, new Vector2(ImGui.GetContentRegionAvail().x, 28f)))
			{
				_selectedPage = pageIndex;
				ClickFeedback(0.3f, 0.05f);
			}
			RegisterHover();
			float num = ImAnim.TweenFloat(SidebarBarTweenId, pageIndex, flag ? 1f : 0f, 0.15f, ImAnim.Ease.OutCubic);
			if (num > 0.01f)
			{
				ImDrawListPtr windowDrawList = ImGui.GetWindowDrawList();
				Vector2 itemRectMin = ImGui.GetItemRectMin();
				Vector2 itemRectMax = ImGui.GetItemRectMax();
				float num2 = (itemRectMin.y + itemRectMax.y) * 0.5f;
				float num3 = num * (itemRectMax.y - itemRectMin.y) * 0.5f;
				windowDrawList.AddRectFilled(new Vector2(itemRectMin.x, num2 - num3), new Vector2(itemRectMin.x + 3f, num2 + num3), ImGui.GetColorU32(_colAccent));
			}
			ImGui.PopStyleColor(2);
		}

		private void DrawFpsHeader()
		{
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			float num = 1f / Mathf.Max(unscaledDeltaTime, 0.0001f);
			float num2 = unscaledDeltaTime * 1000f;
			RecordFpsSample(num);
			Vector4 col = ((num >= 70f) ? FpsColorSmooth : ((num >= 55f) ? FpsColorDegraded : FpsColorBad));
			ImGui.TextColored(col, string.Format("{0:0} fps", num));
			ImGui.SameLine();
			ImGui.TextDisabled(string.Format("|  {0:0.0} ms  |  {1}", num2, Photon.Pun.PhotonNetwork.InRoom ? (Photon.Pun.PhotonNetwork.GetPing() + " ms ping") : "offline"));
			if (ImGui.IsItemHovered())
			{
				DrawFpsTooltip(num, num2);
			}
		}

		private void RecordFpsSample(float frameRate)
		{
			_fpsHistory[_fpsHistoryIdx] = frameRate;
			_fpsHistoryIdx = ((_fpsHistoryIdx + 1 != FPSHistorySize) ? (_fpsHistoryIdx + 1) : 0);
		}

		private void DrawFpsTooltip(float frameRate, float frameMs)
		{
			ImGui.BeginTooltip();
			ImGui.Text(string.Format("{0:0.0} fps  /  {1:0.00} ms", frameRate, frameMs));
			ImGui.Spacing();
			ImGui.PlotLines("##fpsplot", ref _fpsHistory[0], FPSHistorySize, _fpsHistoryIdx, null, 0f, 200f, FpsPlotSize);
			ImGui.EndTooltip();
		}

		private static Vector4 Fade(Vector4 c, float alpha)
		{
			return new Vector4(c.x, c.y, c.z, alpha);
		}

		private static Vector2 FullWidth(float height = 26f)
		{
			return new Vector2(ImGui.GetContentRegionAvail().x, height);
		}

		private bool Btn(string label, Vector2 size = default(Vector2), Action onPressed = null)
		{
			Vector2 cursorScreenPos = ImGui.GetCursorScreenPos();
			bool num = ImGui.Button(label, size);
			uint itemID = ImGui.GetItemID();
			Vector2 itemRectSize = ImGui.GetItemRectSize();
			bool flag = ImGui.IsItemHovered();
			RegisterHover();
			ImDrawListPtr windowDrawList = ImGui.GetWindowDrawList();
			float num2 = ImAnim.TweenFloat(itemID, 10, flag ? 1f : 0f, 0.12f, ImAnim.Ease.OutQuad);
			if (num2 > 0.005f)
			{
				windowDrawList.AddRectFilled(cursorScreenPos, cursorScreenPos + itemRectSize, ImGui.GetColorU32(new Vector4(1f, 1f, 1f, num2 * 0.07f)), ImGui.GetStyle().FrameRounding);
			}
			if (num)
			{
				ImAnim.TriggerRipple(itemID, ImGui.GetIO().MousePos, 0.45f);
				ClickFeedback(0.3f, 0.05f);
				onPressed?.Invoke();
			}
			ImAnim.DrawRipple(windowDrawList, itemID, cursorScreenPos, itemRectSize, new Vector4(1f, 1f, 1f, 0.6f));
			return num;
		}

		private bool DangerBtn(string label, Vector2 size = default(Vector2), Action onPressed = null)
		{
			ImGui.PushStyleColor(ImGuiCol.Button, DangerIdle);
			ImGui.PushStyleColor(ImGuiCol.ButtonHovered, DangerHovered);
			ImGui.PushStyleColor(ImGuiCol.ButtonActive, DangerPressed);
			bool result = Btn(label, size, onPressed);
			ImGui.PopStyleColor(3);
			return result;
		}

		private bool Checkbox(string label, ref bool v)
		{
			bool num = ImGui.Checkbox(label, ref v);
			RegisterHover();
			if (num)
			{
				ClickFeedback(0.2f, 0.04f);
			}
			return num;
		}

		private bool SliderFloat(string label, ref float v, float min, float max, string fmt = "%.2f")
		{
			bool result = ImGui.SliderFloat(label, ref v, min, max, fmt);
			RegisterHover();
			return result;
		}

		private bool SliderInt(string label, ref int v, int min, int max, string fmt = "%d")
		{
			bool result = ImGui.SliderInt(label, ref v, min, max, fmt);
			RegisterHover();
			return result;
		}

		private bool WithHover(bool widgetResult)
		{
			RegisterHover();
			return widgetResult;
		}

		private bool ModToggle(string label, ref bool v, string tooltip)
		{
			bool result = Checkbox(label, ref v);
			Tip(tooltip);
			return result;
		}

		private static void Tip(string text)
		{
			if (!string.IsNullOrEmpty(text) && ImGui.IsItemHovered())
			{
				ImGui.BeginTooltip();
				ImGui.PushTextWrapPos(300f);
				ImGui.TextUnformatted(text);
				ImGui.PopTextWrapPos();
				ImGui.EndTooltip();
			}
		}

		private void PageHeader(string title, string subtitle = null)
		{
			ImGui.Spacing();
			ImGui.TextColored(_colAccent, title);
			if (!string.IsNullOrEmpty(subtitle))
			{
				ImGui.TextDisabled(subtitle);
			}
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();
		}

		private void RegisterHover()
		{
			if (ImGui.IsItemHovered())
			{
				uint itemID = ImGui.GetItemID();
				if (itemID != 0)
				{
					_currentHoveredId = itemID;
				}
			}
		}

		private void SoftKeyboard(string owner, ref string buffer, string title, int maxLength = 64)
		{
			if (!TouchScreenKeyboard.isSupported)
			{
				return;
			}
			if (_softKeyboard == null)
			{
				if (ImGui.IsItemActivated())
				{
					_softKeyboardOwner = owner;
					_softKeyboard = TouchScreenKeyboard.Open(buffer ?? string.Empty, TouchScreenKeyboardType.Default, false, false, false, false, title, maxLength);
				}
				if (_softKeyboard == null)
				{
					return;
				}
			}
			if (_softKeyboardOwner == owner)
			{
				if (_softKeyboard.text != null)
				{
					buffer = _softKeyboard.text;
				}
				if (_softKeyboard.status != TouchScreenKeyboard.Status.Visible)
				{
					_softKeyboard = null;
					_softKeyboardOwner = null;
				}
			}
		}

		private void HandleHoverAudio()
		{
			if (_currentHoveredId == 0)
			{
				_previousHoveredId = 0u;
				return;
			}
			uint previousHoveredId = _previousHoveredId;
			_previousHoveredId = _currentHoveredId;
			if (_currentHoveredId != previousHoveredId)
			{
				PlayClip((hoverClip == null) ? buttonClickClip : hoverClip);
				SendMenuHaptic(0.15f, 0.05f);
			}
		}

		private void ClickFeedback(float hapticAmplitude, float hapticDuration)
		{
			PlayClip(buttonClickClip);
			SendMenuHaptic(hapticAmplitude, hapticDuration);
		}

		private void PlayClip(AudioClip clip)
		{
			if (!(clip == null) && !(audioSource == null))
			{
				audioSource.PlayOneShot(clip);
			}
		}

		private static void ConfigureUiAudioSource(AudioSource src)
		{
			if (!(src == null))
			{
				src.playOnAwake = false;
				src.spatialize = false;
				src.spatialBlend = 0f;
			}
		}

		private void EnsureSoundboardSource()
		{
			if (soundboardAudioSource == null)
			{
				GameObject gameObject = new GameObject("[DevMenu] Soundboard");
				gameObject.transform.SetParent(base.transform, worldPositionStays: false);
				soundboardAudioSource = gameObject.AddComponent<AudioSource>();
			}
			ConfigureUiAudioSource(soundboardAudioSource);
		}

		private static void SendMenuHaptic(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				instance.PulseLeft(amplitude, duration);
				instance.PulseRight(amplitude, duration);
			}
			else
			{
				UnityEngine.XR.InputDevices.GetDeviceAtXRNode(UnityEngine.XR.XRNode.LeftHand).SendHapticImpulse(0u, amplitude, duration);
				UnityEngine.XR.InputDevices.GetDeviceAtXRNode(UnityEngine.XR.XRNode.RightHand).SendHapticImpulse(0u, amplitude, duration);
			}
		}

		private void OnUnityLogMessage(string condition, string stackTrace, LogType type)
		{
			if ((type == LogType.Error || type == LogType.Exception) && !(Time.realtimeSinceStartup - _lastErrorNotifTime < 2f))
			{
				_lastErrorNotifTime = Time.realtimeSinceStartup;
				if (_errorSoundEnabled)
				{
					PlayClip(notifErrorClip);
				}
				if (_errorVisualEnabled)
				{
					string content = ((condition.Length > 120) ? (condition.Substring(0, 117) + "…") : condition);
					ImGuiNotify.Insert(ImGuiNotify.ToastType.Error, "Error", content, 5f);
				}
			}
		}

		public void OnPlayerEnteredRoom(Player newPlayer)
		{
			string content = (string.IsNullOrEmpty(newPlayer.NickName) ? newPlayer.UserId : newPlayer.NickName);
			if (_notifSoundEnabled)
			{
				PlayClip(notifJoinClip);
			}
			if (_notifVisualEnabled)
			{
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Success, "Player Joined", content);
			}
		}

		public void OnPlayerLeftRoom(Player otherPlayer)
		{
			string content = (string.IsNullOrEmpty(otherPlayer.NickName) ? otherPlayer.UserId : otherPlayer.NickName);
			if (_notifSoundEnabled)
			{
				PlayClip(notifLeaveClip);
			}
			if (_notifVisualEnabled)
			{
				ImGuiNotify.Insert(ImGuiNotify.ToastType.Warning, "Player Left", content);
			}
			ForgetPlayer(otherPlayer.ActorNumber);
		}

		public void OnRoomPropertiesUpdate(Hashtable p)
		{
		}

		public void OnPlayerPropertiesUpdate(Player t, Hashtable c)
		{
		}

		public void OnMasterClientSwitched(Player n)
		{
		}
	}
}
