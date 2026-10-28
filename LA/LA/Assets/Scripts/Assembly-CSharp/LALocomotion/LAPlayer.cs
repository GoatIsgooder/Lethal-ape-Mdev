using System;
using System.Collections.Generic;
using GorillaLocomotion;
using LethalApeR.Gameplay;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Gameplay.Monsters;
using UnityEngine;

namespace LALocomotion
{
	[DefaultExecutionOrder(-100)]
	[DisallowMultipleComponent]
	[RequireComponent(typeof(Rigidbody))]
	public class LAPlayer : MonoBehaviour, IPlayerDriver, IBlastReceiver
	{
		[Header("Slop Player bridge")]
		[Tooltip("Slop's Player on this rig. Empty = the one on this object, if any.")]
		public Player legacy;

		private Player _legacy;

		private float _legacyJump;

		private float _legacyCap;

		private float _legacyLimit;

		private float _legacyArm;

		private float _ownJump;

		private float _ownCap;

		private float _ownLimit;

		private float _ownArm;

		private float _launchScale = 1f;

		private Vector3 _realVelocity;

		private readonly Dictionary<Collider, Surface> _surfaces = new Dictionary<Collider, Surface>();

		[Header("Grabbing inside the world")]
		[Tooltip("Closing a hand can leave the item inside the world: a launcher snapped into the palm with its barrel through the wall. The rig is then pushed straight back out the way the item went in, up to this far (scaled with the rig), so it starts clear instead of pinning the hand inside the wall. 0 = never push.")]
		public float maxGrabPushOut = 0.8f;

		private static readonly Collider[] GrabOverlaps = new Collider[16];

		private readonly List<LAContact> _grabbed = new List<LAContact>();

		private readonly List<LAContact> _anchors = new List<LAContact>();

		private const float BackBias = 0.6f;

		private const float GrabRestDepth = 0.015f;

		[Header("Knockback")]
		[Tooltip("Radius of the body around the torso that blasts measure their distance to.")]
		public float blastBodyRadius = 0.35f;

		[Range(0f, 1f)]
		public float blastHapticAmplitude = 0.9f;

		public float blastHapticDuration = 0.25f;

		private float _letGoUntil = -1f;

		[Header("Moving platforms")]
		[Tooltip("Planted hands ride colliders under a MovingPlatform or BasePlatform (opt-in, like Slop's Player).")]
		public bool ridePlatforms = true;

		public bool ridePlatformYaw = true;

		[Tooltip("With no hand down, stand on a platform within reach below the head and travel with it.")]
		public bool bodyRidesPlatforms = true;

		public float bodyRideReach = 2.2f;

		public float bodyRideMaxSlope = 55f;

		[Min(0f)]
		public int bodyRideGraceFrames = 4;

		[Tooltip("Cap on the platform speed you keep when you let go.")]
		public float maxRideSpeed = 20f;

		[Tooltip("A bigger platform jump in one frame is a teleport: re-anchor instead of following.")]
		public float maxRideStep = 1.5f;

		public float rideVelocitySmoothTime = 0.08f;

		private readonly Dictionary<Collider, bool> _platforms = new Dictionary<Collider, bool>();

		private readonly RaycastHit[] _rideHits = new RaycastHit[8];

		private Vector3 _rideVelocity;

		private Vector3 _rideDamp;

		private bool _ridingLast;

		private bool _ridingNow;

		private Transform _bodyRide;

		private Vector3 _bodyRideLocal;

		private Vector3 _bodyRideFoot;

		private Quaternion _bodyRideRotation = Quaternion.identity;

		private int _bodyRideMisses;

		[Header("Scale")]
		[Tooltip("Size the rig grows or shrinks to (size mods). Scales turnPivot about its origin, like Slop's Player, so a bigger ape stands taller; reach, gravity, the launch cap and the torso scale with it.")]
		public float targetScale = 1f;

		[Tooltip("How fast the size follows targetScale (lerp rate per second).")]
		public float scaleSpeed = 1f;

		private int _slipFrame = -1;

		private static readonly Collider[] Embedding = new Collider[8];

		[Header("Turning items")]
		[Tooltip("Sweeps only move a hand collider. A long held item that turns can end up inside the world where no sweep sees it, so after each move it is pushed back out the shortest way, and that push moves the body: twist a planted stick and you lever yourself up, swing a launcher into a wall and you push off it.")]
		public bool pushOutTurnedItems = true;

		[Range(1f, 4f)]
		public int pushOutPasses = 3;

		[Tooltip("Overlaps shallower than this are surface contact, not penetration (keeps planted items from creeping).")]
		public float pushOutSlop = 0.002f;

		private static readonly Collider[] Penetrating = new Collider[16];

		[Header("Rig")]
		public SphereCollider headCollider;

		[Tooltip("Torso capsule. Kept under the head every step; must not be a child of the camera.")]
		public CapsuleCollider bodyCollider;

		[Tooltip("Rotated by Turn() and by turning platforms. Empty = this transform.")]
		public Transform turnPivot;

		public Transform spawnPoint;

		public LAHand leftHand = new LAHand();

		public LAHand rightHand = new LAHand();

		[Header("Launch")]
		[Tooltip("Flunklug averages the body's last 8 steps.")]
		[Min(1f)]
		public int velocityHistorySize = 8;

		[Tooltip("Flunklug divides each step's movement by 0.02 s, so its x2 launch is x1.39 of your arm speed on a 72 Hz Quest. 0 = divide by the real time instead (a literal x2).")]
		[Min(0f)]
		public float historyStepSeconds = 0.02f;

		[Tooltip("Frame rate the history window is measured at: 8 steps at 72 Hz = the last 111 ms. The launch then feels like a 72 Hz Quest at any frame rate (desktop at 150 fps included). 0 = count frames like Flunklug, so launches weaken as the frame rate rises.")]
		[Min(0f)]
		public float historyReferenceHz = 72f;

		public float jumpMultiplier = 2f;

		public float maxJumpSpeed = 10.5f;

		[Tooltip("Averaged speed below which letting go adds nothing.")]
		public float velocityLimit = 0.01f;

		[Header("Hands")]
		[Tooltip("Hand colliders further than this from the head are pulled back to it. Long, so held poles still reach.")]
		public float maxArmLength = 4f;

		[Tooltip("A pinned collider whose tracked position drifts this far away lets go, if the head can see it.")]
		public float unStickDistance = 1f;

		[Tooltip("Sweep radius used for mesh colliders.")]
		public float meshColliderRadius = 0.04f;

		[Tooltip("Sweep skin. Closer to 1 = tighter contact.")]
		[Range(0.9f, 0.9999f)]
		public float precision = 0.999f;

		[Tooltip("How far planted hands creep along surfaces with no Surface component, both hands down. Flunklug tags every level surface with slip 0, so 0 is the game's feel (its untagged fallback is 0.1). A Surface component uses its own slipPercentage.")]
		[Range(0f, 1f)]
		public float bracedSlip;

		[Tooltip("Same, with one hand down (Flunklug's untagged fallback: 0.001).")]
		[Range(0f, 1f)]
		public float singleHandSlip;

		[Header("Landing skid")]
		public float slideDuration = 0.13f;

		[Tooltip("Share of the pre-contact velocity along the surface you keep skidding with.")]
		[Range(0f, 1f)]
		public float slideShare = 0.12f;

		[Header("Physics")]
		public LayerMask locomotionLayers = 1;

		public bool castsHitTriggers;

		[Tooltip("Torso capsule rides the head's tilt like Flunklug's (its bone is pinned in the head-locked armature and only kept upright), so it swings forward when you look down. Off = head yaw only, at bodyOffset.")]
		public bool bodyFollowsHeadTilt = true;

		[Tooltip("Torso capsule centre from the eyes, in head-yaw space (used with bodyFollowsHeadTilt off).")]
		public Vector3 bodyOffset = new Vector3(0f, -0.393f, -0.203f);

		[Header("Safety")]
		[Tooltip("A head jump bigger than this in one step (on top of the body's own speed) is tracking noise; the rig is put back.")]
		public float teleportThreshold = 1f;

		[Tooltip("Hold the rig still while the system menu is up (tracking is unreliable then).")]
		public bool pauseOnSystemOverlay = true;

		[Header("Touch feedback")]
		public float hapticAmplitude = 0.4f;

		public float hapticDuration = 0.2f;

		[Tooltip("Shortest gap between two touch sounds or buzzes on one hand.")]
		public float feedbackInterval = 0.05f;

		public LASurfaceSound[] surfaceSounds = new LASurfaceSound[0];

		[Header("State")]
		public bool disableMovement;

		public bool inOverlay;

		private Rigidbody _body;

		private bool _ready;

		private float _dt = 1f / 72f;

		private Vector3 _lastHead;

		private Vector3 _lastOpenHead;

