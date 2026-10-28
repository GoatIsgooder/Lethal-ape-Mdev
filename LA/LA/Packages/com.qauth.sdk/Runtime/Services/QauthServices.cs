using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace QauthSdk
{
	// ---- cloud saves: POST /v1/cloud/pull, /v1/cloud/push
	public sealed class QauthSave
	{
		public string Key;
		public string Data;
		public long UpdatedAt; // unix ms, set by the game
		public int Season;
	}

	public sealed class QauthPushResult
	{
		public bool Ok;
		public bool Stale; // the cloud copy is newer (CloudUpdatedAt): pull it instead of overwriting it
		public long CloudUpdatedAt;
		public bool SeasonReset; // the server started a new season: start a fresh save
		public int Season;
		public string Error;
	}

	public sealed class QauthSaves
	{
		// a device id for players without a Meta login (editor, PC): SHA-256 of the device id, 64 hex chars
		public static string DeviceId => Hash(SystemInfo.deviceUniqueIdentifier + "|qauth");

		private static Dictionary<string, object> Owner()
		{
			return Qauth.IsLoggedIn ? new Dictionary<string, object> { ["token"] = Qauth.Token } : new Dictionary<string, object> { ["playerId"] = DeviceId };
		}

		// every save slot this player has, by key
		public async Task<Dictionary<string, QauthSave>> PullAsync()
		{
			QauthResponse r = await Qauth.Post("/v1/cloud/pull", Owner());
			Dictionary<string, QauthSave> saves = new Dictionary<string, QauthSave>();
			if (!r.Ok) throw new QauthException("cloud pull", r);
			foreach (JProperty p in (r.Json["saves"] as JObject)?.Properties() ?? Enumerable.Empty<JProperty>())
			{
				saves[p.Name] = new QauthSave
				{
					Key = p.Name,
					Data = p.Value["data"]?.Value<string>(),
					UpdatedAt = p.Value["updatedAt"]?.Value<long>() ?? 0,
					Season = p.Value["season"]?.Value<int>() ?? 1,
				};
			}
			return saves;
		}

		// save one slot; updatedAt = when the game last changed it (unix ms). A newer cloud copy is never overwritten.
		public async Task<QauthPushResult> PushAsync(string key, string data, long updatedAt, int season = 1)
		{
			Dictionary<string, object> body = Owner();
			body["key"] = key;
			body["data"] = data;
			body["updatedAt"] = updatedAt;
			body["season"] = season;
			QauthResponse r = await Qauth.Post("/v1/cloud/push", body);
			return new QauthPushResult
			{
				Ok = r.Ok,
				Stale = r.Get<bool>("stale"),
				CloudUpdatedAt = r.Get<long>("updatedAt"),
				SeasonReset = r.Get<bool>("seasonReset"),
				Season = r.Get("season", season),
				Error = r.Ok ? null : r.Error,
			};
		}

		public static long Now => DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();

		private static string Hash(string s)
		{
			using (System.Security.Cryptography.SHA256 sha = System.Security.Cryptography.SHA256.Create())
			{
				return string.Concat(sha.ComputeHash(System.Text.Encoding.UTF8.GetBytes(s)).Select(b => b.ToString("x2")));
			}
		}
	}

	// ---- coins, items and the shop: /v1/wallet*, /v1/shop/* (all kept on the server)
	public sealed class QauthWalletState
	{
		public long Coins;
		public string Currency = "Coins"; // the name set on the dashboard
		public Dictionary<string, int> Items = new Dictionary<string, int>(); // item id -> how many
		public long NextDailyAt; // unix ms, 0 = can claim now
		public long Granted; // from the daily reward
		public string Error; // NOT_ENOUGH_COINS, NOT_FOR_SALE, BAD_AMOUNT, ...
		public JObject Raw;

		public int Count(string itemId) => Items.TryGetValue(itemId, out int n) ? n : 0;
	}

	public sealed class QauthCatalogItem
	{
		public string Id;
		public string Name;
		public long? Price; // null = not for sale (staff can still give it)
		public bool Tradable;
	}

	public sealed class QauthCatalog
	{
		public string Currency = "Coins";
		public Dictionary<string, QauthCatalogItem> Items = new Dictionary<string, QauthCatalogItem>();
		public JObject Raw;
	}

	public sealed class QauthWallet
	{
		public QauthWalletState Last { get; private set; }

		public event Action<QauthWalletState> OnChanged;

		public Task<QauthWalletState> GetAsync() => Call("/v1/wallet", null);

		public Task<QauthWalletState> ClaimDailyAsync() => Call("/v1/wallet/daily", null);

		public Task<QauthWalletState> SpendAsync(long amount) => Call("/v1/wallet/spend", new Dictionary<string, object> { ["amount"] = amount });

		// buy items from the shop with coins (prices live on the server)
		public Task<QauthWalletState> BuyAsync(string itemId, int count = 1) => Call("/v1/shop/buy", new Dictionary<string, object> { ["itemId"] = itemId, ["count"] = count });

		public bool Owns(string itemId) => Last != null && Last.Count(itemId) > 0;

		public async Task<QauthCatalog> CatalogAsync()
		{
			QauthResponse r = await Qauth.Post("/v1/shop/catalog", new { });
			if (!r.Ok) throw new QauthException("shop catalog", r);
			QauthCatalog c = new QauthCatalog { Raw = r.Json, Currency = r.Get("currency", "Coins") };
			foreach (JProperty p in (r.Json["items"] as JObject)?.Properties() ?? Enumerable.Empty<JProperty>())
			{
				JToken price = p.Value["price"];
				c.Items[p.Name] = new QauthCatalogItem
				{
					Id = p.Name,
					Name = p.Value["name"]?.Value<string>() ?? p.Name,
					Price = price == null || price.Type == JTokenType.Null ? (long?)null : price.Value<long>(),
					Tradable = p.Value["tradable"]?.Value<bool>() ?? true,
				};
			}
			return c;
		}

		private async Task<QauthWalletState> Call(string path, Dictionary<string, object> body)
		{
			QauthResponse r = await Qauth.PostAuthed(path, body);
			QauthWalletState s = new QauthWalletState { Raw = r.Json, Error = r.Ok ? null : r.Error };
			if (r.Json["coins"] != null)
			{
				s.Coins = r.Get<long>("coins");
				s.Currency = r.Get("currency", "Coins");
				s.NextDailyAt = r.Get<long>("nextDailyAt");
				s.Granted = r.Get<long>("granted");
				foreach (JProperty p in (r.Json["items"] as JObject)?.Properties() ?? Enumerable.Empty<JProperty>()) s.Items[p.Name] = p.Value.Value<int>();
				Last = s;
				OnChanged?.Invoke(s);
			}
			return s;
		}
	}

	// ---- leaderboards: /v1/leaderboard/*
	public sealed class QauthLeaderboardEntry
	{
		public int Rank;
		public string Name;
		public long Value;
	}

	public sealed class QauthLeaderboards
	{
		// the game's own stats (ids made on the dashboard, e.g. {"kills": 12, "wins": 3}); unknown ones are ignored and the
		// server can cap how fast one grows
		public async Task<bool> SubmitAsync(IDictionary<string, long> stats)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/leaderboard/submit", new Dictionary<string, object> { ["stats"] = stats });
			return r.Ok;
		}

		public Task<bool> SubmitAsync(string stat, long value) => SubmitAsync(new Dictionary<string, long> { [stat] = value });

		public async Task<List<QauthLeaderboardEntry>> TopAsync(string stat, int limit = 10)
		{
			QauthResponse r = await Qauth.Post("/v1/leaderboard/top", new { stat, limit });
			if (!r.Ok) throw new QauthException("leaderboard", r);
			return (r.Json["entries"] as JArray)?.Select(e => new QauthLeaderboardEntry
			{
				Rank = e["rank"]?.Value<int>() ?? 0,
				Name = e["name"]?.Value<string>(),
				Value = e["value"]?.Value<long>() ?? 0,
			}).ToList() ?? new List<QauthLeaderboardEntry>();
		}

		// this player's own places
		public Task<QauthResponse> MeAsync() => Qauth.PostAuthed("/v1/leaderboard/me");
	}

	// ---- staff gifts and actions delivered to the game: /v1/grants, /v1/grants/ack
	public sealed class QauthGrants
	{
		// each delivery from the dashboard ({type: "kick", reason} or {type: "message", text}): handle it, then it's confirmed
		// automatically. Coins and items staff give go straight onto the wallet (Qauth.Wallet).
		// Throwing from the handler leaves it unconfirmed, so it comes again next time.
		public event Action<JObject> OnGrant;

		// the whole reply each poll
		public event Action<JObject> OnPoll;

		private readonly HashSet<string> handled = new HashSet<string>();

		public async Task PollAsync()
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/grants");
			if (!r.Ok) return;
			OnPoll?.Invoke(r.Json);
			List<string> done = new List<string>();
			foreach (JObject g in (r.Json["grants"] as JArray)?.OfType<JObject>() ?? Enumerable.Empty<JObject>())
			{
				string id = g["id"]?.Value<string>();
				if (string.IsNullOrEmpty(id)) continue;
				if (handled.Contains(id))
				{
					done.Add(id); // applied before, the ack got lost
					continue;
				}
				try
				{
					OnGrant?.Invoke(g);
					handled.Add(id);
					done.Add(id);
				}
				catch (Exception e)
				{
					Debug.LogWarning("[Qauth] grant " + id + " not applied: " + e.Message);
				}
			}
			if (done.Count > 0) await AckAsync(done);
		}

		public async Task<bool> AckAsync(IEnumerable<string> ids)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/grants/ack", new Dictionary<string, object> { ["ids"] = ids.ToArray() });
			return r.Ok;
		}
	}

	// ---- global events: GET /v1/event[?room=]
	public sealed class QauthEvents
	{
		// {event: {weather, startedAt, endsAt, by} | null, now, ...extra live settings}
		public async Task<JObject> GetAsync(string room = null)
		{
			QauthResponse r = await Qauth.Get("/v1/event" + (string.IsNullOrEmpty(room) ? "" : "?room=" + Uri.EscapeDataString(room)));
			if (!r.Ok) throw new QauthException("event", r);
			return r.Json;
		}
	}

	// ---- account: /v1/account/name
	public sealed class QauthAccount
	{
		public sealed class NameResult
		{
			public bool Ok;
			public string Name; // the name actually given (names are unique: "PLAYER" may become "PLAYER2")
			public bool Taken;
			public string Error;
		}

		public async Task<NameResult> SetNameAsync(string name)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/account/name", new Dictionary<string, object> { ["name"] = name });
			return new NameResult { Ok = r.Ok, Name = r.Get("name", name), Taken = r.Get<bool>("taken"), Error = r.Ok ? null : r.Error };
		}
	}

	public sealed class QauthException : Exception
	{
		public readonly QauthResponse Response;

		public QauthException(string what, QauthResponse r) : base(what + " failed: " + r.Error)
		{
			Response = r;
		}
	}
}
