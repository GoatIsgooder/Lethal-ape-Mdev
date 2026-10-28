using System;
using LethalApeR.PlayFab;
using Photon.Pun;
using QauthSdk;
using UnityEngine;

namespace LethalApeR
{
	public class DevMenuChecker : MonoBehaviour
	{
		[Tooltip("DevMenu GameObject to gate. Empty = first child.")]
		[SerializeField]
		private GameObject _devMenuObject;

		[Tooltip("Qauth account ids (or Meta user ids) granted the Owner tier. The Editor is always Owner.")]
		[SerializeField]
		private string[] _ownerPlayFabIds = new string[0];

		// Always Owner, whatever the scene lists (HarpHogan_8pjf7q)
		private static readonly string[] BuiltInOwnerIds = new string[1] { "28882263788032852" };

		private DevMenu _devMenu;

		private void Awake()
		{
			if (_devMenuObject == null && base.transform.childCount > 0)
			{
				_devMenuObject = base.transform.GetChild(0).gameObject;
			}
			if (!(_devMenuObject == null))
			{
				_devMenu = _devMenuObject.GetComponent<DevMenu>();
				_devMenuObject.SetActive(false);
			}
		}

		private void OnEnable()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnInventoryUpdated += Evaluate;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnProfileLoaded += Evaluate;
			}
			InvokeRepeating("Evaluate", 3f, 5f);
		}

		private void OnDisable()
		{
			CancelInvoke("Evaluate");
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnInventoryUpdated -= Evaluate;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnProfileLoaded -= Evaluate;
			}
		}

		private void Evaluate()
		{
			LocalProfileManager instance = LocalProfileManager.Instance;
			if (!(instance == null))
			{
				DevMenuTier devMenuTier = ResolveTier(instance);
				Grant(devMenuTier);
				if (devMenuTier != DevMenuTier.None)
				{
					CancelInvoke("Evaluate");
				}
			}
		}

		private DevMenuTier ResolveTier(LocalProfileManager profile)
		{
			if (IsListedOwner())
			{
				return DevMenuTier.Owner;
			}
			if (profile.OwnsItem("DEVMENUADMIN"))
			{
				return DevMenuTier.Admin;
			}
			if (profile.OwnsItem("DEVMENUMODS"))
			{
				return DevMenuTier.Mod;
			}
			if (profile.OwnsItem("DEVMENU"))
			{
				return DevMenuTier.Trial;
			}
			return DevMenuTier.None;
		}

		private bool IsListedOwner()
		{
			string accountId = Qauth.AccountId;
			string userId = PhotonNetwork.LocalPlayer?.UserId;
			if (string.IsNullOrEmpty(accountId) && string.IsNullOrEmpty(userId))
			{
				return false;
			}
			string[] serialized = _ownerPlayFabIds ?? new string[0];
			string[] ids = new string[BuiltInOwnerIds.Length + serialized.Length];
			BuiltInOwnerIds.CopyTo(ids, 0);
			serialized.CopyTo(ids, BuiltInOwnerIds.Length);
			for (int i = 0; i < ids.Length; i++)
			{
				string text = ids[i];
				if (!string.IsNullOrEmpty(text) && ((!string.IsNullOrEmpty(accountId) && string.Equals(text.Trim(), accountId, StringComparison.OrdinalIgnoreCase)) || (!string.IsNullOrEmpty(userId) && string.Equals(text.Trim(), userId, StringComparison.OrdinalIgnoreCase))))
				{
					return true;
				}
			}
			return false;
		}

		private void Grant(DevMenuTier tier)
		{
			if (_devMenuObject == null)
			{
				return;
			}
			if (_devMenuObject.activeSelf != (tier != DevMenuTier.None))
			{
				_devMenuObject.SetActive(tier != DevMenuTier.None);
			}
			if (_devMenu != null && _devMenu.Tier != tier)
			{
				_devMenu.Tier = tier;
			}
		}
	}
}
