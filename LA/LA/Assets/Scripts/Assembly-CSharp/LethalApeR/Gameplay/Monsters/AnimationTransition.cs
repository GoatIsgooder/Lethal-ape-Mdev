using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public class AnimationTransition : MonoBehaviourPun
	{
		public BaseMonster ai;

		public Animator animator;

		public bool isRunning;

		public float transitionSpeed = 2f;

		public string transitionParameter = "Blend";

		private float blend;

		private void Update()
		{
			if (ai != null)
			{
				isRunning = ai.canSeePlayer;
			}
			float target = (isRunning ? 1f : 0f);
			blend = Mathf.MoveTowards(blend, target, transitionSpeed * Time.deltaTime);
			animator.SetFloat(transitionParameter, blend);
		}
	}
}
