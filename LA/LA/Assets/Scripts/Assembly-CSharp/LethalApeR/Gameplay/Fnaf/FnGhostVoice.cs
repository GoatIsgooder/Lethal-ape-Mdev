using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	[RequireComponent(typeof(AudioSource))]
	public class FnGhostVoice : MonoBehaviour
	{
		private const float SilenceGrace = 0.25f;

		private AudioSource _source;

		private volatile FnVoiceScramble _scramble;

		private volatile bool _run;

		private volatile bool _reset;

		private volatile float _targetGain;

		private float _gain;

		private bool _mutedByUs;

		private float _silentSince;

		private FnVoiceMode _mode;

		public FnVoiceMode Mode => _mode;

		private void Awake()
		{
			_source = GetComponent<AudioSource>();
			AudioSettings.OnAudioConfigurationChanged += OnAudioConfigurationChanged;
			enabled = false;
		}

		private void OnDestroy()
		{
			AudioSettings.OnAudioConfigurationChanged -= OnAudioConfigurationChanged;
			Silence(false);
		}

		private void OnEnable()
		{
			_reset = true;
			_run = true;
		}

		private void OnDisable()
		{
			_run = false;
		}

		public void Apply(FnVoiceMode mode, float gain)
		{
			FnVoiceMode previous = _mode;
			_mode = mode;
			switch (mode)
			{
			case FnVoiceMode.Silent:
				Silence(true);
				_targetGain = 0f;
				if (previous != FnVoiceMode.Silent)
				{
					_silentSince = Time.unscaledTime;
				}
				if (enabled && Time.unscaledTime - _silentSince >= 0.25f)
				{
					enabled = false;
				}
				break;
			case FnVoiceMode.Scrambled:
				if (_scramble == null || _scramble.SampleRate != AudioSettings.outputSampleRate)
				{
					Build();
				}
				_targetGain = Mathf.Clamp01(gain);
				if (!enabled)
				{
					enabled = true;
				}
				Silence(false);
				break;
			default:
				if (enabled)
				{
					enabled = false;
				}
				Silence(false);
				break;
			}
		}

		public void Release()
		{
			Apply(FnVoiceMode.Plain, 1f);
		}

		private void Build()
		{
			_scramble = new FnVoiceScramble(AudioSettings.outputSampleRate, UnityEngine.Random.Range(1, int.MaxValue));
		}

		private void OnAudioConfigurationChanged(bool deviceWasChanged)
		{
			if (_scramble != null)
			{
				Build();
			}
			_reset = true;
		}

		private void Silence(bool silent)
		{
			if (_source == null)
			{
				return;
			}
			if (silent)
			{
				if (!_source.mute)
				{
					_source.mute = true;
					_mutedByUs = true;
				}
			}
			else if (_mutedByUs)
			{
				_mutedByUs = false;
				_source.mute = false;
			}
		}

		private void OnAudioFilterRead(float[] data, int channels)
		{
			if (!_run)
			{
				return;
			}
			FnVoiceScramble scramble = _scramble;
			if (scramble == null)
			{
				Array.Clear(data, 0, data.Length);
				return;
			}
			float target = _targetGain;
			if (_reset)
			{
				_reset = false;
				scramble.Reset();
				_gain = target;
			}
			scramble.Process(data, channels, _gain, target);
			_gain = target;
		}
	}
}
