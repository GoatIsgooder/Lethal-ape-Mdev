using TMPro;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace LethalApeR.Gameplay.Backrooms
{
	public class BackroomsResultScreen : MonoBehaviour
	{
		private enum Phase
		{
			Hidden = 0,
			Showing = 1,
			Hiding = 2
		}

		private const float DomeRadius = 12f;

		private const string DomeShader = "Slop/Backrooms/ResultDome";

		private const string DomeShaderFallback = "Slop/Rivals/AuroraSky";

		private const float Distance = 1.3f;

		private const float HeightOffset = -0.05f;

		private const float FollowPos = 3.5f;

		private const float FollowRot = 5f;

		private const float SpringDur = 0.45f;

		private const float PushDist = 0.18f;

		private const float PulseHz = 0.5f;

		private const float PulseAmp = 0.015f;

		private const float CardW = 0.98f;

		private const float CardH = 0.34f;

		private const float TextZ = -0.006f;

		private const float BackZ = 0.012f;

		private const float DomeFadeInDur = 0.45f;

		private const float DomeFadeOutDur = 0.5f;

		private const float CardFadeInDur = 0.3f;

		private const float CardFadeOutDur = 0.35f;

		private Phase _phase;

		private bool _win;

		private Camera _cam;

		private bool _built;

		private GameObject _dome;

		private Material _domeMat;

		private bool _domeHasExposure;

		private Transform _card;

		private Transform _content;

		private MeshRenderer _backR;

		private Material _backMat;

		private TextMeshPro _title;

		private TextMeshPro _subtitle;

		private MaterialPropertyBlock _mpb;

		private float _domeFade;

		private float _cardAlpha;

		private float _springX;

		private float _springV;

		private float _push;

		private float _t;

		private float _hideScale = 1f;

		private Vector3 _flatFwd = Vector3.forward;

		private Color _backColor;

		private Color _titleColor;

		private float _lastTitleAlpha = -1f;

		private float _lastSubAlpha = -1f;

		private static readonly int ExposureId = Shader.PropertyToID("_Exposure");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		public static BackroomsResultScreen Instance { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(Instance != null))
			{
				GameObject go = new GameObject("BackroomsResultScreen (auto)");
				Object.DontDestroyOnLoad(go);
				go.AddComponent<BackroomsResultScreen>();
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
			_mpb = new MaterialPropertyBlock();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
			Teardown();
		}

		private void OnEnable()
		{
			BackroomsEvents.OnRoundResult += HandleResult;
			BackroomsEvents.OnStateChanged += HandleState;
			SceneManager.sceneLoaded += OnSceneLoaded;
		}

		private void OnDisable()
		{
			BackroomsEvents.OnRoundResult -= HandleResult;
			BackroomsEvents.OnStateChanged -= HandleState;
			SceneManager.sceneLoaded -= OnSceneLoaded;
		}

		private void OnSceneLoaded(Scene s, LoadSceneMode m)
		{
			Teardown();
		}

		private void HandleState(BackroomsState s)
		{
			if (s != BackroomsState.End)
			{
				BeginHide();
			}
		}

		private void HandleResult(bool win)
		{
			Show(win);
		}

		public void Show(bool win)
		{
			Teardown();
			_win = win;
			_phase = Phase.Showing;
			_domeFade = 0f;
			_cardAlpha = 0f;
			_springX = 0.0001f;
			_springV = 0f;
			_push = PushDist;
			_t = 0f;
			_hideScale = 1f;
			_lastTitleAlpha = -1f;
			_lastSubAlpha = -1f;
			Build();
		}

		private void BeginHide()
		{
			if (_phase == Phase.Showing)
			{
				_phase = Phase.Hiding;
			}
		}

		private void Update()
		{
			if (_phase == Phase.Hidden || (!_built && !Build()))
			{
				return;
			}
			float dt = Time.deltaTime;
			_t += dt;
			if (_phase == Phase.Showing)
			{
				_domeFade = Mathf.MoveTowards(_domeFade, 1f, dt / DomeFadeInDur);
				_cardAlpha = Mathf.MoveTowards(_cardAlpha, 1f, dt / CardFadeInDur);
				StepSpring(1f, dt);
				_push = Mathf.MoveTowards(_push, 0f, dt * (PushDist / SpringDur));
			}
			else
			{
				_domeFade = Mathf.MoveTowards(_domeFade, 0f, dt / DomeFadeOutDur);
				_cardAlpha = Mathf.MoveTowards(_cardAlpha, 0f, dt / CardFadeOutDur);
				_hideScale = Mathf.MoveTowards(_hideScale, 0.85f, dt / CardFadeOutDur);
				if (_domeFade <= 0.001f && _cardAlpha <= 0.001f)
				{
					Teardown();
					return;
				}
			}
			ApplyDomeExposure();
			ApplyCardVisuals();
		}

		private void StepSpring(float target, float dt)
		{
			dt = Mathf.Min(dt, 0.05f);
			_springV += dt * (-22.116814f * _springV + -404.25903f * (_springX - target));
			_springX += dt * _springV;
		}

		private void ApplyDomeExposure()
		{
			if (!(_domeMat == null) && _domeHasExposure)
			{
				_domeMat.SetFloat(ExposureId, _domeFade);
			}
		}

		private void ApplyCardVisuals()
		{
			if (_content != null)
			{
				float pulse = 1f;
				if (_phase == Phase.Showing && _t > SpringDur)
				{
					pulse = 1f + Mathf.Sin(Time.time * (PulseHz * 2f * Mathf.PI)) * PulseAmp;
				}
				float s = _hideScale * (pulse * Mathf.Max(_springX, 0.0001f));
				_content.localScale = new Vector3(s, s, s);
			}
			if (_backR != null)
			{
				_backR.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, new Color(_backColor.r, _backColor.g, _backColor.b, _backColor.a * _cardAlpha));
				_backR.SetPropertyBlock(_mpb);
			}
			if (_title != null && !Mathf.Approximately(_cardAlpha, _lastTitleAlpha))
			{
				_lastTitleAlpha = _cardAlpha;
				_title.alpha = _cardAlpha;
			}
			if (_subtitle != null && !Mathf.Approximately(_cardAlpha, _lastSubAlpha))
			{
				_lastSubAlpha = _cardAlpha;
				_subtitle.alpha = _cardAlpha;
			}
		}

		private void LateUpdate()
		{
			if (_phase == Phase.Hidden || _cam == null)
			{
				return;
			}
			Transform camT = _cam.transform;
			if (_dome != null)
			{
				_dome.transform.SetPositionAndRotation(camT.position, Quaternion.identity);
			}
			if (_card != null)
			{
				Vector3 fwd = camT.forward;
				fwd.y = 0f;
				if (fwd.sqrMagnitude > 0.0001f)
				{
					_flatFwd = fwd.normalized;
				}
				Vector3 target = camT.position + _flatFwd * (Distance + _push) + Vector3.up * HeightOffset;
				Vector3 toCard = target - camT.position;
				Quaternion look = ((toCard.sqrMagnitude > 1E-06f) ? Quaternion.LookRotation(toCard, Vector3.up) : _card.rotation);
				float posT = 1f - Mathf.Exp(-FollowPos * Time.deltaTime);
				float rotT = 1f - Mathf.Exp(-FollowRot * Time.deltaTime);
				_card.position = Vector3.Lerp(_card.position, target, posT);
				_card.rotation = Quaternion.Slerp(_card.rotation, look, rotT);
			}
		}

		private bool Build()
		{
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
			_cam = ((player != null && player.mainCamera != null) ? player.mainCamera : Camera.main);
			if (_cam == null)
			{
				return false;
			}
			BuildDome();
			BuildCard();
			Vector3 camPos = _cam.transform.position;
			if (_dome != null)
			{
				_dome.transform.position = camPos;
			}
			if (_card != null)
			{
				Vector3 fwd = _cam.transform.forward;
				fwd.y = 0f;
				if (fwd.sqrMagnitude > 0.0001f)
				{
					_flatFwd = fwd.normalized;
				}
				Vector3 pos = camPos + _flatFwd * (Distance + _push) + Vector3.up * HeightOffset;
				_card.SetPositionAndRotation(pos, Quaternion.LookRotation(pos - camPos, Vector3.up));
			}
			ApplyDomeExposure();
			ApplyCardVisuals();
			_built = true;
			return true;
		}

		private void BuildDome()
		{
			Shader shader = Shader.Find(DomeShader);
			if (shader == null)
			{
				shader = Shader.Find(DomeShaderFallback);
			}
			bool flatFallback = shader == null;
			if (flatFallback)
			{
				shader = Shader.Find("Unlit/Color");
			}
			if (shader == null)
			{
				Debug.LogWarning("[BackroomsResultScreen] No dome shader available — skipping the void dome (card only).");
				return;
			}
			_domeMat = new Material(shader);
			_domeHasExposure = _domeMat.HasProperty(ExposureId);
			ApplyDomeLook(_domeMat, _win, flatFallback);
			_dome = GameObject.CreatePrimitive(PrimitiveType.Sphere);
			_dome.name = "BackroomsResultDome";
			Collider col = _dome.GetComponent<Collider>();
			if (col != null)
			{
				Object.Destroy(col);
			}
			Transform t = _dome.transform;
			t.localScale = Vector3.one * (DomeRadius * 2f);
			if (flatFallback)
			{
				t.localScale = -t.localScale;
			}
			MeshRenderer mr = _dome.GetComponent<MeshRenderer>();
			mr.shadowCastingMode = ShadowCastingMode.Off;
			mr.receiveShadows = false;
			mr.lightProbeUsage = LightProbeUsage.Off;
			mr.reflectionProbeUsage = ReflectionProbeUsage.Off;
			mr.allowOcclusionWhenDynamic = false;
			mr.sharedMaterial = _domeMat;
		}

		private void BuildCard()
		{
			_card = new GameObject("BackroomsResultCard").transform;
			_content = new GameObject("Content").transform;
			_content.SetParent(_card, false);
			Shader backShader = Shader.Find("Slop/Backrooms/ResultCardBack");
			if (backShader != null)
			{
				_backMat = new Material(backShader)
				{
					renderQueue = 3000
				};
				GameObject back = GameObject.CreatePrimitive(PrimitiveType.Quad);
				back.name = "Backing";
				Collider col = back.GetComponent<Collider>();
				if (col != null)
				{
					Object.Destroy(col);
				}
				back.transform.SetParent(_content, false);
				back.transform.localPosition = new Vector3(0f, 0f, BackZ);
				back.transform.localScale = new Vector3(CardW, CardH, 1f);
				_backR = back.GetComponent<MeshRenderer>();
				_backR.sharedMaterial = _backMat;
				SetupRenderer(_backR);
			}
			_backColor = (_win ? Hex("#1A120A", 0.55f) : Hex("#0A0906", 0.74f));
			_titleColor = (_win ? Hex("#FFEFC0") : Hex("#EDE6C8"));
			Color subColor = (_win ? Hex("#FFC861") : Hex("#9A8A4E"));
			_title = CreateText("Title", new Vector3(0f, 0.055f, TextZ), _win ? 0.90000004f : 0.85f, _titleColor);
			_title.text = (_win ? "YOU ESCAPED" : "YOU LOST");
			_subtitle = CreateText("Subtitle", new Vector3(0f, -0.075f, TextZ), 0.33f, subColor);
			_subtitle.text = (_win ? "You made it out of Level 0" : "Level 0 keeps what it catches");
			_content.localScale = Vector3.one * 0.0001f;
		}

		private TextMeshPro CreateText(string name, Vector3 localPos, float fontSize, Color color)
		{
			GameObject go = new GameObject(name);
			go.transform.SetParent(_content, false);
			go.transform.localPosition = localPos;
			TextMeshPro tmp = go.AddComponent<TextMeshPro>();
			tmp.fontSize = fontSize;
			tmp.fontStyle = FontStyles.Bold;
			tmp.color = color;
			tmp.alignment = TextAlignmentOptions.Center;
			tmp.textWrappingMode = TextWrappingModes.NoWrap;
			tmp.overflowMode = TextOverflowModes.Overflow;
			tmp.rectTransform.sizeDelta = new Vector2(CardW, CardH * 0.6f);
			tmp.raycastTarget = false;
			tmp.outlineWidth = 0.18f;
			tmp.outlineColor = new Color32(0, 0, 0, 153);
			return tmp;
		}

		private static void ApplyDomeLook(Material m, bool win, bool flatFallback)
		{
			if (flatFallback)
			{
				m.color = (win ? Hex("#2A2410") : Hex("#0A0906"));
				return;
			}
			if (win)
			{
				m.SetColor("_HorizonColor", Hex("#5A4A14"));
				m.SetColor("_ZenithColor", Hex("#06040E"));
				m.SetFloat("_GradientPower", 2.5f);
				m.SetColor("_HorizonGlowColor", Hex("#FFE3A8"));
				m.SetFloat("_HorizonGlowStrength", 1.85f);
				m.SetFloat("_StarDensity", 0.42f);
				m.SetFloat("_StarScale", 34f);
				m.SetFloat("_StarBrightness", 1.6f);
				m.SetFloat("_TwinkleSpeed", 1f);
				m.SetFloat("_HeroStarDensity", 0.22f);
				m.SetFloat("_HeroStarScale", 6f);
				m.SetFloat("_AuroraIntensity", 2f);
				m.SetColor("_AuroraBottomColor", Hex("#FFF3C8"));
				m.SetColor("_AuroraMidColor", Hex("#FFB347"));
				m.SetColor("_AuroraTopColor", Hex("#3A2A6E"));
				m.SetFloat("_AuroraHeight", 0.5f);
				m.SetFloat("_AuroraExtent", 0.3f);
				m.SetFloat("_AuroraSpeed", 0.9f);
			}
			else
			{
				m.SetColor("_HorizonColor", Hex("#1A1410"));
				m.SetColor("_ZenithColor", Hex("#000000"));
				m.SetFloat("_GradientPower", 0.45f);
				m.SetColor("_HorizonGlowColor", Hex("#7A6A2E"));
				m.SetFloat("_HorizonGlowStrength", 0.85f);
				m.SetFloat("_StarDensity", 0.85f);
				m.SetFloat("_StarScale", 64f);
				m.SetFloat("_StarBrightness", 0.5f);
				m.SetFloat("_TwinkleSpeed", 0.3f);
				m.SetFloat("_HeroStarDensity", 0f);
				m.SetFloat("_HeroStarScale", 8f);
				m.SetFloat("_AuroraIntensity", 0.95f);
				m.SetColor("_AuroraBottomColor", Hex("#6E5E14"));
				m.SetColor("_AuroraMidColor", Hex("#3A3318"));
				m.SetColor("_AuroraTopColor", Hex("#000000"));
				m.SetFloat("_AuroraHeight", 0.3f);
				m.SetFloat("_AuroraExtent", 0.6f);
				m.SetFloat("_AuroraSpeed", 0.25f);
			}
			m.SetFloat(ExposureId, 0f);
		}

		private void Teardown()
		{
			_phase = Phase.Hidden;
			_built = false;
			if (_dome != null)
			{
				Object.Destroy(_dome);
			}
			if (_card != null)
			{
				Object.Destroy(_card.gameObject);
			}
			if (_domeMat != null)
			{
				Object.Destroy(_domeMat);
			}
			if (_backMat != null)
			{
				Object.Destroy(_backMat);
			}
			_dome = null;
			_card = null;
			_content = null;
			_backR = null;
			_domeMat = null;
			_backMat = null;
			_title = null;
			_subtitle = null;
		}

		private static void SetupRenderer(Renderer r)
		{
			r.shadowCastingMode = ShadowCastingMode.Off;
			r.receiveShadows = false;
			r.lightProbeUsage = LightProbeUsage.Off;
			r.reflectionProbeUsage = ReflectionProbeUsage.Off;
		}

		private static Color Hex(string s, float a = 1f)
		{
			ColorUtility.TryParseHtmlString(s, out var c);
			c.a = a;
			return c;
		}
	}
}
