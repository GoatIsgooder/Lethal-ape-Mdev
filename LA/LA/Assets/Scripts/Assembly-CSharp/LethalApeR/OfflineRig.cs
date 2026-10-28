using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR
{
	public class OfflineRig : MonoBehaviourPunCallbacks
	{
		public GameObject target;

		private void Start()
		{
			Sync();
		}

		public override void OnJoinedRoom()
		{
			Sync();
		}

		public override void OnLeftRoom()
		{
			Sync();
		}

		public override void OnDisconnected(DisconnectCause cause)
		{
			Sync();
		}

		private void Sync()
		{
			bool flag = !PhotonNetwork.IsConnected || !PhotonNetwork.InRoom;
			if (target.activeSelf != flag)
			{
				target.SetActive(flag);
			}
		}
	}
}
