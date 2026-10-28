using System.Reflection;
using LethalApeR.PlayFab;
using TMPro;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class GunsLolRewardManager : MonoBehaviour
	{
		private const string PlayerPrefsKey = "GunsLolRewardsPrompted2";

		private const string RewardItemId = "GUNSLOL_PLUSHIE";

		[SerializeField]
		private TMP_Text promptText;

		private int _totalButtons;

		private int _mask;

		private int _pendingMask;

		private bool _purchaseRequested;

		private static GunsLolRewardManager I { get; set; }

		private bool IsComplete
		{
			get
			{
				if (_totalButtons > 0)
				{
					int full = (1 << _totalButtons) - 1;
					return (_mask & full) == full;
				}
				return false;
			}
		}

		private void Awake()
		{
			if ((bool)I && I != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			I = this;
			_mask = PlayerPrefs.GetInt("GunsLolRewardsPrompted2", 0);
		}

		private void Start()
		{
			PlayFabManager instance = PlayFabManager.Instance;
			if (instance == null)
			{
				return;
			}
			if (instance.IsLoggedIn)
			{
				OnLoggedIn();
			}
			else
			{
				instance.OnLoggedIn += OnLoggedIn;
			}
		}

		private void OnDestroy()
		{
			PlayFabManager instance = PlayFabManager.Instance;
			if (instance != null)
			{
				instance.OnLoggedIn -= OnLoggedIn;
			}
			if (I == this)
			{
				I = null;
			}
		}

		private void OnLoggedIn()
		{
			SetTotalButtons(5);
		}

		private void SetTotalButtons(int count)
		{
			_totalButtons = Mathf.Clamp(count, 0, 30);
			Refresh();
		}

		public void MarkVisited(int index)
		{
			if (index >= 0 && index < _totalButtons)
			{
				_pendingMask |= 1 << index;
			}
		}

		private void OnApplicationPause(bool paused)
		{
			if (paused)
			{
				CommitPending();
			}
		}

		private void OnApplicationFocus(bool focused)
		{
			if (focused)
			{
				Refresh();
			}
		}

		private void CommitPending()
		{
			if (_pendingMask != 0)
			{
				int mask = _mask;
				_mask |= _pendingMask;
				_pendingMask = 0;
				if (_mask != mask)
				{
					PlayerPrefs.SetInt("GunsLolRewardsPrompted2", _mask);
					PlayerPrefs.Save();
				}
				Refresh();
			}
		}

		private void Refresh()
		{
			if (!promptText)
			{
				return;
			}
			if (_totalButtons <= 0)
			{
				promptText.text = "";
				return;
			}
			int num = CountBits(_mask & ((1 << _totalButtons) - 1));
			promptText.text = ((num < _totalButtons) ? string.Format("Visit all {0} dev pages to claim the reward\n({1}/{2})", _totalButtons, num, _totalButtons) : "All pages visited.\n Check your wardrobe (hand)");
			if (IsComplete && !_purchaseRequested)
			{
				PlayFabManager instance = PlayFabManager.Instance;
				if (!(instance == null))
				{
					_purchaseRequested = true;
					if (!instance.OwnsItem("GUNSLOL_PLUSHIE"))
					{
						instance.PurchaseItem("GUNSLOL_PLUSHIE", 0, false, delegate
						{
						});
					}
				}
			}
		}

		private static int CountBits(int v)
		{
			int num = 0;
			while (v != 0)
			{
				v &= v - 1;
				num++;
			}
			return num;
		}
	}
}
