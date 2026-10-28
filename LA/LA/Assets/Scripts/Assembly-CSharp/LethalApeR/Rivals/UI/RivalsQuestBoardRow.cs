using LethalApeR.Quests;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.UI
{
	public class RivalsQuestBoardRow : MonoBehaviour
	{
		[HideInInspector]
		public TMP_Text titleText;

		[HideInInspector]
		public TMP_Text descriptionText;

		[HideInInspector]
		public TMP_Text progressText;

		[HideInInspector]
		public TMP_Text rewardText;

		[HideInInspector]
		public RivalsQuestHoldButton holdButton;

		public Quest Quest { get; private set; }

		public bool IsClaimable
		{
			get
			{
				if (Quest == null || QuestManager.Instance == null)
				{
					return false;
				}
				QuestState state = QuestManager.Instance.GetState(Quest);
				if (state.claimed)
				{
					return false;
				}
				return state.progress >= Quest.targetCount;
			}
		}

		public void Bind(Quest quest)
		{
			Quest = quest;
			base.gameObject.SetActive(quest != null);
			if (quest == null)
			{
				return;
			}
			if (titleText != null)
			{
				titleText.text = quest.GetDisplayTitle();
			}
			if (descriptionText != null)
			{
				descriptionText.text = quest.GetDisplayDescription();
			}
			if (rewardText != null)
			{
				rewardText.text = ((quest.keysReward > 0) ? string.Format("{0} KEYS", quest.keysReward) : string.Format("{0} GD", quest.goldReward));
			}
			if (holdButton != null)
			{
				holdButton.ResetForBind();
			}
			Refresh();
		}

		public void Refresh()
		{
			if (Quest == null || QuestManager.Instance == null)
			{
				return;
			}
			QuestState state = QuestManager.Instance.GetState(Quest);
			bool complete = state.claimed || state.progress >= Quest.targetCount;
			if (progressText != null)
			{
				if (state.claimed)
				{
					progressText.text = "Claimed";
				}
				else if (complete)
				{
					progressText.text = "Claim";
				}
				else
				{
					progressText.text = Quest.GetProgressLabel(state.progress);
				}
			}
		}

		public bool TryClaim()
		{
			if (Quest == null || QuestManager.Instance == null)
			{
				return false;
			}
			return QuestManager.Instance.TryClaim(Quest);
		}
	}
}
