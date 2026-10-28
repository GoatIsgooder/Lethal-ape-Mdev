using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using Photon.Voice.PUN;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgVoiceIsolation : MonoBehaviourPunCallbacks
	{
		public const byte GroupBroadcast = 0;

		public const byte GroupAlive = 1;

		public const byte GroupRest = 2;

		private static readonly byte[] NoGroups = new byte[0];

		private static readonly byte[] AliveOnly = new byte[1] { 1 };

		private static readonly byte[] RestOnly = new byte[1] { 2 };

		private static readonly byte[] RestAndAlive = new byte[2] { 2, 1 };

		private const float TickInterval = 0.5f;

		private byte _desiredGroup;

		private byte _appliedGroup;

		private bool _groupDirty;

		private bool _listenSubscribed;

		private bool _localElimLatch;

		private bool _volumesTouched;

		private bool _hooked;

		private int _watchedActor = -1;

		private AgSpectateViewport _listenOwner;

		private float _nextTick;

		private PunVoiceClient _voiceClient;

		private static bool _quitting;

		private readonly List<AgNetSync> _avatars = new List<AgNetSync>();

		public static AgVoiceIsolation Instance { get; private set; }

		public bool IsListeningToAlive { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_quitting = false;
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (!(Instance != this))
			{
				ResetToBroadcast(false);
				Instance = null;
			}
		}

		private void OnApplicationQuit()
		{
			_quitting = true;
		}

		private PunVoiceClient ResolveVoiceClient(bool allowFind = true)
		{
			if (_voiceClient != null)
			{
				return _voiceClient;
			}
			if (!allowFind || _quitting)
			{
				return null;
			}
			_voiceClient = Object.FindFirstObjectByType<PunVoiceClient>();
			return _voiceClient;
		}

		private void Start()
		{
			Hook();
			EvaluateFromProps((ApeGamesManager.Instance != null) ? ApeGamesManager.Instance.Props : null);
		}

		public override void OnEnable()
		{
			base.OnEnable();
			Hook();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			Unhook();
			if (_volumesTouched)
			{
				RestoreVolumes();
			}
		}

		private void Hook()
		{
			if (!_hooked && !(ApeGamesManager.Instance == null))
			{
				_hooked = true;
				ApeGamesManager.Instance.OnPropsChanged += OnPropsChanged;
				ApeGamesManager.Instance.OnLocalEliminated += OnLocalEliminated;
				ApeGamesManager.Instance.OnRoundStartedEvent += OnRoundStarted;
			}
		}

		private void Unhook()
		{
			if (_hooked)
			{
				_hooked = false;
				if (!(ApeGamesManager.Instance == null))
				{
					ApeGamesManager.Instance.OnPropsChanged -= OnPropsChanged;
					ApeGamesManager.Instance.OnLocalEliminated -= OnLocalEliminated;
					ApeGamesManager.Instance.OnRoundStartedEvent -= OnRoundStarted;
				}
			}
		}

		private void OnPropsChanged(AgRoundProperties p)
		{
			EvaluateFromProps(p);
			if (IsListeningToAlive)
			{
				ApplySpectateVolumes();
			}
		}

		private void OnLocalEliminated()
		{
			_localElimLatch = true;
			SetDesiredGroup(2);
		}

		private void OnRoundStarted(int round, AgRoundProperties p)
		{
			if (p != null && PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null && p.AliveContains(PhotonNetwork.LocalPlayer.ActorNumber))
			{
				_localElimLatch = false;
			}
			EvaluateFromProps(p);
		}

		public override void OnJoinedRoom()
		{
			_localElimLatch = false;
			if (AgProps.TryRead(out var p))
			{
				EvaluateFromProps(p);
			}
			else
			{
				SetDesiredGroup(0);
			}
		}

		public override void OnLeftRoom()
		{
			ResetToBroadcast(false);
		}

		private void EvaluateFromProps(AgRoundProperties p)
		{
			if (p == null || !PhotonNetwork.InRoom || p.queue != "ApeGames" || p.phase == AgPhase.MatchEnd || p.phase == AgPhase.Idle)
			{
				_localElimLatch = false;
				SetDesiredGroup(0);
			}
			else if (p.phase == AgPhase.LobbyWait)
			{
				_localElimLatch = false;
				SetDesiredGroup(1);
			}
			else
			{
				SetDesiredGroup((byte)((!_localElimLatch && PhotonNetwork.LocalPlayer != null && p.AliveContains(PhotonNetwork.LocalPlayer.ActorNumber)) ? 1 : 2));
			}
		}

		private void SetDesiredGroup(byte group)
		{
			if (group != 2)
			{
				if (IsListeningToAlive)
				{
					StopListening();
				}
				if (group == 0 && _volumesTouched)
				{
					RestoreVolumes();
				}
			}
			if (_desiredGroup != group)
			{
				_desiredGroup = group;
				_groupDirty = true;
			}
			TryApplyGroup();
		}

		private void TryApplyGroup()
		{
			if (!_groupDirty && _appliedGroup == _desiredGroup)
			{
				return;
			}
			PunVoiceClient punVoiceClient = ResolveVoiceClient();
			if (punVoiceClient == null)
			{
				return;
			}
			if (punVoiceClient.PrimaryRecorder != null)
			{
				punVoiceClient.PrimaryRecorder.InterestGroup = _desiredGroup;
			}
			if (punVoiceClient.Client != null && punVoiceClient.Client.InRoom)
			{
				byte[] groupsToAdd = ((_desiredGroup == 0) ? null : ((_desiredGroup != 2) ? AliveOnly : (IsListeningToAlive ? RestAndAlive : RestOnly)));
				if (punVoiceClient.Client.LoadBalancingPeer.OpChangeGroups(NoGroups, groupsToAdd))
				{
					_groupDirty = false;
					_appliedGroup = _desiredGroup;
					_listenSubscribed = IsListeningToAlive && _desiredGroup == 2;
				}
			}
		}

		public void SetListenToAlive(bool on, int watchedActor, AgSpectateViewport owner = null)
		{
			_watchedActor = watchedActor;
			if (on == IsListeningToAlive)
			{
				if (on)
				{
					_listenOwner = owner;
					ApplySpectateVolumes();
				}
			}
			else if (!on)
			{
				StopListening();
			}
			else if (_desiredGroup == 2)
			{
				_listenOwner = owner;
				IsListeningToAlive = true;
				PunVoiceClient punVoiceClient = VoiceReady();
				if (punVoiceClient != null && punVoiceClient.Client.LoadBalancingPeer.OpChangeGroups(null, AliveOnly))
				{
					_listenSubscribed = true;
				}
				ApplySpectateVolumes();
			}
		}

		public void SetWatchedActor(AgSpectateViewport source, int actor)
		{
			if (!IsListeningToAlive || !(source != _listenOwner))
			{
				_watchedActor = actor;
				if (IsListeningToAlive)
				{
					ApplySpectateVolumes();
				}
			}
		}

		private void StopListening()
		{
			if (IsListeningToAlive)
			{
				IsListeningToAlive = false;
				_listenOwner = null;
				_listenSubscribed = false;
				PunVoiceClient punVoiceClient = VoiceReady();
				if (punVoiceClient != null)
				{
					punVoiceClient.Client.LoadBalancingPeer.OpChangeGroups(AliveOnly, null);
				}
				RestoreVolumes();
			}
		}

		private void ApplySpectateVolumes()
		{
			if (ApeGamesManager.Instance == null)
			{
				return;
			}
			AgRoundProperties props = ApeGamesManager.Instance.Props;
			AgNetSync.CollectAll(_avatars);
			for (int i = 0; i < _avatars.Count; i++)
			{
				AgNetSync agNetSync = _avatars[i];
				if (agNetSync == null || agNetSync.IsMine)
				{
					continue;
				}
				AudioSource voiceSource = agNetSync.VoiceSource;
				if (!(voiceSource == null))
				{
					int actorNumber = agNetSync.ActorNumber;
					bool flag = props != null && props.AliveContains(actorNumber) && actorNumber != _watchedActor;
					voiceSource.volume = (flag ? 0f : 1f);
				}
			}
			_volumesTouched = true;
		}

		private void RestoreVolumes()
		{
			_volumesTouched = false;
			AgNetSync.CollectAll(_avatars);
			for (int i = 0; i < _avatars.Count; i++)
			{
				AgNetSync agNetSync = _avatars[i];
				if (!(agNetSync == null) && !agNetSync.IsMine)
				{
					AudioSource voiceSource = agNetSync.VoiceSource;
					if (voiceSource != null)
					{
						voiceSource.volume = 1f;
					}
				}
			}
		}

		private void Update()
		{
			if (Time.unscaledTime < _nextTick)
			{
				return;
			}
			_nextTick = Time.unscaledTime + TickInterval;
			TryApplyGroup();
			if (!IsListeningToAlive)
			{
				return;
			}
			if (!_listenSubscribed)
			{
				PunVoiceClient punVoiceClient = VoiceReady();
				if (punVoiceClient != null && punVoiceClient.Client.LoadBalancingPeer.OpChangeGroups(null, AliveOnly))
				{
					_listenSubscribed = true;
				}
			}
			ApplySpectateVolumes();
		}

		private void ResetToBroadcast(bool allowFind = true)
		{
			IsListeningToAlive = false;
			_listenOwner = null;
			_listenSubscribed = false;
			_watchedActor = -1;
			_localElimLatch = false;
			_desiredGroup = 0;
			_groupDirty = true;
			PunVoiceClient punVoiceClient = ResolveVoiceClient(allowFind);
			if (punVoiceClient != null && punVoiceClient.PrimaryRecorder != null)
			{
				punVoiceClient.PrimaryRecorder.InterestGroup = 0;
			}
			if (punVoiceClient != null && punVoiceClient.Client != null && punVoiceClient.Client.InRoom && punVoiceClient.Client.LoadBalancingPeer.OpChangeGroups(NoGroups, null))
			{
				_appliedGroup = 0;
				_groupDirty = false;
			}
			RestoreVolumes();
		}

		private PunVoiceClient VoiceReady()
		{
			PunVoiceClient punVoiceClient = ResolveVoiceClient();
			if (punVoiceClient == null)
			{
				return null;
			}
			if (punVoiceClient.Client == null || !punVoiceClient.Client.InRoom)
			{
				return null;
			}
			return punVoiceClient;
		}
	}
}
