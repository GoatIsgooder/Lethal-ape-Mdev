using System;
using LethalApeR.Rivals;
using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Rivals Play Matches", fileName = "Quest_RivalsMatches")]
	public class PlayMatchesQuest : Quest
	{
		[Header("Filter")]
		[Tooltip("0 = any team size, 1 = 1v1 matches only, 2 = 2v2 matches only.")]
		public int teamSizeFilter;

		[Tooltip("Only count matches the local player's team won.")]
		public bool mustWin;

		private Action<MatchResultInfo> _handler;

		private QuestManager _manager;

		public override void Subscribe(QuestManager manager)
		{
			_manager = manager;
			_handler = OnMatchCompleted;
			RivalsEvents.OnMatchCompleted += _handler;
		}

		public override void Unsubscribe(QuestManager manager)
		{
			if (_handler != null)
			{
				RivalsEvents.OnMatchCompleted -= _handler;
			}
			_handler = null;
			_manager = null;
		}

		private void OnMatchCompleted(MatchResultInfo info)
		{
			if (!(_manager == null) && (teamSizeFilter < 1 || info.TeamSize == teamSizeFilter) && (!mustWin || info.Won))
			{
				_manager.ReportProgress(this, 1);
			}
		}
	}
}
