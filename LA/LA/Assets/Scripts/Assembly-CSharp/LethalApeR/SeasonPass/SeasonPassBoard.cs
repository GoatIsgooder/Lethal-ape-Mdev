using System;
using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.UI.Notifications;
using GorillaLocomotion;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.SeasonPass
{
	[DisallowMultipleComponent]
	public class SeasonPassBoard : MonoBehaviour
	{
		private enum TargetKind
		{
			PassTab = 0,
			QuestsTab = 1,
			Purchase = 2,
			PrevPage = 3,
			NextPage = 4,
			Card = 5,
			DailyClaim = 6,
			ChallengeClaim = 7,
			BuyLevel = 8
		}

		private sealed class TouchTarget
		{
			public TargetKind kind;

			public int slot;

			public RectTransform rect;

			public bool active;

			public Vector2 min;

			public Vector2 max;

			public float fill;

			public float punch;

			public float punchScale;

			public bool holding;
		}

		private sealed class Finger
		{
			public readonly bool left;

			public Transform tip;

			public TouchTarget target;

			public float held;

			public bool done;

			public Finger(bool isLeft)
			{
				left = isLeft;
			}
		}

		private enum Tab
		{
			Pass = 0,
			Quests = 1
		}

		private const float PunchSeconds = 0.22f;

		private const float FillDecayPerSecond = 2.5f;

		private const float SentHapticAmplitude = 0.6f;

		private const float SentHapticSeconds = 0.08f;

		[Header("Touch")]
		[SerializeField]
		[Min(0.2f)]
		private float holdSeconds = 1.5f;

		[Tooltip("Canvas units in front of the board face that still count as a touch.")]
		[SerializeField]
		[Min(0f)]
		private float touchFront = 5f;

		[Tooltip("Canvas units behind the face: fingertips sink past it before the hand collider stops them.")]
		[SerializeField]
		[Min(0f)]
		private float touchBack = 6f;

		[Tooltip("Extra canvas units a finger can drift before a press or hold lets go.")]
		[SerializeField]
		[Min(0f)]
		private float releasePadding = 1.5f;

		[SerializeField]
		[Min(0f)]
		private float tapCooldown = 0.3f;

		private readonly List<TouchTarget> _targets = new List<TouchTarget>(32);

		private readonly Finger[] _fingers = new Finger[3] { new Finger(true), new Finger(false), new Finger(false) };

		private readonly List<Transform> _tipScratch = new List<Transform>(256);

		private readonly Vector3[] _corners = new Vector3[4];

		private Player _tipOwner;

		private float _nextTipSearch;

		private float _tapReadyAt;

		private const float XpFillPerSecond = 1.6f;

		private const float LevelPopSeconds = 0.35f;

		private const float SuccessEchoSeconds = 0.13f;

		private const string HiddenGlyph = "???";

		private static readonly Vector2 FreeCardSize = new Vector2(22f, 23f);

		private static readonly Vector2 PremiumCardSize = new Vector2(24f, 30f);

		private static readonly Vector2 FeaturedCardSize = new Vector2(29f, 52f);

		[Header("Layout")]
		[SerializeField]
		private RectTransform passUI;

		[SerializeField]
		private GameObject passPage;

		[SerializeField]
		private GameObject questsPage;

		[Header("Tabs")]
		[SerializeField]
		private SeasonPassButtonView passTab = new SeasonPassButtonView();

		[SerializeField]
		private SeasonPassButtonView questsTab = new SeasonPassButtonView();

		[Header("Header")]
		[SerializeField]
		private RectTransform levelBox;

		[SerializeField]
		private TMP_Text levelLabel;

		[SerializeField]
		private TMP_Text levelValue;

		[SerializeField]
		private TMP_Text xpText;

		[SerializeField]
		private Image[] xpSegments = new Image[0];

		[SerializeField]
		private GameObject nextLevelIcon;

		[SerializeField]
		private TMP_Text nextLevelText;

		[SerializeField]
		private TMP_Text seasonText;

		[SerializeField]
		private TMP_Text countdownText;

		[SerializeField]
		private TMP_Text walletText;

		[Header("Pass")]
		[SerializeField]
		private SeasonPassColumnView[] columns = new SeasonPassColumnView[0];

		[SerializeField]
		private TMP_Text bigLevelText;

		[SerializeField]
		private GameObject premiumTrackLock;

		[Header("Footer")]
		[SerializeField]
		private SeasonPassButtonView purchaseButton = new SeasonPassButtonView();

		[SerializeField]
		private TMP_Text purchasePrice;

		[SerializeField]
		private SeasonPassButtonView buyLevelButton = new SeasonPassButtonView();

		[SerializeField]
		private TMP_Text buyLevelPrice;

		[SerializeField]
		private Image buyLevelFill;

		[SerializeField]
		private SeasonPassButtonView prevButton = new SeasonPassButtonView();

		[SerializeField]
		private SeasonPassButtonView nextButton = new SeasonPassButtonView();

		[SerializeField]
		private TMP_Text pageLabel;

		[SerializeField]
		private GameObject details;

		[SerializeField]
		private Image detailsIcon;

		[SerializeField]
		private TMP_Text detailsGlyph;

		[SerializeField]
		private TMP_Text detailsName;

		[SerializeField]
		private TMP_Text detailsInfo;

		[SerializeField]
		private TMP_Text detailsStatus;

		[SerializeField]
		private TMP_Text questsHint;

		[Header("Quests")]
		[SerializeField]
		private TMP_Text dailyReset;

		[SerializeField]
		private SeasonQuestRowView[] dailyRows = new SeasonQuestRowView[0];

		[SerializeField]
		private TMP_Text challengeCount;

		[SerializeField]
		private SeasonQuestRowView[] challengeRows = new SeasonQuestRowView[0];

		[Header("Feedback")]
		[SerializeField]
		private AudioSource sfx;

		[SerializeField]
		private AudioClip tapClip;

		[SerializeField]
		private AudioClip purchaseClip;

		[SerializeField]
		private ParticleSystem burst;

		[SerializeField]
		[Min(0f)]
		private int burstCount = 28;

		[Tooltip("Spawned on the button for every successful claim; it plays its own party horn.")]
		[SerializeField]
		private GameObject claimVfx;

		[Tooltip("Metres in front of the board face. The confetti leaves a 10 cm disc, which would otherwise start inside the board.")]
		[SerializeField]
		[Min(0f)]
		private float claimVfxOffset = 0.12f;

		[Header("Sprites")]
		[SerializeField]
		private Sprite frameSprite;

		[SerializeField]
		private Sprite featuredFrameSprite;

		private static readonly string[] Numbers = BuildNumbers(100);

		private SeasonPassService _service;

		private Tab _tab;

		private int _passPage;

		private int _challengePage;

		private int _selectedLevel;

		private bool _selectionChosen;

		private bool _dirty;

		private SeasonPassPhase _renderedPhase;

		private float _nextClockRefresh;

		private string _countdown;

		private string _dailyCountdown;

		private int _walletShown = int.MinValue;

		private bool _xpSnapped;

		private int _shownLevel;

		private float _shownProgress;

		private float _levelPop;

		private float _claimVfxSeconds;

		private float _hapticEchoAt = -1f;

		private bool _hapticEchoLeft;

		private int ColumnCount => Mathf.Max(1, columns.Length);

		private int PassPageCount => Mathf.Max(1, (_service.Season.MaxLevel + ColumnCount - 1) / ColumnCount);

		private int ChallengePageCount
		{
			get
			{
				int count = _service.Challenges.Count;
				int rows = Mathf.Max(1, challengeRows.Length);
				return Mathf.Max(1, (count + rows - 1) / rows);
			}
		}

		private string MaxLabel => _service.IsCapped ? "MAX FOR NOW" : "MAX LEVEL";

		private void EnsureTargets()
		{
			if (_targets.Count > 0)
			{
				return;
			}
			AddTarget(TargetKind.PassTab, 0, passTab.root);
			AddTarget(TargetKind.QuestsTab, 0, questsTab.root);
			AddTarget(TargetKind.Purchase, 0, purchaseButton.root);
			AddTarget(TargetKind.BuyLevel, 0, buyLevelButton.root);
			AddTarget(TargetKind.PrevPage, 0, prevButton.root);
			AddTarget(TargetKind.NextPage, 0, nextButton.root);
			for (int i = 0; i < columns.Length; i++)
			{
				if (columns[i] != null)
				{
					AddTarget(TargetKind.Card, i * 2, columns[i].freeCard?.root);
					AddTarget(TargetKind.Card, i * 2 + 1, columns[i].premiumCard?.root);
				}
			}
			for (int j = 0; j < dailyRows.Length; j++)
			{
				AddTarget(TargetKind.DailyClaim, j, dailyRows[j]?.claim);
			}
			for (int k = 0; k < challengeRows.Length; k++)
			{
				AddTarget(TargetKind.ChallengeClaim, k, challengeRows[k]?.claim);
			}
		}

		private void AddTarget(TargetKind kind, int slot, RectTransform rect)
		{
			if (!(rect == null))
			{
				_targets.Add(new TouchTarget
				{
					kind = kind,
					slot = slot,
					rect = rect
				});
			}
		}

		private void LayoutTargets()
		{
			EnsureTargets();
			for (int i = 0; i < _targets.Count; i++)
			{
				TouchTarget t = _targets[i];
				if (!t.rect.gameObject.activeInHierarchy)
				{
					t.active = false;
					continue;
				}
				t.active = TargetUsable(t);
				if (t.active)
				{
					t.rect.GetWorldCorners(_corners);
					Vector3 a = passUI.InverseTransformPoint(_corners[0]);
					Vector3 b = passUI.InverseTransformPoint(_corners[2]);
					t.min = new Vector2(Mathf.Min(a.x, b.x), Mathf.Min(a.y, b.y));
					t.max = new Vector2(Mathf.Max(a.x, b.x), Mathf.Max(a.y, b.y));
				}
			}
		}

		private bool TargetUsable(TouchTarget t)
		{
			switch (t.kind)
			{
			case TargetKind.Purchase:
				if (!_service.HasPremium && !SeasonPassPremium.CheckoutOpen)
				{
					return !_service.PremiumSaleLocked;
				}
				return false;
			case TargetKind.PrevPage:
				return ((_tab == Tab.Pass) ? _passPage : _challengePage) > 0;
			case TargetKind.NextPage:
				return ((_tab == Tab.Pass) ? _passPage : _challengePage) < ((_tab == Tab.Pass) ? PassPageCount : ChallengePageCount) - 1;
			case TargetKind.Card:
				return _tab == Tab.Pass;
			case TargetKind.DailyClaim:
			case TargetKind.ChallengeClaim:
				return _tab == Tab.Quests;
			case TargetKind.BuyLevel:
			{
				LevelBuyState state = SeasonPassLevelShop.State;
				if (state != LevelBuyState.Busy)
				{
					return state != LevelBuyState.MaxLevel;
				}
				return false;
			}
			default:
				return true;
			}
		}

		private void UpdateTouch(float dt)
		{
			EnsureTargets();
			ResolveTips();
			for (int i = 0; i < _targets.Count; i++)
			{
				_targets[i].holding = false;
			}
			for (int j = 0; j < _fingers.Length; j++)
			{
				Finger finger = _fingers[j];
				if (!TryFingerPosition(j, out var world))
				{
					Release(finger);
					continue;
				}
				Vector3 local = passUI.InverseTransformPoint(world);
				if (finger.target != null)
				{
					if (finger.target.active && Inside(finger.target, local, releasePadding))
					{
						Hold(finger, dt);
						continue;
					}
					finger.target = null;
					finger.held = 0f;
					finger.done = false;
				}
				TouchTarget t = FindTarget(local);
				if (t != null && !TargetTaken(t))
				{
					Begin(finger, t);
				}
			}
			AnimateTargets(dt);
		}

		private bool Inside(TouchTarget t, Vector3 local, float pad)
		{
			if (local.z < -(touchFront + pad) || local.z > touchBack + pad)
			{
				return false;
			}
			if (local.x >= t.min.x - pad && local.x <= t.max.x + pad && local.y >= t.min.y - pad)
			{
				return local.y <= t.max.y + pad;
			}
			return false;
		}

		private TouchTarget FindTarget(Vector3 local)
		{
			for (int i = 0; i < _targets.Count; i++)
			{
				TouchTarget t = _targets[i];
				if (t.active && Inside(t, local, 0f))
				{
					return t;
				}
			}
			return null;
		}

		private bool TargetTaken(TouchTarget t)
		{
			for (int i = 0; i < _fingers.Length; i++)
			{
				if (_fingers[i].target == t)
				{
					return true;
				}
			}
			return false;
		}

		private void Begin(Finger finger, TouchTarget t)
		{
			finger.target = t;
			finger.held = 0f;
			finger.done = false;
			switch (t.kind)
			{
			case TargetKind.Card:
			{
				int level = LevelForSlot(t.slot);
				if (level != _selectedLevel)
				{
					Select(level, movePage: false);
					Play(tapClip, 0.45f);
				}
				break;
			}
			case TargetKind.BuyLevel:
			{
				LevelBuyState state = SeasonPassLevelShop.State;
				if (state != LevelBuyState.Ready)
				{
					finger.done = true;
					if (!(Time.unscaledTime < _tapReadyAt))
					{
						_tapReadyAt = Time.unscaledTime + tapCooldown;
						Punch(t, -0.05f);
						Haptic(finger.left, 0.25f, 0.08f);
						HandNotifications.Show(NotificationKind.Info, "Season Pass", SeasonPassLevelShop.Explain(state));
					}
					return;
				}
				break;
			}
			default:
				finger.done = true;
				if (!(Time.unscaledTime < _tapReadyAt))
				{
					_tapReadyAt = Time.unscaledTime + tapCooldown;
					Punch(t, -0.08f);
					Haptic(finger.left, 0.35f, 0.05f);
					Play(tapClip, 1f);
					Press(t, finger.left);
				}
				return;
			case TargetKind.DailyClaim:
			case TargetKind.ChallengeClaim:
				break;
			}
			Haptic(finger.left, 0.15f, 0.03f);
		}

		private void Hold(Finger finger, float dt)
		{
			if (finger.done)
			{
				return;
			}
			TouchTarget t = finger.target;
			if (CanClaim(t))
			{
				finger.held += dt;
				float progress = Mathf.Clamp01(finger.held / holdSeconds);
				t.holding = true;
				t.fill = Mathf.Max(t.fill, progress);
				Haptic(finger.left, Mathf.Lerp(0.05f, 0.6f, progress), 0.04f);
				if (!(progress < 1f))
				{
					finger.done = true;
					if (Claim(t, finger.left))
					{
						Punch(t, 0.14f);
					}
				}
			}
		}

		private void Release(Finger finger)
		{
			finger.target = null;
			finger.held = 0f;
			finger.done = false;
		}

		private void ReleaseAllFingers()
		{
			for (int i = 0; i < _fingers.Length; i++)
			{
				Release(_fingers[i]);
			}
			for (int j = 0; j < _targets.Count; j++)
			{
				_targets[j].fill = 0f;
				_targets[j].punch = 0f;
				ApplyTargetVisuals(_targets[j]);
			}
		}

		private void Press(TouchTarget t, bool left)
		{
			switch (t.kind)
			{
			case TargetKind.PassTab:
				SetTab(Tab.Pass);
				break;
			case TargetKind.QuestsTab:
				SetTab(Tab.Quests);
				break;
			case TargetKind.Purchase:
				Purchase(left);
				break;
			case TargetKind.PrevPage:
				TurnPage(-1);
				break;
			case TargetKind.NextPage:
				TurnPage(1);
				break;
			}
		}

		private bool CanClaim(TouchTarget t)
		{
			switch (t.kind)
			{
			case TargetKind.DailyClaim:
			case TargetKind.ChallengeClaim:
			{
				SeasonQuestDefinition quest = QuestForTarget(t);
				if (quest != null && !SeasonPassServer.Busy)
				{
					return _service.CanClaimQuest(quest);
				}
				return false;
			}
			case TargetKind.Card:
				if (SeasonPassServer.Busy)
				{
					return false;
				}
				return _service.GetClaimBlock(LevelForSlot(t.slot)) == SeasonClaimBlock.None;
			case TargetKind.BuyLevel:
				return SeasonPassLevelShop.State == LevelBuyState.Ready;
			default:
				return false;
			}
		}

		private bool Claim(TouchTarget t, bool left)
		{
			switch (t.kind)
			{
			case TargetKind.Card:
				ClaimReward(t, left);
				return true;
			case TargetKind.BuyLevel:
				BuyLevel(t, left);
				return true;
			default:
			{
				SeasonQuestDefinition quest = QuestForTarget(t);
				if (quest == null)
				{
					return false;
				}
				ClaimQuest(quest, Center(t.rect), left);
				return true;
			}
			}
		}

		private void ClaimQuest(SeasonQuestDefinition quest, Vector3 at, bool left)
		{
			Haptic(left, SentHapticAmplitude, SentHapticSeconds);
			SeasonPassServer.ClaimQuest(quest, delegate(bool ok, string message)
			{
				if (!(this == null))
				{
					if (ok)
					{
						Celebrate(at, left);
						if (!string.IsNullOrEmpty(message))
						{
							HandNotifications.Show(NotificationKind.Info, "Season Pass", message);
						}
					}
					else
					{
						FailHaptic(left);
						if (!string.IsNullOrEmpty(message))
						{
							HandNotifications.Show(NotificationKind.Error, "Season Pass", message);
						}
					}
					_dirty = true;
				}
			});
			_dirty = true;
		}

		private void ClaimReward(TouchTarget t, bool left)
		{
			int level = LevelForSlot(t.slot);
			SeasonPassReward reward = _service.Season.GetLevel(level)?.reward;
			Vector3 at = Center(t.rect);
			Haptic(left, SentHapticAmplitude, SentHapticSeconds);
			SeasonPassServer.Claim(level, delegate(bool ok, string message)
			{
				if (!(this == null))
				{
					if (ok)
					{
						Celebrate(at, left);
						HandNotifications.Show(NotificationKind.Reward, "Season Pass", message ?? (((reward != null) ? reward.ResolveDisplayName() : "Reward") + " claimed."));
					}
					else
					{
						FailHaptic(left);
						if (!string.IsNullOrEmpty(message))
						{
							HandNotifications.Show(NotificationKind.Error, "Season Pass", message);
						}
					}
					_dirty = true;
				}
			});
			_dirty = true;
		}

		private void BuyLevel(TouchTarget t, bool left)
		{
			Haptic(left, SentHapticAmplitude, SentHapticSeconds);
			SeasonPassLevelShop.BuyOne(delegate(bool ok, string error)
			{
				if (!(this == null))
				{
					if (ok)
					{
						Play(purchaseClip, 1f);
						EmitBurst(t.rect.position);
						SuccessHaptic(left);
					}
					else
					{
						FailHaptic(left);
						if (!string.IsNullOrEmpty(error))
						{
							HandNotifications.Show(NotificationKind.Error, "Season Pass", error);
						}
					}
					_dirty = true;
				}
			});
			_dirty = true;
		}

		private Vector3 Center(RectTransform rect)
		{
			rect.GetWorldCorners(_corners);
			return (_corners[0] + _corners[2]) * 0.5f;
		}

		private int LevelForSlot(int slot)
		{
			return ColumnCount * _passPage + slot / 2 + 1;
		}

		private SeasonQuestDefinition QuestForTarget(TouchTarget t)
		{
			if (t.kind == TargetKind.DailyClaim)
			{
				IReadOnlyList<SeasonQuestDefinition> daily = _service.DailyQuests;
				if (t.slot >= daily.Count)
				{
					return null;
				}
				return daily[t.slot];
			}
			IReadOnlyList<SeasonQuestDefinition> challenges = _service.Challenges;
			int index = _challengePage * challengeRows.Length + t.slot;
			if (index >= challenges.Count)
			{
				return null;
			}
			return challenges[index];
		}

		private void Punch(TouchTarget t, float scale)
		{
			t.punch = PunchSeconds;
			t.punchScale = scale;
		}

		private void AnimateTargets(float dt)
		{
			for (int i = 0; i < _targets.Count; i++)
			{
				TouchTarget t = _targets[i];
				if (t.holding || t.punch > 0f || t.fill > 0f)
				{
					if (!t.holding)
					{
						t.fill = Mathf.MoveTowards(t.fill, 0f, dt * FillDecayPerSecond);
					}
					if (t.punch > 0f)
					{
						t.punch = Mathf.Max(0f, t.punch - dt);
					}
					ApplyTargetVisuals(t);
				}
			}
		}

		private void ApplyTargetVisuals(TouchTarget t)
		{
			if (t.rect == null)
			{
				return;
			}
			float k = t.punch / PunchSeconds;
			t.rect.localScale = Vector3.one * (1f + k * (k * t.punchScale));
			Image fill = FillImage(t);
			if (!(fill == null))
			{
				if (fill.enabled != t.fill > 0.001f)
				{
					fill.enabled = t.fill > 0.001f;
				}
				if (t.fill > 0.001f)
				{
					fill.fillAmount = t.fill;
				}
			}
		}

		private Image FillImage(TouchTarget t)
		{
			switch (t.kind)
			{
			case TargetKind.Card:
			{
				int column = t.slot / 2;
				SeasonPassColumnView view = ((column < columns.Length) ? columns[column] : null);
				SeasonPassCardView card = ((view == null) ? null : ((t.slot % 2 == 0) ? view.freeCard : view.premiumCard));
				return card?.fill;
			}
			case TargetKind.DailyClaim:
				return ((t.slot < dailyRows.Length) ? dailyRows[t.slot] : null)?.claimFill;
			case TargetKind.ChallengeClaim:
				return ((t.slot < challengeRows.Length) ? challengeRows[t.slot] : null)?.claimFill;
			case TargetKind.BuyLevel:
				return buyLevelFill;
			default:
				return null;
			}
		}

		private void ResolveTips()
		{
			Player owner = Player.Instance;
			bool missing = _fingers[0].tip == null || _fingers[1].tip == null;
			if (owner == _tipOwner && (!missing || Time.unscaledTime < _nextTipSearch))
			{
				return;
			}
			_tipOwner = owner;
			_nextTipSearch = Time.unscaledTime + 1f;
			_fingers[0].tip = null;
			_fingers[1].tip = null;
			if (owner == null)
			{
				return;
			}
			owner.GetComponentsInChildren(includeInactive: true, _tipScratch);
			for (int i = 0; i < _tipScratch.Count; i++)
			{
				Transform tip = _tipScratch[i];
				if (tip.CompareTag("HandTag"))
				{
					bool left = tip.name.Contains("L_end") || tip.name.Contains("LeftFinger");
					_fingers[(!left) ? 1 : 0].tip = tip;
				}
			}
			_tipScratch.Clear();
		}

		// The third finger is the desktop simulator's mouse: set while a click is held on this board
		private static readonly List<SeasonPassBoard> Boards = new List<SeasonPassBoard>();

		private Vector3? _desktopPointer;

		// Aims the mouse ray at the boards; the nearest one it hits on a live target is pressed. Returns the hit distance.
		public static bool DesktopPress(Ray ray, float maxDistance, out float distance)
		{
			DesktopRelease();
			distance = maxDistance;
			SeasonPassBoard best = null;
			Vector3 bestPoint = default(Vector3);
			foreach (SeasonPassBoard board in Boards)
			{
				if (board == null || board.passUI == null || !board.isActiveAndEnabled || !board.passUI.gameObject.activeInHierarchy)
				{
					continue;
				}
				Plane plane = new Plane(board.passUI.forward, board.passUI.position);
				if (!plane.Raycast(ray, out var enter) || enter > distance)
				{
					continue;
				}
				board.EnsureTargets();
				Vector3 local = board.passUI.InverseTransformPoint(ray.GetPoint(enter));
				local.z = 0f;
				if (board.FindTarget(local) != null)
				{
					best = board;
					distance = enter;
					bestPoint = board.passUI.TransformPoint(local);
				}
			}
			if (best == null)
			{
				return false;
			}
			best._desktopPointer = bestPoint;
			return true;
		}

		public static void DesktopRelease()
		{
			foreach (SeasonPassBoard board in Boards)
			{
				if (board != null)
				{
					board._desktopPointer = null;
				}
			}
		}

		private bool TryFingerPosition(int index, out Vector3 world)
		{
			if (index == 2 && _desktopPointer.HasValue)
			{
				world = _desktopPointer.Value;
				return true;
			}
			if (index <= 1)
			{
				Transform tip = _fingers[index].tip;
				if (tip != null && tip.gameObject.activeInHierarchy)
				{
					world = tip.position;
					return true;
				}
			}
			world = default(Vector3);
			return false;
		}

		private static void Haptic(bool left, float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				if (left)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		private void OnEnable()
		{
			if (!Boards.Contains(this))
			{
				Boards.Add(this);
			}
			_service = SeasonPassService.Instance;
			if (_service != null)
			{
				_service.Changed += MarkDirty;
				SeasonPassPremium.StateChanged += MarkDirty;
				SeasonPassClock.SyncedChanged += MarkDirty;
				SeasonPassLevelShop.StateChanged += MarkDirty;
				SeasonPassServer.StateChanged += MarkDirty;
				if (!_selectionChosen)
				{
					_selectionChosen = true;
					int level = _service.FirstClaimableLevel();
					Select((level != 0) ? level : _service.Level, movePage: true);
				}
				_xpSnapped = false;
				_countdown = null;
				_dailyCountdown = null;
				_walletShown = int.MinValue;
				ReleaseAllFingers();
				_dirty = true;
			}
		}

		private void OnDisable()
		{
			Boards.Remove(this);
			_desktopPointer = null;
			if (_service != null)
			{
				_service.Changed -= MarkDirty;
			}
			SeasonPassPremium.StateChanged -= MarkDirty;
			SeasonPassClock.SyncedChanged -= MarkDirty;
			SeasonPassLevelShop.StateChanged -= MarkDirty;
			SeasonPassServer.StateChanged -= MarkDirty;
			ReleaseAllFingers();
			_hapticEchoAt = -1f;
		}

		private void MarkDirty()
		{
			_dirty = true;
		}

		private static bool IsHidden(SeasonClaimBlock block)
		{
			if (block != SeasonClaimBlock.ComingSoon)
			{
				return block == SeasonClaimBlock.LockedUntilUpdate;
			}
			return true;
		}

		private void Update()
		{
			UpdateHaptics();
			if (_service != null && !(passUI == null) && passUI.gameObject.activeInHierarchy)
			{
				float dt = Time.unscaledDeltaTime;
				if (_dirty)
				{
					_dirty = false;
					Render();
				}
				UpdateTouch(dt);
				AnimateXp(dt);
				AnimateLevelPop(dt);
				if (Time.unscaledTime >= _nextClockRefresh)
				{
					_nextClockRefresh = Time.unscaledTime + 1f;
					RefreshClocks();
				}
			}
		}

		private void Render()
		{
			Tab tab = _tab;
			if (passPage != null && passPage.activeSelf != (tab == Tab.Pass))
			{
				passPage.SetActive(tab == Tab.Pass);
			}
			if (questsPage != null && questsPage.activeSelf != (tab != Tab.Pass))
			{
				questsPage.SetActive(tab != Tab.Pass);
			}
			_renderedPhase = _service.Phase;
			RenderTabs();
			RenderHeader();
			if (tab == Tab.Pass)
			{
				RenderPass();
			}
			else
			{
				RenderQuests();
			}
			RenderFooter();
			RefreshClocks();
			LayoutTargets();
		}

		private void RenderTabs()
		{
			StyleTab(passTab, _tab == Tab.Pass, _service.ClaimableRewardCount > 0);
			StyleTab(questsTab, _tab == Tab.Quests, _service.ClaimableQuestCount > 0);
		}

		private static void StyleTab(SeasonPassButtonView tab, bool active, bool alert)
		{
			if (tab.background != null)
			{
				tab.background.color = (active ? SeasonPassPalette.HeaderCurrent : SeasonPassPalette.Panel);
			}
			if (tab.frame != null)
			{
				tab.frame.color = (active ? SeasonPassPalette.HeaderCurrent : SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, 0.55f));
			}
			if (tab.label != null)
			{
				tab.label.color = (active ? SeasonPassPalette.Dark : SeasonPassPalette.Lavender);
			}
			if (tab.dot != null)
			{
				tab.dot.enabled = alert;
			}
		}

		private void RenderHeader()
		{
			if (levelLabel != null)
			{
				levelLabel.text = "LEVEL";
			}
			if (seasonText != null)
			{
				seasonText.text = (_service.IsPreview ? (_service.Season.displayName + " PREVIEW") : _service.Season.displayName);
			}
			if (bigLevelText != null)
			{
				bigLevelText.text = Num(_service.Level);
			}
			if (premiumTrackLock != null && premiumTrackLock.activeSelf != !_service.HasPremium)
			{
				premiumTrackLock.SetActive(!_service.HasPremium);
			}
			bool isMaxLevel = _service.IsMaxLevel;
			if (xpText != null)
			{
				xpText.text = (isMaxLevel ? MaxLabel : string.Format("{0} <color=#A899D1>/ {1} XP</color>", _service.XpIntoLevel, _service.XpForNextLevel));
			}
			if (nextLevelIcon != null && nextLevelIcon.activeSelf != !isMaxLevel)
			{
				nextLevelIcon.SetActive(!isMaxLevel);
			}
			if (nextLevelText != null)
			{
				if (nextLevelText.gameObject.activeSelf != !isMaxLevel)
				{
					nextLevelText.gameObject.SetActive(!isMaxLevel);
				}
				if (!isMaxLevel)
				{
					nextLevelText.text = Num(_service.Level + 1);
				}
			}
			if (!_xpSnapped)
			{
				SnapXp();
			}
		}

		private void RenderPass()
		{
			SeasonPassSeason season = _service.Season;
			int current = _service.Level;
			int first = ColumnCount * _passPage + 1;
			for (int i = 0; i < columns.Length; i++)
			{
				SeasonPassColumnView column = columns[i];
				if (column == null || column.root == null)
				{
					continue;
				}
				int level = first + i;
				SeasonPassLevel entry = season.GetLevel(level);
				bool hasReward = entry != null && entry.reward != null;
				if (column.root.gameObject.activeSelf != hasReward)
				{
					column.root.gameObject.SetActive(hasReward);
				}
				if (!hasReward)
				{
					continue;
				}
				bool isCurrent = level == current;
				if (column.header != null)
				{
					column.header.color = (isCurrent ? SeasonPassPalette.HeaderCurrent : SeasonPassPalette.Panel);
				}
				if (column.number != null)
				{
					column.number.text = Num(level);
					column.number.color = (isCurrent ? SeasonPassPalette.Dark : ((level > current) ? SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, 0.45f) : SeasonPassPalette.Lavender));
				}
				if (column.freeCell != null)
				{
					column.freeCell.color = (isCurrent ? SeasonPassPalette.CellFreeCurrent : SeasonPassPalette.CellFree);
				}
				if (column.premiumCell != null)
				{
					column.premiumCell.color = (isCurrent ? SeasonPassPalette.CellPremiumCurrent : SeasonPassPalette.CellPremium);
				}
				bool free = entry.track == SeasonTrack.Free;
				Vector2 size = (free ? FreeCardSize : (entry.reward.featured ? FeaturedCardSize : PremiumCardSize));
				BindCard(column.freeCard, free ? level : 0, entry, size);
				BindCard(column.premiumCard, (!free) ? level : 0, entry, size);
				bool selected = level == _selectedLevel;
				if (column.freeSelect != null)
				{
					column.freeSelect.enabled = free && selected;
				}
				if (column.premiumSelect != null)
				{
					column.premiumSelect.enabled = selected && !free;
				}
			}
		}

		private void BindCard(SeasonPassCardView card, int level, SeasonPassLevel entry, Vector2 size)
		{
			if (card == null || card.root == null)
			{
				return;
			}
			if (card.root.gameObject.activeSelf != level > 0)
			{
				card.root.gameObject.SetActive(level > 0);
			}
			if (level < 1)
			{
				return;
			}
			SeasonPassReward reward = entry.reward;
			SeasonClaimBlock block = _service.GetClaimBlock(level);
			int current = _service.Level;
			bool hidden = IsHidden(block);
			bool glyph = hidden || reward.IsGlyph;
			float dim = ((block == SeasonClaimBlock.Claimed) ? 0.42f : (hidden ? 0.62f : ((current < level) ? 0.5f : 1f)));
			card.root.sizeDelta = size;
			if (card.tile != null)
			{
				card.tile.color = SeasonPassPalette.Shade(SeasonPassPalette.Tile(reward.rarity), dim);
			}
			if (card.rarityBar != null)
			{
				card.rarityBar.color = SeasonPassPalette.Shade(SeasonPassPalette.Bar(reward.rarity), Mathf.Max(dim, 0.6f));
			}
			if (card.icon != null)
			{
				if (glyph)
				{
					card.icon.enabled = false;
				}
				else
				{
					bool hasIcon = reward.icon != null;
					card.icon.enabled = hasIcon;
					if (hasIcon)
					{
						card.icon.sprite = reward.icon;
						card.icon.preserveAspect = true;
						float side = Mathf.Min(size.x, size.y) * 0.9f;
						card.icon.rectTransform.sizeDelta = (reward.featured ? new Vector2(size.x * 0.96f, size.y * 0.92f) : new Vector2(side, side));
						card.icon.color = new Color(1f, 1f, 1f, (block == SeasonClaimBlock.Claimed) ? 0.5f : ((current < level) ? 0.62f : 1f));
					}
				}
			}
			if (card.glyph != null)
			{
				if (card.glyph.gameObject.activeSelf != glyph)
				{
					card.glyph.gameObject.SetActive(glyph);
				}
				if (glyph)
				{
					card.glyph.text = (hidden ? "???" : reward.Glyph);
					card.glyph.fontSize = ((hidden && reward.featured) ? 26f : 12f);
					card.glyph.color = new Color(1f, 1f, 1f, (block == SeasonClaimBlock.Claimed) ? 0.5f : (hidden ? 0.7f : 0.92f));
				}
			}
			if (card.amount != null)
			{
				bool showAmount = glyph && !hidden;
				if (card.amount.gameObject.activeSelf != showAmount)
				{
					card.amount.gameObject.SetActive(showAmount);
				}
				if (showAmount)
				{
					card.amount.text = reward.amount.ToString();
				}
			}
			if (card.frame != null)
			{
				card.frame.sprite = ((reward.featured && featuredFrameSprite != null) ? featuredFrameSprite : frameSprite);
				card.frame.color = (reward.featured ? SeasonPassPalette.Gold : new Color(0.8f, 0.6f, 1f, 0.9f));
			}
			if (card.pulse != null)
			{
				card.pulse.enabled = block == SeasonClaimBlock.None;
			}
			if (card.check != null)
			{
				card.check.enabled = block == SeasonClaimBlock.Claimed;
			}
			bool locked = block != SeasonClaimBlock.Claimed && (block == SeasonClaimBlock.NeedsPremium || current < level || hidden || block == SeasonClaimBlock.SeasonClosed || block == SeasonClaimBlock.PreviewOnly);
			if (card.lockTab != null)
			{
				card.lockTab.enabled = locked;
				card.lockTab.color = ((block == SeasonClaimBlock.NeedsPremium) ? SeasonPassPalette.Gold : SeasonPassPalette.WithAlpha(SeasonPassPalette.Dark, 0.92f));
			}
			if (card.lockIcon != null)
			{
				card.lockIcon.enabled = locked;
				card.lockIcon.color = ((block == SeasonClaimBlock.NeedsPremium) ? SeasonPassPalette.Dark : SeasonPassPalette.Ink);
			}
		}

		private void RenderQuests()
		{
			IReadOnlyList<SeasonQuestDefinition> daily = _service.DailyQuests;
			for (int i = 0; i < dailyRows.Length; i++)
			{
				BindQuestRow(dailyRows[i], (i < daily.Count) ? daily[i] : null);
			}
			IReadOnlyList<SeasonQuestDefinition> challenges = _service.Challenges;
			int start = _challengePage * challengeRows.Length;
			for (int j = 0; j < challengeRows.Length; j++)
			{
				int index = start + j;
				BindQuestRow(challengeRows[j], (index < challenges.Count) ? challenges[index] : null);
			}
			if (challengeCount != null)
			{
				challengeCount.text = string.Format("{0} <color=#A899D1>/ {1} DONE</color>", _service.CompletedChallengeCount, challenges.Count);
			}
		}

		private void BindQuestRow(SeasonQuestRowView row, SeasonQuestDefinition quest)
		{
			if (row == null || row.root == null)
			{
				return;
			}
			bool show = quest != null;
			if (row.root.gameObject.activeSelf != show)
			{
				row.root.gameObject.SetActive(show);
			}
			if (!show)
			{
				return;
			}
			SeasonQuestProgress state = _service.GetProgress(quest);
			int progress = (state != null) ? state.progress : 0;
			bool claimed = state != null && state.claimed;
			bool complete = progress >= quest.target;
			bool canClaim = _service.CanClaimQuest(quest);
			if (row.panel != null)
			{
				row.panel.color = SeasonPassPalette.WithAlpha(SeasonPassPalette.Dark, claimed ? 0.55f : 0.88f);
			}
			if (row.title != null)
			{
				row.title.text = quest.title;
				row.title.color = (claimed ? SeasonPassPalette.WithAlpha(SeasonPassPalette.Ink, 0.5f) : SeasonPassPalette.Ink);
			}
			if (row.description != null)
			{
				row.description.text = quest.description;
			}
			if (row.reward != null)
			{
				row.reward.text = string.Format("+{0} XP", quest.xpReward);
				row.reward.color = (claimed ? SeasonPassPalette.WithAlpha(SeasonPassPalette.Gold, 0.45f) : SeasonPassPalette.Gold);
			}
			if (row.barFill != null)
			{
				row.barFill.fillAmount = ((quest.target > 0) ? Mathf.Clamp01((float)progress / (float)quest.target) : 0f);
				row.barFill.color = (complete ? SeasonPassPalette.Gold : SeasonPassPalette.Lavender);
			}
			if (row.progress != null)
			{
				row.progress.text = quest.ProgressLabel(progress);
			}
			if (row.claimBack != null)
			{
				row.claimBack.color = (canClaim ? SeasonPassPalette.GoldDeep : SeasonPassPalette.Panel);
			}
			if (row.claimFrame != null)
			{
				row.claimFrame.color = (canClaim ? SeasonPassPalette.Gold : SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, claimed ? 0.25f : 0.5f));
			}
			if (row.claimPulse != null)
			{
				row.claimPulse.enabled = canClaim;
			}
			if (row.claimCheck != null)
			{
				row.claimCheck.enabled = claimed;
			}
			if (row.claimLabel != null)
			{
				if (row.claimLabel.gameObject.activeSelf != !claimed)
				{
					row.claimLabel.gameObject.SetActive(!claimed);
				}
				row.claimLabel.text = ((SeasonPassServer.ClaimingQuest == quest.questId) ? "..." : "CLAIM");
				row.claimLabel.color = (canClaim ? SeasonPassPalette.Gold : SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, 0.35f));
			}
		}

		private void RenderFooter()
		{
			Tab tab = _tab;
			RenderPurchase();
			RenderBuyLevel();
			if (details != null && details.activeSelf != (tab == Tab.Pass))
			{
				details.SetActive(tab == Tab.Pass);
			}
			if (questsHint != null && questsHint.gameObject.activeSelf != (tab != Tab.Pass))
			{
				questsHint.gameObject.SetActive(tab != Tab.Pass);
			}
			int page;
			int pages;
			if (tab == Tab.Pass)
			{
				RenderDetails();
				page = _passPage;
				pages = PassPageCount;
			}
			else
			{
				page = _challengePage;
				pages = ChallengePageCount;
			}
			if (pageLabel != null)
			{
				pageLabel.text = string.Format("PAGE {0} <color=#9F94BE>/ {1}</color>", page + 1, pages);
			}
			StylePager(prevButton, page > 0);
			StylePager(nextButton, page < pages - 1);
		}

		private static void StylePager(SeasonPassButtonView button, bool usable)
		{
			if (button != null)
			{
				if (button.icon != null)
				{
					button.icon.color = SeasonPassPalette.WithAlpha(SeasonPassPalette.Ink, usable ? 1f : 0.25f);
				}
				if (button.frame != null)
				{
					button.frame.color = SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, usable ? 0.6f : 0.2f);
				}
			}
		}

		private void RenderPurchase()
		{
			bool premium = _service.HasPremium;
			bool opening = SeasonPassPremium.CheckoutOpen;
			bool soon = !premium && _service.PremiumSaleLocked;
			string price = ((premium || opening || soon) ? null : SeasonPassPremium.Price);
			bool noPrice = string.IsNullOrEmpty(price);
			if (purchaseButton.label != null)
			{
				purchaseButton.label.text = (premium ? "PREMIUM ACTIVE" : (opening ? "OPENING STORE" : (soon ? "COMING SOON" : "UNLOCK PREMIUM")));
				purchaseButton.label.color = (premium ? SeasonPassPalette.Gold : SeasonPassPalette.Ink);
				Vector2 anchoredPosition = purchaseButton.label.rectTransform.anchoredPosition;
				purchaseButton.label.rectTransform.anchoredPosition = new Vector2(anchoredPosition.x, noPrice ? 0f : 2.1f);
			}
			if (purchasePrice != null)
			{
				if (purchasePrice.gameObject.activeSelf != !noPrice)
				{
					purchasePrice.gameObject.SetActive(!noPrice);
				}
				if (!noPrice)
				{
					purchasePrice.text = price;
				}
			}
			if (purchaseButton.background != null)
			{
				purchaseButton.background.color = (premium ? SeasonPassPalette.WithAlpha(SeasonPassPalette.GoldDeep, 0.85f) : new Color(0.043f, 0.016f, 0.078f, 1f));
			}
			if (purchaseButton.frame != null)
			{
				purchaseButton.frame.color = SeasonPassPalette.WithAlpha(SeasonPassPalette.Gold, premium ? 0.5f : 0.9f);
			}
		}

		private void RenderBuyLevel()
		{
			if (buyLevelButton.root == null)
			{
				return;
			}
			LevelBuyState state = SeasonPassLevelShop.State;
			bool showPrice = state != LevelBuyState.Busy && state != LevelBuyState.MaxLevel;
			if (buyLevelButton.label != null)
			{
				buyLevelButton.label.text = state switch
				{
					LevelBuyState.Busy => "BUYING...",
					LevelBuyState.MaxLevel => MaxLabel,
					_ => "+1 LEVEL",
				};
				buyLevelButton.label.color = ((state == LevelBuyState.Ready) ? SeasonPassPalette.Ink : SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, 0.6f));
				Vector2 anchoredPosition = buyLevelButton.label.rectTransform.anchoredPosition;
				buyLevelButton.label.rectTransform.anchoredPosition = new Vector2(anchoredPosition.x, showPrice ? 2.1f : 0f);
			}
			if (buyLevelPrice != null)
			{
				if (buyLevelPrice.gameObject.activeSelf != showPrice)
				{
					buyLevelPrice.gameObject.SetActive(showPrice);
				}
				int price = SeasonPassLevelShop.Price;
				buyLevelPrice.text = ((price > 0) ? (SeasonPassLevelShop.Format(price) + " GD") : "-- GD");
				buyLevelPrice.color = ((state == LevelBuyState.NotEnoughGold) ? SeasonPassPalette.Short : ((state == LevelBuyState.Ready) ? SeasonPassPalette.Gold : SeasonPassPalette.WithAlpha(SeasonPassPalette.Gold, 0.45f)));
			}
			if (buyLevelButton.background != null)
			{
				buyLevelButton.background.color = ((state == LevelBuyState.Ready) ? new Color(0.043f, 0.016f, 0.078f, 1f) : SeasonPassPalette.Panel);
			}
			if (buyLevelButton.frame != null)
			{
				buyLevelButton.frame.color = ((state == LevelBuyState.Ready) ? SeasonPassPalette.WithAlpha(SeasonPassPalette.Gold, 0.9f) : SeasonPassPalette.WithAlpha(SeasonPassPalette.Lavender, 0.35f));
			}
		}

		private void RefreshWallet()
		{
			if (!(walletText == null))
			{
				int shown = (SeasonPassLevelShop.HasBalance ? SeasonPassLevelShop.Balance : (-1));
				if (shown != _walletShown)
				{
					_walletShown = shown;
					walletText.text = ((shown >= 0) ? (SeasonPassLevelShop.Format(shown) + " <color=#A899D1>GD</color>") : "-- <color=#A899D1>GD</color>");
					_dirty = true;
				}
			}
		}

		private void RenderDetails()
		{
			SeasonPassLevel entry = _service.Season.GetLevel(_selectedLevel);
			if (entry == null || entry.reward == null)
			{
				if (details != null)
				{
					details.SetActive(false);
				}
				return;
			}
			SeasonPassReward reward = entry.reward;
			SeasonClaimBlock block = _service.GetClaimBlock(_selectedLevel);
			bool hidden = IsHidden(block);
			bool glyph = hidden || reward.IsGlyph;
			if (detailsIcon != null)
			{
				detailsIcon.enabled = !glyph && reward.icon != null;
				detailsIcon.sprite = reward.icon;
				detailsIcon.preserveAspect = true;
			}
			if (detailsGlyph != null)
			{
				if (detailsGlyph.gameObject.activeSelf != glyph)
				{
					detailsGlyph.gameObject.SetActive(glyph);
				}
				if (glyph)
				{
					detailsGlyph.text = (hidden ? "???" : reward.Glyph);
				}
			}
			if (detailsName != null)
			{
				detailsName.text = (hidden ? "???" : reward.ResolveDisplayName());
			}
			if (detailsInfo != null)
			{
				if (hidden)
				{
					detailsInfo.text = string.Format("LEVEL {0} / {1}", _selectedLevel, SeasonPassText.Track(entry.track));
				}
				else if (glyph)
				{
					detailsInfo.text = string.Format("LEVEL {0} / {1} / {2}", _selectedLevel, SeasonPassText.Track(entry.track), reward.KindLabel);
				}
				else
				{
					detailsInfo.text = string.Format("LEVEL {0} / {1} / {2} {3}", _selectedLevel, SeasonPassText.Track(entry.track), SeasonPassText.Rarity(reward.rarity), reward.KindLabel);
				}
			}
			if (detailsStatus != null)
			{
				detailsStatus.text = ((SeasonPassServer.Busy && SeasonPassServer.ClaimingLevel == _selectedLevel) ? "<color=#FFD14C>CLAIMING…</color>" : StatusText(block, _selectedLevel));
			}
		}

		private static string StatusText(SeasonClaimBlock block, int level)
		{
			return block switch
			{
				SeasonClaimBlock.None => "<color=#FFD14C>HOLD TO CLAIM</color>",
				SeasonClaimBlock.NotReached => string.Format("REACH LEVEL {0}", level),
				SeasonClaimBlock.NeedsPremium => "<color=#FFD14C>PREMIUM REQUIRED</color>",
				SeasonClaimBlock.Claimed => "<color=#6BE38F>CLAIMED</color>",
				SeasonClaimBlock.SeasonClosed => "SEASON NOT LIVE",
				SeasonClaimBlock.ComingSoon => "<color=#A899D1>ARRIVES IN AN UPDATE</color>",
				SeasonClaimBlock.PreviewOnly => "<color=#A899D1>CLAIMS OPEN AT LAUNCH</color>",
				SeasonClaimBlock.LockedUntilUpdate => "<color=#A899D1>UNLOCKS IN AN UPDATE</color>",
				_ => string.Empty,
			};
		}

		private void RefreshClocks()
		{
			if (_service.Phase != _renderedPhase)
			{
				_dirty = true;
			}
			RefreshWallet();
			string countdown = BuildCountdown();
			if (countdown != _countdown)
			{
				_countdown = countdown;
				if (countdownText != null)
				{
					countdownText.text = countdown;
				}
			}
			if (_tab == Tab.Quests && !(dailyReset == null))
			{
				string daily = "NEW IN " + SeasonPassText.Countdown(SeasonPassClock.NextDailyResetUtc - SeasonPassClock.UtcNow);
				if (!(daily == _dailyCountdown))
				{
					_dailyCountdown = daily;
					dailyReset.text = daily;
				}
			}
		}

		private string BuildCountdown()
		{
			if (_service.ReleaseLocked)
			{
				return "STARTING SOON";
			}
			DateTime utcNow = SeasonPassClock.UtcNow;
			return _service.Phase switch
			{
				SeasonPassPhase.Ended => "SEASON ENDED",
				SeasonPassPhase.Upcoming => "STARTS IN " + SeasonPassText.Countdown(_service.Season.StartUtc - utcNow),
				_ => "ENDS IN " + SeasonPassText.Countdown(_service.Season.EndUtc - utcNow),
			};
		}

		private void SnapXp()
		{
			_xpSnapped = true;
			_shownLevel = _service.Level;
			_shownProgress = _service.LevelProgress;
			if (levelValue != null)
			{
				levelValue.text = Num(_shownLevel);
			}
			ApplySegments(_shownProgress);
		}

		private void AnimateXp(float dt)
		{
			int level = _service.Level;
			if (!_xpSnapped || _shownLevel > level)
			{
				SnapXp();
				return;
			}
			float target = ((_shownLevel < level) ? 1f : _service.LevelProgress);
			if (_shownLevel == level && Mathf.Approximately(_shownProgress, target))
			{
				return;
			}
			_shownProgress = Mathf.MoveTowards(_shownProgress, target, dt * 1.6f);
			if (_shownLevel < level && _shownProgress >= 1f)
			{
				_shownLevel++;
				_shownProgress = 0f;
				_levelPop = 0.35f;
				if (levelValue != null)
				{
					levelValue.text = Num(_shownLevel);
				}
			}
			ApplySegments(_shownProgress);
		}

		private void ApplySegments(float progress)
		{
			int count = xpSegments.Length;
			float filled = progress * (float)count;
			for (int i = 0; i < count; i++)
			{
				if (xpSegments[i] != null)
				{
					xpSegments[i].fillAmount = Mathf.Clamp01(filled - (float)i);
				}
			}
		}

		private void AnimateLevelPop(float dt)
		{
			if (!(_levelPop <= 0f) && !(levelBox == null))
			{
				_levelPop = Mathf.Max(0f, _levelPop - dt);
				float t = _levelPop / 0.35f;
				levelBox.localScale = Vector3.one * (1f + t * t * 0.18f);
			}
		}

		private void SetTab(Tab tab)
		{
			if (_tab != tab)
			{
				_tab = tab;
				_dailyCountdown = null;
				_dirty = true;
			}
		}

		private void TurnPage(int delta)
		{
			if (_tab == Tab.Pass)
			{
				int page = Mathf.Clamp(_passPage + delta, 0, PassPageCount - 1);
				if (page == _passPage)
				{
					return;
				}
				_passPage = page;
				_selectedLevel = Mathf.Min(_passPage * ColumnCount + 1, _service.Season.MaxLevel);
			}
			else
			{
				int page2 = Mathf.Clamp(_challengePage + delta, 0, ChallengePageCount - 1);
				if (page2 == _challengePage)
				{
					return;
				}
				_challengePage = page2;
			}
			_dirty = true;
		}

		private void Select(int level, bool movePage)
		{
			_selectedLevel = Mathf.Clamp(level, 1, _service.Season.MaxLevel);
			if (movePage)
			{
				_passPage = (_selectedLevel - 1) / ColumnCount;
			}
			_dirty = true;
		}

		private void Purchase(bool left)
		{
			if (_service.HasPremium || SeasonPassPremium.CheckoutOpen)
			{
				return;
			}
			SeasonPassPremium.Purchase(delegate(bool ok, string error)
			{
				if (ok)
				{
					HandNotifications.Show(NotificationKind.Reward, "PREMIUM UNLOCKED", _service.Season.displayName + " premium rewards are open.");
					if (this != null)
					{
						Play(purchaseClip, 1f);
						if (purchaseButton.root != null)
						{
							EmitBurst(purchaseButton.root.position);
						}
						SuccessHaptic(left);
					}
				}
				else if (!string.IsNullOrEmpty(error))
				{
					HandNotifications.Show(NotificationKind.Error, "STORE", error);
					FailHaptic(left);
				}
				if (this != null)
				{
					_dirty = true;
				}
			});
			_dirty = true;
		}

		private void Play(AudioClip clip, float volume)
		{
			if (sfx != null && clip != null)
			{
				sfx.PlayOneShot(clip, volume);
			}
		}

		private void EmitBurst(Vector3 world)
		{
			if (!(burst == null) && burstCount > 0)
			{
				burst.transform.position = world - passUI.forward * 0.03f;
				burst.Emit(burstCount);
			}
		}

		private void Celebrate(Vector3 world, bool left)
		{
			SuccessHaptic(left);
			if (!(claimVfx == null))
			{
				GameObject vfx = UnityEngine.Object.Instantiate(claimVfx, world - passUI.forward * claimVfxOffset, Quaternion.identity);
				UnityEngine.Object.Destroy(vfx, ClaimVfxSeconds());
			}
		}

		private float ClaimVfxSeconds()
		{
			if (_claimVfxSeconds > 0f)
			{
				return _claimVfxSeconds;
			}
			float seconds = 1f;
			ParticleSystem[] systems = claimVfx.GetComponentsInChildren<ParticleSystem>(true);
			foreach (ParticleSystem system in systems)
			{
				ParticleSystem.MainModule main = system.main;
				ParticleSystem.MinMaxCurve life = main.startLifetime;
				seconds = Mathf.Max(seconds, main.duration + Mathf.Max(life.constant, life.constantMax, life.curveMultiplier));
			}
			AudioSource[] sources = claimVfx.GetComponentsInChildren<AudioSource>(true);
			foreach (AudioSource source in sources)
			{
				if (source.clip != null)
				{
					seconds = Mathf.Max(seconds, source.clip.length / Mathf.Max(Mathf.Abs(source.pitch), 0.01f));
				}
			}
			_claimVfxSeconds = seconds + 0.25f;
			return _claimVfxSeconds;
		}

		private void SuccessHaptic(bool left)
		{
			Haptic(left, 0.75f, 0.07f);
			_hapticEchoLeft = left;
			_hapticEchoAt = Time.unscaledTime + 0.13f;
		}

		private static void FailHaptic(bool left)
		{
			Haptic(left, 0.3f, 0.18f);
		}

		private void UpdateHaptics()
		{
			if (!(_hapticEchoAt < 0f) && !(Time.unscaledTime < _hapticEchoAt))
			{
				_hapticEchoAt = -1f;
				Haptic(_hapticEchoLeft, 1f, 0.15f);
			}
		}

		private static string Num(int value)
		{
			if (value >= 0 && value < Numbers.Length)
			{
				return Numbers[value];
			}
			return value.ToString();
		}

		private static string[] BuildNumbers(int count)
		{
			string[] numbers = new string[count];
			for (int i = 0; i < count; i++)
			{
				numbers[i] = i.ToString();
			}
			return numbers;
		}
	}
}
