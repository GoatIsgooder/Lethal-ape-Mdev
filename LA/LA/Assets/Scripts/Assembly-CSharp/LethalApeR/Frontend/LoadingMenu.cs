using System.Collections;
using System.Text.RegularExpressions;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.PlayFab;
using LethalApeR.SceneFlow;
using TMPro;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

namespace LethalApeR.Frontend
{
	public sealed class LoadingMenu : MonoBehaviour
	{
		[Header("Scene")]
		[SerializeField]
		private MenuRig rig;

		[Tooltip("Floor-level root that gets turned to face the player.")]
		[SerializeField]
		private Transform menuRoot;

		[SerializeField]
		private MenuArc arc;

		[SerializeField]
		private LoadingScreenAuth auth;

		[SerializeField]
		private MenuPointer pointer;

		[SerializeField]
		private MenuBackdrop backdrop;

		[SerializeField]
		private TurnAroundBanner banner;

		[SerializeField]
		private ReaderPanel reader;

		[Tooltip("Menu music. Fades out with the screen when the player presses Play.")]
		[SerializeField]
		private AudioSource music;

		[Tooltip("Modal popup with the blurred backdrop (the ban notice uses it).")]
		[SerializeField]
		private MenuNotification notification;

		[Header("Intro")]
		[SerializeField]
		private TitleRevealSequence reveal;

		[SerializeField]
		private MenuArcItem logo;

		[Tooltip("Where the wordmark ends up; its angle, height, offset and scale are the target.")]
		[SerializeField]
		private MenuArcItem logoSlot;

		[SerializeField]
		private float logoMoveSeconds = 0.95f;

		[SerializeField]
		private MenuArcRail[] rails;

		[SerializeField]
		private MenuCard[] cards;

		[SerializeField]
		private CanvasGroup[] chrome;

		[SerializeField]
		private float cardStagger = 0.09f;

		[SerializeField]
		private float backdropFadeSeconds = 1.8f;

		[SerializeField]
		private Vector2 eyeHeightRange = new Vector2(1f, 1.95f);

		[Header("Labels")]
		[SerializeField]
		private TMP_Text versionText;

		[SerializeField]
		private TMP_Text playerText;

		[SerializeField]
		private TMP_Text closeHint;

		[Header("Exit")]
		[SerializeField]
		private float fadeOutSeconds = 0.35f;

		[SerializeField]
		private float fadeInSeconds = 0.5f;

		[SerializeField]
		private int settleFrames = 6;

		private bool _aligned;

		private bool _playRequested;

		private bool _selectWasDown;

		private static readonly Color BanRed = new Color(1f, 0.3f, 0.3f, 1f);

		private bool _nameShown;

		private bool _menuShown;

		private bool _banNoticeShown;

		private bool _banNoticeOpen;

		private void Awake()
		{
			if (auth != null)
			{
				auth.HoldActivation = true;
			}
			MenuArcRail[] array = rails;
			for (int i = 0; i < array.Length; i++)
			{
				array[i].Reveal = 0f;
			}
			MenuCard[] array2 = cards;
			for (int i = 0; i < array2.Length; i++)
			{
				array2[i].Hide();
			}
			CanvasGroup[] array3 = chrome;
			for (int i = 0; i < array3.Length; i++)
			{
				array3[i].alpha = 0f;
			}
			pointer.enabled = false;
			banner.Active = false;
			backdrop.Fade = 0f;
			if (versionText != null)
			{
				versionText.SetText(VersionLabel(Application.version));
			}
			if (playerText != null)
			{
				playerText.SetText(string.Empty);
			}
			ShowCloseHint();
			reader.OpenChanged += OnReaderChanged;
			if (notification != null)
			{
				notification.OpenChanged += OnNotificationChanged;
			}
			pointer.BackPressed += OnBack;
			rig.Recentered += OnRecentered;
			rig.ModeChanged += ShowCloseHint;
		}

		private void ShowCloseHint()
		{
			if (closeHint != null)
			{
				closeHint.SetText(rig.IsDesktop ? "ESC  CLOSE" : "B  CLOSE");
			}
		}

		private static string VersionLabel(string version)
		{
			Match match = Regex.Match(version ?? string.Empty, "\\d+(\\.\\d+)+");
			if (match.Success)
			{
				return "V" + match.Value;
			}
			return (version ?? string.Empty).ToUpperInvariant();
		}

