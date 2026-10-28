using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[CreateAssetMenu(menuName = "Slop/BTM/Tech Tree Catalog", fileName = "BtmTechTreeCatalog")]
	public class BtmTechTreeCatalog : ScriptableObject
	{
		public const string ResourcePath = "BtmTechTreeCatalog";

		public const string CurrencyName = "Salvage";

		[Tooltip("Network ids are indices into this list, so every client must ship the same order. Append new items; never reorder.")]
		public List<BtmItemDefinition> items = new List<BtmItemDefinition>();

		[Header("Salvage payouts (master-computed at round end)")]
		[Min(0f)]
		public int participation = 10;

		[Min(0f)]
		public int survivorWin = 40;

		[Min(0f)]
		public int monsterWin = 40;

		[Min(0f)]
		public int monsterKill = 15;

		[Tooltip("On top of the survivor win, for walking out the escape door.")]
		[Min(0f)]
		public int escapeBonus = 15;

		[Tooltip("Salvage per point of generator charge a survivor personally cranked (a solo generator is 100 points).")]
		[Min(0f)]
		public float perCrankPoint = 0.15f;

		[Min(0f)]
		public int crankCap = 30;

		[Tooltip("Hard ceiling for one round. Receivers clamp to this too.")]
		[Min(0f)]
		public int roundCap = 150;

		[Header("Loadout")]
		[Range(1f, 3f)]
		public int baseSlots = 2;

		public const int MaxSlots = 3;

		private static BtmTechTreeCatalog _instance;

		private Dictionary<string, BtmItemDefinition> _byId;

		public static BtmTechTreeCatalog Instance
		{
			get
			{
				if (_instance == null)
				{
					_instance = Resources.Load<BtmTechTreeCatalog>("BtmTechTreeCatalog");
				}
				return _instance;
			}
		}

		public BtmItemDefinition Find(string id)
		{
			if (string.IsNullOrEmpty(id))
			{
				return null;
			}
			if (_byId == null)
			{
				_byId = new Dictionary<string, BtmItemDefinition>(items.Count);
				foreach (BtmItemDefinition item in items)
				{
					if (item != null && !string.IsNullOrEmpty(item.id))
					{
						_byId[item.id] = item;
					}
				}
			}
			if (!_byId.TryGetValue(id, out var value))
			{
				return null;
			}
			return value;
		}

		public int IndexOf(BtmItemDefinition item)
		{
			if (item == null)
			{
				return -1;
			}
			return items.IndexOf(item);
		}

		public BtmItemDefinition Get(int index)
		{
			if (index < 0 || index >= items.Count)
			{
				return null;
			}
			return items[index];
		}

		public void CollectEquipable(BtmRole role, List<BtmItemDefinition> into)
		{
			foreach (BtmItemDefinition item in items)
			{
				if (item != null && item.IsEquipable && item.role == role)
				{
					into.Add(item);
				}
			}
		}

		private void OnValidate()
		{
			_byId = null;
		}
	}
}
