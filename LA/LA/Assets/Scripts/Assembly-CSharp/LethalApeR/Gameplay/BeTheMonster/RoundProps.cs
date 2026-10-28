using System;
using System.Collections.Generic;
using System.Linq;
using ExitGames.Client.Photon;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class RoundProps
	{
		private const string RoundActive = "ra";

		private const string StartTime = "st";

		private const string EndTime = "et";

		private const string RoundDuration = "rd";

		private const string PrepDuration = "pd";

		private const string ActivePlayers = "ap";

		private const string CurrentMonsters = "cm";

		private const string OriginalMonsters = "om";

		private const string OriginalActives = "oap";

		private const string PoweredGenerators = "gp";

		public const string PoweredGeneratorsKey = "gp";

		public const string GeneratorProgressKey = "gpp";

		private const string GeneratorSpawnPoints = "gsp";

		private const string EscapedPlayers = "esc";

		private const string CurrentMap = "m";

		private const string Queue = "queue";

		private const string MonsterTurnIds = "mti";

		private const string MonsterTurnCounts = "mtn";

		private static readonly string[] VoteMapKeys = new string[6] { "vm0", "vm1", "vm2", "vm3", "vm4", "vm5" };

		public static int MaxVoteMaps => VoteMapKeys.Length;

		public static bool TryRead(out RoundProperties props)
		{
			props = default(RoundProperties);
			if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
			{
				return false;
			}
			Hashtable ht = PhotonNetwork.CurrentRoom.CustomProperties;
			props.queue = Get(ht, "queue", "");
			props.currentMap = Get(ht, "m", "");
			props.roundActive = Get(ht, "ra", false);
			props.startTime = Get(ht, "st", 0.0);
			props.endTime = Get(ht, "et", 0.0);
			props.roundDuration = Get(ht, "rd", 0);
			props.prepDuration = Get(ht, "pd", 0f);
			props.activePlayers = GetIntArray(ht, "ap");
			props.currentMonsters = GetIntArray(ht, "cm");
			props.originalMonsters = GetIntArray(ht, "om");
			props.originalActivePlayers = GetIntArray(ht, "oap");
			props.poweredGenerators = Get(ht, "gp", 0);
			props.generatorProgress = GetIntArray(ht, "gpp");
			props.generatorSpawnPoints = GetIntArray(ht, "gsp");
			props.escapedPlayers = GetIntArray(ht, "esc");
			return true;
		}

		public static void Write(RoundProperties props)
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Hashtable ht = PhotonNetwork.CurrentRoom.CustomProperties;
				ht["ra"] = props.roundActive;
				ht["st"] = props.startTime;
				ht["et"] = props.endTime;
				ht["rd"] = props.roundDuration;
				ht["pd"] = props.prepDuration;
				ht["ap"] = props.activePlayers ?? Array.Empty<int>();
				ht["cm"] = props.currentMonsters ?? Array.Empty<int>();
				ht["om"] = props.originalMonsters ?? Array.Empty<int>();
				ht["oap"] = props.originalActivePlayers ?? Array.Empty<int>();
				ht["gp"] = props.poweredGenerators;
				ht["gpp"] = ToProgressBytes(props.generatorProgress);
				ht["gsp"] = props.generatorSpawnPoints ?? Array.Empty<int>();
				ht["esc"] = props.escapedPlayers ?? Array.Empty<int>();
				ht["m"] = props.currentMap ?? "";
				PhotonNetwork.CurrentRoom.SetCustomProperties(ht);
			}
		}

		private static byte[] ToProgressBytes(int[] progress)
		{
			if (progress == null || progress.Length == 0)
			{
				return Array.Empty<byte>();
			}
			byte[] result = new byte[progress.Length];
			for (int i = 0; i < progress.Length; i++)
			{
				result[i] = (byte)Mathf.Clamp(progress[i], 0, 100);
			}
			return result;
		}

		public static double StartRound(int durationSeconds, float prepSeconds, int[] monsters, int[] activePlayers = null, string map = "", int[] generatorSpawnPoints = null, IDictionary<string, int> monsterTurns = null)
		{
			Hashtable ht = PhotonNetwork.CurrentRoom.CustomProperties;
			if (monsterTurns != null)
			{
				ht["mti"] = monsterTurns.Keys.ToArray();
				ht["mtn"] = monsterTurns.Values.ToArray();
			}
			double time = PhotonNetwork.Time;
			ht["ra"] = true;
			ht["st"] = time;
			ht["et"] = 0;
			ht["rd"] = durationSeconds;
			ht["pd"] = Mathf.Max(0f, prepSeconds);
			ht["ap"] = activePlayers ?? Array.Empty<int>();
			ht["cm"] = monsters ?? Array.Empty<int>();
			ht["om"] = monsters ?? Array.Empty<int>();
			ht["oap"] = activePlayers ?? Array.Empty<int>();
			ht["gp"] = 0;
			ht["gpp"] = Array.Empty<byte>();
			ht["gsp"] = generatorSpawnPoints ?? Array.Empty<int>();
			ht["esc"] = Array.Empty<int>();
			ht["m"] = map ?? "";
			PhotonNetwork.CurrentRoom.SetCustomProperties(ht);
			return time;
		}

		public static double GetRemainingTime()
		{
			if (!TryRead(out var p) || !p.roundActive || p.roundDuration <= 0)
			{
				return 0.0;
			}
			return Math.Clamp(PlayStartTime(in p) + (double)p.roundDuration - PhotonNetwork.Time, 0.0, p.roundDuration);
		}

		public static double PlayStartTime(in RoundProperties p)
		{
			return p.startTime + (double)Math.Max(0f, p.prepDuration);
		}

		public static float PrepRemaining(in RoundProperties p)
		{
			if (!p.roundActive)
			{
				return 0f;
			}
			return (float)Math.Max(0.0, PlayStartTime(in p) - PhotonNetwork.Time);
		}

		public static double GetRemainingIntermissionDuration()
		{
			if (!TryRead(out var p) || p.roundActive)
			{
				return 0.0;
			}
			return Mathf.Max(0f, Mathf.Ceil((float)(p.endTime + (double)BTMGameManager.Instance.roomSettings.intermissionDuration - PhotonNetwork.Time)));
		}

		public static bool IsVotingActive()
		{
			if (!TryRead(out var p) || p.roundActive)
			{
				return false;
			}
			RoundSettings settings = BTMGameManager.Instance.roomSettings;
			double votingStart = p.endTime + (double)settings.intermissionDuration;
			if (PhotonNetwork.Time < votingStart)
			{
				return false;
			}
			return PhotonNetwork.Time < votingStart + (double)settings.mapVotingDuration;
		}

		public static double GetRemainingVotingDuration()
		{
			if (!TryRead(out var p) || p.roundActive)
			{
				return 0.0;
			}
			RoundSettings settings = BTMGameManager.Instance.roomSettings;
			double votingStart = p.endTime + (double)settings.intermissionDuration;
			if (PhotonNetwork.Time < votingStart)
			{
				return 0.0;
			}
			double votingEnd = votingStart + (double)settings.mapVotingDuration;
			if (PhotonNetwork.Time >= votingEnd)
			{
				return 0.0;
			}
			return Mathf.Max(0f, Mathf.Ceil((float)(votingEnd - PhotonNetwork.Time)));
		}

		public static bool IsPrivateRound()
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				return !PhotonNetwork.CurrentRoom.IsVisible;
			}
			return false;
		}

		public static string[] GetVotingMaps()
		{
			if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
			{
				return Array.Empty<string>();
			}
			Hashtable ht = PhotonNetwork.CurrentRoom.CustomProperties;
			List<string> maps = new List<string>(VoteMapKeys.Length);
			string[] voteMapKeys = VoteMapKeys;
			foreach (string key in voteMapKeys)
			{
				string mapId = Get(ht, key, "");
				if (!string.IsNullOrEmpty(mapId))
				{
					maps.Add(mapId);
				}
			}
			return maps.ToArray();
		}

		public static void SetVotingMaps(string[] mapIds)
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Hashtable ht = new Hashtable();
				for (int i = 0; i < VoteMapKeys.Length; i++)
				{
					ht[VoteMapKeys[i]] = ((mapIds != null && i < mapIds.Length) ? mapIds[i] : "");
				}
				PhotonNetwork.CurrentRoom.SetCustomProperties(ht);
			}
		}

		public static void ClearVotingMaps()
		{
			SetVotingMaps(null);
		}

		private static T Get<T>(Hashtable ht, string key, T fallback)
		{
			if (ht != null && ht.TryGetValue(key, out var value) && value is T result)
			{
				return result;
			}
			return fallback;
		}

		private static int[] GetIntArray(Hashtable ht, string key)
		{
			if (ht != null && ht.TryGetValue(key, out var value) && value != null)
			{
				if (value is int[] ints)
				{
					return ints;
				}
				if (value is byte[] bytes)
				{
					int[] result = new int[bytes.Length];
					for (int i = 0; i < bytes.Length; i++)
					{
						result[i] = bytes[i];
					}
					return result;
				}
			}
			return Array.Empty<int>();
		}

		public static void WriteTeams(int[] activePlayers, int[] currentMonsters = null, int[] escapedPlayers = null)
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Hashtable ht = new Hashtable();
				if (activePlayers != null)
				{
					ht["ap"] = activePlayers;
				}
				if (currentMonsters != null)
				{
					ht["cm"] = currentMonsters;
				}
				if (escapedPlayers != null)
				{
					ht["esc"] = escapedPlayers;
				}
				if (ht.Count > 0)
				{
					PhotonNetwork.CurrentRoom.SetCustomProperties(ht);
				}
			}
		}

		public static Dictionary<string, int> ReadMonsterTurns()
		{
			Dictionary<string, int> turns = new Dictionary<string, int>(StringComparer.Ordinal);
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Hashtable ht = PhotonNetwork.CurrentRoom.CustomProperties;
				string[] ids = Get<string[]>(ht, "mti", null);
				int[] counts = GetIntArray(ht, "mtn");
				if (ids != null)
				{
					for (int i = 0; i < ids.Length && i < counts.Length; i++)
					{
						if (!string.IsNullOrEmpty(ids[i]))
						{
							turns[ids[i]] = Math.Max(0, counts[i]);
						}
					}
				}
			}
			return turns;
		}

		public static void OpenLobbyClock()
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				PhotonNetwork.CurrentRoom.SetCustomProperties(new Hashtable { { "et", PhotonNetwork.Time } });
			}
		}
	}
}
