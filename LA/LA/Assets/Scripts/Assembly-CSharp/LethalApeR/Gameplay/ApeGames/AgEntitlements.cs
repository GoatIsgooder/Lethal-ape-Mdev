using System;
using System.Collections;
using System.Reflection;
using LethalApeR.PlayFab;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgEntitlements : MonoBehaviour
	{
		public const string ReviveSku = "APEGAMES_REVIVE";

		public const string VipSku = "APEGAMES_VIP";

		private bool _playFabHooked;

		private bool _profileHooked;

		private const int MaxHookAttempts = 120;

		public static AgEntitlements Instance { get; private set; }

		public static bool OwnsRevive { get; private set; }

		public static bool OwnsVip { get; private set; }

		private bool HooksPending => !_playFabHooked || !_profileHooked;

		public static event Action OnEntitlementsChanged;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
			OwnsRevive = false;
			OwnsVip = false;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			OnEntitlementsChanged = null;
			OwnsRevive = false;
			OwnsVip = false;
		}

		private void Start()
		{
			TryHook();
			if (HooksPending)
			{
				StartCoroutine(WaitForManagersAndHook());
			}
		}

		private void OnDestroy()
		{
			if (PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn -= RefreshEntitlements;
				PlayFabManager.Instance.OnInventoryUpdated -= RefreshEntitlements;
			}
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnProfileLoaded -= RefreshEntitlements;
			}
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private IEnumerator WaitForManagersAndHook()
		{
			WaitForSeconds wait = new WaitForSeconds(0.5f);
			int attempt = 0;
			while (HooksPending)
			{
				yield return wait;
				TryHook();
				attempt++;
				if (attempt >= MaxHookAttempts)
				{
					break;
				}
			}
		}

		private void TryHook()
		{
			if (!_playFabHooked && PlayFabManager.Instance != null)
			{
				PlayFabManager.Instance.OnLoggedIn += RefreshEntitlements;
				PlayFabManager.Instance.OnInventoryUpdated += RefreshEntitlements;
				_playFabHooked = true;
				if (PlayFabManager.Instance.IsLoggedIn)
				{
					RefreshEntitlements();
				}
			}
			if (!_profileHooked && LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.OnProfileLoaded += RefreshEntitlements;
				_profileHooked = true;
				RefreshEntitlements();
			}
		}

		private void RefreshEntitlements()
		{
			LocalProfileManager instance = LocalProfileManager.Instance;
			if (instance == null)
			{
				return;
			}
			bool flag = instance.OwnsItem(VipSku);
			bool flag2 = flag || instance.OwnsItem(ReviveSku);
			if (flag != OwnsVip || flag2 != OwnsRevive)
			{
				OwnsVip = flag;
				OwnsRevive = flag2;
				OnEntitlementsChanged?.Invoke();
			}
		}
	}
}
