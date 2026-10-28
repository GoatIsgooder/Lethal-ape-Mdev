using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;

namespace LALocomotion
{
	[DefaultExecutionOrder(-200)]
	[DisallowMultipleComponent]
	public class LADesktopSimulator : MonoBehaviour
	{
		public enum Activation
		{
			AutoWhenNoHeadset = 0,
			AlwaysOn = 1,
			Off = 2
		}

		public struct Frame
		{
			public Vector2 look;

			public Vector2 move;

			public bool plant;

			public bool jump;

			public bool leftGrip;

			public bool rightGrip;

			public bool leftTrigger;

			public bool rightTrigger;

			public bool buttonX;

			public bool buttonY;

			public bool buttonA;

			public bool buttonB;

			public Vector2 leftStick;

			public Vector2 rightStick;

			public bool leftStickClick;

			public bool rightStickClick;

			public bool menu;

			public float wheel;

			public bool alt;

			public bool shift;

			public int turn;

			public bool reset;
		}

		public Activation activation;

		public LAPlayer player;

		public Transform head;

		public Transform leftController;

		public Transform rightController;

		public LAGrabber leftGrabber;

		public LAGrabber rightGrabber;

		[Tooltip("Pose drivers (head and controllers) switched off while simulating.")]
		public Behaviour[] trackedPoseDrivers = new Behaviour[0];

		[Header("Head")]
		[Tooltip("Head height above the rig root.")]
		public float headHeight = 1.2f;

		public float lookSensitivity = 0.1f;

		[Header("Hands (from the head, in head-yaw space)")]
		public Vector3 leftRest = new Vector3(-0.22f, -0.3f, 0.35f);

		public Vector3 rightRest = new Vector3(0.22f, -0.3f, 0.35f);

		public float minReach = 0.15f;

		public float maxReach = 1.1f;

		[Tooltip("How far below the head F plants the hands.")]
		public float plantDepth = 0.9f;

		public float handLerpSpeed = 14f;

		[Header("Movement")]
		public float walkSpeed = 2.5f;

		public float jumpSpeed = 4.5f;

		[Tooltip("Head height above the ground kept while not planting with F, so walking stays upright instead of sinking onto the body collider.")]
		public float standHeight = 0.9f;

		[Tooltip("How far below standing height the ground can drop before the ape is left to fall (ledges, jumps).")]
		public float standReach = 0.35f;

		public float standSpring = 12f;

		public float maxStandSpeed = 4f;

		[Tooltip("How fast walking stops (m/s per second) once the walk keys are released while standing.")]
		public float walkBrake = 20f;

		[Tooltip("Speed the planted hands sweep back at while F + WASD is held.")]
		public float pushSpeed = 2.4f;

		public float maxPushStroke = 0.7f;

		[Tooltip("Letting go of F lifts both hands this far at once, like lifting them off in VR, so the release keeps the push instead of dragging the hands forward along the ground.")]
		public float releaseLift = 0.25f;

		public float snapAngle = 45f;

		[Header("Controller panel")]
		[Tooltip("On-screen buttons for every controller input, in the bottom corners (Editor and desktop builds). H toggles it.")]
		public bool showPanel = true;

		[Header("Mouse clicking")]
		[Tooltip("Left click on a button (under the crosshair, or under the cursor once Esc frees it) presses it with the right fingertip instead of gripping.")]
		public bool mouseClicking = true;

		public float clickReach = 3f;

		[Tooltip("How far behind a solid surface a button can sit and still be clicked through it.")]
		public float clickDepth = 0.08f;

		private static readonly List<XRDisplaySubsystem> Displays = new List<XRDisplaySubsystem>();

		private static readonly Dictionary<System.Type, bool> TouchTypes = new Dictionary<System.Type, bool>();

		private Collider _fingertip;

		private readonly List<GameObject> _clickTargets = new List<GameObject>();

		private bool _boardClick;

		private float _yaw;

		private float _pitch;

		private float _reach;

		private Vector3 _leftOffset;

		private Vector3 _rightOffset;

		private Vector3 _pushStroke;

		private Vector3 _manualLeft;

		private Vector3 _manualRight;

		private float _tiltLeft;

		private float _tiltRight;

		private float _nextHeadsetCheck;

		private bool _planted;

		public bool IsActive { get; private set; }

		public Frame? Script { get; set; }

		public static bool WalkKeysTaken { get; set; }

