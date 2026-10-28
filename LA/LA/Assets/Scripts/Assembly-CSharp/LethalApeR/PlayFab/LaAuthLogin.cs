using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	public static class LaAuthLogin
	{
		public class Result
		{
			public bool Ok;

			public string PlayFabId;

			public string SessionTicket;

			public QauthStatus Status;

			public bool NewAccount;

			public string Error;

			public string Failure;

			public string RequiredVersion;

			public string BanReason;

			public long BanUntil;
		}

		private static bool _inFlight;

		private static Result _succeeded;

		private static readonly List<Action<Result>> _waiting = new List<Action<Result>>();

		private const string LastAccountIdPref = "QauthAccountId";

		private const string LegacyPlayFabIdPref = "PlayFabId";

		public const string BuildTag = "LA";

		public static bool HasSession => _succeeded != null;

		public static Result Session => _succeeded;

		public static string LastIdentityReport { get; private set; } = "";

		public static bool AccountChanged { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_inFlight = false;
			_succeeded = null;
			_waiting.Clear();
			LastIdentityReport = "";
			AccountChanged = false;
		}

		public static Task Run(Action<Result> onDone)
		{
			if (_succeeded != null)
			{
				onDone?.Invoke(_succeeded);
				return Task.CompletedTask;
			}
			if (_inFlight)
			{
				if (onDone != null)
				{
					_waiting.Add(onDone);
				}
				return Task.CompletedTask;
			}
			_inFlight = true;
			return RunInternal(delegate(Result r)
			{
				Finish(r, onDone);
			});
		}

		private static void Finish(Result result, Action<Result> onDone)
		{
			_inFlight = false;
			if (result.Ok)
			{
				_succeeded = result;
			}
			onDone?.Invoke(result);
			if (_waiting.Count == 0)
			{
				return;
			}
			Action<Result>[] waiters = _waiting.ToArray();
			_waiting.Clear();
			foreach (Action<Result> waiter in waiters)
			{
				waiter(result);
			}
		}

		private static async Task RunInternal(Action<Result> onDone)
		{
			Result result = new Result();
			QauthStatus status = Qauth.Status;
			try
			{
				if (status == QauthStatus.NotStarted || status == QauthStatus.LoggingIn || status == QauthStatus.Failed)
				{
					status = await Qauth.LoginAsync();
				}
			}
			catch (Exception ex)
			{
				Fail(result, "Qauth login threw: " + ex.Message, onDone);
				return;
			}
			result.Status = status;
			switch (status)
			{
			case QauthStatus.LoggedIn:
				Succeed(result, onDone);
				break;
			case QauthStatus.Banned:
				result.BanReason = Qauth.BanReason;
				result.BanUntil = Qauth.BanUntil;
				FailWith(result, "ACCOUNT_BANNED", "account banned", onDone);
				break;
			case QauthStatus.UpdateRequired:
				result.RequiredVersion = Qauth.RequiredVersion;
				FailWith(result, "UPDATE_REQUIRED", "this build is older than the server's minimum (" + Qauth.RequiredVersion + ")", onDone);
				break;
			default:
				FailWith(result, Qauth.LastError ?? status.ToString(), "Qauth login ended in " + status, onDone);
				break;
			}
		}

		private static void RecordLegacyAccount(string previousPlayFabId)
		{
			_ = RecordLegacyAccountAsync(previousPlayFabId);
		}

		private static async Task RecordLegacyAccountAsync(string previousPlayFabId)
		{
			QauthPushResult push;
			try
			{
				push = await Qauth.Saves.PushAsync("LegacyPlayFabId", previousPlayFabId, QauthSaves.Now);
			}
			catch (Exception ex)
			{
				Debug.LogError("[LaAuthLogin] Could not record the legacy account id (recovery will need the display name instead): " + ex.Message);
				return;
			}
			if (push.Ok)
			{
				AuthLog.Device("[LaAuthLogin] Recorded legacy account " + AuthLog.Fingerprint(previousPlayFabId) + " on the replacement for recovery.");
			}
			else
			{
				Debug.LogError("[LaAuthLogin] Could not record the legacy account id (recovery will need the display name instead): " + push.Error);
			}
		}

		private static void Succeed(Result result, Action<Result> onDone)
		{
			result.Ok = true;
			result.PlayFabId = Qauth.AccountId;
			result.SessionTicket = Qauth.Token;
			result.NewAccount = Qauth.NewlyCreated;
			string legacy = PlayerPrefs.GetString(LegacyPlayFabIdPref, "");
			if (result.NewAccount && !string.IsNullOrEmpty(legacy) && legacy != result.PlayFabId)
			{
				AuthLog.DeviceError("[LaAuthLogin] Previous account " + AuthLog.Fingerprint(legacy) + " has no Qauth account yet — created one and recording the old id on it for recovery.");
				RecordLegacyAccount(legacy);
			}
			ReportIdentity(result);
			PlayerPrefs.SetString(LastAccountIdPref, result.PlayFabId ?? "");
			onDone?.Invoke(result);
		}

		private static void ReportIdentity(Result result)
		{
			string previous = PlayerPrefs.GetString(LastAccountIdPref, "");
			bool returningInstall = !string.IsNullOrEmpty(previous);
			bool sameAccount = !returningInstall || previous == result.PlayFabId;
			string via = (result.NewAccount ? "created-new" : "existing");
			AccountChanged = !sameAccount || (result.NewAccount && returningInstall);
			LastIdentityReport = string.Format("acct {0} | {1}", AuthLog.Fingerprint(result.PlayFabId), via) + (returningInstall ? (" | prev " + AuthLog.Fingerprint(previous)) : " | first run");
			string line = "[LaAuthLogin] Account " + AuthLog.Fingerprint(result.PlayFabId) + " via " + via + " " + string.Format("(newAccount={0}, returningInstall={1})", result.NewAccount, returningInstall);
			if (AccountChanged)
			{
				AuthLog.DeviceError(line + " ** ACCOUNT CHANGED ** last launch resolved to " + AuthLog.Fingerprint(previous) + ". This is the failure behind a reset display name and a missing wardrobe: the session is valid, it is simply the wrong account. Inventory and name are correct FOR THIS ACCOUNT.");
			}
			else
			{
				AuthLog.Device(line);
			}
		}

		private static void Fail(Result result, string why, Action<Result> onDone)
		{
			result.Failure = why;
			Debug.LogError("[LaAuthLogin] " + why);
			onDone?.Invoke(result);
		}

		private static void FailWith(Result result, string error, string why, Action<Result> onDone)
		{
			result.Error = error;
			result.Failure = why;
			Debug.LogError("[LaAuthLogin] " + why + ": " + error);
			onDone?.Invoke(result);
		}
	}
}
