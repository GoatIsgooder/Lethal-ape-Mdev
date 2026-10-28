using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.AI;

namespace LethalApeR.Gameplay.Monsters
{
	public class BaseMonster : MonoBehaviourPunCallbacks, IBlastReceiver, IPunObservable
	{
		[Header("Blasts")]
		[Tooltip("Longest stun one blast can give, whatever the weapon asks for (s).")]
		public float maxBlastStun = 3f;

		[Tooltip("After a stun ends, further blasts only shove for this long (s).")]
		public float blastStunCooldown = 3f;

		[Tooltip("How far a full-strength blast slides the monster back along the ground (m).")]
		public float blastShove = 2.5f;

		[Tooltip("How long the slide takes (s).")]
		public float blastShoveTime = 0.35f;

		private float _blastImmuneUntil;

		private Coroutine _shove;

		private Collider _bodyBox;

		private bool _bodyBoxResolved;

		private float _boredUntil;

		private float _ignoreSpawnUntil;

		internal float boredomNearSpawnFor;

		internal float boredomBunchedFor;

		private const byte EvtGusScream = 1;

		[Header("Navigation")]
		public NavMeshAgent agent;

		public WaypointSetType waypointSet;

		[Tooltip("Extra floors this monster can patrol. Leave empty for single-floor.")]
		public WaypointSetType[] additionalWaypointSets = Array.Empty<WaypointSetType>();

		[Header("Movement")]
		[SerializeField]
		private float chaseSpeed = 6f;

		[SerializeField]
		private float patrolSpeed = 3f;

		private Transform[] _patrolPoints;

		[Header("Detection")]
		[Tooltip("Origin for the FOV cone and line-of-sight raycast. Falls back to this.transform if null.")]
		[SerializeField]
		protected Transform headTransform;

		[SerializeField]
		protected float sightRange = 15f;

		[Tooltip("Full FOV cone angle in degrees (so 120 = 60 each side of forward).")]
		[SerializeField]
		protected float sightAngle = 120f;

		[SerializeField]
		protected LayerMask sightMask = -1;

		[SerializeField]
		protected bool requireLineOfSight = true;

		[SerializeField]
		private float trackAfterLoseSightDuration = 2.5f;

		[Header("Remote Smoothing")]
		[SerializeField]
		[Range(0f, 1f)]
		private float lerpValue = 0.15f;

		[Header("Jumpscare")]
		[SerializeField]
		private bool enableJumpscare;

		[Tooltip("Briefly activate the jumpscare visuals at scene load to force shader compilation, audio decompression and GPU mesh upload. Without this, the FIRST jumpscare in a session causes a multi-hundred-ms stutter on every client.")]
		[SerializeField]
		private bool prewarmJumpscareAssets = true;

		[SerializeField]
		protected float jumpscareTriggerDistance = 2.5f;

		[SerializeField]
		private float jumpscareDuration = 2f;

		[SerializeField]
		private float jumpscareCooldown = 15f;

		[SerializeField]
		private float jumpscareLungeDistance = 1.5f;

		[SerializeField]
		private float jumpscareLungeDuration = 0.3f;

		[SerializeField]
		private GameObject jumpscareObject;

		[SerializeField]
		private GameObject[] jumpscareDisableObjects;

		[SerializeField]
		private AudioSource jumpscareAudioSource;

		[SerializeField]
		private AudioClip jumpscareClip;

		[Tooltip("Camera (or any GameObject) that should ONLY be enabled for the player getting jumpscared. Disabled on every other client. Optional.")]
		[SerializeField]
		private GameObject jumpscareVictimCamera;

		[Tooltip("Far clip for the victim camera. The imported Blender camera defaults to 1000 m, which draws the whole map behind a close-up.")]
		[SerializeField]
		private float jumpscareCameraFarClip = 50f;

		[Header("Gus")]
		[SerializeField]
		private bool isGus;

		[SerializeField]
		private AudioSource gassyGusScream;

		[Header("Stuck Recovery (patrol only)")]
		[SerializeField]
		private float stuckTimeout = 2f;

		[SerializeField]
		private float stuckRekickCooldown = 1f;

		private Transform _playerTransform;

		private int _playerActorNumber = -1;

		private int _patrolIndex;

		public bool isPatrolling;

		public bool canSeePlayer;

		public bool screamSent;

		private float _lostSightTime;

		private bool _isTrackingLostPlayer;

		private float _lastMovingTime;

		private float _lastStuckRekick;

		private Transform _forcedTarget;

		private float _forceTargetUntil;

		private float _nextNavRecoveryAttempt;

		private Vector3 _masterPosition;

		private Vector3 _masterEuler;

		private bool _isJumpscaring;

		private float _nextJumpscareTime;

		private Vector3 _jumpscareLungeDirection;

