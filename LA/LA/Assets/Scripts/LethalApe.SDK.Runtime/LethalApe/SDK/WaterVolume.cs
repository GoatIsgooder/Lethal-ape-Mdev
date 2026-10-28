using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Water Volume")]
	[DisallowMultipleComponent]
	public sealed class WaterVolume : ZoneComponent
	{
		[SerializeField]
		[Range(0f, 1.5f)]
		[Tooltip("1 cancels gravity, above 1 floats players up to the surface.")]
		private float buoyancy = 1.05f;

		[SerializeField]
		[Range(0f, 6f)]
		[Tooltip("How quickly the water slows players down.")]
		private float drag = 1.6f;

		[SerializeField]
		[Range(0f, 3f)]
		[Tooltip("How much each arm stroke pushes the player.")]
		private float swimStrength = 1f;

		[SerializeField]
		[Tooltip("Fog colour while the player's head is underwater.")]
		private Color underwaterColor = new Color(0.06f, 0.28f, 0.36f, 1f);

		[SerializeField]
		[Range(0f, 0.5f)]
		private float underwaterFogDensity = 0.09f;

		public float Buoyancy => buoyancy;

		public float Drag => drag;

		public float SwimStrength => swimStrength;

		public Color UnderwaterColor => underwaterColor;

		public float UnderwaterFogDensity => underwaterFogDensity;
	}
}
