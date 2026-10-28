using System;
using System.Collections.Generic;
using LethalApeR.Gameplay.Monsters;
using LethalApeR.Quests;
using LethalApeR.UI.Notifications;
using UnityEngine;

namespace LethalApeR.MonsterIndex
{
	public static class MonsterIndexProgress
	{
		[Serializable]
		private sealed class SaveData
		{
			public List<string> found = new List<string>();
		}

		private const string Key = "MonsterIndex.v1";

		private const string Salt = "slop.monsterindex.4b81d2";

		private static readonly HashSet<string> Found = new HashSet<string>(StringComparer.Ordinal);

		private static SaveData _data;

		public static int FoundCount
		{
			get
			{
				EnsureLoaded();
				MonsterIndexCatalog instance = MonsterIndexCatalog.Instance;
				if (instance == null)
				{
					return 0;
				}
				int num = 0;
				MonsterIndexCatalog.Entry[] entries = instance.entries;
				foreach (MonsterIndexCatalog.Entry entry in entries)
				{
					if (entry.IsOpen && Found.Contains(entry.id))
					{
						num++;
					}
				}
				return num;
			}
		}

		public static int Total
		{
			get
			{
				if (!(MonsterIndexCatalog.Instance != null))
				{
					return 0;
				}
				return MonsterIndexCatalog.Instance.Count;
			}
		}

		public static event Action<string> Added;

		public static event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			QuestEvents.LocalPlayerJumpscared -= OnJumpscared;
			QuestEvents.LocalPlayerJumpscared += OnJumpscared;
			QuestEvents.LocalPlayerJumpscaredBy -= Discover;
			QuestEvents.LocalPlayerJumpscaredBy += Discover;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			QuestEvents.LocalPlayerJumpscared -= OnJumpscared;
			QuestEvents.LocalPlayerJumpscaredBy -= Discover;
			MonsterIndexProgress.Added = null;
			MonsterIndexProgress.Changed = null;
			Found.Clear();
			_data = null;
		}

		public static bool IsFound(string id)
		{
			EnsureLoaded();
			if (id != null)
			{
				return Found.Contains(id);
			}
			return false;
		}

		private static void OnJumpscared(BaseMonster monster)
		{
			if (monster != null)
			{
				Discover(monster.name);
			}
		}

		public static void Discover(string monsterName)
		{
			MonsterIndexCatalog instance = MonsterIndexCatalog.Instance;
			if (string.IsNullOrEmpty(monsterName) || instance == null)
			{
				return;
			}
			MonsterIndexCatalog.Entry entry = instance.Find(monsterName);
			if (entry != null && Add(entry.id))
			{
				HandNotifications.Show(NotificationKind.Reward, "Monster Index", string.Format("{0} added to your index. {1} / {2}", entry.displayName, FoundCount, Total), 5f);
			}
		}

		private static bool Add(string id)
		{
			EnsureLoaded();
			bool num = Found.Add(id);
			if (num)
			{
				_data.found.Add(id);
				Save();
				MonsterIndexProgress.Added?.Invoke(id);
				MonsterIndexProgress.Changed?.Invoke();
			}
			return num;
		}

		public static void DevUnlockAll()
		{
			if (!Debug.isDebugBuild)
			{
				return;
			}
			MonsterIndexCatalog instance = MonsterIndexCatalog.Instance;
			if (!(instance == null))
			{
				MonsterIndexCatalog.Entry[] entries = instance.entries;
				foreach (MonsterIndexCatalog.Entry entry in entries)
				{
					Add(entry.id);
				}
			}
		}

		public static void DevReset()
		{
			if (Debug.isDebugBuild)
			{
				EnsureLoaded();
				Found.Clear();
				_data.found.Clear();
				PlayerPrefs.DeleteKey(Key);
				PlayerPrefs.DeleteKey(Key + ".s");
				PlayerPrefs.Save();
				MonsterIndexProgress.Changed?.Invoke();
			}
		}

		private static void EnsureLoaded()
		{
			if (_data != null)
			{
				return;
			}
			_data = Load();
			Found.Clear();
			foreach (string item in _data.found)
			{
				if (!string.IsNullOrEmpty(item))
				{
					Found.Add(item);
				}
			}
		}

		private static SaveData Load()
		{
			string json = PlayerPrefs.GetString(Key, string.Empty);
			if (!string.IsNullOrEmpty(json))
			{
				try
				{
					if (PlayerPrefs.GetString(Key + ".s", string.Empty) == Seal(json))
					{
						SaveData saveData = JsonUtility.FromJson<SaveData>(json);
						if (saveData != null && saveData.found != null)
						{
							return saveData;
						}
					}
					else
					{
						Debug.LogWarning("[Monster Index] Save failed its seal check; starting fresh.");
					}
				}
				catch (Exception ex)
				{
					Debug.LogWarning("[Monster Index] Save is unreadable (" + ex.Message + "); starting fresh.");
				}
			}
			return new SaveData();
		}

		private static void Save()
		{
			string text = JsonUtility.ToJson(_data);
			PlayerPrefs.SetString(Key, text);
			PlayerPrefs.SetString(Key + ".s", Seal(text));
			PlayerPrefs.Save();
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
