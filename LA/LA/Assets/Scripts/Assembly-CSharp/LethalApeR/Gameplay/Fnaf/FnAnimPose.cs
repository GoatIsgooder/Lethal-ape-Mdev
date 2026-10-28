using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public struct FnAnimPose
	{
		public bool Active;

		public Vector3 Position;

		public float Yaw;

		public Vector3 HeadPosition;

		public Vector3 HeadForward;

		public FnAiState State;

		public float Speed;

		public bool EyesLit;

		public bool Frozen;

		public bool PoweredDown;

		public int Target;
	}
}
