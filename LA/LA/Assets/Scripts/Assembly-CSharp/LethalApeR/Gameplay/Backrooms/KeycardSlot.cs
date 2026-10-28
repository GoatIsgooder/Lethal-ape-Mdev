using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	public class KeycardSlot : MonoBehaviour
	{
		[Tooltip("0..keycardCount-1. Set by the editor builder.")]
		public int SlotIndex;

		[Tooltip("Only used when BackroomsConfig.enforceColorMatch is on.")]
		public KeycardColor RequiredColor;

		[Tooltip("Where a placed card snaps to (defaults to this transform).")]
		[SerializeField]
		private Transform snapAnchor;

		[Tooltip("Optional: enabled when this slot is filled (a little 'accepted' light).")]
		[SerializeField]
		private GameObject filledIndicator;

		public Transform SnapAnchor => (snapAnchor != null) ? snapAnchor : transform;

		public bool IsFilled { get; private set; }

		private int LocalActor => (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : 1;

		private void Awake()
		{
			if (filledIndicator != null)
			{
				filledIndicator.SetActive(false);
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (IsFilled)
			{
				return;
			}
			Keycard keycard = other.GetComponentInParent<Keycard>();
			if (!(keycard == null) && keycard.State == KeycardState.Held && keycard.HolderActor == LocalActor)
			{
				KeycardManager.Instance?.LocalTryPlace(keycard, this);
			}
		}

		public void MasterMarkFilled(int cardId)
		{
			SetFilled(true);
		}

		public void LocalMarkFilled(int cardId)
		{
			SetFilled(true);
		}

		public void LocalClear()
		{
			SetFilled(false);
		}

		private void SetFilled(bool filled)
		{
			IsFilled = filled;
			if (filledIndicator != null)
			{
				filledIndicator.SetActive(filled);
			}
		}
	}
}
