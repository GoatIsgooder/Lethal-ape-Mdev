using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	public class AgLaunchDriver : MonoBehaviour
	{
		private const float AssertSeconds = 0.3f;

		private const float TeleportDetectSqr = 25f;

		private Player _player;

		private Vector3 _launchVelocity;

		private Vector3 _lastPosition;

		private float _launchTime;

		private bool _active;

		public void Begin(Player player, Vector3 velocity)
		{
			_player = player;
			_launchVelocity = velocity;
			_launchTime = Time.time;
			_lastPosition = player.transform.position;
			_active = true;
			base.enabled = true;
			player.SetMaximumSlipThisFrame();
			player.wasLeftHandTouching = false;
			player.wasRightHandTouching = false;
			player.wasLeftHandSlide = false;
			player.wasRightHandSlide = false;
			player.playerRigidBody.linearVelocity = velocity;
		}

		private void LateUpdate()
		{
			if (!_active)
			{
				base.enabled = false;
				return;
			}
			if (_player == null || _player.playerRigidBody == null || _player.playerRigidBody.isKinematic || _player.disableMovement)
			{
				Stop();
				return;
			}
			Vector3 position = _player.transform.position;
			if ((position - _lastPosition).sqrMagnitude > 25f)
			{
				Stop();
				return;
			}
			_lastPosition = position;
			float num = Time.time - _launchTime;
			if (num >= 0.3f)
			{
				Stop();
			}
			else
			{
				_player.playerRigidBody.linearVelocity = _launchVelocity + Physics.gravity * num;
			}
		}

		private void Stop()
		{
			_active = false;
			base.enabled = false;
		}
	}
}
