using System.Diagnostics;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnProps
	{
		public const string Queue = "queue";

		public const string Version = "version";

		public const string Kind = "fnKind";

		public const string Party = "fnPty";

		public const string PadPrefix = "fnPd";

		public const string Night = "fnN";

		public const string Difficulty = "fnDf";

		public const string TeamSize = "fnTS";

		public const string Roster = "fnRos";

		public const string Phase = "fnPh";

		public const string PhaseStart = "fnPS";

		public const string PhaseEnd = "fnPE";

		public const string NightStart = "fnNS";

		public const string HourSeconds = "fnHs";

		public const string ArrivedCount = "fnAC";

		public const string GuardActors = "fnGA";

		public const string GuardNames = "fnGN";

		public const string GuardBuilds = "fnGB";

		public const string GuardStatus = "fnGS";

		public const string GuardTimes = "fnGT";

		public const string Power = "fnPw";

		public const string PowerStamp = "fnPwT";

		public const string PowerRate = "fnPwR";

		public const string Blackout = "fnBo";

		public const string BlackoutEnd = "fnBoE";

		public const string Doors = "fnDr";

		public const string Jams = "fnDj";

		public const string Lights = "fnLt";

		public const string LureReady = "fnLr";

		public const string FuseUses = "fnFz";

		public const string FuseOrder = "fnFzO";

		public const string FuseProgress = "fnFzP";

		public const string BatteryStates = "fnBtS";

		public const string BatteryArgs = "fnBtA";

		public const string BatteryDrops = "fnBtD";

		public const string BatteriesDelivered = "fnBtN";

		public const string AnimPrefix = "fnA";

		public const string Outcome = "fnOut";

		public const string Highest = "fnHi";

		public const string HighestNightmare = "fnHiN";

		public const string Arrived = "fnTm";

		public const string Camera = "fnCam";

		public const string Flashlight = "fnFl";

		public const string Build = "Build";

		private static readonly string[] PadKeys = BuildKeys("fnPd", 16);

		private static readonly string[] AnimKeys = BuildKeys("fnA", 4);

		public static Hashtable RoomProps => (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null) ? PhotonNetwork.CurrentRoom.CustomProperties : null;

		public static string PadKey(int pad)
		{
			if (pad >= 0 && pad < PadKeys.Length)
			{
				return PadKeys[pad];
			}
			return "fnPd" + pad;
		}

		public static string AnimKey(int anim)
		{
			return AnimKeys[anim];
		}

		private static string[] BuildKeys(string prefix, int count)
		{
			string[] array = new string[count];
			for (int i = 0; i < count; i++)
			{
				array[i] = prefix + i;
			}
			return array;
		}

		public static FnRoomKind CurrentRoomKind()
		{
			Hashtable roomProps = RoomProps;
			if (roomProps == null)
			{
				return FnRoomKind.None;
			}
			if (!roomProps.TryGetValue("queue", out object value) || !(value is string text) || text != "FNAF")
			{
				return FnRoomKind.None;
			}
			return (GetByte(roomProps, "fnKind") == 1) ? FnRoomKind.Night : FnRoomKind.Hub;
		}

		public static byte GetByte(Hashtable h, string key, byte fallback = 0)
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				if (value is byte b)
				{
					return b;
				}
				if (value is int num)
				{
					return (byte)num;
				}
				if (value is short num2)
				{
					return (byte)num2;
				}
				if (value is sbyte b2)
				{
					return (byte)b2;
				}
				if (value is bool flag)
				{
					return (byte)(flag ? 1 : 0);
				}
			}
			return fallback;
		}

		public static byte CameraWire(int station)
		{
			return (byte)((station >= 0 && station <= 254) ? station : 255);
		}

		public static sbyte GetSByte(Hashtable h, string key, sbyte fallback = 0)
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				if (value is sbyte result)
				{
					return result;
				}
				if (value is byte b)
				{
					return (sbyte)b;
				}
				if (value is int num)
				{
					return (sbyte)num;
				}
				if (value is short num2)
				{
					return (sbyte)num2;
				}
			}
			return fallback;
		}

		public static int GetInt(Hashtable h, string key, int fallback = 0)
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				if (value is int result)
				{
					return result;
				}
				if (value is byte b)
				{
					return b;
				}
				if (value is short num)
				{
					return num;
				}
				if (value is long num2)
				{
					return (int)num2;
				}
			}
			return fallback;
		}

		public static float GetFloat(Hashtable h, string key, float fallback = 0f)
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				if (value is float result)
				{
					return result;
				}
				if (value is double num)
				{
					return (float)num;
				}
				if (value is int num2)
				{
					return num2;
				}
			}
			return fallback;
		}

		public static double GetDouble(Hashtable h, string key, double fallback = 0.0)
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				if (value is double result)
				{
					return result;
				}
				if (value is float num)
				{
					return num;
				}
				if (value is int num2)
				{
					return num2;
				}
			}
			return fallback;
		}

		public static bool GetBool(Hashtable h, string key, bool fallback = false)
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				if (value is bool result)
				{
					return result;
				}
				if (value is byte b)
				{
					return b != 0;
				}
				if (value is int num)
				{
					return num != 0;
				}
			}
			return fallback;
		}

		public static string GetString(Hashtable h, string key, string fallback = "")
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				return (value as string) ?? fallback;
			}
			return fallback;
		}

		public static T GetArray<T>(Hashtable h, string key) where T : class
		{
			if (h != null && h.TryGetValue(key, out object value))
			{
				return value as T;
			}
			return null;
		}

		public static byte PlayerByte(Player p, string key, byte fallback = 0)
		{
			if (p == null)
			{
				return fallback;
			}
			return GetByte(p.CustomProperties, key, fallback);
		}

		public static sbyte PlayerSByte(Player p, string key, sbyte fallback = 0)
		{
			if (p == null)
			{
				return fallback;
			}
			return GetSByte(p.CustomProperties, key, fallback);
		}

		public static bool PlayerBool(Player p, string key)
		{
			if (p == null)
			{
				return false;
			}
			return GetBool(p.CustomProperties, key);
		}

		public static string PlayerString(Player p, string key)
		{
			if (p == null)
			{
				return "";
			}
			return GetString(p.CustomProperties, key, "");
		}

		public static bool WriteRoom(Hashtable changed)
		{
			if (changed == null || changed.Count == 0 || !PhotonNetwork.InRoom || !PhotonNetwork.IsConnectedAndReady)
			{
				return false;
			}
			return PhotonNetwork.CurrentRoom.SetCustomProperties(changed);
		}

		public static void WriteLocal(Hashtable changed)
		{
			if (changed != null && changed.Count != 0 && PhotonNetwork.LocalPlayer != null)
			{
				PhotonNetwork.LocalPlayer.SetCustomProperties(changed);
			}
		}

		[Conditional("UNITY_EDITOR")]
		[Conditional("DEVELOPMENT_BUILD")]
		private static void CheckWireTypes(Hashtable changed)
		{
			foreach (System.Collections.DictionaryEntry item in changed)
			{
				object value = item.Value;
				if (value != null && !(value is byte) && !(value is bool) && !(value is short) && !(value is int) && !(value is long) && !(value is float) && !(value is double) && !(value is string) && !(value is byte[]) && !(value is int[]) && !(value is float[]) && !(value is string[]) && !(value is bool[]) && !(value is short[]) && !(value is long[]) && !(value is double[]) && !(value is Hashtable) && !(value is object[]))
				{
					// RE: unsure - Type member read via vtable slot 8 assumed to be Name
					UnityEngine.Debug.LogError(string.Format("[FnProps] '{0}' is a {1}: Photon can't serialize it, and it would break the next room join.", item.Key, value.GetType().Name));
				}
			}
		}
	}
}
