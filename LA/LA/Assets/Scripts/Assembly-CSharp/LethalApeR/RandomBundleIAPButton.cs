using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using LethalApeR.PlayFab;
using Oculus.Platform;
using Oculus.Platform.Models;
using QauthSdk;
using TMPro;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class RandomBundleIAPButton : BaseButton
	{
		[Header("IAP Settings")]
		public TMP_Text price;

		public string sku = "RANDOM_BUNDLE";

		public UnityEvent onPurchase;

		[Header("Random Bundle Items")]
		public List<RandomBundleItem> possibleItems = new List<RandomBundleItem>();

		public TMP_Text itemDisplayText;

		public GameObject buttonVisual;

		[Header("Spin Settings")]
		public float idleSpinInterval = 0.5f;

		public float spinDuration = 3f;

		public float spinStartSpeed = 0.1f;

		public float spinEndSpeed = 0.5f;

		private bool isSpinning;

		private Coroutine idleSpinCoroutine;

		private Coroutine winningSpinCoroutine;

		private int currentDisplayIndex;

		private List<RandomBundleItem> availableItems = new List<RandomBundleItem>();

		private string PendingConsumeKey => "RB_GrantedAwaitingConsume_" + sku;

		private void Start()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn += InitializeIAP;
				PlayFabManager.Instance.OnInventoryUpdated += HandleInventoryUpdated;
				if (PlayFabManager.Instance.IsLoggedIn)
				{
					InitializeIAP();
				}
			}
			else
			{
				StartCoroutine(WaitForManagerAndInit());
			}
		}

		private IEnumerator WaitForManagerAndInit()
		{
			while (PlayFabManager.Instance == null)
			{
				yield return new WaitForSeconds(0.5f);
			}
			PlayFabManager.Instance.OnLoggedIn += InitializeIAP;
			PlayFabManager.Instance.OnInventoryUpdated += HandleInventoryUpdated;
			if (PlayFabManager.Instance.IsLoggedIn)
			{
				InitializeIAP();
			}
		}

		private void HandleInventoryUpdated()
		{
			if (!isSpinning)
			{
				RefreshAvailableItems();
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (!isSpinning && availableItems.Count > 0)
			{
				BuyProduct();
			}
			else if (availableItems.Count == 0)
			{
				Debug.Log("Cannot purchase - player owns all items!");
			}
		}

		private void InitializeIAP()
		{
			RefreshAvailableItems();
			StartIdleSpin();
			if (Core.IsInitialized())
			{
				FetchPrice();
				CheckForUnconsumedPurchases();
			}
			else
			{
				Debug.LogWarning("Oculus Core not initialized — price fetch and unconsumed-purchase check skipped.");
			}
		}

		private void CheckForUnconsumedPurchases()
		{
			Debug.Log("[RandomBundleIAPButton] Checking for unconsumed purchases of SKU: " + sku);
			IAP.GetViewerPurchases().OnComplete(delegate(Message<PurchaseList> msg)
			{
				if (msg.IsError)
				{
					Debug.LogError("[RandomBundleIAPButton] Failed to get viewer purchases: " + msg.GetError().Message);
					return;
				}
				Debug.Log(string.Format("[RandomBundleIAPButton] Found {0} total purchases", msg.Data.Count));
				foreach (Purchase purchase in msg.Data)
				{
					if (purchase.Sku == sku)
					{
						Debug.LogWarning("[RandomBundleIAPButton] ========================================");
						Debug.LogWarning("[RandomBundleIAPButton] FOUND UNCONSUMED RANDOM BUNDLE PURCHASE!");
						Debug.LogWarning("[RandomBundleIAPButton] Purchase ID: " + purchase.ID);
						Debug.LogWarning("[RandomBundleIAPButton] Retrying grant now...");
						Debug.LogWarning("[RandomBundleIAPButton] ========================================");
						RetryUnconsumedPurchase();
						return;
					}
				}
				Debug.Log("[RandomBundleIAPButton] No unconsumed random bundle purchases found");
			});
		}

		private void RetryUnconsumedPurchase()
		{
			if (PlayerPrefs.GetInt(PendingConsumeKey, 0) == 1)
			{
				Debug.Log("[RandomBundleIAPButton] Unconsumed purchase was already granted last run — redeeming only.");
				RedeemOnly();
				return;
			}
			List<RandomBundleItem> list = ((availableItems.Count > 0) ? availableItems : possibleItems);
			if (list.Count == 0)
			{
				Debug.LogError("[RandomBundleIAPButton] Cannot retry — no items configured. Purchase left unconsumed.");
				return;
			}
			RandomBundleItem randomBundleItem = list[GetSecureRandomIndex(list.Count)];
			Debug.Log("[RandomBundleIAPButton] Retrying unconsumed purchase with: " + randomBundleItem.displayName);
			GrantWinningItem(randomBundleItem);
		}

		private async void RedeemOnly()
		{
			QauthRedeemResult result = await RedeemPurchase();
			if (!result.Ok && result.Error != "NOT_PURCHASED")
			{
				Debug.LogError("[RandomBundleIAPButton] Redeem-only retry failed: " + result.Error + " — will retry next startup.");
			}
			else
			{
				PlayerPrefs.DeleteKey(PendingConsumeKey);
				PlayerPrefs.Save();
				Debug.Log("[RandomBundleIAPButton] Dangling purchase redeemed.");
			}
		}

		private async Task<QauthRedeemResult> RedeemPurchase()
		{
			try
			{
				return await Qauth.Addons.RedeemAsync(sku);
			}
			catch (Exception ex)
			{
				return new QauthRedeemResult { Error = ex.Message };
			}
		}

		private void RefreshAvailableItems()
		{
			availableItems.Clear();
			foreach (RandomBundleItem item in possibleItems)
			{
				if (PlayFabManager.Instance.OwnedItems.Any((OwnedItem ownedItem) => string.Equals(ownedItem.ItemId?.Trim(), item.playfabItemId.Trim(), StringComparison.OrdinalIgnoreCase)))
				{
					if (item.cosmeticObject != null)
					{
						item.cosmeticObject.SetActive(false);
					}
				}
				else
				{
					availableItems.Add(item);
				}
			}
			if (availableItems.Count == 0)
			{
				Debug.LogWarning("Player owns all items in the random bundle!");
				if ((bool)price)
				{
					price.text = "All Owned";
				}
				if ((bool)buttonVisual)
				{
					buttonVisual.SetActive(false);
				}
				StopIdleSpin();
				currentDisplayIndex = 0;
				return;
			}
			Debug.Log(string.Format("Available items for random bundle: {0}", availableItems.Count));
			if ((bool)buttonVisual)
			{
				buttonVisual.SetActive(true);
			}
			if (currentDisplayIndex < 0 || currentDisplayIndex >= availableItems.Count)
			{
				currentDisplayIndex = 0;
			}
		}

		private void FetchPrice()
		{
			IAP.GetProductsBySKU(new string[1] { sku }).OnComplete(OnProductFetched);
		}

		private void OnProductFetched(Message<ProductList> msg)
		{
			if (msg.IsError)
			{
				Debug.LogWarning("Error fetching product info for " + sku + ": " + msg.GetError().Message);
			}
			else if (msg.Data.Count > 0 && (bool)price && availableItems.Count > 0)
			{
				price.text = msg.Data[0].FormattedPrice;
			}
		}

		private void StartIdleSpin()
		{
			if (availableItems.Count != 0)
			{
				StopIdleSpin();
				if (currentDisplayIndex < 0 || currentDisplayIndex >= availableItems.Count)
				{
					currentDisplayIndex = 0;
				}
				idleSpinCoroutine = StartCoroutine(IdleSpinCoroutine());
			}
		}

		private void StopIdleSpin()
		{
			if (idleSpinCoroutine != null)
			{
				StopCoroutine(idleSpinCoroutine);
				idleSpinCoroutine = null;
			}
		}

		private IEnumerator IdleSpinCoroutine()
		{
			while (availableItems.Count != 0)
			{
				if (currentDisplayIndex >= availableItems.Count || currentDisplayIndex < 0)
				{
					currentDisplayIndex = 0;
				}
				foreach (RandomBundleItem availableItem in availableItems)
				{
					if (availableItem.cosmeticObject != null)
					{
						availableItem.cosmeticObject.SetActive(false);
					}
				}
				RandomBundleItem randomBundleItem = availableItems[currentDisplayIndex];
				if (randomBundleItem.cosmeticObject != null)
				{
					randomBundleItem.cosmeticObject.SetActive(true);
				}
				if (itemDisplayText != null)
				{
					itemDisplayText.text = randomBundleItem.displayName;
				}
				if (availableItems.Count > 0)
				{
					currentDisplayIndex = (currentDisplayIndex + 1) % availableItems.Count;
				}
				yield return new WaitForSeconds(idleSpinInterval);
			}
		}

		private void BuyProduct()
		{
			if (availableItems.Count == 0)
			{
				Debug.LogWarning("No available items to purchase!");
			}
			else if (Core.IsInitialized())
			{
				IAP.LaunchCheckoutFlow(sku).OnComplete(OnOculusPurchaseCompleteMessage);
			}
		}

		private void OnOculusPurchaseCompleteMessage(Message msg)
		{
			OnPurchaseComplete(msg as Message<Purchase>);
		}

		private void OnPurchaseComplete(Message<Purchase> msg)
		{
			Debug.Log("[RandomBundleIAPButton] OnPurchaseComplete called");
			if (msg == null || msg.IsError)
			{
				Debug.LogError("[RandomBundleIAPButton] Purchase failed: " + ((msg != null) ? msg.GetError().Message : "Unknown error"));
				return;
			}
			Debug.Log("[RandomBundleIAPButton] Purchase successful for SKU: " + sku);
			Debug.Log("[RandomBundleIAPButton] Purchase SKU: " + msg.Data.Sku);
			Debug.Log("[RandomBundleIAPButton] Purchase ID: " + msg.Data.ID);
			Debug.Log("[RandomBundleIAPButton] Starting spin (will consume after successful grant)");
			StartWinningSpin();
		}

		private void StartWinningSpin()
		{
			StopIdleSpin();
			isSpinning = true;
			if (winningSpinCoroutine != null)
			{
				StopCoroutine(winningSpinCoroutine);
			}
			winningSpinCoroutine = StartCoroutine(WinningSpinCoroutine());
		}

		private IEnumerator WinningSpinCoroutine()
		{
			if (availableItems.Count == 0)
			{
				Debug.LogError("No available items for spin! Purchase stays unconsumed — startup check will retry.");
				isSpinning = false;
				yield break;
			}
			int winningIndex = GetSecureRandomIndex(availableItems.Count);
			winningIndex = Mathf.Clamp(winningIndex, 0, availableItems.Count - 1);
			Debug.Log(string.Format("Winning item selected: {0} (Index: {1})", availableItems[winningIndex].displayName, winningIndex));
			float elapsed = 0f;
			int spinCount = 0;
			while (elapsed < spinDuration)
			{
				if (availableItems.Count == 0)
				{
					Debug.LogWarning("Spin stopped: availableItems became empty. Purchase stays unconsumed — startup check will retry.");
					isSpinning = false;
					yield break;
				}
				if (spinCount < 0)
				{
					spinCount = 0;
				}
				if (winningIndex >= availableItems.Count)
				{
					Debug.LogWarning("Winner index no longer valid, rerolling...");
					winningIndex = GetSecureRandomIndex(availableItems.Count);
				}
				float t = elapsed / spinDuration;
				float currentSpeed = Mathf.Lerp(spinStartSpeed, spinEndSpeed, t);
				foreach (RandomBundleItem availableItem in availableItems)
				{
					if (availableItem.cosmeticObject != null)
					{
						availableItem.cosmeticObject.SetActive(false);
					}
				}
				int num = spinCount % availableItems.Count;
				if (num < 0)
				{
					num = 0;
				}
				RandomBundleItem randomBundleItem = availableItems[num];
				if (randomBundleItem.cosmeticObject != null)
				{
					randomBundleItem.cosmeticObject.SetActive(true);
				}
				if (itemDisplayText != null)
				{
					itemDisplayText.text = randomBundleItem.displayName;
				}
				yield return new WaitForSeconds(currentSpeed);
				elapsed += currentSpeed;
				spinCount++;
			}
			foreach (RandomBundleItem availableItem2 in availableItems)
			{
				if (availableItem2.cosmeticObject != null)
				{
					availableItem2.cosmeticObject.SetActive(false);
				}
			}
			if (winningIndex >= availableItems.Count)
			{
				winningIndex = 0;
			}
			RandomBundleItem finalWinner = availableItems[winningIndex];
			LocalProfileManager lpm = LocalProfileManager.Instance;
			if (lpm != null && lpm.OwnsItem(finalWinner.playfabItemId))
			{
				RandomBundleItem randomBundleItem2 = availableItems.FirstOrDefault((RandomBundleItem i) => !lpm.OwnsItem(i.playfabItemId));
				if (randomBundleItem2 != null)
				{
					Debug.LogWarning("[RandomBundleIAPButton] Rolled winner '" + finalWinner.displayName + "' is already owned — rerolled to '" + randomBundleItem2.displayName + "'.");
					finalWinner = randomBundleItem2;
				}
			}
			if (finalWinner.cosmeticObject != null)
			{
				finalWinner.cosmeticObject.SetActive(true);
			}
			if (itemDisplayText != null)
			{
				itemDisplayText.text = finalWinner.displayName;
			}
			Debug.Log("Final winner: " + finalWinner.displayName);
			yield return new WaitForSeconds(1f);
			GrantWinningItem(finalWinner);
		}

		private int GetSecureRandomIndex(int maxValue)
		{
			if (maxValue < 2)
			{
				return 0;
			}
			return UnityEngine.Random.Range(0, maxValue);
		}

		private void GrantWinningItem(RandomBundleItem winner)
		{
			Debug.Log("[RandomBundleIAPButton] Granting winner: " + winner.displayName + " ('" + winner.playfabItemId + "')");
			if (string.IsNullOrEmpty(winner.playfabItemId))
			{
				Debug.LogError("[RandomBundleIAPButton] Winner '" + winner.displayName + "' has no Qauth item ID set! Purchase left unconsumed.");
				isSpinning = false;
				StartIdleSpin();
				return;
			}
			if (LocalProfileManager.Instance == null)
			{
				Debug.LogError("[RandomBundleIAPButton] LocalProfileManager not ready — purchase left unconsumed, retried on next startup.");
				isSpinning = false;
				StartIdleSpin();
				return;
			}
			LocalProfileManager.Instance.GrantItemAtZeroGD(winner.playfabItemId.Trim(), delegate(bool granted)
			{
				if (granted)
				{
					ConsumeThenFinalize(winner);
				}
				else
				{
					Debug.LogError("[RandomBundleIAPButton] Failed to grant '" + winner.playfabItemId + "' — purchase NOT consumed, will retry on next startup. Check the item exists on the Qauth dashboard at 0 coins.");
					if (!(this == null))
					{
						isSpinning = false;
						StartIdleSpin();
					}
				}
			});
		}

		private async void ConsumeThenFinalize(RandomBundleItem winner)
		{
			PlayerPrefs.SetInt(PendingConsumeKey, 1);
			PlayerPrefs.Save();
			QauthRedeemResult result = await RedeemPurchase();
			if (!result.Ok)
			{
				Debug.LogError("[RandomBundleIAPButton] Item granted but Qauth redeem failed: " + result.Error + " — startup check will redeem it without regranting.");
			}
			else
			{
				PlayerPrefs.DeleteKey(PendingConsumeKey);
				PlayerPrefs.Save();
				Debug.Log("[RandomBundleIAPButton] Purchase redeemed.");
			}
			if (this != null)
			{
				FinalizeGrantSuccess(winner);
			}
		}

		private void FinalizeGrantSuccess(RandomBundleItem winner)
		{
			Debug.Log("[RandomBundleIAPButton] Finalizing grant success for " + winner.displayName);
			onPurchase?.Invoke();
			RefreshAvailableItems();
			isSpinning = false;
			StartCoroutine(ResumeAfterWin());
		}

		private IEnumerator ResumeAfterWin()
		{
			yield return new WaitForSeconds(3f);
			if (availableItems.Count == 0)
			{
				if ((bool)price)
				{
					price.text = "All Owned";
				}
				if ((bool)buttonVisual)
				{
					buttonVisual.SetActive(false);
				}
				foreach (RandomBundleItem possibleItem in possibleItems)
				{
					if (possibleItem.cosmeticObject != null)
					{
						possibleItem.cosmeticObject.SetActive(false);
					}
				}
				if (itemDisplayText != null)
				{
					itemDisplayText.text = "All Owned!";
				}
				currentDisplayIndex = 0;
			}
			else
			{
				if (currentDisplayIndex >= availableItems.Count || currentDisplayIndex < 0)
				{
					currentDisplayIndex = 0;
				}
				StartIdleSpin();
			}
		}

		private void OnDestroy()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn -= InitializeIAP;
				PlayFabManager.Instance.OnInventoryUpdated -= HandleInventoryUpdated;
			}
			StopIdleSpin();
			if (winningSpinCoroutine != null)
			{
				StopCoroutine(winningSpinCoroutine);
			}
		}
	}
}
