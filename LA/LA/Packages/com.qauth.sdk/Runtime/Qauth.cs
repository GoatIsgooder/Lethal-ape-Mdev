using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

namespace QauthSdk
{
	public enum QauthStatus
	{
		NotStarted,
		LoggingIn,
		LoggedIn,
		NoPlatform, // editor / PC without a Meta login: the game runs without an account
		NotEntitled, // Meta says this account doesn't own the game
		Banned,
		AttestationFailed, // this copy of the game or this headset didn't pass Meta's check
		UpdateRequired, // this build is older than the server's minimum
		Failed, // network / server trouble; try LoginAsync again later
	}

	// The Qauth client. Everything is static: Qauth.LoginAsync(), Qauth.Saves.PullAsync(), Qauth.Wallet..., etc.
	//
	// Logging in (same protocol as the backend's /v1/auth/meta):
	//   1. Meta: start the Platform SDK, check the entitlement, read the user
	//   2. POST /v1/auth/challenge -> one-time nonce; Meta signs an attestation token bound to it
	//   3. POST /v1/auth/meta {metaUserId, nonce (user proof), name, integrityNonce, integrityToken, version}
	//      -> {accountId, name, token, newlyCreated, photonAuth}
	// Every other call sends the token. Login runs again every recheckMinutes so the attestation stays fresh.
	public static class Qauth
	{
		public static QauthSettings Settings { get; private set; }

		// the Meta side; Qauth.Meta sets this by itself when the Meta XR Platform SDK is in the project
		public static IQauthPlatform Platform { get; set; }

		public static QauthStatus Status { get; private set; } = QauthStatus.NotStarted;

		public static bool IsLoggedIn => !string.IsNullOrEmpty(Token);

		public static string Token { get; private set; }

		public static string AccountId { get; private set; }

		public static string AccountName { get; private set; }

		public static bool NewlyCreated { get; private set; }

		public static string MetaUserId { get; private set; }

		public static string MetaUsername { get; private set; }

		// "custom" = Photon asks Qauth before letting this player in (send the token); anything else = Meta (Oculus) auth
		public static string PhotonAuthMode { get; private set; }

		public static string BanReason { get; private set; } = "";

		public static long BanUntil { get; private set; } // unix ms, 0 = permanent

		public static string RequiredVersion { get; private set; } = "";

		public static string LastError { get; private set; }

		// the game version sent with the login (the server can refuse old builds); defaults to Application.version
		public static string GameVersion { get; set; }

		public static event Action OnLoggedIn;

		public static event Action<QauthStatus> OnStatusChanged;

		public static readonly QauthSaves Saves = new QauthSaves();
		public static readonly QauthWallet Wallet = new QauthWallet();
		public static readonly QauthLeaderboards Leaderboards = new QauthLeaderboards();
		public static readonly QauthGrants Grants = new QauthGrants();
		public static readonly QauthEvents Events = new QauthEvents();
		public static readonly QauthAccount Account = new QauthAccount();
		public static readonly QauthTrades Trades = new QauthTrades();
		public static readonly QauthAddons Addons = new QauthAddons();
		public static readonly QauthCloudScript CloudScript = new QauthCloudScript();
		public static readonly QauthSocial Social = new QauthSocial();
		public static readonly QauthSeason Season = new QauthSeason();

		private static Task<QauthStatus> loginTask;

		// use these settings instead of Resources/QauthSettings
		public static void Configure(QauthSettings settings)
		{
			Settings = settings != null ? settings : throw new ArgumentNullException(nameof(settings));
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			if (Settings == null) Settings = Resources.Load<QauthSettings>(QauthSettings.ResourceName);
			if (Settings == null)
			{
				Debug.LogWarning("[Qauth] no QauthSettings in a Resources folder (Tools > Qauth > Settings); call Qauth.Configure() before logging in");
				return;
			}
			QauthRunner.Ensure();
			if (Settings.loginOnStart) _ = LoginAsync();
		}

		// log in (or return the login already running); safe to call many times
		public static Task<QauthStatus> LoginAsync()
		{
			if (loginTask == null || loginTask.IsCompleted && Status != QauthStatus.LoggedIn) loginTask = Login(false);
			return loginTask;
		}

		// wait for the current login attempt (up to the timeout)
		public static async Task WaitReady(float timeoutSeconds = 60f)
		{
			Task t = loginTask;
			if (t != null) await Task.WhenAny(t, Task.Delay(TimeSpan.FromSeconds(timeoutSeconds)));
		}

		public static void Logout()
		{
			Token = null;
			AccountId = null;
			AccountName = null;
			SetStatus(QauthStatus.NotStarted);
		}

		// Meta's checks again (attestation and user proof), keeping the current login if Meta doesn't answer
		internal static Task<QauthStatus> RecheckAsync() => Login(true);

