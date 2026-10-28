using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	[CreateAssetMenu(fileName = "ShopItem_", menuName = "Slop/Scrap/Shop Item")]
	public class ShopItemData : ScriptableObject
	{
		[Header("Identity")]
		public string displayName = "Item";

		public ItemKind kind;

		public ShopTab tab;

		public Sprite icon;

		[Header("Price")]
		[Tooltip("Scrap credits to buy. Spent from the buyer's own wallet.")]
		[Min(0f)]
		public int price = 100;

		[Header("Availability")]
		[Tooltip("Off = 'COMING SOON' (e.g. monster-scanner / powerups whose code lives in another project). The entry shows but can't be bought.")]
		public bool available = true;

		[Header("Spawn")]
		[Tooltip("On = grant via PhotonNetwork.Instantiate (grenade / landmine — networked, host-replicated). Off = local Object.Instantiate (lidar / camcorder / scanner — client-local tools).")]
		public bool networkedSpawn;

		[Tooltip("LOCAL spawn prefab (when networkedSpawn is off). Object.Instantiate'd on the buyer.")]
		public GameObject localPrefab;

		[Tooltip("NETWORKED spawn name (when networkedSpawn is on). Must resolve from a Resources folder, e.g. \"Systems/Landmine\". PhotonNetwork.Instantiate'd by the buyer.")]
		public string networkPrefabName = "";

		[Tooltip("Optional showcase model shown on the board (defaults to localPrefab).")]
		public GameObject displayPrefab;

		public bool CanSpawn
		{
			get
			{
				if (!available)
				{
					return false;
				}
				if (networkedSpawn)
				{
					return !string.IsNullOrEmpty(networkPrefabName);
				}
				return localPrefab != null;
			}
		}
	}
}
