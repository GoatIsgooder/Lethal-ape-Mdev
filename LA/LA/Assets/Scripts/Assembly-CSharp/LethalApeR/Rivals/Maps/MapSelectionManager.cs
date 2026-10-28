using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.SceneFlow;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Rivals.Maps
{
	[Obfuscation(Exclude = true)]
	public class MapSelectionManager : MonoBehaviourPunCallbacks
	{
		[Header("Map pool")]
		[Tooltip("All arenas eligible to be played. Order is the rotation order.")]
		[SerializeField]
		private List<MapData> mapPool = new List<MapData>();

		[Header("Selection mode")]
		[Tooltip("ON = players vote between candidates. OFF = fixed rotation.")]
		[SerializeField]
		private bool useVoting = true;

		[Tooltip("How many maps to offer during a vote.")]
		[Min(2f)]
		[SerializeField]
		private int voteCandidateCount = 3;

		private MapData _selectedMap;

		private MapData _lastPlayedMap;

		private int _rotationIndex = -1;

		private readonly List<MapData> _candidates = new List<MapData>();

		private readonly Dictionary<int, int> _votesByActor = new Dictionary<int, int>();

		public static MapSelectionManager Instance { get; private set; }

		public bool UseVoting => useVoting;

		public IReadOnlyList<MapData> Candidates => _candidates;

		public event Action<IReadOnlyList<MapData>> OnVoteStarted;

		public event Action<int[]> OnVoteTallyChanged;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
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

		public MapData GetSelectedMap()
		{
			return _selectedMap;
		}

		public List<SpawnPoint> GetSpawnPoints(Team team)
		{
			return SpawnPoint.ForTeam(team);
		}

		public IReadOnlyList<SpawnPoint> GetSpawnPoints()
		{
			return SpawnPoint.All;
		}

		public void BeginSelection()
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			if (!useVoting)
			{
				SelectAndAnnounce(PickNextInRotation());
				return;
			}
			_votesByActor.Clear();
			List<MapData> picks = PickCandidates();
			int[] indices = new int[picks.Count];
			for (int i = 0; i < picks.Count; i++)
			{
				indices[i] = mapPool.IndexOf(picks[i]);
			}
			base.photonView.RPC("RPC_OpenVote", RpcTarget.All, indices);
		}

		public void CastVote(int candidateIndex)
		{
			if (useVoting)
			{
				base.photonView.RPC("RPC_CastVote", RpcTarget.MasterClient, PhotonNetwork.LocalPlayer.ActorNumber, candidateIndex);
			}
		}

		public void ResolveSelection()
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			if (!useVoting || _candidates.Count == 0)
			{
				SelectAndAnnounce(_selectedMap ?? PickNextInRotation());
				return;
			}
			int[] tally = TallyVotes();
			List<int> tied = new List<int>();
			int best = -1;
			int winner = 0;
			for (int i = 0; i < tally.Length; i++)
			{
				if (tally[i] > best)
				{
					tied.Clear();
					tied.Add(i);
					best = tally[i];
					winner = i;
				}
				else if (tally[i] == best)
				{
					tied.Add(i);
				}
			}
			if (tied.Count > 1)
			{
				winner = tied[UnityEngine.Random.Range(0, tied.Count)];
			}
			SelectAndAnnounce(_candidates[Mathf.Clamp(winner, 0, _candidates.Count - 1)]);
		}

		public void LoadSelectedMap()
		{
			if (PhotonNetwork.IsMasterClient)
			{
				if (_selectedMap == null)
				{
					Debug.LogWarning("[MapSelection] No map selected to load.");
				}
				else
				{
					LoadMap(_selectedMap);
				}
			}
		}

		public void LoadMap(MapData map)
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			if (map == null || string.IsNullOrWhiteSpace(map.sceneName))
			{
				Debug.LogWarning("[MapSelection] LoadMap called with null/empty-scene map.");
				return;
			}
			_lastPlayedMap = map;
			if (!SceneTransition.GoNetworked(map.sceneName))
			{
				PhotonNetwork.LoadLevel(map.sceneName);
			}
		}

		private MapData PickNextInRotation()
		{
			if (mapPool.Count == 0)
			{
				return null;
			}
			_rotationIndex = (_rotationIndex + 1) % mapPool.Count;
			if (mapPool.Count > 1 && mapPool[_rotationIndex] == _lastPlayedMap)
			{
				_rotationIndex = (_rotationIndex + 1) % mapPool.Count;
			}
			return mapPool[_rotationIndex];
		}

		private List<MapData> PickCandidates()
		{
			List<MapData> pool = new List<MapData>();
			foreach (MapData map in mapPool)
			{
				if (map != null && map != _lastPlayedMap)
				{
					pool.Add(map);
				}
			}
			if (pool.Count < voteCandidateCount)
			{
				foreach (MapData map2 in mapPool)
				{
					if (map2 != null && !pool.Contains(map2))
					{
						pool.Add(map2);
					}
				}
			}
			for (int i = pool.Count - 1; i > 0; i--)
			{
				int j = UnityEngine.Random.Range(0, i + 1);
				(pool[i], pool[j]) = (pool[j], pool[i]);
			}
			return pool.GetRange(0, Mathf.Min(voteCandidateCount, pool.Count));
		}

		private int[] TallyVotes()
		{
			int[] tally = new int[_candidates.Count];
			foreach (KeyValuePair<int, int> kv in _votesByActor)
			{
				if (kv.Value >= 0 && kv.Value < tally.Length)
				{
					tally[kv.Value]++;
				}
			}
			return tally;
		}

		private void SelectAndAnnounce(MapData map)
		{
			int index = ((map != null) ? mapPool.IndexOf(map) : (-1));
			base.photonView.RPC("RPC_SetSelected", RpcTarget.All, index);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_OpenVote(int[] mapIndices)
		{
			_candidates.Clear();
			foreach (int idx in mapIndices)
			{
				if (idx >= 0 && idx < mapPool.Count)
				{
					_candidates.Add(mapPool[idx]);
				}
			}
			this.OnVoteStarted?.Invoke(_candidates);
			this.OnVoteTallyChanged?.Invoke(new int[_candidates.Count]);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_CastVote(int actorNumber, int candidateIndex)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				_votesByActor[actorNumber] = candidateIndex;
				base.photonView.RPC("RPC_TallyUpdate", RpcTarget.All, TallyVotes());
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_TallyUpdate(int[] tally)
		{
			this.OnVoteTallyChanged?.Invoke(tally);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetSelected(int mapIndex)
		{
			_selectedMap = ((mapIndex >= 0 && mapIndex < mapPool.Count) ? mapPool[mapIndex] : null);
			if (_selectedMap != null)
			{
				RivalsEvents.RaiseMapSelected(_selectedMap);
			}
		}

		private void OnValidate()
		{
			if (mapPool.Count == 0)
			{
				Debug.LogWarning("[MapSelectionManager] Map pool is empty on '" + base.name + "'.", this);
			}
			voteCandidateCount = Mathf.Max(2, voteCandidateCount);
		}
	}
}
