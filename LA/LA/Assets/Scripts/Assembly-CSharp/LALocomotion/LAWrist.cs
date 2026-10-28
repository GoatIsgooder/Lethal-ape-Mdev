using UnityEngine;

namespace LALocomotion
{
	[DefaultExecutionOrder(-150)]
	[DisallowMultipleComponent]
	public class LAWrist : MonoBehaviour
	{
		[Tooltip("Tracked controller to follow.")]
		public Transform source;

		[Tooltip("Optional: the wrist holds still while this player is paused for the system menu.")]
		public LAPlayer player;

		[Tooltip("Shift from the controller in its own space (Slop's Long Arms). Scales with the rig.")]
		public Vector3 offset;

		[Tooltip("Stretches the hand away from the head: 1 = real reach.")]
		public float reach = 1f;

		private void OnEnable()
		{
			Snap();
		}

		private void Update()
		{
			if (player != null && player.inOverlay)
			{
				return;
			}
			Snap();
		}

		public void Snap()
		{
			if (source == null)
			{
				return;
			}
			Vector3 position = source.position;
			if (offset != Vector3.zero)
			{
				position += source.rotation * (offset * ((player != null) ? player.Scale : 1f));
			}
			if (reach != 1f && player != null)
			{
				Vector3 headPosition = player.HeadPosition;
				position = headPosition + reach * (position - headPosition);
			}
			transform.SetPositionAndRotation(position, source.rotation);
		}
	}
}
