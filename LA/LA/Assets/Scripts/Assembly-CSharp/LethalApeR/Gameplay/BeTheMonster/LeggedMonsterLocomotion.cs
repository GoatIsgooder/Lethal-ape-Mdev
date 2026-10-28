using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class LeggedMonsterLocomotion : IMonsterLocomotion
	{
		private Player _player;

		private BtmConfig _cfg;

		private MonsterDefinition _def;

		private Transform _head;

		private Vector3 _planarVel;

		private float _crouch;

		private float _lean;

		private bool _snapArmed = true;

		private TurnController.TurnMode _savedTurnMode = TurnController.TurnMode.Snap;

		public MonsterLocomotionType Type => MonsterLocomotionType.Legged;

		public Vector3 PlanarVelocity => _planarVel;

		public float CrouchAmount => _crouch;

		public float LeanAngle => _lean;

		public void Activate(MonsterDefinition def, BtmConfig cfg, Player player)
		{
			_def = def;
			_cfg = cfg;
			_player = player;
			_head = ResolveHead(player);
			_planarVel = Vector3.zero;
			_crouch = 0f;
			_lean = 0f;
			_snapArmed = true;
			_savedTurnMode = TurnController.currentTurnMode;
			TurnController.currentTurnMode = TurnController.TurnMode.None;
		}

		public void Deactivate()
		{
			TurnController.currentTurnMode = _savedTurnMode;
			_planarVel = Vector3.zero;
			_crouch = 0f;
			_lean = 0f;
		}

		public void Tick(float dt)
		{
			if (_player == null || _cfg == null || dt <= 0f)
			{
				return;
			}
			VRInputController input = VRInputController.Instance;
			if (input == null)
			{
				return;
			}
			if (_head == null)
			{
				_head = ResolveHead(_player);
			}
			if (_head == null)
			{
				return;
			}
			Vector2 rightStick = input.RightJoystick;
			float crouchTarget = (rightStick.y < -_cfg.crouchThreshold) ? 1f : 0f;
			_crouch = Mathf.MoveTowards(_crouch, crouchTarget, _cfg.crouchResponse * dt);
			float turnAbs = Mathf.Abs(rightStick.x);
			if (_snapArmed && turnAbs > _cfg.snapTurnThreshold)
			{
				_player.Turn((rightStick.x < 0f) ? (0f - _cfg.snapTurnAngle) : _cfg.snapTurnAngle);
				_snapArmed = false;
			}
			else if (turnAbs < _cfg.snapTurnRelease)
			{
				_snapArmed = true;
			}
			Vector2 leftStick = input.LeftJoystick;
			Vector3 forward = _head.forward;
			Vector3 right = _head.right;
			forward.y = 0f;
			forward = (forward.sqrMagnitude < 0.0001f) ? Vector3.forward : forward.normalized;
			right.y = 0f;
			right = (right.sqrMagnitude < 0.0001f) ? Vector3.right : right.normalized;
			Vector3 move = forward * leftStick.y + right * leftStick.x;
			float magnitude = move.magnitude;
			Vector3 dir;
			float amount;
			if (magnitude < _cfg.stickDeadzone)
			{
				dir = Vector3.zero;
				amount = 0f;
			}
			else
			{
				dir = move / magnitude;
				amount = Mathf.Min(magnitude, 1f);
			}
			float speed = (_def != null && _def.moveSpeedOverride > 0f) ? _def.moveSpeedOverride : _cfg.moveSpeed;
			speed *= Mathf.Lerp(1f, _cfg.crouchSpeedMultiplier, _crouch);
			speed *= Mathf.Max(_player.CurrentScale, 0.05f);
			Vector3 targetVel = dir * (amount * speed);
			float rate = (targetVel.sqrMagnitude > _planarVel.sqrMagnitude) ? _cfg.acceleration : _cfg.deceleration;
			_planarVel = Vector3.MoveTowards(_planarVel, targetVel, rate * dt);
			float speedFrac = (_cfg.moveSpeed > 0.01f) ? (_planarVel.magnitude / _cfg.moveSpeed) : 0f;
			_lean = Mathf.Lerp(_lean, speedFrac * _cfg.maxLeanAngle, _cfg.leanResponse * dt);
			Vector3 delta = _planarVel * dt;
			if (delta.sqrMagnitude > 1E-08f)
			{
				Vector3 origin = _head.position;
				float distance = delta.magnitude;
				float radius = _cfg.wallCheckRadius;
				if (Physics.SphereCast(origin, radius, delta / distance, out var hit, distance + radius, _player.locomotionEnabledLayers.value, QueryTriggerInteraction.Ignore))
				{
					delta = Vector3.ProjectOnPlane(delta, hit.normal);
				}
				Transform transform = _player.transform;
				transform.position += delta;
			}
		}

		private static Transform ResolveHead(Player player)
		{
			if (player == null)
			{
				return null;
			}
			if (player.headCollider != null)
			{
				return player.headCollider.transform;
			}
			return player.transform;
		}
	}
}
