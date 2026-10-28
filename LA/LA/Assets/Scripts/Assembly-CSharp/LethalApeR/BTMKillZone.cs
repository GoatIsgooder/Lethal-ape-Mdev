using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR
{
	public class BTMKillZone : MonoBehaviour
	{
		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("MainCamera") && !BtmGhost.ReturnLocalToMap())
			{
				BTMGameManager.Instance.HandleSuicide();
			}
		}
	}
}
