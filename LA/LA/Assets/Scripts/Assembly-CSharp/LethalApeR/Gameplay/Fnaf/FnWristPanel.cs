using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnWristPanel : MonoBehaviour
	{
		public Transform panel;

		public Vector3 localOffset = new Vector3(0f, 0.06f, -0.05f);

		public TMP_Text hourLabel;

		public TMP_Text powerLabel;

		public TMP_Text flashlightLabel;

		public TMP_Text batteryLabel;

		[Tooltip("Scaled along X by the noise level (0..1).")]
		public Transform noiseBar;

		[Tooltip("Text refresh rate (Hz).")]
		public float refreshHz = 5f;

		private float _nextRefresh;

		private int _shownHour = -1;

		private int _shownPower = -1;

		private int _shownLight = -1;

		private int _shownBattery = -1;

		private static readonly string[] Percent = BuildPercent("POWER {0}%");

		private static readonly string[] LightPercent = BuildPercent("LIGHT {0}%");

		private static string[] BuildPercent(string format)
		{
			string[] array = new string[101];
			for (int i = 0; i < 101; i++)
			{
				array[i] = string.Format(format, i);
			}
			return array;
		}

		private void LateUpdate()
		{
			FnNight night = FnNight.Instance;
			bool show = night != null && night.Active && night.LocalIsAlive && night.Phase != FnPhase.Gathering && night.Phase < FnPhase.Dawn;
			if (panel != null && panel.gameObject.activeSelf != show)
			{
				panel.gameObject.SetActive(show);
			}
			if (!show || panel == null)
			{
				return;
			}
			Transform leftHand = FnPlatform.LeftHand;
			Transform head = FnPlatform.Head;
			if (leftHand != null)
			{
				panel.position = leftHand.TransformPoint(localOffset);
				if (head != null)
				{
					Vector3 toHead = head.position - panel.position;
					if (toHead.sqrMagnitude > 1E-06f)
					{
						panel.rotation = Quaternion.LookRotation(-toHead, Vector3.up);
					}
				}
			}
			if (noiseBar != null)
			{
				Vector3 scale = noiseBar.localScale;
				float target = Mathf.Max(0.02f, FnNoiseReporter.Level01);
				scale.x = Mathf.Lerp(scale.x, target, Time.deltaTime * 12f);
				noiseBar.localScale = scale;
			}
			if (Time.unscaledTime < _nextRefresh)
			{
				return;
			}
			_nextRefresh = Time.unscaledTime + 1f / Mathf.Max(1f, refreshHz);
			int hour = night.Hour;
			if (hourLabel != null && hour != _shownHour)
			{
				_shownHour = hour;
				hourLabel.text = FnStrings.Hour(hour);
			}
			int power = Mathf.Clamp(Mathf.CeilToInt(night.Power), 0, 100);
			if (powerLabel != null && power != _shownPower)
			{
				_shownPower = power;
				powerLabel.text = night.Blackout ? "POWER OUT" : Percent[power];
			}
			int light = Mathf.Clamp(Mathf.RoundToInt(FnFlashlight.Charge01 * 100f), 0, 100);
			if (flashlightLabel != null && light != _shownLight)
			{
				_shownLight = light;
				flashlightLabel.text = LightPercent[light];
			}
			int battery = night.BatteryCarriedBy(FnGame.LocalActor);
			if (batteryLabel != null && battery != _shownBattery)
			{
				_shownBattery = battery;
				batteryLabel.text = (battery < 0) ? "-" : "BATTERY";
			}
		}
	}
}