		public static bool HeadsetRunning()
		{
			SubsystemManager.GetSubsystems(Displays);
			for (int i = 0; i < Displays.Count; i++)
			{
				if (Displays[i].running)
				{
					return true;
				}
			}
			return false;
		}

		private void Start()
		{
			if (player == null)
			{
				player = GetComponentInParent<LAPlayer>();
			}
			_leftOffset = leftRest;
			_rightOffset = rightRest;
			_reach = rightRest.z;
			SetActive(activation == Activation.AlwaysOn || (activation == Activation.AutoWhenNoHeadset && !HeadsetRunning()));
		}

		private void OnDisable()
		{
			if (IsActive)
			{
				SetActive(false);
			}
		}

		public void SetActive(bool active)
		{
			IsActive = active;
			for (int i = 0; i < trackedPoseDrivers.Length; i++)
			{
				if (trackedPoseDrivers[i] != null)
				{
					trackedPoseDrivers[i].enabled = !active;
				}
			}
			float sim = active ? 0f : -1f;
			if (leftGrabber != null)
			{
				leftGrabber.simulatedGrip = sim;
				leftGrabber.simulatedTrigger = sim;
			}
			if (rightGrabber != null)
			{
				rightGrabber.simulatedGrip = sim;
				rightGrabber.simulatedTrigger = sim;
			}
			VRInputController input = VRInputController.Instance;
			if (input != null)
			{
				input.Simulate(true, sim, sim);
				input.Simulate(false, sim, sim);
				input.Simulate(true, default(VRInputController.SimulatedButtons));
				input.Simulate(false, default(VRInputController.SimulatedButtons));
			}
			if (!Script.HasValue)
			{
				Cursor.lockState = active ? CursorLockMode.Locked : CursorLockMode.None;
				Cursor.visible = !active;
			}
		}

