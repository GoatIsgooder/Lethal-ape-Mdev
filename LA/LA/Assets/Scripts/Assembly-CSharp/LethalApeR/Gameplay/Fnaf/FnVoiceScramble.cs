using System;

namespace LethalApeR.Gameplay.Fnaf
{
	public sealed class FnVoiceScramble
	{
		public readonly int SampleRate;

		private readonly int _minChunk;

		private readonly int _maxChunk;

		private readonly int _ringSize;

		private readonly float[] _ring;

		private readonly float[] _fade;

		private readonly float[] _echo;

		private readonly float _lowpassCoeff;

		private readonly float _echoFeedback;

		private readonly float _makeup;

		private readonly uint _seed;

		private int _warmup;

		private int _write;

		private int _chunkStart;

		private int _chunkLength;

		private int _pos;

		private int _read;

		private int _echoPos;

		private float _lowpass;

		private uint _rng;

		public int Latency => _maxChunk;

		public FnVoiceScramble(int sampleRate, int seed = 1, float minChunkSeconds = 0.09f, float maxChunkSeconds = 0.16f, float fadeSeconds = 0.006f, float lowpassHz = 1800f, float echoSeconds = 0.11f, float echoFeedback = 0.35f)
		{
			SampleRate = Math.Max(sampleRate, 8000);
			_minChunk = Math.Max(1, Samples(minChunkSeconds, SampleRate));
			_maxChunk = Math.Max(_minChunk, Samples(maxChunkSeconds, SampleRate));
			_ringSize = _maxChunk * 2;
			_ring = new float[_ringSize];
			_fade = new float[Math.Max(0, Math.Min(_minChunk / 2, Samples(fadeSeconds, SampleRate)))];
			for (int i = 0; i < _fade.Length; i++)
			{
				_fade[i] = 0.5f - 0.5f * (float)Math.Cos((i + 0.5) * Math.PI / _fade.Length);
			}
			_echo = new float[Math.Max(1, Samples(echoSeconds, SampleRate))];
			_lowpassCoeff = ((lowpassHz > 0f) ? (1f - (float)Math.Exp(-2.0 * Math.PI * lowpassHz / SampleRate)) : 1f);
			_echoFeedback = Math.Max(0f, Math.Min(echoFeedback, 0.9f));
			_makeup = 1f - _echoFeedback * 0.5f;
			_seed = ((seed == 0) ? 1u : ((uint)seed));
			Reset();
		}

		public void Reset()
		{
			Array.Clear(_ring, 0, _ring.Length);
			Array.Clear(_echo, 0, _echo.Length);
			_warmup = _maxChunk;
			_write = 0;
			_echoPos = 0;
			_lowpass = 0f;
			_rng = _seed;
			_chunkStart = 0;
			_chunkLength = NextLength();
			_pos = 0;
			_read = Wrap(_chunkStart + _chunkLength - 1);
		}

		public void Process(float[] data, int channels, float gainFrom, float gainTo)
		{
			if (data == null || channels < 1)
			{
				return;
			}
			int frames = data.Length / channels;
			if (frames < 1)
			{
				return;
			}
			float invChannels = 1f / channels;
			float gainStep = (gainTo - gainFrom) / frames;
			float gain = gainFrom;
			for (int f = 0; f < frames; f++)
			{
				int baseIndex = f * channels;
				float sum = 0f;
				for (int c = 0; c < channels; c++)
				{
					sum += data[baseIndex + c];
				}
				_ring[_write] = sum * invChannels;
				if (++_write == _ringSize)
				{
					_write = 0;
				}
				float sample;
				if (_warmup > 0)
				{
					_warmup--;
					sample = 0f;
				}
				else
				{
					sample = _ring[_read] * Envelope(_pos, _chunkLength);
					_read--;
					if (_read < 0)
					{
						_read = _ringSize - 1;
					}
					_pos++;
					if (_pos >= _chunkLength)
					{
						NextChunk();
					}
				}
				if (_lowpassCoeff < 1f)
				{
					_lowpass += _lowpassCoeff * (sample - _lowpass);
					sample = _lowpass;
				}
				float echoed = sample + _echoFeedback * _echo[_echoPos];
				if (echoed < 1E-15f && echoed > -1E-15f)
				{
					echoed = 0f;
				}
				_echo[_echoPos] = echoed;
				if (++_echoPos == _echo.Length)
				{
					_echoPos = 0;
				}
				float output = gain * (_makeup * echoed);
				gain += gainStep;
				for (int c2 = 0; c2 < channels; c2++)
				{
					data[baseIndex + c2] = output;
				}
			}
			if (_lowpass > -1E-15f && _lowpass < 1E-15f)
			{
				_lowpass = 0f;
			}
		}

		private float Envelope(int position, int length)
		{
			int edge = Math.Min(position, length - 1 - position);
			if (edge >= _fade.Length)
			{
				return 1f;
			}
			return _fade[edge];
		}

		private void NextChunk()
		{
			_chunkStart = Wrap(_chunkStart + _chunkLength);
			_chunkLength = NextLength();
			_pos = 0;
			_read = Wrap(_chunkStart + _chunkLength - 1);
		}

		private int NextLength()
		{
			_rng ^= _rng << 13;
			_rng ^= _rng >> 17;
			_rng ^= _rng << 5;
			return _minChunk + (int)(_rng % (uint)(_maxChunk - _minChunk + 1));
		}

		private int Wrap(int i)
		{
			return (i % _ringSize + _ringSize) % _ringSize;
		}

		private static int Samples(float seconds, int sampleRate)
		{
			return (int)Math.Round((double)seconds * (double)sampleRate);
		}
	}
}
