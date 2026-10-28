using System;
using LethalApeR.Gameplay.Monsters;
using UnityEngine;

namespace LethalApeR.Quests
{
	public static class QuestEvents
	{
		public static event Action<BaseMonster> LocalPlayerJumpscared;

		public static event Action<string> LocalPlayerJumpscaredBy;

		public static event Action<Vector3> LocalPlayerJumpedInBush;

		public static void RaiseLocalPlayerJumpscared(BaseMonster monster)
		{
			QuestEvents.LocalPlayerJumpscared?.Invoke(monster);
		}

		public static void RaiseLocalPlayerJumpscared(string monsterName)
		{
			QuestEvents.LocalPlayerJumpscaredBy?.Invoke(monsterName);
		}

		public static void RaiseLocalPlayerJumpedInBush(Vector3 bushWorldPosition)
		{
			QuestEvents.LocalPlayerJumpedInBush?.Invoke(bushWorldPosition);
		}
	}
}
