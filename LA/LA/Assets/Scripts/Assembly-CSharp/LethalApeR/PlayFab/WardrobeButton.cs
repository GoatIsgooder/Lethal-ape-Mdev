using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class WardrobeButton : BaseButton
	{
		public WardrobeButtonType buttonType;

		[Tooltip("Category to jump to (ChangeType buttons only).")]
		public CosmeticType switchCosmeticType;

		[Tooltip("Stand this button drives. Empty = the most recently enabled stand.")]
		public WardrobeManager manager;

		private void Start()
		{
			if (manager == null)
			{
				manager = WardrobeManager.Instance;
			}
			if (manager == null && buttonType != WardrobeButtonType.Refresh)
			{
				Debug.LogError("[WardrobeButton] '" + base.name + "' has no WardrobeManager to drive.", this);
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (buttonType == WardrobeButtonType.Refresh)
			{
				WardrobeManager.ReloadFromServer();
				return;
			}
			if (manager == null)
			{
				manager = WardrobeManager.Instance;
			}
			if (manager == null)
			{
				return;
			}
			switch (buttonType)
			{
			case WardrobeButtonType.Up:
				manager.ScrollCosmetic(true);
				break;
			case WardrobeButtonType.Down:
				manager.ScrollCosmetic(false);
				break;
			case WardrobeButtonType.Equip:
				manager.UseCosmetic(true);
				break;
			case WardrobeButtonType.Unequip:
				manager.UseCosmetic(false);
				break;
			case WardrobeButtonType.ChangeType:
				manager.ShowCategory(switchCosmeticType);
				break;
			}
		}
	}
}
