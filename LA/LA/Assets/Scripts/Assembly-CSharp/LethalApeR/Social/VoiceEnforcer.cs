using System.Collections.Generic;
using LethalApeR.Networking;
using Photon.Realtime;
using Photon.Voice.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Social
{
	[DefaultExecutionOrder(500)]
	public sealed class VoiceEnforcer : MonoBehaviour
	{
		private const float Interval = 0.25f;

		private static VoiceEnforcer _instance;

		private readonly Dictionary<Speaker, AudioSource> _sources = new Dictionary<Speaker, AudioSource>(32);

		private Recorder _recorder;

		private bool _recorderSearched;

		private float _next;

		private readonly HashSet<TextMeshPro> _hiddenTags = new HashSet<TextMeshPro>();

		public static bool VoiceInScene => _instance != null && _instance.FindRecorder() != null;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Social] Voice Enforcer");
				Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<VoiceEnforcer>();
			}
		}

		private void OnEnable()
		{
			SceneManager.sceneLoaded += OnSceneLoaded;
			LocalMutes.Changed += ApplySoon;
			BlockList.Changed += ApplySoon;
			GameSettings.Changed += ApplySoon;
		}

		private void OnDisable()
		{
			SceneManager.sceneLoaded -= OnSceneLoaded;
			LocalMutes.Changed -= ApplySoon;
			BlockList.Changed -= ApplySoon;
			GameSettings.Changed -= ApplySoon;
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			_sources.Clear();
			_recorder = null;
			_recorderSearched = false;
			_next = 0f;
		}

		private void ApplySoon()
		{
			_next = 0f;
		}

		private void LateUpdate()
		{
			if (!(Time.unscaledTime < _next))
			{
				_next = Time.unscaledTime + 0.25f;
				ApplySpeakers();
				ApplyRecorder();
			}
		}

		private void ApplySpeakers()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			float voiceVolume = GameSettings.VoiceVolume01;
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer player = players[i];
				if (player == null || player.photonView == null || player.photonView.IsMine)
				{
					continue;
				}
				Player owner = player.photonView.Owner;
				string userId = owner?.UserId;
				bool blocked = BlockList.IsBlocked(userId);
				bool mute;
				if (blocked)
				{
					BlockList.RememberName(userId, SocialText.CleanName(owner.NickName));
					mute = true;
				}
				else
				{
					mute = LocalMutes.IsMuted(userId);
				}
				AudioSource audioSource = SourceOf(player.PhotonVoiceSpeaker);
				if (audioSource != null)
				{
					if (audioSource.mute != mute)
					{
						audioSource.mute = mute;
					}
					if (!Mathf.Approximately(audioSource.volume, voiceVolume))
					{
						audioSource.volume = voiceVolume;
					}
				}
				TextMeshPro nameText = player.NameText;
				if (nameText == null)
				{
					continue;
				}
				if (blocked)
				{
					if (nameText.enabled)
					{
						nameText.enabled = false;
						_hiddenTags.Add(nameText);
					}
				}
				else if (_hiddenTags.Remove(nameText))
				{
					nameText.enabled = true;
				}
			}
		}

		private AudioSource SourceOf(Speaker speaker)
		{
			AudioSource value = null;
			if (speaker == null)
			{
				return null;
			}
			if (_sources.TryGetValue(speaker, out value) && value != null)
			{
				return value;
			}
			value = speaker.GetComponent<AudioSource>();
			_sources[speaker] = value;
			return value;
		}

		private void ApplyRecorder()
		{
			Recorder recorder = FindRecorder();
			if (!(recorder == null) && recorder.TransmitEnabled != GameSettings.MicOn)
			{
				recorder.TransmitEnabled = GameSettings.MicOn;
			}
		}

		private Recorder FindRecorder()
		{
			if (_recorder != null)
			{
				return _recorder;
			}
			if (_recorderSearched && Time.frameCount % 60 != 0)
			{
				return null;
			}
			_recorderSearched = true;
			_recorder = Object.FindAnyObjectByType<Recorder>(FindObjectsInactive.Include);
			return _recorder;
		}
	}
}
