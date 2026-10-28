using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace QauthSdk
{
	// this player's season pass, as the server sees it
	public sealed class QauthSeasonState
	{
		public string Season; // season id
		public string Phase; // upcoming, live, ended (preview players see "live" before release)
		public int Xp; // from claimed quests and XP rewards
		public int Level; // earned + bought, capped at LevelCap
		public int EarnedLevel;
		public int BoughtLevels;
		public int LevelCap; // the level before the first "coming soon" reward
		public int MaxLevel;
		public List<int> Claimed = new List<int>(); // reward levels claimed
		public bool Premium;
		public bool Preview;
		public int QuestDay; // UTC day number (unix days) the server is on
		public List<string> DailyQuestsClaimed = new List<string>(); // today's
		public List<string> TodaysQuests = new List<string>(); // today's draw, worked out on the server
		public List<string> ChallengesClaimed = new List<string>();
		public long Balance; // coins after this call
		public long Now; // server time, unix ms
		public JObject Definition; // GetStateAsync only: {id, name, start, end, releaseReady, premiumSku, levelPrice, xpTable}
		public JObject Raw;

		public bool IsLive => Phase == "live";
		public bool IsClaimed(int level) => Claimed.Contains(level);

		internal static QauthSeasonState From(JObject j)
		{
			if (j == null || j["phase"] == null) return null;
			return new QauthSeasonState
			{
				Season = j["season"]?.Value<string>(),
				Phase = j["phase"]?.Value<string>(),
				Xp = j["xp"]?.Value<int>() ?? 0,
				Level = j["level"]?.Value<int>() ?? 1,
				EarnedLevel = j["earnedLevel"]?.Value<int>() ?? 1,
				BoughtLevels = j["boughtLevels"]?.Value<int>() ?? 0,
				LevelCap = j["levelCap"]?.Value<int>() ?? 0,
				MaxLevel = j["maxLevel"]?.Value<int>() ?? 0,
				Claimed = (j["claimed"] as JArray)?.Values<int>().ToList() ?? new List<int>(),
				Premium = j["premium"]?.Value<bool>() ?? false,
				Preview = j["preview"]?.Value<bool>() ?? false,
				QuestDay = j["questDay"]?.Value<int>() ?? 0,
				DailyQuestsClaimed = (j["dailyQuests"] as JArray)?.Values<string>().ToList() ?? new List<string>(),
				TodaysQuests = (j["todaysQuests"] as JArray)?.Values<string>().ToList() ?? new List<string>(),
				ChallengesClaimed = (j["challenges"] as JArray)?.Values<string>().ToList() ?? new List<string>(),
				Balance = j["balance"]?.Value<long>() ?? 0,
				Now = j["now"]?.Value<long>() ?? 0,
				Definition = j["definition"] as JObject,
				Raw = j,
			};
		}
	}

	public sealed class QauthSeasonResult
	{
		public bool Success;
		// not_configured, wrong_season, not_live, not_today, unknown_quest, already_claimed, bad_level, not_reached,
		// needs_premium, premium_unknown, coming_soon, item_missing, not_for_sale, max_level, not_enough_coins, ACCOUNT_BANNED
		public string Error;
		public QauthSeasonState State; // also on refusals, so the board can redraw from it (null on a network error)
		public string Kind; // claim-reward: cosmetic, gold, xp
		public string Item; // claim-reward: the item given (cosmetic)
		public int Amount; // claim-reward: coins or XP given
		public int XpGained; // claim-quest
		public JObject Raw;
	}

	// ---- season pass: /v1/season/*
	// The season (levels, rewards, quests, premium SKU, level price) is set on the dashboard's Season Pass page. Quest
	// progress is counted by the game; claiming, XP, levels, premium and rewards are decided by the server. Gold rewards
	// and cosmetics go onto the wallet (Qauth.Wallet is refreshed). Premium = the season's Meta SKU bought (the server asks
	// Meta itself) or switched on by staff.
	public sealed class QauthSeason
	{
		public QauthSeasonState Last { get; private set; }

		public event Action<QauthSeasonState> OnChanged;

		public Task<QauthSeasonResult> GetStateAsync() => Call("state", null);

		// day = the UTC day number the quest was done on (unix days); another day is refused with not_today
		public Task<QauthSeasonResult> ClaimQuestAsync(string seasonId, string questId, int day) =>
			Call("claim-quest", new Dictionary<string, object> { ["season"] = seasonId, ["quest"] = questId, ["day"] = day });

		public Task<QauthSeasonResult> ClaimRewardAsync(string seasonId, int level) =>
			Call("claim-reward", new Dictionary<string, object> { ["season"] = seasonId, ["level"] = level });

		// buy levels with coins at the season's level price
		public Task<QauthSeasonResult> BuyLevelAsync(string seasonId, int count = 1) =>
			Call("buy-level", new Dictionary<string, object> { ["season"] = seasonId, ["count"] = count });

		private async Task<QauthSeasonResult> Call(string action, Dictionary<string, object> body)
		{
			QauthResponse r = await Qauth.PostAuthed("/v1/season/" + action, body);
			bool ok = r.Ok && r.Get<bool>("success");
			QauthSeasonState state = QauthSeasonState.From(r.Json);
			if (state != null)
			{
				// keep the definition from the last full state
				if (state.Definition == null && Last != null) state.Definition = Last.Definition;
				Last = state;
				OnChanged?.Invoke(state);
			}
			QauthSeasonResult res = new QauthSeasonResult
			{
				Success = ok,
				Error = ok ? null : r.Error,
				State = state ?? Last,
				Kind = r.Get<string>("kind"),
				Item = r.Get<string>("item"),
				Amount = r.Get<int>("amount"),
				XpGained = r.Get<int>("xpGained"),
				Raw = r.Json,
			};
			if (ok && (action == "buy-level" || (action == "claim-reward" && res.Kind != "xp"))) await Qauth.Wallet.GetAsync();
			return res;
		}
	}
}
