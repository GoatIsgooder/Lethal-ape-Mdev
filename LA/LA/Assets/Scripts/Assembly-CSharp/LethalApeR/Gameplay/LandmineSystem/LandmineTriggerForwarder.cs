using UnityEngine;

namespace LethalApeR.Gameplay.LandmineSystem
{
	public class LandmineTriggerForwarder : MonoBehaviour
	{
		[HideInInspector]
		public Landmine target;

		private void OnTriggerEnter(Collider other)
		{
			if (target != null)
			{
				target.NotifyTriggerEnter(other);
			}
		}
	}
}
