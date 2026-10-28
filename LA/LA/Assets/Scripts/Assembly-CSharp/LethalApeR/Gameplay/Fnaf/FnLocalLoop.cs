using UnityEngine;
using UnityEngine.Audio;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnLocalLoop
	{
		public static AudioSource Create(Transform parent, string name, AudioMixerGroup output)
		{
			GameObject gameObject = new GameObject(name);
			gameObject.transform.SetParent(parent, false);
			AudioSource audioSource = gameObject.AddComponent<AudioSource>();
			audioSource.playOnAwake = false;
			audioSource.loop = true;
			audioSource.spatialize = false;
			audioSource.spatialBlend = 0f;
			audioSource.dopplerLevel = 0f;
			audioSource.volume = 0f;
			audioSource.outputAudioMixerGroup = output;
			return audioSource;
		}

		public static void Drive(AudioSource source, AudioClip clip, float volume)
		{
			if (source == null)
			{
				return;
			}
			if (volume <= 0.001f || clip == null)
			{
				if (source.isPlaying)
				{
					source.Stop();
				}
				return;
			}
			if (source.clip != clip)
			{
				source.Stop();
				source.clip = clip;
			}
			source.volume = volume;
			if (!source.isPlaying)
			{
				source.Play();
			}
		}
	}
}