		private void Update()
		{
			if (activation == Activation.AutoWhenNoHeadset && !Script.HasValue && Time.unscaledTime >= _nextHeadsetCheck)
			{
				_nextHeadsetCheck = Time.unscaledTime + 1f;
				bool headset = HeadsetRunning();
				if (headset == IsActive)
				{
					SetActive(!headset);
				}
			}
			if (!IsActive || player == null || head == null)
			{
				return;
			}
			// LAPlayer reads an unfocused window as a Quest system overlay and freezes the rig; with no headset
			// there is no overlay, so clicking away from the Game view must not freeze the ape.
			player.inOverlay = false;
			if (!Script.HasValue)
			{
				UpdateMouseClick();
			}
			Frame f = Script ?? ReadDevices();
			float dt = Time.deltaTime;
			Transform rig = player.transform;
			Transform pivot = player.turnPivot != null ? player.turnPivot : rig;
			float scale = player.Scale;
			if (f.reset)
			{
				player.TeleportToSpawn();
			}
			if (f.turn != 0)
			{
				player.Turn(snapAngle * f.turn);
			}
			if (!f.alt)
			{
				_yaw += f.look.x * lookSensitivity;
				_pitch = Mathf.Clamp(_pitch - f.look.y * lookSensitivity, -85f, 85f);
			}
			Quaternion yawRot = Quaternion.Euler(0f, pivot.eulerAngles.y + _yaw, 0f);
			head.SetPositionAndRotation(rig.position + Vector3.up * (scale * headHeight), yawRot * Quaternion.Euler(_pitch, 0f, 0f));
			if (!f.alt)
			{
				_reach = Mathf.Clamp(_reach + f.wheel * 0.05f, minReach, maxReach);
				_manualLeft = Vector3.MoveTowards(_manualLeft, Vector3.zero, dt * 1.5f);
				_manualRight = Vector3.MoveTowards(_manualRight, Vector3.zero, dt * 1.5f);
			}
			else if (f.shift)
			{
				_manualLeft += (Vector3)(f.look * 0.0015f);
				_tiltLeft += f.wheel * 10f;
			}
			else
			{
				_manualRight += (Vector3)(f.look * 0.0015f);
				_tiltRight += f.wheel * 10f;
			}
			_manualLeft = Vector3.ClampMagnitude(_manualLeft, 1.2f);
			_manualRight = Vector3.ClampMagnitude(_manualRight, 1.2f);
			Vector3 wish = Vector3.ClampMagnitude(new Vector3(f.move.x, 0f, f.move.y), 1f);
			Vector3 leftTarget;
			Vector3 rightTarget;
			if (f.plant)
			{
				_pushStroke = Vector3.ClampMagnitude(_pushStroke - wish * (dt * pushSpeed), maxPushStroke);
				leftTarget = _pushStroke + new Vector3(-0.25f, -plantDepth, 0.3f);
				rightTarget = _pushStroke + new Vector3(0.25f, -plantDepth, 0.3f);
			}
			else
			{
				if (_planted)
				{
					_leftOffset.y += releaseLift;
					_rightOffset.y += releaseLift;
				}
				_pushStroke = Vector3.zero;
				leftTarget = new Vector3(leftRest.x, leftRest.y, _reach);
				rightTarget = new Vector3(rightRest.x, rightRest.y, _reach);
				Rigidbody body = player.Body;
				Vector3 flat = Vector3.ProjectOnPlane(body.linearVelocity, Vector3.up);
				if (!WalkKeysTaken && wish.sqrMagnitude > 0f && !body.isKinematic && flat.magnitude <= walkSpeed + 0.1f)
				{
					Vector3 vel = yawRot * wish * walkSpeed;
					body.linearVelocity = new Vector3(vel.x, body.linearVelocity.y, vel.z);
				}
				if (!WalkKeysTaken && !f.jump && !body.isKinematic && HoldStandingHeight(body, scale) && wish.sqrMagnitude == 0f)
				{
					// Held off the floor there is no ground friction, so stop on our own once the walk keys are let go.
					Vector3 stopped = Vector3.MoveTowards(flat, Vector3.zero, walkBrake * dt);
					body.linearVelocity = new Vector3(stopped.x, body.linearVelocity.y, stopped.z);
				}
			}
			_planted = f.plant;
			if (!WalkKeysTaken && f.jump && Grounded() && !player.Body.isKinematic)
			{
				Rigidbody body2 = player.Body;
				body2.linearVelocity = new Vector3(body2.linearVelocity.x, jumpSpeed, body2.linearVelocity.z);
			}
			float t = 1f - Mathf.Exp(-handLerpSpeed * dt);
			_leftOffset = Vector3.Lerp(_leftOffset, leftTarget + _manualLeft, t);
			_rightOffset = Vector3.Lerp(_rightOffset, rightTarget + _manualRight, t);
			Vector3 headPos = head.position;
			if (leftController != null)
			{
				leftController.SetPositionAndRotation(headPos + yawRot * (_leftOffset * scale), yawRot * Quaternion.Euler(_tiltLeft, 0f, 0f));
			}
			if (rightController != null)
			{
				rightController.SetPositionAndRotation(headPos + yawRot * (_rightOffset * scale), yawRot * Quaternion.Euler(_tiltRight, 0f, 0f));
			}
			if (leftGrabber != null)
			{
				leftGrabber.simulatedGrip = f.leftGrip ? 1f : 0f;
				leftGrabber.simulatedTrigger = f.leftTrigger ? 1f : 0f;
			}
			if (rightGrabber != null)
			{
				rightGrabber.simulatedGrip = f.rightGrip ? 1f : 0f;
				rightGrabber.simulatedTrigger = f.rightTrigger ? 1f : 0f;
			}
			VRInputController input = VRInputController.Instance;
			if (input != null)
			{
				input.Simulate(true, f.leftGrip ? 1f : 0f, f.leftTrigger ? 1f : 0f);
				input.Simulate(false, f.rightGrip ? 1f : 0f, f.rightTrigger ? 1f : 0f);
				input.Simulate(true, new VRInputController.SimulatedButtons
				{
					primary = f.buttonX,
					secondary = f.buttonY,
					stick = f.leftStick,
					stickClick = f.leftStickClick,
					menu = f.menu
				});
				input.Simulate(false, new VRInputController.SimulatedButtons
				{
					primary = f.buttonA,
					secondary = f.buttonB,
					stick = f.rightStick,
					stickClick = f.rightStickClick
				});
			}
		}

