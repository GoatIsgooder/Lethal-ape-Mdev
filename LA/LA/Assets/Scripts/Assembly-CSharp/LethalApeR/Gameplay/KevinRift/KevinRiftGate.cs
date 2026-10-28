using System;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;
using LethalApeR.SeasonPass;
using Newtonsoft.Json.Linq;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	[Obfuscation(Exclude = true)]
	public sealed class KevinRiftGate : MonoBehaviour
	{
		[Serializable]
		private sealed class Config
		{
			public bool enabled;

			public string startUtc;
		}

		public enum Override
		{
			None = 0,
			ForceOpen = 1,
			ForceClosed = 2
		}

		private const float PollSeconds = 300f;

		private const float RetrySeconds = 30f;

		private static KevinRiftGate _instance;

		private static bool _remoteEnabled;

		private static DateTime _remoteStart = DateTime.MinValue;

		private static bool _remoteKnown;

		private float _nextPoll;

		private bool _inFlight;

		private static Override _runtimeOverride;

		public static Override DevOverride
		{
			get
			{
				if (!Debug.isDebugBuild)
				{
					return Override.None;
				}
				return _runtimeOverride;
			}
			set
			{
				_runtimeOverride = value;
				Evaluate();
			}
		}

		public static bool SoloSummon => false;

		public static bool IsOpen => FeatureGates.IsOpen("KevinRift");

		public static string RemoteSummary
		{
			get
			{
				if (!_remoteKnown)
				{
					return "unknown";
				}
				return string.Format("enabled={0} start={1}", _remoteEnabled, (_remoteStart == DateTime.MinValue) ? "-" : _remoteStart.ToString("u"));
			}
		}

		public static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Auto] KevinRiftGate");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<KevinRiftGate>();
				Evaluate();
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
			_remoteEnabled = false;
			_remoteStart = DateTime.MinValue;
			_remoteKnown = false;
		}

		private void Update()
		{
			if (Time.unscaledTime >= _nextPoll && !_inFlight)
			{
				Poll();
			}
			if (Time.frameCount % 60 == 0)
			{
				Evaluate();
			}
		}

		private void OnApplicationPause(bool paused)
		{
			if (!paused)
			{
				_nextPoll = 0f;
				SeasonPassClock.MarkStale();
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
			SeasonPassClock.TrySync();
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
			Apply(ReadEventSetting(live, "KevinRift"));
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
					Debug.LogWarning("[KevinRift] Live event data is not JSON (" + ex.Message + "); keeping the rift closed.");
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
			_remoteEnabled = false;
			_remoteStart = DateTime.MinValue;
			try
			{
				if (!string.IsNullOrEmpty(json))
				{
					Config config = JsonUtility.FromJson<Config>(json);
					if (config != null)
					{
						_remoteEnabled = config.enabled;
						if (!string.IsNullOrEmpty(config.startUtc) && DateTime.TryParse(config.startUtc, CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal | DateTimeStyles.AssumeUniversal, out var result))
						{
							_remoteStart = result;
						}
					}
				}
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[KevinRift] Live event 'KevinRift' is unreadable (" + ex.Message + "); keeping the rift closed.");
			}
			Evaluate();
		}

		private static void Evaluate()
		{
			bool open;
			switch (DevOverride)
			{
			case Override.ForceOpen:
				open = true;
				break;
			case Override.ForceClosed:
				open = false;
				break;
			default:
				open = _remoteEnabled && (_remoteStart == DateTime.MinValue || (SeasonPassClock.Synced && SeasonPassClock.UtcNow >= _remoteStart));
				break;
			}
			FeatureGates.Set("KevinRift", open);
		}
	}
}
