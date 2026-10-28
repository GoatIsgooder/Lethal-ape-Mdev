using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public static class CosmeticOwnershipGuard
	{
		private const string PrefsKey = "Cosmetics";

		private const string MonsterSkinSlot = "MonsterSkin";

		private const string MonsterSkinUserDataKey = "SelectedMonsterSkin";

		private const string PlayerModelSlot = "PlayerModel";

		private const string DefaultPlayerModel = "ApeRig";

		private static readonly HashSet<string> FreeIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "DEFAULT_EYE", "APE", "ApeRig", "SandMan" };

		private static bool s_loginComplete;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			s_loginComplete = false;
		}

		public static bool MayWear(LocalProfileManager profile, string itemId)
		{
			if (string.IsNullOrWhiteSpace(itemId))
			{
				return true;
			}
			itemId = itemId.Trim();
			if (FreeIds.Contains(itemId))
			{
				return true;
			}
			if (profile == null)
			{
				return false;
			}
			if (profile.IsAdmin)
			{
				return true;
			}
			return profile.OwnsItem(itemId);
		}

		public static void OnLoginComplete(LocalProfileManager profile)
		{
			s_loginComplete = true;
			Enforce(profile);
		}

		public static void OnInventorySynced(LocalProfileManager profile)
		{
			if (s_loginComplete)
			{
				Enforce(profile);
			}
		}

		private static void Enforce(LocalProfileManager profile)
		{
			if (profile == null || !profile.InventorySynced || profile.IsAdmin)
			{
				return;
			}
			HashSet<string> hashSet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
			bool monsterSkinRemoved = false;
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager != null)
			{
				Dictionary<string, string> dictionary = Strip(profile, manager.Cosmetics, hashSet, ref monsterSkinRemoved);
				if (dictionary != null)
				{
					MonkeDevNetworkingManager.SetCosmetics(dictionary);
				}
			}
			if (!string.IsNullOrEmpty(PlayerPrefs.GetString("Cosmetics")))
			{
				Dictionary<string, string> dictionary2 = Strip(profile, MonkeDevNetworkingValueSaver.GetDictionary("Cosmetics"), hashSet, ref monsterSkinRemoved);
				if (dictionary2 != null)
				{
					MonkeDevNetworkingValueSaver.SaveDictionary("Cosmetics", dictionary2);
				}
			}
			if (hashSet.Count != 0)
			{
				if (monsterSkinRemoved)
				{
					profile.SaveUserData("SelectedMonsterSkin", "");
				}
				PlayerPrefs.Save();
				Debug.LogWarning(string.Format("[CosmeticOwnershipGuard] Unequipped {0} cosmetic(s) this account doesn't own on Qauth: {1}", hashSet.Count, string.Join(", ", hashSet)));
			}
		}

		private static Dictionary<string, string> Strip(LocalProfileManager profile, Dictionary<string, string> equipped, HashSet<string> removed, ref bool monsterSkinRemoved)
		{
			if (equipped == null || equipped.Count == 0)
			{
				return null;
			}
			Dictionary<string, string> dictionary = null;
			foreach (KeyValuePair<string, string> item in equipped)
			{
				string value = item.Value;
				if (string.IsNullOrEmpty(value))
				{
					continue;
				}
				string text = KeepWearable(profile, value, removed);
				if ((object)text != value)
				{
					if (text.Length == 0 && item.Key == "PlayerModel")
					{
						text = "ApeRig";
					}
					if (item.Key == "MonsterSkin")
					{
						monsterSkinRemoved = true;
					}
					if (dictionary == null)
					{
						dictionary = new Dictionary<string, string>(equipped);
					}
					dictionary[item.Key] = text;
				}
			}
			return dictionary;
		}

		private static string KeepWearable(LocalProfileManager profile, string csv, HashSet<string> removed)
		{
			string[] array = csv.Split(',');
			List<string> list = null;
			for (int i = 0; i < array.Length; i++)
			{
				string text = array[i].Trim();
				if (text.Length == 0)
				{
					continue;
				}
				if (MayWear(profile, text))
				{
					if (text.Length > 0 && list != null)
					{
						list.Add(text);
					}
				}
				else
				{
					removed.Add(text);
					if (list != null)
					{
						continue;
					}
					list = new List<string>(array.Length);
					for (int j = 0; j < i; j++)
					{
						string text2 = array[j].Trim();
						if (text2.Length > 0)
						{
							list.Add(text2);
						}
					}
				}
			}
			if (list == null)
			{
				return csv;
			}
			return string.Join(",", list);
		}
	}
}
