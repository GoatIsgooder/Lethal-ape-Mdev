using System;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.UI
{
	public class LeaderboardButton : MonoBehaviour
	{
		[Header("Haptics")]
		[SerializeField]
		private bool enableHaptics = true;

		[SerializeField]
		private float hapticAmplitude = 0.4f;

		[SerializeField]
		private float hapticDuration = 0.08f;

		[Header("Audio")]
		[SerializeField]
		private AudioSource audioSource;

		[SerializeField]
		private AudioClip pressClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float pressVolume = 1f;

		private float _nextPress;

		private const float Cooldown = 0.4f;

		public event Action OnPressed;

		private void OnTriggerEnter(Collider other)
		{
			if (other?.CompareTag("HandTag") ?? false)
			{
				TryPress(FingertipHand.IsLeft(other));
			}
		}

		private void OnCollisionEnter(Collision col)
		{
			if (col?.collider?.CompareTag("HandTag") ?? false)
			{
				TryPress(FingertipHand.IsLeft(col.collider));
			}
		}

		private void TryPress(bool isLeft)
		{
			if (!(Time.time < _nextPress))
			{
				_nextPress = Time.time + 0.4f;
				if (enableHaptics)
				{
					SendHaptic(isLeft);
				}
				PlayPressSfx();
				this.OnPressed?.Invoke();
			}
		}

		private void SendHaptic(bool isLeft)
		{
			InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(isLeft ? XRNode.LeftHand : XRNode.RightHand);
			if (deviceAtXRNode.isValid)
			{
				deviceAtXRNode.SendHapticImpulse(0u, hapticAmplitude, hapticDuration);
			}
		}

		private void PlayPressSfx()
		{
			AudioClip audioClip = ((pressClip != null) ? pressClip : ((audioSource != null) ? audioSource.clip : null));
			if (!(audioClip == null))
			{
				if (audioSource != null)
				{
					audioSource.PlayOneShot(audioClip, pressVolume);
				}
				else
				{
					AudioSource.PlayClipAtPoint(audioClip, base.transform.position, pressVolume);
				}
			}
		}
	}
}
