using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Teleporter")]
	[DisallowMultipleComponent]
	public sealed class Teleporter : ZoneComponent
	{
		[SerializeField]
		[Tooltip("Where players arrive. Its forward (blue) axis is the direction they face.")]
		private Transform destination;

		[SerializeField]
		[Tooltip("Keep the player's speed through the teleport instead of stopping them.")]
		private bool keepMomentum;

		[SerializeField]
		[Min(0f)]
		[Tooltip("Seconds before the same player can use this teleporter again.")]
		private float cooldown = 1f;

		public Transform Destination => destination;

		public bool KeepMomentum => keepMomentum;

		public float Cooldown => cooldown;
	}
}
