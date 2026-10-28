using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Networking;
using LethalApeR.PlayFab;
using LethalApeR.UI.Notifications;
using TMPro;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;

namespace LethalApeR
{
	[RequireComponent(typeof(XRGrabInteractable))]
	public class CosmeticStandPurchaseTag : MonoBehaviour
	{
		[Header("Stand Reference")]
		public CosmeticStand stand;

		[Header("VFX - LineRenderAnchors")]
		public Transform anchorPoint;

		public Transform tagAnchorPoint;

		public Transform vfxSpawnPoint;

		public LineRenderer lineRenderer;

		[Header("UI")]
		public TMP_Text itemNameText;

		public TMP_Text priceText;

		public TMP_Text descriptionText;

		public TMP_Text timerText;

		[Header("Item Setup")]
		[HideInInspector]
		public string itemID;

		[HideInInspector]
		public string displayName;

		[HideInInspector]
		public int price;

		public float purchaseTime = 3f;

		public float dragDistance = 0.2f;

		public float maxDistance = 2.5f;

		[Header("Return Settings")]
		public float returnSpeed = 5f;

		public bool testPurchaseInEditor;

		[Header("References")]
		public AudioSource audioSource;

		private XRGrabInteractable grab;

		private Vector3 startPos;

		private Vector3 originalLocalPos;

		private Quaternion originalLocalRot;

		private float timer;

		private float lastReleaseTime = -10f;

		private float lowFundsTimer;

		private bool owned;

		private bool isPurchasing;

		private bool showingLowFunds;

		private bool isPlayingAudio;

		private bool hasInitialized;

		private bool subscribedToEvents;

		private const float RELEASE_RESET_DELAY = 1f;

		private const float HAND_SWAP_GRACE = 0.25f;

		private const float LOW_FUNDS_DURATION = 3f;

		private void Awake()
		{
			grab = GetComponent<XRGrabInteractable>();
			grab.selectEntered.AddListener(OnGrab);
			grab.selectExited.AddListener(OnRelease);
			if (lineRenderer != null)
			{
				lineRenderer.positionCount = 2;
				lineRenderer.useWorldSpace = true;
			}
			if (audioSource != null)
			{
				audioSource.loop = true;
				audioSource.playOnAwake = false;
			}
		}

		private void Start()
		{
			anchorPoint = (anchorPoint ? anchorPoint : ((stand != null) ? stand.transform : transform.parent));
			startPos = transform.position;
			originalLocalPos = transform.localPosition;
			originalLocalRot = transform.localRotation;
			if (stand != null)
			{
				stand.OnStandChanged += RefreshFromStand;
			}
			TrySubscribeToEvents();
			StartCoroutine(DelayedInitCoroutine());
		}

		private void OnEnable()
		{
			TrySubscribeToEvents();
		}

		private void OnDisable()
		{
			if (PlayFabManager.Instance != null && subscribedToEvents)
			{
				PlayFabManager.Instance.OnLoggedIn -= OnLoginOrInventoryUpdate;
				PlayFabManager.Instance.OnInventoryUpdated -= OnLoginOrInventoryUpdate;
				subscribedToEvents = false;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnCatalogLoaded -= AutoInitializeFromCatalog;
			}
			if (stand != null)
			{
				stand.OnStandChanged -= RefreshFromStand;
			}
		}

		private void TrySubscribeToEvents()
		{
			if (subscribedToEvents)
			{
				return;
			}
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn += OnLoginOrInventoryUpdate;
				PlayFabManager.Instance.OnInventoryUpdated += OnLoginOrInventoryUpdate;
				subscribedToEvents = true;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnCatalogLoaded += AutoInitializeFromCatalog;
			}
		}

		private void OnLoginOrInventoryUpdate()
		{
			SyncItemIDFromStand();
			AutoInitializeFromCatalog();
		}

