using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

namespace LethalApeR.Monsters
{
	public class AIBehaviour : MonoBehaviour
	{
		[Header("Configuration")]
		public AIConfiguration configuration;

		[Header("Agent Settings")]
		public NavMeshAgent agent;

		public float defaultAgentOffsetY = 1.1f;

		public List<Transform> patrolPoints = new List<Transform>();

		public float patrolWaitTime = 2f;

		public float patrolMoveSpeed = 3f;

		public float chaseSpeed = 5f;

		[Header("Sight (native FOV detection)")]
		public Transform sightOrigin;

		public float sightRadius = 15f;

		[Range(0f, 360f)]
		public float sightAngle = 120f;

		public LayerMask detectionMask = -1;

		public LayerMask obstacleMask;

		[Header("Search Settings")]
		public float trackingDuration = 3f;

		public float searchDuration = 5f;

		public float searchRadius = 10f;

		public int maxSearchPoints = 3;

		[Header("Detection Settings")]
		public float grabDistance = 1f;

		public float releaseDistance = 2f;

		[Header("Debug")]
		[SerializeField]
		private bool showDebugInfo;

		[HideInInspector]
		public bool isGrabbing;

		[HideInInspector]
		public bool isRaging;

		[HideInInspector]
		public bool isStunned;

		[HideInInspector]
		public Transform chasingPlayer;

		[HideInInspector]
		public AIState currentState = AIState.Idle;

		public List<Transform> fakePlayers = new List<Transform>();

		private int currentPatrolIndex;

		private bool isWaitingAtPatrol;

		private float trackingTimer;

		private bool isTracking;

		private float searchTimer;

		private Vector3 lastKnownPlayerPosition;

		private int currentSearchPoint;

		private List<Vector3> searchPoints = new List<Vector3>();

		private Coroutine searchCoroutine;

		private readonly Collider[] _sightHits = new Collider[32];

		private void Start()
		{
			InitializeAI();
		}

		private void Update()
		{
			if (isStunned)
			{
				return;
			}
			UpdateTargetDetection();
			UpdateStateMachine();
			UpdateGrabBehaviour();
			UpdateAgentOffset();
		}

		private void OnValidate()
		{
			if (grabDistance >= releaseDistance)
			{
				releaseDistance = grabDistance + 1f;
			}
		}

		private void InitializeAI()
		{
			if (fakePlayers.Count > 0)
			{
				SetPlayerAsTarget(fakePlayers[Random.Range(0, fakePlayers.Count)]);
			}
			if (agent == null)
			{
				Debug.LogError("[AIBehaviour] NavMeshAgent not assigned on " + gameObject.name);
			}
			if (chasingPlayer == null && patrolPoints.Count > 0)
			{
				ChangeState(AIState.Patrolling);
			}
		}

		private void UpdateStateMachine()
		{
			switch (currentState)
			{
			case AIState.Patrolling:
				UpdatePatrolling();
				break;
			case AIState.Chasing:
				UpdateChasing();
				break;
			case AIState.Searching:
				UpdateSearching();
				break;
			}
		}

		private void ChangeState(AIState newState)
		{
			if (currentState == newState)
			{
				return;
			}
			if (currentState == AIState.Searching && searchCoroutine != null)
			{
				StopCoroutine(searchCoroutine);
				searchCoroutine = null;
			}
			currentState = newState;
			switch (newState)
			{
			case AIState.Patrolling:
				if (agent != null)
				{
					agent.speed = patrolMoveSpeed;
				}
				if (showDebugInfo)
				{
					Debug.Log("[AIBehaviour] Entering Patrol state");
				}
				break;
			case AIState.Chasing:
				if (agent != null)
				{
					agent.speed = chaseSpeed;
				}
				if (showDebugInfo)
				{
					Debug.Log("[AIBehaviour] Entering Chase state");
				}
				break;
			case AIState.Searching:
				searchTimer = 0f;
				isTracking = false;
				trackingTimer = 0f;
				GenerateSearchPoints();
				currentSearchPoint = 0;
				searchCoroutine = StartCoroutine(SearchRoutine());
				if (showDebugInfo)
				{
					Debug.Log("[AIBehaviour] Entering Search state");
				}
				break;
			case AIState.Idle:
				if (agent != null)
				{
					agent.ResetPath();
				}
				if (showDebugInfo)
				{
					Debug.Log("[AIBehaviour] Entering Idle state");
				}
				break;
			}
		}

