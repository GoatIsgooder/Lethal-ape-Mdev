using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnTitleCard : MonoBehaviour
	{
		public Transform card;

		public TMP_Text label;

		public CanvasGroup group;

		public float distance = 1.3f;

		public float holdSeconds = 1.8f;

		public float fadeSeconds = 0.35f;

		private float _startedAt = -100f;

		private float _total;

		private void OnEnable()
		{
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.PhaseChanged += OnPhase;
			}
			SetVisible(false);
		}

		private void OnDisable()
		{
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.PhaseChanged -= OnPhase;
			}
		}

		private void OnPhase(FnPhase phase)
		{
			FnNight instance = FnNight.Instance;
			if (instance == null)
			{
				return;
			}
			if (phase == FnPhase.Dawn)
			{
				Play("6 AM");
			}
			else if (phase == FnPhase.Briefing)
			{
				Play(FnStrings.NightTitle(instance.NightNumber, instance.Difficulty) + "\n12 AM");
			}
		}

		public void Play(string text)
		{
			if (label != null)
			{
				label.text = text;
			}
			_startedAt = Time.unscaledTime;
			_total = Mathf.Min(holdSeconds + fadeSeconds * 2f, 2.5f);
			SetVisible(true);
			Place(1f);
		}

		private void SetVisible(bool on)
		{
			if (card != null && card.gameObject.activeSelf != on)
			{
				card.gameObject.SetActive(on);
			}
		}

		private void Place(float follow)
		{
			Transform head = FnPlatform.Head;
			if (head == null || card == null)
			{
				return;
			}
			Vector3 target = head.position + head.forward * distance;
			card.position = Vector3.Lerp(card.position, target, follow);
			Vector3 toHead = head.position - card.position;
			if (toHead.sqrMagnitude > 1E-06f)
			{
				card.rotation = Quaternion.LookRotation(-toHead, Vector3.up);
			}
		}

		private void LateUpdate()
		{
			float elapsed = Time.unscaledTime - _startedAt;
			if (elapsed > _total)
			{
				SetVisible(false);
				return;
			}
			Place(1f - Mathf.Exp(-6f * Time.unscaledDeltaTime));
			if (!(group == null))
			{
				float fadeIn = Mathf.Clamp01(elapsed / fadeSeconds);
				float fadeOut = Mathf.Clamp01((_total - elapsed) / fadeSeconds);
				group.alpha = Mathf.Min(fadeIn, fadeOut);
			}
		}
	}
}
