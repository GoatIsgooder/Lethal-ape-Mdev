using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Content/Audio Zone")]
	[DisallowMultipleComponent]
	public sealed class AudioZone : ZoneComponent
	{
		[SerializeField]
		private AudioClip clip;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.6f;

		[SerializeField]
		[Range(0f, 5f)]
		private float fadeSeconds = 1.5f;

		[SerializeField]
		private AudioZoneLayer layer;

		public AudioClip Clip => clip;

		public float Volume => volume;

		public float FadeSeconds => fadeSeconds;

		public AudioZoneLayer Layer => layer;
	}
}
