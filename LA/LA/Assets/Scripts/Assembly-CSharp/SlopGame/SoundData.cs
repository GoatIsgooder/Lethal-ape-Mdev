using System;
using UnityEngine;
using UnityEngine.Audio;

namespace SlopGame
{
	[Serializable]
	[CreateAssetMenu(fileName = "SoundData", menuName = "SlopGame/Sound Data")]
	public class SoundData : ScriptableObject
	{
		[Header("Clips")]
		[Tooltip("One is picked at random per play.")]
		public AudioClip[] clips;

		public AudioMixerGroup mixerGroup;

		[Header("Playback")]
		public bool loop;

		public bool playOnAwake;

		public bool mute;

		public bool bypassEffects;

		public bool bypassListenerEffects;

		public bool bypassReverbZones;

		[Range(0f, 256f)]
		public int priority = 128;

		[Range(0f, 1f)]
		public float volume = 1f;

		[Range(-3f, 3f)]
		public float pitch = 1f;

		[Range(-1f, 1f)]
		public float panStereo;

		[Header("3D")]
		[Tooltip("0 = 2D, 1 = fully 3D.")]
		[Range(0f, 1f)]
		public float spatialBlend = 1f;

		[Range(0f, 1.1f)]
		public float reverbZoneMix = 1f;

		[Range(0f, 5f)]
		public float dopplerLevel = 1f;

		[Range(0f, 360f)]
		public float spread;

		public float minDistance = 1f;

		public float maxDistance = 500f;

		public AudioRolloffMode rolloffMode;

		[Header("Listener")]
		public bool ignoreListenerVolume;

		public bool ignoreListenerPause;

		public AudioClip PickClip()
		{
			if (clips == null || clips.Length == 0)
			{
				return null;
			}
			if (clips.Length == 1)
			{
				return clips[0];
			}
			return clips[UnityEngine.Random.Range(0, clips.Length)];
		}

		public void ApplyTo(AudioSource source)
		{
			if (!(source == null))
			{
				source.clip = PickClip();
				source.outputAudioMixerGroup = mixerGroup;
				source.loop = loop;
				source.playOnAwake = playOnAwake;
				source.mute = mute;
				source.bypassEffects = bypassEffects;
				source.bypassListenerEffects = bypassListenerEffects;
				source.bypassReverbZones = bypassReverbZones;
				source.priority = priority;
				source.volume = volume;
				source.pitch = pitch;
				source.panStereo = panStereo;
				source.spatialBlend = spatialBlend;
				source.reverbZoneMix = reverbZoneMix;
				source.dopplerLevel = dopplerLevel;
				source.spread = spread;
				source.minDistance = minDistance;
				source.maxDistance = maxDistance;
				source.rolloffMode = rolloffMode;
				source.ignoreListenerVolume = ignoreListenerVolume;
				source.ignoreListenerPause = ignoreListenerPause;
			}
		}
	}
}
