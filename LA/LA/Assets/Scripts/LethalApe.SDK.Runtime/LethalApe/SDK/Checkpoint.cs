using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Checkpoint")]
	[DisallowMultipleComponent]
	public sealed class Checkpoint : ZoneComponent
	{
		[SerializeField]
		[Tooltip("Where players respawn after touching this checkpoint. Empty = this object.")]
		private Transform respawnPoint;

		public Transform RespawnPoint => (respawnPoint != null) ? respawnPoint : base.transform;
	}
}
