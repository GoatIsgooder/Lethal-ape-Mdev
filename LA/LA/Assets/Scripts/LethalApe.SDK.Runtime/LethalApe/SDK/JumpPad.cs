using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Jump Pad")]
	[DisallowMultipleComponent]
	public sealed class JumpPad : ZoneComponent
	{
		[SerializeField]
		[Tooltip("Launch velocity in this object's local space (m/s). Capped at 25 m/s in game.")]
		private Vector3 launchVelocity = new Vector3(0f, 12f, 0f);

		[SerializeField]
		[Tooltip("Add to the player's current velocity instead of replacing it.")]
		private bool additive;

		[SerializeField]
		[Min(0.1f)]
		[Tooltip("Seconds before the pad can launch the same player again.")]
		private float cooldown = 0.5f;

		public Vector3 LaunchVelocity => launchVelocity;

		public bool Additive => additive;

		public float Cooldown => cooldown;

		public Vector3 WorldLaunchVelocity => Vector3.ClampMagnitude(transform.TransformDirection(launchVelocity), 25f);
	}
}
