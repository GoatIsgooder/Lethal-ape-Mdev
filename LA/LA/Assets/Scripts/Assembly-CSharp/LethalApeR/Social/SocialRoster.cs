using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Social
{
	public static class SocialRoster
	{
		private const float CheckInterval = 0.5f;

		private static readonly List<RosterEntry> Entries = new List<RosterEntry>(32);

		private static readonly List<RosterEntry> Pool = new List<RosterEntry>(32);

		private static readonly List<MonkeDevNetworkingPlayer> Scratch = new List<MonkeDevNetworkingPlayer>(32);

		private static float _nextCheck;

		private static int _signature;

		private static bool _dirty = true;

		public static int Version { get; private set; }

		public static IReadOnlyList<RosterEntry> Current
		{
			get
			{
				Tick();
				return Entries;
			}
		}

		public static int PlayerCount
		{
			get
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
				{
					return 0;
				}
				return PhotonNetwork.CurrentRoom.PlayerCount;
			}
		}

		public static int Capacity
		{
			get
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
				{
					return 0;
				}
				return PhotonNetwork.CurrentRoom.MaxPlayers;
			}
		}

		public static string RoomCode
		{
			get
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
				{
					return "";
				}
				return MonkeDevNetworkingManager.SalvageDisplayCode(PhotonNetwork.CurrentRoom.Name);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Entries.Clear();
			Pool.Clear();
			_nextCheck = 0f;
			_signature = 0;
			_dirty = true;
			Version = 0;
		}

		public static void MarkDirty()
		{
			_dirty = true;
		}

		public static RosterEntry Find(string userId)
		{
			Tick();
			for (int i = 0; i < Entries.Count; i++)
			{
				if (Entries[i].UserId == userId)
				{
					return Entries[i];
				}
			}
			return null;
		}

		public static void Tick()
		{
			if (_dirty || !(Time.unscaledTime < _nextCheck))
			{
				_dirty = false;
				_nextCheck = Time.unscaledTime + 0.5f;
				Rebuild();
			}
		}

		private static void Rebuild()
		{
			for (int i = 0; i < Entries.Count; i++)
			{
				Pool.Add(Entries[i]);
			}
			Entries.Clear();
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Scratch.Clear();
			if (manager != null && PhotonNetwork.InRoom && PhotonNetwork.CurrentRoom != null)
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				for (int j = 0; j < manager.Players.Count; j++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = manager.Players[j];
					if (!(monkeDevNetworkingPlayer == null) && !(monkeDevNetworkingPlayer.photonView == null) && monkeDevNetworkingPlayer.photonView.Owner != null && currentRoom.Players.ContainsKey(monkeDevNetworkingPlayer.photonView.OwnerActorNr))
					{
						Scratch.Add(monkeDevNetworkingPlayer);
					}
				}
			}
			int num = 17;
			for (int k = 0; k < Scratch.Count; k++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer2 = Scratch[k];
				Player owner = monkeDevNetworkingPlayer2.photonView.Owner;
				RosterEntry rosterEntry = ((Pool.Count > 0) ? Pool[Pool.Count - 1] : new RosterEntry());
				if (Pool.Count > 0)
				{
					Pool.RemoveAt(Pool.Count - 1);
				}
				rosterEntry.Player = monkeDevNetworkingPlayer2;
				rosterEntry.IsLocal = monkeDevNetworkingPlayer2.photonView.IsMine;
				rosterEntry.UserId = owner.UserId ?? "";
				rosterEntry.Actor = owner.ActorNumber;
				rosterEntry.Name = SocialText.CleanName(owner.NickName);
				rosterEntry.Colour = ((rosterEntry.IsLocal && manager != null) ? manager.Colour : monkeDevNetworkingPlayer2.currentPlayerColor);
				object value;
				rosterEntry.AcceptsRequests = !owner.CustomProperties.TryGetValue("FriendRequests", out value) || !(value is bool flag) || flag;
				Entries.Add(rosterEntry);
				num = num * 31 + rosterEntry.Actor;
				num = num * 31 + StringComparer.Ordinal.GetHashCode(rosterEntry.UserId);
				num = num * 31 + rosterEntry.Colour.GetHashCode();
				num = num * 31 + (rosterEntry.AcceptsRequests ? 1 : 0);
			}
			Entries.Sort(Compare);
			if (num != _signature || (Entries.Count == 0 && Version == 0))
			{
				_signature = num;
				Version++;
			}
		}

		private static int Compare(RosterEntry a, RosterEntry b)
		{
			if (a.IsLocal != b.IsLocal)
			{
				if (!a.IsLocal)
				{
					return 1;
				}
				return -1;
			}
			return a.Actor.CompareTo(b.Actor);
		}
	}
}
