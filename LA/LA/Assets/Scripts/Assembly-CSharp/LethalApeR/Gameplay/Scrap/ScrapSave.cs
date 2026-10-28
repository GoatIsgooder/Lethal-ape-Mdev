using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public static class ScrapSave
	{
		private const string Prefix = "Scrap.";

		public static int GetInt(string key, int fallback = 0)
		{
			return PlayerPrefs.GetInt(Prefix + key, fallback);
		}

		public static void SetInt(string key, int value)
		{
			PlayerPrefs.SetInt(Prefix + key, value);
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
	}
}
