using System.Collections.Generic;
using LethalApeR.Rivals.Combat;
using LethalApeR.Rivals.Maps;
using LethalApeR.Rivals.Weapons;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Rivals.UI
{
	public class RivalsHudBinder : MonoBehaviour
	{
		[Header("Cached HUD values (read-only at runtime)")]
		[SerializeField]
		private int coins;

		[SerializeField]
		private GameState state;

		[SerializeField]
		private float stateTimeRemaining;

		[SerializeField]
		private int teamAWins;

		[SerializeField]
		private int teamBWins;

		[Header("UI events — wire these to your canvas")]
		public UnityEvent<int> onCoinsChanged;

		public UnityEvent<GameState> onStateChanged;

		public UnityEvent<float> onTimerTick;

		public UnityEvent<int, int> onScoreChanged;

		public UnityEvent<string> onKillFeedEntry;

		public UnityEvent<WeaponData> onWeaponUnlocked;

		public UnityEvent onLoadoutChanged;

		public UnityEvent<MapData> onMapSelected;

		[Header("Kill feed")]
		[Tooltip("How many recent kill-feed lines to keep.")]
		[SerializeField]
		private int killFeedLength = 5;

		private readonly Queue<string> _killFeed = new Queue<string>();

		public int Coins => coins;

		public GameState State => state;

		public float StateTimeRemaining => stateTimeRemaining;

		public int TeamAWins => teamAWins;

		public int TeamBWins => teamBWins;

		public IReadOnlyCollection<string> KillFeed => _killFeed;

		private void OnEnable()
		{
			RivalsEvents.OnCoinsChanged += HandleCoins;
			RivalsEvents.OnRoundStateChanged += HandleState;
			RivalsEvents.OnStateTimerTick += HandleTimer;
			RivalsEvents.OnScoreChanged += HandleScore;
			RivalsEvents.OnPlayerKilled += HandleKill;
			RivalsEvents.OnWeaponUnlocked += HandleUnlock;
			RivalsEvents.OnLoadoutChanged += HandleLoadout;
			RivalsEvents.OnMapSelected += HandleMap;
		}

		private void OnDisable()
		{
			RivalsEvents.OnCoinsChanged -= HandleCoins;
			RivalsEvents.OnRoundStateChanged -= HandleState;
			RivalsEvents.OnStateTimerTick -= HandleTimer;
			RivalsEvents.OnScoreChanged -= HandleScore;
			RivalsEvents.OnPlayerKilled -= HandleKill;
			RivalsEvents.OnWeaponUnlocked -= HandleUnlock;
			RivalsEvents.OnLoadoutChanged -= HandleLoadout;
			RivalsEvents.OnMapSelected -= HandleMap;
		}

		private void Update()
		{
			if (GamemodeManager.Instance != null)
			{
				stateTimeRemaining = GamemodeManager.Instance.StateTimeRemaining;
				onTimerTick?.Invoke(stateTimeRemaining);
			}
		}

		private void HandleCoins(int balance)
		{
			coins = balance;
			onCoinsChanged?.Invoke(balance);
		}

		private void HandleState(GameState s)
		{
			state = s;
			onStateChanged?.Invoke(s);
		}

		private void HandleTimer(float remaining)
		{
			stateTimeRemaining = remaining;
			onTimerTick?.Invoke(remaining);
		}

		private void HandleScore(int a, int b)
		{
			teamAWins = a;
			teamBWins = b;
			onScoreChanged?.Invoke(a, b);
		}

		private void HandleUnlock(WeaponData w)
		{
			onWeaponUnlocked?.Invoke(w);
		}

		private void HandleLoadout()
		{
			onLoadoutChanged?.Invoke();
		}

		private void HandleMap(MapData m)
		{
			onMapSelected?.Invoke(m);
		}

		private void HandleKill(KillInfo info)
		{
			string text = FormatKill(info);
			_killFeed.Enqueue(text);
			while (_killFeed.Count > killFeedLength)
			{
				_killFeed.Dequeue();
			}
			onKillFeedEntry?.Invoke(text);
		}

		protected virtual string FormatKill(KillInfo info)
		{
			return string.Format("Player {0} {1} Player {2} [{3}]", info.KillerActorNumber, info.WasHeadshot ? "headshot" : "killed", info.VictimActorNumber, info.WeaponName);
		}
	}
}
