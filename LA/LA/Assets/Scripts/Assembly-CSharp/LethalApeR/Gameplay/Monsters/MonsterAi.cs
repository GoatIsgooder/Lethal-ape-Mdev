using System.Collections.Generic;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.AI;

namespace LethalApeR.Gameplay.Monsters
{
	public class MonsterAi : MonoBehaviourPun
	{
		[SerializeField]
		private NavMeshAgent agent;

		[Space]
		[Header("Detection")]
		[SerializeField]
		private float detectionRange = 10f;

		[SerializeField]
		private float fovAngle = 120f;

		[Tooltip("Eye used for the sight cone and raycast; falls back to this transform.")]
		[SerializeField]
		private Transform headPoint;

		[Tooltip("Seconds the monster keeps heading for a target after losing sight of it.")]
		[SerializeField]
		private float predictionTime = 0.5f;

		[Space]
		[Header("Speed Settings")]
		[SerializeField]
		private float patrolSpeed = 2f;

		[SerializeField]
		private float chaseSpeed = 4f;

		[Space]
		[Header("Patrol Settings")]
		[SerializeField]
		private GameObject patrolPointParent;

		[SerializeField]
		private float nextPointDistance = 1.5f;

		private Vector3[] waypoints = new Vector3[0];

		private float lostSightAt;

		public int currentPatrolIndex { get; private set; }

		public Transform currentTarget { get; private set; }

		public Transform lastTarget { get; private set; }

		private Vector3 EyePosition => ((headPoint != null) ? headPoint : base.transform).position;

		private Vector3 EyeForward => ((headPoint != null) ? headPoint : base.transform).forward;

		private void Start()
		{
			if (agent == null)
			{
				agent = GetComponent<NavMeshAgent>();
			}
			if (patrolPointParent != null)
			{
				waypoints = ChildPositions(patrolPointParent.transform);
			}
			currentPatrolIndex = ((waypoints.Length != 0) ? Random.Range(0, waypoints.Length) : 0);
		}

		private void Update()
		{
			agent.enabled = base.photonView.IsMine;
			if (!base.photonView || !base.photonView.IsMine || agent == null)
			{
				return;
			}
			List<MonkeDevNetworkingPlayer> players = MonkeDevNetworkingManager.Manager?.Players;
			if (players == null)
			{
				return;
			}
			Transform head = ClosestVisibleHead(players);
			if (head != null)
			{
				currentTarget = head;
				ChaseTowards(head.position);
				lastTarget = head;
				lostSightAt = Time.time;
			}
			else if (Time.time - lostSightAt <= predictionTime && lastTarget != null)
			{
				ChaseTowards(lastTarget.position);
			}
			else if (!agent.pathPending)
			{
				if (!agent.hasPath)
				{
					ResumePatrol();
				}
				else if (agent.remainingDistance <= nextPointDistance)
				{
					MoveToNextWaypoint();
				}
			}
		}

		private Transform ClosestVisibleHead(List<MonkeDevNetworkingPlayer> players)
		{
			Vector3 position = base.transform.position;
			Transform result = null;
			float closest = float.MaxValue;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer player = players[i];
				if (player == null)
				{
					continue;
				}
				Transform head = player.Head;
				if (!(head == null) && CanSee(head))
				{
					float sqr = (head.position - position).sqrMagnitude;
					if (sqr < closest)
					{
						closest = sqr;
						result = head;
					}
				}
			}
			return result;
		}

		private bool CanSee(Transform target)
		{
			Vector3 eye = EyePosition;
			Vector3 toTarget = target.position - eye;
			if (toTarget.magnitude > detectionRange)
			{
				return false;
			}
			Vector3 direction = toTarget.normalized;
			if (Vector3.Angle(EyeForward, direction) > fovAngle * 0.5f)
			{
				return false;
			}
			if (Physics.Raycast(eye, direction, out RaycastHit hit, detectionRange))
			{
				return hit.transform == target;
			}
			return false;
		}

		private void ChaseTowards(Vector3 position)
		{
			agent.SetDestination(position);
			agent.speed = chaseSpeed;
		}

		private void MoveToNextWaypoint()
		{
			agent.speed = patrolSpeed;
			if (waypoints.Length == 0)
			{
				agent.ResetPath();
				return;
			}
			currentPatrolIndex = ((currentPatrolIndex + 1 < waypoints.Length) ? (currentPatrolIndex + 1) : 0);
			agent.SetDestination(waypoints[currentPatrolIndex]);
		}

		private void ResumePatrol()
		{
			currentTarget = null;
			lastTarget = null;
			agent.ResetPath();
			agent.speed = patrolSpeed;
			if (waypoints.Length != 0 && agent.remainingDistance == 0f)
			{
				agent.SetDestination(waypoints[currentPatrolIndex]);
			}
		}

		private static Vector3[] ChildPositions(Transform root)
		{
			Vector3[] positions = new Vector3[root.childCount];
			for (int i = 0; i < positions.Length; i++)
			{
				positions[i] = root.GetChild(i).position;
			}
			return positions;
		}

		private void OnDrawGizmos()
		{
			Vector3 eye = EyePosition;
			Vector3 forward = EyeForward * detectionRange;
			float halfFov = fovAngle * 0.5f;
			Gizmos.color = Color.red;
			Gizmos.DrawWireSphere(eye, detectionRange);
			Gizmos.color = Color.yellow;
			Gizmos.DrawLine(eye, eye + Quaternion.AngleAxis(0f - halfFov, Vector3.up) * forward);
			Gizmos.DrawLine(eye, eye + Quaternion.AngleAxis(halfFov, Vector3.up) * forward);
			Gizmos.color = Color.blue;
			Gizmos.DrawLine(eye, eye + forward);
		}
	}
}
