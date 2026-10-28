using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace QauthSdk
{
	// ---- real-money add-ons (Meta store): /v1/iap/*
	public sealed class QauthAddon
	{
		public string Sku;
		public string Name;
		public double Price; // USD, as set on the dashboard
		public bool Durable; // one-time; false = consumable (can be bought again)
	}

	public sealed class QauthRedeemResult
	{
		public bool Ok;
		public bool Granted; // false when a one-time add-on was already owned
		public string Error; // NOT_PURCHASED, UNKNOWN_ADDON, ...
		public QauthWalletState Wallet;
	}

	// After the player buys an add-on with the Meta Platform SDK (IAP.LaunchCheckoutFlow), call RedeemAsync(sku): the server
	// checks the purchase with Meta itself (consumables are consumed there), gives what the dashboard says, and records the
	// sale for the Add-ons revenue page. Don't consume the purchase in the game: the server does it.
	public sealed class QauthAddons
	{
		public async Task<Dictionary<string, QauthAddon>> CatalogAsync()
		{
			QauthResponse r = await Qauth.Post("/v1/iap/catalog", new { });
			if (!r.Ok) throw new QauthException("add-on catalog", r);
			return (r.Json["addons"] as JObject)?.Properties().ToDictionary(p => p.Name, p => new QauthAddon
			{
				Sku = p.Name,
				Name = p.Value["name"]?.Value<string>() ?? p.Name,
				Price = p.Value["price"]?.Value<double>() ?? 0,
				Durable = p.Value["kind"]?.Value<string>() == "durable",
			}) ?? new Dictionary<string, QauthAddon>();
		}

		public async Task<QauthRedeemResult> RedeemAsync(string sku)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/iap/redeem", new Dictionary<string, object> { ["sku"] = sku });
			QauthWalletState w = await Qauth.Wallet.GetAsync();
			return new QauthRedeemResult { Ok = r.Ok, Granted = r.Get<bool>("granted"), Error = r.Ok ? null : r.Error, Wallet = w };
		}

		// Picks up every Meta purchase of this player the server hasn't seen yet (the server also does this on each login),
		// e.g. at startup or when the store menu opens. Returns the SKUs given just now.
		public async Task<List<string>> SyncAsync()
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/iap/sync");
			if (!r.Ok) throw new QauthException("add-on sync", r);
			List<string> granted = (r.Json["granted"] as JArray)?.Values<string>().ToList() ?? new List<string>();
			if (granted.Count > 0) await Qauth.Wallet.GetAsync();
			return granted;
		}

		// the one-time add-ons this player owns
		public async Task<List<string>> OwnedAsync()
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/iap/owned");
			return (r.Json["owned"] as JArray)?.Values<string>().ToList() ?? new List<string>();
		}
	}

	// ---- Cloud Script: /v1/cloudscript
	public sealed class QauthCloudResult
	{
		public bool Ok;
		public string Error; // COOLDOWN, DAILY_LIMIT, CANT_AFFORD, UNKNOWN_FUNCTION
		public long ReadyAt; // unix ms, with COOLDOWN
		public long ResetsAt; // unix ms, with DAILY_LIMIT
		public JObject Reward; // {coins, items}: already on the wallet
		public JToken Result; // what the server function returned (for the built-in ones, the old PlayFab FunctionResult JSON)
		public JObject Raw;
	}

	// Run a server function by name: one made on the dashboard (Live Ops > Cloud Script; costs, rewards, cooldowns and daily
	// limits all run on the server), or a built-in one (e.g. SocialGetState, ClaimSeasonReward, AddCurrency) that takes the
	// same args and returns the same Result JSON as the PlayFab Cloud Script it replaces. Ok/Error = whether the call ran;
	// a function's own refusals are in Result. The wallet (Qauth.Wallet) is refreshed when coins changed.
	public sealed class QauthCloudScript
	{
		public Task<QauthCloudResult> RunAsync(string fn) => RunAsync(fn, null);

		// args reach the server function as its parameters (like PlayFab's FunctionParameter): an anonymous object or a dictionary
		public async Task<QauthCloudResult> RunAsync(string fn, object args)
		{
			Dictionary<string, object> body = new Dictionary<string, object> { ["fn"] = fn };
			if (args != null) body["args"] = JToken.FromObject(args);
			QauthResponse r = await Qauth.PostAuthed("/v1/cloudscript", body);
			if (r.Json?["coins"] != null || (r.Json?["reward"]?["coins"]?.Value<long>() ?? 0) > 0) await Qauth.Wallet.GetAsync();
			return new QauthCloudResult
			{
				Ok = r.Ok,
				Error = r.Ok ? null : r.Error,
				ReadyAt = r.Get<long>("readyAt"),
				ResetsAt = r.Get<long>("resetsAt"),
				Reward = r.Json?["reward"] as JObject,
				Result = r.Json?["result"],
				Raw = r.Json,
			};
		}
	}
}
