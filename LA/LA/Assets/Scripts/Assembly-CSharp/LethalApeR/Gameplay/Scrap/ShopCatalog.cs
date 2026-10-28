using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	[CreateAssetMenu(fileName = "ShopCatalog", menuName = "Slop/Scrap/Shop Catalog")]
	public class ShopCatalog : ScriptableObject
	{
		[Tooltip("Every item the shop offers, across all tabs.")]
		public ShopItemData[] items = new ShopItemData[0];

		private readonly List<ShopItemData> _scratch = new List<ShopItemData>();

		public List<ShopItemData> ForTab(ShopTab tab)
		{
			_scratch.Clear();
			if (items != null)
			{
				for (int i = 0; i < items.Length; i++)
				{
					ShopItemData shopItemData = items[i];
					if (shopItemData != null && shopItemData.tab == tab)
					{
						_scratch.Add(shopItemData);
					}
				}
			}
			return _scratch;
		}
	}
}
