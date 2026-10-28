using System;
using System.Collections;
using System.Reflection;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay
{
	[Obfuscation(Exclude = true)]
	public class FourthOfJulyEvent : MonoBehaviour
	{
		private enum Phase
		{
			None = -1,
			Countdown = 0,
			Live = 1,
			LeavingSoon = 2,
			Over = 3
		}

		[Header("Schedule (UK local time)")]
		[SerializeField]
		private int year = 2026;

		[SerializeField]
		private int month = 7;

		[SerializeField]
		private int day = 4;

		[SerializeField]
		private int hour = 19;

		[SerializeField]
		private int minute;

		[Tooltip("UK offset from UTC at the event date. July = BST = 1. Winter events = 0.")]
		[SerializeField]
		private int ukUtcOffsetHours = 1;

		[Tooltip("How long the event stays up after it starts.")]
		[SerializeField]
		private float liveHours = 12f;

		[Tooltip("How long before the end the leaving message types out.")]
		[SerializeField]
		private float leavingSoonHours = 1f;

		[Header("Countdown")]
		[SerializeField]
		private TMP_Text countdownText;

		[SerializeField]
		private string countdownPrefix = "";

		[Tooltip("Hide the countdown text object once the event goes live (ignored if it doubles as the event text).")]
		[SerializeField]
		private bool hideCountdownWhenLive = true;

		[Header("Event")]
		[Tooltip("Object that enables and scales 0→1 when the countdown hits zero.")]
		[SerializeField]
		private GameObject eventObject;

		[Tooltip("Text the messages typewrite into (usually inside eventObject). Falls back to countdownText if empty.")]
		[SerializeField]
		private TMP_Text eventText;

		[Tooltip("Optional — disabled at the very end along with everything else. Leave empty to only disable eventObject.")]
		[SerializeField]
		private GameObject eventRoot;

		[SerializeField]
		private string happyMessage = "HAPPY 4TH OF JULY!!!";

		[SerializeField]
		private string leavingMessage = "!LEAVING SOON!";

		[SerializeField]
		private float scaleInDuration = 0.9f;

		[SerializeField]
		private float typeCharInterval = 0.07f;

		private Phase _phase = Phase.None;

		private DateTime _startUtc;

		private DateTime _leavingUtc;

		private DateTime _endUtc;

		private Vector3 _eventScale;

		private Coroutine _sequence;

		private WaitForSeconds _charWait;

		private TimeSpan _debugOffset = TimeSpan.Zero;

		private long _lastShownSecond = long.MinValue;

		private DateTime NowUtc => DateTime.UtcNow + _debugOffset;

		private void Awake()
		{
			DateTime local = new DateTime(year, month, day, hour, minute, 0, DateTimeKind.Utc);
			_startUtc = local.AddHours(-ukUtcOffsetHours);
			_endUtc = _startUtc.AddHours(liveHours);
			_leavingUtc = _endUtc.AddHours(-leavingSoonHours);
			_charWait = new WaitForSeconds(typeCharInterval);
			if (eventText == null)
			{
				eventText = countdownText;
			}
			if (eventObject != null)
			{
				_eventScale = eventObject.transform.localScale;
				if (_eventScale == Vector3.zero)
				{
					_eventScale = Vector3.one;
				}
				eventObject.SetActive(false);
			}
		}

		private void Update()
		{
			DateTime now = NowUtc;
			Phase phase = ((now < _startUtc) ? Phase.Countdown : ((now < _leavingUtc) ? Phase.Live : ((now < _endUtc) ? Phase.LeavingSoon : Phase.Over)));
			if (phase != _phase)
			{
				EnterPhase(phase);
			}
			if (_phase == Phase.Countdown)
			{
				UpdateCountdown(now);
			}
		}

		private void EnterPhase(Phase phase)
		{
			_phase = phase;
			if (_sequence != null)
			{
				StopCoroutine(_sequence);
				_sequence = null;
			}
			switch (phase)
			{
			case Phase.Countdown:
				_lastShownSecond = long.MinValue;
				if (eventObject != null)
				{
					eventObject.SetActive(false);
				}
				if (countdownText != null)
				{
					countdownText.gameObject.SetActive(true);
				}
				break;
			case Phase.Live:
				HideCountdown();
				ShowEventObject();
				_sequence = StartCoroutine(LiveSequence());
				break;
			case Phase.LeavingSoon:
				HideCountdown();
				ShowEventObject();
				if (eventObject != null)
				{
					eventObject.transform.localScale = _eventScale;
				}
				_sequence = StartCoroutine(Typewriter(leavingMessage));
				break;
			case Phase.Over:
				if (eventText != null)
				{
					eventText.text = string.Empty;
				}
				if (countdownText != null)
				{
					countdownText.text = string.Empty;
				}
				if (eventObject != null)
				{
					eventObject.SetActive(false);
				}
				if (eventRoot != null)
				{
					eventRoot.SetActive(false);
				}
				base.enabled = false;
				break;
			}
		}

		private void UpdateCountdown(DateTime now)
		{
			if (countdownText == null)
			{
				return;
			}
			TimeSpan remaining = _startUtc - now;
			if (remaining < TimeSpan.Zero)
			{
				remaining = TimeSpan.Zero;
			}
			long second = (long)remaining.TotalSeconds;
			if (second != _lastShownSecond)
			{
				_lastShownSecond = second;
				if (remaining.TotalDays >= 1.0)
				{
					countdownText.text = string.Format("{0}{1}d {2:00}:{3:00}:{4:00}", countdownPrefix, (int)remaining.TotalDays, remaining.Hours, remaining.Minutes, remaining.Seconds);
				}
				else
				{
					countdownText.text = string.Format("{0}{1:00}:{2:00}:{3:00}", countdownPrefix, remaining.Hours, remaining.Minutes, remaining.Seconds);
				}
			}
		}

		private void HideCountdown()
		{
			if (!(countdownText == null) && !(countdownText == eventText))
			{
				if (hideCountdownWhenLive)
				{
					countdownText.gameObject.SetActive(false);
				}
				else
				{
					countdownText.text = string.Empty;
				}
			}
		}

		private void ShowEventObject()
		{
			if (eventObject != null)
			{
				eventObject.SetActive(true);
			}
		}

		private IEnumerator LiveSequence()
		{
			yield return ScaleIn();
			yield return Typewriter(happyMessage);
			_sequence = null;
		}

		private IEnumerator ScaleIn()
		{
			if (eventObject == null)
			{
				yield break;
			}
			Transform t = eventObject.transform;
			t.localScale = Vector3.zero;
			for (float e = 0f; e < scaleInDuration; e += Time.deltaTime)
			{
				t.localScale = _eventScale * EaseOutBack(Mathf.Clamp01(e / scaleInDuration));
				yield return null;
			}
			t.localScale = _eventScale;
		}

		private IEnumerator Typewriter(string message)
		{
			if (!(eventText == null))
			{
				eventText.text = message;
				eventText.maxVisibleCharacters = 0;
				for (int i = 1; i <= message.Length; i++)
				{
					eventText.maxVisibleCharacters = i;
					yield return _charWait;
				}
			}
		}

		private static float EaseOutBack(float t)
		{
			t -= 1f;
			return 1f + 2.70158f * t * t * t + 1.70158f * t * t;
		}

		[ContextMenu("TEST: Trigger Event (jump to start)")]
		public void TriggerTestEvent()
		{
			JumpTo(_startUtc, "event start");
		}

		[ContextMenu("TEST: Jump to LEAVING SOON")]
		public void TriggerTestLeavingSoon()
		{
			JumpTo(_leavingUtc, "leaving soon");
		}

		[ContextMenu("TEST: Jump to event END")]
		public void TriggerTestEnd()
		{
			JumpTo(_endUtc, "event end");
		}

		[ContextMenu("TEST: Reset to real time")]
		public void ResetToRealTime()
		{
			base.enabled = true;
			_phase = Phase.None;
			_debugOffset = TimeSpan.Zero;
		}

		private void JumpTo(DateTime targetUtc, string label)
		{
			base.enabled = true;
			_phase = Phase.None;
			_debugOffset = targetUtc - DateTime.UtcNow - TimeSpan.FromSeconds(3.0);
			if (!Application.isPlaying)
			{
				Debug.LogWarning("[FourthOfJulyEvent] Test '" + label + "' armed — enter Play Mode to see it (the event advances in Update, which only runs while playing).");
			}
		}
	}
}
