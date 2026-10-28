using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace LethalApeR.Monetization
{
	[Obfuscation(Exclude = true)]
	[CreateAssetMenu(fileName = "AtmCatalog", menuName = "Slop-Game/Monetization/ATM Catalog")]
	public class AtmCatalog : ScriptableObject
	{
		public const string ResourcePath = "AtmCatalog";

		[SerializeField]
		private List<GoldPack> packs = new List<GoldPack>();

		private string[] _skuCache;

		private static AtmCatalog _loaded;

		private static bool _loadAttempted;

		public IReadOnlyList<GoldPack> Packs => packs;

		public int PackCount => packs != null ? packs.Count : 0;

		public string[] AllSkus()
		{
			if (_skuCache != null)
			{
				return _skuCache;
			}
			List<string> list = new List<string>(PackCount);
			for (int i = 0; i < PackCount; i++)
			{
				GoldPack goldPack = packs[i];
				if (goldPack != null && goldPack.IsValid)
				{
					list.Add(goldPack.sku.Trim());
				}
			}
			_skuCache = list.ToArray();
			return _skuCache;
		}

		public bool TryGetPack(string sku, out GoldPack pack)
		{
			pack = null;
			if (string.IsNullOrWhiteSpace(sku))
			{
				return false;
			}
			string b = sku.Trim();
			for (int i = 0; i < PackCount; i++)
			{
				GoldPack goldPack = packs[i];
				if (goldPack != null && goldPack.IsValid && string.Equals(goldPack.sku.Trim(), b, System.StringComparison.OrdinalIgnoreCase))
				{
					pack = goldPack;
					return true;
				}
			}
			return false;
		}

		public bool IsAtmSku(string sku)
		{
			GoldPack pack;
			return TryGetPack(sku, out pack);
		}

		public string ResolveCanonicalSku(string sku)
		{
			GoldPack pack;
			if (!TryGetPack(sku, out pack))
			{
				return null;
			}
			return pack.sku.Trim();
		}

		public static AtmCatalog Load()
		{
			if (_loaded != null)
			{
				return _loaded;
			}
			if (_loadAttempted)
			{
				return null;
			}
			_loadAttempted = true;
			_loaded = Resources.Load<AtmCatalog>(ResourcePath);
			if (_loaded == null)
			{
				Debug.Log("[AtmCatalog] No catalog at Resources/AtmCatalog — ATM disabled. Create one via Assets → Create → Slop-Game → Monetization → ATM Catalog and put it in Assets/_Project/Resources/.");
			}
			return _loaded;
		}
	}
}
