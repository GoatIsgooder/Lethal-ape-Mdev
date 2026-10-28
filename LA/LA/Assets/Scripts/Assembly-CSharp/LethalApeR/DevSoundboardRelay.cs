using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR
{
	[DisallowMultipleComponent]
	public class DevSoundboardRelay : MonoBehaviour
	{
		public const byte EventPlay = 181;

		public const byte EventStop = 182;

		private static readonly RaiseEventOptions ToAll = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.All
		};

		private AudioSource _source;

		private AudioClip[] _clips;

		private bool _warnedNoClips;

		public static DevSoundboardRelay Instance { get; private set; }

		public int CurrentIndex { get; private set; } = -1;

		public bool IsPlaying
		{
			get
			{
				if (_source != null)
				{
					return _source.isPlaying;
				}
				return false;
			}
		}

		public float Volume
		{
			get
			{
				if (_source != null)
				{
					return _source.volume;
				}
				return 1f;
			}
			set
			{
				if (_source != null)
				{
					_source.volume = Mathf.Clamp01(value);
				}
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(Instance != null))
			{
				GameObject gameObject = new GameObject("[DevMenu] SoundboardRelay");
				Object.DontDestroyOnLoad(gameObject);
				gameObject.AddComponent<DevSoundboardRelay>();
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
			_source = base.gameObject.AddComponent<AudioSource>();
			_source.playOnAwake = false;
			_source.loop = false;
			_source.spatialize = false;
			_source.spatialBlend = 0f;
			_source.volume = Mathf.Clamp01(PlayerPrefs.GetFloat("LA_SoundboardVolume", 1f));
		}

		private void OnEnable()
		{
			if (PhotonNetwork.NetworkingClient != null)
			{
				PhotonNetwork.NetworkingClient.EventReceived += OnEvent;
			}
		}

		private void OnDisable()
		{
			if (PhotonNetwork.NetworkingClient != null)
			{
				PhotonNetwork.NetworkingClient.EventReceived -= OnEvent;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public static void Broadcast(int index)
		{
			if (PhotonNetwork.InRoom)
			{
				PhotonNetwork.RaiseEvent(181, index, ToAll, SendOptions.SendReliable);
			}
			else
			{
				Instance?.PlayLocal(index);
			}
		}

		public static void BroadcastStop()
		{
			if (PhotonNetwork.InRoom)
			{
				PhotonNetwork.RaiseEvent(182, null, ToAll, SendOptions.SendReliable);
			}
			else
			{
				Instance?.StopLocal();
			}
		}

		private void OnEvent(EventData e)
		{
			if (e.Code == 182)
			{
				StopLocal();
			}
			else if (e.Code == 181 && e.CustomData is int index)
			{
				PlayLocal(index);
			}
		}

		public void PlayLocal(int index)
		{
			AudioClip[] array = ResolveClips();
			if (index >= 0 && array != null && index < array.Length && !(array[index] == null))
			{
				CurrentIndex = index;
				_source.Stop();
				_source.PlayOneShot(array[index]);
			}
		}

		public void StopLocal()
		{
			CurrentIndex = -1;
			if (_source != null)
			{
				_source.Stop();
			}
		}

		private AudioClip[] ResolveClips()
		{
			if (_clips == null || _clips.Length == 0)
			{
				DevMenu devMenu = Object.FindAnyObjectByType<DevMenu>(FindObjectsInactive.Include);
				if (devMenu != null)
				{
					_clips = devMenu.SoundboardClips;
				}
				if ((_clips == null || _clips.Length == 0) && !_warnedNoClips)
				{
					_warnedNoClips = true;
					Debug.LogWarning("[DevSoundboardRelay] No soundboard clips found — is the DevMenu component present in this scene?");
				}
			}
			return _clips;
		}

		public void InvalidateClips()
		{
			_clips = null;
		}
	}
}
