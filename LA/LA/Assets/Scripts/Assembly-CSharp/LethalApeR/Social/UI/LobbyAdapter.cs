using System;
using System.Collections.Generic;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Social.UI
{
	public sealed class LobbyAdapter : ISocialListAdapter
	{
		private const float ConfirmSeconds = 3f;

		private const float LiveInterval = 0.2f;

		private readonly SocialListView _list;

		private readonly Dictionary<string, float> _confirmUntil = new Dictionary<string, float>(StringComparer.Ordinal);

		private readonly List<SocialListItem> _views = new List<SocialListItem>(16);

		private readonly List<int> _indices = new List<int>(16);

		private readonly List<string> _expired = new List<string>(4);

		private readonly Action<PlayerRowView, int> _onButton;

		private IReadOnlyList<RosterEntry> _entries = Array.Empty<RosterEntry>();

		private int _rosterVersion = -1;

		private int _friendsVersion = -1;

		private bool _rebind;

		private float _nextLive;

		private bool _attached;

		public int Count => _entries.Count;

		public LobbyAdapter(SocialListView list)
		{
			_list = list;
			_onButton = OnButton;
		}

		public int KindOf(int index)
		{
			return 0;
		}

		public void Attach()
		{
			if (!_attached)
			{
				_attached = true;
				LocalMutes.Changed += MarkRebind;
				BlockList.Changed += MarkRebind;
				SocialPrefs.Changed += MarkRebind;
				_list.SetAdapter(this);
				_rosterVersion = -1;
			}
		}

		public void Detach()
		{
			if (_attached)
			{
				_attached = false;
				LocalMutes.Changed -= MarkRebind;
				BlockList.Changed -= MarkRebind;
				SocialPrefs.Changed -= MarkRebind;
			}
		}

		private void MarkRebind()
		{
			_rebind = true;
		}

		public void Tick()
		{
			IReadOnlyList<RosterEntry> current = SocialRoster.Current;
			int friendsVersion = ((FriendsService.Instance != null) ? FriendsService.Instance.Version : 0);
			if (SocialRoster.Version != _rosterVersion)
			{
				_entries = current;
				_rosterVersion = SocialRoster.Version;
				_friendsVersion = friendsVersion;
				_rebind = false;
				_list.Refresh();
			}
			else if (_rebind || friendsVersion != _friendsVersion)
			{
				_friendsVersion = friendsVersion;
				_rebind = false;
				_list.Rebind();
			}
			ExpireConfirms();
			if (Time.unscaledTime < _nextLive)
			{
				return;
			}
			_nextLive = Time.unscaledTime + 0.2f;
			_views.Clear();
			_indices.Clear();
			_list.CollectShown(_views, _indices);
			for (int i = 0; i < _views.Count; i++)
			{
				if (_views[i] is PlayerRowView row && _indices[i] < _entries.Count)
				{
					row.SetTalking(_entries[_indices[i]].Talking);
					if (row.PortraitPending)
					{
						row.RefreshPortrait();
					}
				}
			}
		}

		private void ExpireConfirms()
		{
			if (_confirmUntil.Count == 0)
			{
				return;
			}
			_expired.Clear();
			float now = Time.unscaledTime;
			foreach (KeyValuePair<string, float> pair in _confirmUntil)
			{
				if (!(now < pair.Value))
				{
					_expired.Add(pair.Key);
				}
			}
			if (_expired.Count != 0)
			{
				for (int i = 0; i < _expired.Count; i++)
				{
					_confirmUntil.Remove(_expired[i]);
				}
				_list.Rebind();
			}
		}

		public void Bind(SocialListItem view, int index)
		{
			PlayerRowView row = (PlayerRowView)view;
			RosterEntry entry = _entries[index];
			row.ButtonPressed = _onButton;
			row.BoundId = entry.UserId;
			row.BoundName = entry.Name;
			row.BoundIndex = index;
			bool blocked = !entry.IsLocal && BlockList.IsBlocked(entry.UserId);
			row.SetIdentity(entry.Name, entry.Colour, blocked ? 0.4f : 1f);
			row.SetPortrait(entry.Player);
			row.SetTalkingSlot(!entry.IsLocal && !blocked);
			row.SetTalking(!blocked && entry.Talking);
			if (entry.IsLocal)
			{
				PresenceStatus status = SocialPrefs.Status;
				row.SetTag("YOU");
				row.HideButton(0);
				row.HideButton(1);
				row.HideButton(2);
				row.SetInfo(SocialStyle.StatusText(status), SocialStyle.StatusColour(status));
			}
			else if (blocked)
			{
				row.SetTag(null);
				row.HideButton(0);
				row.HideButton(1);
				row.SetButton(2, "UNBLOCK", ButtonLook.Normal);
				row.SetInfo("BLOCKED", null);
			}
			else
			{
				FriendsService service = FriendsService.Instance;
				FriendRelation relation = ((service != null) ? service.RelationTo(entry.UserId) : FriendRelation.None);
				row.SetTag((relation == FriendRelation.Friends) ? "FRIEND" : null);
				row.SetInfo(null, null);
				bool muted = LocalMutes.IsMuted(entry.UserId);
				row.SetButton(0, muted ? "MUTED" : "MUTE", muted ? ButtonLook.Primary : ButtonLook.Normal);
				bool unavailable = service == null || !service.Available || string.IsNullOrEmpty(entry.UserId) || !Qauth.IsLoggedIn;
				switch (relation)
				{
				case FriendRelation.RequestReceived:
					row.SetButton(1, "ACCEPT", unavailable ? ButtonLook.Disabled : ButtonLook.Primary);
					break;
				case FriendRelation.RequestSent:
					row.SetButton(1, "SENT", ButtonLook.Disabled);
					break;
				case FriendRelation.Friends:
					row.SetButton(1, "FRIENDS", ButtonLook.Disabled);
					break;
				default:
					if (service != null && !service.AcceptsRequests(entry))
					{
						row.SetButton(1, "NO REQUESTS", ButtonLook.Disabled);
					}
					else
					{
						row.SetButton(1, "ADD FRIEND", unavailable ? ButtonLook.Disabled : ButtonLook.Normal);
					}
					break;
				}
				bool confirming = _confirmUntil.TryGetValue(entry.UserId ?? "", out float until) && Time.unscaledTime < until;
				row.SetButton(2, confirming ? "SURE?" : "BLOCK", confirming ? ButtonLook.Confirm : ButtonLook.Danger);
			}
			row.Commit();
		}

		private void OnButton(PlayerRowView row, int button)
		{
			string id = row.BoundId;
			if (string.IsNullOrEmpty(id))
			{
				return;
			}
			RosterEntry entry = SocialRoster.Find(id);
			if (entry == null || entry.IsLocal)
			{
				return;
			}
			FriendsService service = FriendsService.Instance;
			if (BlockList.IsBlocked(id))
			{
				if (button == 2)
				{
					BlockList.Unblock(id);
				}
			}
			else
			{
				switch (button)
				{
				case 0:
					LocalMutes.Toggle(id);
					break;
				case 1:
					if (service != null)
					{
						if (service.RelationTo(id) == FriendRelation.RequestReceived)
						{
							service.Accept(id);
						}
						else
						{
							service.SendRequest(id, entry.Name);
						}
					}
					break;
				case 2:
					if (_confirmUntil.TryGetValue(id, out float until) && Time.unscaledTime < until)
					{
						_confirmUntil.Remove(id);
						if (service != null)
						{
							service.Block(id, entry.Name);
						}
						else
						{
							BlockList.Block(id, entry.Name);
						}
					}
					else
					{
						_confirmUntil[id] = Time.unscaledTime + 3f;
					}
					break;
				}
			}
			_list.Rebind();
		}
	}
}
