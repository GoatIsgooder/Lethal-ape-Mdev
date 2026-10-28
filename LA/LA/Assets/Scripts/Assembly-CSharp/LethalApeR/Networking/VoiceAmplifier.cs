using UnityEngine;

namespace LethalApeR.Networking
{
	[RequireComponent(typeof(AudioSource))]
	[DisallowMultipleComponent]
	public class VoiceAmplifier : MonoBehaviour
	{
		[Tooltip("Linear gain applied to voice samples. 2.0 = +6dB, 2.83 = +9dB, 4.0 = +12dB. Default 2.5 (~8dB) is a comfortable boost without overdriving headphones.")]
		[Range(1f, 6f)]
		public float gain = 2.5f;

		[Tooltip("Soft-clip threshold. Peaks above this are smoothly compressed. Lower = more headroom, less distortion risk.")]
		[Range(0.5f, 1f)]
		public float softClipCeiling = 0.95f;

		private void OnAudioFilterRead(float[] data, int channels)
		{
			for (int i = 0; i < data.Length; i++)
			{
				float num = data[i] * gain;
				data[i] = num / (1f + Mathf.Abs(num) / softClipCeiling);
			}
		}
	}
}
