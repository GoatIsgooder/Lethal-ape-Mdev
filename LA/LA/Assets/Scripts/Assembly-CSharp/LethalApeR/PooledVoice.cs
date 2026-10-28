using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using Photon.Voice.PUN;
using Photon.Voice.Unity;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public sealed class PooledVoice : MonoBehaviour, IPoolLifecycle
	{
		public const float VoiceGain = 2.5f;

		[Tooltip("Every AudioSource Photon Voice plays this player's speech through.")]
		[SerializeField]
		private AudioSource[] voiceAudioSources = Array.Empty<AudioSource>();

		private Speaker _speaker;

		private PhotonVoiceView _voiceView;

		private bool _refsCached;

		private bool _recycled;

		private Coroutine _restart;

		int IPoolLifecycle.PoolCallbackOrder => 0;

		private void Awake()
		{
			CacheRefs();
			for (int i = 0; i < voiceAudioSources.Length; i++)
			{
				AudioSource audioSource = voiceAudioSources[i];
				if (!(audioSource == null) && !(audioSource.GetComponent<VoiceAmplifier>() != null))
				{
					audioSource.gameObject.AddComponent<VoiceAmplifier>().gain = 2.5f;
				}
			}
		}

		private void OnEnable()
		{
			if (_recycled)
			{
				if (_restart != null)
				{
					StopCoroutine(_restart);
				}
				_restart = StartCoroutine(RestartPlaybackNextFrame());
			}
		}

		void IPoolLifecycle.OnPoolReleased()
		{
			CacheRefs();
			if (_restart != null)
			{
				StopCoroutine(_restart);
				_restart = null;
			}
			for (int i = 0; i < voiceAudioSources.Length; i++)
			{
				AudioSource audioSource = voiceAudioSources[i];
				if (!(audioSource == null))
				{
					audioSource.Stop();
					audioSource.clip = null;
				}
			}
			if (_speaker != null)
			{
				_speaker.enabled = false;
			}
			if (_voiceView != null)
			{
				_voiceView.enabled = false;
			}
		}

		void IPoolLifecycle.OnPoolAcquired()
		{
			CacheRefs();
			_recycled = true;
			if (_voiceView != null)
			{
				_voiceView.enabled = true;
			}
			if (_speaker != null)
			{
				_speaker.enabled = true;
			}
		}

		private void CacheRefs()
		{
			if (!_refsCached)
			{
				_refsCached = true;
				_speaker = GetComponentInChildren<Speaker>(true);
				_voiceView = GetComponent<PhotonVoiceView>();
			}
		}

		private IEnumerator RestartPlaybackNextFrame()
		{
			yield return null;
			_restart = null;
			if (!(_speaker == null) && _speaker.enabled)
			{
				if (!_speaker.gameObject.activeSelf)
				{
					_speaker.gameObject.SetActive(true);
				}
				_speaker.RestartPlayback();
			}
		}
	}
}
