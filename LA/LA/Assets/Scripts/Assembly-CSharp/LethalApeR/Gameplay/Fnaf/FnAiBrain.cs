using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	internal sealed class FnAiBrain
	{
		public const int MaxGuards = 3;

		public FnAnim Id;

		public FnAnimatronic Body;

		public FnAnimTuning T;

		public FnAiState State;

		public int Arg;

		public double StateSince;

		public double StateUntil;

		public int Level;

		public int LevelOverride = -1;

		public FnDoorSide Side;

		public int JamSide = -1;

		public int HomeNode = -1;

		public int[] Favourites = new int[0];

		public int GoalNode = -1;

		public int CurNode = -1;

		public int WayNode = -1;

		public bool HasGoalPoint;

		public Vector3 GoalPoint;

		public bool Direct;

		public Vector3 DirectPoint;

		public bool ViaDoorway;

		public FnDoorSide ExitSide;

		public bool Arrived = true;

		public bool Running;

		public float SpeedScale = 1f;

		public Vector3 Pos;

		public float Yaw;

		public float Speed;

		public Vector3 Velocity;

		public float Gait;

		public bool HasFace;

		public float FaceYaw;

		public FnLook Look;

		public Vector3 LookPoint;

		public int LookActor;

		public float HeadYaw;

		public float HeadPitch;

		public double NextGlance;

		public float GlanceYaw;

		public float GlancePitch;

		public readonly float[] Spot = new float[3];

		public readonly bool[] Seen = new bool[3];

		public readonly float[] OverlapSince = new float[3];

		public int Target;

		public Vector3 LastKnown;

		public float LastKnownFloorY;

		public double LastSeen;

		public bool KneeClear;

		public double KneeAt;

		public double PerchSince;

		public int PerchNode = -1;

		public bool Idle = true;

		public double NextMove;

		public double NextClatter;

		public int SearchCenter = -1;

		public bool Lingering;

		public bool SleepOnArrival;

		public int KnocksLeft;

		public bool KnockExtended;

		public bool FromChase;

		public double NextBang;

		public bool Staring;

		public bool StareCued;

		public bool BangedOnce;

		public double OfficeCooldownUntil;

		public bool AtStand;

		public bool MusicBoxAsked;

		public bool Frozen;

		public bool WasMoving;

		public double LastLaugh = double.NegativeInfinity;

		public float CoveProgress;

		public int CoveStage = -1;

		public float Repel;

		public double RepelCooldownUntil;

		public FnJumpPhase Jump;

		public int JumpTarget;

		public bool HasJumpSpot;

		public Vector3 JumpSpot;

		public Vector3 JumpPlanHead;

		public float JumpPlanRise;

		public float JumpWindup;

		public float JumpCharged;

		public float JumpLanded;

		public int JumpAttempts;

		public double JumpReadyAt;

		public double JumpSearchAt;

		public Vector3 JumpSearchHead;

		public bool Pouncing;

		public bool PouncedThisSprint;

		public bool HasArc;

		public Vector3 ArcFrom;

		public float ArcRise;

		public float ArcHang;

		public float ArcLiftoff;

		public int Victim;

		public FnCatchCause VictimCause;

		public bool SnapStateDirty;

		public double LastSnapAt = double.NegativeInfinity;

		public Vector3 SnapPos;

		public float SnapYaw;

		public float SnapInterest;

		public bool EverSent;

		public Vector3 SentPos;

		public float SentYaw;

		public float SentHeadYaw;

		public float SentHeadPitch;

		public byte SentState;

		public byte SentFlags;

		public byte SentSpeed;

		public int RestSends;

		public byte Flags
		{
			get
			{
				byte b = 0;
				if (State != FnAiState.Dormant && State != FnAiState.PoweredDown)
				{
					b |= FnPoseCodec.FlagEyesLit;
				}
				if (Frozen)
				{
					b |= FnPoseCodec.FlagFrozen;
				}
				if (State == FnAiState.Attack)
				{
					b |= FnPoseCodec.FlagLunging;
				}
				if (Running && Speed > 0.1f)
				{
					b |= FnPoseCodec.FlagSprinting;
				}
				if (State == FnAiState.PoweredDown)
				{
					b |= FnPoseCodec.FlagPoweredDown;
				}
				if (Jump == FnJumpPhase.Charge)
				{
					b |= FnPoseCodec.FlagJumpCharge;
				}
				if (Jump == FnJumpPhase.Air)
				{
					b |= FnPoseCodec.FlagAirborne;
				}
				return b;
			}
		}

		public void ClearSenses()
		{
			for (int i = 0; i < 3; i++)
			{
				Spot[i] = 0f;
				Seen[i] = false;
				OverlapSince[i] = -1f;
			}
			Target = 0;
			KneeClear = false;
			KneeAt = double.NegativeInfinity;
			PerchSince = 0.0;
			PerchNode = -1;
			ForgetJumpPlan();
		}

		public void ForgetJumpPlan()
		{
			JumpTarget = 0;
			HasJumpSpot = false;
			JumpAttempts = 0;
			JumpReadyAt = 0.0;
			JumpSearchAt = 0.0;
			Pouncing = false;
		}

		public void ResetJump()
		{
			Jump = FnJumpPhase.None;
			JumpCharged = 0f;
			JumpLanded = 0f;
			ForgetJumpPlan();
			PouncedThisSprint = false;
			HasArc = false;
		}

		public void StopMoving()
		{
			GoalNode = -1;
			WayNode = -1;
			HasGoalPoint = false;
			Direct = false;
			ViaDoorway = false;
			Arrived = true;
			Running = false;
			SpeedScale = 1f;
		}

		public void Sample(out FnPoseSample p)
		{
			p = new FnPoseSample
			{
				Id = (byte)Id,
				Position = Pos,
				Yaw = Yaw,
				State = State,
				HeadYaw = HeadYaw,
				HeadPitch = HeadPitch,
				Speed = Speed,
				Flags = Flags,
				Gait = Gait
			};
		}
	}
}
