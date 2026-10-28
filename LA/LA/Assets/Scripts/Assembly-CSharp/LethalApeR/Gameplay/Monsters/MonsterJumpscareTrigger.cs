using GorillaLocomotion;
using LethalApeR.Networking;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Gameplay.Monsters
{
	[RequireComponent(typeof(Collider))]
	public class MonsterJumpscareTrigger : MonoBehaviour
	{
		[Tooltip("The monster whose jumpscare fires when a player enters this trigger.")]
		public BaseMonster monster;

		[Tooltip("If true, the trigger only fires when the monster currently has line-of-sight on a player (canSeePlayer == true). If false, walking into the volume scares regardless of sight — handy for ambush boxes around corners.")]
		public bool requireSight;

		[Tooltip("Optional UnityEvent fired AFTER TryJumpscare is invoked. Receives the entering collider so wired methods can react.")]
		public UnityEvent<Collider> onPlayerEntered;

		private void Reset()
		{
			Collider col = GetComponent<Collider>();
			if ((bool)col)
			{
				col.isTrigger = true;
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (monster == null || (!other.CompareTag("HandTag") && !other.CompareTag("ChaseTag")))
			{
				return;
			}
			Transform victim = ResolveVictim(other);
			if (!(victim == null) && (!requireSight || monster.canSeePlayer))
			{
				monster.TryJumpscare(victim);
				onPlayerEntered?.Invoke(other);
			}
		}

		private static Transform ResolveVictim(Collider other)
		{
			MonkeDevNetworkingPlayer networkPlayer = other.GetComponentInParent<MonkeDevNetworkingPlayer>();
			if (networkPlayer != null)
			{
				if (!(networkPlayer.Head != null))
				{
					return networkPlayer.transform;
				}
				return networkPlayer.Head;
			}
			Player localPlayer = other.GetComponentInParent<Player>();
			if (localPlayer != null)
			{
				if (!(localPlayer.headCollider != null))
				{
					return localPlayer.transform;
				}
				return localPlayer.headCollider.transform;
			}
			return null;
		}
	}
}
