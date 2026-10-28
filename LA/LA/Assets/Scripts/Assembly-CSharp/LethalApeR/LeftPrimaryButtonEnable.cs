using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	public class LeftPrimaryButtonEnable : MonoBehaviour
	{
		[Header("Target")]
		[Tooltip("GameObject to enable when the left controller's primary (X) button is pressed.")]
		[SerializeField]
		private GameObject target;

		[Tooltip("If on, each press toggles the target on/off. If off, press only enables (and never disables).")]
		[SerializeField]
		private bool toggle = true;

		[Header("Audio")]
		[SerializeField]
		private AudioSource audioSource;

		[SerializeField]
		private AudioClip clipOverride;

		[Header("Haptics")]
		[SerializeField]
		private bool enableHaptics = true;

		[Range(0f, 1f)]
		[SerializeField]
		private float hapticAmplitude = 0.6f;

		[SerializeField]
		private float hapticDuration = 0.1f;

		private InputDevice leftController;

		private bool wasPressedLastFrame;

		private static readonly List<InputDevice> _buffer = new List<InputDevice>();

		private void Update()
		{
			bool value = false;
			if (target == null)
			{
				return;
			}
			if (!leftController.isValid)
			{
				InputDevices.GetDevicesWithCharacteristics(InputDeviceCharacteristics.Left | InputDeviceCharacteristics.Controller, _buffer);
				if (_buffer.Count == 0)
				{
					return;
				}
				leftController = _buffer[0];
			}
			if (!leftController.TryGetFeatureValue(CommonUsages.primaryButton, out value))
			{
				return;
			}
			if (value && !wasPressedLastFrame)
			{
				if (toggle)
				{
					target.SetActive(!target.activeSelf);
				}
				else if (!target.activeSelf)
				{
					target.SetActive(true);
				}
				PlayPressFeedback();
			}
			wasPressedLastFrame = value;
		}

		private void PlayPressFeedback()
		{
			if (audioSource != null)
			{
				AudioClip audioClip = ((clipOverride != null) ? clipOverride : audioSource.clip);
				if (audioClip != null)
				{
					audioSource.PlayOneShot(audioClip, 1f);
				}
			}
			if (enableHaptics && leftController.isValid)
			{
				leftController.SendHapticImpulse(0u, hapticAmplitude, hapticDuration);
			}
		}
	}
}