		private float _jumpscareStartedAt;

		private float _frozenUntil;

		private bool _wasFrozen;

		private const string MonsterAudioChannel = "MuteForMonster";

		private static readonly List<Transform> _candTargets = new List<Transform>(32);

		private static readonly List<float> _candSqrDist = new List<float>(32);

		private static RaycastHit[] _losHits = new RaycastHit[32];

		private const int DetectionInterval = 10;

		private int _detectionPhase;

		private static int _detectionPhaseCursor;

		private KillRigVictimLook _victimLook;

		public Bounds BodyBounds
		{
			get
			{
				if (!_bodyBoxResolved)
				{
					_bodyBoxResolved = true;
					Collider[] colliders = GetComponentsInChildren<Collider>(true);
					foreach (Collider collider in colliders)
					{
						if (collider.gameObject.layer == 0 && (_bodyBox == null || collider.bounds.size.sqrMagnitude > _bodyBox.bounds.size.sqrMagnitude))
						{
							_bodyBox = collider;
						}
					}
				}
				if (_bodyBox != null && _bodyBox.enabled && _bodyBox.gameObject.activeInHierarchy)
				{
					return _bodyBox.bounds;
				}
				float scale = transform.lossyScale.y;
				float width = ((agent != null) ? (scale * agent.radius * 2f) : 1f);
				float height = ((agent != null) ? Mathf.Max(scale * agent.height, width) : 1.8f);
				Vector3 lift = ((agent != null) ? (Vector3.up * (scale * agent.baseOffset)) : Vector3.zero);
				Vector3 feet = transform.position - lift;
				return new Bounds(feet + Vector3.up * (height * 0.5f), new Vector3(width, height, width));
			}
		}

		public Vector3 BlastPivot => BodyBounds.center;

		public float BlastBodyRadius
		{
			get
			{
				Bounds bounds = BodyBounds;
				return Mathf.Min(bounds.extents.x, bounds.extents.z);
			}
		}

		public bool IsBored => Time.time < _boredUntil;

		private bool IgnoringSpawn => Time.time < _ignoreSpawnUntil;

		internal bool BoredomEligible => base.isActiveAndEnabled && !IsBored && !_isJumpscaring && !IsFrozen && (_forcedTarget == null || Time.time >= _forceTargetUntil);

		internal float BoredomTargetSqrDistance
		{
			get
			{
				if (_playerTransform != null && (canSeePlayer || _isTrackingLostPlayer))
				{
					return (_playerTransform.position - transform.position).sqrMagnitude;
				}
				return float.MaxValue;
			}
		}

		internal bool ChasingOutsideSpawn => canSeePlayer && _playerTransform != null && !MonsterExclusionZone.Contains(_playerTransform.position);

		protected bool IsJumpscaring => _isJumpscaring;

		protected virtual bool AgentDriven => true;

		protected Transform CurrentTarget => _playerTransform;

		protected bool IsTrackingLostPlayer => _isTrackingLostPlayer;

		protected Vector3 JumpscareLungeDirection => _jumpscareLungeDirection;

		protected Vector3 MasterPosition => _masterPosition;

		protected Quaternion MasterRotation => Quaternion.Euler(_masterEuler);

		protected float RemoteLerp => Mathf.Clamp01(lerpValue);

		protected Transform[] PatrolPoints => _patrolPoints;

		public bool IsFrozen => Time.time < _frozenUntil;

		void IBlastReceiver.OnBlast(in BlastInfo blast, in BlastHit hit)
		{
			if ((!PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom) || _isJumpscaring)
			{
				return;
			}
			float strength = Mathf.Clamp01(hit.strength);
			if (strength <= 0f)
			{
				return;
			}
			if (Time.time >= _blastImmuneUntil)
			{
				float stun = Mathf.Min(maxBlastStun, blast.stunSeconds * strength);
				if (stun > 0f)
				{
					Freeze(stun);
					_blastImmuneUntil = Time.time + stun + blastStunCooldown;
				}
			}
			Vector3 push = Vector3.ProjectOnPlane(hit.direction, Vector3.up);
			if (blastShove > 0f && push.sqrMagnitude > 0.0001f)
			{
				if (_shove != null)
				{
					StopCoroutine(_shove);
				}
				_shove = StartCoroutine(Shove(push.normalized * (strength * blastShove)));
			}
		}

		private IEnumerator Shove(Vector3 offset)
		{
			float duration = Mathf.Max(blastShoveTime, 0.05f);
			Vector3 done = Vector3.zero;
			float t = 0f;
			while (t < duration)
			{
				t = Mathf.Min(t + Time.deltaTime, duration);
				if (agent == null || !agent.enabled || !agent.isOnNavMesh)
				{
					break;
				}
				float remaining = 1f - t / duration;
				Vector3 now = offset * (1f - remaining * remaining);
				agent.Move(now - done);
				done = now;
				yield return null;
			}
			_shove = null;
		}

