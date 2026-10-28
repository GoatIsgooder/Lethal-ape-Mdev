using System;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassText
	{
		public static string Rarity(SeasonRarity rarity)
		{
			return rarity switch
			{
				SeasonRarity.Epic => "EPIC",
				SeasonRarity.Legendary => "LEGENDARY",
				_ => "RARE",
			};
		}

		public static string Track(SeasonTrack track)
		{
			if (track != SeasonTrack.Free)
			{
				return "PREMIUM";
			}
			return "FREE";
		}

		public static string Countdown(TimeSpan span)
		{
			if (span < TimeSpan.Zero)
			{
				span = TimeSpan.Zero;
			}
			if (span.TotalDays >= 1.0)
			{
				return string.Format("{0}D {1:00}H", (int)span.TotalDays, span.Hours);
			}
			if (span.TotalHours >= 1.0)
			{
				return string.Format("{0}H {1:00}M", span.Hours, span.Minutes);
			}
			return string.Format("{0}M {1:00}S", span.Minutes, span.Seconds);
		}

		public static TimeSpan CountdownStep(TimeSpan span)
		{
			if (span.TotalDays >= 1.0)
			{
				return TimeSpan.FromHours(1.0);
			}
			if (span.TotalHours >= 1.0)
			{
				return TimeSpan.FromMinutes(1.0);
			}
			return TimeSpan.FromSeconds(1.0);
		}
	}
}
