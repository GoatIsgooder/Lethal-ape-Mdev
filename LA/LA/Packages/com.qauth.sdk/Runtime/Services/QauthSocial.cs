using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace QauthSdk
{
	public enum QauthPresenceStatus
	{
		Offline = 0, // also "appear offline"
		Online = 1,
		Away = 2,
	}

	// one row of the friends list: a friend, or a request either way. Presence is only filled in for friends.
	public sealed class QauthFriend
	{
		public string Id; // account id (the Photon UserId)
		public string Name;
		public string Relation; // friend, sent, received
		public bool Online; // a presence heartbeat in the last 4 minutes, and not banned
		public bool Joinable; // online, joinable and in a room
		public int Scene = -1; // build index the friend is in, -1 = unknown
		public QauthPresenceStatus Status;
		public int Color = -1; // 0xRRGGBB as the friend sent it, -1 = none

		public bool IsFriend => Relation == "friend";
		public bool IsRequestSent => Relation == "sent";
		public bool IsRequestReceived => Relation == "received";

		internal static QauthFriend From(JToken j) => new QauthFriend
		{
			Id = j["id"]?.Value<string>(),
			Name = j["name"]?.Value<string>(),
			Relation = j["rel"]?.Value<string>(),
			Online = j["online"]?.Value<bool>() ?? false,
			Joinable = j["join"]?.Value<bool>() ?? false,
			Scene = j["scene"]?.Value<int>() ?? -1,
			Status = (QauthPresenceStatus)(j["st"]?.Value<int>() ?? 0),
			Color = j["color"]?.Value<int>() ?? -1,
		};
	}

	public sealed class QauthSocialState
	{
		public List<QauthFriend> Friends = new List<QauthFriend>(); // friends and requests; received requests from blocked players are left out
		public bool AcceptsRequests = true;
		public List<string> Blocked = new List<string>();
		public long Now; // server time, unix ms
		public JObject Raw;

		internal static QauthSocialState From(JToken j)
		{
			if (j == null || j.Type != JTokenType.Object) return null;
			return new QauthSocialState
			{
				Friends = (j["friends"] as JArray)?.Select(QauthFriend.From).ToList() ?? new List<QauthFriend>(),
				AcceptsRequests = j["requests"]?.Value<bool>() ?? true,
				Blocked = (j["blocked"] as JArray)?.Values<string>().ToList() ?? new List<string>(),
				Now = j["now"]?.Value<long>() ?? 0,
				Raw = (JObject)j,
			};
		}
	}

	public sealed class QauthSocialResult
	{
		public bool Ok;
		public string Error; // not_accepting, blocked, no_such_player, unavailable, limit, no_request, bad_target, ACCOUNT_BANNED, ...
		public QauthSocialState State; // the list after the change (null on a network error)
	}

	public sealed class QauthJoinResult
	{
		public bool Ok;
		public string Error; // offline, not_joinable, not_friends
		public string Room; // Photon room name to join
		public int Scene = -1;
	}

	// ---- friends and presence: /v1/social/*
	// Friend requests need the other player to accept (or to have asked too). Presence is a heartbeat: send it when it
	// changes and every few minutes; a player with no word for 4 minutes shows as offline. The block list and the
	// "accept friend requests" switch live on the server, so blocked players can't send requests or join.
	public sealed class QauthSocial
	{
		public QauthSocialState Last { get; private set; }

		public event Action<QauthSocialState> OnChanged;

		public async Task<QauthSocialState> GetStateAsync()
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/social/state");
			if (!r.Ok) throw new QauthException("social state", r);
			return Keep(QauthSocialState.From(r.Json));
		}

		public Task<QauthSocialResult> RequestAsync(string accountId) => Act("request", accountId, null);

		public Task<QauthSocialResult> RespondAsync(string accountId, bool accept) => Act("respond", accountId, accept);

		// unfriend, or cancel a request sent
		public Task<QauthSocialResult> RemoveAsync(string accountId) => Act("remove", accountId, null);

		// room = the Photon room friends can join (null or "" = none); joinable needs a room
		public async Task<bool> SetPresenceAsync(QauthPresenceStatus status, bool joinable, int scene, int color, string room)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/social/presence", new Dictionary<string, object>
			{
				["st"] = (int)status,
				["join"] = joinable,
				["scene"] = scene,
				["color"] = color,
				["room"] = room ?? "",
			});
			return r.Ok;
		}

		// where a friend is, if they can be joined right now
		public async Task<QauthJoinResult> JoinAsync(string accountId)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/social/join", new Dictionary<string, object> { ["target"] = accountId });
			bool ok = r.Ok && r.Get<bool>("ok");
			return new QauthJoinResult { Ok = ok, Error = ok ? null : r.Error, Room = r.Get<string>("room"), Scene = r.Get("scene", -1) };
		}

		// change either or both: the "accept friend requests" switch, and the whole block list (account ids)
		public async Task<QauthSocialResult> SetPrefsAsync(bool? acceptRequests = null, IEnumerable<string> blocked = null)
		{
			Dictionary<string, object> body = new Dictionary<string, object>();
			if (acceptRequests.HasValue) body["requests"] = acceptRequests.Value;
			if (blocked != null) body["blocked"] = blocked.ToArray();
			QauthResponse r = await Qauth.PostAuthed("/v1/social/prefs", body);
			if (r.Ok && Last != null)
			{
				Last.AcceptsRequests = r.Get("requests", true);
				Last.Blocked = (r.Json["blocked"] as JArray)?.Values<string>().ToList() ?? new List<string>();
			}
			// blocking ends friendships, so the list is fetched again
			QauthSocialState state = r.Ok && blocked != null ? await GetStateAsync() : Last;
			return new QauthSocialResult { Ok = r.Ok, Error = r.Ok ? null : r.Error, State = state };
		}

		private async Task<QauthSocialResult> Act(string action, string accountId, bool? accept)
		{
			Dictionary<string, object> body = new Dictionary<string, object> { ["target"] = accountId };
			if (accept.HasValue) body["accept"] = accept.Value;
			QauthResponse r = await Qauth.PostAuthed("/v1/social/" + action, body);
			bool ok = r.Ok && r.Get<bool>("ok");
			QauthSocialState state = QauthSocialState.From(r.Json?["state"]);
			if (state != null) Keep(state);
			return new QauthSocialResult { Ok = ok, Error = ok ? null : r.Error, State = state ?? Last };
		}

		private QauthSocialState Keep(QauthSocialState s)
		{
			Last = s;
			OnChanged?.Invoke(s);
			return s;
		}
	}
}
