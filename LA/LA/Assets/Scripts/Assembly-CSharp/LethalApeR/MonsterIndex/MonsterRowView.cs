using System;
using LethalApeR.Social.UI;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.MonsterIndex
{
	public sealed class MonsterRowView : SocialListItem
	{
		[SerializeField]
		private SocialButton button;

		[SerializeField]
		private RawImage thumbnail;

		[Tooltip("The ? shown in the thumbnail's place until the monster is in the player's index.")]
		[SerializeField]
		private TMP_Text unknownMark;

		[SerializeField]
		private TMP_Text nameLabel;

		[SerializeField]
		private Image selectedBar;

		public Action<int> Pressed;

		private int _index = -1;

		private bool _selected;

		private bool _styled;

		private float _fittedY = float.NaN;

		private void Awake()
		{
			if (button != null)
			{
				button.Pressed += delegate
				{
					Pressed?.Invoke(_index);
				};
			}
		}

		public void Bind(int index, MonsterIndexEntry entry, Texture atlas, bool selected, bool found)
		{
			_index = index;
			string text = (found ? entry.displayName : "???");
			if (!string.Equals(nameLabel.text, text, StringComparison.Ordinal))
			{
				nameLabel.text = text;
			}
			bool flag = found && atlas != null && entry.thumbnailRect.width > 0f;
			if (thumbnail.enabled != flag)
			{
				thumbnail.enabled = flag;
			}
			if (flag)
			{
				if (thumbnail.texture != atlas)
				{
					thumbnail.texture = atlas;
				}
				if (thumbnail.uvRect != entry.thumbnailRect)
				{
					thumbnail.uvRect = entry.thumbnailRect;
				}
			}
			if (unknownMark.enabled == found)
			{
				unknownMark.enabled = !found;
			}
			SetSelected(selected);
		}

		public void SetSelected(bool selected)
		{
			if (!_styled || _selected != selected)
			{
				_selected = selected;
				_styled = true;
				button.SetLook(selected ? ButtonLook.Segment : ButtonLook.Tab);
				selectedBar.enabled = selected;
				nameLabel.color = (selected ? SocialStyle.White : SocialStyle.TextMuted);
			}
		}

		public override void SetPressable(bool pressable)
		{
			if (pressable)
			{
				float y = base.Rect.anchoredPosition.y;
				if (!(Mathf.Abs(y - _fittedY) < 0.5f))
				{
					_fittedY = y;
					button.RefitFinger();
				}
			}
			button.SetFingerEnabled(pressable);
		}
	}
}