		private void OnDestroy()
		{
			if (reader != null)
			{
				reader.OpenChanged -= OnReaderChanged;
			}
			if (notification != null)
			{
				notification.OpenChanged -= OnNotificationChanged;
			}
			if (pointer != null)
			{
				pointer.BackPressed -= OnBack;
			}
			if (rig != null)
			{
				rig.Recentered -= OnRecentered;
				rig.ModeChanged -= ShowCloseHint;
			}
			if (MenuSurface.Modal != null)
			{
				MenuSurface.Modal = null;
			}
		}

		private void Start()
		{
			StartCoroutine(Boot());
		}

		private void Update()
		{
			UpdateBanNotice();
			if (!_nameShown && !(playerText == null) && !(auth == null) && auth.IsCleared)
			{
				_nameShown = true;
				string text = PlayerPrefs.GetString("Username", string.Empty).Trim();
				playerText.SetText((text.Length > 0) ? text.ToUpperInvariant() : string.Empty);
			}
		}

		private void UpdateBanNotice()
		{
			if (!(auth == null) && !(notification == null) && auth.IsBanned)
			{
				if (!_banNoticeShown && _menuShown)
				{
					ShowBanNotice();
				}
				if (_banNoticeOpen)
				{
					notification.SetDetail(auth.BanRemainingText);
				}
			}
		}

		public void ShowBanNotice()
		{
			if (!(auth == null) && !(notification == null) && auth.IsBanned && !notification.IsOpen)
			{
				_banNoticeShown = true;
				if (reader.IsOpen)
				{
					reader.Close();
				}
				string body = (string.IsNullOrEmpty(auth.BanUsername) ? "Your account has been suspended." : (auth.BanUsername + ", your account has been suspended.")) + "\n<color=#8C8C8C>Reason:</color> " + auth.BanReason;
				string footer = (string.IsNullOrEmpty(auth.AppealMessage) ? null : auth.AppealMessage.Replace("\n", " "));
				_banNoticeOpen = true;
				notification.Show("BANNED", body, MenuNotification.Icon.Alert, "TIME REMAINING", auth.BanRemainingText, footer, "OK", delegate
				{
					_banNoticeOpen = false;
				}, BanRed);
			}
		}

		private void OnNotificationChanged(bool open)
		{
			if (_menuShown)
			{
				banner.Active = !open;
			}
		}

		private IEnumerator Boot()
		{
			float start = Time.unscaledTime;
			yield return null;
			while (rig.AwaitingHeadset && Time.unscaledTime - start < 5f)
			{
				yield return null;
			}
			while (!rig.HeadTracked && Time.unscaledTime - start < 6.5f)
			{
				yield return null;
			}
			yield return null;
			Align();
			reveal.Play();
			StartCoroutine(FadeBackdrop());
			while (!reveal.IsRevealed)
			{
				if (SelectPressed())
				{
					reveal.Skip();
				}
				yield return null;
			}
			yield return ShowMenu();
		}

		private IEnumerator FadeBackdrop()
		{
			for (float t = 0f; t < 1f; t += Time.unscaledDeltaTime / backdropFadeSeconds)
			{
				backdrop.Fade = t * t;
				yield return null;
			}
			backdrop.Fade = 1f;
		}

		private IEnumerator ShowMenu()
		{
			float fromAngle = logo.angle;
			float fromHeight = logo.height;
			float fromOffset = logo.radiusOffset;
			Vector3 fromScale = logo.transform.localScale;
			Vector3 toScale = logoSlot.transform.localScale;
			for (int i = 0; i < cards.Length; i++)
			{
				cards[i].Show(cardStagger * (float)i + 0.32f);
			}
			float elapsed = 0f;
			bool pointerOn = false;
			float total = Mathf.Max(logoMoveSeconds, cardStagger * (float)cards.Length + 0.32f + 0.5f, 1.3f);
			while (elapsed < total)
			{
				elapsed += Time.unscaledDeltaTime;
				float t = Ease(Mathf.Clamp01(elapsed / logoMoveSeconds));
				logo.angle = Mathf.Lerp(fromAngle, logoSlot.angle, t);
				logo.height = Mathf.Lerp(fromHeight, logoSlot.height, t);
				logo.radiusOffset = Mathf.Lerp(fromOffset, logoSlot.radiusOffset, t);
				logo.transform.localScale = Vector3.Lerp(fromScale, toScale, t);
				logo.Apply();
				float num = 1f - Mathf.Pow(1f - Mathf.Clamp01((elapsed - 0.12f) / 0.75f), 3f);
				MenuArcRail[] array = rails;
				for (int j = 0; j < array.Length; j++)
				{
					array[j].Reveal = num;
				}
				float alpha = Mathf.Clamp01((elapsed - 0.6f) * 2f);
				CanvasGroup[] array2 = chrome;
				for (int j = 0; j < array2.Length; j++)
				{
					array2[j].alpha = alpha;
				}
				if (!pointerOn && elapsed > 0.55f)
				{
					pointerOn = true;
					pointer.enabled = true;
					banner.Active = true;
				}
				yield return null;
			}
			_menuShown = true;
		}

