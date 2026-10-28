using System;
using System.Collections.Generic;
using Photon.Pun;
using Photon.Realtime;

namespace LethalApeR.CustomMaps
{
	public sealed class RoomBrowserClient : IConnectionCallbacks, ILobbyCallbacks, IMatchmakingCallbacks
	{
		public enum Status
		{
			Offline = 0,
			Waiting = 1,
			Connecting = 2,
			Listing = 3,
			Failed = 4
		}

		private readonly Dictionary<string, RoomInfo> _rooms = new Dictionary<string, RoomInfo>();

		private LoadBalancingClient _client;

		public Status State { get; private set; }

		public string Error { get; private set; }

		public IEnumerable<RoomInfo> Rooms => _rooms.Values;

		public int Count => _rooms.Count;

		public event Action Updated;

		public void Start()
		{
			if (_client != null && State != Status.Failed)
			{
				return;
			}
			if (!PhotonNetwork.IsConnectedAndReady || PhotonNetwork.NetworkingClient == null)
			{
				State = Status.Waiting;
				Updated?.Invoke();
				return;
			}
			Stop();
			LoadBalancingClient networkingClient = PhotonNetwork.NetworkingClient;
			AppSettings appSettings = new AppSettings();
			PhotonNetwork.PhotonServerSettings.AppSettings.CopyTo(appSettings);
			appSettings.AppIdRealtime = networkingClient.AppId;
			appSettings.AppVersion = networkingClient.AppVersion;
			appSettings.FixedRegion = (string.IsNullOrEmpty(networkingClient.CloudRegion) ? appSettings.FixedRegion : networkingClient.CloudRegion.Split('/')[0]);
			_client = new LoadBalancingClient(networkingClient.LoadBalancingPeer.TransportProtocol);
			_client.AuthValues = CopyAuth(PhotonNetwork.AuthValues);
			_client.AddCallbackTarget(this);
			_rooms.Clear();
			Error = null;
			State = Status.Connecting;
			if (!_client.ConnectUsingSettings(appSettings))
			{
				Fail("Couldn't open the room list.");
			}
			Updated?.Invoke();
		}

		public void Stop()
		{
			if (_client == null)
			{
				if (State == Status.Waiting)
				{
					State = Status.Offline;
				}
				return;
			}
			_client.RemoveCallbackTarget(this);
			if (_client.IsConnected)
			{
				_client.Disconnect();
			}
			_client = null;
			if (State != Status.Failed)
			{
				State = Status.Offline;
			}
		}

		public void Service()
		{
			_client?.Service();
		}

		private static AuthenticationValues CopyAuth(AuthenticationValues source)
		{
			if (source == null)
			{
				return null;
			}
			AuthenticationValues authenticationValues = new AuthenticationValues
			{
				UserId = source.UserId,
				AuthType = source.AuthType,
				AuthGetParameters = source.AuthGetParameters
			};
			object authPostData = source.AuthPostData;
			if (authPostData is string stringData)
			{
				authenticationValues.SetAuthPostData(stringData);
			}
			else if (authPostData is byte[] byteData)
			{
				authenticationValues.SetAuthPostData(byteData);
			}
			else if (authPostData is Dictionary<string, object> dictData)
			{
				authenticationValues.SetAuthPostData(dictData);
			}
			return authenticationValues;
		}

		private void Fail(string message)
		{
			Error = message;
			State = Status.Failed;
			Updated?.Invoke();
		}

		public void OnConnectedToMaster()
		{
			if (_client != null && !_client.OpJoinLobby(TypedLobby.Default))
			{
				Fail("Couldn't open the room list.");
			}
		}

		public void OnJoinedLobby()
		{
			State = Status.Listing;
			Updated?.Invoke();
		}

		public void OnRoomListUpdate(List<RoomInfo> roomList)
		{
			foreach (RoomInfo room in roomList)
			{
				if (room.RemovedFromList || !room.IsOpen || !room.IsVisible)
				{
					_rooms.Remove(room.Name);
				}
				else
				{
					_rooms[room.Name] = room;
				}
			}
			Updated?.Invoke();
		}

		public void OnDisconnected(DisconnectCause cause)
		{
			if (cause != DisconnectCause.None && cause != DisconnectCause.DisconnectByClientLogic)
			{
				Fail("Lost the room list (" + cause.ToString() + ").");
			}
		}

		public void OnCustomAuthenticationFailed(string debugMessage)
		{
			Fail("The room list couldn't sign in.");
		}

		public void OnConnected()
		{
		}

		public void OnRegionListReceived(RegionHandler regionHandler)
		{
		}

		public void OnCustomAuthenticationResponse(Dictionary<string, object> data)
		{
		}

		public void OnLeftLobby()
		{
		}

		public void OnLobbyStatisticsUpdate(List<TypedLobbyInfo> lobbyStatistics)
		{
		}

		public void OnFriendListUpdate(List<FriendInfo> friendList)
		{
		}

		public void OnCreatedRoom()
		{
		}

		public void OnCreateRoomFailed(short returnCode, string message)
		{
		}

		public void OnJoinedRoom()
		{
		}

		public void OnJoinRoomFailed(short returnCode, string message)
		{
		}

		public void OnJoinRandomFailed(short returnCode, string message)
		{
		}

		public void OnLeftRoom()
		{
		}
	}
}
