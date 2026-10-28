using System;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Networking;

namespace LethalApeR.Networking
{
	public static class LarApi
	{
		[Serializable]
		public class DenialInfo
		{
			public string error;

			public string code;

			public int days;

			public int minDays;
		}

		[Serializable]
		public class HostRequest
		{
			public string build;
		}

		[Serializable]
		public class HostResult
		{
			public bool ok;

			public bool degraded;

			public string host;

			public string appId;

			public string voiceAppId;

			public string appVersion;
		}

		[Serializable]
		public class IssueRequest
		{
			public string oculusUserToken;

			public string userNonce;

			public string userProof;

			public string challenge;

			public string userId;
		}

		[Serializable]
		public class SecurityUpdateInfo
		{
			public int days;

			public int minDays;
		}

		[Serializable]
		public class IssueResult
		{
			public string id_token;

			public int expires_in;

			public SecurityUpdateInfo securityUpdate;
		}

		[Serializable]
		public class NonceRequest
		{
			public string userId;
		}

		[Serializable]
		public class ReportRequest
		{
			public string sessionTicket;

			public string accused;

			public string offense;

			public string room;

			public string detail;
		}

		[Serializable]
		public class ReportResult
		{
			public bool ok;

			public bool counted;

			public int reporters;
		}

		[Serializable]
		public class NonceResult
		{
			public string nonce;

			public int expires_in;
		}

		internal const string URL = "https://la-auth.monkedevltd.workers.dev/";

		public const string V2Nonce = "v2/nonce";

		public const string V2Issue = "v2/issue";

		public const string V2Report = "v2/report";

		public const string V1Issue = "issue";

		public const int UpdateRequiredCode = 426;

		public const string CrossplayUrl = "https://crossplay.sorebones.net/";

		public const string HostEndpoint = "host";

		private const int RequestTimeoutSeconds = 10;

		public static DenialInfo ParseDenial(string error)
		{
			if (string.IsNullOrEmpty(error))
			{
				return null;
			}
			int num = error.IndexOf('{');
			if (num < 0)
			{
				return null;
			}
			try
			{
				DenialInfo denialInfo = JsonUtility.FromJson<DenialInfo>(error.Substring(num));
				return (denialInfo != null && !string.IsNullOrEmpty(denialInfo.code)) ? denialInfo : null;
			}
			catch (Exception)
			{
				return null;
			}
		}

		public static async Task<HostResult> GetApeGamesHost(string build)
		{
			string payload = JsonUtility.ToJson(new HostRequest
			{
				build = build
			});
			HostResult result = null;
			string text = await TryPost("https://crossplay.sorebones.net/host", payload, delegate(HostResult r)
			{
				result = r;
			});
			if (text != null)
			{
				Debug.Log("<b>[LarApi]</b> placement unavailable, using the configured host: " + text);
				return null;
			}
			if (result == null || !result.ok || string.IsNullOrEmpty(result.appId))
			{
				return null;
			}
			return result;
		}

		public static async Task SendReport(string sessionTicket, string accused, string offense, string room, string detail, Action<string> fail = null)
		{
			string text = await TryPost<ReportResult>("https://la-auth.monkedevltd.workers.dev/v2/report", JsonUtility.ToJson(new ReportRequest
			{
				sessionTicket = sessionTicket,
				accused = accused,
				offense = offense,
				room = room,
				detail = detail
			}), null);
			if (text != null)
			{
				fail?.Invoke(text);
			}
		}

		public static async Task GetChallenge(string userId, Action<string> ok, Action<string> fail)
		{
			string payload = JsonUtility.ToJson(new NonceRequest
			{
				userId = userId
			});
			NonceResult result = null;
			string text = await TryPost("https://la-auth.monkedevltd.workers.dev/v2/nonce", payload, delegate(NonceResult r)
			{
				result = r;
			});
			if (text != null)
			{
				fail?.Invoke(text);
			}
			else if (result == null || string.IsNullOrEmpty(result.nonce))
			{
				fail?.Invoke("Server returned an empty challenge");
			}
			else
			{
				ok?.Invoke(result.nonce);
			}
		}

		public static async Task GetIdToken(string endpoint, string oculusUserToken, string userProof, string challenge, string userId, Action<IssueResult> ok, Action<string> fail, Action<string> onWarning = null)
		{
			await TryPost("https://la-auth.monkedevltd.workers.dev/" + endpoint, JsonUtility.ToJson(new IssueRequest
			{
				oculusUserToken = oculusUserToken,
				userNonce = userProof,
				userProof = userProof,
				challenge = challenge,
				userId = userId
			}), ok);
		}

		private static async Task<string> TryPost<T>(string url, string payload, Action<T> ok) where T : class
		{
			for (int attempt = 0; attempt < 3; attempt++)
			{
				using UnityWebRequest req = new UnityWebRequest(url, "POST");
				req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(payload));
				req.downloadHandler = new DownloadHandlerBuffer();
				req.SetRequestHeader("Content-Type", "application/json");
				req.timeout = 10;
				UnityWebRequestAsyncOperation op = req.SendWebRequest();
				while (!op.isDone)
				{
					await Task.Yield();
				}
				if (req.result == UnityWebRequest.Result.Success)
				{
					try
					{
						T val = JsonUtility.FromJson<T>(req.downloadHandler.text);
						if (val == null)
						{
							return "Empty response from " + url;
						}
						ok?.Invoke(val);
						return null;
					}
					catch (Exception ex)
					{
						return "Malformed response from " + url + ": " + ex.Message;
					}
				}
				bool num = req.responseCode == 0L || req.responseCode >= 500 || req.responseCode == 429;
				Debug.Log(string.Format("<b>[LarApi]</b> {0} attempt {1}: HTTP {2} {3} body={4}", url, attempt + 1, req.responseCode, req.error, req.downloadHandler?.text));
				if (!num)
				{
					return string.Format("{0} {1} {2}", req.responseCode, req.error, req.downloadHandler.text);
				}
				if (attempt < 2)
				{
					await Task.Delay(1000 * (attempt + 1));
				}
			}
			return "Failed to reach server after retries";
		}
	}
}
