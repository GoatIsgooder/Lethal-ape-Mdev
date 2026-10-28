using System;
using Oculus.Platform;
using Oculus.Platform.Models;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassPremium
	{
		private const int MaxPurchasePages = 20;

		private const float CheckoutTimeoutSeconds = 180f;

		private const float PriceRetrySeconds = 60f;

		private static bool _entitlementInFlight;

		private static bool _priceKnown;

		private static float _nextPriceAttempt;

		private static float _checkoutOpenedAt;

		public static string Price { get; private set; }

		public static bool CheckoutOpen { get; private set; }

		public static bool PlatformReady => Core.IsInitialized();

		public static event Action StateChanged;

		public static void RefreshEntitlement()
		{
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null || _entitlementInFlight || !PlatformReady)
			{
				return;
			}
			string sku = instance.Season.premiumSku;
			if (!string.IsNullOrEmpty(sku))
			{
				Request<PurchaseList> viewerPurchases = IAP.GetViewerPurchases();
				if (viewerPurchases != null)
				{
					_entitlementInFlight = true;
					viewerPurchases.OnComplete(delegate(Message<PurchaseList> msg)
					{
						OnPurchasePage(msg, sku, 1);
					});
				}
			}
		}

		private static void OnPurchasePage(Message<PurchaseList> msg, string sku, int page)
		{
			if (msg.IsError)
			{
				_entitlementInFlight = false;
				Debug.LogWarning(string.Format("[SeasonPass] Purchase list page {0} failed: {1}", page, msg.GetError().Message));
				return;
			}
			foreach (Oculus.Platform.Models.Purchase datum in msg.Data)
			{
				if (string.Equals(datum.Sku, sku, StringComparison.OrdinalIgnoreCase))
				{
					FinishEntitlement(owned: true);
					return;
				}
			}
			if (!msg.Data.HasNextPage)
			{
				FinishEntitlement(owned: false);
				return;
			}
			Request<PurchaseList> request = ((page < 20) ? IAP.GetNextPurchaseListPage(msg.Data) : null);
			if (request == null)
			{
				_entitlementInFlight = false;
				return;
			}
			request.OnComplete(delegate(Message<PurchaseList> m)
			{
				OnPurchasePage(m, sku, page + 1);
			});
		}

		private static void FinishEntitlement(bool owned)
		{
			_entitlementInFlight = false;
			SeasonPassService.Instance?.SetPremium(owned);
			StateChanged?.Invoke();
		}

		public static void FetchPrice()
		{
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null || _priceKnown || Time.unscaledTime < _nextPriceAttempt || !PlatformReady)
			{
				return;
			}
			string sku = instance.Season.premiumSku;
			if (string.IsNullOrEmpty(sku))
			{
				return;
			}
			_nextPriceAttempt = Time.unscaledTime + 60f;
			Request<ProductList> productsBySKU = IAP.GetProductsBySKU(new string[1] { sku });
			if (productsBySKU == null)
			{
				return;
			}
			productsBySKU.OnComplete(delegate(Message<ProductList> msg)
			{
				if (!msg.IsError && msg.Data != null && msg.Data.Count > 0)
				{
					_priceKnown = true;
					Price = msg.Data[0].FormattedPrice;
					StateChanged?.Invoke();
				}
				else
				{
					Debug.LogWarning("[SeasonPass] No store product for '" + sku + "'" + (msg.IsError ? (": " + msg.GetError().Message) : "."));
				}
			});
		}

		public static void Purchase(Action<bool, string> done)
		{
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null)
			{
				done?.Invoke(false, "Season data is missing.");
				return;
			}
			if (instance.HasPremium)
			{
				done?.Invoke(true, null);
			}
			else
			{
				if (CheckoutOpen)
				{
					return;
				}
				if (instance.PremiumSaleLocked)
				{
					done?.Invoke(false, "Premium opens when the season launches.");
					return;
				}
				if (!PlatformReady)
				{
					done?.Invoke(false, "The store isn't ready yet. Try again in a moment.");
					return;
				}
				Request<Oculus.Platform.Models.Purchase> request = IAP.LaunchCheckoutFlow(instance.Season.premiumSku);
				if (request == null)
				{
					done?.Invoke(false, "Couldn't open the store.");
					return;
				}
				CheckoutOpen = true;
				_checkoutOpenedAt = Time.unscaledTime;
				StateChanged?.Invoke();
				request.OnComplete(delegate(Message<Oculus.Platform.Models.Purchase> msg)
				{
					CheckoutOpen = false;
					if (msg.IsError)
					{
						string text = msg.GetError().Message ?? string.Empty;
						bool flag = text.IndexOf("cancel", StringComparison.OrdinalIgnoreCase) >= 0;
						StateChanged?.Invoke();
						done?.Invoke(false, flag ? null : text);
					}
					else
					{
						SeasonPassService.Instance?.SetPremium(owned: true);
						StateChanged?.Invoke();
						done?.Invoke(true, null);
					}
				});
			}
		}

		public static void Tick()
		{
			if (CheckoutOpen && !(Time.unscaledTime - _checkoutOpenedAt < 180f))
			{
				CheckoutOpen = false;
				StateChanged?.Invoke();
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_entitlementInFlight = false;
			_priceKnown = false;
			_nextPriceAttempt = 0f;
			CheckoutOpen = false;
			Price = null;
			StateChanged = null;
		}
	}
}
