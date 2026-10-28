# Changelog

## 2.4.0
- `Qauth.CloudScript.RunAsync(fn, args)`: arguments for the server function, and `QauthCloudResult.Result` (the JSON it
  returned). `RunAsync(fn)` still works. The server has built-in functions with the names, arguments and results of the
  PlayFab Cloud Script games used before: SocialGetState, SocialSetPresence, SocialJoinTarget, SocialRequest, SocialRespond,
  SocialRemove, ClaimSeasonQuest, ClaimSeasonReward, AddCurrency, RecieveApeGameReward, GetUserBanStatus.
- Season pass state is also kept in the player's saves (SeasonPass_<season>, SeasonPassPremium, SeasonPassPreview), written
  only by the server; pushing those keys gives SERVER_KEY.

## 2.3.0
- `Qauth.Social`: friends (requests the other side accepts), presence heartbeat with joinable rooms, joining a friend, block list
  and the "accept friend requests" switch kept on the server.
- `Qauth.Season`: season pass state, quest and reward claims, buying levels with coins. All checked on the server; the season
  is set on the dashboard's Season Pass page.
- `Qauth.ServerTimeAsync()` (GET `/v1/time`).

## 2.1.0
- `Qauth.Addons` (Meta store purchases, checked and recorded by the server) and `Qauth.CloudScript`. Default game id is the title ID `5CKJX`.

## 2.0.0
- For the generic Qauth backend: coins and items (`Qauth.Wallet` now has `Coins`, `Items`, `Currency`), shop with counts, item catalog, trading of items and coins, kicks and staff messages. Default game id `qauth`.

## 1.1.0
- Trading (`Qauth.Trades`): brainrots, money and Nuggets, both players accept; crossplay (`QauthCrossplay`).

## 1.0.0
- First release: Meta login + attestation, Photon custom auth, cloud saves, wallet and shop, leaderboards, staff gifts, live events, editor login key.