		private Frame ReadDevices()
		{
			Keyboard kb = Keyboard.current;
			Mouse mouse = Mouse.current;
			if (kb == null || mouse == null)
			{
				return default(Frame);
			}
			if (kb[Key.Escape].wasPressedThisFrame)
			{
				bool locked = Cursor.lockState == CursorLockMode.Locked;
				Cursor.lockState = locked ? CursorLockMode.None : CursorLockMode.Locked;
				Cursor.visible = locked;
			}
			bool alt = kb[Key.LeftAlt].isPressed || kb[Key.RightAlt].isPressed;
			bool shift = kb[Key.LeftShift].isPressed || kb[Key.RightShift].isPressed;
			Vector2 look = (Cursor.lockState == CursorLockMode.Locked || alt) ? mouse.delta.ReadValue() : Vector2.zero;
			float wheel = mouse.scroll.ReadValue().y;
			if (Mathf.Abs(wheel) > 10f)
			{
				wheel /= 120f;
			}
			return new Frame
			{
				look = look,
				move = new Vector2((kb[Key.D].isPressed ? 1f : 0f) - (kb[Key.A].isPressed ? 1f : 0f), (kb[Key.W].isPressed ? 1f : 0f) - (kb[Key.S].isPressed ? 1f : 0f)),
				plant = kb[Key.F].isPressed,
				jump = kb[Key.Space].wasPressedThisFrame,
				leftGrip = mouse.leftButton.isPressed && _clickTargets.Count == 0 && !_boardClick,
				rightGrip = mouse.rightButton.isPressed,
				leftTrigger = kb[Key.Q].isPressed,
				rightTrigger = kb[Key.E].isPressed,
				buttonX = kb[Key.Digit1].isPressed,
				buttonY = kb[Key.Digit2].isPressed,
				buttonA = kb[Key.Digit3].isPressed,
				buttonB = kb[Key.Digit4].isPressed,
				leftStickClick = kb[Key.Digit5].isPressed,
				rightStickClick = kb[Key.Digit6].isPressed,
				menu = kb[Key.M].isPressed,
				wheel = wheel,
				alt = alt,
				shift = shift,
				turn = (kb[Key.RightArrow].wasPressedThisFrame ? 1 : 0) - (kb[Key.LeftArrow].wasPressedThisFrame ? 1 : 0),
				reset = kb[Key.R].wasPressedThisFrame
			};
		}

