using System;
using System.Globalization;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(MenuSurface), typeof(CanvasGroup), typeof(Canvas))]
	public sealed class ReaderPanel : MonoBehaviour
	{
		[SerializeField]
		private MenuArcItem arcItem;

		[SerializeField]
		private MenuButton closeButton;

		[Header("Header")]
		[SerializeField]
		private TMP_Text tagText;

		[SerializeField]
		private RectTransform tagChip;

		[SerializeField]
		private TMP_Text dateText;

		[SerializeField]
		private float chipPadding = 14f;

		[SerializeField]
		private float dateGap = 18f;

		[Header("Body")]
		[SerializeField]
		private MenuScroll scroll;

		[SerializeField]
		private TMP_Text titleText;

		[SerializeField]
		private RawImage image;

		[SerializeField]
		private TMP_Text bodyText;

		[SerializeField]
		private float blockGap = 30f;

		[SerializeField]
		private float maxImageHeight = 460f;

		[SerializeField]
		private float bottomPadding = 24f;

		[Header("Motion")]
		[Tooltip("Radius offset when open (negative = toward the viewer).")]
		[SerializeField]
		private float openOffset = -0.36f;

		[SerializeField]
		private float closedOffset = -0.12f;

		[SerializeField]
		private float openSeconds = 0.28f;

		[SerializeField]
		private float closeSeconds = 0.18f;

		private MenuSurface _surface;

		private CanvasGroup _group;

		private Canvas _canvas;

		private float _t;

		private Vector3 _baseScale;

		public bool IsOpen { get; private set; }

		public event Action<bool> OpenChanged;

		private void Awake()
		{
			_surface = GetComponent<MenuSurface>();
			_group = GetComponent<CanvasGroup>();
			_canvas = GetComponent<Canvas>();
			if (arcItem == null)
			{
				arcItem = GetComponent<MenuArcItem>();
			}
			_baseScale = transform.localScale;
			_surface.ClickedOutside += Close;
			closeButton.Clicked += Close;
			_t = 0f;
			Apply();
		}

		public void Open(MenuContent.Post post)
		{
			tagText.SetText(post.tag.ToString().ToUpperInvariant());
			Vector2 preferredValues = tagText.GetPreferredValues(tagText.text, 1000f, 0f);
			tagChip.sizeDelta = new Vector2(preferredValues.x + chipPadding * 2f, tagChip.sizeDelta.y);
			dateText.SetText(post.TryGetDate(out var value) ? value.ToString("dd MMMM yyyy", CultureInfo.InvariantCulture).ToUpperInvariant() : string.Empty);
			RectTransform rectTransform = dateText.rectTransform;
			rectTransform.anchoredPosition = new Vector2(tagChip.anchoredPosition.x + tagChip.sizeDelta.x + dateGap, rectTransform.anchoredPosition.y);
			Layout(post);
			if (!IsOpen)
			{
				IsOpen = true;
				MenuSurface.Modal = _surface;
				OpenChanged?.Invoke(true);
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
				OpenChanged?.Invoke(false);
			}
		}

		private void Layout(MenuContent.Post post)
		{
			float num = scroll.Rect.rect.width - 28f;
			titleText.SetText(post.title.Trim().ToUpperInvariant());
			float num2 = Place(titleText.rectTransform, 0f, num, titleText.GetPreferredValues(titleText.text, num, 0f).y);
			bool flag = post.image != null;
			image.gameObject.SetActive(flag);
			if (flag)
			{
				float num3 = Mathf.Max(0.1f, (float)post.image.width / (float)Mathf.Max(1, post.image.height));
				float height = Mathf.Min(num / num3, maxImageHeight);
				num2 = Place(image.rectTransform, num2 + blockGap, num, height);
				image.texture = post.image;
				MenuImage.Fill(image, post.image, 0f);
			}
			bodyText.SetText(string.IsNullOrEmpty(post.body) ? string.Empty : post.body.Trim());
			RectTransform rectTransform = bodyText.rectTransform;
			float num4 = Place(rectTransform, num2 + blockGap, num, bodyText.GetPreferredValues(bodyText.text, num, 0f).y);
			scroll.SetContentHeight(num4 + bottomPadding, true);
		}

		private static float Place(RectTransform rt, float y, float width, float height)
		{
			rt.anchoredPosition = new Vector2(0f, 0f - y);
			rt.sizeDelta = new Vector2(width, height);
			return y + height;
		}

		private void Update()
		{
			float num = (IsOpen ? 1f : 0f);
			if (!Mathf.Approximately(_t, num))
			{
				float b = (IsOpen ? openSeconds : closeSeconds);
				_t = Mathf.MoveTowards(_t, num, Time.unscaledDeltaTime / Mathf.Max(0.01f, b));
				Apply();
			}
		}

		private void Apply()
		{
			float num = (IsOpen ? (1f - Mathf.Pow(1f - _t, 3f)) : (_t * _t));
			_group.alpha = num;
			if (_canvas.enabled != num > 0.002f)
			{
				_canvas.enabled = num > 0.002f;
			}
			_surface.Raycastable = IsOpen;
			arcItem.radiusOffset = Mathf.Lerp(closedOffset, openOffset, num);
			arcItem.Apply();
			transform.localScale = _baseScale * Mathf.Lerp(0.97f, 1f, num);
		}
	}
}
