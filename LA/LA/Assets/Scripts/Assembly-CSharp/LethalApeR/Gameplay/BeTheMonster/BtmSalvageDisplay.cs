using System.Reflection;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmSalvageDisplay : MonoBehaviour
	{
		[SerializeField]
		private TMP_Text text;

		[Tooltip("{0} = balance. Rich text allowed.")]
		[SerializeField]
		private string format = "{0}";

		[SerializeField]
		[Min(0.05f)]
		private float tickSeconds = 0.9f;

		[SerializeField]
		private AudioClip tickClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float tickVolume = 0.25f;

		private float _shown = -1f;

		private int _target;

		private float _from;

		private float _t = 1f;

		private int _lastWhole = -1;

		private AudioSource _voice;

		private void Awake()
		{
			if (text == null)
			{
				text = GetComponent<TMP_Text>();
			}
			if (!(tickClip == null))
			{
				_voice = base.gameObject.AddComponent<AudioSource>();
				_voice.playOnAwake = false;
				_voice.spatialBlend = 1f;
				_voice.spatialize = false;
				_voice.maxDistance = 8f;
				_voice.rolloffMode = AudioRolloffMode.Linear;
			}
		}

		private void OnEnable()
		{
			BtmProgress.Changed += OnChanged;
			_target = BtmProgress.Salvage;
			_shown = _target;
			_t = 1f;
			Write(_target);
		}

		private void OnDisable()
		{
			BtmProgress.Changed -= OnChanged;
		}

		private void OnChanged()
		{
			int salvage = BtmProgress.Salvage;
			if (salvage != _target)
			{
				_target = salvage;
				_from = _shown;
				_t = 0f;
			}
		}

		private void Update()
		{
			if (!(_t >= 1f))
			{
				_t = Mathf.Min(1f, _t + Time.deltaTime / tickSeconds);
				float t = 1f - (1f - _t) * (1f - _t);
				_shown = Mathf.Lerp(_from, _target, t);
				int num = Mathf.RoundToInt(_shown);
				if (num != _lastWhole)
				{
					Write(num);
					if (_voice != null && tickClip != null && (num % 5 == 0 || _t >= 1f))
					{
						_voice.PlayOneShot(tickClip, tickVolume);
					}
				}
			}
		}

		private void Write(int value)
		{
			_lastWhole = value;
			if (text != null)
			{
				text.text = string.Format(format, value);
			}
		}
	}
}
