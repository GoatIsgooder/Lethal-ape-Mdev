using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnWallClock : MonoBehaviour
	{
		[Tooltip("Hands pivot on the clock axis and point at 12 at zero rotation.")]
		public Transform hourHand;

		public Transform minuteHand;

		public Transform secondHand;

		[Tooltip("Local axis the hands turn about.")]
		public Vector3 axis = Vector3.forward;

		[Tooltip("+1 if a positive angle about the axis turns the hands clockwise seen from the front, else -1.")]
		public float clockwise = 1f;

		private Quaternion _hour0;

		private Quaternion _minute0;

		private Quaternion _second0;

		private int _lastSecond = -1;

		private float _lastHours = -1f;

		private void Awake()
		{
			if (hourHand != null)
			{
				_hour0 = hourHand.localRotation;
			}
			if (minuteHand != null)
			{
				_minute0 = minuteHand.localRotation;
			}
			if (secondHand != null)
			{
				_second0 = secondHand.localRotation;
			}
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			float hours = 0f;
			if (instance != null && instance.Active)
			{
				hours = instance.NightProgress * 6f;
			}
			if (!Mathf.Approximately(hours, _lastHours))
			{
				_lastHours = hours;
				Set(hourHand, _hour0, hours * 30f);
				Set(minuteHand, _minute0, Mathf.Repeat(hours, 1f) * 360f);
			}
			int second = (int)Time.time % 60;
			if (second != _lastSecond)
			{
				_lastSecond = second;
				Set(secondHand, _second0, (float)second * 6f);
			}
		}

		private void Set(Transform hand, Quaternion rest, float degrees)
		{
			if (!(hand == null))
			{
				hand.localRotation = rest * Quaternion.AngleAxis(clockwise * degrees, axis);
			}
		}
	}
}
