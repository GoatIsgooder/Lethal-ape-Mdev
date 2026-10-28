using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	[CreateAssetMenu(fileName = "WeaponDatabase", menuName = "LethalApeR/Rivals/Weapon Database")]
	public class WeaponDatabase : ScriptableObject
	{
		[Tooltip("Every weapon available in the mode. Use the context-menu helper to auto-collect.")]
		[SerializeField]
		private List<WeaponData> weapons = new List<WeaponData>();

		public IReadOnlyList<WeaponData> Weapons => weapons;

		public static string IdOf(WeaponData data)
		{
			if (data != null)
			{
				return data.name;
			}
			return string.Empty;
		}

		public WeaponData GetById(string id)
		{
			if (string.IsNullOrEmpty(id))
			{
				return null;
			}
			for (int i = 0; i < weapons.Count; i++)
			{
				if (weapons[i] != null && weapons[i].name == id)
				{
					return weapons[i];
				}
			}
			return null;
		}

		public IEnumerable<WeaponData> ForSlot(LoadoutSlot slot)
		{
			for (int i = 0; i < weapons.Count; i++)
			{
				if (weapons[i] != null && weapons[i].slot == slot)
				{
					yield return weapons[i];
				}
			}
		}

		private void OnValidate()
		{
			HashSet<string> hashSet = new HashSet<string>();
			foreach (WeaponData weapon in weapons)
			{
				if (!(weapon == null) && !hashSet.Add(weapon.name))
				{
					Debug.LogWarning("[WeaponDatabase] Duplicate weapon asset name '" + weapon.name + "' — unlock persistence keys must be unique.", this);
				}
			}
		}
	}
}
