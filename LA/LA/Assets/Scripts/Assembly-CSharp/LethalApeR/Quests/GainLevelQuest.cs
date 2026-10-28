using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Rivals.Progression;
using UnityEngine;

namespace LethalApeR.Quests
{
	[CreateAssetMenu(menuName = "Lethal Ape/Quests/Rivals Gain Level", fileName = "Quest_RivalsLevel")]
	public class GainLevelQuest : Quest
	{
		private Action<int, RivalsRank> _handler;

		private QuestManager _manager;

		private RivalsProgression _attached;

		private Coroutine _attachRoutine;

		private int _lastLevel;

		public override void Subscribe(QuestManager manager)
		{
			_manager = manager;
			_handler = OnLevelChanged;
			if (!TryAttach() && manager != null)
			{
				_attachRoutine = manager.StartCoroutine(AttachWhenAvailable());
			}
		}

		public override void Unsubscribe(QuestManager manager)
		{
			if (_attachRoutine != null && manager != null)
			{
				manager.StopCoroutine(_attachRoutine);
			}
			_attachRoutine = null;
			if (_attached != null && _handler != null)
			{
				_attached.OnLevelChanged -= _handler;
			}
			_attached = null;
			_handler = null;
			_manager = null;
		}

		private bool TryAttach()
		{
			RivalsProgression instance = RivalsProgression.Instance;
			if (instance == null)
			{
				return false;
			}
			_attached = instance;
			_lastLevel = instance.Level;
			instance.OnLevelChanged += _handler;
			return true;
		}

		private IEnumerator AttachWhenAvailable()
		{
			WaitForSeconds wait = new WaitForSeconds(0.5f);
			while (RivalsProgression.Instance == null)
			{
				yield return wait;
			}
			TryAttach();
			_attachRoutine = null;
		}

		private void OnLevelChanged(int newLevel, RivalsRank rank)
		{
			if (!(_manager == null))
			{
				int lastLevel = _lastLevel;
				_lastLevel = newLevel;
				int num = newLevel - lastLevel;
				if (num > 0)
				{
					_manager.ReportProgress(this, num);
				}
			}
		}
	}
}
