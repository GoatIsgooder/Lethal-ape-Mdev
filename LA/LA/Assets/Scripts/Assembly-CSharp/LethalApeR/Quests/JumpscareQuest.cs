using System;
using LethalApeR.Gameplay.Monsters;
using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Jumpscare", fileName = "Quest_Jumpscare")]
	public class JumpscareQuest : Quest
	{
		[Header("Monster Filter")]
		[Tooltip("Only count jumpscares from this monster type. Leave empty to count any.")]
		public string monsterTypeName;

		private Action<BaseMonster> _handler;

		private QuestManager _manager;

		public override void Subscribe(QuestManager manager)
		{
			_manager = manager;
			_handler = OnJumpscared;
			QuestEvents.LocalPlayerJumpscared += _handler;
		}

		public override void Unsubscribe(QuestManager manager)
		{
			if (_handler != null)
			{
				QuestEvents.LocalPlayerJumpscared -= _handler;
			}
			_handler = null;
			_manager = null;
		}

		private void OnJumpscared(BaseMonster monster)
		{
			if (!(_manager == null) && !(monster == null) && (string.IsNullOrEmpty(monsterTypeName) || monster.GetType().Name == monsterTypeName))
			{
				_manager.ReportProgress(this, 1);
			}
		}
	}
}
