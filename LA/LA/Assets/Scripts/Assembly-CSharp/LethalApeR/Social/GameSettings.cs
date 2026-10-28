using System;
using LethalApeR;
using UnityEngine;
using UnityEngine.Android;
using UnityEngine.SceneManagement;

namespace LethalApeR.Social
{
	public static class GameSettings
	{
		public enum Volume
		{
			Master = 0,
			Monsters = 1,
			Music = 2,
			Voice = 3
		}

		public const string MusicTag = "MuteForMusic";

		public const string MonsterTag = "MuteForMonster";

		private const string MusicKey = "AudioManager_Volume_MusicVol";

		private const string MonsterKey = "AudioManager_Volume_MonsterVolume";

		private const string MasterKey = "Settings_MasterVolume";

		private const string VoiceKey = "Settings_VoiceVolume";

		public const int Steps = 10;

		private static readonly float[] Percent = new float[4];

		private static bool _loaded;

		private static bool _hooked;

		private static bool _micOn = true;

		public static float VoiceVolume01 => GetPercent(Volume.Voice) / 100f;

		public static bool MicOn
		{
			get
			{
				return _micOn;
			}
			set
			{
				if (_micOn != value)
				{
					_micOn = value;
					GameSettings.Changed?.Invoke();
				}
			}
		}

		public static bool MicPermitted => Permission.HasUserAuthorizedPermission("android.permission.RECORD_AUDIO");

		public static TurnController.TurnMode Turn
		{
			get
			{
				return TurnController.currentTurnMode;
			}
			set
			{
				if (TurnController.currentTurnMode != value)
				{
					TurnController.SetTurnMode(value);
					GameSettings.Changed?.Invoke();
				}
			}
		}

		public static event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			GameSettings.Changed = null;
			_loaded = false;
			_hooked = false;
			_micOn = true;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			if (!_hooked)
			{
				_hooked = true;
				SceneManager.sceneLoaded += delegate(Scene _, LoadSceneMode __)
				{
					ApplyAudio();
				};
			}
			ApplyAudio();
		}

		public static float GetPercent(Volume volume)
		{
			Load();
			return Percent[(int)volume];
		}

		public static int GetStep(Volume volume)
		{
			return Mathf.Clamp(Mathf.RoundToInt(GetPercent(volume) / 10f), 0, 10);
		}

		public static void SetStep(Volume volume, int step)
		{
			SetPercent(volume, (float)Mathf.Clamp(step, 0, 10) * 10f);
		}

		public static void SetPercent(Volume volume, float percentage)
		{
			Load();
			percentage = Mathf.Clamp(percentage, 0f, 100f);
			if (Mathf.Approximately(Percent[(int)volume], percentage))
			{
				return;
			}
			Percent[(int)volume] = percentage;
			switch (volume)
			{
			case Volume.Master:
				PlayerPrefs.SetFloat(MasterKey, percentage);
				AudioListener.volume = percentage / 100f;
				break;
			case Volume.Monsters:
				PlayerPrefs.SetFloat(MonsterKey, percentage);
				AudioManager.SetChannelVolume(MonsterTag, percentage);
				break;
			case Volume.Music:
				PlayerPrefs.SetFloat(MusicKey, percentage);
				AudioManager.SetChannelVolume(MusicTag, percentage);
				break;
			case Volume.Voice:
				PlayerPrefs.SetFloat(VoiceKey, percentage);
				break;
			}
			PlayerPrefs.Save();
			GameSettings.Changed?.Invoke();
		}

		private static void ApplyAudio()
		{
			Load();
			AudioListener.volume = Percent[0] / 100f;
			AudioManager.SetChannelVolume(MusicTag, Percent[2]);
			AudioManager.SetChannelVolume(MonsterTag, Percent[1]);
		}

		private static void Load()
		{
			if (!_loaded)
			{
				_loaded = true;
				Percent[0] = PlayerPrefs.GetFloat(MasterKey, 100f);
				Percent[1] = PlayerPrefs.GetFloat(MonsterKey, 100f);
				Percent[2] = PlayerPrefs.GetFloat(MusicKey, 100f);
				Percent[3] = PlayerPrefs.GetFloat(VoiceKey, 100f);
			}
		}

		public static void Reload()
		{
			_loaded = false;
			Load();
			GameSettings.Changed?.Invoke();
		}
	}
}
