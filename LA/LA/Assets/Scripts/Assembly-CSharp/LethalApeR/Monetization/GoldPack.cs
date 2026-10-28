using System;
using UnityEngine;

namespace LethalApeR.Monetization
{
	[Serializable]
	public class GoldPack
	{
		[Tooltip("Meta add-on SKU. CASE-SENSITIVE — must match the dashboard exactly, and the add-on must be of type Consumable.")]
		public string sku;

		[Tooltip("Gold shown on the button. Display only — the server decides what is actually credited.")]
		public int gold = 1000;

		[Tooltip("Optional flash above the button, e.g. \"BEST VALUE\" or \"+20% BONUS\". Leave empty for none.")]
		public string badge;

		public bool IsValid => !string.IsNullOrWhiteSpace(sku) && gold > 0;
	}
}
