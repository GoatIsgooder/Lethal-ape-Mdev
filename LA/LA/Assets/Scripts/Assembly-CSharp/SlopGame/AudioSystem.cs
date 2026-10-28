using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SlopGame
{
	public static class AudioSystem
	{
		private sealed class Runner : MonoBehaviour
		{
		}

		private const int MaxPooled = 16;

		private const string RootName = "[SlopGame.AudioSystem Pool]";

		private static Transform _root;

		private static readonly Stack<AudioSource> _idle = new Stack<AudioSource>(16);

		private static readonly HashSet<AudioSource> _ours = new HashSet<AudioSource>();

		private static Runner _runner;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_root = null;
			_runner = null;
			_idle.Clear();
			_ours.Clear();
		}

		private static void EnsureRoot()
		{
			if (!(_root != null))
			{
				GameObject gameObject = new GameObject("[SlopGame.AudioSystem Pool]");
				Object.DontDestroyOnLoad(gameObject);
				gameObject.hideFlags = HideFlags.HideInHierarchy;
				_root = gameObject.transform;
				_runner = gameObject.AddComponent<Runner>();
			}
		}

		private static AudioSource Borrow(Vector3 position)
		{
			EnsureRoot();
			AudioSource audioSource = null;
			while (_idle.Count > 0 && audioSource == null)
			{
				audioSource = _idle.Pop();
			}
			if (audioSource == null)
			{
				GameObject gameObject = new GameObject("AudioEmitter");
				gameObject.transform.SetParent(_root, false);
				audioSource = gameObject.AddComponent<AudioSource>();
				_ours.Add(audioSource);
			}
			audioSource.transform.position = position;
			audioSource.gameObject.SetActive(true);
			return audioSource;
		}

		public static AudioSource PlayAudio(SoundData soundData, Vector3 position, Quaternion rotation)
		{
			if (soundData == null)
			{
				return null;
			}
			AudioClip[] clips = soundData.clips;
			if (clips == null || clips.Length == 0)
			{
				return null;
			}
			AudioClip audioClip = clips[Random.Range(0, clips.Length)];
			if (audioClip == null)
			{
				return null;
			}
			AudioSource audioSource = Borrow(position);
			audioSource.transform.rotation = rotation;
			audioSource.clip = audioClip;
			audioSource.outputAudioMixerGroup = soundData.mixerGroup;
			audioSource.loop = soundData.loop;
			audioSource.playOnAwake = false;
			audioSource.spatialize = false;
			audioSource.mute = soundData.mute;
			audioSource.bypassEffects = soundData.bypassEffects;
			audioSource.bypassListenerEffects = soundData.bypassListenerEffects;
			audioSource.bypassReverbZones = soundData.bypassReverbZones;
			audioSource.priority = soundData.priority;
			audioSource.volume = soundData.volume;
			audioSource.pitch = soundData.pitch;
			audioSource.panStereo = soundData.panStereo;
			audioSource.spatialBlend = soundData.spatialBlend;
			audioSource.reverbZoneMix = soundData.reverbZoneMix;
			audioSource.dopplerLevel = soundData.dopplerLevel;
			audioSource.spread = soundData.spread;
			audioSource.minDistance = soundData.minDistance;
			audioSource.maxDistance = soundData.maxDistance;
			audioSource.ignoreListenerVolume = soundData.ignoreListenerVolume;
			audioSource.ignoreListenerPause = soundData.ignoreListenerPause;
			audioSource.rolloffMode = soundData.rolloffMode;
			audioSource.Play();
			if (!audioSource.loop && _runner != null)
			{
				_runner.StartCoroutine(ReturnAfter(audioSource, audioClip.length / Mathf.Max(Mathf.Abs(audioSource.pitch), 0.01f)));
			}
			return audioSource;
		}

		public static AudioSource PlayClipAt(AudioClip clip, Vector3 position, float volume = 1f, AudioSource template = null)
		{
			if (clip == null)
			{
				return null;
			}
			AudioSource audioSource = Borrow(position);
			audioSource.clip = clip;
			audioSource.volume = volume;
			audioSource.spatialize = false;
			audioSource.playOnAwake = false;
			if (template != null)
			{
				audioSource.spatialBlend = template.spatialBlend;
				audioSource.rolloffMode = template.rolloffMode;
				audioSource.minDistance = template.minDistance;
				audioSource.maxDistance = template.maxDistance;
				audioSource.outputAudioMixerGroup = template.outputAudioMixerGroup;
				audioSource.loop = template.loop;
				audioSource.pitch = template.pitch;
				audioSource.priority = template.priority;
			}
			else
			{
				audioSource.spatialBlend = 1f;
				audioSource.rolloffMode = AudioRolloffMode.Logarithmic;
				audioSource.loop = false;
				audioSource.pitch = 1f;
			}
			audioSource.Play();
			if (!audioSource.loop && _runner != null)
			{
				_runner.StartCoroutine(ReturnAfter(audioSource, clip.length / Mathf.Max(Mathf.Abs(audioSource.pitch), 0.01f)));
			}
			return audioSource;
		}

		public static void ReturnToPool(AudioSource source)
		{
			if (source == null)
			{
				return;
			}
			if (!_ours.Contains(source))
			{
				source.Stop();
				return;
			}
			source.Stop();
			source.clip = null;
			source.outputAudioMixerGroup = null;
			source.gameObject.SetActive(false);
			if (_idle.Count < 16)
			{
				if (!_idle.Contains(source))
				{
					_idle.Push(source);
				}
			}
			else
			{
				_ours.Remove(source);
				Object.Destroy(source.gameObject);
			}
		}

		private static IEnumerator ReturnAfter(AudioSource source, float seconds)
		{
			yield return new WaitForSeconds(seconds);
			if (source != null && source.gameObject.activeSelf)
			{
				ReturnToPool(source);
			}
		}
	}
}
