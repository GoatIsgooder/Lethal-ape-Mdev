using Photon.Pun;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(100)]
	public class FnCameraSystem : MonoBehaviour
	{
		public enum FeedMode : byte
		{
			Standby = 0,
			Off = 1,
			Live = 2,
			AudioOnly = 3,
			NoSignal = 4,
			PowerOut = 5
		}

		private int _watchedMask;

		private float _loopVolume;

		private bool _createdLoop;

		private Camera _cam;

		private RenderTexture _rt;

		private RenderPipeline.StandardRequest _request;

		private Camera _maskEye;

		private bool _maskResolved;

		private SphericalHarmonicsL2 _cctvProbe;

		private Color _cctvProbeColor = new Color(-1f, -1f, -1f, -1f);

		private Light _feedLight;

		[Header("Render")]
		[Tooltip("Optional. Left empty, one is created (forward, black clear, near clip 5 cm). Either way it stays disabled, mono, and free of MSAA and HDR.")]
		public Camera renderCamera;

		[Tooltip("Start from the eye camera's culling mask, so a feed never shows what the eyes can't.")]
		public bool matchEyeMask = true;

		[Tooltip("Layers the feed never draws, by name: the scene is copied into LAR, whose layer numbers differ. Unknown names are skipped.")]
		public string[] hideLayers = new string[9] { "UI", "Overlay UI", "Hand", "Finger", "PhysHand", "LivTablet", "LCK Tablet", "RenderOnly", "ComputerNotRendered" };

		[Tooltip("Layers the feed draws although the eyes skip them: the wearer's own face pieces live on MIRROR.")]
		public string[] showLayers = new string[1] { "MIRROR" };

		[Tooltip("Baked occlusion culling for the feed. Every lens must sit in open air inside its room, never inside a wall.")]
		public bool occlusionCulling = true;

		[Tooltip("No realtime shadows in the feed (shadow distance 0 for its render only).")]
		public bool skipShadows = true;

		[Tooltip("Flat ambient for the feed's render only, the CCTV night-vision gain. The scene's ambient is restored straight after.")]
		public Color cctvAmbient = new Color(0.16f, 0.17f, 0.2f, 1f);

		[Tooltip("Keep scene fog in the feed. Off disables fog for the feed's render only.")]
		public bool cctvFog;

		[Tooltip("The camera's night light: a spot on the lens, lit only for the feed's own render (the scene is baked dark, and baked probes light the animatronics, so ambient alone can't). 0 = off.")]
		public float feedLightIntensity = 1.1f;

		public Color feedLightColor = new Color(0.78f, 0.86f, 1f, 1f);

		[Tooltip("Spot cone as a multiple of the lens's vertical field of view.")]
		public float feedLightSpread = 1.35f;

		[Header("Monitor")]
		[Tooltip("Power loss powers the monitor down (dark) instead of showing NO SIGNAL static.")]
		public bool darkInBlackout = true;

		[Tooltip("How long the picture takes to clear after a signal drop (s).")]
		public float settleSeconds = 0.15f;

		[Tooltip("Extra distance past monitorUseDistance before the monitor lets go of a guard, so its edge never flickers (m).")]
		public float deskHysteresis = 0.25f;

		[Header("Audio")]
		[Tooltip("Optional looping source for the static hiss (Spatialize off). Created at the office monitor anchor when empty.")]
		public AudioSource staticLoop;

		[Range(0f, 1f)]
		public float staticVolume = 0.35f;

		[Range(0f, 1f)]
		public float switchVolume = 0.6f;

		[Tooltip("Level of sounds relayed through the monitor from the camera being watched.")]
		[Range(0f, 1f)]
		public float relayVolume = 0.8f;

		private const float MinSendInterval = 0.2f;

		private const float ResendSeconds = 1f;

		private int _selected = -1;

		private FeedMode _mode;

		private int _shown = -1;

		private bool _atDesk;

		private float _dropUntil;

		private float _scramble;

		private float _static;

		private float _forceScrambleUntil;

		private bool _needRender = true;

		private Renderer _screen;

		private bool _screenSeen = true;

		private bool _wasSeen = true;

		private int _screenFrame = -10;

		private sbyte _sentValue = sbyte.MinValue;

		private float _sentAt = -100f;

		private bool _anchorWarned;

		private Vector3 SpeakerPosition
		{
			get
			{
				FnOffice office = FnOffice.Instance;
				if (office != null && office.monitor != null)
				{
					return office.monitor.position;
				}
				return (_screen != null ? _screen.transform : transform).position;
			}
		}

		public static FnCameraSystem Instance { get; private set; }

		private static FnSettings.CameraSettings Cams => FnGame.Settings.cameras;

		public static Vector2Int FeedSize
		{
			get
			{
				FnSettings.CameraSettings c = Cams;
				return new Vector2Int(Mathf.Clamp(c.renderWidth, 64, 1024), Mathf.Clamp(c.renderHeight, 64, 1024));
			}
		}

		public static float FeedAspect
		{
			get
			{
				Vector2Int size = FeedSize;
				return (float)size.x / (float)size.y;
			}
		}

		public int Selected => _selected;

		public FeedMode Mode => _mode;

		public int ShownStation => _shown;

		public RenderTexture Feed => _rt;

		public float StaticAmount => _static;

		public float ScrambleAmount => _scramble;

		public bool AtDesk => _atDesk;

		public bool Watching => _atDesk && (_mode == FeedMode.Live || _mode == FeedMode.AudioOnly);

		public int WatchedMask => _watchedMask;

		public bool DebugPreview { get; set; }

		public static bool RelayToMonitor(AudioClip clip, Vector3 source, float volume = 1f)
		{
			FnCameraSystem system = Instance;
			if (system == null || clip == null)
			{
				return false;
			}
			if (!system.Watching)
			{
				return false;
			}
			if (!FnStations.TryGet(system._selected, out var station))
			{
				return false;
			}
			float range = Mathf.Max(station.Range, 0.5f);
			float distance = Vector3.Distance(source, station.Pose.position);
			if (distance > range)
			{
				return false;
			}
			FnAudio.Play(clip, system.SpeakerPosition, system.relayVolume * volume * (1f - 0.6f * distance / range), 1f, 3f, 1f);
			return true;
		}

		private void UpdateLeds(FnNight night, bool on)
		{
			int mask = 0;
			if (on && night != null && night.Phase <= FnPhase.Night)
			{
				mask = FnStations.LocalSelected >= 0 ? (1 << FnStations.LocalSelected) : 0;
				int localActor = FnGame.LocalActor;
				for (int i = 0; i < night.GuardSlots; i++)
				{
					int actor = night.GuardActor(i);
					if (actor >= 1 && actor != localActor && night.GuardStatus(i) == FnGuardStatus.Alive)
					{
						sbyte cam = FnProps.PlayerSByte(FnGame.PlayerOf(actor), FnProps.Camera, -1);
						if (cam >= 0 && cam < FnStations.MaxStations)
						{
							mask |= 1 << cam;
						}
					}
				}
			}
			_watchedMask = mask;
			for (int j = 0; j < FnStations.Count; j++)
			{
				FnCameraStation station = FnCameraStation.At(j);
				if (station != null)
				{
					station.ApplyLed(((mask >> j) & 1) != 0);
				}
			}
		}

		private void UpdateLoop()
		{
			FnAudioBank bank = FnGame.Audio;
			AudioClip clip = (staticLoop != null && staticLoop.clip != null) ? staticLoop.clip : (bank != null ? bank.staticLoop : null);
			float target = 0f;
			if (_mode != FeedMode.Standby && clip != null)
			{
				target = staticVolume * Mathf.Max(_static, _scramble * 0.8f);
			}
			_loopVolume = Mathf.MoveTowards(_loopVolume, target, Time.deltaTime * 6f);
			if (_loopVolume <= 0.001f || clip == null)
			{
				if (staticLoop != null && staticLoop.isPlaying)
				{
					staticLoop.Stop();
				}
				return;
			}
			AudioSource source = EnsureLoop(clip);
			source.volume = _loopVolume;
			if (!source.isPlaying)
			{
				if (_createdLoop)
				{
					source.transform.position = SpeakerPosition;
				}
				source.time = Random.Range(0f, clip.length * 0.9f);
				source.Play();
			}
		}

		private AudioSource EnsureLoop(AudioClip clip)
		{
			if (staticLoop == null)
			{
				GameObject go = new GameObject("FnStaticLoop");
				go.transform.SetParent(transform, false);
				staticLoop = go.AddComponent<AudioSource>();
				staticLoop.playOnAwake = false;
				staticLoop.spatialize = false;
				staticLoop.spatialBlend = 1f;
				staticLoop.rolloffMode = AudioRolloffMode.Linear;
				staticLoop.minDistance = 0.4f;
				staticLoop.maxDistance = 4f;
				staticLoop.dopplerLevel = 0f;
				FnAudio audio = Object.FindAnyObjectByType<FnAudio>();
				if (audio != null)
				{
					staticLoop.outputAudioMixerGroup = audio.output;
				}
				_createdLoop = true;
			}
			staticLoop.loop = true;
			if (staticLoop.clip != clip)
			{
				staticLoop.clip = clip;
			}
			return staticLoop;
		}

		private void ClearFeedback()
		{
			_watchedMask = 0;
			for (int i = 0; i < FnStations.MaxStations; i++)
			{
				FnCameraStation station = FnCameraStation.At(i);
				if (station != null)
				{
					station.ApplyLed(false);
				}
			}
			_loopVolume = 0f;
			if (staticLoop != null && staticLoop.isPlaying)
			{
				staticLoop.Stop();
			}
		}

		private void SetUpCamera()
		{
			if (renderCamera == null)
			{
				GameObject go = new GameObject("FnCctvCamera");
				go.transform.SetParent(transform, false);
				renderCamera = go.AddComponent<Camera>();
				renderCamera.clearFlags = CameraClearFlags.SolidColor;
				renderCamera.backgroundColor = Color.black;
				renderCamera.nearClipPlane = 0.05f;
				renderCamera.renderingPath = RenderingPath.Forward;
			}
			_cam = renderCamera;
			_cam.enabled = false;
			_cam.stereoTargetEye = StereoTargetEyeMask.None;
			_cam.allowMSAA = false;
			_cam.allowHDR = false;
			_cam.allowDynamicResolution = false;
			_cam.depthTextureMode = DepthTextureMode.None;
			GameObject lightGo = new GameObject("FnCctvNightLight");
			lightGo.transform.SetParent(_cam.transform, false);
			_feedLight = lightGo.AddComponent<Light>();
			_feedLight.type = LightType.Spot;
			_feedLight.shadows = LightShadows.None;
			_feedLight.renderMode = LightRenderMode.ForcePixel;
			_feedLight.enabled = false;
		}

		private void RenderFeed(in FnStations.Station station)
		{
			EnsureTexture();
			ResolveMask();
			_cam.transform.SetPositionAndRotation(station.Pose.position, station.Pose.rotation);
			_cam.fieldOfView = station.VerticalFov;
			_cam.aspect = (float)_rt.width / (float)_rt.height;
			_cam.farClipPlane = Mathf.Max(_cam.nearClipPlane + 0.5f, station.Range);
			_cam.useOcclusionCulling = occlusionCulling;
			AmbientMode ambientMode = RenderSettings.ambientMode;
			Color ambientLight = RenderSettings.ambientLight;
			SphericalHarmonicsL2 ambientProbe = RenderSettings.ambientProbe;
			bool fog = RenderSettings.fog;
			float shadowDistance = QualitySettings.shadowDistance;
			Renderer screen = _screen;
			bool screenWasOff = screen != null && screen.forceRenderingOff;
			bool lightOn = _feedLight != null && feedLightIntensity > 0f;
			try
			{
				if (lightOn)
				{
					_feedLight.color = feedLightColor;
					_feedLight.intensity = feedLightIntensity;
					_feedLight.range = Mathf.Max(station.Range, 2f);
					_feedLight.spotAngle = Mathf.Clamp(station.VerticalFov * feedLightSpread, 20f, 150f);
					_feedLight.innerSpotAngle = _feedLight.spotAngle * 0.4f;
					_feedLight.enabled = true;
				}
				RenderSettings.ambientMode = AmbientMode.Flat;
				RenderSettings.ambientLight = cctvAmbient;
				RenderSettings.ambientProbe = CctvProbe();
				if (!cctvFog)
				{
					RenderSettings.fog = false;
				}
				if (skipShadows)
				{
					QualitySettings.shadowDistance = 0f;
				}
				if (screen != null)
				{
					screen.forceRenderingOff = true;
				}
				Draw();
			}
			finally
			{
				if (lightOn)
				{
					_feedLight.enabled = false;
				}
				RenderSettings.ambientMode = ambientMode;
				RenderSettings.ambientLight = ambientLight;
				RenderSettings.ambientProbe = ambientProbe;
				RenderSettings.fog = fog;
				QualitySettings.shadowDistance = shadowDistance;
				if (screen != null)
				{
					screen.forceRenderingOff = screenWasOff;
				}
			}
			_needRender = false;
		}

		private void Draw()
		{
			if (GraphicsSettings.currentRenderPipeline != null)
			{
				if (_request == null)
				{
					_request = new RenderPipeline.StandardRequest();
				}
				_request.destination = _rt;
				if (RenderPipeline.SupportsRenderRequest(_cam, _request))
				{
					RenderPipeline.SubmitRenderRequest(_cam, _request);
					return;
				}
			}
			_cam.Render();
		}

		private void EnsureTexture()
		{
			if (_rt == null)
			{
				Vector2Int size = FeedSize;
				_rt = new RenderTexture(size.x, size.y, 16, RenderTextureFormat.ARGB32)
				{
					name = "FnCctvFeed",
					antiAliasing = 1,
					useMipMap = false,
					autoGenerateMips = false,
					filterMode = FilterMode.Bilinear,
					wrapMode = TextureWrapMode.Clamp
				};
			}
			if (!_rt.IsCreated())
			{
				_rt.Create();
			}
			if (_cam.targetTexture != _rt)
			{
				_cam.targetTexture = _rt;
			}
		}

		private void ReleaseTexture()
		{
			if (_cam != null && _cam.targetTexture == _rt)
			{
				_cam.targetTexture = null;
			}
			if (!(_rt == null))
			{
				_rt.Release();
				Object.Destroy(_rt);
				_rt = null;
			}
		}

		private void ResolveMask()
		{
			Camera eye = FnPlatform.Eye;
			if (!_maskResolved || !(eye == _maskEye))
			{
				_maskEye = eye;
				_maskResolved = true;
				int mask = (matchEyeMask && eye != null && eye != _cam) ? eye.cullingMask : (-1);
				_cam.cullingMask = (mask | LayerBits(showLayers)) & ~LayerBits(hideLayers);
			}
		}

		private static int LayerBits(string[] names)
		{
			int bits = 0;
			if (names == null)
			{
				return bits;
			}
			for (int i = 0; i < names.Length; i++)
			{
				if (!string.IsNullOrEmpty(names[i]))
				{
					int layer = LayerMask.NameToLayer(names[i]);
					if (layer >= 0)
					{
						bits |= 1 << layer;
					}
				}
			}
			return bits;
		}

		private SphericalHarmonicsL2 CctvProbe()
		{
			if (cctvAmbient == _cctvProbeColor)
			{
				return _cctvProbe;
			}
			_cctvProbeColor = cctvAmbient;
			_cctvProbe = default(SphericalHarmonicsL2);
			Color color = ((QualitySettings.activeColorSpace == ColorSpace.Linear) ? cctvAmbient.linear : cctvAmbient);
			_cctvProbe.AddAmbientLight(color);
			return _cctvProbe;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Debug.LogError("[FnCameraSystem] Two camera systems in the scene; disabling the second.", this);
				base.enabled = false;
				return;
			}
			Instance = this;
			SetUpCamera();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
			ReleaseTexture();
		}

		private void OnEnable()
		{
			_atDesk = false;
			_selected = -1;
			_shown = -1;
			_needRender = true;
			_maskResolved = false;
			_screenFrame = -10;
		}

		private void OnDisable()
		{
			if (!(Instance != this))
			{
				_mode = FeedMode.Standby;
				_atDesk = false;
				FnStations.LocalSelected = -1;
				_shown = -1;
				_scramble = 0f;
				_static = 0f;
				ClearFeedback();
				ReleaseTexture();
				if (PhotonNetwork.InRoom && FnProps.PlayerSByte(PhotonNetwork.LocalPlayer, FnProps.Camera, -1) != -1)
				{
					ExitGames.Client.Photon.Hashtable changed = new ExitGames.Client.Photon.Hashtable();
					changed[FnProps.Camera] = (sbyte)(-1);
					FnProps.WriteLocal(changed);
				}
				_sentValue = sbyte.MinValue;
				_sentAt = -100f;
			}
		}

		private void OnValidate()
		{
			_maskResolved = false;
			settleSeconds = Mathf.Max(0f, settleSeconds);
			deskHysteresis = Mathf.Max(0f, deskHysteresis);
		}

		public void Select(int station)
		{
			if (station < 0 || station >= FnStations.MaxStations)
			{
				station = -1;
			}
			if (station != _selected)
			{
				_selected = station;
				FnAudioBank bank = FnGame.Audio;
				if (bank != null)
				{
					FnAudio.Play(bank.cameraSwitch, SpeakerPosition, switchVolume, 1f, 4f, 1f);
				}
			}
		}

		public void Toggle(int station)
		{
			Select((_selected == station) ? (-1) : station);
		}

		public void DebugSelect(int station)
		{
			Select(station);
		}

		public void DebugForceScramble(float seconds)
		{
			_forceScrambleUntil = Time.time + Mathf.Max(0f, seconds);
		}

		public void ReportScreen(Renderer screen)
		{
			_screen = screen;
			_screenSeen = screen == null || screen.isVisible;
			_screenFrame = Time.frameCount;
		}

		private void LateUpdate()
		{
			if (Instance != this)
			{
				return;
			}
			FnNight night = FnNight.Instance;
			FnSettings.CameraSettings c = Cams;
			float now = Time.time;
			if (night != null && night.Active && !night.LocalIsAlive)
			{
				_selected = -1;
			}
			_atDesk = LocalAtDesk(night, c);
			bool hasStation = FnStations.TryGet(_selected, out var station);
			bool active = night != null && night.Active;
			bool powered = !active || (!night.Blackout && night.Power > 0f);
			FeedMode mode;
			if (!_atDesk && !DebugPreview)
			{
				mode = FeedMode.Standby;
			}
			else if (_selected < 0)
			{
				mode = FeedMode.Off;
			}
			else if (!powered)
			{
				mode = (darkInBlackout ? FeedMode.PowerOut : FeedMode.NoSignal);
			}
			else if (!hasStation)
			{
				mode = FeedMode.NoSignal;
			}
			else
			{
				mode = (station.AudioOnly ? FeedMode.AudioOnly : FeedMode.Live);
			}
			_mode = mode;
			int watched = (Watching ? _selected : (-1));
			FnStations.LocalSelected = watched;
			Publish(watched);
			if (mode == FeedMode.Live || mode == FeedMode.AudioOnly || mode == FeedMode.NoSignal)
			{
				if (_selected != _shown)
				{
					_shown = _selected;
					_scramble = 0f;
					if (_shown >= 0)
					{
						_needRender = true;
						_dropUntil = now + Mathf.Max(0f, c.signalDropSeconds);
					}
				}
			}
			else if (_shown != -1)
			{
				_scramble = 0f;
				_shown = -1;
			}
			if (mode == FeedMode.Live)
			{
				float motion = Mathf.Clamp01(FnStations.MotionInView(_selected) / Mathf.Max(c.scrambleFullSpeed, 0.01f));
				float target = motion * c.scrambleMax;
				if (now < _forceScrambleUntil)
				{
					target = Mathf.Max(target, c.scrambleMax);
				}
				_scramble = Mathf.Max(target, _scramble - c.scrambleDecay * Time.deltaTime);
			}
			else
			{
				_scramble = 0f;
			}
			if (mode == FeedMode.Live || mode == FeedMode.AudioOnly)
			{
				_static = ((now < _dropUntil) ? 1f : Mathf.Clamp01(1f - (now - _dropUntil) / Mathf.Max(settleSeconds, 0.01f)));
			}
			else
			{
				_static = ((mode == FeedMode.NoSignal) ? 1f : 0f);
			}
			if (!_screenSeen && Time.frameCount - _screenFrame <= 2)
			{
				_wasSeen = false;
			}
			else
			{
				if (!_wasSeen)
				{
					_needRender = true;
				}
				_wasSeen = true;
				if (mode == FeedMode.Live && now >= _dropUntil)
				{
					if (_rt == null || !_rt.IsCreated())
					{
						_needRender = true;
					}
					if (_needRender || Time.frameCount % Mathf.Clamp(c.renderEveryNthFrame, 1, 6) == 0)
					{
						RenderFeed(in station);
					}
				}
			}
			UpdateLeds(night, active && powered);
			UpdateLoop();
		}

		private bool LocalAtDesk(FnNight night, FnSettings.CameraSettings c)
		{
			if (night == null || !night.Active || night.Phase > FnPhase.Night || !night.LocalIsAlive)
			{
				return false;
			}
			FnOffice office = FnOffice.Instance;
			Transform anchor = (office != null) ? office.monitor : null;
			if (anchor == null)
			{
				if (office != null && !_anchorWarned)
				{
					_anchorWarned = true;
					Debug.LogError("[FnCameraSystem] FnOffice.monitor is not assigned, so nobody can ever use the cameras.", office);
				}
				return false;
			}
			Transform head = FnPlatform.Head;
			if (head == null)
			{
				return false;
			}
			float reach = c.monitorUseDistance + (_atDesk ? deskHysteresis : 0f);
			return (head.position - anchor.position).sqrMagnitude <= reach * reach;
		}

		private void Publish(int value)
		{
			if (!PhotonNetwork.InRoom)
			{
				return;
			}
			sbyte v = (sbyte)value;
			if (FnProps.PlayerSByte(PhotonNetwork.LocalPlayer, FnProps.Camera, -1) != v)
			{
				float since = Time.unscaledTime - _sentAt;
				if (!(since < MinSendInterval) && (!(since < ResendSeconds) || v != _sentValue))
				{
					_sentValue = v;
					_sentAt = Time.unscaledTime;
					ExitGames.Client.Photon.Hashtable changed = new ExitGames.Client.Photon.Hashtable();
					changed[FnProps.Camera] = (v >= 0) ? v : ((sbyte)(-1));
					FnProps.WriteLocal(changed);
				}
			}
		}
	}
}
