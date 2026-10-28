using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class ApeGamesManager : MonoBehaviourPunCallbacks, IOnEventCallback
	{
		private enum AgRpc : byte
		{
			RoundStarted = 1,
			RoundEnded = 2,
			MatchEnded = 3,
			EliminatePlayer = 4,
			ReportRunner = 5,
			ReachFinish = 7,
			BreakPanel = 8,
			CrankGenerator = 9,
			EscapeHider = 10,
			HammerHit = 11,
			RequestRevive = 12,
			ReviveQueued = 13
		}

		private const byte AgRpcEventCode = 174;

		private static readonly RaiseEventOptions AgRpcToOthers = new RaiseEventOptions { Receivers = ReceiverGroup.Others };

		private static readonly RaiseEventOptions AgRpcToMaster = new RaiseEventOptions { Receivers = ReceiverGroup.MasterClient };

		private double _authStamp = -1.0;

		private readonly HashSet<int> _aliveAuth = new HashSet<int>();

		private readonly HashSet<int> _elimAuth = new HashSet<int>();

		private readonly HashSet<int> _escAuth = new HashSet<int>();

		private readonly HashSet<int> _seekerAuth = new HashSet<int>();

		private readonly HashSet<int> _towerAuth = new HashSet<int>();

		private readonly HashSet<int> _reviveUsedAuth = new HashSet<int>();

		private readonly HashSet<int> _reviveQueueAuth = new HashSet<int>();

		private int _crankMask;

		private readonly float[] _crankCharge = new float[32];

		private readonly Dictionary<long, double> _crankContribTimes = new Dictionary<long, double>();

		private int _catchCount;

		private byte _lightAuth;

		private double _lightStampAuth;

		private double _greenEndAuth;

		private bool _isStartingRound;

		private bool _isEndingRound;

		private float _roundCompleteSince = -1f;

		private float _matchEmptySince = -1f;

		private readonly List<int> _masterScratch = new List<int>();

		private const float TestLobbyWaitSeconds = 5f;

		private bool _testModeArmed;

		private byte _testHideSeekRole;

		private bool _testHadSeekers;

		private bool _testHadHiders;

		private const float CrankDegreesPerPoint = 28f;

		private const float CrankMaxDegreesPerReport = 400f;

		private const float CrankSynergyWindow = 1.25f;

		private const float CrankSynergyPerExtra = 0.35f;

		private const float CrankMaxSynergy = 2.05f;

		private const double CrankMasterPace = 0.25;

		private double _panelsStamp = -1.0;

		private readonly HashSet<int> _appliedPanels = new HashSet<int>();

		public const string GameQueue = "ApeGames";

		public const int FinalRoundIndex = 4;

		private const float spawnFadeOutDuration = 0.55f;

		private const float spawnBlackHoldDuration = 0.3f;

		private const float spawnFadeInDuration = 0.65f;

		[Header("Configuration")]
		public AgSettings settings = new AgSettings();

		[Header("Rounds (index == round index)")]
		public AgRoundBase[] rounds = new AgRoundBase[5];

		private AgRoundProperties _props = new AgRoundProperties();

		private bool _localEliminationApplied;

		private float _localEliminationTime;

		private int[] _prevAlive = Array.Empty<int>();

		private int[] _prevEscaped = Array.Empty<int>();

		private double _prevMatchStamp;

		private double _appliedPhaseStamp = -1.0;

		private double _roundStartedEventStamp = -1.0;

		private double _roundEndedMatchStamp = -1.0;

		private int _roundEndedRound = -1;

		private double _matchEndedEventStamp = -1.0;

		private const float ElimRetryInterval = 2f;

		private const float ElimRetryWindow = 30f;

		private bool _elimRetryActive;

		private double _elimRetryMatchStamp;

		private float _elimRetryNextSend;

		private float _elimRetryDeadline;

		private byte _elimRetryCause;

		private int _elimRetryByActor;

		private int _activeRound = -1;

		private Coroutine _deferredRefresh;

		private AgRagdollSpawner _ragdolls;

		private static readonly int[] CountdownThresholds = new int[] { 60, 30, 10 };

		private double _countdownStamp = -1.0;

		private double _countdownPrevRemaining;

		private int _countdownMask;

		private float _lastSelfElimTime;

		private float _lastRunnerReportTime;

		private float _lastFinishRequestTime;

		private float _lastEscapeRequestTime;

		private float _lastReviveRequestTime;

		private readonly HashSet<int> _sentPanels = new HashSet<int>();

		private readonly Dictionary<int, float> _lastHammerReport = new Dictionary<int, float>();

		private readonly Dictionary<int, float> _lastCatchReport = new Dictionary<int, float>();

		private bool MatchIsEmpty
		{
			get
			{
				if (_aliveAuth.Count == 0)
				{
					return _reviveQueueAuth.Count == 0;
				}
				return false;
			}
		}

		public bool TestModeArmed => _testModeArmed;

		public byte TestHideSeekRole => _testHideSeekRole;

		public static ApeGamesManager Instance { get; private set; }

		public AgRoundProperties Props => _props;

		public AgCause LastLocalEliminationCause { get; private set; }

		public int EnabledRoundCount
		{
			get
			{
				if (settings != null && settings.skipHideSeek)
				{
					return 4;
				}
				return 5;
			}
		}

		public double RoundElapsed
		{
			get
			{
				if (_props.phase != AgPhase.Round)
				{
					return 0.0;
				}
				return PhotonNetwork.Time - _props.startTime;
			}
		}

		public double RoundRemaining
		{
			get
			{
				if (_props.phase != AgPhase.Round)
				{
					return 0.0;
				}
				return AgProps.GetRemaining(_props);
			}
		}

		public event Action<int, AgRoundProperties> OnRoundStartedEvent;

		public event Action<int, AgRoundProperties> OnRoundEndedEvent;

		public event Action<int[]> OnMatchEnded;

		public event Action OnLocalEliminated;

		public event Action<AgRoundProperties> OnPropsChanged;

		public event Action<int> OnCountdown;

		public event Action<int, int> OnPanelBroken;

		public event Action<int, Vector3> OnHammerHit;

		public event Action<int> OnReviveQueued;

		public event Action OnLocalEscaped;

		private void SendAgRpc(AgRpc id, RpcTarget target, params object[] args)
		{
			if (args == null)
			{
				args = Array.Empty<object>();
			}
			object[] payload = new object[args.Length + 1];
			payload[0] = (byte)id;
			Array.Copy(args, 0, payload, 1, args.Length);
			switch (target)
			{
			case RpcTarget.All:
			case RpcTarget.AllViaServer:
				DispatchAgRpc(id, args, PhotonNetwork.LocalPlayer);
				if (PhotonNetwork.InRoom)
				{
					PhotonNetwork.RaiseEvent(AgRpcEventCode, payload, AgRpcToOthers, SendOptions.SendReliable);
				}
				break;
			case RpcTarget.MasterClient:
				if (PhotonNetwork.IsMasterClient)
				{
					DispatchAgRpc(id, args, PhotonNetwork.LocalPlayer);
				}
				else if (PhotonNetwork.InRoom)
				{
					PhotonNetwork.RaiseEvent(AgRpcEventCode, payload, AgRpcToMaster, SendOptions.SendReliable);
				}
				break;
			default:
				UnityEngine.Debug.LogError(string.Format("[ApeGames] SendAgRpc: unsupported RpcTarget {0} for {1}, dropped.", target, id));
				break;
			}
		}

		void IOnEventCallback.OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code != AgRpcEventCode || !(photonEvent.CustomData is object[] data) || data.Length < 1)
			{
				return;
			}
			byte id = Convert.ToByte(data[0]);
			object[] a = new object[data.Length - 1];
			Array.Copy(data, 1, a, 0, a.Length);
			if (PhotonNetwork.CurrentRoom != null)
			{
				Player sender = PhotonNetwork.CurrentRoom.GetPlayer(photonEvent.Sender);
				if (sender != null)
				{
					DispatchAgRpc((AgRpc)id, a, sender);
				}
			}
		}

		private void DispatchAgRpc(AgRpc id, object[] a, Player sender)
		{
			PhotonMessageInfo info = new PhotonMessageInfo(sender, PhotonNetwork.ServerTimestamp, base.photonView);
			switch (id)
			{
			case AgRpc.RoundStarted:
				RPC_RoundStarted(Convert.ToByte(a[0]), (int[])a[1], (int[])a[2], Convert.ToInt32(a[3]), Convert.ToInt32(a[4]));
				break;
			case AgRpc.RoundEnded:
				RPC_RoundEnded(Convert.ToByte(a[0]), (int[])a[1], Convert.ToByte(a[2]));
				break;
			case AgRpc.MatchEnded:
				RPC_MatchEnded((int[])a[0]);
				break;
			case AgRpc.EliminatePlayer:
				RPC_EliminatePlayer(Convert.ToInt32(a[0]), Convert.ToByte(a[1]), Convert.ToInt32(a[2]), info);
				break;
			case AgRpc.ReportRunner:
				RPC_ReportRunner(Convert.ToInt32(a[0]), info);
				break;
			case AgRpc.ReachFinish:
				RPC_ReachFinish(Convert.ToInt32(a[0]), info);
				break;
			case AgRpc.BreakPanel:
				RPC_BreakPanel(Convert.ToInt32(a[0]), Convert.ToInt32(a[1]), info);
				break;
			case AgRpc.CrankGenerator:
				RPC_CrankGenerator(Convert.ToInt32(a[0]), Convert.ToSingle(a[1]), info);
				break;
			case AgRpc.EscapeHider:
				RPC_EscapeHider(Convert.ToInt32(a[0]), info);
				break;
			case AgRpc.HammerHit:
				RPC_HammerHit(Convert.ToInt32(a[0]), Convert.ToSingle(a[1]), Convert.ToSingle(a[2]), Convert.ToSingle(a[3]), info);
				break;
			case AgRpc.RequestRevive:
				RPC_RequestRevive(Convert.ToInt32(a[0]), info);
				break;
			case AgRpc.ReviveQueued:
				RPC_ReviveQueued(Convert.ToInt32(a[0]));
				break;
			}
		}

		private bool EmptyHoldElapsed()
		{
			if (!MatchIsEmpty)
			{
				_matchEmptySince = -1f;
				return false;
			}
			if (_matchEmptySince < 0f)
			{
				_matchEmptySince = Time.time;
			}
			return Time.time - _matchEmptySince >= settings.emptyMatchHoldSeconds;
		}

		private void SeedAuthIfNeeded(AgRoundProperties p)
		{
			if (_authStamp != p.startTime)
			{
				SeedAuthFrom(p);
			}
		}

		private void SeedAuthFrom(AgRoundProperties p)
		{
			_authStamp = p.startTime;
			RebuildSet(_aliveAuth, p.alive);
			RebuildSet(_elimAuth, p.eliminated);
			RebuildSet(_escAuth, p.escaped);
			RebuildSet(_seekerAuth, p.seekers);
			RebuildSet(_towerAuth, p.towerA);
			RebuildSet(_reviveUsedAuth, p.revivesUsed);
			RebuildSet(_reviveQueueAuth, p.reviveQueue);
			_crankMask = p.poweredGenerators;
			for (int i = 0; i < _crankCharge.Length; i++)
			{
				_crankCharge[i] = ((p.generatorProgress != null && i < p.generatorProgress.Length) ? ((float)p.generatorProgress[i]) : 0f);
			}
			_crankContribTimes.Clear();
			_catchCount = p.catchCount;
			_lightAuth = p.lightState;
			_lightStampAuth = p.lightStamp;
			_greenEndAuth = 0.0;
		}

		private static void RebuildSet(HashSet<int> set, int[] src)
		{
			set.Clear();
			if (src != null)
			{
				for (int i = 0; i < src.Length; i++)
				{
					set.Add(src[i]);
				}
			}
		}

		private static int[] ToArray(HashSet<int> set)
		{
			int[] array = new int[set.Count];
			set.CopyTo(array, 0, set.Count);
			return array;
		}

		private void MasterUpdate()
		{
			if (!PhotonNetwork.IsMasterClient || !PhotonNetwork.IsConnectedAndReady)
			{
				return;
			}
			AgRoundProperties p = _props;
			switch (p.phase)
			{
			case AgPhase.Idle:
				if (PhotonNetwork.CurrentRoom.PlayerCount >= settings.minPlayers)
				{
					EnterLobbyWait();
				}
				break;
			case AgPhase.LobbyWait:
				if (!_testModeArmed && PhotonNetwork.CurrentRoom.PlayerCount < settings.minPlayers)
				{
					EnterIdle();
				}
				else if (PhotonNetwork.Time >= p.endTime && !_isStartingRound)
				{
					MasterStartRound(0);
				}
				break;
			case AgPhase.Round:
			{
				if (_isStartingRound || _isEndingRound)
				{
					break;
				}
				SeedAuthIfNeeded(p);
				bool matchIsEmpty = MatchIsEmpty;
				if (matchIsEmpty && EmptyHoldElapsed())
				{
					MasterEndRound(p.round, AgCause.Generic);
					break;
				}
				int round = p.round;
				if (round == 0)
				{
					MasterTickRedLight();
				}
				if (p.endTime != 0.0 && PhotonNetwork.Time >= p.endTime)
				{
					MasterEndRound(round, AgCause.TimeUp);
				}
				else
				{
					if (matchIsEmpty)
					{
						break;
					}
					if (MasterRoundComplete(round))
					{
						if (_roundCompleteSince < 0f)
						{
							_roundCompleteSince = Time.time;
						}
						if (Time.time - _roundCompleteSince >= settings.resultsHoldSeconds)
						{
							MasterEndRound(round, AgCause.Generic);
						}
					}
					else
					{
						_roundCompleteSince = -1f;
						if (round >= 0 && rounds != null && round < rounds.Length && rounds[round] != null && rounds[round].MasterWantsEarlyEnd(p))
						{
							MasterEndRound(round, AgCause.Generic);
						}
					}
				}
				break;
			}
			case AgPhase.Intermission:
				if (_isStartingRound)
				{
					break;
				}
				SeedAuthIfNeeded(p);
				if (MatchIsEmpty || (!_testModeArmed && _aliveAuth.Count + _reviveQueueAuth.Count <= 1))
				{
					if (_matchEmptySince < 0f)
					{
						_matchEmptySince = Time.time;
					}
					if (Time.time - _matchEmptySince >= settings.emptyMatchHoldSeconds)
					{
						MasterMatchEnd(Math.Max(p.round - 1, 0));
						break;
					}
				}
				else
				{
					_matchEmptySince = -1f;
				}
				if (PhotonNetwork.Time >= p.endTime)
				{
					int next = p.round;
					if (settings != null && next == 3 && settings.skipHideSeek)
					{
						next = 4;
					}
					MasterStartRound(next);
				}
				break;
			case AgPhase.MatchEnd:
				if (PhotonNetwork.Time >= p.endTime)
				{
					EnterIdle();
				}
				break;
			}
		}

		private bool MasterRoundComplete(int r)
		{
			if (!_testModeArmed && _aliveAuth.Count < 2)
			{
				return true;
			}
			if (r <= 2)
			{
				foreach (int item in _aliveAuth)
				{
					if (!_escAuth.Contains(item))
					{
						return false;
					}
				}
				return true;
			}
			if (r == 3)
			{
				if (_seekerAuth.Count == 0 && (!_testModeArmed || _testHadSeekers))
				{
					return true;
				}
				bool anyHider = false;
				foreach (int item2 in _aliveAuth)
				{
					if (!_seekerAuth.Contains(item2))
					{
						if (!_escAuth.Contains(item2))
						{
							return false;
						}
						anyHider = true;
					}
				}
				if (!anyHider && _testModeArmed && !_testHadHiders)
				{
					return false;
				}
				return true;
			}
			return false;
		}

		private void EnterLobbyWait(float waitSecondsOverride = -1f)
		{
			AgRoundProperties p = new AgRoundProperties
			{
				queue = GameQueue,
				phase = AgPhase.LobbyWait,
				round = 0,
				matchStamp = PhotonNetwork.Time
			};
			float wait = ((waitSecondsOverride >= 0f) ? waitSecondsOverride : settings.lobbyWaitSeconds);
			_props = p;
			_matchEmptySince = -1f;
			AgProps.WritePhase(p, wait);
			SeedAuthFrom(p);
			Log(string.Format("Lobby wait armed, round 1 in {0:0}s", wait));
		}

		private void EnterIdle()
		{
			AgRoundProperties p = new AgRoundProperties
			{
				queue = GameQueue,
				phase = AgPhase.Idle,
				round = 0,
				matchStamp = 0.0
			};
			_props = p;
			AgProps.WritePhase(p, 0.0);
			SeedAuthFrom(p);
			_isStartingRound = false;
			_isEndingRound = false;
			_roundCompleteSince = -1f;
			_matchEmptySince = -1f;
			DisarmTest("returned to Idle");
		}

		private void MasterStartRound(int r)
		{
			if (!PhotonNetwork.IsMasterClient || !PhotonNetwork.IsConnectedAndReady || _props.queue != GameQueue)
			{
				return;
			}
			if (r < 0 || rounds == null || r >= rounds.Length)
			{
				Log(string.Format("StartRound({0}): no such round.", r), true);
			}
			else
			{
				if (_isStartingRound)
				{
					return;
				}
				_isStartingRound = true;
				_roundCompleteSince = -1f;
				_matchEmptySince = -1f;
				SeedAuthIfNeeded(_props);
				if (r == 0)
				{
					if (!_testModeArmed && PhotonNetwork.CurrentRoom.PlayerCount < settings.minPlayers)
					{
						_isStartingRound = false;
						EnterIdle();
						return;
					}
					_aliveAuth.Clear();
					foreach (KeyValuePair<int, Player> player in PhotonNetwork.CurrentRoom.Players)
					{
						_aliveAuth.Add(player.Value.ActorNumber);
					}
					_elimAuth.Clear();
					_reviveUsedAuth.Clear();
				}
				else
				{
					foreach (int item in _reviveQueueAuth)
					{
						if (PhotonNetwork.CurrentRoom.GetPlayer(item) != null)
						{
							_elimAuth.Remove(item);
							_aliveAuth.Add(item);
						}
					}
				}
				_reviveQueueAuth.Clear();
				_escAuth.Clear();
				_seekerAuth.Clear();
				_towerAuth.Clear();
				_crankMask = 0;
				Array.Clear(_crankCharge, 0, _crankCharge.Length);
				_crankContribTimes.Clear();
				_catchCount = 0;
				int seed = UnityEngine.Random.Range(1, int.MaxValue);
				int glassMask = 0;
				if (r == 2)
				{
					for (int i = 0; i < settings.glass.rows; i++)
					{
						if (UnityEngine.Random.value < 0.5f)
						{
							glassMask |= 1 << i;
						}
					}
				}
				List<int> list = new List<int>(_aliveAuth);
				for (int num = list.Count - 1; num > 0; num--)
				{
					int index = UnityEngine.Random.Range(0, num + 1);
					(list[num], list[index]) = (list[index], list[num]);
				}
				if (r == 3)
				{
					byte role = 0;
					if (_testModeArmed)
					{
						role = _testHideSeekRole;
						if (role != 0 && PhotonNetwork.LocalPlayer != null)
						{
							int idx = list.IndexOf(PhotonNetwork.LocalPlayer.ActorNumber);
							if (idx >= 0)
							{
								int me = list[idx];
								list.RemoveAt(idx);
								if (role == 1)
								{
									list.Insert(0, me);
								}
								else
								{
									list.Add(me);
								}
							}
						}
					}
					int seekerCount = Mathf.Clamp(list.Count / Mathf.Max(1, settings.hideSeek.playersPerSeeker), 1, Mathf.Max(1, list.Count - 1));
					if (role == 2)
					{
						seekerCount = Mathf.Min(seekerCount, list.Count - 1);
					}
					for (int j = 0; j < seekerCount && j < list.Count; j++)
					{
						_seekerAuth.Add(list[j]);
					}
					_testHadSeekers = _seekerAuth.Count > 0;
					_testHadHiders = _aliveAuth.Count > _seekerAuth.Count;
				}
				else if (r == 4)
				{
					int half = list.Count / 2;
					for (int k = 0; k < half; k++)
					{
						_towerAuth.Add(list[k]);
					}
				}
				AgRoundProperties p = new AgRoundProperties
				{
					queue = GameQueue,
					phase = AgPhase.Round,
					round = r,
					matchStamp = _props.matchStamp,
					alive = ToArray(_aliveAuth),
					eliminated = ToArray(_elimAuth),
					escaped = Array.Empty<int>(),
					seekers = ToArray(_seekerAuth),
					towerA = ToArray(_towerAuth),
					revivesUsed = ToArray(_reviveUsedAuth),
					reviveQueue = Array.Empty<int>(),
					glassMask = glassMask,
					roundSeed = seed,
					poweredGenerators = 0,
					generatorProgress = Array.Empty<int>(),
					catchCount = 0,
					lightState = 0,
					lightStamp = PhotonNetwork.Time,
					chaseActor = 0
				};
				double duration = ((r == 4) ? 0.0 : ((double)settings.roundSeconds));
				_props = p;
				AgProps.WritePhase(p, duration);
				SeedAuthFrom(p);
				int[] special = ((r == 3) ? p.seekers : ((r == 4) ? p.towerA : Array.Empty<int>()));
				SendAgRpc(AgRpc.RoundStarted, RpcTarget.All, (byte)r, p.alive, special, seed, glassMask);
				_isStartingRound = false;
				Log(string.Format("Round {0} started, {1} alive", r, p.alive.Length) + ((r == 3) ? string.Format(", {0} seeker(s)", p.seekers.Length) : ""));
			}
		}

		private void MasterEndRound(int r, AgCause reason)
		{
			if (!PhotonNetwork.IsMasterClient || !PhotonNetwork.IsConnectedAndReady || _props.queue != GameQueue || _props.phase != AgPhase.Round || _isEndingRound)
			{
				return;
			}
			_isEndingRound = true;
			SeedAuthIfNeeded(_props);
			if (reason == AgCause.TimeUp)
			{
				_masterScratch.Clear();
				foreach (int item in _aliveAuth)
				{
					if (!_escAuth.Contains(item) && (r != 3 || !_seekerAuth.Contains(item)))
					{
						_masterScratch.Add(item);
					}
				}
				for (int i = 0; i < _masterScratch.Count; i++)
				{
					_aliveAuth.Remove(_masterScratch[i]);
					_elimAuth.Add(_masterScratch[i]);
				}
			}
			if (r == 3 && _catchCount == 0 && _seekerAuth.Count > 0)
			{
				if (_testModeArmed && _seekerAuth.Count >= _aliveAuth.Count)
				{
					TestLog("seekers caught no one, but eliminating them would empty the armed match, rule skipped");
				}
				else
				{
					_masterScratch.Clear();
					foreach (int item2 in _seekerAuth)
					{
						_masterScratch.Add(item2);
					}
					for (int j = 0; j < _masterScratch.Count; j++)
					{
						if (_aliveAuth.Remove(_masterScratch[j]))
						{
							_elimAuth.Add(_masterScratch[j]);
						}
					}
				}
			}
			int[] survivors = ToArray(_aliveAuth);
			if (r == 4 || MatchIsEmpty || (!_testModeArmed && _aliveAuth.Count + _reviveQueueAuth.Count <= 1))
			{
				AgRoundProperties p = (_props = ComposePhaseProps(AgPhase.MatchEnd, r));
				AgProps.WritePhase(p, settings.matchEndSeconds);
				SeedAuthFrom(p);
				SendAgRpc(AgRpc.RoundEnded, RpcTarget.All, (byte)r, survivors, (byte)reason);
				SendAgRpc(AgRpc.MatchEnded, RpcTarget.All, p.alive);
				Log(string.Format("Round {0} ended ({1}) → MATCH END, {2} winner(s)", r, reason, p.alive.Length));
				DisarmTest("match ended");
			}
			else
			{
				AgRoundProperties p2 = (_props = ComposePhaseProps(AgPhase.Intermission, r + 1));
				AgProps.WritePhase(p2, settings.intermissionSeconds);
				SeedAuthFrom(p2);
				SendAgRpc(AgRpc.RoundEnded, RpcTarget.All, (byte)r, survivors, (byte)reason);
				Log(string.Format("Round {0} ended ({1}) → intermission, {2} alive", r, reason, survivors.Length));
			}
			_isEndingRound = false;
		}

		private void MasterMatchEnd(int endedRound)
		{
			if (!PhotonNetwork.IsMasterClient || !PhotonNetwork.IsConnectedAndReady)
			{
				return;
			}
			SeedAuthIfNeeded(_props);
			AgRoundProperties p = ComposePhaseProps(AgPhase.MatchEnd, endedRound);
			_props = p;
			AgProps.WritePhase(p, settings.matchEndSeconds);
			SeedAuthFrom(p);
			SendAgRpc(AgRpc.MatchEnded, RpcTarget.All, new object[] { p.alive });
			Log(string.Format("Match ended early, {0} winner(s)", p.alive.Length));
			DisarmTest("match ended");
		}

		private AgRoundProperties ComposePhaseProps(AgPhase phase, int round)
		{
			return new AgRoundProperties
			{
				queue = GameQueue,
				phase = phase,
				round = round,
				matchStamp = _props.matchStamp,
				alive = ToArray(_aliveAuth),
				eliminated = ToArray(_elimAuth),
				escaped = ToArray(_escAuth),
				seekers = Array.Empty<int>(),
				towerA = Array.Empty<int>(),
				revivesUsed = ToArray(_reviveUsedAuth),
				reviveQueue = ToArray(_reviveQueueAuth),
				glassMask = 0,
				roundSeed = 0,
				poweredGenerators = 0,
				generatorProgress = Array.Empty<int>(),
				catchCount = _catchCount
			};
		}

		private bool MasterEliminate(int actor, AgCause cause)
		{
			if (!PhotonNetwork.IsMasterClient || _props.queue != GameQueue || _props.phase != AgPhase.Round)
			{
				return false;
			}
			SeedAuthIfNeeded(_props);
			if (_escAuth.Contains(actor))
			{
				return false;
			}
			if (!_aliveAuth.Remove(actor))
			{
				return false;
			}
			_elimAuth.Add(actor);
			bool wasSeeker = _seekerAuth.Remove(actor);
			AgProps.WriteTeams(ToArray(_aliveAuth), ToArray(_elimAuth), null, wasSeeker ? ToArray(_seekerAuth) : null);
			Log(string.Format("Eliminated {0} ({1}), {2} alive", actor, cause, _aliveAuth.Count));
			return true;
		}

		private void MasterEscape(int actor)
		{
			if (!PhotonNetwork.IsMasterClient || _props.queue != GameQueue || _props.phase != AgPhase.Round)
			{
				return;
			}
			SeedAuthIfNeeded(_props);
			if (_aliveAuth.Contains(actor) && _escAuth.Add(actor))
			{
				AgProps.WriteTeams(null, null, ToArray(_escAuth));
				Log(string.Format("Actor {0} finished ({1} out)", actor, _escAuth.Count));
			}
		}

		private void MasterTickRedLight()
		{
			AgSettings.RedLight redLight = settings.redLight;
			double time = PhotonNetwork.Time;
			switch ((AgLightState)_lightAuth)
			{
			case AgLightState.Red:
				if (time >= _lightStampAuth + (double)redLight.redSeconds)
				{
					MasterSetLight(AgLightState.Green);
				}
				break;
			case AgLightState.Green:
				if (_greenEndAuth < _lightStampAuth)
				{
					_greenEndAuth = _lightStampAuth + (double)UnityEngine.Random.Range(redLight.greenMin, redLight.greenMax);
				}
				if (time >= _greenEndAuth)
				{
					MasterSetLight(AgLightState.Red);
				}
				break;
			}
		}

		private void MasterSetLight(AgLightState state)
		{
			_lightAuth = (byte)state;
			_lightStampAuth = PhotonNetwork.Time;
			if (state == AgLightState.Green)
			{
				_greenEndAuth = 0.0;
			}
			_props.lightStamp = _lightStampAuth;
			_props.lightState = _lightAuth;
			AgProps.WriteLight(_lightAuth, _lightStampAuth);
		}

		private AgWatcherController ResolveWatcher()
		{
			if (rounds != null && rounds.Length > 0 && rounds[0] is AgRoundRedLight agRoundRedLight)
			{
				AgWatcherController watcher = agRoundRedLight.Watcher;
				if (watcher != null)
				{
					return watcher;
				}
			}
			return AgWatcherController.Instance;
		}

		public void TestStartMatch()
		{
			if (TestGate("TestStartMatch"))
			{
				if (_props.phase == AgPhase.Round || _props.phase == AgPhase.Intermission)
				{
					TestLog("a match is already live, TestEndMatch first.", true);
					return;
				}
				if (_isStartingRound || _isEndingRound)
				{
					TestLog("a phase transition is in flight, try again.", true);
					return;
				}
				ArmTest("TestStartMatch");
				EnterLobbyWait(TestLobbyWaitSeconds);
			}
		}

		public void TestStartRound(int roundIndex)
		{
			if (!TestGate("TestStartRound"))
			{
				return;
			}
			if (roundIndex < 0 || rounds == null || roundIndex >= rounds.Length)
			{
				TestLog(string.Format("round {0} does not exist (0-{1}).", roundIndex, FinalRoundIndex), true);
				return;
			}
			if (_props.phase == AgPhase.Round)
			{
				TestLog("a round is live, TestEndRound first.", true);
				return;
			}
			if (_isStartingRound || _isEndingRound)
			{
				TestLog("a phase transition is in flight, try again.", true);
				return;
			}
			ArmTest(string.Format("{0}({1})", "TestStartRound", roundIndex));
			if (_props.phase != AgPhase.Intermission)
			{
				TestSynthesizeMatch();
			}
			MasterStartRound(roundIndex);
		}

		public void TestEndRound()
		{
			if (TestGate("TestEndRound"))
			{
				if (_props.phase != AgPhase.Round)
				{
					TestLog("no round is live.", true);
					return;
				}
				if (_isStartingRound || _isEndingRound)
				{
					TestLog("a phase transition is in flight, try again.", true);
					return;
				}
				TestLog(string.Format("ending round {0} (TimeUp semantics, non-crossers eliminated)", _props.round));
				MasterEndRound(_props.round, AgCause.TimeUp);
			}
		}

		public void TestEndMatch()
		{
			if (!TestGate("TestEndMatch"))
			{
				return;
			}
			if (_isStartingRound || _isEndingRound)
			{
				TestLog("a phase transition is in flight, try again.", true);
				return;
			}
			switch (_props.phase)
			{
			case AgPhase.LobbyWait:
				TestLog("cancelling the pending match, back to Idle");
				EnterIdle();
				break;
			case AgPhase.Intermission:
				MasterMatchEnd(Mathf.Max(0, _props.round - 1));
				break;
			case AgPhase.Round:
				MasterMatchEnd(_props.round);
				break;
			default:
				TestLog("no match to end");
				break;
			}
			DisarmTest("TestEndMatch");
		}

		public void TestWinMatch()
		{
			if (!TestGate("TestWinMatch"))
			{
				return;
			}
			if (_isStartingRound || _isEndingRound)
			{
				TestLog("a phase transition is in flight, try again.", true);
				return;
			}
			if (_props.phase != AgPhase.Round && _props.phase != AgPhase.Intermission)
			{
				TestLog("no match to win.", true);
				return;
			}
			SeedAuthIfNeeded(_props);
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			_masterScratch.Clear();
			foreach (int item in _aliveAuth)
			{
				if (item != actorNumber)
				{
					_masterScratch.Add(item);
				}
			}
			for (int i = 0; i < _masterScratch.Count; i++)
			{
				_aliveAuth.Remove(_masterScratch[i]);
				_elimAuth.Add(_masterScratch[i]);
			}
			_elimAuth.Remove(actorNumber);
			_aliveAuth.Add(actorNumber);
			_reviveQueueAuth.Clear();
			TestLog(string.Format("forcing a local win, {0} other contestant(s) eliminated", _masterScratch.Count));
			MasterMatchEnd((_props.phase == AgPhase.Intermission) ? Mathf.Max(0, _props.round - 1) : _props.round);
		}

		public void TestEliminateSelf()
		{
			if (TestGate("TestEliminateSelf"))
			{
				if (_props.phase != AgPhase.Round)
				{
					TestLog("no round is live.", true);
					return;
				}
				int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
				if (!_props.AliveContains(actorNumber) || _props.EscapedContains(actorNumber))
				{
					TestLog("local player is not a live contestant.", true);
					return;
				}
				TestLog("eliminating self through the standard self-report path");
				SendSelfElimination(AgCause.Generic);
			}
		}

		public void TestSetHideSeekRole(byte mode)
		{
			if (TestGate("TestSetHideSeekRole"))
			{
				if (mode < 3)
				{
					_testHideSeekRole = mode;
					TestLog("hide&seek role: " + TestRoleName(mode) + " (consumed at round-3 start while armed)");
				}
				else
				{
					TestLog(string.Format("role {0} invalid, 0 auto / 1 seeker / 2 hider.", mode), true);
				}
			}
		}

		private bool TestGate(string op)
		{
			if (!Application.isPlaying)
			{
				TestLog(op + ": play mode only.", true);
				return false;
			}
			if (!PhotonNetwork.InRoom)
			{
				TestLog(op + ": not in a room.", true);
				return false;
			}
			if (!PhotonNetwork.IsMasterClient)
			{
				TestLog(op + ": master client only.", true);
				return false;
			}
			if (_props.queue != GameQueue)
			{
				TestLog(op + ": room queue '" + _props.queue + "' != 'ApeGames', join the ApeGames queue first.", true);
				return false;
			}
			return true;
		}

		private void ArmTest(string via)
		{
			if (!_testModeArmed)
			{
				_testModeArmed = true;
				TestLog("ARMED via " + via + ", population auto-ends suppressed; timers/crossings/eliminations stay real. Hide&seek role: " + TestRoleName(_testHideSeekRole) + ". Master-local, nothing on the wire.");
			}
		}

		private void DisarmTest(string why)
		{
			if (_testModeArmed)
			{
				_testModeArmed = false;
				TestLog("disarmed (" + why + "), population auto-ends back to normal");
			}
		}

		private void TestSynthesizeMatch()
		{
			Room currentRoom = PhotonNetwork.CurrentRoom;
			int[] array = new int[currentRoom.Players.Count];
			int num = 0;
			foreach (KeyValuePair<int, Player> player in currentRoom.Players)
			{
				if (num < array.Length)
				{
					array[num++] = player.Value.ActorNumber;
				}
			}
			AgRoundProperties p = new AgRoundProperties
			{
				queue = GameQueue,
				phase = _props.phase,
				round = _props.round,
				matchStamp = PhotonNetwork.Time,
				startTime = _props.startTime,
				endTime = _props.endTime,
				alive = array
			};
			_props = p;
			SeedAuthFrom(p);
			TestLog(string.Format("synthesized match, {0} actor(s) alive, fresh match stamp", array.Length));
		}

		private static string TestRoleName(byte m)
		{
			switch (m)
			{
			case 1:
				return "FORCE SEEKER";
			case 2:
				return "FORCE HIDER";
			default:
				return "auto";
			}
		}

		private static void TestLog(string msg, bool isError = false)
		{
			string text = "<color=cyan><b>[ApeGames TEST]</b></color>: " + msg;
			if (isError)
			{
				text += " <color=red>IsError</color>";
			}
			UnityEngine.Debug.Log(text);
		}

		public override void OnRoomPropertiesUpdate(ExitGames.Client.Photon.Hashtable propertiesThatChanged)
		{
			if (!AgProps.TryRead(out AgRoundProperties p))
			{
				return;
			}
			if (propertiesThatChanged != null && propertiesThatChanged.Count > 0)
			{
				bool liveOnly = true;
				foreach (object key in propertiesThatChanged.Keys)
				{
					if (!AgProps.GeneratorProgressKey.Equals(key) && !AgProps.CatchCountKey.Equals(key) && !AgProps.LightStateKey.Equals(key) && !AgProps.LightStampKey.Equals(key) && !AgProps.ChaseActorKey.Equals(key))
					{
						liveOnly = false;
						break;
					}
				}
				if (liveOnly)
				{
					_props = p;
					EvaluateGenerators();
					OnPropsChanged?.Invoke(p);
					return;
				}
			}
			ClientHandlePropsChanged(p);
		}

		public override void OnJoinedRoom()
		{
			_localEliminationApplied = false;
			if (!AgProps.TryRead(out AgRoundProperties p))
			{
				return;
			}
			_props = p;
			if (p.queue != GameQueue)
			{
				return;
			}
			_prevMatchStamp = p.matchStamp;
			_prevAlive = p.alive ?? Array.Empty<int>();
			_prevEscaped = p.escaped ?? Array.Empty<int>();
			_appliedPhaseStamp = p.startTime;
			_roundStartedEventStamp = p.startTime;
			_roundEndedMatchStamp = p.matchStamp;
			_roundEndedRound = ((p.phase == AgPhase.MatchEnd) ? p.round : (p.round - 1));
			_matchEndedEventStamp = p.startTime;
			if (p.phase == AgPhase.Round && p.round >= 0 && rounds != null && p.round < rounds.Length && rounds[p.round] != null)
			{
				rounds[p.round].OnRoundPrepare(p);
				_activeRound = p.round;
			}
			if (p.phase >= AgPhase.Round)
			{
				StartCoroutine(TeleportAfterGrabWait(settings.restAreaSpawn));
			}
			KickDeferredAppearanceRefresh();
			OnPropsChanged?.Invoke(p);
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			if (AgProps.TryRead(out AgRoundProperties p))
			{
				_props = p;
			}
			if (_props.queue == GameQueue)
			{
				KickDeferredAppearanceRefresh();
			}
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (PhotonNetwork.IsMasterClient && _props.queue == GameQueue && _props.matchStamp != 0.0 && _props.phase >= AgPhase.Round)
			{
				SeedAuthIfNeeded(_props);
				int actorNumber = otherPlayer.ActorNumber;
				bool aliveRemoved = _aliveAuth.Remove(actorNumber);
				bool seekerRemoved = _seekerAuth.Remove(actorNumber);
				bool towerRemoved = _towerAuth.Remove(actorNumber);
				bool escapedRemoved = _escAuth.Remove(actorNumber);
				bool queueRemoved = _reviveQueueAuth.Remove(actorNumber);
				if (aliveRemoved || seekerRemoved || towerRemoved || escapedRemoved || queueRemoved)
				{
					AgProps.WriteTeams(aliveRemoved ? ToArray(_aliveAuth) : null, null, escapedRemoved ? ToArray(_escAuth) : null, seekerRemoved ? ToArray(_seekerAuth) : null, towerRemoved ? ToArray(_towerAuth) : null, queueRemoved ? ToArray(_reviveQueueAuth) : null);
				}
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			DisarmTest("master client switched");
			_testHideSeekRole = 0;
			if (PhotonNetwork.IsMasterClient)
			{
				if (AgProps.TryRead(out AgRoundProperties p))
				{
					_props = p;
				}
				if (_props.queue == GameQueue)
				{
					SeedAuthFrom(_props);
					_isStartingRound = false;
					_isEndingRound = false;
					MasterUpdate();
				}
			}
		}

		public override void OnLeftRoom()
		{
			if (_activeRound >= 0 && rounds != null && _activeRound < rounds.Length && rounds[_activeRound] != null)
			{
				rounds[_activeRound].OnRoundCleanup();
			}
			_activeRound = -1;
			if (_ragdolls != null)
			{
				_ragdolls.DespawnAll();
			}
			_props = new AgRoundProperties();
			_localEliminationApplied = false;
			_elimRetryActive = false;
			_prevAlive = Array.Empty<int>();
			_prevEscaped = Array.Empty<int>();
			_prevMatchStamp = 0.0;
			_appliedPhaseStamp = -1.0;
			_roundStartedEventStamp = -1.0;
			_roundEndedMatchStamp = -1.0;
			_roundEndedRound = -1;
			_matchEndedEventStamp = -1.0;
			_countdownStamp = -1.0;
			_authStamp = -1.0;
			_isStartingRound = false;
			_isEndingRound = false;
			DisarmTest("left room");
			_testHideSeekRole = 0;
			_sentPanels.Clear();
			_lastHammerReport.Clear();
			_lastCatchReport.Clear();
			if (_deferredRefresh != null)
			{
				StopCoroutine(_deferredRefresh);
				_deferredRefresh = null;
			}
			OnPropsChanged?.Invoke(_props);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_RoundStarted(byte round, int[] alive, int[] special, int seed, int glassMask)
		{
			if (_props.queue == GameQueue && _props.phase == AgPhase.Round && _props.round == round)
			{
				TryApplyPhaseTransition(_props);
				FireRoundStarted(round);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_RoundEnded(byte round, int[] survivors, byte reason)
		{
			if (_props.queue == GameQueue && (_props.phase == AgPhase.Intermission || _props.phase == AgPhase.MatchEnd))
			{
				TryApplyPhaseTransition(_props);
				FireRoundEnded(round);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_MatchEnded(int[] winners)
		{
			if (_props.queue == GameQueue && _props.phase == AgPhase.MatchEnd)
			{
				TryApplyPhaseTransition(_props);
				FireMatchEnded(winners);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_EliminatePlayer(int actor, byte cause, int byActor, PhotonMessageInfo info)
		{
			if (_props.queue != GameQueue || actor < 1 || _props.phase != AgPhase.Round || !_props.AliveContains(actor) || _props.EscapedContains(actor))
			{
				return;
			}
			Player sender = info.Sender;
			if (sender == null)
			{
				return;
			}
			if (sender.ActorNumber == actor)
			{
				if (cause == 4 && _props.SeekersContains(actor))
				{
					return;
				}
			}
			else if (cause == 1)
			{
				if (_props.round != 0 || !sender.IsMasterClient)
				{
					return;
				}
			}
			else
			{
				if (cause != 4 || sender.ActorNumber != byActor || byActor < 1 || _props.round != 3 || !_props.SeekersContains(byActor) || !_props.AliveContains(byActor) || _props.SeekersContains(actor))
				{
					return;
				}
			}
			if (_ragdolls != null)
			{
				_ragdolls.SpawnFor(actor);
			}
			if (PhotonNetwork.IsMasterClient)
			{
				bool eliminated = MasterEliminate(actor, (AgCause)cause);
				if (cause == 4 && eliminated)
				{
					_catchCount++;
					if (PhotonNetwork.IsConnectedAndReady)
					{
						PhotonNetwork.CurrentRoom.SetCustomProperties(new ExitGames.Client.Photon.Hashtable { [AgProps.CatchCountKey] = _catchCount });
					}
				}
			}
			if (PhotonNetwork.LocalPlayer != null && PhotonNetwork.LocalPlayer.ActorNumber == actor)
			{
				LocalApplyElimination((AgCause)cause, false, byActor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_ReportRunner(int actor, PhotonMessageInfo info)
		{
			if (PhotonNetwork.IsMasterClient && info.Sender != null && info.Sender.ActorNumber == actor && _props.queue == GameQueue && _props.phase == AgPhase.Round && _props.round == 0)
			{
				SeedAuthIfNeeded(_props);
				if (_lightAuth == 2 && _aliveAuth.Contains(actor) && !_escAuth.Contains(actor))
				{
					if (PhotonNetwork.IsConnectedAndReady)
					{
						SendAgRpc(AgRpc.EliminatePlayer, RpcTarget.All, actor, (byte)1, 0);
					}
					Log(string.Format("Runner {0} moved on red, eliminated", actor));
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_ReachFinish(int actor, PhotonMessageInfo info)
		{
			if (PhotonNetwork.IsMasterClient && info.Sender != null && info.Sender.ActorNumber == actor && _props.queue == GameQueue && _props.phase == AgPhase.Round && _props.round <= 2)
			{
				MasterEscape(actor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_BreakPanel(int row, int side, PhotonMessageInfo info)
		{
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || row < 0 || _props.round != 2)
			{
				return;
			}
			AgSettings.Glass glass = settings.glass;
			if (side < 0 || side > 1 || row >= glass.rows || ((_props.glassMask >> row) & 1) != side || info.Sender == null || !_props.AliveContains(info.Sender.ActorNumber))
			{
				return;
			}
			if (!_panelsStamp.Equals(_props.startTime))
			{
				_panelsStamp = _props.startTime;
				_appliedPanels.Clear();
			}
			if (_appliedPanels.Add(row * 2 + side))
			{
				if (rounds != null && rounds.Length > 2 && rounds[2] is AgRoundGlassBridge agRoundGlassBridge)
				{
					agRoundGlassBridge.ApplyBreak(row, side);
				}
				OnPanelBroken?.Invoke(row, side);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_CrankGenerator(int generatorId, float clockwiseDegrees, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.IsMasterClient || generatorId < 0 || generatorId >= 32 || !float.IsFinite(clockwiseDegrees) || _props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 3)
			{
				return;
			}
			Player sender = info.Sender;
			if (sender == null || !_props.AliveContains(sender.ActorNumber) || _props.SeekersContains(sender.ActorNumber) || _props.EscapedContains(sender.ActorNumber))
			{
				return;
			}
			SeedAuthIfNeeded(_props);
			int bit = 1 << generatorId;
			if ((_crankMask & bit) != 0)
			{
				return;
			}
			double time = PhotonNetwork.Time;
			float degrees = Mathf.Clamp(clockwiseDegrees, 0f, CrankMaxDegreesPerReport);
			long key = ((long)generatorId << 32) | (uint)sender.ActorNumber;
			if (_crankContribTimes.TryGetValue(key, out double last))
			{
				degrees = Mathf.Min(degrees, Mathf.Clamp01((float)((time - last) / CrankMasterPace)) * CrankMaxDegreesPerReport);
			}
			_crankContribTimes[key] = time;
			if (degrees <= 0f)
			{
				return;
			}
			int crankers = 0;
			foreach (KeyValuePair<long, double> crankContribTime in _crankContribTimes)
			{
				if ((int)(crankContribTime.Key >> 32) == generatorId && time - crankContribTime.Value <= (double)CrankSynergyWindow)
				{
					crankers++;
				}
			}
			int before = Mathf.FloorToInt(_crankCharge[generatorId]);
			float synergy = Mathf.Min(1f + (float)Mathf.Max(0, crankers - 1) * CrankSynergyPerExtra, CrankMaxSynergy);
			_crankCharge[generatorId] = Mathf.Min(_crankCharge[generatorId] + degrees / CrankDegreesPerPoint * synergy, 100f);
			int after = Mathf.FloorToInt(_crankCharge[generatorId]);
			if (after == before)
			{
				return;
			}
			byte[] progress = new byte[32];
			for (int i = 0; i < progress.Length; i++)
			{
				progress[i] = (byte)Mathf.Clamp(Mathf.FloorToInt(_crankCharge[i]), 0, 100);
			}
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable { [AgProps.GeneratorProgressKey] = progress };
			if (after >= 100)
			{
				_crankMask |= bit;
				hashtable[AgProps.PoweredGeneratorsKey] = _crankMask;
				Log(string.Format("Generator {0} fully charged ({1} cranker(s), x{2:0.00})", generatorId, crankers, synergy));
			}
			if (PhotonNetwork.IsConnectedAndReady)
			{
				PhotonNetwork.CurrentRoom.SetCustomProperties(hashtable);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_EscapeHider(int actor, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			if (info.Sender == null || info.Sender.ActorNumber != actor)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 3)
			{
				return;
			}
			if (_props.SeekersContains(actor))
			{
				return;
			}
			SeedAuthIfNeeded(_props);
			int powered = 0;
			for (uint m = (uint)_crankMask; m != 0; m >>= 1)
			{
				powered += (int)(m & 1);
			}
			if (powered >= settings.hideSeek.generatorsRequired)
			{
				MasterEscape(actor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_HammerHit(int victimActor, float ix, float iy, float iz, PhotonMessageInfo info)
		{
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 4)
			{
				return;
			}
			if (info.Sender == null)
			{
				return;
			}
			int attacker = info.Sender.ActorNumber;
			if (attacker == victimActor)
			{
				return;
			}
			if (!_props.AliveContains(attacker) || !_props.AliveContains(victimActor))
			{
				return;
			}
			if (!float.IsFinite(ix) || !float.IsFinite(iy) || !float.IsFinite(iz))
			{
				return;
			}
			Vector3 impulse = new Vector3(ix, iy, iz);
			float max = settings.finalFight.maxKnockbackSpeed;
			if (impulse.sqrMagnitude > max * max)
			{
				impulse = impulse.normalized * max;
			}
			OnHammerHit?.Invoke(victimActor, impulse);
			if (rounds != null && rounds.Length > FinalRoundIndex && rounds[FinalRoundIndex] is AgRoundFinalFight finalFight)
			{
				finalFight.OnHammerHitVisuals(victimActor);
				finalFight.OnHammerHitVictim(victimActor, impulse);
			}
			else if (PhotonNetwork.LocalPlayer != null && PhotonNetwork.LocalPlayer.ActorNumber == victimActor)
			{
				AgLauncher.Launch(impulse);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_RequestRevive(int actor, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			if (info.Sender == null || info.Sender.ActorNumber != actor)
			{
				return;
			}
			if (_props.queue != GameQueue)
			{
				return;
			}
			if (_props.phase != AgPhase.Round && _props.phase != AgPhase.Intermission)
			{
				return;
			}
			int rejoinRound = ReviveRejoinRound();
			if (rejoinRound < 0)
			{
				return;
			}
			SeedAuthIfNeeded(_props);
			if (!_elimAuth.Contains(actor) || _reviveUsedAuth.Contains(actor) || _reviveQueueAuth.Contains(actor))
			{
				return;
			}
			_reviveQueueAuth.Add(actor);
			_reviveUsedAuth.Add(actor);
			AgProps.WriteTeams(null, null, null, null, null, ToArray(_reviveQueueAuth), ToArray(_reviveUsedAuth));
			if (PhotonNetwork.IsConnectedAndReady)
			{
				SendAgRpc(AgRpc.ReviveQueued, RpcTarget.All, actor);
			}
			Log(string.Format("Revive queued for {0}, rejoins at round {1}", actor, rejoinRound));
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_ReviveQueued(int actor)
		{
			if (_props.queue == GameQueue)
			{
				OnReviveQueued?.Invoke(actor);
			}
		}

		private void Awake()
		{
			Instance = this;
			_ragdolls = GetComponent<AgRagdollSpawner>();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Start()
		{
			if (rounds == null)
			{
				return;
			}
			AgRoundBase[] array = rounds;
			foreach (AgRoundBase round in array)
			{
				if (round != null && round.roundRoot != null)
				{
					round.roundRoot.SetActive(false);
				}
			}
		}

		private void Update()
		{
			if (_props.queue == GameQueue && PhotonNetwork.InRoom)
			{
				TickCountdown();
				TickEliminationRetry();
				TickActiveRound();
				MasterUpdate();
			}
		}

		private void TickActiveRound()
		{
			if (_props.phase != AgPhase.Round)
			{
				return;
			}
			int r = _props.round;
			if (!IsValidRound(r) || rounds[r] == null)
			{
				return;
			}
			double elapsed = PhotonNetwork.Time - _props.startTime;
			rounds[r].LocalTick(elapsed, _props);
			if (PhotonNetwork.IsMasterClient)
			{
				rounds[r].MasterTick(elapsed, _props);
			}
		}

		private void TickCountdown()
		{
			if (_props.phase != AgPhase.Round || _props.endTime == 0.0)
			{
				return;
			}
			double endTime = _props.endTime;
			if (!_countdownStamp.Equals(_props.startTime))
			{
				_countdownStamp = _props.startTime;
				_countdownPrevRemaining = endTime - _props.startTime;
				_countdownMask = 0;
			}
			double remaining = endTime - PhotonNetwork.Time;
			if (remaining <= 0.0)
			{
				_countdownPrevRemaining = 0.0;
				return;
			}
			for (int i = 0; i < CountdownThresholds.Length; i++)
			{
				int bit = 1 << i;
				if ((_countdownMask & bit) == 0)
				{
					int threshold = CountdownThresholds[i];
					if (remaining <= (double)threshold && _countdownPrevRemaining > (double)threshold)
					{
						_countdownMask |= bit;
						OnCountdown?.Invoke(threshold);
					}
				}
			}
			_countdownPrevRemaining = remaining;
		}

		private void TickEliminationRetry()
		{
			if (!_elimRetryActive)
			{
				return;
			}
			AgRoundProperties p = _props;
			if (p.matchStamp == 0.0 || !p.matchStamp.Equals(_elimRetryMatchStamp) || p.phase == AgPhase.Idle || p.phase == AgPhase.LobbyWait || p.phase == AgPhase.MatchEnd || Time.time >= _elimRetryDeadline || PhotonNetwork.LocalPlayer == null)
			{
				_elimRetryActive = false;
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (actor <= 0 || !p.AliveContains(actor) || p.EscapedContains(actor))
			{
				_elimRetryActive = false;
			}
			else if (p.phase == AgPhase.Round && !(Time.time < _elimRetryNextSend))
			{
				_elimRetryNextSend = Time.time + 2f;
				if (PhotonNetwork.IsConnectedAndReady)
				{
					SendAgRpc(AgRpc.EliminatePlayer, RpcTarget.MasterClient, actor, _elimRetryCause, _elimRetryByActor);
				}
			}
		}

		private bool IsValidRound(int r)
		{
			if (r >= 0 && rounds != null)
			{
				return r < rounds.Length;
			}
			return false;
		}

		private int SkipDisabled(int round)
		{
			if (settings != null && round == 3 && settings.skipHideSeek)
			{
				return 4;
			}
			return round;
		}

		public int ResolveStartingRound(int round)
		{
			return SkipDisabled(round);
		}

		public int RoundDisplayNumber(int round)
		{
			if (settings != null && round >= 4 && settings.skipHideSeek)
			{
				return round;
			}
			return round + 1;
		}

		public int ReviveRejoinRound()
		{
			if (_props.queue != GameQueue)
			{
				return -1;
			}
			int next;
			if (_props.phase == AgPhase.Round)
			{
				next = _props.round + 1;
			}
			else
			{
				if (_props.phase != AgPhase.Intermission)
				{
					return -1;
				}
				next = _props.round;
			}
			if (SkipDisabled(next) >= FinalRoundIndex)
			{
				return -1;
			}
			return next;
		}

		public static bool IsLocalAlive()
		{
			if (Instance == null || !PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			AgRoundProperties p = Instance._props;
			if (p.queue != GameQueue)
			{
				return false;
			}
			return p.AliveContains(PhotonNetwork.LocalPlayer.ActorNumber);
		}

		public bool IsAlive(int actor)
		{
			return _props.AliveContains(actor);
		}

		public bool IsEliminatedActor(int actor)
		{
			return _props.EliminatedContains(actor);
		}

		public bool TryGetGeneratorProgress(out int powered, out int total)
		{
			powered = 0;
			if (settings == null)
			{
				total = 0;
				return false;
			}
			total = settings.hideSeek.generatorsRequired;
			if (total <= 0 || _props.phase != AgPhase.Round || _props.round != 3)
			{
				return false;
			}
			for (uint m = (uint)_props.poweredGenerators; m != 0; m >>= 1)
			{
				powered += (int)(m & 1);
			}
			if (powered > total)
			{
				powered = total;
			}
			return true;
		}

		public void ReportSelfViolation(AgCause cause)
		{
			SendSelfElimination(cause);
		}

		public bool ReportRunner()
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return false;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 0)
			{
				return false;
			}
			if (Time.time - _lastRunnerReportTime < 1f)
			{
				return false;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (!_props.AliveContains(actor) || _props.EscapedContains(actor))
			{
				return false;
			}
			_lastRunnerReportTime = Time.time;
			SendAgRpc(AgRpc.ReportRunner, RpcTarget.MasterClient, actor);
			return true;
		}

		public bool IsLocalContestant()
		{
			if (!PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			AgRoundProperties p = _props;
			if (p.queue != GameQueue || p.phase != AgPhase.Round)
			{
				return false;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (p.AliveContains(actor))
			{
				return !p.EscapedContains(actor);
			}
			return false;
		}

		public void ApplyLocalDownForce(float speed, float seconds)
		{
			if (!(speed <= 0f) && !(seconds <= 0f))
			{
				AgLauncher.Push(Vector3.down * speed, seconds);
			}
		}

		public void HandleKillZone(AgCause cause)
		{
			if (_props.queue != GameQueue || !PhotonNetwork.InRoom)
			{
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			AgRoundProperties p = _props;
			if (p.phase == AgPhase.Round && p.AliveContains(actor) && !p.EscapedContains(actor))
			{
				SendSelfElimination(cause);
				return;
			}
			RandomizeSpawnPoint fallback = (p.EliminatedContains(actor) ? settings.restAreaSpawn : settings.lobbySpawn);
			StartCoroutine(TeleportToBedOrGrabWait(actor, fallback));
		}

		private void SendSelfElimination(AgCause cause)
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round)
			{
				return;
			}
			if (Time.time - _lastSelfElimTime < 1f)
			{
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (_props.AliveContains(actor) && !_props.EscapedContains(actor))
			{
				_lastSelfElimTime = Time.time;
				SendAgRpc(AgRpc.EliminatePlayer, RpcTarget.All, actor, (byte)cause, actor);
			}
		}

		public void RequestFinishCross()
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round > 2)
			{
				return;
			}
			if (Time.time - _lastFinishRequestTime < 1f)
			{
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (_props.AliveContains(actor) && !_props.EscapedContains(actor))
			{
				_lastFinishRequestTime = Time.time;
				SendAgRpc(AgRpc.ReachFinish, RpcTarget.MasterClient, actor);
			}
		}

		public void RequestBreakPanel(int row, int side)
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || row < 0 || _props.round != 2)
			{
				return;
			}
			int rows = settings.glass.rows;
			if (side >= 0 && side <= 1 && row < rows && IsLocalAlive() && _sentPanels.Add(row * 2 + side))
			{
				SendAgRpc(AgRpc.BreakPanel, RpcTarget.All, row, side);
			}
		}

		public void ReportSeekerCatch(int victimActor)
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 3)
			{
				return;
			}
			int me = PhotonNetwork.LocalPlayer.ActorNumber;
			if (victimActor <= 0 || me == victimActor)
			{
				return;
			}
			if (!_props.SeekersContains(me) || !_props.AliveContains(victimActor) || _props.SeekersContains(victimActor) || _props.EscapedContains(victimActor))
			{
				return;
			}
			if (!_lastCatchReport.TryGetValue(victimActor, out var last) || !(Time.time - last < 1f))
			{
				_lastCatchReport[victimActor] = Time.time;
				SendAgRpc(AgRpc.EliminatePlayer, RpcTarget.All, victimActor, (byte)AgCause.Caught, me);
			}
		}

		public void ContributeCrank(int generatorId, float clockwiseDegrees)
		{
			if (generatorId < 0 || generatorId >= 32 || clockwiseDegrees <= 0f || !float.IsFinite(clockwiseDegrees))
			{
				return;
			}
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 3)
			{
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (_props.AliveContains(actor) && !_props.SeekersContains(actor) && !_props.EscapedContains(actor) && ((_props.poweredGenerators >> generatorId) & 1) == 0)
			{
				SendAgRpc(AgRpc.CrankGenerator, RpcTarget.MasterClient, generatorId, clockwiseDegrees);
			}
		}

		public void RequestHiderEscape()
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 3)
			{
				return;
			}
			if (Time.time - _lastEscapeRequestTime < 1f)
			{
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (_props.AliveContains(actor) && !_props.SeekersContains(actor) && !_props.EscapedContains(actor) && TryGetGeneratorProgress(out var powered, out var total) && powered >= total)
			{
				_lastEscapeRequestTime = Time.time;
				SendAgRpc(AgRpc.EscapeHider, RpcTarget.MasterClient, actor);
			}
		}

		public void ReportHammerHit(int victimActor, Vector3 impulse)
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || _props.phase != AgPhase.Round || _props.round != 4)
			{
				return;
			}
			int me = PhotonNetwork.LocalPlayer.ActorNumber;
			if (victimActor <= 0 || me == victimActor)
			{
				return;
			}
			if (!_props.AliveContains(me) || !_props.AliveContains(victimActor))
			{
				return;
			}
			if (!float.IsFinite(impulse.x) || !float.IsFinite(impulse.y) || !float.IsFinite(impulse.z))
			{
				return;
			}
			if (!_lastHammerReport.TryGetValue(victimActor, out var last) || !(Time.time - last < settings.finalFight.hitCooldownSeconds))
			{
				_lastHammerReport[victimActor] = Time.time;
				SendAgRpc(AgRpc.HammerHit, RpcTarget.All, victimActor, impulse.x, impulse.y, impulse.z);
			}
		}

		public void RequestRevive()
		{
			if (!PhotonNetwork.IsConnectedAndReady || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_props.queue != GameQueue || (_props.phase != AgPhase.Round && _props.phase != AgPhase.Intermission))
			{
				return;
			}
			if (Time.time - _lastReviveRequestTime < 1f)
			{
				return;
			}
			int actor = PhotonNetwork.LocalPlayer.ActorNumber;
			if (_props.EliminatedContains(actor) && !_props.RevivesUsedContains(actor) && !_props.ReviveQueueContains(actor) && ReviveRejoinRound() >= 0)
			{
				_lastReviveRequestTime = Time.time;
				SendAgRpc(AgRpc.RequestRevive, RpcTarget.MasterClient, actor);
			}
		}

		private void ClientHandlePropsChanged(AgRoundProperties p)
		{
			_props = p;
			if (p.queue == GameQueue)
			{
				RefreshAllAppearances();
				EvaluateGenerators();
				TryApplyPhaseTransition(p);
				if (p.matchStamp != 0.0 && _prevMatchStamp.Equals(p.matchStamp))
				{
					for (int i = 0; i < _prevAlive.Length; i++)
					{
						int actor = _prevAlive[i];
						if (p.AliveContains(actor) || p.EscapedContains(actor) || p.ReviveQueueContains(actor) || PhotonNetwork.CurrentRoom == null || PhotonNetwork.CurrentRoom.GetPlayer(actor) == null)
						{
							continue;
						}
						if (_ragdolls != null)
						{
							_ragdolls.SpawnFor(actor);
						}
						if (actor == PhotonNetwork.LocalPlayer.ActorNumber)
						{
							LocalApplyElimination((p.phase != AgPhase.Round) ? AgCause.TimeUp : AgCause.Generic, fromPropsEdge: true);
						}
					}
					int me = PhotonNetwork.LocalPlayer.ActorNumber;
					if (p.EscapedContains(me) && !Contains(_prevEscaped, me))
					{
						OnLocalEscaped?.Invoke();
					}
				}
				_prevMatchStamp = p.matchStamp;
				_prevAlive = p.alive ?? Array.Empty<int>();
				_prevEscaped = p.escaped ?? Array.Empty<int>();
			}
			OnPropsChanged?.Invoke(p);
		}

		private void TryApplyPhaseTransition(AgRoundProperties p)
		{
			if (p.queue != GameQueue || _appliedPhaseStamp.Equals(p.startTime))
			{
				return;
			}
			_appliedPhaseStamp = p.startTime;
			if (_ragdolls != null)
			{
				_ragdolls.DespawnAll();
			}
			if (_activeRound >= 0 && (p.phase != AgPhase.Round || p.round != _activeRound))
			{
				if (IsValidRound(_activeRound) && rounds[_activeRound] != null)
				{
					rounds[_activeRound].OnRoundCleanup();
				}
				_activeRound = -1;
			}
			int local = ((PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
			switch (p.phase)
			{
			case AgPhase.Idle:
			case AgPhase.LobbyWait:
				StartCoroutine(TeleportAfterGrabWait(settings.lobbySpawn));
				break;
			case AgPhase.Intermission:
				if (Contains(p.alive, local))
				{
					StartCoroutine(TeleportToBedOrGrabWait(local, settings.lobbySpawn));
				}
				FireRoundEnded(p.round - 1);
				break;
			case AgPhase.MatchEnd:
				if (Contains(p.alive, local))
				{
					StartCoroutine(TeleportToBedOrGrabWait(local, settings.lobbySpawn));
				}
				FireRoundEnded(p.round);
				FireMatchEnded(p.alive ?? Array.Empty<int>());
				break;
			case AgPhase.Round:
			{
				int round = p.round;
				if (_roundEndedMatchStamp.Equals(p.matchStamp) && _roundEndedRound >= round)
				{
					_roundEndedRound = round - 1;
				}
				if (IsValidRound(round) && rounds[round] != null)
				{
					rounds[round].OnRoundPrepare(p);
					_activeRound = round;
				}
				_sentPanels.Clear();
				_lastHammerReport.Clear();
				_lastCatchReport.Clear();
				if (Contains(p.alive, local))
				{
					_localEliminationApplied = false;
					RandomizeSpawnPoint sp = ((IsValidRound(round) && rounds[round] != null) ? rounds[round].GetSpawnFor(local, p) : settings.lobbySpawn);
					float delay = 0f;
					if (round == 3 && Contains(p.seekers, local))
					{
						delay = settings.hideSeek.seekerSpawnDelay;
					}
					StartCoroutine(TeleportPlayer(sp, delay));
				}
				FireRoundStarted(round);
				break;
			}
			}
		}

		private void FireRoundStarted(int round)
		{
			if (_props != null && !_roundStartedEventStamp.Equals(_props.startTime))
			{
				_roundStartedEventStamp = _props.startTime;
				OnRoundStartedEvent?.Invoke(round, _props);
			}
		}

		private void FireRoundEnded(int round)
		{
			if (round >= 0 && _props != null && (!_roundEndedMatchStamp.Equals(_props.matchStamp) || _roundEndedRound != round))
			{
				_roundEndedMatchStamp = _props.matchStamp;
				_roundEndedRound = round;
				OnRoundEndedEvent?.Invoke(round, _props);
			}
		}

		private void FireMatchEnded(int[] winners)
		{
			if (_props != null && !_matchEndedEventStamp.Equals(_props.startTime))
			{
				_matchEndedEventStamp = _props.startTime;
				OnMatchEnded?.Invoke(winners ?? Array.Empty<int>());
			}
		}

		private void LocalApplyElimination(AgCause cause, bool fromPropsEdge = false, int byActor = 0)
		{
			if (_props.queue != GameQueue)
			{
				return;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (fromPropsEdge)
			{
				_elimRetryActive = false;
				if (_localEliminationApplied && Time.time - _localEliminationTime < 3f)
				{
					return;
				}
			}
			else if (_props.phase != AgPhase.Round || !Contains(_props.alive, actorNumber) || Contains(_props.escaped, actorNumber) || _localEliminationApplied)
			{
				return;
			}
			_localEliminationApplied = true;
			_localEliminationTime = Time.time;
			LastLocalEliminationCause = cause;
			if (!fromPropsEdge)
			{
				_elimRetryActive = true;
				_elimRetryMatchStamp = _props.matchStamp;
				_elimRetryCause = (byte)cause;
				_elimRetryByActor = ((byActor > 0) ? byActor : actorNumber);
				_elimRetryNextSend = Time.time + 2f;
				_elimRetryDeadline = Time.time + 30f;
			}
			StartCoroutine(TeleportToBedOrGrabWait(actorNumber, settings.restAreaSpawn));
			OnLocalEliminated?.Invoke();
		}

		private static IEnumerator TeleportPlayer(RandomizeSpawnPoint sp, float spawnDelay = 0f)
		{
			if (!sp)
			{
				yield break;
			}
			if (spawnDelay > 0f)
			{
				yield return new WaitForSeconds(spawnDelay);
				if (!AgProps.TryRead(out var p) || p.phase != AgPhase.Round)
				{
					yield break;
				}
			}
			Vector3 pos = sp.GetRandomPoint();
			Quaternion rot = sp.LookRotation();
			bool setRot = sp.forceLookDirection;
			ScreenFader fader = ScreenFader.Get();
			if (fader != null)
			{
				yield return fader.FadeOut(spawnFadeOutDuration);
			}
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(pos, rot, setRot);
			}
			yield return new WaitForEndOfFrame();
			yield return new WaitForSeconds(spawnBlackHoldDuration);
			if (fader != null)
			{
				yield return fader.FadeIn(spawnFadeInDuration);
			}
		}

		private IEnumerator TeleportAfterGrabWait(RandomizeSpawnPoint sp)
		{
			MonkeDevNetworkingPlayer me = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.LocalPlayer : null);
			float waited = 0f;
			while (me != null && me.IsBeingGrabbed && waited < 12f)
			{
				waited += Time.deltaTime;
				yield return null;
			}
			yield return TeleportPlayer(sp);
		}

		private IEnumerator TeleportToBedOrGrabWait(int actor, RandomizeSpawnPoint fallback)
		{
			if (AgBedRegistry.Instance == null || !AgBedRegistry.Instance.TryGetSpawn(actor, out var pos, out var rot, out var setRot))
			{
				yield return TeleportAfterGrabWait(fallback);
				yield break;
			}
			MonkeDevNetworkingPlayer me = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.LocalPlayer : null);
			float waited = 0f;
			while (me != null && me.IsBeingGrabbed && waited < 12f)
			{
				waited += Time.deltaTime;
				yield return null;
			}
			ScreenFader fader = ScreenFader.Get();
			if (fader != null)
			{
				yield return fader.FadeOut(spawnFadeOutDuration);
			}
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(pos, rot, setRot);
			}
			yield return new WaitForEndOfFrame();
			yield return new WaitForSeconds(spawnBlackHoldDuration);
			if (fader != null)
			{
				yield return fader.FadeIn(spawnFadeInDuration);
			}
		}

		private void EvaluateGenerators()
		{
			IReadOnlyList<AgGenerator> activeGenerators = AgGenerator.ActiveGenerators;
			if (activeGenerators.Count == 0)
			{
				return;
			}
			AgRoundProperties props = _props;
			bool live = props.queue == GameQueue && props.phase == AgPhase.Round && props.round == 3;
			for (int i = 0; i < activeGenerators.Count; i++)
			{
				AgGenerator agGenerator = activeGenerators[i];
				if (agGenerator == null || agGenerator.generatorId < 0 || agGenerator.generatorId >= 32)
				{
					continue;
				}
				int generatorId = agGenerator.generatorId;
				bool powered = false;
				int progress = 0;
				if (live)
				{
					if (((props.poweredGenerators >> generatorId) & 1) != 0)
					{
						powered = true;
						progress = 100;
					}
					else if (props.generatorProgress != null && generatorId < props.generatorProgress.Length)
					{
						progress = props.generatorProgress[generatorId];
					}
				}
				agGenerator.ApplyPowered(powered, true);
				agGenerator.ApplyProgress(progress);
			}
		}

		private void RefreshAllAppearances()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			AgRoundProperties props = _props;
			bool inMatch = props.queue == GameQueue && (props.phase == AgPhase.Round || props.phase == AgPhase.Intermission || props.phase == AgPhase.MatchEnd);
			bool hasRoster = (props.alive != null && props.alive.Length != 0) || (props.eliminated != null && props.eliminated.Length != 0);
			bool apply = inMatch && hasRoster;
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
				if (monkeDevNetworkingPlayer == null || monkeDevNetworkingPlayer.photonView == null)
				{
					continue;
				}
				int ownerActorNr = monkeDevNetworkingPlayer.photonView.OwnerActorNr;
				if (ownerActorNr >= 1)
				{
					GameModePlayer gameModePlayer = monkeDevNetworkingPlayer.gameModePlayer;
					if (!(gameModePlayer == null))
					{
						gameModePlayer.IsEliminated = apply && !Contains(props.alive, ownerActorNr);
					}
				}
			}
		}

		private void KickDeferredAppearanceRefresh()
		{
			if (_deferredRefresh != null)
			{
				StopCoroutine(_deferredRefresh);
			}
			_deferredRefresh = StartCoroutine(DeferredRefreshAppearances());
		}

		private IEnumerator DeferredRefreshAppearances()
		{
			for (int attempt = 0; attempt < 20; attempt++)
			{
				if (!PhotonNetwork.InRoom)
				{
					yield break;
				}
				if (AgProps.TryRead(out var p))
				{
					_props = p;
				}
				RefreshAllAppearances();
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				bool missing = false;
				foreach (KeyValuePair<int, Player> player in PhotonNetwork.CurrentRoom.Players)
				{
					bool found = false;
					if (manager != null)
					{
						List<MonkeDevNetworkingPlayer> players = manager.Players;
						for (int i = 0; i < players.Count; i++)
						{
							MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
							if (monkeDevNetworkingPlayer != null && monkeDevNetworkingPlayer.photonView != null && monkeDevNetworkingPlayer.photonView.OwnerActorNr == player.Value.ActorNumber)
							{
								found = true;
								break;
							}
						}
					}
					if (!found)
					{
						missing = true;
						break;
					}
				}
				if (!missing)
				{
					yield break;
				}
				yield return new WaitForSeconds(0.5f);
			}
		}

		private static bool Contains(int[] a, int v)
		{
			if (a == null)
			{
				return false;
			}
			for (int i = 0; i < a.Length; i++)
			{
				if (a[i] == v)
				{
					return true;
				}
			}
			return false;
		}

		private static void Log(string msg, bool isError = false)
		{
			string text = "<color=orange><b>[ApeGames]</b></color>: " + msg;
			if (isError)
			{
				text += " <color=red>IsError</color>";
			}
			UnityEngine.Debug.Log(text);
		}
	}
}
