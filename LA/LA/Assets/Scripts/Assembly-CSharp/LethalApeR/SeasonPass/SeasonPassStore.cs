using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassStore
	{
		private const string Salt = "slop.seasonpass.7f3c19";

		public static string Key(string seasonId)
		{
			return "SeasonPass." + seasonId + ".v1";
		}

		public static SeasonPassSaveData Load(string seasonId)
		{
			string key = Key(seasonId);
			string json = PlayerPrefs.GetString(key, string.Empty);
			if (string.IsNullOrEmpty(json))
			{
				return Fresh(seasonId);
			}
			try
			{
				if (PlayerPrefs.GetString(key + ".s", string.Empty) != Seal(json))
				{
					Debug.LogWarning("[SeasonPass] Save for " + seasonId + " failed its seal check; starting fresh.");
					return Fresh(seasonId);
				}
				SeasonPassSaveData data = JsonUtility.FromJson<SeasonPassSaveData>(json);
				if (data != null && data.seasonId == seasonId)
				{
					if (data.daily == null)
					{
						data.daily = new List<SeasonQuestProgress>();
					}
					if (data.challenges == null)
					{
						data.challenges = new List<SeasonQuestProgress>();
					}
					return data;
				}
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[SeasonPass] Save for " + seasonId + " is unreadable (" + ex.Message + "); starting fresh.");
			}
			return Fresh(seasonId);
		}

		public static void Save(SeasonPassSaveData data)
		{
			if (data != null && !string.IsNullOrEmpty(data.seasonId))
			{
				string json = JsonUtility.ToJson(data);
				string key = Key(data.seasonId);
				PlayerPrefs.SetString(key, json);
				PlayerPrefs.SetString(key + ".s", Seal(json));
				PlayerPrefs.Save();
			}
		}

		public static void Delete(string seasonId)
		{
			string key = Key(seasonId);
			PlayerPrefs.DeleteKey(key);
			PlayerPrefs.DeleteKey(key + ".s");
			PlayerPrefs.Save();
		}

		private static SeasonPassSaveData Fresh(string seasonId)
		{
			return new SeasonPassSaveData
			{
				seasonId = seasonId
			};
		}

		private static string Seal(string json)
		{
			ulong hash = 14695981039346656037uL;
			Mix(ref hash, Salt);
			Mix(ref hash, json);
			return hash.ToString("x16");
		}

		private static void Mix(ref ulong hash, string s)
		{
			foreach (char c in s)
			{
				hash ^= c;
				hash *= 1099511628211uL;
			}
		}
	}
}
