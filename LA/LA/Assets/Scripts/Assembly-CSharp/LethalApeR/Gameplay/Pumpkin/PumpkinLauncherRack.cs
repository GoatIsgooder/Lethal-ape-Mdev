using LALocomotion;
using LethalApeR.PlayFab;
using System;
using LethalApeR.UI.Notifications;
using QauthSdk;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	[DisallowMultipleComponent]
	public class PumpkinLauncherRack : MonoBehaviour
	{
		[Tooltip("Catalog item that unlocks the launcher (granted by the Season Pass).")]
		public string itemId = "PUMPKIN_LAUNCHER";

		public PumpkinLauncher launcher;

		[Tooltip("Shown while the local player doesn't own the launcher.")]
		public GameObject lockedDisplay;

		[Tooltip("Shown while they do.")]
		public GameObject unlockedDisplay;

		[Tooltip("The renderer with the rack's glow strip, tinted by state.")]
		public Renderer glow;

		[Tooltip("Which of its materials is the glow (only that slot is tinted).")]
		public int glowMaterialIndex = 2;

		public Color unlockedGlow = new Color(0.35f, 1f, 0.25f, 1f);

		public Color lockedGlow = new Color(0.5f, 0.18f, 0.85f, 1f);

		[Tooltip("Seconds between ownership re-checks; inventory events cover most changes.")]
		public float recheckInterval = 2f;

		[Header("Use fee")]
		[Tooltip("Catalog item bought every time the launcher comes off the rack: a consumable priced in GD. Its catalog price is what's charged; useFee only stands in until the catalog has loaded.")]
		public string useItemId = "PUMPKIN_LAUNCHER_USE";

		[Min(0f)]
		public int useFee = 150;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private bool _owned;

		private bool _applied;

		private float _nextCheck;

		private bool _paid;

		private bool _paying;

		private bool _away;

		private bool _sendHome;

		private LAGrabber _refusedHand;

		private TMP_Text _unlockedHint;

		private int _hintPrice = -1;

		private MaterialPropertyBlock _block;

		private Transform _home;

		private Vector3 _homePosition;

		private Quaternion _homeRotation;

		public bool Owned => _owned;

		private bool AtHome
		{
			get
			{
				Transform t = launcher.transform;
				if (t.parent == _home && (t.localPosition - _homePosition).sqrMagnitude < 1E-06f)
				{
					return Quaternion.Angle(t.localRotation, _homeRotation) < 0.5f;
				}
				return false;
			}
		}

		private bool Free => false;

		public int Price
		{
			get
			{
				if (LocalProfileManager.Instance != null)
				{
					int price = LocalProfileManager.Instance.GetItemPrice(useItemId);
					if (price > 0)
					{
						return price;
					}
				}
				return useFee;
			}
		}

		private void Awake()
		{
			if (!(launcher == null))
			{
				_home = launcher.transform.parent;
				_homePosition = launcher.transform.localPosition;
				_homeRotation = launcher.transform.localRotation;
			}
		}

		private void OnEnable()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnInventoryUpdated += Refresh;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnProfileLoaded += Refresh;
			}
			if (launcher != null)
			{
				launcher.Grabbable.onGrab.AddListener(OnPulledOff);
			}
			Refresh();
			Dock();
		}

		private void OnDisable()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnInventoryUpdated -= Refresh;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnProfileLoaded -= Refresh;
			}
			if (launcher != null)
			{
				launcher.Grabbable.onGrab.RemoveListener(OnPulledOff);
			}
		}

		private void Update()
		{
			if (Time.unscaledTime >= _nextCheck)
			{
				Refresh();
			}
		}

		private void LateUpdate()
		{
			if (launcher == null)
			{
				return;
			}
			if (!_owned && launcher.Grabbable.enabled)
			{
				launcher.Grabbable.enabled = false;
			}
			if (_sendHome)
			{
				_sendHome = false;
				if (!_paid && !AtHome)
				{
					launcher.SendHome();
				}
			}
			if (_refusedHand != null)
			{
				if (_refusedHand.GripDown)
				{
					if (launcher.Grabbable.enabled)
					{
						launcher.Grabbable.enabled = false;
					}
				}
				else
				{
					_refusedHand = null;
					if (_owned && !launcher.ReturningHome)
					{
						launcher.Grabbable.enabled = true;
					}
				}
			}
			Dock();
			if (_away && AtHome && !launcher.Grabbable.IsHeld)
			{
				_away = false;
				if (!_paying)
				{
					_paid = false;
				}
			}
			launcher.FeeDue = !_paid;
		}

		private void Dock()
		{
			if (launcher == null || launcher.Grabbable.IsHeld || !AtHome)
			{
				return;
			}
			Rigidbody body = launcher.GetComponent<Rigidbody>();
			if (!(body == null) && !body.isKinematic)
			{
				body.linearVelocity = Vector3.zero;
				body.angularVelocity = Vector3.zero;
				body.isKinematic = true;
			}
		}

		private void OnPulledOff()
		{
			launcher.Grabbable.SetReleasedKinematic(false);
			_away = true;
			if (!_paid && !_paying)
			{
				Charge();
			}
		}

		private void Charge()
		{
			LocalProfileManager profile = LocalProfileManager.Instance;
			if (profile == null || !Qauth.IsLoggedIn)
			{
				Refuse("Not Available", "The Pumpkin Launcher can't be paid for right now. Try again in a moment.");
				return;
			}
			int price = Price;
			int currency = profile.GetCurrency();
			if (currency < price)
			{
				Refuse("Not Enough Gold", string.Format("The Pumpkin Launcher costs {0} GD a use. You're {1} GD short.", price, price - currency));
				return;
			}
			_paying = true;
			PayUseFee(price);
		}

		private async void PayUseFee(int price)
		{
			QauthWalletState wallet;
			try
			{
				wallet = await Qauth.Wallet.BuyAsync(useItemId);
			}
			catch (Exception e)
			{
				wallet = new QauthWalletState { Error = e.Message };
			}
			if (this == null)
			{
				return;
			}
			_paying = false;
			if (wallet.Error == null)
			{
				_paid = true;
				if (LocalProfileManager.Instance != null)
				{
					LocalProfileManager.Instance.SeedCurrency((int)wallet.Coins);
				}
				HandNotifications.Show(NotificationKind.Success, "Pumpkin Launcher", string.Format("{0} GD. It's yours until it goes back on the rack.", price));
				return;
			}
			Debug.LogWarning("[PumpkinLauncherRack] Use fee failed: " + wallet.Error);
			switch (wallet.Error)
			{
			case "NOT_ENOUGH_COINS":
				Refuse("Not Enough Gold", string.Format("The Pumpkin Launcher costs {0} GD a use.", price));
				break;
			case "NOT_FOR_SALE":
				LocalProfileManager.Instance?.FetchCatalog();
				Refuse("Not Available", "The Pumpkin Launcher can't be used right now.");
				break;
			default:
				Refuse("Not Available", "The charge didn't go through. Try again in a moment.");
				break;
			}
		}

		private void Refuse(string title, string body)
		{
			_paid = false;
			_sendHome = true;
			if (launcher != null && launcher.Grabbable.Holder != null)
			{
				_refusedHand = launcher.Grabbable.Holder;
			}
			HandNotifications.Show(NotificationKind.Error, title, body);
		}

		public void Refresh()
		{
			_nextCheck = Time.unscaledTime + recheckInterval;
			RefreshHint();
			bool owned = LocallyOwned();
			if (!_applied || _owned != owned)
			{
				Apply(owned);
			}
		}

		private void RefreshHint()
		{
			if (unlockedDisplay == null)
			{
				return;
			}
			if (_unlockedHint == null)
			{
				_unlockedHint = unlockedDisplay.GetComponentInChildren<TMP_Text>(true);
			}
			int price = Price;
			if (!(_unlockedHint == null) && price != _hintPrice)
			{
				_hintPrice = price;
				_unlockedHint.text = string.Format("{0} GD A USE  ·  FIRES OUTSIDE THE LOBBY", price);
			}
		}

		private bool LocallyOwned()
		{
			if (LocalProfileManager.Instance != null)
			{
				return LocalProfileManager.Instance.OwnsItem(itemId);
			}
			return false;
		}

		private void Apply(bool owned)
		{
			_owned = owned;
			_applied = true;
			if (!owned)
			{
				_paid = false;
			}
			if (lockedDisplay != null)
			{
				lockedDisplay.SetActive(!owned);
			}
			if (unlockedDisplay != null)
			{
				unlockedDisplay.SetActive(owned);
			}
			if (launcher != null)
			{
				LAGrabbable grabbable = launcher.Grabbable;
				if (!owned && grabbable.Holder != null)
				{
					grabbable.Holder.Release(false);
				}
				grabbable.enabled = owned;
			}
			if (!(glow == null) && glowMaterialIndex >= 0 && glowMaterialIndex < glow.sharedMaterials.Length)
			{
				if (_block == null)
				{
					_block = new MaterialPropertyBlock();
				}
				glow.GetPropertyBlock(_block, glowMaterialIndex);
				_block.SetColor(ColorId, owned ? unlockedGlow : lockedGlow);
				glow.SetPropertyBlock(_block, glowMaterialIndex);
			}
		}
	}
}
