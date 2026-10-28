using UnityEngine;

namespace LethalApeR.Gameplay.Grenade
{
	[CreateAssetMenu(fileName = "GrenadeSettings", menuName = "LethalApeR/Grenade Settings")]
	public class GrenadeSettings : ScriptableObject
	{
		[Header("Fuse")]
		public float fuseDelay = 3.5f;

		[Range(0f, 1f)]
		public float fuseHapticAmplitude = 0.65f;

		public float fuseHapticInterval = 0.35f;

		[Header("Pin")]
		public float pullThreshold = 0.12f;

		[Range(0f, 1f)]
		public float pinResistanceAmplitude = 0.8f;

		public float pinSnapBackDuration = 0.15f;

		public float pinStringWidth = 0.005f;

		[Header("Explosion")]
		public float explosionForce = 18f;

		public float explosionRadius = 6f;

		public float killRadius = 1.5f;

		public float upwardModifier = 1.2f;

		public float monsterStopDuration = 4f;

		public float explosionLifetime = 4f;
	}
}
