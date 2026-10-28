using System;
using UnityEngine;

namespace LALocomotion
{
	[Serializable]
	public class LASurfaceSound
	{
		[Tooltip("Matched against the touched collider's physics material (exact, or by name for instanced copies).")]
		public PhysicsMaterial material;

		public AudioClip[] clips;

		[Range(0f, 1f)]
		public float volume = 1f;
	}
}
