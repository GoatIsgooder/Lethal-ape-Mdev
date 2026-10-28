using System;
using LethalApeR.Rivals.Combat;
using LethalApeR.Rivals.Maps;
using LethalApeR.Rivals.Weapons;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public static class RivalsEvents
	{
		public static event Action<GameState> OnRoundStateChanged;

		public static event Action<float> OnStateTimerTick;

		public static event Action<KillInfo> OnPlayerKilled;

		public static event Action<PlayerHealth, float, int> OnPlayerDamaged;

		public static event Action<DamageInfo, UnityEngine.Object> OnLocalHitDealt;

		public static event Action<float, bool, int> OnLocalDamaged;

		public static event Action<int> OnCoinsChanged;

		public static event Action<WeaponData> OnWeaponUnlocked;

		public static event Action OnLoadoutChanged;

		public static event Action<int, int> OnScoreChanged;

		public static event Action<MapData> OnMapSelected;

		public static event Action<MatchResultInfo> OnMatchCompleted;

		public static event Action OnLocalRoundWon;

		public static void RaiseRoundStateChanged(GameState s)
		{
			RivalsEvents.OnRoundStateChanged?.Invoke(s);
		}

		public static void RaiseStateTimerTick(float secondsRemaining)
		{
			RivalsEvents.OnStateTimerTick?.Invoke(secondsRemaining);
		}

		public static void RaisePlayerKilled(in KillInfo info)
		{
			RivalsEvents.OnPlayerKilled?.Invoke(info);
		}

		public static void RaisePlayerDamaged(PlayerHealth victim, float amount, int attackerActor)
		{
			RivalsEvents.OnPlayerDamaged?.Invoke(victim, amount, attackerActor);
		}

		public static void RaiseLocalHitDealt(in DamageInfo info, UnityEngine.Object victim)
		{
			RivalsEvents.OnLocalHitDealt?.Invoke(info, victim);
		}

		public static void RaiseLocalDamaged(float amount, bool headshot, int attackerActor)
		{
			RivalsEvents.OnLocalDamaged?.Invoke(amount, headshot, attackerActor);
		}

		public static void RaiseCoinsChanged(int balance)
		{
			RivalsEvents.OnCoinsChanged?.Invoke(balance);
		}

		public static void RaiseWeaponUnlocked(WeaponData w)
		{
			RivalsEvents.OnWeaponUnlocked?.Invoke(w);
		}

		public static void RaiseLoadoutChanged()
		{
			RivalsEvents.OnLoadoutChanged?.Invoke();
		}

		public static void RaiseScoreChanged(int teamA, int teamB)
		{
			RivalsEvents.OnScoreChanged?.Invoke(teamA, teamB);
		}

		public static void RaiseMapSelected(MapData m)
		{
			RivalsEvents.OnMapSelected?.Invoke(m);
		}

		public static void RaiseMatchCompleted(MatchResultInfo info)
		{
			RivalsEvents.OnMatchCompleted?.Invoke(info);
		}

		public static void RaiseLocalRoundWon()
		{
			RivalsEvents.OnLocalRoundWon?.Invoke();
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			RivalsEvents.OnRoundStateChanged = null;
			RivalsEvents.OnStateTimerTick = null;
			RivalsEvents.OnPlayerKilled = null;
			RivalsEvents.OnPlayerDamaged = null;
			RivalsEvents.OnLocalHitDealt = null;
			RivalsEvents.OnLocalDamaged = null;
			RivalsEvents.OnCoinsChanged = null;
			RivalsEvents.OnWeaponUnlocked = null;
			RivalsEvents.OnLoadoutChanged = null;
			RivalsEvents.OnScoreChanged = null;
			RivalsEvents.OnMapSelected = null;
			RivalsEvents.OnMatchCompleted = null;
			RivalsEvents.OnLocalRoundWon = null;
		}
	}
}
