using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Social.UI
{
	public sealed class SocialButton : MonoBehaviour, IFingerReceiver
	{
		[SerializeField]
		private Image background;

		[SerializeField]
		private TMP_Text label;

		[SerializeField]
		private Image icon;

		[SerializeField]
		private Image hoverRing;

		[SerializeField]
		private Image badge;

		[SerializeField]
		private TMP_Text badgeLabel;

		[SerializeField]
		private RectTransform face;

		[Tooltip("Label material for light text on dark buttons.")]
		[SerializeField]
		private Material textMaterial;

		[Tooltip("Heavier label material for dark text on the white looks: thin dark strokes on white read lighter in linear colour.")]
		[SerializeField]
		private Material inkMaterial;

		[SerializeField]
		[Min(0f)]
		private float cooldown = 0.3f;

		private const float PressSeconds = 0.16f;

		private ButtonLook _look;

		private bool _styled;

		private string _text;

		private bool _hovered;

		private int _badgeCount = -1;

		private float _press;

		private float _readyAt;

		private MenuPressGate _gate;

		private bool _gateSearched;

		private FingerHitVolume _hit;

		private bool _hitSearched;

		private Color _restColour;

		public RectTransform Rect => base.transform as RectTransform;

		public ButtonLook Look => _look;

		public bool Interactable
		{
			get
			{
				if (_look != ButtonLook.Disabled)
				{
					return base.gameObject.activeInHierarchy;
				}
				return false;
			}
		}

		public string Text => _text;

		public event Action Pressed;

		private void Awake()
		{
			base.enabled = false;
			if (hoverRing != null)
			{
				hoverRing.enabled = false;
			}
		}

		public void Set(string text, ButtonLook look)
		{
			SetText(text);
			SetLook(look);
		}

		public void SetText(string text)
		{
			if (!(label == null) && !string.Equals(_text, text, StringComparison.Ordinal))
			{
				_text = text;
				label.text = text;
			}
		}

		public void SetLook(ButtonLook look)
		{
			if (_styled && _look == look)
			{
				return;
			}
			_styled = true;
			_look = look;
			Colours(look, out var bg, out var fg);
			_restColour = bg;
			if (background != null)
			{
				background.color = bg;
			}
			if (label != null)
			{
				label.color = fg;
				Material material = ((look == ButtonLook.TabSelected || look == ButtonLook.Primary || look == ButtonLook.SegmentOn) ? inkMaterial : textMaterial);
				if (material != null && label.fontSharedMaterial != material)
				{
					label.fontSharedMaterial = material;
				}
			}
			if (icon != null)
			{
				icon.color = fg;
			}
			if (hoverRing != null && _hovered && !Interactable)
			{
				hoverRing.enabled = false;
			}
		}

		public void SetVisible(bool visible)
		{
			if (base.gameObject.activeSelf != visible)
			{
				base.gameObject.SetActive(visible);
			}
		}

		public void SetHovered(bool hovered)
		{
			if (_hovered != hovered)
			{
				_hovered = hovered;
				if (hoverRing != null)
				{
					hoverRing.enabled = hovered && Interactable;
				}
			}
		}

		public void SetBadge(int count)
		{
			if (!(badge == null) && _badgeCount != count)
			{
				_badgeCount = count;
				if (badge.gameObject.activeSelf != count > 0)
				{
					badge.gameObject.SetActive(count > 0);
				}
				if (count >= 1 && badgeLabel != null)
				{
					badgeLabel.text = ((count > 99) ? "99" : count.ToString());
				}
			}
		}

		public void SetFingerEnabled(bool on)
		{
			if (!_hitSearched)
			{
				_hitSearched = true;
				_hit = GetComponentInChildren<FingerHitVolume>(true);
			}
			if (_hit != null)
			{
				_hit.SetEnabled(on);
			}
		}

		public void RefitFinger()
		{
			if (!_hitSearched)
			{
				_hitSearched = true;
				_hit = GetComponentInChildren<FingerHitVolume>(true);
			}
			if (_hit != null && _hit.OnDrum)
			{
				_hit.Place();
			}
		}

		public bool TryPress(PressSource source, bool leftHand)
		{
			if (!Interactable)
			{
				return false;
			}
			float now = Time.unscaledTime;
			if (now < _readyAt)
			{
				return false;
			}
			if (!_gateSearched)
			{
				_gateSearched = true;
				_gate = MenuPressGate.Find(this);
			}
			if (_gate != null && !_gate.TryPress(this))
			{
				return false;
			}
			_press = 1f;
			_readyAt = now + cooldown;
			base.enabled = true;
			SocialStyle.PlayPress();
			if (source == PressSource.Finger)
			{
				SocialStyle.Pulse(leftHand, 0.35f, 0.04f);
			}
			try
			{
				this.Pressed?.Invoke();
			}
			catch (Exception exception)
			{
				Debug.LogException(exception, this);
			}
			return true;
		}

		void IFingerReceiver.FingerEnter(Collider finger, bool leftHand)
		{
			TryPress(PressSource.Finger, leftHand);
		}

		void IFingerReceiver.FingerExit(Collider finger)
		{
		}

		private void Update()
		{
			_press = Mathf.MoveTowards(_press, 0f, Time.unscaledDeltaTime / PressSeconds);
			float t = _press * _press;
			if (face != null)
			{
				face.localScale = Vector3.one * (1f - t * 0.05f);
			}
			if (background != null)
			{
				background.color = Color.Lerp(_restColour, Color.white, t * 0.22f);
			}
			if (_press <= 0f)
			{
				base.enabled = false;
			}
		}

		private void OnDisable()
		{
			_press = 0f;
			if (face != null)
			{
				face.localScale = Vector3.one;
			}
			if (background != null && _styled)
			{
				background.color = _restColour;
			}
			if (!base.gameObject.activeInHierarchy)
			{
				SetHovered(false);
			}
		}

		private static void Colours(ButtonLook look, out Color bg, out Color fg)
		{
			switch (look)
			{
			case ButtonLook.Primary:
			case ButtonLook.TabSelected:
			case ButtonLook.SegmentOn:
				bg = SocialStyle.White;
				fg = SocialStyle.Ink;
				break;
			case ButtonLook.Danger:
				bg = SocialStyle.Button;
				fg = SocialStyle.Danger;
				break;
			case ButtonLook.Confirm:
				bg = SocialStyle.Confirm;
				fg = Color.white;
				break;
			case ButtonLook.Disabled:
				bg = SocialStyle.ButtonOff;
				fg = SocialStyle.TextOff;
				break;
			case ButtonLook.Tab:
				bg = SocialStyle.Tile;
				fg = SocialStyle.TextSoft;
				break;
			default:
				bg = SocialStyle.Button;
				fg = SocialStyle.White;
				break;
			}
		}
	}
}
