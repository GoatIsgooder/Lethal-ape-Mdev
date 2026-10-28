using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmGeneratorSpawnPoint : MonoBehaviour
	{
		[Tooltip("Unique per map, 0-31. Becomes the spawned generator's generatorId. Auto-assigned by the editor tool.")]
		public int pointId;

		[Tooltip("In the map's dangerous part (THE CAVERNS' caves). Each round takes at least the map's Min Deep Generators from deep points, so the whole task can't land somewhere safe.")]
		public bool deep;
	}
}
