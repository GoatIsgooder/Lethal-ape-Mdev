using System;
using System.Collections;
using System.Text;
using Oculus.Platform;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.Networking;

public static class SlopAttestation
{
	public class Result
	{
		public bool Completed;

		public bool Skipped;

		public bool Ok;

		public bool Attested;

		public bool Enforce;

		public string[] Reasons;

		public string Error;

		public string PlayFabSessionTicket;

		public string PlayFabId;

		public string EntityToken;

		public string PhotonToken;
	}

	[Serializable]
	private class ConfigResp
	{
		public bool active;

		public string minVersion;

		public bool enforce;
	}

	[Serializable]
	private class NonceResp
	{
		public string nonce;

		public int ttl;
	}

	[Serializable]
	private class AttestReq
	{
		public string nonce;

		public string attestationToken;

		public string oculusId;

		public string currentPlayFabId;

		public string appVersion;
	}

	[Serializable]
	private class PlayfabBlock
	{
		public string sessionTicket;

		public string playFabId;

		public string entityToken;

		public string entityId;

		public string entityType;

		public bool newlyCreated;

		public bool linked;
	}

	[Serializable]
	private class AttestResp
	{
		public bool ok;

		public bool attested;

		public bool enforce;

		public string[] reasons;

		public PlayfabBlock playfab;

		public string photonToken;

		public int photonTokenTtl;

		public string error;
	}

	private const bool Enabled = false;

	public const string WorkerBaseUrl = "https://slop-attestation.monkedevltd.workers.dev";

	private const int TimeoutSeconds = 15;

	public static Result Last { get; private set; }

	public static IEnumerator Run(string oculusId, string currentPlayFabId, Action<Result> onDone)
	{
		Result result = new Result();
		Last = result;
		if (!Enabled)
		{
			result.Skipped = true;
			onDone?.Invoke(result);
			yield break;
		}
		ConfigResp cfg = null;
		// RE: unsure - this call is unreachable (Enabled is const false) so the compiler dropped it; only its lambdas survive and the "/v1/config" path is a guess
		yield return GetJson(WorkerBaseUrl + "/v1/config", delegate(string txt)
		{
			cfg = JsonUtility.FromJson<ConfigResp>(txt);
		}, delegate(string err)
		{
			Debug.Log("[Attestation] config unreachable; staying dormant: " + err);
		});
		if (cfg == null || !cfg.active || !VersionAtLeast(UnityEngine.Application.version, cfg.minVersion))
		{
			result.Skipped = true;
			Debug.Log($"[Attestation] Dormant (active={cfg != null && cfg.active}, " + "ver=" + UnityEngine.Application.version + ", min=" + ((cfg != null) ? cfg.minVersion : "?") + "). Using legacy login.");
			onDone?.Invoke(result);
			yield break;
		}
		string nonce = null;
		yield return PostJson(WorkerBaseUrl + "/v1/nonce", "{}", delegate(string txt)
		{
			nonce = JsonUtility.FromJson<NonceResp>(txt)?.nonce;
		}, delegate(string err)
		{
			result.Error = "nonce:" + err;
		});
		if (string.IsNullOrEmpty(nonce))
		{
			Debug.LogWarning("[Attestation] Failed to get nonce: " + result.Error);
			onDone?.Invoke(result);
			yield break;
		}
		string token = null;
		string tokenError = null;
		bool tokenDone = false;
		try
		{
			DeviceApplicationIntegrity.GetIntegrityToken(nonce).OnComplete(delegate(Message<string> msg)
			{
				if (msg.IsError)
				{
					tokenError = msg.GetError().Message;
				}
				else
				{
					token = msg.Data;
				}
				tokenDone = true;
			});
		}
		catch (Exception ex)
		{
			tokenError = "exception:" + ex.Message;
			tokenDone = true;
		}
		float waited = 0f;
		while (!tokenDone && waited < (float)TimeoutSeconds)
		{
			waited += Time.unscaledDeltaTime;
			yield return null;
		}
		if (string.IsNullOrEmpty(token))
		{
			result.Error = "integrity_token:" + (tokenError ?? "timeout");
			Debug.LogWarning("[Attestation] " + result.Error);
			onDone?.Invoke(result);
			yield break;
		}
		string json = JsonUtility.ToJson(new AttestReq
		{
			nonce = nonce,
			attestationToken = token,
			oculusId = oculusId,
			currentPlayFabId = currentPlayFabId ?? "",
			appVersion = UnityEngine.Application.version
		});
		AttestResp resp = null;
		yield return PostJson(WorkerBaseUrl + "/v1/attest", json, delegate(string txt)
		{
			resp = JsonUtility.FromJson<AttestResp>(txt);
		}, delegate(string err)
		{
			result.Error = "attest:" + err;
		});
		if (resp == null)
		{
			Debug.LogWarning("[Attestation] attest call failed: " + result.Error);
			onDone?.Invoke(result);
			yield break;
		}
		result.Completed = true;
		result.Ok = resp.ok;
		result.Attested = resp.attested;
		result.Enforce = resp.enforce;
		result.Reasons = resp.reasons;
		if (resp.playfab != null)
		{
			result.PlayFabSessionTicket = resp.playfab.sessionTicket;
			result.PlayFabId = resp.playfab.playFabId;
			result.EntityToken = resp.playfab.entityToken;
		}
		result.PhotonToken = resp.photonToken;
		if (resp.attested)
		{
			Debug.Log("[Attestation] attested OK. enforce=" + resp.enforce);
		}
		else
		{
			Debug.LogWarning("[Attestation] verdict NOT attested. enforce=" + resp.enforce + " reasons=" + ((resp.reasons != null) ? string.Join(",", resp.reasons) : ""));
		}
		onDone?.Invoke(result);
	}

