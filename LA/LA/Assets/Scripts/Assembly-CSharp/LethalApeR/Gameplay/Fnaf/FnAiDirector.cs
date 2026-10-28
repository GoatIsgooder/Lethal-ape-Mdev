using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(-100)]
	public class FnAiDirector : MonoBehaviourPunCallbacks
	{
		private struct AnimSnapshot
		{
			public FnAiState State;

			public int Node;

			public int Target;

			public float Interest;

			public Vector3 Position;

			public float Yaw;

			public double StateUntil;

			public double CooldownUntil;
		}

		private struct GuardView
		{
			public int Actor;

			public bool Alive;

			public bool HasHead;

			public Vector3 Head;

			public Vector3 Velocity;

			public float FloorY;

			public bool Flashlight;

			public bool HasHand;

			public Vector3 HandPosition;

			public Vector3 HandForward;

			public int Camera;

			public bool Lit;

			public bool InOffice;
		}

		private const float LungeStopDistance = 0.45f;

		private readonly float[] _reportNext = new float[4];

		private bool _localCaught;

		private const float JumpBodyRadius = 0.3f;

		private const float JumpBodyTop = 1.75f;

		private const float JumpWalkRadius = 0.25f;

		private const float JumpWalkLow = 0.3f;

		private const float JumpWalkHigh = 1.4f;

		private const float JumpFloorTolerance = 0.3f;

		private const float JumpSpotSpacing = 0.65f;

		private const float JumpSpotArrive = 0.2f;

		private const float JumpReplanDistance = 0.35f;

		private const float JumpReplanHead = 0.6f;

		private const float JumpRiseSlack = 0.2f;

		private const float JumpRiseStep = 0.3f;

		private const int JumpRiseSteps = 3;

		private const float JumpSearchRetrySeconds = 1.5f;

		private const float JumpCommitShare = 0.5f;

		private const float JumpSettleSpeed = 0.8f;

		private const float JumpPoseHz = 30f;

		private const float PounceWindupScale = 0.75f;

		private static readonly float[] JumpRadii = new float[] { 0.45f, 0.7f, 0.95f };

		private static readonly float[] JumpBearings = new float[] { 0f, 45f, -45f, 90f, -90f, 135f, -135f, 180f };

		private int _jumpSearchFrame = -1;

		private bool _sendPosesNow;

		private const float ArriveRadius = 0.3f;

		private const float DirectArriveRadius = 0.15f;

		private const float KneeHeight = 0.5f;

		private const float OffGraphDistance = 3f;

		private const int EntryRays = 4;

		private const int WaitForRays = -2;

		private const float DormantPitch = -8f;

		private const float MaxHeadYaw = 80f;

		private const float MaxHeadPitch = 45f;

		private const FnAiState Unset = (FnAiState)255;

		private static readonly RaiseEventOptions PoseTargets = new RaiseEventOptions { Receivers = ReceiverGroup.Others };

		private readonly byte[][] _poseBuffers = new byte[4][] { new byte[FnPoseCodec.PacketSize(1)], new byte[FnPoseCodec.PacketSize(2)], new byte[FnPoseCodec.PacketSize(3)], new byte[FnPoseCodec.PacketSize(4)] };

		private readonly FnPoseSample[] _outgoing = new FnPoseSample[4];

		private ushort _poseSequence;

		private float _nextPoseSend;

		private bool _forceFullSend;

		private bool _haveSequence;

		private ushort _lastSequence;

		private LoadBalancingClient _poseClient;

		private const float EndoBangDelay = 0.2f;

		private const float EndoBangHold = 0.9f;

		private const float KnockStepScale = 0.55f;

		private const float StandArrive = 0.12f;

		private const float DoorEnterSpeedScale = 1.3f;

		private const float CoveSpeedScale = 0.6f;

		private const float RepelCooldown = 3f;

		private const float InsideLookDepth = 1.5f;

		private const float HeadHeight = 1.4f;

		private const int MaxReporters = 8;

		private const float OfficeNoiseSlack = 0.25f;

		private readonly int[] _watchActors = new int[MaxReporters];

		private readonly bool[] _watching = new bool[MaxReporters];

		private readonly int[] _noiseActors = new int[MaxReporters];

		private readonly float[] _noiseTokens = new float[MaxReporters];

		private readonly double[] _noiseRefill = new double[MaxReporters];

		private const float ChestHeight = 1.2f;

		private const double KneeFreshSeconds = 0.6;

		private readonly GuardView[] _guards = new GuardView[FnAiBrain.MaxGuards];

		private int _guardSlots;

		private int _rays;

		private float _nextSense;

		private float _lastSense;

		private int _senseRotor;

		private const float InvestigateTimeout = 30f;

		private const float SearchSpeedScale = 1.1f;

		private const float PerchBaseRange = 4f;

		private const float PerchArrive = 0.6f;

		[Tooltip("Index = FnAnim: Bear, Bunny, Chicken, Endo. An empty slot runs the night without that animatronic.")]
		public FnAnimatronic[] animatronics = new FnAnimatronic[4];

		[Tooltip("The walk graph (its levelMask is the line-of-sight mask for every AI ray).")]
		public FnWaypointGraph graph;

		[Header("Behaviour")]
		[Tooltip("A lit hall light draws animatronics within this distance of that door's outside node (m).")]
		public float hallLightAttractRange = 8f;

		[Tooltip("A guard within this distance of a lit hall light's door counts as lit for sight (m).")]
		public float hallLightLitRange = 6f;

		[Tooltip("Chance a patrol leg heads for one of the animatronic's favourite nodes.")]
		[Range(0f, 1f)]
		public float favouriteWeight = 0.6f;

		[Tooltip("Chicken's clatter while idling at a favourite node (s, random in range).")]
		public Vector2 kitchenClatterInterval = new Vector2(5f, 11f);

		[Tooltip("How long an investigation lingers at the spot (s, random in range).")]
		public Vector2 investigateLinger = new Vector2(2f, 4f);

		[Tooltip("Search wanders among nodes within this path distance of the last-known node (m).")]
		public float searchRadius = 10f;

		[Tooltip("A bored animatronic retreats at least this far (path distance) from the door (m).")]
		public float retreatMinDistance = 14f;

		[Tooltip("How far back from the doorway an animatronic stands to wait, knock or peek (m): an arm's reach from the door.")]
		public float doorStandDepth = 1f;

		[Tooltip("Per animatronic (FnAnim order), added to doorStandDepth: each stands where its arm reaches the door comfortably (Sandman and Ash on long crawler arms stand back, Gus closer).")]
		public float[] doorStandDepthOffsets = new float[4] { 0.35f, -0.5f, 0.35f, 0f };

		[Tooltip("Lateral stand offset at an office door, per animatronic (m across the doorway), so two never overlap. Near a jamb it can grip the frame.")]
		public float[] doorStandOffsets = new float[4] { 0.5f, -0.5f, -0.5f, 0.5f };

		[Tooltip("From reaching the door to the first knock (s, random in range).")]
		public Vector2 firstKnockDelay = new Vector2(0.5f, 1.1f);

		[Tooltip("After the last knock: one last look through the door, then it walks away (s, random in range).")]
		public Vector2 lastLookSeconds = new Vector2(1.2f, 2f);

		[Tooltip("From this level an animatronic may end its knocking on a two-fisted slam.")]
		[Range(0f, 20f)]
		public int slamFromLevel = 10;

		[Tooltip("Minimum seconds between Bear's laughs.")]
		public float bearLaughCooldown = 6f;

		[Tooltip("Idle head glances (s between, random in range).")]
		public Vector2 glanceInterval = new Vector2(1.2f, 3.5f);

		[Header("Endo")]
		[Tooltip("Cove meter stages (visible creeps toward the cove mouth). Fill time = stages x movementInterval x 20 / level.")]
		[Range(1f, 8f)]
		public int coveStages = 4;

		[Tooltip("Seconds for a full cove meter to drain while a living guard watches the cove camera.")]
		public float coveDecaySeconds = 12f;

		[Tooltip("How far Endo creeps from its cove spot toward the mouth by the last stage (m, along its authored facing).")]
		public float coveCreep = 1.2f;

		[Header("Debug")]
		[Tooltip("Log every AI state change on the master.")]
		public bool logStateChanges;

		private readonly FnAiBrain[] _brains = new FnAiBrain[4];

		private readonly FnAnimTuning[] _fallbackTuning = new FnAnimTuning[4] { FnAnimTuning.Bear(), FnAnimTuning.Bunny(), FnAnimTuning.Chicken(), FnAnimTuning.Endo() };

		private bool _authority;

		private bool _haveMasterPhase;

		private FnPhase _masterPhase;

		private FnNight _boundNight;

		private int _coveNode = -1;

		private bool _bodiesPlaced;

		private FnSettings.DifficultySettings _mods = FnSettings.DifficultySettings.Neutral;

		private FnOffice Office
		{
			get
			{
				FnNight instance = FnNight.Instance;
				if (instance != null && instance.office != null)
				{
					return instance.office;
				}
				return FnOffice.Instance;
			}
		}

		public static FnAiDirector Instance { get; private set; }

		private static FnSettings S => FnGame.Settings;

		public bool IsAuthority => _authority;

		private void LocalCatchTest(FnNight night)
		{
			if (night.Phase == FnPhase.Briefing)
			{
				_localCaught = false;
			}
			else if (_localCaught)
			{
				return;
			}
			if (night.Phase != FnPhase.Night || !night.LocalIsAlive)
			{
				return;
			}
			Transform head = FnPlatform.Head;
			if (head == null)
			{
				return;
			}
			Vector3 position = head.position;
			FnSettings.CatchSettings catches = S.catches;
			bool flag = Office != null && Office.Contains(position, 0f);
			float time = Time.time;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAnimatronic body = _brains[i].Body;
				if (body == null || !body.HasPose || time < _reportNext[i])
				{
					continue;
				}
				FnPoseSample rendered = body.Rendered;
				if (!FnAiRules.CatchableState(rendered.State) || FnAiRules.DoorShields(rendered.State, flag))
				{
					continue;
				}
				Vector3 position2 = rendered.Position;
				if (!_authority)
				{
					Vector3 renderedVelocity = body.RenderedVelocity;
					position2 += new Vector3(renderedVelocity.x, 0f, renderedVelocity.z) * 0.1f;
				}
				float num = ((!rendered.Has(FnPoseCodec.FlagAirborne) || flag) ? 0f : catches.jumpExtraReach);
				if (FnAiRules.InCatchCapsule(position2, position, catches.reachRadius + num, catches.reachHeight))
				{
					if (graph.Sight(position, position2 + Vector3.up * ChestHeight))
					{
						_reportNext[i] = time + Mathf.Max(catches.reportRetrySeconds, 0.1f);
						FnNet.ToMasterClient(FnRpc.CatchReport, (byte)i, position.x, position.y, position.z);
					}
					else
					{
						_reportNext[i] = time + 0.1f;
					}
				}
			}
		}

		private void OnCatchReport(object[] a, PhotonMessageInfo info)
		{
			if (!_authority || a == null || a.Length < 4 || info.Sender == null)
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			if (instance == null || instance.Phase != FnPhase.Night)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (b >= _brains.Length || _brains[b].Body == null)
			{
				return;
			}
			int actorNumber = info.Sender.ActorNumber;
			FnAiBrain fnAiBrain = _brains[b];
			Vector3 vector = new Vector3(FnNet.F(a[1]), FnNet.F(a[2]), FnNet.F(a[3]));
			if (!FnAiRules.IsFinite(vector))
			{
				return;
			}
			bool reporterAlive = instance.IsAliveGuard(actorNumber);
			if (!FnGame.TryGetHead(actorNumber, out var head))
			{
				return;
			}
			int num = SlotOfActor(actorNumber);
			Vector3 vector2 = ((num >= 0) ? _guards[num].Velocity : Vector3.zero);
			float magnitude = new Vector2(vector2.x, vector2.z).magnitude;
			FnSettings.CatchSettings catches = S.catches;
			int ping = PhotonNetwork.GetPing();
			Vector3 animFeet = fnAiBrain.Pos;
			float num2 = catches.reachRadius;
			if ((Office == null || !Office.Contains(head, 0f)) && ArcFeetForReport(fnAiBrain, ping, out var feet))
			{
				animFeet = feet;
				num2 += catches.jumpExtraReach;
			}
			FnCatchVerdict fnCatchVerdict = FnAiRules.ValidateCatch(fnAiBrain.State, reporterAlive, vector, head, animFeet, fnAiBrain.Speed, magnitude, ping, num2, catches.reachHeight, catches.headTolerance, catches.maxSlack);
			if (fnCatchVerdict != FnCatchVerdict.Accept)
			{
				if (logStateChanges)
				{
					Debug.Log(string.Format("[FnAiDirector] {0} catch report from actor {1} refused: {2}.", fnAiBrain.Id, actorNumber, fnCatchVerdict));
				}
			}
			else
			{
				instance.MasterCatch(actorNumber, fnAiBrain.Id, FnCatchCause.Contact);
			}
		}

		private void Backstop(FnNight night)
		{
			FnSettings.CatchSettings catches = S.catches;
			float time = Time.time;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain fnAiBrain = _brains[i];
				if (fnAiBrain.Body == null)
				{
					continue;
				}
				bool flag = FnAiRules.CatchableState(fnAiBrain.State);
				for (int j = 0; j < 3; j++)
				{
					ref GuardView reference = ref _guards[j];
					if (flag && j < _guardSlots && reference.Alive && reference.HasHead && FnAiRules.InCatchCapsule(fnAiBrain.Pos, reference.Head, catches.reachRadius, catches.reachHeight) && !FnAiRules.DoorShields(fnAiBrain.State, reference.InOffice))
					{
						if (fnAiBrain.OverlapSince[j] < 0f)
						{
							fnAiBrain.OverlapSince[j] = time;
						}
						else if (time - fnAiBrain.OverlapSince[j] >= catches.backstopSeconds && SpendRay())
						{
							fnAiBrain.OverlapSince[j] = time;
							if (graph.Sight(reference.Head, fnAiBrain.Pos + Vector3.up * ChestHeight) && night.MasterCatch(reference.Actor, fnAiBrain.Id, FnCatchCause.Backstop))
							{
								return;
							}
						}
					}
					else
					{
						fnAiBrain.OverlapSince[j] = -1f;
					}
				}
			}
		}

		private void OnCaughtEvent(int actor, FnAnim anim, FnCatchCause cause)
		{
			if (FnGame.LocalActor == actor)
			{
				_localCaught = true;
			}
			if (!_authority)
			{
				return;
			}
			ClearReporter(actor);
			if ((int)anim < _brains.Length)
			{
				FnAiBrain fnAiBrain = _brains[(int)anim];
				if (!(fnAiBrain.Body == null) && fnAiBrain.State != FnAiState.PoweredDown && (fnAiBrain.State != FnAiState.Attack || fnAiBrain.Victim == actor || Ready(FnClock.Now, fnAiBrain.StateUntil)))
				{
					EnterAttack(fnAiBrain, actor, cause);
				}
			}
		}

		private void EnterAttack(FnAiBrain b, int victim, FnCatchCause cause)
		{
			b.Victim = victim;
			b.VictimCause = cause;
			b.Target = victim;
			b.Idle = false;
			double now = FnClock.Now;
			b.StopMoving();
			b.Running = true;
			b.Look = FnLook.Actor;
			b.LookActor = victim;
			b.StateUntil = now + (double)Mathf.Clamp(S.catches.lungeSeconds, 0.2f, 1f);
			SetState(b, FnAiState.Attack, victim);
		}

		private void TickAttack(FnAiBrain b, double now)
		{
			Vector3 head;
			bool flag = HeadOf(b.Victim, out head);
			if (flag)
			{
				float num;
				if (b.Jump == FnJumpPhase.None && !FnAiRules.IsPerched(head.y, b.Pos.y, S.catches.reachHeight) && (num = FnAiRules.HorizontalDistance(b.Pos, head)) > 0.5f)
				{
					Vector3 vector = new Vector3(head.x, b.Pos.y, head.z);
					SteerDirect(b, b.Pos + (vector - b.Pos) * ((num - LungeStopDistance) / num), true, 1.2f);
				}
				else
				{
					b.StopMoving();
					Face(b, head);
				}
			}
			if (Ready(now, b.StateUntil))
			{
				b.StopMoving();
				switch (b.VictimCause)
				{
				case FnCatchCause.Blackout:
					EnterIdle(b);
					break;
				case FnCatchCause.Doorway:
					EnterRetreat(b, true);
					break;
				default:
					EnterSearch(b, flag ? head : b.Pos);
					break;
				}
			}
		}

		private FnAiBrain BrainOf(FnAnim anim)
		{
			if ((int)anim >= _brains.Length)
			{
				return null;
			}
			return _brains[(int)anim];
		}

		public bool TryGetDebugInfo(FnAnim anim, out FnAiDebugInfo info)
		{
			info = default(FnAiDebugInfo);
			FnAiBrain fnAiBrain = BrainOf(anim);
			if (fnAiBrain == null || fnAiBrain.Body == null)
			{
				return false;
			}
			info.Valid = true;
			info.LevelOverride = fnAiBrain.LevelOverride;
			if (_authority)
			{
				double now = FnClock.Now;
				info.FromBrain = true;
				info.State = fnAiBrain.State;
				info.Arg = fnAiBrain.Arg;
				info.Level = fnAiBrain.Level;
				info.Frozen = fnAiBrain.Frozen;
				info.Target = fnAiBrain.Target;
				info.GoalNode = (fnAiBrain.Direct ? (-1) : fnAiBrain.GoalNode);
				info.CurrentNode = fnAiBrain.CurNode;
				info.Knocks = fnAiBrain.KnocksLeft;
				info.CoveProgress = fnAiBrain.CoveProgress;
				info.Spot0 = fnAiBrain.Spot[0];
				info.Spot1 = fnAiBrain.Spot[1];
				info.Spot2 = fnAiBrain.Spot[2];
				info.StateSecondsLeft = ((fnAiBrain.StateUntil > 0.0) ? Mathf.Max(0f, -(float)FnAiRules.Elapsed(now, fnAiBrain.StateUntil)) : 0f);
				info.OfficeCooldownLeft = ((fnAiBrain.OfficeCooldownUntil > 0.0) ? Mathf.Max(0f, -(float)FnAiRules.Elapsed(now, fnAiBrain.OfficeCooldownUntil)) : 0f);
				info.Position = fnAiBrain.Pos;
				info.Speed = fnAiBrain.Speed;
				info.JumpPhase = (int)fnAiBrain.Jump;
				info.JumpAttempts = fnAiBrain.JumpAttempts;
			}
			else
			{
				FnPoseSample rendered = fnAiBrain.Body.Rendered;
				info.State = rendered.State;
				info.Speed = rendered.Speed;
				info.Position = rendered.Position;
				info.Frozen = rendered.Has(FnPoseCodec.FlagFrozen);
				info.Target = fnAiBrain.Body.RenderedTarget;
				info.JumpPhase = (rendered.Has(FnPoseCodec.FlagAirborne) ? 2 : (rendered.Has(FnPoseCodec.FlagJumpCharge) ? 1 : 0));
				info.GoalNode = -1;
				info.CurrentNode = -1;
			}
			return true;
		}

		public void DebugForceState(FnAnim anim, FnAiState state)
		{
			FnAiBrain fnAiBrain = BrainOf(anim);
			if (!_authority || fnAiBrain == null || fnAiBrain.Body == null || graph == null)
			{
				return;
			}
			double now = FnClock.Now;
			switch (state)
			{
			case FnAiState.Dormant:
				EnterDormant(fnAiBrain, true);
				break;
			case FnAiState.Patrol:
				EnterIdle(fnAiBrain);
				break;
			case FnAiState.Investigate:
				EnterInvestigate(fnAiBrain, fnAiBrain.Pos + Quaternion.Euler(0f, fnAiBrain.Yaw, 0f) * Vector3.forward * 6f, -1);
				break;
			case FnAiState.Chase:
			{
				int num2 = NearestLivingSlot(fnAiBrain.Pos);
				if (num2 >= 0)
				{
					EnterChase(fnAiBrain, num2, now);
				}
				break;
			}
			case FnAiState.Search:
				EnterSearch(fnAiBrain, fnAiBrain.Pos);
				break;
			case FnAiState.ApproachOffice:
				EnterApproach(fnAiBrain, fnAiBrain.T.side, false);
				break;
			case FnAiState.DoorWait:
				if (PlaceAtDoor(fnAiBrain, fnAiBrain.T.side))
				{
					EnterDoorWait(fnAiBrain);
				}
				break;
			case FnAiState.DoorBang:
				if (PlaceAtDoor(fnAiBrain, fnAiBrain.T.side))
				{
					EnterDoorBang(fnAiBrain);
				}
				break;
			case FnAiState.DoorEnter:
				if (PlaceAtDoor(fnAiBrain, fnAiBrain.T.side))
				{
					EnterDoorEnter(fnAiBrain);
				}
				break;
			case FnAiState.Retreat:
				EnterRetreat(fnAiBrain, true);
				break;
			case FnAiState.Attack:
			{
				int num = NearestLivingSlot(fnAiBrain.Pos);
				if (num >= 0)
				{
					EnterAttack(fnAiBrain, _guards[num].Actor, FnCatchCause.Contact);
				}
				break;
			}
			case FnAiState.Blackout:
				EnterBlackout(fnAiBrain);
				break;
			case FnAiState.PoweredDown:
				EnterPoweredDown(fnAiBrain);
				break;
			}
		}

		public void DebugEmitNoise(Vector3 position, float radius)
		{
			if (_authority)
			{
				FnNoiseBus.Raise(FnNoise.Lure, position, radius, 0);
			}
		}

		public void DebugForceCatch(FnAnim anim, int actor)
		{
			if (_authority)
			{
				FnNight instance = FnNight.Instance;
				if (!(instance == null))
				{
					instance.MasterCatch(actor, anim, FnCatchCause.Contact);
				}
			}
		}

		public void DebugSetLevelOverride(FnAnim anim, int level)
		{
			FnAiBrain fnAiBrain = BrainOf(anim);
			if (fnAiBrain != null)
			{
				fnAiBrain.LevelOverride = ((level < 0) ? (-1) : Mathf.Min(level, 20));
			}
		}

		private void ClearLevelOverrides()
		{
			for (int i = 0; i < _brains.Length; i++)
			{
				if (_brains[i] != null)
				{
					_brains[i].LevelOverride = -1;
				}
			}
		}

		public int DebugLevelOverride(FnAnim anim)
		{
			FnAiBrain fnAiBrain = BrainOf(anim);
			if (fnAiBrain == null)
			{
				return -1;
			}
			return fnAiBrain.LevelOverride;
		}

		private int NearestLivingSlot(Vector3 from)
		{
			int result = -1;
			float num = float.MaxValue;
			for (int i = 0; i < _guardSlots; i++)
			{
				ref GuardView reference = ref _guards[i];
				if (reference.Alive && reference.HasHead)
				{
					float sqrMagnitude = (reference.Head - from).sqrMagnitude;
					if (sqrMagnitude < num)
					{
						num = sqrMagnitude;
						result = i;
					}
				}
			}
			return result;
		}

		private bool PlaceAtDoor(FnAiBrain b, FnDoorSide side)
		{
			int num = graph.DoorNode(side);
			if (num >= 0)
			{
				b.StopMoving();
				b.CurNode = num;
				b.Side = side;
				b.FromChase = false;
				b.Pos = StandPoint(b, side);
				b.Speed = 0f;
				b.Velocity = Vector3.zero;
				FaceDoor(b);
				b.Yaw = b.FaceYaw;
			}
			return num >= 0;
		}

		private bool JumpAllowed(FnAiBrain b)
		{
			if (S.catches.jumpEnabled)
			{
				return b.Body != null;
			}
			return false;
		}

		private bool PlanJump(FnAiBrain b, int slot)
		{
			GuardView g = _guards[slot];
			bool direct = false;
			if (!JumpAllowed(b))
			{
				return false;
			}
			if (b.JumpTarget != g.Actor)
			{
				b.ForgetJumpPlan();
				b.JumpTarget = g.Actor;
			}
			if (b.Jump != FnJumpPhase.None)
			{
				return true;
			}
			if (b.JumpAttempts >= S.catches.jumpMaxAttempts)
			{
				return false;
			}
			if (b.HasJumpSpot && SpotReaches(b, g.Head))
			{
				return true;
			}
			if (!TrySearchJumpSpot(b, in g, out direct))
			{
				return false;
			}
			WalkToJumpSpot(b, direct);
			return true;
		}

		private bool TickJumpChase(FnAiBrain b, int slot, double now)
		{
			GuardView g = _guards[slot];
			if (b.Jump == FnJumpPhase.Charge)
			{
				if (!KeepCharging(b, in g))
				{
					CancelCharge(b);
					b.HasJumpSpot = false;
					return false;
				}
			}
			else if (b.Jump != FnJumpPhase.Air && b.Jump != FnJumpPhase.Land)
			{
				if (!JumpAllowed(b) || !b.HasJumpSpot || b.JumpTarget != g.Actor || b.JumpAttempts >= S.catches.jumpMaxAttempts)
				{
					return false;
				}
				Track(b, in g, now);
				if (AtJumpSpot(b))
				{
					b.StopMoving();
					b.Running = true;
					Face(b, g.Head);
					if (!b.Frozen && Ready(now, b.JumpReadyAt))
					{
						BeginCharge(b, g.Actor);
					}
				}
				else if (b.Arrived && !b.Direct)
				{
					WalkToJumpSpot(b, graph.Walkable(b.Pos, b.JumpSpot, JumpWalkRadius, JumpWalkLow, JumpWalkHigh));
				}
				return true;
			}
			Track(b, in g, now);
			Face(b, g.Head);
			return true;
		}

		private void JumpTargetDown(FnAiBrain b)
		{
			if (b.Jump != FnJumpPhase.None)
			{
				if (b.Jump != FnJumpPhase.Charge || b.JumpCharged >= b.JumpWindup * JumpCommitShare)
				{
					return;
				}
				CancelCharge(b);
			}
			if (b.JumpTarget != 0)
			{
				b.ForgetJumpPlan();
			}
		}

		private static void Track(FnAiBrain b, in GuardView g, double now)
		{
			b.LastKnown = g.Head;
			b.LastKnownFloorY = g.FloorY;
			b.LastSeen = now;
		}

		private void PounceTick(FnAiBrain b)
		{
			bool direct = false;
			if (!JumpAllowed(b) || b.Pouncing || b.PouncedThisSprint || b.Jump != FnJumpPhase.None || b.Frozen)
			{
				return;
			}
			FnSettings.CatchSettings catches = S.catches;
			float num = catches.endoPounceRange;
			int num2 = -1;
			for (int i = 0; i < _guardSlots; i++)
			{
				ref GuardView reference = ref _guards[i];
				if (reference.Alive && reference.HasHead && !reference.InOffice && FnAiRules.IsPerched(reference.Head.y, reference.FloorY, catches.reachHeight))
				{
					float num3 = FnAiRules.HorizontalDistance(b.Pos, reference.Head);
					if (!(num3 > num))
					{
						num = num3;
						num2 = i;
					}
				}
			}
			if (num2 >= 0)
			{
				GuardView g = _guards[num2];
				if (b.JumpTarget != g.Actor)
				{
					b.ForgetJumpPlan();
					b.JumpTarget = g.Actor;
				}
				if (TrySearchJumpSpot(b, in g, out direct))
				{
					b.Pouncing = true;
					b.PouncedThisSprint = true;
					b.Look = FnLook.Actor;
					b.LookActor = g.Actor;
					WalkToJumpSpot(b, direct);
				}
			}
		}

		private void TickPounce(FnAiBrain b)
		{
			int num = SlotOfActor(b.JumpTarget);
			bool flag = num >= 0 && _guards[num].Alive && _guards[num].HasHead;
			if (b.Jump == FnJumpPhase.Charge)
			{
				if (!flag || !KeepCharging(b, in _guards[num]))
				{
					CancelCharge(b);
					ResumeSprint(b);
				}
			}
			else if (b.Jump == FnJumpPhase.Air || b.Jump == FnJumpPhase.Land)
			{
				if (flag)
				{
					Face(b, _guards[num].Head);
				}
			}
			else if (!flag || b.JumpAttempts > 0 || _guards[num].InOffice || !b.HasJumpSpot)
			{
				ResumeSprint(b);
			}
			else
			{
				GuardView guardView = _guards[num];
				if (!FnAiRules.IsPerched(guardView.Head.y, guardView.FloorY, S.catches.reachHeight))
				{
					ResumeSprint(b);
				}
				else if (AtJumpSpot(b))
				{
					b.StopMoving();
					b.Running = true;
					Face(b, guardView.Head);
					if (!b.Frozen)
					{
						BeginCharge(b, guardView.Actor);
					}
				}
			}
		}

		private void ResumeSprint(FnAiBrain b)
		{
			b.Pouncing = false;
			b.HasJumpSpot = false;
			EnterApproach(b, b.Side, b.FromChase);
		}

		private bool TrySearchJumpSpot(FnAiBrain b, in GuardView g, out bool direct)
		{
			direct = false;
			b.HasJumpSpot = false;
			if (b.JumpSearchAt > 0.0 && !Ready(FnClock.Now, b.JumpSearchAt) && (g.Head - b.JumpSearchHead).sqrMagnitude < JumpReplanDistance * JumpReplanDistance)
			{
				return false;
			}
			if (_jumpSearchFrame == Time.frameCount)
			{
				return false;
			}
			_jumpSearchFrame = Time.frameCount;
			if (FindJumpSpot(b, g.Head, g.FloorY, out var spot, out var rise, out direct))
			{
				b.HasJumpSpot = true;
				b.JumpSpot = spot;
				b.JumpPlanRise = rise;
				b.JumpSearchAt = 0.0;
				b.JumpPlanHead = g.Head;
				return true;
			}
			b.JumpSearchAt = FnClock.Now + JumpSearchRetrySeconds;
			b.JumpSearchHead = g.Head;
			return false;
		}

		private bool FindJumpSpot(FnAiBrain b, Vector3 head, float floorY, out Vector3 spot, out float rise, out bool direct)
		{
			spot = default(Vector3);
			rise = 0f;
			direct = false;
			Vector3 at = default(Vector3);
			float rise2 = 0f;
			FnSettings.CatchSettings catches = S.catches;
			float num = catches.reachRadius + catches.jumpExtraReach;
			float num2 = b.Pos.x - head.x;
			float num3 = b.Pos.z - head.z;
			float num4 = ((num2 * num2 + num3 * num3 > 0.0001f) ? (Mathf.Atan2(num2, num3) * 57.29578f) : (b.Yaw + 180f));
			for (int i = 0; i < JumpRadii.Length && !(JumpRadii[i] > num - 0.1f); i++)
			{
				for (int j = 0; j < JumpBearings.Length; j++)
				{
					Vector3 vector = Quaternion.Euler(0f, num4 + JumpBearings[j], 0f) * Vector3.forward;
					at = new Vector3(head.x + vector.x * JumpRadii[i], floorY, head.z + vector.z * JumpRadii[i]);
					if (JumpSpotClear(b, head, ref at, out rise2))
					{
						bool flag = graph.Walkable(b.Pos, at, JumpWalkRadius, JumpWalkLow, JumpWalkHigh);
						int node;
						if (flag || ((node = graph.Nearest(at)) >= 0 && graph.Walkable(graph.Position(node), at, JumpWalkRadius, JumpWalkLow, JumpWalkHigh)))
						{
							spot = at;
							rise = rise2;
							direct = flag;
							return true;
						}
					}
				}
			}
			return false;
		}

		private bool JumpSpotClear(FnAiBrain b, Vector3 head, ref Vector3 at, out float rise)
		{
			float y = 0f;
			FnSettings.CatchSettings catches = S.catches;
			rise = 0f;
			if (InsideOffice(at + Vector3.up))
			{
				return false;
			}
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain fnAiBrain = _brains[i];
				if (fnAiBrain != b && !(fnAiBrain.Body == null) && fnAiBrain.HasJumpSpot && FnAiRules.HorizontalDistance(fnAiBrain.JumpSpot, at) < JumpSpotSpacing)
				{
					return false;
				}
			}
			if (!graph.FloorBelow(at + Vector3.up, 1.3f, out y))
			{
				return false;
			}
			if (Mathf.Abs(y - at.y) > JumpFloorTolerance)
			{
				return false;
			}
			at.y = y;
			float num = Mathf.Max(FnAiRules.MinJumpRise, FnAiRules.JumpRise(head.y, y, catches.jumpHeadAboveFeet));
			for (int j = 0; j < JumpRiseSteps; j++)
			{
				float num2 = num + (float)j * JumpRiseStep;
				if (num2 > catches.jumpMaxHeight)
				{
					return false;
				}
				if (j > 0 && head.y - (num2 + y) < ChestHeight)
				{
					return false;
				}
				if (graph.Occupied(at + Vector3.up * 0.35f, at + Vector3.up * (num2 + JumpBodyTop - JumpBodyRadius), JumpBodyRadius))
				{
					return false;
				}
				if (graph.Sight(head, at + Vector3.up * (num2 + ChestHeight)))
				{
					rise = num2;
					return true;
				}
			}
			return false;
		}

		private bool SpotReaches(FnAiBrain b, Vector3 head)
		{
			if (!b.HasJumpSpot)
			{
				return false;
			}
			FnSettings.CatchSettings catches = S.catches;
			if (FnAiRules.HorizontalDistance(b.JumpSpot, head) > catches.reachRadius + catches.jumpExtraReach - 0.05f)
			{
				return false;
			}
			if (head.y - b.JumpPlanHead.y <= JumpRiseSlack)
			{
				return (head - b.JumpPlanHead).sqrMagnitude <= JumpReplanHead * JumpReplanHead;
			}
			return false;
		}

		private bool AtJumpSpot(FnAiBrain b)
		{
			if (Mathf.Abs(b.Pos.y - b.JumpSpot.y) < 0.5f)
			{
				return FnAiRules.HorizontalDistance(b.Pos, b.JumpSpot) <= JumpSpotArrive;
			}
			return false;
		}

		private void WalkToJumpSpot(FnAiBrain b, bool direct)
		{
			b.PerchSince = 0.0;
			b.PerchNode = -1;
			if (direct)
			{
				SteerDirect(b, b.JumpSpot, true);
			}
			else
			{
				GoToPoint(b, b.JumpSpot, graph.Nearest(b.JumpSpot), true);
			}
		}

		private void BeginCharge(FnAiBrain b, int actor)
		{
			float num = FnAiRules.JumpWindupSeconds(b.Level, S.catches.jumpWindupSeconds);
			b.StopMoving();
			b.Running = true;
			b.Jump = FnJumpPhase.Charge;
			b.JumpCharged = 0f;
			b.Look = FnLook.Actor;
			b.LookActor = actor;
			b.JumpWindup = (b.Pouncing ? Mathf.Max(0.3f, num * PounceWindupScale) : num);
			_sendPosesNow = true;
		}

		private bool KeepCharging(FnAiBrain b, in GuardView g)
		{
			if (!g.Alive || !g.HasHead || g.InOffice)
			{
				return false;
			}
			if (b.JumpCharged >= b.JumpWindup * JumpCommitShare)
			{
				return true;
			}
			if (!FnAiRules.IsPerched(g.Head.y, g.FloorY, S.catches.reachHeight))
			{
				return false;
			}
			return SpotReaches(b, g.Head);
		}

		private void CancelCharge(FnAiBrain b)
		{
			if (b.Jump == FnJumpPhase.Charge)
			{
				b.Jump = FnJumpPhase.None;
				b.JumpCharged = 0f;
				_sendPosesNow = true;
			}
		}

		private bool StepJump(FnAiBrain b, float dt)
		{
			switch (b.Jump)
			{
			case FnJumpPhase.Charge:
			{
				if (b.State != FnAiState.Chase && (b.State != FnAiState.ApproachOffice || !b.Pouncing))
				{
					CancelCharge(b);
					return false;
				}
				Vector3 pos2 = b.Pos;
				b.Pos = Vector3.MoveTowards(b.Pos, b.JumpSpot, dt * JumpSettleSpeed);
				b.Speed = 0f;
				b.Velocity = (b.Pos - pos2) / dt;
				TurnToFace(b, dt);
				if (!b.Frozen)
				{
					b.JumpCharged += dt;
					if (b.JumpCharged >= b.JumpWindup)
					{
						Liftoff(b);
					}
				}
				return true;
			}
			case FnJumpPhase.Air:
			{
				Vector3 pos = b.Pos;
				float num = Time.time - b.ArcLiftoff;
				if (num < FnAiRules.JumpAirSeconds(b.ArcRise, b.ArcHang))
				{
					b.Pos = b.ArcFrom + Vector3.up * FnAiRules.JumpHeight(b.ArcRise, b.ArcHang, num);
				}
				else
				{
					b.Pos = b.ArcFrom;
					Touchdown(b);
				}
				b.Speed = 0f;
				b.Velocity = (b.Pos - pos) / dt;
				TurnToFace(b, dt);
				return true;
			}
			case FnJumpPhase.Land:
				b.Speed = 0f;
				b.Velocity = Vector3.zero;
				if (!b.Frozen)
				{
					b.JumpLanded += dt;
				}
				if (b.JumpLanded >= S.catches.jumpLandSeconds)
				{
					b.Jump = FnJumpPhase.None;
				}
				return true;
			default:
				return false;
			}
		}

		private void TurnToFace(FnAiBrain b, float dt)
		{
			if (b.HasFace)
			{
				b.Yaw = Mathf.MoveTowardsAngle(b.Yaw, b.FaceYaw, TurnRate(b) * dt);
			}
		}

		private void Liftoff(FnAiBrain b)
		{
			FnSettings.CatchSettings catches = S.catches;
			int num = SlotOfActor(b.JumpTarget);
			Vector3 vector = ((num >= 0 && _guards[num].HasHead) ? _guards[num].Head : b.JumpPlanHead);
			b.ArcRise = Mathf.Clamp(b.JumpPlanRise + (vector.y - b.JumpPlanHead.y), FnAiRules.MinJumpRise, Mathf.Max(FnAiRules.MinJumpRise, Mathf.Min(catches.jumpMaxHeight, b.JumpPlanRise + JumpRiseSlack)));
			b.ArcFrom = b.JumpSpot;
			b.ArcHang = Mathf.Max(0f, catches.jumpHangSeconds);
			b.ArcLiftoff = Time.time;
			b.Pos = b.JumpSpot;
			b.Jump = FnJumpPhase.Air;
			b.HasArc = true;
			b.JumpAttempts++;
			_sendPosesNow = true;
		}

		private void Touchdown(FnAiBrain b)
		{
			b.JumpLanded = 0f;
			b.Jump = FnJumpPhase.Land;
			b.JumpReadyAt = FnClock.Now + (double)Mathf.Max(0f, S.catches.jumpCooldownSeconds);
			_sendPosesNow = true;
		}

		private void ResumeFall(FnAiBrain b)
		{
			float y = 0f;
			if (!graph.FloorBelow(b.Pos + Vector3.up * 0.05f, 8f, out y))
			{
				return;
			}
			float num = b.Pos.y - y;
			if (num <= 0.05f)
			{
				b.Pos.y = y;
				return;
			}
			b.ArcFrom = new Vector3(b.Pos.x, y, b.Pos.z);
			b.ArcRise = num;
			b.ArcHang = 0f;
			float time = Time.time;
			b.HasArc = true;
			b.JumpSpot = b.ArcFrom;
			b.Jump = FnJumpPhase.Air;
			b.ArcLiftoff = time - FnAiRules.JumpFlightSeconds(num);
		}

		private bool AnyAirborne()
		{
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain fnAiBrain = _brains[i];
				if (fnAiBrain.Body != null && fnAiBrain.Jump == FnJumpPhase.Air)
				{
					return true;
				}
			}
			return false;
		}

		private bool ArcFeetForReport(FnAiBrain b, float pingMs, out Vector3 feet)
		{
			feet = b.Pos;
			if (!b.HasArc)
			{
				return false;
			}
			float num = Time.time - b.ArcLiftoff;
			float num2 = FnAiRules.JumpPeakBetween(b.ArcRise, b.ArcHang, num - FnAiRules.JumpReportWindow(pingMs, (float)FnAnimatronic.InterpolationDelayMs / 1000f), num);
			if (num2 <= 0.02f)
			{
				return false;
			}
			feet = b.ArcFrom + Vector3.up * num2;
			return true;
		}

		private void GoToNode(FnAiBrain b, int node, bool run, float speedScale = 1f)
		{
			b.GoalNode = node;
			b.HasGoalPoint = false;
			b.Direct = false;
			b.ViaDoorway = false;
			b.WayNode = -1;
			b.Running = run;
			b.SpeedScale = speedScale;
			b.Arrived = node < 0 || (b.CurNode == node && Reached(b.Pos, graph.Position(node), ArriveRadius));
		}

		private void GoToPoint(FnAiBrain b, Vector3 point, int viaNode, bool run, float speedScale = 1f)
		{
			if (viaNode < 0 || b.CurNode == viaNode)
			{
				SteerDirect(b, point, run, speedScale);
				return;
			}
			GoToNode(b, viaNode, run, speedScale);
			b.GoalPoint = point;
			b.HasGoalPoint = true;
			b.Arrived = false;
		}

		private static void SteerDirect(FnAiBrain b, Vector3 point, bool run, float speedScale = 1f)
		{
			b.Direct = true;
			b.DirectPoint = point;
			b.GoalNode = -1;
			b.WayNode = -1;
			b.SpeedScale = speedScale;
			b.HasGoalPoint = false;
			b.Running = run;
			b.ViaDoorway = false;
			b.Arrived = Reached(b.Pos, point, DirectArriveRadius);
			if (b.Arrived)
			{
				b.Direct = false;
			}
		}

		private static bool Reached(Vector3 pos, Vector3 target, float radius)
		{
			if (Mathf.Abs(pos.y - target.y) < 1.6f)
			{
				return FnAiRules.HorizontalDistance(pos, target) <= radius;
			}
			return false;
		}

		private float MoveSpeed(FnAiBrain b)
		{
			float speedMultiplier = _mods.speedMultiplier;
			return (b.Running ? FnAiRules.RunSpeed(b.Level, b.T.runSpeed, speedMultiplier) : FnAiRules.WalkSpeed(b.Level, b.T.walkSpeed, speedMultiplier)) * Mathf.Max(0.05f, b.SpeedScale);
		}

		private static float TurnRate(FnAiBrain b)
		{
			float num = ((b.Body != null) ? b.Body.turnSpeed : 200f);
			if (b.Running)
			{
				num *= 1.5f;
			}
			if (b.State == FnAiState.Attack)
			{
				num *= 2f;
			}
			return num;
		}

		private Vector3 Eye(FnAiBrain b)
		{
			return b.Body.EyeAt(b.Pos, b.Yaw);
		}

		private void Locomote(FnAiBrain b, double now, float dt)
		{
			if (dt <= 0f || (b.Jump != FnJumpPhase.None && StepJump(b, dt)))
			{
				return;
			}
			if (b.Frozen || b.State == FnAiState.PoweredDown || b.State == FnAiState.Dormant)
			{
				b.Speed = 0f;
				b.Velocity = Vector3.zero;
				BearLaugh(b, now);
				return;
			}
			bool halt = false;
			if (!b.Direct)
			{
				if (b.Arrived || b.GoalNode < 0)
				{
					halt = true;
				}
				else
				{
					if (b.WayNode < 0)
					{
						b.WayNode = ((b.CurNode < 0 || InsideOffice(b.Pos)) ? EntryNode(b) : graph.NextHop(b.CurNode, b.GoalNode));
						if (b.WayNode == WaitForRays)
						{
							b.Speed = 0f;
							b.WayNode = -1;
							b.Velocity = Vector3.zero;
							return;
						}
					}
					if (b.ViaDoorway && Reached(b.Pos, DoorwayPoint(b.ExitSide), ArriveRadius))
					{
						b.ViaDoorway = false;
					}
					if (!b.ViaDoorway && b.WayNode >= 0 && Reached(b.Pos, graph.Position(b.WayNode), ArriveRadius))
					{
						AdvanceWaypoint(b);
					}
					if (!b.Direct && (b.WayNode < 0 || b.Arrived))
					{
						b.Arrived = true;
						halt = true;
					}
				}
			}
			if (halt)
			{
				b.Speed = 0f;
				b.Velocity = Vector3.zero;
				if (b.HasFace)
				{
					b.Yaw = Mathf.MoveTowardsAngle(b.Yaw, b.FaceYaw, TurnRate(b) * dt);
				}
			}
			else
			{
				Vector3 target;
				bool final;
				if (b.Direct)
				{
					target = b.DirectPoint;
					final = true;
				}
				else
				{
					target = (b.ViaDoorway ? DoorwayPoint(b.ExitSide) : graph.Position(b.WayNode));
					final = !b.ViaDoorway && b.WayNode == b.GoalNode && !b.HasGoalPoint;
				}
				Step(b, target, final, dt);
				if (b.Direct)
				{
					if (Reached(b.Pos, b.DirectPoint, DirectArriveRadius))
					{
						b.Direct = false;
						b.Arrived = true;
					}
					else if (b.CurNode >= 0 && FnAiRules.HorizontalDistance(b.Pos, graph.Position(b.CurNode)) > OffGraphDistance)
					{
						b.CurNode = -1;
					}
				}
			}
			BearLaugh(b, now);
		}

		private int EntryNode(FnAiBrain b)
		{
			if (InsideOffice(b.Pos) && NearestExit(b.Pos, out var side))
			{
				b.ViaDoorway = true;
				b.ExitSide = side;
				return graph.DoorNode(side);
			}
			if (_rays < 1)
			{
				return WaitForRays;
			}
			int raysUsed;
			int result = graph.BestEntry(b.Pos, b.GoalNode, KneeHeight, Mathf.Min(_rays, EntryRays), out raysUsed);
			_rays -= raysUsed;
			return result;
		}

		private bool InsideOffice(Vector3 p)
		{
			FnOffice office = Office;
			if (office != null)
			{
				return office.Contains(p, 0f);
			}
			return false;
		}

		private bool NearestExit(Vector3 from, out FnDoorSide side)
		{
			side = FnDoorSide.West;
			bool found = false;
			float best = float.MaxValue;
			FnNight instance = FnNight.Instance;
			for (int i = 0; i < 2; i++)
			{
				FnDoorSide s = (FnDoorSide)i;
				if (graph.DoorNode(s) >= 0)
				{
					float d = (DoorwayPoint(s) - from).sqrMagnitude;
					if (instance != null && instance.DoorClosed(s))
					{
						d += 10000f;
					}
					if (d < best)
					{
						best = d;
						found = true;
						side = s;
					}
				}
			}
			return found;
		}

		private void AdvanceWaypoint(FnAiBrain b)
		{
			b.CurNode = b.WayNode;
			if (b.CurNode == b.GoalNode)
			{
				b.WayNode = -1;
				if (b.HasGoalPoint)
				{
					b.HasGoalPoint = false;
					b.Direct = true;
					b.DirectPoint = b.GoalPoint;
				}
				else
				{
					b.Arrived = true;
				}
			}
			else
			{
				b.WayNode = graph.NextHop(b.CurNode, b.GoalNode);
				if (b.WayNode < 0)
				{
					b.Arrived = true;
				}
			}
		}

		private void Step(FnAiBrain b, Vector3 target, bool final, float dt)
		{
			float dx = target.x - b.Pos.x;
			float dz = target.z - b.Pos.z;
			float dist = Mathf.Sqrt(dx * dx + dz * dz);
			float want = ((dist > 0.02f) ? (Mathf.Atan2(dx, dz) * Mathf.Rad2Deg) : b.Yaw);
			b.Yaw = Mathf.MoveTowardsAngle(b.Yaw, want, TurnRate(b) * dt);
			float align = Mathf.Clamp01(Mathf.Cos(Mathf.DeltaAngle(b.Yaw, want) * Mathf.Deg2Rad));
			float accel = Mathf.Max(b.Body.acceleration, 0.5f);
			float speed = align * MoveSpeed(b);
			if (final)
			{
				speed = Mathf.Min(speed, Mathf.Sqrt(2f * accel * dist) + 0.05f);
			}
			speed = Mathf.MoveTowards(b.Speed, speed, accel * dt);
			float step = Mathf.Min(speed * dt, dist);
			Vector3 pos = b.Pos;
			if (dist > 0.0001f)
			{
				float t = step / dist;
				b.Pos = new Vector3(b.Pos.x + dx * t, Mathf.Lerp(b.Pos.y, target.y, t), b.Pos.z + dz * t);
			}
			b.Speed = step / dt;
			b.Velocity = (b.Pos - pos) / dt;
			b.Gait = FnAiRules.AdvanceGait(b.Gait, step, b.Body.strideLength);
		}

		private void BearLaugh(FnAiBrain b, double now)
		{
			if (b.Id == FnAnim.Bear)
			{
				bool moving = b.Speed > 0.25f;
				if (moving && !b.WasMoving && b.State != FnAiState.Attack && FnAiRules.Elapsed(now, b.LastLaugh) >= (double)bearLaughCooldown)
				{
					b.LastLaugh = now;
					Cue(b, FnCue.Laugh);
				}
				b.WasMoving = moving;
			}
		}

		private void UpdateHead(FnAiBrain b, double now)
		{
			if (b.Frozen || b.State == FnAiState.PoweredDown)
			{
				return;
			}
			float yaw = 0f;
			float pitch = -4f;
			switch (b.Look)
			{
			case FnLook.Actor:
			{
				if (HeadOf(b.LookActor, out var head))
				{
					FnAiRules.LookAngles(Eye(b), head, b.Yaw, MaxHeadYaw, MaxHeadPitch, out yaw, out pitch);
					break;
				}
				yaw = b.HeadYaw;
				pitch = b.HeadPitch;
				break;
			}
			case FnLook.Point:
				FnAiRules.LookAngles(Eye(b), b.LookPoint, b.Yaw, MaxHeadYaw, MaxHeadPitch, out yaw, out pitch);
				break;
			case FnLook.Glance:
				if (Ready(now, b.NextGlance))
				{
					b.NextGlance = now + (double)Between(glanceInterval);
					float speed = b.Speed;
					if (Random.value < 0.3f)
					{
						b.GlanceYaw = 0f;
						b.GlancePitch = -4f;
					}
					else
					{
						float range = ((speed < 0.2f) ? 70f : 30f);
						b.GlanceYaw = Random.Range(0f - range, range);
						b.GlancePitch = Random.Range(-15f, 8f);
					}
				}
				yaw = b.GlanceYaw;
				pitch = b.GlancePitch;
				break;
			default:
				if (b.State == FnAiState.Dormant)
				{
					pitch = DormantPitch;
				}
				break;
			}
			b.HeadYaw = Mathf.Round(yaw * 0.5f) * 2f;
			b.HeadPitch = Mathf.Round(pitch * 0.5f) * 2f;
			if ((b.Look == FnLook.Point || b.Look == FnLook.Actor) && b.Arrived && !b.Direct && Mathf.Abs(yaw) > 50f && b.Speed < 0.1f)
			{
				b.HasFace = true;
				b.FaceYaw = b.Yaw + yaw * 0.8f;
			}
		}

		private void LookAt(FnAiBrain b, Vector3 point)
		{
			b.Look = FnLook.Point;
			b.LookPoint = point;
		}

		private void LookAtActor(FnAiBrain b, int actor)
		{
			b.Look = FnLook.Actor;
			b.LookActor = actor;
		}

		private void Face(FnAiBrain b, Vector3 point)
		{
			float dx = point.x - b.Pos.x;
			float dz = point.z - b.Pos.z;
			if (!(dx * dx + dz * dz < 0.0001f))
			{
				b.HasFace = true;
				b.FaceYaw = Mathf.Atan2(dx, dz) * Mathf.Rad2Deg;
			}
		}

		private void SendPoses()
		{
			float unscaledTime = Time.unscaledTime;
			if (unscaledTime < _nextPoseSend && !_sendPosesNow)
			{
				return;
			}
			_sendPosesNow = false;
			float hz = (AnyAirborne() ? Mathf.Max(S.ai.poseHz, JumpPoseHz) : S.ai.poseHz);
			_nextPoseSend = unscaledTime + 1f / Mathf.Clamp(hz, 1f, 30f);
			int count = 0;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain b = _brains[i];
				if (b.Body == null)
				{
					continue;
				}
				b.Sample(out var p);
				if (_forceFullSend || PoseChanged(b, in p))
				{
					b.RestSends = 0;
				}
				else
				{
					if (b.RestSends > 0)
					{
						continue;
					}
					b.RestSends++;
				}
				Remember(b, in p);
				_outgoing[count++] = p;
			}
			_forceFullSend = false;
			if (count != 0 && PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null && PhotonNetwork.CurrentRoom.PlayerCount >= 2)
			{
				byte[] buffer = _poseBuffers[count - 1];
				FnPoseCodec.WriteHeader(buffer, count, PhotonNetwork.ServerTimestamp, ++_poseSequence);
				for (int j = 0; j < count; j++)
				{
					FnPoseCodec.WritePose(buffer, j, in _outgoing[j]);
				}
				PhotonNetwork.RaiseEvent(FnConst.PoseEvent, buffer, PoseTargets, SendOptions.SendUnreliable);
			}
		}

		private static bool PoseChanged(FnAiBrain b, in FnPoseSample s)
		{
			if (!b.EverSent)
			{
				return true;
			}
			if ((s.Position - b.SentPos).sqrMagnitude > 0.0001f)
			{
				return true;
			}
			if (Mathf.Abs(Mathf.DeltaAngle(s.Yaw, b.SentYaw)) > 0.5f)
			{
				return true;
			}
			if (Mathf.Abs(Mathf.DeltaAngle(s.HeadYaw, b.SentHeadYaw)) > 0.5f)
			{
				return true;
			}
			if (Mathf.Abs(s.HeadPitch - b.SentHeadPitch) > 0.5f)
			{
				return true;
			}
			if ((byte)s.State != b.SentState)
			{
				return true;
			}
			if (s.Flags != b.SentFlags)
			{
				return true;
			}
			return b.SentSpeed != FnPoseCodec.SpeedToWire(s.Speed);
		}

		private static void Remember(FnAiBrain b, in FnPoseSample s)
		{
			b.EverSent = true;
			b.SentPos = s.Position;
			b.SentYaw = s.Yaw;
			b.SentHeadYaw = s.HeadYaw;
			b.SentHeadPitch = s.HeadPitch;
			b.SentState = (byte)s.State;
			b.SentFlags = s.Flags;
			b.SentSpeed = FnPoseCodec.SpeedToWire(s.Speed);
		}

		private void SubscribePoses()
		{
			LoadBalancingClient networkingClient = PhotonNetwork.NetworkingClient;
			if (networkingClient != null)
			{
				networkingClient.EventReceived -= OnPoseEvent;
				networkingClient.EventReceived += OnPoseEvent;
				_poseClient = networkingClient;
			}
		}

		private void UnsubscribePoses()
		{
			if (_poseClient != null)
			{
				_poseClient.EventReceived -= OnPoseEvent;
			}
			_poseClient = null;
		}

		private void ResetStreamSequence()
		{
			_haveSequence = false;
		}

		private void OnPoseEvent(EventData e)
		{
			if (e.Code != FnConst.PoseEvent || _authority || !_bodiesPlaced)
			{
				return;
			}
			Player masterClient = PhotonNetwork.MasterClient;
			if (masterClient == null || e.Sender != masterClient.ActorNumber || !(e.CustomData is byte[] buffer) || !FnPoseCodec.ReadHeader(buffer, out var count, out var serverTimestamp, out var sequence) || (_haveSequence && !FnPoseCodec.SequenceNewer(sequence, _lastSequence)))
			{
				return;
			}
			_lastSequence = sequence;
			_haveSequence = true;
			int sendIntervalMs = Mathf.RoundToInt(1000f / Mathf.Clamp(S.ai.poseHz, 1f, 30f));
			for (int i = 0; i < count; i++)
			{
				FnPoseCodec.ReadPose(buffer, i, out var p);
				if (p.Id < _brains.Length && FnAiRules.IsFinite(p.Position))
				{
					FnAnimatronic body = _brains[p.Id].Body;
					if (body != null)
					{
						body.PushSnapshot(serverTimestamp, in p, sendIntervalMs);
					}
				}
			}
		}

		private static bool FromMaster(PhotonMessageInfo info)
		{
			if (info.Sender != null)
			{
				return info.Sender.IsMasterClient;
			}
			return false;
		}

		private void OnAnimState(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 6 || !FromMaster(info) || _authority || !_bodiesPlaced)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (b < _brains.Length && !(_brains[b].Body == null))
			{
				float x = FnNet.F(a[3]);
				float y = FnNet.F(a[4]);
				float z = FnNet.F(a[5]);
				Vector3 position = new Vector3(x, y, z);
				if (FnAiRules.IsFinite(position))
				{
					_brains[b].Body.ReliableState((FnAiState)FnNet.B(a[1]), FnNet.I(a[2]), position, PhotonNetwork.ServerTimestamp);
				}
			}
		}

		private void OnAnimCue(object[] a, PhotonMessageInfo info)
		{
			if (a.Length >= 2 && FromMaster(info))
			{
				byte b = FnNet.B(a[0]);
				if (b < _brains.Length && !(_brains[b].Body == null))
				{
					_brains[b].Body.PlayCue((FnCue)FnNet.B(a[1]));
				}
			}
		}

		private void FlushSnapshots(double now)
		{
			double interval = 1.0 / (double)Mathf.Clamp(S.ai.snapshotHz, 0.1f, 1f);
			Hashtable hashtable = null;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain b = _brains[i];
				if (b.Body == null)
				{
					continue;
				}
				bool moved = (b.Pos - b.SnapPos).sqrMagnitude > 0.0025f || Mathf.Abs(Mathf.DeltaAngle(b.Yaw, b.SnapYaw)) > 2f || Mathf.Abs(SnapInterest(b) - b.SnapInterest) >= 0.1f;
				if (b.SnapStateDirty || (moved && FnAiRules.Elapsed(now, b.LastSnapAt) >= interval))
				{
					if (hashtable == null)
					{
						hashtable = new Hashtable();
					}
					hashtable[FnProps.AnimKey(i)] = Snapshot(b);
					b.SnapStateDirty = false;
					b.SnapPos = b.Pos;
					b.LastSnapAt = now;
					b.SnapYaw = b.Yaw;
					b.SnapInterest = SnapInterest(b);
				}
			}
			if (hashtable != null)
			{
				FnProps.WriteRoom(hashtable);
			}
		}

		private static float SnapInterest(FnAiBrain b)
		{
			if (b.Id == FnAnim.Endo && b.State == FnAiState.Patrol)
			{
				return b.CoveProgress;
			}
			if (b.State != FnAiState.DoorBang)
			{
				return 0f;
			}
			return (float)b.KnocksLeft / (float)FnAiRules.MaxKnockBursts;
		}

		private object[] Snapshot(FnAiBrain b)
		{
			return new object[11]
			{
				(byte)b.State,
				(short)Mathf.Clamp(SnapNode(b), -1, 32767),
				b.Target,
				SnapInterest(b),
				(byte)Mathf.Clamp(b.Level, 0, 255),
				b.Pos.x,
				b.Pos.y,
				b.Pos.z,
				b.Yaw,
				b.StateUntil,
				b.OfficeCooldownUntil
			};
		}

		private int SnapNode(FnAiBrain b)
		{
			switch (b.State)
			{
			case FnAiState.Patrol:
			case FnAiState.Investigate:
			case FnAiState.Retreat:
				return b.Arg;
			case FnAiState.Chase:
				return graph.Nearest(b.LastKnown);
			case FnAiState.Search:
				return b.SearchCenter;
			case FnAiState.ApproachOffice:
			case FnAiState.DoorWait:
			case FnAiState.DoorBang:
			case FnAiState.DoorEnter:
			case FnAiState.Blackout:
				return graph.DoorNode(b.Side);
			case FnAiState.Attack:
				if (b.VictimCause == FnCatchCause.Doorway)
				{
					return graph.DoorNode(b.Side);
				}
				return b.CurNode;
			default:
				return b.CurNode;
			}
		}

		private static bool TryReadSnapshot(int index, out AnimSnapshot snap)
		{
			snap = default(AnimSnapshot);
			Hashtable roomProps = FnProps.RoomProps;
			if (roomProps == null || !roomProps.TryGetValue(FnProps.AnimKey(index), out var value))
			{
				return false;
			}
			try
			{
				if (!(value is object[] array) || array.Length < 11)
				{
					return false;
				}
				snap.State = (FnAiState)FnNet.B(array[0]);
				snap.Node = FnNet.I(array[1]);
				snap.Target = FnNet.I(array[2]);
				snap.Interest = FnNet.F(array[3]);
				snap.Position = new Vector3(FnNet.F(array[5]), FnNet.F(array[6]), FnNet.F(array[7]));
				snap.Yaw = FnNet.F(array[8]);
				snap.StateUntil = System.Convert.ToDouble(array[9]);
				snap.CooldownUntil = System.Convert.ToDouble(array[10]);
				return FnAiRules.IsFinite(snap.Position) && snap.State <= FnAiState.PoweredDown;
			}
			catch (System.Exception)
			{
				return false;
			}
		}

		private void ApplySnapshotToBody(int index, int nowTs, bool initial)
		{
			FnAnimatronic body = _brains[index].Body;
			if (!(body == null) && TryReadSnapshot(index, out var snap))
			{
				if (initial)
				{
					FnPoseSample pose = new FnPoseSample
					{
						Id = (byte)index,
						Position = snap.Position,
						Yaw = snap.Yaw,
						State = snap.State,
						Flags = (byte)((snap.State != FnAiState.Dormant) ? ((snap.State == FnAiState.PoweredDown) ? FnPoseCodec.FlagPoweredDown : FnPoseCodec.FlagEyesLit) : 0)
					};
					body.Place(in pose);
					body.HoldStream(in pose, nowTs - 100);
				}
				else
				{
					body.CorrectFromSnapshot(snap.Position, snap.Yaw, snap.State, nowTs);
				}
			}
		}

		public override void OnRoomPropertiesUpdate(Hashtable changed)
		{
			if (_authority || changed == null || !_bodiesPlaced)
			{
				return;
			}
			int serverTimestamp = PhotonNetwork.ServerTimestamp;
			for (int i = 0; i < _brains.Length; i++)
			{
				if (changed.ContainsKey(FnProps.AnimKey(i)))
				{
					ApplySnapshotToBody(i, serverTimestamp, initial: false);
				}
			}
		}

		private void BecomeAuthority(FnNight night)
		{
			_authority = true;
			_haveMasterPhase = false;
			_forceFullSend = true;
			_nextPoseSend = 0f;
			_nextSense = 0f;
			_lastSense = 0f;
			ResetWatchers();
			FnPhase phase = night.Phase;
			double now = FnClock.Now;
			CacheGuards(night, 0f);
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain b in brains)
			{
				if (!(b.Body == null))
				{
					ResolveTuning(b);
					b.Level = LevelOf(b, night);
					ResetBrain(b);
					if (phase != FnPhase.Gathering && TryReadSnapshot((int)b.Id, out var snap))
					{
						Resume(b, snap, now);
					}
					else
					{
						EnterDormant(b, !b.Body.HasPose);
					}
				}
			}
			for (int j = 0; j < 2; j++)
			{
				FnDoorSide side = (FnDoorSide)j;
				if (!night.DoorJammed(side))
				{
					continue;
				}
				bool held = false;
				for (int k = 0; k < _brains.Length; k++)
				{
					held |= _brains[k].JamSide == (int)side;
				}
				if (!held)
				{
					night.MasterSetJam(side, jammed: false);
				}
			}
			Debug.Log(string.Format("[FnAiDirector] Running the animatronics ({0}, night {1}, {2}).", night.Phase, night.NightNumber, night.Difficulty));
		}

		private void DropAuthority()
		{
			_authority = false;
			_haveMasterPhase = false;
			_haveSequence = false;
			int renderTs = PhotonNetwork.ServerTimestamp - 100;
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain b in brains)
			{
				if (!(b.Body == null) && b.Body.HasPose)
				{
					FnPoseSample pose = b.Body.Rendered;
					pose.Speed = 0f;
					b.Body.HoldStream(in pose, renderTs);
					b.Body.ForgetReliable();
				}
			}
		}

		private void ResetBrain(FnAiBrain b)
		{
			FnAnimatronic body = b.Body;
			bool hasPose = body.HasPose;
			FnPoseSample rendered = (hasPose ? body.Rendered : default(FnPoseSample));
			bool airborne = hasPose && rendered.Has(FnPoseCodec.FlagAirborne);
			b.State = Unset;
			b.Arg = int.MinValue;
			b.StopMoving();
			b.ClearSenses();
			b.ResetJump();
			b.MusicBoxAsked = false;
			b.Frozen = false;
			b.JamSide = -1;
			b.Staring = false;
			b.Lingering = false;
			b.SleepOnArrival = false;
			b.EverSent = false;
			b.RestSends = 0;
			b.SnapStateDirty = true;
			b.LastSnapAt = double.NegativeInfinity;
			if (hasPose)
			{
				b.Pos = rendered.Position;
				b.Yaw = rendered.Yaw;
				b.HeadYaw = rendered.HeadYaw;
				b.HeadPitch = rendered.HeadPitch;
				b.Gait = rendered.Gait;
			}
			else
			{
				b.Pos = body.HomePosition;
				b.Yaw = body.HomeYaw;
				b.HeadYaw = 0f;
				b.HeadPitch = DormantPitch;
				b.Gait = 0f;
			}
			b.Speed = 0f;
			b.Velocity = Vector3.zero;
			if (airborne)
			{
				ResumeFall(b);
			}
			int node = graph.Nearest(b.Pos);
			b.CurNode = ((node >= 0 && Reached(b.Pos, graph.Position(node), 1f)) ? node : (-1));
		}

		private void Resume(FnAiBrain b, AnimSnapshot snap, double now)
		{
			b.OfficeCooldownUntil = snap.CooldownUntil;
			FnWaypoint node = graph.Node(snap.Node);
			bool noDoor;
			if (node != null && node.officeDoorOutside)
			{
				b.Side = node.side;
				noDoor = false;
			}
			else
			{
				noDoor = true;
			}
			if (!b.Body.HasPose)
			{
				b.Pos = snap.Position;
				b.Yaw = snap.Yaw;
			}
			switch (snap.State)
			{
			case FnAiState.Dormant:
				EnterDormant(b, placeAtHome: false);
				return;
			case FnAiState.Blackout:
				EnterBlackout(b);
				return;
			case FnAiState.PoweredDown:
				EnterPoweredDown(b);
				return;
			case FnAiState.Retreat:
				EnterRetreat(b, cooldown: false);
				return;
			case FnAiState.Patrol:
				if (b.Id == FnAnim.Endo)
				{
					b.CoveProgress = Mathf.Clamp01(snap.Interest);
					EnterCove(b);
					return;
				}
				break;
			case FnAiState.Investigate:
				if (snap.Node >= 0)
				{
					EnterInvestigate(b, graph.Position(snap.Node), snap.Node);
					return;
				}
				break;
			case FnAiState.Search:
				if (snap.Node >= 0)
				{
					EnterSearch(b, graph.Position(snap.Node));
					if (snap.StateUntil > 0.0)
					{
						b.StateUntil = snap.StateUntil;
					}
					return;
				}
				break;
			case FnAiState.Chase:
				if (SlotOfActor(snap.Target) >= 0 && _guards[SlotOfActor(snap.Target)].HasHead)
				{
					EnterChase(b, SlotOfActor(snap.Target), now);
					if (snap.StateUntil > 0.0)
					{
						b.StateUntil = snap.StateUntil;
					}
				}
				else
				{
					EnterSearch(b, b.Pos);
				}
				return;
			case FnAiState.Attack:
				if (noDoor)
				{
					EnterSearch(b, b.Pos);
					return;
				}
				b.CurNode = -1;
				EnterRetreat(b, cooldown: true);
				return;
			case FnAiState.ApproachOffice:
				if (!noDoor)
				{
					EnterApproach(b, b.Side, fromChase: false);
					return;
				}
				break;
			case FnAiState.DoorWait:
				if (!noDoor)
				{
					b.CurNode = snap.Node;
					EnterDoorWait(b);
					if (snap.StateUntil > 0.0)
					{
						b.StateUntil = snap.StateUntil;
					}
					return;
				}
				break;
			case FnAiState.DoorBang:
				if (!noDoor)
				{
					b.CurNode = snap.Node;
					EnterDoorBang(b);
					if (b.Id != FnAnim.Endo)
					{
						b.KnocksLeft = Mathf.Clamp(Mathf.RoundToInt(snap.Interest * (float)FnAiRules.MaxKnockBursts), 0, FnAiRules.MaxKnockBursts);
					}
					return;
				}
				break;
			case FnAiState.DoorEnter:
				if (!noDoor)
				{
					b.CurNode = snap.Node;
					EnterDoorEnter(b);
					if (snap.StateUntil > 0.0)
					{
						b.StateUntil = snap.StateUntil;
					}
					return;
				}
				break;
			}
			EnterIdle(b);
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			ResetStreamSequence();
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			_forceFullSend = true;
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (otherPlayer != null && _authority)
			{
				ClearReporter(otherPlayer.ActorNumber);
			}
		}

		private Vector3 OnDoorFloor(Vector3 point, FnDoorSide side)
		{
			int node = graph.DoorNode(side);
			if (node >= 0)
			{
				point.y = graph.Position(node).y;
			}
			return point;
		}

		private Vector3 OutsidePoint(FnDoorSide side)
		{
			FnOffice office = Office;
			Transform transform = ((office != null) ? office.Outside(side) : null);
			if (transform != null)
			{
				return OnDoorFloor(transform.position, side);
			}
			return graph.Position(graph.DoorNode(side));
		}

		private Vector3 DoorwayPoint(FnDoorSide side)
		{
			FnOffice office = Office;
			Transform transform = ((office != null) ? office.Doorway(side) : null);
			if (transform != null)
			{
				return OnDoorFloor(transform.position, side);
			}
			Vector3 outside = OutsidePoint(side);
			if (office == null || office.volume == null)
			{
				return outside;
			}
			Vector3 center = office.volume.transform.TransformPoint(office.volume.center);
			Vector3 toCenter = new Vector3(center.x - outside.x, 0f, center.z - outside.z);
			if (toCenter.x * toCenter.x + toCenter.z * toCenter.z > 0.0001f)
			{
				outside += toCenter.normalized * 1.2f;
			}
			return outside;
		}

		private Vector3 InsidePoint(FnDoorSide side)
		{
			Vector3 doorway = DoorwayPoint(side);
			Vector3 outside = OutsidePoint(side);
			Vector3 inward = new Vector3(doorway.x - outside.x, 0f, doorway.z - outside.z);
			inward = ((inward.x * inward.x + inward.z * inward.z > 0.0001f) ? inward.normalized : Vector3.forward);
			return doorway + inward * InsideLookDepth + Vector3.up * HeadHeight;
		}

		private Vector3 StandPoint(FnAiBrain b, FnDoorSide side)
		{
			int id = (int)b.Id;
			float lateral = ((doorStandOffsets != null && id < doorStandOffsets.Length) ? doorStandOffsets[id] : 0f);
			float depthOffset = ((doorStandDepthOffsets != null && id < doorStandDepthOffsets.Length) ? doorStandDepthOffsets[id] : 0f);
			float depth = doorStandDepth + depthOffset;
			return FnAiRules.DoorStandPoint(OutsidePoint(side), DoorwayPoint(side), depth, lateral);
		}

		private void FaceDoor(FnAiBrain b)
		{
			Face(b, DoorwayPoint(b.Side));
			LookAt(b, InsidePoint(b.Side));
		}

		private void TrackOfficeGuard(FnAiBrain b)
		{
			if (!b.Staring)
			{
				int actor = NearestGuardInOffice(DoorwayPoint(b.Side));
				if (actor > 0)
				{
					LookAtActor(b, actor);
				}
				else
				{
					LookAt(b, InsidePoint(b.Side));
				}
			}
		}

		private int NearestGuardInOffice(Vector3 from)
		{
			FnOffice office = Office;
			if (office == null)
			{
				return 0;
			}
			int result = 0;
			float best = float.MaxValue;
			for (int i = 0; i < _guardSlots; i++)
			{
				ref GuardView guard = ref _guards[i];
				if (guard.Alive && guard.HasHead)
				{
					Vector3 head = guard.Head;
					int actor = guard.Actor;
					if (office.Contains(head, S.office.officeSlack))
					{
						float d = (head - from).sqrMagnitude;
						if (d < best)
						{
							best = d;
							result = actor;
						}
					}
				}
			}
			return result;
		}

		private void EnterApproach(FnAiBrain b, FnDoorSide side, bool fromChase)
		{
			int door = graph.DoorNode(side);
			if (door < 0)
			{
				EnterIdle(b);
				return;
			}
			b.Side = side;
			b.FromChase = fromChase;
			b.AtStand = false;
			b.Idle = false;
			b.Look = FnLook.Forward;
			GoToPoint(b, StandPoint(b, side), door, fromChase || b.Id == FnAnim.Endo);
			SetState(b, FnAiState.ApproachOffice, (int)side);
		}

		private void TickApproach(FnAiBrain b, FnNight night)
		{
			if (b.Pouncing)
			{
				TickPounce(b);
			}
			else if (b.Arrived)
			{
				b.AtStand = true;
				FaceDoor(b);
				if (night.DoorClosed(b.Side))
				{
					EnterDoorBang(b);
				}
				else if (b.Id == FnAnim.Endo)
				{
					EnterDoorEnter(b);
				}
				else
				{
					EnterDoorWait(b);
				}
			}
		}

		private void EnterDoorWait(FnAiBrain b)
		{
			b.StateUntil = FnClock.Now + (double)FnAiRules.WarningSeconds(b.Level, b.T.doorWarningSeconds, _mods.doorWarningMultiplier);
			FaceDoor(b);
			SetState(b, FnAiState.DoorWait, (int)b.Side);
		}

		private void TickDoorWait(FnAiBrain b, FnNight night, double now, float dt)
		{
			if (b.Frozen)
			{
				b.StateUntil += dt;
			}
			else if (night.DoorClosed(b.Side))
			{
				EnterDoorBang(b);
			}
			else if (Ready(now, b.StateUntil))
			{
				EnterDoorEnter(b);
			}
		}

		private void EnterDoorBang(FnAiBrain b)
		{
			b.KnocksLeft = ((b.Id == FnAnim.Endo) ? 1 : FnAiRules.KnockBursts(b.Level, b.T.knockBursts, b.FromChase, Random.value));
			b.KnockExtended = false;
			b.StateUntil = 0.0;
			b.NextBang = 0.0;
			b.Staring = false;
			b.StareCued = false;
			b.BangedOnce = false;
			Vector3 stand = StandPoint(b, b.Side);
			if (Reached(b.Pos, stand, StandArrive))
			{
				b.StopMoving();
			}
			else
			{
				SteerDirect(b, stand, b.Id == FnAnim.Endo, (b.Id == FnAnim.Endo) ? 1f : KnockStepScale);
			}
			FaceDoor(b);
			SetState(b, FnAiState.DoorBang, (int)b.Side);
		}

		private void TickDoorBang(FnAiBrain b, FnNight night, double now, float dt)
		{
			if (b.Frozen)
			{
				if (b.NextBang > 0.0)
				{
					b.NextBang += dt;
				}
				if (b.StateUntil > 0.0)
				{
					b.StateUntil += dt;
				}
				return;
			}
			if (!night.DoorClosed(b.Side))
			{
				EnterDoorEnter(b);
			}
			else
			{
				if (!b.Arrived)
				{
					return;
				}
				if (b.NextBang <= 0.0)
				{
					FaceDoor(b);
					b.NextBang = now + (double)((b.Id == FnAnim.Endo) ? EndoBangDelay : Between(firstKnockDelay));
				}
				else if (b.Staring)
				{
					if (!b.StareCued && night.LightOn(b.Side))
					{
						b.StareCued = true;
						b.Look = FnLook.Point;
						b.LookPoint = InsidePoint(b.Side);
						Cue(b, FnCue.Stare);
					}
					if (Ready(now, b.StateUntil))
					{
						EnterRetreat(b, b.Id != FnAnim.Endo);
					}
				}
				else
				{
					if (!Ready(now, b.NextBang))
					{
						return;
					}
					if (b.KnocksLeft > 0)
					{
						bool heavy;
						int raps;
						if (b.Id == FnAnim.Endo)
						{
							raps = 3;
							heavy = true;
						}
						else if (b.KnocksLeft == 1 && b.Level >= slamFromLevel && Random.value < 0.5f)
						{
							raps = 2;
							heavy = true;
						}
						else
						{
							raps = Mathf.RoundToInt(Between(b.T.knockRaps));
							heavy = false;
						}
						raps = Mathf.Clamp(raps, 1, 6);
						night.MasterKnock(b.Id, b.Side, raps, heavy);
						b.BangedOnce = true;
						b.KnocksLeft--;
						float knock = FnAiRules.KnockSeconds(b.Id, heavy, raps);
						b.NextBang = now + (double)knock + (double)((b.KnocksLeft > 0) ? KnockGap(b) : 0f);
					}
					else
					{
						b.Staring = true;
						b.StateUntil = now + (double)((b.Id == FnAnim.Endo) ? EndoBangHold : Between(lastLookSeconds));
					}
				}
			}
		}

		private float KnockGap(FnAiBrain b)
		{
			return Between(b.T.bangInterval) * _mods.bangIntervalMultiplier;
		}

		private void OfficeNoiseAtDoor(FnAiBrain b)
		{
			if (!b.KnockExtended && b.Id != FnAnim.Endo)
			{
				b.KnockExtended = true;
				b.KnocksLeft = Mathf.Min(b.KnocksLeft + 1, FnAiRules.MaxKnockBursts);
				if (b.Staring)
				{
					b.Staring = false;
					b.StateUntil = 0.0;
					b.NextBang = FnClock.Now + 0.5;
					FaceDoor(b);
				}
			}
		}

		private void EnterDoorEnter(FnAiBrain b)
		{
			FnNight instance = FnNight.Instance;
			if (instance != null && !instance.Blackout)
			{
				instance.MasterSetJam(b.Side, jammed: true);
				b.JamSide = (int)b.Side;
			}
			double now = FnClock.Now;
			b.Staring = false;
			b.StateUntil = now + (double)Mathf.Max(0f, S.catches.doorwayCatchDelay);
			SteerDirect(b, DoorwayPoint(b.Side), run: false, DoorEnterSpeedScale);
			b.Look = FnLook.Point;
			b.LookPoint = InsidePoint(b.Side);
			SetState(b, FnAiState.DoorEnter, (int)b.Side);
		}

		private void TickDoorEnter(FnAiBrain b, FnNight night, double now, float dt)
		{
			if (b.Frozen)
			{
				b.StateUntil += dt;
			}
			else if (Ready(now, b.StateUntil))
			{
				int victim = NearestGuardInOffice(DoorwayPoint(b.Side));
				if (victim < 1 || !night.MasterCatch(victim, b.Id, FnCatchCause.Doorway))
				{
					EnterRetreat(b, cooldown: true);
				}
			}
		}

		private void ReleaseJam(FnAiBrain b)
		{
			int jamSide = b.JamSide;
			if (jamSide < 0)
			{
				return;
			}
			b.JamSide = -1;
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.IsAuthority)
			{
				return;
			}
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain other in brains)
			{
				if (other != b && other.JamSide == jamSide)
				{
					return;
				}
			}
			instance.MasterSetJam((FnDoorSide)jamSide, jammed: false);
		}

		private void EnterBlackout(FnAiBrain b)
		{
			FnDoorSide side = ((b.Id != FnAnim.Bear) ? b.T.side : FnDoorSide.West);
			int node = graph.DoorNode(side);
			b.Side = side;
			b.AtStand = false;
			b.Idle = false;
			b.FromChase = false;
			b.Look = FnLook.Forward;
			if (node >= 0)
			{
				GoToPoint(b, StandPoint(b, side), node, run: false);
			}
			else
			{
				b.StopMoving();
			}
			SetState(b, FnAiState.Blackout, (int)side);
		}

		private void TickBlackout(FnAiBrain b, FnNight night)
		{
			if (!night.Blackout)
			{
				EnterIdle(b);
			}
			else if (b.Arrived)
			{
				if (!b.AtStand)
				{
					b.AtStand = true;
					FaceDoor(b);
				}
				if (b.Id == FnAnim.Bear && !b.MusicBoxAsked && !(night.BlackoutCatchAt > 0.0))
				{
					b.MusicBoxAsked = true;
					night.MasterBeginMusicBox(Between(S.power.musicBoxSeconds));
				}
			}
		}

		private void EnterCove(FnAiBrain b)
		{
			b.Idle = true;
			b.CoveStage = -1;
			b.Look = FnLook.Point;
			b.LookPoint = CoveMouth(b);
			SetState(b, FnAiState.Patrol, b.HomeNode);
		}

		private void TickCove(FnAiBrain b, FnNight night, double now, float dt)
		{
			float fillSeconds = FnAiRules.CoveFillSeconds(b.T.movementInterval, b.Level, coveStages, _mods.coveFillMultiplier);
			b.CoveProgress = FnAiRules.StepCove(b.CoveProgress, CoveWatched(night), fillSeconds, coveDecaySeconds, dt);
			if (b.CoveProgress >= 1f)
			{
				b.CoveProgress = 0f;
				b.CoveStage = -1;
				EnterApproach(b, b.T.side, fromChase: false);
				return;
			}
			int stage = Mathf.Clamp(Mathf.FloorToInt(b.CoveProgress * (float)coveStages), 0, Mathf.Max(coveStages - 1, 0));
			if (stage != b.CoveStage)
			{
				b.CoveStage = stage;
				GoToPoint(b, CoveSpot(b, stage), b.HomeNode, run: false, CoveSpeedScale);
			}
			if (b.Arrived)
			{
				b.HasFace = true;
				b.FaceYaw = b.Body.HomeYaw;
			}
		}

		private Vector3 CoveSpot(FnAiBrain b, int stage)
		{
			Quaternion rotation = Quaternion.Euler(0f, b.Body.HomeYaw, 0f);
			float t = 0f;
			if (coveStages >= 2)
			{
				t = (float)stage / (float)(coveStages - 1);
			}
			Vector3 forward = rotation * Vector3.forward;
			return b.Body.HomePosition + forward * (t * coveCreep);
		}

		private Vector3 CoveMouth(FnAiBrain b)
		{
			Vector3 homePosition = b.Body.HomePosition;
			Vector3 forward = Quaternion.Euler(0f, b.Body.HomeYaw, 0f) * Vector3.forward;
			return homePosition + forward * (coveCreep + 3f) + Vector3.up * HeadHeight;
		}

		private bool CoveWatched(FnNight night)
		{
			if (night.Power <= 0f)
			{
				return false;
			}
			int coveIndex = FnStations.CoveIndex;
			if (coveIndex < 0)
			{
				return false;
			}
			for (int i = 0; i < _guardSlots; i++)
			{
				if (_guards[i].Alive && _guards[i].Camera == coveIndex)
				{
					return true;
				}
			}
			return false;
		}

		private static bool Repellable(FnAiBrain b)
		{
			FnAiState state = b.State;
			if (state != FnAiState.Patrol && state != FnAiState.ApproachOffice)
			{
				return state == FnAiState.DoorEnter;
			}
			return true;
		}

		private void RepelEndo(FnAiBrain b, double now)
		{
			b.Repel = 0f;
			b.CoveProgress = 0f;
			b.RepelCooldownUntil = now + 3.0;
			Cue(b, FnCue.EndoShriek);
			if (b.State == FnAiState.Patrol)
			{
				b.CoveStage = -1;
			}
			else
			{
				EnterRetreat(b, cooldown: false);
			}
		}

		private void OnHeard(FnNoise kind, Vector3 position, float radius, int sourceActor)
		{
			if (!_authority || graph == null)
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			if (instance == null || instance.Phase != FnPhase.Night)
			{
				return;
			}
			bool inOffice = Office != null && Office.Contains(position, OfficeNoiseSlack);
			float throughWallFactor = S.noise.throughWallFactor;
			double now = FnClock.Now;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain fnAiBrain = _brains[i];
				if (!(fnAiBrain.Body == null) && Hears(fnAiBrain))
				{
					Vector3 eye = Eye(fnAiBrain);
					float distance = Vector3.Distance(eye, position);
					float hearingMultiplier = fnAiBrain.T.hearing * _mods.hearingMultiplier;
					if (FnAiRules.Hears(distance, radius, hearingMultiplier, blocked: false, throughWallFactor) && (!FnAiRules.NeedsWallTest(distance, radius, hearingMultiplier, throughWallFactor) || (SpendRay() && graph.Sight(eye, position))))
					{
						Heard(fnAiBrain, instance, position, inOffice, now);
					}
				}
			}
		}

		private static bool Hears(FnAiBrain b)
		{
			if (b.Id == FnAnim.Endo)
			{
				return false;
			}
			switch (b.State)
			{
			case FnAiState.Patrol:
			case FnAiState.Investigate:
			case FnAiState.Search:
			case FnAiState.DoorBang:
				return true;
			case FnAiState.Blackout:
				return b.Id != FnAnim.Bear;
			default:
				return false;
			}
		}

		private void Heard(FnAiBrain b, FnNight night, Vector3 position, bool inOffice, double now)
		{
			if (b.State == FnAiState.DoorBang)
			{
				if (inOffice)
				{
					OfficeNoiseAtDoor(b);
				}
			}
			else if (inOffice)
			{
				if (b.State != FnAiState.Blackout && !night.Blackout && Ready(now, b.OfficeCooldownUntil))
				{
					EnterApproach(b, NearestDoorSide(b), fromChase: false);
				}
			}
			else
			{
				EnterInvestigate(b, position, -1);
			}
		}

		private void OnNoise(object[] a, PhotonMessageInfo info)
		{
			if (!_authority || a.Length < 5 || info.Sender == null)
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			if (instance == null || instance.Phase != FnPhase.Night)
			{
				return;
			}
			int actorNumber = info.Sender.ActorNumber;
			if (!instance.IsAliveGuard(actorNumber))
			{
				return;
			}
			FnNoise kind = (FnNoise)FnNet.B(a[0]);
			byte reported = FnNet.B(a[4]);
			float radius = FnAiRules.ClientNoiseRadius(kind, (float)reported, S.noise.footstepRadius, S.noise.voiceRadius.y);
			if (!(radius <= 0f) && TakeNoiseToken(actorNumber))
			{
				Vector3 vector = new Vector3(FnNet.F(a[1]), FnNet.F(a[2]), FnNet.F(a[3]));
				if (FnAiRules.IsFinite(vector) && FnGame.TryGetHead(actorNumber, out var head))
				{
					FnNoiseBus.Raise(kind, FnAiRules.ClampNear(vector, head, FnAiRules.NoiseClampMeters), radius, actorNumber);
				}
			}
		}

		private bool TakeNoiseToken(int actor)
		{
			double unscaledTimeAsDouble = Time.unscaledTimeAsDouble;
			int num = System.Array.IndexOf(_noiseActors, actor);
			if (num < 0)
			{
				num = Mathf.Max(System.Array.IndexOf(_noiseActors, 0), 0);
				_noiseActors[num] = actor;
				_noiseTokens[num] = Mathf.Max(S.noise.maxReportsPerSecond, 1f);
				_noiseRefill[num] = unscaledTimeAsDouble;
			}
			return FnAiRules.TakeToken(ref _noiseTokens[num], ref _noiseRefill[num], unscaledTimeAsDouble, S.noise.maxReportsPerSecond);
		}

		private void OnBearWatch(object[] a, PhotonMessageInfo info)
		{
			if (_authority && a.Length >= 1 && info.Sender != null)
			{
				int actorNumber = info.Sender.ActorNumber;
				FnNight instance = FnNight.Instance;
				SetWatcher(actorNumber, FnNet.Bool(a[0]) && instance != null && instance.IsAliveGuard(actorNumber));
			}
		}

		private void SetWatcher(int actor, bool watching)
		{
			int num = System.Array.IndexOf(_watchActors, actor);
			if (watching)
			{
				if (num < 0)
				{
					num = System.Array.IndexOf(_watchActors, 0);
					if (num < 0)
					{
						return;
					}
				}
				_watchActors[num] = actor;
				_watching[num] = true;
			}
			else if (num >= 0)
			{
				_watchActors[num] = 0;
				_watching[num] = false;
			}
		}

		private bool AnyLivingWatcher(FnNight night)
		{
			for (int i = 0; i < MaxReporters; i++)
			{
				if (_watching[i] && night.IsAliveGuard(_watchActors[i]))
				{
					return true;
				}
			}
			return false;
		}

		private void UpdateBearFreeze(FnNight night)
		{
			FnAiBrain fnAiBrain = _brains[0];
			if (!(fnAiBrain.Body == null))
			{
				bool flag = fnAiBrain.State != FnAiState.Dormant && fnAiBrain.State != FnAiState.Attack && fnAiBrain.State != FnAiState.PoweredDown && fnAiBrain.Jump != FnJumpPhase.Air && AnyLivingWatcher(night);
				if (flag && !fnAiBrain.Frozen)
				{
					fnAiBrain.Speed = 0f;
					fnAiBrain.Velocity = Vector3.zero;
				}
				fnAiBrain.Frozen = flag;
			}
		}

		private void ClearReporter(int actor)
		{
			SetWatcher(actor, watching: false);
			int num = System.Array.IndexOf(_noiseActors, actor);
			if (num >= 0)
			{
				_noiseActors[num] = 0;
			}
		}

		private void ResetWatchers()
		{
			for (int i = 0; i < MaxReporters; i++)
			{
				_watchActors[i] = 0;
				_watching[i] = false;
				_noiseActors[i] = 0;
			}
		}

		private void CacheGuards(FnNight night, float dt)
		{
			FnOffice office = Office;
			_guardSlots = Mathf.Min(night.GuardSlots, _guards.Length);
			for (int i = 0; i < _guards.Length; i++)
			{
				int num = ((i < _guardSlots) ? night.GuardActor(i) : 0);
				ref GuardView reference = ref _guards[i];
				if (reference.Actor != num)
				{
					reference = new GuardView
					{
						Actor = num,
						Camera = -1
					};
				}
				reference.Alive = num >= 1 && night.GuardStatus(i) == FnGuardStatus.Alive;
				if (!reference.Alive)
				{
					reference.HasHead = false;
					reference.Flashlight = false;
					reference.Camera = -1;
					continue;
				}
				if (FnGame.TryGetHead(num, out var head))
				{
					if (dt > 0f && reference.HasHead)
					{
						reference.Velocity = Vector3.Lerp(reference.Velocity, (head - reference.Head) / dt, 1f - Mathf.Exp(-10f * dt));
					}
					else
					{
						reference.FloorY = graph.Position(graph.Nearest(head)).y;
					}
					reference.Head = head;
					reference.HasHead = true;
				}
				else
				{
					reference.HasHead = false;
					reference.Velocity = Vector3.zero;
				}
				Player p = FnGame.PlayerOf(num);
				reference.Flashlight = FnProps.PlayerBool(p, FnProps.Flashlight);
				reference.Camera = FnProps.PlayerSByte(p, FnProps.Camera, -1);
				Transform transform = ((num == FnGame.LocalActor) ? FnPlatform.RightHand : AvatarHand(num));
				reference.HasHand = transform != null;
				if (reference.HasHand)
				{
					reference.HandPosition = transform.position;
					reference.HandForward = transform.forward;
				}
				reference.InOffice = reference.HasHead && office != null && office.Contains(reference.Head, 0f);
				reference.Lit = reference.Flashlight || (reference.HasHead && NearLitHall(night, reference.Head));
			}
		}

		private static Transform AvatarHand(int actor)
		{
			LethalApeR.Gameplay.ApeGames.AgNetSync agNetSync = FnGame.Avatar(actor);
			if (!(agNetSync != null))
			{
				return null;
			}
			return agNetSync.RightHand;
		}

		private bool NearLitHall(FnNight night, Vector3 head)
		{
			float num = hallLightLitRange * hallLightLitRange;
			for (int i = 0; i < 2; i++)
			{
				if (night.LightOn((FnDoorSide)i))
				{
					int num2 = graph.DoorNode((FnDoorSide)i);
					if (num2 >= 0 && (head - graph.Position(num2)).sqrMagnitude <= num)
					{
						return true;
					}
				}
			}
			return false;
		}

		private int SlotOfActor(int actor)
		{
			if (actor < 1)
			{
				return -1;
			}
			for (int i = 0; i < _guardSlots; i++)
			{
				if (_guards[i].Actor == actor)
				{
					return i;
				}
			}
			return -1;
		}

		private bool HeadOf(int actor, out Vector3 head)
		{
			int num = SlotOfActor(actor);
			if (num >= 0 && _guards[num].HasHead)
			{
				head = _guards[num].Head;
				return true;
			}
			return FnGame.TryGetHead(actor, out head);
		}

		private bool SpendRay()
		{
			if (_rays <= 0)
			{
				return false;
			}
			_rays--;
			return true;
		}

		private void SenseTick(FnNight night, double now, float dt)
		{
			_rays = Mathf.Max(0, S.ai.maxRaycastsPerTick);
			for (int i = 0; i < _guardSlots; i++)
			{
				if (_guards[i].Alive && _guards[i].HasHead)
				{
					_guards[i].FloorY = graph.Position(graph.Nearest(_guards[i].Head)).y;
				}
			}
			_senseRotor = (_senseRotor + 1) % _brains.Length;
			for (int j = 0; j < _brains.Length; j++)
			{
				FnAiBrain fnAiBrain = _brains[(j + _senseRotor) % _brains.Length];
				if (fnAiBrain.Body != null)
				{
					SenseBrain(fnAiBrain, night, now, dt);
				}
			}
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain fnAiBrain2 in brains)
			{
				if (fnAiBrain2.Body == null)
				{
					continue;
				}
				switch (fnAiBrain2.State)
				{
				case FnAiState.DoorWait:
				case FnAiState.DoorBang:
					TrackOfficeGuard(fnAiBrain2);
					break;
				case FnAiState.ApproachOffice:
					if (fnAiBrain2.Id == FnAnim.Endo)
					{
						PounceTick(fnAiBrain2);
					}
					break;
				case FnAiState.Chase:
					ChaseTick(fnAiBrain2, now);
					break;
				}
			}
			HallLights(night, now);
		}

		private void SenseBrain(FnAiBrain b, FnNight night, double now, float dt)
		{
			FnAnim id = b.Id;
			bool flag = id != FnAnim.Endo && UsesSight(b, night);
			bool flag2 = ((b.Id == FnAnim.Endo) ? Repellable(b) : Attractable(b));
			if (!flag && !flag2)
			{
				ForgetSlowly(b, dt);
				if (id == FnAnim.Endo)
				{
					b.Repel = FnAiRules.StepRepel(b.Repel, lit: false, dt);
				}
				return;
			}
			FnSettings.FlashlightSettings flashlight = S.flashlight;
			Vector3 vector = Eye(b);
			Vector3 forward = FnAiRules.LookDirection(b.Yaw, b.HeadYaw, b.HeadPitch);
			Vector3 vector2 = b.Pos + Vector3.up * ChestHeight;
			float secondsToSpot = b.T.secondsToSpot * _mods.spotTimeMultiplier;
			FnAiState state = b.State;
			int num = -1;
			float num2 = 0f;
			int num3 = -1;
			for (int i = 0; i < _guardSlots; i++)
			{
				GuardView guardView = _guards[i];
				if (!guardView.Alive || !guardView.HasHead)
				{
					b.Spot[i] = 0f;
					b.Seen[i] = false;
					continue;
				}
				if (state == FnAiState.Chase && guardView.Actor != b.Target)
				{
					b.Spot[i] = FnAiRules.StepSuspicion(b.Spot[i], seen: false, 1f, secondsToSpot, b.T.secondsToForget, dt);
					b.Seen[i] = false;
					continue;
				}
				float num4 = FnAiRules.SightRange(b.Level, b.T.sightRange, guardView.Lit, b.T.darkSightFactor);
				float distance;
				bool flag3 = FnAiRules.IsInsideCone(vector, forward, guardView.Head, num4, b.T.sightHalfAngle, out distance);
				bool flag4 = false;
				if (flag2 && guardView.Flashlight && guardView.HasHand)
				{
					flag4 = FnAiRules.InBeam(guardView.HandPosition, guardView.HandForward, vector2, flashlight.range, flashlight.attractHalfAngle) && (b.Id != FnAnim.Endo || (guardView.HandPosition - vector2).sqrMagnitude <= flashlight.endoRepelRange * flashlight.endoRepelRange);
				}
				bool flag5 = flag && flag3;
				bool flag6 = false;
				if (flag4 || flag5)
				{
					if (!SpendRay())
					{
						continue;
					}
					flag6 = graph.Sight(vector, guardView.Head);
				}
				bool flag7 = flag6 && flag5;
				b.Seen[i] = flag7;
				if (flag)
				{
					float rateMultiplier = FnAiRules.SpotRateMultiplier(distance, num4, b.T.closeRangeBoost);
					b.Spot[i] = FnAiRules.StepSuspicion(b.Spot[i], flag7, rateMultiplier, secondsToSpot, b.T.secondsToForget, dt);
				}
				if (flag7 && guardView.Actor == b.Target)
				{
					b.LastKnown = guardView.Head;
					b.LastKnownFloorY = guardView.FloorY;
					b.LastSeen = now;
				}
				if (flag6 && flag4)
				{
					num3 = i;
				}
				if (b.Spot[i] > num2)
				{
					num2 = b.Spot[i];
					num = i;
				}
			}
			if (id == FnAnim.Endo)
			{
				b.Repel = FnAiRules.StepRepel(b.Repel, num3 >= 0, dt);
				if (b.Repel >= flashlight.endoRepelSeconds * _mods.endoRepelMultiplier && Ready(now, b.RepelCooldownUntil))
				{
					RepelEndo(b, now);
				}
			}
			else if (state != FnAiState.Chase && flag && num >= 0 && num2 >= 1f)
			{
				EnterChase(b, num, now);
			}
			else if (state != FnAiState.Chase && num3 >= 0 && Attractable(b))
			{
				Vector3 vector3 = new Vector3(_guards[num3].Head.x, _guards[num3].FloorY, _guards[num3].Head.z);
				if (b.State != FnAiState.Investigate || !((b.LastKnown - vector3).sqrMagnitude <= 4f))
				{
					EnterInvestigate(b, vector3, -1);
				}
			}
		}

		private static void ForgetSlowly(FnAiBrain b, float dt)
		{
			for (int i = 0; i < FnAiBrain.MaxGuards; i++)
			{
				b.Spot[i] = FnAiRules.StepSuspicion(b.Spot[i], seen: false, 1f, b.T.secondsToSpot, b.T.secondsToForget, dt);
				b.Seen[i] = false;
			}
		}

		private static bool UsesSight(FnAiBrain b, FnNight night)
		{
			switch (b.State)
			{
			case FnAiState.Patrol:
			case FnAiState.Investigate:
			case FnAiState.Chase:
			case FnAiState.Search:
			case FnAiState.ApproachOffice:
				return true;
			case FnAiState.Blackout:
				if (b.Id != FnAnim.Bear)
				{
					return true;
				}
				if (night.BlackoutCatchAt > 0.0)
				{
					return FnClock.Reached(night.BlackoutCatchAt);
				}
				return false;
			default:
				return false;
			}
		}

		private static bool Attractable(FnAiBrain b)
		{
			if (b.Id == FnAnim.Endo)
			{
				return false;
			}
			switch (b.State)
			{
			case FnAiState.Patrol:
			case FnAiState.Investigate:
			case FnAiState.Search:
				return true;
			default:
				if (b.Id != FnAnim.Bear)
				{
					return b.State == FnAiState.Blackout;
				}
				return false;
			}
		}

		private void ChaseTick(FnAiBrain b, double now)
		{
			int num = SlotOfActor(b.Target);
			if (num < 0 || !_guards[num].HasHead)
			{
				return;
			}
			if (b.Seen[num])
			{
				if (SpendRay())
				{
					Vector3 vector = Vector3.up * KneeHeight;
					bool kneeClear = graph.Sight(b.Pos + vector, new Vector3(_guards[num].Head.x, _guards[num].FloorY, _guards[num].Head.z) + vector);
					b.KneeAt = now;
					b.KneeClear = kneeClear;
				}
				else if (FnAiRules.Elapsed(now, b.KneeAt) > KneeFreshSeconds)
				{
					b.KneeClear = false;
				}
			}
			PlanChase(b, num);
		}

		private void HallLights(FnNight night, double now)
		{
			float num = hallLightAttractRange * hallLightAttractRange;
			for (int i = 0; i < 2; i++)
			{
				if (!night.LightOn((FnDoorSide)i))
				{
					continue;
				}
				int num2 = graph.DoorNode((FnDoorSide)i);
				if (num2 < 0)
				{
					continue;
				}
				Vector3 vector = graph.Position(num2);
				FnAiBrain[] brains = _brains;
				foreach (FnAiBrain fnAiBrain in brains)
				{
					if (!(fnAiBrain.Body == null) && Attractable(fnAiBrain) && fnAiBrain.State != FnAiState.Blackout && Ready(now, fnAiBrain.OfficeCooldownUntil) && !((fnAiBrain.Pos - vector).sqrMagnitude > num) && (fnAiBrain.State != FnAiState.Investigate || fnAiBrain.Arg != num2))
					{
						EnterInvestigate(fnAiBrain, vector, num2);
					}
				}
			}
		}

		private static bool Ready(double now, double stamp)
		{
			if (stamp <= 0.0)
			{
				return true;
			}
			return FnAiRules.Due(now, stamp);
		}

		private static float Between(Vector2 range)
		{
			return Random.Range(Mathf.Min(range.x, range.y), Mathf.Max(range.x, range.y));
		}

		private void TickBrain(FnAiBrain b, FnNight night, double now, float dt, bool blackout)
		{
			if (b.State == FnAiState.PoweredDown)
			{
				return;
			}
			bool flag = b.Level > 0 || (blackout && b.Id == FnAnim.Bear);
			if (b.State == FnAiState.Dormant)
			{
				if (!flag)
				{
					return;
				}
				Wake(b);
			}
			else if (!flag && b.State != FnAiState.DoorEnter && b.State != FnAiState.Attack && (b.State != FnAiState.Retreat || !b.SleepOnArrival))
			{
				EnterRetreat(b, cooldown: false, sleep: true);
			}
			if (flag && blackout && JoinsBlackout(b))
			{
				EnterBlackout(b);
			}
			switch (b.State)
			{
			case FnAiState.Patrol:
				TickPatrol(b, night, now, dt);
				break;
			case FnAiState.Investigate:
				TickInvestigate(b, now);
				break;
			case FnAiState.Chase:
				TickChase(b, night, now);
				break;
			case FnAiState.Search:
				TickSearch(b, now);
				break;
			case FnAiState.ApproachOffice:
				TickApproach(b, night);
				break;
			case FnAiState.DoorWait:
				TickDoorWait(b, night, now, dt);
				break;
			case FnAiState.DoorBang:
				TickDoorBang(b, night, now, dt);
				break;
			case FnAiState.DoorEnter:
				TickDoorEnter(b, night, now, dt);
				break;
			case FnAiState.Retreat:
				TickRetreat(b);
				break;
			case FnAiState.Attack:
				TickAttack(b, now);
				break;
			case FnAiState.Blackout:
				TickBlackout(b, night);
				break;
			}
		}

		private static bool JoinsBlackout(FnAiBrain b)
		{
			switch (b.State)
			{
			case FnAiState.Investigate:
			case FnAiState.Chase:
			case FnAiState.Search:
				return b.Id == FnAnim.Bear;
			case FnAiState.DoorEnter:
			case FnAiState.Attack:
			case FnAiState.Blackout:
				return false;
			case FnAiState.Retreat:
				return !b.SleepOnArrival;
			default:
				return true;
			}
		}

		private void EnterDormant(FnAiBrain b, bool placeAtHome)
		{
			b.StopMoving();
			b.ClearSenses();
			b.Idle = true;
			b.MusicBoxAsked = false;
			b.Frozen = false;
			b.CoveProgress = 0f;
			b.CoveStage = -1;
			b.SleepOnArrival = false;
			b.KnocksLeft = 0;
			b.KnockExtended = false;
			b.FromChase = false;
			b.Repel = 0f;
			b.Look = FnLook.Forward;
			b.HeadYaw = 0f;
			b.HeadPitch = DormantPitch;
			if (placeAtHome)
			{
				b.ResetJump();
				b.Pos = b.Body.HomePosition;
				b.Yaw = b.Body.HomeYaw;
				b.Speed = 0f;
				b.Velocity = Vector3.zero;
				b.Gait = 0f;
				b.CurNode = b.HomeNode;
				b.OfficeCooldownUntil = 0.0;
				b.LastLaugh = double.NegativeInfinity;
			}
			SetState(b, FnAiState.Dormant, 0, placeAtHome);
		}

		private void EnterPoweredDown(FnAiBrain b)
		{
			b.StopMoving();
			b.Speed = 0f;
			b.Velocity = Vector3.zero;
			b.Frozen = false;
			b.Look = FnLook.Forward;
			SetState(b, FnAiState.PoweredDown, 0);
		}

		private void Wake(FnAiBrain b)
		{
			b.ClearSenses();
			b.MusicBoxAsked = false;
			b.CoveProgress = 0f;
			b.CoveStage = -1;
			b.NextGlance = FnClock.Now;
			EnterIdle(b);
		}

		private void EnterIdle(FnAiBrain b)
		{
			FnNight instance = FnNight.Instance;
			if (instance != null && instance.Blackout && (b.Level > 0 || b.Id == FnAnim.Bear))
			{
				EnterBlackout(b);
				return;
			}
			if (b.Id == FnAnim.Endo)
			{
				EnterCove(b);
				return;
			}
			b.StopMoving();
			b.Idle = true;
			b.Look = FnLook.Glance;
			double now = FnClock.Now;
			b.NextMove = now + (double)Mathf.Max(b.T.movementInterval, 0.5f);
			if (IsFavourite(b, b.CurNode))
			{
				b.NextClatter = now + (double)Random.Range(1f, 2.5f);
			}
			SetState(b, FnAiState.Patrol, (b.CurNode >= 0) ? b.CurNode : graph.Nearest(b.Pos));
		}

		private void TickPatrol(FnAiBrain b, FnNight night, double now, float dt)
		{
			if (b.Id == FnAnim.Endo)
			{
				TickCove(b, night, now, dt);
				return;
			}
			if (!b.Idle)
			{
				if (b.Arrived)
				{
					b.Idle = true;
					b.NextMove = (double)Mathf.Max(b.T.movementInterval, 0.5f) + now;
					if (IsFavourite(b, b.CurNode))
					{
						b.NextClatter = (double)Random.Range(1f, 2.5f) + now;
					}
				}
				return;
			}
			if (b.Id == FnAnim.Chicken && IsFavourite(b, b.CurNode) && Ready(now, b.NextClatter))
			{
				b.NextClatter = (double)Between(kitchenClatterInterval) + now;
				Cue(b, FnCue.KitchenClatter);
			}
			if (!Ready(now, b.NextMove))
			{
				return;
			}
			b.NextMove = (double)Mathf.Max(b.T.movementInterval, 0.5f) + now;
			int level = b.Level;
			if (!FnAiRules.MovementRoll(level, Random.Range(1, 21)))
			{
				return;
			}
			if (Ready(now, b.OfficeCooldownUntil) && Random.value < b.T.advanceBias && graph.DoorNode(b.T.side) >= 0)
			{
				EnterApproach(b, b.T.side, fromChase: false);
				return;
			}
			int num = PickPatrolNode(b);
			if (num >= 0)
			{
				b.Idle = false;
				b.Look = FnLook.Glance;
				GoToNode(b, num, run: false);
				SetState(b, FnAiState.Patrol, num);
			}
		}

		private int PickPatrolNode(FnAiBrain b)
		{
			if (b.Favourites.Length != 0 && Random.value < favouriteWeight)
			{
				int num = b.Favourites[Random.Range(0, b.Favourites.Length)];
				if (num != b.CurNode)
				{
					return num;
				}
			}
			return graph.RandomNodeWithin(-1, float.PositiveInfinity, 0f, FnNodeFilter.Patrol, b.CurNode, (b.Id == FnAnim.Endo) ? (-1) : _coveNode);
		}

		private static bool IsFavourite(FnAiBrain b, int node)
		{
			if (node < 0)
			{
				return false;
			}
			for (int i = 0; i < b.Favourites.Length; i++)
			{
				if (b.Favourites[i] == node)
				{
					return true;
				}
			}
			return false;
		}

		private void EnterInvestigate(FnAiBrain b, Vector3 point, int node)
		{
			if (node < 0)
			{
				node = graph.Nearest(point);
				if (node < 0)
				{
					return;
				}
			}
			b.Idle = false;
			b.Lingering = false;
			b.LastKnown = point;
			b.StateUntil = FnClock.Now + (double)InvestigateTimeout;
			b.Look = FnLook.Point;
			b.LookPoint = point + Vector3.up * KneeHeight;
			GoToNode(b, node, run: false);
			SetState(b, FnAiState.Investigate, node);
		}

		private void TickInvestigate(FnAiBrain b, double now)
		{
			if (!b.Lingering && b.Arrived)
			{
				b.Lingering = true;
				b.StateUntil = now + (double)Between(investigateLinger);
				Face(b, b.LastKnown);
				b.Look = FnLook.Glance;
				b.NextGlance = now + 0.6;
			}
			else if (Ready(now, b.StateUntil))
			{
				EnterIdle(b);
			}
		}

		private void EnterChase(FnAiBrain b, int slot, double now)
		{
			GuardView guardView = _guards[slot];
			int actor = guardView.Actor;
			b.LastSeen = now;
			b.PerchSince = 0.0;
			b.Target = actor;
			b.LastKnown = guardView.Head;
			b.LastKnownFloorY = guardView.FloorY;
			b.Idle = false;
			b.Lingering = false;
			b.StateUntil = now + (double)FnAiRules.MaxChaseSeconds(b.Level, b.T.maxChaseSeconds);
			b.KneeClear = false;
			b.KneeAt = double.NegativeInfinity;
			b.Look = FnLook.Actor;
			b.LookActor = actor;
			GoToPoint(b, guardView.Head, graph.Nearest(guardView.Head), run: true);
			SetState(b, FnAiState.Chase, actor);
			FnNet.ToAll(FnRpc.Spotted, (byte)b.Id, actor);
		}

		private void TickChase(FnAiBrain b, FnNight night, double now)
		{
			int num = SlotOfActor(b.Target);
			if (num < 0 || !_guards[num].Alive || !_guards[num].HasHead || Ready(now, b.StateUntil))
			{
				EnterSearch(b, b.LastKnown);
				return;
			}
			GuardView guardView = _guards[num];
			bool flag = b.Seen[num];
			Vector3 vector = new Vector3(guardView.Head.x, guardView.FloorY, guardView.Head.z);
			if (!flag && FnAiRules.ChaseLost(b.Spot[num], b.T.releaseThreshold, (float)FnAiRules.Elapsed(now, b.LastSeen), b.T.loseSightSeconds))
			{
				EnterSearch(b, b.LastKnown);
				return;
			}
			if (guardView.InOffice)
			{
				if (night.Blackout)
				{
					EnterIdle(b);
				}
				else if (Ready(now, b.OfficeCooldownUntil))
				{
					EnterApproach(b, NearestDoorSide(b), fromChase: true);
				}
				else
				{
					EnterSearch(b, b.LastKnown);
				}
				return;
			}
			if (FnAiRules.IsPerched(guardView.Head.y, guardView.FloorY, S.catches.reachHeight))
			{
				if (TickJumpChase(b, num, now) || b.PerchNode < 0 || (!b.Arrived && !Reached(b.Pos, graph.Position(b.PerchNode), PerchArrive)))
				{
					return;
				}
				if (b.PerchSince <= 0.0)
				{
					b.PerchSince = now;
				}
				if (FnAiRules.Elapsed(now, b.PerchSince) >= (double)S.catches.perchGiveUpSeconds)
				{
					EnterSearch(b, b.LastKnown);
					return;
				}
				b.StopMoving();
				b.Running = true;
				Face(b, vector);
			}
			else
			{
				JumpTargetDown(b);
				b.PerchSince = 0.0;
				b.PerchNode = -1;
				if (flag && b.Direct)
				{
					b.DirectPoint = vector;
				}
			}
		}

		private void PlanChase(FnAiBrain b, int slot)
		{
			GuardView guardView = _guards[slot];
			Vector3 head = guardView.Head;
			float floorY = guardView.FloorY;
			if (FnAiRules.IsPerched(head.y, floorY, S.catches.reachHeight))
			{
				if (!PlanJump(b, slot))
				{
					int num = graph.NearestFlagged(head, FnNodeFilter.PerchBase, PerchBaseRange);
					if (num < 0)
					{
						num = graph.Nearest(head);
					}
					if (num != b.PerchNode)
					{
						b.PerchNode = num;
						b.PerchSince = 0.0;
						GoToNode(b, num, run: true);
					}
				}
				return;
			}
			Vector3 vector = new Vector3(head.x, floorY, head.z);
			if (!b.Seen[slot])
			{
				vector = new Vector3(b.LastKnown.x, b.LastKnownFloorY, b.LastKnown.z);
			}
			if (b.KneeClear)
			{
				SteerDirect(b, vector, run: true);
				return;
			}
			int num2 = graph.Nearest(vector);
			if (!b.Direct && b.GoalNode == num2 && b.HasGoalPoint)
			{
				b.GoalPoint = vector;
			}
			else
			{
				GoToPoint(b, vector, num2, run: true);
			}
		}

		private FnDoorSide NearestDoorSide(FnAiBrain b)
		{
			int from = ((b.CurNode >= 0) ? b.CurNode : graph.Nearest(b.Pos));
			float num = graph.Distance(from, graph.DoorNode(FnDoorSide.West));
			float num2 = graph.Distance(from, graph.DoorNode(FnDoorSide.East));
			if (num == float.PositiveInfinity && num2 == float.PositiveInfinity)
			{
				return b.T.side;
			}
			if (!(num > num2))
			{
				return FnDoorSide.West;
			}
			return FnDoorSide.East;
		}

		private void EnterSearch(FnAiBrain b, Vector3 lastKnown)
		{
			b.Target = 0;
			b.Idle = false;
			b.Lingering = false;
			b.SearchCenter = graph.Nearest(lastKnown);
			if (b.SearchCenter < 0)
			{
				EnterIdle(b);
				return;
			}
			b.StateUntil = FnClock.Now + (double)Between(b.T.searchSeconds);
			b.Look = FnLook.Glance;
			GoToNode(b, b.SearchCenter, run: false, SearchSpeedScale);
			SetState(b, FnAiState.Search, b.SearchCenter);
		}

		private void TickSearch(FnAiBrain b, double now)
		{
			if (Ready(now, b.StateUntil))
			{
				EnterIdle(b);
			}
			else
			{
				if (!b.Arrived)
				{
					return;
				}
				int exclude = ((b.Id == FnAnim.Endo) ? (-1) : _coveNode);
				int num = ((Random.value < 0.7f) ? graph.RandomNodeWithin(b.SearchCenter, searchRadius, 0f, FnNodeFilter.Hiding, b.CurNode, exclude) : (-1));
				if (num < 0)
				{
					num = graph.RandomNodeWithin(b.SearchCenter, searchRadius, 0f, FnNodeFilter.Patrol, b.CurNode, exclude);
					if (num < 0)
					{
						EnterIdle(b);
						return;
					}
				}
				GoToNode(b, num, run: false, SearchSpeedScale);
			}
		}

		private void EnterRetreat(FnAiBrain b, bool cooldown, bool sleep = false)
		{
			double now = FnClock.Now;
			if (cooldown)
			{
				b.OfficeCooldownUntil = now + (double)FnAiRules.OfficeCooldownSeconds(b.Level, b.T.officeCooldown, _mods.officeCooldownMultiplier);
			}
			b.Idle = false;
			b.SleepOnArrival = sleep;
			b.Look = FnLook.Forward;
			int num;
			if (sleep || b.Id == FnAnim.Endo)
			{
				num = b.HomeNode;
				GoToPoint(b, b.Body.HomePosition, num, run: false);
			}
			else
			{
				num = PickRetreatNode(b);
				GoToNode(b, num, run: false);
			}
			if (b.Id == FnAnim.Endo)
			{
				b.CoveProgress = 0f;
				b.CoveStage = -1;
			}
			SetState(b, FnAiState.Retreat, num);
		}

		private int PickRetreatNode(FnAiBrain b)
		{
			int num = ((b.CurNode >= 0) ? b.CurNode : graph.Nearest(b.Pos));
			int num2 = graph.RandomNodeWithin(num, float.PositiveInfinity, retreatMinDistance, FnNodeFilter.Patrol, num, _coveNode);
			if (num2 < 0)
			{
				num2 = graph.RandomNodeWithin(-1, float.PositiveInfinity, 0f, FnNodeFilter.Patrol, num, _coveNode);
				if (num2 < 0)
				{
					return b.HomeNode;
				}
			}
			return num2;
		}

		private void TickRetreat(FnAiBrain b)
		{
			if (b.Arrived)
			{
				if (b.SleepOnArrival)
				{
					EnterDormant(b, placeAtHome: false);
				}
				else
				{
					EnterIdle(b);
				}
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		private void Awake()
		{
			Instance = this;
			for (int i = 0; i < _brains.Length; i++)
			{
				_brains[i] = new FnAiBrain
				{
					Id = (FnAnim)i,
					Body = ((i < animatronics.Length) ? animatronics[i] : null)
				};
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			FnNet.On(FnRpc.Noise, OnNoise);
			FnNet.On(FnRpc.BearWatch, OnBearWatch);
			FnNet.On(FnRpc.CatchReport, OnCatchReport);
			FnNet.On(FnRpc.AnimState, OnAnimState);
			FnNet.On(FnRpc.AnimCue, OnAnimCue);
			SubscribePoses();
			FnNoiseBus.Heard -= OnHeard;
			FnNoiseBus.Heard += OnHeard;
			_bodiesPlaced = false;
			_localCaught = false;
			_haveSequence = false;
		}

		public override void OnDisable()
		{
			base.OnDisable();
			FnNet.Off(FnRpc.Noise, OnNoise);
			FnNet.Off(FnRpc.BearWatch, OnBearWatch);
			FnNet.Off(FnRpc.CatchReport, OnCatchReport);
			FnNet.Off(FnRpc.AnimState, OnAnimState);
			FnNet.Off(FnRpc.AnimCue, OnAnimCue);
			UnsubscribePoses();
			FnNoiseBus.Heard -= OnHeard;
			ClearLevelOverrides();
			BindNight(null);
			_authority = false;
			_haveMasterPhase = false;
			for (int i = 0; i < animatronics.Length; i++)
			{
				if (animatronics[i] != null)
				{
					animatronics[i].Unpublish();
				}
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Update()
		{
			FnNight instance = FnNight.Instance;
			BindNight(instance);
			if (instance == null || !instance.InNightRoom || graph == null)
			{
				if (_authority)
				{
					DropAuthority();
				}
				return;
			}
			if (!_bodiesPlaced)
			{
				PlaceBodies();
			}
			if (_poseClient == null)
			{
				SubscribePoses();
			}
			if (PhotonNetwork.IsMasterClient && instance.IsAuthority)
			{
				_mods = S.For(instance.Difficulty);
				if (!_authority)
				{
					BecomeAuthority(instance);
				}
			}
			else if (_authority)
			{
				DropAuthority();
			}
			if (_authority)
			{
				MasterTick(instance);
			}
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (!(instance == null) && instance.InNightRoom && !(graph == null) && _bodiesPlaced)
			{
				RenderBodies();
				LocalCatchTest(instance);
			}
		}

		private void BindNight(FnNight night)
		{
			if (!(_boundNight == night))
			{
				if (_boundNight != null)
				{
					_boundNight.Caught -= OnCaughtEvent;
					_boundNight.Knocked -= OnKnockedEvent;
				}
				_boundNight = night;
				if (!(night == null))
				{
					night.Caught += OnCaughtEvent;
					night.Knocked += OnKnockedEvent;
				}
			}
		}

		private void PlaceBodies()
		{
			_bodiesPlaced = true;
			graph.EnsureBuilt();
			int serverTimestamp = PhotonNetwork.ServerTimestamp;
			_coveNode = -1;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAiBrain fnAiBrain = _brains[i];
				fnAiBrain.Body = ((i < animatronics.Length) ? animatronics[i] : null);
				ResolveTuning(fnAiBrain);
				if (!(fnAiBrain.Body == null))
				{
					if (fnAiBrain.Body.id != fnAiBrain.Id)
					{
						Debug.LogWarning(string.Format("[FnAiDirector] animatronics[{0}] is '{1}' with id {2}; slot {3} is {4}.", i, fnAiBrain.Body.name, fnAiBrain.Body.id, i, fnAiBrain.Id), fnAiBrain.Body);
					}
					fnAiBrain.Body.EnsureInit();
					fnAiBrain.HomeNode = graph.Find(fnAiBrain.T.homeNode);
					if (fnAiBrain.HomeNode < 0)
					{
						fnAiBrain.HomeNode = graph.Nearest(fnAiBrain.Body.HomePosition);
					}
					if (fnAiBrain.Id == FnAnim.Endo)
					{
						_coveNode = fnAiBrain.HomeNode;
					}
					fnAiBrain.Favourites = ResolveFavourites(fnAiBrain.T.favouriteNodes);
					FnPoseSample pose = HomePose(fnAiBrain);
					fnAiBrain.Body.Place(in pose);
					fnAiBrain.Body.HoldStream(in pose, serverTimestamp - 100);
					fnAiBrain.Body.ForgetReliable();
					ApplySnapshotToBody(i, serverTimestamp, initial: true);
				}
			}
		}

		private int[] ResolveFavourites(string[] names)
		{
			if (names == null || names.Length == 0)
			{
				return new int[0];
			}
			int[] array = new int[graph.Count];
			int num = 0;
			for (int i = 0; i < names.Length; i++)
			{
				int num2 = graph.FindAll(names[i], null);
				if (num2 == 0)
				{
					continue;
				}
				int[] array2 = new int[num2];
				graph.FindAll(names[i], array2);
				for (int j = 0; j < array2.Length; j++)
				{
					if (num < array.Length)
					{
						int num3 = array2[j];
						if (System.Array.IndexOf(array, num3, 0, num) < 0)
						{
							array[num++] = num3;
						}
					}
				}
			}
			int[] array3 = new int[num];
			System.Array.Copy(array, array3, num);
			return array3;
		}

		private FnPoseSample HomePose(FnAiBrain b)
		{
			byte id = (byte)b.Id;
			Vector3 position = ((b.Body != null) ? b.Body.HomePosition : graph.Position(b.HomeNode));
			float yaw = ((b.Body != null) ? b.Body.HomeYaw : 0f);
			return new FnPoseSample
			{
				Id = id,
				Position = position,
				Yaw = yaw,
				HeadYaw = 0f,
				HeadPitch = DormantPitch,
				State = FnAiState.Dormant
			};
		}

		private void ResolveTuning(FnAiBrain b)
		{
			FnAnimTuning[] array = S.ai.animatronics;
			b.T = ((array != null && (int)b.Id < array.Length && array[(int)b.Id] != null) ? array[(int)b.Id] : _fallbackTuning[(int)b.Id]);
		}

		private int LevelOf(FnAiBrain b, FnNight night)
		{
			if (b.LevelOverride >= 0)
			{
				return Mathf.Min(b.LevelOverride, FnAiRules.MaxLevel);
			}
			FnSettings.AiSettings ai = S.ai;
			return FnAiRules.Level(b.T.nightLevels, night.NightNumber, night.Hour, night.ArrivedCount, ai.levelBumpHours, ai.teamOffsetPerExtraGuard, ai.levelCap, _mods.levelBonus);
		}

		private void MasterTick(FnNight night)
		{
			FnPhase phase = night.Phase;
			if (!_haveMasterPhase || _masterPhase != phase)
			{
				_haveMasterPhase = true;
				_masterPhase = phase;
				OnMasterPhase(phase);
			}
			double now = FnClock.Now;
			float deltaTime = Time.deltaTime;
			switch (phase)
			{
			case FnPhase.Night:
				TickNight(night, now, deltaTime);
				break;
			case FnPhase.Lost:
				TickLost(now, deltaTime);
				break;
			default:
				LandLeaps(deltaTime);
				break;
			}
			FlushSnapshots(now);
			SendPoses();
		}

		private void OnMasterPhase(FnPhase phase)
		{
			switch (phase)
			{
			case FnPhase.Gathering:
			case FnPhase.Briefing:
			{
				ResetWatchers();
				FnAiBrain[] brains = _brains;
				foreach (FnAiBrain fnAiBrain in brains)
				{
					if (fnAiBrain.Body != null)
					{
						EnterDormant(fnAiBrain, placeAtHome: true);
					}
				}
				break;
			}
			case FnPhase.Dawn:
			{
				FnAiBrain[] brains = _brains;
				foreach (FnAiBrain fnAiBrain in brains)
				{
					if (fnAiBrain.Body != null && fnAiBrain.State != FnAiState.PoweredDown)
					{
						EnterPoweredDown(fnAiBrain);
					}
				}
				break;
			}
			}
		}

		private void TickNight(FnNight night, double now, float dt)
		{
			CacheGuards(night, dt);
			bool blackout = night.Blackout;
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain fnAiBrain in brains)
			{
				if (!(fnAiBrain.Body == null))
				{
					ResolveTuning(fnAiBrain);
					fnAiBrain.Level = LevelOf(fnAiBrain, night);
				}
			}
			UpdateBearFreeze(night);
			if (Time.time >= _nextSense)
			{
				float dt2 = ((_lastSense > 0f) ? Mathf.Min(Time.time - _lastSense, 1f) : S.ai.senseTickSeconds);
				_lastSense = Time.time;
				_nextSense = Time.time + Mathf.Max(S.ai.senseTickSeconds, 0.05f);
				SenseTick(night, now, dt2);
			}
			brains = _brains;
			foreach (FnAiBrain fnAiBrain2 in brains)
			{
				if (!(fnAiBrain2.Body == null))
				{
					TickBrain(fnAiBrain2, night, now, dt, blackout);
					Locomote(fnAiBrain2, now, dt);
					UpdateHead(fnAiBrain2, now);
				}
			}
			Backstop(night);
		}

		private void TickLost(double now, float dt)
		{
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain fnAiBrain in brains)
			{
				if (fnAiBrain.Body == null)
				{
					continue;
				}
				CancelCharge(fnAiBrain);
				if (fnAiBrain.State == FnAiState.Attack)
				{
					TickAttack(fnAiBrain, now);
					if (fnAiBrain.State != FnAiState.Attack)
					{
						fnAiBrain.StopMoving();
					}
				}
				else if (!fnAiBrain.Arrived || fnAiBrain.Direct)
				{
					fnAiBrain.StopMoving();
				}
				Locomote(fnAiBrain, now, dt);
				UpdateHead(fnAiBrain, now);
			}
		}

		private void LandLeaps(float dt)
		{
			if (!(dt > 0f))
			{
				return;
			}
			FnAiBrain[] brains = _brains;
			foreach (FnAiBrain fnAiBrain in brains)
			{
				if (!(fnAiBrain.Body == null) && fnAiBrain.Jump != FnJumpPhase.None)
				{
					CancelCharge(fnAiBrain);
					StepJump(fnAiBrain, dt);
				}
			}
		}

		private void SetState(FnAiBrain b, FnAiState state, int arg, bool force = false)
		{
			bool flag = b.State != state;
			if (flag || b.Arg != arg || force)
			{
				if (flag)
				{
					LeaveState(b, state);
				}
				b.State = state;
				b.Arg = arg;
				if (flag)
				{
					b.StateSince = FnClock.Now;
				}
				b.SnapStateDirty = true;
				FnNet.ToAll(FnRpc.AnimState, (byte)b.Id, (byte)state, arg, b.Pos.x, b.Pos.y, b.Pos.z);
				if (logStateChanges)
				{
					Debug.Log(string.Format("[FnAiDirector] {0} -> {1} ({2}) level {3}", b.Id, state, arg, b.Level));
				}
			}
		}

		private void LeaveState(FnAiBrain b, FnAiState next)
		{
			if (b.JamSide >= 0 && next != FnAiState.DoorEnter && next != FnAiState.Attack)
			{
				ReleaseJam(b);
			}
			b.Staring = false;
			b.Lingering = false;
			b.HasFace = false;
			if (next != FnAiState.Chase && next != FnAiState.Attack)
			{
				b.Target = 0;
			}
			CancelCharge(b);
			if (next != FnAiState.Chase && next != FnAiState.Attack)
			{
				b.ForgetJumpPlan();
			}
			b.PouncedThisSprint = false;
		}

		private void Cue(FnAiBrain b, FnCue cue)
		{
			FnNet.ToAll(FnRpc.AnimCue, (byte)b.Id, (byte)cue);
		}

		private void RenderBodies()
		{
			float deltaTime = Time.deltaTime;
			int renderTs = PhotonNetwork.ServerTimestamp - 100;
			for (int i = 0; i < _brains.Length; i++)
			{
				FnAnimatronic body = _brains[i].Body;
				if (body == null)
				{
					continue;
				}
				if (_authority)
				{
					FnAiBrain fnAiBrain = _brains[i];
					fnAiBrain.Sample(out var p);
					FnAiState state = fnAiBrain.State;
					int target = ((state == FnAiState.Attack || state == FnAiState.Chase) ? fnAiBrain.Target : 0);
					body.Render(in p, fnAiBrain.Velocity, target, state, deltaTime);
				}
				else if (body.SampleStream(renderTs, out var pose, out var velocity))
				{
					body.Render(in pose, velocity, body.StreamTarget(pose.State), body.CueState(pose.State), deltaTime);
				}
			}
		}

		private void OnKnockedEvent(FnAnim anim, FnDoorSide side, int raps, bool heavy)
		{
			if ((int)anim < _brains.Length && _brains[(int)anim].Body != null)
			{
				_brains[(int)anim].Body.Knock(side, raps, heavy);
			}
		}
	}
}
