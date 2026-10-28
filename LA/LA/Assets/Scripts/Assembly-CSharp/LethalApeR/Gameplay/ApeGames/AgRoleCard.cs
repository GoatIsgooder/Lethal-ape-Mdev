using System.Collections;
using System.Collections.Generic;
using LethalApeR.Audio;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.ApeGames
{
	public class AgRoleCard : MonoBehaviour
	{
		private struct CardRequest
		{
			public string text;

			public PlaySfx sfx;

			public float duration;
		}

		private const string InfoColor = "00CEFF";

		private const string CountdownColor = "FFD900";

		private const string EliminatedColor = "FF2648";

		private const string SurvivedColor = "00FF88";

		private const string WinnerColor = "FFD900";

		private const string SeekerColor = "FF2648";

		private const string HiderColor = "00CEFF";

		private const string Round0Name = "RED LIGHT, GREEN LIGHT";

		private const string Round0Rule = "Freeze on red, then reach the finish line";

		private const string Round1Name = "JUMP ROPE";

		private const string Round1Rule = "Clear the rope, then reach the finish line";

		private const string Round2Name = "GLASS BRIDGE";

		private const string Round2Rule = "One panel holds, the other breaks";

		private const string Round3Name = "HIDE AND SEEK";

		private const string Round3Rule = "Hiders power generators and escape. Seekers catch them";

		private const string Round4Name = "FINAL FIGHT";

		private const string Round4Rule = "Last ape standing";

		private static readonly string[] RoundNames = new string[5] { Round0Name, Round1Name, Round2Name, Round3Name, Round4Name };

		private static readonly string[] RoundRules = new string[5] { Round0Rule, Round1Rule, Round2Rule, Round3Rule, Round4Rule };

		public PlaySfx introSfx;

		public PlaySfx countdownSfx;

		public PlaySfx eliminatedSfx;

		public PlaySfx survivedSfx;

		public PlaySfx winSfx;

		public PlaySfx defeatSfx;

		public TMP_Text displayText;

		public CanvasGroup canvasGroup;

		[SerializeField]
		private float queueGapSeconds = 0.4f;

		[Header("HUD look")]
		[SerializeField]
		private RectTransform frame;

		[SerializeField]
		private Color frameColor = new Color(0f, 0.03f, 0.07f, 0.8f);

		[SerializeField]
		private int countdownFromSeconds = 30;

		[SerializeField]
		[Range(0.3f, 1f)]
		private float countdownAlpha = 0.72f;

		private const float FadeInDur = 0.15f;

		private const float FadeOutDur = 0.2f;

		private const int MaxQueuedCards = 8;

		private readonly Queue<CardRequest> _queue = new Queue<CardRequest>();

		private Coroutine _pump;

		private Coroutine _cdRoutine;

		private bool _isDisplaying;

		private bool _hooked;

		private double _lobbyStamp = -1.0;

		private double _cdStamp = -1.0;

		private double _cdLastRemaining;

		private double _escStamp = -1.0;

		private bool _localEscapedShown;

		private AgCause _pendingCause;

		private float _pendingCauseTime = float.NegativeInfinity;

		public static string GetRoundName(int round)
		{
			if (round < 0 || round >= RoundNames.Length)
			{
				return "???";
			}
			return RoundNames[round];
		}

		public static string GetRoundRule(int round)
		{
			if (round < 0 || round >= RoundRules.Length)
			{
				return string.Empty;
			}
			return RoundRules[round];
		}

		private void Start()
		{
			Hook();
			EnsureFrame();
			HideInstant();
			_isDisplaying = false;
		}

		private void OnEnable()
		{
			if (_queue.Count > 0 && _pump == null)
			{
				_pump = StartCoroutine(PumpQueue());
			}
		}

		private void OnDisable()
		{
			StopAllCoroutines();
			_pump = null;
			_cdRoutine = null;
			_isDisplaying = false;
			_queue.Clear();
			HideInstant();
		}

		private void OnDestroy()
		{
			Unhook();
			StopAllCoroutines();
		}

		private void Hook()
		{
			if (!_hooked && !(ApeGamesManager.Instance == null))
			{
				_hooked = true;
				ApeGamesManager.Instance.OnRoundStartedEvent += OnRoundStarted;
				ApeGamesManager.Instance.OnRoundEndedEvent += OnRoundEnded;
				ApeGamesManager.Instance.OnMatchEnded += OnMatchEndedHandler;
				ApeGamesManager.Instance.OnLocalEliminated += OnLocalEliminatedHandler;
				ApeGamesManager.Instance.OnPropsChanged += OnPropsChangedHandler;
				ApeGamesManager.Instance.OnReviveQueued += OnReviveQueuedHandler;
			}
		}

		private void Unhook()
		{
			if (_hooked)
			{
				_hooked = false;
				if (!(ApeGamesManager.Instance == null))
				{
					ApeGamesManager.Instance.OnRoundStartedEvent -= OnRoundStarted;
					ApeGamesManager.Instance.OnRoundEndedEvent -= OnRoundEnded;
					ApeGamesManager.Instance.OnMatchEnded -= OnMatchEndedHandler;
					ApeGamesManager.Instance.OnLocalEliminated -= OnLocalEliminatedHandler;
					ApeGamesManager.Instance.OnPropsChanged -= OnPropsChangedHandler;
					ApeGamesManager.Instance.OnReviveQueued -= OnReviveQueuedHandler;
				}
			}
		}

		public void Enqueue(string headline, string subline, string hexColor, PlaySfx sfx = null, float duration = 2f)
		{
			if (string.IsNullOrEmpty(headline) || displayText == null || canvasGroup == null || _queue.Count >= MaxQueuedCards)
			{
				return;
			}
			string text = "<color=#" + hexColor + "><b>" + headline + "</b>\n<size=50%>" + subline + "</color>";
			_queue.Enqueue(new CardRequest
			{
				text = text,
				sfx = sfx,
				duration = Mathf.Max(0.5f, duration)
			});
			if (_cdRoutine != null)
			{
				StopCoroutine(_cdRoutine);
				_cdRoutine = null;
			}
			if (base.isActiveAndEnabled && _pump == null)
			{
				_pump = StartCoroutine(PumpQueue());
			}
		}

		public void ShowReviveQueued()
		{
			Enqueue("REVIVE USED", "You rejoin next round", SurvivedColor, survivedSfx);
		}

		public void NotifyEliminationCause(AgCause cause)
		{
			_pendingCause = cause;
			_pendingCauseTime = Time.unscaledTime;
		}

		private IEnumerator PumpQueue()
		{
			while (_queue.Count > 0)
			{
				CardRequest card = _queue.Dequeue();
				displayText.text = card.text;
				_isDisplaying = true;
				if ((bool)card.sfx)
				{
					card.sfx.PlayAudio();
				}
				yield return FadeGroup(canvasGroup, 0f, 1f, FadeInDur);
				yield return new WaitForSeconds(card.duration);
				yield return FadeGroup(canvasGroup, 1f, 0f, FadeOutDur);
				HideInstant();
				_isDisplaying = false;
				yield return new WaitForSeconds(queueGapSeconds);
			}
			_pump = null;
		}

		private void OnRoundStarted(int round, AgRoundProperties p)
		{
			Enqueue(GetRoundName(round), GetRoundRule(round), InfoColor, introSfx);
			if (round == 3 && p != null)
			{
				int num = LocalActor();
				if (num > 0 && p.AliveContains(num))
				{
					bool flag = p.SeekersContains(num);
					Enqueue(flag ? "YOU ARE A SEEKER" : "YOU ARE A HIDER", flag ? "Catch the hiders before time runs out" : "Power the generators and slip out the escape door", flag ? SeekerColor : HiderColor, introSfx);
				}
			}
		}

		private void OnRoundEnded(int round, AgRoundProperties p)
		{
			if (round == 3 && p != null && p.catchCount == 0)
			{
				int num = LocalActor();
				bool flag = num > 0 && p.SeekersContains(num);
				Enqueue("THE SEEKERS CAUGHT NO ONE", "All seekers are eliminated", EliminatedColor, flag ? eliminatedSfx : null);
			}
		}

		private void OnLocalEliminatedHandler()
		{
			AgCause cause = ((Time.unscaledTime - _pendingCauseTime <= 3f) ? _pendingCause : ((ApeGamesManager.Instance != null) ? ApeGamesManager.Instance.LastLocalEliminationCause : AgCause.Generic));
			_pendingCauseTime = float.NegativeInfinity;
			Enqueue("ELIMINATED", CauseLine(cause), EliminatedColor, eliminatedSfx, 2.5f);
			AgHaptics.Both(0.7f, 0.3f);
		}

		private void OnLocalEscapedHandler()
		{
			AgHaptics.Both(0.4f, 0.12f);
		}

		private void OnReviveQueuedHandler(int actor)
		{
			if (LocalActor() == actor)
			{
				ShowReviveQueued();
			}
		}

		private void OnMatchEndedHandler(int[] winners)
		{
			if (winners == null || winners.Length == 0)
			{
				Enqueue("NOBODY SURVIVED THE APE GAMES", "The games claim everyone", EliminatedColor, defeatSfx, 3f);
				return;
			}
			int num = LocalActor();
			bool flag = false;
			for (int i = 0; i < winners.Length; i++)
			{
				if (winners[i] == num)
				{
					flag = true;
					break;
				}
			}
			if (!flag)
			{
				Enqueue(ResolveName(winners[0]) + " WINS THE APE GAMES", "Better luck next time", WinnerColor, defeatSfx, 3f);
				return;
			}
			AgRoundProperties agRoundProperties = ((ApeGamesManager.Instance != null) ? ApeGamesManager.Instance.Props : null);
			int num2 = 0;
			if (agRoundProperties != null)
			{
				int players = AgMatchReward.RosterSize(agRoundProperties);
				num2 = AgMatchReward.GoldFor(players);
				AgMatchReward.Claim(agRoundProperties.matchStamp, players);
			}
			string subline = ((num2 > 0) ? string.Format("+{0} gold", num2) : string.Format("Needs {0}+ players for gold", AgMatchReward.MinPlayers));
			Enqueue("YOU WON THE APE GAMES!", subline, WinnerColor, winSfx, 3f);
		}

		private void OnPropsChangedHandler(AgRoundProperties p)
		{
			if (p == null || p.queue != "ApeGames")
			{
				return;
			}
			if (p.phase == AgPhase.LobbyWait && !_lobbyStamp.Equals(p.matchStamp))
			{
				_lobbyStamp = p.matchStamp;
				Enqueue("APE GAMES", "Get ready", InfoColor, introSfx);
			}
			if (!_escStamp.Equals(p.startTime))
			{
				_escStamp = p.startTime;
				_localEscapedShown = false;
			}
			else if (_localEscapedShown)
			{
				return;
			}
			if (p.phase == AgPhase.Round)
			{
				int num = LocalActor();
				if (num > 0 && p.EscapedContains(num))
				{
					_localEscapedShown = true;
					int num2 = ((p.alive != null) ? p.alive.Length : 0);
					Enqueue("FINISHED", string.Format("{0} cleared — {1} left", GetRoundName(p.round), num2), SurvivedColor, survivedSfx);
					AgHaptics.Both(0.4f, 0.12f);
				}
			}
		}

		private void UpdateCountdown()
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null || !PhotonNetwork.InRoom)
			{
				return;
			}
			AgRoundProperties props = instance.Props;
			if (props == null || props.queue != "ApeGames")
			{
				return;
			}
			if (props.phase != AgPhase.Round || !(props.endTime > 0.0))
			{
				_cdStamp = -1.0;
				return;
			}
			double num = props.endTime - PhotonNetwork.Time;
			if (!_cdStamp.Equals(props.startTime))
			{
				_cdStamp = props.startTime;
			}
			else if (num <= 60.0 && _cdLastRemaining > 60.0)
			{
				Enqueue("1 MINUTE LEFT", "The clock is ticking", CountdownColor, countdownSfx, 1.2f);
			}
			else if (num <= 30.0 && _cdLastRemaining > 30.0)
			{
				Enqueue("30 SECONDS", "Hurry", CountdownColor, countdownSfx, 1.2f);
			}
			else if (num <= 10.0 && _cdLastRemaining > 10.0)
			{
				Enqueue("10 SECONDS", "Go go go", CountdownColor, countdownSfx, 1.2f);
			}
			_cdLastRemaining = num;
		}

		private void UpdateNextGameCountdown()
		{
			NextGameSeconds(out var live);
			if (live && !_isDisplaying && _queue.Count == 0 && _pump == null && _cdRoutine == null)
			{
				_cdRoutine = StartCoroutine(CountdownRoutine());
			}
		}

		private int NextGameSeconds(out bool live)
		{
			live = false;
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null || !PhotonNetwork.InRoom)
			{
				return 0;
			}
			AgRoundProperties props = instance.Props;
			if (props == null || props.queue != "ApeGames")
			{
				return 0;
			}
			if ((props.phase != AgPhase.LobbyWait && props.phase != AgPhase.Intermission) || !(props.endTime > 0.0))
			{
				return 0;
			}
			int num = Mathf.CeilToInt((float)(props.endTime - PhotonNetwork.Time));
			if (num < 1)
			{
				return num;
			}
			if (num <= countdownFromSeconds)
			{
				live = true;
			}
			return num;
		}

		private IEnumerator CountdownRoutine()
		{
			int secs0 = NextGameSeconds(out var live0);
			if (!live0)
			{
				_cdRoutine = null;
				yield break;
			}
			_isDisplaying = true;
			displayText.text = CountdownText(secs0);
			yield return FadeGroup(canvasGroup, 0f, countdownAlpha, FadeInDur);
			int lastSecs = secs0;
			while (true)
			{
				int num = NextGameSeconds(out var live);
				if (!live || _queue.Count > 0)
				{
					break;
				}
				if (num != lastSecs)
				{
					lastSecs = num;
					displayText.text = CountdownText(num);
				}
				yield return null;
			}
			yield return FadeGroup(canvasGroup, canvasGroup.alpha, 0f, FadeOutDur);
			HideInstant();
			_cdRoutine = null;
			_isDisplaying = false;
		}

		private static string CountdownText(int secs)
		{
			return string.Format("<color=#{0}><b>NEXT GAME</b>\n<size=55%>starts in {1}</color>", InfoColor, secs);
		}

		private void Update()
		{
			if (!_hooked)
			{
				Hook();
			}
			UpdateCountdown();
			UpdateNextGameCountdown();
		}

		private void EnsureFrame()
		{
			if (displayText == null || frame != null)
			{
				return;
			}
			RectTransform rectTransform = displayText.transform.parent as RectTransform;
			if (!(rectTransform == null))
			{
				GameObject gameObject = new GameObject("NotifyFrame", typeof(RectTransform), typeof(CanvasRenderer), typeof(Image));
				RectTransform rectTransform2 = (RectTransform)gameObject.transform;
				rectTransform2.SetParent(rectTransform, worldPositionStays: false);
				rectTransform2.anchorMin = Vector2.zero;
				rectTransform2.anchorMax = Vector2.one;
				rectTransform2.offsetMin = Vector2.zero;
				rectTransform2.offsetMax = Vector2.zero;
				rectTransform2.pivot = new Vector2(0.5f, 0.5f);
				rectTransform2.SetAsFirstSibling();
				Image component = gameObject.GetComponent<Image>();
				component.color = frameColor;
				component.raycastTarget = false;
				frame = rectTransform2;
			}
		}

		private void HideInstant()
		{
			if ((bool)canvasGroup)
			{
				canvasGroup.alpha = 0f;
			}
		}

		private static IEnumerator FadeGroup(CanvasGroup cg, float from, float to, float dur)
		{
			if (cg == null)
			{
				yield break;
			}
			float e = 0f;
			while (e < dur)
			{
				e += Time.deltaTime;
				cg.alpha = Mathf.Lerp(from, to, e / dur);
				yield return null;
			}
			cg.alpha = to;
		}

		private static int LocalActor()
		{
			Player localPlayer = PhotonNetwork.LocalPlayer;
			if (localPlayer == null)
			{
				return -1;
			}
			return localPlayer.ActorNumber;
		}

		private static string ResolveName(int actor)
		{
			string text = AgNetSync.Get(actor)?.Owner?.NickName;
			if (!string.IsNullOrEmpty(text))
			{
				return text;
			}
			text = PhotonNetwork.CurrentRoom?.GetPlayer(actor)?.NickName;
			if (!string.IsNullOrEmpty(text))
			{
				return text;
			}
			return "SOMEONE";
		}

		private static string CauseLine(AgCause cause)
		{
			switch (cause)
			{
			case AgCause.MovedOnRed:
				return "Moved on red";
			case AgCause.TimeUp:
				return "Time's up";
			case AgCause.Fell:
				return "You fell";
			case AgCause.Caught:
				return "Caught";
			case AgCause.Bonked:
				return "Bonked";
			case AgCause.Roped:
				return "The rope got you";
			default:
				return "You're out. Rest area until the match ends";
			}
		}
	}
}
