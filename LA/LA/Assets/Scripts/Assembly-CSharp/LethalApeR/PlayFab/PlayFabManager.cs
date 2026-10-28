using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using LethalApeR.Networking;
using Oculus.Platform;
using Oculus.Platform.Models;
using Photon.Pun;
using QauthSdk;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.PlayFab
{
	public class PlayFabManager : MonoBehaviour
	{
		[Serializable]
		public struct PlayerData
		{
			public string NickName;

			public string OculusID;

			public string OculusUsername;

			public string DeviceID;

			public string PlayFabId;

			public string SessionTicket;
		}

		public PlayerData user;

		public TextMeshPro usernameText;

		public TMP_Text currencyText;

		public TMP_Text currencyText2;

		public GameObject cosmeticButtonsParent;

		public List<CosmeticPurchase> cosmeticPurchases = new List<CosmeticPurchase>();

		public GameObject staffDoor;

		public GameObject staffMirror;

		public GameObject VIPDoor;

		public GameObject VIP_RPC_Thing;

		public bool hasStaff;

		public bool hasVIPBro;

		public bool hasSMNU;

		public bool hasMenu;

		public bool hasSuperMenu;

		public GameObject purchaseEffectPrefab;

		[Header("Ban Mode")]
		public GameObject bannedModeObject;

		private string _currentAppId;

		private const float PostLoginWatchdogSeconds = 12f;

		private bool _playFabLoginInFlight;

		private bool _postLoginStarted;

		private bool _displayNameKnown;

		private const int MaxNameClaimAttempts = 16;

		private const float OculusIapTimeoutSeconds = 10f;

		public static PlayFabManager Instance { get; private set; }

		public List<OwnedItem> OwnedItems { get; private set; } = new List<OwnedItem>();

		public int currencyAmount => LocalProfileManager.Instance?.GetCurrency() ?? 0;

		public bool IsBanned { get; private set; }

		public bool IsLoggedIn { get; private set; }

		public event Action OnLoggedIn;

		public event Action OnInventoryUpdated;

		public void Awake()
		{
			if (Instance == null)
			{
				Instance = this;
			}
			else
			{
				UnityEngine.Object.Destroy(base.gameObject);
			}
		}

		private void Start()
		{
			_currentAppId = PhotonNetwork.PhotonServerSettings.AppSettings.AppIdRealtime;
			if (cosmeticButtonsParent != null)
			{
				cosmeticPurchases = cosmeticButtonsParent.GetComponentsInChildren<CosmeticPurchase>(true).ToList();
			}
			if (cosmeticPurchases == null || cosmeticPurchases.Count == 0)
			{
				cosmeticPurchases = UnityEngine.Object.FindObjectsOfType<CosmeticPurchase>(true).ToList();
			}
			foreach (CosmeticPurchase cosmeticPurchase in cosmeticPurchases)
			{
				if (cosmeticPurchase != null && !string.IsNullOrEmpty(cosmeticPurchase.itemId))
				{
					cosmeticPurchase.itemId = cosmeticPurchase.itemId.Trim();
				}
			}
			SceneManager.sceneLoaded += OnSceneLoaded;
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnCurrencyChanged += OnCurrencyChanged;
				LocalProfileManager.Instance.OnProfileLoaded += OnProfileLoaded;
			}
			if (OculusAuthManager.Instance != null)
			{
				OculusAuthManager.Instance.OnUserResolved += TryStartPlayFabWork;
				OculusAuthManager.Instance.OnAuthComplete += TryStartPlayFabWork;
			}
			else
			{
				Debug.LogWarning("[QauthManager] No OculusAuthManager in this scene — proceeding on whatever Qauth session already exists.");
			}
			TryStartPlayFabWork();
			StartCoroutine(PlayFabWatchdog());
		}

		private IEnumerator PlayFabWatchdog()
		{
			yield return new WaitForSeconds(PostLoginWatchdogSeconds);
			if (IsLoggedIn || _playFabLoginInFlight || _postLoginStarted)
			{
				yield break;
			}
			user.DeviceID = SystemInfo.deviceUniqueIdentifier;
			if (LaAuthLogin.HasSession)
			{
				Debug.LogWarning(string.Format("[QauthManager] Watchdog: a Qauth session has been available for {0:0}s ", PostLoginWatchdogSeconds) + "but this scene never picked it up (Oculus auth stalled here) — running post-login setup now.");
				_postLoginStarted = true;
				LoginWithPlayFab();
			}
			else if (Qauth.IsLoggedIn)
			{
				user.PlayFabId = Qauth.AccountId;
				user.SessionTicket = Qauth.Token;
				_postLoginStarted = true;
				FetchDisplayNameThenContinue();
			}
			else
			{
				Debug.LogError(string.Format("[QauthManager] Watchdog: still no Qauth session after {0:0}s (status {1}). ", PostLoginWatchdogSeconds, Qauth.Status) + "The player has no display name, gold or cosmetics — check the OculusAuthManager log above for where the chain stopped.");
			}
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			if (IsLoggedIn)
			{
				FetchAndSyncOculusPurchases();
			}
		}

		private void OnDestroy()
		{
			SceneManager.sceneLoaded -= OnSceneLoaded;
			if (OculusAuthManager.Instance != null)
			{
				OculusAuthManager.Instance.OnUserResolved -= TryStartPlayFabWork;
				OculusAuthManager.Instance.OnAuthComplete -= TryStartPlayFabWork;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnCurrencyChanged -= OnCurrencyChanged;
				LocalProfileManager.Instance.OnProfileLoaded -= OnProfileLoaded;
			}
		}

		private void TryStartPlayFabWork()
		{
			if (_postLoginStarted || IsLoggedIn || _playFabLoginInFlight)
			{
				return;
			}
			OculusAuthManager instance = OculusAuthManager.Instance;
			if (instance != null)
			{
				if (!string.IsNullOrEmpty(instance.OculusUserID))
				{
					user.OculusID = instance.OculusUserID;
				}
				if (!string.IsNullOrEmpty(instance.OculusUsername))
				{
					user.OculusUsername = instance.OculusUsername;
				}
			}
			user.DeviceID = SystemInfo.deviceUniqueIdentifier;
			if (LaAuthLogin.HasSession || !(instance != null) || instance.HasCompleted)
			{
				_postLoginStarted = true;
				LoginWithPlayFab();
			}
		}

		private string ResolvePlayFabCustomId()
		{
			if (OculusAuthManager.Instance != null)
			{
				string oculusUserID = OculusAuthManager.Instance.OculusUserID;
				if (!string.IsNullOrEmpty(oculusUserID) && oculusUserID != "0")
				{
					return oculusUserID;
				}
			}
			return null;
		}

		private void LoginWithPlayFab()
		{
			if (_playFabLoginInFlight)
			{
				Debug.Log("[QauthManager] Qauth login already in flight — skipping duplicate call.");
				return;
			}
			_playFabLoginInFlight = true;
			LaAuthLogin.Run(delegate(LaAuthLogin.Result res)
			{
				_playFabLoginInFlight = false;
				if (res.Ok)
				{
					OnPlayFabLoginSuccess(res);
				}
				else
				{
					_postLoginStarted = false;
					if (res.Error != null)
					{
						OnPlayFabLoginError(res.Error);
					}
					else
					{
						Debug.LogError("[QauthManager] Qauth login failed: " + res.Failure);
					}
				}
			});
		}

		private void OnPlayFabLoginSuccess(LaAuthLogin.Result result)
		{
			_playFabLoginInFlight = false;
			user.PlayFabId = result.PlayFabId;
			user.SessionTicket = result.SessionTicket;
			PlayerPrefs.SetString("PlayFabId", result.PlayFabId);
			string text = (result.NewAccount ? null : Qauth.AccountName);
			if (!string.IsNullOrEmpty(text))
			{
				LocalProfileManager.Instance?.SeedDisplayName(text);
			}
			FetchDisplayNameThenContinue(text);
		}

		private void FetchDisplayNameThenContinue(string knownDisplayName = null)
		{
			string text = (Qauth.NewlyCreated ? null : Qauth.AccountName);
			Debug.Log("[QauthManager] Qauth account name: '" + (text ?? "<null>") + "'" + (Qauth.NewlyCreated ? " (new account — will claim a name)" : ""));
			if (!string.IsNullOrEmpty(text))
			{
				LocalProfileManager.Instance?.SeedDisplayName(text);
			}
			if (Qauth.IsLoggedIn || !string.IsNullOrEmpty(knownDisplayName))
			{
				_displayNameKnown = true;
			}
			else
			{
				_displayNameKnown = false;
				Debug.LogError("[QauthManager] Not logged in to Qauth and no known display name. Treating the server name as UNKNOWN — will not claim a new one this session.");
			}
			ContinuePostLogin();
		}

		private void ContinuePostLogin()
		{
			if (LocalProfileManager.Instance == null)
			{
				Debug.LogError("[QauthManager] LocalProfileManager.Instance is NULL — cannot load catalog, inventory or currency. Completing login so the player at least gets a name and a Photon connection.");
				OnLoginSuccess();
				return;
			}
			LocalProfileManager.Instance.FetchCatalog(delegate
			{
				if (string.IsNullOrEmpty(user.OculusUsername) && OculusAuthManager.Instance != null)
				{
					user.OculusUsername = OculusAuthManager.Instance.OculusUsername;
				}
				if (LocalProfileManager.Instance == null)
				{
					Debug.LogError("[QauthManager] LocalProfileManager vanished mid-login — completing without the inventory fetch.");
					OnLoginSuccess();
				}
				else
				{
					LocalProfileManager.Instance.CheckAdminBypass(user.OculusUsername);
					LocalProfileManager.Instance.FetchInventory(delegate
					{
						FetchAndSyncOculusPurchases(delegate
						{
							OnLoginSuccess();
						});
					});
				}
			});
		}

		private void OnPlayFabLoginError(string error)
		{
			_playFabLoginInFlight = false;
			Debug.LogError("[QauthManager] Qauth login failed: " + error);
			if (Qauth.Status == QauthStatus.Banned)
			{
				HandleBanned();
			}
			else
			{
				Debug.LogError("[QauthManager] Cannot proceed without a Qauth login.");
			}
		}

		private void OnLoginSuccess()
		{
			Debug.Log("[QauthManager] Full login sequence complete!");
			SyncOwnedItemsFromProfile();
			CosmeticOwnershipGuard.OnLoginComplete(LocalProfileManager.Instance);
			string text = LocalProfileManager.Instance?.GetDisplayName() ?? "";
			if (!string.IsNullOrEmpty(text))
			{
				Debug.Log("[QauthManager] Using existing account name '" + text + "'.");
			}
			else if (_displayNameKnown)
			{
				string text2 = PlayerPrefs.GetString("Username");
				if (string.IsNullOrEmpty(text2))
				{
					text2 = GenerateRandomApeName();
				}
				Debug.Log("[QauthManager] New Qauth account — claiming '" + text2 + "'.");
				ClaimUniqueDisplayName(text2, 0, delegate(string claimed)
				{
					FinalizeDisplayNameAndContinue(claimed);
				});
				return;
			}
			else
			{
				text = PlayerPrefs.GetString("Username");
				Debug.LogError("[QauthManager] Server display name could not be read this session — using the cached name '" + (string.IsNullOrEmpty(text) ? "<none>" : text) + "' LOCALLY and not claiming a new one.");
				if (string.IsNullOrEmpty(text))
				{
					text = GenerateRandomApeName();
				}
			}
			FinalizeDisplayNameAndContinue(text);
		}

		private void FinalizeDisplayNameAndContinue(string displayName)
		{
			MonkeDevNetworkingManager.SetUsername(displayName);
			user.NickName = displayName;
			if (usernameText != null)
			{
				usernameText.text = displayName;
			}
			UpdateCurrencyDisplay();
			InitializeCosmeticButtons();
			CheckSpecialItems();
			WardrobeManager.RefreshAll();
			IsLoggedIn = true;
			this.OnLoggedIn?.Invoke();
			ConnectToPhoton();
		}

		private static string GenerateRandomApeName()
		{
			return MonkeDevNetworkingPlayer.GenerateRandomPrimateName();
		}

		[ContextMenu("Force Reclaim Random Display Name")]
		public void DebugForceReclaimDisplayName()
		{
			if (!Qauth.IsLoggedIn)
			{
				Debug.LogWarning("[QauthManager] Not logged in to Qauth yet — press Play and wait for login first.");
				return;
			}
			string text = GenerateRandomApeName();
			Debug.Log("[QauthManager] DebugForceReclaim → trying '" + text + "'");
			ClaimUniqueDisplayName(text, 0, delegate(string claimed)
			{
				MonkeDevNetworkingManager.SetUsername(claimed);
				user.NickName = claimed;
				if (usernameText != null)
				{
					usernameText.text = claimed;
				}
				Debug.Log("[QauthManager] DebugForceReclaim → done. Final name: '" + claimed + "'. Check the Qauth dashboard.");
			});
		}

		private void ClaimUniqueDisplayName(string candidate, int attempt, Action<string> onClaimed)
		{
			if (LocalProfileManager.Instance == null)
			{
				Debug.LogError("[QauthManager] ClaimUniqueDisplayName: LocalProfileManager.Instance is NULL — cannot sync to Qauth. Falling back to local-only.");
				onClaimed?.Invoke(candidate);
				return;
			}
			Debug.Log(string.Format("[QauthManager] ClaimUniqueDisplayName attempt {0}/{1} → trying '{2}'", attempt + 1, MaxNameClaimAttempts, candidate));
			LocalProfileManager.Instance.TrySetDisplayName(candidate, delegate(bool success, string error)
			{
				if (success)
				{
					string text = LocalProfileManager.Instance?.GetDisplayName();
					string text2 = (string.IsNullOrEmpty(text) ? candidate : text);
					Debug.Log("[QauthManager] ✓ Claimed display name '" + text2 + "' on Qauth.");
					onClaimed?.Invoke(text2);
				}
				else if (error == null)
				{
					Debug.LogError("[QauthManager] TrySetDisplayName returned failure with NULL error for '" + candidate + "'. Aborting.");
					onClaimed?.Invoke(candidate);
				}
				else
				{
					Debug.LogWarning(string.Format("[QauthManager] Claim '{0}' failed — Error={1}", candidate, error));
					if (error == LocalProfileManager.NameTakenError)
					{
						if (attempt + 1 >= MaxNameClaimAttempts)
						{
							Debug.LogError(string.Format("[QauthManager] Exhausted {0} unique-name attempts. Pool too small or unlucky — give up and use '{1}' locally.", MaxNameClaimAttempts, candidate));
							onClaimed?.Invoke(candidate);
						}
						else
						{
							string text3 = GenerateRandomApeName();
							Debug.Log(string.Format("[QauthManager] '{0}' taken — retrying with '{1}' (attempt {2}/{3})", candidate, text3, attempt + 2, MaxNameClaimAttempts));
							ClaimUniqueDisplayName(text3, attempt + 1, onClaimed);
						}
					}
					else
					{
						Debug.LogError("[QauthManager] Non-collision error from Qauth — display name will NOT be synced. Common causes: name length/character invalid; not logged in. Error: " + error);
						onClaimed?.Invoke(candidate);
					}
				}
			});
		}

		private void FetchAndSyncOculusPurchases(Action onComplete = null)
		{
			bool finished = false;
			if (Core.IsInitialized())
			{
				StartCoroutine(IapSyncWatchdog(() => finished, Finish));
				IAP.GetViewerPurchases().OnComplete(delegate(Message<PurchaseList> msg)
				{
					if (msg.IsError)
					{
						Debug.LogWarning("[QauthManager] Oculus IAP fetch error: " + msg.GetError().Message);
						Finish();
						return;
					}
					HashSet<string> hashSet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
					foreach (Purchase datum in msg.Data)
					{
						hashSet.Add(datum.Sku);
					}
					List<string> list = new List<string>();
					foreach (IAPButton allButton in IAPButton.AllButtons)
					{
						if (string.IsNullOrEmpty(allButton.sku))
						{
							continue;
						}
						bool flag = hashSet.Contains(allButton.sku);
						if (!flag && allButton.legacySKUs != null)
						{
							string[] legacySKUs = allButton.legacySKUs;
							foreach (string item in legacySKUs)
							{
								if (hashSet.Contains(item))
								{
									flag = true;
									break;
								}
							}
						}
						string text = allButton.PlayFabItemId?.Trim();
						if (flag && !string.IsNullOrEmpty(text) && LocalProfileManager.Instance != null && !LocalProfileManager.Instance.OwnsItem(text) && !list.Contains(text))
						{
							list.Add(text);
						}
					}
					if (list.Count == 0)
					{
						Debug.Log("[QauthManager] No new Oculus IAP items to sync");
						Finish();
						return;
					}
					BuyItemsAtZeroGD(list, 0, delegate
					{
						if (LocalProfileManager.Instance == null)
						{
							Debug.LogError("[QauthManager] LocalProfileManager missing during IAP sync — completing login without the entitlement resync.");
							Finish();
							return;
						}
						LocalProfileManager.Instance.FetchInventory(delegate(bool fetchSuccess)
						{
							SyncOwnedItemsFromProfile();
							CheckSpecialItems();
							this.OnInventoryUpdated?.Invoke();
							WardrobeManager.RefreshAll();
							foreach (IAPButton allButton2 in IAPButton.AllButtons)
							{
								allButton2?.RefreshOwnership();
							}
							Finish();
						});
					});
				});
			}
			else
			{
				Debug.LogWarning("[QauthManager] Oculus Core not initialised — skipping IAP sync");
				Finish();
			}
			void Finish()
			{
				if (!finished)
				{
					finished = true;
					onComplete?.Invoke();
				}
			}
		}

		private IEnumerator IapSyncWatchdog(Func<bool> isFinished, Action finish)
		{
			yield return new WaitForSeconds(OculusIapTimeoutSeconds);
			if (!isFinished())
			{
				Debug.LogError(string.Format("[QauthManager] Oculus IAP sync did not return within {0:0}s — ", OculusIapTimeoutSeconds) + "completing login anyway so the display name, wardrobe and Photon connect are not blocked. Entitlements will resync on the next scene load.");
				finish();
			}
		}

		private void BuyItemsAtZeroGD(List<string> items, int index, Action onAllDone)
		{
			if (index >= items.Count || LocalProfileManager.Instance == null)
			{
				onAllDone();
				return;
			}
			LocalProfileManager.Instance.GrantItemAtZeroGD(items[index], delegate
			{
				BuyItemsAtZeroGD(items, index + 1, onAllDone);
			});
		}

		public void PurchaseItem(string itemId, int price, bool isConsumable, Action<bool> onComplete = null)
		{
			string text = itemId?.Trim() ?? "";
			if (string.IsNullOrEmpty(text))
			{
				onComplete?.Invoke(false);
				return;
			}
			if (!isConsumable && LocalProfileManager.Instance.OwnsItem(text))
			{
				Debug.LogWarning("[QauthManager] Already owns '" + text + "'");
				onComplete?.Invoke(false);
				return;
			}
			LocalProfileManager.Instance.PurchaseItem(text, price, delegate(bool success)
			{
				if (success)
				{
					SyncOwnedItemsFromProfile();
					UpdateCurrencyDisplay();
					WardrobeManager.RefreshAll();
					this.OnInventoryUpdated?.Invoke();
				}
				onComplete?.Invoke(success);
			});
		}

		public bool OwnsItem(string itemId)
		{
			return LocalProfileManager.Instance?.OwnsItem(itemId) ?? false;
		}

		public void NotifyInventoryUpdated()
		{
			SyncOwnedItemsFromProfile();
			this.OnInventoryUpdated?.Invoke();
		}

		private void SyncOwnedItemsFromProfile()
		{
			OwnedItems.Clear();
			if (LocalProfileManager.Instance == null)
			{
				return;
			}
			foreach (string ownedItem in LocalProfileManager.Instance.GetOwnedItems())
			{
				OwnedItems.Add(new OwnedItem
				{
					ItemId = ownedItem,
					ItemClass = LocalProfileManager.Instance.GetItemClass(ownedItem)
				});
			}
		}

		private void UpdateCurrencyDisplay()
		{
			int num = currencyAmount;
			if (currencyText != null)
			{
				currencyText.text = string.Format("{0} Gold", num);
			}
			if (currencyText2 != null)
			{
				currencyText2.text = string.Format("{0} Gold", num);
			}
		}

		private void InitializeCosmeticButtons()
		{
			if (cosmeticPurchases == null || cosmeticPurchases.Count == 0)
			{
				return;
			}
			foreach (CosmeticPurchase cosmeticPurchase in cosmeticPurchases)
			{
				if (cosmeticPurchase == null)
				{
					continue;
				}
				string text = cosmeticPurchase.itemId?.Trim() ?? "";
				if (string.IsNullOrEmpty(text))
				{
					cosmeticPurchase.InitializeButton(-1, ownsCosmetic: false, force: true);
					continue;
				}
				bool ownsCosmetic = LocalProfileManager.Instance?.OwnsItem(text) ?? false;
				int cosmeticPrice = LocalProfileManager.Instance?.GetItemPrice(text) ?? 0;
				cosmeticPurchase.InitializeButton(cosmeticPrice, ownsCosmetic, force: true);
			}
		}

		private void CheckSpecialItems()
		{
			if (LocalProfileManager.Instance == null)
			{
				return;
			}
			if (LocalProfileManager.Instance.OwnsItem("SRA") && !hasStaff)
			{
				hasStaff = true;
				if (staffDoor != null)
				{
					UnityEngine.Object.Destroy(staffDoor);
				}
				if (staffMirror != null)
				{
					staffMirror.SetActive(value: true);
				}
			}
			if (LocalProfileManager.Instance.OwnsItem("VIPB") && !hasVIPBro)
			{
				hasVIPBro = true;
				if (VIPDoor != null)
				{
					UnityEngine.Object.Destroy(VIPDoor);
				}
				if (VIP_RPC_Thing != null)
				{
					VIP_RPC_Thing.SetActive(value: true);
				}
			}
			if (LocalProfileManager.Instance.OwnsItem("SMNU") && !hasSMNU)
			{
				hasSMNU = true;
			}
			if (LocalProfileManager.Instance.OwnsItem("MODMENU") && !hasMenu)
			{
				hasMenu = true;
			}
			if (LocalProfileManager.Instance.OwnsItem("SUPERMENU") && !hasSuperMenu)
			{
				hasSuperMenu = true;
			}
		}

		private void HandleBanned()
		{
			IsBanned = true;
			Debug.LogError("[QauthManager] User is BANNED!");
			if (bannedModeObject != null)
			{
				bannedModeObject.SetActive(value: true);
			}
		}

		private void OnCurrencyChanged(int newAmount)
		{
			UpdateCurrencyDisplay();
		}

		private void OnProfileLoaded()
		{
			SyncOwnedItemsFromProfile();
		}

		public void UpdateDisplayname(string newUsername, Action<bool> onComplete = null)
		{
			if (string.IsNullOrEmpty(newUsername))
			{
				onComplete?.Invoke(false);
				return;
			}
			if (LocalProfileManager.Instance == null)
			{
				ApplyDisplayNameLocally(newUsername);
				onComplete?.Invoke(false);
				return;
			}
			LocalProfileManager.Instance.TrySetDisplayName(newUsername, delegate(bool success, string error)
			{
				if (success)
				{
					ApplyDisplayNameLocally(newUsername);
					onComplete?.Invoke(true);
				}
				else
				{
					if (error == LocalProfileManager.NameTakenError)
					{
						Debug.LogWarning("[QauthManager] Rename to '" + newUsername + "' rejected — name taken.");
					}
					else
					{
						Debug.LogWarning("[QauthManager] Rename to '" + newUsername + "' failed: " + error);
					}
					onComplete?.Invoke(false);
				}
			});
		}

		private void ApplyDisplayNameLocally(string newUsername)
		{
			if (usernameText != null)
			{
				usernameText.text = newUsername;
			}
			user.NickName = newUsername;
			MonkeDevNetworkingManager.SetUsername(newUsername);
		}

		private void ConnectToPhoton()
		{
			MonkeDevNetworkingManager.Connect(user.OculusID);
		}

		public void ChangeServer(string newAppId, Action<bool> onComplete = null)
		{
			_currentAppId = newAppId;
			if (PhotonNetwork.IsConnected)
			{
				PhotonNetwork.Disconnect();
				StartCoroutine(WaitForDisconnectAndReconnect(newAppId, onComplete));
			}
			else
			{
				ApplyServerSettingsAndConnect(newAppId, onComplete);
			}
		}

		private IEnumerator WaitForDisconnectAndReconnect(string newAppId, Action<bool> onComplete)
		{
			float timeout = 5f;
			float elapsed = 0f;
			while (PhotonNetwork.IsConnected && elapsed < timeout)
			{
				elapsed += Time.deltaTime;
				yield return null;
			}
			if (PhotonNetwork.IsConnected)
			{
				onComplete?.Invoke(false);
			}
			else
			{
				ApplyServerSettingsAndConnect(newAppId, onComplete);
			}
		}

		private void ApplyServerSettingsAndConnect(string newAppId, Action<bool> onComplete)
		{
			try
			{
				PhotonNetwork.PhotonServerSettings.AppSettings.AppIdRealtime = newAppId;
				ConnectToPhoton();
				onComplete?.Invoke(true);
			}
			catch (Exception ex)
			{
				Debug.LogError("[QauthManager] ChangeServer error: " + ex.Message);
				onComplete?.Invoke(false);
			}
		}

		public string GetCurrentAppId()
		{
			return _currentAppId;
		}
	}
}
