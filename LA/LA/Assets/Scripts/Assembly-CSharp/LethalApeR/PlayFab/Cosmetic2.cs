using TMPro;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class Cosmetic2 : BaseButton
	{
		public TMP_Text text;

		public string itemID;

		public string itemId;

		private const string OwnedLabel = "OWNS";

		private const string UnownedLabel = "FREE";

		private bool _ownershipResolved;

		private bool _owned;

		private void Start()
		{
			text.text = "FREE";
			ResolveOwnershipOnce();
		}

		private void Update()
		{
			if (!_ownershipResolved && !(LocalProfileManager.Instance == null))
			{
				ResolveOwnershipOnce();
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				TryGrant();
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			TryGrant();
		}

		private void ResolveOwnershipOnce()
		{
			if (!_ownershipResolved)
			{
				LocalProfileManager instance = LocalProfileManager.Instance;
				if (!(instance == null))
				{
					_ownershipResolved = true;
					SetOwned(instance.OwnsItem(itemId));
				}
			}
		}

		private void TryGrant()
		{
			LocalProfileManager instance = LocalProfileManager.Instance;
			if (!(instance == null) && !_owned)
			{
				instance.AddOwnedItem(itemId);
				SetOwned(true);
				Debug.Log("Successfully granted free cosmetic: " + itemId);
				if (WardrobeManager.Instance != null)
				{
					WardrobeManager.RefreshAll();
				}
				if (PlayFabManager.Instance != null)
				{
					PlayFabManager.Instance.NotifyInventoryUpdated();
				}
			}
		}

		private void SetOwned(bool owned)
		{
			_owned = owned;
			text.text = (owned ? "OWNS" : "FREE");
		}
	}
}
