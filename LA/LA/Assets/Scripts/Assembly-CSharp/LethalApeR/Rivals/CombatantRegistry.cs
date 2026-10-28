using System.Collections.Generic;
using LethalApeR.Rivals.Combat;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public static class CombatantRegistry
	{
		private static readonly HashSet<IDamageable> _all = new HashSet<IDamageable>();

		public static IReadOnlyCollection<IDamageable> All => _all;

		public static void Register(IDamageable c)
		{
			if (c != null)
			{
				_all.Add(c);
			}
		}

		public static void Unregister(IDamageable c)
		{
			if (c != null)
			{
				_all.Remove(c);
			}
		}

		public static int AliveCount(Team team)
		{
			int num = 0;
			foreach (IDamageable item in _all)
			{
				if (item != null && item.IsAlive && item.Team == team)
				{
					num++;
				}
			}
			return num;
		}

		public static int AliveCountPlaying()
		{
			return AliveCount(Team.TeamA) + AliveCount(Team.TeamB);
		}

		public static bool TryGetSoleSurvivingTeam(out Team survivor)
		{
			int num = AliveCount(Team.TeamA);
			int num2 = AliveCount(Team.TeamB);
			if (num > 0 && num2 == 0)
			{
				survivor = Team.TeamA;
				return true;
			}
			if (num2 > 0 && num == 0)
			{
				survivor = Team.TeamB;
				return true;
			}
			survivor = Team.None;
			return false;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void Reset()
		{
			_all.Clear();
		}
	}
}
