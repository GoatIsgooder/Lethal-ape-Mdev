using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Quests
{
	public class QuestBoard : MonoBehaviour
	{
		[Header("Layout")]
		[Tooltip("Prefab containing a QuestEntry component plus its visuals.")]
		[SerializeField]
		private QuestEntry entryPrefab;

		[Tooltip("Parent that holds the rows. Translated locally to scroll.")]
		[SerializeField]
		private Transform contentRoot;

		[Tooltip("Vertical spacing between rows in local units.")]
		[SerializeField]
		private float rowSpacing = 0.12f;

		[Tooltip("Local Y of the topmost row.")]
		[SerializeField]
		private float topRowLocalY;

		[Header("Scroll Limits")]
		[Tooltip("How many rows are visible at once. Used to clamp scroll so list can't disappear.")]
		[SerializeField]
		private int visibleRows = 5;

		private readonly List<QuestEntry> _entries = new List<QuestEntry>();

		private float _scrollOffset;

		private float _maxScrollOffset;

		private float _pendingScroll;

		private float _contentBaseY;

		public float MaxScrollOffset => _maxScrollOffset;

		public float ScrollOffset => _scrollOffset;

		private void Awake()
		{
			if (contentRoot != null)
			{
				_contentBaseY = contentRoot.localPosition.y;
			}
		}

		private void Start()
		{
			Build();
		}

		public void Build()
		{
			if (entryPrefab == null || contentRoot == null)
			{
				Debug.LogError("[QuestBoard] entryPrefab or contentRoot not assigned.");
				return;
			}
			if (QuestManager.Instance == null)
			{
				Debug.LogError("[QuestBoard] QuestManager.Instance is null. Make sure the manager is in the scene and active before the board.");
				return;
			}
			for (int num = _entries.Count - 1; num >= 0; num--)
			{
				if (_entries[num] != null)
				{
					Object.Destroy(_entries[num].gameObject);
				}
			}
			_entries.Clear();
			IReadOnlyList<Quest> activeQuests = QuestManager.Instance.ActiveQuests;
			for (int i = 0; i < activeQuests.Count; i++)
			{
				Quest quest = activeQuests[i];
				if (!(quest == null))
				{
					QuestEntry questEntry = Object.Instantiate(entryPrefab, contentRoot);
					Transform obj = questEntry.transform;
					obj.localPosition = new Vector3(0f, topRowLocalY - rowSpacing * (float)i, 0f);
					obj.localRotation = Quaternion.identity;
					questEntry.Bind(quest);
					_entries.Add(questEntry);
				}
			}
			_scrollOffset = 0f;
			_pendingScroll = 0f;
			_maxScrollOffset = (float)Mathf.Max(0, _entries.Count - visibleRows) * rowSpacing;
			ApplyScroll();
		}

		public void Scroll(float delta)
		{
			if (rowSpacing == 0f || contentRoot == null)
			{
				return;
			}
			Transform parent = contentRoot.parent;
			float num = 1f;
			if (parent != null)
			{
				num = parent.lossyScale.y;
			}
			if (Mathf.Approximately(num, 0f))
			{
				return;
			}
			_pendingScroll += delta / num;
			int num2 = Mathf.RoundToInt(_pendingScroll / rowSpacing);
			if (num2 != 0)
			{
				float num3 = (float)num2 * rowSpacing;
				_pendingScroll -= num3;
				float num4 = Mathf.Clamp(_scrollOffset + num3, Mathf.Min(0f, _maxScrollOffset), Mathf.Max(0f, _maxScrollOffset));
				if (!Mathf.Approximately(num4, _scrollOffset))
				{
					_scrollOffset = num4;
					ApplyScroll();
				}
			}
		}

		private void ApplyScroll()
		{
			if (!(contentRoot == null))
			{
				Vector3 localPosition = contentRoot.localPosition;
				contentRoot.localPosition = new Vector3(localPosition.x, _contentBaseY + _scrollOffset, localPosition.z);
				UpdateRowVisibility();
			}
		}

		private void UpdateRowVisibility()
		{
			if (rowSpacing == 0f)
			{
				return;
			}
			float num = _scrollOffset / rowSpacing;
			int num2 = Mathf.FloorToInt(num);
			int num3 = Mathf.CeilToInt(num + (float)visibleRows - 1f);
			for (int i = 0; i < _entries.Count; i++)
			{
				QuestEntry questEntry = _entries[i];
				if (!(questEntry == null))
				{
					bool flag = i >= num2 && i <= num3;
					if (questEntry.gameObject.activeSelf != flag)
					{
						questEntry.gameObject.SetActive(flag);
					}
					Vector3 localPosition = questEntry.transform.localPosition;
					int num4 = (flag ? i : (i + 10000));
					questEntry.transform.localPosition = new Vector3(localPosition.x, topRowLocalY - rowSpacing * (float)num4, localPosition.z);
				}
			}
		}

		[ContextMenu("Debug Cull State")]
		private void DebugCullState()
		{
			float num = ((rowSpacing > 0f) ? (_scrollOffset / rowSpacing) : 0f);
			int num2 = Mathf.FloorToInt(num);
			int num3 = Mathf.CeilToInt(num + (float)visibleRows - 1f);
			Debug.Log(string.Format("[QuestBoard] entries={0} scrollOffset={1:F3} max={2:F3} rowSpacing={3} visibleRows={4} topRowLocalY={5} → cull range [{6}, {7}]", _entries.Count, _scrollOffset, _maxScrollOffset, rowSpacing, visibleRows, topRowLocalY, num2, num3));
			for (int i = 0; i < _entries.Count; i++)
			{
				QuestEntry questEntry = _entries[i];
				if (questEntry == null)
				{
					Debug.Log(string.Format("  [{0}] <null>", i));
					continue;
				}
				Debug.Log(string.Format("  [{0}] localY={1:F3} active={2} quest={3}", i, questEntry.transform.localPosition.y, questEntry.gameObject.activeSelf, (questEntry.Quest != null) ? questEntry.Quest.questId : "<none>"));
			}
		}
	}
}
