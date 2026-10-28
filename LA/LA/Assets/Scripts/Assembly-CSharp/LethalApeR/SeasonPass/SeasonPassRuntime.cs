using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Gameplay.Monsters;
using LethalApeR.MonsterIndex;
using LethalApeR.Quests;
using LethalApeR.UI.Notifications;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	[DisallowMultipleComponent]
	public sealed class SeasonPassRuntime : MonoBehaviour
	{
		private const float TickSeconds = 1f;

		private static SeasonPassRuntime _instance;

		private float _nextTick;

		private bool _entitlementChecked;

		private bool _levelsRecounted;

		private bool _serverSynced;

		private bool _indexReported;

		private BTMGameManager _btm;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			if (!(_instance != null) && SeasonPassService.Instance != null)
			{
				GameObject gameObject = new GameObject("[SeasonPass]");
				Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<SeasonPassRuntime>();
			}
		}

		private void OnEnable()
		{
			QuestEvents.LocalPlayerJumpscared += OnJumpscared;
			QuestEvents.LocalPlayerJumpscaredBy += OnJumpscaredBy;
			MonsterIndexProgress.Added += OnMonsterIndexed;
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance != null)
			{
				instance.LevelReached += OnLevelReached;
				instance.QuestCompleted += OnQuestCompleted;
			}
		}

		private void OnDisable()
		{
			QuestEvents.LocalPlayerJumpscared -= OnJumpscared;
			QuestEvents.LocalPlayerJumpscaredBy -= OnJumpscaredBy;
			MonsterIndexProgress.Added -= OnMonsterIndexed;
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance != null)
			{
				instance.LevelReached -= OnLevelReached;
				instance.QuestCompleted -= OnQuestCompleted;
			}
			HookBtm(null);
		}

		private void OnDestroy()
		{
			if (_instance == this)
			{
				_instance = null;
			}
		}

		private void Update()
		{
			if (Time.unscaledTime < _nextTick)
			{
				return;
			}
			_nextTick = Time.unscaledTime + 1f;
			SeasonPassClock.TrySync();
			SeasonPassService.Instance?.Tick();
			SeasonPassPremium.Tick();
			if (SeasonPassPremium.PlatformReady)
			{
				if (!_entitlementChecked)
				{
					_entitlementChecked = true;
					SeasonPassPremium.RefreshEntitlement();
				}
				SeasonPassPremium.FetchPrice();
			}
			if (!_levelsRecounted && Qauth.IsLoggedIn)
			{
				_levelsRecounted = true;
				SeasonPassLevelShop.Recount();
			}
			if (!_serverSynced && Qauth.IsLoggedIn)
			{
				_serverSynced = true;
				SeasonPassServer.Sync();
			}
			HookBtm(BTMGameManager.Instance);
			if (!_indexReported)
			{
				SeasonPassService instance = SeasonPassService.Instance;
				if (instance != null && instance.Phase == SeasonPassPhase.Live)
				{
					_indexReported = true;
					SeasonQuestEvents.Reach(SeasonQuestEvent.MonsterIndexed, MonsterIndexProgress.FoundCount);
				}
			}
		}

		private void OnApplicationPause(bool paused)
		{
			if (!paused)
			{
				SeasonPassClock.MarkStale();
				_nextTick = 0f;
				_entitlementChecked = false;
				_levelsRecounted = false;
				_serverSynced = false;
			}
		}

		private void HookBtm(BTMGameManager manager)
		{
			if (!(manager == _btm))
			{
				if (_btm != null)
				{
					_btm.OnSalvageAwarded -= OnBtmReceipt;
				}
				_btm = manager;
				if (_btm != null)
				{
					_btm.OnSalvageAwarded += OnBtmReceipt;
				}
			}
		}

		private static void OnLevelReached(int level)
		{
			SeasonPassService instance = SeasonPassService.Instance;
			string format = ((instance != null && instance.GetClaimBlock(level) == SeasonClaimBlock.None) ? "Level {0} reached. Claim your reward at the pass board." : "Level {0} reached.");
			HandNotifications.Show(NotificationKind.Reward, "Season Pass", string.Format(format, level), 5f);
		}

		private static void OnQuestCompleted(SeasonQuestDefinition quest)
		{
			HandNotifications.Show(NotificationKind.Reward, "Season Quest", string.Format("{0} done. Claim +{1} XP at the pass board.", quest.title, quest.xpReward), 5f);
		}

		private static void OnJumpscared(BaseMonster monster)
		{
			SeasonQuestEvents.Raise(SeasonQuestEvent.Jumpscared);
		}

		private static void OnJumpscaredBy(string monsterName)
		{
			SeasonQuestEvents.Raise(SeasonQuestEvent.Jumpscared);
		}

		private static void OnMonsterIndexed(string id)
		{
			SeasonQuestEvents.Reach(SeasonQuestEvent.MonsterIndexed, MonsterIndexProgress.FoundCount);
		}

		private static void OnBtmReceipt(BtmSalvageReceipt receipt)
		{
			SeasonQuestEvents.Raise(SeasonQuestEvent.BtmRoundPlayed);
			if (receipt.outcome > 0)
			{
				SeasonQuestEvents.Raise(SeasonQuestEvent.BtmRoundWon);
			}
			if (!receipt.asMonster && receipt.escape > 0)
			{
				SeasonQuestEvents.Raise(SeasonQuestEvent.BtmEscaped);
			}
			if (receipt.asMonster && receipt.catches > 0)
			{
				SeasonQuestEvents.Raise(SeasonQuestEvent.BtmCatch, receipt.catches);
			}
		}
	}
}
