using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonPassButtonView
	{
		public RectTransform root;

		public Image background;

		public Image frame;

		public TMP_Text label;

		public Image icon;

		public Image dot;
	}
}