		private static async Task<QauthStatus> Login(bool recheck)
		{
			RequireSettings();
			if (!recheck) SetStatus(QauthStatus.LoggingIn);
			if (Platform == null)
			{
				LastError = "no Meta platform (add the Meta XR Platform SDK, or set Qauth.Platform)";
				Debug.Log("[Qauth] " + LastError + "; playing without an account");
				return SetStatus(QauthStatus.NoPlatform);
			}
			try
			{
				if (!recheck || string.IsNullOrEmpty(MetaUserId))
				{
					QauthIdentity id = await Platform.InitializeAsync(Settings.metaAppId) ?? new QauthIdentity { Error = "no answer from the platform" };
					bool quest = !Application.isEditor && Application.platform == RuntimePlatform.Android;
					if (!id.Initialized)
					{
						LastError = id.Error ?? "Meta SDK didn't start";
						// on a Quest build Meta counts a failed start as a failed entitlement check; elsewhere just no account
						if (!quest) return SetStatus(QauthStatus.NoPlatform);
						QuitNotEntitled();
						return SetStatus(QauthStatus.NotEntitled);
					}
					if (!id.Entitled)
					{
						LastError = id.Error ?? "Meta says this account doesn't own the game";
						QuitNotEntitled();
						return SetStatus(QauthStatus.NotEntitled);
					}
					if (string.IsNullOrEmpty(id.MetaUserId)) return Fail(id.Error ?? "couldn't read the Meta user");
					MetaUserId = id.MetaUserId;
					MetaUsername = id.Username;
				}
				string proof = await Platform.GetUserProofAsync();
				if (string.IsNullOrEmpty(proof)) return recheck ? Status : Fail("couldn't get a Meta user proof");
				(string nonce, string integrity, string integrityError) = await Attest();
				if (recheck && string.IsNullOrEmpty(integrity)) return Status; // Meta didn't answer: keep the login, try later
				return await SendLogin(proof, nonce, integrity, integrityError);
			}
			catch (Exception e)
			{
				return recheck ? Status : Fail("login crashed: " + e.Message);
			}
		}

		// one-time nonce from the server, then Meta's attestation token for it; two tries, each with a timeout
		private static async Task<(string, string, string)> Attest()
		{
			string error = null;
			for (int attempt = 0; attempt < 2; attempt++)
			{
				QauthResponse c = await Post("/v1/auth/challenge", new { });
				string nonce = c.Get<string>("nonce");
				if (string.IsNullOrEmpty(nonce))
				{
					error = "no challenge from the server (" + c.Error + ")";
					continue;
				}
				try
				{
					Task<string> t = Platform.GetIntegrityTokenAsync(nonce);
					if (await Task.WhenAny(t, Task.Delay(TimeSpan.FromSeconds(Settings.attestationTimeoutSeconds))) != t)
					{
						error = "attestation timed out";
						continue;
					}
					if (!string.IsNullOrEmpty(t.Result)) return (nonce, t.Result, null);
					error = "empty attestation token";
				}
				catch (Exception e)
				{
					error = e.Message;
				}
			}
			Debug.LogWarning("[Qauth] attestation: " + error);
			return (null, null, error);
		}

		private static async Task<QauthStatus> SendLogin(string proof, string nonce, string integrity, string integrityError)
		{
			QauthResponse r = await Post("/v1/auth/meta", new Dictionary<string, object>
			{
				["metaUserId"] = MetaUserId,
				["nonce"] = proof,
				["name"] = MetaUsername,
				["integrityNonce"] = nonce,
				["integrityToken"] = integrity,
				["integrityError"] = integrityError,
				["version"] = string.IsNullOrEmpty(GameVersion) ? Application.version : GameVersion,
				["editorKey"] = QauthEditorKey.Get(),
			});
			string error = r.Get<string>("error");
			if (r.Status == 426 && error == "UPDATE_REQUIRED")
			{
				RequiredVersion = r.Get("min", "");
				LastError = "this version of the game is too old";
				return SetStatus(QauthStatus.UpdateRequired);
			}
			if (r.Status == 403 && error == "ATTESTATION_FAILED")
			{
				LastError = "this copy of the game or this headset didn't pass Meta's check";
				Token = null;
				return SetStatus(QauthStatus.AttestationFailed);
			}
			if (r.Status == 403 && error == "ACCOUNT_BANNED")
			{
				BanReason = r.Get("reason", "");
				BanUntil = r.Get<long>("until");
				LastError = "this account is banned";
				Token = null;
				return SetStatus(QauthStatus.Banned);
			}
			string token = r.Get<string>("token");
			if (!r.Ok || string.IsNullOrEmpty(token)) return Fail("server said " + r.Status + " " + r.Error);
			bool first = !IsLoggedIn;
			Token = token;
			AccountId = r.Get<string>("accountId");
			AccountName = r.Get<string>("name");
			NewlyCreated = r.Get<bool>("newlyCreated");
			PhotonAuthMode = r.Get<string>("photonAuth");
			LastError = null;
			SetStatus(QauthStatus.LoggedIn);
			if (first)
			{
				Debug.Log("[Qauth] " + (NewlyCreated ? "created account" : "logged in") + " as " + AccountName);
				OnLoggedIn?.Invoke();
			}
			return Status;
		}

