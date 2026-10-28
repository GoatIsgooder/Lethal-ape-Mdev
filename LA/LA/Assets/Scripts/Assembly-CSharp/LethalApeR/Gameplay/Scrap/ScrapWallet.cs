using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ScrapWallet : MonoBehaviour
	{
		[Tooltip("Starting balance for a brand-new save.")]
		[SerializeField]
		private int startingBalance;

		[Tooltip("Keep the wallet alive across scene loads. Leave on for a global currency.")]
		[SerializeField]
		private bool persistAcrossScenes = true;

		private const string BalanceKey = "Wallet";

		private int _balance;

		public static ScrapWallet Instance { get; private set; }

		public int Balance => _balance;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
			if (persistAcrossScenes)
			{
				base.transform.SetParent(null);
				Object.DontDestroyOnLoad(base.gameObject);
			}
			_balance = Mathf.Max(0, ScrapSave.GetInt(BalanceKey, startingBalance));
		}

		private void Start()
		{
			ScrapEvents.RaiseBalanceChanged(_balance);
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
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

		private void Persist()
		{
			_balance = Mathf.Max(0, _balance);
			ScrapSave.SetInt(BalanceKey, _balance);
			ScrapEvents.RaiseBalanceChanged(_balance);
		}
	}
}
