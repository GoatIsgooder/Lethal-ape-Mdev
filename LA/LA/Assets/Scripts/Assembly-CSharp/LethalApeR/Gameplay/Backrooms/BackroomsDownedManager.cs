using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Networking;
using LethalApeR.Rivals.Combat;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class BackroomsDownedManager : MonoBehaviourPunCallbacks
	{
		[SerializeField]
		private BackroomsConfig config;

		private readonly HashSet<int> _downed = new HashSet<int>();

		private readonly HashSet<int> _dead = new HashSet<int>();

		private readonly Dictionary<int, float> _bleedOutAt = new Dictionary<int, float>();

		private readonly List<int> _expireScratch = new List<int>();

		public static BackroomsDownedManager Instance { get; private set; }

		public IReadOnlyCollection<int> DownedActors => _downed;

		public float BleedOutSeconds => config != null ? config.bleedOutSeconds : 30f;

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority => !Connected || PhotonNetwork.IsMasterClient;

		private int LocalActor => Connected ? PhotonNetwork.LocalPlayer.ActorNumber : 1;

		private bool CanRpc => Connected && base.photonView != null && base.photonView.ViewID != 0;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Update()
		{
			if (!IsAuthority || _bleedOutAt.Count == 0)
			{
				return;
			}
			_expireScratch.Clear();
			foreach (KeyValuePair<int, float> item in _bleedOutAt)
			{
				if (Time.time >= item.Value)
				{
					_expireScratch.Add(item.Key);
				}
			}
			for (int i = 0; i < _expireScratch.Count; i++)
			{
				MasterKill(_expireScratch[i]);
			}
		}

		public void MasterResetForNewRound()
		{
			if (IsAuthority)
			{
				_bleedOutAt.Clear();
				if (CanRpc)
				{
					base.photonView.RPC("RPC_ResetDowned", RpcTarget.All);
				}
				else
				{
					RPC_ResetDowned();
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ResetDowned()
		{
			bool num = _downed.Contains(LocalActor) || _dead.Contains(LocalActor);
			_downed.Clear();
			_dead.Clear();
			if (num && Player.Instance != null)
			{
				Player.Instance.disableMovement = false;
			}
			BackroomsEvents.RaiseLocalDownedChanged(downed: false);
		}

		public void MasterDownPlayer(int actor)
		{
			if (!IsAuthority)
			{
				return;
			}
			if (actor == -2)
			{
				actor = LocalActor;
			}
			if (actor >= 1 && !_downed.Contains(actor) && !_dead.Contains(actor))
			{
				_bleedOutAt[actor] = Time.time + BleedOutSeconds;
				if (CanRpc)
				{
					base.photonView.RPC("RPC_SetDowned", RpcTarget.All, actor, true);
				}
				else
				{
					RPC_SetDowned(actor, downed: true);
				}
			}
		}

		private void MasterKill(int actor)
		{
			_bleedOutAt.Remove(actor);
			if (CanRpc)
			{
				base.photonView.RPC("RPC_SetDead", RpcTarget.All, actor);
			}
			else
			{
				RPC_SetDead(actor);
			}
		}

		public void RequestRevive(int downedActor)
		{
			if (Connected)
			{
				base.photonView.RPC("RPC_RequestRevive", RpcTarget.MasterClient, downedActor, LocalActor);
			}
			else
			{
				MasterHandleRevive(downedActor, LocalActor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestRevive(int downedActor, int reviverActor)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				MasterHandleRevive(downedActor, reviverActor);
			}
		}

		private void MasterHandleRevive(int downedActor, int reviverActor)
		{
			if (IsAuthority && _downed.Contains(downedActor) && !_downed.Contains(reviverActor) && !_dead.Contains(reviverActor) && InReviveRange(downedActor, reviverActor))
			{
				_bleedOutAt.Remove(downedActor);
				if (CanRpc)
				{
					base.photonView.RPC("RPC_SetDowned", RpcTarget.All, downedActor, false);
				}
				else
				{
					RPC_SetDowned(downedActor, downed: false);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetDowned(int actor, bool downed)
		{
			if (downed)
			{
				_downed.Add(actor);
			}
			else
			{
				_downed.Remove(actor);
			}
			if (LocalActor == actor && Player.Instance != null)
			{
				Player.Instance.disableMovement = downed;
				BackroomsEvents.RaiseLocalDownedChanged(downed);
			}
			BackroomsEvents.RaisePlayerDownedChanged(actor, downed);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetDead(int actor)
		{
			_downed.Remove(actor);
			_dead.Add(actor);
			if (LocalActor == actor && Player.Instance != null)
			{
				Player.Instance.disableMovement = false;
				BackroomsEvents.RaiseLocalDied();
			}
			BackroomsEvents.RaisePlayerDied(actor);
		}

		public bool IsDowned(int actor)
		{
			return _downed.Contains(actor);
		}

		public bool IsDead(int actor)
		{
			return _dead.Contains(actor);
		}

		public bool IsLocalDownedOrDead()
		{
			if (!_downed.Contains(LocalActor))
			{
				return _dead.Contains(LocalActor);
			}
			return true;
		}

		public int UpCount()
		{
			if (!Connected || PhotonNetwork.CurrentRoom == null)
			{
				if (!IsLocalDownedOrDead())
				{
					return 1;
				}
				return 0;
			}
			int num = 0;
			var playerList = PhotonNetwork.PlayerList;
			foreach (var player in playerList)
			{
				int actorNumber = player.ActorNumber;
				if (!_downed.Contains(actorNumber) && !_dead.Contains(actorNumber))
				{
					num++;
				}
			}
			return num;
		}

		public Transform ResolveAvatarHead(int actor)
		{
			PlayerHealth health = null;
			if (actor == LocalActor && Player.Instance != null && Player.Instance.headCollider != null)
			{
				return Player.Instance.headCollider.transform;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager != null && manager.Players != null)
			{
				for (int i = 0; i < manager.Players.Count; i++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = manager.Players[i];
					if (monkeDevNetworkingPlayer != null && monkeDevNetworkingPlayer.photonView != null && monkeDevNetworkingPlayer.photonView.OwnerActorNr == actor && monkeDevNetworkingPlayer.Head != null)
					{
						return monkeDevNetworkingPlayer.Head;
					}
				}
			}
			if (PlayerHealth.TryGet(actor, out health) && health != null)
			{
				return health.transform;
			}
			return null;
		}

		private bool InReviveRange(int a, int b)
		{
			Transform transform = ResolveAvatarHead(a);
			Transform transform2 = ResolveAvatarHead(b);
			if (transform == null || transform2 == null)
			{
				return true;
			}
			float num = config != null ? config.reviveRange : 1.6f;
			return (transform.position - transform2.position).sqrMagnitude <= num * num;
		}
	}
}
