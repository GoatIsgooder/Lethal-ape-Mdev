using System.Collections;
using LethalApeR.Gameplay.Monsters;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	public class RoamingMonster : FOVMonster
	{
		[Header("Backrooms")]
		[SerializeField]
		private BackroomsConfig config;

		[Tooltip("This monster's roam/patrol points (the Backrooms anchors). Self-managed, independent of MonsterManager.")]
		[SerializeField]
		private Transform[] roamWaypoints = new Transform[0];

		[Header("Animator")]
		[Tooltip("Animator with the locomotion blend tree (driven by AnimationTransition) + a separate Kill state.")]
		[SerializeField]
		private Animator animator;

		[Tooltip("Trigger that fires the one-shot Kill state. Must transition back to locomotion on exit.")]
		[SerializeField]
		private string killTrigger = "Kill";

		private Transform _alertAnchor;

		private Coroutine _alertRoutine;

		private bool _appliedRoam;

		private bool IsAuthority => PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom;

		public override void OnEnable()
		{
			base.OnEnable();
			if (config != null)
			{
				sightRange = config.monsterFovRange;
				sightAngle = config.monsterFovAngle;
			}
			jumpscareTriggerDistance = (config != null) ? config.monsterCatchDistance : 1.8f;
			if (_alertAnchor == null)
			{
				_alertAnchor = new GameObject(base.name + "_AlertAnchor").transform;
				_alertAnchor.SetParent(null);
			}
			if (!_appliedRoam)
			{
				StartCoroutine(ApplyRoamDelayed());
			}
		}

		private IEnumerator ApplyRoamDelayed()
		{
			yield return null;
			yield return null;
			_appliedRoam = true;
			if (roamWaypoints != null && roamWaypoints.Length > 0)
			{
				SetWaypoints(roamWaypoints);
			}
		}

		public void AlertTo(Vector3 position)
		{
			if (!IsAuthority)
			{
				return;
			}
			if (_alertAnchor == null)
			{
				_alertAnchor = new GameObject(base.name + "_AlertAnchor").transform;
				_alertAnchor.SetParent(null);
			}
			_alertAnchor.position = position;
			SetWaypoints(new Transform[1] { _alertAnchor });
			if (_alertRoutine != null)
			{
				StopCoroutine(_alertRoutine);
			}
			_alertRoutine = StartCoroutine(AlertRoutine());
		}

		private IEnumerator AlertRoutine()
		{
			float seconds = 30f;
			if (config != null)
			{
				seconds = Mathf.Max(1f, config.monsterAlertChaseDuration);
			}
			yield return new WaitForSeconds(seconds);
			if (roamWaypoints != null && roamWaypoints.Length > 0)
			{
				SetWaypoints(roamWaypoints);
			}
			_alertRoutine = null;
		}

		public void ForceChase(Transform player, float duration)
		{
			if (!IsAuthority || player == null)
			{
				return;
			}
			if (_alertRoutine != null)
			{
				StopCoroutine(_alertRoutine);
				_alertRoutine = null;
			}
			ForceTarget(player, Mathf.Max(1f, duration));
		}

		protected override bool IsTargetIncapacitated(int actorNumber)
		{
			BackroomsDownedManager instance = BackroomsDownedManager.Instance;
			if (instance == null)
			{
				return false;
			}
			if (actorNumber == -2)
			{
				actorNumber = (PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : 1);
			}
			if (!instance.IsDowned(actorNumber))
			{
				return instance.IsDead(actorNumber);
			}
			return true;
		}

		public float SqrDistanceTo(Vector3 p)
		{
			return (base.transform.position - p).sqrMagnitude;
		}

		protected override void OnJumpscareStarted()
		{
			if (animator != null && !string.IsNullOrEmpty(killTrigger))
			{
				animator.SetTrigger(killTrigger);
			}
		}

		protected override void OnJumpscareEnded()
		{
			if (animator != null && !string.IsNullOrEmpty(killTrigger))
			{
				animator.ResetTrigger(killTrigger);
			}
		}

		protected override bool TeleportVictimOnJumpscare()
		{
			return false;
		}

		protected override void OnJumpscareVictim(int victimActorNumber)
		{
			if (!IsAuthority)
			{
				return;
			}
			BackroomsDownedManager instance = BackroomsDownedManager.Instance;
			if (instance == null)
			{
				return;
			}
			float num = ((config != null) ? config.monsterCatchDistance : 1.8f) + 1.5f;
			Transform transform = instance.ResolveAvatarHead(victimActorNumber);
			if (!(transform != null) || !(Vector3.Distance(base.transform.position, transform.position) > num))
			{
				instance.MasterDownPlayer(victimActorNumber);
			}
		}
	}
}
