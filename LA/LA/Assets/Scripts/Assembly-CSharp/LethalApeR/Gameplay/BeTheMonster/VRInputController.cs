using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class VRInputController : MonoBehaviour
	{
		public struct SimulatedButtons
		{
			public bool primary;

			public bool secondary;

			public Vector2 stick;

			public bool stickClick;

			public bool menu;
		}

		public static VRInputController Instance;

		private const string PlaceholderPrefix = "[Auto]";

		private static readonly List<InputDevice> Lookup = new List<InputDevice>();

		private InputDevice _left;

		private InputDevice _right;

		private float _simLeftGrip = -1f;

		private float _simLeftTrigger = -1f;

		private float _simRightGrip = -1f;

		private float _simRightTrigger = -1f;

		private SimulatedButtons _simLeftButtons;

		private SimulatedButtons _simRightButtons;

		public Vector3 LeftControllerVelocity { get; private set; }

		public Vector3 RightControllerVelocity { get; private set; }

		public float LeftGripValue { get; private set; }

		public float RightGripValue { get; private set; }

		public float LeftTriggerValue { get; private set; }

		public float RightTriggerValue { get; private set; }

		public bool LeftPrimaryButton { get; private set; }

		public bool RightPrimaryButton { get; private set; }

		public bool LeftSecondaryButton { get; private set; }

		public bool RightSecondaryButton { get; private set; }

		public Vector2 LeftJoystick { get; private set; }

		public Vector2 RightJoystick { get; private set; }

		public bool LeftJoystickClick { get; private set; }

		public bool RightJoystickClick { get; private set; }

		public bool LeftMenuButton { get; private set; }

		public InputDevice LeftController => _left;

		public InputDevice RightController => _right;

		public void Simulate(bool left, float grip, float trigger)
		{
			if (left)
			{
				_simLeftGrip = grip;
				_simLeftTrigger = trigger;
			}
			else
			{
				_simRightGrip = grip;
				_simRightTrigger = trigger;
			}
		}

		public void Simulate(bool left, SimulatedButtons buttons)
		{
			if (left)
			{
				_simLeftButtons = buttons;
			}
			else
			{
				_simRightButtons = buttons;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void EnsureRuntimeInstance()
		{
			if (!(Instance != null))
			{
				VRInputController existing = Object.FindObjectOfType<VRInputController>();
				if (existing != null)
				{
					Instance = existing;
					return;
				}
				GameObject go = new GameObject("[Auto] VRInputController");
				Object.DontDestroyOnLoad(go);
				go.AddComponent<VRInputController>();
			}
		}

		private void Awake()
		{
			VRInputController previous = Instance;
			Instance = this;
			if (!(previous == null) && !(previous == this) && previous.gameObject != null && previous.gameObject.name.StartsWith(PlaceholderPrefix))
			{
				Object.Destroy(previous.gameObject);
			}
		}

		private void Update()
		{
			Reacquire(ref _left, InputDeviceCharacteristics.Left, XRNode.LeftHand);
			Reacquire(ref _right, InputDeviceCharacteristics.Right, XRNode.RightHand);
			bool leftLive = _left.isValid;
			if (leftLive)
			{
				LeftGripValue = Read(_left, live: true, CommonUsages.grip);
				LeftTriggerValue = Read(_left, live: true, CommonUsages.trigger);
				LeftPrimaryButton = Read(_left, live: true, CommonUsages.primaryButton);
				LeftSecondaryButton = Read(_left, live: true, CommonUsages.secondaryButton);
				LeftJoystick = Read(_left, live: true, CommonUsages.primary2DAxis);
				LeftJoystickClick = Read(_left, live: true, CommonUsages.primary2DAxisClick);
				LeftMenuButton = Read(_left, live: true, CommonUsages.menuButton);
			}
			else
			{
				LeftGripValue = Simulated(_simLeftGrip);
				LeftTriggerValue = Simulated(_simLeftTrigger);
				LeftPrimaryButton = _simLeftButtons.primary;
				LeftSecondaryButton = _simLeftButtons.secondary;
				LeftJoystick = _simLeftButtons.stick;
				LeftJoystickClick = _simLeftButtons.stickClick;
				LeftMenuButton = _simLeftButtons.menu;
			}
			LeftControllerVelocity = Read(_left, leftLive, CommonUsages.deviceVelocity);
			bool rightLive = _right.isValid;
			if (rightLive)
			{
				RightGripValue = Read(_right, live: true, CommonUsages.grip);
				RightTriggerValue = Read(_right, live: true, CommonUsages.trigger);
				RightPrimaryButton = Read(_right, live: true, CommonUsages.primaryButton);
				RightSecondaryButton = Read(_right, live: true, CommonUsages.secondaryButton);
				RightJoystick = Read(_right, live: true, CommonUsages.primary2DAxis);
				RightJoystickClick = Read(_right, live: true, CommonUsages.primary2DAxisClick);
			}
			else
			{
				RightGripValue = Simulated(_simRightGrip);
				RightTriggerValue = Simulated(_simRightTrigger);
				RightPrimaryButton = _simRightButtons.primary;
				RightSecondaryButton = _simRightButtons.secondary;
				RightJoystick = _simRightButtons.stick;
				RightJoystickClick = _simRightButtons.stickClick;
			}
			RightControllerVelocity = Read(_right, rightLive, CommonUsages.deviceVelocity);
		}

		public void PulseLeft(float amplitude, float duration)
		{
			SendPulse(_left, amplitude, duration);
		}

		public void PulseRight(float amplitude, float duration)
		{
			SendPulse(_right, amplitude, duration);
		}

		private static void Reacquire(ref InputDevice device, InputDeviceCharacteristics hand, XRNode node)
		{
			if (!device.isValid)
			{
				InputDevices.GetDevicesWithCharacteristics(hand | InputDeviceCharacteristics.Controller, Lookup);
				device = ((Lookup.Count > 0) ? Lookup[0] : InputDevices.GetDeviceAtXRNode(node));
			}
		}

		private static void SendPulse(InputDevice device, float amplitude, float duration)
		{
			if (device.isValid && device.TryGetHapticCapabilities(out var capabilities) && capabilities.supportsImpulse)
			{
				device.SendHapticImpulse(0u, Mathf.Clamp01(amplitude), Mathf.Max(0f, duration));
			}
		}

		private static float Simulated(float value)
		{
			return Mathf.Max(value, 0f);
		}

		private static float Read(InputDevice device, bool live, InputFeatureUsage<float> usage)
		{
			float value = 0f;
			if (live)
			{
				device.TryGetFeatureValue(usage, out value);
			}
			return value;
		}

		private static bool Read(InputDevice device, bool live, InputFeatureUsage<bool> usage)
		{
			bool value = false;
			if (live)
			{
				device.TryGetFeatureValue(usage, out value);
			}
			return value;
		}

		private static Vector2 Read(InputDevice device, bool live, InputFeatureUsage<Vector2> usage)
		{
			Vector2 value = Vector2.zero;
			if (live)
			{
				device.TryGetFeatureValue(usage, out value);
			}
			return value;
		}

		private static Vector3 Read(InputDevice device, bool live, InputFeatureUsage<Vector3> usage)
		{
			Vector3 value = Vector3.zero;
			if (live)
			{
				device.TryGetFeatureValue(usage, out value);
			}
			return value;
		}
	}
}
