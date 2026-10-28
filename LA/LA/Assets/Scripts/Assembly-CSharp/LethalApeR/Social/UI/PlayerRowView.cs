using System;
using LethalApeR.Networking;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Social.UI
{
	public sealed class PlayerRowView : SocialListItem
	{
		public const int ButtonA = 0;

		public const int ButtonB = 1;

		public const int ButtonC = 2;

		[SerializeField]
		private Image colourBar;

		[SerializeField]
		private RawImage portrait;

		[SerializeField]
		private TMP_Text nameLabel;

		[SerializeField]
		private RectTransform tagChip;

		[SerializeField]
		private TMP_Text tagLabel;

		[SerializeField]
		private Image talking;

		[SerializeField]
		private TMP_Text sub;

		[SerializeField]
		private Image subDot;

		[SerializeField]
		private TMP_Text info;

		[SerializeField]
		private Image infoDot;

		[SerializeField]
		private SocialButton[] buttons = new SocialButton[3];

		[SerializeField]
		private float spacing = 10f;

		[SerializeField]
		private float rowPadding = 6f;

		[SerializeField]
		private float talkingWidth = 18f;

		public Action<PlayerRowView, int> ButtonPressed;

		private string _name;

		private string _tag;

		private bool _showTalking;

		private bool _layoutDirty = true;

		private MonkeDevNetworkingPlayer _portraitOf;

		private bool _portraitReady;

		private bool _pressable = true;

		private float _fittedY = float.NaN;

		public string BoundId { get; set; }

		public string BoundName { get; set; }

		public int BoundIndex { get; set; }

		public bool PortraitPending => portrait != null && _portraitOf != null && !_portraitReady;

		private void Awake()
		{
			for (int i = 0; i < buttons.Length; i++)
			{
				int index = i;
				if (buttons[i] != null)
				{
					buttons[i].Pressed += delegate
					{
						ButtonPressed?.Invoke(this, index);
					};
				}
			}
		}

		public SocialButton Button(int index)
		{
			return buttons[index];
		}

		public void SetIdentity(string displayName, Color colour, float opacity)
		{
			if (!string.Equals(_name, displayName, StringComparison.Ordinal))
			{
				_name = displayName;
				nameLabel.text = displayName;
				_layoutDirty = true;
			}
			Color nameColour = ((opacity < 1f) ? SocialStyle.TextGone : SocialStyle.White);
			if (nameLabel.color != nameColour)
			{
				nameLabel.color = nameColour;
			}
			Color barColour = new Color(colour.r, colour.g, colour.b, opacity);
			if (colourBar.color != barColour)
			{
				colourBar.color = barColour;
			}
			if (portrait != null)
			{
				Color portraitColour = new Color(1f, 1f, 1f, opacity);
				if (portrait.color != portraitColour)
				{
					portrait.color = portraitColour;
				}
			}
		}

		public void SetPortrait(MonkeDevNetworkingPlayer player)
		{
			_portraitOf = player;
			_portraitReady = false;
			RefreshPortrait();
		}

		public void RefreshPortrait()
		{
			if (portrait == null || _portraitReady)
			{
				return;
			}
			PlayerPortraits portraits = ((_portraitOf != null) ? PlayerPortraits.Instance : null);
			if (portraits != null && portraits.TryGet(_portraitOf, out var uv))
			{
				_portraitReady = true;
				if (portrait.texture != portraits.Atlas)
				{
					portrait.texture = portraits.Atlas;
				}
				portrait.uvRect = uv;
				if (!portrait.enabled)
				{
					portrait.enabled = true;
				}
			}
			else if (portrait.enabled)
			{
				portrait.enabled = false;
			}
		}

		public void SetTag(string tag)
		{
			if (!(tagChip == null) && !string.Equals(_tag, tag, StringComparison.Ordinal))
			{
				_tag = tag;
				bool empty = string.IsNullOrEmpty(tag);
				tagChip.gameObject.SetActive(!empty);
				if (!empty)
				{
					tagLabel.text = tag;
				}
				_layoutDirty = true;
			}
		}

		public void SetTalkingSlot(bool hasSlot)
		{
			if (_showTalking != hasSlot)
			{
				_showTalking = hasSlot;
				if (!hasSlot && talking != null)
				{
					talking.enabled = false;
				}
				_layoutDirty = true;
			}
		}

		public void SetTalking(bool on)
		{
			if (!(talking == null))
			{
				bool show = _showTalking && on;
				if (talking.enabled != show)
				{
					talking.enabled = show;
				}
			}
		}

		public void SetSub(string text, Color dot, bool tintText = false)
		{
			if (sub == null)
			{
				return;
			}
			if (!string.Equals(sub.text, text, StringComparison.Ordinal))
			{
				sub.text = text;
			}
			Color textColour = (tintText ? dot : SocialStyle.TextFaint);
			if (sub.color != textColour)
			{
				sub.color = textColour;
			}
			if (subDot != null && subDot.color != dot)
			{
				subDot.color = dot;
			}
		}

		public void SetInfo(string text, Color? dot)
		{
			if (info == null)
			{
				return;
			}
			bool empty = string.IsNullOrEmpty(text);
			if (info.gameObject.activeSelf != !empty)
			{
				info.gameObject.SetActive(!empty);
			}
			if (!empty && !string.Equals(info.text, text, StringComparison.Ordinal))
			{
				info.text = text;
			}
			if (infoDot != null)
			{
				bool showDot = !empty && dot.HasValue;
				if (infoDot.gameObject.activeSelf != showDot)
				{
					infoDot.gameObject.SetActive(showDot);
				}
				if (showDot && infoDot.color != dot.Value)
				{
					infoDot.color = dot.Value;
				}
			}
			_layoutDirty = true;
		}

		public void SetButton(int index, string text, ButtonLook look)
		{
			SocialButton button = buttons[index];
			if (!(button == null))
			{
				if (!button.gameObject.activeSelf)
				{
					button.gameObject.SetActive(true);
					_layoutDirty = true;
					if (_pressable)
					{
						button.RefitFinger();
					}
				}
				button.SetText(text);
				button.SetLook(look);
				button.SetFingerEnabled(_pressable && look != ButtonLook.Disabled);
			}
		}

		public void HideButton(int index)
		{
			SocialButton button = buttons[index];
			if (!(button == null) && button.gameObject.activeSelf)
			{
				button.gameObject.SetActive(false);
				_layoutDirty = true;
			}
		}

		public override void SetPressable(bool pressable)
		{
			_pressable = pressable;
			if (pressable)
			{
				FitFingers();
			}
			for (int i = 0; i < buttons.Length; i++)
			{
				SocialButton button = buttons[i];
				if (button != null && button.gameObject.activeSelf)
				{
					button.SetFingerEnabled(pressable && button.Interactable);
				}
			}
		}

		private void FitFingers()
		{
			float y = base.Rect.anchoredPosition.y;
			if (Mathf.Abs(y - _fittedY) < 0.5f)
			{
				return;
			}
			_fittedY = y;
			for (int i = 0; i < buttons.Length; i++)
			{
				SocialButton button = buttons[i];
				if (button != null && button.gameObject.activeSelf)
				{
					button.RefitFinger();
				}
			}
		}

		public void Commit()
		{
			if (!_layoutDirty)
			{
				return;
			}
			_layoutDirty = false;
			float right = base.Rect.rect.width - rowPadding;
			for (int i = 0; i < buttons.Length; i++)
			{
				SocialButton button = buttons[i];
				if (!(button == null) && button.gameObject.activeSelf)
				{
					float left = button.Rect.anchoredPosition.x - button.Rect.rect.width * button.Rect.pivot.x;
					right = Mathf.Min(right, left);
				}
			}
			float x = right - (spacing + 4f);
			if (info != null && info.gameObject.activeSelf)
			{
				RectTransform infoRect = info.rectTransform;
				infoRect.anchoredPosition = new Vector2(x, infoRect.anchoredPosition.y);
				float infoWidth = info.GetPreferredValues(info.text).x;
				float dotWidth = 0f;
				if (infoDot != null && infoDot.gameObject.activeSelf)
				{
					dotWidth = infoDot.rectTransform.rect.width + 8f;
				}
				if (infoDot != null && infoDot.gameObject.activeSelf)
				{
					RectTransform dotRect = infoDot.rectTransform;
					float dotSize = dotRect.rect.width;
					dotRect.anchoredPosition = new Vector2(x - infoWidth - 8f - dotSize * 0.5f, dotRect.anchoredPosition.y);
				}
				x -= infoWidth + dotWidth + spacing * 2f;
			}
			RectTransform nameRect = nameLabel.rectTransform;
			float nameX = nameRect.anchoredPosition.x;
			float tagWidth = 0f;
			float reserved = 0f;
			if (tagChip != null && tagChip.gameObject.activeSelf)
			{
				tagWidth = tagLabel.GetPreferredValues(tagLabel.text).x + 14f;
				tagChip.sizeDelta = new Vector2(tagWidth, tagChip.sizeDelta.y);
				reserved = tagWidth + spacing;
			}
			if (_showTalking && talking != null)
			{
				reserved += talkingWidth + spacing;
			}
			float nameWidth = Mathf.Max(x - nameX - reserved, 40f);
			nameWidth = Mathf.Min(nameLabel.GetPreferredValues(_name ?? "").x + 2f, nameWidth);
			nameRect.sizeDelta = new Vector2(nameWidth, nameRect.sizeDelta.y);
			float cursor = nameX + nameWidth + spacing;
			if (tagWidth > 0f)
			{
				tagChip.anchoredPosition = new Vector2(cursor, tagChip.anchoredPosition.y);
				cursor += tagWidth + spacing;
			}
			if (talking != null)
			{
				RectTransform talkingRect = talking.rectTransform;
				talkingRect.anchoredPosition = new Vector2(cursor, talkingRect.anchoredPosition.y);
			}
			if (sub != null)
			{
				RectTransform subRect = sub.rectTransform;
				float subWidth = Mathf.Max(x - subRect.anchoredPosition.x, 40f);
				subRect.sizeDelta = new Vector2(subWidth, subRect.sizeDelta.y);
			}
		}
	}
}
