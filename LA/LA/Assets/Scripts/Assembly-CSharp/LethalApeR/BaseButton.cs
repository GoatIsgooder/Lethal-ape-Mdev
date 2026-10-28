using System;
using System.Reflection;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class BaseButton : MonoBehaviour
	{
		[Header("Audio Settings")]
		[SerializeField]
		private AudioSource audioSource;

		[Header("Haptic Settings")]
		[SerializeField]
		private bool enableHaptics = true;

		[SerializeField]
		[Range(0f, 1f)]
		private float hapticAmplitude = 0.5f;

		[SerializeField]
		private float hapticDuration = 0.1f;

		protected bool pressedWithLeft;

		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				string name = other.gameObject.name;
				bool flag = name.Contains("LeftFinger") || name.Contains("L_end") || other.CompareTag("LFinger");
				pressedWithLeft = flag;
				try
				{
					OnButtonPressed(flag);
				}
				catch (Exception arg)
				{
					Debug.LogError(string.Format("[BaseButton] OnButtonPressed exception: {0}", arg));
				}
				try
				{
					ButtonVisuals(flag);
				}
				catch (Exception arg2)
				{
					Debug.LogError(string.Format("[BaseButton] ButtonVisuals exception: {0}", arg2));
				}
			}
		}

		public virtual void ButtonVisuals(bool isLeft)
		{
			if (enableHaptics)
			{
				SendHaptic(hapticAmplitude, hapticDuration, isLeft);
			}
			if (audioSource != null && audioSource.clip != null)
			{
				audioSource.PlayOneShot(audioSource.clip);
			}
		}

		protected virtual void SendHaptic(float amplitude, float duration, bool isLeft)
		{
			InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(isLeft ? XRNode.LeftHand : XRNode.RightHand);
			if (deviceAtXRNode.isValid)
			{
				deviceAtXRNode.SendHapticImpulse(0u, amplitude, duration);
			}
		}

		public virtual void OnButtonPressed(bool isLeft)
		{
		}
	}
}
