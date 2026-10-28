using System;
using System.Text;
using LethalApeR.PlayFab;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonPassReward
	{
		public SeasonRewardKind kind;

		[Tooltip("Qauth catalog ItemId, exact case.")]
		public string itemId;

		[Tooltip("GD granted when kind is Gold, XP when kind is Xp.")]
		[Min(0f)]
		public int amount;

		[Tooltip("Board name. Empty = the catalog DisplayName, then the ItemId.")]
		public string displayName;

		public Sprite icon;

		public SeasonRarity rarity = SeasonRarity.Epic;

		[Tooltip("A headline skin: big card with a gold frame.")]
		public bool featured;

		[Tooltip("Item still in production: shows as a locked ??? card and can never be claimed.")]
		public bool comingSoon;

		private const string PlayerModelSuffix = "_PLAYERMODEL";

		private const string BodySuffix = "_BODY";

		private const string LauncherSuffix = "_LAUNCHER";

		private bool IsPlayerModel
		{
			get
			{
				if (!string.IsNullOrEmpty(itemId))
				{
					return itemId.EndsWith("_PLAYERMODEL", StringComparison.Ordinal);
				}
				return false;
			}
		}

		private bool IsBody
		{
			get
			{
				if (!string.IsNullOrEmpty(itemId))
				{
					return itemId.EndsWith("_BODY", StringComparison.Ordinal);
				}
				return false;
			}
		}

		private bool IsWeapon
		{
			get
			{
				if (!string.IsNullOrEmpty(itemId))
				{
					return itemId.EndsWith("_LAUNCHER", StringComparison.Ordinal);
				}
				return false;
			}
		}

		public string KindLabel
		{
			get
			{
				switch (kind)
				{
				case SeasonRewardKind.Gold:
					return "CURRENCY";
				case SeasonRewardKind.Xp:
					return "XP BOOST";
				default:
					if (!string.IsNullOrEmpty(itemId) && itemId.EndsWith("BTMSkin", StringComparison.Ordinal))
					{
						return "BTM SKIN";
					}
					if (IsPlayerModel)
					{
						return "PLAYER MODEL";
					}
					if (IsBody)
					{
						return "BODY COSMETIC";
					}
					if (IsWeapon)
					{
						return "WEAPON";
					}
					if (!featured)
					{
						return "ITEM";
					}
					return "SKIN";
				}
			}
		}

		public bool IsGlyph
		{
			get
			{
				if (!comingSoon)
				{
					return kind != SeasonRewardKind.Cosmetic;
				}
				return true;
			}
		}

		public string Glyph
		{
			get
			{
				if (comingSoon)
				{
					return "?";
				}
				if (kind != SeasonRewardKind.Xp)
				{
					return "GD";
				}
				return "XP";
			}
		}

		public string ResolveDisplayName()
		{
			if (comingSoon)
			{
				return "COMING SOON";
			}
			if (!string.IsNullOrEmpty(displayName))
			{
				return displayName.ToUpperInvariant();
			}
			switch (kind)
			{
			case SeasonRewardKind.Gold:
				return amount + " GOLD";
			case SeasonRewardKind.Xp:
				return amount + " XP";
			default:
			{
				if (LocalProfileManager.Instance != null)
				{
					RemoteCatalogItem catalogItem = LocalProfileManager.Instance.GetCatalogItem(itemId);
					if (catalogItem != null && !string.IsNullOrEmpty(catalogItem.DisplayName) && catalogItem.DisplayName != itemId)
					{
						return catalogItem.DisplayName.Replace('_', ' ').ToUpperInvariant();
					}
				}
				if (!string.IsNullOrEmpty(itemId))
				{
					return PrettyId(itemId);
				}
				return "REWARD";
			}
			}
		}

		private static string PrettyId(string id)
		{
			if (id.EndsWith("BTMSkin", StringComparison.Ordinal) && id.Length > 7)
			{
				id = id.Substring(0, id.Length - 7);
			}
			if (id.EndsWith("_PLAYERMODEL", StringComparison.Ordinal) && id.Length > "_PLAYERMODEL".Length)
			{
				id = id.Substring(0, id.Length - "_PLAYERMODEL".Length);
			}
			if (id.EndsWith("_BODY", StringComparison.Ordinal) && id.Length > "_BODY".Length)
			{
				id = id.Substring(0, id.Length - "_BODY".Length);
			}
			StringBuilder stringBuilder = new StringBuilder(id.Length + 8);
			for (int i = 0; i < id.Length; i++)
			{
				char c = ((id[i] == '_') ? ' ' : id[i]);
				if (i > 0 && char.IsUpper(c) && char.IsLower(id[i - 1]) && stringBuilder.Length > 0 && stringBuilder[stringBuilder.Length - 1] != ' ')
				{
					stringBuilder.Append(' ');
				}
				if (c != ' ' || stringBuilder.Length <= 0 || stringBuilder[stringBuilder.Length - 1] != ' ')
				{
					stringBuilder.Append(c);
				}
			}
			return stringBuilder.ToString().Trim().ToUpperInvariant();
		}
	}
}
