using System;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	public static class AgProps
	{
		private const string Phase = "agph";

		private const string RoundIndex = "agrn";

		private const string MatchStamp = "agms";

		private const string StartTime = "agst";

		private const string EndTime = "aget";

		private const string Alive = "agap";

		private const string Eliminated = "agel";

		private const string Escaped = "ages";

		private const string Seekers = "agsk";

		private const string TowerA = "agtw";

		private const string RevivesUsed = "agru";

		private const string ReviveQueue = "agrq";

		private const string GlassMask = "aggm";

		private const string RoundSeed = "agsd";

		private const string PoweredGenerators = "aggp";

		private const string GeneratorProgress = "aggr";

		private const string CatchCount = "agct";

		private const string LightState = "aglt";

		private const string LightStamp = "aglts";

		private const string ChaseActor = "agch";

		private const string Queue = "queue";

		public const string PoweredGeneratorsKey = "aggp";

		public const string GeneratorProgressKey = "aggr";

		public const string CatchCountKey = "agct";

		public const string LightStateKey = "aglt";

		public const string LightStampKey = "aglts";

		public const string ChaseActorKey = "agch";

		public static bool TryRead(out AgRoundProperties p)
		{
			p = new AgRoundProperties();
			if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
			{
				return false;
			}
			Hashtable ht = PhotonNetwork.CurrentRoom.CustomProperties;
			p.queue = Get(ht, Queue, "");
			p.phase = (AgPhase)Get<byte>(ht, Phase, 0);
			p.round = Get<byte>(ht, RoundIndex, 0);
			p.matchStamp = Get(ht, MatchStamp, 0.0);
			p.startTime = Get(ht, StartTime, 0.0);
			p.endTime = Get(ht, EndTime, 0.0);
			p.alive = GetIntArray(ht, Alive);
			p.eliminated = GetIntArray(ht, Eliminated);
			p.escaped = GetIntArray(ht, Escaped);
			p.seekers = GetIntArray(ht, Seekers);
			p.towerA = GetIntArray(ht, TowerA);
			p.revivesUsed = GetIntArray(ht, RevivesUsed);
			p.reviveQueue = GetIntArray(ht, ReviveQueue);
			p.glassMask = Get(ht, GlassMask, 0);
			p.roundSeed = Get(ht, RoundSeed, 0);
			p.poweredGenerators = Get(ht, PoweredGenerators, 0);
			p.generatorProgress = GetIntArray(ht, GeneratorProgress);
			p.catchCount = Get(ht, CatchCount, 0);
			p.lightState = Get<byte>(ht, LightState, 0);
			p.lightStamp = Get(ht, LightStamp, 0.0);
			p.chaseActor = Get(ht, ChaseActor, 0);
			return true;
		}

		public static double GetRemaining(AgRoundProperties p)
		{
			if (p == null)
			{
				return 0.0;
			}
			if (p.endTime == 0.0)
			{
				return double.PositiveInfinity;
			}
			return Math.Max(0.0, p.endTime - PhotonNetwork.Time);
		}

		public static double WritePhase(AgRoundProperties p, double durationSeconds)
		{
			double time = PhotonNetwork.Time;
			p.startTime = time;
			p.endTime = ((durationSeconds > 0.0) ? (time + durationSeconds) : 0.0);
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
			{
				return time;
			}
			Hashtable hashtable = new Hashtable();
			hashtable[Phase] = (byte)p.phase;
			hashtable[RoundIndex] = (byte)Mathf.Clamp(p.round, 0, 255);
			hashtable[MatchStamp] = p.matchStamp;
			hashtable[StartTime] = p.startTime;
			hashtable[EndTime] = p.endTime;
			hashtable[Alive] = p.alive ?? Array.Empty<int>();
			hashtable[Eliminated] = p.eliminated ?? Array.Empty<int>();
			hashtable[Escaped] = p.escaped ?? Array.Empty<int>();
			hashtable[Seekers] = p.seekers ?? Array.Empty<int>();
			hashtable[TowerA] = p.towerA ?? Array.Empty<int>();
			hashtable[RevivesUsed] = p.revivesUsed ?? Array.Empty<int>();
			hashtable[ReviveQueue] = p.reviveQueue ?? Array.Empty<int>();
			hashtable[GlassMask] = p.glassMask;
			hashtable[RoundSeed] = p.roundSeed;
			hashtable[PoweredGenerators] = p.poweredGenerators;
			hashtable[GeneratorProgress] = ToProgressBytes(p.generatorProgress);
			hashtable[CatchCount] = p.catchCount;
			hashtable[LightState] = p.lightState;
			hashtable[LightStamp] = p.lightStamp;
			hashtable[ChaseActor] = p.chaseActor;
			PhotonNetwork.CurrentRoom.SetCustomProperties(hashtable);
			return time;
		}

		public static void WriteAlive(int[] alive, int[] eliminated = null, int[] escaped = null)
		{
			WriteTeams(alive, eliminated, escaped);
		}

		public static void WriteTeams(int[] alive = null, int[] eliminated = null, int[] escaped = null, int[] seekers = null, int[] towerA = null, int[] reviveQueue = null, int[] revivesUsed = null)
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
			{
				return;
			}
			Hashtable hashtable = new Hashtable();
			if (alive != null)
			{
				hashtable[Alive] = alive;
			}
			if (eliminated != null)
			{
				hashtable[Eliminated] = eliminated;
			}
			if (escaped != null)
			{
				hashtable[Escaped] = escaped;
			}
			if (seekers != null)
			{
				hashtable[Seekers] = seekers;
			}
			if (towerA != null)
			{
				hashtable[TowerA] = towerA;
			}
			if (reviveQueue != null)
			{
				hashtable[ReviveQueue] = reviveQueue;
			}
			if (revivesUsed != null)
			{
				hashtable[RevivesUsed] = revivesUsed;
			}
			if (hashtable.Count > 0)
			{
				PhotonNetwork.CurrentRoom.SetCustomProperties(hashtable);
			}
		}

		public static void WriteLight(byte state, double stamp)
		{
			if (PhotonNetwork.IsConnectedAndReady && PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				Hashtable hashtable = new Hashtable();
				hashtable[LightState] = state;
				hashtable[LightStamp] = stamp;
				currentRoom.SetCustomProperties(hashtable);
			}
		}

		public static void WriteChase(int actor)
		{
			if (PhotonNetwork.IsConnectedAndReady && PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				Hashtable hashtable = new Hashtable();
				hashtable[ChaseActor] = actor;
				currentRoom.SetCustomProperties(hashtable);
			}
		}

		public static byte[] ToProgressBytes(int[] progress)
		{
			if (progress == null || progress.Length == 0)
			{
				return Array.Empty<byte>();
			}
			byte[] array = new byte[progress.Length];
			for (int i = 0; i < progress.Length; i++)
			{
				array[i] = (byte)Mathf.Clamp(progress[i], 0, 100);
			}
			return array;
		}

		private static T Get<T>(Hashtable ht, string key, T fallback)
		{
			if (ht != null && ht.TryGetValue(key, out object value) && value is T)
			{
				return (T)value;
			}
			return fallback;
		}

		private static int[] GetIntArray(Hashtable ht, string key)
		{
			if (ht != null && ht.TryGetValue(key, out object value) && value != null)
			{
				if (value is int[] result)
				{
					return result;
				}
				if (value is byte[] array)
				{
					int[] array2 = new int[array.Length];
					for (int i = 0; i < array.Length; i++)
					{
						array2[i] = array[i];
					}
					return array2;
				}
			}
			return Array.Empty<int>();
		}
	}
}
