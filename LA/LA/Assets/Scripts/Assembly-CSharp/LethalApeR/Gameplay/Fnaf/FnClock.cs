using Photon.Pun;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnClock
	{
		private const double WrapSeconds = 4294967.296;

		public static double Now => PhotonNetwork.Time;

		public static int ServerMs => PhotonNetwork.ServerTimestamp;

		public static double Since(double stamp)
		{
			double num = PhotonNetwork.Time - stamp;
			if (num < -WrapSeconds * 0.5)
			{
				num += WrapSeconds;
			}
			else if (num > WrapSeconds * 0.5)
			{
				num -= WrapSeconds;
			}
			return num;
		}

		public static double Until(double stamp)
		{
			return -Since(stamp);
		}

		public static bool Reached(double stamp)
		{
			if (stamp > 0.0)
			{
				return Since(stamp) >= 0.0;
			}
			return false;
		}

		public static int MsUntil(int serverDeadline)
		{
			return serverDeadline - PhotonNetwork.ServerTimestamp;
		}

		public static int DeadlineIn(int milliseconds)
		{
			int num = PhotonNetwork.ServerTimestamp + milliseconds;
			if (num == 0)
			{
				return 1;
			}
			return num;
		}
	}
}
