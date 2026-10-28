using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
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
	public class IAPButton : BaseButton
	{
		public static readonly List<IAPButton> AllButtons = new List<IAPButton>();

		[Header("Oculus IAP")]
		public TMP_Text price;

		public string sku;

		public string[] legacySKUs;

		[Header("Qauth")]
		public string playfabItemId;

		[Header("Events")]
		public UnityEvent onPurchase;

		private bool _owned;

		public string PlayFabItemId => (!string.IsNullOrEmpty(playfabItemId)) ? playfabItemId : sku;

		private void Awake()
		{
			if (!string.IsNullOrEmpty(sku))
			{
				AllButtons.Add(this);
			}
		}

		private void Start()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn += InitializeIAP;
				if (PlayFabManager.Instance.IsLoggedIn)
				{
					CheckOwnershipInPlayFab();
					FetchOculusPrice();
				}
			}
			else
			{
				StartCoroutine(WaitForManagerAndInit());
			}
		}

		private void OnDestroy()
		{
			AllButtons.Remove(this);
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn -= InitializeIAP;
			}
		}

		private IEnumerator WaitForManagerAndInit()
		{
			while (PlayFabManager.Instance == null)
			{
				yield return new WaitForSeconds(0.5f);
			}
			PlayFabManager.Instance.OnLoggedIn += InitializeIAP;
			if (PlayFabManager.Instance.IsLoggedIn)
			{
				CheckOwnershipInPlayFab();
				FetchOculusPrice();
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			BuyProduct();
		}

		private void InitializeIAP()
		{
			CheckOwnershipInPlayFab();
			FetchOculusPrice();
		}

		private void CheckOwnershipInPlayFab()
		{
			if (LocalProfileManager.Instance == null)
			{
				return;
			}
			if (LocalProfileManager.Instance.OwnsItem(GetItemId()))
			{
				SetOwned();
				return;
			}
			if (legacySKUs != null)
			{
				string[] array = legacySKUs;
				foreach (string text in array)
				{
					string itemId = ((!string.IsNullOrEmpty(playfabItemId)) ? playfabItemId : text);
					if (LocalProfileManager.Instance.OwnsItem(itemId))
					{
						SetOwned();
						return;
					}
				}
			}
			if (Core.IsInitialized())
			{
				FetchAllOculusPurchases(ProcessOculusPurchases);
			}
		}

		private void FetchAllOculusPurchases(Action<HashSet<string>> callback)
		{
			IAP.GetViewerPurchases().OnComplete(delegate(Message<PurchaseList> msg)
			{
				HashSet<string> hashSet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
				if (msg.IsError)
				{
					Debug.LogWarning("[IAPButton:" + sku + "] Error fetching purchases: " + msg.GetError().Message);
				}
				else
				{
					foreach (Purchase datum in msg.Data)
					{
						hashSet.Add(datum.Sku);
					}
				}
				callback(hashSet);
			});
		}

		private void ProcessOculusPurchases(HashSet<string> ownedSkus)
		{
			if (ownedSkus.Contains(sku))
			{
				SetOwned();
				GrantAtZeroGD(sku);
			}
			else
			{
				if (legacySKUs == null)
				{
					return;
				}
				string[] array = legacySKUs;
				foreach (string item in array)
				{
					if (ownedSkus.Contains(item))
					{
						SetOwned();
						GrantAtZeroGD(item);
						break;
					}
				}
			}
		}

		private async void GrantAtZeroGD(string ownedSku)
		{
			string itemId = GetItemId();
			QauthRedeemResult result;
			try
			{
				result = await Qauth.Addons.RedeemAsync(ownedSku);
			}
			catch (Exception ex)
			{
				result = new QauthRedeemResult { Error = ex.Message };
			}
			if (this == null)
			{
				return;
			}
			if (result.Ok)
			{
				LocalProfileManager.Instance?.AddOwnedItem(itemId);
				SetOwned();
				onPurchase?.Invoke();
				WardrobeManager.RefreshAll();
				PlayFabManager.Instance?.NotifyInventoryUpdated();
			}
			else
			{
				Debug.LogError("[IAPButton:" + sku + "] Qauth redeem failed for '" + ownedSku + "' (" + result.Error + ") — Oculus entitlement is intact; pressing the button again retries via ForceResync.");
			}
		}

		private void SetPriceText(string text)
		{
			if (price != null && !_owned)
			{
				price.text = text;
			}
		}

		private void FetchOculusPrice()
		{
			if (string.IsNullOrEmpty(sku))
			{
				Debug.LogWarning("[IAPButton] sku field is empty on this button — set it in the Inspector to the SKU registered in the Oculus dashboard.");
				SetPriceText("NO SKU");
			}
			else if (!Core.IsInitialized())
			{
				Debug.LogWarning("[IAPButton:" + sku + "] Oculus Core not initialized — can't fetch price. Make sure something calls Core.AsyncInitialize() at app start.");
				SetPriceText("…");
				StartCoroutine(RetryFetchAfter(3f));
			}
			else
			{
				Debug.Log("[IAPButton:" + sku + "] Requesting price from Oculus IAP…");
				IAP.GetProductsBySKU(new string[1] { sku }).OnComplete(OnProductFetched);
			}
		}

		private IEnumerator RetryFetchAfter(float delay)
		{
			yield return new WaitForSeconds(delay);
			if (!_owned)
			{
				FetchOculusPrice();
			}
		}

		private void OnProductFetched(Message<ProductList> msg)
		{
			if (msg.IsError)
			{
				Error error = msg.GetError();
				Debug.LogError(string.Format("[IAPButton:{0}] Oculus IAP error fetching price — code={1} message=\"{2}\". Common causes: SKU not added to the Oculus dashboard, SKU name mismatch (case-sensitive), or app not yet uploaded to a release channel that includes IAPs.", sku, error.Code, error.Message));
				SetPriceText("ERR");
			}
			else if (msg.Data.Count == 0)
			{
				Debug.LogWarning("[IAPButton:" + sku + "] Oculus returned 0 products for this SKU. Check that '" + sku + "' exists in the Oculus dashboard under Platform Services → IAP and that it's published in the channel your build uses.");
				SetPriceText("?");
			}
			else
			{
				Product product = msg.Data[0];
				Debug.Log("[IAPButton:" + sku + "] Got price from Oculus: " + product.FormattedPrice + " (sku in response: " + product.Sku + ")");
				SetPriceText(product.FormattedPrice);
			}
		}

		private void BuyProduct()
		{
			if (_owned)
			{
				ForceResync();
			}
			else if (!Core.IsInitialized())
			{
				Debug.LogWarning("[IAPButton:" + sku + "] Oculus Core not initialized");
			}
			else
			{
				IAP.LaunchCheckoutFlow(sku).OnComplete(OnPurchaseComplete);
			}
		}

		private void OnPurchaseComplete(Message<Purchase> msg)
		{
			if (msg.IsError)
			{
				Debug.LogWarning("[IAPButton:" + sku + "] Purchase failed: " + msg.GetError().Message);
				return;
			}
			SetOwned();
			GrantAtZeroGD(sku);
		}

		private void ForceResync()
		{
			string itemId = GetItemId();
			LocalProfileManager.Instance?.FetchInventory(delegate(bool fetchSuccess)
			{
				if (!fetchSuccess)
				{
					Debug.LogWarning("[IAPButton:" + sku + "] ForceResync: inventory fetch failed");
				}
				else if (LocalProfileManager.Instance.OwnsItem(itemId))
				{
					onPurchase?.Invoke();
					WardrobeManager.RefreshAll();
					PlayFabManager.Instance?.NotifyInventoryUpdated();
				}
				else if (Core.IsInitialized())
				{
					FetchAllOculusPurchases(ProcessResyncCheck);
				}
			});
		}

		private void ProcessResyncCheck(HashSet<string> ownedSkus)
		{
			if (ownedSkus.Contains(sku))
			{
				GrantAtZeroGD(sku);
				return;
			}
			if (legacySKUs != null)
			{
				string[] array = legacySKUs;
				foreach (string item in array)
				{
					if (ownedSkus.Contains(item))
					{
						GrantAtZeroGD(item);
						return;
					}
				}
			}
			Debug.LogWarning("[IAPButton:" + sku + "] ForceResync: not found on Oculus — cannot re-grant");
		}

		public void RefreshOwnership()
		{
			if (!_owned && LocalProfileManager.Instance != null && LocalProfileManager.Instance.OwnsItem(GetItemId()))
			{
				SetOwned();
			}
		}

		private string GetItemId()
		{
			if (!string.IsNullOrEmpty(playfabItemId))
			{
				return playfabItemId;
			}
			return sku;
		}

		private void SetOwned()
		{
			_owned = true;
			if (price != null)
			{
				price.text = "Owned";
			}
		}
	}
}
