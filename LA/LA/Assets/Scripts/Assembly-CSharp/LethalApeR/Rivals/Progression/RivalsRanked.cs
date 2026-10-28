using System;
using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using LethalApeR.Rivals.Economy;
using Photon.Pun;
using Photon.Realtime;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	[Obfuscation(Exclude = true)]
	public static class RivalsRanked
	{
		public const string RpProp = "rivalsRp";

		public const string RpStatistic = "RivalsRP";

		private const string RpKey = "Progression.RankPoints";

		private static int _rp = -1;

		private static bool _statDirty;

		private static int _lastPushedRp = -1;

		public static int Rp
		{
			get
			{
				if (_rp < 0)
				{
					_rp = Mathf.Max(0, SaveWrapper.GetInt(RpKey, 0));
				}
				return _rp;
			}
		}

		public static RivalsRank Rank => RankDefs.RankForRp(Rp);

		public static bool StatPushPending => _statDirty;

		public static event Action<int, int> OnRpChanged;

		public static event Action<RivalsRank, RivalsRank> OnRankChanged;

		public static int ApplyMatchResult(bool won)
		{
			RivalsRank rank = Rank;
			int rp = Rp;
			int delta = (won ? RankDefs.WinRp(rank) : (-RankDefs.LossRp(rank)));
			int newRp = Mathf.Max(0, rp + delta);
			int applied = newRp - rp;
			_rp = newRp;
			SaveWrapper.SetInt(RpKey, newRp);
			PushRpProp();
			PushStatistic();
			OnRpChanged?.Invoke(applied, newRp);
			RivalsRank newRank = RankDefs.RankForRp(newRp);
			if (newRank != rank)
			{
				OnRankChanged?.Invoke(rank, newRank);
				Debug.Log("[RivalsRanked] " + ((newRank > rank) ? "RANK UP" : "DERANK") + " → " + string.Format("{0} ({1} RP)", RankDefs.DisplayName(newRank), newRp));
			}
			return applied;
		}

		public static void PushRpProp()
		{
			if (PhotonNetwork.IsConnectedAndReady)
			{
				Player localPlayer = PhotonNetwork.LocalPlayer;
				Hashtable hashtable = new Hashtable();
				hashtable.Add(RpProp, Rp);
				localPlayer.SetCustomProperties(hashtable);
			}
		}

		public static bool TryGetRp(Player player, out int rp)
		{
			rp = 0;
			object value;
			if (player?.CustomProperties == null || !player.CustomProperties.TryGetValue(RpProp, out value) || !(value is int num))
			{
				return false;
			}
			rp = Mathf.Max(0, num);
			return true;
		}

		public static void PushStatistic()
		{
			if (!Qauth.IsLoggedIn)
			{
				_statDirty = true;
			}
			else if (_statDirty || Rp != _lastPushedRp)
			{
				_statDirty = false;
				SubmitRp(Rp);
			}
		}

		private static async void SubmitRp(int rp)
		{
			string error = "rejected by Qauth";
			bool ok;
			try
			{
				ok = await Qauth.Leaderboards.SubmitAsync(RpStatistic, rp);
			}
			catch (Exception ex)
			{
				ok = false;
				error = ex.Message;
			}
			if (ok)
			{
				_lastPushedRp = rp;
			}
			else
			{
				_statDirty = true;
				Debug.LogWarning("[RivalsRanked] RP statistic push failed: " + error);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_rp = -1;
			_lastPushedRp = -1;
			_statDirty = false;
			OnRpChanged = null;
			OnRankChanged = null;
		}
	}
}
