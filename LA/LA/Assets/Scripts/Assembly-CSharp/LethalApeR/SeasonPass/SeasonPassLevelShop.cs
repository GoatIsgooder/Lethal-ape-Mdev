using System;
using System.Collections.Generic;
using System.Globalization;
using LethalApeR.PlayFab;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassLevelShop
	{
		private const string CatalogVersion = "Main";

		private const string Currency = "GD";

		private static bool _busy;

		private static bool _recounting;

		private static bool _recountAgain;

		private static int _purchaseEpoch;

		private const float PriceRefreshSeconds = 0.5f;

		private static int _cachedPrice;

		private static float _priceReadAt = float.NegativeInfinity;

		public static bool DevSimulate => false;

		public static int Price
		{
			get
			{
				if (Time.unscaledTime - _priceReadAt >= 0.5f || Time.unscaledTime < _priceReadAt)
				{
					_priceReadAt = Time.unscaledTime;
					_cachedPrice = ReadCatalogPrice();
				}
				return _cachedPrice;
			}
		}

		public static bool HasBalance => LocalProfileManager.Instance != null;

		public static int Balance
		{
			get
			{
				if (!(LocalProfileManager.Instance != null))
				{
					return 0;
				}
				return LocalProfileManager.Instance.GetCurrency();
			}
		}

		public static LevelBuyState State
		{
			get
			{
				SeasonPassService instance = SeasonPassService.Instance;
				if (instance == null)
				{
					return LevelBuyState.NotInStore;
				}
				if (_busy)
				{
					return LevelBuyState.Busy;
				}
				if (instance.IsMaxLevel)
				{
					return LevelBuyState.MaxLevel;
				}
				if (instance.Phase != SeasonPassPhase.Live)
				{
					return LevelBuyState.NotLive;
				}
				if (!Qauth.IsLoggedIn || LocalProfileManager.Instance == null)
				{
					return LevelBuyState.Offline;
				}
				int price = Price;
				if (price <= 0)
				{
					return LevelBuyState.NotInStore;
				}
				if (Balance < price)
				{
					return LevelBuyState.NotEnoughGold;
				}
				return LevelBuyState.Ready;
			}
		}

		public static event Action StateChanged;

		private static int ReadCatalogPrice()
		{
			SeasonPassService instance = SeasonPassService.Instance;
			LocalProfileManager instance2 = LocalProfileManager.Instance;
			if (instance2 == null || instance2.Catalog == null)
			{
				return 0;
			}
			if (instance == null)
			{
				return 0;
			}
			List<RemoteCatalogItem> catalog = instance2.Catalog.Catalog;
			if (catalog == null)
			{
				return 0;
			}
			string levelItemId = instance.Season.levelItemId;
			if (string.IsNullOrEmpty(levelItemId))
			{
				return 0;
			}
			for (int i = 0; i < catalog.Count; i++)
			{
				RemoteCatalogItem remoteCatalogItem = catalog[i];
				if (remoteCatalogItem != null && string.Equals(remoteCatalogItem.ItemId, levelItemId, StringComparison.Ordinal))
				{
					return remoteCatalogItem.VirtualCurrencyPrices?.GD ?? 0;
				}
			}
			return 0;
		}

		public static string Explain(LevelBuyState state)
		{
			switch (state)
			{
			case LevelBuyState.Busy:
				return "A level purchase is already going through.";
			case LevelBuyState.MaxLevel:
			{
				SeasonPassService instance = SeasonPassService.Instance;
				if (instance != null && instance.IsCapped)
				{
					return string.Format("Levels past {0} unlock in an update.", instance.Season.LevelCap);
				}
				return "You're already at the max level.";
			}
			case LevelBuyState.NotLive:
				return "Levels can be bought while the season is live.";
			case LevelBuyState.Offline:
				return "Can't reach the store right now.";
			case LevelBuyState.NotInStore:
				return "Level purchases aren't open yet.";
			case LevelBuyState.NotEnoughGold:
				return "A level costs " + Format(Price) + " GD. You have " + Format(Balance) + ".";
			default:
				return string.Empty;
			}
		}

		public static string Format(int gold)
		{
			return gold.ToString("N0", CultureInfo.InvariantCulture);
		}

		public static async void BuyOne(Action<bool, string> done)
		{
			LevelBuyState state = State;
			if (state != LevelBuyState.Ready)
			{
				done?.Invoke(false, Explain(state));
				return;
			}
			SeasonPassService instance = SeasonPassService.Instance;
			int price = Price;
			_busy = true;
			StateChanged?.Invoke();
			QauthWalletState result;
			try
			{
				result = await Qauth.Wallet.BuyAsync(instance.Season.levelItemId);
			}
			catch (Exception ex)
			{
				result = new QauthWalletState
				{
					Error = ex.Message
				};
			}
			if (result.Error == null)
			{
				_busy = false;
				_purchaseEpoch++;
				SeasonPassService instance2 = SeasonPassService.Instance;
				if (instance2 != null)
				{
					instance2.SetBoughtLevels(instance2.BoughtLevels + 1);
				}
				LocalProfileManager instance3 = LocalProfileManager.Instance;
				if (instance3 != null)
				{
					instance3.SeedCurrency(Mathf.Max(0, instance3.GetCurrency() - price));
				}
				done?.Invoke(true, null);
				StateChanged?.Invoke();
				Recount();
				return;
			}
			_busy = false;
			Debug.LogWarning("[SeasonPass] Level purchase failed: " + result.Error);
			string arg;
			switch (result.Error)
			{
			case "NOT_FOR_SALE":
			case "UNKNOWN_ITEM":
				arg = "Level purchases aren't open yet.";
				break;
			case "NOT_ENOUGH_COINS":
				arg = "You don't have enough GD for a level.";
				break;
			default:
				arg = "The purchase didn't go through. If GD was taken, the level shows up shortly.";
				break;
			}
			done?.Invoke(false, arg);
			StateChanged?.Invoke();
			Recount();
		}

		public static async void Recount()
		{
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null || string.IsNullOrEmpty(instance.Season.levelItemId) || !Qauth.IsLoggedIn)
			{
				return;
			}
			if (_recounting)
			{
				_recountAgain = true;
				return;
			}
			_recounting = true;
			_recountAgain = false;
			int epoch = _purchaseEpoch;
			string itemId = instance.Season.levelItemId;
			QauthWalletState result;
			try
			{
				result = await Qauth.Wallet.GetAsync();
			}
			catch (Exception ex)
			{
				result = new QauthWalletState
				{
					Error = ex.Message
				};
			}
			_recounting = false;
			if (result.Error != null)
			{
				Debug.LogWarning("[SeasonPass] Bought-level recount failed: " + result.Error);
				if (_recountAgain)
				{
					Recount();
				}
				return;
			}
			if (epoch != _purchaseEpoch || _recountAgain)
			{
				Recount();
				return;
			}
			SeasonPassService.Instance?.SetBoughtLevels(result.Count(itemId));
			LocalProfileManager.Instance?.SeedCurrency((int)result.Coins);
			StateChanged?.Invoke();
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_busy = false;
			_recounting = false;
			_recountAgain = false;
			_purchaseEpoch = 0;
			_cachedPrice = 0;
			_priceReadAt = float.NegativeInfinity;
			StateChanged = null;
		}
	}
}
