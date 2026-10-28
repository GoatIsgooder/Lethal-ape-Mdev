using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public struct RiftAvatar
	{
		public int actor;

		public Vector3 head;

		public Vector3 leftHand;

		public Vector3 rightHand;

		public bool isLocal;

		public Vector3 Hand(bool left)
		{
			return left ? leftHand : rightHand;
		}
	}
}
