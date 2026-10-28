using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using LethalApeR.Rivals.Combat;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using Hashtable = ExitGames.Client.Photon.Hashtable;

namespace LethalApeR.Rivals
{
	[Obfuscation(Exclude = true)]
	public class RivalsMatchmaker : MonoBehaviourPunCallbacks
	{
		[Header("Timing")]
		[Tooltip("Seconds to wait in the match room for all participants to arrive and their NetworkPlayers to spawn. On timeout the match starts with whoever made it, or aborts back to the hub if a whole team is missing.")]
		public float joinTimeout = 25f;

		private const string TeamProp = "rivalsTeam";

		private const string MatchRoomPrefix = "RIVALS-";

		private string _pendingMatchRoom;

		private int _expectedPlayers;

		private int _pendingTeam;

		private readonly List<int> _botActors = new List<int>();

		private readonly List<int> _botTeams = new List<int>();

		private string _returnQueue;

		private bool _inMatchRoom;

		private bool _migrating;

		private bool _matchStarted;

		private bool _returningToHub;

		private float _matchRoomJoinedAt;

		private float _nextTeamRepublish;

		private bool _kickoffGraceUsed;

		private float _returnToHubDeadline;

		[Tooltip("After a match, if returning to the public hub stalls this many seconds (the post-leave OnConnectedToMaster callback can be slow/skipped on Quest), the rejoin is forced. Retries on this interval until back in a room.")]
		public float returnToHubTimeout = 6f;

		public static RivalsMatchmaker Instance { get; private set; }

		public bool InMatchRoom => _inMatchRoom;

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

		public bool TryBeginMatchMigration(RivalsReadyPads.MatchReadyInfo info)
		{
			if (!PhotonNetwork.InRoom)
			{
				return false;
			}
			if (_migrating || _inMatchRoom)
			{
				return true;
			}
			if (!HasAnyReal(info.TeamAActors) && !HasAnyReal(info.TeamBActors))
			{
				return false;
			}
			string roomName = "RIVALS-" + Guid.NewGuid().ToString("N").Substring(0, 8).ToUpperInvariant();
			List<int> actors = new List<int>();
			List<int> teams = new List<int>();
			foreach (int actor in info.TeamAActors)
			{
				actors.Add(actor);
				teams.Add(1);
			}
			foreach (int actor2 in info.TeamBActors)
			{
				actors.Add(actor2);
				teams.Add(2);
			}
			_migrating = true;
			Debug.Log(string.Format("[RivalsMatchmaker] Migrating group '{0}' ({1} players) to match room '{2}'.", info.GroupId, actors.Count, roomName));
			base.photonView.RPC("RPC_MoveToMatchRoom", RpcTarget.All, roomName, actors.ToArray(), teams.ToArray());
			return true;
		}

