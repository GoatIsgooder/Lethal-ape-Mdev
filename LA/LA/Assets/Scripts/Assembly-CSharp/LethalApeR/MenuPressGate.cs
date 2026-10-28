using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR
{
	[DisallowMultipleComponent]
	public sealed class MenuPressGate : MonoBehaviour
	{
		[SerializeField]
		[Min(0f)]
		private float cooldown = 0.35f;

		private readonly Dictionary<Object, bool> _answers = new Dictionary<Object, bool>(4);

		private int _answersFrame = -1;

		private float _openAt;

		public float Cooldown
		{
			get
			{
				return cooldown;
			}
			set
			{
				cooldown = Mathf.Max(0f, value);
			}
		}

		public bool TryPress(Object button)
		{
			if (Time.frameCount != _answersFrame)
			{
				_answers.Clear();
				_answersFrame = Time.frameCount;
			}
			if (_answers.TryGetValue(button, out var value))
			{
				return value;
			}
			float unscaledTime = Time.unscaledTime;
			value = unscaledTime >= _openAt;
			if (value)
			{
				_openAt = unscaledTime + cooldown;
			}
			_answers[button] = value;
			return value;
		}

		public static MenuPressGate Find(Component button)
		{
			if (button == null)
			{
				return null;
			}
			return button.GetComponentInParent<MenuPressGate>(true);
		}
	}
}