		private Vector3 _lastRoot;

		private const int HistoryCapacity = 256;

		private readonly Vector3[] _historyMove = new Vector3[HistoryCapacity];

		private readonly float[] _historyTime = new float[HistoryCapacity];

		private int _historyHead;

		private int _historyCount;

		private float _frameTime = 1f / 72f;

		private Vector3 _averageVelocity;

		private Vector3 _currentVelocity;

		private Vector3 _preContactVelocity;

		private Vector3 _slideVelocity;

		private float _slideTime;

		private bool _overlayHeld;

		private bool _overlaySavedKinematic;

		private int _frozenMask;

		private static readonly Vector3 TorsoBoneFromEye = new Vector3(0f, -0.206f, -0.159f);

		private static readonly Vector3 TorsoCentreFromBone = new Vector3(0f, -0.187f, -0.044f);

		public Player Legacy => _legacy;

		public Vector3 RealVelocity => _realVelocity;

		private void BindLegacy()
		{
			_legacy = legacy != null ? legacy : GetComponent<Player>();
			if (_legacy == null)
			{
				return;
			}
			_ownJump = jumpMultiplier;
			_ownCap = maxJumpSpeed;
			_ownLimit = velocityLimit;
			_ownArm = maxArmLength;
			_legacy.SetDriver(this);
			_legacyJump = _legacy.jumpMultiplier;
			_legacyCap = _legacy.maxJumpSpeed;
			_legacyLimit = _legacy.velocityLimit;
			_legacyArm = _legacy.maxArmLength;
		}

		private void UnbindLegacy()
		{
			if (_legacy != null && _legacy.Driver == this)
			{
				_legacy.SetDriver(null);
			}
		}

		private static float Ratio(float value, float baseline)
		{
			return Mathf.Abs(baseline) > 1E-06f ? value / baseline : 1f;
		}

		private void PullLegacy()
		{
			if (_legacy == null)
			{
				return;
			}
			disableMovement = _legacy.disableMovement;
			jumpMultiplier = _ownJump * Ratio(_legacy.jumpMultiplier, _legacyJump);
			maxJumpSpeed = _ownCap * Ratio(_legacy.maxJumpSpeed, _legacyCap);
			velocityLimit = _ownLimit * Ratio(_legacy.velocityLimit, _legacyLimit);
			maxArmLength = _ownArm * Ratio(_legacy.maxArmLength, _legacyArm) * Mathf.Max(_legacy.armReachMultiplier, 0.01f);
			_launchScale = _legacy.speedMultiplier;
			targetScale = _legacy.targetScale;
			scaleSpeed = _legacy.scaleSpeed;
			if (_legacy.defaultSlideFactor > 0f && _legacy.defaultSlideFactor > _legacy.iceThreshold)
			{
				_slipFrame = Time.frameCount;
			}
			if (leftHand.wrist != null)
			{
				leftHand.wrist.offset = _legacy.leftHandOffset;
				leftHand.wrist.reach = _legacy.armReachMultiplier;
			}
			if (rightHand.wrist != null)
			{
				rightHand.wrist.offset = _legacy.rightHandOffset;
				rightHand.wrist.reach = _legacy.armReachMultiplier;
			}
		}

		private void PushLegacy()
		{
			if (_legacy == null)
			{
				return;
			}
			_legacy.wasLeftHandTouching = leftHand.touching;
			_legacy.wasRightHandTouching = rightHand.touching;
			bool slipping = _slipFrame == Time.frameCount;
			_legacy.leftHandSlide = _legacy.wasLeftHandSlide = slipping && leftHand.touching;
			_legacy.rightHandSlide = _legacy.wasRightHandSlide = slipping && rightHand.touching;
			_legacy.leftHandSurfaceOverride = TouchedSurface(leftHand, out _legacy.leftHandSlideNormal);
			_legacy.rightHandSurfaceOverride = TouchedSurface(rightHand, out _legacy.rightHandSlideNormal);
			_legacy.currentVelocity = _realVelocity;
			_legacy.lastHeadPosition = HeadPosition;
			_legacy.inOverlay = inOverlay;
		}

		public void CollectHandColliders(List<Collider> into)
		{
			AddColliders(leftHand, into);
			AddColliders(rightHand, into);
		}

