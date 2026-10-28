using System;
using System.Text;
using LethalApeR.Gameplay;
using UnityEngine;

namespace LethalApeR.MonsterIndex
{
	public sealed class MonsterIndexCatalog : ScriptableObject
	{
		[Serializable]
		public sealed class Entry
		{
			[Tooltip("MonsterIndexEntry.id: the save key. Never rename after release.")]
			public string id;

			public string displayName;

			[Tooltip("Key()s of the monster's names: its entry, its stand and every AI that plays it.")]
			public string[] keys = Array.Empty<string>();

			[Tooltip("FeatureGates key; closed = not in the index yet.")]
			public string featureGate;

			public bool IsOpen => FeatureGates.IsOpen(featureGate);
		}

		public const string ResourcePath = "Systems/MonsterIndexCatalog";

		public Entry[] entries = Array.Empty<Entry>();

		private static MonsterIndexCatalog _instance;

		private static bool _missingLogged;

		private static readonly (string from, string to)[] Aliases = new (string, string)[4]
		{
			("weeper", "weepingangel"),
			("mechanic", "robot"),
			("bmg", "bloodmoongus"),
			("centi", "centipede")
		};

		public static MonsterIndexCatalog Instance
		{
			get
			{
				if (_instance == null && !_missingLogged)
				{
					_instance = Resources.Load<MonsterIndexCatalog>(ResourcePath);
					if (_instance == null)
					{
						_missingLogged = true;
						Debug.LogWarning("[Monster Index] Resources/Systems/MonsterIndexCatalog is missing. Run Slop > Monster Index > Build Monster Index.");
					}
				}
				return _instance;
			}
		}

		public int Count
		{
			get
			{
				int num = 0;
				for (int i = 0; i < entries.Length; i++)
				{
					if (entries[i].IsOpen)
					{
						num++;
					}
				}
				return num;
			}
		}

		public Entry Find(string monsterName)
		{
			string text = Key(monsterName);
			if (text.Length == 0)
			{
				return null;
			}
			for (int i = 0; i < entries.Length; i++)
			{
				if (!entries[i].IsOpen)
				{
					continue;
				}
				string[] keys = entries[i].keys;
				for (int j = 0; j < keys.Length; j++)
				{
					if (keys[j] == text)
					{
						return entries[i];
					}
				}
			}
			return null;
		}

		public Entry Get(string id)
		{
			for (int i = 0; i < entries.Length; i++)
			{
				if (entries[i].id == id)
				{
					return entries[i];
				}
			}
			return null;
		}

		public static string Key(string name)
		{
			if (string.IsNullOrEmpty(name))
			{
				return string.Empty;
			}
			name = name.Replace("(Clone)", "");
			StringBuilder stringBuilder = new StringBuilder(name.Length);
			string text = name.ToLowerInvariant();
			foreach (char c in text)
			{
				if (c >= 'a' && c <= 'z')
				{
					stringBuilder.Append(c);
				}
			}
			string text2 = stringBuilder.ToString();
			if (text2.StartsWith("the", StringComparison.Ordinal) && text2.Length >= 6)
			{
				text2 = text2.Substring(3);
			}
			(string, string)[] aliases = Aliases;
			for (int i = 0; i < aliases.Length; i++)
			{
				var (text3, result) = aliases[i];
				if (text2 == text3)
				{
					return result;
				}
			}
			return text2;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
			_missingLogged = false;
		}
	}
}
