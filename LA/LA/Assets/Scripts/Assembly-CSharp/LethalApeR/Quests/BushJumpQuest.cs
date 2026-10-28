using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Jump In Bushes", fileName = "Quest_Bushes")]
	public class BushJumpQuest : Quest
	{
		[Header("Bush Filter")]
		[Tooltip("When on, entering the SAME bush again never counts — the target is N distinct bushes. Off: any entry counts, so you can farm one bush on its cooldown.")]
		public bool requireDistinctBushes = true;

		[NonSerialized]
		private HashSet<long> _visited;

		private Action<Vector3> _handler;

		private QuestManager _manager;

		public override void Subscribe(QuestManager manager)
		{
			_manager = manager;
			_visited = (requireDistinctBushes ? new HashSet<long>() : null);
			_handler = OnBushEntered;
			QuestEvents.LocalPlayerJumpedInBush += _handler;
		}

		public override void Unsubscribe(QuestManager manager)
		{
			if (_handler != null)
			{
				QuestEvents.LocalPlayerJumpedInBush -= _handler;
			}
			_handler = null;
			_manager = null;
			_visited = null;
		}

		private void OnBushEntered(Vector3 bushWorldPosition)
		{
			if (!(_manager == null) && (_visited == null || _visited.Add(CellKey(bushWorldPosition))))
			{
				_manager.ReportProgress(this, 1);
			}
		}

		private static long CellKey(Vector3 p)
		{
			int num = Mathf.RoundToInt(p.x * 4f);
			int num2 = Mathf.RoundToInt(p.y * 4f);
			int num3 = Mathf.RoundToInt(p.z * 4f);
			return ((long)num * 73856093L) ^ ((long)num2 * 19349663L) ^ ((long)num3 * 83492791L);
		}
	}
}
