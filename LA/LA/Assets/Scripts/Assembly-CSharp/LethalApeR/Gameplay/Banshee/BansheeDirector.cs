using System;
using System.Collections.Generic;
using GorillaLocomotion;
using LethalApeR.Gameplay.Monsters;
using LethalApeR.MonsterIndex;
using LethalApeR.Quests;
using LethalApeR.SeasonPass;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	[DefaultExecutionOrder(-50)]
	public sealed class BansheeDirector : MonoBehaviour
	{
		private const float MotionEvery = 0.1f;

		private const float MeterEvery = 0.25f;

		private const float SteerAcceleration = 28f;

		private const float LeaveSpeed = 14f;

		private readonly Dictionary<int, float> _recentCatch = new Dictionary<int, float>();

		private readonly List<int> _eligible = new List<int>(32);

		private byte[] _meterBytes = new byte[0];

		private byte[] _meterSent = new byte[0];

		private Vector3 _velocity;

		private float _nextMotion;

		private float _nextMeters;

		private float _lastGraveActivity;

		private float _nextRandomRoll;

		private float _targetMissingSince = -1f;

		private float _hostCloseSince = -1f;

		private bool _retargeted;

		private bool _hostStarted;

		[Header("Scene")]
		[Tooltip("Every grave that can wake her. The builder fills this; empty = found in the scene at start.")]
		public BansheeGrave[] graves = new BansheeGrave[0];

		public BansheeGhost ghost;

		public BansheeLift lift;

		[Header("Waking her")]
		[Tooltip("How far from a grave an ape counts as standing at it (m, flat).")]
		public float graveRadius = 4f;

		public float graveHeight = 2.5f;

		[Tooltip("Seconds to fill a grave by how many apes stand at it: index = apes, the last entry covers that many or more.")]
		public float[] fillSeconds = new float[7] { 0f, 12f, 9f, 7f, 6f, 5f, 4f };

		[Tooltip("Seconds for a full grave to empty with nobody at it.")]
		public float drainSeconds = 60f;

		[Tooltip("This many apes at the grave when she rises makes her red.")]
		public int redFromApes = 6;

		[Tooltip("Every grave sleeps this long after she leaves (s).")]
		public float cooldownSeconds = 90f;

		[Header("Rising on her own")]
		public float randomRollEvery = 300f;

		[Tooltip("Only once no grave has been touched for this long (s).")]
		public float randomIdleBefore = 600f;

		public int randomMinApes = 4;

		[Range(0f, 1f)]
		public float randomChance = 0.15f;

		[Header("Hunt and chase")]
		public float riseHeight = 2f;

		[Tooltip("Crossing the map to her target (m/s). Doesn't count towards their escape.")]
		public float huntSpeed = 12f;

		[Tooltip("The chase (and its clock) starts this close to the target (m).")]
		public float chaseFromRange = 15f;

		public float paleStartSpeed = 2.5f;

		public float paleAcceleration = 0.35f;

		public float paleTopSpeed = 6f;

		public float redStartSpeed = 3.5f;

		public float redAcceleration = 0.5f;

		public float redTopSpeed = 7.5f;

		[Tooltip("Outlast this much chase and she gives up (s).")]
		public float chaseSeconds = 20f;

		[Tooltip("Her hands this close to the target's head is a catch (m).")]
		public float catchRadius = 0.9f;

		[Tooltip("How much further the master allows a reported catch, for the target seeing her a little late (m).")]
		public float catchSlack = 1.2f;

		[Tooltip("A caught ape can't be picked again for this long (s).")]
		public float recentCatchSeconds = 30f;

		private readonly List<BansheeAvatar> _players = new List<BansheeAvatar>(32);

		private float[] _meters = new float[0];

		private float _caughtSentAt = -10f;

		private Vector3 _holdOffset;

		private bool _holdKnown;

		private const int InterpDelayMs = 150;

		private const int SnapCapacity = 8;

		private readonly int[] _snapMs = new int[SnapCapacity];

		private readonly Vector3[] _snapPos = new Vector3[SnapCapacity];

		private readonly float[] _snapYaw = new float[SnapCapacity];

		private int _snapCount;

		private int _snapEpoch;

		private float StartSpeed => (Form == BansheeForm.Red) ? redStartSpeed : paleStartSpeed;

		private float Acceleration => (Form == BansheeForm.Red) ? redAcceleration : paleAcceleration;

		private BansheeNet.State CurrentState => new BansheeNet.State
		{
			epoch = Epoch,
			phase = Phase,
			form = Form,
			grave = (byte)Mathf.Clamp(GraveIndex, 0, 255),
			target = Target,
			phaseStartMs = PhaseStartMs,
			exit = Exit
		};

		public static BansheeDirector Instance { get; private set; }

		public int Epoch { get; private set; }

		public BansheePhase Phase { get; private set; }

		public BansheeForm Form { get; private set; }

		public int GraveIndex { get; private set; }

		public int Target { get; private set; }

		public int PhaseStartMs { get; private set; }

		public BansheeExit Exit { get; private set; }

		public bool IsAuthority
		{
			get
			{
				if (PhotonNetwork.InRoom)
				{
					return PhotonNetwork.IsMasterClient;
				}
				return true;
			}
		}

		public float PhaseTime => PlatformClock.SecondsSince(PhaseStartMs);

		public bool IsOut
		{
			get
			{
				if (Phase >= BansheePhase.Rising)
				{
					return Phase <= BansheePhase.Leaving;
				}
				return false;
			}
		}

		public BansheeGrave Grave
		{
			get
			{
				if (GraveIndex < 0 || GraveIndex >= graves.Length)
				{
					return null;
				}
				return graves[GraveIndex];
			}
		}

		public IReadOnlyList<BansheeAvatar> Players => _players;

		public Vector3 Position { get; private set; }

		public float Yaw { get; private set; }

		public float ChaseProgress
		{
			get
			{
				if (Phase != BansheePhase.Chasing || !(chaseSeconds > 0f))
				{
					return 0f;
				}
				return Mathf.Clamp01(PhaseTime / chaseSeconds);
			}
		}

		public float TopSpeed => (Form == BansheeForm.Red) ? redTopSpeed : paleTopSpeed;

		private void HostAwake()
		{
			_meterBytes = new byte[graves.Length];
			_meterSent = new byte[graves.Length];
			_lastGraveActivity = Time.time;
			_nextRandomRoll = Time.time + randomRollEvery;
		}

		private void HostUpdate(float dt)
		{
			if (!_hostStarted)
			{
				_hostStarted = true;
				if (BansheeNet.LastState is BansheeNet.State s && PhotonNetwork.InRoom && s.phase != BansheePhase.Off)
				{
					ApplyState(in s);
					if (IsOut)
					{
						_velocity = Vector3.zero;
					}
				}
				else if (BansheeGate.IsOpen)
				{
					SetPhase(BansheePhase.Sleeping, BansheeExit.None);
				}
			}
			if (!BansheeGate.IsOpen)
			{
				if (Phase != BansheePhase.Off)
				{
					SetPhase(BansheePhase.Off, BansheeExit.Closed);
				}
				return;
			}
			float phaseTime = PhaseTime;
			switch (Phase)
			{
			case BansheePhase.Off:
				SetPhase(BansheePhase.Sleeping, BansheeExit.None);
				break;
			case BansheePhase.Sleeping:
				HostMeters(dt);
				HostRandomRise();
				break;
			case BansheePhase.Rising:
				HostRising(phaseTime);
				break;
			case BansheePhase.Hunting:
			case BansheePhase.Chasing:
				HostPursue(phaseTime, dt);
				break;
			case BansheePhase.Grabbing:
				if (phaseTime >= BansheeTimings.GrabFor)
				{
					Leave(BansheeExit.Caught);
				}
				break;
			case BansheePhase.Leaving:
				HostLeaving(phaseTime, dt);
				break;
			case BansheePhase.Cooldown:
				if (phaseTime >= cooldownSeconds)
				{
					SetPhase(BansheePhase.Sleeping, BansheeExit.None);
				}
				break;
			}
			if (IsOut && Time.time >= _nextMotion)
			{
				_nextMotion = Time.time + MotionEvery;
				BansheeNet.SendMotion(Epoch, Position, Yaw, PlatformClock.NowMs);
			}
		}

		private void HostMeters(float dt)
		{
			int num = -1;
			for (int i = 0; i < graves.Length; i++)
			{
				int num2 = ApesAt(i);
				float num3 = _meters[i];
				if (num2 >= 1)
				{
					float num4 = fillSeconds[Mathf.Min(num2, fillSeconds.Length - 1)];
					num3 += dt / Mathf.Max(0.5f, num4);
					_lastGraveActivity = Time.time;
				}
				else
				{
					num3 -= dt / Mathf.Max(1f, drainSeconds);
				}
				num3 = Mathf.Clamp01(num3);
				_meters[i] = num3;
				_meterBytes[i] = (byte)Mathf.RoundToInt(num3 * 255f);
				if (num3 >= 1f && (num < 0 || num2 > ApesAt(num)))
				{
					num = i;
				}
			}
			if (num >= 0)
			{
				Rise(num, (ApesAt(num) >= redFromApes) ? BansheeForm.Red : BansheeForm.Pale);
			}
			else
			{
				SendMetersIfChanged();
			}
		}

		private void SendMetersIfChanged()
		{
			bool flag = false;
			bool flag2 = false;
			for (int i = 0; i < _meterBytes.Length; i++)
			{
				byte b = _meterBytes[i];
				byte b2 = _meterSent[i];
				if (Candles(b) != Candles(b2))
				{
					flag = true;
				}
				else
				{
					flag2 |= Math.Abs(b - b2) > 11;
				}
			}
			if (flag || (flag2 && Time.time >= _nextMeters))
			{
				_nextMeters = Time.time + MeterEvery;
				Array.Copy(_meterBytes, _meterSent, _meterBytes.Length);
				BansheeNet.SendMeters(_meterBytes);
			}
		}

		private static int Candles(int meterByte)
		{
			return Mathf.FloorToInt((float)meterByte / 255f * (float)BansheeTimings.CandleCount + 0.001f);
		}

		private void HostRandomRise()
		{
			if (!(Time.time < _nextRandomRoll))
			{
				_nextRandomRoll = Time.time + randomRollEvery;
				if (graves.Length != 0 && !(Time.time - _lastGraveActivity < randomIdleBefore) && _players.Count >= randomMinApes && UnityEngine.Random.value < randomChance)
				{
					Rise(UnityEngine.Random.Range(0, graves.Length), BansheeForm.Pale);
				}
			}
		}

		private void Rise(int grave, BansheeForm form)
		{
			for (int i = 0; i < _meters.Length; i++)
			{
				_meters[i] = 0f;
				_meterBytes[i] = 0;
				_meterSent[i] = 0;
			}
			_retargeted = false;
			_targetMissingSince = -1f;
			_hostCloseSince = -1f;
			Epoch++;
			Form = form;
			_velocity = Vector3.zero;
			GraveIndex = grave;
			Target = 0;
			Position = graves[grave].SpawnPoint + Vector3.down * 1.4f;
			Yaw = graves[grave].transform.eulerAngles.y;
			SetPhase(BansheePhase.Rising, BansheeExit.None);
		}

		private void HostRising(float t)
		{
			BansheeGrave grave = Grave;
			if (grave == null)
			{
				Leave(BansheeExit.NoTarget);
				return;
			}
			float num = 1f - Mathf.Clamp01(t / BansheeTimings.RiseFor);
			float t2 = 1f - num * num;
			Position = grave.SpawnPoint + Vector3.up * Mathf.Lerp(-1.4f, riseHeight, t2);
			if (!(t < BansheeTimings.RiseFor))
			{
				int num2 = PickTarget(0);
				if (num2 == 0)
				{
					Leave(BansheeExit.NoTarget);
					return;
				}
				Target = num2;
				SetPhase(BansheePhase.Hunting, BansheeExit.None);
			}
		}

		private int PickTarget(int except)
		{
			_eligible.Clear();
			for (int i = 0; i < _players.Count; i++)
			{
				BansheeAvatar bansheeAvatar = _players[i];
				if (bansheeAvatar.actor != 0 && bansheeAvatar.actor != except && !MonsterExclusionZone.Contains(bansheeAvatar.head) && (!_recentCatch.TryGetValue(bansheeAvatar.actor, out var value) || !(Time.time - value < recentCatchSeconds)))
				{
					_eligible.Add(bansheeAvatar.actor);
				}
			}
			if (_eligible.Count == 0)
			{
				return 0;
			}
			return _eligible[UnityEngine.Random.Range(0, _eligible.Count)];
		}

		private void HostPursue(float t, float dt)
		{
			if (!TryGetPlayer(Target, out var avatar))
			{
				if (_targetMissingSince < 0f)
				{
					_targetMissingSince = Time.time;
				}
				if (Time.time - _targetMissingSince < 1f)
				{
					return;
				}
				if (_retargeted)
				{
					Leave(BansheeExit.NoTarget);
					return;
				}
				int num = PickTarget(Target);
				if (num == 0)
				{
					Leave(BansheeExit.NoTarget);
					return;
				}
				_retargeted = true;
				_targetMissingSince = -1f;
				Target = num;
				SetPhase(BansheePhase.Hunting, BansheeExit.None);
				return;
			}
			_targetMissingSince = -1f;
			Vector3 vector = avatar.head + Vector3.down * 0.15f - Position;
			float magnitude = vector.magnitude;
			bool flag = MonsterExclusionZone.Contains(avatar.head);
			float num2;
			if (Phase == BansheePhase.Hunting)
			{
				if (!(magnitude > chaseFromRange) || flag)
				{
					SetPhase(BansheePhase.Chasing, BansheeExit.None);
					_velocity = Vector3.ClampMagnitude(_velocity, StartSpeed);
					return;
				}
				num2 = huntSpeed;
			}
			else
			{
				if (t >= chaseSeconds)
				{
					Leave(BansheeExit.Escaped);
					return;
				}
				num2 = Mathf.Min(StartSpeed + Acceleration * t, TopSpeed);
			}
			Vector3 target = ((magnitude > 0.001f) ? (vector / magnitude * num2) : Vector3.zero);
			_velocity = Vector3.MoveTowards(_velocity, target, SteerAcceleration * dt);
			Vector3 vector2 = Position + _velocity * dt;
			if (MonsterExclusionZone.Contains(vector2))
			{
				_velocity = Vector3.zero;
			}
			else
			{
				Position = vector2;
			}
			if (_velocity.sqrMagnitude > 0.04f && vector.x * vector.x + vector.z * vector.z > 0.0001f)
			{
				Yaw = Mathf.MoveTowardsAngle(Yaw, Quaternion.LookRotation(new Vector3(vector.x, 0f, vector.z)).eulerAngles.y, 540f * dt);
			}
			if (magnitude < 0.5f && Phase == BansheePhase.Chasing)
			{
				if (_hostCloseSince < 0f)
				{
					_hostCloseSince = Time.time;
				}
				else if (Time.time - _hostCloseSince > 0.8f)
				{
					Catch(Target);
				}
			}
			else
			{
				_hostCloseSince = -1f;
			}
		}

		public void OnCaughtReport(int actor, int epoch)
		{
			if (IsAuthority && epoch == Epoch && actor == Target && (Phase == BansheePhase.Hunting || Phase == BansheePhase.Chasing) && TryGetPlayer(actor, out var avatar))
			{
				float num = catchRadius + catchSlack;
				if (!((avatar.head - Position).sqrMagnitude > num * num))
				{
					Catch(actor);
				}
			}
		}

		private void Catch(int actor)
		{
			_recentCatch[actor] = Time.time;
			_hostCloseSince = -1f;
			Target = actor;
			_velocity = Vector3.zero;
			SetPhase(BansheePhase.Grabbing, BansheeExit.None);
		}

		private void Leave(BansheeExit why)
		{
			_velocity = Vector3.zero;
			SetPhase(BansheePhase.Leaving, why);
		}

		private void HostLeaving(float t, float dt)
		{
			float num = ((Exit == BansheeExit.Escaped) ? BansheeTimings.LeaveEscapedFor : ((Exit == BansheeExit.Caught) ? BansheeTimings.LeaveCaughtFor : BansheeTimings.LeaveNoTargetFor));
			if (Exit == BansheeExit.Escaped || Exit == BansheeExit.NoTarget)
			{
				BansheeGrave grave = Grave;
				if (grave != null)
				{
					Vector3 target = grave.SpawnPoint + ((Exit == BansheeExit.NoTarget) ? (Vector3.down * 1.4f) : (Vector3.up * 0.5f));
					float num2 = ((Exit == BansheeExit.NoTarget) ? 1.6f : LeaveSpeed);
					Position = Vector3.MoveTowards(Position, target, num2 * dt);
				}
			}
			if (t >= num)
			{
				SetPhase(BansheePhase.Cooldown, Exit);
			}
		}

		private void SetPhase(BansheePhase phase, BansheeExit exit)
		{
			BansheeNet.State s = new BansheeNet.State
			{
				epoch = Epoch,
				phase = phase,
				form = Form,
				grave = (byte)Mathf.Clamp(GraveIndex, 0, 255),
				target = Target,
				phaseStartMs = PlatformClock.NowMs,
				exit = exit
			};
			ApplyState(in s);
			BansheeNet.SendState(in s);
			if (phase == BansheePhase.Sleeping)
			{
				SendMetersIfChanged();
			}
		}

		public void OnPlayerJoined(int actor)
		{
			if (IsAuthority)
			{
				BansheeNet.SendState(CurrentState, actor);
				BansheeNet.SendMeters(_meterBytes, actor);
			}
		}

		public void OnMasterSwitched()
		{
			if (IsAuthority)
			{
				_hostStarted = false;
			}
		}

		public void OnJoinedRoom()
		{
			if (lift != null)
			{
				lift.Abort();
			}
			_hostStarted = false;
			_snapCount = 0;
		}

		public void OnLeftRoom()
		{
			if (lift != null)
			{
				lift.Abort();
			}
			_hostStarted = false;
			_snapCount = 0;
			Target = 0;
			if (IsOut)
			{
				SetPhase(BansheePhase.Cooldown, BansheeExit.Closed);
			}
		}

		public float Meter(int grave)
		{
			if (grave < 0 || _meters == null || grave >= _meters.Length)
			{
				return 0f;
			}
			return _meters[grave];
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Debug.LogWarning("[Banshee] A second director was found and disabled.", this);
				base.enabled = false;
				return;
			}
			Instance = this;
			if (graves == null || graves.Length == 0)
			{
				graves = UnityEngine.Object.FindObjectsByType<BansheeGrave>(FindObjectsSortMode.None);
			}
			Array.Sort(graves, (BansheeGrave a, BansheeGrave b) => string.CompareOrdinal(a.name, b.name));
			_meters = new float[graves.Length];
			HostAwake();
			BansheeGate.Bootstrap();
			if (ghost != null)
			{
				ghost.director = this;
			}
			if (lift != null)
			{
				lift.director = this;
			}
			for (int i = 0; i < graves.Length; i++)
			{
				graves[i].Bind(this, i);
			}
			PhaseStartMs = PlatformClock.NowMs;
		}

		private void OnEnable()
		{
			FeatureGates.Changed += OnGatesChanged;
			if (BansheeNet.LastState is BansheeNet.State s && PhotonNetwork.InRoom && !PhotonNetwork.IsMasterClient)
			{
				ApplyState(in s);
			}
		}

		private void OnDisable()
		{
			FeatureGates.Changed -= OnGatesChanged;
			if (lift != null)
			{
				lift.Abort();
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnGatesChanged()
		{
			if (IsAuthority && !BansheeGate.IsOpen && Phase != BansheePhase.Off)
			{
				SetPhase(BansheePhase.Off, BansheeExit.Closed);
			}
		}

		private void Update()
		{
			BansheePlayers.Collect(_players);
			float deltaTime = Time.deltaTime;
			if (IsAuthority)
			{
				HostUpdate(deltaTime);
			}
			else
			{
				ClientInterpolate();
			}
			UpdateHoldPose();
			LocalCatchCheck();
			for (int i = 0; i < graves.Length; i++)
			{
				graves[i].Tick(deltaTime);
			}
		}

		public bool TryGetPlayer(int actor, out BansheeAvatar avatar)
		{
			for (int i = 0; i < _players.Count; i++)
			{
				if (_players[i].actor == actor)
				{
					avatar = _players[i];
					return true;
				}
			}
			avatar = default(BansheeAvatar);
			return false;
		}

		public int ApesAt(int grave)
		{
			BansheeGrave bansheeGrave = ((grave >= 0 && grave < graves.Length) ? graves[grave] : null);
			if (bansheeGrave == null)
			{
				return 0;
			}
			int num = 0;
			for (int i = 0; i < _players.Count; i++)
			{
				if (AtGrave(bansheeGrave, _players[i].head))
				{
					num++;
				}
			}
			return num;
		}

		public bool AtGrave(BansheeGrave g, Vector3 head)
		{
			Vector3 position = g.transform.position;
			float num = head.x - position.x;
			float num2 = head.z - position.z;
			float num3 = head.y - position.y;
			if (num * num + num2 * num2 <= graveRadius * graveRadius && num3 > -0.5f && num3 < graveHeight)
			{
				return !MonsterExclusionZone.Contains(head);
			}
			return false;
		}

		private void LocalCatchCheck()
		{
			if ((Phase != BansheePhase.Hunting && Phase != BansheePhase.Chasing) || Target != BansheePlayers.LocalActor || (lift != null && lift.Active) || Time.time - _caughtSentAt < 0.4f || !BansheePlayers.TryGetLocalHead(out var head) || (Position - head).sqrMagnitude > catchRadius * catchRadius)
			{
				return;
			}
			_caughtSentAt = Time.time;
			if (IsAuthority)
			{
				OnCaughtReport(BansheePlayers.LocalActor, Epoch);
			}
			else
			{
				BansheeNet.SendCaught(Epoch);
			}
		}

		private void UpdateHoldPose()
		{
			if (Phase != BansheePhase.Grabbing || !TryGetPlayer(Target, out var avatar))
			{
				return;
			}
			if (!_holdKnown)
			{
				Vector3 vector = new Vector3(Position.x - avatar.head.x, 0f, Position.z - avatar.head.z);
				Vector3 vector2 = ((vector.sqrMagnitude > 0.01f) ? vector.normalized : Vector3.forward);
				_holdOffset = vector2 * 0.42f + Vector3.up * 0.18f;
				_holdKnown = true;
			}
			Position = avatar.head + _holdOffset;
			Vector3 vector3 = avatar.head - Position;
			if (vector3.x * vector3.x + vector3.z * vector3.z > 0.0001f)
			{
				Yaw = Quaternion.LookRotation(new Vector3(vector3.x, 0f, vector3.z)).eulerAngles.y;
			}
		}

		private void ApplyState(in BansheeNet.State s)
		{
			int epoch = Epoch;
			BansheePhase phase = Phase;
			int target = Target;
			Epoch = s.epoch;
			GraveIndex = s.grave;
			Form = s.form;
			Phase = s.phase;
			Target = s.target;
			PhaseStartMs = s.phaseStartMs;
			Exit = s.exit;
			if (phase == s.phase && epoch == s.epoch && target == s.target)
			{
				return;
			}
			int localActor = BansheePlayers.LocalActor;
			if (s.phase == BansheePhase.Rising && (phase != BansheePhase.Rising || epoch != s.epoch))
			{
				for (int i = 0; i < _meters.Length; i++)
				{
					_meters[i] = 0f;
				}
				_snapCount = 0;
				BansheeGrave grave = Grave;
				if (grave != null)
				{
					Position = grave.SpawnPoint + Vector3.down * 1.4f;
					if (s.form == BansheeForm.Red && BansheePlayers.TryGetLocalHead(out var head) && AtGrave(grave, head))
					{
						SeasonQuestEvents.Raise(SeasonQuestEvent.BansheeRedSummoned);
					}
				}
			}
			if (s.phase == BansheePhase.Grabbing)
			{
				_holdKnown = false;
				if (s.target == localActor)
				{
					if (lift != null)
					{
						lift.Begin();
					}
					QuestEvents.RaiseLocalPlayerJumpscared("Banshee");
					MonsterIndexProgress.Discover("Banshee");
					SeasonQuestEvents.Raise(SeasonQuestEvent.BansheeCaught);
				}
			}
			else if (lift != null && lift.Active)
			{
				lift.Release();
			}
			if (s.phase == BansheePhase.Leaving && s.exit == BansheeExit.Escaped && s.target == localActor)
			{
				SeasonQuestEvents.Raise(SeasonQuestEvent.BansheeEscaped);
			}
			if (ghost != null)
			{
				ghost.OnPhase(phase, s.phase);
			}
			for (int j = 0; j < graves.Length; j++)
			{
				graves[j].OnPhase(phase, s.phase, j == s.grave);
			}
		}

		public void OnRemoteState(in BansheeNet.State s)
		{
			if (!IsAuthority)
			{
				ApplyState(in s);
			}
		}

		public void OnRemoteMeters(byte[] meters)
		{
			if (!IsAuthority && meters != null)
			{
				for (int i = 0; i < _meters.Length && i < meters.Length; i++)
				{
					_meters[i] = (float)(int)meters[i] / 255f;
				}
			}
		}

		public void OnRemoteMotion(int epoch, Vector3 position, float yaw, int serverMs)
		{
			if (IsAuthority)
			{
				return;
			}
			if (epoch != _snapEpoch)
			{
				_snapEpoch = epoch;
				_snapCount = 0;
			}
			else if (_snapCount > 0 && serverMs - _snapMs[(_snapCount - 1) % SnapCapacity] <= 0)
			{
				return;
			}
			int num = _snapCount % SnapCapacity;
			_snapMs[num] = serverMs;
			_snapPos[num] = position;
			_snapYaw[num] = yaw;
			_snapCount++;
		}

		private void ClientInterpolate()
		{
			if (!IsOut || _snapCount == 0 || _snapEpoch != Epoch)
			{
				return;
			}
			int num = PlatformClock.NowMs - InterpDelayMs;
			int num2 = Mathf.Max(0, _snapCount - SnapCapacity);
			for (int num3 = _snapCount - 1; num3 >= num2; num3--)
			{
				int num4 = num3 % SnapCapacity;
				if (_snapMs[num4] - num <= 0)
				{
					if (num3 == _snapCount - 1)
					{
						if (num3 > num2)
						{
							int num5 = (num3 - 1) % SnapCapacity;
							int num6 = Mathf.Max(1, _snapMs[num4] - _snapMs[num5]);
							float num7 = (float)Mathf.Min(num - _snapMs[num4], 200) / (float)num6;
							Position = _snapPos[num4] + (_snapPos[num4] - _snapPos[num5]) * num7;
						}
						else
						{
							Position = _snapPos[num4];
						}
						Yaw = _snapYaw[num4];
					}
					else
					{
						int num8 = (num3 + 1) % SnapCapacity;
						int num9 = _snapMs[num8] - _snapMs[num4];
						float t = ((num9 != 0) ? Mathf.Clamp01((float)(num - _snapMs[num4]) / (float)num9) : 0f);
						Position = Vector3.Lerp(_snapPos[num4], _snapPos[num8], t);
						Yaw = Mathf.LerpAngle(_snapYaw[num4], _snapYaw[num8], t);
					}
					return;
				}
			}
			Position = _snapPos[num2 % SnapCapacity];
			Yaw = _snapYaw[num2 % SnapCapacity];
		}
	}
}
