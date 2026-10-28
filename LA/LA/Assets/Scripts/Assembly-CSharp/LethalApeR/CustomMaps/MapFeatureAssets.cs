using TMPro;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[CreateAssetMenu(menuName = "Slop/Custom Maps/Feature Assets", fileName = "MapFeatureAssets")]
	public sealed class MapFeatureAssets : ScriptableObject
	{
		[Header("Text")]
		public TMP_FontAsset font;

		[Tooltip("Dark panel behind signs. Unlit, opaque (no alpha blending over the world).")]
		public Material panelMaterial;

		[Tooltip("Panel behind the head-following message. Transparent so it can fade out with the text.")]
		public Material toastPanelMaterial;

		[Header("Sounds (2D)")]
		public AudioClip buttonClick;

		public AudioClip teleport;

		public AudioClip jumpPad;

		public AudioClip checkpoint;

		public AudioClip respawn;

		public AudioClip splash;

		public AudioClip raceStart;

		public AudioClip raceCheckpoint;

		public AudioClip raceFinish;

		public AudioClip message;

		[Range(0f, 1f)]
		public float sfxVolume = 0.7f;
	}
}
