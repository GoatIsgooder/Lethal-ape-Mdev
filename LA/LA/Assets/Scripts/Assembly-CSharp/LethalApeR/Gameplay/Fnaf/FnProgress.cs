using System;
using System.Security.Cryptography;
using System.Text;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnProgress
	{
		private const string LegacyKey = "FNAF.Progress.v1";

		private const string LegacySealKey = "FNAF.Progress.v1.s";

		private const string Salt = "fn-xplay-1:night-guard";

		private const int MaxRecorded = 15;

		private static readonly string[] Keys = new string[2] { "FNAF.Progress.v2.Default", "FNAF.Progress.v2.Nightmare" };

		private static readonly string[] SealKeys = new string[2] { "FNAF.Progress.v2.Default.s", "FNAF.Progress.v2.Nightmare.s" };

		private static readonly string[] PropKeys = new string[2] { "fnHi", "fnHiN" };

		private static readonly int[] Best = new int[2];

		private static bool _loaded;

		public static bool NightmareUnlockedLocally => UnlocksNightmare(Highest(FnDifficulty.Default));

		public static event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_loaded = false;
			if (Best != null)
			{
				Array.Clear(Best, 0, Best.Length);
			}
			Changed = null;
		}

		private static int Index(FnDifficulty difficulty)
		{
			return (difficulty == FnDifficulty.Nightmare) ? 1 : 0;
		}

		public static int Highest(FnDifficulty difficulty)
		{
			if (!_loaded)
			{
				Load();
			}
			return Best[Index(difficulty)];
		}

		public static int MaxSelectable(FnDifficulty difficulty, int maxNight)
		{
			return Mathf.Clamp(Highest(difficulty) + 1, 1, maxNight);
		}

		public static int HighestOf(Player player, FnDifficulty difficulty)
		{
			return FnProps.PlayerByte(player, PropKeys[Index(difficulty)]);
		}

		public static bool NightmareUnlocked(Player player)
		{
			if (player == null)
			{
				return false;
			}
			return UnlocksNightmare(HighestOf(player, FnDifficulty.Default));
		}

		private static bool UnlocksNightmare(int highestDefault)
		{
			return highestDefault >= FnGame.Settings.hub.maxNight;
		}

		public static bool RecordCompleted(FnDifficulty difficulty, int night)
		{
			int num = Mathf.Clamp(night, 0, MaxRecorded);
			int num2 = Highest(difficulty);
			if (num > num2)
			{
				Best[Index(difficulty)] = num;
				Save(Index(difficulty));
				PlayerPrefs.Save();
				Publish();
				Changed?.Invoke();
			}
			return num > num2;
		}

		public static void Publish()
		{
			if (PhotonNetwork.LocalPlayer != null)
			{
				Hashtable hashtable = new Hashtable();
				hashtable["fnHi"] = (byte)Highest(FnDifficulty.Default);
				hashtable["fnHiN"] = (byte)Highest(FnDifficulty.Nightmare);
				FnProps.WriteLocal(hashtable);
			}
		}

		public static void ResetAll()
		{
			for (int i = 0; i < Keys.Length; i++)
			{
				Best[i] = 0;
				PlayerPrefs.DeleteKey(Keys[i]);
				PlayerPrefs.DeleteKey(SealKeys[i]);
			}
			PlayerPrefs.DeleteKey(LegacyKey);
			PlayerPrefs.DeleteKey(LegacySealKey);
			PlayerPrefs.Save();
			_loaded = true;
			Publish();
			Changed?.Invoke();
		}

		private static void Load()
		{
			_loaded = true;
			for (int i = 0; i < Keys.Length; i++)
			{
				int num = PlayerPrefs.GetInt(Keys[i], 0);
				Best[i] = ((num >= 1 && PlayerPrefs.GetString(SealKeys[i], "") == Seal(Keys[i], num)) ? Mathf.Min(num, MaxRecorded) : 0);
			}
			if (PlayerPrefs.HasKey(LegacyKey) || PlayerPrefs.HasKey(LegacySealKey))
			{
				MigrateLegacy();
			}
		}

		private static void MigrateLegacy()
		{
			int num = PlayerPrefs.GetInt(LegacyKey, 0);
			if (num >= 1 && PlayerPrefs.GetString(LegacySealKey, "") == Hash(Salt + ":" + num))
			{
				int num2 = Mathf.Min(num, MaxRecorded);
				if (num2 > Best[0])
				{
					Best[0] = num2;
					Save(0);
				}
			}
			PlayerPrefs.DeleteKey(LegacyKey);
			PlayerPrefs.DeleteKey(LegacySealKey);
			PlayerPrefs.Save();
		}

		private static void Save(int i)
		{
			PlayerPrefs.SetInt(Keys[i], Best[i]);
			PlayerPrefs.SetString(SealKeys[i], Seal(Keys[i], Best[i]));
		}

		private static string Seal(string key, int value)
		{
			return Hash(Salt + ":" + key + ":" + value);
		}

		private static string Hash(string text)
		{
			using (SHA256 sHA = SHA256.Create())
			{
				return Convert.ToBase64String(sHA.ComputeHash(Encoding.UTF8.GetBytes(text)), 0, 12);
			}
		}
	}
}
