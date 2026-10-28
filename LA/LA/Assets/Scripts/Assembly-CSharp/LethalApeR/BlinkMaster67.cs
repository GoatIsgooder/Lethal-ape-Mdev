using UnityEngine;

namespace LethalApeR
{
	public class BlinkMaster67 : MonoBehaviour
	{
		public SkinnedMeshRenderer thisSmr;

		public float minBlinkDelay;

		public float maxBlinkDelay;

		public float blinkDuration;

		public AnimationCurve blinkCurve;

		private const int EyelidShape = 0;

		private float _nextBlink = -1f;

		private float _blinkStart = -1f;

		private float _lid = -1f;

		private void OnEnable()
		{
			if (_nextBlink < 0f)
			{
				WriteLid(0f);
				ScheduleNext();
			}
		}

		private void OnDisable()
		{
			if (!base.gameObject.activeInHierarchy)
			{
				_nextBlink = -1f;
				_blinkStart = -1f;
				WriteLid(0f);
			}
		}

		public void ResetForPool()
		{
			_nextBlink = -1f;
			_blinkStart = -1f;
			WriteLid(0f);
		}

		private void Update()
		{
			if (thisSmr == null)
			{
				return;
			}
			float time = Time.time;
			if (_blinkStart < 0f)
			{
				if (time < _nextBlink)
				{
					return;
				}
				if (!thisSmr.isVisible)
				{
					ScheduleNext();
					return;
				}
				_blinkStart = time;
			}
			float num = time - _blinkStart;
			if (num < blinkDuration)
			{
				float num2 = blinkDuration * 0.5f;
				if (num2 > 0f)
				{
					float value = ((num < num2) ? (num / num2) : (1f - (num - num2) / num2));
					WriteLid(blinkCurve.Evaluate(Mathf.Clamp01(value)) * 100f);
					return;
				}
			}
			WriteLid(0f);
			_blinkStart = -1f;
			ScheduleNext();
		}

		private void ScheduleNext()
		{
			_nextBlink = Time.time + Random.Range(minBlinkDelay, maxBlinkDelay);
		}

		private void WriteLid(float weight)
		{
			if (!(thisSmr == null) && _lid != weight)
			{
				_lid = weight;
				thisSmr.SetBlendShapeWeight(0, weight);
			}
		}
	}
}
