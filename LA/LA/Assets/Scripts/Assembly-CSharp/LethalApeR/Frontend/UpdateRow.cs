using System;
using System.Globalization;
using TMPro;
using UnityEngine;

namespace LethalApeR.Frontend
{
	public sealed class UpdateRow : MenuButton
	{
		[Header("Row")]
		[SerializeField]
		private TMP_Text tagText;

		[SerializeField]
		private RectTransform tagChip;

		[SerializeField]
		private TMP_Text dateText;

		[SerializeField]
		private TMP_Text titleText;

		[SerializeField]
		private GameObject newMarker;

		[SerializeField]
		private RectTransform arrow;

		[Header("Layout (canvas units)")]
		[SerializeField]
		private float paddingTop = 26f;

		[SerializeField]
		private float metaHeight = 40f;

		[SerializeField]
		private float gap = 14f;

		[SerializeField]
		private float paddingBottom = 28f;

		[SerializeField]
		private float chipPadding = 14f;

		[SerializeField]
		private float dateGap = 18f;

		[SerializeField]
		private float arrowTravel = 8f;

		private Vector2 _arrowBase;

		public MenuContent.Post Post { get; private set; }

		protected override void Awake()
		{
			if (arrow != null)
			{
				_arrowBase = arrow.anchoredPosition;
			}
			base.Awake();
		}

		public float Bind(MenuContent.Post post, bool unread)
		{
			Post = post;
			tagText.SetText(post.tag.ToString().ToUpperInvariant());
			Vector2 preferredValues = tagText.GetPreferredValues(tagText.text, 1000f, 0f);
			tagChip.sizeDelta = new Vector2(preferredValues.x + chipPadding * 2f, metaHeight);
			dateText.SetText(post.TryGetDate(out var value) ? value.ToString("dd MMM yyyy", CultureInfo.InvariantCulture).ToUpperInvariant() : string.Empty);
			RectTransform rectTransform = dateText.rectTransform;
			rectTransform.anchoredPosition = new Vector2(tagChip.anchoredPosition.x + tagChip.sizeDelta.x + dateGap, rectTransform.anchoredPosition.y);
			SetUnread(unread);
			string text = post.title.Trim().ToUpperInvariant();
			titleText.SetText(text);
			float width = titleText.rectTransform.rect.width;
			float y = titleText.GetPreferredValues("A", width, 0f).y;
			float num = Mathf.Min(titleText.GetPreferredValues(text, width, 0f).y, y * 2.05f);
			RectTransform rectTransform2 = titleText.rectTransform;
			rectTransform2.anchoredPosition = new Vector2(rectTransform2.anchoredPosition.x, 0f - (paddingTop + metaHeight + gap));
			rectTransform2.sizeDelta = new Vector2(rectTransform2.sizeDelta.x, num);
			if (arrow != null)
			{
				_arrowBase = new Vector2(_arrowBase.x, rectTransform2.anchoredPosition.y + num * -0.5f);
				arrow.anchoredPosition = _arrowBase;
			}
			float num2 = paddingTop + metaHeight + gap + num + paddingBottom;
			base.Rect.sizeDelta = new Vector2(base.Rect.sizeDelta.x, num2);
			return num2;
		}

		public void SetUnread(bool unread)
		{
			if (newMarker != null)
			{
				newMarker.SetActive(unread);
			}
		}

		protected override void ApplyVisuals()
		{
			base.ApplyVisuals();
			if (arrow != null)
			{
				arrow.anchoredPosition = _arrowBase + Vector2.right * (arrowTravel * base.Hover01);
			}
		}
	}
}