		private static float Ease(float t)
		{
			if (!(t < 0.5f))
			{
				return 1f - Mathf.Pow(-2f * t + 2f, 3f) / 2f;
			}
			return 4f * t * t * t;
		}

		private void Align()
		{
			Transform transform = rig.Head.transform;
			Vector3 vector = transform.forward;
			if (vector.x * vector.x + vector.z * vector.z < 0.0001f)
			{
				vector = transform.up;
			}
			float y = Mathf.Atan2(vector.x, vector.z) * Mathf.Rad2Deg;
			Vector3 position = rig.transform.position;
			menuRoot.SetPositionAndRotation(new Vector3(transform.position.x, position.y, transform.position.z), Quaternion.Euler(0f, y, 0f));
			float y2 = Mathf.Clamp(transform.position.y - position.y, eyeHeightRange.x, eyeHeightRange.y);
			Vector3 localPosition = arc.transform.localPosition;
			arc.transform.localPosition = new Vector3(localPosition.x, y2, localPosition.z);
			_aligned = true;
		}

		private void OnRecentered()
		{
			if (_aligned)
			{
				StartCoroutine(RealignNextFrame());
			}
		}

		private IEnumerator RealignNextFrame()
		{
			yield return null;
			yield return null;
			Align();
		}

		private void OnReaderChanged(bool open)
		{
			MenuCard[] array = cards;
			for (int i = 0; i < array.Length; i++)
			{
				array[i].Dimmed = open;
			}
		}

		private void OnBack()
		{
			if (notification != null && notification.IsOpen)
			{
				notification.Close();
			}
			else if (reader.IsOpen)
			{
				reader.Close();
			}
		}

		private bool SelectPressed()
		{
			VRInputController instance = VRInputController.Instance;
			bool flag = instance != null && (instance.LeftTriggerValue > 0.6f || instance.RightTriggerValue > 0.6f);
			Mouse current = Mouse.current;
			if (current != null)
			{
				flag |= current.leftButton.isPressed;
			}
			bool result = flag && !_selectWasDown;
			_selectWasDown = flag;
			return result;
		}

		public void RequestPlay()
		{
			if (!_playRequested && !(auth == null))
			{
				_playRequested = true;
				StartCoroutine(Enter());
			}
		}

		private IEnumerator Enter()
		{
			if (reader.IsOpen)
			{
				reader.Close();
			}
			while (!auth.WorldReady)
			{
				yield return null;
			}
			pointer.enabled = false;
			banner.Active = false;
			SceneFadeOverlay overlay = SceneFadeOverlay.Ensure();
			if (music != null)
			{
				StartCoroutine(FadeMusic(fadeOutSeconds));
			}
			yield return overlay.FadeTo(1f, fadeOutSeconds);
			ThreadPriority backgroundLoadingPriority = Application.backgroundLoadingPriority;
			Application.backgroundLoadingPriority = ThreadPriority.High;
			overlay.StartCoroutine(RevealAfterActivation(overlay, SceneManager.GetActiveScene(), backgroundLoadingPriority, settleFrames, fadeInSeconds));
			auth.HoldActivation = false;
		}

		private IEnumerator FadeMusic(float seconds)
		{
			float from = music.volume;
			for (float t = 0f; t < seconds; t += Time.unscaledDeltaTime)
			{
				music.volume = (1f - t / seconds) * from;
				yield return null;
			}
			music.volume = 0f;
			music.Stop();
		}

		private static IEnumerator RevealAfterActivation(SceneFadeOverlay overlay, Scene fromScene, ThreadPriority priority, int settle, float fadeIn)
		{
			float start = Time.unscaledTime;
			while (SceneManager.GetActiveScene() == fromScene && Time.unscaledTime - start < 60f)
			{
				yield return null;
			}
			for (int i = 0; i < settle; i++)
			{
				yield return null;
			}
			Application.backgroundLoadingPriority = priority;
			yield return overlay.FadeTo(0f, fadeIn);
		}
	}
}
