using LethalApeR.Rivals.Weapons;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class LoadoutSlotButton : BaseButton
	{
		[Tooltip("Which loadout slot this button assigns.")]
		public LoadoutSlot slot;

		[Tooltip("The weapon equipped when pressed. Its WeaponData.slot should match 'slot'.")]
		public WeaponData weapon;

		[Header("Feedback (optional)")]
		public Renderer highlightRenderer;

		public Color selectedColor = Color.green;

		[Tooltip("Shown while the weapon isn't unlocked (e.g. a padlock icon). Presses are rejected while locked.")]
		public GameObject lockedVisual;

		private void OnEnable()
		{
			RefreshLocked();
		}

		public void RefreshLocked()
		{
			if (!(lockedVisual == null))
			{
				GunUnlocker instance = GunUnlocker.Instance;
				bool active = instance != null && weapon != null && !instance.IsUnlocked(weapon);
				lockedVisual.SetActive(active);
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			GunUnlocker instance = GunUnlocker.Instance;
			if (instance == null || weapon == null)
			{
				return;
			}
			bool purchasingAllowed = instance.PurchasingAllowed;
			instance.SetPurchasingAllowed(true);
			bool num = instance.Equip(weapon, slot);
			instance.SetPurchasingAllowed(purchasingAllowed);
			if (num)
			{
				if (highlightRenderer != null)
				{
					highlightRenderer.material.color = selectedColor;
				}
				GetComponentInParent<LoadoutBox>()?.NotifyEquipped(slot);
			}
			else if (!instance.IsUnlocked(weapon))
			{
				Debug.Log("[LoadoutSlotButton] '" + weapon.displayName + "' is LOCKED — buy it in the store first (or untick its price / use GunUnlocker's unlock-all debug).");
			}
			else if (weapon.slot != slot)
			{
				Debug.LogWarning(string.Format("[LoadoutSlotButton] '{0}' is a {1} weapon but this button assigns {2} — fix one of them.", weapon.name, weapon.slot, slot), this);
			}
		}
	}
}
