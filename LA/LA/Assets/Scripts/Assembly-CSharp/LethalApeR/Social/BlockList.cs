using System;
using System.Collections.Generic;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Social
{
	public static class BlockList
	{
		[Serializable]
		private sealed class Saved
		{
			public List<string> ids = new List<string>();

			public List<string> names = new List<string>();
		}

		private const string LocalKey = "Social_BlockedLocal";

		public const string ServerKey = "Social_Blocked";

		private const int MaxEntries = 200;

		private static readonly List<string> Ids = new List<string>();

		private static readonly List<string> Names = new List<string>();

		private static readonly HashSet<string> Set = new HashSet<string>(StringComparer.Ordinal);

		private static bool _loaded;

		private static bool _pushPending;

		private static bool _pushing;

		public static int Count
		{
			get
			{
				Load();
				return Ids.Count;
			}
		}

		public static event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Ids.Clear();
			Names.Clear();
			Set.Clear();
			_loaded = false;
			_pushPending = false;
			_pushing = false;
			Changed = null;
		}

		public static string IdAt(int index)
		{
			Load();
			return Ids[index];
		}

		public static string NameAt(int index)
		{
			Load();
			return Names[index];
		}

		public static bool IsBlocked(string userId)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return false;
			}
			Load();
			return Set.Contains(userId);
		}

		public static void Block(string userId, string displayName)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return;
			}
			Load();
			if (Set.Contains(userId))
			{
				return;
			}
			Set.Add(userId);
			Ids.Add(userId);
			Names.Add(string.IsNullOrEmpty(displayName) ? "PLAYER" : displayName);
			while (Ids.Count > 200)
			{
				Set.Remove(Ids[0]);
				Ids.RemoveAt(0);
				Names.RemoveAt(0);
			}
			SaveAndPush();
		}

		public static void Unblock(string userId)
		{
			Load();
			int index = Ids.IndexOf(userId);
			if (index >= 0)
			{
				Set.Remove(userId);
				Ids.RemoveAt(index);
				Names.RemoveAt(index);
				SaveAndPush();
			}
		}

		public static void RememberName(string userId, string displayName)
		{
			if (string.IsNullOrEmpty(displayName))
			{
				return;
			}
			Load();
			int index = Ids.IndexOf(userId);
			if (index >= 0 && !(Names[index] == displayName))
			{
				Names[index] = displayName;
				SaveLocal();
			}
		}

		public static async void SyncWithServer()
		{
			if (!Qauth.IsLoggedIn)
			{
				return;
			}
			Load();
			Dictionary<string, QauthSave> result;
			try
			{
				result = await Qauth.Saves.PullAsync();
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[Social] Couldn't read the block list: " + ex.Message);
				return;
			}
			if (result != null && result.TryGetValue("Social_Blocked", out var value) && value != null && !string.IsNullOrEmpty(value.Data))
			{
				string[] array = value.Data.Split(',');
				bool flag = false;
				foreach (string text in array)
				{
					if (!string.IsNullOrEmpty(text) && Set.Add(text))
					{
						Ids.Add(text);
						Names.Add("PLAYER");
						flag = true;
					}
				}
				if (flag)
				{
					SaveLocal();
					Changed?.Invoke();
				}
			}
			if (ServerDiffers(result))
			{
				Push();
			}
		}

		private static bool ServerDiffers(Dictionary<string, QauthSave> result)
		{
			string a = ((result != null && result.TryGetValue("Social_Blocked", out var value) && value != null) ? (value.Data ?? "") : "");
			return !string.Equals(a, string.Join(",", Ids), StringComparison.Ordinal);
		}

		private static void SaveAndPush()
		{
			SaveLocal();
			Push();
			Changed?.Invoke();
		}

		private static void SaveLocal()
		{
			Saved saved = new Saved();
			saved.ids.AddRange(Ids);
			saved.names.AddRange(Names);
			PlayerPrefs.SetString("Social_BlockedLocal", JsonUtility.ToJson(saved));
			PlayerPrefs.Save();
		}

		private static async void Push()
		{
			if (!Qauth.IsLoggedIn)
			{
				return;
			}
			if (_pushing)
			{
				_pushPending = true;
				return;
			}
			_pushPending = false;
			_pushing = true;
			QauthPushResult result;
			try
			{
				result = await Qauth.Saves.PushAsync("Social_Blocked", string.Join(",", Ids), QauthSaves.Now);
			}
			catch (Exception ex)
			{
				_pushing = false;
				Debug.LogWarning("[Social] Couldn't save the block list: " + ex.Message);
				return;
			}
			_pushing = false;
			if (!result.Ok)
			{
				Debug.LogWarning("[Social] Couldn't save the block list: " + result.Error);
			}
			else if (_pushPending)
			{
				Push();
			}
		}

		private static void Load()
		{
			if (_loaded)
			{
				return;
			}
			_loaded = true;
			try
			{
				string json = PlayerPrefs.GetString("Social_BlockedLocal", "");
				if (string.IsNullOrEmpty(json))
				{
					return;
				}
				Saved saved = JsonUtility.FromJson<Saved>(json);
				if (saved == null || saved.ids == null)
				{
					return;
				}
				for (int i = 0; i < saved.ids.Count; i++)
				{
					string text = saved.ids[i];
					if (!string.IsNullOrEmpty(text) && Set.Add(text))
					{
						Ids.Add(text);
						Names.Add((saved.names != null && i < saved.names.Count) ? saved.names[i] : "PLAYER");
					}
				}
			}
			catch (Exception)
			{
			}
		}
	}
}
