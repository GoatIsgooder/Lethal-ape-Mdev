using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnOfficeDisplay : MonoBehaviour
	{
		public TMP_Text clock;

		public TMP_Text power;

		public TMP_Text nightLabel;

		[Tooltip("Usage bars, lit left to right: base drain + one per door, hall light and guard on the cameras.")]
		public Renderer[] usageBars = new Renderer[5];

		public Color barOff = new Color(0.08f, 0.08f, 0.08f, 1f);

		public Color barLow = new Color(0.25f, 1f, 0.35f, 1f);

		public Color barMid = new Color(1f, 0.85f, 0.2f, 1f);

		public Color barHigh = new Color(1f, 0.2f, 0.12f, 1f);

		public float refreshHz = 4f;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private static readonly string[] Percent = BuildPercent();

		private MaterialPropertyBlock _mpb;

		private float _nextRefresh;

		private int _shownHour = -1;

		private int _shownPower = -1;

		private int _shownBars = -1;

		private int _shownNight = -1;

		private FnDifficulty _shownDifficulty;

		private bool _shownBlackout;

		private static string[] BuildPercent()
		{
			string[] array = new string[101];
			for (int i = 0; i <= 100; i++)
			{
				array[i] = string.Format("POWER {0}%", i);
			}
			return array;
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.Active || Time.unscaledTime < _nextRefresh)
			{
				return;
			}
			_nextRefresh = Time.unscaledTime + 1f / Mathf.Max(1f, refreshHz);
			if (nightLabel != null && (instance.NightNumber != _shownNight || instance.Difficulty != _shownDifficulty))
			{
				_shownNight = instance.NightNumber;
				_shownDifficulty = instance.Difficulty;
				nightLabel.text = FnStrings.NightTitle(_shownNight, _shownDifficulty);
			}
			int hour = instance.Hour;
			if (clock != null && hour != _shownHour)
			{
				_shownHour = hour;
				clock.text = FnStrings.Hour(hour);
			}
			int num = Mathf.Clamp(Mathf.CeilToInt(instance.Power), 0, 100);
			if (power != null && (num != _shownPower || instance.Blackout != _shownBlackout))
			{
				_shownPower = num;
				_shownBlackout = instance.Blackout;
				power.text = (instance.Blackout ? "POWER OUT" : Percent[num]);
			}
			int num2 = ((!instance.Blackout) ? Mathf.Clamp(instance.UsageUnits + 1, 1, usageBars.Length) : 0);
			if (num2 == _shownBars)
			{
				return;
			}
			_shownBars = num2;
			for (int i = 0; i < usageBars.Length; i++)
			{
				if (!(usageBars[i] == null))
				{
					Color value = ((i >= num2) ? barOff : ((num2 > 3) ? barHigh : ((num2 == 3) ? barMid : barLow)));
					if (_mpb == null)
					{
						_mpb = new MaterialPropertyBlock();
					}
					usageBars[i].GetPropertyBlock(_mpb);
					_mpb.SetColor(ColorId, value);
					_mpb.SetColor(BaseColorId, value);
					_mpb.SetColor(EmissionId, value);
					usageBars[i].SetPropertyBlock(_mpb);
				}
			}
		}
	}
}