		public void GetBored(MonsterBoredOf cause, Vector3 awayFrom, float blindSeconds, float ignoreSpawnSeconds, float escapeDistance)
		{
			if (!PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom)
			{
				return;
			}
			float now = Time.time;
			_boredUntil = now + Mathf.Max(0f, blindSeconds);
			if (cause == MonsterBoredOf.Spawn)
			{
				_ignoreSpawnUntil = Mathf.Max(_ignoreSpawnUntil, _boredUntil + Mathf.Max(0f, ignoreSpawnSeconds));
			}
			boredomNearSpawnFor = 0f;
			boredomBunchedFor = 0f;
			DropTarget();
			isPatrolling = true;
			if (!(agent == null) && agent.enabled && agent.isOnNavMesh)
			{
				agent.isStopped = false;
				agent.speed = patrolSpeed;
				if (TryPickEscape(cause, awayFrom, escapeDistance, out var escape))
				{
					agent.SetDestination(escape);
				}
				else
				{
					SelectRandomPatrol();
				}
				_lastMovingTime = now;
			}
		}

		private void BoredStep()
		{
			if (!(agent == null) && agent.enabled && agent.isOnNavMesh && !agent.pathPending)
			{
				agent.speed = patrolSpeed;
				if (agent.remainingDistance <= agent.stoppingDistance || !agent.hasPath)
				{
					SelectRandomPatrol();
				}
			}
		}

		private void DropSpawnTarget()
		{
			if (!(_playerTransform == null) && (canSeePlayer || _isTrackingLostPlayer) && MonsterExclusionZone.Contains(_playerTransform.position))
			{
				DropTarget();
				isPatrolling = true;
				SelectRandomPatrol();
			}
		}

		private void DropTarget()
		{
			canSeePlayer = false;
			_isTrackingLostPlayer = false;
			_playerTransform = null;
			_playerActorNumber = -1;
		}

		private bool TryPickEscape(MonsterBoredOf cause, Vector3 awayFrom, float escapeDistance, out Vector3 escape)
		{
			Vector3 position = transform.position;
			escape = position;
			Vector3 away = position - awayFrom;
			away.y = 0f;
			if (away.sqrMagnitude < 0.01f)
			{
				away = Vector3.ProjectOnPlane(-transform.forward, Vector3.up);
			}
			if (away.sqrMagnitude < 0.0001f)
			{
				away = Vector3.forward;
			}
			Vector3 dir = away.normalized;
			if (_patrolPoints != null && _patrolPoints.Length != 0)
			{
				Transform best = null;
				float bestClearance = float.MinValue;
				Transform pick = null;
				int eligible = 0;
				for (int i = 0; i < _patrolPoints.Length; i++)
				{
					Transform point = _patrolPoints[i];
					if (point == null)
					{
						continue;
					}
					Vector3 pointPos = point.position;
					float clearance = Clearance(cause, awayFrom, pointPos);
					if (clearance > bestClearance)
					{
						bestClearance = clearance;
						best = point;
					}
					if (!(clearance < escapeDistance))
					{
						Vector3 to = pointPos - position;
						to.y = 0f;
						if (Vector3.Dot(dir, to) > 0f && UnityEngine.Random.Range(0, ++eligible) == 0)
						{
							pick = point;
						}
					}
				}
				Transform chosen = ((pick != null) ? pick : best);
				if (chosen != null)
				{
					escape = chosen.position;
					return true;
				}
			}
			if (NavMesh.SamplePosition(position + dir * Mathf.Max(escapeDistance, 4f), out var hit, escapeDistance, -1))
			{
				escape = hit.position;
				return true;
			}
			return false;
		}

		private static float Clearance(MonsterBoredOf cause, Vector3 awayFrom, Vector3 point)
		{
			if (cause == MonsterBoredOf.Spawn && MonsterExclusionZone.DistanceToNearest(point, out var distance, out var _))
			{
				return distance;
			}
			float dx = point.x - awayFrom.x;
			float dz = point.z - awayFrom.z;
			return Mathf.Sqrt(dx * dx + dz * dz);
		}

		protected virtual void OnMonsterUpdate(bool isMaster)
		{
		}

		public override void OnEnable()
		{
			base.OnEnable();
			if ((bool)MonsterManager.Instance)
			{
				MonsterManager.Instance.RegisterMonster(this);
			}
			PhotonNetwork.NetworkingClient.EventReceived += OnEvent;
			AudioManager.Adopt(MonsterAudioChannel, GetComponentsInChildren<AudioSource>(true));
		}

