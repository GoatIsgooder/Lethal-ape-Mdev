using System;
using System.Collections.Generic;
using Oculus.Platform;
using Oculus.Platform.Models;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevOculusPresenceManager : MonoBehaviour
	{
		public struct OculusUserData
		{
			public ulong OculusID;

			public string OculusUsername;

			public string ImageUrl;
		}

		[Header("Presence Settings")]
		[Tooltip("Destination API name (Meta Developer Dashboard) used while in the lobby")]
		public string lobbyDestinationApiName = "lobby";

		[Tooltip("Destination API name used while in a game room")]
		public string gameDestinationApiName = "game";

		[Header("Debug")]
		public bool enableDebugLogs = true;

		private const string LogTag = "[MonkeDevOculusPresence] ";

		private readonly Dictionary<ulong, OculusUserData> _userCache = new Dictionary<ulong, OculusUserData>();

		private string _roomCode = "";

		private string _queue = "";

		private bool _inRoom;

		public static MonkeDevOculusPresenceManager Instance { get; private set; }

		private static bool PlatformReady => Core.IsInitialized();

		private void Awake()
		{
			if (Instance != null)
			{
				UnityEngine.Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
		}

		private void Start()
		{
			Trace("Initialized");
		}

		private void OnDestroy()
		{
			ClearPresence();
		}

		public void SetRoomPresence(string roomCode, string queue, int currentPlayers, int maxPlayers, bool isPublic)
		{
			if (!PlatformReady)
			{
				return;
			}
			_roomCode = roomCode;
			_queue = queue;
			_inRoom = true;
			bool joinable = currentPlayers < maxPlayers;
			GroupPresenceOptions groupPresenceOptions = new GroupPresenceOptions();
			groupPresenceOptions.SetDestinationApiName(gameDestinationApiName);
			groupPresenceOptions.SetIsJoinable(joinable);
			groupPresenceOptions.SetLobbySessionId(roomCode);
			groupPresenceOptions.SetMatchSessionId(roomCode);
			GroupPresence.Set(groupPresenceOptions).OnComplete(delegate(Message message)
			{
				if (!LoggedFailure(message, "set presence") && enableDebugLogs)
				{
					Debug.Log(string.Format("{0}Room presence set - Room: {1}, Queue: {2}, Players: {3}/{4}, Joinable: {5}", LogTag, roomCode, queue, currentPlayers, maxPlayers, joinable));
				}
			});
		}

		public void UpdateRoomPresence(int currentPlayers, int maxPlayers)
		{
			if (_inRoom)
			{
				// RE: unsure - binary null-checks CurrentRoom and passes constant false (unused isPublic); likely CurrentRoom.IsVisible folded away
				SetRoomPresence(_roomCode, _queue, currentPlayers, maxPlayers, PhotonNetwork.CurrentRoom.IsVisible);
			}
		}

		public void SetLobbyPresence()
		{
			if (PlatformReady)
			{
				_roomCode = "";
				_inRoom = false;
				GroupPresenceOptions groupPresenceOptions = new GroupPresenceOptions();
				groupPresenceOptions.SetDestinationApiName(lobbyDestinationApiName);
				groupPresenceOptions.SetIsJoinable(false);
				GroupPresence.Set(groupPresenceOptions).OnComplete(delegate(Message message)
				{
					if (!LoggedFailure(message, "set lobby presence"))
					{
						Trace("Lobby presence set");
					}
				});
			}
		}

		public void ClearPresence()
		{
			_roomCode = "";
			_inRoom = false;
			if (PlatformReady)
			{
				GroupPresence.Clear().OnComplete(delegate(Message message)
				{
					if (!LoggedFailure(message, "clear presence"))
					{
						Trace("Presence cleared");
					}
				});
			}
		}

		public void GetOculusUserData(ulong oculusId, Action<OculusUserData> onComplete)
		{
			if (_userCache.TryGetValue(oculusId, out var value))
			{
				onComplete?.Invoke(value);
			}
			else if (PlatformReady)
			{
				Users.Get(oculusId).OnComplete(delegate(Message<User> message)
				{
					if (LoggedFailure(message, string.Format("get user data for {0}", oculusId)))
					{
						onComplete?.Invoke(default(OculusUserData));
						return;
					}
					User data = message.Data;
					OculusUserData oculusUserData = new OculusUserData
					{
						OculusID = data.ID,
						OculusUsername = data.OculusID,
						ImageUrl = data.ImageURL
					};
					_userCache[oculusId] = oculusUserData;
					onComplete?.Invoke(oculusUserData);
				});
			}
			else
			{
				onComplete?.Invoke(default(OculusUserData));
			}
		}

		public string GetCachedOculusUsername(ulong oculusId)
		{
			if (!_userCache.TryGetValue(oculusId, out var value))
			{
				return null;
			}
			return value.OculusUsername;
		}

		public void OpenInvitePanel()
		{
			if (!_inRoom)
			{
				Debug.LogWarning(LogTag + "Cannot invite - not in a room");
				return;
			}
			if (!PlatformReady)
			{
				Debug.LogWarning(LogTag + "Cannot open invite panel - Oculus Platform not initialized");
				return;
			}
			GroupPresence.LaunchInvitePanel(new InviteOptions()).OnComplete(delegate(Message<InvitePanelResultInfo> message)
			{
				if (!LoggedFailure(message, "open invite panel"))
				{
					Trace("Invite panel opened");
				}
			});
		}

		private static bool LoggedFailure(Message message, string action)
		{
			if (!message.IsError)
			{
				return false;
			}
			Debug.LogError(LogTag + "Failed to " + action + ": " + message.GetError().Message);
			return true;
		}

		private void Trace(string text)
		{
			if (enableDebugLogs)
			{
				Debug.Log(LogTag + text);
			}
		}
	}
}
