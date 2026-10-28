using System.Text;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnHubBoard : MonoBehaviour
	{
		public TMP_Text title;

		public TMP_Text body;

		private readonly StringBuilder _sb = new StringBuilder(128);

		private FnHub _hub;

		private bool _dirty = true;

		private string _shown;

		private void OnEnable()
		{
			_hub = FnHub.Instance;
			if (_hub != null)
			{
				_hub.Changed += MarkDirty;
			}
			if (title != null)
			{
				title.text = FnStrings.BoardTitle;
			}
			_dirty = true;
		}

		private void OnDisable()
		{
			if (_hub != null)
			{
				_hub.Changed -= MarkDirty;
			}
		}

		private void MarkDirty()
		{
			_dirty = true;
		}

		private void LateUpdate()
		{
			if (!_dirty || body == null)
			{
				return;
			}
			if (_hub == null)
			{
				_hub = FnHub.Instance;
				if (_hub == null)
				{
					return;
				}
				_hub.Changed += MarkDirty;
			}
			_dirty = false;
			_sb.Length = 0;
			for (int i = 0; i < _hub.PadCount; i++)
			{
				FnPadState fnPadState = _hub.Pad(i);
				int num = _hub.PadSize(i);
				if (fnPadState.Locked)
				{
					continue;
				}
				int count = fnPadState.Count;
				if (count != 0 && count < num)
				{
					if (_sb.Length > 0)
					{
						_sb.Append('\n');
					}
					_sb.AppendFormat((fnPadState.Difficulty == FnDifficulty.Nightmare) ? FnStrings.NeedPlayersNightmareFormat : FnStrings.NeedPlayersFormat, FnStrings.SizeName(num), num - count);
				}
			}
			string text = ((_sb.Length > 0) ? _sb.ToString() : FnStrings.BoardIdle);
			if (!(text == _shown))
			{
				_shown = text;
				body.text = text;
			}
		}
	}
}
