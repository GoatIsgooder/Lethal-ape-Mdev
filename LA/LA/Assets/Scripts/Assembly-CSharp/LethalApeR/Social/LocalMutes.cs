using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Social
{
	public static class LocalMutes
	{
		private const string Key = "Social_Mutes";

		private const int MaxEntries = 300;

		private static readonly List<string> Order = new List<string>();

		private static readonly HashSet<string> Set = new HashSet<string>(StringComparer.Ordinal);

		private static bool _loaded;

		public static event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Order.Clear();
			Set.Clear();
			_loaded = false;
			LocalMutes.Changed = null;
		}

		public static bool IsMuted(string userId)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return false;
			}
			Load();
			return Set.Contains(userId);
		}

		public static void SetMuted(string userId, bool muted)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return;
			}
			Load();
			if (Set.Contains(userId) == muted)
			{
				return;
			}
			if (muted)
			{
				Set.Add(userId);
				Order.Add(userId);
				while (Order.Count > MaxEntries)
				{
					Set.Remove(Order[0]);
					Order.RemoveAt(0);
				}
			}
			else
			{
				Set.Remove(userId);
				Order.Remove(userId);
			}
			PlayerPrefs.SetString(Key, string.Join(",", Order));
			PlayerPrefs.Save();
			LocalMutes.Changed?.Invoke();
		}

		public static void Toggle(string userId)
		{
			SetMuted(userId, !IsMuted(userId));
		}

		private static void Load()
		{
			if (_loaded)
			{
				return;
			}
			_loaded = true;
			string text = PlayerPrefs.GetString(Key, "");
			if (string.IsNullOrEmpty(text))
			{
				return;
			}
			string[] array = text.Split(',');
			foreach (string text2 in array)
			{
				if (!string.IsNullOrEmpty(text2) && Set.Add(text2))
				{
					Order.Add(text2);
				}
			}
		}
	}
}
