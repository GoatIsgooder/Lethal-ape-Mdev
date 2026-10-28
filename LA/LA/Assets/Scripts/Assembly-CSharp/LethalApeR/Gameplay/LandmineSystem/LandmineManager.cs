using System.Reflection;
using ExitGames.Client.Photon;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.LandmineSystem
{
	[RequireComponent(typeof(PhotonView))]
	public class LandmineManager : MonoBehaviourPunCallbacks
	{
		[Header("Lobby layout")]
		[Tooltip("Fraction of child landmines that start active in each lobby. The rest are disabled for the whole match. Each lobby rolls its own subset.")]
		[Range(0f, 1f)]
		public float activeFraction = 0.7f;

		[Header("Respawn")]
		[Tooltip("Seconds after a landmine detonates before it respawns. Set to 0 to disable respawning.")]
		public float respawnDelay = 120f;

		private const string RoomPropLayout = "LM_Layout";

		private Landmine[] _mines;

		private bool[] _enabledInLobby;

		private float[] _respawnAtRealtime;

		private bool _layoutApplied;

		private void Awake()
		{
			_mines = GetComponentsInChildren<Landmine>(true);
			_enabledInLobby = new bool[_mines.Length];
			_respawnAtRealtime = new float[_mines.Length];
			for (int i = 0; i < _mines.Length; i++)
			{
				_respawnAtRealtime[i] = -1f;
				if (_mines[i] != null)
				{
					_mines[i].manager = this;
					_mines[i].managerIndex = i;
				}
			}
		}

		private void Start()
		{
			TryApplyLayout();
		}

		public override void OnJoinedRoom()
		{
			TryApplyLayout();
		}

		public override void OnRoomPropertiesUpdate(Hashtable propsThatChanged)
		{
			if (propsThatChanged != null && !_layoutApplied && propsThatChanged.ContainsKey("LM_Layout"))
			{
				TryApplyLayout();
			}
		}

		private void TryApplyLayout()
		{
			if (_layoutApplied)
			{
				return;
			}
			if (_mines == null || _mines.Length == 0)
			{
				_layoutApplied = true;
				return;
			}
			if (!PhotonNetwork.InRoom)
			{
				ApplyMask(GenerateLocalMask());
				_layoutApplied = true;
				return;
			}
			if (PhotonNetwork.CurrentRoom.CustomProperties.TryGetValue("LM_Layout", out object value) && value is byte[] bytes && bytes.Length >= MaskByteLength())
			{
				ApplyMask(bytes);
				_layoutApplied = true;
			}
			else if (PhotonNetwork.IsMasterClient)
			{
				byte[] mask = GenerateLocalMask();
				PhotonNetwork.CurrentRoom.SetCustomProperties(new Hashtable { { "LM_Layout", mask } });
				ApplyMask(mask);
				_layoutApplied = true;
			}
		}

		private int MaskByteLength()
		{
			return (_mines.Length + 7) / 8;
		}

		private byte[] GenerateLocalMask()
		{
			byte[] array = new byte[MaskByteLength()];
			int num = 0;
			int num2 = _mines.Length;
			for (int i = 0; i < num2; i++)
			{
				if (Random.value < activeFraction)
				{
					array[i / 8] |= (byte)(1 << i % 8);
					num++;
				}
			}
			if (num == 0 && num2 > 0)
			{
				int num3 = Random.Range(0, num2);
				array[num3 / 8] |= (byte)(1 << num3 % 8);
			}
			return array;
		}

		private void ApplyMask(byte[] bytes)
		{
			for (int i = 0; i < _mines.Length; i++)
			{
				if (!(_mines[i] == null))
				{
					bool flag = (bytes[i / 8] & (1 << i % 8)) != 0;
					_enabledInLobby[i] = flag;
					_mines[i].gameObject.SetActive(flag);
				}
			}
		}

		public void NotifyDetonated(int index)
		{
			if (index >= 0 && !(respawnDelay <= 0f) && index < _mines.Length && _enabledInLobby[index] && (!PhotonNetwork.InRoom || PhotonNetwork.IsMasterClient))
			{
				_respawnAtRealtime[index] = Time.time + respawnDelay;
			}
		}

		private void Update()
		{
			if (respawnDelay <= 0f || (PhotonNetwork.InRoom && !PhotonNetwork.IsMasterClient))
			{
				return;
			}
			for (int i = 0; i < _mines.Length; i++)
			{
				if (!(_respawnAtRealtime[i] < 0f) && !(Time.time < _respawnAtRealtime[i]))
				{
					_respawnAtRealtime[i] = -1f;
					if (PhotonNetwork.InRoom)
					{
						base.photonView.RPC("RPC_Respawn", RpcTarget.All, i);
					}
					else
					{
						DoRespawn(i);
					}
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_Respawn(int index)
		{
			DoRespawn(index);
		}

		private void DoRespawn(int index)
		{
			if (index >= 0 && index < _mines.Length && _enabledInLobby[index] && !(_mines[index] == null))
			{
				_respawnAtRealtime[index] = -1f;
				_mines[index].ResetForRespawn();
			}
		}
	}
}
