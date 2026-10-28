using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgSeekerHandTrigger : MonoBehaviour
	{
		private const float PerVictimCooldown = 1f;

		private const float TriggerRadius = 0.5f;

		private const int KillLayerFallback = 20;

		private static readonly Dictionary<int, float> NextReportAt = new Dictionary<int, float>();

		private bool _isLeftHand;

		public static GameObject Attach(Transform hand, bool isLeft)
		{
			GameObject gameObject = new GameObject("AgSeekerCatchTrigger");
			gameObject.transform.SetParent(hand, false);
			gameObject.transform.localPosition = Vector3.zero;
			gameObject.transform.localRotation = Quaternion.identity;
			int num = LayerMask.NameToLayer("BTMKill");
			gameObject.layer = ((num >= 0) ? num : 20);
			SphereCollider sphereCollider = gameObject.AddComponent<SphereCollider>();
			sphereCollider.isTrigger = true;
			sphereCollider.radius = 0.5f;
			gameObject.AddComponent<AgSeekerHandTrigger>()._isLeftHand = isLeft;
			return gameObject;
		}

		public static void ResetCooldowns()
		{
			NextReportAt.Clear();
		}

		private void OnTriggerEnter(Collider other)
		{
			if (!other.CompareTag("BTMKillTrigger"))
			{
				return;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null || !ApeGamesManager.IsLocalAlive())
			{
				return;
			}
			MonkeDevNetworkingPlayer componentInParent = other.GetComponentInParent<MonkeDevNetworkingPlayer>();
			if (componentInParent == null || componentInParent.photonView == null)
			{
				return;
			}
			int ownerActorNr = componentInParent.photonView.OwnerActorNr;
			if (PhotonNetwork.LocalPlayer == null)
			{
				return;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (ownerActorNr < 1 || actorNumber < 1 || ownerActorNr == actorNumber)
			{
				return;
			}
			AgRoundProperties props = instance.Props;
			if (props != null && props.SeekersContains(actorNumber) && props.AliveContains(ownerActorNr) && !props.SeekersContains(ownerActorNr) && !props.EscapedContains(ownerActorNr) && (!NextReportAt.TryGetValue(ownerActorNr, out var value) || !(Time.time < value)))
			{
				NextReportAt[ownerActorNr] = Time.time + 1f;
				if (_isLeftHand)
				{
					AgHaptics.Left(0.85f, 0.16f);
				}
				else
				{
					AgHaptics.Right(0.85f, 0.16f);
				}
				instance.ReportSeekerCatch(ownerActorNr);
			}
		}
	}
}
