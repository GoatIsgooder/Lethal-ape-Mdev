using LethalApeR.PlayFab;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Frontend
{
	public sealed class PlayCard : MonoBehaviour
	{
		private enum State
		{
			SigningIn = 0,
			Ready = 1,
			Joining = 2,
			Blocked = 3,
			Banned = 4
		}

		[SerializeField]
		private LoadingScreenAuth auth;

		[SerializeField]
		private LoadingMenu menu;

		[SerializeField]
		private MenuContent content;

		[SerializeField]
		private MenuButton button;

		[Header("Visuals")]
		[SerializeField]
		private RawImage cover;

		[SerializeField]
		private TMP_Text label;

		[SerializeField]
		private TMP_Text stateText;

		[Tooltip("Wired to LoadingScreenAuth.statusText; shown only while signing in or blocked.")]
		[SerializeField]
		private TMP_Text authDetail;

		[SerializeField]
		private CanvasGroup progressGroup;

		[SerializeField]
		private RectTransform progressFill;

		[Header("Blocked")]
		[Tooltip("Cover, label and progress. Hidden while blocked so the explanation can use the whole card.")]
		[SerializeField]
		private GameObject readyGroup;

		[Tooltip("Where the auth message goes while blocked: x, y from the top-left, width, height (canvas units).")]
		[SerializeField]
		private Vector4 blockedDetailRect = new Vector4(44f, 116f, 672f, 900f);

		[SerializeField]
		private float blockedDetailSize = 34f;

		[SerializeField]
		private Color blockedDetailColor = new Color(0.88f, 0.88f, 0.88f, 1f);

		[Header("Colours")]
		[SerializeField]
		private Color labelReady = new Color(1f, 1f, 1f, 1f);

		[SerializeField]
		private Color labelWaiting = new Color(0.32f, 0.32f, 0.32f, 1f);

		[SerializeField]
		private Color coverIdle = new Color(0.62f, 0.62f, 0.62f, 1f);

		[SerializeField]
		private Color coverHover = new Color(0.95f, 0.95f, 0.95f, 1f);

		[SerializeField]
		private Color coverBlocked = new Color(0.18f, 0.18f, 0.18f, 1f);

		private State _state = (State)(-1);

		private int _percent = -1;

		private bool _requested;

		private float _ready;

		private float _progressAlpha;

		private Vector2 _detailPos;

		private Vector2 _detailSize;

		private Color _detailColor;

		private bool _detailAutoSize;

		private float _detailFontSize;

		private void Awake()
		{
			button.Clicked += OnClicked;
			if (authDetail != null)
			{
				RectTransform rectTransform = authDetail.rectTransform;
				_detailPos = rectTransform.anchoredPosition;
				_detailSize = rectTransform.sizeDelta;
				_detailColor = authDetail.color;
				_detailAutoSize = authDetail.enableAutoSizing;
				_detailFontSize = authDetail.fontSize;
			}
			if (content != null && content.PlayCover != null && cover != null)
			{
				cover.texture = content.PlayCover;
				MenuImage.Fill(cover, content.PlayCover, 0f);
			}
		}

		private void OnDestroy()
		{
			if (button != null)
			{
				button.Clicked -= OnClicked;
			}
		}

		private void OnClicked()
		{
			if (auth != null && auth.IsBanned)
			{
				menu.ShowBanNotice();
			}
			else if (!_requested && !(auth == null) && auth.IsCleared)
			{
				_requested = true;
				menu.RequestPlay();
			}
		}

		private void Update()
		{
			State state = Evaluate();
			if (state != _state)
			{
				Enter(state);
			}
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			_ready = Mathf.MoveTowards(_ready, (state == State.Ready || state == State.Joining) ? 1f : 0f, unscaledDeltaTime * 4f);
			Color color = Color.Lerp(labelWaiting, labelReady, _ready);
			if (label.color != color)
			{
				label.color = color;
			}
			Color color2 = ((state == State.Blocked || state == State.Banned) ? coverBlocked : Color.Lerp(Color.Lerp(coverBlocked, coverIdle, _ready), coverHover, _ready * button.Hover01));
			if (cover != null && cover.color != color2)
			{
				cover.color = color2;
			}
			UpdateProgress(state, unscaledDeltaTime);
		}

		private State Evaluate()
		{
			if (auth == null)
			{
				return State.SigningIn;
			}
			if (auth.IsBanned)
			{
				return State.Banned;
			}
			if (auth.IsBlocked)
			{
				return State.Blocked;
			}
			if (auth.IsCleared)
			{
				if (!_requested)
				{
					return State.Ready;
				}
				return State.Joining;
			}
			return State.SigningIn;
		}

		private void Enter(State state)
		{
			_state = state;
			_percent = -1;
			button.Interactable = state == State.Ready || state == State.Banned;
			if (authDetail != null)
			{
				authDetail.gameObject.SetActive(state == State.SigningIn || state == State.Blocked);
			}
			LayoutDetail(state == State.Blocked);
			switch (state)
			{
			case State.SigningIn:
				stateText.SetText("SIGNING IN");
				break;
			case State.Ready:
				stateText.SetText("READY");
				break;
			case State.Joining:
				stateText.SetText("JOINING");
				break;
			case State.Blocked:
				stateText.SetText("CAN'T JOIN");
				break;
			case State.Banned:
				stateText.SetText(string.Empty);
				break;
			}
		}

		private void LayoutDetail(bool blocked)
		{
			if (blocked && readyGroup != null)
			{
				readyGroup.SetActive(false);
			}
			if (!(authDetail == null))
			{
				RectTransform rectTransform = authDetail.rectTransform;
				if (blocked)
				{
					rectTransform.anchoredPosition = new Vector2(blockedDetailRect.x, 0f - blockedDetailRect.y);
					rectTransform.sizeDelta = new Vector2(blockedDetailRect.z, blockedDetailRect.w);
					authDetail.enableAutoSizing = false;
					authDetail.fontSize = blockedDetailSize;
					authDetail.color = blockedDetailColor;
				}
				else
				{
					rectTransform.anchoredPosition = _detailPos;
					rectTransform.sizeDelta = _detailSize;
					authDetail.enableAutoSizing = _detailAutoSize;
					authDetail.fontSize = _detailFontSize;
					authDetail.color = _detailColor;
				}
			}
		}

		private void UpdateProgress(State state, float dt)
		{
			bool flag = state == State.Joining && !auth.WorldReady;
			bool flag2 = state == State.SigningIn || flag;
			_progressAlpha = Mathf.MoveTowards(_progressAlpha, flag2 ? 1f : 0f, dt * 5f);
			if (progressGroup != null)
			{
				progressGroup.alpha = _progressAlpha;
			}
			if (progressFill == null || !(_progressAlpha > 0f))
			{
				return;
			}
			if (flag)
			{
				int num = Mathf.RoundToInt(auth.WorldProgress * 100f);
				if (num != _percent)
				{
					_percent = num;
					stateText.SetText("JOINING  {0}%", num);
				}
				SetSpan(0f, auth.WorldProgress);
			}
			else if (state == State.SigningIn)
			{
				float num2 = Mathf.SmoothStep(0f, 1.25f, Mathf.Repeat(Time.unscaledTime * 0.55f, 1f));
				SetSpan(Mathf.Clamp01(num2 - 0.3f), Mathf.Clamp01(num2));
			}
		}

		private void SetSpan(float from, float to)
		{
			Vector2 anchorMin = progressFill.anchorMin;
			Vector2 anchorMax = progressFill.anchorMax;
			if (!Mathf.Approximately(anchorMin.x, from) || !Mathf.Approximately(anchorMax.x, to))
			{
				progressFill.anchorMin = new Vector2(from, anchorMin.y);
				progressFill.anchorMax = new Vector2(to, anchorMax.y);
			}
		}
	}
}
