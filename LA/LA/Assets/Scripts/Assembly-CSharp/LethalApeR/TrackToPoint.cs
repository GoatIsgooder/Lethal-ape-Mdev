using UnityEngine;

namespace LethalApeR
{
	public class TrackToPoint : MonoBehaviour
	{
		[Tooltip("The child object that moves to the target.")]
		public Transform childToMove;

		[Tooltip("The point to track towards.")]
		public Transform target;

		[Tooltip("How fast the child moves. Set to 0 for instant snap.")]
		public float followSpeed = 10f;

		[Tooltip("Also match the target's rotation.")]
		public bool matchRotation;

		private void Update()
		{
			if (childToMove == null || target == null)
			{
				return;
			}
			if (followSpeed > 0f)
			{
				float t = 1f - Mathf.Exp((0f - followSpeed) * Time.deltaTime);
				Vector3 position = Vector3.LerpUnclamped(childToMove.position, target.position, t);
				if (matchRotation)
				{
					childToMove.SetPositionAndRotation(position, Quaternion.LerpUnclamped(childToMove.rotation, target.rotation, t));
				}
				else
				{
					childToMove.position = position;
				}
			}
			else if (matchRotation)
			{
				childToMove.SetPositionAndRotation(target.position, target.rotation);
			}
			else
			{
				childToMove.position = target.position;
			}
		}
	}
}
