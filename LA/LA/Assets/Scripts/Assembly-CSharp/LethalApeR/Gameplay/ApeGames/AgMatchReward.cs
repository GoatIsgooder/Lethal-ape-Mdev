using System.Collections.Generic;
using System;
using System.Reflection;
using LethalApeR.PlayFab;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public static class AgMatchReward
	{
		private const string CloudScriptFunction = "RecieveApeGameReward";

		public const int MinPlayers = 10;

		private static readonly Vector2Int[] Curve = new Vector2Int[4]
		{
			new Vector2Int(0, 0),
			new Vector2Int(10, 100),
			new Vector2Int(50, 600),
			new Vector2Int(100, 1000)
		};

		private static double _claimedStamp = -1.0;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_claimedStamp = -1.0;
		}

		public static int GoldFor(int players)
		{
			if (players < MinPlayers)
			{
				return 0;
			}
			if (players <= Curve[0].x)
			{
				return Curve[0].y;
			}
			int last = Curve.Length - 1;
			if (players >= Curve[last].x)
			{
				return Curve[last].y;
			}
			for (int i = 0; i < last; i++)
			{
				Vector2Int a = Curve[i];
				Vector2Int b = Curve[i + 1];
				if (players <= b.x)
				{
					float t = (float)(players - a.x) / (float)(b.x - a.x);
					return Mathf.FloorToInt(Mathf.Lerp(a.y, b.y, t) + 0.5f);
				}
			}
			return Curve[last].y;
		}

		public static int RosterSize(AgRoundProperties p)
		{
			if (p == null)
			{
				return 0;
			}
			return (p.alive?.Length ?? 0) + (p.eliminated?.Length ?? 0);
		}

		public static void Claim(double matchStamp, int players)
		{
			if (_claimedStamp.Equals(matchStamp))
			{
				return;
			}
			_claimedStamp = matchStamp;
			if (players < MinPlayers || !Qauth.IsLoggedIn)
			{
				return;
			}
			RunReward(players);
		}

		private static async void RunReward(int players)
		{
			QauthCloudResult res;
			try
			{
				res = await Qauth.CloudScript.RunAsync(CloudScriptFunction, new Dictionary<string, object> { { "playerCount", players } });
			}
			catch (Exception e)
			{
				Debug.LogError("[ApeGames] RecieveApeGameReward: " + e.Message);
				return;
			}
			if (res.Ok)
			{
				Bank((int?)res.Result?["gold"] ?? (int?)res.Reward?["coins"] ?? 0);
			}
			else
			{
				Debug.LogError("[ApeGames] RecieveApeGameReward rejected: " + (res.Error ?? "no result"));
			}
		}

		private static void Bank(int gold)
		{
			if (LocalProfileManager.Instance != null)
			{
				LocalProfileManager.Instance.FetchInventory();
			}
		}
	}
}
