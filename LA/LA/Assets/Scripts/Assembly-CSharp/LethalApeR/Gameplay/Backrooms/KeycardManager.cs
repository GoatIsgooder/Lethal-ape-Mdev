using System.Collections.Generic;
using System.Reflection;
using Locomotion.Scripts;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class KeycardManager : MonoBehaviourPunCallbacks
	{
		[Header("Config")]
		[SerializeField]
		private BackroomsConfig config;

		[Header("Scene refs (assign / let the builder fill)")]
		[Tooltip("Candidate vent anchor points. The host picks keycardCount of these each round.")]
		[SerializeField]
		private Transform[] ventAnchors = new Transform[0];

		[Tooltip("The pooled keycard objects (pre-placed, disabled). Length should be >= keycardCount.")]
		[SerializeField]
		private Keycard[] keycards = new Keycard[0];

		[Tooltip("The door slots (one per keycard).")]
		[SerializeField]
		private KeycardSlot[] slots = new KeycardSlot[0];

		private int[] _cardVent;

		private int _placed;

		private static GrabInteractor[] _grabInteractors;

		public static KeycardManager Instance { get; private set; }

		public int PlacedCount => _placed;

		public int Required => (config != null) ? Mathf.Max(1, config.keycardCount) : 3;

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority => !Connected || PhotonNetwork.IsMasterClient;

		private int LocalActor => (Connected && PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : 1;

		private bool CanRpc => Connected && photonView != null && photonView.ViewID != 0;

		public static GrabInteractor[] GrabInteractors
		{
			get
			{
				if (_grabInteractors == null || _grabInteractors.Length == 0)
				{
					_grabInteractors = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
				}
				return _grabInteractors;
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
			_cardVent = new int[(keycards != null) ? keycards.Length : 0];
			for (int i = 0; i < keycards.Length; i++)
			{
				if (keycards[i] != null)
				{
					keycards[i].cardId = i;
				}
			}
		}

		private void Start()
		{
			for (int i = 0; i < keycards.Length; i++)
			{
				if (keycards[i] != null)
				{
					keycards[i].gameObject.SetActive(false);
				}
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
				if (CanRpc)
				{
					photonView.RPC("RPC_ResetAll", RpcTarget.All);
				}
				else
				{
					RPC_ResetAll();
				}
			}
		}

		public void MasterSpawnKeycards()
		{
			if (!IsAuthority)
			{
				return;
			}
			int num = Mathf.Min(Required, keycards.Length, ventAnchors.Length);
			if (num <= 0)
			{
				Debug.LogWarning("[Backrooms] KeycardManager has no cards/vents wired.");
				return;
			}
			List<int> list = new List<int>(ventAnchors.Length);
			for (int i = 0; i < ventAnchors.Length; i++)
			{
				if (ventAnchors[i] != null)
				{
					list.Add(i);
				}
			}
			int[] array = new int[num];
			for (int j = 0; j < num; j++)
			{
				int index = Random.Range(0, list.Count);
				array[j] = list[index];
				list.RemoveAt(index);
			}
			int[] array2 = new int[num];
			for (int k = 0; k < num; k++)
			{
				array2[k] = k;
			}
			if (CanRpc)
			{
				photonView.RPC("RPC_SpawnCards", RpcTarget.AllBuffered, array2, array);
			}
			else
			{
				RPC_SpawnCards(array2, array);
			}
		}

		public void LocalRequestPickup(Keycard card)
		{
			if (!(card == null))
			{
				if (Connected)
				{
					photonView.RPC("RPC_RequestPickup", RpcTarget.MasterClient, card.cardId, LocalActor);
				}
				else
				{
					MasterHandlePickup(card.cardId, LocalActor);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestPickup(int cardId, int actor)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				MasterHandlePickup(cardId, actor);
			}
		}

		private void MasterHandlePickup(int cardId, int actor)
		{
			if (!IsAuthority || !ValidCard(cardId))
			{
				return;
			}
			Keycard keycard = keycards[cardId];
			if (keycard.State == KeycardState.InVent)
			{
				if (Connected && keycard.photonView != null)
				{
					keycard.photonView.TransferOwnership(actor);
				}
				BroadcastCardState(cardId, KeycardState.Held, actor, -1);
			}
			else
			{
				BroadcastCardState(cardId, keycard.State, keycard.HolderActor, -1);
			}
		}

		public void LocalTryPlace(Keycard card, KeycardSlot slot)
		{
			if (!(card == null) && !(slot == null))
			{
				if (Connected)
				{
					photonView.RPC("RPC_RequestPlace", RpcTarget.MasterClient, card.cardId, slot.SlotIndex, LocalActor);
				}
				else
				{
					MasterHandlePlace(card.cardId, slot.SlotIndex, LocalActor);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestPlace(int cardId, int slotIndex, int actor)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				MasterHandlePlace(cardId, slotIndex, actor);
			}
		}

		private void MasterHandlePlace(int cardId, int slotIndex, int actor)
		{
			if (!IsAuthority || !ValidCard(cardId) || slotIndex < 0 || slotIndex >= slots.Length)
			{
				return;
			}
			Keycard keycard = keycards[cardId];
			KeycardSlot keycardSlot = slots[slotIndex];
			if (keycard == null || keycardSlot == null || keycard.State != KeycardState.Held || keycardSlot.IsFilled || (config != null && config.enforceColorMatch && keycardSlot.RequiredColor != keycard.color))
			{
				return;
			}
			keycardSlot.MasterMarkFilled(cardId);
			if (Connected && keycard.photonView != null)
			{
				keycard.photonView.TransferOwnership(PhotonNetwork.MasterClient.ActorNumber);
			}
			BroadcastCardState(cardId, KeycardState.Placed, -1, slotIndex);
			RecountPlaced();
		}

		private void RecountPlaced()
		{
			int num = 0;
			for (int i = 0; i < slots.Length; i++)
			{
				if (slots[i] != null && slots[i].IsFilled)
				{
					num++;
				}
			}
			_placed = num;
			BackroomsGamemodeManager.Instance?.MasterNotifyPlaced(_placed, Required);
		}

		private void BroadcastCardState(int cardId, KeycardState state, int holder, int slotIndex)
		{
			if (CanRpc)
			{
				photonView.RPC("RPC_SetCardState", RpcTarget.AllBuffered, cardId, (int)state, holder, slotIndex);
			}
			else
			{
				RPC_SetCardState(cardId, (int)state, holder, slotIndex);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SpawnCards(int[] cardIds, int[] ventIndices)
		{
			if (_cardVent == null || _cardVent.Length < keycards.Length)
			{
				_cardVent = new int[keycards.Length];
			}
			for (int i = 0; i < keycards.Length; i++)
			{
				if (keycards[i] != null)
				{
					keycards[i].ConfigureFor(KeycardState.Pooled, -1, Vector3.zero, Quaternion.identity, null);
				}
			}
			for (int j = 0; j < cardIds.Length && j < ventIndices.Length; j++)
			{
				int num = cardIds[j];
				int num2 = ventIndices[j];
				if (ValidCard(num) && num2 >= 0 && num2 < ventAnchors.Length && !(ventAnchors[num2] == null))
				{
					_cardVent[num] = num2;
					keycards[num].ConfigureFor(KeycardState.InVent, -1, ventAnchors[num2].position, ventAnchors[num2].rotation, null);
				}
			}
			_placed = 0;
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetCardState(int cardId, int stateInt, int holder, int slotIndex)
		{
			if (!ValidCard(cardId))
			{
				return;
			}
			Vector3 pos = keycards[cardId].transform.position;
			Quaternion rot = keycards[cardId].transform.rotation;
			Transform placedParent = null;
			if (stateInt == 3)
			{
				if (slotIndex >= 0 && slotIndex < slots.Length && slots[slotIndex] != null)
				{
					Transform snapAnchor = slots[slotIndex].SnapAnchor;
					if (snapAnchor != null)
					{
						pos = snapAnchor.position;
						rot = snapAnchor.rotation;
						placedParent = snapAnchor;
					}
					if (!slots[slotIndex].IsFilled)
					{
						slots[slotIndex].LocalMarkFilled(cardId);
					}
				}
			}
			else if (stateInt == 1 && _cardVent != null && cardId < _cardVent.Length)
			{
				Transform vent = ventAnchors[_cardVent[cardId]];
				if (vent != null)
				{
					pos = vent.position;
					rot = vent.rotation;
				}
			}
			keycards[cardId].ConfigureFor((KeycardState)stateInt, holder, pos, rot, placedParent);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ResetAll()
		{
			for (int i = 0; i < keycards.Length; i++)
			{
				if (keycards[i] != null)
				{
					keycards[i].ConfigureFor(KeycardState.Pooled, -1, Vector3.zero, Quaternion.identity, null);
				}
			}
			for (int j = 0; j < slots.Length; j++)
			{
				if (slots[j] != null)
				{
					slots[j].LocalClear();
				}
			}
			_placed = 0;
		}

		private bool ValidCard(int id)
		{
			if (id >= 0 && keycards != null && id < keycards.Length)
			{
				return keycards[id] != null;
			}
			return false;
		}
	}
}
