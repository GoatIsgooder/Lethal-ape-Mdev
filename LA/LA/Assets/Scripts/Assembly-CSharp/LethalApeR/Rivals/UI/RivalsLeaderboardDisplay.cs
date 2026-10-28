using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using LethalApeR.Rivals.Progression;
using Newtonsoft.Json.Linq;
using QauthSdk;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.UI
{
	[Obfuscation(Exclude = true)]
	public class RivalsLeaderboardDisplay : MonoBehaviour
	{
		[Header("Text targets")]
		[Tooltip("Top-N rows. One TMP, one row per line.")]
		public TMP_Text boardText;

		[Tooltip("Separate bottom line: your global position, rank, level and kills.")]
		public TMP_Text yourStatsText;

		[Header("Settings")]
		[Tooltip("How many top players to show.")]
		[Range(1f, 100f)]
		public int topCount = 10;

		[Tooltip("Seconds between automatic refreshes.")]
		public float refreshInterval = 120f;

		[Tooltip("Optional heading rendered above the rows.")]
		public string heading = "RIVALS — WORLD KILLS";

		[Tooltip("Heading size as a percentage of the row text size (100 = same size).")]
		[Range(100f, 300f)]
		public int headingSizePercent = 175;

		private const string LocalRowHex = "FFD24A";

		private string FormattedHeading()
		{
			if (string.IsNullOrEmpty(heading))
			{
				return "";
			}
			return string.Format("<size={0}%><b>{1}</b></size>", headingSizePercent, heading);
		}

		private void OnEnable()
		{
			StartCoroutine(RefreshLoop());
		}

		private IEnumerator RefreshLoop()
		{
			if (boardText != null)
			{
				boardText.text = FormattedHeading();
			}
			if (yourStatsText != null)
			{
				yourStatsText.text = "";
			}
			while (!Qauth.IsLoggedIn)
			{
				yield return new WaitForSeconds(1f);
			}
			WaitForSeconds wait = new WaitForSeconds(Mathf.Max(15f, refreshInterval));
			while (true)
			{
				Refresh();
				yield return wait;
			}
		}

		public void Refresh()
		{
			if (Qauth.IsLoggedIn)
			{
				FetchTopBoard();
				FetchYourPosition();
			}
		}

		private async void FetchTopBoard()
		{
			List<QauthLeaderboardEntry> leaderboard;
			try
			{
				leaderboard = await Qauth.Leaderboards.TopAsync("RivalsKills", topCount);
			}
			catch (Exception error)
			{
				if (boardText != null)
				{
					boardText.text = FormattedHeading() + "\nLeaderboard unavailable.";
				}
				Debug.LogWarning("[RivalsLeaderboard] GetLeaderboard failed: " + error.Message);
				return;
			}
			if (boardText == null || leaderboard == null)
			{
				return;
			}
			string text = LocalPlayerName();
			StringBuilder stringBuilder = new StringBuilder();
			if (!string.IsNullOrEmpty(heading))
			{
				stringBuilder.AppendLine(FormattedHeading());
			}
			foreach (QauthLeaderboardEntry item in leaderboard)
			{
				string text2 = (string.IsNullOrEmpty(item.Name) ? "UNKNOWN" : item.Name);
				string text3 = string.Format("{0}. {1} — {2:N0}", item.Rank, text2, item.Value);
				if (!string.IsNullOrEmpty(text) && item.Name == text)
				{
					text3 = "<color=#" + LocalRowHex + ">" + text3 + "</color>";
				}
				stringBuilder.AppendLine(text3);
			}
			if (leaderboard.Count == 0)
			{
				stringBuilder.AppendLine("No entries yet — go get some kills!");
			}
			boardText.text = stringBuilder.ToString().TrimEnd();
		}

		private void FetchYourPosition()
		{
			if (yourStatsText == null)
			{
				return;
			}
			RivalsProgression instance = RivalsProgression.Instance;
			int num = ((instance != null) ? instance.Level : RivalsRankedQueue.LocalLevel());
			RivalsRank rank = RivalsRanked.Rank;
			string rankPart = string.Format("<color=#{0}>{1}</color> {2}", RankDefs.RankColorHex(rank), RankDefs.DisplayName(rank), num);
			int kills = ((instance != null) ? instance.LifetimeKills : 0);
			if (kills <= 0)
			{
				yourStatsText.text = "UNRANKED • " + rankPart + " • 0 KILLS";
				return;
			}
			FetchYourPlace(rankPart, kills);
		}

		private async void FetchYourPlace(string rankPart, int kills)
		{
			QauthResponse result;
			try
			{
				result = await Qauth.Leaderboards.MeAsync();
			}
			catch (Exception error)
			{
				result = null;
				Debug.LogWarning("[RivalsLeaderboard] GetLeaderboardAroundPlayer failed: " + error.Message);
			}
			if (yourStatsText == null)
			{
				return;
			}
			if (result == null || !result.Ok)
			{
				yourStatsText.text = string.Format("{0} • {1:N0} KILLS", rankPart, kills);
				if (result != null)
				{
					Debug.LogWarning("[RivalsLeaderboard] GetLeaderboardAroundPlayer failed: " + result.Error);
				}
				return;
			}
			if (TryGetMyPlace(result, "RivalsKills", out int position, out long value))
			{
				yourStatsText.text = string.Format("#{0} GLOBAL • {1} • {2:N0} KILLS", position, rankPart, value);
			}
			else
			{
				yourStatsText.text = string.Format("UNRANKED • {0} • {1:N0} KILLS", rankPart, kills);
			}
		}

		private static bool TryGetMyPlace(QauthResponse result, string stat, out int position, out long value)
		{
			position = 0;
			value = 0L;
			if (!(result?.Json?["scores"] is JArray scores))
			{
				return false;
			}
			foreach (JToken score in scores)
			{
				if (score?["stat"]?.Value<string>() == stat)
				{
					position = score["rank"]?.Value<int>() ?? 0;
					value = score["value"]?.Value<long>() ?? 0L;
					return position > 0;
				}
			}
			return false;
		}

		private static string LocalPlayerName()
		{
			return Qauth.AccountName ?? "";
		}
	}
}
