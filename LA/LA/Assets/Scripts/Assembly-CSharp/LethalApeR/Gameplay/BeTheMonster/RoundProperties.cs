using System;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Serializable]
	public struct RoundProperties
	{
		public string queue;

		public bool roundActive;

		public double startTime;

		public double endTime;

		public int roundDuration;

		public float prepDuration;

		public int[] activePlayers;

		public int[] currentMonsters;

		public int[] originalMonsters;

		public int[] originalActivePlayers;

		public int poweredGenerators;

		public int[] generatorProgress;

		public int[] generatorSpawnPoints;

		public int[] escapedPlayers;

		public string currentMap;
	}
}
