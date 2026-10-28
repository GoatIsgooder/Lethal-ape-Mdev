using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonPassColumnView
	{
		public RectTransform root;

		public Image header;

		public TMP_Text number;

		public Image freeCell;

		public Image premiumCell;

		public Image freeSelect;

		public Image premiumSelect;

		public SeasonPassCardView freeCard;

		public SeasonPassCardView premiumCard;
	}
}
