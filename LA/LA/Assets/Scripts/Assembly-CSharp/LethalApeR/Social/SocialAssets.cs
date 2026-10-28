using TMPro;
using UnityEngine;

namespace LethalApeR.Social
{
	public sealed class SocialAssets : ScriptableObject
	{
		public const string ResourcePath = "Systems/SocialAssets";

		[Header("Type")]
		public TMP_FontAsset font;

		[Tooltip("Kode Mono on the curved, distance-faded board shader.")]
		public Material boardTextMaterial;

		[Tooltip("Kode Mono on the mobile SDF shader, for the flat hand menu.")]
		public Material menuTextMaterial;

		[Header("Images")]
		public Material boardImageMaterial;

		public Sprite rounded;

		public Sprite roundedSmall;

		public Sprite chevron;

		public Sprite cross;

		public Sprite talking;

		[Header("Portraits")]
		[Tooltip("Hidden/Slop/Social/Portrait Alpha: makes each portrait opaque after its shot (some shaders write no alpha).")]
		public Shader portraitAlphaShader;

		[Header("Sound")]
		public AudioClip pressClip;

		public AudioClip menuOpenClip;

		public AudioClip menuCloseClip;

		private static SocialAssets _instance;

		public static SocialAssets Instance
		{
			get
			{
				if (_instance != null)
				{
					return _instance;
				}
				_instance = Resources.Load<SocialAssets>("Systems/SocialAssets");
				if (_instance == null)
				{
					Debug.LogError("[Social] Resources/Systems/SocialAssets is missing. Run Slop > Social > Build Social UI.");
				}
				else if (_instance.font != null)
				{
					SocialText.Font = _instance.font;
				}
				return _instance;
			}
		}
	}
}
