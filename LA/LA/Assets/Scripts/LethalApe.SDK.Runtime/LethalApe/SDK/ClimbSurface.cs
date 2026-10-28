using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Climb Surface")]
	[DisallowMultipleComponent]
	public sealed class ClimbSurface : MapComponent
	{
		[SerializeField]
		[Tooltip("Slippery: hands slide off like ice.  Bouncy: jumps off it go further.  Not Climbable: hands pass through it.  Ladder: hold grip to climb hand over hand.")]
		private ClimbSurfaceType type;

		[SerializeField]
		[Range(1f, 3f)]
		[Tooltip("Bouncy only: jump strength multiplier.")]
		private float bounce = 1.6f;

		public ClimbSurfaceType Type => type;

		public float Bounce => Mathf.Clamp(bounce, 1f, 3f);
	}
}
