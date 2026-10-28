using SlopGame;
using UnityEngine;

namespace LethalApeR.Audio
{
	public class PlaySfx : MonoBehaviour
	{
		[SerializeField]
		private SoundData soundData;

		[SerializeField]
		private AudioSource audioSource;

		[SerializeField]
		private AudioClip clip;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 1f;

		private bool _warned;

		public AudioSource CurrentAudioSource { get; private set; }

		private void Reset()
		{
			audioSource = GetComponent<AudioSource>();
			if (audioSource != null)
			{
				audioSource.spatialize = false;
			}
		}

		private AudioClip ResolveClip()
		{
			if (audioSource == null)
			{
				audioSource = GetComponent<AudioSource>();
			}
			if (clip != null)
			{
				return clip;
			}
			if (!(audioSource != null))
			{
				return null;
			}
			return audioSource.clip;
		}

		private void WarnOnce()
		{
			if (!_warned)
			{
				_warned = true;
				Debug.LogWarning("[PlaySfx] '" + base.name + "': nothing to play — needs an AudioSource plus a clip in either the PlaySfx Clip slot or the AudioSource's AudioClip slot.", this);
			}
		}

		public void PlayAudio()
		{
			if (soundData != null)
			{
				CurrentAudioSource = AudioSystem.PlayAudio(soundData, base.transform.position, base.transform.rotation);
				if (CurrentAudioSource == null)
				{
					WarnOnce();
				}
				return;
			}
			AudioClip audioClip = ResolveClip();
			if (audioSource != null && audioClip != null)
			{
				audioSource.PlayOneShot(audioClip, volume);
				CurrentAudioSource = audioSource;
			}
			else
			{
				WarnOnce();
			}
		}

		public void PlayAudioAt(Vector3 position)
		{
			if (soundData != null)
			{
				CurrentAudioSource = AudioSystem.PlayAudio(soundData, position, base.transform.rotation);
				if (CurrentAudioSource == null)
				{
					WarnOnce();
				}
				return;
			}
			AudioClip audioClip = ResolveClip();
			if (audioClip == null)
			{
				WarnOnce();
			}
			else
			{
				CurrentAudioSource = AudioSystem.PlayClipAt(audioClip, position, volume, audioSource);
			}
		}

		public void ClearCurrentAudioSource()
		{
			CurrentAudioSource = null;
		}
	}
}