		public override void OnDisable()
		{
			base.OnDisable();
			if ((bool)MonsterManager.Instance)
			{
				MonsterManager.Instance.UnregisterMonster(this);
			}
			PhotonNetwork.NetworkingClient.EventReceived -= OnEvent;
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			if (PhotonNetwork.IsMasterClient && !(agent == null) && AgentDriven)
			{
				agent.enabled = true;
				if (!isPatrolling && _patrolPoints != null && _patrolPoints.Length != 0)
				{
					isPatrolling = true;
					agent.speed = patrolSpeed;
					SelectRandomPatrol();
				}
			}
		}

		private void Start()
		{
			MonsterManager.Instance.RegisterMonster(this);
			_detectionPhase = _detectionPhaseCursor;
			_detectionPhaseCursor = (_detectionPhaseCursor + 1) % DetectionInterval;
			bool isRemote = !PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom;
			if (agent != null)
			{
				agent.enabled = !isRemote && AgentDriven;
			}
			if (!isRemote)
			{
				isPatrolling = _patrolPoints != null && _patrolPoints.Length > 0;
				if (isPatrolling)
				{
					SelectRandomPatrol();
				}
			}
			_masterPosition = transform.position;
			_masterEuler = transform.eulerAngles;
			if ((bool)jumpscareVictimCamera)
			{
				jumpscareVictimCamera.SetActive(false);
			}
			if (prewarmJumpscareAssets)
			{
				StartCoroutine(PrewarmJumpscareAssets());
			}
		}

		private IEnumerator PrewarmJumpscareAssets()
		{
			if (jumpscareClip != null)
			{
				jumpscareClip.LoadAudioData();
			}
			yield return null;
			if (jumpscareAudioSource != null && jumpscareClip != null)
			{
				float origVolume = jumpscareAudioSource.volume;
				bool origMute = jumpscareAudioSource.mute;
				jumpscareAudioSource.volume = 0f;
				jumpscareAudioSource.mute = true;
				jumpscareAudioSource.PlayOneShot(jumpscareClip, 0f);
				yield return null;
				jumpscareAudioSource.volume = origVolume;
				jumpscareAudioSource.mute = origMute;
			}
			else
			{
				yield return null;
			}
			bool prevJumpscareActive = (bool)jumpscareObject && jumpscareObject.activeSelf;
			if ((bool)jumpscareObject && !prevJumpscareActive)
			{
				jumpscareObject.SetActive(true);
			}
			yield return null;
			yield return null;
			if ((bool)jumpscareObject && !prevJumpscareActive)
			{
				jumpscareObject.SetActive(false);
			}
		}

		private void Update()
		{
			bool isMaster = PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom;
			bool wantAgent = isMaster && AgentDriven;
			if (agent != null && agent.enabled != wantAgent)
			{
				agent.enabled = wantAgent;
			}
			if (wantAgent && agent != null && agent.enabled && !agent.isOnNavMesh && Time.time >= _nextNavRecoveryAttempt)
			{
				_nextNavRecoveryAttempt = Time.time + 0.5f;
				if (NavMesh.SamplePosition(transform.position, out var hit, 1000f, -1))
				{
					agent.Warp(hit.position);
					if (agent.isOnNavMesh)
					{
						agent.isStopped = false;
					}
				}
			}
			TickJumpscareWatchdog();
			if (isMaster)
			{
				RunMasterAI();
			}
			else
			{
				FollowNetwork();
			}
			CheckForStuck();
			OnMonsterUpdate(isMaster);
		}

		private void CheckForStuck()
		{
			if (_isJumpscaring || IsFrozen || agent == null || !agent.enabled || !agent.isOnNavMesh || (!PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom))
			{
				return;
			}
			if (!isPatrolling || canSeePlayer || _isTrackingLostPlayer)
			{
				_lastMovingTime = Time.time;
			}
			else if (agent.velocity.sqrMagnitude > 0.04f)
			{
				_lastMovingTime = Time.time;
			}
			else if (!(Time.time - _lastMovingTime < stuckTimeout) && !(Time.time - _lastStuckRekick < stuckRekickCooldown))
			{
				agent.isStopped = false;
				SelectRandomPatrol();
				_lastStuckRekick = Time.time;
				_lastMovingTime = Time.time;
			}
		}

