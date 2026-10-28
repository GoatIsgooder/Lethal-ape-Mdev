using System;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public class LoadingPlayFabManager : MonoBehaviour
	{
		private bool _loginInFlight;

		public static LoadingPlayFabManager Instance { get; private set; }

		public bool IsLoggedIn { get; private set; }

		public string PlayFabId { get; private set; }

		public string SessionTicket { get; private set; }

		public bool BannedAtLogin { get; private set; }

		public string BannedAtLoginReason { get; private set; }

		public string BannedAtLoginExpiresIso { get; private set; }

		public bool BannedAtLoginPermanent { get; private set; }

		public bool UpdateRequired { get; private set; }

		public string UpdateRequiredVersion { get; private set; }

		public bool UpdateAvailable { get; private set; }

		public int UpdateAvailableDays { get; private set; }

		public int UpdateAvailableMinDays { get; private set; }

		public event Action OnLoggedIn;

		public event Action<string> OnUpdateRequired;

		public event Action<int, int> OnUpdateAvailable;

		public event Action<string, string, bool> OnBannedAtLogin;

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

		private void Start()
		{
			if (OculusAuthManager.Instance != null)
			{
				OculusAuthManager.Instance.OnAuthComplete += HandleOculusAuthComplete;
				if (OculusAuthManager.Instance.HasCompleted)
				{
					LoginWithPlayFab();
				}
			}
		}

		private void OnDestroy()
		{
			if (OculusAuthManager.Instance != null)
			{
				OculusAuthManager.Instance.OnAuthComplete -= HandleOculusAuthComplete;
			}
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void HandleOculusAuthComplete()
		{
			LoginWithPlayFab();
		}

		private string ResolveCustomId()
		{
			if (OculusAuthManager.Instance != null)
			{
				string oculusUserID = OculusAuthManager.Instance.OculusUserID;
				if (!string.IsNullOrEmpty(oculusUserID) && oculusUserID != "0")
				{
					return oculusUserID;
				}
			}
			return null;
		}

		private void LoginWithPlayFab()
		{
			if (_loginInFlight || IsLoggedIn)
			{
				return;
			}
			string text = ResolveCustomId();
			if (string.IsNullOrEmpty(text))
			{
				Debug.LogError("[QauthLoading] Cannot login — no Meta user id (Oculus auth may have failed).");
				return;
			}
			_loginInFlight = true;
			Debug.Log("[QauthLoading] Starting Qauth login...");
			LaAuthLogin.Run(delegate(LaAuthLogin.Result res)
			{
				_loginInFlight = false;
				if (res.Ok)
				{
					PlayFabId = res.PlayFabId;
					SessionTicket = res.SessionTicket;
					PlayerPrefs.SetString("PlayFabId", res.PlayFabId);
					IsLoggedIn = true;
					this.OnLoggedIn?.Invoke();
				}
				else if (res.Status == QauthStatus.UpdateRequired)
				{
					UpdateRequired = true;
					UpdateRequiredVersion = res.RequiredVersion;
					Debug.LogError("[QauthLoading] Login refused: this build is older than the minimum version " + res.RequiredVersion + ".");
					this.OnUpdateRequired?.Invoke(res.RequiredVersion);
				}
				else if (res.Status == QauthStatus.Banned)
				{
					OnLoginBanned(res);
				}
				else
				{
					Debug.LogError("[QauthLoading] Login failed: " + res.Failure + ((res.Error != null) ? (" (" + res.Error + ")") : ""));
				}
			});
		}

		private void OnLoginBanned(LaAuthLogin.Result res)
		{
			_loginInFlight = false;
			Debug.LogError("[QauthLoading] Login failed: account banned (until " + ((res.BanUntil > 0) ? res.BanUntil.ToString() : "permanent") + ").");
			bool flag = res.BanUntil <= 0;
			string text = (string.IsNullOrEmpty(res.BanReason) ? "Your account is banned." : res.BanReason);
			string text2 = (flag ? null : DateTimeOffset.FromUnixTimeMilliseconds(res.BanUntil).UtcDateTime.ToString("o"));
			BannedAtLogin = true;
			BannedAtLoginReason = text;
			BannedAtLoginExpiresIso = text2;
			BannedAtLoginPermanent = flag;
			this.OnBannedAtLogin?.Invoke(text, text2, flag);
		}
	}
}
