using LethalApeR.Rivals.Economy;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.Shop
{
	public class KeysDisplay : MonoBehaviour
	{
		[Tooltip("Target text. Defaults to the TMP on this GameObject.")]
		[SerializeField]
		private TMP_Text text;

		[Tooltip("{0} is the balance.")]
		public string format = "KEYS: {0:N0}";

		private void OnEnable()
		{
			if (text == null)
			{
				text = GetComponent<TMP_Text>();
			}
			RivalsEvents.OnCoinsChanged += HandleCoinsChanged;
			HandleCoinsChanged((KeyManager.Instance != null) ? KeyManager.Instance.Balance : 0);
		}

		private void OnDisable()
		{
			RivalsEvents.OnCoinsChanged -= HandleCoinsChanged;
		}

		private void HandleCoinsChanged(int balance)
		{
			if (text != null)
			{
				text.text = string.Format(format, balance);
			}
		}
	}
}