		protected virtual void UpdateDetection()
		{
			if (_forcedTarget != null && Time.time < _forceTargetUntil)
			{
				return;
			}
			IReadOnlyList<Transform> targets = ChaseTargetRegistry.Targets;
			int count = targets.Count;
			if (count == 0)
			{
				if (canSeePlayer)
				{
					OnLostSight();
				}
				return;
			}
			Transform head = ((headTransform != null) ? headTransform : transform);
			Vector3 headPos = head.position;
			Vector3 forward = head.forward;
			float range = sightRange;
			float cosHalfAngle = Mathf.Cos(sightAngle * 0.5f * Mathf.Deg2Rad);
			bool ignoringSpawn = IgnoringSpawn;
			_candTargets.Clear();
			_candSqrDist.Clear();
			float rangeSqr = range * range;
			for (int i = 0; i < count; i++)
			{
				Transform candidate = targets[i];
				if (candidate == null)
				{
					continue;
				}
				Vector3 delta = candidate.position - headPos;
				float sqrDist = delta.sqrMagnitude;
				if (sqrDist >= rangeSqr)
				{
					continue;
				}
				if (sqrDist > 1E-08f)
				{
					Vector3 dir = delta / Mathf.Sqrt(sqrDist);
					if (Vector3.Dot(forward, dir) < cosHalfAngle)
					{
						continue;
					}
				}
				if (!ignoringSpawn || !MonsterExclusionZone.Contains(candidate.position))
				{
					_candTargets.Add(candidate);
					_candSqrDist.Add(sqrDist);
				}
			}
			Transform found = null;
			while (found == null)
			{
				int best = -1;
				for (int j = 0; j < _candSqrDist.Count; j++)
				{
					if (_candSqrDist[j] != float.MaxValue && (best < 0 || _candSqrDist[j] < _candSqrDist[best]))
					{
						best = j;
					}
				}
				if (best < 0)
				{
					break;
				}
				Transform next = _candTargets[best];
				_candSqrDist[best] = float.MaxValue;
				if (!requireLineOfSight || HasLineOfSight(headPos, next))
				{
					found = next;
				}
			}
			if (found != null)
			{
				SetTargetTransform(found);
			}
			else if (canSeePlayer)
			{
				OnLostSight();
			}
		}

		private bool HasLineOfSight(Vector3 headPos, Transform target)
		{
			Vector3 delta = target.position - headPos;
			float distance = delta.magnitude;
			if (distance <= 0.0001f)
			{
				return true;
			}
			Vector3 dir = delta / distance;
			int hits = CastLineOfSight(headPos, dir, distance, sightMask);
			for (int i = 0; i < hits; i++)
			{
				Transform hitTransform = _losHits[i].transform;
				if (!(hitTransform == null) && !hitTransform.IsChildOf(transform) && !(hitTransform == target))
				{
					ChaseTarget chaseTarget = hitTransform.GetComponentInParent<ChaseTarget>();
					if (!(chaseTarget != null) || !(chaseTarget.TargetTransform == target))
					{
						return false;
					}
				}
			}
			return true;
		}

		private static int CastLineOfSight(Vector3 origin, Vector3 dir, float dist, int mask)
		{
			int hits;
			while (true)
			{
				hits = Physics.RaycastNonAlloc(origin, dir, _losHits, dist, mask, QueryTriggerInteraction.Ignore);
				if (hits < _losHits.Length || _losHits.Length >= 1024)
				{
					break;
				}
				_losHits = new RaycastHit[_losHits.Length * 2];
			}
			return hits;
		}

		private void RunMasterAI()
		{
			if (IsFrozen)
			{
				_wasFrozen = true;
				if (agent != null && agent.isOnNavMesh)
				{
					agent.isStopped = true;
					agent.velocity = Vector3.zero;
				}
				return;
			}
			if (_wasFrozen)
			{
				_wasFrozen = false;
				if (agent != null && agent.isOnNavMesh)
				{
					agent.isStopped = false;
				}
				_lastMovingTime = Time.time;
				_lastStuckRekick = 0f;
			}
			if (IsBored)
			{
				BoredStep();
				return;
			}
			if (_forcedTarget != null)
			{
				if (Time.time >= _forceTargetUntil || IsTargetIncapacitated(_playerActorNumber))
				{
					ClearForcedTarget();
				}
				else
				{
					SetTargetTransform(_forcedTarget);
				}
			}
			if (Time.frameCount % DetectionInterval == _detectionPhase)
			{
				UpdateDetection();
			}
			if (IgnoringSpawn && _forcedTarget == null)
			{
				DropSpawnTarget();
			}
			if (_isJumpscaring)
			{
				return;
			}
			HandleScreamEvent();
			if (canSeePlayer && (bool)_playerTransform)
			{
				if (IsTargetIncapacitated(_playerActorNumber))
				{
					OnLostSight();
					return;
				}
				if (enableJumpscare && Time.time >= _nextJumpscareTime && (transform.position - _playerTransform.position).sqrMagnitude <= jumpscareTriggerDistance * jumpscareTriggerDistance)
				{
					Vector3 lungeDirection = _playerTransform.position - transform.position;
					lungeDirection.y = 0f;
					lungeDirection.Normalize();
					base.photonView.RPC("RPC_DoJumpscare", RpcTarget.All, lungeDirection, _playerTransform.position, _playerActorNumber);
				}
				else
				{
					agent.speed = chaseSpeed;
					if (agent.isOnNavMesh)
					{
						agent.SetDestination(_playerTransform.position);
					}
				}
			}
			else if (_isTrackingLostPlayer)
			{
				if ((bool)_playerTransform && agent.isOnNavMesh)
				{
					agent.speed = chaseSpeed;
					agent.SetDestination(_playerTransform.position);
				}
				if (Time.time - _lostSightTime >= trackAfterLoseSightDuration)
				{
					_isTrackingLostPlayer = false;
					isPatrolling = true;
					SelectRandomPatrol();
				}
			}
			else
			{
				if (!isPatrolling)
				{
					isPatrolling = true;
					SelectRandomPatrol();
				}
				agent.speed = patrolSpeed;
				if (agent.isOnNavMesh && !agent.pathPending)
				{
					bool arrived = agent.remainingDistance <= agent.stoppingDistance;
					bool noPath = !agent.hasPath && _patrolPoints != null && _patrolPoints.Length != 0;
					if (arrived || noPath)
					{
						SelectRandomPatrol();
					}
				}
			}
		}