		private static void QuitNotEntitled()
		{
			if (Application.isEditor || !Settings.quitIfNotEntitled) return;
			Debug.LogError("[Qauth] entitlement check failed, quitting");
			Application.Quit();
		}

		private static QauthStatus Fail(string why)
		{
			LastError = why;
			Debug.LogWarning("[Qauth] " + why);
			return SetStatus(QauthStatus.Failed);
		}

		private static QauthStatus SetStatus(QauthStatus s)
		{
			if (Status != s)
			{
				Status = s;
				OnStatusChanged?.Invoke(s);
			}
			return s;
		}

		private static void RequireSettings()
		{
			if (Settings == null) Settings = Resources.Load<QauthSettings>(QauthSettings.ResourceName);
			if (Settings == null) throw new InvalidOperationException("Qauth isn't configured: add Resources/QauthSettings or call Qauth.Configure()");
		}

		// ---- raw API access for routes the SDK doesn't wrap: POST {token, ...body} to /g/<game><path>
		public static Task<QauthResponse> Post(string path, object body)
		{
			RequireSettings();
			return QauthHttp.Post(Settings.GameBaseUrl + path, body, Settings.requestTimeoutSeconds);
		}

		public static Task<QauthResponse> Get(string path)
		{
			RequireSettings();
			return QauthHttp.Get(Settings.GameBaseUrl + path, Settings.requestTimeoutSeconds);
		}

		// the server's clock (UTC), e.g. for daily resets and season dates; no login needed
		public static async Task<DateTime> ServerTimeAsync()
		{
			QauthResponse r = await Get("/v1/time");
			if (!r.Ok) throw new QauthException("server time", r);
			return DateTimeOffset.FromUnixTimeMilliseconds(r.Get<long>("now")).UtcDateTime;
		}

		// GET on the Qauth API itself, not a game (e.g. /crossplay/<group>)
		public static Task<QauthResponse> GetPlatform(string path)
		{
			RequireSettings();
			return QauthHttp.Get(Settings.apiUrl.TrimEnd('/') + path, Settings.requestTimeoutSeconds);
		}

		// POST with the login token added; fails fast when not logged in. A 401 drops the token and logs in again.
		public static async Task<QauthResponse> PostAuthed(string path, IDictionary<string, object> body = null)
		{
			if (!IsLoggedIn) return new QauthResponse { Status = 401, Json = new Newtonsoft.Json.Linq.JObject { ["error"] = "not logged in" } };
			Dictionary<string, object> b = body != null ? new Dictionary<string, object>(body) : new Dictionary<string, object>();
			b["token"] = Token;
			QauthResponse r = await Post(path, b);
			if (r.Status == 401 && r.Get<string>("error") == "login expired")
			{
				Token = null;
				_ = LoginAsync();
			}
			return r;
		}
	}

	// Editor logins: Meta's attestation can't pass in the editor, so the dashboard can make a personal editor key (kept
	// in this PC's EditorPrefs, never in a build).
	public static class QauthEditorKey
	{
		public const string Pref = "Qauth.EditorKey";

		public static string Get()
		{
#if UNITY_EDITOR
			string key = UnityEditor.EditorPrefs.GetString(Pref, "").Trim();
			return key.Length == 32 ? key : null;
#else
			return null;
#endif
		}
	}

	// keeps the background jobs running: attestation recheck and staff-gift polling
	internal sealed class QauthRunner : MonoBehaviour
	{
		private static QauthRunner instance;
		private float nextRecheck = -1f;
		private float nextGrants;
		private float nextTrade;
		private bool busy;

		public static void Ensure()
		{
			if (instance != null) return;
			GameObject go = new GameObject("[Qauth]");
			DontDestroyOnLoad(go);
			instance = go.AddComponent<QauthRunner>();
		}

		private void Update()
		{
			QauthSettings s = Qauth.Settings;
			if (s == null || !Qauth.IsLoggedIn || busy) return;
			float now = Time.realtimeSinceStartup;
			if (s.recheckMinutes > 0f)
			{
				if (nextRecheck < 0f) nextRecheck = now + s.recheckMinutes * 60f;
				else if (now >= nextRecheck)
				{
					nextRecheck = now + s.recheckMinutes * 60f;
					Run(Qauth.RecheckAsync());
					return;
				}
			}
			if (s.grantsPollSeconds > 0f && now >= nextGrants)
			{
				nextGrants = now + s.grantsPollSeconds;
				Run(Qauth.Grants.PollAsync());
				return;
			}
			// trades: quick polls while one is live (both screens stay in step), slow ones otherwise (incoming requests)
			float tradeEvery = Qauth.Trades.Current != null ? s.tradePollSeconds : s.tradeIdlePollSeconds;
			if (tradeEvery > 0f && now >= nextTrade)
			{
				nextTrade = now + tradeEvery;
				Run(Qauth.Trades.PollAsync());
			}
		}

		private async void Run(Task t)
		{
			busy = true;
			try
			{
				await t;
			}
			catch (Exception e)
			{
				Debug.LogWarning("[Qauth] " + e.Message);
			}
			finally
			{
				busy = false;
			}
		}
	}
}
