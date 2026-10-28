using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ExitGames.Client.Photon;
using Newtonsoft.Json.Linq;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace QauthSdk
{
	// A crossplay group, from GET api.qauth.wtf/crossplay/<group>
	public sealed class QauthCrossplayGroup
	{
		public string Group;
		public string Name;
		public List<string> Games = new List<string>();
		public string AppIdRealtime;
		public string AppIdVoice; // give this to Photon Voice yourself (PunVoiceClient settings)
		public string AppVersion; // every linked game must use exactly this, or Photon keeps them apart
		public int MaxPlayers;
		public Dictionary<string, string> RoomFilter = new Dictionary<string, string>(); // custom room properties every room of the group has
		public bool Ready; // false until the group has a shared Photon app
	}

	// Crossplay: players from different Qauth games in the same Photon rooms.
	//
	// Every game in a group connects to the group's shared Photon app with the group's version. That app's custom
	// authentication points at Qauth (/crossplay/<group>/photon/auth), which hands each sign-in to the player's own game,
	// so a player is checked by the game they're playing (logged in, not banned, matching Meta account).
	//
	//   var group = await QauthCrossplay.ConnectAsync("ape-games");   // leaves the game's own servers
	//   // in OnConnectedToMaster:
	//   QauthCrossplay.JoinMatch(group);                               // public room by the group's filter
	//   // leaving crossplay:
	//   await QauthCrossplay.ReturnAsync();                            // back to the game's own servers
	public static class QauthCrossplay
	{
		public static QauthCrossplayGroup Current { get; private set; }

		public static bool InCrossplay => Current != null;

		public static async Task<QauthCrossplayGroup> GetGroupAsync(string group)
		{
			QauthResponse r = await Qauth.GetPlatform("/crossplay/" + Uri.EscapeDataString(group));
			if (!r.Ok) throw new QauthException("crossplay group " + group, r);
			JObject j = r.Json;
			return new QauthCrossplayGroup
			{
				Group = r.Get("group", group),
				Name = r.Get("name", group),
				Games = (j["games"] as JArray)?.Values<string>().ToList() ?? new List<string>(),
				AppIdRealtime = r.Get("appIdRealtime", ""),
				AppIdVoice = r.Get("appIdVoice", ""),
				AppVersion = r.Get("appVersion", ""),
				MaxPlayers = r.Get("maxPlayers", 20),
				RoomFilter = (j["roomFilter"] as JObject)?.Properties().ToDictionary(p => p.Name, p => p.Value.ToString()) ?? new Dictionary<string, string>(),
				Ready = r.Get<bool>("ready"),
			};
		}

		// disconnect from the game's own Photon app and connect to the group's shared one (the project's Photon settings
		// asset isn't changed). Call JoinMatch or JoinCode once connected (OnConnectedToMaster).
		public static async Task<QauthCrossplayGroup> ConnectAsync(string group)
		{
			QauthCrossplayGroup g = await GetGroupAsync(group);
			string gameId = Qauth.Settings != null ? Qauth.Settings.gameId : "";
			if (!g.Ready) throw new InvalidOperationException("crossplay group " + group + " has no shared Photon app yet");
			if (!g.Games.Contains(gameId)) throw new InvalidOperationException("this game (" + gameId + ") isn't in crossplay group " + group);
			AuthenticationValues auth = await QauthPhoton.MakeAuthValuesAsync();
			if (auth == null) throw new InvalidOperationException("crossplay needs a Meta login");
			// the shared app always asks Qauth, and needs to know which game this player comes from
			auth.AuthType = CustomAuthenticationType.Custom;
			if (!auth.AuthGetParameters.Contains("token=")) auth.AddAuthParameter("token", Qauth.Token);
			auth.AddAuthParameter("game", gameId);
			// a copy, so the project's PhotonServerSettings asset never changes (GetCopy() isn't in every PUN 2 version)
			AppSettings settings = JsonUtility.FromJson<AppSettings>(JsonUtility.ToJson(PhotonNetwork.PhotonServerSettings.AppSettings));
			settings.AppIdRealtime = g.AppIdRealtime;
			if (!string.IsNullOrEmpty(g.AppIdVoice)) settings.AppIdVoice = g.AppIdVoice;
			settings.AppVersion = g.AppVersion;
			await Disconnect();
			PhotonNetwork.AuthValues = auth;
			Current = g;
			if (!PhotonNetwork.ConnectUsingSettings(settings)) throw new InvalidOperationException("Photon wouldn't start connecting");
			return g;
		}

		// a public room of the group: join one that matches the filter, or make it
		public static bool JoinMatch(QauthCrossplayGroup g = null)
		{
			g = g ?? Current ?? throw new InvalidOperationException("not in crossplay");
			Hashtable filter = Filter(g);
			return PhotonNetwork.JoinRandomOrCreateRoom(filter, 0, MatchmakingMode.FillRoom, null, null, null, Options(g, filter, true));
		}

		// a private room by code, shared by every game in the group: "K7Q2M" -> room "K7Q2M_ag-xplay-1"
		public static bool JoinCode(string code, QauthCrossplayGroup g = null)
		{
			g = g ?? Current ?? throw new InvalidOperationException("not in crossplay");
			return PhotonNetwork.JoinOrCreateRoom(RoomName(code, g), Options(g, Filter(g), false), TypedLobby.Default);
		}

		public static string RoomName(string code, QauthCrossplayGroup g) => code.Trim().ToUpperInvariant() + "_" + g.AppVersion;

		// the code shown to players: the room name without "_<version>"
		public static string CodeOf(string roomName)
		{
			int i = roomName?.LastIndexOf('_') ?? -1;
			return i > 0 ? roomName.Substring(0, i) : roomName;
		}

		// a random 5-character code (no 0/O/1/I/L, so it's easy to read out)
		public static string NewCode(int length = 5)
		{
			const string chars = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
			char[] c = new char[length];
			for (int i = 0; i < length; i++) c[i] = chars[UnityEngine.Random.Range(0, chars.Length)];
			return new string(c);
		}

		// leave the shared app and reconnect to the game's own Photon app (the settings asset, normal Qauth auth)
		public static async Task ReturnAsync()
		{
			Current = null;
			await Disconnect();
			await QauthPhoton.ConfigureAsync();
			PhotonNetwork.ConnectUsingSettings();
		}

		private static Hashtable Filter(QauthCrossplayGroup g)
		{
			Hashtable h = new Hashtable();
			foreach (KeyValuePair<string, string> kv in g.RoomFilter) h[kv.Key] = kv.Value;
			return h;
		}

		private static RoomOptions Options(QauthCrossplayGroup g, Hashtable props, bool visible)
		{
			return new RoomOptions
			{
				MaxPlayers = (byte)Mathf.Clamp(g.MaxPlayers, 2, 255),
				IsVisible = visible,
				CustomRoomProperties = props,
				CustomRoomPropertiesForLobby = props.Keys.Cast<object>().Select(k => k.ToString()).ToArray(),
			};
		}

		private static async Task Disconnect()
		{
			if (!PhotonNetwork.IsConnected) return;
			PhotonNetwork.Disconnect();
			for (int i = 0; i < 100 && PhotonNetwork.NetworkClientState != ClientState.Disconnected; i++) await Task.Delay(50);
		}
	}
}
