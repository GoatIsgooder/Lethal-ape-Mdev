using System;
using System.Collections.Generic;
using LethalApeR.PlayFab;
using LethalApeR.Rivals.Economy;
using UnityEngine;

namespace LethalApeR.Quests
{
	public class QuestManager : MonoBehaviour
	{
		[Header("Quest Lineup (fixed — change between updates)")]
		[Tooltip("All quests shown on the board, in display order. Used when the rotating pool below is empty.")]
		public List<Quest> quests = new List<Quest>();

		[Header("Rotating Pool (optional — overrides the fixed list)")]
		[Tooltip("When non-empty, each UTC day picks dailyQuestCount quests from this pool (deterministic shuffle seeded by the day number).")]
		public List<Quest> questPool = new List<Quest>();

		[Tooltip("How many pool quests are active per day.")]
		public int dailyQuestCount = 3;

		private readonly List<Quest> _activeQuests = new List<Quest>();

		private readonly Dictionary<Quest, QuestState> _state = new Dictionary<Quest, QuestState>();

		private const string PrefDayKey = "Quest_LastResetDay";

		private bool _initialized;

		private bool _subscribed;

		public static QuestManager Instance { get; private set; }

		public IReadOnlyList<Quest> ActiveQuests => _activeQuests;

		public event Action<Quest> OnQuestProgressed;

		public event Action<Quest> OnQuestCompleted;

		public event Action<Quest> OnQuestClaimed;

		public event Action OnDailyReset;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(base.gameObject);
			}
			else
			{
				Instance = this;
			}
		}

		private void Start()
		{
			EnsureInitialized();
		}

		public void EnsureInitialized()
		{
			if (!_initialized)
			{
				_initialized = true;
				LoadOrResetForToday();
				SetSubscribed(on: true);
			}
		}

		private void OnDestroy()
		{
			SetSubscribed(on: false);
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Update()
		{
			if (_initialized)
			{
				int num = TodayUtcDayNumber();
				if (num != PlayerPrefs.GetInt("Quest_LastResetDay", num))
				{
					LoadOrResetForToday();
				}
			}
		}

		public QuestState GetState(Quest quest)
		{
			if (quest == null)
			{
				return default(QuestState);
			}
			_state.TryGetValue(quest, out var value);
			return value;
		}

		public void ReportProgress(Quest quest, int delta)
		{
			if (quest == null || delta <= 0 || !quest.IsAvailableToday() || !_state.TryGetValue(quest, out var value) || value.claimed || value.progress >= quest.targetCount)
			{
				return;
			}
			value.progress = Mathf.Min(value.progress + delta, quest.targetCount);
			_state[quest] = value;
			SaveQuestState(quest, value);
			this.OnQuestProgressed?.Invoke(quest);
			if (value.progress >= quest.targetCount && !value.completedFired)
			{
				value.completedFired = true;
				_state[quest] = value;
				SaveQuestState(quest, value);
				this.OnQuestCompleted?.Invoke(quest);
			}
		}

		public bool TryClaim(Quest quest)
		{
			if (quest == null || !_state.TryGetValue(quest, out var value) || value.claimed || value.progress < quest.targetCount)
			{
				return false;
			}
			value.claimed = true;
			_state[quest] = value;
			SaveQuestState(quest, value);
			if (LocalProfileManager.Instance != null && quest.goldReward > 0)
			{
				LocalProfileManager.Instance.AddCurrency(quest.goldReward);
			}
			if (KeyManager.Instance != null && quest.keysReward > 0)
			{
				KeyManager.Instance.Add(quest.keysReward);
			}
			this.OnQuestClaimed?.Invoke(quest);
			return true;
		}

		private void LoadOrResetForToday()
		{
			int num = TodayUtcDayNumber();
			int num2 = PlayerPrefs.GetInt("Quest_LastResetDay", -1);
			PlayerPrefs.SetInt("Quest_LastResetDay", num);
			bool subscribed = _subscribed;
			SetSubscribed(on: false);
			RefreshActiveSelection(num);
			_state.Clear();
			foreach (Quest activeQuest in _activeQuests)
			{
				if (!(activeQuest == null))
				{
					_state[activeQuest] = ((num2 == num) ? LoadQuestState(activeQuest) : default(QuestState));
					if (num2 != num)
					{
						SaveQuestState(activeQuest, _state[activeQuest]);
					}
				}
			}
			PlayerPrefs.Save();
			if (subscribed)
			{
				SetSubscribed(on: true);
			}
			if (num2 != num)
			{
				this.OnDailyReset?.Invoke();
			}
		}

		private void RefreshActiveSelection(int dayNumber)
		{
			_activeQuests.Clear();
			if (questPool != null && questPool.Count != 0)
			{
				List<Quest> list = new List<Quest>();
				foreach (Quest item in questPool)
				{
					if (item != null && item.IsAvailableToday())
					{
						list.Add(item);
					}
				}
				if (list.Count != 0)
				{
					System.Random random = new System.Random(dayNumber);
					for (int num = list.Count - 1; num > 0; num--)
					{
						int index = random.Next(num + 1);
						(list[num], list[index]) = (list[index], list[num]);
					}
					int num2 = Mathf.Clamp(dailyQuestCount, 1, list.Count);
					for (int i = 0; i < num2; i++)
					{
						_activeQuests.Add(list[i]);
					}
				}
				return;
			}
			foreach (Quest quest in quests)
			{
				if (quest != null && quest.IsAvailableToday())
				{
					_activeQuests.Add(quest);
				}
			}
		}

		private void SetSubscribed(bool on)
		{
			if (_subscribed == on)
			{
				return;
			}
			_subscribed = on;
			foreach (Quest activeQuest in _activeQuests)
			{
				if (!(activeQuest == null))
				{
					if (on)
					{
						activeQuest.Subscribe(this);
					}
					else
					{
						activeQuest.Unsubscribe(this);
					}
				}
			}
		}

		private static int TodayUtcDayNumber()
		{
			return (int)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalDays;
		}

		private static string ProgressKey(Quest q)
		{
			return "Quest_" + q.questId + "_Progress";
		}

		private static string ClaimedKey(Quest q)
		{
			return "Quest_" + q.questId + "_Claimed";
		}

		private static QuestState LoadQuestState(Quest q)
		{
			int progress = PlayerPrefs.GetInt(ProgressKey(q), 0);
			int num = PlayerPrefs.GetInt(ClaimedKey(q), 0);
			return new QuestState
			{
				progress = progress,
				claimed = (num == 1),
				completedFired = (PlayerPrefs.GetInt(ProgressKey(q), 0) >= q.targetCount)
			};
		}

		private static void SaveQuestState(Quest q, QuestState s)
		{
			PlayerPrefs.SetInt(ProgressKey(q), s.progress);
			PlayerPrefs.SetInt(ClaimedKey(q), s.claimed ? 1 : 0);
		}
	}
}
