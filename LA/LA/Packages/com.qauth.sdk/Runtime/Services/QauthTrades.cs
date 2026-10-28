using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace QauthSdk
{
	public sealed class QauthTradeItem
	{
		public string Id; // item id from the catalog
		public int Count = 1;
		public string Name; // filled in by the server
	}

	public sealed class QauthTradeOffer
	{
		public List<QauthTradeItem> Items = new List<QauthTradeItem>();
		public long Coins;

		public bool IsEmpty => Items.Count == 0 && Coins == 0;

		internal static QauthTradeOffer From(JToken j)
		{
			QauthTradeOffer o = new QauthTradeOffer();
			if (j == null) return o;
			o.Coins = j["coins"]?.Value<long>() ?? 0;
			foreach (JToken it in j["items"] as JArray ?? new JArray())
			{
				o.Items.Add(new QauthTradeItem { Id = it["id"]?.Value<string>(), Count = it["count"]?.Value<int>() ?? 1, Name = it["name"]?.Value<string>() });
			}
			return o;
		}
	}

	// one trade between this player and another, as the server sees it
	public sealed class QauthTrade
	{
		public string Id;
		public string State; // requested, open, done, cancelled, declined, expired
		public int Version; // accept this exact version; any offer change bumps it and clears both accepts
		public string WithAccountId;
		public string WithName;
		public bool YouAsked;
		public QauthTradeOffer You = new QauthTradeOffer();
		public QauthTradeOffer Them = new QauthTradeOffer();
		public bool YouAccepted;
		public bool TheyAccepted;
		public long ExpiresAt; // unix ms
		public string Error; // why the last accept didn't go through (e.g. "Bob doesn't have 1x Sword")
		public string Reason; // why it ended (cancelled / declined / failed)

		public bool IsRequest => State == "requested";
		public bool IsOpen => State == "open";
		public bool IsDone => State == "done";
		public bool IsOver => State == "done" || State == "cancelled" || State == "declined" || State == "expired";

		internal static QauthTrade From(JToken j)
		{
			if (j == null || j.Type != JTokenType.Object) return null;
			return new QauthTrade
			{
				Id = j["id"]?.Value<string>(),
				State = j["state"]?.Value<string>(),
				Version = j["version"]?.Value<int>() ?? 0,
				WithAccountId = j["with"]?["accountId"]?.Value<string>(),
				WithName = j["with"]?["name"]?.Value<string>(),
				YouAsked = j["youAsked"]?.Value<bool>() ?? false,
				You = QauthTradeOffer.From(j["you"]),
				Them = QauthTradeOffer.From(j["them"]),
				YouAccepted = j["youAccepted"]?.Value<bool>() ?? false,
				TheyAccepted = j["theyAccepted"]?.Value<bool>() ?? false,
				ExpiresAt = j["expiresAt"]?.Value<long>() ?? 0,
				Error = j["error"]?.Value<string>(),
				Reason = j["reason"]?.Value<string>(),
			};
		}
	}

	public sealed class QauthTradeResult
	{
		public bool Ok;
		public QauthTrade Trade;
		public string Error; // e.g. YOU_ARE_ALREADY_TRADING, THEY_ARE_ALREADY_TRADING, OFFER_CHANGED, NOTHING_TO_TRADE
	}

	// Trading between two players: items and coins. Both must accept the same offers; then the server swaps everything
	// in one step (it checks both sides still have what they offered).
	//
	//   var r = await Qauth.Trades.RequestAsync(otherPlayersAccountId);       // their Photon UserId
	//   Qauth.Trades.OnRequest += t => show "Trade with t.WithName?" -> RespondAsync(t, true)
	//   await Qauth.Trades.SetOfferAsync(trade, offer);                         // clears both accepts
	//   await Qauth.Trades.AcceptAsync(trade);                                  // accepts trade.Version
	//   Qauth.Trades.OnUpdate += t => refresh the trade screen (polled while a trade is live)
	public sealed class QauthTrades
	{
		// the live trade (request, open or settling), or null
		public QauthTrade Current { get; private set; }

		public event Action<QauthTrade> OnUpdate; // any change to the live trade, including the moment it ends
		public event Action<QauthTrade> OnRequest; // someone asked this player to trade

		private readonly HashSet<string> announced = new HashSet<string>();

		public Task<QauthTradeResult> RequestAsync(string accountId) => Act("request", new Dictionary<string, object> { ["to"] = accountId });

		public Task<QauthTradeResult> RespondAsync(QauthTrade t, bool accept) => Act("respond", new Dictionary<string, object> { ["tradeId"] = t.Id, ["accept"] = accept });

		public Task<QauthTradeResult> SetOfferAsync(QauthTrade t, QauthTradeOffer offer)
		{
			return Act("offer", new Dictionary<string, object>
			{
				["tradeId"] = t.Id,
				["items"] = offer.Items.Select(i => new Dictionary<string, object> { ["id"] = i.Id, ["count"] = Math.Max(1, i.Count) }).ToArray(),
				["coins"] = offer.Coins,
			});
		}

		public Task<QauthTradeResult> AcceptAsync(QauthTrade t) => Act("accept", new Dictionary<string, object> { ["tradeId"] = t.Id, ["version"] = t.Version });

		public Task<QauthTradeResult> UnacceptAsync(QauthTrade t) => Act("unaccept", new Dictionary<string, object> { ["tradeId"] = t.Id });

		public Task<QauthTradeResult> CancelAsync(QauthTrade t) => Act("cancel", new Dictionary<string, object> { ["tradeId"] = t.Id });

		// every live trade this player is in (normally zero or one)
		public async Task<List<QauthTrade>> StatusAsync()
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/trade", new Dictionary<string, object> { ["action"] = "status" });
			List<QauthTrade> list = (r.Json?["trades"] as JArray)?.Select(QauthTrade.From).Where(t => t != null).ToList() ?? new List<QauthTrade>();
			return list;
		}

		// called by the SDK's background runner (QauthSettings.tradePollSeconds): fires OnRequest / OnUpdate
		public async Task PollAsync()
		{
			if (!Qauth.IsLoggedIn) return;
			List<QauthTrade> live = await StatusAsync();
			foreach (QauthTrade t in live.Where(t => t.IsRequest && !t.YouAsked && announced.Add(t.Id))) OnRequest?.Invoke(t);
			QauthTrade now = live.FirstOrDefault(t => !(t.IsRequest && !t.YouAsked));
			if (now == null && Current != null)
			{
				// it ended since the last poll: fetch the final state once, so the game can show done / why it failed
				QauthResponse v = await Qauth.PostAuthed("/v1/trade", new Dictionary<string, object> { ["action"] = "view", ["tradeId"] = Current.Id });
				QauthTrade last = QauthTrade.From(v.Json?["trade"]);
				Current = null;
				if (last != null) OnUpdate?.Invoke(last);
				return;
			}
			Set(now);
		}

		private async Task<QauthTradeResult> Act(string action, Dictionary<string, object> body)
		{
			body["action"] = action;
			QauthResponse r = await Qauth.PostAuthed("/v1/trade", body);
			QauthTrade t = QauthTrade.From(r.Json?["trade"]);
			if (t != null) Set(t.IsOver ? null : t, t);
			return new QauthTradeResult { Ok = r.Ok, Trade = t, Error = r.Ok ? null : r.Error };
		}

		private void Set(QauthTrade live, QauthTrade show = null)
		{
			QauthTrade before = Current;
			Current = live;
			QauthTrade t = show ?? live;
			if (t == null) return;
			if (before == null || before.Id != t.Id || before.Version != t.Version || before.State != t.State || before.YouAccepted != t.YouAccepted || before.TheyAccepted != t.TheyAccepted || before.Error != t.Error)
			{
				OnUpdate?.Invoke(t);
			}
		}
	}
}
