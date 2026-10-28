using System;
using System.Text;
using LethalApeR.Seasons;
using UnityEngine;

namespace LethalApeR.Quests
{
	public abstract class Quest : ScriptableObject
	{
		[Header("Identity")]
		[Tooltip("Stable unique key — used as the PlayerPrefs prefix. Never rename after release.")]
		public string questId;

		[Header("Display")]
		public string title;

		[TextArea]
		public string description;

		[Header("Reward")]
		[Tooltip("Qauth wallet coins (GD) granted on claim. Leave 0 on Rivals quests.")]
		public int goldReward = 50;

		[Tooltip("Rivals keys granted on claim (through KeyManager). Leave 0 on SampleScene quests.")]
		public int keysReward;

		[Header("Progress")]
		[Tooltip("How many times the tracked action must occur to complete. Set 1 for boolean quests like Welcome Back.")]
		public int targetCount = 1;

		[Header("Seasonal Window (optional)")]
		[Tooltip("When on, this quest is only eligible for the daily lineup inside the UTC date window below, and its progress is refused outside it. Leave off for evergreen quests.")]
		public bool seasonalOnly;

		[Tooltip("Inclusive UTC start of the window. Autumn = 9 / 1.")]
		public int seasonStartMonth = 9;

		public int seasonStartDay = 1;

		[Tooltip("Inclusive UTC end of the window. Autumn = 11 / 30. Windows may wrap the new year (12/1 → 2/28).")]
		public int seasonEndMonth = 11;

		public int seasonEndDay = 30;

		[Tooltip("Badge shown on the board, e.g. \"AUTUMN ONLY\". Any occurrence of this exact phrase inside the description is recoloured too. Empty = no badge.")]
		public string seasonTag = "";

		[Tooltip("Badge colour as RRGGBB (no '#'). Autumn orange is F97316.")]
		public string seasonTagColorHex = "F97316";

		private bool HasSeasonBadge
		{
			get
			{
				if (seasonalOnly)
				{
					return !string.IsNullOrEmpty(seasonTag);
				}
				return false;
			}
		}

		private string SanitizedHex
		{
			get
			{
				string text = seasonTagColorHex?.Trim().TrimStart('#');
				if (string.IsNullOrEmpty(text) || (text.Length != 6 && text.Length != 8))
				{
					return "F97316";
				}
				for (int i = 0; i < text.Length; i++)
				{
					char c = char.ToUpperInvariant(text[i]);
					if ((c < '0' || c > '9') && (c < 'A' || c > 'F'))
					{
						return "F97316";
					}
				}
				return text;
			}
		}

		public abstract void Subscribe(QuestManager manager);

		public abstract void Unsubscribe(QuestManager manager);

		public virtual string GetProgressLabel(int currentProgress)
		{
			if (targetCount > 1)
			{
				return string.Format("{0} / {1}", Mathf.Min(currentProgress, targetCount), targetCount);
			}
			if (currentProgress <= 0)
			{
				return "";
			}
			return "Ready";
		}

		public bool IsAvailableToday()
		{
			if (!seasonalOnly)
			{
				return true;
			}
			return SeasonClock.IsInWindow(seasonStartMonth, seasonStartDay, seasonEndMonth, seasonEndDay);
		}

		public string GetDisplayTitle()
		{
			if (!HasSeasonBadge)
			{
				return title;
			}
			return title + "  <size=65%>" + Colored(seasonTag) + "</size>";
		}

		public string GetDisplayDescription()
		{
			if (!HasSeasonBadge)
			{
				return description;
			}
			string text = description ?? string.Empty;
			if (text.IndexOf(seasonTag, StringComparison.OrdinalIgnoreCase) >= 0)
			{
				return HighlightOccurrences(text, seasonTag);
			}
			string text2 = Colored(seasonTag);
			if (text.Length <= 0)
			{
				return text2;
			}
			return text + "\n" + text2;
		}

		private string Colored(string s)
		{
			return "<color=#" + SanitizedHex + ">" + s + "</color>";
		}

		private string HighlightOccurrences(string body, string needle)
		{
			StringBuilder stringBuilder = new StringBuilder(body.Length + 32);
			int num = 0;
			while (num < body.Length)
			{
				int num2 = body.IndexOf(needle, num, StringComparison.OrdinalIgnoreCase);
				if (num2 < 0)
				{
					stringBuilder.Append(body, num, body.Length - num);
					break;
				}
				stringBuilder.Append(body, num, num2 - num);
				stringBuilder.Append(Colored(body.Substring(num2, needle.Length)));
				num = num2 + needle.Length;
			}
			return stringBuilder.ToString();
		}
	}
}
