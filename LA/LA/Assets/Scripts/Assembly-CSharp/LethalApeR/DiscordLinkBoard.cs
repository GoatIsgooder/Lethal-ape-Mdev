using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using QauthSdk;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;

namespace LethalApeR
{
	public class DiscordLinkBoard : MonoBehaviour
	{
		[Tooltip("Your deployed worker base URL, no trailing slash.")]
		public string workerBaseUrl = "https://lethal-ape-bot.YOUR-SUBDOMAIN.workers.dev";

		[Tooltip("The TextMeshPro label that displays the code.")]
		public TMP_Text codeLabel;

		[Tooltip("Label format. {0} is replaced with the code (or a short status word).")]
		[TextArea]
		public string labelFormat = "<size=100%>Link Code:   <size=120%><b><color=yellow>{0}</color></b>";

		[Tooltip("Re-fetch this many seconds before the code expires (0 = never).")]
		public float autoRefreshSeconds;

		private bool _fetching;

		private void OnEnable()
		{
			StartCoroutine(WaitForLoginThenFetch());
		}

		public void Refresh()
		{
			if (!_fetching)
			{
				StartCoroutine(FetchCode());
			}
		}

		private IEnumerator WaitForLoginThenFetch()
		{
			SetCode("...");
			float waited = 0f;
			while (string.IsNullOrEmpty(GetSessionTicket()) && waited < 60f)
			{
				waited += 0.5f;
				yield return new WaitForSeconds(0.5f);
			}
			if (!string.IsNullOrEmpty(GetSessionTicket()))
			{
				yield return FetchCode();
			}
			else
			{
				SetCode("log in first");
			}
		}

		private IEnumerator FetchCode()
		{
			if (_fetching)
			{
				yield break;
			}
			_fetching = true;
			SetCode("...");
			string sessionTicket = GetSessionTicket();
			if (string.IsNullOrEmpty(sessionTicket))
			{
				SetCode("log in first");
				_fetching = false;
				yield break;
			}
			string s = "{\"token\":\"" + Escape(sessionTicket) + "\",\"accountId\":\"" + Escape(Qauth.AccountId ?? "") + "\",\"gameId\":\"" + Escape(Qauth.Settings?.gameId ?? "") + "\"}";
			using (UnityWebRequest req = new UnityWebRequest(workerBaseUrl + "/link-code", "POST"))
			{
				req.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(s));
				req.downloadHandler = new DownloadHandlerBuffer();
				req.SetRequestHeader("Content-Type", "application/json");
				req.timeout = 15;
				yield return req.SendWebRequest();
				string json = ((req.downloadHandler != null) ? req.downloadHandler.text : "");
				string text = ExtractJsonString(json, "code");
				if (!string.IsNullOrEmpty(text))
				{
					SetCode(text);
					int num = ExtractJsonInt(json, "ttlMinutes", 0);
					if (autoRefreshSeconds > 0f && num > 0)
					{
						_fetching = false;
						yield return new WaitForSeconds(Mathf.Max(5f, (float)num * 60f - autoRefreshSeconds));
						StartCoroutine(FetchCode());
						yield break;
					}
				}
				else
				{
					SetCode("error - retry");
				}
			}
			_fetching = false;
		}

		private void SetCode(string value)
		{
			if (codeLabel != null)
			{
				codeLabel.text = string.Format(labelFormat, value);
			}
		}

		private string GetSessionTicket()
		{
			try
			{
				return Qauth.Token;
			}
			catch (Exception)
			{
				return null;
			}
		}

		private static string Escape(string s)
		{
			return s.Replace("\\", "\\\\").Replace("\"", "\\\"");
		}

		private static string ExtractJsonString(string json, string key)
		{
			if (string.IsNullOrEmpty(json))
			{
				return null;
			}
			string text = "\"" + key + "\":\"";
			int num = json.IndexOf(text, StringComparison.Ordinal);
			if (num < 0)
			{
				return null;
			}
			int num2 = num + text.Length;
			int num3 = json.IndexOf('"', num2);
			if (num3 <= num2)
			{
				return null;
			}
			return json.Substring(num2, num3 - num2);
		}

		private static int ExtractJsonInt(string json, string key, int fallback)
		{
			if (string.IsNullOrEmpty(json))
			{
				return fallback;
			}
			string text = "\"" + key + "\":";
			int num = json.IndexOf(text, StringComparison.Ordinal);
			if (num < 0)
			{
				return fallback;
			}
			int num2 = num + text.Length;
			int i;
			for (i = num2; i < json.Length && (char.IsDigit(json[i]) || json[i] == '-'); i++)
			{
			}
			if (!int.TryParse(json.Substring(num2, i - num2), out var result))
			{
				return fallback;
			}
			return result;
		}
	}
}
