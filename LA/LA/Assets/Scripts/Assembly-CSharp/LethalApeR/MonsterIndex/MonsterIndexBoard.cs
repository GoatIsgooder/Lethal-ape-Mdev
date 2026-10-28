using System;
using System.Collections.Generic;
using LethalApeR.Gameplay;
using LethalApeR.Networking;
using LethalApeR.Social.UI;
using TMPro;
using UnityEngine;

namespace LethalApeR.MonsterIndex
{
	public sealed class MonsterIndexBoard : MonoBehaviour, ISocialListAdapter
	{
		[SerializeField]
		private MonsterIndexData data;

		[Header("Parts")]
		[SerializeField]
		private Canvas canvas;

		[SerializeField]
		private SocialListView list;

		[SerializeField]
		private MonsterFigure figure;

		[SerializeField]
		private TMP_Text title;

		[SerializeField]
		private RectTransform countChip;

		[SerializeField]
		private TMP_Text countLabel;

		[SerializeField]
		private SocialButton previous;

		[SerializeField]
		private SocialButton next;

		[Header("Detail")]
		[SerializeField]
		private TMP_Text nameLabel;

		[SerializeField]
		private TMP_Text dangerValue;

		[SerializeField]
		private TMP_Text foundValue;

		[SerializeField]
		private TMP_Text speedValue;

		[SerializeField]
		private TMP_Text jumpscaredValue;

		[Tooltip("The JUMPSCARED caption and value: only on monsters the player has found.")]
		[SerializeField]
		private GameObject jumpscaredRow;

		[SerializeField]
		private TMP_Text descriptionLabel;

		[Header("List (must match the builder)")]
		[Tooltip("Row and end-spacer height (kind 0 and 1 share it).")]
		[SerializeField]
		private float rowHeight = 56f;

		[SerializeField]
		private float rowGap = 8f;

		[Header("Distance (metres)")]
		[Tooltip("Stops drawing past this. Keep it just past the shaders' _FadeFar, where it's already invisible.")]
		[SerializeField]
		private float hideBeyond = 4.1f;

		[SerializeField]
		private float showWithin = 3.9f;

		public const string Unknown = "???";

		private static string _lastOpened;

		private readonly List<int> _visible = new List<int>(64);

		private int _selected = -1;

		private bool _selectedFound;

		private bool _shown = true;

		private bool _progressDirty;

		private float _nextDistanceCheck;

		private Action<int> _onRow;

		private Action _onProgress;

		private Action _onGates;

		private const int KindRow = 0;

		private const int KindSpacer = 1;

		public int Count
		{
			get
			{
				if (_visible.Count <= 0)
				{
					return 0;
				}
				return _visible.Count + 2;
			}
		}

		public int KindOf(int index)
		{
			if (index != 0 && index != Count - 1)
			{
				return 0;
			}
			return 1;
		}

		private void Awake()
		{
			_onRow = Open;
			_onProgress = delegate
			{
				_progressDirty = true;
			};
			_onGates = Regather;
			list.Warm(0, 9);
			list.Warm(1, 2);
			previous.Pressed += delegate
			{
				Step(-1);
			};
			next.Pressed += delegate
			{
				Step(1);
			};
		}

		private void OnEnable()
		{
			MonsterIndexProgress.Changed += _onProgress;
			FeatureGates.Changed += _onGates;
		}

		private void OnDisable()
		{
			MonsterIndexProgress.Changed -= _onProgress;
			FeatureGates.Changed -= _onGates;
		}

		private void Regather()
		{
			string text = ((_selected >= 0 && _selected < _visible.Count) ? Entry(_selected).id : _lastOpened);
			Gather();
			list.SetAdapter(this);
			if (_visible.Count == 0)
			{
				return;
			}
			int position = 0;
			for (int i = 0; i < _visible.Count; i++)
			{
				if (Entry(i).id == text)
				{
					position = i;
				}
			}
			Open(position, animate: false);
		}

		private void Start()
		{
			Gather();
			list.SetAdapter(this);
			int position = 0;
			for (int i = 0; i < _visible.Count; i++)
			{
				if (Entry(i).id == _lastOpened)
				{
					position = i;
				}
			}
			Open(position, animate: false);
		}

		private void Gather()
		{
			_visible.Clear();
			if (data != null)
			{
				MonsterIndexEntry[] entries = data.entries;
				if (entries != null)
				{
					for (int i = 0; i < entries.Length; i++)
					{
						MonsterIndexEntry monsterIndexEntry = entries[i];
						if (monsterIndexEntry != null && !monsterIndexEntry.hidden && FeatureGates.IsOpen(monsterIndexEntry.featureGate))
						{
							_visible.Add(i);
						}
					}
				}
			}
			UpdateCount();
		}

		private void UpdateCount()
		{
			int num = 0;
			for (int i = 0; i < _visible.Count; i++)
			{
				if (IsFound(i))
				{
					num++;
				}
			}
			string text = num + "/" + _visible.Count;
			countLabel.text = text;
			float x = countLabel.rectTransform.anchoredPosition.x;
			float x2 = countLabel.GetPreferredValues(text).x;
			countChip.sizeDelta = new Vector2(x * 2f + x2, countChip.sizeDelta.y);
			float x3 = title.rectTransform.anchoredPosition.x;
			float x4 = title.GetPreferredValues(title.text).x;
			countChip.anchoredPosition = new Vector2(x3 + x4 + 14f, countChip.anchoredPosition.y);
		}

		private MonsterIndexEntry Entry(int position)
		{
			return data.entries[_visible[position]];
		}

		private bool IsFound(int position)
		{
			return MonsterIndexProgress.IsFound(Entry(position).id);
		}

