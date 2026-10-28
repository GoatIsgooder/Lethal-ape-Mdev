using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	public static class AgLauncher
	{
		public static void Launch(Vector3 velocity)
		{
			if (velocity.sqrMagnitude < 0.0001f || !Player.HasInstance)
			{
				return;
			}
			Player instance = Player.Instance;
			if (!(instance == null) && !(instance.playerRigidBody == null) && !instance.playerRigidBody.isKinematic && !instance.disableMovement)
			{
				AgLaunchDriver agLaunchDriver = instance.GetComponent<AgLaunchDriver>();
				if (agLaunchDriver == null)
				{
					agLaunchDriver = instance.gameObject.AddComponent<AgLaunchDriver>();
				}
				agLaunchDriver.Begin(instance, velocity);
			}
		}

		public static void Push(Vector3 velocity, float seconds)
		{
		}
	}
}
