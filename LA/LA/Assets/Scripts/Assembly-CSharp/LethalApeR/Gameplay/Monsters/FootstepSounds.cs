using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public class FootstepSounds : MonoBehaviour
	{
		private const float TELEPORT_DISTANCE_THRESHOLD = 5f;

		private const float MIN_MOVE_SQR = 1E-06f;

		private const int MAX_STEPS_PER_FRAME = 2;

		private Vector3 previousPosition;

		private float distanceAccumulator;

		[Header("Footsteps")]
		public AudioSource source;

		public AudioClip[] defaultFootstepSounds;

		public float footstepLength = 0.5f;

		public float maxRaycastDistance = 1.5f;

		public LayerMask surfaceLayerMask;

		[Range(0.8f, 1.2f)]
		public float minPitch = 0.9f;

		[Range(0.8f, 1.2f)]
		public float maxPitch = 1.1f;

		private RaycastHit groundHit;

		private bool isGrounded;

		private Transform cachedTransform;

		private float teleportThresholdSqr;

		private void Start()
		{
			cachedTransform = base.transform;
			previousPosition = cachedTransform.position;
			distanceAccumulator = 0f;
			teleportThresholdSqr = 25f;
			if (source == null || defaultFootstepSounds == null || defaultFootstepSounds.Length == 0 || footstepLength <= 0f)
			{
				base.enabled = false;
			}
		}

		private void Update()
		{
			Vector3 position = cachedTransform.position;
			Vector3 vector = position - previousPosition;
			previousPosition = position;
			float sqrMagnitude = vector.sqrMagnitude;
			if (sqrMagnitude < 1E-06f)
			{
				return;
			}
			if (sqrMagnitude > teleportThresholdSqr)
			{
				distanceAccumulator = 0f;
				return;
			}
			distanceAccumulator += Mathf.Sqrt(sqrMagnitude);
			if (distanceAccumulator < footstepLength)
			{
				return;
			}
			isGrounded = CheckGrounded();
			if (!isGrounded)
			{
				return;
			}
			int num = (int)(distanceAccumulator / footstepLength);
			if (num < 1)
			{
				return;
			}
			if (num > 2)
			{
				num = 2;
				distanceAccumulator = 0f;
			}
			else
			{
				distanceAccumulator -= footstepLength * (float)num;
			}
			AudioClip[] footstepSounds = GetFootstepSounds();
			if (footstepSounds == null || footstepSounds.Length == 0)
			{
				return;
			}
			for (int i = 0; i < num; i++)
			{
				AudioClip audioClip = footstepSounds[Random.Range(0, footstepSounds.Length)];
				if (!(audioClip == null))
				{
					source.pitch = Random.Range(minPitch, maxPitch);
					source.PlayOneShot(audioClip);
				}
			}
		}

		private bool CheckGrounded()
		{
			return Physics.Raycast(cachedTransform.position, Vector3.down, out groundHit, maxRaycastDistance, surfaceLayerMask, QueryTriggerInteraction.Ignore);
		}

		private AudioClip[] GetFootstepSounds()
		{
			return defaultFootstepSounds;
		}
	}
}