		private static void AddColliders(LAHand hand, List<Collider> into)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				if (hand.contacts[i].collider != null && !into.Contains(hand.contacts[i].collider))
				{
					into.Add(hand.contacts[i].collider);
				}
			}
		}

		private Surface TouchedSurface(LAHand hand, out Vector3 normal)
		{
			normal = Vector3.up;
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (c.touching)
				{
					normal = c.lastNormal;
					return SurfaceOf(c.lastHit);
				}
			}
			return null;
		}

		float IPlayerDriver.Scale => Scale;

		void IPlayerDriver.TeleportRig(Vector3 position, Quaternion rotation, bool setRotation, bool resetVelocity)
		{
			TeleportPlayerRaw(position, rotation, setRotation, resetVelocity);
		}

		void IPlayerDriver.TurnRig(float degrees)
		{
			if (!_ready || Mathf.Abs(degrees) < 1E-05f)
			{
				return;
			}
			RotateRig(degrees, false);
		}

		void IPlayerDriver.ReinitializeRig()
		{
			if (_ready)
			{
				SnapWrists();
				Initialize(false);
			}
		}

		private void AddSerializedColliders(LAHand hand)
		{
			for (int i = 0; i < hand.colliders.Count; i++)
			{
				Collider c = hand.colliders[i];
				if (c != null && hand.IndexOf(c) < 0)
				{
					hand.contacts.Add(new LAContact(c, TrackedCenter(c)));
				}
			}
		}

		private void ResetContacts(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (c.collider != null)
				{
					c.Reset(TrackedCenter(c.collider));
				}
			}
			hand.touching = false;
		}

		public Vector3 TrackedCenter(Collider c)
		{
			Vector3 center = LAShape.Center(c);
			Vector3 head = HeadPosition;
			Vector3 offset = center - head;
			float reach = maxArmLength * Scale;
			if (offset.sqrMagnitude > reach * reach)
			{
				return head + offset.normalized * reach;
			}
			return center;
		}

		private LAShape ShapeOf(Collider c)
		{
			return LAShape.Of(c, meshColliderRadius * Scale);
		}

		private bool PushPass(LAHand hand, bool left, out Vector3 push)
		{
			push = Vector3.zero;
			PruneSuspenders(hand);
			if (hand.Suspended)
			{
				RestSuspended(hand);
				return false;
			}
			if (IsLettingGo)
			{
				SlidePass(hand);
				return false;
			}
			bool slipping = _slipFrame == Time.frameCount;
			Vector3 sag = Physics.gravity * (2f * _dt * _dt * Scale);
			int touched = 0;
			List<LAContact> contacts = hand.contacts;
			for (int i = 0; i < contacts.Count; i++)
			{
				LAContact c = contacts[i];
				RefreshGhost(c, hand);
				if (c.ghost || !c.Present)
				{
					if (c.collider != null)
					{
						c.resolved = TrackedCenter(c.collider);
					}
					c.rideTransform = null;
					c.touching = false;
					continue;
				}
				Vector3 target = TrackedCenter(c.collider);
				LAShape shape = ShapeOf(c.collider);
				if (slipping)
				{
					Unembed(c.collider, shape, ref c.resolved);
				}
				bool hit = Resolve(c.resolved, shape, sag + (target - c.resolved), false, out Vector3 end, out RaycastHit hitInfo);
				Vector3 at = hit ? ((c.wasTouching && !slipping) ? c.resolved : end) : target;
				bool pushed = PushOutOfWorld(c.collider, shape, ref at, out Collider wall);
				if (!hit && !pushed)
				{
					c.touching = false;
					continue;
				}
				if (pushed)
				{
					c.resolved = at;
				}
				push += at - target;
				if (hit)
				{
					c.lastHit = hitInfo.collider;
					c.lastNormal = hitInfo.normal;
					if (!c.wasTouching)
					{
						if (!slipping)
						{
							StartSkid(hitInfo);
						}
						TouchFeedback(hand, left, hitInfo);
					}
				}
				else
				{
					c.lastHit = wall;
					if (!c.wasTouching)
					{
						Buzz(hand, left, wall);
					}
				}
				c.touching = true;
				touched++;
			}
			if (touched == 0)
			{
				return false;
			}
			if (!_body.isKinematic && !slipping)
			{
				_body.linearVelocity = Vector3.zero;
			}
			push /= touched;
			return true;
		}

		private bool SettlePass(LAHand hand, bool singleHand)
		{
			if (IsLettingGo || hand.Suspended)
			{
				return false;
			}
			bool any = false;
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (c.ghost || !c.Present)
				{
					continue;
				}
				Vector3 target = TrackedCenter(c.collider);
				LAShape shape = ShapeOf(c.collider);
				bool hit = Resolve(c.resolved, shape, target - c.resolved, !singleHand, out Vector3 end, out RaycastHit hitInfo);
				Vector3 at = hit ? end : target;
				bool pushed = PushOutOfWorld(c.collider, shape, ref at, out Collider wall);
				c.resolved = at;
				if (hit || pushed)
				{
					c.touching = true;
					if (hit)
					{
						c.lastHit = hitInfo.collider;
						c.lastNormal = hitInfo.normal;
					}
					else
					{
						c.lastHit = wall;
					}
					any = true;
				}
			}
			return any;
		}

		private void Unstick(LAHand hand)
		{
			float limit = unStickDistance * Scale;
			limit *= limit;
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (!c.touching || c.ghost || !c.Present)
				{
					continue;
				}
				Vector3 tracked = TrackedCenter(c.collider);
				if ((tracked - c.resolved).sqrMagnitude <= limit)
				{
					continue;
				}
				Vector3 head = HeadPosition;
				Vector3 toward = tracked - head;
				float distance = toward.magnitude;
				LAShape shape = ShapeOf(c.collider);
				if (distance > shape.thickness && Physics.SphereCast(head, shape.thickness * precision, toward / distance, out RaycastHit _, distance - shape.thickness, Mask, Triggers))
				{
					continue;
				}
				c.resolved = tracked;
				c.rideTransform = null;
				c.touching = false;
			}
		}

		private static void Roll(LAHand hand)
		{
			bool any = false;
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				c.wasTouching = c.touching;
				any |= c.touching;
			}
			hand.touching = any;
		}

		private static void ShiftContacts(LAHand hand, Vector3 delta, bool skipRiders)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (skipRiders && c.wasTouching && c.rideTransform != null)
				{
					continue;
				}
				c.resolved += delta;
			}
		}

		private static void RotateContacts(LAHand hand, Vector3 pivot, Quaternion q)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				hand.contacts[i].resolved = pivot + q * (hand.contacts[i].resolved - pivot);
			}
		}

		private void StartSkid(RaycastHit hit)
		{
			if (slideDuration <= 0f || slideShare <= 0f)
			{
				return;
			}
			_slideVelocity = Vector3.ProjectOnPlane(_preContactVelocity, hit.normal) * slideShare;
			_slideTime = slideDuration;
		}

		private void Skid()
		{
			if (_slideTime <= 0f || !IsTouchingAnything)
			{
				_slideTime = 0f;
				_slideVelocity = Vector3.zero;
				return;
			}
			_slideTime -= _dt;
			Vector3 step = _slideVelocity * (_dt * Mathf.Clamp01(_slideTime / slideDuration));
			if (_slideTime <= 0f)
			{
				_slideVelocity = Vector3.zero;
			}
			if (step.sqrMagnitude < 1E-10f)
			{
				return;
			}
			if (Resolve(_lastHead, LAShape.Sphere(HeadRadius), step, true, out Vector3 end, out RaycastHit hit))
			{
				_slideVelocity = Vector3.ProjectOnPlane(_slideVelocity, hit.normal);
				step = end - _lastHead;
			}
			transform.position += step;
			SkidContacts(leftHand, step);
			SkidContacts(rightHand, step);
			_lastHead = HeadPosition;
		}

		private void SkidContacts(LAHand hand, Vector3 step)
		{
			if (hand.Suspended)
			{
				return;
			}
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (c.ghost || !c.Present)
				{
					continue;
				}
				if (Resolve(c.resolved, ShapeOf(c.collider), step, false, out Vector3 end, out RaycastHit hit))
				{
					_slideVelocity = Vector3.ProjectOnPlane(_slideVelocity, hit.normal);
					c.resolved = end;
				}
				else
				{
					c.resolved += step;
				}
			}
		}

		private Surface SurfaceOf(Collider c)
		{
			if (c == null)
			{
				return null;
			}
			if (!_surfaces.TryGetValue(c, out Surface surface))
			{
				surface = c.GetComponent<Surface>();
				_surfaces[c] = surface;
			}
			return surface;
		}

		private float SlipFor(Collider c, bool braced)
		{
			Surface surface = SurfaceOf(c);
			if (surface != null)
			{
				return surface.slipPercentage;
			}
			return braced ? bracedSlip : singleHandSlip;
		}

		private void SurfaceBoost(out float boost, out float capBoost)
		{
			boost = 1f;
			capBoost = 1f;
			AccumulateBoost(leftHand, ref boost, ref capBoost);
			AccumulateBoost(rightHand, ref boost, ref capBoost);
		}

		private void AccumulateBoost(LAHand hand, ref float boost, ref float capBoost)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (!c.wasTouching)
				{
					continue;
				}
				Surface surface = SurfaceOf(c.lastHit);
				if (surface != null)
				{
					boost = Mathf.Max(boost, surface.extraVelMultiplier);
					capBoost = Mathf.Max(capBoost, surface.extraVelMaxMultiplier);
				}
			}
		}

		private void TouchFeedback(LAHand hand, bool left, RaycastHit hit)
		{
			Buzz(hand, left, hit.collider);
			HandTouched?.Invoke(left, hit);
		}

		private void Buzz(LAHand hand, bool left, Collider surface)
		{
			float now = Time.unscaledTime;
			if (hand.feedbackFrame == Time.frameCount || now - hand.lastFeedbackTime < feedbackInterval)
			{
				return;
			}
			hand.lastFeedbackTime = now;
			hand.feedbackFrame = Time.frameCount;
			VRInputController input = VRInputController.Instance;
			if (input != null && hapticAmplitude > 0f && hapticDuration > 0f)
			{
				if (left)
				{
					input.PulseLeft(hapticAmplitude, hapticDuration);
				}
				else
				{
					input.PulseRight(hapticAmplitude, hapticDuration);
				}
			}
			if (hand.audioSource == null)
			{
				return;
			}
			AudioClip clip = SurfaceClip(surface, out float volume);
			if (clip == null)
			{
				clip = hand.fallbackTouchClip;
				volume = 1f;
			}
			if (clip != null)
			{
				hand.audioSource.PlayOneShot(clip, volume);
			}
		}

		private AudioClip SurfaceClip(Collider c, out float volume)
		{
			volume = 1f;
			PhysicsMaterial material = c != null ? c.sharedMaterial : null;
			if (material == null || surfaceSounds == null)
			{
				return null;
			}
			for (int i = 0; i < surfaceSounds.Length; i++)
			{
				LASurfaceSound s = surfaceSounds[i];
				if (s == null || s.material == null || s.clips == null || s.clips.Length == 0)
				{
					continue;
				}
				if (s.material == material || material.name.StartsWith(s.material.name))
				{
					volume = s.volume;
					return s.clips[UnityEngine.Random.Range(0, s.clips.Length)];
				}
			}
			return null;
		}

		private bool CanPushRig => _ready && !IsFrozen && !_overlayHeld && !disableMovement && !Body.isKinematic && maxGrabPushOut > 0f;

		public void SettleGrabbed(bool left, IReadOnlyList<Collider> colliders, bool push = true)
		{
			if (colliders == null || !_ready)
			{
				return;
			}
			LAHand hand = Hand(left);
			_grabbed.Clear();
			for (int i = 0; i < colliders.Count; i++)
			{
				int index = hand.IndexOf(colliders[i]);
				if (index >= 0 && hand.contacts[index].Present)
				{
					_grabbed.Add(hand.contacts[index]);
				}
			}
			if (_grabbed.Count == 0)
			{
				return;
			}
			Physics.SyncTransforms();
			Vector3 palm = PalmCenter(hand);
			if (EmbeddedCentroid(palm, out Vector3 centroid, out Vector3 shortest))
			{
				if (push && CanPushRig && FindGrabPushOut(hand, palm, centroid, shortest, out Vector3 delta))
				{
					PushRig(delta);
					palm += delta;
				}
				for (int j = 0; j < _grabbed.Count; j++)
				{
					LAContact c = _grabbed[j];
					c.resolved = TrackedCenter(c.collider);
					if (Embedded(c.collider, c.resolved, palm, out Vector3 _, c.ghostIgnores))
					{
						BeginGhost(c);
					}
				}
			}
			_grabbed.Clear();
			_anchors.Clear();
		}

		private void RefreshGhost(LAContact c, LAHand hand)
		{
			if (!c.ghost)
			{
				return;
			}
			if (!c.Present)
			{
				EndGhost(c);
				return;
			}
			int from = c.ghostIgnores.Count;
			if (Embedded(c.collider, TrackedCenter(c.collider), PalmCenter(hand), out Vector3 _, c.ghostIgnores))
			{
				IgnoreGhostHits(c, from);
				return;
			}
			EndGhost(c);
			c.resolved = TrackedCenter(c.collider);
		}

		private static void BeginGhost(LAContact c)
		{
			c.ghost = true;
			c.touching = false;
			c.wasTouching = false;
			c.rideTransform = null;
			IgnoreGhostHits(c, 0);
		}

		private static void IgnoreGhostHits(LAContact c, int from)
		{
			for (int i = from; i < c.ghostIgnores.Count; i++)
			{
				if (c.ghostIgnores[i] != null)
				{
					Physics.IgnoreCollision(c.collider, c.ghostIgnores[i], true);
				}
			}
		}

		private static void EndGhost(LAContact c)
		{
			c.ghost = false;
			if (c.collider != null)
			{
				for (int i = 0; i < c.ghostIgnores.Count; i++)
				{
					if (c.ghostIgnores[i] != null)
					{
						Physics.IgnoreCollision(c.collider, c.ghostIgnores[i], false);
					}
				}
			}
			c.ghostIgnores.Clear();
		}

		private bool FindGrabPushOut(LAHand hand, Vector3 palm, Vector3 buried, Vector3 shortest, out Vector3 delta)
		{
			_anchors.Clear();
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (!c.ghost && c.Present && !_grabbed.Contains(c))
				{
					_anchors.Add(c);
				}
			}
			float max = maxGrabPushOut * Scale;
			bool found = TryPushOut(palm, palm - buried, max, out delta);
			float best = found ? delta.magnitude * BackBias : float.MaxValue;
			ConsiderPushOut(palm, HeadPosition - buried, max, ref delta, ref best, ref found);
			ConsiderPushOut(palm, shortest, max, ref delta, ref best, ref found);
			return found;
		}

		private void ConsiderPushOut(Vector3 palm, Vector3 direction, float max, ref Vector3 delta, ref float best, ref bool found)
		{
			if (TryPushOut(palm, direction, Mathf.Min(max, best), out Vector3 candidate))
			{
				float length = candidate.magnitude;
				if (length < best)
				{
					delta = candidate;
					best = length;
					found = true;
				}
			}
		}

		private bool TryPushOut(Vector3 palm, Vector3 direction, float max, out Vector3 delta)
		{
			delta = Vector3.zero;
			float length = direction.magnitude;
			if (length < 0.0001f)
			{
				return false;
			}
			Vector3 dir = direction / length;
			float step = Scale * 0.04f;
			float lo = 0f;
			float hi = -1f;
			for (float t = step; t < max + step; t += step)
			{
				float probe = Mathf.Min(t, max);
				if (!GrabbedEmbedded(palm, dir * probe))
				{
					hi = probe;
					break;
				}
				lo = probe;
				if (probe >= max)
				{
					break;
				}
			}
			if (hi < 0f)
			{
				return false;
			}
			for (int i = 0; i < 6; i++)
			{
				float mid = (lo + hi) * 0.5f;
				if (GrabbedEmbedded(palm, dir * mid))
				{
					lo = mid;
				}
				else
				{
					hi = mid;
				}
			}
			delta = dir * (hi + pushOutSlop);
			float distance = delta.magnitude;
			float radius = HeadRadius * 0.9f;
			Vector3 head = HeadPosition;
			if (Physics.SphereCast(head, radius, dir, out RaycastHit _, distance, Mask, Triggers))
			{
				return false;
			}
			if (!Physics.CheckSphere(head, radius, Mask, Triggers) && Physics.CheckSphere(head + delta, radius, Mask, Triggers))
			{
				return false;
			}
			for (int j = 0; j < _anchors.Count; j++)
			{
				LAContact a = _anchors[j];
				if (ShapeOf(a.collider).Shrunk(precision).Sweep(a.resolved, dir, distance, Mask, Triggers, out RaycastHit _))
				{
					return false;
				}
			}
			return true;
		}

		private void PushRig(Vector3 delta)
		{
			MoveBy(delta);
			_lastRoot += delta;
			Unbury(leftHand);
			Unbury(rightHand);
			LetGo(leftHand);
			LetGo(rightHand);
			Physics.SyncTransforms();
		}

		private void Unbury(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact c = hand.contacts[i];
				if (!c.ghost && c.Present && !_grabbed.Contains(c) && Buried(c.collider, c.resolved, out Vector3 push, null))
				{
					c.resolved += push;
				}
			}
		}

		private bool GrabbedEmbedded(Vector3 palm, Vector3 offset)
		{
			Vector3 moved = palm + offset;
			for (int i = 0; i < _grabbed.Count; i++)
			{
				if (Embedded(_grabbed[i].collider, TrackedCenter(_grabbed[i].collider) + offset, moved, out Vector3 _, null))
				{
					return true;
				}
			}
			return false;
		}

		private bool EmbeddedCentroid(Vector3 palm, out Vector3 centroid, out Vector3 shortest)
		{
			shortest = Vector3.zero;
			centroid = Vector3.zero;
			int count = 0;
			for (int i = 0; i < _grabbed.Count; i++)
			{
				Vector3 center = TrackedCenter(_grabbed[i].collider);
				if (Embedded(_grabbed[i].collider, center, palm, out Vector3 push, null))
				{
					count++;
					centroid += center;
					shortest += push;
				}
			}
			if (count != 0)
			{
				centroid /= count;
			}
			return count != 0;
		}

		private bool Embedded(Collider c, Vector3 center, Vector3 palm, out Vector3 push, List<Collider> into)
		{
			if (Buried(c, center, out push, into))
			{
				return true;
			}
			return Physics.Linecast(palm, center, Mask, Triggers);
		}

		private bool Buried(Collider c, Vector3 center, out Vector3 push, List<Collider> into)
		{
			push = Vector3.zero;
			Transform t = c.transform;
			Vector3 position = t.position;
			Vector3 shapeCenter = LAShape.Center(c);
			float slop = Mathf.Max(pushOutSlop, Scale * GrabRestDepth);
			bool penetrable = !(c is MeshCollider mesh) || mesh.convex;
			LAShape shape = ShapeOf(c);
			int n = shape.Overlap(center, GrabOverlaps, Mask, Triggers);
			bool any = false;
			Vector3 at = center + (position - shapeCenter);
			for (int i = 0; i < n; i++)
			{
				Collider other = GrabOverlaps[i];
				if (other == null || other == c || other.transform.IsChildOf(transform))
				{
					continue;
				}
				if (penetrable)
				{
					if (!Physics.ComputePenetration(c, at, t.rotation, other, other.transform.position, other.transform.rotation, out Vector3 direction, out float distance) || distance <= slop)
					{
						continue;
					}
					push += direction * distance;
				}
				if (into != null && !into.Contains(other))
				{
					into.Add(other);
				}
				any = true;
			}
			Array.Clear(GrabOverlaps, 0, n);
			return any;
		}

		private Vector3 PalmCenter(LAHand hand)
		{
			Collider c = hand.colliders.Count > 0 ? hand.colliders[0] : null;
			if (c != null)
			{
				int index = hand.IndexOf(c);
				if (index >= 0)
				{
					LAContact contact = hand.contacts[index];
					float reach = Scale * 0.1f;
					if ((contact.resolved - TrackedCenter(c)).sqrMagnitude <= reach * reach)
					{
						return contact.resolved;
					}
				}
			}
			return HeadPosition;
		}

		public bool IsLettingGo => Time.time < _letGoUntil;

		public Vector3 BlastPivot => bodyCollider != null ? bodyCollider.bounds.center : HeadPosition;

		public float BlastBodyRadius => blastBodyRadius * Scale;

		public void Knockback(Vector3 velocityChange, float maxSpeed, float letGoSeconds = 0.2f)
		{
			Rigidbody body = Body;
			if (!_ready || body.isKinematic || IsFrozen || disableMovement)
			{
				return;
			}
			Vector3 velocity = body.linearVelocity;
			if (_ridingNow || _ridingLast)
			{
				velocity += Vector3.ClampMagnitude(_rideVelocity, maxRideSpeed);
			}
			velocity = velocityChange + velocity;
			if (maxSpeed > 0f && velocity.sqrMagnitude > maxSpeed * maxSpeed)
			{
				velocity = velocity.normalized * maxSpeed;
			}
			LetGo(leftHand);
			LetGo(rightHand);
			ClearRide();
			_slideTime = 0f;
			_slideVelocity = Vector3.zero;
			_letGoUntil = Mathf.Max(_letGoUntil, Time.time + Mathf.Max(0f, letGoSeconds));
			transform.position += Vector3.up * 0.001f;
			body.position = transform.position;
			body.linearVelocity = velocity;
		}

		void IBlastReceiver.OnBlast(in BlastInfo blast, in BlastHit hit)
		{
			if (MonsterExclusionZone.Contains(HeadPosition))
			{
				return;
			}
			Vector3 velocityChange = hit.direction * ((hit.isSelf ? blast.selfScale : 1f) * (blast.knockbackSpeed * hit.strength));
			if (velocityChange.sqrMagnitude > 0.0001f)
			{
				Knockback(velocityChange, blast.maxSpeed, blast.letGoSeconds);
			}
			VRInputController input = VRInputController.Instance;
			float strength = Mathf.Clamp01(hit.strength);
			if (input == null)
			{
				return;
			}
			float amplitude = blastHapticAmplitude * (strength * 0.65f + 0.35f);
			if (amplitude > 0f && blastHapticDuration > 0f)
			{
				input.PulseLeft(amplitude, blastHapticDuration);
				input.PulseRight(amplitude, blastHapticDuration);
			}
		}

		private static void LetGo(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				contact.rideTransform = null;
				contact.touching = false;
				contact.wasTouching = false;
			}
			hand.touching = false;
		}

		private void SlidePass(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				contact.rideTransform = null;
				contact.touching = false;
				if (contact.collider == null)
				{
					continue;
				}
				Vector3 target = TrackedCenter(contact.collider);
				if (contact.Live)
				{
					LAShape shape = LAShape.Of(contact.collider, meshColliderRadius * Scale);
					Vector3 center = Resolve(contact.resolved, shape, target - contact.resolved, false, out Vector3 end, out RaycastHit _) ? end : target;
					PushOutOfWorld(contact.collider, shape, ref center, out Collider _);
					contact.resolved = center;
				}
				else
				{
					contact.resolved = target;
				}
			}
		}

		public bool IsRidingPlatform => _ridingNow;

		public Vector3 RidingVelocity => _rideVelocity;

		public bool IsPinnedTo(Collider c)
		{
			if (c != null)
			{
				if (!PinnedTo(leftHand, c))
				{
					return PinnedTo(rightHand, c);
				}
				return true;
			}
			return false;
		}

		public bool IsPinnedTo(Collider c, bool left)
		{
			if (c != null)
			{
				return PinnedTo(left ? leftHand : rightHand, c);
			}
			return false;
		}

		private static bool PinnedTo(LAHand hand, Collider c)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				if (hand.contacts[i].touching && hand.contacts[i].lastHit == c)
				{
					return true;
				}
			}
			return false;
		}

		private static bool PlatformsExist
		{
			get
			{
				if (MovingPlatform.ActiveCount > 0)
				{
					return true;
				}
				return BasePlatform.ActiveCount > 0;
			}
		}

		private bool IsPlatform(Collider c)
		{
			if (c == null)
			{
				return false;
			}
			if (_platforms.TryGetValue(c, out bool known))
			{
				return known;
			}
			bool result;
			if (c.transform.IsChildOf(transform))
			{
				result = false;
			}
			else
			{
				Transform root = (c.attachedRigidbody != null) ? c.attachedRigidbody.transform : c.transform;
				result = root.GetComponentInParent<MovingPlatform>() != null || root.GetComponentInParent<BasePlatform>() != null || c.GetComponentInParent<MovingPlatform>() != null || c.GetComponentInParent<BasePlatform>() != null;
			}
			_platforms[c] = result;
			return result;
		}

		private void RideStep()
		{
			_ridingNow = false;
			if (!ridePlatforms || _body.isKinematic || disableMovement || !PlatformsExist || IsLettingGo)
			{
				ClearRideAnchors(leftHand);
				ClearRideAnchors(rightHand);
				_bodyRide = null;
				return;
			}
			LAContact first = null;
			bool mixed = false;
			bool onStatic = false;
			ScanRiders(leftHand, ref first, ref mixed, ref onStatic);
			ScanRiders(rightHand, ref first, ref mixed, ref onStatic);
			if (first == null)
			{
				if (bodyRidesPlatforms && !IsTouchingAnything && _bodyRide != null)
				{
					RideOnBody();
				}
			}
			else if (onStatic)
			{
				FollowPins(leftHand);
				FollowPins(rightHand);
				ForgetRideVelocity();
			}
			else
			{
				RideOnHands(first, mixed);
			}
		}

		private static void ScanRiders(LAHand hand, ref LAContact first, ref bool mixed, ref bool onStatic)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				if (!contact.wasTouching)
				{
					continue;
				}
				if (contact.rideTransform == null)
				{
					onStatic = true;
				}
				else if (first == null)
				{
					first = contact;
				}
				else if (contact.rideTransform != first.rideTransform)
				{
					mixed = true;
				}
			}
		}

		private void RideOnHands(LAContact first, bool mixed)
		{
			if (ridePlatformYaw && !mixed)
			{
				float yaw = Mathf.DeltaAngle(first.rideRotation.eulerAngles.y, first.rideTransform.eulerAngles.y);
				if (Mathf.Abs(yaw) > 0.0001f)
				{
					RotateRig(yaw, true);
				}
			}
			Vector3 shift = Vector3.zero;
			int riders = 0;
			SumPinTravel(leftHand, ref shift, ref riders);
			SumPinTravel(rightHand, ref shift, ref riders);
			shift /= (float)riders;
			if (maxRideStep > 0f && shift.sqrMagnitude > maxRideStep * maxRideStep)
			{
				ReanchorPins(leftHand);
				ReanchorPins(rightHand);
				ForgetRideVelocity();
				return;
			}
			FollowPins(leftHand);
			FollowPins(rightHand);
			ShiftRig(shift);
			EstimateRideVelocity(shift);
			_ridingNow = true;
		}

		private void RideOnBody()
		{
			Transform ride = _bodyRide;
			if (ridePlatformYaw)
			{
				float yaw = Mathf.DeltaAngle(_bodyRideRotation.eulerAngles.y, ride.eulerAngles.y);
				if (Mathf.Abs(yaw) > 0.0001f)
				{
					RotateRig(yaw, true);
				}
				_bodyRideRotation = ride.rotation;
			}
			Vector3 shift = ride.TransformPoint(_bodyRideLocal) - _bodyRideFoot;
			_bodyRideFoot += shift;
			if (maxRideStep > 0f && shift.sqrMagnitude > maxRideStep * maxRideStep)
			{
				ForgetRideVelocity();
				return;
			}
			ShiftRig(shift);
			EstimateRideVelocity(shift);
			_ridingNow = true;
		}

		private static void SumPinTravel(LAHand hand, ref Vector3 shift, ref int riders)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				if (contact.wasTouching && !(contact.rideTransform == null))
				{
					shift += contact.rideTransform.TransformPoint(contact.rideLocal) - contact.resolved;
					riders++;
				}
			}
		}

		private static void FollowPins(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				if (contact.wasTouching && !(contact.rideTransform == null))
				{
					contact.resolved = contact.rideTransform.TransformPoint(contact.rideLocal);
					contact.rideRotation = contact.rideTransform.rotation;
				}
			}
		}

		private static void ReanchorPins(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				if (!(contact.rideTransform == null))
				{
					contact.rideLocal = contact.rideTransform.InverseTransformPoint(contact.resolved);
					contact.rideRotation = contact.rideTransform.rotation;
				}
			}
		}

		private static void ClearRideAnchors(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				hand.contacts[i].rideTransform = null;
			}
		}

		private void ShiftRig(Vector3 shift)
		{
			if (!(shift.sqrMagnitude < 1E-14f))
			{
				transform.position += shift;
				_lastHead += shift;
				_lastOpenHead += shift;
				_lastRoot += shift;
				ShiftContacts(leftHand, shift, true);
				ShiftContacts(rightHand, shift, true);
			}
		}

		private void RefreshRideAnchors(LAHand hand)
		{
			bool off = !ridePlatforms || !PlatformsExist;
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				if (!off && contact.touching && IsPlatform(contact.lastHit))
				{
					contact.rideTransform = contact.lastHit.transform;
					contact.rideLocal = contact.rideTransform.InverseTransformPoint(contact.resolved);
					contact.rideRotation = contact.rideTransform.rotation;
				}
				else
				{
					contact.rideTransform = null;
				}
			}
		}

		private void ProbeBodyRide()
		{
			Vector3 foot = Vector3.zero;
			bool idle = !bodyRidesPlatforms || !ridePlatforms || _body.isKinematic || disableMovement || !PlatformsExist || IsLettingGo;
			Transform below = idle ? null : PlatformBelow(out foot);
			if (below == null)
			{
				if (!(_bodyRide == null))
				{
					if (!idle && _bodyRideMisses < bodyRideGraceFrames)
					{
						_bodyRideMisses++;
						return;
					}
					_bodyRide = null;
					_bodyRideMisses = 0;
				}
				return;
			}
			if (below != _bodyRide)
			{
				_bodyRideRotation = below.rotation;
			}
			_bodyRide = below;
			_bodyRideMisses = 0;
			_bodyRideLocal = below.InverseTransformPoint(foot);
			_bodyRideFoot = foot;
		}

		private Transform PlatformBelow(out Vector3 foot)
		{
			foot = Vector3.zero;
			float minUp = Mathf.Cos(bodyRideMaxSlope * 0.017453292f);
			Vector3 head = HeadPosition;
			float radius = HeadRadius;
			int count = Physics.SphereCastNonAlloc(head, radius * 0.5f, Vector3.down, _rideHits, bodyRideReach * Scale, locomotionLayers, QueryTriggerInteraction.Ignore);
			int best = -1;
			for (int i = 0; i < count; i++)
			{
				RaycastHit hit = _rideHits[i];
				if (!(hit.collider == null) && !(hit.distance <= 0f) && !hit.transform.IsChildOf(transform) && (best < 0 || hit.distance < _rideHits[best].distance))
				{
					best = i;
				}
			}
			if (best < 0 || _rideHits[best].normal.y < minUp || !IsPlatform(_rideHits[best].collider))
			{
				return null;
			}
			foot = _rideHits[best].point;
			return _rideHits[best].collider.transform;
		}

		private void HandOffRideMomentum()
		{
			if (_ridingLast && !_ridingNow && !_body.isKinematic && !disableMovement)
			{
				_body.linearVelocity += Vector3.ClampMagnitude(_rideVelocity, maxRideSpeed);
			}
			if (!_ridingNow)
			{
				ForgetRideVelocity();
			}
			_ridingLast = _ridingNow;
		}

		private void EstimateRideVelocity(Vector3 shift)
		{
			if (_dt > 0f)
			{
				Vector3 target = Vector3.ClampMagnitude(shift / _dt, maxRideSpeed);
				_rideVelocity = Vector3.SmoothDamp(_rideVelocity, target, ref _rideDamp, rideVelocitySmoothTime, float.PositiveInfinity, _dt);
			}
		}

		private void ForgetRideVelocity()
		{
			_rideVelocity = Vector3.zero;
			_rideDamp = Vector3.zero;
		}

		private void RotateRide(Vector3 pivot, Quaternion q, bool turnMomentum)
		{
			_bodyRideFoot = pivot + q * (_bodyRideFoot - pivot);
			if (turnMomentum)
			{
				_rideVelocity = q * _rideVelocity;
				_rideDamp = q * _rideDamp;
			}
		}

		private void ClearRide()
		{
			ClearRideAnchors(leftHand);
			ClearRideAnchors(rightHand);
			ForgetRideVelocity();
			_bodyRide = null;
			_ridingLast = false;
			_ridingNow = false;
			_bodyRideMisses = 0;
		}

		public float Scale { get; private set; } = 1f;

		private void StepScale()
		{
			if (Scale != targetScale)
			{
				float scale = Mathf.Lerp(Scale, targetScale, _frameTime * Mathf.Max(scaleSpeed, 0f));
				if (Mathf.Abs(scale - targetScale) < 0.0001f)
				{
					scale = targetScale;
				}
				ApplyScale(scale);
			}
		}

		private void ApplyScale(float scale)
		{
			Scale = Mathf.Max(scale, 0.01f);
			if (!(turnPivot == null) && !(turnPivot == transform))
			{
				Vector3 before = HeadPosition;
				turnPivot.localScale = Vector3.one * Scale;
				Vector3 delta = HeadPosition - before;
				_lastHead += delta;
				_lastOpenHead += delta;
				Physics.SyncTransforms();
			}
		}

		private void ScaleGravity()
		{
			if (Scale != 1f && !_body.isKinematic && _body.useGravity)
			{
				_body.linearVelocity += Physics.gravity * ((Scale - 1f) * _dt);
			}
		}

		public void SlipThisFrame()
		{
			_slipFrame = Time.frameCount;
		}

		public bool IsSlipping => _slipFrame == Time.frameCount;

		private void Unembed(Collider c, LAShape shape, ref Vector3 center)
		{
			Transform t = c.transform;
			Vector3 offset = t.position - LAShape.Center(c);
			for (int pass = 0; pass < 2; pass++)
			{
				int count = shape.Overlap(center, Embedding, locomotionLayers, castsHitTriggers ? QueryTriggerInteraction.Collide : QueryTriggerInteraction.Ignore);
				Vector3 push = Vector3.zero;
				for (int i = 0; i < count; i++)
				{
					Collider other = Embedding[i];
					if (!(other == null) && !(other == c) && !other.transform.IsChildOf(transform) && Physics.ComputePenetration(c, center + offset + push, t.rotation, other, other.transform.position, other.transform.rotation, out Vector3 direction, out float distance) && distance > 0f)
					{
						push += direction * distance;
					}
				}
				Array.Clear(Embedding, 0, count);
				float magnitude = push.magnitude;
				if (magnitude < 1E-06f)
				{
					break;
				}
				center += push + push / magnitude * (Scale * 0.001f);
			}
		}

		public void SuspendHand(bool left, object owner)
		{
			if (owner == null)
			{
				return;
			}
			LAHand hand = left ? leftHand : rightHand;
			if (!hand.suspenders.Contains(owner))
			{
				hand.suspenders.Add(owner);
				if (hand.suspenders.Count == 1 && _ready)
				{
					ResetContacts(hand);
				}
			}
		}

		public void ResumeHand(bool left, object owner)
		{
			LAHand hand = left ? leftHand : rightHand;
			if (hand.suspenders.Remove(owner) && !hand.Suspended && _ready)
			{
				ResetContacts(hand);
			}
		}

		public bool IsHandSuspended(bool left)
		{
			LAHand hand = left ? leftHand : rightHand;
			PruneSuspenders(hand);
			return hand.Suspended;
		}

		private static void PruneSuspenders(LAHand hand)
		{
			for (int i = hand.suspenders.Count - 1; i >= 0; i--)
			{
				if (hand.suspenders[i] is UnityEngine.Object obj && obj == null)
				{
					hand.suspenders.RemoveAt(i);
				}
			}
		}

		private void RestSuspended(LAHand hand)
		{
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				LAContact contact = hand.contacts[i];
				if (contact.collider != null)
				{
					contact.resolved = TrackedCenter(contact.collider);
				}
				contact.rideTransform = null;
				contact.touching = false;
			}
		}

		private bool Resolve(Vector3 start, LAShape shape, Vector3 move, bool braced, out Vector3 end, out RaycastHit hit)
		{
			end = start;
			hit = default(RaycastHit);
			float distance = move.magnitude;
			if (distance < 1E-07f)
			{
				return false;
			}
			Vector3 direction = move / distance;
			LAShape inner = shape.Shrunk(precision);
			float skin = shape.thickness * (1f - precision);
			int mask = locomotionLayers;
			QueryTriggerInteraction triggers = castsHitTriggers ? QueryTriggerInteraction.Collide : QueryTriggerInteraction.Ignore;
			if (inner.Sweep(start, direction, distance + skin, mask, triggers, out hit))
			{
				end = start + direction * Mathf.Max(hit.distance - skin, 0f);
				float slip = 1f;
				if (!IsSlipping)
				{
					slip = SlipFor(hit.collider, braced);
					if (slip <= 0f)
					{
						return true;
					}
				}
				Vector3 target = start + move;
				Vector3 slide = slip * Vector3.ProjectOnPlane(target - end, hit.normal);
				float slideLength = slide.magnitude;
				if (slideLength < 1E-07f)
				{
					return true;
				}
				Vector3 slideDirection = slide / slideLength;
				if (inner.Sweep(end, slideDirection, skin + slideLength, mask, triggers, out RaycastHit slideHit))
				{
					end += slideDirection * Mathf.Max(slideHit.distance - skin, 0f);
					hit = slideHit;
					if (IsSlipping)
					{
						end = SlideOn(end, inner, target, skin, ref hit);
					}
					return true;
				}
				Vector3 slid = end + slide;
				Vector3 back = target - slid;
				float backLength = back.magnitude;
				if (backLength > 1E-07f)
				{
					Vector3 backDirection = back / backLength;
					if (inner.Sweep(slid, backDirection, skin + backLength, mask, triggers, out RaycastHit backHit))
					{
						end = slid + backDirection * Mathf.Max(backHit.distance - skin, 0f);
						hit = backHit;
					}
				}
				return true;
			}
			if (Physics.Raycast(start, direction, out hit, distance + shape.thickness * precision, mask, triggers))
			{
				return true;
			}
			LAShape probe = shape.Shrunk(precision * 0.66f);
			if (probe.Sweep(start, direction, distance + shape.thickness * 0.34f, mask, triggers, out hit))
			{
				return true;
			}
			hit = default(RaycastHit);
			return false;
		}

		private Vector3 SlideOn(Vector3 from, LAShape inner, Vector3 target, float skin, ref RaycastHit hit)
		{
			Vector3 position = from;
			for (int i = 0; i < 2; i++)
			{
				Vector3 rest = Vector3.ProjectOnPlane(target - position, hit.normal);
				float length = rest.magnitude;
				if (length < 1E-06f)
				{
					break;
				}
				Vector3 direction = rest / length;
				if (!inner.Sweep(position, direction, length + skin, locomotionLayers, castsHitTriggers ? QueryTriggerInteraction.Collide : QueryTriggerInteraction.Ignore, out RaycastHit next))
				{
					position += rest;
					break;
				}
				position += direction * Mathf.Max(next.distance - skin, 0f);
				hit = next;
			}
			return position;
		}

		private bool PushOutOfWorld(Collider c, LAShape shape, ref Vector3 center, out Collider into)
		{
			into = null;
			if (!pushOutTurnedItems || c == null || shape.kind == LAShape.Kind.Sphere)
			{
				return false;
			}
			Transform t = c.transform;
			Vector3 offset = t.position - LAShape.Center(c);
			Quaternion rotation = t.rotation;
			bool moved = false;
			for (int pass = 0; pass < pushOutPasses; pass++)
			{
				int count = shape.Overlap(center, Penetrating, locomotionLayers, castsHitTriggers ? QueryTriggerInteraction.Collide : QueryTriggerInteraction.Ignore);
				Vector3 push = Vector3.zero;
				for (int i = 0; i < count; i++)
				{
					Collider other = Penetrating[i];
					if (!(other == null) && !(other == c) && !other.transform.IsChildOf(transform) && Physics.ComputePenetration(c, center + offset + push, rotation, other, other.transform.position, other.transform.rotation, out Vector3 direction, out float distance) && distance > pushOutSlop)
					{
						push += direction * distance;
						into = other;
					}
				}
				Array.Clear(Penetrating, 0, count);
				if (push.sqrMagnitude < 1E-12f)
				{
					break;
				}
				center += push;
				moved = true;
			}
			return moved;
		}

		public static LAPlayer Instance { get; private set; }

		public static event Action<LAPlayer> Teleported;

		public event Action<bool, RaycastHit> HandTouched;

		public Rigidbody Body => _body != null ? _body : (_body = GetComponent<Rigidbody>());

		public Transform Head => headCollider != null ? headCollider.transform : transform;

		public Vector3 HeadPosition => headCollider.transform.TransformPoint(headCollider.center);

		public float HeadRadius => headCollider.radius * MaxAbs(headCollider.transform.lossyScale);

		public Vector3 AverageVelocity => _averageVelocity;

		public Vector3 CurrentVelocity => _currentVelocity;

		public float StepDeltaTime => _dt;

		public bool IsTouchingAnything => leftHand.touching || rightHand.touching;

		public bool IsFrozen { get; private set; }

		public float LastLaunchSpeed { get; private set; }

		public float LastLaunchTime { get; private set; } = -100f;

		public bool LastLaunchCapped { get; private set; }

		public LAHand Hand(bool left)
		{
			return left ? leftHand : rightHand;
		}

		private int Mask => locomotionLayers;

		private QueryTriggerInteraction Triggers => castsHitTriggers ? QueryTriggerInteraction.Collide : QueryTriggerInteraction.Ignore;

		private void Awake()
		{
			_body = GetComponent<Rigidbody>();
			if (Instance != null && Instance != this)
			{
				Debug.LogWarning("[LAPlayer] A second LAPlayer is active; Instance now points at " + name + ".", this);
			}
			Instance = this;
			_body.constraints |= RigidbodyConstraints.FreezeRotation;
			_body.interpolation = RigidbodyInterpolation.None;
			if (headCollider == null)
			{
				Debug.LogError("[LAPlayer] headCollider is not assigned.", this);
				enabled = false;
				return;
			}
			AddSerializedColliders(leftHand);
			AddSerializedColliders(rightHand);
			BindLegacy();
		}

		private void Start()
		{
			Initialize(false);
		}

		private void OnDestroy()
		{
			UnbindLegacy();
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnApplicationFocus(bool focused)
		{
			inOverlay = pauseOnSystemOverlay && !focused;
		}

		private void OnApplicationPause(bool paused)
		{
			inOverlay = pauseOnSystemOverlay && (paused || !Application.isFocused);
		}

		private void Update()
		{
			if (_ready)
			{
				PullLegacy();
				Step();
				PushLegacy();
			}
		}

		private void Initialize(bool keepMomentum)
		{
			if (!keepMomentum)
			{
				ResetHistory();
			}
			_lastRoot = transform.position;
			_lastHead = HeadPosition;
			_lastOpenHead = _lastHead;
			_slideVelocity = Vector3.zero;
			_slideTime = 0f;
			ResetContacts(leftHand);
			ResetContacts(rightHand);
			ClearRide();
			PlaceBody();
			_ready = true;
		}

		private void ResetHistory()
		{
			_historyHead = 0;
			_historyCount = 0;
			_averageVelocity = Vector3.zero;
			_currentVelocity = Vector3.zero;
		}

		private void Step()
		{
			if (inOverlay != _overlayHeld)
			{
				if (inOverlay)
				{
					HoldForOverlay();
				}
				else
				{
					ResumeFromOverlay();
				}
			}
			if (_overlayHeld || IsFrozen)
			{
				PlaceBody();
				return;
			}
			float frame = Time.deltaTime;
			if (frame <= 0f)
			{
				return;
			}
			_frameTime = Mathf.Min(frame, 0.25f);
			_dt = frame > 0.1f ? 0.05f : Mathf.Max(frame, 0.006f);
			Physics.SyncTransforms();
			GuardTrackingJump();
			StepScale();
			_preContactVelocity = _body.isKinematic ? Vector3.zero : _body.linearVelocity;
			RideStep();
			bool wasLeft = leftHand.touching;
			bool wasRight = rightHand.touching;
			bool pushedLeft = PushPass(leftHand, true, out Vector3 leftPush);
			bool pushedRight = PushPass(rightHand, false, out Vector3 rightPush);
			bool left = pushedLeft || wasLeft;
			bool right = pushedRight || wasRight;
			bool braced = left && right;
			Vector3 movement = leftPush + rightPush;
			if (braced)
			{
				movement *= 0.5f;
			}
			movement = KeepHeadOut(movement);
			if (movement.sqrMagnitude > 1e-12f)
			{
				transform.position += movement;
			}
			_lastHead = HeadPosition;
			left |= SettlePass(leftHand, !braced);
			SettlePass(rightHand, !(left && right));
			RecordVelocity();
			bool launched = false;
			if ((wasLeft || wasRight) && !disableMovement && !_body.isKinematic && _slipFrame != Time.frameCount)
			{
				_body.linearVelocity = LaunchVelocity(out bool capped);
				launched = true;
				LastLaunchCapped = capped;
			}
			ScaleGravity();
			Unstick(leftHand);
			Unstick(rightHand);
			Roll(leftHand);
			Roll(rightHand);
			Skid();
			RefreshRideAnchors(leftHand);
			RefreshRideAnchors(rightHand);
			ProbeBodyRide();
			HandOffRideMomentum();
			if (launched && !leftHand.touching && !rightHand.touching)
			{
				LastLaunchSpeed = _body.linearVelocity.magnitude;
				LastLaunchTime = Time.time;
			}
			if (!Physics.CheckSphere(HeadPosition, HeadRadius * 0.9f, Mask, Triggers))
			{
				_lastOpenHead = HeadPosition;
			}
			_body.position = transform.position;
			PlaceBody();
		}

		private Vector3 LaunchVelocity(out bool capped)
		{
			capped = false;
			float speed = _averageVelocity.magnitude;
			if (speed > velocityLimit * Scale)
			{
				SurfaceBoost(out float boost, out float capBoost);
				float multiplier = jumpMultiplier * boost;
				float cap = maxJumpSpeed * capBoost * Scale;
				if (speed * multiplier > cap)
				{
					multiplier = cap / speed;
					capped = true;
				}
				return _averageVelocity * (multiplier * _launchScale);
			}
			return Vector3.zero;
		}

		private void RecordVelocity()
		{
			Vector3 move = transform.position - _lastRoot;
			_lastRoot = transform.position;
			float frame = Mathf.Max(_frameTime, 0.0001f);
			float step = historyStepSeconds > 0f ? historyStepSeconds : frame;
			_historyHead = (_historyHead + 1) % HistoryCapacity;
			_currentVelocity = move / step;
			_realVelocity = move / frame;
			_historyMove[_historyHead] = move;
			_historyTime[_historyHead] = _frameTime;
			if (_historyCount < HistoryCapacity)
			{
				_historyCount++;
			}
			int size = Mathf.Max(velocityHistorySize, 1);
			Vector3 sum = Vector3.zero;
			float span = 0f;
			int index = _historyHead;
			if (historyReferenceHz > 0f)
			{
				span = size / historyReferenceHz;
				float covered = 0f;
				for (int i = 0; i < _historyCount && covered < span; i++)
				{
					float t = _historyTime[index];
					float weight = 1f;
					if (t > 0f)
					{
						weight = Mathf.Min((span - covered) / t, 1f);
					}
					sum += _historyMove[index] * weight;
					index = (index - 1 + HistoryCapacity) % HistoryCapacity;
					covered += t * weight;
				}
			}
			else
			{
				int count = Mathf.Min(_historyCount, size);
				for (int i = 0; i < count; i++)
				{
					span += _historyTime[index];
					sum += _historyMove[index];
					index = (index - 1 + HistoryCapacity) % HistoryCapacity;
				}
			}
			float seconds = historyStepSeconds > 0f ? historyStepSeconds * size : Mathf.Max(span, 0.0001f);
			_averageVelocity = sum / seconds;
		}

		private Vector3 KeepHeadOut(Vector3 movement)
		{
			Vector3 head = HeadPosition;
			float radius = HeadRadius;
			Vector3 from = _lastHead;
			if (Physics.CheckSphere(from, radius * 0.9f, Mask, Triggers))
			{
				from = _lastOpenHead;
			}
			LAShape shape = LAShape.Sphere(radius);
			if (!Resolve(from, shape, head + movement - from, true, out Vector3 end, out RaycastHit hit))
			{
				return movement;
			}
			Vector3 travel = end - from;
			float distance = travel.magnitude;
			if (distance > 1e-5f && Physics.Raycast(from, travel / distance, distance, Mask, Triggers))
			{
				return from - head;
			}
			return end - head;
		}

		private void GuardTrackingJump()
		{
			Vector3 head = HeadPosition;
			float scale = Mathf.Max(1f, Scale);
			float speed = _body.isKinematic ? 0f : _body.linearVelocity.magnitude;
			Vector3 back = _lastHead - head;
			float limit = teleportThreshold * scale + speed * _dt;
			if (back.sqrMagnitude > limit * limit)
			{
				transform.position += back;
				_lastRoot += back;
				Physics.SyncTransforms();
			}
		}

		private void PlaceBody()
		{
			if (bodyCollider == null || headCollider == null)
			{
				return;
			}
			Transform head = headCollider.transform;
			Vector3 forward = Vector3.ProjectOnPlane(head.forward, Vector3.up);
			if (forward.sqrMagnitude < 0.0001f)
			{
				forward = Vector3.ProjectOnPlane(head.up, Vector3.up);
			}
			Quaternion yaw = forward.sqrMagnitude > 1e-8f ? Quaternion.LookRotation(forward, Vector3.up) : Quaternion.identity;
			Vector3 position = head.position;
			float scale = Scale;
			Vector3 offset;
			if (bodyFollowsHeadTilt)
			{
				position += head.rotation * (TorsoBoneFromEye * scale);
				offset = TorsoCentreFromBone;
			}
			else
			{
				offset = bodyOffset;
			}
			Vector3 centre = position + yaw * (offset * scale);
			Transform body = bodyCollider.transform;
			body.SetPositionAndRotation(centre, yaw);
			if (body.parent == null || body.parent.lossyScale == Vector3.one)
			{
				body.localScale = Vector3.one * scale;
			}
			if (bodyCollider.center != Vector3.zero)
			{
				body.position -= body.TransformVector(bodyCollider.center);
			}
		}

		private void HoldForOverlay()
		{
			_overlayHeld = true;
			_overlaySavedKinematic = _body.isKinematic;
			if (!_body.isKinematic)
			{
				_body.linearVelocity = Vector3.zero;
			}
			_body.isKinematic = true;
		}

		private void ResumeFromOverlay()
		{
			_overlayHeld = false;
			_body.isKinematic = _overlaySavedKinematic;
			if (!_body.isKinematic)
			{
				_body.linearVelocity = Vector3.zero;
			}
			Initialize(false);
		}

		public void Turn(float degrees)
		{
			if (Mathf.Abs(degrees) < 1e-5f || !_ready)
			{
				return;
			}
			RotateRig(degrees, false);
		}

		public void TeleportToSpawn()
		{
			if (spawnPoint != null)
			{
				TeleportPlayerRaw(spawnPoint.position, spawnPoint.rotation, true, true);
			}
			else if (_legacy != null)
			{
				_legacy.TeleportToSpawn();
			}
		}

		public void TeleportPlayerTransform(Transform destination, bool setRotation = false)
		{
			if (destination == null)
			{
				Debug.LogWarning("[LAPlayer] TeleportPlayerTransform called with no destination.", this);
				return;
			}
			TeleportPlayerRaw(destination.position, destination.rotation, setRotation, true);
		}

		public void TeleportPlayerRaw(Vector3 position, Quaternion rotation, bool setRotation = false, bool resetVelocity = true)
		{
			Rigidbody body = Body;
			transform.position = position;
			if (setRotation)
			{
				transform.rotation = Quaternion.Euler(0f, rotation.eulerAngles.y, 0f);
			}
			body.position = transform.position;
			body.rotation = transform.rotation;
			if (resetVelocity && !body.isKinematic)
			{
				body.linearVelocity = Vector3.zero;
			}
			Physics.SyncTransforms();
			SnapWrists();
			Initialize(!resetVelocity);
			Teleported?.Invoke(this);
			if (_legacy != null)
			{
				_legacy.NotifyDriverTeleported();
			}
		}

		public void AcceptExternalHeadPosition()
		{
			if (headCollider == null)
			{
				return;
			}
			_lastHead = HeadPosition;
			_lastOpenHead = _lastHead;
			_lastRoot = transform.position;
			if (_ready)
			{
				ResetContacts(leftHand);
				ResetContacts(rightHand);
				ClearRide();
			}
		}

		public void MoveBy(Vector3 delta)
		{
			if (delta.sqrMagnitude < 1e-12f)
			{
				return;
			}
			transform.position += delta;
			Body.position = transform.position;
			ShiftContacts(leftHand, delta, false);
			ShiftContacts(rightHand, delta, false);
			ReanchorPins(leftHand);
			ReanchorPins(rightHand);
			_lastHead += delta;
			_lastOpenHead += delta;
		}

		public void SetFrozen(bool frozen)
		{
			if (IsFrozen == frozen)
			{
				return;
			}
			Rigidbody body = Body;
			if (frozen)
			{
				_frozenMask = locomotionLayers;
				locomotionLayers = 0;
				if (!body.isKinematic)
				{
					body.linearVelocity = Vector3.zero;
				}
				body.isKinematic = true;
				IsFrozen = true;
			}
			else
			{
				locomotionLayers = _frozenMask;
				body.isKinematic = false;
				body.linearVelocity = Vector3.zero;
				IsFrozen = false;
				Initialize(false);
			}
		}

		public void AddHandCollider(bool left, Collider c)
		{
			if (c == null)
			{
				return;
			}
			LAHand hand = Hand(left);
			if (hand.IndexOf(c) >= 0)
			{
				return;
			}
			hand.contacts.Add(new LAContact(c, TrackedCenter(c)));
		}

		public void RemoveHandCollider(bool left, Collider c)
		{
			LAHand hand = Hand(left);
			int index = hand.IndexOf(c);
			if (index < 0)
			{
				return;
			}
			EndGhost(hand.contacts[index]);
			hand.contacts.RemoveAt(index);
		}

		private void SnapWrists()
		{
			if (leftHand.wrist != null)
			{
				leftHand.wrist.Snap();
			}
			if (rightHand.wrist != null)
			{
				rightHand.wrist.Snap();
			}
		}

		private void RotateRig(float degrees, bool turnMomentum)
		{
			Vector3 head = HeadPosition;
			Quaternion q = Quaternion.AngleAxis(degrees, Vector3.up);
			Transform pivot = turnPivot != null ? turnPivot : transform;
			Vector3 before = transform.position;
			pivot.RotateAround(head, Vector3.up, degrees);
			if (pivot == transform)
			{
				Body.rotation = transform.rotation;
			}
			_lastRoot += transform.position - before;
			_lastHead = head + q * (_lastHead - head);
			_lastOpenHead = head + q * (_lastOpenHead - head);
			RotateContacts(leftHand, head, q);
			RotateContacts(rightHand, head, q);
			RotateRide(head, q, turnMomentum);
			if (!turnMomentum)
			{
				return;
			}
			for (int i = 0; i < HistoryCapacity; i++)
			{
				_historyMove[i] = q * _historyMove[i];
			}
			_averageVelocity = q * _averageVelocity;
			_slideVelocity = q * _slideVelocity;
			if (!Body.isKinematic)
			{
				Body.linearVelocity = q * Body.linearVelocity;
			}
		}

		private static float MaxAbs(Vector3 v)
		{
			return Mathf.Max(Mathf.Abs(v.x), Mathf.Max(Mathf.Abs(v.y), Mathf.Abs(v.z)));
		}
	}
}
