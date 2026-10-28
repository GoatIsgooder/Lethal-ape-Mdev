using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(PhotonView))]
	public class ScrapManager : MonoBehaviourPunCallbacks
	{
		[Header("Lobby layout")]
		[Tooltip("Fraction of ALL scrap pieces that spawn in each lobby (the rest stay hidden for the whole match) — exactly like the landmine spawner. Each lobby rolls its own random subset. Set to 1 if you want EVERY piece to always spawn.")]
		[Range(0f, 1f)]
		public float activeFraction = 0.7f;

		[Header("Refs")]
		[Tooltip("Where the '+$N' payout overlay appears (the grinder mouth / board). Defaults to this transform.")]
		[SerializeField]
		private Transform payoutAnchor;

		private const string RoomPropSeed = "SCRAP_Seed";

		private const string RoomPropLayout = "SCRAP_Layout";

		private const string RoomPropConsumed = "SCRAP_Consumed";

		private ScrapSpawnPoint[] _points;

		private ScrapPickup[] _pickups;

		private readonly List<ScrapPickup> _looseScan = new List<ScrapPickup>();

		private byte[] _consumedMask;

		private int _lobbySeed;

		private bool _layoutApplied;

		private bool _appliedOffline;

		public static ScrapManager Instance { get; private set; }

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority
		{
			get
			{
				if (Connected)
				{
					return PhotonNetwork.IsMasterClient;
				}
				return true;
			}
		}

		private int LocalActor
		{
			get
			{
				if (Connected)
				{
					return PhotonNetwork.LocalPlayer.ActorNumber;
				}
				return 1;
			}
		}

		private bool CanRpc
		{
			get
			{
				if (Connected && base.photonView != null)
				{
					return base.photonView.ViewID != 0;
				}
				return false;
			}
		}

		public Vector3 PayoutPos
		{
			get
			{
				if (payoutAnchor != null)
				{
					return payoutAnchor.position;
				}
				return base.transform.position;
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
			if (payoutAnchor == null)
			{
				payoutAnchor = base.transform;
			}
			_points = GetComponentsInChildren<ScrapSpawnPoint>(true);
			List<ScrapPickup> list = new List<ScrapPickup>();
			HashSet<ScrapPickup> hashSet = new HashSet<ScrapPickup>();
			for (int i = 0; i < _points.Length; i++)
			{
				if (_points[i] == null)
				{
					continue;
				}
				_points[i].SetIndex(i);
				ScrapPickup[] pickups = _points[i].Pickups;
				foreach (ScrapPickup scrapPickup in pickups)
				{
					if (scrapPickup != null && hashSet.Add(scrapPickup))
					{
						list.Add(scrapPickup);
					}
				}
			}
			GameObject[] rootGameObjects = base.gameObject.scene.GetRootGameObjects();
			foreach (GameObject root in rootGameObjects)
			{
				root.transform.GetComponentsInChildren(true, _looseScan);
				for (int k = 0; k < _looseScan.Count; k++)
				{
					ScrapPickup scrapPickup2 = _looseScan[k];
					if (scrapPickup2 != null && hashSet.Add(scrapPickup2))
					{
						list.Add(scrapPickup2);
					}
				}
			}
			_pickups = list.ToArray();
			_consumedMask = new byte[ConsumedByteLength()];
			Debug.Log($"[ScrapManager] Found {_pickups.Length} scrap piece(s); rolling ~{activeFraction:P0} " + "active each lobby (set activeFraction = 1 for all).");
		}

		private void Start()
		{
			for (int i = 0; i < _pickups.Length; i++)
			{
				if (_pickups[i] != null)
				{
					_pickups[i].gameObject.SetActive(false);
				}
			}
			TryApplyLayout();
		}

		public override void OnJoinedRoom()
		{
			if (_appliedOffline)
			{
				_layoutApplied = false;
				_appliedOffline = false;
				_consumedMask = new byte[ConsumedByteLength()];
			}
			TryApplyLayout();
		}

		public override void OnRoomPropertiesUpdate(Hashtable propsThatChanged)
		{
			if (propsThatChanged != null)
			{
				if (!_layoutApplied && propsThatChanged.ContainsKey(RoomPropLayout))
				{
					TryApplyLayout();
				}
				if (_layoutApplied && propsThatChanged.TryGetValue(RoomPropConsumed, out object value) && value is byte[] bytes)
				{
					ApplyConsumedMask(bytes);
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

		private void TryApplyLayout()
		{
			if (_layoutApplied)
			{
				return;
			}
			if (_pickups == null || _pickups.Length == 0)
			{
				_layoutApplied = true;
				return;
			}
			if (!PhotonNetwork.InRoom)
			{
				int seed = LocalSeed();
				ApplyLayout(seed, GenerateLayoutMask());
				_layoutApplied = true;
				_appliedOffline = true;
				return;
			}
			Hashtable customProperties = PhotonNetwork.CurrentRoom.CustomProperties;
			if (customProperties.TryGetValue(RoomPropLayout, out object value) && value is byte[] layout && layout.Length >= LayoutByteLength())
			{
				int seed2 = ((customProperties.TryGetValue(RoomPropSeed, out object value2) && value2 is int num) ? num : 0);
				ApplyLayout(seed2, layout);
				if (customProperties.TryGetValue(RoomPropConsumed, out object value3) && value3 is byte[] bytes)
				{
					ApplyConsumedMask(bytes);
				}
				_layoutApplied = true;
			}
			else if (PhotonNetwork.IsMasterClient)
			{
				int seed3 = LocalSeed();
				byte[] mask = GenerateLayoutMask();
				PhotonNetwork.CurrentRoom.SetCustomProperties(new Hashtable
				{
					{ RoomPropSeed, seed3 },
					{ RoomPropLayout, mask }
				});
				ApplyLayout(seed3, mask);
				_layoutApplied = true;
			}
		}

		private int LocalSeed()
		{
			return Random.Range(1, int.MaxValue);
		}

		private int LayoutByteLength()
		{
			if (_pickups == null)
			{
				return 0;
			}
			return (_pickups.Length + 7) / 8;
		}

		private int ConsumedByteLength()
		{
			if (_pickups == null)
			{
				return 0;
			}
			return (_pickups.Length + 7) / 8;
		}

		private byte[] GenerateLayoutMask()
		{
			byte[] array = new byte[LayoutByteLength()];
			int num = 0;
			for (int i = 0; i < _pickups.Length; i++)
			{
				if (!(_pickups[i] == null) && Random.value < activeFraction)
				{
					array[i / 8] |= (byte)(1 << i % 8);
					num++;
				}
			}
			if (num == 0 && _pickups.Length > 0)
			{
				int num2 = Random.Range(0, _pickups.Length);
				array[num2 / 8] |= (byte)(1 << num2 % 8);
			}
			return array;
		}

		private void ApplyLayout(int seed, byte[] layout)
		{
			_lobbySeed = seed;
			for (int i = 0; i < _pickups.Length; i++)
			{
				ScrapPickup scrapPickup = _pickups[i];
				if (!(scrapPickup == null))
				{
					int sellValue = ((scrapPickup.Data != null) ? scrapPickup.Data.RollValue(seed ^ i) : 0);
					scrapPickup.Init(this, i, sellValue);
					int num = i / 8;
					bool active = num < layout.Length && ((layout[num] >> i % 8) & 1) == 1;
					scrapPickup.ConfigureFor(active ? ScrapState.InWorld : ScrapState.Pooled);
				}
			}
		}

		public void LocalRequestSell(ScrapPickup pickup)
		{
			if (!(pickup == null) && pickup.State == ScrapState.InWorld)
			{
				if (Connected)
				{
					base.photonView.RPC("RPC_RequestSell", RpcTarget.MasterClient, pickup.ScrapId, LocalActor);
				}
				else
				{
					MasterHandleSell(pickup.ScrapId, LocalActor);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_RequestSell(int scrapId, int actor, PhotonMessageInfo info)
		{
			if (PhotonNetwork.IsMasterClient && (info.Sender == null || info.Sender.ActorNumber == actor))
			{
				MasterHandleSell(scrapId, actor);
			}
		}

		private void MasterHandleSell(int scrapId, int actor)
		{
			if (!IsAuthority || !ValidPickup(scrapId))
			{
				return;
			}
			ScrapPickup scrapPickup = _pickups[scrapId];
			if (scrapPickup.State != ScrapState.InWorld || IsConsumedBit(scrapId))
			{
				return;
			}
			if (Connected && scrapPickup.photonView != null && scrapPickup.photonView.ControllerActorNr != actor)
			{
				return;
			}
			int sellValue = scrapPickup.SellValue;
			SetConsumed(scrapId);
			if (CanRpc)
			{
				base.photonView.RPC("RPC_Credit", RpcTarget.All, sellValue, actor);
			}
			else
			{
				RPC_Credit(sellValue, actor, default(PhotonMessageInfo));
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_Credit(int value, int sellerActor, PhotonMessageInfo info)
		{
			if (!PhotonNetwork.InRoom || info.Sender == null || info.Sender.IsMasterClient)
			{
				if (ScrapWallet.Instance != null)
				{
					ScrapWallet.Instance.Add(value);
				}
				ScrapEvents.RaiseScrapSold(value, PayoutPos, sellerActor);
			}
		}

		private void SetConsumed(int scrapId)
		{
			if (_consumedMask == null || _consumedMask.Length < ConsumedByteLength())
			{
				_consumedMask = new byte[ConsumedByteLength()];
			}
			_consumedMask[scrapId / 8] |= (byte)(1 << scrapId % 8);
			if (Connected)
			{
				PhotonNetwork.CurrentRoom.SetCustomProperties(new Hashtable { { RoomPropConsumed, _consumedMask } });
			}
			ApplyConsumedMask(_consumedMask);
		}

		private void ApplyConsumedMask(byte[] bytes)
		{
			if (bytes == null || _pickups == null)
			{
				return;
			}
			_consumedMask = bytes;
			for (int i = 0; i < _pickups.Length; i++)
			{
				if (!(_pickups[i] == null) && i / 8 < bytes.Length && ((bytes[i / 8] >> i % 8) & 1) != 0 && _pickups[i].State != ScrapState.Consumed)
				{
					_pickups[i].ConfigureFor(ScrapState.Consumed);
				}
			}
		}

		private bool IsConsumedBit(int scrapId)
		{
			if (_consumedMask == null || scrapId / 8 >= _consumedMask.Length)
			{
				return false;
			}
			return ((_consumedMask[scrapId / 8] >> scrapId % 8) & 1) == 1;
		}

		private bool ValidPickup(int id)
		{
			if (id >= 0 && _pickups != null && id < _pickups.Length)
			{
				return _pickups[id] != null;
			}
			return false;
		}
	}
}
