using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay
{
	public static class FeatureGates
	{
		private static readonly Dictionary<string, bool> Gates = new Dictionary<string, bool>(StringComparer.Ordinal);

		public static int Version { get; private set; }

		public static event Action Changed;

		public static bool IsOpen(string key)
		{
			if (string.IsNullOrEmpty(key))
			{
				return true;
			}
			bool value;
			return Gates.TryGetValue(key, out value) && value;
		}

		public static void Set(string key, bool open)
		{
			if (!string.IsNullOrEmpty(key) && (!Gates.TryGetValue(key, out var value) || value != open))
			{
				Gates[key] = open;
				Version++;
				Changed?.Invoke();
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Gates.Clear();
			Changed = null;
			Version = 0;
		}
	}
}
