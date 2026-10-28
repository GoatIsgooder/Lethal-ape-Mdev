using UnityEngine;

namespace LethalApeR.Rivals.Economy
{
	public class KeyManager : MonoBehaviour
	{
		[Header("Config")]
		[Tooltip("Coin award amounts. Required — assign an EconomyConfig asset.")]
		[SerializeField]
		private EconomyConfig config;

		private const string BalanceKey = "Coins";

		private int _balance;

		public static KeyManager Instance { get; private set; }

		public int Balance => _balance;

		public EconomyConfig Config => config;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
			_balance = Mathf.Max(0, SaveWrapper.GetInt(BalanceKey, (config != null) ? config.startingBalance : 0));
		}

		private void Start()
		{
			RivalsEvents.RaiseCoinsChanged(_balance);
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public int GetBalance()
		{
			return _balance;
		}

		public void Add(int amount)
		{
			if (amount > 0)
			{
				_balance += amount;
				Persist();
			}
		}

		public bool TrySpend(int amount)
		{
			if (amount <= 0)
			{
				return true;
			}
			if (_balance < amount)
			{
				return false;
			}
			_balance -= amount;
			Persist();
			return true;
		}

		public bool CanAfford(int amount)
		{
			return _balance >= amount;
		}

		public void AwardKill()
		{
			if ((bool)config)
			{
				Add(config.coinsPerKill);
			}
		}

		public void AwardAssist()
		{
			if ((bool)config)
			{
				Add(config.coinsPerAssist);
			}
		}

		public void AwardRoundWin()
		{
			if ((bool)config)
			{
				Add(config.coinsPerRoundWin);
			}
		}

		public void AwardMatchWin()
		{
			if ((bool)config)
			{
				Add(config.coinsPerMatchWin);
			}
		}

		public void AwardObjective()
		{
			if ((bool)config)
			{
				Add(config.coinsPerObjective);
			}
		}

		private void Persist()
		{
			_balance = Mathf.Max(0, _balance);
			SaveWrapper.SetInt(BalanceKey, _balance);
			RivalsEvents.RaiseCoinsChanged(_balance);
		}

		private void OnValidate()
		{
			if (config == null)
			{
				Debug.LogWarning("[KeyManager] No EconomyConfig assigned on '" + base.name + "'. Award helpers will no-op.", this);
			}
		}
	}
}
