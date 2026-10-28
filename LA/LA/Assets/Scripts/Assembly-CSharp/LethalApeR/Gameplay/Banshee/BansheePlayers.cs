using System.Collections.Generic;
using LALocomotion;
using LethalApeR.Gameplay.Pumpkin;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	public static class BansheePlayers
	{
		private static readonly List<PumpkinAvatar> Remote = new List<PumpkinAvatar>(32);

		public static IBansheePlayerSource Override { get; set; }

		public static int LocalActor
		{
			get
			{
				if (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null)
				{
					return PhotonNetwork.LocalPlayer.ActorNumber;
				}
				return 1;
			}
		}

		public static void Collect(List<BansheeAvatar> into)
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
					into.Add(new BansheeAvatar
					{
						actor = pumpkinAvatar.actor,
						head = pumpkinAvatar.head.position,
						leftHand = ((pumpkinAvatar.leftHand != null) ? pumpkinAvatar.leftHand : pumpkinAvatar.head).position,
						rightHand = ((pumpkinAvatar.rightHand != null) ? pumpkinAvatar.rightHand : pumpkinAvatar.head).position,
						isLocal = false
					});
				}
			}
			Remote.Clear();
		}

		public static bool TryGetLocal(out BansheeAvatar avatar)
		{
			avatar = default(BansheeAvatar);
			if (!TryGetLocalHead(out var head))
			{
				return false;
			}
			avatar.actor = LocalActor;
			avatar.head = head;
			avatar.leftHand = LocalHand(left: true, head);
			avatar.rightHand = LocalHand(left: false, head);
			avatar.isLocal = true;
			return true;
		}

		public static bool TryGetLocalHead(out Vector3 head)
		{
			LAPlayer instance = LAPlayer.Instance;
			if (instance != null && instance.isActiveAndEnabled && instance.headCollider != null)
			{
				head = instance.HeadPosition;
				return true;
			}
			if (GorillaLocomotion.Player.HasInstance && GorillaLocomotion.Player.Instance.headCollider != null)
			{
				head = GorillaLocomotion.Player.Instance.headCollider.transform.position;
				return true;
			}
			head = default(Vector3);
			return false;
		}

		public static Transform LocalEyes()
		{
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (instance.mainCamera != null)
				{
					return instance.mainCamera.transform;
				}
			}
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform;
			}
			return null;
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
	}
}
