using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using Newtonsoft.Json.Linq;
using QauthSdk;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmLeaderboardDisplay : MonoBehaviour
	{
		[Header("Text targets")]
		[Tooltip("Top-N rows. One TMP, one row per line.")]
		public TMP_Text boardText;

		[Tooltip("Separate bottom line: your global position and win count.")]
		public TMP_Text yourStatsText;

		[Header("Settings")]
		[Tooltip("How many top players to show.")]
		[Range(1f, 100f)]
		public int topCount = 10;

		[Tooltip("Seconds between automatic refreshes.")]
		public float refreshInterval = 120f;

		[Tooltip("Optional heading rendered above the rows.")]
		public string heading = "BE THE MONSTER — ROUND WINS";

		[Tooltip("Heading size as a percentage of the row text size (100 = same size).")]
		[Range(100f, 300f)]
		public int headingSizePercent = 175;

		private const string LocalRowHex = "FFD24A";

		private const float FetchCooldown = 8f;

		private Coroutine _loop;

		private bool _refreshQueued;

		private float _cooldownUntil;

		private float _nextAutoRefresh;

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
			BTMLeaderboard.OnWinsChanged += HandleWinsChanged;
			BTMLeaderboard.OnStatisticPushed += QueueRefresh;
			BTMLeaderboard.OnRefreshRequested += QueueRefresh;
			_loop = StartCoroutine(RefreshLoop());
		}

		private void OnDisable()
		{
			BTMLeaderboard.OnWinsChanged -= HandleWinsChanged;
			BTMLeaderboard.OnStatisticPushed -= QueueRefresh;
			BTMLeaderboard.OnRefreshRequested -= QueueRefresh;
			if (_loop != null)
			{
				StopCoroutine(_loop);
				_loop = null;
			}
		}

		private void HandleWinsChanged(int wins)
		{
			if (yourStatsText != null)
			{
				yourStatsText.text = string.Format("{0:N0} WINS — updating…", wins);
			}
			_refreshQueued = true;
		}

		private void QueueRefresh()
		{
			_refreshQueued = true;
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
			WaitForSeconds tick = new WaitForSeconds(1f);
			while (!Qauth.IsLoggedIn)
			{
				yield return tick;
			}
			BTMLeaderboard.PushStatistic();
			Refresh();
			while (true)
			{
				yield return tick;
				if (BTMLeaderboard.StatPushPending)
				{
					BTMLeaderboard.PushStatistic();
				}
				if ((_refreshQueued || Time.unscaledTime >= _nextAutoRefresh) && Time.unscaledTime >= _cooldownUntil)
				{
					Refresh();
				}
			}
		}

		public void Refresh()
		{
			if (Qauth.IsLoggedIn)
			{
				_refreshQueued = false;
				_cooldownUntil = Time.unscaledTime + 8f;
				_nextAutoRefresh = Time.unscaledTime + Mathf.Max(15f, refreshInterval);
				FetchTopBoard();
				FetchYourPosition();
			}
		}

		private async void FetchTopBoard()
		{
			List<QauthLeaderboardEntry> leaderboard;
			try
			{
				leaderboard = await Qauth.Leaderboards.TopAsync(BTMLeaderboard.StatisticName, topCount);
			}
			catch (Exception error)
			{
				if (boardText != null)
				{
					boardText.text = FormattedHeading() + "\nLeaderboard unavailable.";
				}
				Debug.LogWarning("[BtmLeaderboard] GetLeaderboard failed: " + error.Message);
				return;
			}
			if (boardText == null || leaderboard == null)
			{
				return;
			}
			string localName = LocalPlayerName();
			StringBuilder sb = new StringBuilder();
			if (!string.IsNullOrEmpty(heading))
			{
				sb.AppendLine(FormattedHeading());
			}
			foreach (QauthLeaderboardEntry entry in leaderboard)
			{
				string name = (string.IsNullOrEmpty(entry.Name) ? "UNKNOWN" : entry.Name);
				string line = string.Format("{0}. {1} — {2:N0}", entry.Rank, name, entry.Value);
				if (!string.IsNullOrEmpty(localName) && entry.Name == localName)
				{
					line = "<color=#FFD24A>" + line + "</color>";
				}
				sb.AppendLine(line);
			}
			if (leaderboard.Count == 0)
			{
				sb.AppendLine("No wins recorded yet — win a round!");
			}
			boardText.text = sb.ToString().TrimEnd();
		}

		private void FetchYourPosition()
		{
			if (yourStatsText == null)
			{
				return;
			}
			int localWins = BTMLeaderboard.Wins;
			if (localWins <= 0)
			{
				yourStatsText.text = "UNRANKED • 0 WINS";
				return;
			}
			FetchYourPlace(localWins);
		}

		private async void FetchYourPlace(int localWins)
		{
			QauthResponse result;
			try
			{
				result = await Qauth.Leaderboards.MeAsync();
			}
			catch (Exception error)
			{
				result = null;
				Debug.LogWarning("[BtmLeaderboard] GetLeaderboardAroundPlayer failed: " + error.Message);
			}
			if (yourStatsText == null)
			{
				return;
			}
			if (result == null || !result.Ok)
			{
				yourStatsText.text = string.Format("{0:N0} WINS", localWins);
				if (result != null)
				{
					Debug.LogWarning("[BtmLeaderboard] GetLeaderboardAroundPlayer failed: " + result.Error);
				}
				return;
			}
			if (TryGetMyPlace(result, BTMLeaderboard.StatisticName, out int position, out long value) && value >= 1)
			{
				long wins = Math.Max(value, BTMLeaderboard.Wins);
				yourStatsText.text = string.Format("#{0} GLOBAL • {1:N0} WINS", position, wins);
			}
			else
			{
				yourStatsText.text = string.Format("UNRANKED • {0:N0} WINS", localWins);
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
