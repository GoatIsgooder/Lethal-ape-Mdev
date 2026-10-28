using System;
using TMPro;
using UnityEngine;

namespace LethalApeR.Social.UI
{
	public sealed class SectionRowView : SocialListItem
	{
		[SerializeField]
		private TMP_Text title;

		[SerializeField]
		private TMP_Text count;

		[SerializeField]
		private RectTransform rule;

		private string _title;

		private int _count = int.MinValue;

		public void Set(string text, int number)
		{
			if (string.Equals(_title, text, StringComparison.Ordinal) && _count == number)
			{
				return;
			}
			_title = text;
			_count = number;
			title.text = text;
			float x = title.rectTransform.anchoredPosition.x + title.GetPreferredValues(text).x + 10f;
			bool showCount = number >= 0 && count != null;
			if (count != null)
			{
				count.gameObject.SetActive(showCount);
			}
			if (showCount)
			{
				count.text = number.ToString();
				count.rectTransform.anchoredPosition = new Vector2(x, count.rectTransform.anchoredPosition.y);
				x += count.GetPreferredValues(count.text).x + 12f;
			}
			if (!(rule == null))
			{
				if (rule.gameObject.activeSelf != number >= 0)
				{
					rule.gameObject.SetActive(number >= 0);
				}
				float width = base.Rect.rect.width;
				rule.anchoredPosition = new Vector2(x, rule.anchoredPosition.y);
				rule.sizeDelta = new Vector2(Mathf.Max(0f, width - 4f - x), rule.sizeDelta.y);
			}
		}
	}
}
