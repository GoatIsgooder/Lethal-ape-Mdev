using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using LethalApeR.Networking;
using Newtonsoft.Json.Linq;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class LocalProfileManager : MonoBehaviour
	{
		private const string CATALOG_VERSION = "Main";

		private static readonly string[] ADMIN_USERNAMES = new string[2] { "0x11xera", "colorxera_g77y5t" };

		private HashSet<string> _ownedItemIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

		private int _cachedCurrency;

		private string _displayName = "";

		private const int PurchaseAttempts = 3;

		public const string NameTakenError = "NameNotAvailable";

		public static LocalProfileManager Instance { get; private set; }

		public bool IsAdmin { get; private set; }

		public RemoteCatalog Catalog { get; private set; }

		public bool IsBanned { get; private set; }

		public string BanIdentifier { get; private set; } = "";

		public bool InventorySynced { get; private set; }

		public event Action OnProfileLoaded;

		public event Action OnCatalogLoaded;

		public event Action OnBanChecked;

		public event Action<int> OnCurrencyChanged;

		private void Awake()
		{
			if (Instance == null)
			{
				Instance = this;
				UnityEngine.Object.DontDestroyOnLoad(base.gameObject);
				StartCoroutine(LiveWalletRefresh());
			}
			else
			{
				UnityEngine.Object.Destroy(base.gameObject);
			}
		}

		// Staff gifts from the Qauth dashboard land on the server wallet directly; re-read it so they show up in game.
		private const float LiveWalletRefreshSeconds = 15f;

		private bool _liveRefreshInFlight;

		private IEnumerator LiveWalletRefresh()
		{
			WaitForSecondsRealtime wait = new WaitForSecondsRealtime(LiveWalletRefreshSeconds);
			while (true)
			{
				yield return wait;
				if (InventorySynced && Qauth.IsLoggedIn && !_liveRefreshInFlight)
				{
					RefreshWalletIfChanged();
				}
			}
		}

		private async void RefreshWalletIfChanged()
		{
			_liveRefreshInFlight = true;
			QauthWalletState result;
			try
			{
				result = await Qauth.Wallet.GetAsync();
			}
			catch (Exception)
			{
				return;
			}
			finally
			{
				_liveRefreshInFlight = false;
			}
			if (result == null || result.Error != null)
			{
				return;
			}
			HashSet<string> owned = new HashSet<string>(result.Items.Where((KeyValuePair<string, int> i) => i.Value > 0).Select((KeyValuePair<string, int> i) => i.Key), StringComparer.OrdinalIgnoreCase);
			bool itemsChanged = !IsAdmin && !owned.SetEquals(_ownedItemIds);
			bool coinsChanged = (int)result.Coins != _cachedCurrency;
			if (itemsChanged)
			{
				_ownedItemIds = owned;
				CosmeticOwnershipGuard.OnInventorySynced(this);
				PlayFabManager.Instance?.NotifyInventoryUpdated();
			}
			if (coinsChanged)
			{
				_cachedCurrency = (int)result.Coins;
				OnCurrencyChanged?.Invoke(_cachedCurrency);
			}
			if (itemsChanged || coinsChanged)
			{
				Debug.Log(string.Format("[LocalProfileManager] Wallet changed on the server — {0} items, {1} GD", _ownedItemIds.Count, _cachedCurrency));
			}
		}

		public void FetchCatalog(Action<bool> callback = null)
		{
			FetchCatalogAsync(callback);
		}

		private async void FetchCatalogAsync(Action<bool> callback)
		{
			QauthCatalog result;
			try
			{
				result = await Qauth.Wallet.CatalogAsync();
			}
			catch (Exception ex)
			{
				Debug.LogError("[LocalProfileManager] FetchCatalog failed: " + ex.Message);
				callback?.Invoke(false);
				return;
			}
			Catalog = new RemoteCatalog
			{
				CatalogVersion = "Main",
				Catalog = new List<RemoteCatalogItem>()
			};
			JObject rawItems = result.Raw?["items"] as JObject;
			foreach (QauthCatalogItem item in result.Items.Values)
			{
				JObject raw = rawItems?[item.Id] as JObject;
				List<RemoteCatalogItem> catalog = Catalog.Catalog;
				RemoteCatalogItem remoteCatalogItem = new RemoteCatalogItem();
				remoteCatalogItem.ItemId = item.Id;
				remoteCatalogItem.ItemClass = ReadRawString(raw, "class") ?? ReadRawString(raw, "itemClass") ?? "";
				remoteCatalogItem.DisplayName = item.Name;
				RemoteVirtualCurrencyPrices remoteVirtualCurrencyPrices = new RemoteVirtualCurrencyPrices();
				remoteVirtualCurrencyPrices.GD = (int)(item.Price ?? 0);
				remoteVirtualCurrencyPrices.RM = 0;
				remoteCatalogItem.VirtualCurrencyPrices = remoteVirtualCurrencyPrices;
				remoteCatalogItem.Bundle = ((raw?["bundle"] is JArray bundle) ? new RemoteBundle
				{
					BundledItems = bundle.Values<string>().Where((string b) => !string.IsNullOrEmpty(b)).ToList()
				} : null);
				catalog.Add(remoteCatalogItem);
			}
			Debug.Log(string.Format("[LocalProfileManager] Catalog loaded: {0} items", Catalog.Catalog.Count));
			OnCatalogLoaded?.Invoke();
			callback?.Invoke(true);
		}

		private static string ReadRawString(JObject raw, string key)
		{
			JToken jToken = raw?[key];
			if (jToken == null || jToken.Type != JTokenType.String)
			{
				return null;
			}
			string text = jToken.Value<string>();
			return string.IsNullOrEmpty(text) ? null : text;
		}

		public RemoteCatalogItem GetCatalogItem(string itemId)
		{
			return Catalog?.Catalog?.FirstOrDefault((RemoteCatalogItem i) => string.Equals(i.ItemId, itemId, StringComparison.OrdinalIgnoreCase));
		}

		public int GetItemPrice(string itemId)
		{
			return GetCatalogItem(itemId)?.VirtualCurrencyPrices?.GD ?? 0;
		}

		public string GetItemClass(string itemId)
		{
			return GetCatalogItem(itemId)?.ItemClass ?? "";
		}

		public void FetchInventory(Action<bool> callback = null)
		{
			FetchInventoryAsync(callback);
		}

		private async void FetchInventoryAsync(Action<bool> callback)
		{
			QauthWalletState result;
			try
			{
				result = await Qauth.Wallet.GetAsync();
			}
			catch (Exception ex)
			{
				Debug.LogError("[LocalProfileManager] FetchInventory failed: " + ex.Message);
				callback?.Invoke(false);
				return;
			}
			if (result.Error != null)
			{
				Debug.LogError("[LocalProfileManager] FetchInventory failed: " + result.Error);
				callback?.Invoke(false);
				return;
			}
			_ownedItemIds.Clear();
			foreach (KeyValuePair<string, int> item in result.Items)
			{
				if (item.Value > 0)
				{
					_ownedItemIds.Add(item.Key);
				}
			}
			if (IsAdmin)
			{
				GrantAllItems();
			}
			InventorySynced = true;
			_cachedCurrency = (int)result.Coins;
			OnCurrencyChanged?.Invoke(_cachedCurrency);
			Debug.Log(string.Format("[LocalProfileManager] Inventory synced — {0} items, {1} GD", _ownedItemIds.Count, _cachedCurrency));
			CosmeticOwnershipGuard.OnInventorySynced(this);
			OnProfileLoaded?.Invoke();
			GetUserData("SelectedMonsterSkin", delegate(string savedSkin)
			{
				if (!string.IsNullOrEmpty(savedSkin) && CosmeticOwnershipGuard.MayWear(this, savedSkin))
				{
					MonkeDevNetworkingManager.SetCosmetic("MonsterSkin", savedSkin);
				}
			});
			callback?.Invoke(true);
		}

		public bool OwnsItem(string itemId)
		{
			if (string.IsNullOrEmpty(itemId))
			{
				return false;
			}
			return _ownedItemIds.Contains(itemId.Trim());
		}

		public List<string> GetOwnedItems()
		{
			return _ownedItemIds.ToList();
		}

		public void RemoveOwnedItem(string id)
		{
			if (!string.IsNullOrEmpty(id))
			{
				_ownedItemIds.Remove(id.Trim());
			}
		}

		public void ClearOwnedItems()
		{
			_ownedItemIds.Clear();
		}

		public void AddOwnedItem(string id)
		{
			if (!string.IsNullOrEmpty(id))
			{
				_ownedItemIds.Add(id.Trim());
			}
		}

		public void PurchaseItem(string itemId, int price, Action<bool> callback = null)
		{
			if (string.IsNullOrWhiteSpace(itemId))
			{
				callback?.Invoke(false);
			}
			else if (OwnsItem(itemId))
			{
				callback?.Invoke(false);
			}
			else
			{
				PurchaseWithRetry(itemId.Trim(), Mathf.Max(0, price), PurchaseAttempts, callback);
			}
		}

		public void GrantItemAtZeroGD(string itemId, Action<bool> callback = null)
		{
			if (string.IsNullOrWhiteSpace(itemId))
			{
				callback?.Invoke(false);
				return;
			}
			itemId = itemId.Trim();
			if (OwnsItem(itemId))
			{
				callback?.Invoke(true);
			}
			else
			{
				GrantFromStoreAsync(itemId, callback);
			}
		}

		private async void GrantFromStoreAsync(string itemId, Action<bool> callback)
		{
			try
			{
				List<string> list = await Qauth.Addons.SyncAsync();
				if (list.Count > 0)
				{
					Debug.Log("[LocalProfileManager] Meta purchases granted by the server: " + string.Join(", ", list));
				}
				QauthWalletState qauthWalletState = await Qauth.Wallet.GetAsync();
				if (qauthWalletState.Error == null && qauthWalletState.Count(itemId) > 0)
				{
					AddOwnedItem(itemId);
					FetchInventory(delegate
					{
						callback?.Invoke(true);
					});
					return;
				}
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[LocalProfileManager] Add-on sync failed for '" + itemId + "': " + ex.Message);
			}
			RemoteCatalogItem catalogItem = GetCatalogItem(itemId);
			if (catalogItem != null && catalogItem.VirtualCurrencyPrices != null && catalogItem.VirtualCurrencyPrices.GD == 0)
			{
				PurchaseWithRetry(itemId, 0, PurchaseAttempts, callback);
				return;
			}
			Debug.LogError("[LocalProfileManager] GrantItemAtZeroGD '" + itemId + "': the server has not granted it and it is not free in the Qauth shop.");
			callback?.Invoke(false);
		}

		private async void PurchaseWithRetry(string itemId, int price, int attemptsLeft, Action<bool> callback)
		{
			QauthWalletState result;
			try
			{
				result = await Qauth.Wallet.BuyAsync(itemId);
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
				AddOwnedItem(itemId);
				foreach (KeyValuePair<string, int> item in result.Items)
				{
					if (item.Value > 0)
					{
						AddOwnedItem(item.Key);
					}
				}
				FetchInventory(delegate
				{
					callback?.Invoke(true);
				});
			}
			else if (price != 0 || attemptsLeft <= 1)
			{
				Debug.LogError(string.Format("[LocalProfileManager] PurchaseItem '{0}' failed after {1} attempts: {2}", itemId, PurchaseAttempts, result.Error));
				callback?.Invoke(false);
			}
			else
			{
				float num = (float)(PurchaseAttempts - attemptsLeft + 1) * 1.5f;
				Debug.LogWarning(string.Format("[LocalProfileManager] PurchaseItem '{0}' failed ({1}) — retrying in {2:0.#}s, {3} attempt(s) left", itemId, result.Error, num, attemptsLeft - 1));
				StartCoroutine(InvokeAfter(num, delegate
				{
					PurchaseWithRetry(itemId, price, attemptsLeft - 1, callback);
				}));
			}
		}

		private IEnumerator InvokeAfter(float seconds, Action action)
		{
			yield return new WaitForSeconds(seconds);
			action?.Invoke();
		}

		public int GetCurrency()
		{
			if (IsAdmin)
			{
				return 999999;
			}
			return _cachedCurrency;
		}

		public void SeedCurrency(int amount)
		{
			_cachedCurrency = amount;
			OnCurrencyChanged?.Invoke(amount);
		}

		public void AddCurrency(int amount, Action<bool> callback = null)
		{
			if (amount <= 0)
			{
				callback?.Invoke(false);
				return;
			}
			AddCurrencyAsync(amount, callback);
		}

		private async void AddCurrencyAsync(int amount, Action<bool> callback)
		{
			QauthCloudResult result;
			QauthWalletState qauthWalletState;
			try
			{
				result = await Qauth.CloudScript.RunAsync("AddCurrency", new { CurrencyCode = "GD", Amount = amount });
				qauthWalletState = (result.Ok ? (await Qauth.Wallet.GetAsync()) : null);
			}
			catch (Exception ex)
			{
				Debug.LogError("[LocalProfileManager] AddCurrency HTTP error: " + ex.Message);
				callback?.Invoke(false);
				return;
			}
			if (!result.Ok)
			{
				Debug.LogError("[LocalProfileManager] AddCurrency refused by server: " + (result.Error ?? "(no error)"));
				callback?.Invoke(false);
				return;
			}
			if (qauthWalletState != null && qauthWalletState.Error == null)
			{
				_cachedCurrency = (int)qauthWalletState.Coins;
			}
			OnCurrencyChanged?.Invoke(_cachedCurrency);
			callback?.Invoke(true);
		}

		public string GetDisplayName()
		{
			return _displayName;
		}

		public void SeedDisplayName(string name)
		{
			if (!string.IsNullOrEmpty(name))
			{
				_displayName = name;
			}
		}

		public void SetDisplayName(string name, Action<bool> callback = null)
		{
			_displayName = name;
			SetDisplayNameAsync(name, callback);
		}

		private async void SetDisplayNameAsync(string name, Action<bool> callback)
		{
			QauthAccount.NameResult result;
			try
			{
				result = await Qauth.Account.SetNameAsync(name);
			}
			catch (Exception ex)
			{
				result = new QauthAccount.NameResult
				{
					Error = ex.Message
				};
			}
			if (result.Ok)
			{
				_displayName = result.Name;
				callback?.Invoke(true);
			}
			else
			{
				Debug.LogError("[LocalProfileManager] SetDisplayName failed: " + result.Error);
				callback?.Invoke(false);
			}
		}

		public void TrySetDisplayName(string name, Action<bool, string> callback)
		{
			TrySetDisplayNameAsync(name, callback);
		}

		private async void TrySetDisplayNameAsync(string name, Action<bool, string> callback)
		{
			QauthAccount.NameResult result;
			try
			{
				result = await Qauth.Account.SetNameAsync(name);
			}
			catch (Exception ex)
			{
				result = new QauthAccount.NameResult
				{
					Error = ex.Message
				};
			}
			if (result.Ok)
			{
				_displayName = result.Name;
				Debug.Log("[LocalProfileManager] Display name '" + result.Name + "' synced to Qauth.");
				callback?.Invoke(true, null);
			}
			else
			{
				callback?.Invoke(false, result.Taken ? NameTakenError : (result.Error ?? "unknown error"));
			}
		}

		public void SaveUserData(string key, string value, Action<bool> callback = null)
		{
			SaveUserDataAsync(key, value, callback);
		}

		private async void SaveUserDataAsync(string key, string value, Action<bool> callback)
		{
			QauthPushResult result;
			try
			{
				result = await Qauth.Saves.PushAsync(key, value, QauthSaves.Now);
			}
			catch (Exception ex)
			{
				result = new QauthPushResult
				{
					Error = ex.Message
				};
			}
			if (result.Ok && !result.Stale)
			{
				callback?.Invoke(true);
				return;
			}
			Debug.LogError("[LocalProfileManager] SaveUserData failed: " + (result.Stale ? "the cloud copy is newer" : result.Error));
			callback?.Invoke(false);
		}

		public void GetUserData(string key, Action<string> callback)
		{
			GetUserDataAsync(key, callback);
		}

		private async void GetUserDataAsync(string key, Action<string> callback)
		{
			Dictionary<string, QauthSave> result;
			try
			{
				result = await Qauth.Saves.PullAsync();
			}
			catch (Exception ex)
			{
				Debug.LogError("[LocalProfileManager] GetUserData failed: " + ex.Message);
				callback?.Invoke(null);
				return;
			}
			callback?.Invoke((result != null && result.TryGetValue(key, out var value)) ? value.Data : null);
		}

		public void CheckBanStatus(string oculusUsername, string deviceId, Action<bool> callback = null)
		{
			IsBanned = Qauth.Status == QauthStatus.Banned;
			BanIdentifier = (IsBanned ? (Qauth.BanReason ?? "") : "");
			OnBanChecked?.Invoke();
			callback?.Invoke(IsBanned);
		}

		public void CheckAdminBypass(string oculusUsername)
		{
			if (string.IsNullOrEmpty(oculusUsername))
			{
				return;
			}
			string[] aDMIN_USERNAMES = ADMIN_USERNAMES;
			foreach (string b in aDMIN_USERNAMES)
			{
				if (string.Equals(oculusUsername, b, StringComparison.OrdinalIgnoreCase))
				{
					IsAdmin = true;
					GrantAllItems();
					break;
				}
			}
		}

		private void GrantAllItems()
		{
			if (Catalog?.Catalog == null)
			{
				return;
			}
			foreach (RemoteCatalogItem item in Catalog.Catalog)
			{
				if (!string.IsNullOrEmpty(item.ItemId))
				{
					_ownedItemIds.Add(item.ItemId);
				}
			}
		}
	}
}
