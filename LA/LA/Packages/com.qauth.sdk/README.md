# Qauth SDK for Unity

Client for [Qauth](https://qauth.wtf): Meta login with attestation, Photon custom auth, cloud saves, coins, items and
shop, trading, leaderboards, friends and presence, season pass, staff messages and live events. Unity 2021.3+.

## Install

Package Manager → **+** → *Add package from tarball…* → `com.qauth.sdk-1.0.0.tgz`
(or *Add package from disk…* → this folder's `package.json`).

Needs `com.unity.nuget.newtonsoft-json` (added automatically). Optional, picked up by themselves:

| If the project has | You get |
|---|---|
| Meta XR Platform SDK (`com.meta.xr.sdk.platform` v55+) | `QauthMetaPlatform`: Meta login + attestation, registered automatically |
| Photon PUN 2 | `QauthPhoton`: Photon auth values for Qauth's custom auth |

## Set up

1. **Tools → Qauth → Settings** creates `Assets/Resources/QauthSettings.asset`.
2. Fill in **Game Id** (your title's ID on the dashboard, e.g. `5CKJX`) and **Meta App Id**.
3. That's it: with *Login On Start* on, the player is logged in when the game starts.

## Use

```csharp
using QauthSdk;

await Qauth.LoginAsync();                    // or let loginOnStart do it
if (Qauth.Status == QauthStatus.Banned) ShowBan(Qauth.BanReason, Qauth.BanUntil);

// Photon (custom auth: Photon asks Qauth before letting the player in)
await QauthPhoton.ConfigureAsync();
PhotonNetwork.ConnectUsingSettings();

// cloud saves (a newer cloud copy is never overwritten)
var saves = await Qauth.Saves.PullAsync();
var push = await Qauth.Saves.PushAsync("PlayerData", json, QauthSaves.Now);
if (push.Stale) { /* the cloud copy is newer: load it */ }

// coins, items and the shop (all on the server; items and prices are set on the dashboard)
var w = await Qauth.Wallet.ClaimDailyAsync();                 // w.Coins, w.Items["sword"], w.Currency
await Qauth.Wallet.BuyAsync("sword");
var catalog = await Qauth.Wallet.CatalogAsync();

// leaderboards
await Qauth.Leaderboards.SubmitAsync("kills", 42);          // stat ids are made on the dashboard
var top = await Qauth.Leaderboards.TopAsync("kills", 10);

// kicks and messages from the dashboard (polled every grantsPollSeconds, confirmed after your handler runs)
Qauth.Grants.OnGrant += g => {
    if ((string)g["type"] == "kick") PhotonNetwork.LeaveRoom();
    if ((string)g["type"] == "message") ShowPopup((string)g["text"]);
};

// anything else the server offers
var r = await Qauth.PostAuthed("/v1/leaderboard/me");
```

## Add-ons (real money) and Cloud Script

```csharp
// after Oculus.Platform.IAP.LaunchCheckoutFlow(sku) succeeds:
var r = await Qauth.Addons.RedeemAsync(sku);      // the server checks it with Meta, gives it, records the sale
// don't consume the purchase in the game: the server does

var run = await Qauth.CloudScript.RunAsync("open-chest");   // made on the dashboard: cost, reward, cooldown, daily limit
if (!run.Ok && run.Error == "COOLDOWN") ShowWait(run.ReadyAt);
```

Built-in functions take arguments and return JSON like PlayFab's ExecuteCloudScript did (`FunctionParameter` →
`args`, `FunctionResult` → `Result`):

```csharp
var r = await Qauth.CloudScript.RunAsync("ClaimSeasonReward", new { Season = "S1", Level = 5 });
if (r.Ok && (bool)r.Result["success"]) { /* r.Result["claimed"], ["xp"], ["balance"]... */ }
await Qauth.CloudScript.RunAsync("AddCurrency", new { CurrencyCode = "GD", Amount = 50 });   // capped per call and per day
```

| Function | args | Result |
|---|---|---|
| SocialGetState | – | `{ok, friends: [{id, name, rel, online, join, scene, st, color}], requests, blocked, now}` |
| SocialSetPresence | `{st, join, scene, color, room}` | `{ok}` |
| SocialJoinTarget | `{target}` | `{ok, room, scene}` / `{ok: false, error}` |
| SocialRequest / SocialRespond / SocialRemove | `{target}` (+ `accept`) | `{ok, error?, state}` |
| ClaimSeasonQuest | `{Season, Quest, Day}` | `{success, error?, claimed, xp, premium, questDay, dailyQuests, challenges, ...}` |
| ClaimSeasonReward | `{Season, Level}` | `{success, error?, kind, item, amount, balance, inventoryChanged, claimed, xp, premium, ...}` |
| AddCurrency | `{CurrencyCode, Amount}` | `{ok, granted, capped, balance}` |
| RecieveApeGameReward | `{playerCount}` | `{ok, gold, players, error?}` |
| GetUserBanStatus | – | `{banned, reason, expires, permanent, username}` |

## Friends and presence

```csharp
var s = await Qauth.Social.GetStateAsync();                  // s.Friends: friends and requests (Relation friend/sent/received)
var r = await Qauth.Social.RequestAsync(otherPlayer.UserId);   // r.Error "not_accepting" = they turned requests off or blocked you
await Qauth.Social.RespondAsync(id, accept: true);
await Qauth.Social.RemoveAsync(id);                          // unfriend or cancel a request

// heartbeat: on changes and every ~3 minutes (no word for 4 minutes = offline)
await Qauth.Social.SetPresenceAsync(QauthPresenceStatus.Online, joinable: true, scene, 0xFF8800, PhotonNetwork.CurrentRoom?.Name);
var j = await Qauth.Social.JoinAsync(friend.Id);             // j.Room, j.Scene, or j.Error offline / not_joinable
await Qauth.Social.SetPrefsAsync(acceptRequests: false, blocked: myBlockList);
```

## Season pass

Set the season on the dashboard (Live Ops > Season Pass), with levels and quests in the same order as the game's own
season data. The game counts quest progress; claims, XP, levels, premium and rewards are decided by the server.

```csharp
var st = (await Qauth.Season.GetStateAsync()).State;           // Level, Xp, Claimed, Premium, TodaysQuests, Phase...
var q = await Qauth.Season.ClaimQuestAsync("S1", "win-3-rounds", st.QuestDay);
var c = await Qauth.Season.ClaimRewardAsync("S1", 5);          // c.Error: not_reached, needs_premium, item_missing...
var b = await Qauth.Season.BuyLevelAsync("S1");                // coins at the season's level price
DateTime now = await Qauth.ServerTimeAsync();
```

Premium is the season's Meta SKU (bought with `IAP.LaunchCheckoutFlow`; the server checks it with Meta) or switched on
for a player on the dashboard.

## Trading

Two players swap items and coins. Both must accept the same offers (any change clears both accepts); then the server
swaps everything in one step, after checking both still have what they offered.

```csharp
var r = await Qauth.Trades.RequestAsync(otherPlayer.UserId);   // their account id (Photon UserId)
Qauth.Trades.OnRequest += t => ShowPopup($"Trade with {t.WithName}?", yes => Qauth.Trades.RespondAsync(t, yes));
Qauth.Trades.OnUpdate += t => tradeScreen.Show(t);               // offers, who accepted, errors, final state

var offer = new QauthTradeOffer { Coins = 50 };
offer.Items.Add(new QauthTradeItem { Id = "sword", Count = 1 });
await Qauth.Trades.SetOfferAsync(Qauth.Trades.Current, offer);
await Qauth.Trades.AcceptAsync(Qauth.Trades.Current);            // accepts exactly what's on screen (its Version)
```

Items marked "can't be traded" on the dashboard are refused.

## Crossplay

Players from different Qauth games in the same rooms (needs Photon PUN 2). The group is set up on the server.

```csharp
var group = await QauthCrossplay.ConnectAsync("ape-games");  // leaves your game's servers, joins the shared app
// in OnConnectedToMaster:
QauthCrossplay.JoinMatch();                  // public room by the group's filter, made if none is open
QauthCrossplay.JoinCode("K7Q2M");            // or a private code shared by every game in the group
// Photon Voice: use group.AppIdVoice and group.AppVersion for the voice client
await QauthCrossplay.ReturnAsync();          // back to your game's own servers
```

Your project's PhotonServerSettings asset is never changed: crossplay connects with a copy.

## Status values

| `Qauth.Status` | Meaning / what to do |
|---|---|
| `LoggedIn` | Ready |
| `NoPlatform` | Editor / PC without a Meta login: play without an account (saves use a device id) |
| `NotEntitled` | Meta says this account doesn't own the game (the build quits if *Quit If Not Entitled*) |
| `Banned` | Show `BanReason` and `BanUntil` (unix ms, 0 = permanent) |
| `AttestationFailed` | Modded copy or untrusted headset |
| `UpdateRequired` | Build older than the server's minimum (`RequiredVersion`) |
| `Failed` | Network / server trouble: `LastError`; call `LoginAsync()` again later |

## Editor logins

Meta's attestation can't pass in the editor. Make an editor key on the Qauth dashboard, then
**Tools → Qauth → Set Editor Login Key…**. It's kept in this PC's EditorPrefs only, never in the project or a build.
For the Meta login itself in the editor, set up a Meta test user (Meta → Platform → Edit Settings → *Use Standalone Platform*).

## API base

Calls go to `apiUrl + "/g/" + gameId` (e.g. `https://api.qauth.wtf/g/qauth/v1/...`). Leave *Game Id* empty to use
the server's default game.