		private IEnumerator DelayedInitCoroutine()
		{
			yield return null;
			SyncItemIDFromStand();
			ShowPlaceholder();
			if (LocalProfileManager.Instance?.Catalog?.Catalog?.Count > 0)
			{
				hasInitialized = true;
				AutoInitializeFromCatalog();
				yield break;
			}
			WaitForSeconds wait = new WaitForSeconds(0.5f);
			while (LocalProfileManager.Instance == null)
			{
				yield return wait;
			}
			if (!subscribedToEvents)
			{
				TrySubscribeToEvents();
			}
			while (LocalProfileManager.Instance.Catalog == null || LocalProfileManager.Instance.Catalog.Catalog == null || LocalProfileManager.Instance.Catalog.Catalog.Count == 0)
			{
				yield return wait;
			}
			if (!hasInitialized)
			{
				hasInitialized = true;
				SyncItemIDFromStand();
				AutoInitializeFromCatalog();
			}
		}

		private void ShowPlaceholder()
		{
			SetMainTextsActive(true);
			if ((bool)itemNameText)
			{
				itemNameText.text = (string.IsNullOrEmpty(itemID) ? "Loading..." : itemID);
			}
			if ((bool)priceText)
			{
				priceText.text = "...";
			}
			if ((bool)descriptionText)
			{
				descriptionText.text = "";
			}
			if ((bool)timerText)
			{
				timerText.gameObject.SetActive(false);
			}
		}

		public void RefreshFromStand()
		{
			SyncItemIDFromStand();
			hasInitialized = false;
			owned = false;
			AutoInitializeFromCatalog();
		}

		private void SyncItemIDFromStand()
		{
			if (!(stand == null))
			{
				string activeItemID = stand.GetActiveItemID();
				if (!string.IsNullOrEmpty(activeItemID))
				{
					itemID = activeItemID;
				}
			}
		}

		public void AutoInitializeFromCatalog()
		{
			if (LocalProfileManager.Instance == null)
			{
				Debug.LogWarning("[CosmeticStandPurchaseTag:" + itemID + "] LocalProfileManager is null");
				return;
			}
			SyncItemIDFromStand();
			if (string.IsNullOrEmpty(itemID))
			{
				Debug.LogWarning("[CosmeticStandPurchaseTag] itemID is empty — check cosmeticItemIDs on the CosmeticStand");
				ShowPlaceholder();
				return;
			}
			RemoteCatalogItem catalogItem = LocalProfileManager.Instance.GetCatalogItem(itemID);
			if (catalogItem == null)
			{
				Debug.LogWarning("[CosmeticStandPurchaseTag] '" + itemID + "' not found in catalog — check IDs match the Qauth dashboard exactly");
				SetMainTextsActive(true);
				if ((bool)itemNameText)
				{
					itemNameText.text = itemID;
				}
				if ((bool)priceText)
				{
					priceText.text = "<color=red>[?]</color>";
				}
				if ((bool)descriptionText)
				{
					descriptionText.text = "";
				}
				if ((bool)timerText)
				{
					timerText.gameObject.SetActive(false);
				}
			}
			else
			{
				price = ((catalogItem.VirtualCurrencyPrices != null) ? catalogItem.VirtualCurrencyPrices.GD : 0);
				bool isOwned = LocalProfileManager.Instance.OwnsItem(itemID);
				Initialize(string.IsNullOrEmpty(catalogItem.DisplayName) ? itemID : catalogItem.DisplayName, price, isOwned);
			}
		}

		public void Initialize(string name, int cost, bool isOwned)
		{
			displayName = name;
			price = cost;
			owned = isOwned;
			SetMainTextsActive(true);
			if ((bool)itemNameText)
			{
				itemNameText.text = displayName;
			}
			UpdatePriceText();
			if ((bool)descriptionText)
			{
				descriptionText.text = (owned ? "<color=green>[!]</color> Already Own" : "<color=red>[!]</color> Drag to Purchase");
			}
			if ((bool)timerText)
			{
				timerText.gameObject.SetActive(false);
			}
		}

		private void UpdatePriceText()
		{
			if ((bool)priceText)
			{
				if (owned)
				{
					priceText.text = "<color=green>Purchased</color>";
				}
				else if (price != 0)
				{
					priceText.text = string.Format("<color=yellow>{0} Gold</color>", price);
				}
				else
				{
					priceText.text = "<color=#00FFFF>[FREE]</color>";
				}
			}
		}

		private void Update()
		{
			HandleLowFundsTimer();
			HandleMaxDistanceCheck();
			HandlePositionReset();
			UpdateLineRenderer();
			HandlePurchaseProgress();
		}

