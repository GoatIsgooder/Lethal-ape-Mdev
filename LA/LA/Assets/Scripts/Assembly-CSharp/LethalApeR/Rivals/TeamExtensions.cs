using UnityEngine;

namespace LethalApeR.Rivals
{
	public static class TeamExtensions
	{
		public static readonly Color ColorTeamA = new Color(0.2f, 0.55f, 1f, 1f);

		public static readonly Color ColorTeamB = new Color(1f, 0.45f, 0.15f, 1f);

		public static readonly Color ColorNone = new Color(0.6f, 0.6f, 0.6f, 1f);

		public static Team Opposing(this Team team)
		{
			switch (team)
			{
			case Team.TeamA:
				return Team.TeamB;
			case Team.TeamB:
				return Team.TeamA;
			default:
				return Team.None;
			}
		}

		public static Color ToColor(this Team team)
		{
			switch (team)
			{
			case Team.TeamA:
				return ColorTeamA;
			case Team.TeamB:
				return ColorTeamB;
			default:
				return ColorNone;
			}
		}

		public static bool IsSameTeam(this Team a, Team b)
		{
			if (a != Team.None)
			{
				return a == b;
			}
			return false;
		}
	}
}