		private void StartPatrol()
		{
			isPatrolling = true;
			SelectRandomPatrol();
		}

		private void HandleScreamEvent()
		{
			if (isGus && canSeePlayer && !screamSent)
			{
				screamSent = true;
				RaiseEventOptions raiseEventOptions = new RaiseEventOptions
				{
					Receivers = ReceiverGroup.All
				};
				PhotonNetwork.RaiseEvent(EvtGusScream, null, raiseEventOptions, SendOptions.SendReliable);
			}
		}

		protected void SetTargetPlayer(MonkeDevNetworkingPlayer player)
		{
			canSeePlayer = true;
			screamSent = false;
			_isTrackingLostPlayer = false;
			_playerTransform = player.Head;
			_playerActorNumber = ((player != null && player.photonView != null) ? player.photonView.OwnerActorNr : (-1));
		}

		protected void SetTargetTransform(Transform target)
		{
			canSeePlayer = true;
			screamSent = false;
			_isTrackingLostPlayer = false;
			_playerTransform = target;
			_playerActorNumber = ResolveActorNumberFromTransform(target);
		}

		public static int ResolveActorNumberFromTransform(Transform t)
		{
			if (t == null)
			{
				return -1;
			}
			PhotonView componentInParent = t.GetComponentInParent<PhotonView>();
			if (componentInParent != null)
			{
				return componentInParent.OwnerActorNr;
			}
			if (GorillaLocomotion.Player.Instance != null && t.IsChildOf(GorillaLocomotion.Player.Instance.transform))
			{
				if (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null)
				{
					return PhotonNetwork.LocalPlayer.ActorNumber;
				}
				return -2;
			}
			return -1;
		}

		public void TryJumpscare(Transform victim)
		{
			if ((!PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom) || _isJumpscaring || IsBored || Time.time < _nextJumpscareTime || victim == null)
			{
				return;
			}
			Vector3 vector = victim.position - transform.position;
			vector.y = 0f;
			Vector3 vector2 = ((vector.sqrMagnitude > 0.0001f) ? vector.normalized : transform.forward);
			int num = ResolveActorNumberFromTransform(victim);
			photonView.RPC("RPC_DoJumpscare", RpcTarget.All, vector2, victim.position, num);
		}

		public void ForceTarget(Transform victim, float duration)
		{
			if ((PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom) && !(victim == null))
			{
				_boredUntil = 0f;
				_forcedTarget = victim;
				_forceTargetUntil = Time.time + Mathf.Max(0f, duration);
				isPatrolling = false;
				SetTargetTransform(victim);
			}
		}

		public void ClearForcedTarget()
		{
			if (!(_forcedTarget == null))
			{
				_forcedTarget = null;
				OnLostSight();
			}
		}

		protected virtual bool IsTargetIncapacitated(int actorNumber)
		{
			return false;
		}

		public void Freeze(float duration)
		{
			if ((PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom) && !_isJumpscaring)
			{
				_frozenUntil = Mathf.Max(_frozenUntil, Time.time + Mathf.Max(0f, duration));
				if (agent != null && agent.enabled && agent.isOnNavMesh)
				{
					agent.isStopped = true;
					agent.velocity = Vector3.zero;
				}
			}
		}

