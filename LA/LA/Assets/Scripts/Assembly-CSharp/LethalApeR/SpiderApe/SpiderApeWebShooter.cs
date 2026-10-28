using System;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.SpiderApe
{
	[DisallowMultipleComponent]
	public class SpiderApeWebShooter : MonoBehaviour
	{
		private enum WebState
		{
			Idle = 0,
			InFlight = 1,
			Attached = 2
		}

		[Header("Identity")]
		[Tooltip("Which hand this shooter is strapped to. Drives input, haptics and the PC binding.")]
		[SerializeField]
		private WebHand hand = WebHand.Right;

		[Header("Shoot Point")]
		[Tooltip("Nozzle. Position is where the line is drawn from; +Z (blue arrow) is the direction the web flies in VR. Rotate this in the scene until the gizmo ray points out the back of the wrist the way you'd actually aim.")]
		[SerializeField]
		private Transform shootPoint;

		[Header("Aiming")]
		[Tooltip("What the web is allowed to stick to. Default matches the Player's locomotionEnabledLayers (Default only) so anything climbable is webbable.")]
		[SerializeField]
		private LayerMask attachMask = 1;

		[Tooltip("Furthest the web will reach, in metres.")]
		[SerializeField]
		private float maxRange = 45f;

		[Tooltip("Aim-assist radius. The aim ray is a sphere cast this wide, so you don't have to thread a pixel-perfect line at a ledge with a shaking hand in a headset. 0 = pinpoint raycast.")]
		[SerializeField]
		private float aimAssistRadius = 0.6f;

		[Tooltip("Metres per second the web fluid travels. Real-feeling range is 90–200; below ~60 it starts to feel like you're throwing a rope.")]
		[SerializeField]
		private float travelSpeed = 130f;

		[Tooltip("Seconds of grace after losing a target during which a shot still sticks to it. Squeezing a trigger physically tilts your wrist a few degrees — at 30m that's metres of drift, which is why a shot can miss a target the crosshair was clearly sitting on. 0 disables.")]
		[SerializeField]
		private float aimGraceTime = 0.18f;

		[Header("PC Testing")]
		[Tooltip("On PC, aim from the CAMERA (screen centre) instead of the wrist. The sim rig's hands hang at fixed offsets and don't point anywhere useful, so wrist-aiming is unusable with a mouse. The line still draws from the shoot point.")]
		[SerializeField]
		private bool pcAimFromCamera = true;

		[Header("Firing")]
		[Tooltip("What ends a swing. Default HoldTrigger: while the trigger is down the web is gripped, let go and it lets go. Squeeze = hold on, release = let go, no latching and nothing to toggle.")]
		[SerializeField]
		private WebReleaseMode releaseMode;

		[Tooltip("Fire a visible strand even when nothing is in range. It flies out, finds nothing and falls — honest feedback beats a button that silently does nothing.")]
		[SerializeField]
		private bool fireOnMiss = true;

		[Header("Pull")]
		[Tooltip("Grip = pull yourself toward the anchor, on top of whatever your hand is doing. You never NEED it — hand motion and the swing carry you — it's there for when you want a deliberate haul toward a ledge.\n\nAuto-disabled in LatchUntilGrip mode, where grip is the release button instead; one button can't do both.")]
		[SerializeField]
		private bool enableReel = true;

		[Header("Visuals & Feel")]
		[Tooltip("The bending strand. Leave empty for no visual (physics still works).")]
		[SerializeField]
		private SpiderApeWebLine webLine;

		[Tooltip("Crosshair driven by this shooter's aim. Optional.")]
		[SerializeField]
		private SpiderApeReticle reticle;

		[Tooltip("Non-spatialised source for thwip / attach / snap. Spatialize is left OFF per project convention — it's on your own wrist, and Spatialize=1 sources go silent in the Editor.")]
		[SerializeField]
		private AudioSource sfx;

		[SerializeField]
		private AudioClip fireClip;

		[SerializeField]
		private AudioClip attachClip;

		[SerializeField]
		private AudioClip detachClip;

		[SerializeField]
		private AudioClip breakClip;

		[Header("Hand Tracking")]
		[Tooltip("Smoothing rate (per second) on the measured hand velocity that drives the swing. This is the main 'snappy vs smooth' dial for hand control.\n\nHigher tracks your arm more literally but passes every tracking wobble and every physics-step aliasing artefact straight through as a shove. ~9 is a ~110ms window: still clearly your arm, without the twitch.")]
		[SerializeField]
		private float handVelocitySmoothing = 9f;

		[Tooltip("Hand speeds above this (m/s) are treated as tracking glitches, not arm movement. A real arm swing tops out well under this.")]
		[SerializeField]
		private float handVelocityClamp = 8f;

		[Header("Haptics")]
		[SerializeField]
		private bool haptics = true;

		[Tooltip("Low continuous buzz while the line is loaded, scaled by how fast you're moving. Sells rope tension without becoming a massage gun.")]
		[SerializeField]
		private bool tensionHaptics = true;

		[SerializeField]
		[Range(0f, 0.4f)]
		private float tensionHapticAmplitude = 0.06f;

		[Header("Debug")]
		[SerializeField]
		private bool drawAimGizmo = true;

		private WebState _state;

		private Transform _anchorParent;

		private Vector3 _anchorLocal;

		private Vector3 _anchorStatic;

		private float _flightDistance;

		private float _flightTravelled;

		private bool _flightWillStick;

		private Vector3 _handVelocity;

		private Vector3 _lastHandPos;

		private Vector3 _lastRigPos;

		private bool _handSampleValid;

		private float _nextTensionHaptic;

		private bool _registered;

		private Transform _selfRoot;

		private Transform _rigRoot;

		private Camera _cam;

		private bool _aimValid;

		private Vector3 _aimPoint;

		private Vector3 _aimNormal;

		private float _aimDistance;

		private Collider _aimCollider;

		private Collider _lastValidCollider;

		private Vector3 _lastValidPoint;

		private float _lastValidTime = -99f;

		public WebHand Hand => hand;

		public LayerMask AttachMask => attachMask;

		public float MaxRange => maxRange;

		public bool IsAttached => _state == WebState.Attached;

		public bool IsInFlight => _state == WebState.InFlight;

		public bool IsTaut => _state == WebState.Attached;

		public float RopeLength { get; set; }

		public float BaseRopeLength { get; set; }

		public float TuckOffset { get; set; }

		public float LandedTime { get; private set; }

		public Vector3 AnchorWorld => (_anchorParent != null) ? _anchorParent.TransformPoint(_anchorLocal) : _anchorStatic;

		public Vector3 ShootOrigin => ((shootPoint != null) ? shootPoint : transform).position;

		public Vector3 HandVelocity => _handVelocity;

		public bool ReelHeld => enableReel && releaseMode != WebReleaseMode.LatchUntilGrip && SpiderApeInput.GripHeld(hand);

		public Vector2 Steer => SpiderApeInput.Steer(hand);

		public Vector3 AimOrigin { get; private set; }

		public Vector3 AimDirection { get; private set; }

		public Collider AimCollider => _aimCollider;

		public bool TryGetAim(out Vector3 point, out Vector3 normal, out float distance)
		{
			point = _aimPoint;
			normal = _aimNormal;
			distance = _aimDistance;
			return _aimValid;
		}

		private void Reset()
		{
			if (shootPoint == null)
			{
				shootPoint = transform;
			}
			hand = (transform.name.ToLowerInvariant().IndexOf("left", StringComparison.Ordinal) >= 0) ? WebHand.Left : WebHand.Right;
		}

		private void Awake()
		{
			if (shootPoint == null)
			{
				shootPoint = transform;
				Debug.LogWarning("[SpiderApe] " + name + " has no Shoot Point — falling back to its own transform. Aim direction will almost certainly be wrong.", this);
			}
			_selfRoot = transform;
		}

		private void OnEnable()
		{
			_registered = false;
			TryRegister();
			if (webLine != null)
			{
				webLine.Clear();
			}
			_handSampleValid = false;
		}

		private void OnDisable()
		{
			Detach(silent: true);
			if (SpiderApeSwing.Instance != null)
			{
				SpiderApeSwing.Instance.Unregister(this);
			}
			_registered = false;
		}

		private void TryRegister()
		{
			if (!_registered)
			{
				SpiderApeSwing instance = SpiderApeSwing.Instance;
				if (!(instance == null))
				{
					instance.Register(this);
					_registered = true;
				}
			}
		}

		private void Update()
		{
			TryRegister();
			SampleHandVelocity();
			RefreshAim();
			HandleFireInput();
			AdvanceFlight();
			ValidateAnchor();
			TensionHaptics();
		}

		private void LateUpdate()
		{
			if (webLine == null)
			{
				return;
			}
			if (_state == WebState.Attached)
			{
				webLine.SetAttached(ShootOrigin, AnchorWorld, RopeLength);
			}
			else if (_state == WebState.InFlight)
			{
				float t = (_flightDistance > 0.0001f) ? Mathf.Clamp01(_flightTravelled / _flightDistance) : 1f;
				webLine.SetTravel(ShootOrigin, AnchorWorld, t);
			}
		}

		private void GetAimRay(out Vector3 origin, out Vector3 direction)
		{
			if (pcAimFromCamera && SpiderApeInput.IsPC)
			{
				Camera camera = ResolveCamera();
				if (camera != null)
				{
					origin = camera.transform.position;
					direction = camera.transform.forward;
					return;
				}
			}
			origin = ShootOrigin;
			direction = ((shootPoint != null) ? shootPoint : transform).forward;
		}

		private void RefreshAim()
		{
			GetAimRay(out var origin, out var direction);
			AimOrigin = origin;
			AimDirection = direction;
			_aimValid = CastForAnchor(origin, direction, out var best);
			if (_aimValid)
			{
				_aimPoint = best.point;
				_aimNormal = best.normal;
				_aimDistance = best.distance;
				_aimCollider = best.collider;
				_lastValidCollider = best.collider;
				_lastValidPoint = best.point;
				_lastValidTime = Time.time;
			}
			else
			{
				_aimDistance = maxRange;
				_aimCollider = null;
			}
		}

		private bool CastForAnchor(Vector3 origin, Vector3 dir, out RaycastHit best)
		{
			best = default(RaycastHit);
			Transform rigRoot = ResolveRigRoot();
			float num = 0f;
			for (int i = 0; i < 8; i++)
			{
				if (num >= maxRange)
				{
					break;
				}
				float maxDistance = maxRange - num;
				RaycastHit hitInfo = default(RaycastHit);
				if ((!(aimAssistRadius > 0f) || !Physics.SphereCast(origin, aimAssistRadius, dir, out hitInfo, maxDistance, attachMask, QueryTriggerInteraction.Ignore) || !(hitInfo.distance > 0.0001f)) && !Physics.Raycast(origin, dir, out hitInfo, maxDistance, attachMask, QueryTriggerInteraction.Ignore))
				{
					return false;
				}
				Transform transform2 = hitInfo.collider.transform;
				if ((!(rigRoot != null) || !transform2.IsChildOf(rigRoot)) && (!(_selfRoot != null) || !transform2.IsChildOf(_selfRoot)))
				{
					best = hitInfo;
					best.distance = num + hitInfo.distance;
					return true;
				}
				float num2 = hitInfo.distance + 0.02f;
				origin += dir * num2;
				num += num2;
			}
			return false;
		}

		private void HandleFireInput()
		{
			bool flag = SpiderApeInput.FirePressed(hand);
			bool flag2 = SpiderApeInput.GripPressed(hand);
			switch (releaseMode)
			{
			case WebReleaseMode.HoldTrigger:
				if (flag)
				{
					TryFire();
				}
				else if (SpiderApeInput.FireReleased(hand) && _state != WebState.Idle)
				{
					Detach(silent: false);
				}
				break;
			case WebReleaseMode.LatchUntilGrip:
				if (flag)
				{
					TryFire();
				}
				else if (flag2 && _state != WebState.Idle)
				{
					Detach(silent: false);
				}
				break;
			case WebReleaseMode.ToggleTrigger:
				if (flag)
				{
					if (_state == WebState.Idle)
					{
						TryFire();
					}
					else
					{
						Detach(silent: false);
					}
				}
				else if (flag2 && _state != WebState.Idle)
				{
					Detach(silent: false);
				}
				break;
			}
		}

		private void TryFire()
		{
			if (_state != WebState.Idle)
			{
				Detach(silent: true);
			}
			RefreshAim();
			bool flag = false;
			Collider collider = null;
			Vector3 vector = default(Vector3);
			if (_aimValid)
			{
				flag = true;
				collider = _aimCollider;
				vector = _aimPoint;
			}
			else if (aimGraceTime > 0f && Time.time - _lastValidTime <= aimGraceTime && _lastValidCollider != null)
			{
				flag = true;
				collider = _lastValidCollider;
				vector = _lastValidPoint;
			}
			else if (!fireOnMiss)
			{
				return;
			}
			if (flag && collider != null)
			{
				_anchorParent = collider.transform;
				_anchorLocal = _anchorParent.InverseTransformPoint(vector);
				_anchorStatic = vector;
				_flightWillStick = true;
			}
			else
			{
				_anchorParent = null;
				_anchorStatic = ShootOrigin + AimDirection * maxRange;
				_flightWillStick = false;
			}
			_flightDistance = Vector3.Distance(ShootOrigin, AnchorWorld);
			_flightTravelled = 0f;
			_state = WebState.InFlight;
			if (webLine != null)
			{
				webLine.SetTravel(ShootOrigin, AnchorWorld, 0f);
			}
			Play(fireClip);
			if (haptics)
			{
				SpiderApeInput.Pulse(hand, 0.25f, 0.04f);
			}
		}

		private void AdvanceFlight()
		{
			if (_state != WebState.InFlight)
			{
				return;
			}
			_flightTravelled += travelSpeed * Time.deltaTime;
			if (_flightTravelled < _flightDistance)
			{
				return;
			}
			if (!_flightWillStick)
			{
				Detach(silent: false);
				return;
			}
			_state = WebState.Attached;
			LandedTime = Time.time;
			float num = Vector3.Distance(SwingOrigin(), AnchorWorld);
			TuckOffset = 0f;
			RopeLength = num;
			BaseRopeLength = num;
			SpiderApeSwing spiderApeSwing = ResolveSwing();
			if (spiderApeSwing != null)
			{
				spiderApeSwing.OnWebLanded(this);
			}
			Play(attachClip);
			if (haptics)
			{
				SpiderApeInput.Pulse(hand, 0.55f, 0.07f);
			}
		}

		private void ValidateAnchor()
		{
			if (_state != WebState.Idle && _flightWillStick && _anchorParent == null)
			{
				Break();
			}
		}

		public void Detach()
		{
			Detach(silent: false);
		}

		public void Break()
		{
			WebState state = _state;
			if (state != WebState.Idle)
			{
				EndStrand();
				Play((breakClip != null) ? breakClip : detachClip);
				if (haptics)
				{
					SpiderApeInput.Pulse(hand, 0.8f, 0.1f);
				}
				SpiderApeSwing spiderApeSwing = ResolveSwing();
				if (spiderApeSwing != null)
				{
					spiderApeSwing.OnWebDetached(this, state == WebState.Attached);
				}
			}
		}

		private void Detach(bool silent)
		{
			WebState state = _state;
			if (state == WebState.Idle)
			{
				return;
			}
			EndStrand();
			if (!silent)
			{
				Play(detachClip);
				SpiderApeSwing spiderApeSwing = ResolveSwing();
				if (spiderApeSwing != null)
				{
					spiderApeSwing.OnWebDetached(this, state == WebState.Attached);
				}
			}
		}

		private void EndStrand()
		{
			bool flightWillStick = _flightWillStick;
			_state = WebState.Idle;
			_anchorParent = null;
			RopeLength = 0f;
			BaseRopeLength = 0f;
			_flightWillStick = false;
			TuckOffset = 0f;
			if (webLine != null)
			{
				webLine.ReleaseFrom(ShootOrigin, flightWillStick);
			}
		}

		private void SampleHandVelocity()
		{
			SpiderApeSwing spiderApeSwing = ResolveSwing();
			Vector3 vector = ((spiderApeSwing != null) ? spiderApeSwing.SwingOrigin : transform.root.position);
			Vector3 shootOrigin = ShootOrigin;
			if (_handSampleValid)
			{
				float deltaTime = Time.deltaTime;
				if (deltaTime > 0.0001f)
				{
					Vector3 b = Vector3.ClampMagnitude((shootOrigin - _lastHandPos - (vector - _lastRigPos)) / deltaTime, Mathf.Max(handVelocityClamp, 0.1f));
					_handVelocity = Vector3.Lerp(_handVelocity, b, 1f - Mathf.Exp((0f - Mathf.Max(handVelocitySmoothing, 0.1f)) * deltaTime));
				}
				_lastHandPos = shootOrigin;
				_lastRigPos = vector;
			}
			else
			{
				_lastHandPos = shootOrigin;
				_lastRigPos = vector;
				_handVelocity = Vector3.zero;
				_handSampleValid = true;
			}
		}

		private void TensionHaptics()
		{
			if (!tensionHaptics || !haptics || _state != WebState.Attached || Time.time < _nextTensionHaptic)
			{
				return;
			}
			_nextTensionHaptic = Time.time + 0.08f;
			SpiderApeSwing spiderApeSwing = ResolveSwing();
			if (!(spiderApeSwing == null) && !(spiderApeSwing.MaxSpeed <= 0f))
			{
				float num = Mathf.Clamp01(spiderApeSwing.Speed / spiderApeSwing.MaxSpeed);
				if (!(num < 0.15f))
				{
					SpiderApeInput.Pulse(hand, num * tensionHapticAmplitude, 0.05f);
				}
			}
		}

		private void Play(AudioClip clip)
		{
			if (sfx != null && clip != null)
			{
				sfx.PlayOneShot(clip, 1f);
			}
		}

		private SpiderApeSwing ResolveSwing()
		{
			if (!(SpiderApeSwing.Instance != null))
			{
				return null;
			}
			return SpiderApeSwing.Instance;
		}

		private Vector3 SwingOrigin()
		{
			SpiderApeSwing spiderApeSwing = ResolveSwing();
			if (spiderApeSwing != null)
			{
				return spiderApeSwing.SwingOrigin;
			}
			if (Player.HasInstance && Player.Instance != null)
			{
				return Player.Instance.transform.position;
			}
			return transform.position;
		}

		private Transform ResolveRigRoot()
		{
			if (_rigRoot == null && Player.HasInstance && Player.Instance != null)
			{
				_rigRoot = Player.Instance.transform;
			}
			return _rigRoot;
		}

		private Camera ResolveCamera()
		{
			if (_cam == null)
			{
				_cam = ((Player.HasInstance && Player.Instance != null && Player.Instance.mainCamera != null) ? Player.Instance.mainCamera : Camera.main);
			}
			return _cam;
		}
	}
}
