using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Quests;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.UI.Notifications
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class QuestNotificationBridge : MonoBehaviour
	{
		private const string MainSceneName = "MainScene";

		private const string ReminderDayPref = "Notif_LastQuestReminderDay";

		[Tooltip("Seconds of play before the daily 'claim your GD' reminder fires.")]
		[SerializeField]
		private float reminderDelaySeconds = 75f;

		[Tooltip("How long the reminder card stays up. Longer than a normal toast — it's a to-do, not a receipt.")]
		[SerializeField]
		private float reminderLife = 6f;

		private QuestManager _boundManager;

		private float _nextPollAt;

		private float _reminderDueAt = -1f;

		private bool _reminderHandled;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(UnityEngine.Object.FindAnyObjectByType<QuestNotificationBridge>() != null))
			{
				GameObject obj = new GameObject("QuestNotificationBridge");
				obj.AddComponent<QuestNotificationBridge>();
				UnityEngine.Object.DontDestroyOnLoad(obj);
			}
		}

		private void OnDisable()
		{
			Bind(null);
		}

		private void OnDestroy()
		{
			Bind(null);
		}

		private void Update()
		{
			float unscaledTime = Time.unscaledTime;
			if (!(unscaledTime < _nextPollAt))
			{
				_nextPollAt = unscaledTime + 1f;
				QuestManager instance = QuestManager.Instance;
				if (instance != _boundManager)
				{
					Bind(instance);
				}
				TickReminder(unscaledTime);
			}
		}

		private void Bind(QuestManager mgr)
		{
			if (_boundManager != null)
			{
				_boundManager.OnQuestCompleted -= HandleQuestCompleted;
				_boundManager.OnQuestClaimed -= HandleQuestClaimed;
				_boundManager.OnDailyReset -= HandleDailyReset;
			}
			_boundManager = mgr;
			if (_boundManager != null)
			{
				_boundManager.OnQuestCompleted += HandleQuestCompleted;
				_boundManager.OnQuestClaimed += HandleQuestClaimed;
				_boundManager.OnDailyReset += HandleDailyReset;
				if (_reminderDueAt < 0f)
				{
					_reminderDueAt = Time.unscaledTime + Mathf.Max(5f, reminderDelaySeconds);
				}
			}
		}

		private static void HandleQuestCompleted(Quest quest)
		{
			if (!(quest == null))
			{
				string text = DescribeReward(quest);
				string body = (string.IsNullOrEmpty(text) ? quest.title : (quest.title + " — hold to claim " + text));
				HandNotifications.Show(NotificationKind.Reward, "Task Complete", body, 5f);
			}
		}

		private static void HandleQuestClaimed(Quest quest)
		{
			if (!(quest == null))
			{
				string text = DescribeReward(quest);
				string body = (string.IsNullOrEmpty(text) ? quest.title : ("+" + text));
				HandNotifications.Show(NotificationKind.Success, "Claimed", body);
			}
		}

		private void HandleDailyReset()
		{
			_reminderHandled = false;
			_reminderDueAt = Time.unscaledTime + Mathf.Max(5f, reminderDelaySeconds);
		}

		private static string DescribeReward(Quest quest)
		{
			int goldReward = quest.goldReward;
			int keysReward = quest.keysReward;
			if (goldReward > 0 && keysReward > 0)
			{
				return string.Format("{0} GD + {1} keys", goldReward, keysReward);
			}
			if (goldReward > 0)
			{
				return string.Format("{0} GD", goldReward);
			}
			if (keysReward > 0)
			{
				if (keysReward != 1)
				{
					return string.Format("{0} keys", keysReward);
				}
				return "1 key";
			}
			return string.Empty;
		}

		private void TickReminder(float now)
		{
			if (_reminderHandled || _boundManager == null || _reminderDueAt < 0f || now < _reminderDueAt || !(SceneManager.GetActiveScene().name == "MainScene"))
			{
				return;
			}
			int num = TodayUtcDayNumber();
			if (PlayerPrefs.GetInt("Notif_LastQuestReminderDay", -1) == num)
			{
				_reminderHandled = true;
				return;
			}
			IReadOnlyList<Quest> activeQuests = _boundManager.ActiveQuests;
			int num2 = 0;
			int num3 = 0;
			for (int i = 0; i < activeQuests.Count; i++)
			{
				Quest quest = activeQuests[i];
				if (!(quest == null))
				{
					QuestState state = _boundManager.GetState(quest);
					if (!state.claimed)
					{
						num2++;
						if (state.progress >= quest.targetCount)
						{
							num3++;
						}
					}
				}
			}
			if (num2 != 0)
			{
				string body = ((num3 <= 0) ? "Free GD on the Quest Board outside spawn — finish today's tasks to claim it." : string.Format("{0} reward{1} waiting at the Quest Board outside spawn.", num3, (num3 == 1) ? "" : "s"));
				HandNotifications.Show(NotificationKind.Reward, "Daily Rewards", body, reminderLife);
			}
			_reminderHandled = true;
			StampToday(num);
		}

		private static void StampToday(int day)
		{
			PlayerPrefs.SetInt("Notif_LastQuestReminderDay", day);
			PlayerPrefs.Save();
		}

		private static int TodayUtcDayNumber()
		{
			return (int)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalDays;
		}
	}
}