		private void UpdateTargetDetection()
		{
			Collider collider = DetectNearestTargetInSight();
			if (collider != null)
			{
				if (currentState != AIState.Chasing || collider.transform != chasingPlayer)
				{
					SetPlayerAsTarget(collider.transform);
					ChangeState(AIState.Chasing);
				}
				lastKnownPlayerPosition = collider.transform.position;
				isTracking = false;
				trackingTimer = 0f;
			}
			else if (currentState == AIState.Chasing && !isTracking)
			{
				trackingTimer = 0f;
				isTracking = true;
				if (showDebugInfo)
				{
					Debug.Log(string.Format("[AIBehaviour] Lost sight of player, tracking for {0}s", trackingDuration));
				}
			}
		}

		private Collider DetectNearestTargetInSight()
		{
			Vector3 position = (sightOrigin != null ? sightOrigin : transform).position;
			Vector3 forward = (sightOrigin != null ? sightOrigin : transform).forward;
			int num = Physics.OverlapSphereNonAlloc(position, sightRadius, _sightHits, detectionMask, QueryTriggerInteraction.Collide);
			if (num <= 0)
			{
				return null;
			}
			Collider result = null;
			float num2 = float.MaxValue;
			for (int i = 0; i < num; i++)
			{
				Collider collider = _sightHits[i];
				if (collider == null || collider.transform == transform || collider.transform.IsChildOf(transform))
				{
					continue;
				}
				Vector3 vector = collider.bounds.center - position;
				float magnitude = vector.magnitude;
				if (magnitude < 0.001f || magnitude > sightRadius)
				{
					continue;
				}
				if (Vector3.Angle(forward, vector) > sightAngle * 0.5f)
				{
					continue;
				}
				if (obstacleMask.value != 0 && Physics.Raycast(position, vector / magnitude, out RaycastHit hitInfo, magnitude, obstacleMask, QueryTriggerInteraction.Collide) && hitInfo.collider.transform != collider.transform && !hitInfo.collider.transform.IsChildOf(collider.transform))
				{
					continue;
				}
				if (magnitude < num2)
				{
					result = collider;
					num2 = magnitude;
				}
			}
			return result;
		}

		private void UpdatePatrolling()
		{
			if (patrolPoints.Count == 0)
			{
				ChangeState(AIState.Idle);
			}
			else
			{
				if (isWaitingAtPatrol || agent == null)
				{
					return;
				}
				if (!agent.pathPending && agent.remainingDistance <= agent.stoppingDistance)
				{
					if (!agent.hasPath || agent.velocity.sqrMagnitude == 0f)
					{
						StartCoroutine(WaitAtPatrolPoint());
					}
				}
				else if (!agent.hasPath)
				{
					MoveToPatrolPoint(currentPatrolIndex);
				}
			}
		}

		private void MoveToPatrolPoint(int index)
		{
			if (!(agent == null) && patrolPoints.Count != 0)
			{
				agent.SetDestination(patrolPoints[index].position);
			}
		}

		private IEnumerator WaitAtPatrolPoint()
		{
			isWaitingAtPatrol = true;
			yield return new WaitForSeconds(patrolWaitTime);
			currentPatrolIndex = (currentPatrolIndex + 1) % patrolPoints.Count;
			MoveToPatrolPoint(currentPatrolIndex);
			isWaitingAtPatrol = false;
		}

