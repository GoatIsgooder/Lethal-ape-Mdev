using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;

namespace LethalApeR.SpiderApe
{
	public static class SpiderApeInput
	{
		public static SpiderApeInputMode Mode = SpiderApeInputMode.Auto;

		public static float TriggerPressThreshold = 0.6f;

		public static float TriggerReleaseThreshold = 0.3f;

		public static float GripPressThreshold = 0.6f;

		public static float GripReleaseThreshold = 0.3f;

		public static float StickDeadzone = 0.18f;

		private static readonly bool[] _fire = new bool[2];

		private static readonly bool[] _firePrev = new bool[2];

		private static readonly bool[] _grip = new bool[2];

		private static readonly bool[] _gripPrev = new bool[2];

		private static readonly Vector2[] _steer = new Vector2[2];

		private static int _polledFrame = -1;

		public static bool IsPC
		{
			get
			{
				switch (Mode)
				{
				case SpiderApeInputMode.ForceVR:
					return false;
				case SpiderApeInputMode.ForcePC:
					return true;
				default:
					return !XRSettings.isDeviceActive;
				}
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Mode = SpiderApeInputMode.Auto;
			_polledFrame = -1;
			for (int i = 0; i < 2; i++)
			{
				_fire[i] = false;
				_firePrev[i] = false;
				_grip[i] = false;
				_gripPrev[i] = false;
				_steer[i] = Vector2.zero;
			}
		}

		public static bool FireHeld(WebHand hand)
		{
			Poll();
			return _fire[(int)hand];
		}

		public static bool FirePressed(WebHand hand)
		{
			Poll();
			if (_fire[(int)hand])
			{
				return !_firePrev[(int)hand];
			}
			return false;
		}

		public static bool FireReleased(WebHand hand)
		{
			Poll();
			if (!_fire[(int)hand])
			{
				return _firePrev[(int)hand];
			}
			return false;
		}

		public static bool GripHeld(WebHand hand)
		{
			Poll();
			return _grip[(int)hand];
		}

		public static bool GripPressed(WebHand hand)
		{
			Poll();
			if (_grip[(int)hand])
			{
				return !_gripPrev[(int)hand];
			}
			return false;
		}

		public static Vector2 Steer(WebHand hand)
		{
			Poll();
			return _steer[(int)hand];
		}

		public static void Pulse(WebHand hand, float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				if (hand == WebHand.Left)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		private static void Poll()
		{
			if (_polledFrame != Time.frameCount)
			{
				_polledFrame = Time.frameCount;
				_firePrev[0] = _fire[0];
				_firePrev[1] = _fire[1];
				_gripPrev[0] = _grip[0];
				_gripPrev[1] = _grip[1];
				if (IsPC)
				{
					PollPC();
				}
				else
				{
					PollVR();
				}
			}
		}

		private static void PollVR()
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				_fire[0] = false;
				_fire[1] = false;
				_grip[0] = false;
				_grip[1] = false;
				_steer[0] = Vector2.zero;
				_steer[1] = Vector2.zero;
			}
			else
			{
				_fire[0] = Latch(_fire[0], instance.LeftTriggerValue, TriggerPressThreshold, TriggerReleaseThreshold);
				_fire[1] = Latch(_fire[1], instance.RightTriggerValue, TriggerPressThreshold, TriggerReleaseThreshold);
				_grip[0] = Latch(_grip[0], instance.LeftGripValue, GripPressThreshold, GripReleaseThreshold);
				_grip[1] = Latch(_grip[1], instance.RightGripValue, GripPressThreshold, GripReleaseThreshold);
				_steer[0] = Deadzone(instance.LeftJoystick);
				_steer[1] = Deadzone(instance.RightJoystick);
			}
		}

		private static void PollPC()
		{
			Keyboard current = Keyboard.current;
			Mouse current2 = Mouse.current;
			bool flag = current2 != null && current2.leftButton.isPressed;
			bool flag2 = current != null && current.qKey.isPressed;
			bool flag3 = current != null && current.spaceKey.isPressed;
			_fire[1] = flag;
			_fire[0] = flag2;
			_grip[1] = flag3;
			_grip[0] = flag3;
			Vector2 zero = Vector2.zero;
			if (current != null)
			{
				if (current.wKey.isPressed)
				{
					zero.y += 1f;
				}
				if (current.sKey.isPressed)
				{
					zero.y -= 1f;
				}
				if (current.dKey.isPressed)
				{
					zero.x += 1f;
				}
				if (current.aKey.isPressed)
				{
					zero.x -= 1f;
				}
			}
			_steer[1] = zero;
			_steer[0] = zero;
		}

		private static bool Latch(bool held, float value, float press, float release)
		{
			return value > (held ? release : press);
		}

		private static Vector2 Deadzone(Vector2 v)
		{
			return new Vector2((Mathf.Abs(v.x) < StickDeadzone) ? 0f : v.x, (Mathf.Abs(v.y) < StickDeadzone) ? 0f : v.y);
		}
	}
}
