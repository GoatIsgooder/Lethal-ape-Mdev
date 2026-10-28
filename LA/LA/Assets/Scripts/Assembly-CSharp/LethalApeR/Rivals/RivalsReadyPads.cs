using System;
using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Rivals
{
	[Obfuscation(Exclude = true)]
	public class RivalsReadyPads : MonoBehaviourPunCallbacks
	{
		public enum GroupSize
		{
			OneVsOne = 1,
			TwoVsTwo = 2
		}

		[Serializable]
		public class PadGroup
		{
			[Tooltip("Unique name for this group — its pads form one match.")]
			public string groupId = "1v1";

			[Tooltip("Players per team. Spread over the team's pads (1 pad with capacity 2 covers a 2v2 side).")]
			public GroupSize size = GroupSize.OneVsOne;

			[Tooltip("Team A pads (one pad is enough — it gets the team's full capacity).")]
			public List<ReadyPad> teamAPads = new List<ReadyPad>();

			[Tooltip("Team B pads (one pad is enough — it gets the team's full capacity).")]
			public List<ReadyPad> teamBPads = new List<ReadyPad>();
		}

		public struct MatchReadyInfo
		{
			public string GroupId;

			public List<int> TeamAActors;

			public List<int> TeamBActors;
		}

		[Header("Pad groups (central setup — pads are auto-configured from here)")]
		[SerializeField]
		private List<PadGroup> padGroups = new List<PadGroup>();

		[Tooltip("Inspector hook: fired with the ready group's id when a match is ready.")]
		public UnityEvent<string> onMatchReadyEvent;

		private readonly List<ReadyPad> _pads = new List<ReadyPad>();

		private readonly HashSet<string> _readyGroups = new HashSet<string>();

		public static RivalsReadyPads Instance { get; private set; }

		private bool Connected => PhotonNetwork.InRoom;

		private bool IsAuthority => !Connected || PhotonNetwork.IsMasterClient;

		private int LocalActor => Connected ? PhotonNetwork.LocalPlayer.ActorNumber : 1;

		public int LocalActorId => LocalActor;

		public event Action<MatchReadyInfo> OnMatchReady;

		public static event Action OnOccupancyChanged;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
			ApplyPadGroups();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnValidate()
		{
			if (!Application.isPlaying)
			{
				ApplyPadGroups();
			}
		}

		private void ApplyPadGroups()
		{
			HashSet<ReadyPad> seen = new HashSet<ReadyPad>();
			foreach (PadGroup padGroup in padGroups)
			{
				if (padGroup == null)
				{
					continue;
				}
				if (string.IsNullOrEmpty(padGroup.groupId))
				{
					Debug.LogWarning("[RivalsReadyPads] A pad group has an empty groupId — skipped.", this);
					continue;
				}
				ConfigureTeamPads(padGroup, padGroup.teamAPads, Team.TeamA, seen);
				ConfigureTeamPads(padGroup, padGroup.teamBPads, Team.TeamB, seen);
			}
		}

		private void ConfigureTeamPads(PadGroup g, List<ReadyPad> pads, Team team, HashSet<ReadyPad> seen)
		{
			int count = 0;
			foreach (ReadyPad pad in pads)
			{
				if (pad != null)
				{
					count++;
				}
			}
			if (count == 0)
			{
				Debug.LogWarning(string.Format("[RivalsReadyPads] Group '{0}' {1}: has no pads.", g.groupId, team), this);
				return;
			}
			int size = (int)g.size;
			if (count > size)
			{
				Debug.LogWarning(string.Format("[RivalsReadyPads] Group '{0}' {1}: {2} pads for {3} player slot(s) — extra pads get capacity 1 and will block readiness.", g.groupId, team, count, size), this);
			}
			int perPad = Mathf.Max(1, size / count);
			int remainder = Mathf.Max(0, size - perPad * count);
			int slot = 0;
			foreach (ReadyPad pad2 in pads)
			{
				if (pad2 == null)
				{
					continue;
				}
				if (!seen.Add(pad2))
				{
					Debug.LogWarning("[RivalsReadyPads] Pad '" + pad2.name + "' is assigned to more than one group/team — only its first assignment is used.", pad2);
					continue;
				}
				int capacity = perPad + ((slot < remainder) ? 1 : 0);
				if (pad2.groupId != g.groupId || pad2.team != team || pad2.slot != slot || pad2.capacity != capacity)
				{
					pad2.groupId = g.groupId;
					pad2.team = team;
					pad2.slot = slot;
					pad2.capacity = capacity;
				}
				slot++;
			}
		}

		public void RegisterPad(ReadyPad pad)
		{
			if (pad != null && !_pads.Contains(pad))
			{
				_pads.Add(pad);
			}
		}

		public void UnregisterPad(ReadyPad pad)
		{
			_pads.Remove(pad);
		}

		private ReadyPad FindByKey(string key)
		{
			foreach (ReadyPad pad in _pads)
			{
				if (pad != null && pad.Key == key)
				{
					return pad;
				}
			}
			return null;
		}

		public void NotifyLocalOccupancy(ReadyPad pad, bool occupied)
		{
			if (pad == null)
			{
				return;
			}
			if (occupied)
			{
				if (!pad.IsFull && !pad.HasOccupant(LocalActor))
				{
					SendClaim(pad.Key, LocalActor);
				}
			}
			else if (pad.HasOccupant(LocalActor))
			{
				SendRelease(pad.Key, LocalActor);
			}
		}

		public void ForceOccupy(string groupId, Team team, int slot, int actor = -2)
		{
			ReadyPad readyPad = FindByKey(string.Format("{0}:{1}:{2}", groupId, (int)team, slot));
			if (readyPad != null)
			{
				SendClaim(readyPad.Key, actor);
			}
		}

		public void ForceRelease(string groupId, Team team, int slot, int actor = -2)
		{
			ReadyPad readyPad = FindByKey(string.Format("{0}:{1}:{2}", groupId, (int)team, slot));
			if (readyPad != null && readyPad.HasOccupant(actor))
			{
				SendRelease(readyPad.Key, actor);
			}
		}

		private void SendClaim(string key, int actor)
		{
			if (Connected)
			{
				base.photonView.RPC("RPC_ClaimPad", RpcTarget.All, key, actor);
			}
			else
			{
				RPC_ClaimPad(key, actor);
			}
		}

		private void SendRelease(string key, int actor)
		{
			if (Connected)
			{
				base.photonView.RPC("RPC_ReleasePad", RpcTarget.All, key, actor);
			}
			else
			{
				RPC_ReleasePad(key, actor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ClaimPad(string key, int actor)
		{
			ReadyPad readyPad = FindByKey(key);
			if (readyPad == null)
			{
				return;
			}
			bool flag = false;
			foreach (ReadyPad pad in _pads)
			{
				if (pad != null && pad != readyPad && pad.HasOccupant(actor))
				{
					flag |= pad.RemoveOccupant(actor);
				}
			}
			if (flag | readyPad.AddOccupant(actor))
			{
				OnOccupancyChanged?.Invoke();
				if (IsAuthority)
				{
					CheckGroups();
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReleasePad(string key, int actor)
		{
			ReadyPad readyPad = FindByKey(key);
			if (!(readyPad == null) && readyPad.RemoveOccupant(actor))
			{
				OnOccupancyChanged?.Invoke();
				if (IsAuthority)
				{
					CheckGroups();
				}
			}
		}

		public PadGroup GetGroup(string groupId)
		{
			foreach (PadGroup padGroup in padGroups)
			{
				if (padGroup != null && padGroup.groupId == groupId)
				{
					return padGroup;
				}
			}
			return null;
		}

		private void CheckGroups()
		{
			Dictionary<string, List<ReadyPad>> dictionary = new Dictionary<string, List<ReadyPad>>();
			foreach (ReadyPad pad in _pads)
			{
				if (!(pad == null))
				{
					if (!dictionary.TryGetValue(pad.groupId, out var value))
					{
						value = (dictionary[pad.groupId] = new List<ReadyPad>());
					}
					value.Add(pad);
				}
			}
			foreach (KeyValuePair<string, List<ReadyPad>> item in dictionary)
			{
				int count = item.Value.Count;
				List<int> teamA = new List<int>();
				List<int> teamB = new List<int>();
				bool allFull = true;
				foreach (ReadyPad item2 in item.Value)
				{
					if (!item2.IsFull)
					{
						allFull = false;
						break;
					}
					foreach (int occupant in item2.Occupants)
					{
						if (item2.team == Team.TeamA)
						{
							teamA.Add(occupant);
						}
						else if (item2.team == Team.TeamB)
						{
							teamB.Add(occupant);
						}
					}
				}
				if (!allFull || count <= 0 || teamA.Count < 1 || teamB.Count < 1)
				{
					_readyGroups.Remove(item.Key);
				}
				else if (_readyGroups.Add(item.Key))
				{
					MatchReadyInfo obj = new MatchReadyInfo
					{
						GroupId = item.Key,
						TeamAActors = teamA,
						TeamBActors = teamB
					};
					Debug.Log("[RivalsReadyPads] Group '" + item.Key + "' READY — A:[" + string.Join(",", teamA) + "] B:[" + string.Join(",", teamB) + "]");
					this.OnMatchReady?.Invoke(obj);
					onMatchReadyEvent?.Invoke(item.Key);
				}
			}
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			foreach (ReadyPad pad in _pads)
			{
				if (pad != null && pad.HasOccupant(otherPlayer.ActorNumber))
				{
					SendRelease(pad.Key, otherPlayer.ActorNumber);
				}
			}
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			if (!PhotonNetwork.IsMasterClient)
			{
				return;
			}
			foreach (ReadyPad pad in _pads)
			{
				if (pad == null)
				{
					continue;
				}
				foreach (int occupant in pad.Occupants)
				{
					base.photonView.RPC("RPC_ClaimPad", newPlayer, pad.Key, occupant);
				}
			}
		}

		public override void OnJoinedRoom()
		{
			ResetAllPads();
		}

		public override void OnLeftRoom()
		{
			ResetAllPads();
		}

		private void ResetAllPads()
		{
			foreach (ReadyPad pad in _pads)
			{
				if (pad != null)
				{
					pad.ClearOccupants();
				}
			}
			_readyGroups.Clear();
			OnOccupancyChanged?.Invoke();
		}
	}
}