		private void UpdateChasing()
		{
			if (chasingPlayer == null)
			{
				ChangeState(AIState.Patrolling);
			}
			else if (isTracking)
			{
				trackingTimer += Time.deltaTime;
				if (trackingTimer >= trackingDuration)
				{
					if (showDebugInfo)
					{
						Debug.Log("[AIBehaviour] Tracking expired, starting search");
					}
					ChangeState(AIState.Searching);
				}
				else if (agent != null && agent.isOnNavMesh)
				{
					agent.SetDestination(lastKnownPlayerPosition);
				}
			}
			else if (agent != null && agent.isOnNavMesh)
			{
				agent.SetDestination(chasingPlayer.position);
				lastKnownPlayerPosition = chasingPlayer.position;
			}
		}

		private void UpdateSearching()
		{
			searchTimer += Time.deltaTime;
			if (searchTimer >= searchDuration)
			{
				if (showDebugInfo)
				{
					Debug.Log("[AIBehaviour] Search timeout, returning to patrol");
				}
				chasingPlayer = null;
				ChangeState(AIState.Patrolling);
			}
		}

		private void GenerateSearchPoints()
		{
			searchPoints.Clear();
			for (int i = 0; i < maxSearchPoints; i++)
			{
				Vector2 vector = Random.insideUnitCircle * searchRadius;
				Vector3 sourcePosition = lastKnownPlayerPosition + new Vector3(vector.x, 0f, vector.y);
				if (NavMesh.SamplePosition(sourcePosition, out NavMeshHit hit, searchRadius, -1))
				{
					searchPoints.Add(hit.position);
				}
			}
		}

		private IEnumerator SearchRoutine()
		{
			while (currentSearchPoint < searchPoints.Count)
			{
				if (currentState != AIState.Searching)
				{
					yield break;
				}
				if (agent != null && agent.isOnNavMesh)
				{
					agent.SetDestination(searchPoints[currentSearchPoint]);
					while (agent.pathPending || agent.remainingDistance > agent.stoppingDistance)
					{
						if (currentState != AIState.Searching)
						{
							yield break;
						}
						yield return null;
					}
					yield return new WaitForSeconds(1f);
				}
				currentSearchPoint++;
			}
			if (currentState == AIState.Searching)
			{
				if (showDebugInfo)
				{
					Debug.Log("[AIBehaviour] Finished searching, returning to patrol");
				}
				chasingPlayer = null;
				ChangeState(AIState.Patrolling);
			}
		}

		private void UpdateGrabBehaviour()
		{
			if (chasingPlayer == null)
			{
				return;
			}
			float num = Vector3.Distance(transform.position, chasingPlayer.position);
			if (isGrabbing)
			{
				if (num > releaseDistance)
				{
					isGrabbing = false;
				}
			}
			else if (num < grabDistance)
			{
				isGrabbing = true;
			}
		}

		private void UpdateAgentOffset()
		{
			if (!(agent == null))
			{
				agent.baseOffset = Mathf.MoveTowards(agent.baseOffset, defaultAgentOffsetY, Time.deltaTime * 2f);
			}
		}

		public void SetPlayerAsTarget(Transform playerTransform)
		{
			chasingPlayer = playerTransform;
			if (playerTransform != null)
			{
				lastKnownPlayerPosition = playerTransform.position;
			}
		}

		public void SetLookTarget(Transform target)
		{
		}

		public void Stun(float duration)
		{
			if (!isStunned)
			{
				StartCoroutine(StunCoroutine(duration));
			}
		}

		public void ForcePatrol()
		{
			chasingPlayer = null;
			ChangeState(AIState.Patrolling);
		}

		private IEnumerator StunCoroutine(float duration)
		{
			isStunned = true;
			if (agent != null)
			{
				agent.isStopped = true;
			}
			ChangeState(AIState.Idle);
			yield return new WaitForSeconds(duration);
			isStunned = false;
			if (agent != null)
			{
				agent.isStopped = false;
			}
			ChangeState(chasingPlayer != null ? AIState.Chasing : AIState.Patrolling);
		}
	}
}
