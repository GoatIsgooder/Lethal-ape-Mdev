using System;
using TMPro;
using UnityEngine;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(MenuSurface), typeof(CanvasGroup), typeof(Canvas))]
	public sealed class MenuNotification : MonoBehaviour
	{
		public enum Icon
		{
			Info = 0,
			Alert = 1
		}

		[SerializeField]
		private MenuRig rig;

		[SerializeField]
		private MenuBlur blur;

		[SerializeField]
		private MenuButton button;

		[Header("Content")]
		[SerializeField]
		private MenuFrame iconRing;

		[SerializeField]
		private TMP_Text iconGlyph;

		[SerializeField]
		private TMP_Text titleText;

		[SerializeField]
		private TMP_Text bodyText;

		[SerializeField]
		private GameObject detailGroup;

		[SerializeField]
		private TMP_Text detailLabel;

		[SerializeField]
		private TMP_Text detailValue;

		[SerializeField]
		private TMP_Text footerText;

		[SerializeField]
		private TMP_Text buttonLabel;

		[Header("Placement")]
		[SerializeField]
		private float distance = 1.3f;

		[Tooltip("Metres relative to the eye.")]
		[SerializeField]
		private float heightOffset = -0.08f;

		[Header("Motion")]
		[SerializeField]
		private float openSeconds = 0.22f;

		[SerializeField]
		private float closeSeconds = 0.16f;

		private MenuSurface _surface;

		private CanvasGroup _group;

		private Canvas _canvas;

		private Vector3 _baseScale;

		private float _t;

		private Action _onClosed;

		public bool IsOpen { get; private set; }

		public event Action<bool> OpenChanged;

		private void Awake()
		{
			_surface = GetComponent<MenuSurface>();
			_group = GetComponent<CanvasGroup>();
			_canvas = GetComponent<Canvas>();
			_baseScale = transform.localScale;
			_surface.ClickedOutside += Close;
			button.Clicked += Close;
			Apply();
		}

		public void Show(string title, string body, Icon icon, string detailCaption = null, string detail = null, string footer = null, string buttonText = "OK", Action onClosed = null, Color? accent = null)
		{
			Color color = accent ?? Color.white;
			iconGlyph.SetText((icon == Icon.Alert) ? "!" : "i");
			iconGlyph.color = color;
			if (iconRing != null)
			{
				iconRing.Border = color;
			}
			titleText.color = color;
			titleText.SetText(title ?? string.Empty);
			bodyText.SetText(body ?? string.Empty);
			if (!string.IsNullOrEmpty(detail))
			{
				detailGroup.SetActive(true);
				detailLabel.SetText(detailCaption ?? string.Empty);
				detailValue.SetText(detail);
			}
			else
			{
				detailGroup.SetActive(false);
			}
			footerText.SetText(footer ?? string.Empty);
			buttonLabel.SetText(string.IsNullOrEmpty(buttonText) ? "OK" : buttonText);
			_onClosed = onClosed;
			if (!IsOpen)
			{
				Place();
				_t = 0f;
				IsOpen = true;
				MenuSurface.Modal = _surface;
				blur.Show();
				OpenChanged?.Invoke(true);
			}
		}

		public void SetDetail(string value)
		{
			if (!(detailValue.text == value))
			{
				detailValue.SetText(value);
			}
		}

		public void Close()
		{
			if (IsOpen)
			{
				IsOpen = false;
				if (MenuSurface.Modal == _surface)
				{
					MenuSurface.Modal = null;
				}
				blur.Hide();
				Action onClosed = _onClosed;
				_onClosed = null;
				OpenChanged?.Invoke(false);
				onClosed?.Invoke();
			}
		}

		private void Place()
		{
			Transform head = rig.Head.transform;
			Vector3 forward = head.forward;
			forward = new Vector3(forward.x, 0f, forward.z);
			if (forward.sqrMagnitude < 0.0001f)
			{
				forward = Vector3.forward;
			}
			forward.Normalize();
			Vector3 position = head.position + forward * distance + Vector3.up * heightOffset;
			transform.SetPositionAndRotation(position, Quaternion.LookRotation(position - head.position));
		}

		private void Update()
		{
			float target = (IsOpen && blur.Ready) ? 1f : 0f;
			if (!Mathf.Approximately(_t, target))
			{
				float seconds = IsOpen ? openSeconds : closeSeconds;
				_t = Mathf.MoveTowards(_t, target, Time.unscaledDeltaTime / Mathf.Max(seconds, 0.01f));
				Apply();
			}
		}

		private void Apply()
		{
			float k = IsOpen ? (1f - Mathf.Pow(1f - _t, 3f)) : (_t * _t);
			_group.alpha = k;
			bool visible = k > 0.002f;
			if (_canvas.enabled != visible)
			{
				_canvas.enabled = visible;
			}
			_surface.Raycastable = IsOpen;
			transform.localScale = _baseScale * Mathf.Lerp(0.96f, 1f, k);
		}
	}
}
