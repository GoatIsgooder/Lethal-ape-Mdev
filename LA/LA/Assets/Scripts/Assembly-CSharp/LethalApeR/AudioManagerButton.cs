using UnityEngine;

namespace LethalApeR
{
	public class AudioManagerButton : BaseButton
	{
		[Header("Audio Manager Button Settings")]
		[Tooltip("AudioManager whose volume this button sets.")]
		[SerializeField]
		private AudioManager audioManager;

		[Tooltip("Volume to apply, as a percentage (0-100) of the AudioManager's authored volume.")]
		[Range(0f, 100f)]
		[SerializeField]
		private float volumePercentage = 100f;

		private void Awake()
		{
			if (audioManager == null)
			{
				Debug.LogError("[AudioManagerButton] '" + base.name + "' has no AudioManager assigned; the button will do nothing.", this);
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (audioManager != null)
			{
				audioManager.SetVolumePercentage(volumePercentage);
			}
		}
	}
}
