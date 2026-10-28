using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonPassCardView
	{
		public RectTransform root;

		public Image tile;

		public Image icon;

		public TMP_Text glyph;

		public TMP_Text amount;

		public Image rarityBar;

		public Image frame;

		public Image pulse;

		public Image fill;

		public Image lockTab;

		public Image lockIcon;

		public Image check;
	}
}
