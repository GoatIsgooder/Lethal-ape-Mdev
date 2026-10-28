using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmLoadoutBox : MonoBehaviour
	{
		[Header("Rig")]
		[SerializeField]
		private GameObject boxRoot;

		[SerializeField]
		private Transform title;

		[SerializeField]
		private TMP_Text titleText;

		[SerializeField]
		private Transform titleCenterPoint;

		[SerializeField]
		private Transform titleHeaderPoint;

		[Tooltip("Page heading (\"SLOT 1:\"), like the Rivals \"PRIMARY:\".")]
		[SerializeField]
		private TMP_Text slotText;

		[SerializeField]
		private TMP_Text hintText;

		[SerializeField]
		private TMP_Text countdownText;

		[SerializeField]
		private RectTransform page;

		[SerializeField]
		private CanvasGroup pageGroup;

		[Tooltip("A tile's trigger cube (BtmLoadoutCard); its parent tile is what gets copied.")]
		[SerializeField]
		private BtmLoadoutCard cardTemplate;

		[Tooltip("Uniformly scaled parent for the spinning item previews (the tiles are squashed).")]
		[SerializeField]
		private Transform previewParent;

		[Header("Layout (page units, Rivals grid)")]
		[SerializeField]
		private Vector2 gridOrigin = new Vector2(-33f, -8f);

		[SerializeField]
		private Vector2 gridStep = new Vector2(22f, -21f);

		[SerializeField]
		[Min(1f)]
		private int gridColumns = 4;

		[Header("Timing")]
		[SerializeField]
		private float titleHold = 0.7f;

		[SerializeField]
		private float titleMove = 0.5f;

		[SerializeField]
		private float pageFade = 0.4f;

		[SerializeField]
		private float pickDebounce = 0.35f;

		[Header("Audio")]
		[SerializeField]
		private AudioClip openSurvivorClip;

		[SerializeField]
		private AudioClip openMonsterClip;

		[SerializeField]
		private AudioClip pageClip;

		[SerializeField]
		private AudioClip pickClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.7f;

		private readonly List<BtmLoadoutCard> _cards = new List<BtmLoadoutCard>(8);

		private readonly List<BtmItemDefinition> _options = new List<BtmItemDefinition>(8);

		private readonly List<BtmItemDefinition> _owned = new List<BtmItemDefinition>(8);

		private readonly List<BtmItemDefinition> _picked = new List<BtmItemDefinition>(3);

		private readonly List<TMP_Text> _cardTexts = new List<TMP_Text>(32);

		private readonly List<Collider> _cardColliders = new List<Collider>(8);

		private readonly List<TMP_Text> _textScratch = new List<TMP_Text>(8);

		private readonly List<Collider> _colliderScratch = new List<Collider>(4);

		private Coroutine _sequence;

		private BtmRole _role;

		private double _closeAt;

		private bool _open;

		private bool _pageLive;

		private BtmLoadoutCard _pending;

		private float _lastPickTime;

		private int _lastCountdown = -1;

		private AudioSource _voice;

		private Vector3 _pageBaseScale = Vector3.one;

		private Vector3 _titleBaseScale = Vector3.one;

		public static BtmLoadoutBox Instance { get; private set; }

		public bool IsOpen => _open;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
			if (page != null)
			{
				_pageBaseScale = page.localScale;
			}
			if (title != null)
			{
				_titleBaseScale = title.localScale;
			}
			if (cardTemplate != null && cardTemplate.Tile != null)
			{
				cardTemplate.Tile.gameObject.SetActive(false);
			}
			if (boxRoot != null)
			{
				boxRoot.SetActive(false);
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void Open(BtmRole role, double closeAt)
		{
			Close();
			_role = role;
			_closeAt = closeAt;
			_open = true;
			PlaceAtHead();
			if (boxRoot != null)
			{
				boxRoot.SetActive(true);
			}
			Play((role == BtmRole.Monster) ? openMonsterClip : openSurvivorClip);
			_sequence = StartCoroutine(Sequence());
		}

		public void Close()
		{
			if (_sequence != null)
			{
				StopCoroutine(_sequence);
				_sequence = null;
			}
			_open = false;
			_pageLive = false;
			_pending = null;
			_lastCountdown = -1;
			ClearCards();
			if (boxRoot != null)
			{
				boxRoot.SetActive(false);
			}
		}

		public void OnCardPressed(BtmLoadoutCard card, bool isLeft)
		{
			if (_pageLive && !(card == null) && !(card.Item == null) && !(Time.time - _lastPickTime < pickDebounce))
			{
				_lastPickTime = Time.time;
				_pending = card;
			}
		}

		private void Update()
		{
			if (_open && !(countdownText == null))
			{
				int num = Mathf.Max(0, Mathf.CeilToInt((float)(_closeAt - PhotonNetwork.Time)));
				if (num != _lastCountdown)
				{
					_lastCountdown = num;
					countdownText.text = num.ToString();
				}
			}
		}

		private IEnumerator Sequence()
		{
			SetText(titleText, (_role == BtmRole.Monster) ? "YOU ARE THE MONSTER" : "YOU ARE A SURVIVOR");
			SetText(slotText, "");
			SetText(hintText, "");
			SetPageVisible(0f);
			if (title != null && titleCenterPoint != null)
			{
				Snap(title, titleCenterPoint);
				yield return Fade(delegate(float t)
				{
					SetTitleVisible(t);
				}, 0f, 1f, 0.25f);
				yield return new WaitForSeconds(titleHold);
				if (titleHeaderPoint != null)
				{
					yield return MoveTitle(titleCenterPoint, titleHeaderPoint, titleMove);
				}
			}
			_owned.Clear();
			BtmTechTreeCatalog instance = BtmTechTreeCatalog.Instance;
			if (instance != null)
			{
				foreach (BtmItemDefinition item in instance.items)
				{
					if (item != null && item.IsEquipable && item.role == _role && BtmProgress.Owns(item))
					{
						_owned.Add(item);
					}
				}
			}
			if (_owned.Count == 0)
			{
				SetText(slotText, "NO GEAR YET");
				SetText(hintText, "Earn Salvage each round and unlock gear in the Tech Tree.");
				yield return Fade(SetPageVisible, 0f, 1f, pageFade);
				yield break;
			}
			_picked.Clear();
			int slots = BtmProgress.SlotCount(_role);
			int slot = 0;
			do
			{
				_options.Clear();
				foreach (BtmItemDefinition item2 in _owned)
				{
					if (!_picked.Contains(item2))
					{
						_options.Add(item2);
					}
				}
				if (_options.Count == 0)
				{
					break;
				}
				SetText(slotText, (slots > 1) ? string.Format("SLOT {0} OF {1}:", slot + 1, slots) : "YOUR GEAR:");
				SetText(hintText, "Tap one to take it into the round");
				BuildCards(_options, BtmProgress.GetLoadout(_role, slot));
				SetPageVisible(0f);
				Play(pageClip);
				yield return Fade(SetPageVisible, 0f, 1f, pageFade);
				_pending = null;
				_pageLive = true;
				while (_pending == null)
				{
					yield return null;
				}
				BtmLoadoutCard pending = _pending;
				_pageLive = false;
				_pending = null;
				BtmProgress.SetLoadout(_role, slot, pending.Item);
				_picked.Add(pending.Item);
				pending.SetChosen(true);
				Play(pickClip);
				yield return new WaitForSeconds(0.2f);
				yield return Fade(SetPageVisible, 1f, 0f, pageFade * 0.75f);
				slot++;
			}
			while (slot < slots);
			ClearCards();
			SetText(slotText, "READY");
			SetText(hintText, PickedSummary());
			yield return Fade(SetPageVisible, 0f, 1f, pageFade);
		}

		private string PickedSummary()
		{
			if (_picked.Count == 0)
			{
				return "";
			}
			StringBuilder stringBuilder = new StringBuilder("Your gear is on your chest when the doors open:\n");
			for (int i = 0; i < _picked.Count; i++)
			{
				if (i > 0)
				{
					stringBuilder.Append("   ");
				}
				stringBuilder.Append("<b>");
				stringBuilder.Append(_picked[i].displayName).Append("</b>");
			}
			return stringBuilder.ToString();
		}

		private void BuildCards(List<BtmItemDefinition> items, BtmItemDefinition current)
		{
			ClearCards();
			if (cardTemplate == null || cardTemplate.Tile == null || page == null)
			{
				return;
			}
			RectTransform tile = cardTemplate.Tile;
			for (int i = 0; i < items.Count; i++)
			{
				RectTransform rectTransform = UnityEngine.Object.Instantiate(tile, page);
				rectTransform.gameObject.SetActive(true);
				int row = i / gridColumns;
				int col = i % gridColumns;
				int inRow = Mathf.Min(gridColumns, items.Count - row * gridColumns);
				float x = (float)(gridColumns - inRow) * 0.5f + (float)col;
				rectTransform.anchoredPosition = gridOrigin + Vector2.Scale(gridStep, new Vector2(x, row));
				rectTransform.localPosition = new Vector3(rectTransform.localPosition.x, rectTransform.localPosition.y, tile.localPosition.z);
				BtmLoadoutCard componentInChildren = rectTransform.GetComponentInChildren<BtmLoadoutCard>(true);
				componentInChildren.Bind(this, items[i], items[i] == current, previewParent);
				_cards.Add(componentInChildren);
				rectTransform.GetComponentsInChildren(true, _textScratch);
				_cardTexts.AddRange(_textScratch);
				rectTransform.GetComponentsInChildren(true, _colliderScratch);
				_cardColliders.AddRange(_colliderScratch);
			}
		}

		private void ClearCards()
		{
			foreach (BtmLoadoutCard card in _cards)
			{
				if (card != null)
				{
					UnityEngine.Object.Destroy((card.Tile != null) ? card.Tile.gameObject : card.gameObject);
				}
			}
			_cards.Clear();
			_cardTexts.Clear();
			_cardColliders.Clear();
		}

		private void PlaceAtHead()
		{
			if (!GorillaLocomotion.Player.HasInstance)
			{
				return;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			Transform transform = ((Camera.main != null) ? Camera.main.transform : ((instance.headCollider != null) ? instance.headCollider.transform : instance.transform));
			Vector3 forward = transform.forward;
			if (forward.x * forward.x + forward.z * forward.z < 0.0001f)
			{
				forward = transform.up;
			}
			Quaternion rotation = Quaternion.LookRotation(new Vector3(forward.x, 0f, forward.z).normalized, Vector3.up);
			float num = Mathf.Max(instance.CurrentScale, 0.1f);
			base.transform.SetPositionAndRotation(transform.position, rotation);
			base.transform.localScale = Vector3.one * num;
		}

		private void SetPageVisible(float t)
		{
			if (page == null)
			{
				return;
			}
			if (page.gameObject.activeSelf != t > 0.001f)
			{
				page.gameObject.SetActive(t > 0.001f);
			}
			page.localScale = _pageBaseScale * Mathf.Lerp(0.92f, 1f, t);
			if (pageGroup != null)
			{
				pageGroup.alpha = t;
			}
			foreach (TMP_Text cardText in _cardTexts)
			{
				if (cardText != null)
				{
					cardText.alpha = t;
				}
			}
			foreach (Collider cardCollider in _cardColliders)
			{
				if (cardCollider != null)
				{
					cardCollider.enabled = t >= 0.999f;
				}
			}
		}

		private void SetTitleVisible(float t)
		{
			if (!(title == null))
			{
				title.gameObject.SetActive(t > 0.001f);
				if (titleText != null)
				{
					titleText.alpha = t;
				}
			}
		}

		private IEnumerator MoveTitle(Transform from, Transform to, float duration)
		{
			duration = Mathf.Max(duration, 0.01f);
			float t = 0f;
			while (t < 1f)
			{
				t += Time.deltaTime / duration;
				float t2 = Mathf.SmoothStep(0f, 1f, t);
				title.position = Vector3.Lerp(from.position, to.position, t2);
				title.rotation = Quaternion.Slerp(from.rotation, to.rotation, t2);
				title.localScale = Vector3.Lerp(from.localScale, to.localScale, t2);
				yield return null;
			}
			Snap(title, to);
		}

		private static void Snap(Transform target, Transform point)
		{
			target.SetPositionAndRotation(point.position, point.rotation);
			target.localScale = point.localScale;
		}

		private static IEnumerator Fade(Action<float> apply, float from, float to, float duration)
		{
			duration = Mathf.Max(duration, 0.01f);
			float t = 0f;
			while (t < 1f)
			{
				t += Time.deltaTime / duration;
				apply(Mathf.Lerp(from, to, Mathf.SmoothStep(0f, 1f, t)));
				yield return null;
			}
			apply(to);
		}

		private static void SetText(TMP_Text text, string value)
		{
			if (text != null)
			{
				text.text = value;
			}
		}

		private void Play(AudioClip clip)
		{
			if (clip != null && _voice != null)
			{
				_voice.PlayOneShot(clip, volume);
			}
		}
	}
}
