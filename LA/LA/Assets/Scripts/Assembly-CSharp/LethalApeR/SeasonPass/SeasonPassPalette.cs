using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassPalette
	{
		public static readonly Color Ink = Hex(0xFFFFFFu);

		public static readonly Color Lavender = Hex(0xA899D1u);

		public static readonly Color Dark = Hex(0x120D1Cu);

		public static readonly Color Panel = Hex(0x211A33u, 0.95f);

		public static readonly Color Gold = Hex(0xFFD14Cu);

		public static readonly Color GoldDeep = Hex(0x8A6414u);

		public static readonly Color Green = Hex(0x6BE38Fu);

		public static readonly Color Short = Hex(0xFF6B6Bu);

		public static readonly Color HeaderCurrent = Hex(0xEDE6FFu);

		public static readonly Color CellFreeCurrent = Hex(0xC7B8F2u, 0.42f);

		public static readonly Color CellPremiumCurrent = Hex(0xFFD14Cu, 0.16f);

		public static readonly Color CellFree = Hex(0x7366A8u, 0.26f);

		public static readonly Color CellPremium = Hex(0x7366A8u, 0.17f);

		public static Color Tile(SeasonRarity rarity)
		{
			return rarity switch
			{
				SeasonRarity.Legendary => Hex(0xC9821Cu), 
				SeasonRarity.Epic => Hex(0x8C38D1u), 
				_ => Hex(0x2F6CD1u), 
			};
		}

		public static Color Bar(SeasonRarity rarity)
		{
			return rarity switch
			{
				SeasonRarity.Legendary => Hex(0xFFD45Cu), 
				SeasonRarity.Epic => Hex(0xD08BFFu), 
				_ => Hex(0x69B0FFu), 
			};
		}

		public static Color Shade(Color c, float brightness)
		{
			return new Color(c.r * brightness, c.g * brightness, c.b * brightness, c.a);
		}

		public static Color WithAlpha(Color c, float a)
		{
			c.a = a;
			return c;
		}

		private static Color Hex(uint rgb, float a = 1f)
		{
			return new Color((float)((rgb >> 16) & 0xFF) / 255f, (float)((rgb >> 8) & 0xFF) / 255f, (float)(rgb & 0xFF) / 255f, a);
		}
	}
}
