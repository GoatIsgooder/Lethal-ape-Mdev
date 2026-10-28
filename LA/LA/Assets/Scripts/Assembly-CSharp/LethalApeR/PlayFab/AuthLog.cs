using System.Diagnostics;
using UnityEngine;

namespace LethalApeR.PlayFab
{
	internal static class AuthLog
	{
		[Conditional("UNITY_EDITOR")]
		public static void Info(string message)
		{
			UnityEngine.Debug.Log(message);
		}

		[Conditional("UNITY_EDITOR")]
		public static void Error(string message)
		{
			UnityEngine.Debug.LogError(message);
		}

		public static void Device(string message)
		{
			UnityEngine.Debug.Log(message);
		}

		public static void DeviceError(string message)
		{
			UnityEngine.Debug.LogError(message);
		}

		public static string Fingerprint(string id)
		{
			if (string.IsNullOrEmpty(id))
			{
				return "<none>";
			}
			uint num = 2166136261u;
			foreach (char c in id)
			{
				num = (num ^ c) * 16777619;
			}
			return num.ToString("x8");
		}
	}
}
