using System;
using System.Linq;
using System.Reflection;
using LethalApeR.PlayFab;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class IAPManager : MonoBehaviour
	{
		public void Start()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn += OnLoggedIn;
			}
		}

		private void OnDestroy()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn -= OnLoggedIn;
			}
		}

		public void OnLoggedIn()
		{
			if (PlayFabManager.Instance.OwnedItems.Any((OwnedItem item) => string.Equals(item.ItemId, "VIPB", StringComparison.OrdinalIgnoreCase)))
			{
				Debug.Log("[IAPManager] Player owns VIP");
			}
		}

		public void BundleReward(string itemID)
		{
			BundleReward(itemID, null);
		}

		public void BundleReward(string itemID, Action<bool> onComplete = null)
		{
			Debug.Log("[IAPManager] BundleReward called for: " + itemID);
			if (LocalProfileManager.Instance == null)
			{
				Debug.LogError("[IAPManager] LocalProfileManager not ready!");
				onComplete?.Invoke(false);
				return;
			}
			LocalProfileManager.Instance.GrantItemAtZeroGD(itemID, delegate(bool granted)
			{
				if (granted)
				{
					Debug.Log("[IAPManager] Granted and verified " + itemID);
					WardrobeManager.RefreshAll();
					if (PlayFabManager.Instance != null)
					{
						PlayFabManager.Instance.NotifyInventoryUpdated();
					}
				}
				else
				{
					Debug.LogError("[IAPManager] Failed to grant '" + itemID + "' at 0 GD");
				}
				onComplete?.Invoke(granted);
			});
		}
	}
}
