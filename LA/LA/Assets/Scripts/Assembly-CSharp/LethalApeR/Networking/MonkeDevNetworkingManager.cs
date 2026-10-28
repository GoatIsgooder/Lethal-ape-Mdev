using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using Photon.Voice.PUN;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevNetworkingManager : MonoBehaviourPunCallbacks
	{
		public enum CrossplayHost
		{
			LA = 0,
			LAR = 1
		}

		private enum XplayRequest : byte
		{
			None = 0,
			Hub = 1,
			Private = 2
		}

		[Header("Player")]
		public Transform Head;

		public Transform LeftHand;

		public Transform RightHand;

		public Color Colour;

		[Header("Networking")]
		public string DefaultQueue = "Default";

		public int DefaultRoomLimit = 16;

		[Header("Other")]
		public bool JoinRoomOnConnect = true;

		private bool hasJoinedRoomOnConnect;

		public List<MonkeDevNetworkingPlayer> Players = new List<MonkeDevNetworkingPlayer>();

		[NonSerialized]
		public MonkeDevNetworkingPlayer LocalPlayer;

		private RoomOptions options;

		private ConnectionState State;

		public const string XplayRealtimeAppId = "b8146134-b894-4739-8533-ed29c1e9891d";

		public const string XplayVoiceAppId = "5e935d1f-03c7-4cd7-aa93-dd6617a57668";

		public const string XplayVersion = "ag-xplay-1";

		public const string ApeGamesQueue = "ApeGames";

		public const string LarRealtimeAppId = "84997d7a-79df-4b69-8b75-f63ad347a8c2";

		public const string LarVoiceAppId = "06b03811-e8c7-4328-9e01-b983b5abcf05";

		public CrossplayHost crossplayHost;

		[Tooltip("Set TRUE on the ApeGames scene's manager: routes the normal connect + JoinRandomRoom onto LA's crossplay Photon app so LA and LAR ApeGames players share the match. Leave FALSE everywhere else — normal matchmaking is untouched.")]
		public bool crossplay;

		[Tooltip("Which crossplay mode this scene matchmakes for. Its queue, room version and hub room limit come from CrossplayProfiles in code, never from the scene.")]
		public CrossplayMode crossplayMode;

		private static bool _crossplayLink;

		private const float CrossplayStallSeconds = 6f;

		private float _crossplayIdleSince = -1f;

		private const float HandoffTimeout = 30f;

		private static bool _handoffPending;

		private static MonkeDevNetworkingManager _handoffFrom;

		private static string _pendingUserId;

		private static string _connectUserId;

		private static bool _connectAuthenticated;

		private static bool _reconnectWithAuth;

		private static string _reconnectUserId;

		private static AppSettings _crossplayVoiceSettings;

		private static XplayRequest _xplayRequest;

		private static string _xplayRoom;

		private static int _xplayMaxPlayers;

		private static ExitGames.Client.Photon.Hashtable _xplayProps;

		private static bool _xplayPrivateInFlight;

		private static bool _returningToNative;

		public static Func<ExitGames.Client.Photon.Hashtable> ExtraRoomProperties;

		private static string _pendingPrivateJoinCode;

		private static int _pendingPrivateJoinMaxPlayers;

		private static string _pendingRandomJoinQueue;

		private static int _pendingRandomJoinMaxPlayers;

		public const string PrivateRoomVersionSeparator = "_v";

		private static string _pendingNamedJoin;

		private static int _darkRoomLeaves;

		private const int MaxDarkRoomLeaves = 2;

		private const float PresenceUpdateMinInterval = 2f;

		private float _lastPresenceUpdateTime = -100f;

		private Coroutine _pendingPresenceUpdate;

		public static MonkeDevNetworkingManager Manager { get; private set; }

		public Dictionary<string, string> Cosmetics { get; private set; } = new Dictionary<string, string>();

		public static CrossplayProfile ActiveCrossplayProfile
		{
			get
			{
				if (Manager != null && Manager.crossplay)
				{
					return CrossplayProfiles.Get(Manager.crossplayMode);
				}
				return null;
			}
		}

		public static bool SceneHandoffPending => _handoffPending;

		private static bool IsOnMasterServer
		{
			get
			{
				ClientState networkClientState = PhotonNetwork.NetworkClientState;
				return networkClientState == ClientState.ConnectedToMasterServer || networkClientState == ClientState.JoinedLobby;
			}
		}

		public static bool IdentityHidden { get; private set; }

		public static event Action<short, string> RoomJoinFailed;

		private void Start()
		{
			if (Manager == null)
			{
				Manager = this;
			}
			else
			{
				Debug.LogError("There can't be multiple MonkeDevNetworkingManagers in a scene");
				Application.Quit();
			}
			if (!string.IsNullOrEmpty(PlayerPrefs.GetString("Colour")))
			{
				Colour = JsonUtility.FromJson<Color>(PlayerPrefs.GetString("Colour"));
			}
			if (!string.IsNullOrEmpty(PlayerPrefs.GetString("Cosmetics")))
			{
				Cosmetics = MonkeDevNetworkingValueSaver.GetDictionary("Cosmetics");
			}
			if (_handoffPending && _handoffFrom != this)
			{
				StartCoroutine(FinishSceneHandoff());
			}
		}

		private void Update()
		{
			if (Manager != this || !crossplay || !JoinRoomOnConnect || !_crossplayLink || _handoffPending || !IsOnMasterServer)
			{
				_crossplayIdleSince = -1f;
				return;
			}
			float unscaledTime = Time.unscaledTime;
			if (_crossplayIdleSince < 0f)
			{
				_crossplayIdleSince = unscaledTime;
			}
			else if (unscaledTime - _crossplayIdleSince >= CrossplayStallSeconds)
			{
				_crossplayIdleSince = Time.unscaledTime;
				Debug.LogWarning(string.Format("[Crossplay] On the Master Server with no join for {0}s; joining.", CrossplayStallSeconds));
				DoCrossplayJoin();
			}
		}

		public static void BeginSceneHandoff()
		{
			_handoffPending = true;
			_handoffFrom = Manager;
			_pendingRandomJoinQueue = null;
			_pendingRandomJoinMaxPlayers = 0;
			_pendingPrivateJoinCode = null;
			_pendingPrivateJoinMaxPlayers = 0;
			_pendingNamedJoin = null;
			ClearCrossplayRequest();
			_xplayPrivateInFlight = false;
		}

		public static void CancelSceneHandoff()
		{
			if (_handoffPending)
			{
				_handoffFrom = null;
				if (Manager != null)
				{
					Manager.StartCoroutine(Manager.FinishSceneHandoff());
				}
				else
				{
					_handoffPending = false;
				}
			}
		}

		private IEnumerator FinishSceneHandoff()
		{
			float giveUpAt = Time.realtimeSinceStartup + HandoffTimeout;
			while (_handoffPending && _handoffFrom != this)
			{
				switch (PhotonNetwork.NetworkClientState)
				{
				case ClientState.JoinedLobby:
				case ClientState.Joined:
				case ClientState.ConnectedToMasterServer:
					JoinForHandoff();
					yield break;
				case ClientState.PeerCreated:
				case ClientState.Disconnected:
					EndSceneHandoff();
					yield break;
				}
				if (Time.realtimeSinceStartup > giveUpAt)
				{
					Debug.LogWarning(string.Format("[MonkeDevNetworkingManager] Scene hand-off still waiting on Photon ({0}) after {1}s; giving up.", PhotonNetwork.NetworkClientState, HandoffTimeout));
					EndSceneHandoff();
					yield break;
				}
				yield return null;
			}
		}

		private void JoinForHandoff()
		{
			EndSceneHandoff();
			if (JoinRoomOnConnect)
			{
				hasJoinedRoomOnConnect = true;
				_JoinRandomRoom(DefaultQueue, DefaultRoomLimit);
			}
		}

		private static void EndSceneHandoff()
		{
			_handoffFrom = null;
			_handoffPending = false;
		}

		public static bool Connect(string userId = null)
		{
			if (userId != null)
			{
				_connectUserId = userId;
			}
			ClientState networkClientState = PhotonNetwork.NetworkClientState;
			if (networkClientState != ClientState.PeerCreated && networkClientState != ClientState.Disconnected)
			{
				if (_connectAuthenticated || Qauth.Platform == null || string.IsNullOrEmpty(Qauth.MetaUserId))
				{
					return false;
				}
				_reconnectUserId = userId;
				_reconnectWithAuth = true;
				PhotonNetwork.Disconnect();
				return true;
			}
			_ = ConnectWithAuthAsync(userId);
			return true;
		}

		private static async Task ConnectWithAuthAsync(string userId)
		{
			AuthenticationValues authenticationValues = null;
			try
			{
				authenticationValues = await QauthPhoton.MakeAuthValuesAsync();
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[MonkeDevNetworkingManager] Qauth Photon auth failed, connecting without it: " + ex.Message);
			}
			ClientState networkClientState = PhotonNetwork.NetworkClientState;
			if (networkClientState != ClientState.PeerCreated && networkClientState != ClientState.Disconnected)
			{
				return;
			}
			_pendingUserId = userId;
			if (authenticationValues != null)
			{
				PhotonNetwork.AuthValues = authenticationValues;
				_pendingUserId = null;
			}
			_connectAuthenticated = authenticationValues != null;
			if (Manager != null && Manager.crossplay)
			{
				ConnectCrossplay();
				return;
			}
			_crossplayLink = false;
			Manager.State = ConnectionState.Connecting;
			PhotonNetwork.ConnectUsingSettings();
		}

		public void Disconnect()
		{
			PhotonNetwork.Disconnect();
		}

		private static void ConnectCrossplay()
		{
			_ = ConnectCrossplayAsync();
		}

		private static async Task ConnectCrossplayAsync()
		{
			_crossplayLink = true;
			LarApi.HostResult hostResult = await LarApi.GetApeGamesHost("LA");
			bool flag = ((hostResult != null) ? (hostResult.host == "LAR") : (Manager.crossplayHost == CrossplayHost.LAR));
			AppSettings appSettings = new AppSettings();
			PhotonNetwork.PhotonServerSettings.AppSettings.CopyTo(appSettings);
			appSettings.AppIdRealtime = hostResult?.appId ?? (flag ? LarRealtimeAppId : XplayRealtimeAppId);
			appSettings.AppIdVoice = hostResult?.voiceAppId ?? (flag ? LarVoiceAppId : XplayVoiceAppId);
			appSettings.AppVersion = XplayVersion;
			if (hostResult != null && !string.IsNullOrEmpty(hostResult.appVersion) && hostResult.appVersion != XplayVersion)
			{
				Debug.LogError("[Crossplay] Placement wants appVersion '" + hostResult.appVersion + "' but this build is 'ag-xplay-1'. Using the build's — fix the worker's AG_APP_VERSION.");
			}
			ApplyCrossplayVoiceSettings(appSettings);
			Manager.State = ConnectionState.Connecting;
			PhotonNetwork.ConnectUsingSettings(appSettings);
		}

		private static void ApplyCrossplayVoiceSettings(AppSettings source)
		{
			_crossplayVoiceSettings = source;
			PunVoiceClient[] array = UnityEngine.Object.FindObjectsByType<PunVoiceClient>(FindObjectsSortMode.None);
			foreach (PunVoiceClient client in array)
			{
				ConfigureVoiceClient(client, source);
			}
		}

		private static void ConfigureVoiceClient(PunVoiceClient client, AppSettings source)
		{
			if (client == null)
			{
				return;
			}
			if (source == null)
			{
				client.UsePunAppSettings = true;
				return;
			}
			if (client.Settings == null)
			{
				client.Settings = new AppSettings();
			}
			source.CopyTo(client.Settings);
			client.UsePunAppSettings = false;
			if (!string.IsNullOrEmpty(PhotonNetwork.CloudRegion))
			{
				client.Settings.FixedRegion = PhotonNetwork.CloudRegion;
			}
			if (client.Client != null)
			{
				client.Client.ServerPortOverrides = PhotonNetwork.ServerPortOverrides;
				client.Client.SerializationProtocol = PhotonNetwork.NetworkingClient.SerializationProtocol;
			}
		}

		public static void JoinCrossplayPrivateRoom(string roomName, int maxPlayers, ExitGames.Client.Photon.Hashtable roomProperties = null)
		{
			CrossplayProfile activeCrossplayProfile = ActiveCrossplayProfile;
			if (activeCrossplayProfile == null || string.IsNullOrEmpty(roomName) || maxPlayers <= 0)
			{
				Debug.LogError(string.Format("[Crossplay] JoinCrossplayPrivateRoom('{0}', {1}) needs a crossplay scene, a name and a size. Ignored.", roomName, maxPlayers));
				return;
			}
			_xplayRequest = XplayRequest.Private;
			_xplayRoom = CrossplayProfiles.PrivateRoomName(activeCrossplayProfile, roomName);
			_xplayMaxPlayers = maxPlayers;
			_xplayProps = CrossplayProfiles.PrivateRoomProperties(activeCrossplayProfile, roomProperties);
			RequestCrossplayJoin();
		}

		public static void JoinCrossplayHub()
		{
			if (ActiveCrossplayProfile != null)
			{
				ClearCrossplayRequest();
				_xplayRequest = XplayRequest.Hub;
				RequestCrossplayJoin();
			}
		}

		private static void ClearCrossplayRequest()
		{
			_xplayRequest = XplayRequest.None;
			_xplayRoom = null;
			_xplayMaxPlayers = 0;
			_xplayProps = null;
		}

		private static void RequestCrossplayJoin()
		{
			Manager.State = ConnectionState.JoiningRoom;
			if (PhotonNetwork.InRoom)
			{
				PhotonNetwork.LeaveRoom();
			}
			else if (!PhotonNetwork.IsConnected)
			{
				ConnectCrossplay();
			}
			else if (!_crossplayLink)
			{
				PhotonNetwork.Disconnect();
			}
			else if (IsOnMasterServer)
			{
				DoCrossplayJoin();
			}
		}

		private static void DoCrossplayJoin()
		{
			if (IsOnMasterServer)
			{
				if (_xplayRequest == XplayRequest.Private)
				{
					DoJoinCrossplayPrivateRoom();
					return;
				}
				ClearCrossplayRequest();
				DoJoinCrossplayHub();
			}
		}

		private static void DoJoinCrossplayHub()
		{
			CrossplayProfile activeCrossplayProfile = ActiveCrossplayProfile;
			if (activeCrossplayProfile == null)
			{
				Debug.LogError(string.Format("[Crossplay] Crossplay mode {0} is unknown to this build. Not joining.", Manager.crossplayMode));
				return;
			}
			Manager.State = ConnectionState.JoiningRoom;
			ExitGames.Client.Photon.Hashtable hashtable = CrossplayProfiles.HubFilter(activeCrossplayProfile);
			Manager.options = NewRoomOptions(activeCrossplayProfile.HubRoomLimit, true, hashtable, CrossplayProfiles.HubLobbyKeys());
			PhotonNetwork.JoinRandomRoom(hashtable, (byte)activeCrossplayProfile.HubRoomLimit, activeCrossplayProfile.Matchmaking, null, null);
		}

		private static void DoJoinCrossplayPrivateRoom()
		{
			string xplayRoom = _xplayRoom;
			RoomOptions roomOptions = NewRoomOptions(_xplayMaxPlayers, false, _xplayProps);
			ClearCrossplayRequest();
			Manager.State = ConnectionState.JoiningRoom;
			_xplayPrivateInFlight = true;
			PhotonNetwork.JoinOrCreateRoom(xplayRoom, roomOptions, null);
		}

		private static bool CrossplayRequestUnmet()
		{
			Room currentRoom = PhotonNetwork.CurrentRoom;
			switch (_xplayRequest)
			{
			case XplayRequest.Hub:
				if (currentRoom != null)
				{
					return !currentRoom.IsVisible;
				}
				return true;
			case XplayRequest.Private:
				if (currentRoom != null)
				{
					return currentRoom.Name != _xplayRoom;
				}
				return true;
			default:
				return false;
			}
		}

		private static void ReturnToNativeApp()
		{
			_returningToNative = true;
			Manager.State = ConnectionState.JoiningRoom;
			PhotonNetwork.Disconnect();
		}

		public static void SetUsername(string Name)
		{
			PhotonNetwork.LocalPlayer.NickName = Name;
			PlayerPrefs.SetString("Username", Name);
			TrySetLocalProps(new ExitGames.Client.Photon.Hashtable { ["Username"] = Name });
			if (PhotonNetwork.InRoom && Manager.LocalPlayer != null)
			{
				Manager.LocalPlayer.RefreshPlayerValues();
			}
		}

		public static void SetColour(Color PlayerColour)
		{
			Manager.Colour = PlayerColour;
			TrySetLocalProps(new ExitGames.Client.Photon.Hashtable { ["Colour"] = JsonUtility.ToJson(PlayerColour) });
			PlayerPrefs.SetString("Colour", JsonUtility.ToJson(PlayerColour));
			if (PhotonNetwork.InRoom && Manager.LocalPlayer != null)
			{
				Manager.LocalPlayer.RefreshPlayerValues();
			}
		}

		public static void SetCosmetics(Dictionary<string, string> PlayerCosmetics)
		{
			Manager.Cosmetics = PlayerCosmetics;
			Dictionary<string, string> value = new Dictionary<string, string>(Manager.Cosmetics);
			TrySetLocalProps(new ExitGames.Client.Photon.Hashtable { ["Cosmetics"] = value });
			MonkeDevNetworkingValueSaver.SaveDictionary("Cosmetics", Manager.Cosmetics);
			if (PhotonNetwork.InRoom && Manager.LocalPlayer != null)
			{
				Manager.LocalPlayer.RefreshPlayerValues();
			}
		}

		public static void SetCosmetic(string Type, string CosmeticId)
		{
			Manager.Cosmetics[Type] = CosmeticId;
			Dictionary<string, string> value = new Dictionary<string, string>(Manager.Cosmetics);
			TrySetLocalProps(new ExitGames.Client.Photon.Hashtable { ["Cosmetics"] = value });
			MonkeDevNetworkingValueSaver.SaveDictionary("Cosmetics", Manager.Cosmetics);
			if (PhotonNetwork.InRoom && Manager.LocalPlayer != null)
			{
				Manager.LocalPlayer.UpdateSingleCosmetic(Type, CosmeticId);
				Manager.LocalPlayer.photonView.RPC("RPC_UpdateSingleCosmetic", RpcTarget.All, Type, CosmeticId);
			}
		}

		public static void TrySetLocalProps(ExitGames.Client.Photon.Hashtable props)
		{
			if (props != null && props.Count != 0 && PhotonNetwork.IsConnectedAndReady)
			{
				PhotonNetwork.LocalPlayer.SetCustomProperties(props);
			}
		}

		public override void OnConnectedToMaster()
		{
			State = ConnectionState.Connected;
			ApplyCrossplayVoiceSettings(_crossplayLink ? _crossplayVoiceSettings : null);
			if (!string.IsNullOrEmpty(_pendingUserId))
			{
				PhotonNetwork.AuthValues = new AuthenticationValues(_pendingUserId);
				_pendingUserId = null;
			}
			PhotonNetwork.LocalPlayer.NickName = PlayerPrefs.GetString("Username");
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
			hashtable["Colour"] = JsonUtility.ToJson(Colour);
			hashtable["Cosmetics"] = Cosmetics;
			hashtable["OculusUsername"] = ((LethalApeR.PlayFab.OculusAuthManager.Instance != null && !string.IsNullOrEmpty(LethalApeR.PlayFab.OculusAuthManager.Instance.OculusUsername)) ? LethalApeR.PlayFab.OculusAuthManager.Instance.OculusUsername : "");
			PhotonNetwork.LocalPlayer.SetCustomProperties(hashtable);
			if (_handoffPending)
			{
				if (_handoffFrom != this)
				{
					JoinForHandoff();
				}
				return;
			}
			if (Manager.crossplay && _crossplayLink)
			{
				DoCrossplayJoin();
				return;
			}
			if (!string.IsNullOrEmpty(_pendingPrivateJoinCode))
			{
				string pendingPrivateJoinCode = _pendingPrivateJoinCode;
				int pendingPrivateJoinMaxPlayers = _pendingPrivateJoinMaxPlayers;
				_pendingPrivateJoinCode = null;
				_pendingPrivateJoinMaxPlayers = 0;
				DoJoinPrivateRoom(pendingPrivateJoinCode, pendingPrivateJoinMaxPlayers);
				return;
			}
			if (!string.IsNullOrEmpty(_pendingNamedJoin))
			{
				string pendingNamedJoin = _pendingNamedJoin;
				_pendingNamedJoin = null;
				DoJoinNamedRoom(pendingNamedJoin);
				return;
			}
			if (!string.IsNullOrEmpty(_pendingRandomJoinQueue))
			{
				string pendingRandomJoinQueue = _pendingRandomJoinQueue;
				int pendingRandomJoinMaxPlayers = _pendingRandomJoinMaxPlayers;
				_pendingRandomJoinQueue = null;
				_pendingRandomJoinMaxPlayers = 0;
				DoJoinRandomRoom(pendingRandomJoinQueue, pendingRandomJoinMaxPlayers);
				return;
			}
			if (JoinRoomOnConnect && !hasJoinedRoomOnConnect)
			{
				hasJoinedRoomOnConnect = true;
				_JoinRandomRoom(DefaultQueue, DefaultRoomLimit);
			}
		}

		public static void JoinRandomRoom(string Queue, int MaxPlayers)
		{
			_JoinRandomRoom(Queue, MaxPlayers);
		}

		public static void JoinRandomRoom(string Queue)
		{
			_JoinRandomRoom(Queue, Manager.DefaultRoomLimit);
		}

		private static void _JoinRandomRoom(string Queue, int MaxPlayers)
		{
			if (Manager.crossplay)
			{
				if (PhotonNetwork.IsConnected && _crossplayLink)
				{
					DoCrossplayJoin();
				}
				else if (PhotonNetwork.IsConnected)
				{
					PhotonNetwork.Disconnect();
				}
				else
				{
					ConnectCrossplay();
				}
			}
			else if (_crossplayLink && PhotonNetwork.IsConnected)
			{
				_pendingRandomJoinQueue = Queue;
				_pendingRandomJoinMaxPlayers = MaxPlayers;
				ReturnToNativeApp();
			}
			else if (PhotonNetwork.InRoom)
			{
				_pendingRandomJoinQueue = Queue;
				_pendingRandomJoinMaxPlayers = MaxPlayers;
				Manager.State = ConnectionState.JoiningRoom;
				PhotonNetwork.LeaveRoom();
			}
			else
			{
				DoJoinRandomRoom(Queue, MaxPlayers);
			}
		}

		private static RoomOptions NewRoomOptions(int maxPlayers, bool visible, ExitGames.Client.Photon.Hashtable props = null, string[] lobbyProps = null)
		{
			ExitGames.Client.Photon.Hashtable hashtable = props;
			ExitGames.Client.Photon.Hashtable hashtable2 = ExtraRoomProperties?.Invoke();
			if (hashtable2 != null && hashtable2.Count > 0)
			{
				hashtable = new ExitGames.Client.Photon.Hashtable();
				if (props != null)
				{
					foreach (DictionaryEntry prop in props)
					{
						hashtable[prop.Key] = prop.Value;
					}
				}
				List<string> list = new List<string>(lobbyProps ?? Array.Empty<string>());
				foreach (DictionaryEntry item in hashtable2)
				{
					hashtable[item.Key] = item.Value;
					if (item.Key is string text && !list.Contains(text))
					{
						list.Add(text);
					}
				}
				lobbyProps = list.ToArray();
			}
			return new RoomOptions
			{
				MaxPlayers = (byte)maxPlayers,
				IsVisible = visible,
				IsOpen = true,
				CustomRoomProperties = hashtable,
				CustomRoomPropertiesForLobby = lobbyProps,
				PublishUserId = true
			};
		}

		private static void DoJoinRandomRoom(string Queue, int MaxPlayers)
		{
			Manager.State = ConnectionState.JoiningRoom;
			ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable
			{
				{ "queue", Queue },
				{ "version", Application.version },
				{ "antiunity", "Okay" },
				{ "yr", "2025" }
			};
			string[] lobbyProps = new string[4] { "queue", "version", "antiunity", "yr" };
			RoomOptions roomOptions = NewRoomOptions(MaxPlayers, true, hashtable, lobbyProps);
			Manager.options = roomOptions;
			PhotonNetwork.JoinRandomRoom(hashtable, roomOptions.MaxPlayers, MatchmakingMode.RandomMatching, null, null);
		}

		public static void JoinPrivateRoom(string RoomId, int MaxPlayers)
		{
			_JoinPrivateRoom(RoomId, MaxPlayers);
		}

		public static void JoinPrivateRoom(string RoomId)
		{
			_JoinPrivateRoom(RoomId, Manager.DefaultRoomLimit);
		}

		private static string SaltCodeForVersion(string raw)
		{
			return raw + "_v" + Application.version;
		}

		public static string SalvageDisplayCode(string roomName)
		{
			if (string.IsNullOrEmpty(roomName))
			{
				return roomName;
			}
			int num = roomName.IndexOf("_v", StringComparison.Ordinal);
			if (num > 0)
			{
				return roomName.Substring(0, num);
			}
			return roomName;
		}

		public static void _JoinPrivateRoom(string RoomId, int MaxPlayers)
		{
			string text = SaltCodeForVersion(RoomId);
			if (!Manager.crossplay && _crossplayLink && PhotonNetwork.IsConnected)
			{
				_pendingPrivateJoinCode = text;
				_pendingPrivateJoinMaxPlayers = MaxPlayers;
				ReturnToNativeApp();
			}
			else if (PhotonNetwork.InRoom)
			{
				_pendingPrivateJoinCode = text;
				_pendingPrivateJoinMaxPlayers = MaxPlayers;
				PhotonNetwork.LeaveRoom();
			}
			else
			{
				DoJoinPrivateRoom(text, MaxPlayers);
			}
		}

		public static void JoinRoomByName(string roomName)
		{
			if (string.IsNullOrEmpty(roomName) || Manager == null || Manager.crossplay)
			{
				return;
			}
			if (_crossplayLink && PhotonNetwork.IsConnected)
			{
				_pendingNamedJoin = roomName;
				ReturnToNativeApp();
			}
			else if (PhotonNetwork.InRoom)
			{
				_pendingNamedJoin = roomName;
				Manager.State = ConnectionState.JoiningRoom;
				PhotonNetwork.LeaveRoom();
			}
			else
			{
				DoJoinNamedRoom(roomName);
			}
		}

		private static void DoJoinNamedRoom(string roomName)
		{
			Manager.State = ConnectionState.JoiningRoom;
			PhotonNetwork.JoinRoom(roomName);
		}

		public override void OnJoinRoomFailed(short returnCode, string message)
		{
			State = ConnectionState.Connected;
			MonkeDevNetworkingManager.RoomJoinFailed?.Invoke(returnCode, message);
			if (_xplayPrivateInFlight)
			{
				_xplayPrivateInFlight = false;
				if (crossplay && _crossplayLink)
				{
					DoCrossplayJoin();
				}
			}
		}

		public override void OnCreateRoomFailed(short returnCode, string message)
		{
			State = ConnectionState.Connected;
			MonkeDevNetworkingManager.RoomJoinFailed?.Invoke(returnCode, message);
		}

		private static void DoJoinPrivateRoom(string saltedCode, int MaxPlayers)
		{
			PhotonNetwork.JoinOrCreateRoom(saltedCode, NewRoomOptions(MaxPlayers, false), null);
		}

		public override void OnJoinedRoom()
		{
			State = ConnectionState.InRoom;
			if (_handoffPending)
			{
				Debug.Log("[MonkeDevNetworkingManager] Leaving '" + PhotonNetwork.CurrentRoom?.Name + "', joined mid scene switch.");
				State = ConnectionState.JoiningRoom;
				PhotonNetwork.LeaveRoom();
				return;
			}
			_xplayPrivateInFlight = false;
			if (CrossplayRequestUnmet())
			{
				Debug.Log("[Crossplay] Leaving '" + PhotonNetwork.CurrentRoom?.Name + "' for a join requested mid-join.");
				State = ConnectionState.JoiningRoom;
				PhotonNetwork.LeaveRoom();
				return;
			}
			ClearCrossplayRequest();
			if (CheckRoomPublishesUserIds())
			{
				StartCoroutine(DeferredOculusPresenceUpdate());
			}
		}

		private bool CheckRoomPublishesUserIds()
		{
			if (PhotonNetwork.OfflineMode)
			{
				return true;
			}
			Room currentRoom = PhotonNetwork.CurrentRoom;
			if (currentRoom == null || currentRoom.PublishUserId)
			{
				IdentityHidden = false;
				_darkRoomLeaves = 0;
				return true;
			}
			IdentityHidden = true;
			Debug.LogError("[Security] Room '" + currentRoom.Name + "' was created with PublishUserId OFF — no player in it can be identified. This build cannot create such a room (see NewRoomOptions), so the host is running a patched client.");
			if (!currentRoom.IsVisible)
			{
				return true;
			}
			if (_darkRoomLeaves >= MaxDarkRoomLeaves)
			{
				Debug.LogError("[Security] Still landing in rooms that hide user ids after " + $"{_darkRoomLeaves} attempts — staying put rather than making " + "matchmaking a dead end. IdentityHidden remains set.");
				return true;
			}
			_darkRoomLeaves++;
			if (!Manager.crossplay)
			{
				string text = DefaultQueue;
				if (currentRoom.CustomProperties != null && currentRoom.CustomProperties.ContainsKey("queue"))
				{
					text = currentRoom.CustomProperties["queue"]?.ToString() ?? DefaultQueue;
				}
				_pendingRandomJoinQueue = text;
				_pendingRandomJoinMaxPlayers = ((currentRoom.MaxPlayers > 0) ? currentRoom.MaxPlayers : DefaultRoomLimit);
			}
			State = ConnectionState.JoiningRoom;
			PhotonNetwork.LeaveRoom();
			return false;
		}

		private IEnumerator DeferredOculusPresenceUpdate()
		{
			yield return new WaitForSeconds(2f);
			RequestPresenceUpdate();
		}

		private void RequestPresenceUpdate()
		{
			float num = Time.unscaledTime - _lastPresenceUpdateTime;
			if (num >= PresenceUpdateMinInterval)
			{
				_lastPresenceUpdateTime = Time.unscaledTime;
				UpdateOculusPresence();
			}
			else if (_pendingPresenceUpdate == null)
			{
				_pendingPresenceUpdate = StartCoroutine(DeferredPresenceUpdate(PresenceUpdateMinInterval - num));
			}
		}

		private IEnumerator DeferredPresenceUpdate(float delay)
		{
			yield return new WaitForSeconds(delay);
			_pendingPresenceUpdate = null;
			_lastPresenceUpdateTime = Time.unscaledTime;
			UpdateOculusPresence();
		}

		public override void OnDisconnected(DisconnectCause cause)
		{
			State = ConnectionState.Disconnected;
			bool reconnectWithAuth = _reconnectWithAuth;
			_connectAuthenticated = false;
			if (reconnectWithAuth)
			{
				string reconnectUserId = _reconnectUserId;
				_reconnectWithAuth = false;
				_reconnectUserId = null;
				Connect(reconnectUserId);
				return;
			}
			Players.RemoveAll((MonkeDevNetworkingPlayer p) => p == null || p.photonView == null || !p.photonView.IsMine);
			if (MonkeDevOculusPresenceManager.Instance != null)
			{
				MonkeDevOculusPresenceManager.Instance.ClearPresence();
			}
			bool returningToNative = _returningToNative;
			_crossplayLink = false;
			_returningToNative = false;
			if (Manager != null && Manager.crossplay)
			{
				ConnectCrossplay();
			}
			else if (returningToNative)
			{
				Connect(_connectUserId);
			}
		}

		public override void OnJoinRandomFailed(short returnCode, string message)
		{
			HandleJoinError();
		}

		private void HandleJoinError()
		{
			RoomOptions roomOptions = options ?? NewRoomOptions(DefaultRoomLimit, true);
			PhotonNetwork.CreateRoom(CreateRoomCode(), roomOptions);
		}

		public string CreateRoomCode()
		{
			StringBuilder stringBuilder = new StringBuilder();
			string text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			for (int i = 0; i < 5; i++)
			{
				stringBuilder.Append(text[UnityEngine.Random.Range(0, text.Length)]);
			}
			return stringBuilder.ToString();
		}

		public MonkeDevNetworkingPlayer GetPlayerByActorId(int ActorId)
		{
			for (int num = Players.Count - 1; num >= 0; num--)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = Players[num];
				if (monkeDevNetworkingPlayer == null)
				{
					Players.RemoveAt(num);
				}
				else if (monkeDevNetworkingPlayer.photonView != null && monkeDevNetworkingPlayer.photonView.OwnerActorNr == ActorId)
				{
					return monkeDevNetworkingPlayer;
				}
			}
			return null;
		}

		private void UpdateOculusPresence()
		{
			try
			{
				if (!(MonkeDevOculusPresenceManager.Instance == null) && PhotonNetwork.InRoom)
				{
					Room currentRoom = PhotonNetwork.CurrentRoom;
					if (currentRoom != null)
					{
						string roomCode = SalvageDisplayCode(currentRoom.Name);
						string queue = DefaultQueue;
						if (currentRoom.CustomProperties != null && currentRoom.CustomProperties.ContainsKey("queue"))
						{
							queue = currentRoom.CustomProperties["queue"].ToString();
						}
						MonkeDevOculusPresenceManager.Instance.SetRoomPresence(roomCode, queue, currentRoom.PlayerCount, currentRoom.MaxPlayers, false);
					}
				}
			}
			catch (Exception ex)
			{
				Debug.LogError("[MonkeDevNetworkingManager] Error updating Oculus presence: " + ex.Message);
			}
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			RequestPresenceUpdate();
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			int actorNr = otherPlayer.ActorNumber;
			Players.RemoveAll((MonkeDevNetworkingPlayer p) => p == null || (p.photonView != null && p.photonView.OwnerActorNr == actorNr));
			RequestPresenceUpdate();
		}

		public override void OnLeftRoom()
		{
			Players.RemoveAll((MonkeDevNetworkingPlayer p) => p == null || p.photonView == null || !p.photonView.IsMine);
			if (MonkeDevOculusPresenceManager.Instance != null)
			{
				MonkeDevOculusPresenceManager.Instance.SetLobbyPresence();
			}
		}
	}
}
