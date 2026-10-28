using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ShopScrollButton : BaseButton
	{
		[Tooltip("The board this scrolls. Auto-found in parents when empty.")]
		public ShopBoard board;

		[Tooltip("On = next item, off = previous item.")]
		public bool next = true;

		private void Awake()
		{
			if (board == null)
			{
				board = GetComponentInParent<ShopBoard>();
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (!(board == null))
			{
				if (next)
				{
					board.ScrollNext();
				}
				else
				{
					board.ScrollPrev();
				}
			}
		}
	}
}
