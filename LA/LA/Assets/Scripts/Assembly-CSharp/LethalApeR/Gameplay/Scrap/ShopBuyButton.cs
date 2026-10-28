using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ShopBuyButton : BaseButton
	{
		[Tooltip("The board this button buys from. Auto-found in parents when empty.")]
		public ShopBoard board;

		[Header("Feedback")]
		public Renderer flashRenderer;

		public Color idleColor = new Color(0.85f, 0.85f, 0.85f, 1f);

		public Color successColor = new Color(0.25f, 1f, 0.35f, 1f);

		public Color denyColor = new Color(1f, 0.25f, 0.2f, 1f);

		[Tooltip("Seconds the result color takes to settle back to idle.")]
		public float flashFade = 0.6f;

		[Range(0f, 1f)]
		public float successHaptic = 0.75f;

		private MaterialPropertyBlock _mpb;

		private Color _current;

		private Color _flashColor;

		private float _flashT = 1f;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private void Awake()
		{
			if (board == null)
			{
				board = GetComponentInParent<ShopBoard>();
			}
			if (flashRenderer == null)
			{
				flashRenderer = GetComponent<Renderer>();
			}
			_flashColor = idleColor;
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (board == null)
			{
				return;
			}
			ShopBoard.PurchaseResult purchaseResult = board.TryBuyFocused();
			if (purchaseResult == ShopBoard.PurchaseResult.Busy)
			{
				return;
			}
			if (purchaseResult == ShopBoard.PurchaseResult.Purchased)
			{
				Flash(successColor);
				if (VRInputController.Instance != null)
				{
					if (isLeft)
					{
						VRInputController.Instance.PulseLeft(successHaptic, 0.15f);
					}
					else
					{
						VRInputController.Instance.PulseRight(successHaptic, 0.15f);
					}
				}
			}
			else
			{
				Flash(denyColor);
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
				_flashT = Mathf.MoveTowards(_flashT, 1f, Time.deltaTime / Mathf.Max(0.05f, flashFade));
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
