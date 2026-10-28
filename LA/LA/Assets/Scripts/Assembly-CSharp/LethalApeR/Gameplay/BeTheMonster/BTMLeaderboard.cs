using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Rivals.Economy;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public static class BTMLeaderboard
	{
		private const string WinsKey = "Progression.BtmWins";

		private const float RetryInterval = 30f;

		private static int _wins = -1;

		private static bool _statDirty;

		private static int _lastPushedWins = -1;

		private static int _lastAttemptedWins = -1;

		private static float _retryCooldownUntil;

		public static string StatisticName => "BTM_Wins";

		public static int Wins
		{
			get
			{
				if (_wins < 0)
				{
					_wins = Mathf.Max(0, SaveWrapper.GetInt("Progression.BtmWins"));
				}
				return _wins;
			}
		}

		public static bool StatPushPending => _statDirty;

		public static event Action<int> OnWinsChanged;

		public static event Action OnStatisticPushed;

		public static event Action OnRefreshRequested;

		public static void AddWin()
		{
			_wins = Wins + 1;
			SaveWrapper.SetInt("Progression.BtmWins", _wins);
			OnWinsChanged?.Invoke(_wins);
			PushStatistic();
		}

		public static void RequestRefresh()
		{
			OnRefreshRequested?.Invoke();
		}

		public static void PushStatistic()
		{
			if (Wins < 1)
			{
				return;
			}
			if (!Qauth.IsLoggedIn)
			{
				_statDirty = true;
			}
			else if ((_statDirty || Wins != _lastPushedWins) && (Wins != _lastAttemptedWins || !(Time.unscaledTime < _retryCooldownUntil)))
			{
				_statDirty = false;
				int wins = Wins;
				_lastAttemptedWins = wins;
				SubmitWins(wins);
			}
		}

		private static async void SubmitWins(int wins)
		{
			bool ok;
			string error = "rejected by Qauth";
			try
			{
				ok = await Qauth.Leaderboards.SubmitAsync(StatisticName, wins);
			}
			catch (Exception ex)
			{
				ok = false;
				error = ex.Message;
			}
			if (ok)
			{
				if (wins > _lastPushedWins)
				{
					_lastPushedWins = wins;
				}
				if (wins < Wins)
				{
					_statDirty = true;
				}
				OnStatisticPushed?.Invoke();
			}
			else
			{
				_statDirty = true;
				_retryCooldownUntil = Time.unscaledTime + 30f;
				Debug.LogWarning("[BTMLeaderboard] wins statistic push failed: " + error);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_wins = -1;
			_statDirty = false;
			_lastPushedWins = -1;
			_lastAttemptedWins = -1;
			_retryCooldownUntil = 0f;
			OnWinsChanged = null;
			OnStatisticPushed = null;
			OnRefreshRequested = null;
		}
	}
}
