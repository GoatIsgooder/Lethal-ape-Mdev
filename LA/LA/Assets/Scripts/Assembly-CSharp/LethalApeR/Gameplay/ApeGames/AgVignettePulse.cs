using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgVignettePulse : MonoBehaviour
	{
		[SerializeField]
		private float peakIntensity = 0.396f;

		[SerializeField]
		private float attackSeconds = 0.08f;

		[SerializeField]
		private float decaySeconds = 0.5f;

		private SlopColorGrade _grade;

		private float _baseVignette;

		private float _baseSmoothness;

		private float _pulseStart = -1f;

		private float _pulseStrength = 1f;

		private Color _pulseColor = Color.black;

		private float _holdIntensity;

		private Color _holdColor = Color.black;

		private bool _applied;

		private bool _warned;

		private bool HasTarget => _grade != null;

		private void Awake()
		{
			FindVolume();
		}

		public void Pulse(Color color)
		{
			Pulse(color, 1f);
		}

		public void Pulse(Color color, float strength)
		{
			if (EnsureVignette())
			{
				_pulseColor = color;
				_pulseStrength = Mathf.Clamp01(strength);
				_pulseStart = Time.time;
			}
		}

		public void SetHold(Color color, float intensity)
		{
			if (EnsureVignette())
			{
				_holdColor = color;
				_holdIntensity = Mathf.Clamp01(intensity);
			}
		}

		public void ClearHold()
		{
			_holdIntensity = 0f;
			Apply(CurrentPulse());
		}

		public void CancelToZero()
		{
			_pulseStart = -1f;
			_holdIntensity = 0f;
			WriteVignette(_holdColor, 0f);
			_applied = false;
		}

		private void Update()
		{
			Apply(CurrentPulse());
		}

		private float CurrentPulse()
		{
			if (_pulseStart < 0f)
			{
				return 0f;
			}
			float num = Time.time - _pulseStart;
			if (num >= attackSeconds + decaySeconds)
			{
				_pulseStart = -1f;
				return 0f;
			}
			float value = ((num < attackSeconds) ? ((attackSeconds > 0f) ? (num / attackSeconds) : 1f) : (1f - Mathf.Clamp01((num - attackSeconds) / Mathf.Max(decaySeconds, 0.01f))));
			return peakIntensity * _pulseStrength * Mathf.Clamp01(value);
		}

		private void Apply(float pulse)
		{
			if (!HasTarget)
			{
				return;
			}
			float num = Mathf.Clamp01(_holdIntensity + pulse);
			if (num > 0f || _applied)
			{
				Color color = ((pulse > 0f) ? _pulseColor : _holdColor);
				WriteVignette(color, num);
				_applied = num > 0f;
			}
		}

		private void OnDisable()
		{
			_pulseStart = -1f;
			_holdIntensity = 0f;
			WriteVignette(_holdColor, 0f);
			_applied = false;
		}

		private void WriteVignette(Color color, float intensity)
		{
			if (!(_grade == null))
			{
				_grade.vignetteColor = color;
				_grade.vignetteIntensity = Mathf.Max(_baseVignette, intensity);
				_grade.vignetteSmoothness = _baseSmoothness;
			}
		}

		private void FindVolume()
		{
			if (_grade != null)
			{
				return;
			}
			Camera main = Camera.main;
			if (main != null)
			{
				_grade = main.GetComponent<SlopColorGrade>();
			}
			if (_grade == null)
			{
				_grade = Object.FindFirstObjectByType<SlopColorGrade>();
			}
		}

		private bool EnsureVignette()
		{
			if (_grade != null)
			{
				return true;
			}
			FindVolume();
			if (_grade == null)
			{
				WarnOnce("no SlopColorGrade found - add one to the head camera, or the pulse cannot render");
				return false;
			}
			_baseVignette = _grade.vignetteIntensity;
			_baseSmoothness = _grade.vignetteSmoothness;
			return true;
		}

		private void WarnOnce(string why)
		{
			if (!_warned)
			{
				_warned = true;
				Debug.LogError("[AgVignettePulse] " + why + ", screen pulses disabled.", this);
			}
		}
	}
}
