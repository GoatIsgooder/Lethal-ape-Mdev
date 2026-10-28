using System.Collections.Generic;
using LethalApeR.Gameplay.Pumpkin;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public static class RiftPlayers
	{
		private static readonly List<PumpkinAvatar> Remote = new List<PumpkinAvatar>(32);

		public static IRiftPlayerSource Override { get; set; }

		public static int LocalActor
		{
			get
			{
				if (Photon.Pun.PhotonNetwork.InRoom && Photon.Pun.PhotonNetwork.LocalPlayer != null)
				{
					return Photon.Pun.PhotonNetwork.LocalPlayer.ActorNumber;
				}
				return 1;
			}
		}

		public static void Collect(List<RiftAvatar> into)
		{
			into.Clear();
			if (Override != null)
			{
				Override.Collect(into);
				return;
			}
			if (TryGetLocal(out var avatar))
			{
				into.Add(avatar);
			}
			PumpkinRig.Avatars.Collect(Remote);
			for (int i = 0; i < Remote.Count; i++)
			{
				PumpkinAvatar pumpkinAvatar = Remote[i];
				if (!(pumpkinAvatar.head == null))
				{
					Vector3 position = pumpkinAvatar.head.position;
					Vector3 position2 = ((pumpkinAvatar.leftHand != null) ? pumpkinAvatar.leftHand : pumpkinAvatar.head).position;
					Vector3 position3 = ((pumpkinAvatar.rightHand != null) ? pumpkinAvatar.rightHand : pumpkinAvatar.head).position;
					into.Add(new RiftAvatar
					{
						actor = pumpkinAvatar.actor,
						head = position,
						leftHand = position2,
						rightHand = position3,
						isLocal = false
					});
				}
			}
			Remote.Clear();
		}

		public static bool TryGetLocal(out RiftAvatar avatar)
		{
			avatar = default(RiftAvatar);
			LALocomotion.LAPlayer instance = LALocomotion.LAPlayer.Instance;
			Vector3 vector;
			if (instance != null && instance.isActiveAndEnabled && instance.headCollider != null)
			{
				vector = instance.HeadPosition;
			}
			else
			{
				if (!GorillaLocomotion.Player.HasInstance || !(GorillaLocomotion.Player.Instance.headCollider != null))
				{
					return false;
				}
				vector = GorillaLocomotion.Player.Instance.headCollider.transform.position;
			}
			avatar.actor = LocalActor;
			avatar.head = vector;
			avatar.leftHand = LocalHand(left: true, vector);
			avatar.rightHand = LocalHand(left: false, vector);
			avatar.isLocal = true;
			return true;
		}

		private static Vector3 LocalHand(bool left, Vector3 fallback)
		{
			Transform transform = PumpkinRig.SyncedHand(left);
			if (transform != null)
			{
				return transform.position;
			}
			if (GorillaLocomotion.Player.HasInstance)
			{
				Transform transform2 = (left ? GorillaLocomotion.Player.Instance.leftHandFollower : GorillaLocomotion.Player.Instance.rightHandFollower);
				if (transform2 != null)
				{
					return transform2.position;
				}
			}
			return fallback;
		}

		public static void Body(Vector3 head, out Vector3 top, out Vector3 bottom, out float radius)
		{
			top = head + Vector3.down * PumpkinRig.AvatarTorsoTop;
			bottom = head + Vector3.down * PumpkinRig.AvatarTorsoBottom;
			radius = PumpkinRig.AvatarTorsoRadius;
		}
	}
}
