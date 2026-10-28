using System;
using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Gameplay.Monsters;
using LethalApeR.MonsterIndex;
using LethalApeR.Quests;
using LethalApeR.SeasonPass;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(PhotonView))]
	public sealed class KevinRiftDirector : MonoBehaviourPun, IPunObservable
	{
		private int _spawned;

		private float _nextSpawnAt;

		private int _vortexCursor;

		private float _leashTimer;

		private float _nextLeashCheck;

		private bool _hostStarted;

		private readonly Dictionary<int, float> _caughtUntil = new Dictionary<int, float>();

		private readonly Dictionary<int, Vector2> _meleeBudget = new Dictionary<int, Vector2>();

		private static readonly List<int> Scratch = new List<int>(16);

		private const float MeleeReach = 1.7f;

		private const float HitCushion = 4f;

		private const float MaxMeleeDamage = 45f;

		private const float MeleeHitsPerSecond = 8f;

		public const float DefaultLeashRadius = 30f;

		[Header("Parts")]
		public KevinRiftSite site;

		public ZombieHorde horde;

		public ZombieMelee melee;

		public ZombieJumpscare jumpscare;

		public KevinRiftTips tips;

		[Header("Waves")]
		[Tooltip("Zombies per wave; the number of entries is the number of waves.")]
		public int[] waveSizes = new int[3] { 5, 7, 9 };

		[Tooltip("Chance a zombie in each wave is a runner (sprints when it's close).")]
		public float[] runnerChance = new float[3] { 0.15f, 0.4f, 0.65f };

		[Tooltip("Seconds between zombies climbing out (randomised ±30%).")]
		public float spawnInterval = 0.55f;

		[Tooltip("Pause between one wave dying and the next starting (s).")]
		public float breather = 4f;

		[Header("Rules")]
		[Tooltip("A wave fails when no participant is within this distance of the rift...")]
		public float leashRadius = 30f;

		[Tooltip("...for this long (s).")]
		public float leashSeconds = 6f;

		[Tooltip("Players this close to the rift during a summon or a wave join in (they count for the leash and the clear).")]
		public float joinRadius = 12f;

		[Tooltip("How long a rift stays gone after it clears or fails (s).")]
		public float cooldownSeconds = 60f;

		[Tooltip("A local hand this close to the crystal surface touches it (m).")]
		public float touchDistance = 0.12f;

		[Tooltip("Extra reach the host allows a summon request, for latency and tracking (m).")]
		public float touchSlack = 0.35f;

		[Tooltip("After a player is caught, zombies ignore them this long (s); covers the jumpscare and the teleport.")]
		public float caughtImmunity = 4f;

		[Tooltip("The first-time tip shows when the local player comes this close to a rift (m).")]
		public float tipRadius = 6f;

		private readonly List<int> _summoners = new List<int>(3);

		private readonly List<int> _participants = new List<int>(16);

		private readonly List<RiftAvatar> _players = new List<RiftAvatar>(32);

		private readonly int[] _padHolder = new int[3];

		private float _nextPadScan;

		private float _nextSummonSend;

		private float _localImmuneUntil;

		private bool _killedOne;

		public static KevinRiftDirector Instance { get; private set; }

		public RiftPhase Phase { get; private set; }

		public int Epoch { get; private set; }

		public int AnchorIndex { get; private set; } = -1;

		public int Wave { get; private set; }

		public int PhaseStartMs { get; private set; }

		public IReadOnlyList<int> Summoners => _summoners;

		public IReadOnlyList<int> Participants => _participants;

		public KevinRiftAnchor Anchor => KevinRiftAnchor.Get(AnchorIndex);

		public int WaveCount
		{
			get
			{
				if (waveSizes == null)
				{
					return 1;
				}
				return Mathf.Max(1, waveSizes.Length);
			}
		}

		public float PhaseTime
		{
			get
			{
				if (PhaseStartMs == 0 && Phase == RiftPhase.Off)
				{
					return 0f;
				}
				return (float)(PlatformClock.NowMs - PhaseStartMs) / 1000f;
			}
		}

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

		public bool IsActiveFight
		{
			get
			{
				if (Phase != RiftPhase.Charging)
				{
					return Phase == RiftPhase.Waves;
				}
				return true;
			}
		}

		public IReadOnlyList<RiftAvatar> Players => _players;

		public int PadsHeld { get; private set; }

		public static int PadsRequired
		{
			get
			{
				if (!KevinRiftGate.SoloSummon)
				{
					return 3;
				}
				return 1;
			}
		}

		public bool PadsFull => PadsHeld >= PadsRequired;

		public int LocalPad { get; private set; } = -1;

		public bool LocalIsParticipant => _participants.Contains(RiftPlayers.LocalActor);

		public bool LocalImmune
		{
			get
			{
				if (Time.time < _localImmuneUntil)
				{
					return true;
				}
				if (jumpscare != null)
				{
					return jumpscare.Playing;
				}
				return false;
			}
		}

		public bool IsImmune(int actor)
		{
			if (_caughtUntil.TryGetValue(actor, out var value))
			{
				return Time.time < value;
			}
			return false;
		}

		private void HostUpdate()
		{
			if (!KevinRiftGate.IsOpen || KevinRiftAnchor.All.Count == 0)
			{
				if (_hostStarted)
				{
					HostGateClosed();
				}
				return;
			}
			if (!_hostStarted)
			{
				_hostStarted = true;
				if (Phase == RiftPhase.Off || Anchor == null)
				{
					HostBegin();
				}
			}
			float phaseTime = PhaseTime;
			switch (Phase)
			{
			case RiftPhase.Off:
				HostBegin();
				break;
			case RiftPhase.Charging:
				if (phaseTime >= RiftTimings.WavesAt)
				{
					StartWave(0);
				}
				break;
			case RiftPhase.Waves:
				HostWaves();
				break;
			case RiftPhase.Cleared:
				if (phaseTime >= RiftTimings.ClearedFor)
				{
					SetPhase(RiftPhase.Away, 0);
				}
				break;
			case RiftPhase.Failed:
				if (phaseTime >= RiftTimings.FailedFor)
				{
					SetPhase(RiftPhase.Away, 0);
				}
				break;
			case RiftPhase.Away:
				if (phaseTime >= cooldownSeconds)
				{
					AnchorIndex = PickAnchor(AnchorIndex);
					_summoners.Clear();
					_participants.Clear();
					SetPhase(RiftPhase.Arriving, 0);
				}
				break;
			case RiftPhase.Arriving:
				if (phaseTime >= RiftTimings.ArrivingFor)
				{
					SetPhase(RiftPhase.Dormant, 0);
				}
				break;
			}
		}

		private void HostBegin()
		{
			if (KevinRiftAnchor.All.Count != 0)
			{
				if (AnchorIndex < 0 || Anchor == null)
				{
					AnchorIndex = PickAnchor(-1);
				}
				_summoners.Clear();
				_participants.Clear();
				Epoch = Mathf.Max(Epoch, KevinRiftNet.LastState?.epoch ?? 0) + 1;
				SetPhase(RiftPhase.Dormant, 0);
			}
		}

		private void HostGateClosed()
		{
			if (Phase != RiftPhase.Off)
			{
				if (horde != null)
				{
					horde.SinkAll();
				}
				_summoners.Clear();
				_participants.Clear();
				SetPhase(RiftPhase.Off, 0);
				_hostStarted = false;
			}
		}

		private static int PickAnchor(int avoid)
		{
			int count = KevinRiftAnchor.All.Count;
			if (count == 0)
			{
				return -1;
			}
			if (count == 1)
			{
				return 0;
			}
			if (avoid < 0 || avoid >= count)
			{
				return UnityEngine.Random.Range(0, count);
			}
			int num = UnityEngine.Random.Range(0, count - 1);
			if (num >= avoid)
			{
				num++;
			}
			return num;
		}

		private void SetPhase(RiftPhase phase, int wave)
		{
			KevinRiftNet.State s = new KevinRiftNet.State
			{
				epoch = Epoch,
				phase = phase,
				anchor = Mathf.Max(0, AnchorIndex),
				wave = wave,
				phaseStartMs = PlatformClock.NowMs,
				summoners = _summoners.ToArray(),
				participants = _participants.ToArray()
			};
			ApplyState(in s, fromNetwork: false);
			KevinRiftNet.SendState(in s);
		}

		private void Broadcast(int toActor = 0)
		{
			KevinRiftNet.State s = new KevinRiftNet.State
			{
				epoch = Epoch,
				phase = Phase,
				anchor = Mathf.Max(0, AnchorIndex),
				wave = Wave,
				phaseStartMs = PhaseStartMs,
				summoners = _summoners.ToArray(),
				participants = _participants.ToArray()
			};
			KevinRiftNet.SendState(in s, toActor);
		}

		public void OnSummonRequest(int actor, int epoch, bool left)
		{
			if (!IsAuthority || Phase != RiftPhase.Dormant || Epoch != epoch || site == null || site.crystal == null)
			{
				return;
			}
			ScanPads();
			if (!PadsFull || PadOf(actor) < 0 || !TryGetPlayer(actor, out var avatar))
			{
				return;
			}
			Vector3 hand = avatar.Hand(left);
			if (site.crystal.DistanceToSurface(hand) > touchDistance + touchSlack)
			{
				return;
			}
			_summoners.Clear();
			for (int i = 0; i < _padHolder.Length; i++)
			{
				if (_padHolder[i] != 0)
				{
					_summoners.Add(_padHolder[i]);
				}
			}
			_participants.Clear();
			_participants.AddRange(_summoners);
			AddNearbyParticipants();
			_caughtUntil.Clear();
			Epoch++;
			SetPhase(RiftPhase.Charging, 0);
			if (site != null)
			{
				site.HostSummonedBy(hand);
			}
		}

		private void AddNearbyParticipants()
		{
			KevinRiftAnchor anchor = Anchor;
			if (anchor == null)
			{
				return;
			}
			float num = joinRadius * joinRadius;
			for (int i = 0; i < _players.Count; i++)
			{
				RiftAvatar riftAvatar = _players[i];
				if (riftAvatar.actor != 0 && !_participants.Contains(riftAvatar.actor) && !((riftAvatar.head - anchor.transform.position).sqrMagnitude > num) && !MonsterExclusionZone.Contains(riftAvatar.head))
				{
					_participants.Add(riftAvatar.actor);
				}
			}
		}

		public void AddParticipant(int actor)
		{
			if (IsAuthority && actor != 0 && !_participants.Contains(actor) && IsActiveFight)
			{
				_participants.Add(actor);
				Broadcast();
			}
		}

		private void StartWave(int wave)
		{
			_spawned = 0;
			_nextSpawnAt = Time.time + ((wave == 0) ? 0.1f : breather);
			_vortexCursor = UnityEngine.Random.Range(0, 16);
			_leashTimer = 0f;
			SetPhase(RiftPhase.Waves, wave);
		}

		private void HostWaves()
		{
			if (horde == null)
			{
				return;
			}
			KevinRiftAnchor anchor = Anchor;
			if (anchor == null)
			{
				HostFail();
				return;
			}
			int num = ((waveSizes != null && Wave < waveSizes.Length) ? waveSizes[Wave] : 6);
			if (_spawned < num && horde.ActiveCount < ZombieHorde.MaxSlots && Time.time >= _nextSpawnAt)
			{
				int vortexCount = anchor.VortexCount;
				if (vortexCount > 0)
				{
					int num2 = _vortexCursor++ % vortexCount;
					float num3 = ((runnerChance != null && Wave < runnerChance.Length) ? runnerChance[Wave] : 0.5f);
					if (horde.HostSpawn(anchor.vortexPoints[num2], num2, UnityEngine.Random.value < num3, Wave))
					{
						_spawned++;
						_nextSpawnAt = Time.time + spawnInterval * UnityEngine.Random.Range(0.7f, 1.3f);
					}
					else
					{
						_nextSpawnAt = Time.time + 0.25f;
					}
				}
			}
			if (_spawned >= num && horde.LivingCount == 0)
			{
				if (Wave + 1 < WaveCount)
				{
					StartWave(Wave + 1);
				}
				else
				{
					SetPhase(RiftPhase.Cleared, Wave);
				}
			}
			else
			{
				if (Time.time < _nextLeashCheck)
				{
					return;
				}
				_nextLeashCheck = Time.time + 0.5f;
				int count = _participants.Count;
				AddNearbyParticipants();
				if (_participants.Count != count)
				{
					Broadcast();
				}
				float num4 = leashRadius * leashRadius;
				bool flag = false;
				for (int i = 0; !flag && i < _participants.Count; i++)
				{
					if (TryGetPlayer(_participants[i], out var avatar) && !MonsterExclusionZone.Contains(avatar.head) && (avatar.head - anchor.transform.position).sqrMagnitude <= num4)
					{
						flag = true;
					}
				}
				_leashTimer = (flag ? 0f : (_leashTimer + 0.5f));
				if (_leashTimer >= leashSeconds)
				{
					HostFail();
				}
			}
		}

		private void HostFail()
		{
			if (horde != null)
			{
				horde.SinkAll();
			}
			SetPhase(RiftPhase.Failed, Wave);
		}

		public void OnPlayerJoined(int actor)
		{
			Broadcast(actor);
		}

		public void OnPlayerLeft(int actor)
		{
			_caughtUntil.Remove(actor);
			_meleeBudget.Remove(actor);
			if (_participants.Remove(actor) && IsActiveFight)
			{
				Broadcast();
			}
		}

		public void OnMasterSwitched()
		{
			if (IsAuthority)
			{
				_hostStarted = true;
				if (IsActiveFight)
				{
					HostFail();
				}
				else if (Phase != RiftPhase.Off)
				{
					Broadcast();
				}
			}
		}

		public void OnJoinedRoom()
		{
			_hostStarted = false;
			if (IsAuthority)
			{
				Phase = RiftPhase.Off;
			}
			else if (KevinRiftNet.LastState is KevinRiftNet.State s)
			{
				ApplyState(in s, fromNetwork: false);
			}
		}

		public void OnLeftRoom()
		{
			_hostStarted = false;
			_caughtUntil.Clear();
			if (horde != null)
			{
				horde.ClearAll();
			}
			KevinRiftNet.State s = new KevinRiftNet.State
			{
				epoch = Epoch,
				phase = RiftPhase.Off,
				anchor = Mathf.Max(0, AnchorIndex)
			};
			ApplyState(in s, fromNetwork: false);
		}

		public void OnRemoteState(in KevinRiftNet.State s)
		{
			if (!IsAuthority || !PhotonNetwork.InRoom)
			{
				ApplyState(in s, fromNetwork: false);
			}
		}

		public void OnMeleeReport(int actor, int epoch, byte zombie, byte damage, ZombieDamage cause, bool left, Vector3 point, Vector3 direction)
		{
			if (!IsAuthority || Epoch != epoch || Phase != RiftPhase.Waves || horde == null || !horde.TryGetHostZombie(zombie, out var centre) || !TryGetPlayer(actor, out var avatar))
			{
				return;
			}
			Vector3 vector = avatar.Hand(left);
			if ((vector - centre).sqrMagnitude > MeleeReach * MeleeReach)
			{
				return;
			}
			float time = Time.time;
			if (!_meleeBudget.TryGetValue(actor, out var value))
			{
				value = new Vector2(MeleeHitsPerSecond, time);
			}
			float num = Mathf.Min(MeleeHitsPerSecond, value.x + (time - value.y) * MeleeHitsPerSecond);
			if (num < 1f)
			{
				_meleeBudget[actor] = new Vector2(num, time);
				return;
			}
			_meleeBudget[actor] = new Vector2(num - 1f, time);
			Vector3 vector2 = ((direction.sqrMagnitude > 0.0001f) ? direction : (centre - vector));
			horde.HostDamage(zombie, Mathf.Min((float)(int)damage, MaxMeleeDamage), actor, cause, vector2.normalized, 0f, 1f);
		}

		public void OnHitReport(int actor, int epoch, byte zombie)
		{
			if (IsAuthority && Epoch == epoch && IsActiveFight && !(horde == null) && !IsImmune(actor) && horde.TryGetHostAttacker(zombie, out var at))
			{
				if (TryGetPlayer(actor, out var avatar))
				{
					float num = horde.attackRange + HitCushion;
					if (new Vector2(avatar.head.x - at.x, avatar.head.z - at.z).sqrMagnitude > num * num)
					{
						return;
					}
				}
				_caughtUntil[actor] = Time.time + caughtImmunity;
				AddParticipant(actor);
				horde.HostOnVictimCaught(zombie, actor);
			}
		}

		public void HostBroadcastKill(byte zombie, int killer, ZombieDamage cause)
		{
			KevinRiftNet.SendKill(Epoch, zombie, killer, cause);
			OnKill(Epoch, zombie, killer, cause);
		}

		public int PadHolder(int pad)
		{
			return _padHolder[pad];
		}

		public bool TryGetPlayer(int actor, out RiftAvatar avatar)
		{
			for (int i = 0; i < _players.Count; i++)
			{
				if (_players[i].actor == actor)
				{
					avatar = _players[i];
					return true;
				}
			}
			avatar = default(RiftAvatar);
			return false;
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Debug.LogWarning("[KevinRift] A second director was found and disabled.", this);
				base.enabled = false;
				return;
			}
			Instance = this;
			KevinRiftGate.Bootstrap();
			for (int i = 0; i < _padHolder.Length; i++)
			{
				_padHolder[i] = 0;
			}
			if (horde != null)
			{
				horde.director = this;
			}
			if (melee != null)
			{
				melee.director = this;
			}
			if (site != null)
			{
				site.director = this;
			}
			if (tips != null)
			{
				tips.director = this;
			}
		}

		private void OnEnable()
		{
			FeatureGates.Changed += OnGatesChanged;
			if (KevinRiftNet.LastState is KevinRiftNet.State s && !IsAuthority)
			{
				ApplyState(in s, fromNetwork: false);
			}
		}

		private void OnDisable()
		{
			FeatureGates.Changed -= OnGatesChanged;
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
			if (IsAuthority && !KevinRiftGate.IsOpen)
			{
				HostGateClosed();
			}
		}

		private void Update()
		{
			RiftPlayers.Collect(_players);
			if (Time.time >= _nextPadScan)
			{
				_nextPadScan = Time.time + 0.1f;
				ScanPads();
			}
			if (IsAuthority)
			{
				HostUpdate();
			}
			ClientUpdate();
		}

		private void ScanPads()
		{
			for (int i = 0; i < _padHolder.Length; i++)
			{
				_padHolder[i] = 0;
			}
			PadsHeld = 0;
			LocalPad = -1;
			KevinRiftAnchor anchor = Anchor;
			if (anchor == null || Phase != RiftPhase.Dormant)
			{
				return;
			}
			for (int j = 0; j < KevinRiftAnchor.PadCount; j++)
			{
				Vector3 vector = anchor.PadPosition(j);
				int num = 0;
				float num2 = KevinRiftAnchor.PadRadius * KevinRiftAnchor.PadRadius;
				for (int k = 0; k < _players.Count; k++)
				{
					RiftAvatar riftAvatar = _players[k];
					if (riftAvatar.actor == 0 || HoldsPad(riftAvatar.actor))
					{
						continue;
					}
					float num3 = riftAvatar.head.y - vector.y;
					if (!(num3 < 0.05f) && !(num3 > 2.4f))
					{
						float num4 = riftAvatar.head.x - vector.x;
						float num5 = riftAvatar.head.z - vector.z;
						float num6 = num4 * num4 + num5 * num5;
						if (!(num6 > num2))
						{
							num2 = num6;
							num = riftAvatar.actor;
						}
					}
				}
				_padHolder[j] = num;
				if (num != 0)
				{
					PadsHeld++;
					if (num == RiftPlayers.LocalActor)
					{
						LocalPad = j;
					}
				}
			}
		}

		private bool HoldsPad(int actor)
		{
			for (int i = 0; i < _padHolder.Length; i++)
			{
				if (_padHolder[i] == actor)
				{
					return true;
				}
			}
			return false;
		}

		private int PadOf(int actor)
		{
			for (int i = 0; i < _padHolder.Length; i++)
			{
				if (_padHolder[i] == actor)
				{
					return i;
				}
			}
			return -1;
		}

		private void ClientUpdate()
		{
			if (site != null)
			{
				site.Tick();
			}
			if (Phase == RiftPhase.Dormant && LocalPad >= 0 && PadsFull && site != null && site.crystal != null && RiftPlayers.TryGetLocal(out var avatar) && Time.time >= _nextSummonSend)
			{
				bool flag = site.crystal.DistanceToSurface(avatar.leftHand) <= touchDistance;
				if (flag || site.crystal.DistanceToSurface(avatar.rightHand) <= touchDistance)
				{
					_nextSummonSend = Time.time + 0.5f;
					if (IsAuthority)
					{
						OnSummonRequest(RiftPlayers.LocalActor, Epoch, flag);
					}
					else
					{
						KevinRiftNet.SendSummon(Epoch, flag);
					}
				}
			}
			if (tips != null && KevinRiftGate.IsOpen && Anchor != null && RiftPlayers.TryGetLocal(out var avatar2) && (Phase == RiftPhase.Arriving || Phase == RiftPhase.Dormant) && (avatar2.head - Anchor.transform.position).sqrMagnitude < tipRadius * tipRadius)
			{
				tips.OfferFound();
			}
		}

		private void ApplyState(in KevinRiftNet.State s, bool fromNetwork)
		{
			RiftPhase phase = Phase;
			int epoch = Epoch;
			bool flag = s.phase == RiftPhase.Charging && (phase != RiftPhase.Charging || epoch != s.epoch);
			Epoch = s.epoch;
			int wave = Wave;
			Phase = s.phase;
			AnchorIndex = s.anchor;
			Wave = s.wave;
			PhaseStartMs = s.phaseStartMs;
			_summoners.Clear();
			if (s.summoners != null)
			{
				_summoners.AddRange(s.summoners);
			}
			_participants.Clear();
			if (s.participants != null)
			{
				_participants.AddRange(s.participants);
			}
			if (phase != s.phase || epoch != s.epoch || wave != s.wave)
			{
				int localActor = RiftPlayers.LocalActor;
				if (flag && _summoners.Contains(localActor))
				{
					SeasonQuestEvents.Raise(SeasonQuestEvent.KevinRiftSummoned);
				}
				if (phase != RiftPhase.Cleared && s.phase == RiftPhase.Cleared && _participants.Contains(localActor))
				{
					SeasonQuestEvents.Raise(SeasonQuestEvent.KevinRiftCleared);
				}
				if (s.phase == RiftPhase.Waves && phase != RiftPhase.Waves && s.wave == 0 && _participants.Contains(localActor) && tips != null)
				{
					tips.OfferWaves();
				}
				if (site != null)
				{
					site.OnPhase(phase, wave);
				}
				if (horde != null)
				{
					horde.OnPhase(phase);
				}
				if (s.phase == RiftPhase.Away || s.phase == RiftPhase.Off)
				{
					ScanPads();
				}
			}
		}

		public void OnLocalCaught(ZombieView zombie)
		{
			if (LocalImmune || zombie == null || (RiftPlayers.TryGetLocal(out var avatar) && MonsterExclusionZone.Contains(avatar.head)))
			{
				return;
			}
			_localImmuneUntil = Time.time + caughtImmunity;
			if (jumpscare != null)
			{
				jumpscare.Play(zombie.transform.position);
			}
			QuestEvents.RaiseLocalPlayerJumpscared("Rift Ape");
			if (IsAuthority)
			{
				OnHitReport(RiftPlayers.LocalActor, Epoch, zombie.NetId);
			}
			else
			{
				KevinRiftNet.SendHit(Epoch, zombie.NetId);
			}
		}

		public void OnKill(int epoch, byte zombie, int killer, ZombieDamage cause)
		{
			if (Epoch == epoch && RiftPlayers.LocalActor == killer)
			{
				SeasonQuestEvents.Raise(SeasonQuestEvent.ZombieKilled);
				if (!_killedOne)
				{
					_killedOne = true;
					MonsterIndexProgress.Discover("Rift Ape");
				}
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (!(horde == null))
			{
				if (stream.IsWriting)
				{
					horde.WriteStream(stream);
				}
				else
				{
					horde.ReadStream(stream, info.SentServerTimestamp);
				}
			}
		}
	}
}
