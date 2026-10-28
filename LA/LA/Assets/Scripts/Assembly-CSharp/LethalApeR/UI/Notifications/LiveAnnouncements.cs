using System;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;
using System.Text.RegularExpressions;
using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.UI.Notifications
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class LiveAnnouncements : MonoBehaviour
	{
		[Serializable]
		[Obfuscation(Exclude = true)]
		private class Announcement
		{
			public string type;

			public string id;

			public string title;

			public string text;

			public float seconds;

			public long sentAt;
		}

		private struct Pending
		{
			public Announcement message;

			public float receivedAt;
		}

		public const string Endpoint = "wss://lethal-ape-bot.monkedevltd.workers.dev/live";

		private const string LastShownPref = "LiveAnnounce_LastSentAt";

		private const string DefaultTitle = "STAFF EVENT";

		private const float DefaultSeconds = 15f;

		private const float MaxRigWait = 300f;

		private const int MaxTitleChars = 40;

		private const int MaxTextChars = 280;

		private const float ChimeVolume = 0.55f;

		private const float HapticStrength = 0.45f;

		private const float HapticSeconds = 0.15f;

		private static readonly Regex NoParseClose = new Regex("</noparse>", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);

		private static LiveAnnouncements _instance;

		private readonly List<Pending> _pending = new List<Pending>(4);

		private LiveAnnouncementSocket _socket;

		private AudioSource _chime;

		private long _lastShownSentAt;

		private bool _wasConnected;

		private bool _reportedFirstFailure;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("LiveAnnouncements");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				gameObject.AddComponent<LiveAnnouncements>();
			}
		}

		private void Awake()
		{
			if (_instance != null && _instance != this)
			{
				UnityEngine.Object.Destroy(base.gameObject);
				return;
			}
			_instance = this;
			long.TryParse(PlayerPrefs.GetString(LastShownPref, "0"), NumberStyles.Integer, CultureInfo.InvariantCulture, out _lastShownSentAt);
			_socket = new LiveAnnouncementSocket(ResolveEndpoint());
		}

		private void OnEnable()
		{
			_socket?.Start();
		}

		private void OnDisable()
		{
			_socket?.Stop();
		}

		private void OnDestroy()
		{
			_socket?.Stop();
			if (_instance == this)
			{
				_instance = null;
			}
		}

		private void OnApplicationPause(bool paused)
		{
			if (_socket != null && base.isActiveAndEnabled)
			{
				if (paused)
				{
					_socket.Stop();
				}
				else
				{
					_socket.Start();
				}
			}
		}

		private void Update()
		{
			if (_socket != null)
			{
				string json;
				while (_socket.Inbox.TryDequeue(out json))
				{
					Receive(json);
				}
				if (_pending.Count > 0)
				{
					ShowPending();
				}
				ReportConnection();
			}
		}

		private void Receive(string json)
		{
			Announcement announcement;
			try
			{
				announcement = JsonUtility.FromJson<Announcement>(json);
			}
			catch (Exception)
			{
				return;
			}
			if (announcement == null || announcement.type != "announce" || string.IsNullOrEmpty(announcement.text) || announcement.sentAt <= _lastShownSentAt)
			{
				return;
			}
			for (int i = 0; i < _pending.Count; i++)
			{
				if (_pending[i].message.id == announcement.id)
				{
					return;
				}
			}
			_pending.Add(new Pending
			{
				message = announcement,
				receivedAt = Time.unscaledTime
			});
		}

		private void ShowPending()
		{
			if (!RigReady())
			{
				float unscaledTime = Time.unscaledTime;
				for (int num = _pending.Count - 1; num >= 0; num--)
				{
					if (unscaledTime - _pending[num].receivedAt > MaxRigWait)
					{
						_pending.RemoveAt(num);
					}
				}
				return;
			}
			bool flag = false;
			for (int i = 0; i < _pending.Count; i++)
			{
				Announcement message = _pending[i].message;
				if (message.sentAt > _lastShownSentAt)
				{
					float life = ((message.seconds > 0f) ? Mathf.Clamp(message.seconds, 5f, 60f) : DefaultSeconds);
					HandNotifications.Show(NotificationKind.Event, Literal(message.title, MaxTitleChars, DefaultTitle), Literal(message.text, MaxTextChars, ""), life);
					_lastShownSentAt = message.sentAt;
					flag = true;
				}
			}
			_pending.Clear();
			if (flag)
			{
				PlayerPrefs.SetString(LastShownPref, _lastShownSentAt.ToString(CultureInfo.InvariantCulture));
				PlayerPrefs.Save();
				PlayChime();
				Buzz();
			}
		}

		private static bool RigReady()
		{
			if (!Player.HasInstance)
			{
				return false;
			}
			Player instance = Player.Instance;
			if (instance != null && instance.mainCamera != null)
			{
				if (!(instance.leftHandFollower != null))
				{
					return instance.leftHandTransform != null;
				}
				return true;
			}
			return false;
		}

		private static string Literal(string s, int max, string fallback)
		{
			if (string.IsNullOrEmpty(s))
			{
				s = fallback;
			}
			if (s.Length > max)
			{
				s = s.Substring(0, char.IsHighSurrogate(s[max - 1]) ? (max - 1) : max);
			}
			return "<noparse>" + NoParseClose.Replace(s, "") + "</noparse>";
		}

		private void ReportConnection()
		{
			bool isConnected = _socket.IsConnected;
			if (isConnected != _wasConnected)
			{
				_wasConnected = isConnected;
				if (isConnected)
				{
					Debug.Log("[LiveAnnouncements] Connected to the live channel.");
				}
				else
				{
					Debug.Log("[LiveAnnouncements] Live channel dropped (" + (_socket.LastError ?? "closed") + "); reconnecting.");
				}
				_reportedFirstFailure = true;
			}
			else if (!isConnected && !_reportedFirstFailure && _socket.LastError != null)
			{
				_reportedFirstFailure = true;
				Debug.LogWarning("[LiveAnnouncements] Can't reach the live channel yet (" + _socket.LastError + "); retrying in the background.");
			}
		}

		private static Uri ResolveEndpoint()
		{
			return new Uri(Endpoint);
		}

		private void PlayChime()
		{
			if (_chime == null)
			{
				_chime = base.gameObject.AddComponent<AudioSource>();
				_chime.playOnAwake = false;
				_chime.spatialBlend = 0f;
				_chime.spatialize = false;
				_chime.bypassReverbZones = true;
				_chime.dopplerLevel = 0f;
				_chime.priority = 16;
				_chime.volume = ChimeVolume;
				_chime.clip = BuildChime(AudioSettings.outputSampleRate);
			}
			_chime.Play();
		}

		private static void Buzz()
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				if (HandNotifications.PreferLeftHand)
				{
					instance.PulseLeft(HapticStrength, HapticSeconds);
				}
				else
				{
					instance.PulseRight(HapticStrength, HapticSeconds);
				}
			}
		}

		private static AudioClip BuildChime(int rate)
		{
			if (rate <= 0)
			{
				rate = 48000;
			}
			int num = Mathf.CeilToInt((float)rate * 1.1f);
			float[] array = new float[num];
			AddNote(array, rate, 880f, 0f, 0.26f, 0.9f);
			AddNote(array, rate, 1318.51f, 0.12f, 0.36f, 0.8f);
			float num2 = 0f;
			for (int i = 0; i < num; i++)
			{
				num2 = Mathf.Max(num2, Mathf.Abs(array[i]));
			}
			float num3 = ((num2 > 0f) ? (0.9f / num2) : 0f);
			int num4 = rate / 20;
			for (int j = 0; j < num; j++)
			{
				int num5 = num - 1 - j;
				array[j] *= ((num5 < num4) ? (num3 * (float)num5 / (float)num4) : num3);
			}
			AudioClip audioClip = AudioClip.Create("EventChime", num, 1, rate, stream: false);
			audioClip.SetData(array, 0);
			return audioClip;
		}

		private static void AddNote(float[] data, int rate, float hz, float start, float decay, float level)
		{
			int num = Mathf.RoundToInt((float)rate * start);
			double num2 = (double)hz * (Math.PI * 2.0) / (double)rate;
			float num3 = (float)rate * 0.004f;
			for (int i = 0; num + i < data.Length; i++)
			{
				float num4 = (float)i / (float)rate;
				float num5 = ((num3 > (float)i) ? ((float)i / num3) : 1f) * Mathf.Exp((0f - num4) / decay);
				double num6 = num2 * (double)i;
				double num7 = Math.Sin(num6) + Math.Sin(num6 * 2.0) * (Math.Exp((0f - num4) / (decay * 0.45f)) * 0.3) + Math.Sin(num6 * 3.0) * 0.08;
				data[num + i] += level * num5 * (float)num7;
			}
		}
	}
}
