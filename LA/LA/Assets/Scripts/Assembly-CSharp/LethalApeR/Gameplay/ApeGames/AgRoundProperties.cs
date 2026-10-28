using System;
using System.Reflection;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoundProperties
	{
		public string queue = "";

		public AgPhase phase;

		public int round;

		public double matchStamp;

		public double startTime;

		public double endTime;

		public int[] alive = Array.Empty<int>();

		public int[] eliminated = Array.Empty<int>();

		public int[] escaped = Array.Empty<int>();

		public int[] seekers = Array.Empty<int>();

		public int[] towerA = Array.Empty<int>();

		public int[] revivesUsed = Array.Empty<int>();

		public int[] reviveQueue = Array.Empty<int>();

		public int glassMask;

		public int roundSeed;

		public int poweredGenerators;

		public int catchCount;

		public int[] generatorProgress = Array.Empty<int>();

		public byte lightState;

		public double lightStamp;

		public int chaseActor;

		public bool AliveContains(int actor)
		{
			return Contains(alive, actor);
		}

		public bool EliminatedContains(int actor)
		{
			return Contains(eliminated, actor);
		}

		public bool EscapedContains(int actor)
		{
			return Contains(escaped, actor);
		}

		public bool SeekersContains(int actor)
		{
			return Contains(seekers, actor);
		}

		public bool TowerAContains(int actor)
		{
			return Contains(towerA, actor);
		}

		public bool ReviveQueueContains(int actor)
		{
			return Contains(reviveQueue, actor);
		}

		public bool RevivesUsedContains(int actor)
		{
			return Contains(revivesUsed, actor);
		}

		private static bool Contains(int[] a, int v)
		{
			if (a == null)
			{
				return false;
			}
			for (int i = 0; i < a.Length; i++)
			{
				if (a[i] == v)
				{
					return true;
				}
			}
			return false;
		}
	}
}
