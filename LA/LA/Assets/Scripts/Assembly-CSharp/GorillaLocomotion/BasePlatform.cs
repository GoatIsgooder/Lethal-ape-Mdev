using UnityEngine;

namespace GorillaLocomotion
{
	public class BasePlatform : MonoBehaviour
	{
		public static int ActiveCount { get; private set; }

		private void OnEnable()
		{
			ActiveCount++;
		}

		private void OnDisable()
		{
			ActiveCount--;
		}
	}
}
