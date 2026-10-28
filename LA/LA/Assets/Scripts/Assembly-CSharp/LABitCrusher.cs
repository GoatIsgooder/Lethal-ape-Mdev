using System;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class LABitCrusher : MonoBehaviour
{
	public enum Mode
	{
		BitCrusher = 0,
		Radio = 1,
		Both = 2
	}

	[Header("Mode")]
	public Mode processingMode;

	[Range(0f, 1f)]
	public float dryWet = 1f;

	[Header("Bit Crusher")]
	[Range(1f, 16f)]
	[Tooltip("Number of bits per sample — lower = crunchier")]
	public int bitDepth = 8;

	[Range(1f, 50f)]
	[Tooltip("Sample hold length — higher = more downsampled / lower apparent sample rate")]
	public int downsample = 4;

	[Range(0f, 1f)]
	[Tooltip("Randomly varies hold length for a more organic lo-fi texture")]
	public float jitter;

	[Header("Radio")]
	[Range(50f, 2000f)]
	[Tooltip("High-pass cutoff — cuts bass, simulating radio bandwidth")]
	public float bassRolloff = 500f;

	[Range(1000f, 20000f)]
	[Tooltip("Low-pass cutoff — cuts treble, simulating radio bandwidth")]
	public float trebleRolloff = 4000f;

	[Range(0f, 0.3f)]
	[Tooltip("White noise layered over the signal")]
	public float noiseLevel = 0.04f;

	[Range(0f, 1f)]
	[Tooltip("Drive amount into soft-clip saturation")]
	public float distortion = 0.2f;

	[Range(0f, 0.5f)]
	[Tooltip("AM modulation depth — simulates a fading signal")]
	public float signalFlutter = 0.06f;

	[Range(0.5f, 20f)]
	[Tooltip("Speed of the signal flutter in Hz")]
	public float flutterRate = 4f;

	[Header("General")]
	[Range(0f, 1f)]
	[Tooltip("Subtle analog warmth — a light saturation applied after all processing")]
	public float warmth = 0.1f;

	private const int MAX_CH = 8;

	private float[] _held = new float[8];

	private float[] _hpOut = new float[8];

	private float[] _hpIn = new float[8];

	private float[] _lpOut = new float[8];

	private int _holdIdx;

	private int _holdLen;

	private double _phase;

	private bool _active;

	private System.Random _rng;

	[ContextMenu("Preset/8-Bit Console")]
	private void Preset8Bit()
	{
		processingMode = Mode.BitCrusher;
		dryWet = 1f;
		bitDepth = 8;
		downsample = 4;
		jitter = 0f;
	}

	[ContextMenu("Preset/4-Bit Chip")]
	private void Preset4Bit()
	{
		processingMode = Mode.BitCrusher;
		dryWet = 1f;
		bitDepth = 4;
		downsample = 8;
		jitter = 0.25f;
	}

	[ContextMenu("Preset/AM Radio")]
	private void PresetAMRadio()
	{
		processingMode = Mode.Radio;
		dryWet = 1f;
		bassRolloff = 400f;
		trebleRolloff = 3200f;
		noiseLevel = 0.06f;
		distortion = 0.25f;
		signalFlutter = 0.1f;
		flutterRate = 3f;
	}

	[ContextMenu("Preset/Walkie Talkie")]
	private void PresetWalkie()
	{
		processingMode = Mode.Radio;
		dryWet = 1f;
		bassRolloff = 700f;
		trebleRolloff = 2500f;
		noiseLevel = 0.1f;
		distortion = 0.5f;
		signalFlutter = 0.05f;
		flutterRate = 2f;
	}

	[ContextMenu("Preset/Retro Radio Chip")]
	private void PresetBoth()
	{
		processingMode = Mode.Both;
		dryWet = 1f;
		bitDepth = 8;
		downsample = 3;
		jitter = 0.1f;
		bassRolloff = 500f;
		trebleRolloff = 5000f;
		noiseLevel = 0.03f;
		distortion = 0.15f;
		signalFlutter = 0.04f;
		flutterRate = 5f;
	}

	private void Awake()
	{
		_rng = new System.Random();
	}

	private void OnEnable()
	{
		Array.Clear(_held, 0, 8);
		Array.Clear(_hpOut, 0, 8);
		Array.Clear(_hpIn, 0, 8);
		Array.Clear(_lpOut, 0, 8);
		_holdIdx = 0;
		_holdLen = Math.Max(1, downsample);
		_phase = 0.0;
		_active = true;
	}

	private void OnDisable()
	{
		_active = false;
	}

	private void OnAudioFilterRead(float[] data, int channels)
	{
		if (!_active)
		{
			return;
		}
		double num = 1.0 / (double)AudioSettings.outputSampleRate;
		float num2 = (float)(1.0 - Math.Exp(-Math.PI * 2.0 * (double)trebleRolloff * num));
		float num3 = Mathf.Pow(2f, bitDepth - 1);
		bool flag = processingMode == Mode.BitCrusher || processingMode == Mode.Both;
		bool flag2 = processingMode == Mode.Radio || processingMode == Mode.Both;
		int num4 = data.Length / channels;
		double num5 = 1.0 / (Math.PI * 2.0 * (double)bassRolloff);
		float num6 = (float)(num5 / (num5 + num));
		int num7 = Math.Min(channels, 8);
		for (int i = 0; i < num4; i++)
		{
			for (int j = 0; j < num7; j++)
			{
				int num8 = i * channels + j;
				float num9 = data[num8];
				float num10 = num9;
				if (flag)
				{
					if (_holdIdx == 0)
					{
						_held[j] = num9;
					}
					num10 = Mathf.Round(_held[j] * num3) / num3;
				}
				if (flag2)
				{
					float num11 = num6 * (_hpOut[j] + num10 - _hpIn[j]);
					_hpIn[j] = num10;
					_hpOut[j] = num11;
					num10 = _lpOut[j] + num2 * (num11 - _lpOut[j]);
					_lpOut[j] = num10;
					if (noiseLevel > 0f)
					{
						num10 += noiseLevel * (float)(_rng.NextDouble() * 2.0 - 1.0);
					}
					if (distortion > 0f)
					{
						float num12 = num10 * (1f + distortion * 10f);
						num10 = num12 / (1f + Mathf.Abs(num12));
					}
					if (signalFlutter > 0f)
					{
						float num13 = (float)Math.Sin(Math.PI * 2.0 * (double)flutterRate * _phase);
						num10 *= 1f - signalFlutter * (num13 * 0.5f + 0.5f);
					}
				}
				if (warmth > 0f)
				{
					num10 = num10 * (1f + warmth) / (1f + Mathf.Abs(num10) * warmth);
				}
				data[num8] = Mathf.Lerp(num9, num10, dryWet);
			}
			_holdIdx++;
			_phase += num;
			if (_holdIdx >= _holdLen)
			{
				_holdIdx = 0;
				_holdLen = Math.Max(1, downsample);
				if (jitter > 0f && _rng.NextDouble() < (double)jitter)
				{
					_holdLen = Math.Max(1, _holdLen + ((_rng.NextDouble() > 0.5) ? 1 : (-1)));
				}
			}
		}
	}
}
