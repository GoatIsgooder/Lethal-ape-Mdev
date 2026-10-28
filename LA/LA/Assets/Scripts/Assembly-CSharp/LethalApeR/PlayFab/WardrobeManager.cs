using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using QauthSdk;
using TMPro;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class WardrobeManager : MonoBehaviour
	{
		public static readonly List<WardrobeManager> All = new List<WardrobeManager>();

		public static WardrobeManager Instance;

		[Tooltip("Direct children are the preview cosmetics, each named exactly by its Qauth item ID.")]
		public GameObject cosmeticsParent;

		[Tooltip("Category the stand is showing.")]
		public CosmeticType currentType;

		[Tooltip("Optional label for Refresh feedback ('Refreshing...', 'Cosmetics updated', ...).")]
		[SerializeField]
		private TMP_Text statusText;

		private const string DefaultEye = "DEFAULT_EYE";

		private const float ReloadCooldown = 3f;

		private const float ReloadTimeout = 20f;

		private static readonly int CategoryCount = Enum.GetValues(typeof(CosmeticType)).Length;

		private static readonly Dictionary<string, CosmeticType> ClassToCategory = new Dictionary<string, CosmeticType>(StringComparer.OrdinalIgnoreCase)
		{
			{ "HEAD", CosmeticType.Head },
			{ "FACE", CosmeticType.Face },
			{ "BODY", CosmeticType.Body },
			{ "HAND", CosmeticType.Hand },
			{ "EYE", CosmeticType.Eye },
			{ "SKIN", CosmeticType.Skin },
			{ "NAMETAG", CosmeticType.NameTag },
			{ "MONSTERSKIN", CosmeticType.MonsterSkin },
			{ "PLAYERMODEL", CosmeticType.PlayerModel },
			{ "PET", CosmeticType.Pet },
			{ "PETS", CosmeticType.Pet }
		};

		private static readonly string[] EquipSlot = new string[10] { "Head", "Face", "Body", "LeftHand", "Eye", "Skin", "NameTag", "MonsterSkin", "PlayerModel", "Pet" };

		private static readonly HashSet<string> s_warned = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

		private static bool s_reloading;

		private static float s_reloadStartedAt;

		private static float s_nextReloadAllowed;

		private readonly List<GameObject> _previews = new List<GameObject>();

		private readonly List<GameObject>[] _owned = NewCategoryLists();

		private bool _previewsCollected;

		private GameObject _shown;

		private int _index;

		private static List<GameObject>[] NewCategoryLists()
		{
			List<GameObject>[] lists = new List<GameObject>[CategoryCount];
			for (int i = 0; i < lists.Length; i++)
			{
				lists[i] = new List<GameObject>();
			}
			return lists;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			All.Clear();
			Instance = null;
			s_warned.Clear();
			s_reloading = false;
			s_reloadStartedAt = 0f;
			s_nextReloadAllowed = 0f;
		}

		private void Awake()
		{
			CollectPreviews();
		}

		private void OnEnable()
		{
			if (!All.Contains(this))
			{
				All.Add(this);
			}
			Instance = this;
			if (LocalProfileManager.Instance != null && Qauth.IsLoggedIn)
			{
				RefreshCosmetics();
			}
		}

		private void OnDisable()
		{
			All.Remove(this);
			if (Instance == this)
			{
				Instance = (All.Count > 0) ? All[All.Count - 1] : null;
			}
		}

		private void CollectPreviews()
		{
			if (_previewsCollected || cosmeticsParent == null)
			{
				return;
			}
			_previewsCollected = true;
			Transform parent = cosmeticsParent.transform;
			for (int i = 0; i < parent.childCount; i++)
			{
				GameObject preview = parent.GetChild(i).gameObject;
				preview.SetActive(false);
				_previews.Add(preview);
			}
		}

		public static void RefreshAll()
		{
			for (int i = All.Count - 1; i >= 0; i--)
			{
				if (All[i] == null)
				{
					All.RemoveAt(i);
				}
				else
				{
					All[i].RefreshCosmetics();
				}
			}
		}

		public void RefreshCosmetics()
		{
			CollectPreviews();
			for (int i = 0; i < _owned.Length; i++)
			{
				_owned[i].Clear();
			}
			LocalProfileManager profile = LocalProfileManager.Instance;
			if (profile == null)
			{
				Debug.LogError("[WardrobeManager] LocalProfileManager is missing; the wardrobe can't tell what you own.", this);
				Present(false);
				return;
			}
			if (!profile.OwnsItem(DefaultEye))
			{
				profile.AddOwnedItem(DefaultEye);
			}
			HashSet<string> previewed = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
			foreach (GameObject preview in _previews)
			{
				if (preview == null)
				{
					continue;
				}
				string id = preview.name;
				if (!profile.OwnsItem(id))
				{
					continue;
				}
				previewed.Add(id);
				string itemClass = profile.GetItemClass(id);
				if (string.IsNullOrEmpty(itemClass) && id.Equals(DefaultEye, StringComparison.OrdinalIgnoreCase))
				{
					itemClass = "EYE";
				}
				if (ClassToCategory.TryGetValue(itemClass ?? "", out var category))
				{
					_owned[(int)category].Add(preview);
				}
				else if (string.IsNullOrEmpty(itemClass))
				{
					WarnOnce(id, "'" + id + "' is owned but has no ItemClass (catalog not loaded, or the item is missing from the catalog). Press Refresh to reload it.");
				}
				else
				{
					WarnOnce(id, "'" + id + "' has ItemClass '" + itemClass + "', which is not a wardrobe category.");
				}
			}
			foreach (string ownedId in profile.GetOwnedItems())
			{
				if (!previewed.Contains(ownedId))
				{
					WarnOnce(ownedId, "Owned item '" + ownedId + "' has no preview under '" + cosmeticsParent?.name + "'. Add a direct child named exactly '" + ownedId + "' for it to appear.");
				}
			}
			Present(true);
		}

		public static void ReloadFromServer()
		{
			float now = Time.unscaledTime;
			if ((s_reloading && now - s_reloadStartedAt < ReloadTimeout) || now < s_nextReloadAllowed)
			{
				return;
			}
			LocalProfileManager profile = LocalProfileManager.Instance;
			if (profile == null || !Qauth.IsLoggedIn)
			{
				SetStatusAll("Not signed in yet");
				RefreshAll();
				return;
			}
			s_reloading = true;
			s_reloadStartedAt = now;
			s_nextReloadAllowed = now + ReloadCooldown;
			SetStatusAll("Refreshing...");
			profile.FetchInventory(delegate(bool inventoryOk)
			{
				if (!inventoryOk)
				{
					FinishReload("Couldn't reach the server");
				}
				else if (OwnsItemsWithUnknownCategory(profile))
				{
					profile.FetchCatalog(delegate(bool catalogOk)
					{
						FinishReload(catalogOk ? "Cosmetics updated" : "Some items couldn't be loaded");
					});
				}
				else
				{
					FinishReload("Cosmetics updated");
				}
			});
		}

		private static void FinishReload(string status)
		{
			s_reloading = false;
			s_warned.Clear();
			RefreshAll();
			SetStatusAll(status);
		}

		private static bool OwnsItemsWithUnknownCategory(LocalProfileManager profile)
		{
			foreach (string id in profile.GetOwnedItems())
			{
				if (!id.Equals(DefaultEye, StringComparison.OrdinalIgnoreCase) && string.IsNullOrEmpty(profile.GetItemClass(id)))
				{
					return true;
				}
			}
			return false;
		}

		private static void SetStatusAll(string text)
		{
			foreach (WardrobeManager manager in All)
			{
				if (manager != null && manager.statusText != null)
				{
					manager.statusText.text = text;
				}
			}
		}

		private static void WarnOnce(string id, string message)
		{
			if (s_warned.Add(id))
			{
				Debug.LogWarning("[WardrobeManager] " + message);
			}
		}

		public void UpdateCosmeticListForType()
		{
			Present(false);
		}

		public void ShowCategory(CosmeticType category)
		{
			currentType = category;
			Present(false);
		}

		public void SwitchCosmeticType(bool next)
		{
			currentType = (CosmeticType)(((int)currentType + (next ? 1 : (-1)) + CategoryCount) % CategoryCount);
			Present(false);
		}

		public void ScrollCosmetic(bool next)
		{
			List<GameObject> items = CurrentItems();
			if (items.Count != 0)
			{
				_index = (_index + (next ? 1 : (-1)) + items.Count) % items.Count;
				Show(items[_index]);
			}
		}

		private List<GameObject> CurrentItems()
		{
			int index = (int)currentType;
			if (index < 0 || index >= _owned.Length)
			{
				index = 0;
			}
			return _owned[index];
		}

		private void Present(bool keepSelection)
		{
			List<GameObject> items = CurrentItems();
			if (keepSelection && _shown != null)
			{
				_index = Mathf.Max(0, items.IndexOf(_shown));
			}
			else
			{
				_index = 0;
			}
			Show((items.Count > 0) ? items[_index] : null);
		}

		private void Show(GameObject preview)
		{
			if (_shown == preview)
			{
				if (preview != null)
				{
					preview.SetActive(true);
				}
				return;
			}
			if (_shown != null)
			{
				_shown.SetActive(false);
			}
			_shown = preview;
			if (_shown != null)
			{
				_shown.SetActive(true);
			}
		}

		public void UseCosmetic(bool equip)
		{
			List<GameObject> items = CurrentItems();
			if (items.Count == 0 || _index >= items.Count)
			{
				return;
			}
			string id = items[_index].name;
			string slot = EquipSlot[(int)currentType];
			switch (currentType)
			{
			case CosmeticType.MonsterSkin:
			{
				string value = equip ? id : "";
				MonkeDevNetworkingManager.SetCosmetic(slot, value);
				LocalProfileManager.Instance?.SaveUserData("SelectedMonsterSkin", value);
				return;
			}
			case CosmeticType.PlayerModel:
				MonkeDevNetworkingManager.SetCosmetic(slot, equip ? id : "ApeRig");
				return;
			case CosmeticType.Pet:
				MonkeDevNetworkingManager.SetCosmetic(slot, equip ? id : "");
				return;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			manager.Cosmetics.TryGetValue(slot, out var current);
			List<string> equipped = new List<string>();
			if (!string.IsNullOrEmpty(current))
			{
				string[] parts = current.Split(',');
				for (int i = 0; i < parts.Length; i++)
				{
					string part = parts[i].Trim();
					if (part.Length > 0 && !equipped.Contains(part))
					{
						equipped.Add(part);
					}
				}
			}
			if (equip)
			{
				if (!equipped.Contains(id))
				{
					equipped.Add(id);
				}
			}
			else
			{
				equipped.Remove(id);
			}
			MonkeDevNetworkingManager.SetCosmetic(slot, string.Join(",", equipped));
		}
	}
}
