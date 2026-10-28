using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ScrapWalletDisplay : MonoBehaviour
	{
		[Tooltip("Target text. Defaults to the TMP on this GameObject.")]
		[SerializeField]
		private TMP_Text text;

		[Tooltip("{0} is the balance.")]
		public string format = "SCRAP: {0:N0}";

		private void OnEnable()
		{
			if (text == null)
			{
				text = GetComponent<TMP_Text>();
			}
			ScrapEvents.OnBalanceChanged += HandleBalanceChanged;
			HandleBalanceChanged((ScrapWallet.Instance != null) ? ScrapWallet.Instance.Balance : 0);
		}

		private void OnDisable()
		{
			ScrapEvents.OnBalanceChanged -= HandleBalanceChanged;
		}

		private void HandleBalanceChanged(int balance)
		{
			if (text != null)
			{
				text.text = string.Format(format, balance);
			}
		}
	}
}
