using System.Collections.Generic;
using Photon.Voice.Unity;
using UnityEngine;

namespace LethalApeR.Networking
{
	[DisallowMultipleComponent]
	[AddComponentMenu("Slop/Voice Distance Culler")]
	public class VoiceDistanceCuller : MonoBehaviour
	{
		private sealed class VoiceCullDriver : MonoBehaviour
		{
			private float _next;

			private readonly List<KeyValuePair<float, VoiceDistanceCuller>> _ranked = new List<KeyValuePair<float, VoiceDistanceCuller>>(64);

			private void LateUpdate()
			{
				if (Time.unscaledTime < _next)
				{
					return;
				}
				float num = 0.2f;
				for (int i = 0; i < All.Count; i++)
				{
					if (All[i] != null)
					{
						num = All[i].evaluateInterval;
						break;
					}
				}
				_next = Time.unscaledTime + num;
				if (All.Count == 0)
				{
					return;
				}
				Transform transform = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.Head : null);
				if (transform == null)
				{
					Camera main = Camera.main;
					transform = ((main != null) ? main.transform : null);
				}
				if (transform == null)
				{
					return;
				}
				Vector3 position = transform.position;
				_ranked.Clear();
				for (int j = 0; j < All.Count; j++)
				{
					VoiceDistanceCuller voiceDistanceCuller = All[j];
					if (!(voiceDistanceCuller == null))
					{
						float num2 = voiceDistanceCuller.DistanceFrom(position);
						if (!(num2 < 0f))
						{
							_ranked.Add(new KeyValuePair<float, VoiceDistanceCuller>(num2, voiceDistanceCuller));
						}
					}
				}
				if (_ranked.Count == 0)
				{
					return;
				}
				_ranked.Sort((KeyValuePair<float, VoiceDistanceCuller> a, KeyValuePair<float, VoiceDistanceCuller> b) => a.Key.CompareTo(b.Key));
				int num3 = ((RuntimeHrtfOverride >= 0) ? RuntimeHrtfOverride : _ranked[0].Value.hrtfNearestCount);
				int num4 = 0;
				for (int k = 0; k < _ranked.Count; k++)
				{
					VoiceDistanceCuller value = _ranked[k].Value;
					float key = _ranked[k].Key;
					bool flag = k < num3;
					if (flag)
					{
						num4++;
					}
					value.ApplyTier(key, flag);
				}
				ActiveHrtfCount = num4;
			}
		}

		[Header("Tiers")]
		[Tooltip("How many of the NEAREST players keep Meta XR Audio (HRTF + room acoustics). 64 = everyone: measured in a live 24-player MainScene lobby (2026-10-20), going from 8 to all of them added ~2 ms of audio-thread time per second on a desktop core, and voices outside the cap came out ~25% louder than those inside it (Unity panning vs Meta). The DevMenu Perf page A/Bs this live.")]
		[SerializeField]
		private int hrtfNearestCount = 64;

		[Tooltip("Beyond this the AudioSource is switched off entirely. Keep it at or slightly above the voice rolloff max distance so you only ever cut people who are already inaudible.")]
		[SerializeField]
		private float inaudibleDistance = 37f;

		[Tooltip("Re-enable a little closer than the cut distance. Without this gap someone walking the boundary stutters in and out.")]
		[SerializeField]
		private float audibleAgainDistance = 33f;

		[Header("Scheduling")]
		[Tooltip("Seconds between re-rankings. Voice does not need per-frame precision; 4-8 times a second is imperceptible and costs nothing.")]
		[SerializeField]
		private float evaluateInterval = 0.2f;

		private MonkeDevNetworkingPlayer _player;

		private AudioSource _source;

		private Speaker _speaker;

		private bool _resolved;

		private bool _originalSpatialize;

		private bool _cutOff;

		private static readonly List<VoiceDistanceCuller> All = new List<VoiceDistanceCuller>();

		private static VoiceCullDriver _driver;

		public static int RuntimeHrtfOverride = -1;

		public static int ActiveHrtfCount { get; private set; }

		private void Awake()
		{
			_player = GetComponent<MonkeDevNetworkingPlayer>();
		}

		private void OnEnable()
		{
			if (!All.Contains(this))
			{
				All.Add(this);
			}
			_resolved = false;
			EnsureDriver();
		}

		private void OnDisable()
		{
			All.Remove(this);
			Restore();
		}

		private static void EnsureDriver()
		{
			if (!(_driver != null))
			{
				GameObject gameObject = new GameObject("[Voice] Cull Driver");
				gameObject.hideFlags = HideFlags.HideAndDontSave;
				_driver = gameObject.AddComponent<VoiceCullDriver>();
				Object.DontDestroyOnLoad(gameObject);
			}
		}

		private void Resolve()
		{
			_resolved = true;
			_speaker = GetComponentInChildren<Speaker>(true);
			_source = ((_speaker != null) ? _speaker.GetComponent<AudioSource>() : null);
			if (_source != null)
			{
				_originalSpatialize = _source.spatialize;
			}
		}

		private void Restore()
		{
			if (_source == null)
			{
				return;
			}
			_source.spatialize = _originalSpatialize;
			if (!_source.enabled)
			{
				_source.enabled = true;
				if (_speaker != null && _speaker.enabled)
				{
					_speaker.RestartPlayback();
				}
			}
			_cutOff = false;
		}

		private float DistanceFrom(Vector3 origin)
		{
			if (!_resolved)
			{
				Resolve();
			}
			if (_source == null)
			{
				return -1f;
			}
			if (_player != null && _player.photonView != null && _player.photonView.IsMine)
			{
				return -1f;
			}
			return Vector3.Distance(((_player != null && _player.Head != null) ? _player.Head : base.transform).position, origin);
		}

		private void ApplyTier(float dist, bool inNearSet)
		{
			if (_source == null)
			{
				return;
			}
			if (_cutOff)
			{
				if (dist > audibleAgainDistance)
				{
					return;
				}
				_cutOff = false;
				_source.enabled = true;
				if (_speaker != null && _speaker.enabled)
				{
					_speaker.RestartPlayback();
				}
			}
			else if (dist > inaudibleDistance)
			{
				_cutOff = true;
				_source.enabled = false;
				return;
			}
			bool flag = inNearSet && _originalSpatialize;
			if (_source.spatialize != flag)
			{
				_source.spatialize = flag;
			}
		}

		private void OnValidate()
		{
			hrtfNearestCount = Mathf.Max(0, hrtfNearestCount);
			if (audibleAgainDistance >= inaudibleDistance)
			{
				audibleAgainDistance = Mathf.Max(0f, inaudibleDistance - 4f);
			}
			evaluateInterval = Mathf.Max(0.05f, evaluateInterval);
		}
	}
}
