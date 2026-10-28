using System;
using System.Collections.Generic;
using QauthSdk;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Social.UI
{
	public sealed class FriendsAdapter : ISocialListAdapter
	{
		private enum RowType
		{
			Request = 0,
			Friend = 1,
			Sent = 2,
			Blocked = 3
		}

		private struct Item
		{
			public int Kind;

			public string Title;

			public int Count;

			public RowType Type;

			public FriendInfo Friend;

			public string Id;

			public string Name;
		}

		public const int KindRow = 0;

		public const int KindHeader = 1;

		public const int KindNote = 2;

		private const float ConfirmSeconds = 3f;

		private const float FeedbackSeconds = 2.5f;

		private const float JoiningSeconds = 8f;

		private readonly SocialListView _list;

		private readonly List<Item> _items = new List<Item>(64);

		private readonly Dictionary<string, float> _confirmUntil = new Dictionary<string, float>(StringComparer.Ordinal);

		private readonly Dictionary<string, (string text, float until)> _joinState = new Dictionary<string, (string text, float until)>(StringComparer.Ordinal);

		private readonly List<string> _expired = new List<string>(4);

		private readonly Action<PlayerRowView, int> _onButton;

		private int _friendsVersion = -1;

		private int _rosterVersion = -1;

		private bool _dirty = true;

		private bool _attached;

		public int Count => _items.Count;

		public int OnlineCount { get; private set; }

		public FriendsAdapter(SocialListView list)
		{
			_list = list;
			_onButton = OnButton;
		}

		public int KindOf(int index)
		{
			return _items[index].Kind;
		}

		public void Attach()
		{
			if (!_attached)
			{
				_attached = true;
				BlockList.Changed += MarkDirty;
				_list.SetAdapter(this);
				_dirty = true;
				FriendsService.Instance?.RefreshSoon();
			}
		}

		public void Detach()
		{
			if (_attached)
			{
				_attached = false;
				BlockList.Changed -= MarkDirty;
			}
		}

		private void MarkDirty()
		{
			_dirty = true;
		}

		public void Tick()
		{
			SocialRoster.Tick();
			FriendsService service = FriendsService.Instance;
			int version = ((service != null) ? service.Version : (-1));
			if (version != _friendsVersion || SocialRoster.Version != _rosterVersion || _dirty)
			{
				_friendsVersion = version;
				_rosterVersion = SocialRoster.Version;
				_dirty = false;
				BuildItems(service);
				_list.Refresh();
			}
			Expire();
		}

		private void Expire()
		{
			if (_confirmUntil.Count == 0 && _joinState.Count == 0)
			{
				return;
			}
			float now = Time.unscaledTime;
			_expired.Clear();
			foreach (KeyValuePair<string, float> pair in _confirmUntil)
			{
				if (!(now < pair.Value))
				{
					_expired.Add(pair.Key);
				}
			}
			for (int i = 0; i < _expired.Count; i++)
			{
				_confirmUntil.Remove(_expired[i]);
			}
			bool confirmsExpired = _expired.Count > 0;
			_expired.Clear();
			foreach (KeyValuePair<string, (string text, float until)> pair2 in _joinState)
			{
				if (!(now < pair2.Value.until))
				{
					_expired.Add(pair2.Key);
				}
			}
			for (int j = 0; j < _expired.Count; j++)
			{
				_joinState.Remove(_expired[j]);
			}
			if (confirmsExpired || _expired.Count > 0)
			{
				_list.Rebind();
			}
		}

		private void BuildItems(FriendsService service)
		{
			_items.Clear();
			OnlineCount = 0;
			if (service == null || !Qauth.IsLoggedIn)
			{
				Note("SIGNING IN");
			}
			else if (!service.Available)
			{
				Note("FRIENDS ARE OFFLINE RIGHT NOW");
			}
			else if (!service.Ready)
			{
				Note("LOADING FRIENDS");
			}
			else
			{
				if (service.Incoming.Count > 0)
				{
					Header("REQUESTS", service.Incoming.Count);
					foreach (FriendInfo f in service.Incoming)
					{
						Row(RowType.Request, f);
					}
				}
				int online = 0;
				foreach (FriendInfo f2 in service.Friends)
				{
					if (f2.Online || SocialRoster.Find(f2.Id) != null)
					{
						online++;
					}
				}
				OnlineCount = online;
				if (service.Friends.Count == 0 && service.Incoming.Count == 0 && service.Outgoing.Count == 0)
				{
					Note("NO FRIENDS YET. ADD PEOPLE FROM THE LEADERBOARD TAB.");
				}
				else if (service.Friends.Count > 0)
				{
					Header("ONLINE", online);
					foreach (FriendInfo f3 in service.Friends)
					{
						if (f3.Online || SocialRoster.Find(f3.Id) != null)
						{
							Row(RowType.Friend, f3);
						}
					}
					int offline = service.Friends.Count - online;
					if (offline > 0)
					{
						Header("OFFLINE", offline);
						foreach (FriendInfo f4 in service.Friends)
						{
							if (!f4.Online && SocialRoster.Find(f4.Id) == null)
							{
								Row(RowType.Friend, f4);
							}
						}
					}
				}
				if (service.Outgoing.Count > 0)
				{
					Header("SENT", service.Outgoing.Count);
					foreach (FriendInfo f5 in service.Outgoing)
					{
						Row(RowType.Sent, f5);
					}
				}
			}
			int blocked = BlockList.Count;
			if (blocked > 0)
			{
				Header("BLOCKED", blocked);
				for (int i = 0; i < blocked; i++)
				{
					_items.Add(new Item
					{
						Kind = 0,
						Type = RowType.Blocked,
						Id = BlockList.IdAt(i),
						Name = BlockList.NameAt(i)
					});
				}
			}
		}

		private void Note(string text)
		{
			_items.Add(new Item
			{
				Kind = 2,
				Title = text,
				Count = -1
			});
		}

		private void Header(string title, int count)
		{
			_items.Add(new Item
			{
				Kind = 1,
				Title = title,
				Count = count
			});
		}

		private void Row(RowType type, FriendInfo f)
		{
			_items.Add(new Item
			{
				Kind = 0,
				Type = type,
				Friend = f,
				Id = f.Id,
				Name = f.Name
			});
		}

		public void Bind(SocialListItem view, int index)
		{
			Item item = _items[index];
			if (item.Kind != 0)
			{
				((SectionRowView)view).Set(item.Title, item.Count);
				return;
			}
			PlayerRowView row = (PlayerRowView)view;
			row.ButtonPressed = _onButton;
			row.BoundId = item.Id;
			row.BoundName = item.Name;
			row.BoundIndex = index;
			row.SetTag(null);
			row.SetInfo(null, null);
			row.SetTalkingSlot(false);
			row.HideButton(0);
			RosterEntry entry = SocialRoster.Find(item.Id);
			Color colour = ((entry != null) ? entry.Colour : ((item.Friend != null) ? item.Friend.Colour : SocialStyle.TextOff));
			switch (item.Type)
			{
			case RowType.Request:
				row.SetIdentity(item.Name, colour, 1f);
				row.SetSub("WANTS TO BE FRIENDS", SocialStyle.White);
				row.SetButton(1, "ACCEPT", ButtonLook.Primary);
				row.SetButton(2, "DECLINE", ButtonLook.Normal);
				break;
			case RowType.Sent:
				row.SetIdentity(item.Name, colour, 1f);
				row.SetSub("PENDING", SocialStyle.TextFaint);
				row.HideButton(1);
				row.SetButton(2, "CANCEL", ButtonLook.Normal);
				break;
			case RowType.Blocked:
				row.SetIdentity(item.Name, SocialStyle.TextOff, 0.4f);
				row.SetSub("HIDDEN + MUTED", SocialStyle.Offline);
				row.HideButton(1);
				row.SetButton(2, "UNBLOCK", ButtonLook.Normal);
				break;
			default:
				BindFriend(row, item.Friend, entry != null, colour);
				break;
			}
			row.Commit();
		}

		private void BindFriend(PlayerRowView row, FriendInfo f, bool inLobby, Color colour)
		{
			bool offline = !inLobby && !f.Online;
			row.SetIdentity(f.Name, colour, offline ? 0.45f : 1f);
			int scene = SceneManager.GetActiveScene().buildIndex;
			string text;
			Color dot;
			if (offline)
			{
				text = "OFFLINE";
				dot = SocialStyle.Offline;
			}
			else if (f.Online && f.Status == PresenceStatus.Away)
			{
				text = "AWAY";
				dot = SocialStyle.Away;
			}
			else
			{
				text = "ONLINE";
				dot = SocialStyle.Online;
			}
			row.SetSub(text, dot, !offline);
			if (inLobby)
			{
				row.SetButton(1, "HERE", ButtonLook.Disabled);
			}
			else if (_joinState.TryGetValue(f.Id, out (string text, float until) state))
			{
				row.SetButton(1, state.text, ButtonLook.Disabled);
			}
			else
			{
				bool canJoin = f.Online && f.Joinable && f.SceneIndex == scene;
				row.SetButton(1, "JOIN", canJoin ? ButtonLook.Primary : ButtonLook.Disabled);
			}
			bool confirming = _confirmUntil.TryGetValue(f.Id, out float until) && Time.unscaledTime < until;
			row.SetButton(2, confirming ? "SURE?" : "REMOVE", confirming ? ButtonLook.Confirm : ButtonLook.Normal);
		}

		private void OnButton(PlayerRowView row, int button)
		{
			int index = row.BoundIndex;
			if (index < 0 || index >= _items.Count || _items[index].Id != row.BoundId)
			{
				return;
			}
			Item item = _items[index];
			string id = item.Id;
			FriendsService service = FriendsService.Instance;
			switch (item.Type)
			{
			case RowType.Request:
				if (service == null)
				{
					return;
				}
				if (button == 2)
				{
					service.Decline(id);
				}
				else if (button == 1)
				{
					service.Accept(id);
				}
				break;
			case RowType.Sent:
				if (button == 2)
				{
					service?.Remove(id);
				}
				break;
			case RowType.Blocked:
				if (button == 2)
				{
					BlockList.Unblock(id);
				}
				break;
			default:
				if (button == 2)
				{
					if (_confirmUntil.TryGetValue(id, out float until) && Time.unscaledTime < until)
					{
						_confirmUntil.Remove(id);
						service?.Remove(id);
					}
					else
					{
						_confirmUntil[id] = Time.unscaledTime + 3f;
					}
				}
				else if (button == 1 && service != null)
				{
					_joinState[id] = ("JOINING", Time.unscaledTime + 8f);
					service.Join(id, delegate(JoinOutcome outcome)
					{
						if (outcome != JoinOutcome.Joining)
						{
							_joinState[id] = (Describe(outcome), Time.unscaledTime + 2.5f);
							_list.Rebind();
						}
					});
				}
				break;
			}
			_list.Rebind();
		}

		private static string Describe(JoinOutcome outcome)
		{
			switch (outcome)
			{
			case JoinOutcome.Offline:
				return "OFFLINE";
			case JoinOutcome.NotJoinable:
				return "LOCKED";
			case JoinOutcome.OtherMode:
				return "OTHER MODE";
			case JoinOutcome.RoomGone:
				return "CAN'T JOIN";
			default:
				return "TRY AGAIN";
			}
		}
	}
}