	public static AuthenticationValues BuildPhotonAuthValues(string oculusId)
	{
		Result last = Last;
		if (last == null || string.IsNullOrEmpty(last.PhotonToken))
		{
			return null;
		}
		AuthenticationValues authenticationValues = new AuthenticationValues(oculusId);
		authenticationValues.AuthType = CustomAuthenticationType.Custom;
		authenticationValues.AddAuthParameter("token", last.PhotonToken);
		authenticationValues.AddAuthParameter("user", oculusId);
		return authenticationValues;
	}

	private static bool VersionAtLeast(string version, string minVersion)
	{
		if (string.IsNullOrEmpty(minVersion))
		{
			return true;
		}
		if (string.IsNullOrEmpty(version))
		{
			return false;
		}
		string[] array = NumericVersion(version).Split('.');
		string[] array2 = minVersion.Split('.');
		int num = Math.Max(array.Length, array2.Length);
		for (int i = 0; i < num; i++)
		{
			int result;
			int num2 = ((i < array.Length && int.TryParse(array[i], out result)) ? result : 0);
			int result2;
			int num3 = ((i < array2.Length && int.TryParse(array2[i], out result2)) ? result2 : 0);
			if (num2 != num3)
			{
				return num2 > num3;
			}
		}
		return true;
	}

	private static string NumericVersion(string v)
	{
		if (string.IsNullOrEmpty(v))
		{
			return v;
		}
		int num = v.LastIndexOf(' ');
		if (num >= 0)
		{
			v = v.Substring(num + 1);
		}
		StringBuilder stringBuilder = new StringBuilder(v.Length);
		for (int i = 0; i < v.Length; i++)
		{
			char c = v[i];
			if (c == '.' || (c >= '0' && c <= '9'))
			{
				stringBuilder.Append(c);
			}
		}
		if (stringBuilder.Length <= 0)
		{
			return v;
		}
		return stringBuilder.ToString();
	}

	private static IEnumerator GetJson(string url, Action<string> onText, Action<string> onError)
	{
		using (UnityWebRequest www = UnityWebRequest.Get(url))
		{
			www.timeout = TimeoutSeconds;
			yield return www.SendWebRequest();
			if (www.result == UnityWebRequest.Result.Success)
			{
				onText?.Invoke(www.downloadHandler.text);
			}
			else
			{
				onError?.Invoke(www.error + " (" + www.responseCode + ")");
			}
		}
	}

	private static IEnumerator PostJson(string url, string json, Action<string> onText, Action<string> onError)
	{
		using (UnityWebRequest www = new UnityWebRequest(url, "POST"))
		{
			www.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(json));
			www.downloadHandler = new DownloadHandlerBuffer();
			www.SetRequestHeader("Content-Type", "application/json");
			www.timeout = TimeoutSeconds;
			yield return www.SendWebRequest();
			if (www.result == UnityWebRequest.Result.Success)
			{
				onText?.Invoke(www.downloadHandler.text);
			}
			else
			{
				onError?.Invoke(www.error + " (" + www.responseCode + ") " + ((www.downloadHandler != null) ? www.downloadHandler.text : ""));
			}
		}
	}
}
