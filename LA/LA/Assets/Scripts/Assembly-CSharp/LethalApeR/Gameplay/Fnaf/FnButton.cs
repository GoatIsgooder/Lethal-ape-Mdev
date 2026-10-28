using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnButton : BaseButton
	{
		[Tooltip("Seconds between accepted presses.")]
		public float debounce = 0.3f;

		[Tooltip("Optional cap that moves in along its local -Z while pressed.")]
		public Transform cap;

		public float pressDepth = 0.008f;

		[Tooltip("Optional lamp tinted by state (MaterialPropertyBlock _Color / _EmissionColor).")]
		public Renderer lamp;

		public Color idleColor = new Color(0.25f, 0.25f, 0.25f, 1f);

		public Color litColor = new Color(0.2f, 1f, 0.35f, 1f);

		public Color refusedColor = new Color(1f, 0.12f, 0.1f, 1f);

		[NonSerialized]
		public bool interactable = true;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private MaterialPropertyBlock _mpb;

		private Vector3 _capRest;

		private float _nextPress;

		private float _pressedUntil;

		private float _refusedUntil;

		private bool _lit;

		public event Action<bool> Pressed;

		private void Awake()
		{
			if (cap != null)
			{
				_capRest = cap.localPosition;
			}
			ApplyLamp();
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (interactable && !(Time.time < _nextPress))
			{
				_nextPress = Time.time + debounce;
				_pressedUntil = Time.time + 0.12f;
				FnAudioBank audio = FnGame.Audio;
				if (audio != null)
				{
					FnAudio.Play(audio.buttonPress, transform.position, 0.6f, 1f, 6f, 1f);
				}
				this.Pressed?.Invoke(isLeft);
			}
		}

		public void SetLit(bool lit)
		{
			if (_lit != lit)
			{
				_lit = lit;
				ApplyLamp();
			}
		}

		public void FlashRefused()
		{
			_refusedUntil = Time.time + 0.6f;
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				FnAudio.Play(audio.denied, transform.position, 0.7f, 1f, 6f, 1f);
			}
		}

		private void Update()
		{
			if (cap != null)
			{
				Vector3 target = ((Time.time < _pressedUntil) ? (_capRest - Vector3.forward * pressDepth) : _capRest);
				cap.localPosition = Vector3.MoveTowards(cap.localPosition, target, Time.deltaTime * 0.2f);
			}
			if (lamp != null && _refusedUntil > 0f)
			{
				if (Time.time >= _refusedUntil)
				{
					_refusedUntil = 0f;
				}
				ApplyLamp();
			}
		}

		private void ApplyLamp()
		{
			if (!(lamp == null))
			{
				Color value = ((_refusedUntil > 0f && Time.time < _refusedUntil) ? ((Mathf.Repeat(_refusedUntil - Time.time, 0.5f) > 0.25f) ? refusedColor : idleColor) : (_lit ? litColor : idleColor));
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				lamp.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, value);
				_mpb.SetColor(BaseColorId, value);
				_mpb.SetColor(EmissionId, value);
				lamp.SetPropertyBlock(_mpb);
			}
		}
	}
}