		public void Bind(SocialListItem view, int index)
		{
			if (view is MonsterRowView monsterRowView)
			{
				monsterRowView.Pressed = _onRow;
				int num = index - 1;
				monsterRowView.Bind(num, Entry(num), data.thumbnails, num == _selected, IsFound(num));
			}
		}

		private void Step(int by)
		{
			int count = _visible.Count;
			if (count != 0)
			{
				Open((_selected + by + count) % count, animate: true);
			}
		}

		private void Open(int position)
		{
			Open(position, animate: true);
		}

		private void Open(int position, bool animate)
		{
			if (_visible.Count == 0)
			{
				ShowEmpty();
				return;
			}
			position = Mathf.Clamp(position, 0, _visible.Count - 1);
			if (position != _selected)
			{
				_selected = position;
				_selectedFound = IsFound(position);
				MonsterIndexEntry monsterIndexEntry = Entry(position);
				_lastOpened = monsterIndexEntry.id;
				list.Rebind();
				KeepInView(position);
				figure.Show(_selectedFound ? monsterIndexEntry : null, animate);
				Fill(monsterIndexEntry, _selectedFound);
			}
		}

		private void ApplyProgress()
		{
			_progressDirty = false;
			if (_visible.Count == 0)
			{
				return;
			}
			UpdateCount();
			list.Rebind();
			if (_selected >= 0)
			{
				bool flag = IsFound(_selected);
				if (_selectedFound != flag)
				{
					_selectedFound = flag;
					MonsterIndexEntry monsterIndexEntry = Entry(_selected);
					figure.Show(flag ? monsterIndexEntry : null, grow: true);
					Fill(monsterIndexEntry, flag);
				}
			}
		}

		private void KeepInView(int position)
		{
			float num = rowHeight + rowGap;
			int num2 = Mathf.FloorToInt((list.ViewHeight + rowGap) / num);
			int num3 = Mathf.RoundToInt(Mathf.Max(0f, list.Offset) / num);
			int num4 = position + 1;
			if (num4 < num3 + 1)
			{
				list.StepItems(position - num3);
			}
			else if (num4 > num3 + num2 - 2)
			{
				list.StepItems(position - num2 + 3 - num3);
			}
		}

		private void Fill(MonsterIndexEntry entry, bool found)
		{
			nameLabel.text = (found ? entry.displayName : "???");
			dangerValue.text = ((!found) ? "???" : (string.IsNullOrWhiteSpace(entry.danger) ? "UNKNOWN" : entry.danger.Trim().ToUpperInvariant()));
			foundValue.text = ((entry.areas != null && entry.areas.Length != 0) ? Areas(entry.areas) : (string.IsNullOrWhiteSpace(entry.appears) ? "UNKNOWN" : entry.appears));
			speedValue.text = ((!found) ? "???" : ((entry.chaseSpeed > 0f) ? (entry.chaseSpeed.ToString("0.0") + " M/S") : "UNKNOWN"));
			if (jumpscaredRow.activeSelf != found)
			{
				jumpscaredRow.SetActive(found);
			}
			jumpscaredValue.text = "1/1";
			descriptionLabel.text = (found ? (string.IsNullOrWhiteSpace(entry.description) ? "No notes yet." : entry.description) : "");
		}

		private static string Areas(string[] areas)
		{
			List<string> list = new List<string>(4);
			List<string> list2 = new List<string>(4);
			int num = -1;
			for (int i = 0; i < areas.Length; i++)
			{
				string text = areas[i];
				if (text.StartsWith("FLOOR ", StringComparison.Ordinal))
				{
					if (num < 0)
					{
						num = list2.Count;
						list2.Add(null);
					}
					list.Add(text.Substring("FLOOR ".Length));
				}
				else
				{
					list2.Add(text);
				}
			}
			if (num >= 0)
			{
				string text2 = ((list.Count == 1) ? list[0] : (string.Join(", ", list.GetRange(0, list.Count - 1)) + " & " + list[list.Count - 1]));
				list2[num] = ((list.Count == 1) ? "FLOOR " : "FLOORS ") + text2;
			}
			return string.Join(", ", list2);
		}

		private void ShowEmpty()
		{
			_selected = -1;
			figure.Show(null, grow: false);
			nameLabel.text = "NO ENTRIES";
			speedValue.text = "-";
			foundValue.text = "-";
			dangerValue.text = "-";
			jumpscaredRow.SetActive(value: false);
			descriptionLabel.text = "Run Slop > Monster Index > Build Monster Index with MainScene open.";
		}

		private void Update()
		{
			if (_progressDirty)
			{
				ApplyProgress();
			}
			float unscaledTime = Time.unscaledTime;
			if (unscaledTime < _nextDistanceCheck)
			{
				return;
			}
			_nextDistanceCheck = unscaledTime + 0.15f;
			Transform transform = Head();
			if (transform == null)
			{
				return;
			}
			bool flag = Vector3.Distance(transform.position, base.transform.position) < (_shown ? hideBeyond : showWithin);
			if (flag != _shown)
			{
				_shown = flag;
				if (canvas != null)
				{
					canvas.enabled = flag;
				}
				figure.SetShown(flag);
			}
		}

		[ContextMenu("Dev: Unlock Every Monster")]
		private void DevUnlockAll()
		{
			MonsterIndexProgress.DevUnlockAll();
		}

		[ContextMenu("Dev: Empty The Index")]
		private void DevReset()
		{
			MonsterIndexProgress.DevReset();
		}

		private static Transform Head()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager != null && manager.Head != null)
			{
				return manager.Head;
			}
			Camera main = Camera.main;
			if (!(main != null))
			{
				return null;
			}
			return main.transform;
		}
	}
}