		private void HandleMaxDistanceCheck()
		{
			if (grab.isSelected && Vector3.Distance(startPos, transform.position) >= maxDistance && grab.interactionManager != null)
			{
				grab.interactionManager.SelectExit(grab.interactorsSelecting[0], grab);
			}
		}

		private void HandleLowFundsTimer()
		{
			if (showingLowFunds)
			{
				lowFundsTimer += Time.deltaTime;
				if (lowFundsTimer >= 3f)
				{
					showingLowFunds = false;
					lowFundsTimer = 0f;
					SetMainTextsActive(true);
					UpdatePriceText();
				}
			}
		}

		private void HandlePositionReset()
		{
			if (!grab.isSelected && !testPurchaseInEditor)
			{
				transform.localPosition = Vector3.Lerp(transform.localPosition, originalLocalPos, Time.deltaTime * returnSpeed);
				transform.localRotation = Quaternion.Lerp(transform.localRotation, originalLocalRot, Time.deltaTime * returnSpeed);
				if (Vector3.Distance(transform.localPosition, originalLocalPos) < 0.01f)
				{
					transform.localPosition = originalLocalPos;
					transform.localRotation = originalLocalRot;
					ResetTimer();
				}
			}
		}

		private void UpdateLineRenderer()
		{
			if ((bool)lineRenderer && (bool)anchorPoint)
			{
				lineRenderer.SetPosition(0, anchorPoint.position);
				lineRenderer.SetPosition(1, tagAnchorPoint ? tagAnchorPoint.position : transform.position);
			}
		}

		private void HandlePurchaseProgress()
		{
			if (!grab.isSelected || owned || isPurchasing || showingLowFunds)
			{
				return;
			}
			if (Vector3.Distance(startPos, transform.position) >= dragDistance || testPurchaseInEditor)
			{
				timer += Time.deltaTime;
				if (!isPlayingAudio && audioSource != null && !testPurchaseInEditor)
				{
					audioSource.Play();
					isPlayingAudio = true;
				}
				if ((bool)timerText)
				{
					timerText.gameObject.SetActive(true);
					SetMainTextsActive(false);
					timerText.text = string.Format("<color=black>{0:F1}s</color>", purchaseTime - timer);
				}
				if (timer >= purchaseTime)
				{
					Purchase();
				}
			}
			else
			{
				ResetTimer();
			}
		}

		private void OnGrab(SelectEnterEventArgs args)
		{
			if (Time.time - lastReleaseTime > 0.25f && !owned && !isPurchasing)
			{
				startPos = transform.position;
				timer = 0f;
			}
		}

		private void OnRelease(SelectExitEventArgs args)
		{
			lastReleaseTime = Time.time;
			ResetTimer();
		}

		private void ResetTimer()
		{
			timer = 0f;
			if ((bool)timerText)
			{
				timerText.gameObject.SetActive(false);
			}
			SetMainTextsActive(true);
			if (isPlayingAudio && audioSource != null)
			{
				audioSource.Stop();
				isPlayingAudio = false;
			}
		}

		private void SetMainTextsActive(bool state)
		{
			if ((bool)itemNameText)
			{
				itemNameText.gameObject.SetActive(state);
			}
			if ((bool)priceText)
			{
				priceText.gameObject.SetActive(state);
			}
			if ((bool)descriptionText)
			{
				descriptionText.gameObject.SetActive(state);
			}
		}

