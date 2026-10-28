using System.Collections.Generic;
using System.Reflection;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.UI.Notifications
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class HandNotifications : MonoBehaviour
	{
		private struct Pending
		{
			public NotificationKind kind;

			public string title;

			public string body;

			public float life;

			public string key;
		}

		[Header("Anchor")]
		[Tooltip("Ride the left hand (watch-style). Off = right hand.")]
		[SerializeField]
		private bool useLeftHand = true;

		[Tooltip("Height of the first card above the hand, in metres.")]
		[SerializeField]
		private float baseHeight = 0.24f;

		[Tooltip("Minimum vertical step between stacked cards, in metres. Cards taller than this (a wrapped two-line body) push the stack further apart on their own.")]
		[SerializeField]
		private float stackSpacing = 0.105f;

		private const float StackGap = 0.014f;

		[Header("Card")]
		[Tooltip("Panel width in metres. Height follows the 300x100 design ratio.")]
		[SerializeField]
		private float cardWidthMeters = 0.26f;

		[SerializeField]
		private int maxVisible = 3;

		[SerializeField]
		private float defaultLife = 3.6f;

		[Tooltip("Seconds a lazy float takes to settle. Higher = floatier.")]
		[SerializeField]
		private float positionSmoothTime = 0.16f;

		[Header("Palette")]
		[SerializeField]
		private Color panelColor = new Color(0.055f, 0.063f, 0.086f, 0.94f);

		[SerializeField]
		private Color bodyColor = new Color(0.902f, 0.914f, 0.933f, 1f);

		[SerializeField]
		private Color errorColor = new Color(0.898f, 0.282f, 0.302f, 1f);

		[SerializeField]
		private Color successColor = new Color(0.275f, 0.655f, 0.345f, 1f);

		[SerializeField]
		private Color infoColor = new Color(0.231f, 0.62f, 1f, 1f);

		[SerializeField]
		private Color rewardColor = new Color(0.976f, 0.451f, 0.086f, 1f);

		[SerializeField]
		private Color eventColor = new Color(0.71f, 0.482f, 1f, 1f);

		[Header("Font")]
		[Tooltip("Leave empty to use the project's TMP default font asset.")]
		[SerializeField]
		private TMP_FontAsset fontOverride;

		private const float CardW = 300f;

		private const float CardMinH = 92f;

		private const float PadLeft = 34f;

		private const float PadRight = 16f;

		private const float TitleTop = 10f;

		private const float TitleH = 34f;

		private const float BodyTop = 44f;

		private const float BodyBot = 14f;

		private const float TextW = 250f;

		private readonly List<HandNotificationCard> _pool = new List<HandNotificationCard>();

		private readonly List<HandNotificationCard> _visible = new List<HandNotificationCard>();

		private readonly Queue<Pending> _queue = new Queue<Pending>();

		private bool _built;

		private static bool _quitting;

		private static float s_reservedHeight;

		public static HandNotifications Instance { get; private set; }

		public static bool PreferLeftHand
		{
			get
			{
				return Instance == null || Instance.useLeftHand;
			}
			set
			{
				HandNotifications instance = EnsureInstance();
				if (instance != null)
				{
					instance.useLeftHand = value;
				}
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
			_quitting = false;
		}

		public static HandNotifications EnsureInstance()
		{
			if (Instance != null)
			{
				return Instance;
			}
			if (_quitting)
			{
				return null;
			}
			HandNotifications existing = Object.FindAnyObjectByType<HandNotifications>(FindObjectsInactive.Include);
			if (existing != null)
			{
				existing.Claim();
			}
			else
			{
				new GameObject("HandNotifications").AddComponent<HandNotifications>().Claim();
			}
			return Instance;
		}

		private void Claim()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
			base.transform.SetParent(null, true);
			Object.DontDestroyOnLoad(base.gameObject);
			Build();
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(base.gameObject);
			}
			else
			{
				Claim();
			}
		}

		private void OnApplicationQuit()
		{
			_quitting = true;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public static void Error(string title, string body, float life = 0f)
		{
			Show(NotificationKind.Error, title, body, life);
		}

		public static void Success(string title, string body, float life = 0f)
		{
			Show(NotificationKind.Success, title, body, life);
		}

		public static void Info(string title, string body, float life = 0f)
		{
			Show(NotificationKind.Info, title, body, life);
		}

		public static void Reward(string title, string body, float life = 0f)
		{
			Show(NotificationKind.Reward, title, body, life);
		}

		public static void Show(NotificationKind kind, string title, string body, float life = 0f)
		{
			HandNotifications instance = EnsureInstance();
			if (!(instance == null))
			{
				instance.Enqueue(kind, title, body, life);
			}
		}

		private void Enqueue(NotificationKind kind, string title, string body, float life)
		{
			if (!_built)
			{
				Build();
			}
			if (life <= 0f)
			{
				life = defaultLife;
			}
			string key = (int)kind + "|" + title + "|" + body;
			for (int i = 0; i < _visible.Count; i++)
			{
				if (_visible[i].Key == key)
				{
					_visible[i].Refresh(life);
					return;
				}
			}
			foreach (Pending item in _queue)
			{
				if (item.key == key)
				{
					return;
				}
			}
			_queue.Enqueue(new Pending
			{
				kind = kind,
				title = title,
				body = body,
				life = life,
				key = key
			});
			PumpQueue();
		}

		private void Update()
		{
			for (int num = _visible.Count - 1; num >= 0; num--)
			{
				if (_visible[num] == null || !_visible[num].IsActive)
				{
					_visible.RemoveAt(num);
				}
			}
			ApplyStackLayout(ResolveHandAnchor(), ResolveHead());
			PumpQueue();
		}

		public static void SetReservedHeight(float metres)
		{
			metres = Mathf.Max(0f, metres);
			if (!Mathf.Approximately(s_reservedHeight, metres))
			{
				s_reservedHeight = metres;
				if (Instance != null)
				{
					Instance.ApplyStackLayout(Instance.ResolveHandAnchor(), ResolveHead());
				}
			}
		}

		private void ApplyStackLayout(Transform anchor, Transform head)
		{
			float num = baseHeight + s_reservedHeight;
			for (int i = 0; i < _visible.Count; i++)
			{
				HandNotificationCard card = _visible[i];
				if (!(card == null))
				{
					card.Slot = i;
					card.SetStackOffset(Vector3.up * num);
					card.SetRig(anchor, head);
					num += Mathf.Max(stackSpacing, card.HeightMeters + StackGap);
				}
			}
		}

		private void PumpQueue()
		{
			int num = Mathf.Max(1, maxVisible);
			bool flag = false;
			while (_queue.Count > 0 && _visible.Count < num)
			{
				Pending pending = _queue.Dequeue();
				HandNotificationCard card = TakeCard();
				if (card == null)
				{
					return;
				}
				Paint(card, pending.kind, pending.title, pending.body);
				card.Show(pending.key, ResolveHandAnchor(), ResolveHead(), Vector3.up * (baseHeight + s_reservedHeight), pending.life);
				_visible.Add(card);
				flag = true;
			}
			if (flag)
			{
				ApplyStackLayout(ResolveHandAnchor(), ResolveHead());
			}
		}

		private HandNotificationCard TakeCard()
		{
			for (int i = 0; i < _pool.Count; i++)
			{
				if (!_pool[i].IsActive)
				{
					return _pool[i];
				}
			}
			return null;
		}

		private void Paint(HandNotificationCard card, NotificationKind kind, string title, string body)
		{
			Color color = AccentFor(kind);
			if (card.accent != null)
			{
				card.accent.color = color;
			}
			if (card.background != null)
			{
				card.background.color = panelColor;
			}
			if (card.titleText != null)
			{
				card.titleText.color = color;
				card.titleText.text = (string.IsNullOrEmpty(title) ? "" : title.ToUpperInvariant());
			}
			if (card.bodyText != null)
			{
				card.bodyText.color = bodyColor;
				card.bodyText.text = body ?? "";
			}
			ResizeToContent(card, body);
		}

		private void ResizeToContent(HandNotificationCard card, string body)
		{
			if (card.root == null)
			{
				return;
			}
			float y = CardMinH;
			if (card.bodyText != null && !string.IsNullOrEmpty(body))
			{
				Vector2 preferredValues = card.bodyText.GetPreferredValues(body, TextW, 0f);
				y = Mathf.Max(CardMinH, BodyTop + preferredValues.y + BodyBot);
			}
			card.root.sizeDelta = new Vector2(CardW, y);
		}

		private Color AccentFor(NotificationKind kind)
		{
			switch (kind)
			{
			case NotificationKind.Error:
				return errorColor;
			case NotificationKind.Success:
				return successColor;
			case NotificationKind.Reward:
				return rewardColor;
			case NotificationKind.Event:
				return eventColor;
			default:
				return infoColor;
			}
		}

		private Transform ResolveHandAnchor()
		{
			if (!GorillaLocomotion.Player.HasInstance)
			{
				return null;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null)
			{
				return null;
			}
			Transform transform = (useLeftHand ? instance.leftHandFollower : instance.rightHandFollower);
			if (transform == null)
			{
				transform = (useLeftHand ? instance.leftHandTransform : instance.rightHandTransform);
			}
			return transform;
		}

		private static Transform ResolveHead()
		{
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (instance != null && instance.mainCamera != null)
				{
					return instance.mainCamera.transform;
				}
			}
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform;
			}
			return null;
		}

		private void Build()
		{
			if (!_built)
			{
				_built = true;
				float num = cardWidthMeters / CardW;
				int num2 = Mathf.Max(1, Mathf.Min(maxVisible, 6));
				for (int i = 0; i < num2; i++)
				{
					_pool.Add(BuildCard(i, Vector3.one * num));
				}
			}
		}

		private HandNotificationCard BuildCard(int index, Vector3 baseScale)
		{
			GameObject gameObject = new GameObject("HandNotificationCard_" + index, typeof(RectTransform));
			gameObject.transform.SetParent(base.transform, false);
			RectTransform rectTransform = (RectTransform)gameObject.transform;
			rectTransform.sizeDelta = new Vector2(CardW, CardMinH);
			rectTransform.pivot = new Vector2(0.5f, 0.5f);
			gameObject.AddComponent<Canvas>().renderMode = RenderMode.WorldSpace;
			CanvasGroup canvasGroup = gameObject.AddComponent<CanvasGroup>();
			canvasGroup.interactable = false;
			canvasGroup.blocksRaycasts = false;
			canvasGroup.alpha = 0f;
			Image image = NewImage(rectTransform, "BG", panelColor);
			Stretch(image.rectTransform, 0f, 0f, 0f, 0f);
			Image image2 = NewImage(rectTransform, "Accent", errorColor);
			RectTransform rectTransform2 = image2.rectTransform;
			rectTransform2.anchorMin = new Vector2(0f, 0f);
			rectTransform2.anchorMax = new Vector2(0f, 1f);
			rectTransform2.pivot = new Vector2(0f, 0.5f);
			rectTransform2.offsetMin = new Vector2(12f, 12f);
			rectTransform2.offsetMax = new Vector2(22f, -12f);
			TMP_Text tMP_Text = NewText(rectTransform, "Title", 27f, FontStyles.Bold, TextAlignmentOptions.MidlineLeft);
			RectTransform rectTransform3 = tMP_Text.rectTransform;
			rectTransform3.anchorMin = new Vector2(0f, 1f);
			rectTransform3.anchorMax = new Vector2(1f, 1f);
			rectTransform3.pivot = new Vector2(0.5f, 1f);
			rectTransform3.offsetMin = new Vector2(PadLeft, -(TitleTop + TitleH));
			rectTransform3.offsetMax = new Vector2(-PadRight, -TitleTop);
			tMP_Text.enableAutoSizing = true;
			tMP_Text.fontSizeMax = 27f;
			tMP_Text.fontSizeMin = 15f;
			tMP_Text.overflowMode = TextOverflowModes.Overflow;
			TMP_Text tMP_Text2 = NewText(rectTransform, "Body", 20f, FontStyles.Normal, TextAlignmentOptions.TopLeft);
			Stretch(tMP_Text2.rectTransform, PadLeft, PadRight, BodyTop, BodyBot);
			tMP_Text2.textWrappingMode = TextWrappingModes.Normal;
			tMP_Text2.overflowMode = TextOverflowModes.Overflow;
			tMP_Text2.color = bodyColor;
			HandNotificationCard handNotificationCard = gameObject.AddComponent<HandNotificationCard>();
			handNotificationCard.root = rectTransform;
			handNotificationCard.group = canvasGroup;
			handNotificationCard.background = image;
			handNotificationCard.accent = image2;
			handNotificationCard.titleText = tMP_Text;
			handNotificationCard.bodyText = tMP_Text2;
			handNotificationCard.positionSmoothTime = positionSmoothTime;
			handNotificationCard.Initialise(baseScale);
			return handNotificationCard;
		}

		private static void Stretch(RectTransform rt, float left, float right, float top, float bottom)
		{
			rt.anchorMin = Vector2.zero;
			rt.anchorMax = Vector2.one;
			rt.pivot = new Vector2(0.5f, 0.5f);
			rt.offsetMin = new Vector2(left, bottom);
			rt.offsetMax = new Vector2(0f - right, 0f - top);
		}

		private static Image NewImage(RectTransform parent, string name, Color color)
		{
			GameObject gameObject = new GameObject(name, typeof(RectTransform));
			gameObject.transform.SetParent(parent, false);
			Image image = gameObject.AddComponent<Image>();
			image.sprite = null;
			image.type = Image.Type.Simple;
			image.color = color;
			image.raycastTarget = false;
			return image;
		}

		private TMP_Text NewText(RectTransform parent, string name, float size, FontStyles style, TextAlignmentOptions align)
		{
			GameObject gameObject = new GameObject(name, typeof(RectTransform));
			gameObject.transform.SetParent(parent, false);
			TextMeshProUGUI textMeshProUGUI = gameObject.AddComponent<TextMeshProUGUI>();
			TMP_FontAsset tMP_FontAsset = ResolveFont();
			if (tMP_FontAsset != null)
			{
				textMeshProUGUI.font = tMP_FontAsset;
			}
			textMeshProUGUI.fontSize = size;
			textMeshProUGUI.fontStyle = style;
			textMeshProUGUI.alignment = align;
			textMeshProUGUI.raycastTarget = false;
			textMeshProUGUI.richText = true;
			textMeshProUGUI.textWrappingMode = TextWrappingModes.NoWrap;
			RectTransform rectTransform = textMeshProUGUI.rectTransform;
			rectTransform.localPosition = new Vector3(rectTransform.localPosition.x, rectTransform.localPosition.y, -0.6f);
			return textMeshProUGUI;
		}

		private TMP_FontAsset ResolveFont()
		{
			if (fontOverride != null)
			{
				return fontOverride;
			}
			TMP_FontAsset defaultFontAsset = TMP_Settings.defaultFontAsset;
			if (defaultFontAsset != null)
			{
				return defaultFontAsset;
			}
			return Resources.Load<TMP_FontAsset>("Fonts & Materials/LiberationSans SDF");
		}
	}
}
