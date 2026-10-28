using UnityEngine;
using UnityEngine.Audio;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnAudio : MonoBehaviour
	{
		private static FnAudio _instance;

		[Tooltip("Mixer group every FNAF one-shot plays through (the game's SFX group).")]
		public AudioMixerGroup output;

		[Range(4f, 32f)]
		public int voices = 16;

		private AudioSource[] _pool;

		private int _next;

		private const float DuplicateSeconds = 0.06f;

		private const float DuplicateMetres = 0.75f;

		private const int Recent = 24;

		private readonly AudioClip[] _recentClip = new AudioClip[Recent];

		private readonly float[] _recentTime = new float[Recent];

		private readonly Vector3[] _recentAt = new Vector3[Recent];

		private int _recentNext;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
		}

		private void Awake()
		{
			_instance = this;
			_pool = new AudioSource[voices];
			for (int i = 0; i < voices; i++)
			{
				GameObject gameObject = new GameObject("Voice" + i);
				gameObject.transform.SetParent(base.transform, worldPositionStays: false);
				AudioSource audioSource = gameObject.AddComponent<AudioSource>();
				audioSource.playOnAwake = false;
				audioSource.spatialize = false;
				audioSource.outputAudioMixerGroup = output;
				audioSource.rolloffMode = AudioRolloffMode.Linear;
				audioSource.dopplerLevel = 0f;
				_pool[i] = audioSource;
			}
		}

		private void OnDestroy()
		{
			if (_instance == this)
			{
				_instance = null;
			}
		}

		public static AudioSource At(AudioClip clip, Vector3 position, float volume = 1f, float maxDistance = 20f, float pitch = 1f)
		{
			return Play(clip, position, volume, 1f, maxDistance, pitch);
		}

		public static AudioSource Flat(AudioClip clip, float volume = 1f, float pitch = 1f)
		{
			return Play(clip, Vector3.zero, volume, 0f, 1f, pitch);
		}

		public static AudioSource Play(AudioClip clip, Vector3 position, float volume, float spatialBlend, float maxDistance, float pitch)
		{
			if (clip == null || _instance == null)
			{
				return null;
			}
			if (_instance._pool == null || _instance.IsDuplicate(clip, position))
			{
				return null;
			}
			AudioSource audioSource = _instance.NextVoice();
			audioSource.transform.position = position;
			audioSource.clip = clip;
			audioSource.volume = volume;
			audioSource.pitch = pitch;
			audioSource.spatialBlend = spatialBlend;
			audioSource.minDistance = Mathf.Min(1f, maxDistance * 0.1f);
			audioSource.maxDistance = Mathf.Max(1f, maxDistance);
			audioSource.Play();
			return audioSource;
		}

		private bool IsDuplicate(AudioClip clip, Vector3 at)
		{
			float unscaledTime = Time.unscaledTime;
			for (int i = 0; i < Recent; i++)
			{
				if (!(_recentClip[i] != clip) && !(unscaledTime - _recentTime[i] > DuplicateSeconds) && (_recentAt[i] - at).sqrMagnitude < DuplicateMetres * DuplicateMetres)
				{
					return true;
				}
			}
			_recentClip[_recentNext] = clip;
			_recentTime[_recentNext] = unscaledTime;
			_recentAt[_recentNext] = at;
			_recentNext = (_recentNext + 1) % Recent;
			return false;
		}

		private AudioSource NextVoice()
		{
			for (int i = 0; i < _pool.Length; i++)
			{
				AudioSource audioSource = _pool[(_next + i) % _pool.Length];
				if (!audioSource.isPlaying)
				{
					_next = (_next + i + 1) % _pool.Length;
					return audioSource;
				}
			}
			AudioSource audioSource2 = _pool[0];
			float num = -1f;
			for (int j = 0; j < _pool.Length; j++)
			{
				AudioSource audioSource3 = _pool[j];
				float num2 = 1f;
				if (audioSource3.clip != null)
				{
					float length = audioSource3.clip.length;
					if (length > 0f)
					{
						num2 = audioSource3.time / length;
					}
				}
				if (num2 > num)
				{
					num = num2;
					audioSource2 = audioSource3;
				}
			}
			audioSource2.Stop();
			return audioSource2;
		}
	}
}
