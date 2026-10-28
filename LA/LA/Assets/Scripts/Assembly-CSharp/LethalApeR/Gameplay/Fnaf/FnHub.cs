using System;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(-140)]
	public class FnHub : MonoBehaviourPunCallbacks
	{
		private float[] _lockedAt = new float[0];

		[Tooltip("Pad index = wire id (a contract scene table): keep the order stable once shipped.")]
		public FnPad[] pads = new FnPad[0];

		private FnPadState[] _view = new FnPadState[0];

		private FnPadState[] _auth;

		public static FnHub Instance { get; private set; }

		private static FnSettings S => FnGame.Settings;

		public bool IsAuthority => _auth != null && PhotonNetwork.IsMasterClient;

		public bool InHubRoom => FnGame.Instance != null && FnGame.Instance.RoomKind == FnRoomKind.Hub;

		public int PadCount => (pads != null) ? pads.Length : 0;

		public int LocalPad
		{
			get
			{
				int localActor = FnGame.LocalActor;
				for (int i = 0; i < PadCount; i++)
				{
					if (Pad(i).Contains(localActor))
					{
						return i;
					}
				}
				return -1;
			}
		}

		public event Action Changed;

		public event Action<FnRpc, FnReject, int> Rejected;

		public void DebugFillPad(int pad, bool ready)
		{
			if (!PhotonNetwork.IsMasterClient || pad < 0 || pad >= PadCount)
			{
				return;
			}
			if (_auth == null || _auth.Length != PadCount)
			{
				SeedAuthority();
			}
			FnPadState p = _auth[pad];
			int fake = -2;
			for (int i = 0; i < PadSize(pad); i++)
			{
				if (p.Occupant(i) == 0)
				{
					p.SetOccupant(i, fake--);
				}
				if (ready && p.Occupant(i) < 0)
				{
					p.SetReady(i, ready: true);
				}
			}
			_auth[pad] = p;
			StartIfSet(pad);
			Push(pad);
		}

		public void DebugClearPad(int pad)
		{
			if (PhotonNetwork.IsMasterClient && pad >= 0 && pad < PadCount)
			{
				if (_auth == null || _auth.Length != PadCount)
				{
					SeedAuthority();
				}
				_auth[pad] = default(FnPadState);
				Push(pad);
			}
		}

		public void DebugSetDifficulty(int pad, FnDifficulty difficulty)
		{
			if (PhotonNetwork.IsMasterClient && pad >= 0 && pad < PadCount)
			{
				if (_auth == null || _auth.Length != PadCount)
				{
					SeedAuthority();
				}
				if (!_auth[pad].Locked)
				{
					SetDifficulty(pad, difficulty);
					Push(pad);
				}
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			_auth = null;
		}

		private void SeedAuthority()
		{
			_auth = (FnPadState[])_view.Clone();
			_lockedAt = new float[PadCount];
			Room currentRoom = PhotonNetwork.CurrentRoom;
			for (int i = 0; i < _auth.Length; i++)
			{
				FnPadState before = _auth[i];
				for (int s = 2; s >= 0; s--)
				{
					int actor = _auth[i].Occupant(s);
					if (actor != 0 && currentRoom?.GetPlayer(actor) == null)
					{
						_auth[i].Remove(actor);
					}
				}
				if (_auth[i].Locked)
				{
					_lockedAt[i] = Time.time;
				}
				else if (_auth[i].Count > 0)
				{
					DropLockedNightmare(i);
					ClampNight(i);
				}
				if (!_auth[i].SameAs(before))
				{
					Push(i);
				}
			}
		}

		private void MasterTick()
		{
			if (FnProps.CurrentRoomKind() != FnRoomKind.Hub)
			{
				return;
			}
			if (_auth == null || _auth.Length != PadCount)
			{
				SeedAuthority();
			}
			for (int i = 0; i < _auth.Length; i++)
			{
				FnPadState p = _auth[i];
				if (p.Locked)
				{
					if (!(Time.time - _lockedAt[i] < S.hub.lockTimeoutSeconds))
					{
						_auth[i] = default(FnPadState);
						Push(i);
					}
				}
				else if (p.Counting)
				{
					if (!AllSet(i))
					{
						p.ClearReadies();
						p.Deadline = 0;
						_auth[i] = p;
						Push(i);
					}
					else if (FnClock.MsUntil(p.Deadline) <= 0)
					{
						Migrate(i);
					}
				}
			}
		}

		private bool AllSet(int pad)
		{
			FnPadState fnPadState = _auth[pad];
			int num = PadSize(pad);
			if (fnPadState.Count >= num)
			{
				return fnPadState.ReadyCount >= num;
			}
			return false;
		}

		private bool AcceptPad(PhotonMessageInfo info, object[] a, out int pad, out int actor)
		{
			pad = ((a.Length != 0) ? FnNet.B(a[0]) : (-1));
			actor = info.Sender?.ActorNumber ?? 0;
			if (!InHubRoom || !PhotonNetwork.IsMasterClient || pad < 0 || pad >= PadCount || actor == 0)
			{
				return false;
			}
			if (_auth == null || _auth.Length != PadCount)
			{
				SeedAuthority();
			}
			return true;
		}

		private void OnPadClaim(object[] a, PhotonMessageInfo info)
		{
			if (!AcceptPad(info, a, out var pad, out var actor))
			{
				return;
			}
			FnPadState p = _auth[pad];
			if (p.Contains(actor))
			{
				return;
			}
			if (p.Locked)
			{
				Refuse(actor, FnRpc.PadClaim, FnReject.Locked, pad);
				return;
			}
			int count = p.Count;
			if (count >= PadSize(pad))
			{
				Refuse(actor, FnRpc.PadClaim, FnReject.Full, pad);
				return;
			}
			if (p.Difficulty == FnDifficulty.Nightmare && !FnProgress.NightmareUnlocked(info.Sender))
			{
				Refuse(actor, FnRpc.PadClaim, FnReject.DifficultyLocked, pad);
				return;
			}
			for (int i = 0; i < _auth.Length; i++)
			{
				if (i != pad && _auth[i].Contains(actor) && !_auth[i].Locked)
				{
					RemoveFrom(i, actor);
				}
			}
			p.Add(actor, PadSize(pad));
			_auth[pad] = p;
			if (count == 0)
			{
				_auth[pad].Night = MaxNightFor(_auth[pad]);
			}
			ClampNight(pad);
			Push(pad);
		}

		private void OnPadRelease(object[] a, PhotonMessageInfo info)
		{
			if (AcceptPad(info, a, out var pad, out var actor) && _auth[pad].Contains(actor) && !_auth[pad].Locked)
			{
				RemoveFrom(pad, actor);
			}
		}

		private void OnPadReady(object[] a, PhotonMessageInfo info)
		{
			if (!AcceptPad(info, a, out var pad, out var actor) || a.Length < 2)
			{
				return;
			}
			FnPadState p = _auth[pad];
			int slot = p.SlotOf(actor);
			if (slot >= 0 && !p.Locked)
			{
				if (FnNet.Bool(a[1]))
				{
					p.SetReady(slot, ready: true);
				}
				else
				{
					p.ClearReadies();
					p.Deadline = 0;
				}
				_auth[pad] = p;
				StartIfSet(pad);
				Push(pad);
			}
		}

		private void OnPadNight(object[] a, PhotonMessageInfo info)
		{
			if (!AcceptPad(info, a, out var pad, out var actor) || a.Length < 2)
			{
				return;
			}
			FnPadState p = _auth[pad];
			if (!p.Contains(actor) || p.Locked)
			{
				return;
			}
			int night = FnNet.B(a[1]);
			if (night < 1 || night > MaxNightFor(p))
			{
				Refuse(actor, FnRpc.PadNight, FnReject.NightLocked, pad);
			}
			else if (p.Night != night)
			{
				p.Night = night;
				p.ClearReadies();
				p.Deadline = 0;
				_auth[pad] = p;
				Push(pad);
			}
		}

		private void OnPadDifficulty(object[] a, PhotonMessageInfo info)
		{
			if (!AcceptPad(info, a, out var pad, out var actor) || a.Length < 2)
			{
				return;
			}
			FnPadState p = _auth[pad];
			if (!p.Contains(actor) || p.Locked)
			{
				return;
			}
			FnDifficulty difficulty = (FnDifficulty)FnNet.B(a[1]);
			if (difficulty > FnDifficulty.Nightmare)
			{
				Refuse(actor, FnRpc.PadDifficulty, FnReject.Invalid, pad);
			}
			else if (p.Difficulty != difficulty)
			{
				if (difficulty == FnDifficulty.Nightmare && !NightmareOpen(p))
				{
					Refuse(actor, FnRpc.PadDifficulty, FnReject.DifficultyLocked, pad);
					return;
				}
				SetDifficulty(pad, difficulty);
				ClampNight(pad);
				Push(pad);
			}
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (!IsAuthority)
			{
				return;
			}
			for (int i = 0; i < _auth.Length; i++)
			{
				int actorNumber = otherPlayer.ActorNumber;
				if (!_auth[i].Contains(actorNumber))
				{
					continue;
				}
				if (!_auth[i].Locked)
				{
					RemoveFrom(i, actorNumber);
					continue;
				}
				_auth[i].Remove(actorNumber);
				if (_auth[i].Count == 0)
				{
					_auth[i] = default(FnPadState);
				}
				Push(i);
			}
		}

		private void MasterRecheckProgress(int actor)
		{
			for (int i = 0; i < _auth.Length; i++)
			{
				if (_auth[i].Contains(actor) && !_auth[i].Locked && (DropLockedNightmare(i) | ClampNight(i)))
				{
					Push(i);
				}
			}
		}

		private void RemoveFrom(int pad, int actor)
		{
			FnPadState p = _auth[pad];
			if (p.Remove(actor))
			{
				p.ClearReadies();
				p.Deadline = 0;
				_auth[pad] = p;
				ClampNight(pad);
				Push(pad);
			}
		}

		private bool ClampNight(int pad)
		{
			FnPadState p = _auth[pad];
			if (p.Count == 0)
			{
				return false;
			}
			int max = MaxNightFor(p);
			if (p.Night <= max)
			{
				return false;
			}
			p.Night = max;
			p.ClearReadies();
			p.Deadline = 0;
			_auth[pad] = p;
			return true;
		}

		private void SetDifficulty(int pad, FnDifficulty difficulty)
		{
			_auth[pad].Difficulty = difficulty;
			_auth[pad].ClearReadies();
			_auth[pad].Deadline = 0;
		}

		private bool DropLockedNightmare(int pad)
		{
			if (_auth[pad].Difficulty != FnDifficulty.Nightmare || NightmareOpen(_auth[pad]))
			{
				return false;
			}
			SetDifficulty(pad, FnDifficulty.Default);
			return true;
		}

		private void StartIfSet(int pad)
		{
			if (!_auth[pad].Counting && AllSet(pad))
			{
				_auth[pad].Deadline = FnClock.DeadlineIn((int)Math.Round(S.hub.countdownSeconds * 1000f));
			}
		}

		private void Migrate(int pad)
		{
			FnPadState p = _auth[pad];
			int size = PadSize(pad);
			int[] actors = new int[size];
			string[] names = new string[size];
			for (int i = 0; i < size; i++)
			{
				actors[i] = p.Occupant(i);
				Player player = FnGame.PlayerOf(actors[i]);
				names[i] = ((player != null) ? player.NickName : "");
			}
			string room = FnConst.NightRoomPrefix + Guid.NewGuid().ToString("N").Substring(0, 8).ToUpperInvariant();
			p.Locked = true;
			p.Deadline = 0;
			_auth[pad] = p;
			_lockedAt[pad] = Time.time;
			Push(pad);
			int night = p.Night;
			FnDifficulty difficulty = p.Difficulty;
			Debug.Log(string.Format("[FnHub] Pad {0}: night {1} ({2}) for {3} -> {4}.", pad, night, difficulty, size, room));
			FnNet.ToActorsList(Array.FindAll(actors, (int a) => a > 0), FnRpc.MoveToNight, room, (byte)night, (byte)size, names, (byte)difficulty);
		}

		private void Push(int pad)
		{
			Settle(pad);
			Hashtable hashtable = new Hashtable();
			hashtable[FnProps.PadKey(pad)] = _auth[pad].ToWire();
			FnProps.WriteRoom(hashtable);
			this.Changed?.Invoke();
		}

		private void Settle(int pad)
		{
			if (_auth[pad].Count == 0)
			{
				_auth[pad].ClearReadies();
				_auth[pad].Locked = false;
				_auth[pad].Difficulty = FnDifficulty.Default;
				_auth[pad].Deadline = 0;
			}
		}

		private static void Refuse(int actor, FnRpc request, FnReject reason, int pad)
		{
			FnNet.ToActor(actor, FnRpc.Rejected, (byte)request, (byte)reason, (byte)pad);
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		public FnPadState Pad(int index)
		{
			FnPadState[] array = (IsAuthority ? _auth : _view);
			if (index < 0 || index >= array.Length)
			{
				return default(FnPadState);
			}
			return array[index];
		}

		public int PadSize(int index)
		{
			if (index < 0 || index >= PadCount || pads[index] == null)
			{
				return 1;
			}
			return Mathf.Clamp(pads[index].size, 1, 3);
		}

		public int MaxNightFor(FnPadState pad)
		{
			int maxNight = S.hub.maxNight;
			int best = maxNight;
			for (int i = 0; i < 3; i++)
			{
				Player player = OccupantPlayer(pad, i);
				if (player != null)
				{
					best = Mathf.Min(best, Mathf.Clamp(FnProgress.HighestOf(player, pad.Difficulty) + 1, 1, maxNight));
				}
			}
			return Mathf.Max(1, best);
		}

		public bool NightmareOpen(FnPadState pad)
		{
			for (int i = 0; i < 3; i++)
			{
				Player player = OccupantPlayer(pad, i);
				if (player != null && !FnProgress.NightmareUnlocked(player))
				{
					return false;
				}
			}
			return true;
		}

		private static Player OccupantPlayer(FnPadState pad, int slot)
		{
			int num = pad.Occupant(slot);
			if (num == 0)
			{
				return null;
			}
			return FnGame.PlayerOf(num);
		}

		private void Awake()
		{
			Instance = this;
			_view = new FnPadState[PadCount];
			for (int i = 0; i < PadCount; i++)
			{
				if (pads[i] != null)
				{
					pads[i].Bind(this, i);
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

		public override void OnEnable()
		{
			base.OnEnable();
			FnNet.On(FnRpc.PadClaim, OnPadClaim);
			FnNet.On(FnRpc.PadRelease, OnPadRelease);
			FnNet.On(FnRpc.PadReady, OnPadReady);
			FnNet.On(FnRpc.PadNight, OnPadNight);
			FnNet.On(FnRpc.PadDifficulty, OnPadDifficulty);
			FnNet.On(FnRpc.Rejected, OnRejected);
			ReadAll();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			FnNet.Off(FnRpc.PadClaim, OnPadClaim);
			FnNet.Off(FnRpc.PadRelease, OnPadRelease);
			FnNet.Off(FnRpc.PadReady, OnPadReady);
			FnNet.Off(FnRpc.PadNight, OnPadNight);
			FnNet.Off(FnRpc.PadDifficulty, OnPadDifficulty);
			FnNet.Off(FnRpc.Rejected, OnRejected);
			_auth = null;
		}

		public override void OnJoinedRoom()
		{
			_auth = null;
			ReadAll();
		}

		public override void OnLeftRoom()
		{
			_auth = null;
			for (int i = 0; i < _view.Length; i++)
			{
				_view[i] = default(FnPadState);
			}
			this.Changed?.Invoke();
		}

		public override void OnRoomPropertiesUpdate(Hashtable changed)
		{
			bool flag = false;
			for (int i = 0; i < PadCount; i++)
			{
				string key = FnProps.PadKey(i);
				if (changed.ContainsKey(key))
				{
					_view[i] = FnPadState.FromWire(changed[key] as int[]);
					flag = true;
				}
			}
			if (flag)
			{
				this.Changed?.Invoke();
			}
		}

		public override void OnPlayerPropertiesUpdate(Player target, Hashtable changed)
		{
			bool flag = changed.ContainsKey(FnProps.Highest) || changed.ContainsKey(FnProps.HighestNightmare);
			if (flag || changed.ContainsKey(FnProps.Build) || changed.ContainsKey("Username"))
			{
				this.Changed?.Invoke();
			}
			if (IsAuthority && flag)
			{
				MasterRecheckProgress(target.ActorNumber);
			}
		}

		private void ReadAll()
		{
			if (_view.Length != PadCount)
			{
				_view = new FnPadState[PadCount];
			}
			Hashtable roomProps = FnProps.RoomProps;
			bool flag = FnProps.CurrentRoomKind() == FnRoomKind.Hub && roomProps != null;
			for (int i = 0; i < PadCount; i++)
			{
				_view[i] = (flag ? FnPadState.FromWire(roomProps[FnProps.PadKey(i)] as int[]) : default(FnPadState));
			}
			this.Changed?.Invoke();
		}

		public void RequestClaim(int pad)
		{
			FnNet.ToMasterClient(FnRpc.PadClaim, (byte)pad);
		}

		public void RequestRelease(int pad)
		{
			FnNet.ToMasterClient(FnRpc.PadRelease, (byte)pad);
		}

		public void RequestReady(int pad, bool ready)
		{
			FnNet.ToMasterClient(FnRpc.PadReady, (byte)pad, ready);
		}

		public void RequestNight(int pad, int night)
		{
			FnNet.ToMasterClient(FnRpc.PadNight, (byte)pad, (byte)Mathf.Clamp(night, 0, 15));
		}

		public void RequestDifficulty(int pad, FnDifficulty difficulty)
		{
			FnNet.ToMasterClient(FnRpc.PadDifficulty, (byte)pad, (byte)difficulty);
		}

		private void OnRejected(object[] a, PhotonMessageInfo info)
		{
			if (info.Sender != null && (info.Sender.IsMasterClient || info.Sender.IsLocal) && a.Length >= 3)
			{
				FnRpc request = (FnRpc)FnNet.B(a[0]);
				FnReject reason = (FnReject)FnNet.B(a[1]);
				byte b = FnNet.B(a[2]);
				this.Rejected?.Invoke(request, reason, b);
				if (b < PadCount && pads[b] != null)
				{
					pads[b].OnRefused(request, reason);
				}
			}
		}

		private void Update()
		{
			if (InHubRoom)
			{
				if (PhotonNetwork.IsMasterClient)
				{
					MasterTick();
				}
				else if (_auth != null)
				{
					_auth = null;
				}
			}
		}
	}
}
