using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ShopTabButton : BaseButton
	{
		[Tooltip("The board this tab drives. Auto-found in parents when empty.")]
		public ShopBoard board;

		public ShopTab tab;

		[Header("Highlight")]
		public Renderer highlightRenderer;

		public Color activeColor = new Color(1f, 0.85f, 0.25f, 1f);

		public Color inactiveColor = new Color(0.45f, 0.45f, 0.45f, 1f);

		private MaterialPropertyBlock _mpb;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private void Awake()
		{
			if (board == null)
			{
				board = GetComponentInParent<ShopBoard>();
			}
			if (highlightRenderer == null)
			{
				highlightRenderer = GetComponent<Renderer>();
			}
		}

		private void OnEnable()
		{
			if (board != null)
			{
				board.onTabChanged += HandleTabChanged;
				HandleTabChanged(board.CurrentTab);
			}
		}

		private void OnDisable()
		{
			if (board != null)
			{
				board.onTabChanged -= HandleTabChanged;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (board != null)
			{
				board.SetTab(tab);
			}
		}

		private void HandleTabChanged(ShopTab active)
		{
			if (!(highlightRenderer == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				highlightRenderer.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, (tab == active) ? activeColor : inactiveColor);
				highlightRenderer.SetPropertyBlock(_mpb);
			}
		}
	}
}
