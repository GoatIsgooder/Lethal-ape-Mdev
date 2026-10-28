using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.SeasonPass
{
	[Serializable]
	public class SeasonQuestRowView
	{
		public RectTransform root;

		public Image panel;

		public TMP_Text title;

		public TMP_Text description;

		public Image barFill;

		public TMP_Text progress;

		public TMP_Text reward;

		public RectTransform claim;

		public Image claimBack;

		public Image claimFrame;

		public Image claimPulse;

		public Image claimFill;

		public TMP_Text claimLabel;

		public Image claimCheck;
	}
}
