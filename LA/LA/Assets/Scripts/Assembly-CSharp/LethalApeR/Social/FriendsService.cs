using System;
using System.Collections.Generic;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Newtonsoft.Json.Linq;
using Photon.Pun;
using Photon.Realtime;
using QauthSdk;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Social
{
	public sealed class FriendsService : MonoBehaviourPunCallbacks
	{
		public const string RequestsProp = "FriendRequests";

		private const string FnState = "SocialGetState";

		private const string FnRequest = "SocialRequest";

		private const string FnRespond = "SocialRespond";

		private const string FnRemove = "SocialRemove";

		private const string FnPresence = "SocialSetPresence";

		private const string FnJoin = "SocialJoinTarget";

		private const float StateInterval = 120f;

		private const float FreshEnough = 15f;

		private const float HeartbeatInterval = 180f;

		private const float PresenceDebounce = 1.5f;

		private const float RequestsSaveRetry = 30f;

		private readonly List<FriendInfo> _friends = new List<FriendInfo>();

		private readonly List<FriendInfo> _incoming = new List<FriendInfo>();

		private readonly List<FriendInfo> _outgoing = new List<FriendInfo>();

		private readonly Dictionary<string, FriendInfo> _byId = new Dictionary<string, FriendInfo>(StringComparer.Ordinal);

		private readonly HashSet<string> _refusedBy = new HashSet<string>(StringComparer.Ordinal);

		private bool _loggedIn;

		private bool _stateBusy;

		private float _lastState = -999f;

		private float _nextState;

		private bool _presenceDirty = true;

		private float _presenceAt;

		private float _nextHeartbeat;

		private bool _publishedOffline;

		private Color _publishedColour;

		private float _nextColourCheck;

		private bool _joinBusy;

		private Action<JoinOutcome> _pendingJoinDone;

		private PresenceStatus _prefsStatus;

		private bool _prefsJoinable;

		private bool _prefsRequests;

		private float _nextRequestsRetry;

		public static FriendsService Instance { get; private set; }

		public bool Ready { get; private set; }

		public bool Available { get; private set; } = true;

		public int Version { get; private set; }

		public IReadOnlyList<FriendInfo> Friends => _friends;

		public IReadOnlyList<FriendInfo> Incoming => _incoming;

		public IReadOnlyList<FriendInfo> Outgoing => _outgoing;

		public event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			if (!(Instance != null))
			{
				GameObject gameObject = new GameObject("[Social] Friends");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				Instance = gameObject.AddComponent<FriendsService>();
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			_prefsStatus = SocialPrefs.Status;
			_prefsJoinable = SocialPrefs.Joinable;
			_prefsRequests = SocialPrefs.FriendRequests;
			SocialPrefs.Changed += OnPrefsChanged;
			MonkeDevNetworkingManager.RoomJoinFailed += OnRoomJoinFailed;
		}

		public override void OnDisable()
		{
			base.OnDisable();
			SocialPrefs.Changed -= OnPrefsChanged;
			MonkeDevNetworkingManager.RoomJoinFailed -= OnRoomJoinFailed;
		}

		public FriendRelation RelationTo(string userId)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return FriendRelation.None;
			}
			if (_byId.TryGetValue(userId, out var value))
			{
				return value.Relation;
			}
			return FriendRelation.None;
		}

		public FriendInfo Get(string userId)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return null;
			}
			if (!_byId.TryGetValue(userId, out var value))
			{
				return null;
			}
			return value;
		}

		public bool AcceptsRequests(string userId)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return false;
			}
			RosterEntry rosterEntry = SocialRoster.Find(userId);
			if (rosterEntry != null)
			{
				return AcceptsRequests(rosterEntry);
			}
			return !_refusedBy.Contains(userId);
		}

		public bool AcceptsRequests(RosterEntry player)
		{
			if (player.AcceptsRequests && !string.IsNullOrEmpty(player.UserId))
			{
				return !_refusedBy.Contains(player.UserId);
			}
			return false;
		}

		public void RefreshSoon()
		{
			if (Time.unscaledTime - _lastState > 15f)
			{
				_nextState = 0f;
			}
		}

		public void SendRequest(string userId, string displayName)
		{
			if (!CanAct(userId) || BlockList.IsBlocked(userId))
			{
				return;
			}
			FriendRelation friendRelation = RelationTo(userId);
			if (friendRelation != FriendRelation.Friends && friendRelation != FriendRelation.RequestSent)
			{
				if (friendRelation == FriendRelation.RequestReceived)
				{
					Accept(userId);
				}
				else if (AcceptsRequests(userId))
				{
					Upsert(userId, displayName, FriendRelation.RequestSent);
					Call("SocialRequest", Args(userId));
				}
			}
		}

		public void Accept(string userId)
		{
			if (CanAct(userId) && RelationTo(userId) == FriendRelation.RequestReceived)
			{
				Upsert(userId, null, FriendRelation.Friends);
				Call("SocialRespond", Args(userId, ("accept", true)));
			}
		}

		public void Decline(string userId)
		{
			if (CanAct(userId) && RelationTo(userId) == FriendRelation.RequestReceived)
			{
				Drop(userId);
				Call("SocialRespond", Args(userId, ("accept", false)));
			}
		}

		public void Remove(string userId)
		{
			if (CanAct(userId) && RelationTo(userId) != FriendRelation.None)
			{
				Drop(userId);
				Call("SocialRemove", Args(userId));
			}
		}

		public void Block(string userId, string displayName)
		{
			if (!string.IsNullOrEmpty(userId))
			{
				BlockList.Block(userId, displayName);
				if (RelationTo(userId) != FriendRelation.None)
				{
					Remove(userId);
				}
			}
		}

		public void Join(string userId, Action<JoinOutcome> done)
		{
			FriendInfo friendInfo = Get(userId);
			if (friendInfo == null || friendInfo.Relation != FriendRelation.Friends)
			{
				done?.Invoke(JoinOutcome.Unavailable);
				return;
			}
			if (!friendInfo.Online)
			{
				done?.Invoke(JoinOutcome.Offline);
				return;
			}
			if (!friendInfo.Joinable)
			{
				done?.Invoke(JoinOutcome.NotJoinable);
				return;
			}
			if (friendInfo.SceneIndex != SceneManager.GetActiveScene().buildIndex)
			{
				done?.Invoke(JoinOutcome.OtherMode);
				return;
			}
			if (_joinBusy || !Qauth.IsLoggedIn)
			{
				done?.Invoke(JoinOutcome.Busy);
				return;
			}
			_joinBusy = true;
			Run("SocialJoinTarget", Args(userId), delegate(QauthCloudResult result)
			{
				_joinBusy = false;
				if (!TryReply(result, "SocialJoinTarget", out var reply))
				{
					done?.Invoke(JoinOutcome.Unavailable);
				}
				else if (!GetBool(reply, "ok"))
				{
					string text = GetString(reply, "error");
					done?.Invoke((text == "offline") ? JoinOutcome.Offline : JoinOutcome.NotJoinable);
				}
				else
				{
					string text2 = GetString(reply, "room");
					if (GetInt(reply, "scene", -1) != SceneManager.GetActiveScene().buildIndex)
					{
						done?.Invoke(JoinOutcome.OtherMode);
					}
					else
					{
						if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null || PhotonNetwork.CurrentRoom.Name != text2)
						{
							_pendingJoinDone = done;
							MonkeDevNetworkingManager.JoinRoomByName(text2);
						}
						done?.Invoke(JoinOutcome.Joining);
					}
				}
			}, delegate(Exception error)
			{
				_joinBusy = false;
				Debug.LogWarning("[Social] SocialJoinTarget failed: " + error.Message);
				done?.Invoke(JoinOutcome.Unavailable);
			});
		}

		private void OnRoomJoinFailed(short code, string message)
		{
			Action<JoinOutcome> pendingJoinDone = _pendingJoinDone;
			if (pendingJoinDone != null)
			{
				_pendingJoinDone = null;
				pendingJoinDone(JoinOutcome.RoomGone);
			}
		}

		private void Update()
		{
			if (!_loggedIn)
			{
				if (Time.frameCount % 30 != 0 || !Qauth.IsLoggedIn)
				{
					return;
				}
				_loggedIn = true;
				BlockList.SyncWithServer();
				SocialPrefs.SyncWithServer();
				_nextState = 0f;
				_presenceDirty = true;
				_nextRequestsRetry = Time.unscaledTime + 30f;
			}
			else if (!Qauth.IsLoggedIn)
			{
				_loggedIn = false;
				return;
			}
			float unscaledTime = Time.unscaledTime;
			if (unscaledTime >= _nextState && !_stateBusy)
			{
				FetchState();
			}
			if (unscaledTime >= _nextRequestsRetry)
			{
				_nextRequestsRetry = unscaledTime + 30f;
				SocialPrefs.RetryUnsaved();
			}
			if (unscaledTime >= _nextColourCheck)
			{
				_nextColourCheck = unscaledTime + 5f;
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				if (manager != null && manager.Colour != _publishedColour)
				{
					MarkPresenceDirty();
				}
			}
			PresenceStatus status = SocialPrefs.Status;
			if ((_presenceDirty && unscaledTime >= _presenceAt) || (status != PresenceStatus.AppearOffline && unscaledTime >= _nextHeartbeat))
			{
				PublishPresence();
			}
		}

		private void OnPrefsChanged()
		{
			if (_prefsRequests != SocialPrefs.FriendRequests)
			{
				_prefsRequests = SocialPrefs.FriendRequests;
				PublishRequests();
			}
			if (SocialPrefs.Status != _prefsStatus || SocialPrefs.Joinable != _prefsJoinable)
			{
				_prefsStatus = SocialPrefs.Status;
				_prefsJoinable = SocialPrefs.Joinable;
				MarkPresenceDirty();
				_publishedOffline = false;
			}
		}

		private void PublishRequests()
		{
			if (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null)
			{
				PhotonNetwork.LocalPlayer.SetCustomProperties(new Hashtable { { "FriendRequests", SocialPrefs.FriendRequests } });
			}
		}

		private void MarkPresenceDirty()
		{
			_presenceDirty = true;
			_presenceAt = Time.unscaledTime + 1.5f;
		}

		public override void OnJoinedRoom()
		{
			PublishRequests();
			SocialRoster.MarkDirty();
			MarkPresenceDirty();
		}

		public override void OnLeftRoom()
		{
			SocialRoster.MarkDirty();
			MarkPresenceDirty();
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			SocialRoster.MarkDirty();
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			SocialRoster.MarkDirty();
		}

		public override void OnPlayerPropertiesUpdate(Player target, Hashtable changed)
		{
			SocialRoster.MarkDirty();
			if (target != null && changed != null && changed.ContainsKey("FriendRequests") && _refusedBy.Remove(target.UserId ?? ""))
			{
				Notify();
			}
		}

		private void OnApplicationQuit()
		{
			if (_loggedIn && SocialPrefs.Status != PresenceStatus.AppearOffline)
			{
				SendPresence(0, joinable: false, null);
			}
		}

		private void PublishPresence()
		{
			_presenceDirty = false;
			_nextHeartbeat = Time.unscaledTime + 180f;
			if (!_loggedIn)
			{
				return;
			}
			PresenceStatus status = SocialPrefs.Status;
			if (status == PresenceStatus.AppearOffline)
			{
				if (!_publishedOffline)
				{
					_publishedOffline = true;
					SendPresence(0, joinable: false, null);
				}
				return;
			}
			_publishedOffline = false;
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Room room = (PhotonNetwork.InRoom ? PhotonNetwork.CurrentRoom : null);
			bool flag = SocialPrefs.Joinable && room != null && (manager == null || !manager.crossplay);
			string room2 = (flag ? PhotonNetwork.CurrentRoom.Name : null);
			SendPresence((status == PresenceStatus.Away) ? 2 : 1, flag, room2);
		}

		private void SendPresence(int wireStatus, bool joinable, string room)
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Color color = ((manager != null) ? manager.Colour : Color.white);
			_publishedColour = color;
			Run("SocialSetPresence", new Dictionary<string, object>
			{
				{ "st", wireStatus },
				{ "join", joinable },
				{
					"scene",
					Mathf.Clamp(SceneManager.GetActiveScene().buildIndex, 0, 255)
				},
				{
					"color",
					PackColour(color)
				},
				{
					"room",
					room ?? ""
				}
			}, delegate(QauthCloudResult result)
			{
				TryReply(result, "SocialSetPresence", out var _);
			}, delegate(Exception error)
			{
				Debug.LogWarning("[Social] Presence update failed: " + error.Message);
			});
		}

		private void FetchState()
		{
			if (Qauth.IsLoggedIn)
			{
				_stateBusy = true;
				_nextState = Time.unscaledTime + 120f;
				Run("SocialGetState", null, delegate(QauthCloudResult result)
				{
					_stateBusy = false;
					if (TryReply(result, "SocialGetState", out var reply))
					{
						ApplyState(reply);
					}
				}, delegate(Exception error)
				{
					_stateBusy = false;
					Debug.LogWarning("[Social] SocialGetState failed: " + error.Message);
				});
			}
		}

		private void Call(string function, Dictionary<string, object> args)
		{
			Run(function, args, delegate(QauthCloudResult result)
			{
				if (TryReply(result, function, out var reply))
				{
					if (!GetBool(reply, "ok"))
					{
						string text = GetString(reply, "error");
						if (text == "not_accepting" && args.TryGetValue("target", out var value) && value is string item)
						{
							_refusedBy.Add(item);
						}
						else
						{
							Debug.LogWarning("[Social] " + function + " refused: " + text);
						}
					}
					if (reply.TryGetValue("state", out var value2) && value2 is IDictionary<string, object> state)
					{
						ApplyState(state);
					}
				}
			}, delegate(Exception error)
			{
				Debug.LogWarning("[Social] " + function + " failed: " + error.Message);
				_nextState = 0f;
			});
		}

		private static async void Run(string function, object args, Action<QauthCloudResult> onResult, Action<Exception> onError)
		{
			QauthCloudResult result;
			try
			{
				result = await Qauth.CloudScript.RunAsync(function, args);
			}
			catch (Exception obj)
			{
				onError?.Invoke(obj);
				return;
			}
			onResult?.Invoke(result);
		}

		private bool TryReply(QauthCloudResult result, string function, out IDictionary<string, object> reply)
		{
			reply = null;
			if (result == null || !result.Ok)
			{
				string text = result?.Error ?? "no result";
				if (text == "UNKNOWN_FUNCTION")
				{
					if (Available)
					{
						Debug.LogError("[Social] " + function + " is not on the server's Cloud Script.");
					}
					Available = false;
					Notify();
					return false;
				}
				Debug.LogError("[Social] " + function + " threw: " + text);
				return false;
			}
			if (!Available)
			{
				Available = true;
				Notify();
			}
			reply = ToPlain(result.Result) as IDictionary<string, object>;
			return reply != null;
		}

		private static object ToPlain(JToken token)
		{
			if (token == null)
			{
				return null;
			}
			switch (token.Type)
			{
			case JTokenType.Object:
			{
				Dictionary<string, object> dictionary = new Dictionary<string, object>();
				foreach (JProperty item in ((JObject)token).Properties())
				{
					dictionary[item.Name] = ToPlain(item.Value);
				}
				return dictionary;
			}
			case JTokenType.Array:
			{
				List<object> list = new List<object>();
				foreach (JToken item2 in (JArray)token)
				{
					list.Add(ToPlain(item2));
				}
				return list;
			}
			case JTokenType.Null:
			case JTokenType.Undefined:
				return null;
			default:
				return ((JValue)token).Value;
			}
		}

		private void ApplyState(IDictionary<string, object> state)
		{
			_lastState = Time.unscaledTime;
			_friends.Clear();
			_incoming.Clear();
			_outgoing.Clear();
			_byId.Clear();
			if (state.TryGetValue("friends", out var value) && value is IList<object> list)
			{
				foreach (object item in list)
				{
					if (!(item is IDictionary<string, object> d))
					{
						continue;
					}
					string text = GetString(d, "id");
					if (string.IsNullOrEmpty(text))
					{
						continue;
					}
					FriendInfo friendInfo = new FriendInfo
					{
						Id = text,
						Name = SocialText.CleanName(GetString(d, "name")),
						Relation = ParseRelation(GetString(d, "rel")),
						Online = GetBool(d, "online"),
						Joinable = GetBool(d, "join"),
						SceneIndex = GetInt(d, "scene", -1),
						Status = ((GetInt(d, "st", 0) == 2) ? PresenceStatus.Away : PresenceStatus.Online)
					};
					int num = GetInt(d, "color", -1);
					if (num >= 0)
					{
						friendInfo.Colour = UnpackColour(num);
					}
					if (friendInfo.Relation == FriendRelation.RequestReceived)
					{
						if (BlockList.IsBlocked(text))
						{
							continue;
						}
					}
					else if (friendInfo.Relation == FriendRelation.None)
					{
						continue;
					}
					Add(friendInfo);
				}
			}
			_friends.Sort(CompareFriends);
			Ready = true;
			Notify();
		}

		private static int CompareFriends(FriendInfo a, FriendInfo b)
		{
			if (a.Online != b.Online)
			{
				if (!a.Online)
				{
					return 1;
				}
				return -1;
			}
			return string.CompareOrdinal(a.Name, b.Name);
		}

		private void Upsert(string userId, string displayName, FriendRelation relation)
		{
			FriendInfo friendInfo = Get(userId);
			if (friendInfo != null)
			{
				RemoveFromLists(friendInfo);
			}
			else
			{
				friendInfo = new FriendInfo
				{
					Id = userId,
					Name = SocialText.CleanName(displayName)
				};
			}
			if (!string.IsNullOrEmpty(displayName))
			{
				friendInfo.Name = SocialText.CleanName(displayName);
			}
			friendInfo.Relation = relation;
			Add(friendInfo);
			_friends.Sort(CompareFriends);
			Notify();
		}

		private void Drop(string userId)
		{
			FriendInfo friendInfo = Get(userId);
			if (friendInfo != null)
			{
				RemoveFromLists(friendInfo);
				_byId.Remove(userId);
				Notify();
			}
		}

		private void Add(FriendInfo info)
		{
			_byId[info.Id] = info;
			switch (info.Relation)
			{
			case FriendRelation.Friends:
				_friends.Add(info);
				break;
			case FriendRelation.RequestSent:
				_outgoing.Add(info);
				break;
			case FriendRelation.RequestReceived:
				_incoming.Add(info);
				break;
			}
		}

		private void RemoveFromLists(FriendInfo info)
		{
			_friends.Remove(info);
			_incoming.Remove(info);
			_outgoing.Remove(info);
		}

		private void Notify()
		{
			Version++;
			this.Changed?.Invoke();
		}

		private bool CanAct(string userId)
		{
			if (string.IsNullOrEmpty(userId) || !Available || !Qauth.IsLoggedIn)
			{
				return false;
			}
			Player localPlayer = PhotonNetwork.LocalPlayer;
			if (localPlayer != null)
			{
				return localPlayer.UserId != userId;
			}
			return true;
		}

		private static Dictionary<string, object> Args(string target, params (string key, object value)[] extra)
		{
			Dictionary<string, object> dictionary = new Dictionary<string, object> { { "target", target } };
			for (int i = 0; i < extra.Length; i++)
			{
				(string key, object value) tuple = extra[i];
				dictionary[tuple.key] = tuple.value;
			}
			return dictionary;
		}

		private static FriendRelation ParseRelation(string rel)
		{
			if (rel == "friend")
			{
				return FriendRelation.Friends;
			}
			if (rel == "sent")
			{
				return FriendRelation.RequestSent;
			}
			if (!(rel == "received"))
			{
				return FriendRelation.None;
			}
			return FriendRelation.RequestReceived;
		}

		public static int PackColour(Color c)
		{
			int num = Mathf.Clamp(Mathf.RoundToInt(c.r * 255f), 0, 255);
			int num2 = Mathf.Clamp(Mathf.RoundToInt(c.g * 255f), 0, 255);
			int num3 = Mathf.Clamp(Mathf.RoundToInt(c.b * 255f), 0, 255);
			return (num << 16) | (num2 << 8) | num3;
		}

		public static Color UnpackColour(int packed)
		{
			return new Color((float)((packed >> 16) & 0xFF) / 255f, (float)((packed >> 8) & 0xFF) / 255f, (float)(packed & 0xFF) / 255f, 1f);
		}

		private static string GetString(IDictionary<string, object> d, string key)
		{
			if (!d.TryGetValue(key, out var value) || value == null)
			{
				return "";
			}
			return value.ToString();
		}

		private static bool GetBool(IDictionary<string, object> d, string key)
		{
			if (d.TryGetValue(key, out var value) && value is bool)
			{
				return (bool)value;
			}
			return false;
		}

		private static int GetInt(IDictionary<string, object> d, string key, int fallback)
		{
			if (!d.TryGetValue(key, out var value) || value == null)
			{
				return fallback;
			}
			try
			{
				return Convert.ToInt32(value);
			}
			catch (Exception)
			{
				return fallback;
			}
		}
	}
}
