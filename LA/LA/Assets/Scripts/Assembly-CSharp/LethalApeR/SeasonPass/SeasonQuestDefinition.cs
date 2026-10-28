using LethalApeR.Gameplay;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	[CreateAssetMenu(menuName = "Slop/Season Pass/Quest", fileName = "Quest")]
	public class SeasonQuestDefinition : ScriptableObject
	{
		[Tooltip("Save key. Never rename after release.")]
		public string questId;

		public string title;

		[TextArea]
		public string description;

		public SeasonQuestEvent trigger;

		[Min(1f)]
		public int target = 1;

		[Min(0f)]
		public int xpReward = 250;

		[Tooltip("FeatureGates key. While that gate is closed the quest is hidden and can't progress; empty = always shown.")]
		public string featureGate;

		public bool IsAvailable => FeatureGates.IsOpen(featureGate);

		public string ProgressLabel(int progress)
		{
			if (target <= 1)
			{
				if (progress < 1)
				{
					return "0 / 1";
				}
				return "DONE";
			}
			return string.Format("{0} / {1}", Mathf.Min(progress, target), target);
		}
	}
}
