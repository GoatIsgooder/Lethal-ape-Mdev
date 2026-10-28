using System;
using Photon.Voice;
using Photon.Voice.PUN;
using Photon.Voice.Unity;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnNoiseReporter : MonoBehaviour
	{
		private const int CalibrationSamples = 128;

		private const float SampleInterval = 0.1f;

		private const float DefaultFloor = 0.02f;

		private readonly float[] _samples = new float[128];

		private int _sampleCount;

		private float _nextSample;

		private float _floor = 0.02f;

		private bool _calibrated;

		private FnPhase _lastPhase;

		private PunVoiceClient _voice;

		private float _nextVoiceLookup;

		private float _tokens;

		private float _nextFootstep;

		public static float Level01 { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Level01 = 0f;
		}

		private float MicLevel()
		{
			if (_voice == null && Time.unscaledTime >= _nextVoiceLookup)
			{
				_nextVoiceLookup = Time.unscaledTime + 2f;
				_voice = UnityEngine.Object.FindAnyObjectByType<PunVoiceClient>();
			}
			Recorder recorder = ((_voice != null) ? _voice.PrimaryRecorder : null);
			if (recorder != null)
			{
				AudioUtil.ILevelMeter levelMeter = recorder.LevelMeter;
				if (levelMeter != null)
				{
					return levelMeter.CurrentAvgAmp;
				}
			}
			return 0f;
		}

		private void Update()
		{
			FnNight instance = FnNight.Instance;
			if (instance != null && instance.Active)
			{
				FnPhase phase = instance.Phase;
				if (_lastPhase != phase)
				{
					switch (phase)
					{
					case FnPhase.Briefing:
						_sampleCount = 0;
						_calibrated = false;
						break;
					case FnPhase.Night:
						if (!_calibrated)
						{
							FinishCalibration();
						}
						break;
					}
					_lastPhase = phase;
				}
				FnSettings.NoiseSettings noise = FnGame.Settings.noise;
				float num = MicLevel();
				if (phase == FnPhase.Night)
				{
					if (instance.LocalIsAlive)
					{
						float maxReportsPerSecond = noise.maxReportsPerSecond;
						_tokens = Mathf.Min(maxReportsPerSecond, _tokens + maxReportsPerSecond * Time.deltaTime);
						float num2 = num - (_floor + noise.voiceMargin);
						float num3 = 0f;
						if (num2 > 0f)
						{
							num3 = Mathf.Clamp01(num2 / Mathf.Max(noise.voiceShoutAbove, 0.001f));
						}
						Vector3 rigVelocity = FnPlatform.RigVelocity;
						float magnitude = new Vector2(rigVelocity.x, rigVelocity.z).magnitude;
						float num4 = 0f;
						if (magnitude > noise.runSpeed)
						{
							num4 = Mathf.Clamp01((magnitude - noise.runSpeed) / noise.runSpeed);
						}
						Level01 = Mathf.Max(num3, num4 * 0.8f);
						Transform head = FnPlatform.Head;
						if (head == null || _tokens < 1f)
						{
							return;
						}
						if (num2 > 0f)
						{
							Report(FnNoise.Voice, head.position, Mathf.Lerp(noise.voiceRadius.x, noise.voiceRadius.y, num3));
						}
						else if (num4 > 0f && Time.unscaledTime >= _nextFootstep)
						{
							_nextFootstep = Time.unscaledTime + 0.5f;
							Report(FnNoise.Footsteps, head.position, noise.footstepRadius);
						}
						return;
					}
				}
				else if (phase == FnPhase.Briefing && Time.unscaledTime >= _nextSample && _sampleCount < 128)
				{
					_nextSample = Time.unscaledTime + 0.1f;
					_samples[_sampleCount++] = num;
				}
			}
			Level01 = 0f;
		}

		private void Report(FnNoise kind, Vector3 at, float radius)
		{
			_tokens -= 1f;
			FnNet.ToMasterClient(FnRpc.Noise, (byte)kind, at.x, at.y, at.z, (byte)Mathf.Clamp(Mathf.RoundToInt(radius), 1, 255));
		}

		private void FinishCalibration()
		{
			_calibrated = true;
			if (_sampleCount < 8)
			{
				_floor = 0.02f;
				return;
			}
			float[] array = new float[_sampleCount];
			Array.Copy(_samples, array, _sampleCount);
			Array.Sort(array);
			float num = Mathf.Clamp01(FnGame.Settings.noise.voiceFloorPercentile);
			int num2 = Mathf.Clamp(Mathf.RoundToInt(num * (float)(_sampleCount - 1)), 0, _sampleCount - 1);
			_floor = Mathf.Max(array[num2], 0.002f);
		}
	}
}
