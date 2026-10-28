using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms.Ragdoll
{
	public class RagdollDeathCam : MonoBehaviour
	{
		[Tooltip("Follow smoothing toward the camera pose.")]
		public float followSpeed = 6f;

		[Tooltip("Metres above the corpse the camera floats.")]
		public float height = 2f;

		[Tooltip("Metres back from the corpse (so it looks down at an angle, not straight down).")]
		public float back = 1.8f;

		private PlayerRagdoll _ragdoll;

		private bool _active;

		private bool _released;

		private Vector3 _backDir = Vector3.forward;

		public void SetActiveForOwner(bool isOwner, PlayerRagdoll ragdoll)
		{
			if (!isOwner)
			{
				enabled = false;
				return;
			}
			_ragdoll = ragdoll;
			_active = true;
			_released = false;
			GorillaLocomotion.Player player = GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null;
			if (player != null)
			{
				if (player.playerRigidBody != null)
				{
					player.playerRigidBody.isKinematic = true;
				}
				player.disableMovement = true;
				Vector3 forward = player.transform.forward;
				forward.y = 0f;
				if (forward.sqrMagnitude > 0.0001f)
				{
					_backDir = -forward.normalized;
				}
			}
			Debug.Log("[RagdollDeathCam] activated — framing the corpse.");
		}

		private void LateUpdate()
		{
			Vector3 look = default(Vector3);
			if (!_active)
			{
				return;
			}
			GorillaLocomotion.Player player = GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null;
			if (player == null || player.headCollider == null)
			{
				return;
			}
			player.disableMovement = true;
			Transform target = (_ragdoll != null) ? ((_ragdoll.lowerTorso != null) ? _ragdoll.lowerTorso : ((_ragdoll.head != null) ? _ragdoll.head : _ragdoll.transform)) : null;
			if (target == null)
			{
				return;
			}
			Vector3 corpse = target.position;
			if (!IsFinite(corpse))
			{
				return;
			}
			Vector3 desired = corpse + Vector3.up * height + _backDir * back;
			Vector3 delta = desired - player.headCollider.transform.position;
			float t = 1f - Mathf.Exp(-followSpeed * Time.deltaTime);
			if (delta.sqrMagnitude <= 2500f)
			{
				player.transform.position = Vector3.Lerp(player.transform.position, player.transform.position + delta, t);
			}
			look = corpse - desired;
			if (look.sqrMagnitude > 0.0001f)
			{
				Quaternion b = Quaternion.LookRotation(look.normalized, Vector3.up);
				player.transform.rotation = Quaternion.Slerp(player.transform.rotation, b, t);
			}
		}

		private static bool IsFinite(Vector3 v)
		{
			if (!float.IsNaN(v.x) && !float.IsNaN(v.y) && !float.IsNaN(v.z) && !float.IsInfinity(v.x) && !float.IsInfinity(v.y))
			{
				return !float.IsInfinity(v.z);
			}
			return false;
		}

		public void ReleaseForDeath()
		{
			if (!_released)
			{
				_active = false;
				_released = true;
				RestoreRig(false);
			}
		}

		public void Deactivate()
		{
			if (!_released)
			{
				_active = false;
				_released = true;
				RestoreRig(true);
			}
		}

		private void RestoreRig(bool teleportToCorpse)
		{
			GorillaLocomotion.Player player = GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null;
			if (player == null)
			{
				return;
			}
			if (teleportToCorpse && _ragdoll != null)
			{
				Transform target = (_ragdoll.lowerTorso != null) ? _ragdoll.lowerTorso : _ragdoll.transform;
				player.TeleportPlayerRaw(target.position, Quaternion.identity, false, true);
			}
			float y = player.transform.eulerAngles.y;
			player.transform.rotation = Quaternion.Euler(0f, y, 0f);
			if (player.playerRigidBody != null)
			{
				player.playerRigidBody.isKinematic = false;
			}
			player.disableMovement = false;
			Debug.Log("[RagdollDeathCam] restored rig (upright, unfrozen).");
		}

		private void OnDisable()
		{
			if (_active && !_released)
			{
				_active = false;
				_released = true;
				RestoreRig(true);
			}
		}
	}
}
