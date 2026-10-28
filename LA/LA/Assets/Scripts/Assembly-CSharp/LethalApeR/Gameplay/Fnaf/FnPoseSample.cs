using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public struct FnPoseSample
	{
		public byte Id;

		public Vector3 Position;

		public float Yaw;

		public float HeadYaw;

		public float HeadPitch;

		public FnAiState State;

		public float Speed;

		public byte Flags;

		public float Gait;

		public bool Has(byte flag)
		{
			return (Flags & flag) != 0;
		}
	}
}
