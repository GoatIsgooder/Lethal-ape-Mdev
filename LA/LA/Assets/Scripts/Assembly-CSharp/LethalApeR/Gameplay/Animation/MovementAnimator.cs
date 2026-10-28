using UnityEngine;

namespace LethalApeR.Gameplay.Animation
{
	public class MovementAnimator : MonoBehaviour
	{
		[Header("References")]
		[Tooltip("GameObject whose movement speed drives the animation. Defaults to this transform.")]
		public Transform target;

		public Animator animator;

		[Header("Blend")]
		public string blendParameter = "Blend";

		[Tooltip("At or below this speed the blend value is 0.")]
		public float walkSpeed = 1f;

		[Tooltip("At or above this speed the blend value is 1.")]
		public float runSpeed = 3f;

		[Tooltip("How quickly the blend value lerps toward its target (units per second).")]
		public float blendSmoothing = 5f;

		[Header("Animator Speed")]
		[Tooltip("Animator playback speed when the target is stationary.")]
		public float baseAnimSpeed = 0.5f;

		[Tooltip("Extra animator playback speed added per world unit/sec of movement.")]
		public float animSpeedPerUnit = 0.2f;

		private Vector3 _lastPos;

		private float _currentBlend;

		private void OnEnable()
		{
			if (target == null)
			{
				target = base.transform;
			}
			_lastPos = target.position;
		}

		private void Update()
		{
			if (!(target == null) && !(animator == null))
			{
				float deltaTime = Time.deltaTime;
				if (!(deltaTime <= 0f))
				{
					float num = Vector3.Distance(target.position, _lastPos) / deltaTime;
					_lastPos = target.position;
					float target2 = Mathf.InverseLerp(walkSpeed, runSpeed, num);
					_currentBlend = Mathf.MoveTowards(_currentBlend, target2, blendSmoothing * deltaTime);
					animator.SetFloat(blendParameter, _currentBlend);
					animator.speed = baseAnimSpeed + num * animSpeedPerUnit;
				}
			}
		}
	}
}
