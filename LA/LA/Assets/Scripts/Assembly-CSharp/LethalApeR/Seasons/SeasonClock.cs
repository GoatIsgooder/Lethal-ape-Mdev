using System;

namespace LethalApeR.Seasons
{
	public static class SeasonClock
	{
		public const int AutumnStartMonth = 9;

		public const int AutumnStartDay = 1;

		public const int AutumnEndMonth = 11;

		public const int AutumnEndDay = 30;

		public static DateTime NowUtc => DateTime.UtcNow;

		public static bool IsAutumn => IsInWindow(9, 1, 11, 30);

		public static bool IsInWindow(int startMonth, int startDay, int endMonth, int endDay)
		{
			int now = Ordinal(NowUtc.Month, NowUtc.Day);
			int start = Ordinal(startMonth, startDay);
			int end = Ordinal(endMonth, endDay);
			if (start <= end)
			{
				return now >= start && now <= end;
			}
			return now >= start || now <= end;
		}

		public static int DaysRemainingInWindow(int startMonth, int startDay, int endMonth, int endDay)
		{
			if (!IsInWindow(startMonth, startDay, endMonth, endDay))
			{
				return 0;
			}
			DateTime today = NowUtc.Date;
			DateTime end = SafeDate(today.Year, endMonth, endDay);
			if (end < today)
			{
				end = SafeDate(today.Year + 1, endMonth, endDay);
			}
			return Math.Max(0, (int)(end - today).TotalDays);
		}

		private static int Ordinal(int month, int day)
		{
			month = Math.Clamp(month, 1, 12);
			day = Math.Clamp(day, 1, DateTime.DaysInMonth(2000, month));
			return new DateTime(2000, month, day).DayOfYear;
		}

		private static DateTime SafeDate(int year, int month, int day)
		{
			month = Math.Clamp(month, 1, 12);
			day = Math.Clamp(day, 1, DateTime.DaysInMonth(year, month));
			return new DateTime(year, month, day, 0, 0, 0, DateTimeKind.Utc);
		}
	}
}
