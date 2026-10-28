using System;
using System.Collections;
using System.Globalization;
using QauthSdk;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.PlayFab
{
	public class LoadingScreenAuth : MonoBehaviour
	{
		[Header("Scene Load")]
		[SerializeField]
		private string mainSceneName = "Main_Scene";

		[SerializeField]
		private float preLoadDelay = 0.5f;

		[Header("UI — Loading")]
		[SerializeField]
		private GameObject loadingObject;

		[SerializeField]
		private TMP_Text statusText;

		[Header("UI — Banned")]
		[SerializeField]
		private GameObject bannedObject;

		[SerializeField]
		private TMP_Text banReasonText;

		[SerializeField]
		private TMP_Text banTimeRemainingText;

		[Header("Behaviour")]
		[Tooltip("Quit the app a few seconds after entitlement fails. Required by Meta for store builds. Always disabled in editor.")]
		[SerializeField]
		private bool quitOnEntitlementFail = true;

		[SerializeField]
		private float quitDelay = 3f;

		[Tooltip("If the auth chain hasn't reached scene-load by this many seconds, force-load the main scene anyway (fail-open). Set <= 0 to disable.")]
		[SerializeField]
		private float watchdogSeconds = 60f;

		[Header("Banned message")]
		[Tooltip("Appeal line appended below the username + ban reason. Edit here to change the Discord invite or wording.")]
		[SerializeField]
		[TextArea(2, 4)]
		private string appealMessage = "To appeal this ban, join our Discord:\ndiscord.gg/lethalape";

		[Header("Headset out of date")]
		[Tooltip("Shown when Meta reports the headset is too far behind on security patches. {0} = days behind, {1} = maximum allowed.")]
		[SerializeField]
		[TextArea(2, 5)]
		private string updateAvailableMessage = "Heads up: your headset is {0} days behind on system updates.\nPlease update soon — it will be required to play.";

		[Tooltip("How long the advisory notice stays on screen before the game continues.")]
		[SerializeField]
		private float updateNoticeSeconds = 4f;

		[Header("Auth diagnostic")]
		[Tooltip("Show which Qauth account this launch resolved to on the loading screen. Account ids are fingerprinted, never shown raw. Turn OFF for a public release build.")]
		[SerializeField]
		private bool showAuthDiagnostic = true;

		[SerializeField]
		private float authDiagnosticSeconds = 2f;

		[Tooltip("Hold time when the account CHANGED since last launch — the case worth reading.")]
		[SerializeField]
		private float authDiagnosticErrorSeconds = 8f;

		[Header("Editor test")]
		[Tooltip("Editor only: once Qauth login succeeds, take the real banned path as if the login had been refused, to preview every ban screen. Never compiled into builds.")]
		[SerializeField]
		private bool editorSimulateBan;

		[SerializeField]
		private string editorBanReason = "Testing the ban notice";

		[Tooltip("Hours left on the simulated ban. 0 = permanent.")]
		[SerializeField]
		private float editorBanHours = 67.2f;

		private string updateRequiredMessage = "This version of the game is out of date.\n\nVersion {0} or newer is required.\nUpdate the game from the Meta Horizon Store, then restart it.";

		private bool _isBanned;

		private bool _updateRequired;

		private bool _banPermanent;

		private string _banUsername;

		private string _banReason;

		private string _banRemaining = string.Empty;

		private DateTime? _banExpiresUtc;

		private long _lastCountdownSeconds = long.MinValue;

		private bool _flowFinished;

		private bool _banCheckStarted;

		private bool _entitlementHandled;

		private bool _oculusAuthHandled;

		private bool _cleared;

		private bool _updateNoticeShown;

		public bool IsCleared => _cleared;

		public bool IsBlocked => _flowFinished && !_cleared;

		public bool IsBanned => _isBanned;

		public string BanUsername => _banUsername;

		public string BanReason => _banReason;

		public string AppealMessage => appealMessage;

		public string BanRemainingText => _banRemaining;

		public float WorldProgress { get; private set; }

		public bool WorldReady { get; private set; }

		public bool HoldActivation { get; set; }

		private void Awake()
		{
			if ((bool)loadingObject)
			{
				loadingObject.SetActive(true);
			}
			if ((bool)bannedObject)
			{
				bannedObject.SetActive(false);
			}
			SetStatus("Initializing...");
		}

		private void OnEnable()
		{
			if (OculusAuthManager.Instance != null)
			{
				OculusAuthManager.Instance.OnEntitlementVerified += HandleEntitlementVerified;
				OculusAuthManager.Instance.OnEntitlementFailed += HandleEntitlementFailed;
				OculusAuthManager.Instance.OnAuthComplete += HandleOculusAuthComplete;
				if (OculusAuthManager.Instance.IsEntitled)
				{
					HandleEntitlementVerified();
				}
			}
			else
			{
				Debug.LogWarning("[LoadingScreenAuth] OculusAuthManager.Instance is null in OnEnable — make sure OculusAuthManager exists in the scene with a lower script execution order, or on the same GameObject.");
			}
			if (LoadingPlayFabManager.Instance != null)
			{
				LoadingPlayFabManager.Instance.OnLoggedIn += HandlePlayFabLoggedIn;
				LoadingPlayFabManager.Instance.OnBannedAtLogin += HandleBannedAtLogin;
				LoadingPlayFabManager.Instance.OnUpdateRequired += HandleUpdateRequired;
				LoadingPlayFabManager.Instance.OnUpdateAvailable += HandleUpdateAvailable;
				if (LoadingPlayFabManager.Instance.IsLoggedIn)
				{
					HandlePlayFabLoggedIn();
				}
			}
			else
			{
				Debug.LogWarning("[LoadingScreenAuth] LoadingPlayFabManager.Instance is null in OnEnable — make sure the loading scene has a LoadingPlayFabManager (NOT the main-scene PlayFabManager).");
			}
		}

		private void OnDisable()
		{
			if (OculusAuthManager.Instance != null)
			{
				OculusAuthManager.Instance.OnEntitlementVerified -= HandleEntitlementVerified;
				OculusAuthManager.Instance.OnEntitlementFailed -= HandleEntitlementFailed;
				OculusAuthManager.Instance.OnAuthComplete -= HandleOculusAuthComplete;
			}
			if (LoadingPlayFabManager.Instance != null)
			{
				LoadingPlayFabManager.Instance.OnLoggedIn -= HandlePlayFabLoggedIn;
				LoadingPlayFabManager.Instance.OnBannedAtLogin -= HandleBannedAtLogin;
				LoadingPlayFabManager.Instance.OnUpdateRequired -= HandleUpdateRequired;
				LoadingPlayFabManager.Instance.OnUpdateAvailable -= HandleUpdateAvailable;
			}
		}

		private void Start()
		{
			SetStatus("Verifying app entitlement...");
			if (watchdogSeconds > 0f)
			{
				StartCoroutine(WatchdogRoutine());
			}
		}

		private IEnumerator WatchdogRoutine()
		{
			yield return new WaitForSeconds(watchdogSeconds);
			if (!_flowFinished)
			{
				_flowFinished = true;
				string text = string.Format("entitled={0} ", OculusAuthManager.Instance?.IsEntitled) + string.Format("loggedIn={0} ", LoadingPlayFabManager.Instance?.IsLoggedIn) + string.Format("banCheckStarted={0}", _banCheckStarted);
				Debug.LogError(string.Format("[LoadingScreenAuth] Watchdog tripped after {0:0}s — auth chain stalled. {1}", watchdogSeconds, text));
				SetStatus("Authentication failed.\nPlease restart the app.\n\n<size=50%>" + text + "</size>");
			}
		}

		private void HandleEntitlementVerified()
		{
			if (!_flowFinished && !_entitlementHandled)
			{
				_entitlementHandled = true;
				SetStatus("Entitlement verified. Signing in...");
			}
		}

		private void HandleEntitlementFailed(string reason)
		{
			Debug.LogError("[LoadingScreenAuth] Entitlement failed: " + reason);
			if (Application.isEditor)
			{
				// RE: unsure - branch compiled out of the player build (Application.isEditor is constant false); body inferred from its unused string literal
				SetStatus("Editor: entitlement skipped, awaiting login...");
			}
			else if (!_flowFinished)
			{
				_flowFinished = true;
				SetStatus("Entitlement check failed.\n" + reason);
				if (quitOnEntitlementFail)
				{
					StartCoroutine(QuitAfterDelay());
				}
			}
		}

		private IEnumerator QuitAfterDelay()
		{
			yield return new WaitForSeconds(quitDelay);
			Application.Quit();
		}

		private void HandleOculusAuthComplete()
		{
			if (!_flowFinished && !_oculusAuthHandled)
			{
				_oculusAuthHandled = true;
				SetStatus("Logging in...");
			}
		}

		private void HandlePlayFabLoggedIn()
		{
			if (!_flowFinished && !_banCheckStarted)
			{
				_banCheckStarted = true;
				if (showAuthDiagnostic && !string.IsNullOrEmpty(LaAuthLogin.LastIdentityReport))
				{
					StartCoroutine(ShowAuthDiagnosticThenCheckBans());
					return;
				}
				SetStatus("Checking account status...");
				CheckBanStatus();
			}
		}

		private IEnumerator ShowAuthDiagnosticThenCheckBans()
		{
			bool accountChanged = LaAuthLogin.AccountChanged;
			SetStatus(accountChanged ? ("<color=#FF6B6B>ACCOUNT CHANGED SINCE LAST LAUNCH</color>\n<size=60%>" + LaAuthLogin.LastIdentityReport + "</size>\n<size=55%>Signed in as a different account — name and wardrobe belong to it.</size>") : ("Checking account status...\n<size=55%>" + LaAuthLogin.LastIdentityReport + "</size>"));
			yield return new WaitForSeconds(accountChanged ? authDiagnosticErrorSeconds : authDiagnosticSeconds);
			CheckBanStatus();
		}

		private void HandleBannedAtLogin(string reason, string expiresIso, bool permanent)
		{
			if (!_flowFinished)
			{
				_flowFinished = true;
				_isBanned = true;
				_banPermanent = permanent;
				_banExpiresUtc = ParseExpires(expiresIso);
				_banUsername = PlayerPrefs.GetString("Username", "");
				ShowBannedUI(reason);
			}
		}

		private void CheckBanStatus()
		{
			if (Qauth.Status != QauthStatus.Banned)
			{
				ProceedToMain();
				return;
			}
			_isBanned = true;
			_flowFinished = true;
			_banPermanent = Qauth.BanUntil <= 0;
			_banExpiresUtc = (_banPermanent ? ((DateTime?)null) : new DateTime?(DateTimeOffset.FromUnixTimeMilliseconds(Qauth.BanUntil).UtcDateTime));
			_banUsername = (string.IsNullOrEmpty(Qauth.AccountName) ? PlayerPrefs.GetString("Username", "") : Qauth.AccountName);
			ShowBannedUI(Qauth.BanReason);
		}

		private static DateTime? ParseExpires(string iso)
		{
			if (string.IsNullOrEmpty(iso))
			{
				return null;
			}
			if (DateTime.TryParse(iso, null, DateTimeStyles.AdjustToUniversal | DateTimeStyles.AssumeUniversal, out var result))
			{
				return result;
			}
			return null;
		}

		private void HandleUpdateAvailable(int daysBehind, int maxAllowed)
		{
			if (!_updateNoticeShown && !_updateRequired)
			{
				_updateNoticeShown = true;
				Debug.Log(string.Format("[LoadingScreenAuth] Headset is {0} day(s) behind on security patches (limit {1}) — advisory only.", daysBehind, maxAllowed));
				if (!string.IsNullOrEmpty(updateAvailableMessage))
				{
					StartCoroutine(ShowUpdateNotice(string.Format(updateAvailableMessage, daysBehind, maxAllowed)));
				}
			}
		}

		private IEnumerator ShowUpdateNotice(string message)
		{
			SetStatus(message);
			yield return new WaitForSeconds(Mathf.Max(0f, updateNoticeSeconds));
		}

		private void HandleUpdateRequired(string requiredVersion)
		{
			if (!_updateRequired)
			{
				_updateRequired = true;
				_flowFinished = true;
				if ((bool)loadingObject)
				{
					loadingObject.SetActive(false);
				}
				SetStatus((!string.IsNullOrEmpty(updateRequiredMessage)) ? string.Format(updateRequiredMessage, requiredVersion) : string.Format("This version of the game is out of date (version {0} required).", requiredVersion));
				Debug.LogError("[LoadingScreenAuth] Blocked: this build (" + Application.version + ") is older than the minimum version " + requiredVersion + ".");
			}
		}

		private void ShowBannedUI(string reason)
		{
			_banReason = (string.IsNullOrEmpty(reason) ? "No reason provided" : reason);
			if ((bool)loadingObject)
			{
				loadingObject.SetActive(false);
			}
			if ((bool)bannedObject)
			{
				bannedObject.SetActive(true);
			}
			if ((bool)banReasonText)
			{
				string text = (string.IsNullOrEmpty(_banUsername) ? "You have been banned." : (_banUsername + ", you have been banned."));
				banReasonText.text = (string.IsNullOrEmpty(appealMessage) ? (text + "\nReason: " + _banReason) : (text + "\nReason: " + _banReason + "\n\n" + appealMessage));
			}
			UpdateBanCountdown();
		}

		private void Update()
		{
			if (_isBanned)
			{
				UpdateBanCountdown();
			}
			else
			{
				if (_updateRequired || _flowFinished)
				{
					return;
				}
				OculusAuthManager instance = OculusAuthManager.Instance;
				if (instance != null && instance.IsEntitled && !_entitlementHandled)
				{
					HandleEntitlementVerified();
				}
				LoadingPlayFabManager instance2 = LoadingPlayFabManager.Instance;
				if (instance2 != null)
				{
					if (instance2.UpdateAvailable && !_updateNoticeShown && !_updateRequired)
					{
						HandleUpdateAvailable(instance2.UpdateAvailableDays, instance2.UpdateAvailableMinDays);
					}
					if (instance2.UpdateRequired && !_updateRequired)
					{
						HandleUpdateRequired(instance2.UpdateRequiredVersion);
					}
					else if (instance2.BannedAtLogin && !_isBanned)
					{
						HandleBannedAtLogin(instance2.BannedAtLoginReason, instance2.BannedAtLoginExpiresIso, instance2.BannedAtLoginPermanent);
					}
					else if (instance2.IsLoggedIn && !_banCheckStarted)
					{
						HandlePlayFabLoggedIn();
					}
				}
			}
		}

		private void UpdateBanCountdown()
		{
			string text;
			if (_banPermanent)
			{
				text = "Never — this ban is permanent.";
			}
			else if (!_banExpiresUtc.HasValue)
			{
				text = "Unknown — contact support";
			}
			else
			{
				TimeSpan t = _banExpiresUtc.Value - DateTime.UtcNow;
				if (t <= TimeSpan.Zero)
				{
					text = "Ban expired — please relaunch the app.";
				}
				else
				{
					long num = (long)t.TotalSeconds;
					if (num == _lastCountdownSeconds)
					{
						return;
					}
					_lastCountdownSeconds = num;
					text = FormatRemaining(t);
				}
			}
			if ((object)text != _banRemaining)
			{
				_banRemaining = text;
				if (banTimeRemainingText != null)
				{
					banTimeRemainingText.text = text;
				}
			}
		}

		private static string FormatRemaining(TimeSpan t)
		{
			int num = (int)t.TotalHours;
			int minutes = t.Minutes;
			int seconds = t.Seconds;
			if (num > 0)
			{
				return string.Format("{0}h {1}m {2}s", num, minutes, seconds);
			}
			if (minutes > 0)
			{
				return string.Format("{0}m {1}s", minutes, seconds);
			}
			return string.Format("{0}s", seconds);
		}

		private void ProceedToMain()
		{
			if (!_flowFinished)
			{
				_flowFinished = true;
				_cleared = true;
				StartCoroutine(LoadMainSceneRoutine());
			}
		}

		private IEnumerator LoadMainSceneRoutine()
		{
			SetStatus("Loading world...");
			yield return new WaitForSeconds(preLoadDelay);
			AsyncOperation op = SceneManager.LoadSceneAsync(mainSceneName);
			if (op == null)
			{
				Debug.LogError("[LoadingScreenAuth] Scene '" + mainSceneName + "' is missing from Build Settings. Falling back to a blocking load — expect a frozen eye during the transition.");
				SceneManager.LoadScene(mainSceneName);
				yield break;
			}
			op.allowSceneActivation = false;
			Application.backgroundLoadingPriority = ThreadPriority.Low;
			int shownPercent = -1;
			while (op.progress < 0.9f)
			{
				float num = op.progress / 0.9f;
				WorldProgress = num;
				int num2 = Mathf.RoundToInt(num * 100f);
				if (num2 != shownPercent)
				{
					shownPercent = num2;
					SetStatus(string.Format("Loading world... {0}%", num2));
				}
				yield return null;
			}
			WorldProgress = 1f;
			WorldReady = true;
			SetStatus("Loading world... 100%");
			yield return null;
			yield return null;
			while (HoldActivation)
			{
				yield return null;
			}
			op.allowSceneActivation = true;
		}

		private void SetStatus(string msg)
		{
			if ((bool)statusText)
			{
				statusText.text = msg;
			}
		}
	}
}
