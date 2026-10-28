using System.Collections.Generic;
using System.Reflection;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(RectTransform))]
	public class BtmResearchMap : MonoBehaviour, IBtmRayTarget
	{
		private sealed class NodeView
		{
			public BtmItemDefinition item;

			public Vector2 pos;

			public RectTransform root;

			public Image glow;

			public Image dot;

			public Image ring;

			public TextMeshProUGUI label;

			public float hoverT;

			public float appearAt;

			public readonly List<EdgeView> incoming = new List<EdgeView>();
		}

		private sealed class EdgeView
		{
			public NodeView from;

			public NodeView to;

			public RawImage image;

			public float length;

			public bool marching;
		}

		private enum NodeState
		{
			Owned = 0,
			Available = 1,
			Locked = 2
		}

		private RectTransform _card;

		private RectTransform _leader;

		private RectTransform _leaderDot;

		private Image _leaderImg;

		private Image _leaderDotImg;

		private CanvasGroup _cardGroup;

		private TextMeshProUGUI _cardTitle;

		private TextMeshProUGUI _cardCost;

		private TextMeshProUGUI _cardBody;

		private TextMeshProUGUI _cardTag;

		private TextMeshProUGUI _cardStatus;

		private Image[] _cardBorder;

		private float _cardT;

		private bool _cardWanted;

		private RectTransform _cursor;

		private Image _cursorRing;

		private Image _cursorGlow;

		private bool _cursorVisible;

		private float _cursorA;

		private float _cursorPulse;

		private bool _cursorPressed;

		private const float CardW = 64f;

		private const float CardH = 31f;

		[Header("Text")]
		[SerializeField]
		private TMP_FontAsset font;

		[Tooltip("Optional: the board's own header value (e.g. its Version row) to show 07/11 in.")]
		[SerializeField]
		private TMP_Text externalProgress;

		[Header("Colours")]
		[SerializeField]
		private Color survivorColor = new Color(0.72f, 0.86f, 1f, 1f);

		[SerializeField]
		private Color monsterColor = new Color(0.95f, 0.1f, 0.14f, 1f);

		[SerializeField]
		private Color coreColor = new Color(1f, 0.62f, 0.18f, 1f);

		[SerializeField]
		private Color availableColor = new Color(1f, 0.84f, 0.2f, 1f);

		[SerializeField]
		private Color lockedColor = new Color(0.4f, 0.41f, 0.44f, 1f);

		[SerializeField]
		private Color gridColor = new Color(1f, 1f, 1f, 0.05f);

		[SerializeField]
		private Color ink = new Color(1f, 1f, 1f, 1f);

		[SerializeField]
		private Color inkDim = new Color(0.75f, 0.78f, 0.82f, 1f);

		[Header("Layout (canvas units, ~1 cm each on the boards)")]
		[SerializeField]
		private float padding = 8f;

		[SerializeField]
		private float headerHeight = 20f;

		[SerializeField]
		private float nodeSize = 4.6f;

		[SerializeField]
		private float lineWidth = 0.55f;

		[SerializeField]
		private float gridCell = 6f;

		[SerializeField]
		private float hoverRadius = 7f;

		[Header("Feel")]
		[SerializeField]
		private float hoverScale = 1.55f;

		[SerializeField]
		private float scanInSeconds = 0.9f;

		[SerializeField]
		private float dashSpeed = 1.2f;

		[SerializeField]
		private AudioClip hoverClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverVolume = 0.25f;

		private RectTransform _rect;

		private CanvasGroup _group;

		private RectTransform _dynamic;

		private readonly List<NodeView> _nodes = new List<NodeView>();

		private readonly List<EdgeView> _edges = new List<EdgeView>();

		private readonly Dictionary<BtmItemDefinition, NodeView> _byItem = new Dictionary<BtmItemDefinition, NodeView>();

		private readonly HashSet<EdgeView> _pathEdges = new HashSet<EdgeView>();

		private bool _built;

		private float _openedAt;

		private NodeView _hover;

		private NodeView _pinned;

		private AudioSource _voice;

		private RectTransform _progressFill;

		private float _barWidth;

		private TextMeshProUGUI _progressText;

		private TextMeshProUGUI _salvageText;

		public bool RayEnabled
		{
			get
			{
				if (base.isActiveAndEnabled && _built)
				{
					return _group.alpha > 0.3f;
				}
				return false;
			}
		}

		private NodeView Focus => _hover ?? _pinned;

		private void Build()
		{
			BtmTechTreeCatalog catalog = BtmTechTreeCatalog.Instance;
			if (catalog == null)
			{
				return;
			}
			Rect rect = _rect.rect;
			Vector2 half = new Vector2(rect.width * 0.5f, rect.height * 0.5f);
			RawImage grid = NewRaw(base.transform, "Grid", BtmUiSprites.Grid, gridColor);
			Stretch(grid.rectTransform);
			grid.uvRect = new Rect(0f, 0f, rect.width / gridCell, rect.height / gridCell);
			BuildHeader(half);
			_dynamic = (RectTransform)new GameObject("Dynamic", typeof(RectTransform), typeof(Canvas)).transform;
			_dynamic.SetParent(base.transform, false);
			Stretch(_dynamic);
			RectTransform edges = NewRect(_dynamic, "Edges");
			RectTransform nodes = NewRect(_dynamic, "Nodes");
			Stretch(edges);
			Stretch(nodes);
			Layout(catalog, half);
			foreach (NodeView node in _nodes)
			{
				BtmItemDefinition[] prerequisites = node.item.prerequisites;
				if (prerequisites == null)
				{
					continue;
				}
				foreach (BtmItemDefinition pre in prerequisites)
				{
					if (pre != null && _byItem.TryGetValue(pre, out var from))
					{
						_edges.Add(NewEdge(edges, from, node));
					}
				}
			}
			foreach (NodeView node2 in _nodes)
			{
				BuildNode(nodes, node2);
			}
			float coreTop = half.y - headerHeight;
			Caption(base.transform, "SURVIVOR", new Vector2(padding - half.x, padding - half.y), TextAlignmentOptions.BottomLeft, survivorColor);
			Caption(base.transform, "MONSTER", new Vector2(half.x - padding, padding - half.y), TextAlignmentOptions.BottomRight, monsterColor);
			Caption(base.transform, "CORE", new Vector2(0f, coreTop - 3f), TextAlignmentOptions.Top, coreColor);
			BuildCard();
			BuildCursor();
			_built = true;
		}

		private void BuildHeader(Vector2 half)
		{
			float top = half.y - padding;
			TextMeshProUGUI label = NewText(base.transform, "ProgressLabel", "UNLOCK PROGRESS", 3.1f, inkDim, TextAlignmentOptions.TopLeft);
			Place(label.rectTransform, new Vector2(padding - half.x, top), new Vector2(60f, 5f), new Vector2(0f, 1f));
			label.characterSpacing = 12f;
			_barWidth = half.x * 0.9f;
			Image bar = NewImage(base.transform, "ProgressBar", null, new Color(1f, 1f, 1f, 0.08f));
			Place(bar.rectTransform, new Vector2(padding - half.x, top - 6.5f), new Vector2(_barWidth, 1.3f), new Vector2(0f, 1f));
			_progressFill = NewImage(bar.transform, "Fill", null, availableColor).rectTransform;
			_progressFill.anchorMin = new Vector2(0f, 0f);
			_progressFill.anchorMax = new Vector2(0f, 1f);
			_progressFill.pivot = new Vector2(0f, 0.5f);
			_progressFill.anchoredPosition = Vector2.zero;
			_progressFill.sizeDelta = new Vector2(0f, 0f);
			_progressText = NewText(base.transform, "Progress", "00/00", 7f, ink, TextAlignmentOptions.TopRight);
			_progressText.fontStyle = FontStyles.Bold;
			Place(_progressText.rectTransform, new Vector2(half.x - padding, top + 1f), new Vector2(40f, 9f), new Vector2(1f, 1f));
			_salvageText = NewText(base.transform, "Salvage", "", 3.2f, ink, TextAlignmentOptions.TopRight);
			Place(_salvageText.rectTransform, new Vector2(half.x - padding, top - 8.5f), new Vector2(50f, 5f), new Vector2(1f, 1f));
			Image rule = NewImage(base.transform, "Rule", null, new Color(inkDim.r, inkDim.g, inkDim.b, 0.35f));
			Place(rule.rectTransform, new Vector2(0f, half.y - headerHeight + 3f), new Vector2(half.x * 2f - padding * 2f, 0.25f), new Vector2(0.5f, 0.5f));
		}

		private void Layout(BtmTechTreeCatalog catalog, Vector2 half)
		{
			Dictionary<BtmItemDefinition, int> depth = new Dictionary<BtmItemDefinition, int>();
			List<BtmItemDefinition> items = new List<BtmItemDefinition>();
			foreach (BtmItemDefinition item in catalog.items)
			{
				if (item != null)
				{
					items.Add(item);
					Depth(item, 0);
				}
			}
			int maxDepth = 0;
			foreach (BtmItemDefinition item2 in items)
			{
				if (item2.branch != BtmBranch.Core)
				{
					maxDepth = Mathf.Max(maxDepth, depth[item2]);
				}
			}
			float bandTop = half.y - headerHeight - 10f;
			float coreY = bandTop - 2f;
			float bottom = padding - half.y + 8f;
			float top = coreY - 12f;
			float midY = (bottom + top) * 0.5f;
			float spanY = (top - bottom) * 0.5f;
			float maxX = half.x - padding - 6f;
			foreach (BtmItemDefinition item3 in items)
			{
				NodeView nv = new NodeView();
				nv.item = item3;
				_nodes.Add(nv);
				_byItem[item3] = nv;
			}
			Dictionary<int, int> coreCount = new Dictionary<int, int>();
			int n;
			foreach (NodeView node in _nodes)
			{
				if (node.item.branch == BtmBranch.Core)
				{
					int side = ((node.item.role == BtmRole.Monster) ? 1 : (-1));
					coreCount.TryGetValue(side, out n);
					coreCount[side] = n + 1;
					node.pos = new Vector2(maxX * ((n * 0.12f + 0.1f) * side), coreY);
				}
			}
			for (int d = 0; d <= maxDepth; d++)
			{
				int[] sides = new int[2] { -1, 1 };
				foreach (int side2 in sides)
				{
					float t = (d + 0.5f) * 0.8f / (maxDepth + 1) + 0.16f;
					List<NodeView> column = new List<NodeView>();
					foreach (NodeView node2 in _nodes)
					{
						if (node2.item.branch != BtmBranch.Core && depth[node2.item] == d && ((node2.item.role == BtmRole.Monster) ? 1 : (-1)) == side2)
						{
							column.Add(node2);
						}
					}
					if (column.Count == 0)
					{
						continue;
					}
					column.Sort(delegate(NodeView a, NodeView b)
					{
						int num = ParentY(b).CompareTo(ParentY(a));
						return (num != 0) ? num : catalog.items.IndexOf(a.item).CompareTo(catalog.items.IndexOf(b.item));
					});
					int count = column.Count;
					float x = maxX * (t * side2);
					float step = Mathf.Min(1.7f / count, 0.5f);
					for (int i = 0; i < column.Count; i++)
					{
						column[i].pos = new Vector2(x, midY + spanY * ((i - (count - 1) * 0.5f) * -step));
					}
				}
			}
			int Depth(BtmItemDefinition it, int guard)
			{
				if (depth.TryGetValue(it, out var value))
				{
					return value;
				}
				value = 0;
				if (guard < 32 && it.prerequisites != null)
				{
					BtmItemDefinition[] prerequisites = it.prerequisites;
					foreach (BtmItemDefinition pre in prerequisites)
					{
						if (pre != null)
						{
							value = Mathf.Max(value, Depth(pre, guard + 1) + 1);
						}
					}
				}
				depth[it] = value;
				return value;
			}
		}

		private float ParentY(NodeView nv)
		{
			BtmItemDefinition[] prerequisites = nv.item.prerequisites;
			if (prerequisites == null)
			{
				return 0f;
			}
			float sum = 0f;
			int count = 0;
			foreach (BtmItemDefinition pre in prerequisites)
			{
				if (pre != null && _byItem.TryGetValue(pre, out var parent))
				{
					sum += parent.pos.y;
					count++;
				}
			}
			if (count <= 0)
			{
				return 0f;
			}
			return sum / count;
		}

		private EdgeView NewEdge(RectTransform layer, NodeView from, NodeView to)
		{
			RawImage image = NewRaw(layer, "Edge", null, Color.white);
			RectTransform rt = image.rectTransform;
			Vector2 delta = to.pos - from.pos;
			float length = delta.magnitude;
			rt.pivot = new Vector2(0f, 0.5f);
			rt.anchoredPosition = from.pos;
			rt.sizeDelta = new Vector2(length, lineWidth);
			rt.localRotation = Quaternion.Euler(0f, 0f, Mathf.Atan2(delta.y, delta.x) * Mathf.Rad2Deg);
			EdgeView edge = new EdgeView
			{
				from = from,
				to = to,
				image = image,
				length = length
			};
			to.incoming.Add(edge);
			return edge;
		}

		private void BuildNode(RectTransform layer, NodeView nv)
		{
			nv.root = NewRect(layer, "Node_" + nv.item.id);
			nv.root.anchoredPosition = nv.pos;
			nv.root.sizeDelta = Vector2.one * nodeSize;
			nv.glow = NewImage(nv.root, "Glow", BtmUiSprites.Soft, Color.clear);
			Place(nv.glow.rectTransform, Vector2.zero, Vector2.one * nodeSize * 3.2f, new Vector2(0.5f, 0.5f));
			nv.ring = NewImage(nv.root, "Ring", BtmUiSprites.Ring, Color.white);
			Place(nv.ring.rectTransform, Vector2.zero, Vector2.one * nodeSize * 1.45f, new Vector2(0.5f, 0.5f));
			nv.dot = NewImage(nv.root, "Dot", BtmUiSprites.Dot, Color.white);
			Place(nv.dot.rectTransform, Vector2.zero, Vector2.one * nodeSize, new Vector2(0.5f, 0.5f));
			nv.label = NewText(nv.root, "Label", "", 2.3f, ink, TextAlignmentOptions.Top);
			nv.label.lineSpacing = -12f;
			Place(nv.label.rectTransform, new Vector2(0f, nodeSize * -0.95f), new Vector2(34f, 7f), new Vector2(0.5f, 1f));
			nv.root.localScale = Vector3.zero;
		}

		private void Caption(Transform parent, string text, Vector2 pos, TextAlignmentOptions align, Color color)
		{
			TextMeshProUGUI caption = NewText(parent, "Caption_" + text, text, 2.8f, new Color(color.r, color.g, color.b, 0.8f), align);
			caption.characterSpacing = 25f;
			float pivotX = ((align == TextAlignmentOptions.BottomLeft) ? 0f : ((align == TextAlignmentOptions.BottomRight) ? 1f : 0.5f));
			float pivotY = ((align == TextAlignmentOptions.BottomRight || align == TextAlignmentOptions.BottomLeft) ? 0f : 1f);
			Place(caption.rectTransform, pos, new Vector2(40f, 5f), new Vector2(pivotX, pivotY));
		}

		private void BuildCard()
		{
			_leaderImg = NewImage(_dynamic, "Leader", null, Color.white);
			_leader = _leaderImg.rectTransform;
			_leader.pivot = new Vector2(0f, 0.5f);
			_leaderDotImg = NewImage(_dynamic, "LeaderDot", BtmUiSprites.Dot, Color.white);
			_leaderDot = _leaderDotImg.rectTransform;
			_leaderDot.sizeDelta = Vector2.one * 1.6f;
			_card = NewRect(_dynamic, "Card");
			_card.sizeDelta = new Vector2(CardW, CardH);
			_cardGroup = _card.gameObject.AddComponent<CanvasGroup>();
			_cardGroup.alpha = 0f;
			Stretch(NewImage(_card, "Back", null, new Color(0.035f, 0.035f, 0.04f, 0.96f)).rectTransform);
			_cardBorder = new Image[4];
			for (int i = 0; i < 4; i++)
			{
				_cardBorder[i] = NewImage(_card, "Edge" + i, null, Color.white);
				RectTransform rt = _cardBorder[i].rectTransform;
				rt.anchorMin = ((i < 2) ? new Vector2(0f, i) : new Vector2(i - 2, 0f));
				rt.anchorMax = ((i < 2) ? new Vector2(1f, i) : new Vector2(i - 2, 1f));
				rt.sizeDelta = ((i < 2) ? new Vector2(0f, 0.35f) : new Vector2(0.35f, 0f));
				rt.anchoredPosition = Vector2.zero;
			}
			_cardTitle = NewText(_card, "Title", "", 4.2f, ink, TextAlignmentOptions.TopLeft);
			_cardTitle.fontStyle = FontStyles.Bold;
			Place(_cardTitle.rectTransform, new Vector2(-29.4f, 12.9f), new Vector2(58.8f, 6f), new Vector2(0f, 1f));
			_cardCost = NewText(_card, "Cost", "", 3.4f, availableColor, TextAlignmentOptions.TopRight);
			Place(_cardCost.rectTransform, new Vector2(29.4f, 12.9f), new Vector2(30f, 6f), new Vector2(1f, 1f));
			_cardBody = NewText(_card, "Body", "", 2.7f, inkDim, TextAlignmentOptions.TopLeft);
			_cardBody.textWrappingMode = TextWrappingModes.Normal;
			Place(_cardBody.rectTransform, new Vector2(-29.4f, 5.9f), new Vector2(58.8f, 12f), new Vector2(0f, 1f));
			_cardTag = NewText(_card, "Tag", "", 2.1f, new Color(0.75f, 0.78f, 0.82f, 1f), TextAlignmentOptions.BottomLeft);
			_cardTag.characterSpacing = 8f;
			Place(_cardTag.rectTransform, new Vector2(-29.4f, -8.9f), new Vector2(58.8f, 4f), new Vector2(0f, 0f));
			_cardStatus = NewText(_card, "Status", "", 2.5f, ink, TextAlignmentOptions.BottomLeft);
			Place(_cardStatus.rectTransform, new Vector2(-29.4f, -12.9f), new Vector2(58.8f, 4f), new Vector2(0f, 0f));
			_leader.gameObject.SetActive(false);
			_leaderDot.gameObject.SetActive(false);
			_card.gameObject.SetActive(false);
		}

		private void ShowCard(NodeView nv)
		{
			_cardWanted = true;
			BtmItemDefinition item = nv.item;
			NodeState state = StateOf(item);
			Color color = ((state == NodeState.Owned) ? BranchColor(item) : ((state == NodeState.Available) ? availableColor : lockedColor));
			_cardTitle.text = item.displayName.ToUpperInvariant();
			_cardCost.text = ((state != NodeState.Owned) ? string.Format("{0} <size=70%>{1}</size>", item.cost, BtmTechTreeCatalog.CurrencyName.ToUpperInvariant()) : ("<color=#" + ColorUtility.ToHtmlStringRGB(BranchColor(item)) + ">OWNED</color>"));
			string body = item.description;
			if (item.kind == BtmItemKind.Potion)
			{
				body = body + "\n<color=#" + ColorUtility.ToHtmlStringRGB(ink) + ">Lasts " + item.DurationLabel + "</color>";
			}
			_cardBody.text = body;
			_cardTag.text = ((item.kind == BtmItemKind.SlotUnlock) ? "PERMANENT UPGRADE" : "EQUIPABLE AT THE START OF ROUND");
			_cardStatus.text = StatusFor(item, state);
			Image[] cardBorder = _cardBorder;
			for (int i = 0; i < cardBorder.Length; i++)
			{
				cardBorder[i].color = color;
			}
			_leaderImg.color = new Color(color.r, color.g, color.b, 0.85f);
			_leaderDotImg.color = color;
			Rect rect = _rect.rect;
			float halfW = rect.width * 0.5f;
			float halfH = rect.height * 0.5f;
			float side = ((nv.pos.x > 0f) ? (-1f) : 1f);
			float x = Mathf.Clamp(nv.pos.x + side * 44f, CardW * 0.5f - halfW + 2f, halfW - CardW * 0.5f - 2f);
			float y = Mathf.Clamp(nv.pos.y + ((nv.pos.y > 0f) ? (-10.85f) : 10.85f), CardH * 0.5f - halfH + 2f, halfH - headerHeight - CardH * 0.5f);
			_card.anchoredPosition = new Vector2(x, y);
			Vector2 anchor = new Vector2(x + side * -CardW * 0.5f, y + ((nv.pos.y > y) ? 9.3f : (-9.3f)));
			Vector2 dir = (anchor - nv.pos).normalized;
			Vector2 start = nv.pos + dir * nodeSize * 1.1f;
			_leader.anchoredPosition = start;
			Vector2 delta = anchor - start;
			_leader.sizeDelta = new Vector2(delta.magnitude, 0.35f);
			_leader.localRotation = Quaternion.Euler(0f, 0f, Mathf.Atan2(delta.y, delta.x) * Mathf.Rad2Deg);
			_leaderDot.anchoredPosition = anchor;
			_card.gameObject.SetActive(true);
			_leader.gameObject.SetActive(true);
			_leaderDot.gameObject.SetActive(true);
		}

		private string StatusFor(BtmItemDefinition item, NodeState state)
		{
			switch (state)
			{
			case NodeState.Locked:
			{
				System.Text.StringBuilder sb = new System.Text.StringBuilder("<color=#FF4A4A>Requires ");
				bool first = true;
				BtmItemDefinition[] prerequisites = item.prerequisites;
				foreach (BtmItemDefinition pre in prerequisites)
				{
					if (!(pre == null) && !BtmProgress.Owns(pre))
					{
						if (!first)
						{
							sb.Append(" + ");
						}
						sb.Append(pre.displayName);
						first = false;
					}
				}
				sb.Append("</color>");
				return sb.ToString();
			}
			case NodeState.Owned:
				if (item.kind != BtmItemKind.SlotUnlock)
				{
					return "Pick it in the loadout box at round start";
				}
				return "Active on every round";
			default:
			{
				int need = item.cost - BtmProgress.Salvage;
				if (need > 0)
				{
					return string.Format("<color=#FF4A4A>Need {0} more</color> - buy it in the Tech Tree", need);
				}
				return "<color=#FFD633>Affordable</color> - buy it in the Tech Tree";
			}
			}
		}

		private void HideCard()
		{
			_cardWanted = false;
		}

		private void UpdateCard(float dt)
		{
			if (_card == null)
			{
				return;
			}
			_cardT = Mathf.MoveTowards(_cardT, _cardWanted ? 1f : 0f, dt / 0.12f);
			float e = Mathf.SmoothStep(0f, 1f, _cardT);
			_cardGroup.alpha = e;
			_card.localScale = Vector3.one * Mathf.Lerp(0.92f, 1f, e);
			SetAlpha(_leaderImg, e * 0.85f);
			SetAlpha(_leaderDotImg, e);
			if (_cardT <= 0f && _card.gameObject.activeSelf)
			{
				_card.gameObject.SetActive(false);
				_leader.gameObject.SetActive(false);
				_leaderDot.gameObject.SetActive(false);
			}
		}

		private void BuildCursor()
		{
			_cursor = NewRect(_dynamic, "Cursor");
			_cursorGlow = NewImage(_cursor, "Glow", BtmUiSprites.Soft, new Color(1f, 1f, 1f, 0.25f));
			Place(_cursorGlow.rectTransform, Vector2.zero, Vector2.one * 9f, new Vector2(0.5f, 0.5f));
			_cursorRing = NewImage(_cursor, "Ring", BtmUiSprites.Ring, Color.white);
			Place(_cursorRing.rectTransform, Vector2.zero, Vector2.one * 3.2f, new Vector2(0.5f, 0.5f));
			Place(NewImage(_cursor, "Dot", BtmUiSprites.Dot, Color.white).rectTransform, Vector2.zero, Vector2.one * 0.8f, new Vector2(0.5f, 0.5f));
			_cursor.gameObject.SetActive(false);
		}

		private void ShowCursor(Vector2 local)
		{
			_cursorVisible = true;
			_cursor.anchoredPosition = local;
			if (!_cursor.gameObject.activeSelf)
			{
				_cursor.gameObject.SetActive(true);
			}
		}

		private void HideCursor()
		{
			_cursorVisible = false;
		}

		private void PulseCursor()
		{
			_cursorPulse = 1f;
		}

		private void SetCursorPressed(bool pressed)
		{
			_cursorPressed = pressed;
		}

		private void UpdateCursor(float dt)
		{
			if (_cursor == null)
			{
				return;
			}
			_cursorA = Mathf.MoveTowards(_cursorA, _cursorVisible ? 1f : 0f, dt / 0.1f);
			_cursorPulse = Mathf.MoveTowards(_cursorPulse, 0f, dt / 0.35f);
			if (_cursorA <= 0f)
			{
				if (_cursor.gameObject.activeSelf)
				{
					_cursor.gameObject.SetActive(false);
				}
				return;
			}
			float scale = ((_hover != null) ? 1.35f : 1f);
			_cursorRing.rectTransform.localScale = Vector3.one * (_cursorPressed ? 0.75f : scale) * (_cursorPulse * 0.8f + 1f);
			SetAlpha(_cursorRing, _cursorA);
			SetAlpha(_cursorGlow, _cursorA * (_cursorPulse * 0.4f + 0.22f));
		}

		private RectTransform NewRect(Transform parent, string name)
		{
			RectTransform rt = (RectTransform)new GameObject(name, typeof(RectTransform)).transform;
			rt.SetParent(parent, false);
			rt.anchorMax = new Vector2(0.5f, 0.5f);
			rt.anchorMin = new Vector2(0.5f, 0.5f);
			rt.pivot = new Vector2(0.5f, 0.5f);
			return rt;
		}

		private Image NewImage(Transform parent, string name, Sprite sprite, Color color)
		{
			Image image = NewRect(parent, name).gameObject.AddComponent<Image>();
			image.sprite = sprite;
			image.color = color;
			image.raycastTarget = false;
			return image;
		}

		private RawImage NewRaw(Transform parent, string name, Texture tex, Color color)
		{
			RawImage rawImage = NewRect(parent, name).gameObject.AddComponent<RawImage>();
			rawImage.texture = tex;
			rawImage.color = color;
			rawImage.raycastTarget = false;
			return rawImage;
		}

		private TextMeshProUGUI NewText(Transform parent, string name, string text, float size, Color color, TextAlignmentOptions align)
		{
			TextMeshProUGUI textMeshProUGUI = NewRect(parent, name).gameObject.AddComponent<TextMeshProUGUI>();
			if (font != null)
			{
				textMeshProUGUI.font = font;
			}
			textMeshProUGUI.fontSize = size;
			textMeshProUGUI.color = color;
			textMeshProUGUI.alignment = align;
			textMeshProUGUI.textWrappingMode = TextWrappingModes.NoWrap;
			textMeshProUGUI.overflowMode = TextOverflowModes.Overflow;
			textMeshProUGUI.raycastTarget = false;
			textMeshProUGUI.richText = true;
			textMeshProUGUI.text = text;
			return textMeshProUGUI;
		}

		private static void Place(RectTransform rt, Vector2 pos, Vector2 size, Vector2 pivot)
		{
			rt.pivot = pivot;
			rt.anchoredPosition = pos;
			rt.sizeDelta = size;
		}

		private static void Stretch(RectTransform rt)
		{
			rt.anchorMin = Vector2.zero;
			rt.anchorMax = Vector2.one;
			rt.offsetMin = Vector2.zero;
			rt.offsetMax = Vector2.zero;
		}

		private void Awake()
		{
			_rect = (RectTransform)base.transform;
			_group = GetComponent<CanvasGroup>();
			if (_group == null)
			{
				_group = base.gameObject.AddComponent<CanvasGroup>();
			}
			_group.interactable = false;
			_group.blocksRaycasts = false;
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 1f;
			_voice.spatialize = false;
			_voice.maxDistance = 6f;
		}

		private void OnEnable()
		{
			if (!_built)
			{
				Build();
			}
			BtmProgress.Changed += Refresh;
			BtmRayPointer.Register(this);
			Refresh();
			_openedAt = Time.time;
			_group.alpha = 0f;
			for (int i = 0; i < _nodes.Count; i++)
			{
				_nodes[i].appearAt = _openedAt + 0.15f + scanInSeconds * (float)i / (float)Mathf.Max(1, _nodes.Count);
			}
		}

		private void OnDisable()
		{
			BtmProgress.Changed -= Refresh;
			BtmRayPointer.Unregister(this);
			_hover = null;
			_pinned = null;
			HideCard();
			HideCursor();
		}

		public bool TryHit(Ray ray, float maxDistance, out Vector3 point, out float distance)
		{
			point = default(Vector3);
			distance = 0f;
			Vector3 forward = _rect.forward;
			float num = Vector3.Dot(ray.direction, forward);
			if (Mathf.Abs(num) < 0.0001f)
			{
				return false;
			}
			distance = Vector3.Dot(forward, _rect.position - ray.origin) / num;
			if (distance <= 0f || distance > maxDistance)
			{
				return false;
			}
			point = ray.origin + ray.direction * distance;
			Vector3 vector = _rect.InverseTransformPoint(point);
			return _rect.rect.Contains(vector);
		}

		public bool OnRayHover(Vector3 worldPoint)
		{
			Vector2 vector = _rect.InverseTransformPoint(worldPoint);
			ShowCursor(vector);
			float num = hoverRadius * hoverRadius;
			NodeView nodeView = null;
			foreach (NodeView node in _nodes)
			{
				float sqrMagnitude = (node.pos - vector).sqrMagnitude;
				if (sqrMagnitude < num)
				{
					num = sqrMagnitude;
					nodeView = node;
				}
			}
			if (nodeView == _hover)
			{
				return false;
			}
			_hover = nodeView;
			OnFocusChanged();
			if (nodeView != null && hoverClip != null)
			{
				_voice.PlayOneShot(hoverClip, hoverVolume);
			}
			return nodeView != null;
		}

		public void OnRayExit()
		{
			HideCursor();
			if (_hover != null)
			{
				_hover = null;
				OnFocusChanged();
			}
		}

		public void OnRayClick(Vector3 worldPoint)
		{
			_pinned = ((_hover != null && _pinned != _hover) ? _hover : null);
			PulseCursor();
			OnFocusChanged();
		}

		public void OnRayPress(bool pressed)
		{
			SetCursorPressed(pressed);
		}

		private void OnFocusChanged()
		{
			_pathEdges.Clear();
			NodeView focus = Focus;
			if (focus != null)
			{
				CollectPath(focus);
				RestyleEdges();
				ShowCard(focus);
			}
			else
			{
				RestyleEdges();
				HideCard();
			}
		}

		private void CollectPath(NodeView nv)
		{
			foreach (EdgeView item in nv.incoming)
			{
				if (_pathEdges.Add(item))
				{
					CollectPath(item.from);
				}
			}
		}

		private void Update()
		{
			if (!_built)
			{
				return;
			}
			float time = Time.time;
			float deltaTime = Time.deltaTime;
			_group.alpha = Mathf.MoveTowards(_group.alpha, 1f, deltaTime * 4f);
			float maxDelta = deltaTime / 0.12f;
			foreach (NodeView node in _nodes)
			{
				float num = Mathf.Clamp01((time - node.appearAt) / 0.18f);
				node.hoverT = Mathf.MoveTowards(node.hoverT, (node == Focus) ? 1f : 0f, maxDelta);
				float num2 = Mathf.SmoothStep(0f, 1f, node.hoverT);
				float num3 = 1f;
				if (num < 1f)
				{
					num3 = Mathf.SmoothStep(0f, 1f, num) * (1f + Mathf.Sin(num * Mathf.PI) * 0.25f);
				}
				node.root.localScale = Vector3.one * Mathf.Lerp(1f, hoverScale, num2) * num3;
				if (StateOf(node.item) == NodeState.Available)
				{
					float num4 = Mathf.Sin(time * 3.2f + node.pos.x * 0.1f) * 0.45f + 0.55f;
					SetAlpha(node.ring, Mathf.Lerp(num4, 1f, num2));
					SetAlpha(node.glow, Mathf.Lerp(num4 * 0.18f, 0.55f, num2));
				}
				else
				{
					SetAlpha(node.glow, Mathf.Lerp((StateOf(node.item) == NodeState.Owned) ? 0.3f : 0f, 0.55f, num2));
				}
			}
			foreach (EdgeView edge in _edges)
			{
				if (edge.marching)
				{
					Rect uvRect = edge.image.uvRect;
					uvRect.x = (0f - time) * dashSpeed;
					edge.image.uvRect = uvRect;
				}
			}
			UpdateCursor(deltaTime);
			UpdateCard(deltaTime);
		}

		private static void SetAlpha(Graphic g, float a)
		{
			if (!(g == null))
			{
				Color color = g.color;
				if (!(Mathf.Abs(color.a - a) < 0.004f))
				{
					color.a = a;
					g.color = color;
				}
			}
		}

		private static NodeState StateOf(BtmItemDefinition item)
		{
			BtmUnlockResult btmUnlockResult = BtmProgress.CanUnlock(item);
			if (btmUnlockResult == BtmUnlockResult.AlreadyOwned)
			{
				return NodeState.Owned;
			}
			if (btmUnlockResult == BtmUnlockResult.MissingPrerequisite)
			{
				return NodeState.Locked;
			}
			return NodeState.Available;
		}

		private Color BranchColor(BtmItemDefinition item)
		{
			if (item.branch == BtmBranch.Core)
			{
				return coreColor;
			}
			if (item.role != BtmRole.Monster)
			{
				return survivorColor;
			}
			return monsterColor;
		}

		private void Refresh()
		{
			if (!_built)
			{
				return;
			}
			int num = 0;
			foreach (NodeView node in _nodes)
			{
				NodeState nodeState = StateOf(node.item);
				if (nodeState == NodeState.Owned)
				{
					num++;
				}
				Color color = BranchColor(node.item);
				switch (nodeState)
				{
				case NodeState.Owned:
					node.dot.color = color;
					node.ring.color = new Color(color.r, color.g, color.b, 0.9f);
					node.glow.color = new Color(color.r, color.g, color.b, 0.3f);
					node.label.text = node.item.displayName + "\n<color=#" + ColorUtility.ToHtmlStringRGB(color) + ">OWNED</color>";
					break;
				case NodeState.Available:
					node.dot.color = new Color(availableColor.r, availableColor.g, availableColor.b, 0.35f);
					node.ring.color = availableColor;
					node.glow.color = new Color(availableColor.r, availableColor.g, availableColor.b, 0.2f);
					node.label.text = string.Format("{0}\n<color=#{1}>{2}</color>", node.item.displayName, ColorUtility.ToHtmlStringRGB(availableColor), node.item.cost);
					break;
				default:
					node.dot.color = new Color(lockedColor.r, lockedColor.g, lockedColor.b, 0.55f);
					node.ring.color = new Color(lockedColor.r, lockedColor.g, lockedColor.b, 0.5f);
					node.glow.color = Color.clear;
					node.label.text = string.Format("<color=#{0}>{1}\n{2}</color>", ColorUtility.ToHtmlStringRGB(inkDim), node.item.displayName, node.item.cost);
					break;
				}
			}
			int count = _nodes.Count;
			string text = string.Format("{0:00}/{1:00}", num, count);
			if (_progressText != null)
			{
				_progressText.text = text;
			}
			if (externalProgress != null)
			{
				externalProgress.text = text;
			}
			if (_progressFill != null)
			{
				float num2 = ((count > 0) ? ((float)num / (float)count) : 0f);
				_progressFill.sizeDelta = new Vector2(_barWidth * num2, _progressFill.sizeDelta.y);
			}
			if (_salvageText != null)
			{
				_salvageText.text = string.Format("{0} <size=70%><color=#{1}>{2}</color></size>", BtmProgress.Salvage, ColorUtility.ToHtmlStringRGB(inkDim), BtmTechTreeCatalog.CurrencyName.ToUpperInvariant());
			}
			RestyleEdges();
			NodeView focus = Focus;
			if (focus != null)
			{
				ShowCard(focus);
			}
		}

		private void RestyleEdges()
		{
			foreach (EdgeView edge in _edges)
			{
				NodeState nodeState = StateOf(edge.to.item);
				NodeState nodeState2 = StateOf(edge.from.item);
				bool flag = _pathEdges.Contains(edge);
				Color color;
				if (nodeState == NodeState.Owned)
				{
					Color color2 = BranchColor(edge.to.item);
					color = new Color(color2.r, color2.g, color2.b, flag ? 1f : 0.75f);
				}
				else if (nodeState2 == NodeState.Owned)
				{
					color = new Color(availableColor.r, availableColor.g, availableColor.b, flag ? 1f : 0.7f);
				}
				else
				{
					color = new Color(lockedColor.r, lockedColor.g, lockedColor.b, flag ? 0.85f : 0.35f);
				}
				edge.image.color = color;
				edge.image.texture = ((nodeState != NodeState.Owned) ? BtmUiSprites.Dash : null);
				edge.image.uvRect = new Rect(0f, 0f, (nodeState != NodeState.Owned) ? (edge.length / 3f) : 1f, 1f);
				edge.marching = nodeState != NodeState.Owned && (nodeState2 == NodeState.Owned || flag);
				edge.image.rectTransform.sizeDelta = new Vector2(edge.length, flag ? (lineWidth * 1.8f) : lineWidth);
			}
		}
	}
}

