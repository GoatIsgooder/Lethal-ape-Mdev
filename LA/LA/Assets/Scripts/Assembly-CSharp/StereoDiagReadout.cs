using System;
using System.IO;
using LethalApeR.PlayFab;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

[DefaultExecutionOrder(-10000)]
[DisallowMultipleComponent]
public class StereoDiagReadout : MonoBehaviour
{
	[Tooltip("Seconds to hold the loading screen so you can read the report. 0 = don't hold.")]
	[SerializeField]
	private float holdSeconds = 30f;

	[Tooltip("Show the full per-sample detail instead of just the summary. Small text.")]
	[SerializeField]
	private bool showFullDetail;

	[Tooltip("Optional. Leave null and a world-space panel is created in front of the camera.")]
	[SerializeField]
	private TMP_Text target;

	[Tooltip("Metres in front of the camera to place the auto-created panel.")]
	[SerializeField]
	private float distance = 1.8f;

	private LoadingScreenAuth _held;

	private float _releaseAt;

	private string _body = "";

	private void Awake()
	{
		_body = ReadReport(showFullDetail);
		if (holdSeconds > 0f)
		{
			_held = UnityEngine.Object.FindAnyObjectByType<LoadingScreenAuth>();
			if (_held != null && _held.enabled)
			{
				_held.enabled = false;
				_releaseAt = Time.unscaledTime + holdSeconds;
			}
			else
			{
				_held = null;
			}
		}
	}

	private void Start()
	{
		if (target == null)
		{
			target = BuildPanel();
		}
		Render();
	}

	private void Update()
	{
		if (_held == null)
		{
			return;
		}
		if (Time.unscaledTime < _releaseAt)
		{
			Render();
			return;
		}
		_held.enabled = true;
		_held = null;
		if (target != null)
		{
			target.text = _body + "\n\n<color=#7FBFFF>continuing...</color>";
		}
	}

	private void Render()
	{
		if (!(target == null))
		{
			string text = ((_held != null) ? ("\n\n<color=#7FBFFF>continuing in " + Mathf.CeilToInt(_releaseAt - Time.unscaledTime) + "s</color>") : "");
			target.text = _body + text;
		}
	}

	private static string ReadReport(bool full)
	{
		string reportPath = StereoDiagnostics.ReportPath;
		try
		{
			if (!File.Exists(reportPath))
			{
				return "<color=#FFD37F>STEREO DIAG - no report yet</color>\n\nThis is run 1. Load into MainScene, let the eyes break,\nwait ~10s, quit the app, then relaunch.\nRun 2 will show the numbers here.\n\n<size=60%>" + reportPath + "</size>";
			}
			string text = File.ReadAllText(reportPath);
			if (string.IsNullOrWhiteSpace(text))
			{
				return "<color=#FF8080>Report file is empty.</color>";
			}
			if (full)
			{
				return text;
			}
			int num = text.IndexOf("---- detail ----", StringComparison.Ordinal);
			if (num > 0)
			{
				return text.Substring(0, num).TrimEnd();
			}
			return text;
		}
		catch (Exception ex)
		{
			return "<color=#FF8080>Read failed:</color> " + ex.Message + "\n" + reportPath;
		}
	}

	private TMP_Text BuildPanel()
	{
		Camera main = Camera.main;
		GameObject gameObject = new GameObject("[StereoDiag] Panel");
		gameObject.AddComponent<Canvas>().renderMode = RenderMode.WorldSpace;
		gameObject.AddComponent<CanvasScaler>();
		RectTransform rectTransform = (RectTransform)gameObject.transform;
		rectTransform.sizeDelta = new Vector2(1600f, 1000f);
		rectTransform.localScale = Vector3.one * 0.001f;
		if (main != null)
		{
			rectTransform.SetParent(main.transform, false);
			rectTransform.localPosition = new Vector3(0f, 0f, distance);
			rectTransform.localRotation = Quaternion.identity;
		}
		else
		{
			rectTransform.position = new Vector3(0f, 1.5f, distance);
		}
		GameObject gameObject2 = new GameObject("BG", typeof(RectTransform), typeof(Image));
		gameObject2.transform.SetParent(gameObject.transform, false);
		RectTransform obj = (RectTransform)gameObject2.transform;
		obj.anchorMin = Vector2.zero;
		obj.anchorMax = Vector2.one;
		obj.offsetMin = Vector2.zero;
		obj.offsetMax = Vector2.zero;
		gameObject2.GetComponent<Image>().color = new Color(0.04f, 0.04f, 0.06f, 0.94f);
		GameObject gameObject3 = new GameObject("Text", typeof(RectTransform));
		gameObject3.transform.SetParent(gameObject.transform, false);
		RectTransform obj2 = (RectTransform)gameObject3.transform;
		obj2.anchorMin = Vector2.zero;
		obj2.anchorMax = Vector2.one;
		obj2.offsetMin = new Vector2(40f, 40f);
		obj2.offsetMax = new Vector2(-40f, -40f);
		TextMeshProUGUI textMeshProUGUI = gameObject3.AddComponent<TextMeshProUGUI>();
		textMeshProUGUI.font = TMP_Settings.defaultFontAsset;
		textMeshProUGUI.fontSize = (showFullDetail ? 22f : 40f);
		textMeshProUGUI.textWrappingMode = TextWrappingModes.NoWrap;
		textMeshProUGUI.overflowMode = TextOverflowModes.Overflow;
		textMeshProUGUI.alignment = TextAlignmentOptions.TopLeft;
		textMeshProUGUI.color = Color.white;
		textMeshProUGUI.richText = true;
		if (textMeshProUGUI.font == null)
		{
			Debug.LogWarning("[StereoDiagReadout] TMP_Settings.defaultFontAsset is null - panel will be blank. Assign a TMP_Text to 'target' instead.");
		}
		return textMeshProUGUI;
	}
}
