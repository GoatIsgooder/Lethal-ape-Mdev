using System;
using System.Collections;
using ExitGames.Client.Photon;
using Photon.Realtime;
using Hashtable = ExitGames.Client.Photon.Hashtable;

namespace LethalApeR.Networking
{
	public static class CrossplayProfiles
	{
		public const string SharedAppVersion = "ag-xplay-1";

		public const string ApeGamesQueue = "ApeGames";

		public const string FnafQueue = "FNAF";

		public static readonly CrossplayProfile ApeGames = new CrossplayProfile(CrossplayMode.ApeGames, "ApeGames", "ag-xplay-1", 100, MatchmakingMode.RandomMatching);

		public static readonly CrossplayProfile Fnaf = new CrossplayProfile(CrossplayMode.Fnaf, "FNAF", "fn-xplay-1", 30, MatchmakingMode.FillRoom);

		public static CrossplayProfile Get(CrossplayMode mode)
		{
			return mode switch
			{
				CrossplayMode.ApeGames => ApeGames,
				CrossplayMode.Fnaf => Fnaf,
				_ => null,
			};
		}

		public static Hashtable HubFilter(CrossplayProfile p)
		{
			return new Hashtable
			{
				{ "queue", p.Queue },
				{ "version", p.RoomVersion },
				{ "antiunity", "Okay" },
				{ "yr", "2025" }
			};
		}

		public static string[] HubLobbyKeys()
		{
			return new string[4] { "queue", "version", "antiunity", "yr" };
		}

		public static string PrivateRoomName(CrossplayProfile p, string roomName)
		{
			return roomName + "_" + p.RoomVersion;
		}

		public static string UnsaltedRoomName(CrossplayProfile p, string roomName)
		{
			if (string.IsNullOrEmpty(roomName))
			{
				return roomName;
			}
			string text = "_" + p.RoomVersion;
			if (roomName.EndsWith(text, StringComparison.Ordinal))
			{
				return roomName.Substring(0, roomName.Length - text.Length);
			}
			return roomName;
		}

		public static Hashtable PrivateRoomProperties(CrossplayProfile p, Hashtable extra)
		{
			Hashtable hashtable = new Hashtable
			{
				{ "queue", p.Queue },
				{ "version", p.RoomVersion }
			};
			if (extra != null)
			{
				foreach (DictionaryEntry item in extra)
				{
					hashtable[item.Key] = item.Value;
				}
			}
			return hashtable;
		}
	}
}
