using System;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using UnityEngine.Networking;

namespace QauthSdk
{
	// One answer from Qauth: the HTTP status and the JSON body (empty object when there was none).
	public sealed class QauthResponse
	{
		public long Status;
		public JObject Json;
		public string NetworkError;

		public bool Ok => NetworkError == null && Status >= 200 && Status < 300;

		// the server's "error" field, or the network problem
		public string Error => NetworkError ?? Json?["error"]?.Value<string>() ?? (Ok ? null : "HTTP " + Status);

		public T Get<T>(string key, T fallback = default)
		{
			JToken t = Json?[key];
			if (t == null || t.Type == JTokenType.Null) return fallback;
			try
			{
				return t.ToObject<T>();
			}
			catch
			{
				return fallback;
			}
		}
	}

	// UnityWebRequest -> Task. Runs on the main thread (UnityWebRequest needs it); continuations come back on Unity's
	// synchronization context.
	internal static class QauthHttp
	{
		public static Task<QauthResponse> Post(string url, object body, int timeoutSeconds)
		{
			UnityWebRequest req = new UnityWebRequest(url, "POST");
			req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(body is string s ? s : JsonConvert.SerializeObject(body ?? new { })));
			req.downloadHandler = new DownloadHandlerBuffer();
			req.SetRequestHeader("Content-Type", "application/json");
			return Send(req, timeoutSeconds);
		}

		public static Task<QauthResponse> Get(string url, int timeoutSeconds)
		{
			return Send(UnityWebRequest.Get(url), timeoutSeconds);
		}

		private static Task<QauthResponse> Send(UnityWebRequest req, int timeoutSeconds)
		{
			TaskCompletionSource<QauthResponse> tcs = new TaskCompletionSource<QauthResponse>();
			req.timeout = Math.Max(1, timeoutSeconds);
			UnityWebRequestAsyncOperation op;
			try
			{
				op = req.SendWebRequest();
			}
			catch (Exception e)
			{
				req.Dispose();
				tcs.SetResult(new QauthResponse { Status = 0, Json = new JObject(), NetworkError = e.Message });
				return tcs.Task;
			}
			op.completed += _ =>
			{
				QauthResponse r = new QauthResponse { Status = req.responseCode, Json = new JObject() };
				string text = req.downloadHandler?.text;
				if (!string.IsNullOrEmpty(text))
				{
					try
					{
						r.Json = JObject.Parse(text);
					}
					catch
					{
					}
				}
				if (req.result == UnityWebRequest.Result.ConnectionError || req.result == UnityWebRequest.Result.DataProcessingError)
				{
					r.NetworkError = req.error ?? "network error";
				}
				req.Dispose();
				tcs.SetResult(r);
			};
			return tcs.Task;
		}
	}
}
