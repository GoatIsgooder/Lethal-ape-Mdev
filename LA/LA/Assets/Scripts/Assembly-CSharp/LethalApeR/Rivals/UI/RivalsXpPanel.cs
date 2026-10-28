using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Rivals.Progression;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.UI
{
	public class RivalsXpPanel : MonoBehaviour
	{
		private static RivalsXpPanel _active;

		[Header("Audio (optional — all null-guarded, 2D non-spatialized)")]
		[Tooltip("Soft tick looped while a counter is running.")]
		public AudioClip tickClip;

		public AudioClip levelUpClip;

		public AudioClip rankUpClip;

		[Header("Placement")]
		[Tooltip("Meters in front of the eyes (along the head's flattened forward).")]
		public float distance = 1.3f;

		[Tooltip("Meters below eye height.")]
		public float heightOffset = -0.18f;

		[Tooltip("How hard the panel chases the head. Low = lazy glide.")]
		public float followPosSpeed = 3.5f;

		public float followRotSpeed = 5f;

		[Header("Look")]
		[Tooltip("Font for all panel text. Defaults to the TMP default font.")]
		[SerializeField]
		private TMP_FontAsset font;

		[Tooltip("Rank icon set. Optional — overrides the static RankIcons when set.")]
		[SerializeField]
		private RivalsRankIcons rankIcons;

		public Color xpBarColor = new Color(0.3f, 0.78f, 1f, 1f);

		public Color victoryColor = new Color(1f, 0.84f, 0.2f, 1f);

		public Color defeatColor = new Color(0.55f, 0.62f, 0.72f, 1f);

		public Color keysColor = new Color(1f, 0.84f, 0.2f, 1f);

		public Color rpGainColor = new Color(0.45f, 1f, 0.5f, 1f);

		public Color rpLossColor = new Color(1f, 0.35f, 0.3f, 1f);

		private const float PanelW = 0.9f;

		private const float PanelH = 0.45f;

		private const float BarW = 0.34f;

		private const float BarH = 0.045f;

		private const float WheelSize = 0.22f;

		private const float TextZ = -0.006f;

		private const string BarShaderName = "Slop/Rivals/BarFill";

		private const string RingShaderName = "Slop/Rivals/RadialFill";

		private MatchXpSummary _summary;

		private Camera _head;

		private Camera _forcedHead;

		private Transform _content;

		private Coroutine _master;

		private Coroutine _keysRoutine;

		private bool _dismissed;

		private Vector3 _flatFwd = Vector3.forward;

		private MaterialPropertyBlock _mpb;

		private Material _backMat;

		private Material _barMat;

		private Material _ringMat;

		private Material _textMat;

		private Material _fallbackFillMat;

		private Material _sparkleMat;

		private MeshRenderer _backR;

		private MeshRenderer _barR;

		private MeshRenderer _ringR;

		private bool _barShaderOk;

		private bool _ringShaderOk;

		private bool _warnedShader;

		private Transform _barFillFallback;

		private MeshRenderer _barFillFallbackR;

		private TextMeshPro _header;

		private TextMeshPro _levelText;

		private TextMeshPro _xpCounter;

		private TextMeshPro _xpFraction;

		private TextMeshPro _keysPopup;

		private TextMeshPro _rpCounter;

		private TextMeshPro _rankName;

		private TextMeshPro _rankLetter;

		private TextMeshPro[] _allTexts;

		private Transform _levelTf;

		private Transform _wheelTf;

		private Transform _keysTf;

		private Vector3 _wheelBaseScale = Vector3.one;

		private Vector3 _keysBasePos;

		private int _keysShown;

		private bool _keysPopupShown;

		private float _barFill;

		private float _barFlash;

		private float _ringFill;

		private float _ringFlash;

		private float _ringDim;

		private float _drainBlend;

		private Color _ringColor = Color.white;

		private bool _championFull;

		private bool _iconOn;

		private float _levelPunch;

		private float _wheelPunch;

		private float _keysPunch;

		private float _alphaMul = 1f;

		private AudioSource _audio;

		private ParticleSystem _sparkles;

		private static readonly Color DimGrey = new Color(0.45f, 0.45f, 0.5f, 1f);

		private static readonly int FillAmountId = Shader.PropertyToID("_FillAmount");

		private static readonly int FillColorId = Shader.PropertyToID("_FillColor");

		private static readonly int BackColorId = Shader.PropertyToID("_BackColor");

		private static readonly int FlashId = Shader.PropertyToID("_Flash");

		private static readonly int AlphaId = Shader.PropertyToID("_Alpha");

		private static readonly int AspectId = Shader.PropertyToID("_Aspect");

		private static readonly int CornerId = Shader.PropertyToID("_Corner");

		private static readonly int IconTexId = Shader.PropertyToID("_IconTex");

		private static readonly int IconColorId = Shader.PropertyToID("_IconColor");

		private static readonly int IconRectId = Shader.PropertyToID("_IconRect");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		public const int PanelLayer = 5;

		public static RivalsRankIcons RankIcons { get; set; }

		public static RivalsXpPanel Spawn(MatchXpSummary summary)
		{
			if (_active != null)
			{
				_active.Dismiss();
			}
			GameObject go = new GameObject("RivalsXpPanel");
			RivalsXpPanel panel = go.AddComponent<RivalsXpPanel>();
			panel._summary = summary;
			panel._master = panel.StartCoroutine(panel.Master());
			_active = panel;
			return panel;
		}

		public void SetViewCamera(Camera cam)
		{
			_forcedHead = cam;
			if (cam != null)
			{
				_head = cam;
				SnapToHead();
			}
		}

		private Camera PickHead()
		{
			if (_forcedHead != null)
			{
				return _forcedHead;
			}
			return ResolveCamera();
		}

		public void Dismiss()
		{
			if (_dismissed)
			{
				return;
			}
			_dismissed = true;
			if (_master != null)
			{
				StopCoroutine(_master);
			}
			if (_keysRoutine != null)
			{
				StopCoroutine(_keysRoutine);
			}
			StopTickLoop();
			StartCoroutine(FadeOutAndDie());
		}

		private IEnumerator Master()
		{
			float deadline = Time.unscaledTime + 3f;
			while (true)
			{
				_head = PickHead();
				if (_head != null)
				{
					break;
				}
				if (Time.unscaledTime > deadline)
				{
					Debug.LogWarning("[RivalsXpPanel] No head camera found — skipping the XP panel.");
					Destroy(gameObject);
					yield break;
				}
				yield return null;
			}
			SnapToHead();
			BuildVisuals();
			yield return SpringIn();
			yield return XpPhase();
			yield return new WaitForSeconds(0.5f);
			yield return RankPhase();
		}

		private IEnumerator SpringIn()
		{
			float x = 0f;
			float v = 0f;
			for (float t = 0f; t < 0.5f; t += Time.deltaTime)
			{
				float dt = Mathf.Min(Time.deltaTime, 0.05f);
				v += (-22.116814f * v + -404.25903f * (x - 1f)) * dt;
				x += v * dt;
				_content.localScale = Vector3.one * Mathf.Max(x, 0.0001f);
				yield return null;
			}
			_content.localScale = Vector3.one;
		}

		private IEnumerator XpPhase()
		{
			int gained = _summary.XpEnd - _summary.XpStart;
			if (gained <= 0)
			{
				yield break;
			}
			int displayLevel = Mathf.Max(1, _summary.LevelStart);
			int levelsTotal = Mathf.Max(0, _summary.LevelEnd - _summary.LevelStart);
			int keysPerLevel = ((levelsTotal > 0) ? (_summary.KeysGranted / levelsTotal) : 0);
			int levelsSeen = 0;
			int lastShown = -1;
			StartTickLoop();
			for (float t = 0f; t < 1.5f; t += Time.deltaTime)
			{
				float k = Mathf.Clamp01(t / 1.5f);
				float e = 1f - (1f - k) * (1f - k) * (1f - k);
				int xp = _summary.XpStart + Mathf.RoundToInt((float)gained * e);
				int level = RankDefs.LevelFromTotalXp(xp);
				if (level > displayLevel)
				{
					levelsSeen += level - displayLevel;
					displayLevel = level;
					TriggerLevelUp(level, levelsSeen, levelsTotal, keysPerLevel);
				}
				_barFill = Mathf.Clamp01((float)RankDefs.XpIntoLevel(xp) / (float)Mathf.Max(1, RankDefs.XpForLevelUp(displayLevel)));
				if (xp != lastShown)
				{
					lastShown = xp;
					if (_xpCounter != null)
					{
						_xpCounter.text = string.Format("+{0} XP", xp - _summary.XpStart);
					}
					SetXpFraction(xp, displayLevel);
				}
				yield return null;
			}
			StopTickLoop();
			if (_summary.LevelEnd > displayLevel)
			{
				levelsSeen += _summary.LevelEnd - displayLevel;
				displayLevel = _summary.LevelEnd;
				TriggerLevelUp(_summary.LevelEnd, levelsSeen, levelsTotal, keysPerLevel);
			}
			_barFill = Mathf.Clamp01((float)RankDefs.XpIntoLevel(_summary.XpEnd) / (float)Mathf.Max(1, RankDefs.XpForLevelUp(displayLevel)));
			if (_xpCounter != null)
			{
				_xpCounter.text = string.Format("+{0} XP", gained);
			}
			SetXpFraction(_summary.XpEnd, displayLevel);
		}

		private void TriggerLevelUp(int newLevel, int levelsSeen, int levelsTotal, int keysPerLevel)
		{
			SetLevelText(newLevel);
			_barFlash = 1f;
			_levelPunch = 1f;
			PlayOneShot(levelUpClip);
			if (levelsTotal <= 0 || _summary.KeysGranted <= 0)
			{
				return;
			}
			int target = ((levelsSeen < levelsTotal) ? (keysPerLevel * levelsSeen) : _summary.KeysGranted);
			if (target > _keysShown)
			{
				if (_keysRoutine != null)
				{
					StopCoroutine(_keysRoutine);
				}
				_keysRoutine = StartCoroutine(KeysPopupRoutine(target));
			}
		}

		private IEnumerator KeysPopupRoutine(int target)
		{
			if (_keysPopup == null)
			{
				yield break;
			}
			_keysPopup.gameObject.SetActive(true);
			_keysPunch = 1f;
			int from = _keysShown;
			float fromAlpha = (_keysPopupShown ? 1f : 0f);
			_keysPopupShown = true;
			for (float t = 0f; t < 0.45f; t += Time.deltaTime)
			{
				float k = Mathf.Clamp01(t / 0.45f);
				float e = 1f - (1f - k) * (1f - k);
				int shown = Mathf.RoundToInt(Mathf.Lerp(from, target, e));
				if (shown != _keysShown)
				{
					_keysShown = shown;
					_keysPopup.text = string.Format("+{0} KEYS", shown);
				}
				_keysTf.localPosition = _keysBasePos + Vector3.up * (e * 0.035f);
				_keysPopup.color = new Color(Mathf.Lerp(1f, keysColor.r, k), Mathf.Lerp(1f, keysColor.g, k), Mathf.Lerp(1f, keysColor.b, k), Mathf.Lerp(fromAlpha, 1f, e));
				yield return null;
			}
			_keysShown = target;
			_keysPopup.text = string.Format("+{0} KEYS", target);
			_keysPopup.color = keysColor;
			_keysTf.localPosition = _keysBasePos + Vector3.up * 0.035f;
		}

		private IEnumerator RankPhase()
		{
			RivalsRank displayRank = _summary.RankStart;
			int delta = _summary.RpDelta;
			if (delta == 0)
			{
				yield break;
			}
			if (_rpCounter != null)
			{
				_rpCounter.color = ((delta > 0) ? rpGainColor : rpLossColor);
			}
			if (delta < 0)
			{
				_drainBlend = 1f;
			}
			StartTickLoop();
			int lastShown = int.MinValue;
			for (float t = 0f; t < 1.4f; t += Time.deltaTime)
			{
				float k = Mathf.Clamp01(t / 1.4f);
				float e = 1f - (1f - k) * (1f - k) * (1f - k);
				int rp = _summary.RpStart + Mathf.RoundToInt((float)delta * e);
				RivalsRank rank = RankDefs.RankForRp(rp);
				if (rank != displayRank)
				{
					TriggerRankSwap(rank, rank > displayRank);
					displayRank = rank;
				}
				UpdateRingFill(rp);
				int shown = rp - _summary.RpStart;
				if (shown != lastShown)
				{
					lastShown = shown;
					if (_rpCounter != null)
					{
						_rpCounter.text = FormatSigned(shown, "RP");
					}
				}
				yield return null;
			}
			StopTickLoop();
			_drainBlend = 0f;
			if (_summary.RankEnd != displayRank)
			{
				TriggerRankSwap(_summary.RankEnd, _summary.RankEnd > displayRank);
			}
			UpdateRingFill(_summary.RpEnd);
			if (_rpCounter != null)
			{
				_rpCounter.text = FormatSigned(delta, "RP");
			}
		}

		private void TriggerRankSwap(RivalsRank rank, bool promoted)
		{
			ApplyRank(rank);
			_wheelPunch = 1f;
			if (promoted)
			{
				_ringFlash = 1.5f;
				PlayOneShot(rankUpClip);
				EmitSparkles(rank);
			}
			else
			{
				_ringFlash = 0.6f;
				_ringDim = 1f;
			}
		}

		private IEnumerator FadeOutAndDie()
		{
			if (_content == null)
			{
				Destroy(gameObject);
				yield break;
			}
			float[] alphas = new float[_allTexts.Length];
			for (int i = 0; i < _allTexts.Length; i++)
			{
				alphas[i] = ((_allTexts[i] != null) ? _allTexts[i].alpha : 1f);
			}
			for (float t = 0f; t < 0.4f; t += Time.deltaTime)
			{
				_alphaMul = 1f - Mathf.Clamp01(t / 0.4f);
				for (int j = 0; j < _allTexts.Length; j++)
				{
					if (_allTexts[j] != null)
					{
						_allTexts[j].alpha = _alphaMul * alphas[j];
					}
				}
				yield return null;
			}
			Destroy(gameObject);
		}

		private void Update()
		{
			if (_content == null)
			{
				return;
			}
			float dt = Time.deltaTime;
			_barFlash = Mathf.Max(0f, _barFlash - dt * 3.5f);
			_ringFlash = Mathf.Max(0f, _ringFlash - dt * 3f);
			_ringDim = Mathf.Max(0f, _ringDim - dt * 1.2f);
			_levelPunch = Mathf.Max(0f, _levelPunch - dt * 4f);
			_wheelPunch = Mathf.Max(0f, _wheelPunch - dt * 4f);
			_keysPunch = Mathf.Max(0f, _keysPunch - dt * 4f);
			if (_levelTf != null)
			{
				_levelTf.localScale = Vector3.one * (1f + _levelPunch * 0.3f);
			}
			if (_wheelTf != null)
			{
				_wheelTf.localScale = _wheelBaseScale * (1f + _wheelPunch * 0.22f);
			}
			if (_keysTf != null)
			{
				_keysTf.localScale = Vector3.one * (1f + _keysPunch * 0.25f);
			}
			if (_backR != null)
			{
				_backR.GetPropertyBlock(_mpb);
				if (_barShaderOk)
				{
					_mpb.SetFloat(AlphaId, _alphaMul);
				}
				else
				{
					_mpb.SetColor(ColorId, new Color(0.02f, 0.03f, 0.05f, 0.62f * _alphaMul));
				}
				_backR.SetPropertyBlock(_mpb);
			}
			if (_barR != null)
			{
				if (_barShaderOk)
				{
					_barR.GetPropertyBlock(_mpb);
					_mpb.SetFloat(FillAmountId, _barFill);
					_mpb.SetColor(FillColorId, xpBarColor);
					_mpb.SetFloat(FlashId, _barFlash);
					_mpb.SetFloat(AlphaId, _alphaMul);
					_barR.SetPropertyBlock(_mpb);
				}
				else
				{
					_barR.GetPropertyBlock(_mpb);
					_mpb.SetColor(ColorId, new Color(0.05f, 0.07f, 0.12f, 0.9f * _alphaMul));
					_barR.SetPropertyBlock(_mpb);
					if (_barFillFallback != null && _barFillFallbackR != null)
					{
						Vector3 s = _barFillFallback.localScale;
						s.x = Mathf.Max(_barFill, 0.0001f);
						_barFillFallback.localScale = s;
						Color fillColor = Color.Lerp(xpBarColor, Color.white, _barFlash);
						fillColor.a = _alphaMul;
						_barFillFallbackR.GetPropertyBlock(_mpb);
						_mpb.SetColor(ColorId, fillColor);
						_barFillFallbackR.SetPropertyBlock(_mpb);
					}
				}
			}
			if (_ringR == null || !_ringShaderOk)
			{
				return;
			}
			Color ring = Color.Lerp(_ringColor, DimGrey, _ringDim);
			ring = Color.Lerp(ring, rpLossColor, _drainBlend * 0.35f);
			if (_championFull)
			{
				float pulse = 1f + Mathf.Sin(Time.time * 2.6f) * 0.1f;
				ring.r *= pulse;
				ring.g *= pulse;
				ring.b *= pulse;
			}
			Color iconColor = Color.Lerp(Color.white, DimGrey, _ringDim);
			iconColor.a = (_iconOn ? _alphaMul : 0f);
			_ringR.GetPropertyBlock(_mpb);
			_mpb.SetFloat(FillAmountId, _championFull ? 1f : _ringFill);
			_mpb.SetColor(FillColorId, ring);
			_mpb.SetFloat(FlashId, _ringFlash);
			_mpb.SetFloat(AlphaId, _alphaMul);
			_mpb.SetColor(IconColorId, iconColor);
			_ringR.SetPropertyBlock(_mpb);
		}

		private void LateUpdate()
		{
			if (_head == null)
			{
				_head = PickHead();
				if (_head == null)
				{
					return;
				}
			}
			ComputeTarget(out var pos, out var rot);
			float posT = Mathf.Exp((0f - followPosSpeed) * Time.deltaTime);
			float rotT = Mathf.Exp((0f - followRotSpeed) * Time.deltaTime);
			transform.position = Vector3.Lerp(transform.position, pos, 1f - posT);
			transform.rotation = Quaternion.Slerp(transform.rotation, rot, 1f - rotT);
		}

		private void ComputeTarget(out Vector3 pos, out Quaternion rot)
		{
			Transform head = _head.transform;
			Vector3 fwd = head.forward;
			if (fwd.x * fwd.x + fwd.z * fwd.z > 0.0001f)
			{
				_flatFwd = new Vector3(fwd.x, 0f, fwd.z).normalized;
			}
			pos = head.position + _flatFwd * distance + Vector3.up * heightOffset;
			Vector3 toPanel = pos - head.position;
			if (toPanel.sqrMagnitude > 1E-06f)
			{
				rot = Quaternion.LookRotation(toPanel, Vector3.up);
			}
			else
			{
				rot = transform.rotation;
			}
		}

		private void SnapToHead()
		{
			ComputeTarget(out var pos, out var rot);
			transform.SetPositionAndRotation(pos, rot);
		}

		private static Camera ResolveCamera()
		{
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
			if (player != null && player.mainCamera != null)
			{
				return player.mainCamera;
			}
			return Camera.main;
		}

		private void BuildVisuals()
		{
			_mpb = new MaterialPropertyBlock();
			_content = new GameObject("Content").transform;
			_content.SetParent(transform, false);
			_content.localScale = Vector3.zero;
			_backMat = MakeMat("Slop/Rivals/BarFill", 3996, out _);
			_barMat = MakeMat("Slop/Rivals/BarFill", 3997, out _barShaderOk);
			_ringMat = MakeMat("Slop/Rivals/RadialFill", 3997, out _ringShaderOk);
			if (_barShaderOk)
			{
				_backMat.SetFloat(FillAmountId, 0f);
				_backMat.SetColor(BackColorId, new Color(0.02f, 0.03f, 0.05f, 0.62f));
				_backMat.SetFloat(AspectId, PanelW / PanelH);
				_backMat.SetFloat(CornerId, 0.18f);
				_barMat.SetColor(BackColorId, new Color(0.05f, 0.07f, 0.12f, 0.9f));
				_barMat.SetFloat(AspectId, BarW / BarH);
				_barMat.SetFloat(CornerId, 0.85f);
			}
			if (_ringShaderOk)
			{
				_ringMat.SetColor(BackColorId, new Color(0.08f, 0.1f, 0.14f, 0.9f));
			}
			_backR = CreateQuad("Backing", new Vector3(0f, 0f, 0.012f), new Vector2(PanelW, PanelH), _backMat);
			_barR = CreateQuad("XpBar", new Vector3(-0.23f, -0.045f, 0f), new Vector2(BarW, BarH), _barMat);
			_ringR = CreateQuad("RankWheel", new Vector3(0.24f, -0.01f, 0f), new Vector2(WheelSize, WheelSize), _ringMat);
			_wheelTf = ((_ringR != null) ? _ringR.transform : null);
			if (_wheelTf != null)
			{
				_wheelBaseScale = _wheelTf.localScale;
			}
			if (_ringR != null && !_ringShaderOk)
			{
				_ringR.enabled = false;
			}
			if (_barR != null && !_barShaderOk)
			{
				Transform pivot = new GameObject("FillPivot").transform;
				pivot.SetParent(_barR.transform, false);
				pivot.localPosition = new Vector3(-0.5f, 0f, -0.002f);
				pivot.localScale = new Vector3(0.0001f, 1f, 1f);
				_barFillFallback = pivot;
				Shader shader = Shader.Find("Sprites/Default");
				if (shader != null)
				{
					_fallbackFillMat = new Material(shader)
					{
						renderQueue = 3998
					};
					GameObject fill = GameObject.CreatePrimitive(PrimitiveType.Quad);
					fill.name = "Fill";
					Collider col = fill.GetComponent<Collider>();
					if (col != null)
					{
						Destroy(col);
					}
					fill.transform.SetParent(pivot, false);
					fill.transform.localPosition = new Vector3(0.5f, 0f, 0f);
					fill.transform.localScale = new Vector3(1f, 0.9f, 1f);
					_barFillFallbackR = fill.GetComponent<MeshRenderer>();
					_barFillFallbackR.sharedMaterial = _fallbackFillMat;
					SetupRenderer(_barFillFallbackR);
				}
			}
			Color headerColor = (_summary.Won ? victoryColor : defeatColor);
			string headerText = (_summary.Won ? "VICTORY" : "DEFEAT");
			_header = CreateText("Header", new Vector3(0f, 0.17f, TextZ), 0.5f, headerColor, FontStyles.Bold);
			_header.text = headerText;
			_levelText = CreateText("Level", new Vector3(-0.26f, 0.075f, TextZ), 0.95f, Color.white, FontStyles.Bold);
			_xpCounter = CreateText("XpCounter", new Vector3(0f, -0.045f, TextZ), 0.32f, Color.Lerp(xpBarColor, Color.white, 0.35f), FontStyles.Normal);
			_xpFraction = CreateText("XpFraction", new Vector3(-0.23f, -0.1f, TextZ), 0.3f, new Color(0.75f, 0.8f, 0.88f, 1f), FontStyles.Normal);
			_keysPopup = CreateText("KeysPopup", new Vector3(-0.23f, -0.145f, TextZ), 0.34f, keysColor, FontStyles.Bold);
			_keysBasePos = _keysPopup.transform.localPosition;
			_keysPopup.gameObject.SetActive(false);
			_rpCounter = CreateText("RpCounter", new Vector3(0.24f, 0.135f, TextZ), 0.34f, Color.white, FontStyles.Bold);
			_rankName = CreateText("RankName", new Vector3(0.24f, -0.165f, TextZ), 0.34f, Color.white, FontStyles.Bold);
			_rankLetter = CreateText("RankLetter", new Vector3(0.24f, -0.01f, -0.004f), 0.9f, Color.white, FontStyles.Bold);
			_levelTf = _levelText.transform;
			_keysTf = _keysPopup.transform;
			_allTexts = new TextMeshPro[8] { _header, _levelText, _xpCounter, _xpFraction, _keysPopup, _rpCounter, _rankName, _rankLetter };
			_audio = gameObject.AddComponent<AudioSource>();
			_audio.playOnAwake = false;
			_audio.spatialize = false;
			_audio.spatialBlend = 0f;
			_audio.volume = 0.8f;
			int level = Mathf.Max(1, _summary.LevelStart);
			SetLevelText(level);
			_barFill = Mathf.Clamp01((float)RankDefs.XpIntoLevel(_summary.XpStart) / (float)Mathf.Max(1, RankDefs.XpForLevelUp(level)));
			SetXpFraction(_summary.XpStart, level);
			ApplyRank(_summary.RankStart);
			UpdateRingFill(_summary.RpStart);
			SetLayerRecursively(gameObject, PanelLayer);
		}

		private MeshRenderer CreateQuad(string name, Vector3 localPos, Vector2 size, Material mat)
		{
			if (mat == null)
			{
				return null;
			}
			GameObject go = GameObject.CreatePrimitive(PrimitiveType.Quad);
			go.name = name;
			Collider col = go.GetComponent<Collider>();
			if (col != null)
			{
				Destroy(col);
			}
			go.transform.SetParent(_content, false);
			go.transform.localPosition = localPos;
			go.transform.localScale = new Vector3(size.x, size.y, 1f);
			MeshRenderer r = go.GetComponent<MeshRenderer>();
			r.sharedMaterial = mat;
			SetupRenderer(r);
			return r;
		}

		private static void SetLayerRecursively(GameObject go, int layer)
		{
			go.layer = layer;
			Transform transform = go.transform;
			for (int i = 0; i < transform.childCount; i++)
			{
				SetLayerRecursively(transform.GetChild(i).gameObject, layer);
			}
		}

		private static void SetupRenderer(Renderer r)
		{
			r.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			r.receiveShadows = false;
			r.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
			r.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
		}

		private Material MakeMat(string shaderName, int queue, out bool ok)
		{
			Shader shader = Shader.Find(shaderName);
			ok = shader != null;
			if (!ok)
			{
				if (!_warnedShader)
				{
					_warnedShader = true;
					Debug.LogWarning("[RivalsXpPanel] Shader '" + shaderName + "' not found (stripped from the build?) — falling back to flat quads.");
				}
				shader = Shader.Find("Sprites/Default");
				if (shader == null)
				{
					return null;
				}
			}
			Material material = new Material(shader);
			material.renderQueue = queue;
			return material;
		}

		private TextMeshPro CreateText(string name, Vector3 pos, float size, Color color, FontStyles style)
		{
			GameObject gameObject = new GameObject(name);
			gameObject.transform.SetParent(_content, false);
			gameObject.transform.localPosition = pos;
			TextMeshPro textMeshPro = gameObject.AddComponent<TextMeshPro>();
			if (font != null)
			{
				textMeshPro.font = font;
			}
			Material material = ResolveTextMaterial(textMeshPro);
			if (material != null)
			{
				textMeshPro.fontSharedMaterial = material;
			}
			textMeshPro.fontSize = size;
			textMeshPro.fontStyle = style;
			textMeshPro.color = color;
			textMeshPro.alignment = TextAlignmentOptions.Center;
			textMeshPro.textWrappingMode = TextWrappingModes.NoWrap;
			textMeshPro.overflowMode = TextOverflowModes.Overflow;
			textMeshPro.rectTransform.sizeDelta = new Vector2(0.5f, 0.2f);
			textMeshPro.text = "";
			return textMeshPro;
		}

		private Material ResolveTextMaterial(TextMeshPro tmp)
		{
			if (_textMat != null)
			{
				return _textMat;
			}
			Shader shader = Shader.Find("TextMeshPro/Mobile/Distance Field Overlay");
			if (shader == null)
			{
				shader = Shader.Find("TextMeshPro/Distance Field Overlay");
			}
			if (shader == null)
			{
				return null;
			}
			Material material = ((tmp.font != null) ? tmp.font.material : tmp.fontSharedMaterial);
			if (material == null)
			{
				return null;
			}
			Material material2 = new Material(material);
			material2.shader = shader;
			material2.renderQueue = 4001;
			_textMat = material2;
			return _textMat;
		}

		private void SetLevelText(int level)
		{
			if (_levelText != null)
			{
				_levelText.text = string.Format("LVL {0}", level);
			}
		}

		private void SetXpFraction(int totalXp, int level)
		{
			if (_xpFraction != null)
			{
				_xpFraction.text = string.Format("{0} / {1} XP", RankDefs.XpIntoLevel(totalXp), RankDefs.XpForLevelUp(level));
			}
		}

		private void UpdateRingFill(int rp)
		{
			int num = RankDefs.RpForNextRank(rp);
			if (num <= 0)
			{
				_championFull = true;
				_ringFill = 1f;
				return;
			}
			_championFull = false;
			_ringFill = Mathf.Clamp01((float)RankDefs.RpIntoRank(rp) / (float)num);
		}

		private void ApplyRank(RivalsRank rank)
		{
			_ringColor = RankDefs.RankColor(rank);
			if (_rankName != null)
			{
				_rankName.text = RankDefs.DisplayName(rank);
				_rankName.color = _ringColor;
			}
			RivalsRankIcons rivalsRankIcons = ((rankIcons != null) ? rankIcons : RankIcons);
			Sprite sprite = ((rivalsRankIcons != null) ? rivalsRankIcons.GetIcon(rank) : null);
			if (_ringShaderOk && sprite != null && sprite.texture != null)
			{
				Texture2D texture = sprite.texture;
				Rect textureRect = sprite.textureRect;
				_ringMat.SetTexture(IconTexId, texture);
				_ringMat.SetVector(IconRectId, new Vector4(textureRect.x / (float)texture.width, textureRect.y / (float)texture.height, textureRect.width / (float)texture.width, textureRect.height / (float)texture.height));
				_iconOn = true;
				if (_rankLetter != null)
				{
					_rankLetter.gameObject.SetActive(false);
				}
				return;
			}
			_iconOn = false;
			if (_rankLetter != null)
			{
				_rankLetter.gameObject.SetActive(true);
				_rankLetter.text = RankDefs.DisplayName(rank).Substring(0, 1);
				_rankLetter.color = _ringColor;
			}
		}

		private static string FormatSigned(int v, string suffix)
		{
			if (v >= 0)
			{
				return string.Format("+{0} {1}", v, suffix);
			}
			return string.Format("-{0} {1}", -v, suffix);
		}

		private void EmitSparkles(RivalsRank rank)
		{
			if (_sparkles == null)
			{
				_sparkles = BuildSparkles();
			}
			if (!(_sparkles == null))
			{
				ParticleSystem.MainModule main = _sparkles.main;
				main.startColor = new ParticleSystem.MinMaxGradient(Color.Lerp(RankDefs.RankColor(rank), Color.white, 0.35f));
				_sparkles.Play(true);
				_sparkles.Emit(20);
			}
		}

		private ParticleSystem BuildSparkles()
		{
			GameObject gameObject = new GameObject("RankSparkles");
			gameObject.layer = 5;
			gameObject.transform.SetParent(_content, false);
			gameObject.transform.localPosition = new Vector3(0.24f, -0.01f, 0f);
			gameObject.transform.localRotation = Quaternion.Euler(-90f, 0f, 0f);
			ParticleSystem particleSystem = gameObject.AddComponent<ParticleSystem>();
			particleSystem.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
			ParticleSystem.MainModule main = particleSystem.main;
			main.loop = false;
			main.playOnAwake = false;
			main.duration = 1f;
			main.startLifetime = new ParticleSystem.MinMaxCurve(0.7f, 1.2f);
			main.startSpeed = new ParticleSystem.MinMaxCurve(0.5f, 1.1f);
			main.startSize = new ParticleSystem.MinMaxCurve(0.012f, 0.028f);
			main.gravityModifier = 0.12f;
			main.simulationSpace = ParticleSystemSimulationSpace.World;
			main.maxParticles = 64;
			ParticleSystem.EmissionModule emission = particleSystem.emission;
			emission.enabled = false;
			ParticleSystem.ShapeModule shape = particleSystem.shape;
			shape.enabled = true;
			shape.shapeType = ParticleSystemShapeType.Cone;
			shape.angle = 28f;
			shape.radius = 0.05f;
			ParticleSystem.ColorOverLifetimeModule colorOverLifetime = particleSystem.colorOverLifetime;
			colorOverLifetime.enabled = true;
			Gradient gradient = new Gradient();
			gradient.SetKeys(new GradientColorKey[2]
			{
				new GradientColorKey(Color.white, 0f),
				new GradientColorKey(Color.white, 1f)
			}, new GradientAlphaKey[3]
			{
				new GradientAlphaKey(1f, 0f),
				new GradientAlphaKey(1f, 0.5f),
				new GradientAlphaKey(0f, 1f)
			});
			colorOverLifetime.color = new ParticleSystem.MinMaxGradient(gradient);
			ParticleSystemRenderer component = gameObject.GetComponent<ParticleSystemRenderer>();
			Shader shader = Shader.Find("Sprites/Default");
			if (shader != null)
			{
				_sparkleMat = new Material(shader);
				component.material = _sparkleMat;
			}
			SetupRenderer(component);
			return particleSystem;
		}

		private void StartTickLoop()
		{
			if (!(_audio == null) && !(tickClip == null))
			{
				_audio.clip = tickClip;
				_audio.loop = true;
				_audio.Play();
			}
		}

		private void StopTickLoop()
		{
			if (!(_audio == null) && _audio.loop)
			{
				_audio.loop = false;
				_audio.Stop();
			}
		}

		private void PlayOneShot(AudioClip clip)
		{
			if (!(_audio == null) && !(clip == null))
			{
				_audio.PlayOneShot(clip);
			}
		}

		private void OnDestroy()
		{
			if (_active == this)
			{
				_active = null;
			}
			if (_backMat != null)
			{
				UnityEngine.Object.Destroy(_backMat);
			}
			if (_barMat != null)
			{
				UnityEngine.Object.Destroy(_barMat);
			}
			if (_ringMat != null)
			{
				UnityEngine.Object.Destroy(_ringMat);
			}
			if (_textMat != null)
			{
				UnityEngine.Object.Destroy(_textMat);
			}
			if (_fallbackFillMat != null)
			{
				UnityEngine.Object.Destroy(_fallbackFillMat);
			}
			if (_sparkleMat != null)
			{
				UnityEngine.Object.Destroy(_sparkleMat);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_active = null;
			RankIcons = null;
		}
	}
}