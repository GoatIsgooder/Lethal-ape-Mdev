using System.Collections.Generic;
using LethalApeR.Social;
using UnityEngine;

namespace LethalApeR
{
	public class AudioManager : MonoBehaviour
	{
		private sealed class Channel
		{
			public float Scale = 1f;

			public readonly Dictionary<AudioSource, float> BaseVolumes = new Dictionary<AudioSource, float>();

			public readonly List<AudioSource> Sources = new List<AudioSource>();

			public readonly HashSet<AudioSource> Muted = new HashSet<AudioSource>();
		}

		[Header("Audio Management Settings")]
		[Tooltip("Every AudioSource on a GameObject with this tag is scaled by this manager, along with any handed in by tag at runtime (the AI monsters hand theirs to MuteForMonster as they spawn).")]
		[SerializeField]
		private string audioTag = "Music";

		private static readonly Dictionary<string, Channel> Channels = new Dictionary<string, Channel>();

		private string PrefsKey => "AudioManager_Volume_" + base.gameObject.name;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Channels.Clear();
		}

		private void Start()
		{
			GameObject[] array = GameObject.FindGameObjectsWithTag(audioTag);
			foreach (GameObject gameObject in array)
			{
				if (gameObject.TryGetComponent<AudioSource>(out var component))
				{
					Add(ChannelOf(audioTag), component);
				}
			}
			SetVolumePercentage(PlayerPrefs.GetFloat(PrefsKey, 100f), saveToPrefs: false);
		}

		public static void Adopt(string tag, IReadOnlyList<AudioSource> sources)
		{
			if (string.IsNullOrEmpty(tag) || sources == null)
			{
				return;
			}
			Channel channel = ChannelOf(tag);
			for (int num = channel.Sources.Count - 1; num >= 0; num--)
			{
				if (channel.Sources[num] == null)
				{
					Forget(channel, num);
				}
			}
			for (int i = 0; i < sources.Count; i++)
			{
				Add(channel, sources[i]);
			}
		}

		public void SetVolumePercentage(float percentage, bool saveToPrefs = true)
		{
			SetChannelScale(audioTag, percentage);
			if (saveToPrefs)
			{
				PlayerPrefs.SetFloat(PrefsKey, Mathf.Clamp(percentage, 0f, 100f));
				PlayerPrefs.Save();
				GameSettings.Reload();
			}
		}

		public static void SetChannelVolume(string tag, float percentage)
		{
			if (string.IsNullOrEmpty(tag))
			{
				return;
			}
			Channel channel = ChannelOf(tag);
			GameObject[] array = GameObject.FindGameObjectsWithTag(tag);
			foreach (GameObject gameObject in array)
			{
				if (gameObject.TryGetComponent<AudioSource>(out var component))
				{
					Add(channel, component);
				}
			}
			SetChannelScale(tag, percentage);
		}

		private static void SetChannelScale(string tag, float percentage)
		{
			Channel channel = ChannelOf(tag);
			channel.Scale = Mathf.Clamp(percentage, 0f, 100f) / 100f;
			for (int num = channel.Sources.Count - 1; num >= 0; num--)
			{
				AudioSource audioSource = channel.Sources[num];
				if (audioSource == null)
				{
					Forget(channel, num);
				}
				else
				{
					Apply(channel, audioSource);
				}
			}
		}

		public float GetOriginalVolume(AudioSource audioSource)
		{
			if (audioSource != null && ChannelOf(audioTag).BaseVolumes.TryGetValue(audioSource, out var value))
			{
				return value;
			}
			return 0f;
		}

		public void ResetVolumes()
		{
			SetVolumePercentage(100f);
		}

		public int GetManagedAudioSourceCount()
		{
			return ChannelOf(audioTag).Sources.Count;
		}

		private static Channel ChannelOf(string tag)
		{
			if (!Channels.TryGetValue(tag, out var value))
			{
				value = new Channel();
				Channels[tag] = value;
			}
			return value;
		}

		private static void Add(Channel channel, AudioSource source)
		{
			if (!(source == null) && !channel.BaseVolumes.ContainsKey(source))
			{
				channel.BaseVolumes[source] = source.volume;
				channel.Sources.Add(source);
				Apply(channel, source);
			}
		}

		private static void Apply(Channel channel, AudioSource source)
		{
			if (channel.BaseVolumes.TryGetValue(source, out var value))
			{
				source.volume = channel.Scale * value;
			}
			if (channel.Scale > 0f)
			{
				if (channel.Muted.Remove(source))
				{
					source.mute = false;
				}
			}
			else if (!source.mute)
			{
				source.mute = true;
				channel.Muted.Add(source);
			}
		}

		private static void Forget(Channel channel, int index)
		{
			AudioSource item = channel.Sources[index];
			channel.Sources.RemoveAt(index);
			channel.BaseVolumes.Remove(item);
			channel.Muted.Remove(item);
		}
	}
}
