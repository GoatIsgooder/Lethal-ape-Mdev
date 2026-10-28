using GorillaLocomotion;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR
{
	public class DistanceEvent : MonoBehaviour
	{
		public float distance = 5f;

		public UnityEvent onDistanceReached;

		public UnityEvent onDistanceNotreached;

		private void Start()
		{
			InvokeRepeating("CheckDistance", 1f, 0.5f);
		}

		private void CheckDistance()
		{
			if (Vector3.Distance(base.transform.position, Player.Instance.headCollider.transform.position) <= distance)
			{
				onDistanceReached?.Invoke();
			}
			else
			{
				onDistanceNotreached?.Invoke();
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = Color.cyan;
			Gizmos.DrawWireSphere(base.transform.position, distance);
			Gizmos.color = Color.yellow;
			Gizmos.DrawLine(base.transform.position, Player.Instance.headCollider.transform.position);
		}
	}
}
