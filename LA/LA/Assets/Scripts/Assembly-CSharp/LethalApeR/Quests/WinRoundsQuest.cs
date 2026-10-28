using System;
using LethalApeR.Rivals;
using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Rivals Win Rounds", fileName = "Quest_RivalsRounds")]
	public class WinRoundsQuest : Quest
	{
		private Action _handler;

		private QuestManager _manager;

		public override void Subscribe(QuestManager manager)
		{
			_manager = manager;
			_handler = OnRoundWon;
			RivalsEvents.OnLocalRoundWon += _handler;
		}

		public override void Unsubscribe(QuestManager manager)
		{
			if (_handler != null)
			{
				RivalsEvents.OnLocalRoundWon -= _handler;
			}
			_handler = null;
			_manager = null;
		}

		private void OnRoundWon()
		{
			if (!(_manager == null))
			{
				_manager.ReportProgress(this, 1);
			}
		}
	}
}
