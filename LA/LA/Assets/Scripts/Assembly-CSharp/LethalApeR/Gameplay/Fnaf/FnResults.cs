using System.Text;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnResults : MonoBehaviour
	{
		public Transform panel;

		public TMP_Text title;

		public TMP_Text body;

		public float distance = 1.4f;

		public float heightOffset = -0.1f;

		private readonly StringBuilder _sb = new StringBuilder(256);

		private bool _shown;

		private void OnEnable()
		{
			if (FnNight.Instance != null)
			{
				FnNight.Instance.PhaseChanged += OnPhase;
			}
			Hide();
		}

		private void OnDisable()
		{
			if (FnNight.Instance != null)
			{
				FnNight.Instance.PhaseChanged -= OnPhase;
			}
		}

		private void OnPhase(FnPhase phase)
		{
			if (phase == FnPhase.Results)
			{
				Show();
			}
			else if (phase <= FnPhase.Night)
			{
				Hide();
			}
		}

		private void Hide()
		{
			_shown = false;
			if (panel != null && panel.gameObject.activeSelf)
			{
				panel.gameObject.SetActive(false);
			}
		}

		private void Show()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || panel == null)
			{
				return;
			}
			_shown = true;
			Transform head = FnPlatform.Head;
			if (head != null)
			{
				Vector3 forward = head.forward;
				forward.y = 0f;
				if (forward.sqrMagnitude < 0.0001f)
				{
					forward = Vector3.forward;
				}
				forward = forward.normalized;
				panel.position = head.position + forward * distance + Vector3.up * heightOffset;
				panel.rotation = Quaternion.LookRotation(forward);
			}
			panel.gameObject.SetActive(true);
			byte outcome = instance.Outcome;
			if (title != null)
			{
				title.text = ((outcome == 1) ? "YOU SURVIVED" : "THE SHIFT IS OVER");
			}
			if (body == null)
			{
				return;
			}
			FnDifficulty difficulty = instance.Difficulty;
			_sb.Length = 0;
			_sb.AppendFormat((difficulty == FnDifficulty.Nightmare) ? "NIGHTMARE {0}" : "NIGHT {0}", instance.NightNumber).Append('\n');
			float seconds = instance.HourSeconds * 6f;
			for (int i = 0; i < instance.GuardSlots; i++)
			{
				FnGuardStatus fnGuardStatus = instance.GuardStatus(i);
				if (fnGuardStatus == FnGuardStatus.Absent)
				{
					continue;
				}
				string text = instance.GuardName(i);
				string text2 = instance.GuardBuild(i);
				_sb.Append(string.IsNullOrEmpty(text) ? "GUARD" : text);
				if (!string.IsNullOrEmpty(text2))
				{
					_sb.Append(" [").Append(text2).Append(']');
				}
				_sb.Append("  ");
				switch (fnGuardStatus)
				{
				case FnGuardStatus.Alive:
					_sb.Append("SURVIVED");
					AppendTime(seconds);
					break;
				case FnGuardStatus.Caught:
					_sb.Append("CAUGHT");
					AppendTime(SurvivedSeconds(instance, i));
					break;
				case FnGuardStatus.Left:
					_sb.Append("LEFT");
					AppendTime(SurvivedSeconds(instance, i));
					break;
				}
				_sb.Append('\n');
			}
			_sb.AppendFormat("POWER LEFT {0}%", Mathf.CeilToInt(instance.Power)).Append('\n');
			_sb.AppendFormat("BATTERIES {0}", instance.BatteriesDelivered);
			if (instance.LocalUnlockedNight >= 1)
			{
				_sb.Append('\n').AppendFormat((difficulty == FnDifficulty.Nightmare) ? "NIGHTMARE {0} UNLOCKED" : "NIGHT {0} UNLOCKED", instance.LocalUnlockedNight);
			}
			if (instance.LocalUnlockedNightmare)
			{
				_sb.Append('\n').Append("NIGHTMARE UNLOCKED");
			}
			body.text = _sb.ToString();
		}

		private static float SurvivedSeconds(FnNight night, int slot)
		{
			double num = night.GuardTime(slot);
			if (num <= 0.0 || night.NightStart <= 0.0)
			{
				return 0f;
			}
			double num2 = num - night.NightStart;
			if (num2 < 0.0)
			{
				num2 += 4294967.296;
			}
			return (float)num2;
		}

		private void AppendTime(float seconds)
		{
			int num = Mathf.Max(0, Mathf.RoundToInt(seconds));
			_sb.Append("  ").AppendFormat("{0}:{1:00}", num / 60, num % 60);
		}

		private void LateUpdate()
		{
			if (_shown)
			{
				FnNight instance = FnNight.Instance;
				if (instance == null || !instance.Active)
				{
					Hide();
				}
			}
		}
	}
}
