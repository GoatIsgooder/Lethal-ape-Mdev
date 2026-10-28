using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	public class WeaponAmmoDisplay : MonoBehaviour
	{
		[Header("Source")]
		[Tooltip("Weapon to read ammo from. Auto-found on this GameObject / parent if empty.")]
		[SerializeField]
		private Weapon weapon;

		[Header("Labels")]
		[Tooltip("Shows rounds left in the current clip/magazine.")]
		[SerializeField]
		private TMP_Text clipText;

		[Tooltip("Shows reserve ammo left in total (spare rounds not yet loaded).")]
		[SerializeField]
		private TMP_Text reserveText;

		[Header("Formatting")]
		[Tooltip("Format for the clip count. {0} = rounds in the clip.")]
		[SerializeField]
		private string clipFormat = "{0}";

		[Tooltip("Format for the reserve count. {0} = reserve rounds.")]
		[SerializeField]
		private string reserveFormat = "{0}";

		[Tooltip("Shown in the clip label while reloading. Leave empty to keep showing the number.")]
		[SerializeField]
		private string reloadingLabel = "...";

		[Tooltip("Symbol used when reserve ammo is infinite (Weapon reserve set to -1).")]
		[SerializeField]
		private string infiniteSymbol = "∞";

		[Tooltip("Hide both labels for weapons that don't use ammo (melee, beam, shield, etc).")]
		[SerializeField]
		private bool hideWhenNoAmmo = true;

		private int _lastClip = int.MinValue;

		private int _lastReserve = int.MinValue;

		private bool _lastReloading;

		private bool _initialized;

		private void Awake()
		{
			if (weapon == null)
			{
				weapon = GetComponentInParent<Weapon>();
			}
		}

		private void OnEnable()
		{
			_initialized = false;
		}

		private void LateUpdate()
		{
			if (weapon == null)
			{
				return;
			}
			bool flag = weapon.Data != null && weapon.Data.UsesAmmo;
			if (hideWhenNoAmmo && !flag)
			{
				SetActive(clipText, on: false);
				SetActive(reserveText, on: false);
				return;
			}
			SetActive(clipText, on: true);
			SetActive(reserveText, on: true);
			int currentAmmo = weapon.CurrentAmmo;
			int reserveAmmo = weapon.ReserveAmmo;
			bool isReloading = weapon.IsReloading;
			if (_initialized && currentAmmo == _lastClip && reserveAmmo == _lastReserve && _lastReloading == isReloading)
			{
				return;
			}
			if (clipText != null)
			{
				clipText.text = ((isReloading && reloadingLabel.Length > 0) ? reloadingLabel : string.Format(clipFormat, currentAmmo));
			}
			if (reserveText != null)
			{
				string arg = ((reserveAmmo < 0) ? infiniteSymbol : reserveAmmo.ToString());
				reserveText.text = string.Format(reserveFormat, arg);
			}
			_lastClip = currentAmmo;
			_lastReserve = reserveAmmo;
			_lastReloading = isReloading;
			_initialized = true;
		}

		private static void SetActive(TMP_Text t, bool on)
		{
			if (t != null && t.gameObject.activeSelf != on)
			{
				t.gameObject.SetActive(on);
			}
		}
	}
}
