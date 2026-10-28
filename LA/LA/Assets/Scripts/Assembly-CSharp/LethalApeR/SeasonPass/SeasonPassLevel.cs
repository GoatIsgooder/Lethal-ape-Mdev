using System;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonPassLevel
	{
		public SeasonTrack track;

		public SeasonPassReward reward = new SeasonPassReward();
	}
}
