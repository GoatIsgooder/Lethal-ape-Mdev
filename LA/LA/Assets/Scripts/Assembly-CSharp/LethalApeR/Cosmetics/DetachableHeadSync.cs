using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Cosmetics
{
	public sealed class DetachableHeadSync : MonoBehaviourPunCallbacks
	{
		private const float MinSendInterval = 0.1f;

		private const float MaxHeldOffset = 1.5f;

		private MonkeDevNetworkingPlayer _player;

		private DetachableHead _head;

		private bool _dirty;

		private float _nextSendTime;

		public bool Held { get; private set; }

		public bool LeftHand { get; private set; }

		public Vector3 HeldPosition { get; private set; }

		public Quaternion HeldRotation { get; private set; } = Quaternion.identity;

		internal bool IsLocalOwner => base.photonView != null && base.photonView.IsMine;

		internal Transform Head => (_player != null) ? _player.Head : null;

		private void Awake()
		{
			_player = GetComponent<MonkeDevNetworkingPlayer>();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			Held = false;
			_dirty = false;
		}

		internal void Register(DetachableHead head)
		{
			_head = head;
		}

		internal void Unregister(DetachableHead head)
		{
			if (_head == head)
			{
				_head = null;
			}
		}

		internal void PublishHeld(bool left, Vector3 position, Quaternion rotation)
		{
			Held = true;
			LeftHand = left;
			HeldPosition = position;
			HeldRotation = rotation;
			_dirty = true;
		}

		internal void PublishReleased()
		{
			Held = false;
			_dirty = true;
		}

		internal void Flush(bool force = false)
		{
			if (!_dirty || !CanSend())
			{
				return;
			}
			if (!force && Time.unscaledTime < _nextSendTime)
			{
				return;
			}
			_dirty = false;
			_nextSendTime = Time.unscaledTime + MinSendInterval;
			if (Held)
			{
				base.photonView.RPC("RPC_DetachableHeadHeld", RpcTarget.Others, LeftHand, HeldPosition, HeldRotation);
			}
			else
			{
				base.photonView.RPC("RPC_DetachableHeadReleased", RpcTarget.Others);
			}
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			if (Held && CanSend())
			{
				base.photonView.RPC("RPC_DetachableHeadHeld", newPlayer, LeftHand, HeldPosition, HeldRotation);
			}
		}

		private bool CanSend()
		{
			if (base.isActiveAndEnabled && PhotonNetwork.InRoom && base.photonView != null && base.photonView.IsMine)
			{
				return base.photonView.ViewID != 0;
			}
			return false;
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_DetachableHeadHeld(bool left, Vector3 position, Quaternion rotation, PhotonMessageInfo info)
		{
			if (FromOwner(info))
			{
				ReceiveHeld(left, position, rotation);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_DetachableHeadReleased(PhotonMessageInfo info)
		{
			if (FromOwner(info))
			{
				ReceiveReleased();
			}
		}

		private bool FromOwner(PhotonMessageInfo info)
		{
			if (base.photonView == null || base.photonView.IsMine)
			{
				return false;
			}
			if (info.Sender != null)
			{
				return info.Sender.ActorNumber == base.photonView.OwnerActorNr;
			}
			return false;
		}

		private void ReceiveHeld(bool left, Vector3 position, Quaternion rotation)
		{
			if (!IsFinite(position) || position.sqrMagnitude > MaxHeldOffset * MaxHeldOffset)
			{
				return;
			}
			float magnitude = Mathf.Sqrt(Quaternion.Dot(rotation, rotation));
			if (magnitude > 0.5f && magnitude < 2f)
			{
				Held = true;
				LeftHand = left;
				HeldPosition = position;
				HeldRotation = new Quaternion(rotation.x / magnitude, rotation.y / magnitude, rotation.z / magnitude, rotation.w / magnitude);
				if (_head != null)
				{
					_head.ApplyRemoteState();
				}
			}
		}

		private void ReceiveReleased()
		{
			Held = false;
			if (_head != null)
			{
				_head.ApplyRemoteState();
			}
		}

		private static bool IsFinite(Vector3 v)
		{
			if (!float.IsNaN(v.x) && !float.IsInfinity(v.x) && !float.IsNaN(v.y) && !float.IsInfinity(v.y) && !float.IsNaN(v.z))
			{
				return !float.IsInfinity(v.z);
			}
			return false;
		}
	}
}
