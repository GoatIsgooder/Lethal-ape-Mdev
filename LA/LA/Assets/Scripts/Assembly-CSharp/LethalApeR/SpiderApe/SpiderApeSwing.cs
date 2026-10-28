using System.Collections.Generic;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.SpiderApe
{
	[DisallowMultipleComponent]
	public class SpiderApeSwing : MonoBehaviour
	{
		[Header("Input")]
		[Tooltip("Auto = VR when a headset is active, mouse+keyboard otherwise.\nPC test bindings: LMB = right web, Q = left web, Space = reel in, WASD = pump/steer.")]
		[SerializeField]
		private SpiderApeInputMode inputMode;

		[Header("Rope — spring-damper, same shape as a SpringJoint")]
		[Tooltip("Rope stiffness (1/s^2). How hard the line pulls per metre of stretch.\n\nLower = a stretchier, more elastic web that eases you round the arc. Higher = closer to a steel cable, and past ~400 it starts to feel like the old hard clamp again. At speed the line needs roughly 40 m/s^2 to hold you, so 160 sits at about a quarter-metre of visible stretch under load.")]
		[SerializeField]
		private float springStiffness = 160f;

		[Tooltip("Rope damping (1/s). Bleeds the bounce out of the spring. Too low and the web pogos; too high and it stiffens back up into a clamp.")]
		[SerializeField]
		private float springDamping = 8f;

		[Tooltip("Ceiling on rope acceleration (m/s^2). Purely a safety valve for absurd stretch — a teleport, a lag spike — so the line can't act as a slingshot.")]
		[SerializeField]
		private float maxSpringAccel = 90f;

		[Tooltip("Seconds for a freshly landed web to reach full strength. The ramp turns the catch into a stretch instead of a neck-snap. Comfort-critical in VR.")]
		[SerializeField]
		private float tautBlendTime = 0.28f;

		[Tooltip("Snap the web if it's stretched this fraction past its length (0.35 = 35%). 0 disables. Normal swinging never gets close — this is a safety valve.")]
		[SerializeField]
		private float breakStretch = 0.35f;

		[Header("Rope Length")]
		[Tooltip("The web can never be winched shorter than this. Stops you from being reeled into the anchor and getting stuck inside geometry.")]
		[SerializeField]
		private float minRopeLength = 2.5f;

		[Tooltip("AUTO-TUCK. Fraction of rope drawn in at the bottom of the arc and paid back out at the top — parametric pumping, the playground-swing trick. It DOES add real energy every pass, which is precisely the problem: it's a push you didn't ask for, and it was the last thing still shoving you along on its own.\n\nDEFAULT 0. Your hand does this now — hauling on the line shortens it, and doing that through the bottom of the arc is the same physics, done by you. Raise it only if you want the swing to sustain itself hands-free.")]
		[Range(0f, 0.3f)]
		[SerializeField]
		private float autoTuck;

		[Tooltip("Metres per second the auto-tuck is allowed to change the rope by. Caps how hard the tuck can yank you, so it reads as effort rather than a winch.")]
		[SerializeField]
		private float tuckRate = 3f;

		[Tooltip("Swing speed (m/s) at which auto-tuck reaches full strength. Below it the tuck fades out, and at a dead stop it does NOTHING — which is the point: without this, webbing a point above your head reels you straight up to it the instant the line lands, and that is a grappling hook. You only tuck as part of an actual swing, exactly like a real one.")]
		[SerializeField]
		private float tuckFullSpeed = 6f;

		[Tooltip("Web-zip speed — metres of rope pulled in per second while reeling. Only used if a shooter has 'Enable Reel' ticked; reeling is off by default.")]
		[SerializeField]
		private float reelSpeed = 9f;

		[Tooltip("Extra acceleration straight AT the anchor while reeling. DEFAULT 0, and leave it there unless you specifically want a zip-line: this is the one knob that genuinely turns the web into a grapple, because it drags you off the swing sphere and into a straight line at the wall. The rope shortening above does the pulling and keeps you swinging while it does it.")]
		[SerializeField]
		private float reelAccel;

		[Tooltip("Gradually take in rope so the bottom of the arc clears whatever is under the anchor, keeping long low webs from ploughing you into the street.\n\nOnly ever acts on SLACK line — see ApplyGroundClearance for why that restriction is the whole point.")]
		[SerializeField]
		private bool autoShortenForGround = true;

		[Tooltip("Metres of daylight to leave under the bottom of the arc.")]
		[SerializeField]
		private float groundClearance = 3f;

		[Tooltip("Metres per second the ground-clearance trim is allowed to take in. Slow is fine — it only ever eats slack, so there is nothing to rush.")]
		[SerializeField]
		private float groundClearanceRate = 4f;

		[Header("Energy")]
		[Tooltip("Gravity multiplier while swinging. >1 makes arcs punchier than real physics allows — every Spider-Man game cheats here, and it's what sells the weight.")]
		[SerializeField]
		private float swingGravityMultiplier = 1.35f;

		[Tooltip("Constant tangential push along your direction of travel. DEFAULT 0 — a force that moves you without you doing anything is precisely what makes a web feel like a grappling hook. Your arm and gravity should be the only things driving the swing. Only raise this if swings decay more than you want.")]
		[SerializeField]
		private float autoPumpAccel;

		[Tooltip("Tangential acceleration from stick forward/back (VR) or W/S (PC).")]
		[SerializeField]
		private float pumpAccel = 8f;

		[Tooltip("Sideways acceleration from stick left/right (VR) or A/D (PC) — steers the arc.")]
		[SerializeField]
		private float steerAccel = 6f;

		[Header("Hand Drive — the web is a handhold, not a winch")]
		[Tooltip("Which way you move your hand to haul yourself in. Flip this if pulling feels backwards — it's purely which mental model you have of holding the line.")]
		[SerializeField]
		private HandPullDirection handPullDirection;

		[Tooltip("Metres of line hauled in per metre/second of hand pull, in whichever direction Hand Pull Direction says. SHORTENS the rope.\n\nIt deliberately does NOT push you at the anchor. Velocity along the line takes you off the swing sphere and you fly at the wall in a straight line — that is exactly what a grapple does and a rope cannot. Shortening keeps you ON the sphere, so you climb the arc and keep orbiting the contact point.")]
		[SerializeField]
		private float handPullGain = 3.2f;

		[Tooltip("Ceiling on how fast a yank can take in line (m/s). This is what a hard, committed pull actually gets you — raise it for more punch, lower it if a fast yank starts to feel like it snatches.")]
		[SerializeField]
		private float handPullMaxRate = 11f;

		[Tooltip("Thrust strength for hand motion ACROSS the line (per second). You get pushed the way you pushed — sweep your hand sideways and you're shoved sideways, sweep it along the arc and you pump the swing.")]
		[SerializeField]
		private float handSwingGain = 8f;

		[Tooltip("Ceiling on that across-the-line thrust (m/s^2). A hard clamp is a discontinuity you can feel, so keep it high enough that normal arm speeds stay under it and only a genuine swipe reaches it.")]
		[SerializeField]
		private float handSwingMaxAccel = 20f;

		[Tooltip("Hand speed (m/s) below which nothing transfers. Filters tracking noise and the small constant drift of a hand that's just holding still.")]
		[SerializeField]
		private float handDeadzone = 0.15f;

		[Tooltip("Velocity lost per second while swinging. Keeps terminal speed sane and bleeds off energy when you stop pumping.")]
		[SerializeField]
		private float airDrag = 0.06f;

		[Header("Limits & Release")]
		[Tooltip("Hard speed cap (m/s). Comfort limit AND a safety rail for Player.AntiTeleportTechnology. 28 is already very fast in a headset.")]
		[SerializeField]
		private float maxSpeed = 28f;

		[Tooltip("Bonus speed along your current heading when you let go of the LAST web at pace. Rewards releasing at the right point in the arc.")]
		[SerializeField]
		private float releaseBoost = 1.5f;

		[Tooltip("Extra upward kick on release, so a well-timed let-go pops you over the next roof.")]
		[SerializeField]
		private float releaseUpBoost = 1f;

		[Tooltip("Below this speed a release pays no bonus.")]
		[SerializeField]
		private float releaseBoostMinSpeed = 6f;

		[Header("Momentum Guard")]
		[Tooltip("Seconds after letting go during which a sudden total loss of velocity is treated as a mistake and undone.\n\nPlayer.cs zeroes linearVelocity outright the moment a hand sphere-cast grazes anything — that IS how gorilla grabbing works. At 20 m/s your hands sweep ~30cm every frame and will clip scenery you never meant to grab, so a release at full pace can be silently flattened to a dead stop. 0 disables.")]
		[SerializeField]
		private float momentumGuardTime = 0.5f;

		[Header("Interaction with gorilla locomotion")]
		[Tooltip("Cut every web the moment a hand grabs a surface. OFF by default: leaving the web stuck while you're on a wall is both more useful and more Spider-Man. Player.cs already zeroes your velocity on grab, so nothing fights.")]
		[SerializeField]
		private bool detachOnSurfaceGrab;

		[Header("Debug")]
		[Tooltip("Draw rope lines and the taut/slack state in the Scene view.")]
		[SerializeField]
		private bool drawGizmos = true;

		private readonly List<SpiderApeWebShooter> _shooters = new List<SpiderApeWebShooter>(2);

		private readonly List<SpiderApeWebShooter> _taut = new List<SpiderApeWebShooter>(2);

		private Player _player;

		private Rigidbody _rb;

		private Transform _cam;

		private Vector3 _guardVelocity;

		private float _guardUntil;

		public static SpiderApeSwing Instance { get; private set; }

		public bool IsSwinging { get; private set; }

		public float Speed { get; private set; }

		public float MaxSpeed => maxSpeed;

		public int AttachedCount => _taut.Count;

		public Rigidbody PlayerBody
		{
			get
			{
				if (_rb == null)
				{
					ResolvePlayer();
				}
				return _rb;
			}
		}

		public Vector3 SwingOrigin
		{
			get
			{
				if (_rb != null)
				{
					return _rb.position;
				}
				return transform.position;
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Debug.LogWarning("[SpiderApe] A second SpiderApeSwing exists on '" + name + "'. Disabling it — the solver is a singleton.", this);
				enabled = false;
				return;
			}
			Instance = this;
			SpiderApeInput.Mode = inputMode;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnValidate()
		{
			if (Application.isPlaying && Instance == this)
			{
				SpiderApeInput.Mode = inputMode;
			}
			minRopeLength = Mathf.Max(0.5f, minRopeLength);
			groundClearance = Mathf.Max(0f, groundClearance);
		}

		public void Register(SpiderApeWebShooter shooter)
		{
			if (shooter != null && !_shooters.Contains(shooter))
			{
				_shooters.Add(shooter);
			}
		}

		public void Unregister(SpiderApeWebShooter shooter)
		{
			_shooters.Remove(shooter);
			_taut.Remove(shooter);
		}

		private void ResolvePlayer()
		{
			if (_player == null)
			{
				_player = Player.HasInstance ? Player.Instance : GetComponent<Player>();
			}
			if (_player == null)
			{
				return;
			}
			if (_rb == null)
			{
				_rb = (_player.playerRigidBody != null) ? _player.playerRigidBody : _player.GetComponent<Rigidbody>();
			}
			if (_cam == null && _player.mainCamera != null)
			{
				_cam = _player.mainCamera.transform;
			}
		}

		public void OnWebLanded(SpiderApeWebShooter shooter)
		{
			ResolvePlayer();
			if (!(shooter == null) && !(_rb == null))
			{
				float length = Mathf.Max(minRopeLength, Vector3.Distance(SwingOrigin, shooter.AnchorWorld));
				shooter.TuckOffset = 0f;
				shooter.BaseRopeLength = length;
				shooter.RopeLength = length;
			}
		}

		public void OnWebDetached(SpiderApeWebShooter shooter, bool wasTaut)
		{
			if (!wasTaut)
			{
				return;
			}
			ResolvePlayer();
			if (_rb == null)
			{
				return;
			}
			for (int i = 0; i < _shooters.Count; i++)
			{
				if (_shooters[i] != shooter && _shooters[i].IsAttached)
				{
					return;
				}
			}
			Vector3 v = _rb.linearVelocity;
			float speed = v.magnitude;
			if (speed >= releaseBoostMinSpeed)
			{
				v += v / speed * releaseBoost + Vector3.up * releaseUpBoost;
				v = Vector3.ClampMagnitude(v, maxSpeed);
				_rb.linearVelocity = v;
			}
			ArmMomentumGuard(v);
		}

		public void DetachAll()
		{
			for (int i = 0; i < _shooters.Count; i++)
			{
				_shooters[i].Detach();
			}
		}

		private void FixedUpdate()
		{
			ResolvePlayer();
			if (_rb == null)
			{
				IsSwinging = false;
				return;
			}
			Speed = _rb.linearVelocity.magnitude;
			_taut.Clear();
			for (int i = 0; i < _shooters.Count; i++)
			{
				if (_shooters[i].IsAttached)
				{
					_taut.Add(_shooters[i]);
				}
			}
			IsSwinging = _taut.Count > 0;
			if (!IsSwinging)
			{
				RunMomentumGuard();
				return;
			}
			if (detachOnSurfaceGrab && TouchingSurface())
			{
				DetachAll();
				return;
			}
			float dt = Time.fixedDeltaTime;
			Vector3 origin = SwingOrigin;
			Vector3 v = _rb.linearVelocity;
			if (!TouchingSurface())
			{
				v += Physics.gravity * ((swingGravityMultiplier - 1f) * dt);
				v -= v * Mathf.Clamp01(airDrag * dt);
				for (int j = 0; j < _taut.Count; j++)
				{
					v = ApplyEnergy(_taut[j], origin, v, dt);
				}
			}
			for (int k = 0; k < _taut.Count; k++)
			{
				v = ApplyReel(_taut[k], origin, v, dt);
			}
			for (int l = 0; l < _taut.Count; l++)
			{
				ApplyAutoTuck(_taut[l], origin, v, dt);
			}
			for (int m = 0; m < _taut.Count; m++)
			{
				ApplyGroundClearance(_taut[m], origin, dt);
			}
			for (int n = 0; n < _taut.Count; n++)
			{
				SpiderApeWebShooter s = _taut[n];
				Vector3 offset = origin - s.AnchorWorld;
				float dist = offset.magnitude;
				if (dist < 0.0001f)
				{
					continue;
				}
				float stretch = dist - s.RopeLength;
				if (!(stretch <= 0f))
				{
					Vector3 dir = offset / dist;
					float outward = Vector3.Dot(v, dir);
					float accel = stretch * springStiffness;
					if (outward > 0f)
					{
						accel += outward * springDamping;
					}
					accel = Mathf.Min(accel, maxSpringAccel);
					v -= dir * (dt * (Tension(s) * accel));
				}
			}
			if (v.sqrMagnitude > maxSpeed * maxSpeed)
			{
				v = v.normalized * maxSpeed;
			}
			_rb.linearVelocity = v;
			ArmMomentumGuard(v);
			Speed = v.magnitude;
			if (!(breakStretch > 0f))
			{
				return;
			}
			for (int num = _taut.Count - 1; num >= 0; num--)
			{
				SpiderApeWebShooter s2 = _taut[num];
				float stretched = Vector3.Distance(origin, s2.AnchorWorld);
				if (stretched > s2.RopeLength * (1f + breakStretch))
				{
					Debug.Log(string.Format("[SpiderApe] {0} web snapped — stretched to {1:F1}m on a {2:F1}m line.", s2.Hand, stretched, s2.RopeLength), s2);
					s2.Break();
				}
			}
		}

		private void ArmMomentumGuard(Vector3 v)
		{
			_guardVelocity = v;
			_guardUntil = Time.time + momentumGuardTime;
		}

		private void RunMomentumGuard()
		{
			if (momentumGuardTime <= 0f || Time.time > _guardUntil)
			{
				return;
			}
			if (_rb == null || TouchingSurface())
			{
				_guardUntil = 0f;
				return;
			}
			Vector3 linearVelocity = _rb.linearVelocity;
			if (linearVelocity.sqrMagnitude < 0.04f && _guardVelocity.sqrMagnitude > 4f)
			{
				_rb.linearVelocity = _guardVelocity;
				Speed = _guardVelocity.magnitude;
			}
			else
			{
				_guardVelocity = linearVelocity;
			}
		}

		private float Tension(SpiderApeWebShooter s)
		{
			if (tautBlendTime <= 0f)
			{
				return 1f;
			}
			return Mathf.Clamp01((Time.time - s.LandedTime) / tautBlendTime);
		}

		private bool TouchingSurface()
		{
			if (_player == null)
			{
				return false;
			}
			return _player.wasLeftHandTouching || _player.wasRightHandTouching || _player.wasLeftHandSlide || _player.wasRightHandSlide;
		}

		private Vector3 ApplyEnergy(SpiderApeWebShooter s, Vector3 origin, Vector3 v, float dt)
		{
			Vector3 rope = origin - s.AnchorWorld;
			float length = rope.magnitude;
			if (length < 0.01f)
			{
				return v;
			}
			Vector3 n = rope / length;
			Vector3 tangent = Vector3.ProjectOnPlane(v, n);
			Vector3 along;
			if (tangent.sqrMagnitude > 0.01f)
			{
				along = tangent.normalized;
			}
			else
			{
				Vector3 facing = Vector3.ProjectOnPlane(((_cam != null) ? _cam : transform).forward, n);
				if (facing.sqrMagnitude < 0.0001f)
				{
					return v;
				}
				along = facing.normalized;
			}
			Vector3 side = Vector3.Cross(along, n).normalized;
			Vector2 steer = s.Steer;
			Vector3 hand = s.HandVelocity;
			float pump = autoPumpAccel + steer.y * pumpAccel;
			if (hand.sqrMagnitude > handDeadzone * handDeadzone)
			{
				float radial = Vector3.Dot(n, hand);
				float pull = (handPullDirection == HandPullDirection.TowardAnchor) ? (0f - radial) : radial;
				if (pull > 0f)
				{
					s.BaseRopeLength = Mathf.Max(minRopeLength, s.BaseRopeLength - Mathf.Min(pull * handPullGain, handPullMaxRate) * dt);
				}
				Vector3 across = Vector3.ProjectOnPlane(hand, n);
				v += Vector3.ClampMagnitude(across * handSwingGain, handSwingMaxAccel) * dt;
			}
			return v + along * (pump * dt) + side * (steer.x * steerAccel * dt);
		}

		private void ApplyGroundClearance(SpiderApeWebShooter s, Vector3 origin, float dt)
		{
			if (!autoShortenForGround || s.BaseRopeLength <= 0f)
			{
				return;
			}
			float dist = Vector3.Distance(origin, s.AnchorWorld);
			if (!(s.BaseRopeLength - dist <= 0.05f) && Physics.Raycast(s.AnchorWorld, Vector3.down, out var hitInfo, s.BaseRopeLength + groundClearance, s.AttachMask, QueryTriggerInteraction.Ignore))
			{
				float maxLength = hitInfo.distance - groundClearance;
				if (s.BaseRopeLength > maxLength)
				{
					s.BaseRopeLength = Mathf.MoveTowards(s.BaseRopeLength, Mathf.Max(maxLength, dist), groundClearanceRate * dt);
				}
			}
		}

		private Vector3 ApplyReel(SpiderApeWebShooter s, Vector3 origin, Vector3 v, float dt)
		{
			if (!s.ReelHeld)
			{
				return v;
			}
			s.BaseRopeLength = Mathf.Max(minRopeLength, s.BaseRopeLength - reelSpeed * dt);
			Vector3 toAnchor = s.AnchorWorld - origin;
			float dist = toAnchor.magnitude;
			if (dist < 0.01f)
			{
				return v;
			}
			return v + toAnchor / dist * (reelAccel * dt);
		}

		private void ApplyAutoTuck(SpiderApeWebShooter s, Vector3 origin, Vector3 v, float dt)
		{
			if (s.BaseRopeLength <= 0f)
			{
				s.RopeLength = 0f;
				return;
			}
			float target = 0f;
			if (autoTuck > 0f)
			{
				Vector3 rope = origin - s.AnchorWorld;
				float length = rope.magnitude;
				if (length > 0.01f)
				{
					Vector3 n = rope / length;
					float down = Mathf.Clamp01(Vector3.Dot(n, Vector3.down));
					float swing = Mathf.Clamp01(Vector3.ProjectOnPlane(v, n).magnitude / Mathf.Max(tuckFullSpeed, 0.01f));
					float depth = down * down;
					target = s.BaseRopeLength * autoTuck * depth * swing;
				}
			}
			s.TuckOffset = Mathf.MoveTowards(s.TuckOffset, target, tuckRate * dt);
			s.RopeLength = Mathf.Max(minRopeLength, s.BaseRopeLength - s.TuckOffset);
		}
	}
}