		private static bool HasAnyReal(List<int> actors)
		{
			if (actors == null)
			{
				return false;
			}
			foreach (int actor in actors)
			{
				if (actor >= 1)
				{
					return true;
				}
			}
			return false;
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_MoveToMatchRoom(string roomName, int[] actors, int[] teams)
		{
			int localActor = (PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
			int index = Array.IndexOf(actors, localActor);
			if (index < 0)
			{
				return;
			}
			_pendingMatchRoom = roomName;
			_matchStarted = false;
			_returnQueue = GetCurrentRoomQueue();
			_pendingTeam = teams[index];
			_botActors.Clear();
			_botTeams.Clear();
			int realPlayers = 0;
			for (int i = 0; i < actors.Length; i++)
			{
				if (actors[i] >= 1)
				{
					realPlayers++;
					continue;
				}
				_botActors.Add(actors[i]);
				_botTeams.Add(teams[i]);
			}
			_expectedPlayers = Mathf.Max(1, realPlayers);
			MonkeDevNetworkingManager._JoinPrivateRoom(roomName, _expectedPlayers);
		}

		private static string GetCurrentRoomQueue()
		{
			Room currentRoom = PhotonNetwork.CurrentRoom;
			if (currentRoom != null && currentRoom.CustomProperties != null && currentRoom.CustomProperties.TryGetValue("queue", out object value) && value is string text && !string.IsNullOrEmpty(text))
			{
				return text;
			}
			return FallbackRivalsQueue();
		}

		private static string FallbackRivalsQueue()
		{
			GamemodeManager instance = GamemodeManager.Instance;
			if (instance != null && !string.IsNullOrEmpty(instance.requiredQueuePrefix))
			{
				return instance.requiredQueuePrefix;
			}
			return "RVLS";
		}

		public override void OnJoinedRoom()
		{
			if (_pendingMatchRoom != null && PhotonNetwork.CurrentRoom != null && string.Equals(MonkeDevNetworkingManager.SalvageDisplayCode(PhotonNetwork.CurrentRoom.Name), _pendingMatchRoom))
			{
				_inMatchRoom = true;
				_migrating = false;
				_matchRoomJoinedAt = Time.time;
				_kickoffGraceUsed = false;
				_nextTeamRepublish = Time.time + 1f;
				PhotonNetwork.LocalPlayer.SetCustomProperties(new Hashtable { { "rivalsTeam", _pendingTeam } });
				Debug.Log("[RivalsMatchmaker] Entered match room '" + _pendingMatchRoom + "' " + string.Format("({0}/{1}).", PhotonNetwork.CurrentRoom.PlayerCount, _expectedPlayers));
			}
		}

		private void Update()
		{
			if (_returningToHub && Time.time >= _returnToHubDeadline)
			{
				_returnToHubDeadline = Time.time + Mathf.Max(returnToHubTimeout, 2f);
				if (PhotonNetwork.IsConnectedAndReady && !PhotonNetwork.InRoom)
				{
					Debug.LogWarning("[RivalsMatchmaker] Return-to-hub stalled (no OnConnectedToMaster) — forcing public hub rejoin.");
					RejoinPublicHub();
				}
			}
			if (!_inMatchRoom || _matchStarted || !PhotonNetwork.InRoom)
			{
				return;
			}
			if (_pendingTeam != 0 && Time.time >= _nextTeamRepublish && !LocalTeamPropPresent())
			{
				_nextTeamRepublish = Time.time + 1f;
				PhotonNetwork.LocalPlayer.SetCustomProperties(new Hashtable { { "rivalsTeam", _pendingTeam } });
			}
			if (PhotonNetwork.IsMasterClient)
			{
				if (PhotonNetwork.CurrentRoom.PlayerCount >= _expectedPlayers && AllHealthsRegistered() && AllTeamPropsSet())
				{
					Kickoff();
				}
				else if (Time.time - _matchRoomJoinedAt >= joinTimeout)
				{
					Debug.LogWarning(string.Format("[RivalsMatchmaker] Join timeout — players={0}/{1} ", PhotonNetwork.CurrentRoom.PlayerCount, _expectedPlayers) + string.Format("healthsReady={0} teamsReady={1} — starting with whoever arrived.", AllHealthsRegistered(), AllTeamPropsSet()));
					Kickoff();
				}
			}
		}

		private static bool LocalTeamPropPresent()
		{
			Player localPlayer = PhotonNetwork.LocalPlayer;
			if (localPlayer == null || localPlayer.CustomProperties == null)
			{
				return false;
			}
			return localPlayer.CustomProperties.ContainsKey("rivalsTeam");
		}

		private static bool AllTeamPropsSet()
		{
			foreach (Player value in PhotonNetwork.CurrentRoom.Players.Values)
			{
				if (value.CustomProperties == null || !value.CustomProperties.ContainsKey("rivalsTeam"))
				{
					return false;
				}
			}
			return true;
		}

		private static bool AllHealthsRegistered()
		{
			foreach (Player value in PhotonNetwork.CurrentRoom.Players.Values)
			{
				if (!PlayerHealth.TryGet(value.ActorNumber, out PlayerHealth health) || health == null || !health.isActiveAndEnabled || health.photonView == null || health.photonView.ViewID == 0 || health.photonView.OwnerActorNr != value.ActorNumber)
				{
					return false;
				}
			}
			return true;
		}

		private void Kickoff()
		{
			List<int> teamA = new List<int>();
			List<int> teamB = new List<int>();
			foreach (Player player in PhotonNetwork.CurrentRoom.Players.Values)
			{
				if (player.CustomProperties != null && player.CustomProperties.TryGetValue("rivalsTeam", out object value))
				{
					switch ((int)value)
					{
					case 1:
						teamA.Add(player.ActorNumber);
						break;
					case 2:
						teamB.Add(player.ActorNumber);
						break;
					}
				}
			}
			for (int i = 0; i < _botActors.Count; i++)
			{
				if (_botTeams[i] == 1)
				{
					if (!teamA.Contains(_botActors[i]))
					{
						teamA.Add(_botActors[i]);
					}
				}
				else if (_botTeams[i] == 2 && !teamB.Contains(_botActors[i]))
				{
					teamB.Add(_botActors[i]);
				}
			}
			if (teamA.Count == 0 || teamB.Count == 0)
			{
				if (_kickoffGraceUsed)
				{
					Debug.LogWarning("[RivalsMatchmaker] A team never arrived — aborting match, returning to hub.");
					ReturnEveryoneToHub();
				}
				else
				{
					_kickoffGraceUsed = true;
					_matchRoomJoinedAt = Time.time - joinTimeout + 4f;
					Debug.LogWarning("[RivalsMatchmaker] A team looks empty at timeout — granting 4s grace before aborting.");
				}
				return;
			}
			_matchStarted = true;
			Debug.Log("[RivalsMatchmaker] Match starting — A:[" + string.Join(",", teamA) + "] B:[" + string.Join(",", teamB) + "]");
			if (GamemodeManager.Instance != null)
			{
				GamemodeManager.Instance.StartMatchmadeMatch(teamA, teamB);
			}
		}

		public void ReturnEveryoneToHub()
		{
			if (_inMatchRoom && PhotonNetwork.InRoom)
			{
				base.photonView.RPC("RPC_ReturnToHub", RpcTarget.All);
			}
			else
			{
				RPC_ReturnToHub();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReturnToHub()
		{
			if (_inMatchRoom)
			{
				ClearMatchState();
				_returningToHub = true;
				_returnToHubDeadline = Time.time + Mathf.Max(returnToHubTimeout, 2f);
				if (PhotonNetwork.InRoom)
				{
					PhotonNetwork.LeaveRoom();
				}
			}
		}

		public override void OnConnectedToMaster()
		{
			if (_returningToHub)
			{
				RejoinPublicHub();
			}
		}

		private void RejoinPublicHub()
		{
			_returningToHub = false;
			string text = (string.IsNullOrEmpty(_returnQueue) ? FallbackRivalsQueue() : _returnQueue);
			Debug.Log("[RivalsMatchmaker] Returning to public hub (queue '" + text + "').");
			MonkeDevNetworkingManager.JoinRandomRoom(text);
		}

		public override void OnJoinRoomFailed(short returnCode, string message)
		{
			if (_pendingMatchRoom != null && !_inMatchRoom)
			{
				Debug.LogWarning("[RivalsMatchmaker] Failed to join match room (" + message + ") — rejoining hub.");
				ClearMatchState();
				_returningToHub = true;
				OnConnectedToMaster();
			}
		}

		public override void OnLeftRoom()
		{
			if (_inMatchRoom && !_returningToHub)
			{
				ClearMatchState();
			}
		}

		private void ClearMatchState()
		{
			_pendingMatchRoom = null;
			_inMatchRoom = false;
			_migrating = false;
			_matchStarted = false;
			_expectedPlayers = 0;
			_pendingTeam = 0;
			_kickoffGraceUsed = false;
			_nextTeamRepublish = 0f;
			_botActors.Clear();
			_botTeams.Clear();
			if (PhotonNetwork.InRoom)
			{
				PhotonNetwork.LocalPlayer.SetCustomProperties(new Hashtable { { "rivalsTeam", 0 } });
			}
		}
	}
}
