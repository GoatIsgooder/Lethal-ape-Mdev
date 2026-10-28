using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	public struct PumpkinAvatar
	{
		public int actor;

		public Transform head;

		public Transform leftHand;

		public Transform rightHand;

		public float scale;

		public PumpkinBody Body => new PumpkinBody
		{
			head = head.position,
			headRadius = scale * 0.2f,
			torsoTop = head.position + Vector3.down * (scale * 0.25f),
			torsoBottom = head.position + Vector3.down * (scale * 0.8f),
			torsoRadius = scale * 0.2f
		};

		public Transform Hand(bool left)
		{
			if (!left)
			{
				return rightHand;
			}
			return leftHand;
		}
	}
}
