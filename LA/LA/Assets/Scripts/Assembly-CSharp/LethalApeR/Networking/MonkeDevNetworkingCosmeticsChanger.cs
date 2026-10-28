using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevNetworkingCosmeticsChanger : MonoBehaviour
	{
		[Serializable]
		public class MonkeDevNetworkingCosmeticTest
		{
			public string SlotName;

			public string Cosmetic;
		}

		public List<MonkeDevNetworkingCosmeticTest> Cosmetics = new List<MonkeDevNetworkingCosmeticTest>();

		public void ChangeCosmetics(Dictionary<string, string> Cosmetics)
		{
			MonkeDevNetworkingManager.SetCosmetics(Cosmetics);
		}
	}
}
