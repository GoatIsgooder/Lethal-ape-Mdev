using UnityEngine;

namespace GorillaLocomotion
{
	public readonly struct TravelProfile
	{
		public readonly float Distance;

		public readonly float Duration;

		private readonly float _accel;

		private readonly float _peak;

		private readonly float _rampTime;

		public TravelProfile(float distance, float maxSpeed, float acceleration)
		{
			Distance = Mathf.Max(0f, distance);
			_accel = Mathf.Max(0.01f, acceleration);
			float peak = Mathf.Max(0.01f, maxSpeed);
			if (Distance * _accel < peak * peak)
			{
				_rampTime = Mathf.Sqrt(Distance / _accel);
				_peak = _accel * _rampTime;
				Duration = 2f * _rampTime;
			}
			else
			{
				_rampTime = peak / _accel;
				_peak = peak;
				Duration = 2f * _rampTime + (Distance - peak * _rampTime) / peak;
			}
		}

		public float DistanceAt(float t)
		{
			if (t <= 0f)
			{
				return 0f;
			}
			if (t >= Duration)
			{
				return Distance;
			}
			float halfAccel = 0.5f * _accel;
			if (t < _rampTime)
			{
				return halfAccel * t * t;
			}
			if (t > Duration - _rampTime)
			{
				float remaining = Duration - t;
				return Distance - remaining * (remaining * halfAccel);
			}
			return _rampTime * (_rampTime * halfAccel) + (t - _rampTime) * _peak;
		}

		public float SpeedAt(float t)
		{
			if (t <= 0f || t >= Duration)
			{
				return 0f;
			}
			if (t < _rampTime)
			{
				return _accel * t;
			}
			if (t > Duration - _rampTime)
			{
				return (Duration - t) * _accel;
			}
			return _peak;
		}
	}
}
