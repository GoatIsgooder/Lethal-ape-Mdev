using System;
using GorillaLocomotion;
using LALocomotion;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmMonsterSkin : MonoBehaviourPun
	{
		private readonly struct LocoInput
		{
			public readonly Vector2 Move;

			public readonly float CrouchAxis;

			public readonly bool Run;

			public readonly bool Jump;

			public LocoInput(Vector2 move, float crouchAxis, bool run, bool jump)
			{
				Move = move;
				CrouchAxis = crouchAxis;
				Run = run;
				Jump = jump;
			}
		}

		private interface ILocoInput
		{
			LocoInput Read();
		}

		private sealed class VrLocoInput : ILocoInput
		{
			private readonly float _deadzone;

			public VrLocoInput(float deadzone)
			{
				_deadzone = deadzone;
			}

			public LocoInput Read()
			{
				VRInputController vr = VRInputController.Instance;
				if (vr == null)
				{
					return new LocoInput(Vector2.zero, 0f, false, false);
				}
				return new LocoInput(ApplyRadialDeadzone(vr.LeftJoystick, _deadzone), ApplyDeadzone(vr.RightJoystick.y, _deadzone), vr.LeftJoystickClick, vr.RightPrimaryButton);
			}

			private static Vector2 ApplyRadialDeadzone(Vector2 value, float deadzone)
			{
				if (value.magnitude < deadzone)
				{
					return Vector2.zero;
				}
				return value;
			}

			private static float ApplyDeadzone(float value, float deadzone)
			{
				if (Mathf.Abs(value) < deadzone)
				{
					return 0f;
				}
				return value;
			}
		}

		private sealed class PcLocoInput : ILocoInput
		{
			public LocoInput Read()
			{
				Keyboard keyboard = Keyboard.current;
				if (keyboard == null)
				{
					return new LocoInput(Vector2.zero, 0f, false, false);
				}
				Vector2 move = new Vector2(Axis(keyboard[Key.D].isPressed, keyboard[Key.A].isPressed), Axis(keyboard[Key.W].isPressed, keyboard[Key.S].isPressed));
				float crouchAxis = Axis(keyboard[Key.E].isPressed, keyboard[Key.Q].isPressed);
				return new LocoInput(move, crouchAxis, keyboard[Key.LeftShift].isPressed, keyboard[Key.Space].isPressed);
			}

			private static float Axis(bool positive, bool negative)
			{
				return (positive ? 1f : 0f) - (negative ? 1f : 0f);
			}
		}

		[Header("Locomotion")]
		[Tooltip("Legged skins get joystick walk/run/crouch/jump + the hover spring. Leave off for head-mounted skins that keep the stock arm-swing.")]
		public bool isLegged;

		[SerializeField]
		private float walkSpeed = 3.5f;

		[SerializeField]
		private float runMultiplier = 1.8f;

		[SerializeField]
		private float crouchSpeedMultiplier = 0.45f;

		[SerializeField]
		private float acceleration = 24f;

		[Header("Hover (pushup)")]
		[SerializeField]
		private float raycastYOffset = 1f;

		[SerializeField]
		private float rideHeight = 1f;

		[SerializeField]
		private float crouchRideHeight = 0.01f;

		[SerializeField]
		private float springStrength = 120f;

		[SerializeField]
		private float springDamper = 14f;

		[SerializeField]
		private float springIntegral;

		[SerializeField]
		private float integralClamp = 4f;

		[SerializeField]
		private float probeExtra = 0.6f;

		[SerializeField]
		private float probeUpOffset = 0.05f;

		[Tooltip("Leave empty (Nothing) to inherit Player.locomotionEnabledLayers at runtime.")]
		[SerializeField]
		private LayerMask groundMask;

		[Header("Crouch")]
		[SerializeField]
		private float crouchLerpSpeed = 2.5f;

		[Header("Jump")]
		[SerializeField]
		private float jumpVelocity = 5f;

		[SerializeField]
		private float jumpHoverSuspend = 0.25f;

		[Header("Input")]
		[SerializeField]
		private float stickDeadzone = 0.15f;

		[Header("Leg IK")]
		[Tooltip("Root of the legged body. Pinned to the floor under the networked head every LateUpdate, on every client.")]
		[SerializeField]
		private Transform ikRig;

		[SerializeField]
		private float ikGroundOffset;

		[SerializeField]
		private float ikProbeHeight = 2f;

		[SerializeField]
		private float ikProbeDistance = 6f;

		[Header("Abilities")]
		[SerializeField]
		private bool proximitySpeedBoost = true;

		[SerializeField]
		private float boostRange = 12f;

		[SerializeField]
		private float boostMultiplier = 1.4f;

		[SerializeField]
		private float boostBlendSpeed = 3f;

		[SerializeField]
		private float preyScanInterval = 0.25f;

		private ILocoInput _input;

		private Player _player;

		private Transform _head;

		private MonkeDevNetworkingPlayer _owner;

		private bool _active;

		private float _crouchT;

		private float _integralAccum;

		private bool _grounded;

		private bool _jumpHeld;

		private float _hoverSuspendUntil;

		private float _boostBlend;

		private float _nextPreyScan;

		private bool _preyNear;

		private bool _handSpeedApplied;

		private float _baseJumpMultiplier;

		private float _baseMaxJumpSpeed;

		public static float PerkSpeedMultiplier = 1f;

		public float CurrentSpeedMultiplier => Mathf.Lerp(1f, boostMultiplier, _boostBlend) * PerkSpeedMultiplier;

		public static bool LocalDriverActive { get; private set; }

		public bool IsDriving => _active;

		public bool HuntBoost => proximitySpeedBoost;

		public float HuntBoostRange => boostRange;

		public bool IsLegged => isLegged;

		public bool DebugGrounded => _grounded;

		public float DebugCrouch => _crouchT;

		public float DebugBoostBlend => _boostBlend;

		public bool DebugPreyNear => _preyNear;

		public Transform DebugIkRig => ikRig;

		public Transform DebugHead => _head;

		public float DebugRideHeight => rideHeight;

		public float DebugCrouchRideHeight => crouchRideHeight;

		public LayerMask DebugGroundMask => groundMask;

		public float DebugRigHeightAboveFloor
		{
			get
			{
				if (ikRig == null || _head == null)
				{
					return float.NaN;
				}
				int mask = ((groundMask.value != 0) ? groundMask.value : Physics.DefaultRaycastLayers);
				if (Physics.Raycast(_head.position + Vector3.up * ikProbeHeight, Vector3.down, out RaycastHit hit, ikProbeHeight + ikProbeDistance, mask, QueryTriggerInteraction.Ignore))
				{
					return ikRig.position.y - hit.point.y;
				}
				return float.NaN;
			}
		}

		private void OnEnable()
		{
			if (isLegged && base.photonView.IsMine && ShouldDrive())
			{
				TryActivate();
			}
		}

		private void OnDisable()
		{
			Deactivate();
			_preyNear = false;
			_boostBlend = 0f;
			ResetHandSpeed();
		}

		private bool ShouldDrive()
		{
			if (BTMGameManager.Instance == null)
			{
				return false;
			}
			GameModePlayer gameModePlayer = ResolveOwnerGameModePlayer();
			if (gameModePlayer != null && gameModePlayer.isMonster)
			{
				return !gameModePlayer.isEliminated;
			}
			return false;
		}

		private GameModePlayer ResolveOwnerGameModePlayer()
		{
			if (_owner == null)
			{
				_owner = GetComponentInParent<MonkeDevNetworkingPlayer>();
			}
			if (_owner != null)
			{
				return _owner.gameModePlayer;
			}
			return GetComponentInParent<GameModePlayer>();
		}

		private void TryActivate()
		{
			if (_active)
			{
				return;
			}
			_player = Player.Instance;
			if (!(_player == null))
			{
				EnsureGroundMask();
				_input = (XRSettings.isDeviceActive ? ((ILocoInput)new VrLocoInput(stickDeadzone)) : ((ILocoInput)new PcLocoInput()));
				LADesktopSimulator.WalkKeysTaken = _input is PcLocoInput;
				_hoverSuspendUntil = 0f;
				_crouchT = 0f;
				_integralAccum = 0f;
				_grounded = false;
				_jumpHeld = false;
				_active = true;
				LocalDriverActive = true;
			}
		}

		private void Deactivate()
		{
			if (_active)
			{
				_active = false;
				LocalDriverActive = false;
				LADesktopSimulator.WalkKeysTaken = false;
				_crouchT = 0f;
				_integralAccum = 0f;
			}
		}

		private void Update()
		{
			if (!base.photonView.IsMine)
			{
				return;
			}
			if (isLegged)
			{
				bool flag = ShouldDrive();
				if (flag && !_active)
				{
					TryActivate();
				}
				else if (!flag && _active)
				{
					Deactivate();
				}
			}
			UpdateAbilities();
		}

		private void UpdateAbilities()
		{
			if (!_active)
			{
				_preyNear = false;
				_boostBlend = 0f;
				ResetHandSpeed();
				return;
			}
			if (!proximitySpeedBoost)
			{
				_preyNear = false;
				_boostBlend = 0f;
			}
			else
			{
				if (Time.time >= _nextPreyScan)
				{
					_nextPreyScan = Time.time + preyScanInterval;
					_preyNear = IsPreyNearby();
				}
				_boostBlend = Mathf.MoveTowards(_boostBlend, _preyNear ? 1f : 0f, boostBlendSpeed * Time.deltaTime);
			}
			ApplyHandSpeed();
		}

		private bool IsPreyNearby()
		{
			if (!RoundProps.TryRead(out RoundProperties props) || !props.roundActive || props.activePlayers == null || props.activePlayers.Length == 0)
			{
				return false;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Player instance = Player.Instance;
			if (manager == null || instance == null || instance.headCollider == null)
			{
				return false;
			}
			Vector3 position = instance.headCollider.transform.position;
			float num = boostRange * boostRange;
			int[] escapedPlayers = props.escapedPlayers;
			for (int i = 0; i < manager.Players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = manager.Players[i];
				if (monkeDevNetworkingPlayer == null || monkeDevNetworkingPlayer.Head == null || monkeDevNetworkingPlayer.photonView == null || monkeDevNetworkingPlayer.photonView.IsMine)
				{
					continue;
				}
				GameModePlayer gameModePlayer = monkeDevNetworkingPlayer.gameModePlayer;
				if (gameModePlayer != null && (gameModePlayer.isEliminated || gameModePlayer.isMonster))
				{
					continue;
				}
				int ownerActorNr = monkeDevNetworkingPlayer.photonView.OwnerActorNr;
				if (Array.IndexOf(props.activePlayers, ownerActorNr) >= 0 && (escapedPlayers == null || Array.IndexOf(escapedPlayers, ownerActorNr) < 0))
				{
					if ((monkeDevNetworkingPlayer.Head.position - position).sqrMagnitude <= num)
					{
						return true;
					}
				}
			}
			return false;
		}

		private void ApplyHandSpeed()
		{
			Player instance = Player.Instance;
			if (instance == null)
			{
				return;
			}
			float currentSpeedMultiplier = CurrentSpeedMultiplier;
			if (Mathf.Abs(currentSpeedMultiplier - 1f) <= 0.001f)
			{
				ResetHandSpeed();
				return;
			}
			if (!_handSpeedApplied)
			{
				if (!BtmItemRuntime.TryGetRigBase(out _baseJumpMultiplier, out _baseMaxJumpSpeed))
				{
					_baseJumpMultiplier = instance.jumpMultiplier;
					_baseMaxJumpSpeed = instance.maxJumpSpeed;
				}
				_handSpeedApplied = true;
			}
			instance.jumpMultiplier = _baseJumpMultiplier * currentSpeedMultiplier;
			instance.maxJumpSpeed = _baseMaxJumpSpeed * currentSpeedMultiplier;
		}

		private void ResetHandSpeed()
		{
			if (_handSpeedApplied)
			{
				_handSpeedApplied = false;
				Player instance = Player.Instance;
				if (!(instance == null))
				{
					instance.jumpMultiplier = _baseJumpMultiplier;
					instance.maxJumpSpeed = _baseMaxJumpSpeed;
				}
			}
		}

		private void LateUpdate()
		{
			if (ikRig == null || !ResolveHead())
			{
				return;
			}
			EnsureGroundMask();
			int mask = ((groundMask.value != 0) ? groundMask.value : Physics.DefaultRaycastLayers);
			Vector3 position = _head.position;
			RaycastHit hit;
			bool flag = Physics.Raycast(new Vector3(position.x, position.y + ikProbeHeight, position.z), Vector3.down, out hit, ikProbeHeight + ikProbeDistance, mask, QueryTriggerInteraction.Ignore);
			float y;
			if (_active && _player != null)
			{
				y = _player.transform.position.y + ikGroundOffset;
				if (flag)
				{
					y = Mathf.Max(y, hit.point.y + ikGroundOffset);
				}
			}
			else
			{
				if (!flag)
				{
					return;
				}
				y = hit.point.y + ikGroundOffset;
			}
			ikRig.position = new Vector3(position.x, y, position.z);
		}

		private bool ResolveHead()
		{
			if (_head != null)
			{
				return true;
			}
			if (_owner == null)
			{
				_owner = GetComponentInParent<MonkeDevNetworkingPlayer>();
			}
			if (_owner != null)
			{
				_head = _owner.Head;
			}
			return _head != null;
		}

		private void EnsureGroundMask()
		{
			if (groundMask.value == 0 && Player.HasInstance && Player.Instance != null)
			{
				groundMask = Player.Instance.locomotionEnabledLayers;
			}
		}

		private void FixedUpdate()
		{
			if (_active && !(_player == null) && !_player.disableMovement)
			{
				Rigidbody playerRigidBody = _player.playerRigidBody;
				if (!(playerRigidBody == null) && !playerRigidBody.isKinematic)
				{
					LocoInput data = _input.Read();
					float fixedDeltaTime = Time.fixedDeltaTime;
					float scale = Mathf.Max(0.05f, _player.CurrentScale);
					_crouchT = Mathf.Clamp01(_crouchT - crouchLerpSpeed * data.CrouchAxis * fixedDeltaTime);
					ApplyHover(playerRigidBody, scale * Mathf.Lerp(rideHeight, crouchRideHeight, _crouchT), scale, fixedDeltaTime);
					ApplyJump(playerRigidBody, data, scale);
					ApplyWalk(playerRigidBody, data, scale, fixedDeltaTime);
				}
			}
		}

		private void ApplyHover(Rigidbody body, float targetHeight, float scale, float dt)
		{
			Vector3 position = _player.headCollider.transform.position;
			float num = body.position.y + raycastYOffset * scale;
			float num2 = probeUpOffset * scale;
			Vector3 origin = new Vector3(position.x, num + num2, position.z);
			float maxDistance = targetHeight + probeExtra * scale + num2;
			_grounded = Physics.Raycast(origin, Vector3.down, out RaycastHit hitInfo, maxDistance, groundMask, QueryTriggerInteraction.Ignore);
			if (!_grounded)
			{
				_integralAccum = 0f;
			}
			else if (!(Time.time < _hoverSuspendUntil))
			{
				float num3 = hitInfo.distance - probeUpOffset * scale - targetHeight;
				float num4 = Vector3.Dot(Vector3.up, body.linearVelocity);
				float num5 = (0f - num3) * springStrength - springDamper * num4;
				if (springIntegral > 0f)
				{
					_integralAccum = Mathf.Clamp(_integralAccum + num3 * dt, 0f - integralClamp, integralClamp);
					num5 -= springIntegral * _integralAccum;
				}
				body.AddForce(Vector3.up * (num5 * dt), ForceMode.VelocityChange);
			}
		}

		private void ApplyJump(Rigidbody body, LocoInput data, float scale)
		{
			bool num = data.Jump && !_jumpHeld;
			_jumpHeld = data.Jump;
			if (num && _grounded && !(Time.time < _hoverSuspendUntil))
			{
				Vector3 linearVelocity = body.linearVelocity;
				linearVelocity.y = jumpVelocity * scale;
				body.linearVelocity = linearVelocity;
				_grounded = false;
				_integralAccum = 0f;
				_hoverSuspendUntil = Time.time + jumpHoverSuspend;
			}
		}

		private void ApplyWalk(Rigidbody body, LocoInput data, float scale, float dt)
		{
			Transform transform = _player.headCollider.transform;
			Vector3 vector = transform.forward;
			if (vector.x * vector.x + vector.z * vector.z < 0.0001f)
			{
				vector = transform.up;
			}
			Vector3 normalized = new Vector3(vector.x, 0f, vector.z).normalized;
			Vector3 vector2 = Vector3.Cross(Vector3.up, normalized);
			Vector3 vector3 = normalized * data.Move.y + vector2 * data.Move.x;
			if (vector3.sqrMagnitude > 1f)
			{
				vector3 = vector3.normalized;
			}
			float num = (data.Run ? runMultiplier : 1f);
			float num2 = walkSpeed * scale * num * Mathf.Lerp(1f, crouchSpeedMultiplier, _crouchT) * CurrentSpeedMultiplier;
			Vector3 vector4 = vector3 * num2;
			Vector3 linearVelocity = body.linearVelocity;
			Vector3 vector5 = Vector3.ClampMagnitude(vector4 - new Vector3(linearVelocity.x, 0f, linearVelocity.z), acceleration * scale * dt);
			body.AddForce(new Vector3(vector5.x, 0f, vector5.z), ForceMode.VelocityChange);
		}
	}
}
