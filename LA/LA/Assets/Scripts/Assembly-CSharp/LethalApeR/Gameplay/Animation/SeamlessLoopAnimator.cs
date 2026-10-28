using UnityEngine;

namespace LethalApeR.Gameplay.Animation
{
	public class SeamlessLoopAnimator : MonoBehaviour
	{
		[Header("References")]
		public Animator animator;

		[Header("Animator Speed")]
		public float baseAnimSpeed = 1f;

		public float animSpeedSmoothTime = 0.15f;

		[Header("Loop Seam")]
		[Range(0.5f, 0.95f)]
		public float loopCrossFadeThreshold = 0.85f;

		public float loopCrossFadeDuration = 0.15f;

		[Header("Float")]
		public bool enableFloat;

		public float floatAmplitude = 0.08f;

		public float floatSpeed = 1.2f;

		public float floatSmoothTime = 0.1f;

		[Header("Spin")]
		public bool enableSpin;

		public float spinDegreesPerSecond = 30f;

		public float spinSmoothTime = 0.12f;

		private float _animSpeedVel;

		private bool _crossFadeFired;

		private Vector3 _baseLocalPos;

		private float _floatOffset;

		private float _floatVel;

		private float _currentSpinRate;

		private float _spinVel;

		private void OnEnable()
		{
			_baseLocalPos = base.transform.localPosition;
			_crossFadeFired = false;
			_currentSpinRate = 0f;
			_floatOffset = 0f;
		}

		private void Update()
		{
			if (!(animator == null))
			{
				float deltaTime = Time.deltaTime;
				if (!(deltaTime <= 0f))
				{
					animator.speed = Mathf.SmoothDamp(animator.speed, baseAnimSpeed, ref _animSpeedVel, animSpeedSmoothTime);
					if (enableFloat)
					{
						ApplyFloat(deltaTime);
					}
					if (enableSpin)
					{
						ApplySpin(deltaTime);
					}
					HandleLoopSeam();
				}
			}
		}

		private void ApplyFloat(float dt)
		{
			float target = floatAmplitude * Mathf.Sin(Time.time * floatSpeed);
			_floatOffset = Mathf.SmoothDamp(_floatOffset, target, ref _floatVel, floatSmoothTime);
			base.transform.localPosition = new Vector3(_baseLocalPos.x, _floatOffset + _baseLocalPos.y, _baseLocalPos.z);
		}

		private void ApplySpin(float dt)
		{
			_currentSpinRate = Mathf.SmoothDamp(_currentSpinRate, spinDegreesPerSecond, ref _spinVel, spinSmoothTime);
			base.transform.Rotate(Vector3.up, _currentSpinRate * dt, Space.Self);
		}

		private void HandleLoopSeam()
		{
			if (animator.IsInTransition(0))
			{
				return;
			}
			AnimatorStateInfo currentAnimatorStateInfo = animator.GetCurrentAnimatorStateInfo(0);
			if (currentAnimatorStateInfo.loop)
			{
				float num = Mathf.Repeat(currentAnimatorStateInfo.normalizedTime, 1f);
				if (!_crossFadeFired && num >= loopCrossFadeThreshold)
				{
					_crossFadeFired = true;
					animator.CrossFadeInFixedTime(currentAnimatorStateInfo.fullPathHash, loopCrossFadeDuration, 0, 0f);
				}
				else if (num < loopCrossFadeThreshold)
				{
					_crossFadeFired = false;
				}
			}
		}

		private void OnDisable()
		{
			base.transform.localPosition = _baseLocalPos;
		}
	}
}
