using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Welcome Back", fileName = "Quest_WelcomeBack")]
	public class WelcomeBackQuest : Quest
	{
		public override void Subscribe(QuestManager manager)
		{
			manager.ReportProgress(this, 1);
		}

		public override void Unsubscribe(QuestManager manager)
		{
		}

		public override string GetProgressLabel(int currentProgress)
		{
			return "Ready";
		}
	}
}
