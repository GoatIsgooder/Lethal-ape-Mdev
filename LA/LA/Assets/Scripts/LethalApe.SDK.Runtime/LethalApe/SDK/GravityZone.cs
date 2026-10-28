using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Gravity Zone")]
	[DisallowMultipleComponent]
	public sealed class GravityZone : ZoneComponent
	{
		[SerializeField]
		[Range(-1f, 3f)]
		[Tooltip("1 is normal gravity, 0 is floating, negative pulls players upward.")]
		private float gravityMultiplier = 0.35f;

		public float GravityMultiplier => Mathf.Clamp(gravityMultiplier, -1f, 3f);
	}
}
