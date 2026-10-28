using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public struct FnAiDebugInfo
	{
		public bool Valid;

		public bool FromBrain;

		public FnAiState State;

		public int Arg;

		public int Level;

		public int LevelOverride;

		public bool Frozen;

		public int Target;

		public int GoalNode;

		public int CurrentNode;

		public int Knocks;

		public float CoveProgress;

		public float Spot0;

		public float Spot1;

		public float Spot2;

		public float StateSecondsLeft;

		public float OfficeCooldownLeft;

		public Vector3 Position;

		public float Speed;

		public int JumpPhase;

		public int JumpAttempts;
	}
}
