using System;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassClock
	{
		private const double ResyncSeconds = 600.0;

		private const double RetrySeconds = 30.0;

		private const float UnsyncedTrustSeconds = 20f;

		private static readonly DateTime Epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

		private static DateTime _serverAnchor;

		private static double _realtimeAnchor;

		private static double _nextSyncAt;

		private static bool _inFlight;

		public static bool Synced { get; private set; }

		public static DateTime UtcNow
		{
			get
			{
				if (Synced)
				{
					return _serverAnchor.AddSeconds(Time.realtimeSinceStartupAsDouble - _realtimeAnchor);
				}
				return DateTime.UtcNow;
			}
		}

		public static int DayNumber => (int)Math.Floor((UtcNow - Epoch).TotalDays);

		public static DateTime NextDailyResetUtc => Epoch.AddDays(DayNumber + 1);

		public static bool Settled
		{
			get
			{
				if (Synced)
				{
					return true;
				}
				return Time.realtimeSinceStartup > 20f;
			}
		}

		public static event Action SyncedChanged;

		public static async void TrySync()
		{
			if (_inFlight || Time.realtimeSinceStartupAsDouble < _nextSyncAt || !Qauth.IsLoggedIn)
			{
				return;
			}
			_inFlight = true;
			double sentAt = Time.realtimeSinceStartupAsDouble;
			DateTime result;
			try
			{
				result = await Qauth.ServerTimeAsync();
			}
			catch (Exception)
			{
				_inFlight = false;
				_nextSyncAt = Time.realtimeSinceStartupAsDouble + 30.0;
				return;
			}
			_inFlight = false;
			double realtimeSinceStartupAsDouble = Time.realtimeSinceStartupAsDouble;
			double value = (realtimeSinceStartupAsDouble - sentAt) * 0.5;
			_serverAnchor = DateTime.SpecifyKind(result, DateTimeKind.Utc).AddSeconds(value);
			_realtimeAnchor = realtimeSinceStartupAsDouble;
			_nextSyncAt = realtimeSinceStartupAsDouble + 600.0;
			bool synced = Synced;
			Synced = true;
			if (!synced)
			{
				SyncedChanged?.Invoke();
			}
		}

		public static void MarkStale()
		{
			_nextSyncAt = 0.0;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_nextSyncAt = 0.0;
			_inFlight = false;
			Synced = false;
			SyncedChanged = null;
		}
	}
}
