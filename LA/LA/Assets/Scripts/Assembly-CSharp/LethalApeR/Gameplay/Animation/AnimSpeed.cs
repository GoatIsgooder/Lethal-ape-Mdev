using UnityEngine;

namespace LethalApeR.Gameplay.Animation
{
	public class AnimSpeed : MonoBehaviour
	{
		public float speedMultiplier = 1f;

		public Animator animator;

		private Vector3 previousPosition;

		private void Start()
		{
			previousPosition = base.transform.position;
		}

		private void Update()
		{
			Vector3 position = base.transform.position;
			float num = Vector3.Distance(position, previousPosition) / Time.deltaTime;
			animator.speed = num * speedMultiplier;
			previousPosition = position;
		}
	}
}
