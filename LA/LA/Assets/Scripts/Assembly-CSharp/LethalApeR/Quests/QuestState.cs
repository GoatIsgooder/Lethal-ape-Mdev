using System;

namespace LethalApeR.Quests
{
	[Serializable]
	public struct QuestState
	{
		public int progress;

		public bool claimed;

		public bool completedFired;
	}
}
