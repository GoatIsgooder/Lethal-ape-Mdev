using System;
using LethalApeR.Rivals;
using LethalApeR.Rivals.Combat;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Rivals Elimination", fileName = "Quest_RivalsElims")]
	public class EliminationQuest : Quest
	{
		[Header("Filter")]
		[Tooltip("Only count eliminations that were headshots.")]
		public bool headshotsOnly;

		private Action<KillInfo> _handler;

		private QuestManager _manager;

		private static int LocalActor
		{
			get
			{
				if (!PhotonNetwork.InRoom)
				{
					return 1;
				}
				return PhotonNetwork.LocalPlayer.ActorNumber;
			}
		}

		public override void Subscribe(QuestManager manager)
		{
			_manager = manager;
			_handler = OnPlayerKilled;
			RivalsEvents.OnPlayerKilled += _handler;
		}

		public override void Unsubscribe(QuestManager manager)
		{
			if (_handler != null)
			{
				RivalsEvents.OnPlayerKilled -= _handler;
			}
			_handler = null;
			_manager = null;
		}

		private void OnPlayerKilled(KillInfo info)
		{
			if (_manager == null || info.KillerActorNumber != LocalActor || info.VictimActorNumber == info.KillerActorNumber || (headshotsOnly && !info.WasHeadshot))
			{
				return;
			}
			GamemodeManager instance = GamemodeManager.Instance;
			if (!(instance == null))
			{
				GameState state = instance.State;
				if (state == GameState.RoundActive || state == GameState.RoundEnd)
				{
					_manager.ReportProgress(this, 1);
				}
			}
		}
	}
}
