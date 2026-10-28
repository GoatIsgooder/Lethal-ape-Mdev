using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	public class BackroomsReviveInteractor : MonoBehaviour
	{
		[SerializeField]
		private BackroomsConfig config;

		[Tooltip("Grip value (0..1) that counts as 'holding to revive'.")]
		[SerializeField]
		private float gripThreshold = 0.7f;

		private float _hold;

		private int _target = -1;

		private float _nextAllowed;

		private float _lastProgressSent = -1f;

		private void Update()
		{
			BackroomsDownedManager dm = BackroomsDownedManager.Instance;
			if (dm == null || Player.Instance == null || Player.Instance.headCollider == null)
			{
				PushProgress(0f);
				return;
			}
			if (dm.IsLocalDownedOrDead() || Time.time < _nextAllowed)
			{
				ResetHold();
				return;
			}
			float dist;
			int idx = FindNearestDownedInRange(dm, Player.Instance.headCollider.transform.position, out dist);
			bool grip = VRInputController.Instance != null && (VRInputController.Instance.LeftGripValue > gripThreshold || VRInputController.Instance.RightGripValue > gripThreshold);
			if (idx < 0 || !grip)
			{
				ResetHold();
				return;
			}
			if (idx != _target)
			{
				_target = idx;
				_hold = 0f;
			}
			_hold += Time.deltaTime;
			float need = ((config != null) ? Mathf.Max(config.reviveHoldSeconds, 0.1f) : 3f);
			PushProgress(Mathf.Clamp01(_hold / need));
			if (_hold >= need)
			{
				dm.RequestRevive(idx);
				_hold = 0f;
				_nextAllowed = Time.time + 1f;
				PushProgress(0f);
			}
		}

		private int FindNearestDownedInRange(BackroomsDownedManager dm, Vector3 from, out float dist)
		{
			dist = float.MaxValue;
			float range = ((config != null) ? config.reviveRange : 1.6f);
			float bestSqr = range * range;
			int best = -1;
			foreach (int actor in dm.DownedActors)
			{
				Transform head = dm.ResolveAvatarHead(actor);
				if (!(head == null))
				{
					float sqr = (head.position - from).sqrMagnitude;
					if (sqr < bestSqr)
					{
						bestSqr = sqr;
						dist = Mathf.Sqrt(sqr);
						best = actor;
					}
				}
			}
			return best;
		}

		private void ResetHold()
		{
			_hold = 0f;
			_target = -1;
			PushProgress(0f);
		}

		private void PushProgress(float t)
		{
			if (!(Mathf.Abs(t - _lastProgressSent) < 0.001f))
			{
				_lastProgressSent = t;
				BackroomsEvents.RaiseLocalReviveProgress(t);
			}
		}
	}
}
