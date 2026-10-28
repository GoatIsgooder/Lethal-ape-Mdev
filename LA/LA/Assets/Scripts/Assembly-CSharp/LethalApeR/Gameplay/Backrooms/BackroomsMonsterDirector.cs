using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class BackroomsMonsterDirector : MonoBehaviourPunCallbacks
	{
		[SerializeField]
		private BackroomsConfig config;

		private readonly Dictionary<int, float> _lastScream = new Dictionary<int, float>();

		private RoamingMonster[] _monsters;

		public static BackroomsMonsterDirector Instance { get; private set; }

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority => !Connected || PhotonNetwork.IsMasterClient;

		private bool CanRpc => Connected && base.photonView != null && base.photonView.ViewID != 0;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void MasterResetForNewRound()
		{
			if (IsAuthority)
			{
				_lastScream.Clear();
			}
		}

		public void LocalReportWatcherScream(int watcherIndex, Vector3 pos, int screamerActor)
		{
			if (Connected)
			{
				base.photonView.RPC("RPC_RequestScream", RpcTarget.MasterClient, watcherIndex, pos, screamerActor);
			}
			else
			{
				MasterHandleScream(watcherIndex, pos, screamerActor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestScream(int watcherIndex, Vector3 pos, int screamerActor)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				MasterHandleScream(watcherIndex, pos, screamerActor);
			}
		}

		private void MasterHandleScream(int watcherIndex, Vector3 pos, int screamerActor)
		{
			if (!IsAuthority)
			{
				return;
			}
			float num = ((config != null) ? config.watcherScreamCooldown : 12f);
			if (_lastScream.TryGetValue(watcherIndex, out var value) && Time.time - value < num)
			{
				return;
			}
			_lastScream[watcherIndex] = Time.time;
			if (CanRpc)
			{
				base.photonView.RPC("RPC_WatcherScreamed", RpcTarget.All, watcherIndex, pos);
			}
			else
			{
				BackroomsEvents.RaiseWatcherScream(watcherIndex, pos);
			}
			DispatchNearest(pos, screamerActor);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_WatcherScreamed(int watcherIndex, Vector3 pos)
		{
			BackroomsEvents.RaiseWatcherScream(watcherIndex, pos);
		}

		private void DispatchNearest(Vector3 pos, int screamerActor)
		{
			_monsters = Object.FindObjectsByType<RoamingMonster>(FindObjectsSortMode.None);
			if (_monsters == null || _monsters.Length == 0)
			{
				return;
			}
			RoamingMonster roamingMonster = null;
			float num = float.PositiveInfinity;
			for (int i = 0; i < _monsters.Length; i++)
			{
				RoamingMonster roamingMonster2 = _monsters[i];
				if (!(roamingMonster2 == null))
				{
					float num2 = roamingMonster2.SqrDistanceTo(pos);
					if (num2 < num)
					{
						num = num2;
						roamingMonster = roamingMonster2;
					}
				}
			}
			if (!(roamingMonster == null))
			{
				Transform transform = ((BackroomsDownedManager.Instance != null) ? BackroomsDownedManager.Instance.ResolveAvatarHead(screamerActor) : null);
				float duration = ((config != null) ? config.monsterAlertChaseDuration : 30f);
				if (transform != null)
				{
					roamingMonster.ForceChase(transform, duration);
				}
				else
				{
					roamingMonster.AlertTo(pos);
				}
			}
		}
	}
}
