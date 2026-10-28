using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[RequireComponent(typeof(Collider))]
	public class EscapeDoorTrigger : MonoBehaviour
	{
		private bool _fired;

		private void OnEnable()
		{
			BackroomsEvents.OnStateChanged += OnStateChanged;
		}

		private void OnDisable()
		{
			BackroomsEvents.OnStateChanged -= OnStateChanged;
		}

		private void OnStateChanged(BackroomsState s)
		{
			if (s != BackroomsState.Powering)
			{
				_fired = false;
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (_fired)
			{
				return;
			}
			BackroomsGamemodeManager instance = BackroomsGamemodeManager.Instance;
			if (instance == null || instance.State != BackroomsState.Powering)
			{
				return;
			}
			Player player = Player.HasInstance ? Player.Instance : null;
			if (player == null)
			{
				return;
			}
			if ((player.headCollider != null && other.transform == player.headCollider.transform) || other.GetComponentInParent<Player>() == player)
			{
				_fired = true;
				instance.MasterBeginEscape();
			}
		}
	}
}
