using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Speed Zone")]
	[DisallowMultipleComponent]
	public sealed class SpeedZone : ZoneComponent
	{
		[SerializeField]
		[Range(0.25f, 3f)]
		[Tooltip("Multiplies how fast players move while inside.")]
		private float speedMultiplier = 1.5f;

		public float SpeedMultiplier => Mathf.Clamp(speedMultiplier, 0.25f, 3f);
	}
}
