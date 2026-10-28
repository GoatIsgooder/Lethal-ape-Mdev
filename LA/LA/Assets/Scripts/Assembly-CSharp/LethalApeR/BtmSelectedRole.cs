using System.Collections;
using System.Collections.Generic;
using LethalApeR.Audio;
using LethalApeR.Gameplay.BeTheMonster;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR
{
	public class BtmSelectedRole : MonoBehaviour
	{
		private const string MonsterDisplayText = "<color=#FF2648><b>YOU ARE THE MONSTER</b>\n<size=50%>Your task: Kill all the survivors to win</color>";

		private const string SurvivorDisplayText = "<color=#00CEFF><size=90%><b>YOU ARE A SURVIVOR</b>\n<size=50%>Your task: Hide from the monster</color>";

		private const string WinDisplayText = "<color=#FFD900><b>YOU WON!</b>\n<size=50%>Congratulations! You survived this round.</color>";

		private const string DefeatDisplayText = "<color=#DC143C><b>YOU LOST</b>\n<size=50%>Better luck next time!</color>";

		private const string CaughtDisplayText = "<color=#FF2648><b>YOU'VE BEEN CAUGHT!</b>\n<size=50%>You're a ghost now. Your left wrist takes you back in to haunt the map</color>";

		public PlaySfx selectedSurvivorSfx;

		public PlaySfx selectedMonsterSfx;

		public PlaySfx winSfx;

		public PlaySfx defeatSfx;

		public TMP_Text displayText;

		public CanvasGroup canvasGroup;

		public Transform followTarget;

		[SerializeField]
		private float followSpeed = 8f;

		[SerializeField]
		private Vector3 followOffset = new Vector3(0f, 0.2f, 0.6f);

		[SerializeField]
		private float rotationSharpness = 8f;

		[SerializeField]
		private float positionSmoothTime = 0.08f;

		[SerializeField]
		private float maxPitch = 40f;

		[SerializeField]
		private float displayDuration = 2f;

		private Quaternion _smoothedRot;

		private Vector3 _smoothedPos;

		private Vector3 _posVelocity;

		private Coroutine _showRoutine;

		private Coroutine _hideRoutine;

		private bool _isDisplaying;

		private float _hideAt;

		private bool _hiding;

		public static BtmSelectedRole Instance { get; private set; }

		public Vector3 FollowOffset => followOffset;

		private void Awake()
		{
			Instance = this;
		}

		private void Start()
		{
			BTMGameManager.Instance.OnRoundStarted += OnRoundStarted;
			BTMGameManager.Instance.OnRoundEnded += OnRoundEnded;
			BTMGameManager.Instance.OnLocalPlayerEliminated += OnLocalPlayerEliminated;
			BTMGameManager.Instance.OnSalvageAwarded += OnSalvageAwarded;
			canvasGroup.alpha = 0f;
			transform.localScale = Vector3.zero;
			gameObject.SetActive(false);
			_isDisplaying = false;
		}

		private void OnRoundStarted(int[] monsters, int[] activePlayers, bool roundActive, string mapId)
		{
			bool isMonster = monsters.Length != 0 && monsters.Contains(PhotonNetwork.LocalPlayer.ActorNumber);
			string text = isMonster ? MonsterDisplayText : SurvivorDisplayText;
			PlaySfx sfx = isMonster ? selectedMonsterSfx : selectedSurvivorSfx;
			if ((isMonster || activePlayers.Contains(PhotonNetwork.LocalPlayer.ActorNumber)) && BtmLoadoutBox.Instance != null && RoundProps.PrepRemaining(in BTMGameManager.Instance.roomProperties) > 0.25f)
			{
				if (sfx)
				{
					sfx.PlayAudio();
				}
			}
			else
			{
				Show(text, sfx);
			}
		}

		private void OnSalvageAwarded(BtmSalvageReceipt receipt)
		{
			if (receipt.total < 1)
			{
				return;
			}
			string text = ReceiptText(receipt);
			if (!_isDisplaying)
			{
				Show(text.TrimStart('\n'), null);
			}
			else if (_hiding)
			{
				Show(displayText.text + text, null);
			}
			else
			{
				displayText.text += text;
				_hideAt = Mathf.Max(_hideAt, Time.time + displayDuration + 1.5f);
			}
		}

		private static string ReceiptText(BtmSalvageReceipt r)
		{
			List<string> list = new List<string>(5);
			list.Add(string.Format("Played +{0}", r.participation));
			if (r.outcome > 0)
			{
				list.Add(string.Format("{0} +{1}", r.asMonster ? "Hunt won" : ((r.escape > 0) ? "Escaped" : "Survived"), r.outcome));
			}
			if (r.generators > 0)
			{
				list.Add(string.Format("Generators +{0}", r.generators));
			}
			if (r.escape > 0)
			{
				list.Add(string.Format("Escape bonus +{0}", r.escape));
			}
			if (r.catchSalvage > 0)
			{
				list.Add(string.Format("{0} catch{1} +{2}", r.catches, (r.catches == 1) ? "" : "es", r.catchSalvage));
			}
			return string.Format("\n<size=45%><color=#E3B55B><b>+{0} {1}</b></color></size>", r.total, "Salvage".ToUpperInvariant()) + "\n<size=26%><color=#B9B4AA>" + string.Join(",  ", list) + "</color></size>";
		}

		private void OnLocalPlayerEliminated()
		{
			Show(CaughtDisplayText, defeatSfx);
		}

		private void OnRoundEnded(int[] winners, string mapId)
		{
			if (winners.Length != 0 && winners.Contains(PhotonNetwork.LocalPlayer.ActorNumber))
			{
				Show(WinDisplayText, winSfx);
			}
			else
			{
				Show(DefeatDisplayText, defeatSfx);
			}
		}

		public void ShowEscapeWin()
		{
			Show(WinDisplayText, winSfx);
		}

		public void ShowNotice(string text)
		{
			Show(text, null);
		}

		private void Show(string text, PlaySfx sfx)
		{
			_hiding = false;
			_isDisplaying = true;
			if (!string.IsNullOrEmpty(text))
			{
				displayText.text = text;
			}
			SnapToTarget();
			gameObject.SetActive(true);
			transform.localScale = Vector3.zero;
			canvasGroup.alpha = 0f;
			if (sfx)
			{
				sfx.PlayAudio();
			}
			if (_showRoutine != null)
			{
				StopCoroutine(_showRoutine);
			}
			if (_hideRoutine != null)
			{
				StopCoroutine(_hideRoutine);
			}
			_hideAt = Time.time + 0.75f + displayDuration;
			_showRoutine = StartCoroutine(ShowRoutine());
		}

		private IEnumerator ShowRoutine()
		{
			StartCoroutine(BtmTween.FadeCanvas(canvasGroup, 0f, 1f, 0.25f, BtmTween.OutQuad));
			yield return StartCoroutine(BtmTween.ScaleTo(transform, 0f, 1f, 0.35f, BtmTween.OutBack));
			yield return StartCoroutine(BtmTween.PunchScale(transform, 0.12f, 0.4f, 5, 0.5f));
			while (Time.time < _hideAt)
			{
				yield return null;
			}
			Hide();
		}

		private void Hide()
		{
			_hiding = true;
			if (_showRoutine != null)
			{
				StopCoroutine(_showRoutine);
			}
			_hideRoutine = StartCoroutine(HideRoutine());
		}

		private IEnumerator HideRoutine()
		{
			StartCoroutine(BtmTween.FadeCanvas(canvasGroup, canvasGroup.alpha, 0f, 0.2f, BtmTween.InQuad));
			yield return StartCoroutine(BtmTween.ScaleTo(transform, transform.localScale.x, 0f, 0.2f, BtmTween.InBack));
			gameObject.SetActive(false);
			_isDisplaying = false;
			_hiding = false;
		}

		private void Update()
		{
			if (followTarget && _isDisplaying)
			{
				_smoothedPos = Vector3.SmoothDamp(_smoothedPos, followTarget.position, ref _posVelocity, positionSmoothTime);
				transform.position = _smoothedPos + followTarget.TransformDirection(followOffset);
				float pitch = followTarget.eulerAngles.x;
				if (pitch > 180f)
				{
					pitch -= 360f;
				}
				pitch = Mathf.Clamp(pitch, -maxPitch, maxPitch);
				Quaternion target = Quaternion.Euler(pitch, followTarget.eulerAngles.y, 0f);
				_smoothedRot = Quaternion.Slerp(_smoothedRot, target, Time.deltaTime * rotationSharpness);
				transform.rotation = _smoothedRot;
			}
		}

		private void SnapToTarget()
		{
			if (followTarget)
			{
				_smoothedPos = followTarget.position;
				_posVelocity = Vector3.zero;
				transform.position = followTarget.TransformPoint(followOffset);
				float pitch = followTarget.eulerAngles.x;
				if (pitch > 180f)
				{
					pitch -= 360f;
				}
				pitch = Mathf.Clamp(pitch, -maxPitch, maxPitch);
				_smoothedRot = Quaternion.Euler(pitch, followTarget.eulerAngles.y, 0f);
				transform.rotation = _smoothedRot;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager.Instance.OnRoundStarted -= OnRoundStarted;
				BTMGameManager.Instance.OnRoundEnded -= OnRoundEnded;
				BTMGameManager.Instance.OnLocalPlayerEliminated -= OnLocalPlayerEliminated;
				BTMGameManager.Instance.OnSalvageAwarded -= OnSalvageAwarded;
			}
			StopAllCoroutines();
		}
	}
}
