using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace GorillaLocomotion
{
	[Obfuscation(Exclude = true)]
	public class Player : MonoBehaviour
	{
		private sealed class PlatformGrip
		{
			public Transform anchor;

			public Vector3 local;

			public Quaternion lastRotation = Quaternion.identity;
		}

		public static bool HasInstance;

		[Header("Camera & Colliders")]
		public Camera mainCamera;

		public SphereCollider headCollider;

		public CapsuleCollider bodyCollider;

		[Header("Hands")]
		public Transform leftHandFollower;

		public Transform rightHandFollower;

		public Transform rightHandTransform;

		public Transform leftHandTransform;

		public Vector3 rightHandOffset;

		public Vector3 leftHandOffset;

		[Header("Rigidbody")]
		public Rigidbody playerRigidBody;

		[Header("Movement Tuning")]
		public int velocityHistorySize;

		public float maxArmLength = 1f;

		public float unStickDistance = 1f;

		public float velocityLimit;

		public float slideVelocityLimit;

		public float maxJumpSpeed;

		public float jumpMultiplier;

		public float minimumRaycastDistance = 0.05f;

		public float defaultSlideFactor = 0.03f;

		public float slidingMinimum = 0.9f;

		public float defaultPrecision = 0.995f;

		public float teleportThresholdNoVel = 1f;

		public float frictionConstant = 1f;

		public float slideControl = 0.00425f;

		public float stickDepth = 0.01f;

		public float iceThreshold = 0.9f;

		public float bodyLerp = 0.17f;

		public Vector3 bodyOffset;

		public LayerMask locomotionEnabledLayers;

		public float speedMultiplier = 1f;

		[Tooltip("Stretches the virtual hands away from the head (1 = real arm length). Ramp it; a step change while a hand is planted shoves the body.")]
		public float armReachMultiplier = 1f;

		[Header("Scale")]
		public float targetScale = 1f;

		public float scaleSpeed = 1f;

		private float currentScale = 1f;

		[Header("Turn")]
		[Tooltip("Optional pivot for scale + turn. Falls back to this player's transform if null. Lethal-Ape uses a separate turnParent; Slop-Game's prefab can leave this null.")]
		public GameObject turnParent;

		[Header("Behaviour")]
		public bool disableMovement;

		public bool inOverlay;

		public bool didATurn;

		public bool didAJump;

		public bool debugMovement;

		[Header("Spawn / Respawn")]
		public Transform spawnPosition;

		private Vector3 _storedSpawnPosition;

		[Header("Jumpscare Teleport")]
		[Tooltip("Where the player gets teleported when a monster jumpscares them. Leave null to fall back to spawn.")]
		public Transform jumpscareTeleportTarget;

		[Tooltip("If true, also rotate the player to the target's forward (Y-axis only).")]
		public bool jumpscareTeleportSetRotation;

		[Tooltip("Extra horizontal distance beyond the monster's trigger distance for accepting a jumpscare TP — covers network latency between master triggering and this client receiving the RPC.")]
		public float jumpscareTeleportLatencyCushion = 5f;

		[Header("Teleport Targets — optional named destinations")]
		[SerializeField]
		private Transform teleportTarget;

		[SerializeField]
		private Transform MonsterMuseum;

		[SerializeField]
		private Transform Shop;

		[SerializeField]
		private Transform BundleRoom;

		[SerializeField]
		private Transform CaveEnterenceShop;

		[SerializeField]
		private Transform FloodedMap;

		[SerializeField]
		private Transform Guarage;

		[SerializeField]
		private Transform Outdoors;

		[SerializeField]
		private Transform FlooddedMap;

		private float bodyInitialRadius;

		private float bodyInitialHeight;

		private RaycastHit bodyHitInfo;

		private RaycastHit lastHitInfoHand;

		private Vector3 lastLeftHandPosition;

		private Vector3 lastRightHandPosition;

		public Vector3 lastHeadPosition;

		private float _maxArmLengthSqr;

		private Vector3[] velocityHistory;

		private Vector3[] slideAverageHistory;

		private int velocityIndex;

		public Vector3 currentVelocity;

		private Vector3 denormalizedVelocityAverage;

		private Vector3 lastPosition;

		public bool wasLeftHandTouching;

		public bool wasRightHandTouching;

		public bool wasHeadTouching;

		public int currentMaterialIndex;

		public bool leftHandSlide;

		public Vector3 leftHandSlideNormal;

		public bool rightHandSlide;

		public Vector3 rightHandSlideNormal;

		public Vector3 headSlideNormal;

		public float rightHandSlipPercentage;

		public float leftHandSlipPercentage;

		public float headSlipPercentage;

		public bool wasLeftHandSlide;

		public bool wasRightHandSlide;

		public Vector3 rightHandHitPoint;

		public Vector3 leftHandHitPoint;

		public int leftHandMaterialTouchIndex;

		public Surface leftHandSurfaceOverride;

		public int rightHandMaterialTouchIndex;

		public Surface rightHandSurfaceOverride;

		public Surface currentOverride;

		private bool leftHandColliding;

		private bool rightHandColliding;

		private bool headColliding;

		private Vector3 finalPosition;

		private Vector3 rigidBodyMovement;

		private Vector3 firstIterationLeftHand;

		private Vector3 firstIterationRightHand;

		private RaycastHit hitInfo;

		private RaycastHit iterativeHitInfo;

		private RaycastHit collisionsInnerHit;

		private float slipPercentage;

		private Vector3 bodyOffsetVector;

		private Vector3 distanceTraveled;

		private Vector3 movementToProjectedAboveCollisionPlane;

		private MeshCollider meshCollider;

		private float lastRealTime;

		private float calcDeltaTime;

		private float tempRealTime;

		private Vector3 junkNormal;

		private Vector3 slideAverage;

		private Vector3 slideAverageNormal;

		private Vector3 tempVector3;

		private RaycastHit tempHitInfo;

		private RaycastHit junkHit;

		private Vector3 firstPosition;

		private RaycastHit tempIterativeHit;

		private float overlapRadiusFunction;

		private float maxSphereSize1;

		private float maxSphereSize2;

		private Collider[] overlapColliders = new Collider[10];

		private int overlapAttempts;

		private int touchPoints;

		private float averageSlipPercentage;

		private Vector3 surfaceDirection;

		public float debugMagnitude;

		private float bodyMaxRadius;

		private bool areBothTouching;

		private float slideFactor;

		private RaycastHit[] rayCastNonAllocColliders;

		private Vector3[] crazyCheckVectors;

		private RaycastHit emptyHit;

		private int bufferCount;

		private Vector3 _runningVelocitySum;

		private Vector3 lastOpenHeadPosition;

		private List<Material> tempMaterialArray = new List<Material>();

		private int disableGripFrameIdx = -1;

		[Header("Moving platforms")]
		[Tooltip("Ride MovingPlatform / BasePlatform colliders a hand is planted on.")]
		public bool followMovingPlatforms = true;

		public bool followPlatformRotation = true;

		[Tooltip("Stand on a platform with no hand down and travel with it.")]
		public bool bodyRidesPlatforms = true;

		public float rideVelocitySmoothTime = 0.08f;

		public float maxRidingVelocity = 20f;

		[Tooltip("A bigger jump in one frame is a platform teleport: re-anchor instead of following.")]
		public float maxRideStepMetres = 1.5f;

		[Tooltip("How far below the head a platform still carries you: standing height, scaled with the player.")]
		public float bodyRideReach = 2.2f;

		public float bodyRideMaxSlope = 55f;

		[Min(0f)]
		public int bodyRideGraceFrames = 4;

		private readonly PlatformGrip leftGrip = new PlatformGrip();

		private readonly PlatformGrip rightGrip = new PlatformGrip();

		private readonly Dictionary<Collider, Transform> _platformCache = new Dictionary<Collider, Transform>();

		private readonly RaycastHit[] _rideHits = new RaycastHit[8];

		private readonly Collider[] _rideOverlaps = new Collider[4];

		private Collider _castCollider;

		private bool _hitchFrame;

		private bool _handRiding;

		private Vector3 _rideVelocity;

		private Vector3 _rideVelocityDamp;

		private Transform _bodyRideMover;

		private Vector3 _bodyRideAnchorLocal;

		private Vector3 _bodyRideFootWorld;

		private Quaternion _bodyRideLastRotation = Quaternion.identity;

		private int _bodyRideMissFrames;

		private static Player _instance;

		private Dictionary<Collider, Surface> _surfaceCache = new Dictionary<Collider, Surface>();

		private int _maxSlipFrame = -1;

		public static Player Instance => _instance;

		public float CurrentScale => Driver != null ? Driver.Scale : currentScale;

		public IPlayerDriver Driver { get; private set; }

		private Transform TurnPivot => turnParent != null ? turnParent.transform : transform;

		public Vector3 RidingVelocity => Driver != null ? Driver.RidingVelocity : _rideVelocity;

		public bool IsRidingPlatform => Driver != null ? Driver.IsRidingPlatform : (_handRiding || _bodyRideMover != null);

		public void SetDriver(IPlayerDriver driver)
		{
			Driver = driver;
		}

		private void OnApplicationPause(bool paused)
		{
			if (Driver != null)
			{
				return;
			}
			inOverlay = paused || !Application.isFocused;
			if (inOverlay && playerRigidBody != null)
			{
				playerRigidBody.linearVelocity = Vector3.zero;
				playerRigidBody.angularVelocity = Vector3.zero;
			}
		}

		private void OnApplicationFocus(bool focused)
		{
			if (Driver != null)
			{
				return;
			}
			inOverlay = !focused;
			if (!focused && playerRigidBody != null)
			{
				playerRigidBody.linearVelocity = Vector3.zero;
				playerRigidBody.angularVelocity = Vector3.zero;
			}
		}

		private void OnDestroy()
		{
			if (_instance == this)
			{
				_instance = null;
				HasInstance = false;
			}
		}

		private void Awake()
		{
			if (_instance != null && _instance != this)
			{
				Destroy(gameObject);
				return;
			}
			_instance = this;
			HasInstance = true;
			_storedSpawnPosition = transform.position;
			InitializeValues();
			playerRigidBody.maxAngularVelocity = 0f;
			bodyOffsetVector = new Vector3(0f, -bodyCollider.height / 2f, 0f);
			bodyInitialHeight = bodyCollider.height;
			bodyInitialRadius = bodyCollider.radius;
			rayCastNonAllocColliders = new RaycastHit[5];
			crazyCheckVectors = new Vector3[7];
			emptyHit = default(RaycastHit);
			crazyCheckVectors[0] = Vector3.up;
			crazyCheckVectors[1] = Vector3.down;
			crazyCheckVectors[2] = Vector3.left;
			crazyCheckVectors[3] = Vector3.right;
			crazyCheckVectors[4] = Vector3.forward;
			crazyCheckVectors[5] = Vector3.back;
			crazyCheckVectors[6] = Vector3.zero;
		}

		public void InitializeValues()
		{
			if (Driver != null)
			{
				Driver.ReinitializeRig();
				return;
			}
			Physics.SyncTransforms();
			playerRigidBody = GetComponent<Rigidbody>();
			_maxArmLengthSqr = maxArmLength * maxArmLength;
			velocityHistory = new Vector3[velocityHistorySize];
			slideAverageHistory = new Vector3[velocityHistorySize];
			for (int i = 0; i < velocityHistory.Length; i++)
			{
				velocityHistory[i] = Vector3.zero;
				slideAverageHistory[i] = Vector3.zero;
			}
			_runningVelocitySum = Vector3.zero;
			leftHandFollower.transform.position = leftHandTransform.position;
			rightHandFollower.transform.position = rightHandTransform.position;
			lastLeftHandPosition = leftHandFollower.transform.position;
			lastRightHandPosition = rightHandFollower.transform.position;
			lastHeadPosition = headCollider.transform.position;
			wasLeftHandTouching = false;
			wasRightHandTouching = false;
			velocityIndex = 0;
			denormalizedVelocityAverage = Vector3.zero;
			slideAverage = Vector3.zero;
			lastPosition = transform.position;
			lastRealTime = Time.realtimeSinceStartup;
			lastOpenHeadPosition = headCollider.transform.position;
			ClearPlatformRide();
			bodyCollider.transform.position = PositionWithOffset(headCollider.transform, bodyOffset) + bodyOffsetVector;
			bodyCollider.transform.eulerAngles = new Vector3(0f, headCollider.transform.eulerAngles.y, 0f);
		}

		private void FixedUpdate()
		{
			if (Driver != null)
			{
				return;
			}
			AntiTeleportTechnology();
			if (currentScale != 1f)
			{
				playerRigidBody.AddForce(-Physics.gravity * (1f - currentScale), ForceMode.Acceleration);
			}
		}

		private void BodyCollider()
		{
			Vector3 position = PositionWithOffset(headCollider.transform, bodyOffset);
			if (MaxSphereSizeForNoOverlap(bodyInitialRadius * currentScale, position, out bodyMaxRadius))
			{
				if (currentScale > 0f)
				{
					bodyCollider.radius = bodyMaxRadius / currentScale;
				}
				if (Physics.SphereCast(position, bodyMaxRadius, Vector3.down, out bodyHitInfo, bodyInitialHeight * currentScale - bodyMaxRadius, locomotionEnabledLayers.value))
				{
					bodyCollider.height = (bodyHitInfo.distance + bodyMaxRadius) / currentScale;
				}
				else
				{
					bodyCollider.height = bodyInitialHeight;
				}
				if (!bodyCollider.gameObject.activeSelf)
				{
					bodyCollider.gameObject.SetActive(true);
				}
			}
			else
			{
				bodyCollider.gameObject.SetActive(false);
			}
			bodyCollider.height = Mathf.Lerp(bodyCollider.height, bodyInitialHeight, bodyLerp);
			bodyCollider.radius = Mathf.Lerp(bodyCollider.radius, bodyInitialRadius, bodyLerp);
			bodyOffsetVector = Vector3.down * bodyCollider.height / 2f;
			bodyCollider.transform.position = position + bodyOffsetVector * currentScale;
			bodyCollider.transform.eulerAngles = new Vector3(0f, headCollider.transform.eulerAngles.y, 0f);
		}

		private Vector3 CurrentHandPosition(Transform handTransform, Vector3 handOffset)
		{
			if (inOverlay)
			{
				return headCollider.transform.position + headCollider.transform.up * (currentScale * -0.5f);
			}
			Vector3 vector = PositionWithOffset(handTransform, handOffset);
			Vector3 vector2 = vector - headCollider.transform.position;
			if (armReachMultiplier != 1f)
			{
				vector2 = armReachMultiplier * vector2;
				vector = vector2 + headCollider.transform.position;
			}
			float num = armReachMultiplier * currentScale;
			if (vector2.sqrMagnitude < _maxArmLengthSqr * num * num)
			{
				return vector;
			}
			return headCollider.transform.position + vector2.normalized * maxArmLength * num;
		}

		private Vector3 LastLeftHandPosition()
		{
			return lastLeftHandPosition;
		}

		private Vector3 LastRightHandPosition()
		{
			return lastRightHandPosition;
		}

		private Vector3 CurrentLeftHandPosition()
		{
			return CurrentHandPosition(leftHandTransform, leftHandOffset);
		}

		private Vector3 CurrentRightHandPosition()
		{
			return CurrentHandPosition(rightHandTransform, rightHandOffset);
		}

		private Vector3 PositionWithOffset(Transform t, Vector3 offsetVector)
		{
			return t.position + t.rotation * offsetVector * currentScale;
		}

		private void Update()
		{
			if (Driver != null)
			{
				return;
			}
			if (currentScale != targetScale)
			{
				currentScale = Mathf.Lerp(currentScale, targetScale, Time.deltaTime * scaleSpeed);
			}
			if (debugMovement)
			{
				tempRealTime = Time.time;
				calcDeltaTime = Time.deltaTime;
				lastRealTime = tempRealTime;
			}
			else
			{
				tempRealTime = Time.realtimeSinceStartup;
				calcDeltaTime = tempRealTime - lastRealTime;
				lastRealTime = tempRealTime;
			}
			_hitchFrame = calcDeltaTime > 0.1f;
			if (_hitchFrame)
			{
				calcDeltaTime = 0.05f;
			}
			if (FollowMovingPlatforms(calcDeltaTime))
			{
				Physics.SyncTransforms();
			}
			Vector3 position = headCollider.transform.position;
			TurnPivot.localScale = Vector3.one * currentScale;
			playerRigidBody.MovePosition(playerRigidBody.position + position - headCollider.transform.position);
			Physics.SyncTransforms();
			ProbeBodyPlatform();
			rigidBodyMovement = Vector3.zero;
			firstIterationLeftHand = Vector3.zero;
			firstIterationRightHand = Vector3.zero;
			if (!didAJump && (wasLeftHandTouching || wasRightHandTouching))
			{
				transform.position = transform.position + 4.9f * Vector3.down * calcDeltaTime * calcDeltaTime * currentScale;
				if (Vector3.Dot(denormalizedVelocityAverage, slideAverageNormal) <= 0f && Vector3.Dot(Vector3.down, slideAverageNormal) <= 0f)
				{
					transform.position = transform.position - Vector3.Project(Mathf.Min(stickDepth * currentScale, Vector3.Project(denormalizedVelocityAverage, slideAverageNormal).magnitude * calcDeltaTime) * slideAverageNormal, Vector3.down);
				}
			}
			if (!didAJump && (wasLeftHandSlide || wasRightHandSlide))
			{
				transform.position = transform.position + slideAverage * calcDeltaTime;
				slideAverage += 9.8f * Vector3.down * calcDeltaTime;
			}
			_castCollider = null;
			FirstHandIteration(leftHandTransform, leftHandOffset, lastLeftHandPosition, wasLeftHandSlide, wasLeftHandTouching, out firstIterationLeftHand, ref leftHandSlipPercentage, ref leftHandSlide, ref leftHandSlideNormal, ref leftHandColliding, ref leftHandMaterialTouchIndex, ref leftHandSurfaceOverride);
			Collider leftCastCollider = _castCollider;
			_castCollider = null;
			FirstHandIteration(rightHandTransform, rightHandOffset, lastRightHandPosition, wasRightHandSlide, wasRightHandTouching, out firstIterationRightHand, ref rightHandSlipPercentage, ref rightHandSlide, ref rightHandSlideNormal, ref rightHandColliding, ref rightHandMaterialTouchIndex, ref rightHandSurfaceOverride);
			Collider rightCastCollider = _castCollider;
			touchPoints = 0;
			rigidBodyMovement = Vector3.zero;
			if (leftHandColliding || wasLeftHandTouching)
			{
				rigidBodyMovement += firstIterationLeftHand;
				touchPoints++;
			}
			if (rightHandColliding || wasRightHandTouching)
			{
				rigidBodyMovement += firstIterationRightHand;
				touchPoints++;
			}
			if (touchPoints != 0)
			{
				rigidBodyMovement /= (float)touchPoints;
			}
			if (!MaxSphereSizeForNoOverlap(headCollider.radius * 0.9f * currentScale, lastHeadPosition, out maxSphereSize1) && !CrazyCheck2(headCollider.radius * 0.9f * 0.75f * currentScale, lastHeadPosition))
			{
				lastHeadPosition = lastOpenHeadPosition;
			}
			if (IterativeCollisionSphereCast(lastHeadPosition, headCollider.radius * 0.9f * currentScale, headCollider.transform.position + rigidBodyMovement - lastHeadPosition, out finalPosition, false, out slipPercentage, out junkHit, true))
			{
				rigidBodyMovement = finalPosition - headCollider.transform.position;
			}
			if (!MaxSphereSizeForNoOverlap(headCollider.radius * 0.9f * currentScale, lastHeadPosition + rigidBodyMovement, out maxSphereSize1) || !CrazyCheck2(headCollider.radius * 0.9f * 0.75f * currentScale, lastHeadPosition + rigidBodyMovement))
			{
				lastHeadPosition = lastOpenHeadPosition;
				rigidBodyMovement = lastHeadPosition - headCollider.transform.position;
			}
			else if (headCollider.radius * 0.9f * 0.825f * currentScale < maxSphereSize1)
			{
				lastOpenHeadPosition = headCollider.transform.position + rigidBodyMovement;
			}
			if (rigidBodyMovement != Vector3.zero)
			{
				transform.position = transform.position + rigidBodyMovement;
			}
			lastHeadPosition = headCollider.transform.position;
			areBothTouching = (!leftHandColliding && !wasLeftHandTouching) || (!rightHandColliding && !wasRightHandTouching);
			_castCollider = null;
			lastLeftHandPosition = FinalHandPosition(leftHandTransform, leftHandOffset, lastLeftHandPosition, areBothTouching, leftHandColliding, out leftHandColliding, leftHandSlide, out leftHandSlide, leftHandMaterialTouchIndex, out leftHandMaterialTouchIndex, leftHandSurfaceOverride, out leftHandSurfaceOverride);
			UpdateGrip(leftGrip, leftHandColliding, lastLeftHandPosition, (_castCollider != null) ? _castCollider : leftCastCollider);
			_castCollider = null;
			lastRightHandPosition = FinalHandPosition(rightHandTransform, rightHandOffset, lastRightHandPosition, areBothTouching, rightHandColliding, out rightHandColliding, rightHandSlide, out rightHandSlide, rightHandMaterialTouchIndex, out rightHandMaterialTouchIndex, rightHandSurfaceOverride, out rightHandSurfaceOverride);
			UpdateGrip(rightGrip, rightHandColliding, lastRightHandPosition, (_castCollider != null) ? _castCollider : rightCastCollider);
			StoreVelocities();
			didAJump = false;
			if (OverrideSlipToMax())
			{
				didAJump = true;
			}
			else if (rightHandSlide || leftHandSlide)
			{
				slideAverageNormal = Vector3.zero;
				touchPoints = 0;
				averageSlipPercentage = 0f;
				if (leftHandSlide)
				{
					slideAverageNormal += leftHandSlideNormal.normalized;
					averageSlipPercentage += leftHandSlipPercentage;
					touchPoints++;
				}
				if (rightHandSlide)
				{
					slideAverageNormal += rightHandSlideNormal.normalized;
					averageSlipPercentage += rightHandSlipPercentage;
					touchPoints++;
				}
				slideAverageNormal = slideAverageNormal.normalized;
				averageSlipPercentage /= (float)touchPoints;
				if (touchPoints == 1)
				{
					surfaceDirection = (rightHandSlide ? Vector3.ProjectOnPlane(rightHandTransform.forward, rightHandSlideNormal) : Vector3.ProjectOnPlane(leftHandTransform.forward, leftHandSlideNormal));
					if (Vector3.Dot(slideAverage, surfaceDirection) > 0f)
					{
						slideAverage = Vector3.Project(slideAverage, Vector3.Slerp(slideAverage, surfaceDirection.normalized * slideAverage.magnitude, slideControl));
					}
					else
					{
						slideAverage = Vector3.Project(slideAverage, Vector3.Slerp(slideAverage, -surfaceDirection.normalized * slideAverage.magnitude, slideControl));
					}
				}
				if (!wasLeftHandSlide && !wasRightHandSlide)
				{
					slideAverage = ((Vector3.Dot(playerRigidBody.linearVelocity, slideAverageNormal) <= 0f) ? Vector3.ProjectOnPlane(playerRigidBody.linearVelocity, slideAverageNormal) : playerRigidBody.linearVelocity);
				}
				else if (Vector3.Dot(slideAverage, slideAverageNormal) <= 0f)
				{
					slideAverage = Vector3.ProjectOnPlane(slideAverage, slideAverageNormal);
				}
				slideAverage = slideAverage.normalized * Mathf.Min(slideAverage.magnitude, Mathf.Max(0.5f, denormalizedVelocityAverage.magnitude * 2f));
				playerRigidBody.linearVelocity = Vector3.zero;
			}
			else if (leftHandColliding || rightHandColliding)
			{
				if (!didATurn)
				{
					playerRigidBody.linearVelocity = Vector3.zero;
				}
				else
				{
					playerRigidBody.linearVelocity = playerRigidBody.linearVelocity.normalized * Mathf.Min(2f, playerRigidBody.linearVelocity.magnitude);
				}
			}
			else if (wasLeftHandSlide || wasRightHandSlide)
			{
				playerRigidBody.linearVelocity = ((Vector3.Dot(slideAverage, slideAverageNormal) <= 0f) ? Vector3.ProjectOnPlane(slideAverage, slideAverageNormal) : slideAverage) * speedMultiplier;
			}
			bool flag = GameModePlayer.LocalPlayer != null && GameModePlayer.LocalPlayer.isFrozen;
			if ((rightHandColliding || leftHandColliding) && !disableMovement && !flag)
			{
				if (!didATurn && !didAJump)
				{
					if (rightHandSlide || leftHandSlide)
					{
						if (Vector3.Project(denormalizedVelocityAverage, slideAverageNormal).magnitude > slideVelocityLimit && Vector3.Dot(denormalizedVelocityAverage, slideAverageNormal) > 0f && Vector3.Project(denormalizedVelocityAverage, slideAverageNormal).magnitude > Vector3.Project(slideAverage, slideAverageNormal).magnitude)
						{
							leftHandSlide = false;
							rightHandSlide = false;
							didAJump = true;
							playerRigidBody.linearVelocity = (Mathf.Min(maxJumpSpeed * ExtraVelMaxMultiplier(), jumpMultiplier * ExtraVelMultiplier() * Vector3.Project(denormalizedVelocityAverage, slideAverageNormal).magnitude) * slideAverageNormal.normalized + Vector3.ProjectOnPlane(slideAverage, slideAverageNormal)) * speedMultiplier;
						}
					}
					else if (denormalizedVelocityAverage.magnitude > velocityLimit * currentScale)
					{
						didAJump = true;
						playerRigidBody.linearVelocity = Mathf.Min(maxJumpSpeed * ExtraVelMaxMultiplier(), jumpMultiplier * ExtraVelMultiplier() * denormalizedVelocityAverage.magnitude) * denormalizedVelocityAverage.normalized * speedMultiplier;
					}
				}
			}
			else if (flag)
			{
				playerRigidBody.linearVelocity = Vector3.zero;
			}
			float num = unStickDistance * currentScale;
			num *= num;
			int layerMask = locomotionEnabledLayers;
			Vector3 vector = CurrentHandPosition(leftHandTransform, leftHandOffset);
			Vector3 vector2 = CurrentHandPosition(rightHandTransform, rightHandOffset);
			if (leftHandColliding)
			{
				Vector3 position2 = headCollider.transform.position;
				if ((vector - lastLeftHandPosition).sqrMagnitude > num)
				{
					Vector3 vector3 = vector - position2;
					if (!Physics.Raycast(headCollider.transform.position, vector3.normalized, out hitInfo, vector3.magnitude, layerMask))
					{
						lastLeftHandPosition = vector;
						leftHandColliding = false;
						leftGrip.anchor = null;
					}
				}
			}
			if (rightHandColliding)
			{
				Vector3 position3 = headCollider.transform.position;
				if ((vector2 - lastRightHandPosition).sqrMagnitude > num)
				{
					Vector3 vector4 = vector2 - position3;
					if (!Physics.Raycast(headCollider.transform.position, vector4.normalized, out hitInfo, vector4.magnitude, layerMask))
					{
						lastRightHandPosition = vector2;
						rightHandColliding = false;
						rightGrip.anchor = null;
					}
				}
			}
			bool flag2 = (leftHandColliding && leftGrip.anchor != null) || (rightHandColliding && rightGrip.anchor != null);
			if (_handRiding && !flag2 && _bodyRideMover == null && !leftHandColliding && !rightHandColliding && !disableMovement && !flag && !_hitchFrame)
			{
				playerRigidBody.linearVelocity = playerRigidBody.linearVelocity + Vector3.ClampMagnitude(_rideVelocity, maxRidingVelocity);
				ForgetRideVelocity();
			}
			_handRiding = flag2;
			leftHandFollower.position = lastLeftHandPosition;
			rightHandFollower.position = lastRightHandPosition;
			leftHandFollower.rotation = leftHandTransform.rotation;
			rightHandFollower.rotation = rightHandTransform.rotation;
			wasLeftHandTouching = leftHandColliding;
			wasRightHandTouching = rightHandColliding;
			wasLeftHandSlide = leftHandSlide;
			wasRightHandSlide = rightHandSlide;
			didATurn = false;
			BodyCollider();
		}

		private void FirstHandIteration(Transform handTransform, Vector3 handOffset, Vector3 lastHandPosition, bool wasHandSlide, bool wasHandTouching, out Vector3 firstIteration, ref float handSlipPercentage, ref bool handSlide, ref Vector3 slideNormal, ref bool handColliding, ref int materialTouchIndex, ref Surface touchedOverride)
		{
			firstIteration = Vector3.zero;
			distanceTraveled = CurrentHandPosition(handTransform, handOffset) - lastHandPosition;
			if (!didAJump && wasHandSlide && Vector3.Dot(slideNormal, Vector3.up) > 0f)
			{
				distanceTraveled += Vector3.Project(stickDepth * currentScale * -slideAverageNormal, Vector3.down);
			}
			if (IterativeCollisionSphereCast(lastHandPosition, minimumRaycastDistance * currentScale, distanceTraveled, out finalPosition, true, out slipPercentage, out tempHitInfo, false))
			{
				if (wasHandTouching && slipPercentage <= defaultSlideFactor)
				{
					firstIteration = lastHandPosition - CurrentHandPosition(handTransform, handOffset);
				}
				else
				{
					firstIteration = finalPosition - CurrentHandPosition(handTransform, handOffset);
				}
				handSlipPercentage = slipPercentage;
				handSlide = slipPercentage > iceThreshold;
				slideNormal = tempHitInfo.normal;
				handColliding = true;
				materialTouchIndex = currentMaterialIndex;
				touchedOverride = currentOverride;
				lastHitInfoHand = tempHitInfo;
				_castCollider = tempHitInfo.collider;
			}
			else
			{
				handSlipPercentage = 0f;
				handSlide = false;
				slideNormal = Vector3.up;
				handColliding = false;
				materialTouchIndex = 0;
				touchedOverride = null;
			}
		}

		private Vector3 FinalHandPosition(Transform handTransform, Vector3 handOffset, Vector3 lastHandPosition, bool bothTouching, bool isHandTouching, out bool handColliding, bool isHandSlide, out bool handSlide, int currentMaterialTouchIndex, out int materialTouchIndex, Surface currentSurface, out Surface touchedOverride)
		{
			handColliding = isHandTouching;
			handSlide = isHandSlide;
			materialTouchIndex = currentMaterialTouchIndex;
			touchedOverride = currentSurface;
			distanceTraveled = CurrentHandPosition(handTransform, handOffset) - lastHandPosition;
			if (IterativeCollisionSphereCast(lastHandPosition, minimumRaycastDistance * currentScale, distanceTraveled, out finalPosition, bothTouching, out slipPercentage, out junkHit, false))
			{
				handColliding = true;
				handSlide = slipPercentage > iceThreshold;
				materialTouchIndex = currentMaterialIndex;
				touchedOverride = currentOverride;
				lastHitInfoHand = junkHit;
				_castCollider = junkHit.collider;
				return finalPosition;
			}
			return CurrentHandPosition(handTransform, handOffset);
		}

		private bool IterativeCollisionSphereCast(Vector3 startPosition, float sphereRadius, Vector3 movementVector, out Vector3 endPosition, bool singleHand, out float slipPercentage, out RaycastHit iterativeHitInfo, bool fullSlide)
		{
			slipPercentage = defaultSlideFactor;
			if (CollisionsSphereCast(startPosition, sphereRadius, movementVector, out endPosition, out tempIterativeHit))
			{
				firstPosition = endPosition;
				iterativeHitInfo = tempIterativeHit;
				slideFactor = GetSlidePercentage(iterativeHitInfo);
				slipPercentage = (Mathf.Approximately(slideFactor, defaultSlideFactor) ? slideFactor : (singleHand ? 0.001f : defaultSlideFactor));
				if (fullSlide || OverrideSlipToMax())
				{
					slipPercentage = 1f;
				}
				movementToProjectedAboveCollisionPlane = Vector3.ProjectOnPlane(startPosition + movementVector - firstPosition, iterativeHitInfo.normal) * slipPercentage;
				if (CollisionsSphereCast(firstPosition, sphereRadius, movementToProjectedAboveCollisionPlane, out endPosition, out tempIterativeHit))
				{
					iterativeHitInfo = tempIterativeHit;
					return true;
				}
				if (CollisionsSphereCast(movementToProjectedAboveCollisionPlane + firstPosition, sphereRadius, startPosition + movementVector - (movementToProjectedAboveCollisionPlane + firstPosition), out endPosition, out tempIterativeHit))
				{
					iterativeHitInfo = tempIterativeHit;
					return true;
				}
				endPosition = Vector3.zero;
				return false;
			}
			iterativeHitInfo = tempIterativeHit;
			endPosition = Vector3.zero;
			return false;
		}

		private bool CollisionsSphereCast(Vector3 startPosition, float sphereRadius, Vector3 movementVector, out Vector3 finalPos, out RaycastHit collisionsHitInfo)
		{
			int value = locomotionEnabledLayers.value;
			float magnitude = movementVector.magnitude;
			Vector3 normalized = movementVector.normalized;
			MaxSphereSizeForNoOverlap(sphereRadius, startPosition, out maxSphereSize1);
			ClearRaycasthitBuffer(ref rayCastNonAllocColliders);
			bufferCount = Physics.SphereCastNonAlloc(startPosition, maxSphereSize1, normalized, rayCastNonAllocColliders, magnitude, value);
			if (bufferCount > 0)
			{
				tempHitInfo = rayCastNonAllocColliders[0];
				for (int i = 0; i < bufferCount; i++)
				{
					if (rayCastNonAllocColliders[i].distance < tempHitInfo.distance)
					{
						tempHitInfo = rayCastNonAllocColliders[i];
					}
				}
				collisionsHitInfo = tempHitInfo;
				finalPos = collisionsHitInfo.point + collisionsHitInfo.normal * sphereRadius;
				Vector3 vector = finalPos - startPosition;
				float magnitude2 = vector.magnitude;
				Vector3 direction = vector / magnitude2;
				ClearRaycasthitBuffer(ref rayCastNonAllocColliders);
				bufferCount = Physics.RaycastNonAlloc(startPosition, direction, rayCastNonAllocColliders, magnitude2, value, QueryTriggerInteraction.Ignore);
				if (bufferCount > 0)
				{
					tempHitInfo = rayCastNonAllocColliders[0];
					for (int j = 0; j < bufferCount; j++)
					{
						if (rayCastNonAllocColliders[j].distance < tempHitInfo.distance)
						{
							tempHitInfo = rayCastNonAllocColliders[j];
						}
					}
					finalPos = startPosition + normalized * tempHitInfo.distance;
				}
				MaxSphereSizeForNoOverlap(sphereRadius, finalPos, out maxSphereSize2);
				Vector3 vector2 = finalPos - startPosition;
				float magnitude3 = vector2.magnitude;
				Vector3 direction2 = vector2 / magnitude3;
				ClearRaycasthitBuffer(ref rayCastNonAllocColliders);
				bufferCount = Physics.SphereCastNonAlloc(startPosition, Mathf.Min(maxSphereSize1, maxSphereSize2), direction2, rayCastNonAllocColliders, magnitude3, value);
				if (bufferCount > 0)
				{
					tempHitInfo = rayCastNonAllocColliders[0];
					for (int k = 0; k < bufferCount; k++)
					{
						if (rayCastNonAllocColliders[k].collider != null && rayCastNonAllocColliders[k].distance < tempHitInfo.distance)
						{
							tempHitInfo = rayCastNonAllocColliders[k];
						}
					}
					finalPos = startPosition + direction2 * tempHitInfo.distance;
					collisionsHitInfo = tempHitInfo;
				}
				Vector3 vector3 = finalPos - startPosition;
				float magnitude4 = vector3.magnitude;
				ClearRaycasthitBuffer(ref rayCastNonAllocColliders);
				bufferCount = Physics.RaycastNonAlloc(startPosition, vector3 / magnitude4, rayCastNonAllocColliders, magnitude4, value);
				if (bufferCount > 0)
				{
					tempHitInfo = rayCastNonAllocColliders[0];
					for (int l = 0; l < bufferCount; l++)
					{
						if (rayCastNonAllocColliders[l].distance < tempHitInfo.distance)
						{
							tempHitInfo = rayCastNonAllocColliders[l];
						}
					}
					collisionsHitInfo = tempHitInfo;
					finalPos = startPosition;
				}
				return true;
			}
			ClearRaycasthitBuffer(ref rayCastNonAllocColliders);
			bufferCount = Physics.RaycastNonAlloc(startPosition, normalized, rayCastNonAllocColliders, magnitude, value);
			if (bufferCount > 0)
			{
				tempHitInfo = rayCastNonAllocColliders[0];
				for (int m = 0; m < bufferCount; m++)
				{
					if (rayCastNonAllocColliders[m].collider != null && rayCastNonAllocColliders[m].distance < tempHitInfo.distance)
					{
						tempHitInfo = rayCastNonAllocColliders[m];
					}
				}
				collisionsHitInfo = tempHitInfo;
				finalPos = startPosition;
				return true;
			}
			finalPos = startPosition + movementVector;
			collisionsHitInfo = default(RaycastHit);
			return false;
		}

		public bool IsHandTouching(bool forLeftHand)
		{
			if (forLeftHand)
			{
				return wasLeftHandTouching;
			}
			return wasRightHandTouching;
		}

		public bool IsHandSliding(bool forLeftHand)
		{
			if (forLeftHand)
			{
				if (!wasLeftHandSlide)
				{
					return leftHandSlide;
				}
				return true;
			}
			if (!wasRightHandSlide)
			{
				return rightHandSlide;
			}
			return true;
		}

		public float GetSlidePercentage(RaycastHit raycastHit)
		{
			Collider collider = raycastHit.collider;
			if (!_surfaceCache.TryGetValue(collider, out currentOverride))
			{
				currentOverride = collider.GetComponent<Surface>();
				_surfaceCache[collider] = currentOverride;
			}
			if ((bool)currentOverride)
			{
				return defaultSlideFactor;
			}
			meshCollider = collider as MeshCollider;
			if ((bool)meshCollider && (bool)meshCollider.sharedMesh && currentMaterialIndex == -1)
			{
				currentMaterialIndex = 0;
			}
			return defaultSlideFactor;
		}

		public void Turn(float degrees)
		{
			if (Driver != null)
			{
				Driver.TurnRig(degrees);
				return;
			}
			TurnPivot.RotateAround(headCollider.transform.position, transform.up, degrees);
			Quaternion quaternion = Quaternion.Euler(0f, degrees, 0f);
			denormalizedVelocityAverage = Vector3.zero;
			for (int i = 0; i < velocityHistory.Length; i++)
			{
				velocityHistory[i] = quaternion * velocityHistory[i];
				denormalizedVelocityAverage += velocityHistory[i];
			}
			_runningVelocitySum = denormalizedVelocityAverage;
			didATurn = true;
		}

		public void TeleportToSpawn()
		{
			Vector3 position = (spawnPosition ? spawnPosition.position : _storedSpawnPosition);
			Quaternion rotation = (spawnPosition ? spawnPosition.rotation : transform.rotation);
			TeleportPlayerRaw(position, rotation);
		}

		public void TeleportPlayerTransform(Transform destination, bool setRotation = false)
		{
			if (destination == null)
			{
				Debug.LogWarning("[Player] TeleportPlayerTransform called with null destination");
			}
			else
			{
				TeleportPlayerRaw(destination.position, destination.rotation, setRotation);
			}
		}

		public void JumpscareTeleport(Vector3 senderViewOfPlayerPos, float triggerDistance)
		{
			Vector3 b = new Vector3(senderViewOfPlayerPos.x, transform.position.y, senderViewOfPlayerPos.z);
			float num = Vector3.Distance(transform.position, b);
			float num2 = triggerDistance + jumpscareTeleportLatencyCushion;
			Debug.Log(string.Format("[Player] JumpscareTeleport called. distance={0:F2}, threshold={1:F2}, target={2}, spawnSet={3}", num, num2, (jumpscareTeleportTarget != null) ? jumpscareTeleportTarget.name : "<null, will use spawn>", spawnPosition != null));
			if (num > num2)
			{
				Debug.LogWarning(string.Format("[Player] JumpscareTeleport REJECTED — distance {0:F2} exceeds threshold {1:F2}. If this is wrong, increase jumpscareTeleportLatencyCushion on the Player component (currently {2}).", num, num2, jumpscareTeleportLatencyCushion));
			}
			else if (jumpscareTeleportTarget != null)
			{
				TeleportPlayerTransform(jumpscareTeleportTarget, jumpscareTeleportSetRotation);
			}
			else
			{
				TeleportToSpawn();
			}
		}

		public static event Action<Player> Teleported;

		public void AcceptExternalHeadPosition()
		{
			if (!(headCollider == null))
			{
				lastHeadPosition = headCollider.transform.position;
				lastOpenHeadPosition = lastHeadPosition;
				if (Driver != null)
				{
					Driver.AcceptExternalHeadPosition();
				}
			}
		}

		public void TeleportPlayerRaw(Vector3 position, Quaternion rotation, bool setRotation = false, bool resetVelocity = true)
		{
			if (Driver != null)
			{
				Driver.TeleportRig(position, rotation, setRotation, resetVelocity);
				return;
			}
			transform.position = position;
			if (setRotation)
			{
				transform.rotation = Quaternion.Euler(0f, rotation.eulerAngles.y, 0f);
			}
			Physics.SyncTransforms();
			if (resetVelocity && playerRigidBody != null)
			{
				playerRigidBody.linearVelocity = Vector3.zero;
				playerRigidBody.angularVelocity = Vector3.zero;
				if (velocityHistory != null)
				{
					for (int i = 0; i < velocityHistory.Length; i++)
					{
						velocityHistory[i] = Vector3.zero;
					}
				}
				_runningVelocitySum = Vector3.zero;
				denormalizedVelocityAverage = Vector3.zero;
				slideAverage = Vector3.zero;
			}
			lastPosition = transform.position;
			lastHeadPosition = headCollider.transform.position;
			lastOpenHeadPosition = headCollider.transform.position;
			lastLeftHandPosition = leftHandFollower.transform.position;
			lastRightHandPosition = rightHandFollower.transform.position;
			wasLeftHandTouching = false;
			wasRightHandTouching = false;
			wasLeftHandSlide = false;
			wasRightHandSlide = false;
			ClearPlatformRide();
			Teleported?.Invoke(this);
		}

		public void TeleportToObject(GameObject jumpscareObject)
		{
			if (teleportTarget == null)
			{
				Debug.LogWarning("Teleport target is not set in the inspector!");
				return;
			}
			TeleportPlayerTransform(teleportTarget);
			if (jumpscareObject != null)
			{
				StartCoroutine(ActivateJumpscareRoutine(jumpscareObject));
			}
		}

		public void TeleportToObjectExtended(GameObject jumpscareObject)
		{
			if (teleportTarget == null)
			{
				Debug.LogWarning("Teleport target is not set in the inspector!");
				return;
			}
			TeleportPlayerTransform(teleportTarget);
			if (jumpscareObject != null)
			{
				StartCoroutine(ActivateJumpscareRoutine2(jumpscareObject));
			}
		}

		public void TpToMonsterMuseum(GameObject j)
		{
			TpHelper(MonsterMuseum, j, "MonsterMuseum");
		}

		public void TpToShop(GameObject j)
		{
			TpHelper(Shop, j, "Shop");
		}

		public void TpToBundleRoom(GameObject j)
		{
			TpHelper(BundleRoom, j, "BundleRoom");
		}

		public void TpToCaveEnterenceShop(GameObject j)
		{
			TpHelper(CaveEnterenceShop, j, "CaveEnterenceShop");
		}

		public void TpToFloodedMap(GameObject j)
		{
			TpHelper(FloodedMap, j, "FloodedMap");
		}

		public void TpToGuarage(GameObject j)
		{
			TpHelper(Guarage, j, "Guarage");
		}

		public void TpToOutdoors(GameObject j)
		{
			TpHelper(Outdoors, j, "Outdoors");
		}

		public void TpToFlooddedMap(GameObject j)
		{
			TpHelper(FlooddedMap, j, "FlooddedMap");
		}

		private void TpHelper(Transform target, GameObject jumpscareObject, string name)
		{
			if (target == null)
			{
				Debug.LogWarning(name + " teleport target is not set in the inspector!");
				return;
			}
			TeleportPlayerTransform(target);
			if (jumpscareObject != null)
			{
				StartCoroutine(ActivateJumpscareRoutine(jumpscareObject));
			}
		}

		private IEnumerator ActivateJumpscareRoutine(GameObject obj)
		{
			obj.SetActive(true);
			yield return new WaitForSeconds(1.25f);
			obj.SetActive(false);
		}

		private IEnumerator ActivateJumpscareRoutine2(GameObject obj)
		{
			obj.SetActive(true);
			yield return new WaitForSeconds(4.958f);
			obj.SetActive(false);
		}

		private void StoreVelocities()
		{
			velocityIndex = (velocityIndex + 1) % velocityHistorySize;
			currentVelocity = (transform.position - lastPosition) / Mathf.Max(calcDeltaTime, 0.0001f);
			_runningVelocitySum -= velocityHistory[velocityIndex];
			velocityHistory[velocityIndex] = currentVelocity;
			_runningVelocitySum += currentVelocity;
			denormalizedVelocityAverage = _runningVelocitySum / velocityHistorySize;
			lastPosition = transform.position;
		}

		private void AntiTeleportTechnology()
		{
			if ((headCollider.transform.position - lastHeadPosition).magnitude >= teleportThresholdNoVel + playerRigidBody.linearVelocity.magnitude * calcDeltaTime)
			{
				transform.position = transform.position + lastHeadPosition - headCollider.transform.position;
			}
		}

		private bool MaxSphereSizeForNoOverlap(float testRadius, Vector3 checkPosition, out float overlapRadiusTest)
		{
			int value = locomotionEnabledLayers.value;
			overlapRadiusTest = testRadius;
			overlapAttempts = 0;
			while (overlapAttempts < 100 && overlapRadiusTest > testRadius * 0.75f)
			{
				ClearColliderBuffer(ref overlapColliders);
				bufferCount = Physics.OverlapSphereNonAlloc(checkPosition, overlapRadiusTest, overlapColliders, value, QueryTriggerInteraction.Ignore);
				if (bufferCount > 0)
				{
					overlapRadiusTest *= 0.99f;
					overlapAttempts++;
					continue;
				}
				overlapRadiusTest *= 0.995f;
				return true;
			}
			return false;
		}

		private bool CrazyCheck2(float sphereSize, Vector3 startPosition)
		{
			for (int i = 0; i < crazyCheckVectors.Length; i++)
			{
				if (NonAllocRaycast(startPosition, startPosition + crazyCheckVectors[i] * sphereSize) > 0)
				{
					return false;
				}
			}
			return true;
		}

		private int NonAllocRaycast(Vector3 startPosition, Vector3 endPosition)
		{
			Vector3 vector = endPosition - startPosition;
			float magnitude = vector.magnitude;
			return Physics.RaycastNonAlloc(startPosition, vector / magnitude, rayCastNonAllocColliders, magnitude, locomotionEnabledLayers.value, QueryTriggerInteraction.Ignore);
		}

		private void ClearColliderBuffer(ref Collider[] colliders)
		{
			Array.Clear(colliders, 0, colliders.Length);
		}

		private void ClearRaycasthitBuffer(ref RaycastHit[] raycastHits)
		{
			Array.Clear(raycastHits, 0, raycastHits.Length);
		}

		private float ExtraVelMultiplier()
		{
			float num = 1f;
			if (leftHandSurfaceOverride != null)
			{
				num = Mathf.Max(num, leftHandSurfaceOverride.extraVelMultiplier);
			}
			if (rightHandSurfaceOverride != null)
			{
				num = Mathf.Max(num, rightHandSurfaceOverride.extraVelMultiplier);
			}
			return num;
		}

		private float ExtraVelMaxMultiplier()
		{
			float num = 1f;
			if (leftHandSurfaceOverride != null)
			{
				num = Mathf.Max(num, leftHandSurfaceOverride.extraVelMaxMultiplier);
			}
			if (rightHandSurfaceOverride != null)
			{
				num = Mathf.Max(num, rightHandSurfaceOverride.extraVelMaxMultiplier);
			}
			return num * currentScale;
		}

		private void UpdateGrip(PlatformGrip grip, bool colliding, Vector3 handPoint, Collider hit)
		{
			if (!colliding)
			{
				grip.anchor = null;
			}
			else if (hit == null)
			{
				if (grip.anchor != null)
				{
					grip.local = grip.anchor.InverseTransformPoint(handPoint);
				}
			}
			else
			{
				grip.anchor = PlatformTransform(hit);
				if (!(grip.anchor == null))
				{
					grip.local = grip.anchor.InverseTransformPoint(handPoint);
					grip.lastRotation = grip.anchor.rotation;
				}
			}
		}

		private Transform PlatformTransform(Collider col)
		{
			Transform value = null;
			if (!followMovingPlatforms || col == null)
			{
				return null;
			}
			if (_platformCache.TryGetValue(col, out value))
			{
				return value;
			}
			Transform result = null;
			if (!col.transform.IsChildOf(transform))
			{
				Transform root = ((col.attachedRigidbody != null) ? col.attachedRigidbody.transform : col.transform);
				if (root.GetComponentInParent<MovingPlatform>() != null || root.GetComponentInParent<BasePlatform>() != null || col.GetComponentInParent<MovingPlatform>() != null || col.GetComponentInParent<BasePlatform>() != null)
				{
					result = col.transform;
				}
			}
			_platformCache[col] = result;
			return result;
		}

		private bool FollowMovingPlatforms(float dt)
		{
			if (!followMovingPlatforms || playerRigidBody.isKinematic)
			{
				ForgetRideVelocity();
				return false;
			}
			bool flag = wasLeftHandTouching && leftGrip.anchor != null;
			bool flag2 = wasRightHandTouching && rightGrip.anchor != null;
			bool flag3 = wasLeftHandTouching || wasLeftHandSlide || wasRightHandTouching || wasRightHandSlide;
			bool result;
			if (flag || flag2)
			{
				result = FollowHands(dt, flag, flag2);
			}
			else if (!flag3 && _bodyRideMover != null)
			{
				result = FollowBody(dt);
			}
			else
			{
				ForgetRideVelocity();
				result = false;
			}
			if (MovingPlatform.ActiveCount > 0 || BasePlatform.ActiveCount > 0)
			{
				Physics.SyncTransforms();
				ReleaseIfEmbedded(ref lastLeftHandPosition, ref wasLeftHandTouching, leftGrip, CurrentHandPosition(leftHandTransform, leftHandOffset));
				ReleaseIfEmbedded(ref lastRightHandPosition, ref wasRightHandTouching, rightGrip, CurrentHandPosition(rightHandTransform, rightHandOffset));
			}
			return result;
		}

		private bool FollowHands(float dt, bool leftPlanted, bool rightPlanted)
		{
			bool result = false;
			if (followPlatformRotation)
			{
				PlatformGrip platformGrip = (leftPlanted ? leftGrip : rightGrip);
				if (!leftPlanted || !rightPlanted || leftGrip.anchor == rightGrip.anchor)
				{
					float num = Mathf.DeltaAngle(platformGrip.lastRotation.eulerAngles.y, platformGrip.anchor.eulerAngles.y);
					if (Mathf.Abs(num) > 0.0001f)
					{
						RotateRigWithPlatform(num);
						result = true;
					}
				}
			}
			Vector3 zero = Vector3.zero;
			int num2 = 0;
			if (leftPlanted)
			{
				zero += Follow(leftGrip, ref lastLeftHandPosition);
				num2++;
			}
			if (rightPlanted)
			{
				zero += Follow(rightGrip, ref lastRightHandPosition);
				num2++;
			}
			zero /= (float)num2;
			float sqrMagnitude = zero.sqrMagnitude;
			if (maxRideStepMetres > 0f && sqrMagnitude > maxRideStepMetres * maxRideStepMetres)
			{
				lastLeftHandPosition = CurrentHandPosition(leftHandTransform, leftHandOffset);
				lastRightHandPosition = CurrentHandPosition(rightHandTransform, rightHandOffset);
				if (leftGrip.anchor != null)
				{
					leftGrip.local = leftGrip.anchor.InverseTransformPoint(lastLeftHandPosition);
				}
				if (rightGrip.anchor != null)
				{
					rightGrip.local = rightGrip.anchor.InverseTransformPoint(lastRightHandPosition);
				}
				ForgetRideVelocity();
				return result;
			}
			if (sqrMagnitude > 0f)
			{
				ShiftRig(zero, leftPlanted, rightPlanted);
				result = true;
			}
			EstimateRideVelocity(zero, dt);
			return result;
		}

		private bool FollowBody(float dt)
		{
			bool result = false;
			Transform bodyRideMover = _bodyRideMover;
			if (followPlatformRotation)
			{
				float num = Mathf.DeltaAngle(_bodyRideLastRotation.eulerAngles.y, bodyRideMover.eulerAngles.y);
				if (Mathf.Abs(num) > 0.0001f)
				{
					result = true;
					RotateRigWithPlatform(num);
				}
				_bodyRideLastRotation = bodyRideMover.rotation;
			}
			Vector3 vector = bodyRideMover.TransformPoint(_bodyRideAnchorLocal) - _bodyRideFootWorld;
			float sqrMagnitude = vector.sqrMagnitude;
			if (maxRideStepMetres > 0f && sqrMagnitude > maxRideStepMetres * maxRideStepMetres)
			{
				_bodyRideFootWorld += vector;
				ForgetRideVelocity();
				return result;
			}
			if (sqrMagnitude > 0f)
			{
				ShiftRig(vector, false, false);
				result = true;
			}
			_bodyRideFootWorld += vector;
			EstimateRideVelocity(vector, dt);
			return result;
		}

		private void ShiftRig(Vector3 shift, bool leftPlanted, bool rightPlanted)
		{
			transform.position += shift;
			lastHeadPosition += shift;
			lastOpenHeadPosition += shift;
			lastPosition += shift;
			if (!leftPlanted && !wasLeftHandTouching)
			{
				lastLeftHandPosition += shift;
			}
			if (!rightPlanted && !wasRightHandTouching)
			{
				lastRightHandPosition += shift;
			}
		}

		private void EstimateRideVelocity(Vector3 shift, float dt)
		{
			if (!(dt <= 0f) && !_hitchFrame)
			{
				Vector3 target = Vector3.ClampMagnitude(shift / dt, maxRidingVelocity);
				_rideVelocity = Vector3.SmoothDamp(_rideVelocity, target, ref _rideVelocityDamp, rideVelocitySmoothTime, float.PositiveInfinity, dt);
			}
		}

		private void ForgetRideVelocity()
		{
			_rideVelocity = Vector3.zero;
			_rideVelocityDamp = Vector3.zero;
		}

		private static Vector3 Follow(PlatformGrip grip, ref Vector3 lastHandPosition)
		{
			Vector3 vector = grip.anchor.TransformPoint(grip.local);
			Vector3 result = vector - lastHandPosition;
			lastHandPosition = vector;
			grip.lastRotation = grip.anchor.rotation;
			return result;
		}

		private void RotateRigWithPlatform(float yaw)
		{
			Vector3 position = headCollider.transform.position;
			Quaternion quaternion = Quaternion.Euler(0f, yaw, 0f);
			Vector3 position2 = transform.position;
			TurnPivot.RotateAround(position, Vector3.up, yaw);
			lastPosition += transform.position - position2;
			lastLeftHandPosition = position + quaternion * (lastLeftHandPosition - position);
			lastRightHandPosition = position + quaternion * (lastRightHandPosition - position);
			lastHeadPosition = position + quaternion * (lastHeadPosition - position);
			lastOpenHeadPosition = position + quaternion * (lastOpenHeadPosition - position);
			_bodyRideFootWorld = position + quaternion * (_bodyRideFootWorld - position);
			_rideVelocity = quaternion * _rideVelocity;
			_rideVelocityDamp = quaternion * _rideVelocityDamp;
			_runningVelocitySum = Vector3.zero;
			for (int i = 0; i < velocityHistory.Length; i++)
			{
				velocityHistory[i] = quaternion * velocityHistory[i];
				_runningVelocitySum += velocityHistory[i];
			}
			denormalizedVelocityAverage = _runningVelocitySum / velocityHistorySize;
		}

		private void ProbeBodyPlatform()
		{
			bool flag = bodyRidesPlatforms && followMovingPlatforms && !disableMovement && !playerRigidBody.isKinematic && (MovingPlatform.ActiveCount > 0 || BasePlatform.ActiveCount > 0);
			Vector3 foot = Vector3.zero;
			Transform platform = (flag ? PlatformUnderBody(out foot) : null);
			if (platform == null)
			{
				if (_bodyRideMover == null)
				{
					return;
				}
				if (flag && _bodyRideMissFrames < bodyRideGraceFrames)
				{
					_bodyRideMissFrames++;
					return;
				}
				bool flag2 = (wasLeftHandTouching && leftGrip.anchor != null) || (wasRightHandTouching && rightGrip.anchor != null);
				if (flag && !flag2 && !_hitchFrame)
				{
					playerRigidBody.linearVelocity += Vector3.ClampMagnitude(_rideVelocity, maxRidingVelocity);
				}
				_bodyRideMover = null;
				_bodyRideMissFrames = 0;
			}
			else
			{
				if (platform != _bodyRideMover)
				{
					_bodyRideLastRotation = platform.rotation;
				}
				_bodyRideMover = platform;
				_bodyRideMissFrames = 0;
				_bodyRideAnchorLocal = platform.InverseTransformPoint(foot);
				_bodyRideFootWorld = foot;
			}
		}

		private Transform PlatformUnderBody(out Vector3 foot)
		{
			foot = Vector3.zero;
			float num = Mathf.Cos(bodyRideMaxSlope * ((float)Math.PI / 180f));
			int num2 = Physics.SphereCastNonAlloc(headCollider.transform.position, headCollider.radius * 0.5f * currentScale, Vector3.down, _rideHits, currentScale * bodyRideReach, locomotionEnabledLayers.value, QueryTriggerInteraction.Ignore);
			if (num2 > 0)
			{
				int num3 = -1;
				for (int i = 0; i < num2; i++)
				{
					RaycastHit raycastHit = _rideHits[i];
					if (!(raycastHit.collider == null) && !(raycastHit.distance <= 0f) && !raycastHit.transform.IsChildOf(transform) && (num3 < 0 || raycastHit.distance < _rideHits[num3].distance))
					{
						num3 = i;
					}
				}
				if (num3 >= 0 && !(_rideHits[num3].normal.y < num))
				{
					Transform platform = PlatformTransform(_rideHits[num3].collider);
					if (platform != null)
					{
						foot = _rideHits[num3].point;
					}
					return platform;
				}
			}
			return null;
		}

		private void ReleaseIfEmbedded(ref Vector3 lastHand, ref bool touching, PlatformGrip grip, Vector3 currentHand)
		{
			int num = Physics.OverlapSphereNonAlloc(lastHand, minimumRaycastDistance * 0.5f * currentScale, _rideOverlaps, locomotionEnabledLayers.value, QueryTriggerInteraction.Ignore);
			for (int i = 0; i < num; i++)
			{
				if (!(PlatformTransform(_rideOverlaps[i]) == null))
				{
					lastHand = currentHand;
					touching = false;
					grip.anchor = null;
					break;
				}
			}
		}

		private void ClearPlatformRide()
		{
			leftGrip.anchor = null;
			rightGrip.anchor = null;
			_handRiding = false;
			ForgetRideVelocity();
			_bodyRideMover = null;
			_bodyRideMissFrames = 0;
		}

		public void SetMaximumSlipThisFrame()
		{
			disableGripFrameIdx = Time.frameCount;
			if (Driver != null)
			{
				Driver.SlipThisFrame();
			}
		}

		public bool OverrideSlipToMax()
		{
			return disableGripFrameIdx == Time.frameCount;
		}

		public void NotifyDriverTeleported()
		{
			lastHeadPosition = (headCollider != null) ? headCollider.transform.position : lastHeadPosition;
			lastOpenHeadPosition = lastHeadPosition;
			wasLeftHandTouching = false;
			wasRightHandTouching = false;
			wasLeftHandSlide = false;
			wasRightHandSlide = false;
			Teleported?.Invoke(this);
		}
	}
}
