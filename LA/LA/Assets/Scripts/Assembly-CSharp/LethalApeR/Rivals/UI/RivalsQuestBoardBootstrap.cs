using System.Collections.Generic;
using LethalApeR.Quests;
using LethalApeR.Rivals.Shop;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace LethalApeR.Rivals.UI
{
	public static class RivalsQuestBoardBootstrap
	{
		private const string RivalryScene = "Rivalry";

		private static Quest[] _pool;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_pool = null;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Init()
		{
			SceneManager.sceneLoaded -= HandleSceneLoaded;
			SceneManager.sceneLoaded += HandleSceneLoaded;
			if (SceneManager.GetActiveScene().name == RivalryScene)
			{
				TryBuild();
			}
		}

		private static void HandleSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			if (scene.name == RivalryScene)
			{
				TryBuild();
			}
		}

		private static void TryBuild()
		{
			if (Object.FindObjectOfType<RivalsQuestBoardController>() != null)
			{
				return;
			}
			QuestManager questManager = EnsureManager();
			if (questManager == null)
			{
				return;
			}
			BuildBoard(questManager);
		}

		public static QuestManager EnsureManagerPublic()
		{
			return EnsureManager();
		}

		public static GameObject BuildBoardPublic(QuestManager manager)
		{
			return BuildBoard(manager);
		}

		public static Material MakeFillMaterialPublic()
		{
			return MakeFillMaterial();
		}

		private static QuestManager EnsureManager()
		{
			QuestManager questManager = Object.FindObjectOfType<QuestManager>();
			if (questManager == null)
			{
				questManager = new GameObject("RivalsQuestManager (Auto)").AddComponent<QuestManager>();
			}
			if (questManager.questPool == null || questManager.questPool.Count == 0)
			{
				questManager.questPool = new List<Quest>(GetOrCreatePool());
				questManager.dailyQuestCount = 3;
			}
			questManager.EnsureInitialized();
			return questManager;
		}

		private static Quest[] GetOrCreatePool()
		{
			if (_pool != null)
			{
				return _pool;
			}
			EliminationQuest eliminationQuest = Make<EliminationQuest>("rivals_elims_5", "Eliminator", "Get 5 eliminations", 5, 35);
			PlayMatchesQuest playMatchesQuest = Make<PlayMatchesQuest>("rivals_play_1v1_2", "Duelist", "Play 2 1v1 matches", 2, 30);
			playMatchesQuest.teamSizeFilter = 1;
			GainLevelQuest gainLevelQuest = Make<GainLevelQuest>("rivals_gain_level", "Scholar", "Gain a level", 1, 50);
			EliminationQuest eliminationQuest2 = Make<EliminationQuest>("rivals_headshots_3", "Marksman", "Get 3 headshot eliminations", 3, 45);
			eliminationQuest2.headshotsOnly = true;
			WinRoundsQuest winRoundsQuest = Make<WinRoundsQuest>("rivals_win_rounds_5", "Round Boss", "Win 5 rounds", 5, 40);
			PlayMatchesQuest playMatchesQuest2 = Make<PlayMatchesQuest>("rivals_win_match_2", "Victor", "Win 2 matches", 2, 45);
			playMatchesQuest2.mustWin = true;
			_pool = new Quest[6] { eliminationQuest, playMatchesQuest, gainLevelQuest, eliminationQuest2, winRoundsQuest, playMatchesQuest2 };
			return _pool;
		}

		private static T Make<T>(string id, string title, string description, int target, int keys) where T : Quest
		{
			T val = ScriptableObject.CreateInstance<T>();
			val.name = id;
			val.questId = id;
			val.title = title;
			val.description = description;
			val.targetCount = target;
			val.keysReward = keys;
			val.goldReward = 0;
			return val;
		}

		private static GameObject BuildBoard(QuestManager manager)
		{
			GamemodeManager instance = GamemodeManager.Instance;
			Transform transform = null;
			if (instance != null)
			{
				transform = ((instance.HubReturnPoint != null) ? instance.HubReturnPoint : instance.transform);
			}
			Vector3 vector = ((transform != null) ? transform.position : Vector3.zero);
			Vector3 vector2 = ((transform != null) ? Flat(transform.right) : Vector3.right);
			Vector3 vector3 = vector + vector2 * 4f;
			Quaternion rotation = Quaternion.LookRotation(Flat(vector3 - vector), Vector3.up);
			GameObject gameObject = new GameObject("RivalsQuestBoard (Auto)");
			gameObject.transform.SetPositionAndRotation(vector3, rotation);
			RivalsQuestBoardController rivalsQuestBoardController = gameObject.AddComponent<RivalsQuestBoardController>();
			IReadOnlyList<Quest> activeQuests = manager.ActiveQuests;
			float num = 1.7f;
			float num2 = 0.5f;
			int num3 = Mathf.Max(1, activeQuests.Count);
			float num4 = Mathf.Max(0.2f, num - (float)(num3 - 1) * num2 - 0.25f);
			float num5 = 2.4f;
			Transform transform2 = GameObject.CreatePrimitive(PrimitiveType.Cube).transform;
			transform2.name = "Backboard";
			transform2.SetParent(gameObject.transform, false);
			transform2.localScale = new Vector3(1.6f, num5 - num4, 0.06f);
			transform2.localPosition = new Vector3(0f, (num5 + num4) * 0.5f, 0.05f);
			Tint(transform2, new Color(0.1f, 0.11f, 0.15f, 1f));
			for (int i = -1; i <= 1; i += 2)
			{
				Transform transform3 = GameObject.CreatePrimitive(PrimitiveType.Cylinder).transform;
				transform3.name = ((i < 0) ? "LegL" : "LegR");
				transform3.SetParent(gameObject.transform, false);
				transform3.localScale = new Vector3(0.12f, num4 * 0.5f, 0.12f);
				transform3.localPosition = new Vector3((float)i * 0.55f, num4 * 0.5f, 0.05f);
				Tint(transform3, new Color(0.08f, 0.09f, 0.12f, 1f));
			}
			MakeText(gameObject.transform, "Header", "DAILY QUESTS", 1.1f, new Vector2(1.5f, 0.2f), new Vector3(0f, 2.18f, -0.02f), TextAlignmentOptions.Center, new Color(1f, 0.84f, 0.2f, 1f));
			MakeText(gameObject.transform, "KeyBalance", "", 0.5f, new Vector2(1.4f, 0.1f), new Vector3(0f, 1.98f, -0.02f), TextAlignmentOptions.Center, new Color(0.8f, 0.85f, 0.9f, 1f)).gameObject.AddComponent<KeysDisplay>();
			Material fillMat = MakeFillMaterial();
			for (int j = 0; j < activeQuests.Count; j++)
			{
				RivalsQuestBoardRow rivalsQuestBoardRow = BuildRow(gameObject.transform, new Vector3(0f, num - (float)j * num2, -0.02f), fillMat);
				rivalsQuestBoardController.Register(rivalsQuestBoardRow);
				rivalsQuestBoardRow.Bind(activeQuests[j]);
			}
			return gameObject;
		}

		private static RivalsQuestBoardRow BuildRow(Transform boardRoot, Vector3 localPos, Material fillMat)
		{
			GameObject gameObject = new GameObject("QuestRow");
			gameObject.transform.SetParent(boardRoot, false);
			gameObject.transform.localPosition = localPos;
			RivalsQuestBoardRow rivalsQuestBoardRow = gameObject.AddComponent<RivalsQuestBoardRow>();
			Transform transform = GameObject.CreatePrimitive(PrimitiveType.Cube).transform;
			transform.name = "Plate";
			RivalsBuildUtil.Destroy(transform.GetComponent<Collider>());
			transform.SetParent(gameObject.transform, false);
			transform.localScale = new Vector3(1.48f, 0.46f, 0.02f);
			transform.localPosition = new Vector3(0f, 0f, 0.01f);
			Tint(transform, new Color(0.16f, 0.18f, 0.23f, 1f));
			rivalsQuestBoardRow.titleText = MakeText(gameObject.transform, "Title", "", 0.8f, new Vector2(0.94f, 0.14f), new Vector3(-0.24f, 0.135f, -0.02f), TextAlignmentOptions.Left, Color.white);
			rivalsQuestBoardRow.rewardText = MakeText(gameObject.transform, "Reward", "", 0.6f, new Vector2(0.5f, 0.14f), new Vector3(0.46f, 0.135f, -0.02f), TextAlignmentOptions.Right, new Color(1f, 0.84f, 0.2f, 1f));
			rivalsQuestBoardRow.descriptionText = MakeText(gameObject.transform, "Description", "", 0.5f, new Vector2(1.42f, 0.12f), new Vector3(0f, 0f, -0.02f), TextAlignmentOptions.Left, new Color(0.75f, 0.78f, 0.82f, 1f));
			rivalsQuestBoardRow.progressText = MakeText(gameObject.transform, "Progress", "", 0.65f, new Vector2(0.5f, 0.12f), new Vector3(0.46f, -0.14f, -0.02f), TextAlignmentOptions.Right, Color.white);
			GameObject gameObject2 = GameObject.CreatePrimitive(PrimitiveType.Cube);
			gameObject2.name = "ClaimButton";
			gameObject2.transform.SetParent(gameObject.transform, false);
			gameObject2.transform.localScale = new Vector3(0.42f, 0.13f, 0.1f);
			gameObject2.transform.localPosition = new Vector3(-0.5f, -0.14f, -0.06f);
			Tint(gameObject2.transform, new Color(0.2f, 0.45f, 0.3f, 1f));
			BoxCollider component = gameObject2.GetComponent<BoxCollider>();
			component.isTrigger = true;
			component.size = new Vector3(1.2f, 1.5f, 1.6f);
			RivalsQuestHoldButton rivalsQuestHoldButton = gameObject2.AddComponent<RivalsQuestHoldButton>();
			rivalsQuestHoldButton.owner = rivalsQuestBoardRow;
			rivalsQuestBoardRow.holdButton = rivalsQuestHoldButton;
			GameObject gameObject3 = GameObject.CreatePrimitive(PrimitiveType.Quad);
			gameObject3.name = "Fill";
			RivalsBuildUtil.Destroy(gameObject3.GetComponent<Collider>());
			gameObject3.transform.SetParent(gameObject.transform, false);
			gameObject3.transform.localScale = new Vector3(0.4f, 0.11f, 1f);
			gameObject3.transform.localPosition = new Vector3(-0.5f, -0.14f, -0.113f);
			Renderer component2 = gameObject3.GetComponent<Renderer>();
			component2.shadowCastingMode = ShadowCastingMode.Off;
			component2.receiveShadows = false;
			rivalsQuestHoldButton.SetFillRenderer(component2, fillMat);
			MakeText(gameObject.transform, "HoldLabel", "HOLD", 0.32f, new Vector2(0.4f, 0.1f), new Vector3(-0.5f, -0.14f, -0.118f), TextAlignmentOptions.Center, new Color(1f, 1f, 1f, 0.85f));
			return rivalsQuestBoardRow;
		}

		private static Material MakeFillMaterial()
		{
			Shader shader = Shader.Find("LethalApe/Quest Claim Fill");
			if (shader != null)
			{
				return new Material(shader);
			}
			return null;
		}

		private static TMP_Text MakeText(Transform parent, string name, string text, float size, Vector2 rect, Vector3 localPos, TextAlignmentOptions align, Color color)
		{
			GameObject gameObject = new GameObject(name);
			gameObject.transform.SetParent(parent, false);
			gameObject.transform.localPosition = localPos;
			TextMeshPro textMeshPro = gameObject.AddComponent<TextMeshPro>();
			textMeshPro.text = text;
			textMeshPro.fontSize = size;
			textMeshPro.alignment = align;
			textMeshPro.color = color;
			textMeshPro.textWrappingMode = TextWrappingModes.NoWrap;
			textMeshPro.overflowMode = TextOverflowModes.Overflow;
			textMeshPro.rectTransform.sizeDelta = rect;
			return textMeshPro;
		}

		private static void Tint(Transform t, Color c)
		{
			Renderer component = t.GetComponent<Renderer>();
			if (component != null && component.material != null)
			{
				component.material.color = c;
			}
		}

		private static Vector3 Flat(Vector3 v)
		{
			v.y = 0f;
			if (v.sqrMagnitude > 0.0001f)
			{
				return v.normalized;
			}
			return Vector3.forward;
		}
	}
}
