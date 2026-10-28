using TMPro;
using UnityEngine;

namespace LethalApeR.Quests
{
	public class QuestEntry : MonoBehaviour
	{
		[Header("References")]
		[SerializeField]
		private TMP_Text titleText;

		[SerializeField]
		private TMP_Text descriptionText;

		[SerializeField]
		private TMP_Text progressText;

		[SerializeField]
		private TMP_Text rewardText;

		[SerializeField]
		private HoldClaimButton claimButton;

		[Tooltip("Shown while the quest is in progress (not yet completable). Optional.")]
		[SerializeField]
		private GameObject inProgressCover;

		[Tooltip("Shown after the player claims. Optional.")]
		[SerializeField]
		private GameObject claimedCover;

		[Header("Effects")]
		[Tooltip("Spawned at the claim button's particle point when the hold completes.")]
		[SerializeField]
		private GameObject claimParticlePrefab;

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
				if (!state.claimed)
				{
					return state.progress >= Quest.targetCount;
				}
				return false;
			}
		}

		public void Bind(Quest quest)
		{
			Quest = quest;
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
				rewardText.text = string.Format("{0} GD", quest.goldReward);
			}
			if (claimButton != null)
			{
				claimButton.Bind(this);
			}
			HookManagerEvents(subscribe: true);
			Refresh();
		}

		private void OnDestroy()
		{
			HookManagerEvents(subscribe: false);
		}

		private void HookManagerEvents(bool subscribe)
		{
			QuestManager instance = QuestManager.Instance;
			if (!(instance == null))
			{
				instance.OnQuestProgressed -= HandleQuestEvent;
				instance.OnQuestCompleted -= HandleQuestEvent;
				instance.OnQuestClaimed -= HandleQuestEvent;
				instance.OnDailyReset -= Refresh;
				if (subscribe)
				{
					instance.OnQuestProgressed += HandleQuestEvent;
					instance.OnQuestCompleted += HandleQuestEvent;
					instance.OnQuestClaimed += HandleQuestEvent;
					instance.OnDailyReset += Refresh;
				}
			}
		}

		private void HandleQuestEvent(Quest q)
		{
			if (q == Quest)
			{
				Refresh();
			}
		}

		private void Refresh()
		{
			if (Quest == null || QuestManager.Instance == null)
			{
				return;
			}
			QuestState state = QuestManager.Instance.GetState(Quest);
			bool flag = !state.claimed && state.progress >= Quest.targetCount;
			if (progressText != null)
			{
				if (state.claimed)
				{
					progressText.text = "Claimed";
				}
				else if (flag)
				{
					progressText.text = "Claim";
				}
				else
				{
					progressText.text = Quest.GetProgressLabel(state.progress);
				}
			}
			if (inProgressCover != null)
			{
				inProgressCover.SetActive(!state.claimed && !flag);
			}
			if (claimedCover != null)
			{
				claimedCover.SetActive(state.claimed);
			}
		}

		public void OnHoldCompleted(Vector3 particleWorldPosition)
		{
			if (!(QuestManager.Instance == null) && QuestManager.Instance.TryClaim(Quest) && claimParticlePrefab != null)
			{
				Object.Instantiate(claimParticlePrefab, particleWorldPosition, Quaternion.identity);
			}
		}
	}
}
