using System.Reflection;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgCountdownBoard : MonoBehaviour
	{
		[SerializeField]
		private TMP_Text label;

		[SerializeField]
		private string untimedText = "LAST APE STANDING";

		[SerializeField]
		private Color lowTimeColor = new Color(1f, 0.16f, 0.28f, 1f);

		[SerializeField]
		private float lowTimeSeconds = 10f;

		[Header("Last-seconds punch (optional)")]
		[SerializeField]
		private AudioSource tickSfx;

		[SerializeField]
		private float punchScale = 1.18f;

		[SerializeField]
		private float punchSeconds = 0.16f;

		private const int SecsUntimed = -2;

		private const int SecsHidden = -1;

		private Color _baseColor;

		private Vector3 _baseScale;

		private Transform _labelTransform;

		private float _punchUntil;

		private AgPhase _lastPhase = (AgPhase)255;

		private int _lastRound = -1;

		private int _lastSecs = int.MinValue;

		private static int _clockSecs = int.MinValue;

		private static string _clockText = string.Empty;

		private void Awake()
		{
			if (label == null)
			{
				label = GetComponent<TMP_Text>();
			}
			if (label == null)
			{
				Debug.LogError("[AgCountdownBoard] no TMP_Text assigned or on this GameObject, disabled.", this);
				base.enabled = false;
			}
			else
			{
				_baseColor = label.color;
				_labelTransform = label.transform;
				_baseScale = _labelTransform.localScale;
			}
		}

		private void Update()
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			AgRoundProperties agRoundProperties = ((instance != null) ? instance.Props : null);
			if (agRoundProperties != null && agRoundProperties.queue == "ApeGames" && PhotonNetwork.InRoom)
			{
				double remaining = AgProps.GetRemaining(agRoundProperties);
				int secs = (double.IsInfinity(remaining) ? (-2) : Mathf.Max(0, Mathf.CeilToInt((float)remaining)));
				Show(agRoundProperties.phase, agRoundProperties.round, secs);
			}
			else
			{
				Show(AgPhase.Idle, -1, -1);
			}
			TickPunch();
		}

		private void Show(AgPhase phase, int round, int secs)
		{
			if (phase != _lastPhase || round != _lastRound || secs != _lastSecs)
			{
				int lastSecs = _lastSecs;
				_lastPhase = phase;
				_lastRound = round;
				_lastSecs = secs;
				bool flag = phase == AgPhase.Round && secs >= 0 && (float)secs <= lowTimeSeconds;
				label.color = (flag ? lowTimeColor : _baseColor);
				label.text = ((phase != AgPhase.Round) ? string.Empty : ((secs == -2) ? untimedText : Clock(secs)));
				if (flag && secs < lastSecs)
				{
					_punchUntil = Time.unscaledTime + punchSeconds;
					if (tickSfx != null)
					{
						tickSfx.Play();
					}
				}
			}
		}

		private void TickPunch()
		{
			if (_labelTransform == null || _punchUntil <= 0f)
			{
				return;
			}
			float num = _punchUntil - Time.unscaledTime;
			if (num <= 0f)
			{
				_punchUntil = 0f;
				_labelTransform.localScale = _baseScale;
				return;
			}
			float t = ((punchSeconds > 0f) ? (num / punchSeconds) : 0f);
			_labelTransform.localScale = _baseScale * Mathf.Lerp(1f, punchScale, t);
		}

		private static string Clock(int secs)
		{
			secs = Mathf.Max(0, secs);
			if (secs == _clockSecs)
			{
				return _clockText;
			}
			_clockSecs = secs;
			_clockText = (secs / 60).ToString() + ":" + (secs % 60).ToString("00");
			return _clockText;
		}
	}
}
