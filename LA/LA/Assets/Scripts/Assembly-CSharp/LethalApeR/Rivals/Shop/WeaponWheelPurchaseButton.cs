using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Rivals.Shop
{
	public class WeaponWheelPurchaseButton : BaseButton
	{
		[Tooltip("The wheel this button buys from. Auto-found in parents when empty.")]
		public WeaponWheel wheel;

		[Header("Feedback")]
		public Renderer flashRenderer;

		public Color idleColor = new Color(0.85f, 0.85f, 0.85f, 1f);

		public Color successColor = new Color(0.25f, 1f, 0.35f, 1f);

		public Color denyColor = new Color(1f, 0.25f, 0.2f, 1f);

		[Tooltip("Seconds the result color takes to settle back to idle.")]
		public float flashFade = 0.6f;

		[Tooltip("Extra success buzz on top of BaseButton's press haptic.")]
		[Range(0f, 1f)]
		public float successHaptic = 0.7f;

		private MaterialPropertyBlock _mpb;

		private Color _current;

		private float _flashT = 1f;

		private Color _flashColor;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private void Awake()
		{
			if (wheel == null)
			{
				wheel = GetComponentInParent<WeaponWheel>();
			}
			if (flashRenderer == null)
			{
				flashRenderer = GetComponent<Renderer>();
			}
			_flashColor = idleColor;
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (wheel == null)
			{
				return;
			}
			switch (wheel.TryPurchaseFocused())
			{
			case WeaponWheel.PurchaseResult.AlreadyOwned:
				break;
			case WeaponWheel.PurchaseResult.Purchased:
			{
				Flash(successColor);
				VRInputController instance = VRInputController.Instance;
				if (instance != null)
				{
					if (isLeft)
					{
						instance.PulseLeft(successHaptic, 0.15f);
					}
					else
					{
						instance.PulseRight(successHaptic, 0.15f);
					}
				}
				break;
			}
			default:
				Flash(denyColor);
				break;
			}
		}

		private void Flash(Color c)
		{
			_flashColor = c;
			_flashT = 0f;
		}

		private void Update()
		{
			if (!(flashRenderer == null))
			{
				_flashT = Mathf.MoveTowards(_flashT, 1f, Time.deltaTime / Mathf.Max(flashFade, 0.05f));
				Color color = Color.Lerp(_flashColor, idleColor, _flashT);
				if (!(_flashT >= 1f) || !(color == _current))
				{
					_current = color;
					if (_mpb == null)
					{
						_mpb = new MaterialPropertyBlock();
					}
					flashRenderer.GetPropertyBlock(_mpb);
					_mpb.SetColor(ColorId, color);
					flashRenderer.SetPropertyBlock(_mpb);
				}
			}
		}
	}
}
