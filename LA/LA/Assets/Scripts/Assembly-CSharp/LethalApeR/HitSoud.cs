using System;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	public class HitSoud : MonoBehaviour
	{
		[Serializable]
		public class FootstepSounds
		{
			public PhysicsMaterial physicMaterial;

			public AudioClip[] footstepClips;
		}

		public FootstepSounds[] footstepSounds;

		public AudioSource audioSource;

		public bool isLeftHand;

		public float globalHapticIntensity = 0.5f;

		public float globalHapticDuration = 0.1f;

		private InputDevice controller;

		private void OnTriggerEnter(Collider collision)
		{
			if (footstepSounds.Length == 0)
			{
				return;
			}
			PhysicsMaterial material = collision.material;
			if (material == null)
			{
				return;
			}
			string text = material.name;
			for (int i = 0; i < footstepSounds.Length; i++)
			{
				FootstepSounds item = footstepSounds[i];
				if (text.Contains(item.physicMaterial.name))
				{
					PlayAnyOf(item.footstepClips);
					Buzz();
					break;
				}
			}
		}

		private void PlayAnyOf(AudioClip[] clips)
		{
			if (clips.Length != 0)
			{
				AudioClip audioClip = clips[UnityEngine.Random.Range(0, clips.Length)];
				if (audioClip != null)
				{
					audioSource.PlayOneShot(audioClip, 1f);
				}
			}
		}

		private void Buzz()
		{
			if (!controller.isValid)
			{
				controller = InputDevices.GetDeviceAtXRNode(isLeftHand ? XRNode.LeftHand : XRNode.RightHand);
			}
			if (controller.isValid)
			{
				controller.SendHapticImpulse(0u, globalHapticIntensity, globalHapticDuration);
			}
		}
	}
}
