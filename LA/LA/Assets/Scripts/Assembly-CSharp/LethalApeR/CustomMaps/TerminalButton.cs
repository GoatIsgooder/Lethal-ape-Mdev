using System;
using System.Reflection;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.CustomMaps
{
	[Obfuscation(Exclude = true)]
	public sealed class TerminalButton : BaseButton
	{
		private const float Cooldown = 0.35f;

		private const float FlashSeconds = 0.18f;

		private Action _onPress;

		private Image _background;

		private Color _normal;

		private Color _flash;

		private float _pressedAt = -10f;

		private bool _interactable = true;

		public bool Interactable
		{
			get
			{
				return _interactable;
			}
			set
			{
				_interactable = value;
				if (_background != null)
				{
					_background.color = new Color(_normal.r, _normal.g, _normal.b, value ? _normal.a : (_normal.a * 0.35f));
				}
			}
		}

		public void Init(Action onPress, Image background, Color normal, Color flash)
		{
			_onPress = onPress;
			_background = background;
			_normal = normal;
			_flash = flash;
			if (_background != null)
			{
				_background.color = _normal;
			}
			base.enabled = false;
		}

		public void SetAction(Action onPress)
		{
			_onPress = onPress;
		}

		public void SetColors(Color normal, Color flash)
		{
			_normal = normal;
			_flash = flash;
			if (_background != null && Time.time - _pressedAt > 0.18f)
			{
				_background.color = _normal;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (_interactable && !(Time.time - _pressedAt < 0.35f))
			{
				_pressedAt = Time.time;
				if (_background != null)
				{
					_background.color = _flash;
				}
				base.enabled = true;
				_onPress?.Invoke();
			}
		}

		public override void ButtonVisuals(bool isLeft)
		{
			if (_interactable)
			{
				base.ButtonVisuals(isLeft);
				MapTerminal.Click();
			}
		}

		private void Update()
		{
			if (!(Time.time - _pressedAt < 0.18f))
			{
				if (_background != null && _interactable)
				{
					_background.color = _normal;
				}
				base.enabled = false;
			}
		}
	}
}