		public void RequestFreeze(float duration)
		{
			if (PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom)
			{
				Freeze(duration);
			}
			else if (photonView != null && photonView.ViewID != 0)
			{
				photonView.RPC("RPC_Freeze", RpcTarget.MasterClient, duration);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_Freeze(float duration)
		{
			Freeze(duration);
		}

		protected void OnLostSight()
		{
			canSeePlayer = false;
			_isTrackingLostPlayer = true;
			_lostSightTime = Time.time;
		}

		private void SelectRandomPatrol()
		{
			if (_patrolPoints != null && _patrolPoints.Length != 0)
			{
				_patrolIndex = UnityEngine.Random.Range(0, _patrolPoints.Length);
				if (agent.isOnNavMesh)
				{
					agent.SetDestination(_patrolPoints[_patrolIndex].position);
				}
			}
		}

		protected virtual void FollowNetwork()
		{
			transform.position = Vector3.Lerp(transform.position, _masterPosition, RemoteLerp);
		}

		private void OnEvent(EventData data)
		{
			if (data.Code == 1 && (bool)gassyGusScream && !gassyGusScream.isPlaying)
			{
				gassyGusScream.Play();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_DoJumpscare(Vector3 lungeDirection, Vector3 targetPosition, int victimActorNumber)
		{
			if (_isJumpscaring)
			{
				return;
			}
			_isJumpscaring = true;
			_jumpscareStartedAt = Time.time;
			if (agent != null && agent.isOnNavMesh)
			{
				agent.isStopped = true;
				agent.velocity = Vector3.zero;
			}
			if ((bool)jumpscareObject)
			{
				if (_victimLook == null)
				{
					_victimLook = new KillRigVictimLook(jumpscareObject);
				}
				_victimLook.Apply(FindVictimPlayer(victimActorNumber));
				jumpscareObject.SetActive(true);
			}
			if (jumpscareDisableObjects != null)
			{
				GameObject[] array = jumpscareDisableObjects;
				foreach (GameObject gameObject in array)
				{
					if ((bool)gameObject)
					{
						gameObject.SetActive(false);
					}
				}
			}
			if ((bool)jumpscareAudioSource && (bool)jumpscareClip)
			{
				jumpscareAudioSource.PlayOneShot(jumpscareClip);
			}
			_jumpscareLungeDirection = lungeDirection;
			int num = ((PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
			bool flag = false;
			if (victimActorNumber == -2 || (victimActorNumber >= 1 && num == victimActorNumber))
			{
				if (TeleportVictimOnJumpscare() && GorillaLocomotion.Player.Instance != null)
				{
					GorillaLocomotion.Player.Instance.JumpscareTeleport(targetPosition, jumpscareTriggerDistance);
				}
				LethalApeR.Quests.QuestEvents.RaiseLocalPlayerJumpscared(this);
				flag = true;
			}
			if ((bool)jumpscareVictimCamera)
			{
				if (flag)
				{
					PrepareVictimCamera();
				}
				jumpscareVictimCamera.SetActive(flag);
			}
			OnJumpscareStarted();
			OnJumpscareVictim(victimActorNumber);
			if (PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom)
			{
				StartCoroutine(JumpscareRoutine());
			}
		}

		private IEnumerator LungeRoutine(Vector3 direction)
		{
			float elapsed = 0f;
			while (elapsed < jumpscareLungeDuration)
			{
				elapsed += Time.deltaTime;
				float num = jumpscareLungeDistance * (Time.deltaTime / jumpscareLungeDuration);
				if (agent != null && agent.enabled && agent.isOnNavMesh)
				{
					agent.Move(direction * num);
				}
				else
				{
					transform.position += direction * num;
				}
				yield return null;
			}
			if (agent != null && agent.enabled && agent.isOnNavMesh && !IsFrozen)
			{
				agent.isStopped = false;
			}
			_lastMovingTime = Time.time;
			_lastStuckRekick = 0f;
			OnJumpscareEnded();
		}

		private IEnumerator JumpscareRoutine()
		{
			yield return new WaitForSeconds(jumpscareDuration);
			photonView.RPC("RPC_EndJumpscare", RpcTarget.All);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_EndJumpscare()
		{
			_isJumpscaring = false;
			_nextJumpscareTime = Time.time + jumpscareCooldown;
			if ((bool)jumpscareObject)
			{
				jumpscareObject.SetActive(false);
			}
			if ((bool)jumpscareVictimCamera)
			{
				jumpscareVictimCamera.SetActive(false);
			}
			if (jumpscareDisableObjects != null)
			{
				GameObject[] array = jumpscareDisableObjects;
				foreach (GameObject gameObject in array)
				{
					if ((bool)gameObject)
					{
						gameObject.SetActive(true);
					}
				}
			}
			if (jumpscareLungeDistance > 0f)
			{
				StartCoroutine(LungeRoutine(_jumpscareLungeDirection));
				return;
			}
			if (agent != null && agent.isOnNavMesh && !IsFrozen)
			{
				agent.isStopped = false;
			}
			_lastMovingTime = Time.time;
			_lastStuckRekick = 0f;
			OnJumpscareEnded();
		}

		private static MonkeDevNetworkingPlayer FindVictimPlayer(int victimActorNumber)
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return null;
			}
			if (victimActorNumber == -2)
			{
				return manager.LocalPlayer;
			}
			if (victimActorNumber >= 1)
			{
				List<MonkeDevNetworkingPlayer> players = manager.Players;
				for (int i = 0; i < players.Count; i++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
					if (monkeDevNetworkingPlayer != null && monkeDevNetworkingPlayer.photonView != null && monkeDevNetworkingPlayer.photonView.Owner != null && monkeDevNetworkingPlayer.photonView.Owner.ActorNumber == victimActorNumber)
					{
						return monkeDevNetworkingPlayer;
					}
				}
			}
			return null;
		}

		private void PrepareVictimCamera()
		{
			if (!jumpscareVictimCamera.TryGetComponent<KillCamView>(out var _))
			{
				jumpscareVictimCamera.AddComponent<KillCamView>();
			}
			Camera component = jumpscareVictimCamera.GetComponent<Camera>();
			if (!component)
			{
				return;
			}
			component.farClipPlane = Mathf.Max(component.nearClipPlane + 0.01f, jumpscareCameraFarClip);
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
			Camera camera = ((player != null) ? player.mainCamera : null);
			if ((bool)camera)
			{
				component.clearFlags = camera.clearFlags;
				component.backgroundColor = camera.backgroundColor;
				component.allowHDR = camera.allowHDR;
				component.allowMSAA = camera.allowMSAA;
			}
		}

		protected virtual void OnJumpscareStarted()
		{
		}

		protected virtual void OnJumpscareEnded()
		{
		}

		protected virtual void OnJumpscareVictim(int victimActorNumber)
		{
		}

		protected virtual bool TeleportVictimOnJumpscare()
		{
			return true;
		}

		private void ForceEndJumpscareLocal()
		{
			_isJumpscaring = false;
			_nextJumpscareTime = Time.time + jumpscareCooldown;
			if ((bool)jumpscareObject)
			{
				jumpscareObject.SetActive(false);
			}
			if ((bool)jumpscareVictimCamera)
			{
				jumpscareVictimCamera.SetActive(false);
			}
			if (jumpscareDisableObjects != null)
			{
				GameObject[] array = jumpscareDisableObjects;
				foreach (GameObject gameObject in array)
				{
					if ((bool)gameObject)
					{
						gameObject.SetActive(true);
					}
				}
			}
			if ((bool)agent && agent.isOnNavMesh && !IsFrozen)
			{
				agent.isStopped = false;
			}
			_lastMovingTime = Time.time;
			_lastStuckRekick = 0f;
			OnJumpscareEnded();
		}

		private void TickJumpscareWatchdog()
		{
			if (!_isJumpscaring)
			{
				return;
			}
			float num = jumpscareDuration + Mathf.Max(0f, jumpscareLungeDuration) + 5f;
			if (!(Time.time - _jumpscareStartedAt < num))
			{
				if (PhotonNetwork.InRoom && PhotonNetwork.IsMasterClient && photonView != null && photonView.ViewID != 0)
				{
					photonView.RPC("RPC_EndJumpscare", RpcTarget.All);
				}
				else
				{
					ForceEndJumpscareLocal();
				}
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (stream.IsWriting)
			{
				stream.SendNext(transform.position);
				stream.SendNext(transform.eulerAngles);
				stream.SendNext(canSeePlayer);
				WriteExtraSync(stream);
			}
			else
			{
				_masterPosition = (Vector3)stream.ReceiveNext();
				_masterEuler = (Vector3)stream.ReceiveNext();
				canSeePlayer = (bool)stream.ReceiveNext();
				ReadExtraSync(stream);
			}
		}

		protected virtual void WriteExtraSync(PhotonStream stream)
		{
		}

		protected virtual void ReadExtraSync(PhotonStream stream)
		{
		}

		public void IgnoreCollisionWith(BaseMonster other)
		{
			if (other == null || other == this)
			{
				return;
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(true);
			Collider[] componentsInChildren2 = other.GetComponentsInChildren<Collider>(true);
			foreach (Collider collider in componentsInChildren)
			{
				if (collider == null || collider.isTrigger)
				{
					continue;
				}
				foreach (Collider collider2 in componentsInChildren2)
				{
					if (!(collider2 == null) && !collider2.isTrigger)
					{
						Physics.IgnoreCollision(collider, collider2);
					}
				}
			}
		}

		public void SetWaypoints(Transform[] waypoints)
		{
			if (_patrolPoints != waypoints)
			{
				_patrolPoints = waypoints;
				_patrolIndex = 0;
				isPatrolling = waypoints != null && waypoints.Length > 0;
				SelectRandomPatrol();
			}
		}
	}
}
