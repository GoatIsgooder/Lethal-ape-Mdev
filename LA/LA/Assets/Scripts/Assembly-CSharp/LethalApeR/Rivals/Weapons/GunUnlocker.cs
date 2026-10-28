using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Rivals.Economy;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	[RequireComponent(typeof(Transform))]
	[Obfuscation(Exclude = true)]
	public class GunUnlocker : MonoBehaviour
	{
		[Serializable]
		[Obfuscation(Exclude = true)]
		private class UnlockSave
		{
			public List<string> ids = new List<string>();
		}

		[Serializable]
		[Obfuscation(Exclude = true)]
		private class LoadoutSave
		{
			public List<string> slotIds = new List<string>();
		}

		[Header("Catalogue")]
		[Tooltip("The master weapon list. Required.")]
		[SerializeField]
		private WeaponDatabase database;

		[Header("State")]
		[Tooltip("Whether unlocking/equipping is currently permitted (false during live rounds).")]
		[SerializeField]
		private bool purchasingAllowed = true;

		private const string UnlocksKey = "UnlockedWeapons";

		private const string LoadoutKey = "Loadout";

		private readonly HashSet<string> _unlocked = new HashSet<string>();

		private readonly Dictionary<LoadoutSlot, WeaponData> _loadout = new Dictionary<LoadoutSlot, WeaponData>();

		private bool _trialUnlockAll;

		public static GunUnlocker Instance { get; private set; }

		public WeaponDatabase Database => database;

		public bool PurchasingAllowed => purchasingAllowed;

		public bool TrialUnlockAll => _trialUnlockAll;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
			LoadUnlocks();
			LoadLoadout();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public bool IsUnlocked(WeaponData weapon)
		{
			if (weapon == null)
			{
				return false;
			}
			if (_trialUnlockAll || weapon.unlockedByDefault)
			{
				return true;
			}
			return _unlocked.Contains(WeaponDatabase.IdOf(weapon));
		}

		public bool TryUnlock(WeaponData weapon)
		{
			if (weapon == null || !purchasingAllowed || IsUnlocked(weapon))
			{
				return false;
			}
			KeyManager instance = KeyManager.Instance;
			if (instance == null)
			{
				Debug.LogWarning("[GunUnlocker] No KeyManager in scene — cannot spend.");
				return false;
			}
			if (!instance.TrySpend(weapon.unlockPrice))
			{
				return false;
			}
			_unlocked.Add(WeaponDatabase.IdOf(weapon));
			SaveUnlocks();
			RivalsEvents.RaiseWeaponUnlocked(weapon);
			return true;
		}

		public bool Equip(WeaponData weapon, LoadoutSlot slot)
		{
			if (weapon == null || !purchasingAllowed || !IsUnlocked(weapon))
			{
				return false;
			}
			if (weapon.slot != slot)
			{
				return false;
			}
			_loadout[slot] = weapon;
			SaveLoadout();
			RivalsEvents.RaiseLoadoutChanged();
			return true;
		}

		public WeaponData GetEquipped(LoadoutSlot slot)
		{
			if (!_loadout.TryGetValue(slot, out var value))
			{
				return null;
			}
			return value;
		}

		public IReadOnlyDictionary<LoadoutSlot, WeaponData> GetLoadout()
		{
			return _loadout;
		}

		public void SetPurchasingAllowed(bool allowed)
		{
			purchasingAllowed = allowed;
		}

		public void SetTrialUnlockAll(bool on)
		{
			if (_trialUnlockAll != on)
			{
				_trialUnlockAll = on;
				if (!on)
				{
					RevalidateLoadout();
				}
			}
		}

		public void ClearLoadout()
		{
			if (_loadout.Count != 0)
			{
				_loadout.Clear();
				RivalsEvents.RaiseLoadoutChanged();
			}
		}

		public void RestoreLoadout(IReadOnlyDictionary<LoadoutSlot, WeaponData> snapshot)
		{
			_loadout.Clear();
			if (snapshot != null)
			{
				foreach (KeyValuePair<LoadoutSlot, WeaponData> item in snapshot)
				{
					if (item.Value != null && IsUnlocked(item.Value))
					{
						_loadout[item.Key] = item.Value;
					}
				}
			}
			SaveLoadout();
			RivalsEvents.RaiseLoadoutChanged();
		}

		public void RevalidateLoadout()
		{
			if (database == null)
			{
				return;
			}
			foreach (LoadoutSlot item in new List<LoadoutSlot>(_loadout.Keys))
			{
				if (!IsUnlocked(_loadout[item]))
				{
					_loadout.Remove(item);
				}
			}
			foreach (LoadoutSlot value in Enum.GetValues(typeof(LoadoutSlot)))
			{
				if (_loadout.ContainsKey(value))
				{
					continue;
				}
				foreach (WeaponData item2 in database.ForSlot(value))
				{
					if (IsUnlocked(item2))
					{
						_loadout[value] = item2;
						break;
					}
				}
			}
			SaveLoadout();
			RivalsEvents.RaiseLoadoutChanged();
		}

		private void LoadUnlocks()
		{
			_unlocked.Clear();
			foreach (string id in SaveWrapper.GetJson<UnlockSave>(UnlocksKey).ids)
			{
				_unlocked.Add(id);
			}
			if (!(database != null))
			{
				return;
			}
			foreach (WeaponData weapon in database.Weapons)
			{
				if (weapon != null && weapon.unlockedByDefault)
				{
					_unlocked.Add(WeaponDatabase.IdOf(weapon));
				}
			}
		}

		private void SaveUnlocks()
		{
			UnlockSave value = new UnlockSave();
			value.ids = new List<string>(_unlocked);
			SaveWrapper.SetJson(UnlocksKey, value);
		}

		private void LoadLoadout()
		{
			_loadout.Clear();
			if (database == null)
			{
				return;
			}
			LoadoutSave json = SaveWrapper.GetJson<LoadoutSave>(LoadoutKey);
			for (int i = 0; i < json.slotIds.Count; i++)
			{
				WeaponData byId = database.GetById(json.slotIds[i]);
				if (byId != null && IsUnlocked(byId))
				{
					_loadout[(LoadoutSlot)i] = byId;
				}
			}
			foreach (LoadoutSlot value in Enum.GetValues(typeof(LoadoutSlot)))
			{
				if (_loadout.ContainsKey(value))
				{
					continue;
				}
				foreach (WeaponData item in database.ForSlot(value))
				{
					if (IsUnlocked(item))
					{
						_loadout[value] = item;
						break;
					}
				}
			}
		}

		private void SaveLoadout()
		{
			Array values = Enum.GetValues(typeof(LoadoutSlot));
			LoadoutSave loadoutSave = new LoadoutSave();
			for (int i = 0; i < values.Length; i++)
			{
				WeaponData equipped = GetEquipped((LoadoutSlot)i);
				loadoutSave.slotIds.Add((equipped != null) ? WeaponDatabase.IdOf(equipped) : string.Empty);
			}
			SaveWrapper.SetJson(LoadoutKey, loadoutSave);
		}

		private void OnValidate()
		{
			if (database == null)
			{
				Debug.LogWarning("[GunUnlocker] No WeaponDatabase assigned on '" + base.name + "'.", this);
			}
		}
	}
}
