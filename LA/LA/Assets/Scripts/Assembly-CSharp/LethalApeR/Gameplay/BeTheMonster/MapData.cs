using System;
using UnityEngine;
using UnityEngine.Serialization;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Serializable]
	public class MapData
	{
		public string displayName;

		public string sceneId;

		public Sprite mapPreview;

		public GameObject mapObject;

		[FormerlySerializedAs("monsterTP")]
		public RandomizeSpawnPoint monsterTp;

		[FormerlySerializedAs("survivoursTP")]
		public RandomizeSpawnPoint survivoursTp;

		[Tooltip("How many of each round's generators come from this map's deep spawn points (BtmGeneratorSpawnPoint.deep). The rest roll from every point. 0 = no quota.")]
		[Min(0f)]
		public int minDeepGenerators;
	}
}
