using System.Collections;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public class DelayedDestroy : MonoBehaviour
	{
		public float destroyTime = 2f;

		private IEnumerator Start()
		{
			yield return new WaitForSeconds(destroyTime);
			Object.Destroy(base.gameObject);
		}
	}
}
