using System.Collections;
using LethalApeR.UI.Notifications;
using TMPro;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class CosmeticPurchase : BaseButton
	{
		[Header("UI References")]
		public TMP_Text text;

		[Header("Item Configuration")]
		[SerializeField]
		private string _itemId;

		private int price;

		private bool ownsItem;

		private bool isInitialized;

		private bool isPurchasing;

		public string itemId
		{
			get
			{
				return _itemId;
			}
			set
			{
				_itemId = value;
			}
		}

		private void Awake()
		{
			if (text == null)
			{
				text = GetComponentInChildren<TMP_Text>();
			}
			if (text != null)
			{
				text.text = "Loading...";
			}
		}

		private void Start()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnInventoryUpdated += HandleInventoryUpdated;
			}
		}

		private void OnDestroy()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnInventoryUpdated -= HandleInventoryUpdated;
			}
		}

		private void HandleInventoryUpdated()
		{
			if (isInitialized && !isPurchasing)
			{
				ForceRefresh();
			}
		}

		public void InitializeButton(int cosmeticPrice, bool ownsCosmetic, bool force = false)
		{
			if (!isInitialized || force)
			{
				price = cosmeticPrice;
				ownsItem = ownsCosmetic;
				isInitialized = true;
				UpdateButtonDisplay();
			}
		}

		private void UpdateButtonDisplay()
		{
			if (text == null)
			{
				return;
			}
			if (ownsItem)
			{
				text.text = "<size=70%>OWNED";
				text.color = Color.green;
			}
			else if (price < 0)
			{
				text.text = "N/A";
				text.color = Color.gray;
			}
			else if (price == 0)
			{
				text.text = "FREE";
				text.color = Color.cyan;
			}
			else
			{
				text.text = string.Format("{0}G", price);
				text.color = Color.yellow;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			string trimmedId = _itemId?.Trim();
			if (isPurchasing)
			{
				return;
			}
			if (ownsItem)
			{
				ShowFeedback("<size=70%>Already Owned!", Color.green);
				HandNotifications.Show(NotificationKind.Info, "Already Owned", "You already own " + ItemLabel() + ".");
				return;
			}
			if (!isInitialized || price < 0)
			{
				ShowFeedback("Not Available", Color.red);
				HandNotifications.Show(NotificationKind.Error, "Not Available", ItemLabel() + " can't be bought right now.");
				return;
			}
			if (PlayFabManager.Instance == null)
			{
				ShowFeedback("Error!", Color.red);
				HandNotifications.Show(NotificationKind.Error, "Store Offline", "Not connected to the store — try again in a moment.");
				return;
			}
			if (price > 0 && PlayFabManager.Instance.currencyAmount < price)
			{
				int shortBy = price - PlayFabManager.Instance.currencyAmount;
				ShowFeedback("Not Enough Gold!", Color.red);
				HandNotifications.Show(NotificationKind.Error, "Not Enough Gold", string.Format("{0} costs {1} GD — you're {2} short.", ItemLabel(), price, shortBy));
				return;
			}
			StartPurchase();
		}

		private void StartPurchase()
		{
			isPurchasing = true;
			string trimmedId = _itemId?.Trim();
			if (text != null)
			{
				text.text = "Buying...";
				text.color = Color.white;
			}
			PlayFabManager.Instance.PurchaseItem(trimmedId ?? "", price, false, delegate(bool success)
			{
				isPurchasing = false;
				if (success)
				{
					ownsItem = true;
					UpdateButtonDisplay();
					ShowFeedback("Purchased!", Color.green);
					string body = ((price > 0) ? string.Format("{0} — {1} GD spent.", ItemLabel(), price) : (ItemLabel() + " unlocked."));
					HandNotifications.Show(NotificationKind.Success, "Purchased", body);
				}
				else
				{
					UpdateButtonDisplay();
					ShowFeedback("Purchase Failed!", Color.red);
					HandNotifications.Show(NotificationKind.Error, "Purchase Failed", "The store rejected " + ItemLabel() + ". Your gold was not spent.");
				}
			});
		}

		private void ShowFeedback(string message, Color color)
		{
			if (text != null)
			{
				StopAllCoroutines();
				StartCoroutine(ShowFeedbackCoroutine(message, color));
			}
		}

		private IEnumerator ShowFeedbackCoroutine(string message, Color color)
		{
			text.text = message;
			text.color = color;
			yield return new WaitForSeconds(1.5f);
			UpdateButtonDisplay();
		}

		private string ItemLabel()
		{
			string trimmedId = _itemId?.Trim() ?? "";
			if (LocalProfileManager.Instance != null)
			{
				RemoteCatalogItem catalogItem = LocalProfileManager.Instance.GetCatalogItem(trimmedId);
				if (catalogItem != null && !string.IsNullOrEmpty(catalogItem.DisplayName))
				{
					return catalogItem.DisplayName;
				}
			}
			if (!string.IsNullOrEmpty(trimmedId))
			{
				return trimmedId;
			}
			return "this cosmetic";
		}

		public void ForceRefresh()
		{
			if (!(LocalProfileManager.Instance == null))
			{
				bool ownsCosmetic = LocalProfileManager.Instance.OwnsItem(_itemId);
				int itemPrice = LocalProfileManager.Instance.GetItemPrice(_itemId);
				InitializeButton(itemPrice, ownsCosmetic, force: true);
			}
		}
	}
}