		// Buttons only react to a fingertip (HandTag trigger) touching them, so a click hands them that touch directly:
		// Enter on press, Stay while held (hold-to-claim buttons), Exit on release.
		private void UpdateMouseClick()
		{
			Mouse mouse = Mouse.current;
			if (!mouseClicking || mouse == null)
			{
				EndClick();
				return;
			}
			if (mouse.leftButton.wasPressedThisFrame)
			{
				EndClick();
				if (_fingertip == null)
				{
					_fingertip = FindFingertip();
				}
				Camera cam = head.GetComponentInChildren<Camera>() ?? Camera.main;
				if (cam != null)
				{
					Ray ray = Cursor.lockState == CursorLockMode.Locked ? cam.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f)) : cam.ScreenPointToRay(mouse.position.ReadValue());
					float reach = clickReach * player.Scale;
					float triggerDistance = _fingertip != null ? FindClickTargets(ray, reach) : float.MaxValue;
					// the season pass board reads fingertip positions, not triggers: it gets the mouse as its third finger
					if (LethalApeR.SeasonPass.SeasonPassBoard.DesktopPress(ray, Mathf.Min(reach, triggerDistance), out _))
					{
						_clickTargets.Clear();
						_boardClick = true;
					}
					foreach (GameObject target in _clickTargets)
					{
						target.SendMessage("OnTriggerEnter", _fingertip, SendMessageOptions.DontRequireReceiver);
					}
				}
			}
			if (_clickTargets.Count == 0 && !_boardClick)
			{
				return;
			}
			if (!mouse.leftButton.isPressed || _fingertip == null && !_boardClick)
			{
				EndClick();
				return;
			}
			foreach (GameObject target in _clickTargets)
			{
				if (target != null && target.activeInHierarchy)
				{
					target.SendMessage("OnTriggerStay", _fingertip, SendMessageOptions.DontRequireReceiver);
				}
			}
		}

		private void EndClick()
		{
			if (_fingertip != null)
			{
				foreach (GameObject target in _clickTargets)
				{
					if (target != null)
					{
						target.SendMessage("OnTriggerExit", _fingertip, SendMessageOptions.DontRequireReceiver);
					}
				}
			}
			_clickTargets.Clear();
			if (_boardClick)
			{
				LethalApeR.SeasonPass.SeasonPassBoard.DesktopRelease();
				_boardClick = false;
			}
		}

		// Fills _clickTargets with the button the ray points at and returns its distance. A solid collider only blocks
		// the click when the button sits further than clickDepth behind it (button faces often have a solid backing).
		private float FindClickTargets(Ray ray, float reach)
		{
			RaycastHit[] hits = Physics.RaycastAll(ray, reach, -1, QueryTriggerInteraction.Collide);
			System.Array.Sort(hits, (a, b) => a.distance.CompareTo(b.distance));
			Transform rig = player.transform;
			float solidAt = -1f;
			for (int i = 0; i < hits.Length; i++)
			{
				Collider col = hits[i].collider;
				if (col.attachedRigidbody == player.Body || col.transform.IsChildOf(rig))
				{
					continue;
				}
				if (solidAt >= 0f && hits[i].distance - solidAt > clickDepth * player.Scale)
				{
					break;
				}
				// Unity sends trigger messages to the collider's object and to its rigidbody's object
				if (IsTouchable(col.gameObject))
				{
					_clickTargets.Add(col.gameObject);
				}
				Rigidbody rb = col.attachedRigidbody;
				if (rb != null && rb.gameObject != col.gameObject && IsTouchable(rb.gameObject))
				{
					_clickTargets.Add(rb.gameObject);
				}
				if (_clickTargets.Count > 0)
				{
					return hits[i].distance;
				}
				if (!col.isTrigger && solidAt < 0f)
				{
					solidAt = hits[i].distance;
				}
			}
			return float.MaxValue;
		}

		private Collider FindFingertip()
		{
			Collider fallback = null;
			foreach (Collider col in transform.root.GetComponentsInChildren<Collider>(true))
			{
				if (!col.CompareTag("HandTag"))
				{
					continue;
				}
				if (col.name.Contains("R_end") || col.name.Contains("RightFinger"))
				{
					return col;
				}
				if (fallback == null)
				{
					fallback = col;
				}
			}
			return fallback;
		}

		private static bool IsTouchable(GameObject go)
		{
			foreach (MonoBehaviour mb in go.GetComponents<MonoBehaviour>())
			{
				if (mb == null)
				{
					continue;
				}
				System.Type type = mb.GetType();
				if (!TouchTypes.TryGetValue(type, out bool touchable))
				{
					const System.Reflection.BindingFlags flags = System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.DeclaredOnly;
					for (System.Type t = type; t != null && t != typeof(MonoBehaviour) && !touchable; t = t.BaseType)
					{
						touchable = t.GetMethod("OnTriggerEnter", flags) != null || t.GetMethod("OnTriggerStay", flags) != null;
					}
					TouchTypes[type] = touchable;
				}
				if (touchable)
				{
					return true;
				}
			}
			return false;
		}

		private void OnGUI()
		{
			if (IsActive && mouseClicking && !Script.HasValue && Cursor.lockState == CursorLockMode.Locked)
			{
				Rect dot = new Rect(Screen.width * 0.5f - 2f, Screen.height * 0.5f - 2f, 4f, 4f);
				GUI.DrawTexture(dot, Texture2D.whiteTexture);
			}
		}

		private bool HoldStandingHeight(Rigidbody body, float scale)
		{
			if (body.linearVelocity.y > 0.5f)
			{
				return false;
			}
			float radius = scale * 0.12f;
			if (!Physics.SphereCast(head.position, radius, Vector3.down, out RaycastHit hit, scale * (standHeight + standReach), player.locomotionLayers, QueryTriggerInteraction.Ignore))
			{
				return false;
			}
			float rise = scale * standHeight - (hit.distance + radius);
			if (rise <= 0f)
			{
				return true;
			}
			// Lift the rig transform itself: LAPlayer re-syncs the body to it every step and zeroes velocity while its
			// colliders touch the ground, so moving the body or pushing its velocity alone gets overwritten.
			player.transform.position += Vector3.up * Mathf.Min(rise, Mathf.Max(rise * standSpring, maxStandSpeed) * Time.deltaTime);
			body.position = player.transform.position;
			if (body.linearVelocity.y < 0f)
			{
				body.linearVelocity = new Vector3(body.linearVelocity.x, 0f, body.linearVelocity.z);
			}
			return true;
		}

		private bool Grounded()
		{
			if (player.IsTouchingAnything)
			{
				return true;
			}
			RaycastHit hit;
			return Physics.SphereCast(head.position, player.Scale * 0.12f, Vector3.down, out hit, player.Scale, player.locomotionLayers, QueryTriggerInteraction.Ignore);
		}
	}
}
