using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(-150)]
	public class FnNight : MonoBehaviourPunCallbacks
	{
		private bool _returnRequested;

		private bool _unlockSaved;

		private bool _blackoutHeard;

		private Coroutine _briefingMove;

		private readonly double[] _lightOffAt = new double[2];

		private readonly double[] _doorToggleAt = new double[2];

		private readonly Dictionary<int, Vector3> _lastHeads = new Dictionary<int, Vector3>();

		private readonly int[] _living = new int[3];

		private int _endoHits;

		private bool _closingSent;

		private bool _powerDirty;

		private double _lastPowerWrite = double.NegativeInfinity;

		private double _blackoutFallbackAt;

		private bool _blackoutCatchDone;

		private const float BlackoutMusicBoxFallback = 25f;

		[Tooltip("Office geometry and anchors.")]
		public FnOffice office;

		[Tooltip("Backstage fuse box.")]
		public FnFuseBox fuseBox;

		[Tooltip("Battery spawn points and the pooled battery visuals.")]
		public FnBatteries batteries;

		private readonly FnNightState _view = new FnNightState();

		private FnNightState _auth;

		private FnPhase _lastRaisedPhase;

		private bool _raisedAnyPhase;

		public int LocalUnlockedNight { get; private set; }

		public bool LocalUnlockedNightmare { get; private set; }

		public static string RoomShortName
		{
			get
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				if (currentRoom == null)
				{
					return "";
				}
				return LethalApeR.Networking.CrossplayProfiles.UnsaltedRoomName(LethalApeR.Networking.CrossplayProfiles.Fnaf, currentRoom.Name);
			}
		}

		public int UsageUnits
		{
			get
			{
				FnNightState st = St;
				int num = 0;
				for (int i = 0; i < 2; i++)
				{
					byte b = Bit((FnDoorSide)i);
					if ((st.Doors & b) != 0)
					{
						num++;
					}
					if ((st.Lights & b) != 0)
					{
						num++;
					}
				}
				for (int j = 0; j < st.GuardStatus.Length && j < st.GuardActors.Length; j++)
				{
					if ((FnGuardStatus)st.GuardStatus[j] == FnGuardStatus.Alive)
					{
						Player player = FnGame.PlayerOf(st.GuardActors[j]);
						if (player != null && FnProps.PlayerSByte(player, FnProps.Camera, -1) >= 0)
						{
							num++;
						}
					}
				}
				return num;
			}
		}

		public static FnNight Instance { get; private set; }

		private static FnSettings S => FnGame.Settings;

		public bool IsAuthority
		{
			get
			{
				if (_auth != null)
				{
					return PhotonNetwork.IsMasterClient;
				}
				return false;
			}
		}

		private FnNightState St
		{
			get
			{
				if (!IsAuthority)
				{
					return _view;
				}
				return _auth;
			}
		}

		public bool InNightRoom
		{
			get
			{
				if (FnGame.Instance != null)
				{
					return FnGame.Instance.RoomKind == FnRoomKind.Night;
				}
				return false;
			}
		}

		public bool Active
		{
			get
			{
				if (InNightRoom)
				{
					return St.HasPhase;
				}
				return false;
			}
		}

		public FnPhase Phase => St.Phase;

		public double PhaseStart => St.PhaseStart;

		public double PhaseEnd => St.PhaseEnd;

		public double NightStart => St.NightStart;

		public float HourSeconds => St.HourSeconds;

		public int NightNumber => St.Night;

		public FnDifficulty Difficulty => St.Difficulty;

		public int TeamSize => St.TeamSize;

		public int ArrivedCount => St.Arrived;

		public string[] Roster => St.Roster;

		public int Hour
		{
			get
			{
				FnNightState st = St;
				if (!(st.NightStart > 0.0) || st.Phase < FnPhase.Night)
				{
					return 0;
				}
				return Mathf.Clamp((int)Math.Floor(FnClock.Since(st.NightStart) / (double)Mathf.Max(1f, st.HourSeconds)), 0, 6);
			}
		}

		public float NightProgress
		{
			get
			{
				FnNightState st = St;
				if (!(st.NightStart > 0.0) || st.Phase < FnPhase.Night)
				{
					return 0f;
				}
				return Mathf.Clamp01((float)(FnClock.Since(st.NightStart) / (double)(Mathf.Max(1f, st.HourSeconds) * 6f)));
			}
		}

		public float Power => St.PowerAt(FnClock.Now);

		public float PowerRate => St.PowerRate;

		public bool Blackout => St.Blackout > 0.0;

		public double BlackoutStart => St.Blackout;

		public double BlackoutCatchAt => St.BlackoutEnd;

		public double LureReadyAt => St.LureReady;

		public float LureCooldownLeft
		{
			get
			{
				if (!(St.LureReady > 0.0))
				{
					return 0f;
				}
				return Mathf.Max(0f, -(float)FnClock.Since(St.LureReady));
			}
		}

		public int FuseUsesLeft => St.FuseUses;

		public byte[] FuseOrder => St.FuseOrder;

		public int FuseProgress => St.FuseProgress;

		public int BatteryCount => St.BatteryStates.Length;

		public int BatteriesDelivered => St.BatteriesDelivered;

		public byte Outcome => St.Outcome;

		public int GuardSlots => St.GuardStatus.Length;

		public int LocalSlot => St.SlotOfUser(FnGame.LocalUserId);

		public bool LocalIsAlive
		{
			get
			{
				if (!Active)
				{
					return false;
				}
				if (St.Phase == FnPhase.Gathering)
				{
					return LocalSlot >= 0;
				}
				return IsAliveGuard(FnGame.LocalActor);
			}
		}

		public bool LocalIsGhost
		{
			get
			{
				if (!Active || St.Phase > FnPhase.Lost)
				{
					return false;
				}
				return IsGhost(FnGame.LocalActor);
			}
		}

		public event Action Changed;

		public event Action<FnPhase> PhaseChanged;

		public event Action<int, FnAnim, FnCatchCause> Caught;

		public event Action<FnAnim, FnDoorSide, int, bool> Knocked;

		public event Action<FnAnim, int> Spotted;

		public event Action<int, FnBreakerResult> BreakerResult;

		public event Action<int> LurePlayed;

		public event Action<FnRpc, FnReject, int> Rejected;

		public event Action ReturnToHubRequested;

		public void DebugJumpToHour(int hour)
		{
			if (IsAuthority && _auth.Phase == FnPhase.Night)
			{
				double now = FnClock.Now;
				int num = Mathf.Clamp(hour, 0, 6);
				_auth.NightStart = now - (double)(_auth.HourSeconds * (float)num);
				_auth.PhaseEnd = _auth.NightStart + (double)(_auth.HourSeconds * 6f);
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable[FnProps.NightStart] = _auth.NightStart;
				hashtable[FnProps.PhaseEnd] = _auth.PhaseEnd;
				Write(hashtable);
			}
		}

		public void DebugSetPower(float percent)
		{
			if (IsAuthority && _auth.Phase == FnPhase.Night)
			{
				RebasePower(FnClock.Now);
				AddPower(Mathf.Clamp(percent, 0f, 100f) - _auth.Power);
			}
		}

		public void DebugSkipPhase()
		{
			if (!IsAuthority)
			{
				return;
			}
			switch (_auth.Phase)
			{
			case FnPhase.Gathering:
				StartBriefing();
				break;
			case FnPhase.Briefing:
				StartNight(FnClock.Now);
				break;
			default:
				if (_auth.PhaseEnd > 0.0)
				{
					EnterPhase(_auth.Phase, 0.01f);
				}
				break;
			}
		}

		public void DebugCatch(int actor, FnAnim anim)
		{
			MasterCatch(actor, anim, FnCatchCause.Contact);
		}

		private void OnLocalPhase(FnPhase phase)
		{
			switch (phase)
			{
			case FnPhase.Gathering:
				_returnRequested = false;
				ResetUnlock();
				_blackoutHeard = false;
				break;
			case FnPhase.Briefing:
				_returnRequested = false;
				ResetUnlock();
				_blackoutHeard = false;
				if (LocalSlot >= 0 && !LocalHeadInOffice())
				{
					_briefingMove = StartCoroutine(MoveToOffice());
				}
				FnAudio.Flat((FnGame.Audio != null) ? FnGame.Audio.nightStartSting : null, 0.8f);
				break;
			case FnPhase.Dawn:
				FnAudio.Flat((FnGame.Audio != null) ? FnGame.Audio.sixAmChime : null);
				SaveUnlock();
				break;
			case FnPhase.Closing:
				RequestReturn();
				break;
			}
		}

		private void LocalTick()
		{
			FnNightState st = St;
			if (st.HasPhase)
			{
				if (st.Blackout > 0.0 && !_blackoutHeard)
				{
					_blackoutHeard = true;
					FnAudio.Flat((FnGame.Audio != null) ? FnGame.Audio.powerOut : null);
				}
				else if (st.Blackout <= 0.0)
				{
					_blackoutHeard = false;
				}
				if (st.Phase == FnPhase.Results && st.PhaseEnd > 0.0 && FnClock.Since(st.PhaseEnd) >= (double)S.night.closingGraceSeconds)
				{
					RequestReturn();
				}
			}
		}

		private void SaveUnlock()
		{
			if (!_unlockSaved && LocalSlot >= 0)
			{
				_unlockSaved = true;
				int nightNumber = NightNumber;
				bool nightmareUnlockedLocally = FnProgress.NightmareUnlockedLocally;
				if (FnProgress.RecordCompleted(Difficulty, nightNumber))
				{
					LocalUnlockedNight = ((nightNumber < S.hub.maxNight) ? (nightNumber + 1) : 0);
					LocalUnlockedNightmare = !nightmareUnlockedLocally && FnProgress.NightmareUnlockedLocally;
				}
			}
		}

		private void ResetUnlock()
		{
			_unlockSaved = false;
			LocalUnlockedNight = 0;
			LocalUnlockedNightmare = false;
		}

		private void RequestReturn()
		{
			if (!_returnRequested)
			{
				_returnRequested = true;
				ReturnToHubRequested?.Invoke();
				if (FnMatchmaker.Instance != null)
				{
					FnMatchmaker.Instance.ReturnToHub();
				}
			}
		}

		public bool LocalHeadInOffice()
		{
			Transform head = FnPlatform.Head;
			if (head != null && office != null)
			{
				return office.Contains(head.position, 0f);
			}
			return false;
		}

		private IEnumerator MoveToOffice()
		{
			yield return FnPlatform.FadeOut(S.hub.migrateFadeSeconds);
			if (office != null)
			{
				Transform transform = office.SlotSpawn(LocalSlot);
				if (transform != null)
				{
					FnPlatform.Teleport(transform.position, transform.eulerAngles.y);
				}
			}
			yield return FnPlatform.FadeIn(S.hub.arriveFadeSeconds);
			_briefingMove = null;
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			_auth = null;
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (IsAuthority)
			{
				int num = _auth.SlotOfActor(otherPlayer.ActorNumber);
				if (num >= 0 && _auth.StatusOf(num) == FnGuardStatus.Alive)
				{
					MarkGuard(num, FnGuardStatus.Left, otherPlayer.ActorNumber);
				}
			}
		}

		public override void OnPlayerPropertiesUpdate(Player target, ExitGames.Client.Photon.Hashtable changed)
		{
			if (IsAuthority && changed.ContainsKey(FnProps.Camera) && _auth.Phase == FnPhase.Night)
			{
				SetRate(FnClock.Now);
			}
		}

		private void MasterTick()
		{
			if (FnProps.CurrentRoomKind() != FnRoomKind.Night)
			{
				return;
			}
			if (_auth == null)
			{
				SeedAuthority();
				if (_auth == null)
				{
					return;
				}
			}
			double now = FnClock.Now;
			switch (_auth.Phase)
			{
			case FnPhase.Gathering:
				TickGathering();
				break;
			case FnPhase.Briefing:
				if (FnClock.Reached(_auth.PhaseEnd))
				{
					StartNight(now);
				}
				break;
			case FnPhase.Night:
				TickNight(now);
				break;
			case FnPhase.Dawn:
			case FnPhase.Lost:
				if (FnClock.Reached(_auth.PhaseEnd))
				{
					EnterPhase(FnPhase.Results, S.night.resultsSeconds);
				}
				break;
			case FnPhase.Results:
				if (FnClock.Reached(_auth.PhaseEnd))
				{
					EnterPhase(FnPhase.Closing, 0f);
				}
				break;
			case FnPhase.Closing:
				if (!_closingSent)
				{
					_closingSent = true;
					FnNet.ToAll(FnRpc.ReturnToHub);
				}
				break;
			}
			FlushPower(now);
		}

		private void SeedAuthority()
		{
			_auth = _view.Clone();
			_endoHits = 0;
			_closingSent = false;
			_powerDirty = false;
			_lastPowerWrite = double.NegativeInfinity;
			for (int i = 0; i < 2; i++)
			{
				_doorToggleAt[i] = 0.0;
				_lightOffAt[i] = FnClock.Now + (double)S.office.lightAutoOff;
			}
			if (!_auth.HasPhase)
			{
				if (_auth.Roster.Length == 0)
				{
					_auth.Roster = PresentUserIds();
				}
				_auth.HasPhase = true;
				EnterPhase(FnPhase.Gathering, 0f);
				return;
			}
			double now = FnClock.Now;
			bool flag = false;
			for (int j = 0; j < _auth.GuardStatus.Length && j < _auth.GuardActors.Length; j++)
			{
				if ((FnGuardStatus)_auth.GuardStatus[j] == FnGuardStatus.Alive && FnGame.PlayerOf(_auth.GuardActors[j]) == null)
				{
					_auth.GuardStatus[j] = 2;
					if (j < _auth.GuardTimes.Length)
					{
						_auth.GuardTimes[j] = now;
					}
					DropCarried(_auth.GuardActors[j]);
					flag = true;
				}
			}
			if (flag)
			{
				WriteGuards(withBatteries: true);
			}
			if (_auth.Phase == FnPhase.Night)
			{
				SetRate(now);
			}
			UnityEngine.Debug.Log(string.Format("[FnNight] Took over as master in {0} (night {1}, {2}).", _auth.Phase, _auth.Night, _auth.Difficulty));
		}

		private static string[] PresentUserIds()
		{
			List<string> list = new List<string>();
			if (PhotonNetwork.CurrentRoom != null)
			{
				foreach (Player value in PhotonNetwork.CurrentRoom.Players.Values)
				{
					if (!string.IsNullOrEmpty(value.UserId))
					{
						list.Add(value.UserId);
					}
				}
			}
			return list.ToArray();
		}

		private static Player PlayerByUserId(string userId)
		{
			if (string.IsNullOrEmpty(userId) || PhotonNetwork.CurrentRoom == null)
			{
				return null;
			}
			foreach (Player value in PhotonNetwork.CurrentRoom.Players.Values)
			{
				if (value.UserId == userId)
				{
					return value;
				}
			}
			return null;
		}

		private void TickGathering()
		{
			string[] roster = _auth.Roster;
			string roomShortName = RoomShortName;
			int num = 0;
			int num2 = 0;
			for (int i = 0; i < roster.Length; i++)
			{
				Player player = PlayerByUserId(roster[i]);
				if (player != null)
				{
					num2++;
					if (FnProps.PlayerString(player, FnProps.Arrived) == roomShortName)
					{
						num += ((FnGame.Avatar(player.ActorNumber) != null) ? 1 : 0);
					}
				}
			}
			bool flag = roster.Length != 0 && num == roster.Length;
			bool flag2 = FnClock.Since(_auth.PhaseStart) >= (double)S.night.gatherTimeoutSeconds;
			if (flag || (flag2 && num2 > 0))
			{
				if (!flag)
				{
					UnityEngine.Debug.LogWarning(string.Format("[FnNight] Gathering timed out: {0}/{1} ready, {2} present. Starting.", num, roster.Length, num2));
				}
				StartBriefing();
			}
		}

		private void StartBriefing()
		{
			double now = FnClock.Now;
			if (PhotonNetwork.CurrentRoom != null)
			{
				PhotonNetwork.CurrentRoom.IsOpen = false;
			}
			string[] roster = _auth.Roster;
			int num = roster.Length;
			_auth.GuardActors = new int[num];
			_auth.GuardNames = new string[num];
			_auth.GuardBuilds = new string[num];
			_auth.GuardStatus = new byte[num];
			_auth.GuardTimes = new double[num];
			int num2 = 0;
			for (int i = 0; i < num; i++)
			{
				Player player = PlayerByUserId(roster[i]);
				_auth.GuardActors[i] = ((player != null) ? player.ActorNumber : 0);
				_auth.GuardNames[i] = ((player != null) ? (string.IsNullOrEmpty(player.NickName) ? ("GUARD " + (i + 1)) : player.NickName) : "");
				_auth.GuardBuilds[i] = ((player != null) ? FnProps.PlayerString(player, FnProps.Build) : "");
				_auth.GuardStatus[i] = (byte)((player != null) ? FnGuardStatus.Alive : FnGuardStatus.Absent);
				if (player != null)
				{
					num2++;
				}
			}
			_auth.Arrived = num2;
			_auth.HourSeconds = Mathf.Max(5f, S.night.hourSeconds);
			_auth.Power = Mathf.Clamp(S.power.startPower, 0f, 100f);
			_auth.PowerStamp = now;
			_auth.PowerRate = 0f;
			_auth.Blackout = 0.0;
			_auth.BlackoutEnd = 0.0;
			_auth.Doors = 0;
			_auth.Jams = 0;
			_auth.Lights = 0;
			_auth.LureReady = 0.0;
			_auth.FuseUses = (byte)Mathf.Clamp(S.tasks.fuseUses, 0, 9);
			_auth.FuseOrder = RandomFuseOrder();
			_auth.FuseProgress = 0;
			PlaceBatteries();
			_auth.BatteriesDelivered = 0;
			_auth.Outcome = 0;
			_auth.Phase = FnPhase.Briefing;
			_auth.PhaseStart = now;
			_auth.PhaseEnd = now + (double)Mathf.Max(1f, S.night.briefingSeconds);
			_auth.NightStart = 0.0;
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.ArrivedCount] = (byte)num2;
			hashtable[FnProps.HourSeconds] = _auth.HourSeconds;
			hashtable[FnProps.GuardActors] = _auth.GuardActors;
			hashtable[FnProps.GuardNames] = _auth.GuardNames;
			hashtable[FnProps.GuardBuilds] = _auth.GuardBuilds;
			hashtable[FnProps.GuardStatus] = _auth.GuardStatus;
			hashtable[FnProps.GuardTimes] = _auth.GuardTimes;
			hashtable[FnProps.Power] = _auth.Power;
			hashtable[FnProps.PowerStamp] = _auth.PowerStamp;
			hashtable[FnProps.PowerRate] = _auth.PowerRate;
			hashtable[FnProps.Blackout] = 0.0;
			hashtable[FnProps.BlackoutEnd] = 0.0;
			hashtable[FnProps.Doors] = (byte)0;
			hashtable[FnProps.Jams] = (byte)0;
			hashtable[FnProps.Lights] = (byte)0;
			hashtable[FnProps.LureReady] = 0.0;
			hashtable[FnProps.FuseUses] = _auth.FuseUses;
			hashtable[FnProps.FuseOrder] = _auth.FuseOrder;
			hashtable[FnProps.FuseProgress] = (byte)0;
			hashtable[FnProps.BatteryStates] = _auth.BatteryStates;
			hashtable[FnProps.BatteryArgs] = _auth.BatteryArgs;
			hashtable[FnProps.BatteryDrops] = _auth.BatteryDrops;
			hashtable[FnProps.BatteriesDelivered] = (byte)0;
			hashtable[FnProps.Outcome] = (byte)0;
			hashtable[FnProps.NightStart] = 0.0;
			hashtable[FnProps.Phase] = (byte)FnPhase.Briefing;
			hashtable[FnProps.PhaseStart] = _auth.PhaseStart;
			hashtable[FnProps.PhaseEnd] = _auth.PhaseEnd;
			Write(hashtable);
			UnityEngine.Debug.Log(string.Format("[FnNight] Briefing: night {0} ({1}), {2}/{3} guards.", _auth.Night, _auth.Difficulty, num2, num));
		}

		private static byte[] RandomFuseOrder()
		{
			List<byte> list = new List<byte>();
			for (int i = 0; i < 6; i++)
			{
				list.Add((byte)i);
			}
			byte[] array = new byte[3];
			for (int j = 0; j < array.Length; j++)
			{
				int index = UnityEngine.Random.Range(0, list.Count);
				array[j] = list[index];
				list.RemoveAt(index);
			}
			return array;
		}

		private void PlaceBatteries()
		{
			int num = ((batteries != null && batteries.spawns != null) ? batteries.spawns.Length : 0);
			Vector2Int batteryCount = S.tasks.batteryCount;
			int num2 = Mathf.Min(num, UnityEngine.Random.Range(Mathf.Min(batteryCount.x, batteryCount.y), Mathf.Max(batteryCount.x, batteryCount.y) + 1));
			List<int> list = new List<int>();
			for (int i = 0; i < num; i++)
			{
				list.Add(i);
			}
			_auth.BatteryStates = new byte[num2];
			_auth.BatteryArgs = new int[num2];
			_auth.BatteryDrops = new float[num2 * 3];
			for (int j = 0; j < num2; j++)
			{
				int index = UnityEngine.Random.Range(0, list.Count);
				_auth.BatteryStates[j] = 0;
				_auth.BatteryArgs[j] = list[index];
				list.RemoveAt(index);
			}
		}

		private void StartNight(double now)
		{
			_auth.Phase = FnPhase.Night;
			_auth.PhaseStart = now;
			_auth.PowerStamp = now;
			_auth.PhaseEnd = now + (double)(_auth.HourSeconds * 6f);
			_auth.NightStart = now;
			_auth.PowerRate = CurrentRate();
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.Phase] = (byte)FnPhase.Night;
			hashtable[FnProps.PhaseStart] = now;
			hashtable[FnProps.PhaseEnd] = _auth.PhaseEnd;
			hashtable[FnProps.NightStart] = now;
			hashtable[FnProps.Power] = _auth.Power;
			hashtable[FnProps.PowerStamp] = now;
			hashtable[FnProps.PowerRate] = _auth.PowerRate;
			Write(hashtable);
			_lastPowerWrite = now;
			_powerDirty = false;
		}

		private void TickNight(double now)
		{
			CacheHeads();
			int num = LivingGuards(_living);
			if (FnClock.Since(_auth.NightStart) >= (double)(_auth.HourSeconds * 6f))
			{
				if (num >= 1)
				{
					EndNight(FnPhase.Dawn, 1);
				}
				else
				{
					EndNight(FnPhase.Lost, 2);
				}
				return;
			}
			if (num == 0)
			{
				EndNight(FnPhase.Lost, 2);
				return;
			}
			for (int i = 0; i < 2; i++)
			{
				byte b = Bit((FnDoorSide)i);
				if ((_auth.Lights & b) != 0 && _lightOffAt[i] <= now)
				{
					_auth.Lights = (byte)(_auth.Lights & ~b);
					ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
					hashtable[FnProps.Lights] = _auth.Lights;
					Write(hashtable);
					SetRate(now);
				}
			}
			if (_auth.Blackout <= 0.0 && _auth.PowerAt(now) <= 0f)
			{
				StartBlackout(now);
			}
			if (_auth.Blackout > 0.0)
			{
				TickBlackout(now);
			}
		}

		private void EndNight(FnPhase phase, byte outcome)
		{
			_auth.Outcome = outcome;
			RebasePower(FnClock.Now);
			_auth.PowerRate = 0f;
			_powerDirty = true;
			float seconds = ((phase == FnPhase.Dawn) ? S.night.dawnSeconds : S.night.lostSeconds);
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.Outcome] = outcome;
			EnterPhase(phase, seconds, hashtable);
			UnityEngine.Debug.Log(string.Format("[FnNight] Night over: {0}.", phase));
		}

		private void EnterPhase(FnPhase phase, float seconds, ExitGames.Client.Photon.Hashtable extra = null)
		{
			double now = FnClock.Now;
			_auth.HasPhase = true;
			_auth.Phase = phase;
			_auth.PhaseStart = now;
			_auth.PhaseEnd = ((seconds > 0f) ? (now + (double)seconds) : 0.0);
			ExitGames.Client.Photon.Hashtable hashtable = extra ?? new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.Phase] = (byte)phase;
			hashtable[FnProps.PhaseStart] = now;
			hashtable[FnProps.PhaseEnd] = _auth.PhaseEnd;
			if (phase == FnPhase.Gathering)
			{
				hashtable[FnProps.Roster] = _auth.Roster;
			}
			Write(hashtable);
		}

		private void CacheHeads()
		{
			Vector3 head;
			for (int i = 0; i < _auth.GuardActors.Length; i++)
			{
				int num = _auth.GuardActors[i];
				if (num > 0 && FnGame.TryGetHead(num, out head))
				{
					_lastHeads[num] = head;
				}
			}
		}

		private void MarkGuard(int slot, FnGuardStatus status, int actor)
		{
			_auth.GuardStatus[slot] = (byte)status;
			if (slot < _auth.GuardTimes.Length)
			{
				_auth.GuardTimes[slot] = FnClock.Now;
			}
			DropCarried(actor);
			WriteGuards(withBatteries: true);
			if (_auth.Phase == FnPhase.Night)
			{
				SetRate(FnClock.Now);
			}
		}

		private void WriteGuards(bool withBatteries)
		{
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.GuardStatus] = _auth.GuardStatus;
			hashtable[FnProps.GuardTimes] = _auth.GuardTimes;
			if (withBatteries)
			{
				AddBatteryKeys(hashtable);
			}
			Write(hashtable);
		}

		private void Write(ExitGames.Client.Photon.Hashtable changed)
		{
			FnProps.WriteRoom(changed);
			Notify();
		}

		private float CurrentRate()
		{
			if (_auth == null || _auth.Phase != FnPhase.Night || _auth.Blackout > 0.0)
			{
				return 0f;
			}
			float[] baseDrainPerNight = S.power.baseDrainPerNight;
			float num = 0.1f;
			if (baseDrainPerNight != null && baseDrainPerNight.Length != 0)
			{
				num = baseDrainPerNight[Mathf.Clamp(_auth.Night - 1, 0, baseDrainPerNight.Length - 1)];
			}
			return Mathf.Max(0f, (num + (float)UsageUnits * S.power.unitDrain) * S.For(_auth.Difficulty).powerDrainMultiplier);
		}

		private void RebasePower(double now)
		{
			_auth.Power = _auth.PowerAt(now);
			_auth.PowerStamp = now;
		}

		private void SetRate(double now)
		{
			if (_auth != null)
			{
				RebasePower(now);
				float num = CurrentRate();
				if (!Mathf.Approximately(num, _auth.PowerRate))
				{
					_auth.PowerRate = num;
					_powerDirty = true;
				}
			}
		}

		private void AddPower(float delta)
		{
			if (_auth != null)
			{
				double now = FnClock.Now;
				RebasePower(now);
				_auth.Power = Mathf.Clamp(_auth.Power + delta, 0f, 100f);
				_powerDirty = true;
				if (_auth.Power <= 0f && _auth.Phase == FnPhase.Night && _auth.Blackout <= 0.0)
				{
					StartBlackout(now);
				}
			}
		}

		private void FlushPower(double now)
		{
			if (_powerDirty && _auth != null && !(now - _lastPowerWrite < (double)S.power.minWriteInterval))
			{
				RebasePower(now);
				_lastPowerWrite = now;
				_powerDirty = false;
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable[FnProps.Power] = _auth.Power;
				hashtable[FnProps.PowerStamp] = _auth.PowerStamp;
				hashtable[FnProps.PowerRate] = _auth.PowerRate;
				Write(hashtable);
			}
		}

		private void StartBlackout(double now)
		{
			_auth.Power = 0f;
			_auth.PowerStamp = now;
			_auth.PowerRate = 0f;
			_auth.Blackout = now;
			_auth.BlackoutEnd = 0.0;
			_auth.Doors = 0;
			_auth.Jams = 0;
			_auth.Lights = 0;
			_blackoutCatchDone = false;
			_powerDirty = false;
			_lastPowerWrite = now;
			_blackoutFallbackAt = now + 25.0;
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.Power] = 0f;
			hashtable[FnProps.PowerStamp] = now;
			hashtable[FnProps.PowerRate] = 0f;
			hashtable[FnProps.Blackout] = now;
			hashtable[FnProps.BlackoutEnd] = 0.0;
			hashtable[FnProps.Doors] = (byte)0;
			hashtable[FnProps.Jams] = (byte)0;
			hashtable[FnProps.Lights] = (byte)0;
			Write(hashtable);
			UnityEngine.Debug.Log("[FnNight] Blackout.");
		}

		private void TickBlackout(double now)
		{
			Vector3 head;
			if (_auth.BlackoutEnd > 0.0)
			{
				if (_blackoutCatchDone || !FnClock.Reached(_auth.BlackoutEnd))
				{
					return;
				}
				_blackoutCatchDone = true;
				FnNet.ToAll(FnRpc.AnimCue, (byte)FnAnim.Bear, (byte)FnCue.MusicBoxStop);
				int num = LivingGuards(_living);
				for (int i = 0; i < num; i++)
				{
					int num2 = _living[i];
					if (office != null && FnGame.TryGetHead(num2, out head) && office.Contains(head, S.office.officeSlack))
					{
						MasterCatch(num2, FnAnim.Bear, FnCatchCause.Blackout);
					}
				}
			}
			else if (_blackoutFallbackAt <= now)
			{
				MasterBeginMusicBox(UnityEngine.Random.Range(S.power.musicBoxSeconds.x, S.power.musicBoxSeconds.y));
			}
		}

		public void MasterBeginMusicBox(float seconds)
		{
			if (IsAuthority && _auth.Blackout > 0.0 && !(_auth.BlackoutEnd > 0.0) && _auth.Phase == FnPhase.Night)
			{
				_auth.BlackoutEnd = FnClock.Now + (double)Mathf.Max(1f, seconds);
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable[FnProps.BlackoutEnd] = _auth.BlackoutEnd;
				Write(hashtable);
				FnNet.ToAll(FnRpc.AnimCue, (byte)FnAnim.Bear, (byte)FnCue.MusicBoxStart);
			}
		}

		public void MasterKnock(FnAnim anim, FnDoorSide side, int raps, bool heavy)
		{
			if (!IsAuthority || _auth.Phase != FnPhase.Night)
			{
				return;
			}
			float num = ((anim == FnAnim.Endo) ? (S.power.endoHitBase + S.power.endoHitStep * (float)_endoHits++) : S.power.bangCost);
			if (num > 0f)
			{
				AddPower(-num);
			}
			raps = Mathf.Clamp(raps, 1, 6);
			FnNet.ToAll(FnRpc.Bang, (byte)anim, (byte)side, heavy ? ((byte)1) : ((byte)0), (byte)raps);
			Transform transform = ((office != null) ? office.Outside(side) : null);
			if (transform != null)
			{
				FnNoiseBus.Raise(FnNoise.Bang, transform.position, S.noise.bangRadius, 0);
			}
		}

		public void MasterSetJam(FnDoorSide side, bool jammed)
		{
			if (IsAuthority)
			{
				byte b = (jammed ? ((byte)(_auth.Jams | Bit(side))) : ((byte)(_auth.Jams & ~Bit(side))));
				if (b != _auth.Jams)
				{
					_auth.Jams = b;
					ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
					hashtable[FnProps.Jams] = b;
					Write(hashtable);
				}
			}
		}

		public bool MasterCatch(int actor, FnAnim anim, FnCatchCause cause)
		{
			if (!IsAuthority || _auth.Phase != FnPhase.Night)
			{
				return false;
			}
			int num = _auth.SlotOfActor(actor);
			if (num < 0 || _auth.StatusOf(num) != FnGuardStatus.Alive)
			{
				return false;
			}
			MarkGuard(num, FnGuardStatus.Caught, actor);
			FnNet.ToAll(FnRpc.Caught, actor, (byte)anim, (byte)cause);
			UnityEngine.Debug.Log(string.Format("[FnNight] {0} caught actor {1} ({2}).", FnStrings.AnimName(anim), actor, cause));
			return true;
		}

		public bool MasterLastHead(int actor, out Vector3 head)
		{
			if (FnGame.TryGetHead(actor, out head))
			{
				return true;
			}
			return _lastHeads.TryGetValue(actor, out head);
		}

		private void DropCarried(int actor)
		{
			for (int i = 0; i < _auth.BatteryStates.Length; i++)
			{
				if (_auth.BatteryStates[i] == 1 && _auth.BatteryArgs[i] == actor)
				{
					MasterLastHead(actor, out var head);
					Vector3 vector = ((batteries != null) ? batteries.FloorBelow(head) : head);
					_auth.BatteryStates[i] = 2;
					_auth.BatteryArgs[i] = -1;
					int num = i * 3;
					if (num + 3 <= _auth.BatteryDrops.Length)
					{
						_auth.BatteryDrops[num] = vector.x;
						_auth.BatteryDrops[num + 1] = vector.y;
						_auth.BatteryDrops[num + 2] = vector.z;
					}
				}
			}
		}

		private void AddBatteryKeys(ExitGames.Client.Photon.Hashtable h)
		{
			h[FnProps.BatteryStates] = _auth.BatteryStates;
			h[FnProps.BatteryArgs] = _auth.BatteryArgs;
			h[FnProps.BatteryDrops] = _auth.BatteryDrops;
		}

		private bool AcceptRequest(PhotonMessageInfo info, FnRpc request, byte subject, out int actor)
		{
			actor = ((info.Sender != null) ? info.Sender.ActorNumber : (-1));
			if (!IsAuthority)
			{
				return false;
			}
			int num = _auth.SlotOfActor(actor);
			if (num < 0 || _auth.StatusOf(num) != FnGuardStatus.Alive)
			{
				return false;
			}
			if (_auth.Phase != FnPhase.Night)
			{
				Reject(actor, request, FnReject.WrongPhase, subject);
				return false;
			}
			return true;
		}

		private bool SenderInOffice(int actor)
		{
			if (office != null && FnGame.TryGetHead(actor, out var head))
			{
				return office.Contains(head, S.office.officeSlack);
			}
			return false;
		}

		private static bool SenderNear(int actor, Vector3 point, float range)
		{
			if (FnGame.TryGetHead(actor, out var head))
			{
				return (head - point).sqrMagnitude <= range * range;
			}
			return false;
		}

		private void Reject(int actor, FnRpc request, FnReject reason, byte subject)
		{
			FnNet.ToActor(actor, FnRpc.Rejected, (byte)request, (byte)reason, subject);
		}

		private void OnDoorToggle(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 1)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (b > 1 || !AcceptRequest(info, FnRpc.DoorToggle, b, out var actor))
			{
				return;
			}
			double now = FnClock.Now;
			FnDoorSide side = (FnDoorSide)b;
			byte b2 = Bit(side);
			FnReject? fnReject = null;
			if (_auth.Blackout > 0.0)
			{
				fnReject = FnReject.Blackout;
			}
			else if (!SenderInOffice(actor))
			{
				fnReject = FnReject.NotInOffice;
			}
			else if (_auth.PowerAt(now) <= 0f)
			{
				fnReject = FnReject.NoPower;
			}
			else if ((_auth.Jams & b2) != 0)
			{
				fnReject = FnReject.Jammed;
			}
			else if (now - _doorToggleAt[b] < (double)S.office.doorToggleCooldown)
			{
				fnReject = FnReject.Cooldown;
			}
			if (fnReject.HasValue)
			{
				Reject(actor, FnRpc.DoorToggle, fnReject.Value, b);
				return;
			}
			_doorToggleAt[b] = now;
			_auth.Doors ^= b2;
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.Doors] = _auth.Doors;
			Write(hashtable);
			SetRate(now);
			if ((_auth.Doors & b2) != 0 && office != null)
			{
				FnDoor fnDoor = office.Door(side);
				if (fnDoor != null)
				{
					FnNoiseBus.Raise(FnNoise.DoorSlam, fnDoor.transform.position, S.noise.doorSlamRadius, actor);
				}
			}
		}

		private void OnLightToggle(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 1)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (b > 1 || !AcceptRequest(info, FnRpc.LightToggle, b, out var actor))
			{
				return;
			}
			double now = FnClock.Now;
			FnReject? fnReject = null;
			if (_auth.Blackout > 0.0)
			{
				fnReject = FnReject.Blackout;
			}
			else if (!SenderInOffice(actor))
			{
				fnReject = FnReject.NotInOffice;
			}
			else if (!(_auth.PowerAt(now) > 0f))
			{
				fnReject = FnReject.NoPower;
			}
			if (fnReject.HasValue)
			{
				Reject(actor, FnRpc.LightToggle, fnReject.Value, b);
				return;
			}
			byte b2 = Bit((FnDoorSide)b);
			_auth.Lights ^= b2;
			if ((_auth.Lights & b2) != 0)
			{
				_lightOffAt[b] = now + (double)S.office.lightAutoOff;
			}
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.Lights] = _auth.Lights;
			Write(hashtable);
			SetRate(now);
		}

		private void OnLure(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 1)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (!AcceptRequest(info, FnRpc.Lure, b, out var actor))
			{
				return;
			}
			double now = FnClock.Now;
			FnReject? fnReject = null;
			if (_auth.Blackout > 0.0)
			{
				fnReject = FnReject.Blackout;
			}
			else if (!SenderInOffice(actor))
			{
				fnReject = FnReject.NotInOffice;
			}
			else if (_auth.PowerAt(now) < S.cameras.lureCost)
			{
				fnReject = FnReject.NoPower;
			}
			else if (_auth.LureReady > 0.0 && FnClock.Since(_auth.LureReady) < 0.0)
			{
				fnReject = FnReject.Cooldown;
			}
			else if (!FnStations.TryGet(b, out var station) || station.AudioOnly)
			{
				fnReject = FnReject.Invalid;
			}
			else if (FnStations.MotionInView(b) > 0.15f)
			{
				fnReject = FnReject.Scrambled;
			}
			if (fnReject.HasValue)
			{
				Reject(actor, FnRpc.Lure, fnReject.Value, b);
				return;
			}
			FnStations.TryGet(b, out var station2);
			AddPower(-S.cameras.lureCost);
			_auth.LureReady = now + (double)S.cameras.lureCooldown;
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.LureReady] = _auth.LureReady;
			Write(hashtable);
			FnNet.ToAll(FnRpc.LurePlayed, b);
			FnNoiseBus.Raise(FnNoise.Lure, station2.Pose.position, S.noise.lureRadius, 0);
		}

		private void OnBreakerPull(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 1)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (b > 5 || !AcceptRequest(info, FnRpc.BreakerPull, b, out var actor))
			{
				return;
			}
			FnReject? fnReject = null;
			if (_auth.Blackout > 0.0)
			{
				fnReject = FnReject.Blackout;
			}
			else if (fuseBox == null || !SenderNear(actor, fuseBox.transform.position, S.tasks.fuseBoxRange))
			{
				fnReject = FnReject.TooFar;
			}
			else if (_auth.FuseUses == 0)
			{
				fnReject = FnReject.Invalid;
			}
			if (fnReject.HasValue)
			{
				Reject(actor, FnRpc.BreakerPull, fnReject.Value, b);
				return;
			}
			float num = 1f;
			FnBreakerResult fnBreakerResult;
			if (((_auth.FuseProgress < _auth.FuseOrder.Length) ? _auth.FuseOrder[_auth.FuseProgress] : 255) == b)
			{
				_auth.FuseProgress++;
				if (_auth.FuseProgress >= 3)
				{
					_auth.FuseProgress = 0;
					_auth.FuseUses--;
					_auth.FuseOrder = RandomFuseOrder();
					AddPower(S.power.fuseGain);
					fnBreakerResult = FnBreakerResult.Complete;
					num = 1.5f;
				}
				else
				{
					fnBreakerResult = FnBreakerResult.Correct;
				}
			}
			else
			{
				fnBreakerResult = FnBreakerResult.Wrong;
				_auth.FuseProgress = 0;
			}
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable[FnProps.FuseProgress] = _auth.FuseProgress;
			hashtable[FnProps.FuseUses] = _auth.FuseUses;
			hashtable[FnProps.FuseOrder] = _auth.FuseOrder;
			Write(hashtable);
			FnNet.ToAll(FnRpc.Breaker, b, (byte)fnBreakerResult);
			FnNoiseBus.Raise(FnNoise.Breaker, fuseBox.transform.position, S.noise.breakerRadius * num, actor);
		}

		private void OnBatteryPick(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 1)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (!AcceptRequest(info, FnRpc.BatteryPick, b, out var actor) || b >= _auth.BatteryStates.Length)
			{
				return;
			}
			FnBatteryState fnBatteryState = (FnBatteryState)_auth.BatteryStates[b];
			if ((fnBatteryState == FnBatteryState.AtSpawn || fnBatteryState == FnBatteryState.Dropped) && BatteryCarriedByAuth(actor) < 0)
			{
				Vector3 vector = BatteryWorldPosition(b);
				if (!SenderNear(actor, vector, S.tasks.batteryPickRange))
				{
					Reject(actor, FnRpc.BatteryPick, FnReject.TooFar, b);
					return;
				}
				_auth.BatteryStates[b] = 1;
				_auth.BatteryArgs[b] = actor;
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				AddBatteryKeys(hashtable);
				Write(hashtable);
				FnNoiseBus.Raise(FnNoise.Pickup, vector, S.noise.pickupRadius, actor);
			}
		}

		private void OnBatteryDeliver(object[] a, PhotonMessageInfo info)
		{
			if (a.Length < 1)
			{
				return;
			}
			byte b = FnNet.B(a[0]);
			if (AcceptRequest(info, FnRpc.BatteryDeliver, b, out var actor) && b < _auth.BatteryStates.Length && _auth.BatteryStates[b] == 1 && _auth.BatteryArgs[b] == actor)
			{
				if (office == null || office.charger == null || !SenderNear(actor, office.charger.position, S.tasks.chargerRange))
				{
					Reject(actor, FnRpc.BatteryDeliver, FnReject.TooFar, b);
					return;
				}
				_auth.BatteryStates[b] = 3;
				_auth.BatteryArgs[b] = -1;
				_auth.BatteriesDelivered++;
				AddPower(S.power.batteryGain);
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable[FnProps.BatteriesDelivered] = _auth.BatteriesDelivered;
				AddBatteryKeys(hashtable);
				Write(hashtable);
			}
		}

		private int BatteryCarriedByAuth(int actor)
		{
			for (int i = 0; i < _auth.BatteryStates.Length; i++)
			{
				if (_auth.BatteryStates[i] == 1 && _auth.BatteryArgs[i] == actor)
				{
					return i;
				}
			}
			return -1;
		}

		public Vector3 BatteryWorldPosition(int battery)
		{
			FnNightState st = St;
			if (battery < 0 || battery >= st.BatteryStates.Length)
			{
				return Vector3.zero;
			}
			if (st.BatteryStates[battery] == 2)
			{
				return BatteryDrop(battery);
			}
			int spawn = ((battery < st.BatteryArgs.Length) ? st.BatteryArgs[battery] : (-1));
			if (batteries != null)
			{
				return batteries.SpawnPosition(spawn);
			}
			return Vector3.zero;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		public bool DoorClosed(FnDoorSide side)
		{
			return ((St.Doors >> (int)side) & 1) != 0;
		}

		public bool DoorJammed(FnDoorSide side)
		{
			return ((St.Jams >> (int)side) & 1) != 0;
		}

		public bool LightOn(FnDoorSide side)
		{
			return ((St.Lights >> (int)side) & 1) != 0;
		}

		public FnBatteryState BatteryState(int i)
		{
			if (i >= 0 && i < St.BatteryStates.Length)
			{
				return (FnBatteryState)St.BatteryStates[i];
			}
			return FnBatteryState.Delivered;
		}

		public int BatteryArg(int i)
		{
			if (i >= 0 && i < St.BatteryArgs.Length)
			{
				return St.BatteryArgs[i];
			}
			return -1;
		}

		public Vector3 BatteryDrop(int i)
		{
			FnNightState st = St;
			if (i < 0 || i * 3 + 3 > st.BatteryDrops.Length)
			{
				return Vector3.zero;
			}
			int num = i * 3;
			return new Vector3(st.BatteryDrops[num], st.BatteryDrops[num + 1], st.BatteryDrops[num + 2]);
		}

		public int BatteryCarriedBy(int actor)
		{
			FnNightState st = St;
			for (int i = 0; i < st.BatteryStates.Length; i++)
			{
				if (st.BatteryStates[i] == 1 && i < st.BatteryArgs.Length && st.BatteryArgs[i] == actor)
				{
					return i;
				}
			}
			return -1;
		}

		public int GuardActor(int slot)
		{
			if (slot >= 0 && slot < St.GuardActors.Length)
			{
				return St.GuardActors[slot];
			}
			return 0;
		}

		public FnGuardStatus GuardStatus(int slot)
		{
			return St.StatusOf(slot);
		}

		public string GuardName(int slot)
		{
			if (slot >= 0 && slot < St.GuardNames.Length)
			{
				return St.GuardNames[slot];
			}
			return "";
		}

		public string GuardBuild(int slot)
		{
			if (slot >= 0 && slot < St.GuardBuilds.Length)
			{
				return St.GuardBuilds[slot];
			}
			return "";
		}

		public double GuardTime(int slot)
		{
			if (slot >= 0 && slot < St.GuardTimes.Length)
			{
				return St.GuardTimes[slot];
			}
			return 0.0;
		}

		public int SlotOfActor(int actor)
		{
			return St.SlotOfActor(actor);
		}

		public int SlotOfUser(string userId)
		{
			return St.SlotOfUser(userId);
		}

		public bool IsAliveGuard(int actor)
		{
			int num = St.SlotOfActor(actor);
			if (num >= 0)
			{
				return St.StatusOf(num) == FnGuardStatus.Alive;
			}
			return false;
		}

		public bool IsGhost(int actor)
		{
			int num = St.SlotOfActor(actor);
			if (num >= 0)
			{
				return St.StatusOf(num) == FnGuardStatus.Caught;
			}
			return false;
		}

		public int LivingGuards(int[] into)
		{
			FnNightState st = St;
			int num = 0;
			for (int i = 0; i < st.GuardStatus.Length && i < st.GuardActors.Length; i++)
			{
				if (st.GuardStatus[i] == 0 && st.GuardActors[i] > 0)
				{
					if (into != null && num < into.Length)
					{
						into[num] = st.GuardActors[i];
					}
					num++;
				}
			}
			return num;
		}

		public static byte Bit(FnDoorSide side)
		{
			return (byte)(1 << (int)side);
		}

		private void Awake()
		{
			Instance = this;
		}

		public override void OnEnable()
		{
			base.OnEnable();
			FnNet.On(FnRpc.DoorToggle, OnDoorToggle);
			FnNet.On(FnRpc.LightToggle, OnLightToggle);
			FnNet.On(FnRpc.BreakerPull, OnBreakerPull);
			FnNet.On(FnRpc.BatteryPick, OnBatteryPick);
			FnNet.On(FnRpc.BatteryDeliver, OnBatteryDeliver);
			FnNet.On(FnRpc.Lure, OnLure);
			FnNet.On(FnRpc.Bang, OnBang);
			FnNet.On(FnRpc.Spotted, OnSpotted);
			FnNet.On(FnRpc.Caught, OnCaught);
			FnNet.On(FnRpc.Breaker, OnBreaker);
			FnNet.On(FnRpc.LurePlayed, OnLurePlayed);
			FnNet.On(FnRpc.Rejected, OnRejected);
			FnNet.On(FnRpc.ReturnToHub, OnReturnToHub);
			ReadAll();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			FnNet.Off(FnRpc.DoorToggle, OnDoorToggle);
			FnNet.Off(FnRpc.LightToggle, OnLightToggle);
			FnNet.Off(FnRpc.BreakerPull, OnBreakerPull);
			FnNet.Off(FnRpc.BatteryPick, OnBatteryPick);
			FnNet.Off(FnRpc.BatteryDeliver, OnBatteryDeliver);
			FnNet.Off(FnRpc.Lure, OnLure);
			FnNet.Off(FnRpc.Bang, OnBang);
			FnNet.Off(FnRpc.Spotted, OnSpotted);
			FnNet.Off(FnRpc.Caught, OnCaught);
			FnNet.Off(FnRpc.Breaker, OnBreaker);
			FnNet.Off(FnRpc.LurePlayed, OnLurePlayed);
			FnNet.Off(FnRpc.Rejected, OnRejected);
			FnNet.Off(FnRpc.ReturnToHub, OnReturnToHub);
			_auth = null;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public override void OnJoinedRoom()
		{
			_auth = null;
			_raisedAnyPhase = false;
			ReadAll();
		}

		public override void OnLeftRoom()
		{
			_auth = null;
			_raisedAnyPhase = false;
			ResetView();
		}

		public override void OnRoomPropertiesUpdate(ExitGames.Client.Photon.Hashtable changed)
		{
			_view.Read(changed);
			Notify();
		}

		private void ReadAll()
		{
			ResetView();
			ExitGames.Client.Photon.Hashtable roomProps = FnProps.RoomProps;
			if (roomProps != null && FnProps.CurrentRoomKind() == FnRoomKind.Night)
			{
				_view.Read(roomProps);
			}
			Notify();
		}

		private void ResetView()
		{
			CopyInto(new FnNightState(), _view);
		}

		private static void CopyInto(FnNightState from, FnNightState to)
		{
			if (from != null && to != null)
			{
				to.HasPhase = from.HasPhase;
				to.Phase = from.Phase;
				to.PhaseStart = from.PhaseStart;
				to.PhaseEnd = from.PhaseEnd;
				to.NightStart = from.NightStart;
				to.HourSeconds = from.HourSeconds;
				to.Night = from.Night;
				to.Difficulty = from.Difficulty;
				to.TeamSize = from.TeamSize;
				to.Arrived = from.Arrived;
				to.Roster = from.Roster;
				to.GuardActors = from.GuardActors;
				to.GuardNames = from.GuardNames;
				to.GuardBuilds = from.GuardBuilds;
				to.GuardStatus = from.GuardStatus;
				to.GuardTimes = from.GuardTimes;
				to.Power = from.Power;
				to.PowerStamp = from.PowerStamp;
				to.PowerRate = from.PowerRate;
				to.Blackout = from.Blackout;
				to.BlackoutEnd = from.BlackoutEnd;
				to.Doors = from.Doors;
				to.Jams = from.Jams;
				to.Lights = from.Lights;
				to.LureReady = from.LureReady;
				to.FuseUses = from.FuseUses;
				to.FuseOrder = from.FuseOrder;
				to.FuseProgress = from.FuseProgress;
				to.BatteryStates = from.BatteryStates;
				to.BatteryArgs = from.BatteryArgs;
				to.BatteryDrops = from.BatteryDrops;
				to.BatteriesDelivered = from.BatteriesDelivered;
				to.Outcome = from.Outcome;
			}
		}

		private void Notify()
		{
			FnNightState st = St;
			if (st.HasPhase && (!_raisedAnyPhase || st.Phase != _lastRaisedPhase))
			{
				_lastRaisedPhase = st.Phase;
				_raisedAnyPhase = true;
				OnLocalPhase(st.Phase);
				this.PhaseChanged?.Invoke(st.Phase);
			}
			this.Changed?.Invoke();
		}

		public void RequestDoor(FnDoorSide side)
		{
			FnNet.ToMasterClient(FnRpc.DoorToggle, (byte)side);
		}

		public void RequestLight(FnDoorSide side)
		{
			FnNet.ToMasterClient(FnRpc.LightToggle, (byte)side);
		}

		public void RequestBreaker(int breaker)
		{
			FnNet.ToMasterClient(FnRpc.BreakerPull, (byte)breaker);
		}

		public void RequestPickBattery(int battery)
		{
			FnNet.ToMasterClient(FnRpc.BatteryPick, (byte)battery);
		}

		public void RequestDeliverBattery(int battery)
		{
			FnNet.ToMasterClient(FnRpc.BatteryDeliver, (byte)battery);
		}

		public void RequestLure(int camera)
		{
			FnNet.ToMasterClient(FnRpc.Lure, (byte)camera);
		}

		private void OnBang(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info) && a.Length >= 3)
			{
				int arg = ((a.Length > 3) ? Mathf.Clamp(FnNet.B(a[3]), 1, 6) : 1);
				this.Knocked?.Invoke((FnAnim)FnNet.B(a[0]), (FnDoorSide)FnNet.B(a[1]), arg, FnNet.B(a[2]) != 0);
			}
		}

		private void OnSpotted(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info) && a.Length >= 2)
			{
				this.Spotted?.Invoke((FnAnim)FnNet.B(a[0]), FnNet.I(a[1]));
			}
		}

		private void OnCaught(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info) && a.Length >= 3)
			{
				this.Caught?.Invoke(FnNet.I(a[0]), (FnAnim)FnNet.B(a[1]), (FnCatchCause)FnNet.B(a[2]));
			}
		}

		private void OnBreaker(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info) && a.Length >= 2)
			{
				this.BreakerResult?.Invoke(FnNet.B(a[0]), (FnBreakerResult)FnNet.B(a[1]));
			}
		}

		private void OnLurePlayed(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info) && a.Length >= 1)
			{
				this.LurePlayed?.Invoke(FnNet.B(a[0]));
			}
		}

		private void OnRejected(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info) && a.Length >= 3)
			{
				this.Rejected?.Invoke((FnRpc)FnNet.B(a[0]), (FnReject)FnNet.B(a[1]), FnNet.B(a[2]));
			}
		}

		private void OnReturnToHub(object[] a, PhotonMessageInfo info)
		{
			if (FromMaster(info))
			{
				this.ReturnToHubRequested?.Invoke();
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

		private void Update()
		{
			if (InNightRoom)
			{
				if (PhotonNetwork.IsMasterClient)
				{
					MasterTick();
				}
				else if (_auth != null)
				{
					_auth = null;
				}
				LocalTick();
			}
		}
	}
}
