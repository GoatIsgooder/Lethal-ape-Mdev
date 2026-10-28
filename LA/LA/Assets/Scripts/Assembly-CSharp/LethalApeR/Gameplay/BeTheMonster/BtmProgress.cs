using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmProgress
	{
		[Serializable]
		private class SaveData
		{
			public int salvage;

			public int lifetimeEarned;

			public List<string> owned = new List<string>();

			public string[] survivorLoadout = new string[3];

			public string[] monsterLoadout = new string[3];
		}

		private const string SaveKey = "BTM.Progress.v1";

		private const string SealKey = "BTM.Progress.v1.s";

		private const string SealSalt = "slop:btm:salvage:7f3a91";

		private static SaveData _data;

		private static readonly HashSet<string> Owned = new HashSet<string>();

		public static int Salvage
		{
			get
			{
				EnsureLoaded();
				return _data.salvage;
			}
		}

		public static int LifetimeEarned
		{
			get
			{
				EnsureLoaded();
				return _data.lifetimeEarned;
			}
		}

		public static event Action Changed;

		public static bool Owns(BtmItemDefinition item)
		{
			EnsureLoaded();
			if (item != null)
			{
				return Owned.Contains(item.id);
			}
			return false;
		}

		public static BtmUnlockResult CanUnlock(BtmItemDefinition item)
		{
			EnsureLoaded();
			if (item == null || string.IsNullOrEmpty(item.id))
			{
				return BtmUnlockResult.Invalid;
			}
			if (Owned.Contains(item.id))
			{
				return BtmUnlockResult.AlreadyOwned;
			}
			if (item.prerequisites != null)
			{
				for (int i = 0; i < item.prerequisites.Length; i++)
				{
					BtmItemDefinition prerequisite = item.prerequisites[i];
					if (prerequisite != null && !Owned.Contains(prerequisite.id))
					{
						return BtmUnlockResult.MissingPrerequisite;
					}
				}
			}
			if (_data.salvage < item.cost)
			{
				return BtmUnlockResult.NotEnoughSalvage;
			}
			return BtmUnlockResult.Unlocked;
		}

		public static BtmUnlockResult TryUnlock(BtmItemDefinition item)
		{
			BtmUnlockResult result = CanUnlock(item);
			if (result != BtmUnlockResult.Unlocked)
			{
				return result;
			}
			_data.salvage -= item.cost;
			_data.owned.Add(item.id);
			Owned.Add(item.id);
			AutoEquip(item);
			Save();
			return result;
		}

		public static void AddSalvage(int amount)
		{
			if (amount > 0)
			{
				EnsureLoaded();
				_data.salvage = SaturatingAdd(_data.salvage, amount);
				_data.lifetimeEarned = SaturatingAdd(_data.lifetimeEarned, amount);
				Save();
			}
		}

		public static int SlotCount(BtmRole role)
		{
			EnsureLoaded();
			BtmTechTreeCatalog instance = BtmTechTreeCatalog.Instance;
			int count = ((instance != null) ? instance.baseSlots : 2);
			if (instance != null)
			{
				foreach (BtmItemDefinition item in instance.items)
				{
					if (item != null && item.effect == BtmEffect.ExtraSlot && item.role == role && Owned.Contains(item.id))
					{
						count++;
					}
				}
			}
			return Mathf.Clamp(count, 1, BtmTechTreeCatalog.MaxSlots);
		}

		public static BtmItemDefinition GetLoadout(BtmRole role, int slot)
		{
			EnsureLoaded();
			string[] loadout = LoadoutArray(role);
			if (slot < 0 || slot >= loadout.Length || slot >= SlotCount(role))
			{
				return null;
			}
			BtmTechTreeCatalog instance = BtmTechTreeCatalog.Instance;
			BtmItemDefinition item = ((instance != null) ? instance.Find(loadout[slot]) : null);
			if (item == null)
			{
				return null;
			}
			if (!item.IsEquipable || item.role != role || !Owned.Contains(item.id))
			{
				return null;
			}
			return item;
		}

		public static bool SetLoadout(BtmRole role, int slot, BtmItemDefinition item)
		{
			EnsureLoaded();
			if (slot < 0 || slot >= SlotCount(role))
			{
				return false;
			}
			if (item != null && (!item.IsEquipable || item.role != role || !Owned.Contains(item.id)))
			{
				return false;
			}
			string[] loadout = LoadoutArray(role);
			if (item != null)
			{
				for (int i = 0; i < loadout.Length; i++)
				{
					if (i != slot && loadout[i] == item.id)
					{
						loadout[i] = loadout[slot];
					}
				}
			}
			loadout[slot] = ((item != null) ? item.id : null);
			Save();
			return true;
		}

		public static bool IsEquipped(BtmRole role, BtmItemDefinition item)
		{
			if (item == null)
			{
				return false;
			}
			int count = SlotCount(role);
			for (int i = 0; i < count; i++)
			{
				if (GetLoadout(role, i) == item)
				{
					return true;
				}
			}
			return false;
		}

		public static void ResetAll()
		{
			_data = new SaveData();
			Owned.Clear();
			Save();
		}

		private static void AutoEquip(BtmItemDefinition item)
		{
			if (!item.IsEquipable)
			{
				return;
			}
			string[] loadout = LoadoutArray(item.role);
			int count = SlotCount(item.role);
			for (int i = 0; i < count; i++)
			{
				if (string.IsNullOrEmpty(loadout[i]) || GetLoadout(item.role, i) == null)
				{
					loadout[i] = item.id;
					break;
				}
			}
		}

		private static string[] LoadoutArray(BtmRole role)
		{
			ref string[] loadout = ref ((role == BtmRole.Monster) ? ref _data.monsterLoadout : ref _data.survivorLoadout);
			if (loadout == null || loadout.Length != 3)
			{
				string[] resized = new string[3];
				if (loadout != null)
				{
					Array.Copy(loadout, resized, Math.Min(loadout.Length, resized.Length));
				}
				loadout = resized;
			}
			return loadout;
		}

		private static void EnsureLoaded()
		{
			if (_data != null)
			{
				return;
			}
			_data = new SaveData();
			Owned.Clear();
			string json = PlayerPrefs.GetString(SaveKey, "");
			if (string.IsNullOrEmpty(json))
			{
				return;
			}
			if (PlayerPrefs.GetString(SealKey, "") != Seal(json))
			{
				Debug.LogWarning("[BtmProgress] Save seal mismatch — progress was edited outside the game and has been reset.");
				Save();
				return;
			}
			try
			{
				SaveData saveData = JsonUtility.FromJson<SaveData>(json);
				if (saveData != null)
				{
					_data = saveData;
				}
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[BtmProgress] Unreadable save, starting fresh: " + ex.Message);
			}
			if (_data.owned == null)
			{
				_data.owned = new List<string>();
			}
			_data.salvage = Math.Max(0, _data.salvage);
			foreach (string id in _data.owned)
			{
				if (!string.IsNullOrEmpty(id))
				{
					Owned.Add(id);
				}
			}
		}

		private static void Save()
		{
			string json = JsonUtility.ToJson(_data);
			PlayerPrefs.SetString(SaveKey, json);
			PlayerPrefs.SetString(SealKey, Seal(json));
			PlayerPrefs.Save();
			BtmProgress.Changed?.Invoke();
		}

		private static string Seal(string json)
		{
			ulong hash = 14695981039346656037uL;
			foreach (char c in SealSalt)
			{
				hash ^= c;
				hash *= 1099511628211uL;
			}
			foreach (char c in json)
			{
				hash ^= c;
				hash *= 1099511628211uL;
			}
			for (int i = SealSalt.Length - 1; i >= 0; i--)
			{
				hash ^= SealSalt[i];
				hash *= 1099511628211uL;
			}
			return hash.ToString("x16");
		}

		private static int SaturatingAdd(int a, int b)
		{
			return (int)Math.Min((long)a + (long)b, 2147483647L);
		}
	}
}
