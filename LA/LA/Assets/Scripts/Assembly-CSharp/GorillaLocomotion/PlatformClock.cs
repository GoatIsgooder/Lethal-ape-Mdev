using Photon.Pun;
using UnityEngine;

namespace GorillaLocomotion
{
	public static class PlatformClock
	{
		public static double Now
		{
			get
			{
				if (PhotonNetwork.InRoom)
				{
					return (double)(uint)PhotonNetwork.ServerTimestamp / 1000.0;
				}
				return Time.timeAsDouble;
			}
		}

		public static int NowMs
		{
			get
			{
				if (PhotonNetwork.InRoom)
				{
					return PhotonNetwork.ServerTimestamp;
				}
				return (int)(Time.timeAsDouble * 1000.0);
			}
		}

		public static float SecondsSince(int startMs)
		{
			return (float)(NowMs - startMs) / 1000f;
		}
	}
}
