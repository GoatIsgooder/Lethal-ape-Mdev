using System;
using UnityEngine;

namespace LethalApeR.Rivals.Economy
{
	public static class SaveWrapper
	{
		private const string Prefix = "Rivals.";

		public static int GetInt(string key, int fallback = 0)
		{
			return PlayerPrefs.GetInt(Prefix + key, fallback);
		}

		public static void SetInt(string key, int value)
		{
			PlayerPrefs.SetInt(Prefix + key, value);
			PlayerPrefs.Save();
		}

		public static string GetString(string key, string fallback = "")
		{
			return PlayerPrefs.GetString(Prefix + key, fallback);
		}

		public static void SetString(string key, string value)
		{
			PlayerPrefs.SetString(Prefix + key, value);
			PlayerPrefs.Save();
		}

		public static bool HasKey(string key)
		{
			return PlayerPrefs.HasKey(Prefix + key);
		}

		public static void Delete(string key)
		{
			PlayerPrefs.DeleteKey(Prefix + key);
		}

		public static T GetJson<T>(string key) where T : class, new()
		{
			string json = PlayerPrefs.GetString(Prefix + key, string.Empty);
			if (!string.IsNullOrEmpty(json))
			{
				try
				{
					return JsonUtility.FromJson<T>(json) ?? new T();
				}
				catch (Exception)
				{
					Debug.LogWarning("[SaveWrapper] Failed to parse JSON for key '" + key + "', returning default.");
				}
			}
			return new T();
		}

		public static void SetJson<T>(string key, T value) where T : class
		{
			PlayerPrefs.SetString(Prefix + key, JsonUtility.ToJson(value));
			PlayerPrefs.Save();
		}
	}
}
