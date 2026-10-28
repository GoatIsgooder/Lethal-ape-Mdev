using System;
using System.Globalization;
using TMPro;
using UnityEngine;

namespace LethalApeR.UI
{
	public class CountdownTimer : MonoBehaviour
	{
		[Tooltip("The GameObject to disable when the countdown reaches zero.")]
		public GameObject targetObject;

		[Tooltip("Text element to display the countdown.")]
		public TextMeshPro countdownText;

		[Tooltip("Deadline in UTC, ISO 8601 (e.g. 2026-04-11T00:00:00Z).")]
		[SerializeField]
		private string deadlineUtc = "2026-04-11T00:00:00Z";

		[SerializeField]
		private string expiredMessage = "SORRY TIME IS UP";

		private DateTime _deadline;

		private long _shownSecond = long.MinValue;

		private bool _expired;

		private void Awake()
		{
			if (!DateTime.TryParse(deadlineUtc, CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal | DateTimeStyles.AssumeUniversal, out _deadline))
			{
				Debug.LogError("[CountdownTimer] Unreadable deadline '" + deadlineUtc + "' on " + base.name + "; treating it as expired.", this);
				_deadline = DateTime.MinValue;
			}
		}

		private void Update()
		{
			if (_expired)
			{
				return;
			}
			TimeSpan remaining = _deadline - DateTime.UtcNow;
			if (remaining <= TimeSpan.Zero)
			{
				_expired = true;
				if (countdownText != null)
				{
					countdownText.text = expiredMessage;
				}
				if (targetObject != null)
				{
					targetObject.SetActive(false);
				}
				return;
			}
			long num = (long)remaining.TotalSeconds;
			if (num != _shownSecond && !(countdownText == null))
			{
				_shownSecond = num;
				countdownText.text = string.Format("{0}d {1}h {2}m {3}s", remaining.Days, remaining.Hours, remaining.Minutes, remaining.Seconds);
			}
		}
	}
}
