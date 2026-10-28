using System;
using System.Collections.Generic;
using System.Reflection;
using Newtonsoft.Json.Linq;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	[Obfuscation(Exclude = true)]
	public sealed class BansheeGate : MonoBehaviour
	{
		[Serializable]
		private sealed class Config
		{
			public bool enabled = true;
		}

		public enum Override
		{
			None = 0,
			ForceOpen = 1,
			ForceClosed = 2
		}

		private const float PollSeconds = 600f;

		private const float RetrySeconds = 60f;

		private static BansheeGate _instance;

		private static bool _remoteEnabled = true;

		private static bool _remoteKnown;

		private float _nextPoll;

		private bool _inFlight;

		public static bool IsOpen => FeatureGates.IsOpen("Banshee");

		public static string RemoteSummary => _remoteKnown ? string.Format("enabled={0}", _remoteEnabled) : "unknown (on by default)";

		public static Override DevOverride
		{
			get
			{
				return Override.None;
			}
			set
			{
				Evaluate();
			}
		}

		public static bool FastSummon => false;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
		private static void OpenByDefault()
		{
			Evaluate();
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
			_remoteEnabled = true;
			_remoteKnown = false;
		}

		public static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Auto] BansheeGate");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<BansheeGate>();
			}
		}

		private void Update()
		{
			if (!(Time.unscaledTime < _nextPoll) && !_inFlight)
			{
				Poll();
			}
		}

		private void OnApplicationPause(bool paused)
		{
			if (!paused)
			{
				_nextPoll = 0f;
			}
		}

		private async void Poll()
		{
			if (!Qauth.IsLoggedIn)
			{
				_nextPoll = Time.unscaledTime + 5f;
				return;
			}
			_inFlight = true;
			JObject live;
			try
			{
				live = await Qauth.Events.GetAsync();
			}
			catch
			{
				_inFlight = false;
				_nextPoll = Time.unscaledTime + RetrySeconds;
				return;
			}
			_inFlight = false;
			_nextPoll = Time.unscaledTime + PollSeconds;
			Apply(ReadEventSetting(live, "Banshee"));
		}

		private static string ReadEventSetting(JObject live, string key)
		{
			JToken value = live?[key];
			if (value == null || value.Type == JTokenType.Null)
			{
				string data = (live?["event"] as JObject)?["data"]?.Value<string>();
				if (string.IsNullOrEmpty(data))
				{
					return null;
				}
				try
				{
					value = JObject.Parse(data)[key];
				}
				catch (Exception ex)
				{
					Debug.LogWarning("[Banshee] Live event data is not JSON (" + ex.Message + "); leaving her on.");
					return null;
				}
			}
			if (value == null || value.Type == JTokenType.Null)
			{
				return null;
			}
			return (value.Type == JTokenType.String) ? value.Value<string>() : value.ToString(Newtonsoft.Json.Formatting.None);
		}

		private static void Apply(string json)
		{
			_remoteKnown = true;
			_remoteEnabled = true;
			if (!string.IsNullOrEmpty(json))
			{
				try
				{
					Config config = JsonUtility.FromJson<Config>(json);
					if (config != null)
					{
						_remoteEnabled = config.enabled;
					}
				}
				catch (Exception ex)
				{
					Debug.LogWarning("[Banshee] Live event 'Banshee' is unreadable (" + ex.Message + "); leaving her on.");
				}
			}
			Evaluate();
		}

		private static void Evaluate()
		{
			FeatureGates.Set("Banshee", _remoteEnabled);
		}
	}
}