		private void Purchase()
		{
			if (isPurchasing || owned)
			{
				return;
			}
			if (LocalProfileManager.Instance == null)
			{
				ResetTimer();
				return;
			}
			RemoteCatalogItem catalogItem = LocalProfileManager.Instance.GetCatalogItem(itemID);
			if (catalogItem == null)
			{
				Debug.LogError("[CosmeticStandPurchaseTag] Item '" + itemID + "' NOT FOUND in catalog!");
				ResetTimer();
				ShowItemNotFoundMessage();
				return;
			}
			price = ((catalogItem.VirtualCurrencyPrices != null) ? catalogItem.VirtualCurrencyPrices.GD : 0);
			if (LocalProfileManager.Instance.GetCurrency() < price)
			{
				ShowLowFundsMessage();
				ResetTimer();
				return;
			}
			isPurchasing = true;
			StopAudio();
			StartCoroutine(PurchaseTimeout());
			LocalProfileManager.Instance.PurchaseItem(itemID, price, delegate(bool success)
			{
				isPurchasing = false;
				StopAllCoroutines();
				if (success)
				{
					owned = true;
					if ((bool)priceText)
					{
						priceText.text = "<color=green>Purchased</color>";
					}
					if ((bool)descriptionText)
					{
						descriptionText.text = "<color=green>[!]</color> Already Own";
					}
					HandNotifications.Show(NotificationKind.Success, "Purchased", (price > 0) ? string.Format("{0} — {1} GD spent.", ItemLabel(), price) : (ItemLabel() + " unlocked."));
					SpawnPurchaseVFX();
					if (WardrobeManager.Instance != null)
					{
						WardrobeManager.RefreshAll();
					}
					if (PlayFabManager.Instance != null)
					{
						PlayFabManager.Instance.NotifyInventoryUpdated();
					}
					if (MonkeDevNetworkingManager.Manager != null && MonkeDevNetworkingManager.Manager.LocalPlayer != null)
					{
						MonkeDevNetworkingManager.Manager.LocalPlayer.RefreshPlayerValuesLocal();
					}
				}
				else if (LocalProfileManager.Instance.GetCurrency() < price)
				{
					ShowLowFundsMessage();
				}
				else
				{
					ShowItemNotFoundMessage();
				}
				ResetTimer();
			});
		}

		private string ItemLabel()
		{
			if (!string.IsNullOrEmpty(displayName))
			{
				return displayName;
			}
			if (!string.IsNullOrEmpty(itemID))
			{
				return itemID;
			}
			return "this cosmetic";
		}

		private void ShowItemNotFoundMessage()
		{
			showingLowFunds = true;
			lowFundsTimer = 0f;
			if ((bool)itemNameText)
			{
				itemNameText.gameObject.SetActive(false);
			}
			if ((bool)descriptionText)
			{
				descriptionText.gameObject.SetActive(false);
			}
			if ((bool)timerText)
			{
				timerText.gameObject.SetActive(false);
			}
			if ((bool)priceText)
			{
				priceText.text = "<color=red>Item Not Found!</color>";
			}
			HandNotifications.Show(NotificationKind.Error, "Not Available", ItemLabel() + " isn't in the store right now. Your gold was not spent.");
		}

		private void ShowLowFundsMessage()
		{
			showingLowFunds = true;
			lowFundsTimer = 0f;
			if ((bool)itemNameText)
			{
				itemNameText.gameObject.SetActive(false);
			}
			if ((bool)descriptionText)
			{
				descriptionText.gameObject.SetActive(false);
			}
			if ((bool)timerText)
			{
				timerText.gameObject.SetActive(false);
			}
			if ((bool)priceText)
			{
				priceText.text = "<color=red>Low On Funds!</color>";
			}
			int num = ((LocalProfileManager.Instance != null) ? LocalProfileManager.Instance.GetCurrency() : 0);
			int num2 = price - num;
			string text = ItemLabel();
			HandNotifications.Show(NotificationKind.Error, "Not Enough Gold", (num2 > 0) ? string.Format("{0} costs {1} GD — you're {2} short.", text, price, num2) : ("You can't afford " + text + " right now."));
		}

		private IEnumerator PurchaseTimeout()
		{
			yield return new WaitForSeconds(10f);
			if (isPurchasing)
			{
				Debug.LogWarning("[CosmeticStandPurchaseTag] Purchase timeout for '" + itemID + "'");
				isPurchasing = false;
				ResetTimer();
			}
		}

		private void StopAudio()
		{
			if (isPlayingAudio && audioSource != null)
			{
				audioSource.Stop();
				isPlayingAudio = false;
			}
		}

		private void SpawnPurchaseVFX()
		{
			if ((bool)vfxSpawnPoint && !(PlayFabManager.Instance?.purchaseEffectPrefab == null))
			{
				UnityEngine.Object.Destroy(UnityEngine.Object.Instantiate(PlayFabManager.Instance.purchaseEffectPrefab, vfxSpawnPoint.position, Quaternion.identity), 5f);
			}
		}
	}
}
