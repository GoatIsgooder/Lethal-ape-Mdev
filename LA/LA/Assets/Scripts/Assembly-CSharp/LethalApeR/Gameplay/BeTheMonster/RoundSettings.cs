using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Serializable]
	public class RoundSettings
	{
		public int roundDuration = 60;

		public int intermissionDuration = 20;

		public int mapVotingDuration = 20;

		public float monsterSpawnDelay = 3f;

		[Tooltip("Seconds everyone spends in the loadout box before the round clock and the monster delay start.")]
		public float prepDuration = 8f;

		public int roundRetryDuration = 10;

		public float monsterSize = 1.4f;

		[Tooltip("The most monsters a round can have however full the room is. Otherwise one per five players.")]
		[Min(1f)]
		public int maxMonsters = 3;

		[Tooltip("How many generators spawn per round, clamped to the map's placed spawn points.")]
		public int generatorsPerRound = 4;

		public RandomizeSpawnPoint spawnPoint;

		public List<MapData> maps = new List<MapData>();
	}
}
