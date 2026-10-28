using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public struct FnPuppetInput
	{
		public float Speed;

		public Vector3 Velocity;

		public float Gait;

		public float StrideLength;

		public FnAiState State;

		public bool Frozen;

		public bool PoweredDown;

		public bool Lunging;

		public bool Home;

		public float HeadYaw;

		public float HeadPitch;

		public bool HasLook;

		public Vector3 LookPoint;

		public float Droop;

		public float Lunge;

		public float BangAge;

		public int BangCount;

		public bool BangHeavy;

		public int KnockRaps;

		public float KnockInterval;

		public bool HasDoor;

		public Vector3 DoorPoint;

		public Vector3 DoorNormal;

		public float DoorHalfWidth;

		public float LaughLeft;

		public float StareLeft;

		public float ShriekLeft;

		public bool Music;

		public bool JumpCharge;

		public float JumpChargeAge;

		public bool Airborne;

		public float Lift;

		public float VerticalSpeed;

		public float LandAge;

		public float LandImpact;

		public bool InTank;

		public Vector3 TankCentre;

		public float TankRadius;

		public float Dt;
	}
}
