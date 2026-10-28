using System;
using System.Threading.Tasks;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class OculusAuthManager : MonoBehaviour
	{
		public static OculusAuthManager Instance { get; private set; }

		public bool HasUser { get; private set; }

		public string OculusUserID { get; private set; }

		public string OculusUsername { get; private set; }

		public bool IsEntitled { get; private set; }

		public bool HasCompleted { get; private set; }

		public event Action OnAuthComplete;

		public event Action OnEntitlementVerified;

		public event Action<string> OnEntitlementFailed;

		public event Action OnUserResolved;

		private void Awake()
		{
			if (Instance == null)
			{
				Instance = this;
			}
			else
			{
				UnityEngine.Object.Destroy(base.gameObject);
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Start()
		{
			RequestMicrophonePermission();
			StartMetaLogin();
		}

		private void RequestMicrophonePermission()
		{
			if (!UnityEngine.Android.Permission.HasUserAuthorizedPermission("android.permission.RECORD_AUDIO"))
			{
				UnityEngine.Android.Permission.RequestUserPermission("android.permission.RECORD_AUDIO");
			}
		}

		public void StartMetaLogin()
		{
			_ = RunMetaLogin();
		}

		private async Task RunMetaLogin()
		{
			QauthStatus status;
			try
			{
				status = await Qauth.LoginAsync();
			}
			catch (Exception ex)
			{
				Debug.LogError("[OculusAuthManager] Initialisation exception: " + ex.Message);
				OnEntitlementFailed?.Invoke(ex.Message);
				return;
			}
			if (this == null)
			{
				return;
			}
			switch (status)
			{
			case QauthStatus.NoPlatform:
			{
				string lastError = Qauth.LastError;
				Debug.LogError("[OculusAuthManager] Init error: " + lastError);
				OnEntitlementFailed?.Invoke("Platform init failed: " + lastError);
				return;
			}
			case QauthStatus.NotEntitled:
			{
				string lastError2 = Qauth.LastError;
				Debug.LogError("[OculusAuthManager] User is NOT entitled to this app: " + lastError2);
				IsEntitled = false;
				OnEntitlementFailed?.Invoke(lastError2);
				return;
			}
			}
			if (string.IsNullOrEmpty(Qauth.MetaUserId) || Qauth.MetaUserId == "0")
			{
				Debug.LogError("[OculusAuthManager] User error: " + (Qauth.LastError ?? "invalid Oculus user ID."));
				return;
			}
			Debug.Log("[OculusAuthManager] Entitlement verified.");
			IsEntitled = true;
			OnEntitlementVerified?.Invoke();
			OculusUserID = Qauth.MetaUserId;
			OculusUsername = Qauth.MetaUsername;
			HasUser = true;
			OnUserResolved?.Invoke();
			if (status != QauthStatus.LoggedIn)
			{
				Debug.LogWarning("[OculusAuthManager] Qauth login ended in " + status + ": " + Qauth.LastError);
			}
			HasCompleted = true;
			OnAuthComplete?.Invoke();
		}
	}
}
