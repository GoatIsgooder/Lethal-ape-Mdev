using System;
using System.Collections.Generic;
using LethalApeR.Quests;
using UnityEngine;

namespace LethalApeR.Rivals.UI
{
	public class RivalsQuestBoardController : MonoBehaviour
	{
		[Tooltip("Claim celebration sound (optional — assign later). Played 2D / non-spatialized.")]
		public AudioClip claimClip;

		private readonly List<RivalsQuestBoardRow> _rows = new List<RivalsQuestBoardRow>();

		private AudioSource _audio;

		public void Register(RivalsQuestBoardRow row)
		{
			if (row != null)
			{
				_rows.Add(row);
			}
		}

		private void Start()
		{
			if (_rows.Count == 0)
			{
				RivalsQuestBoardRow[] componentsInChildren = GetComponentsInChildren<RivalsQuestBoardRow>(true);
				Array.Sort(componentsInChildren, (RivalsQuestBoardRow a, RivalsQuestBoardRow b) => b.transform.localPosition.y.CompareTo(a.transform.localPosition.y));
				_rows.AddRange(componentsInChildren);
				QuestManager questManager = RivalsQuestBoardBootstrap.EnsureManagerPublic();
				if (questManager != null)
				{
					IReadOnlyList<Quest> activeQuests = questManager.ActiveQuests;
					for (int i = 0; i < _rows.Count; i++)
					{
						_rows[i].Bind((activeQuests != null && i < activeQuests.Count) ? activeQuests[i] : null);
					}
				}
			}
			Hook(true);
		}

		private void OnDestroy()
		{
			Hook(false);
		}

		private void Hook(bool subscribe)
		{
			QuestManager instance = QuestManager.Instance;
			if (!(instance == null))
			{
				instance.OnQuestProgressed -= HandleQuestEvent;
				instance.OnQuestCompleted -= HandleQuestEvent;
				instance.OnQuestClaimed -= HandleQuestClaimed;
				instance.OnDailyReset -= RebindAll;
				if (subscribe)
				{
					instance.OnQuestProgressed += HandleQuestEvent;
					instance.OnQuestCompleted += HandleQuestEvent;
					instance.OnQuestClaimed += HandleQuestClaimed;
					instance.OnDailyReset += RebindAll;
				}
			}
		}

		private void HandleQuestEvent(Quest q)
		{
			for (int i = 0; i < _rows.Count; i++)
			{
				if (_rows[i] != null && _rows[i].Quest == q)
				{
					_rows[i].Refresh();
				}
			}
		}

		private void HandleQuestClaimed(Quest q)
		{
			HandleQuestEvent(q);
			if (claimClip == null)
			{
				return;
			}
			for (int i = 0; i < _rows.Count; i++)
			{
				if (!(_rows[i] == null) && !(_rows[i].Quest != q))
				{
					EnsureAudio();
					_audio.PlayOneShot(claimClip, 1f);
					break;
				}
			}
		}

		private void RebindAll()
		{
			IReadOnlyList<Quest> readOnlyList = ((QuestManager.Instance != null) ? QuestManager.Instance.ActiveQuests : null);
			for (int i = 0; i < _rows.Count; i++)
			{
				if (!(_rows[i] == null))
				{
					_rows[i].Bind((readOnlyList != null && i < readOnlyList.Count) ? readOnlyList[i] : null);
				}
			}
		}

		private void EnsureAudio()
		{
			if (!(_audio != null))
			{
				_audio = base.gameObject.AddComponent<AudioSource>();
				_audio.playOnAwake = false;
				_audio.spatialBlend = 0f;
				_audio.spatialize = false;
				_audio.volume = 0.9f;
			}
		}
	}
}
