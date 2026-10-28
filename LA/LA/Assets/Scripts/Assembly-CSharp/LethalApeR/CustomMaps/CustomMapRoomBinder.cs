using System;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[DisallowMultipleComponent]
	public sealed class CustomMapRoomBinder : MonoBehaviourPunCallbacks
	{
		[SerializeField]
		private CustomMapHost host;

		private string _builtinQueue;

		private int _builtinLimit;

		private bool _captured;

		private MapPackage _armed;

		private MapPackage _joining;

		public static CustomMapRoomBinder Instance { get; private set; }

		public string BuiltinQueue => Capture() ? _builtinQueue : "Sandbox";

		public bool Busy
		{
			get
			{
				if (_joining != null)
				{
					return true;
				}
				if (host != null)
				{
					if (host.State != CustomMapHost.HostState.Loading)
					{
						return host.State == CustomMapHost.HostState.Unloading;
					}
					return true;
				}
				return false;
			}
		}

		public event Action<string> Notice;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				base.enabled = false;
				return;
			}
			Instance = this;
			if (host == null)
			{
				host = GetComponent<CustomMapHost>();
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			MonkeDevNetworkingManager.RoomJoinFailed += OnRoomJoinFailed;
		}

		public override void OnDisable()
		{
			base.OnDisable();
			MonkeDevNetworkingManager.RoomJoinFailed -= OnRoomJoinFailed;
		}

		private void OnDestroy()
		{
			Disarm();
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private bool Capture()
		{
			if (_captured)
			{
				return true;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return false;
			}
			_builtinQueue = manager.DefaultQueue;
			_builtinLimit = manager.DefaultRoomLimit;
			_captured = true;
			return true;
		}

		private void Arm(MapPackage map)
		{
			if (Capture())
			{
				_armed = map;
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				manager.DefaultQueue = MapRoomProps.QueueFor(_builtinQueue, map);
				manager.DefaultRoomLimit = map.MaxPlayers;
				MonkeDevNetworkingManager.ExtraRoomProperties = ArmedProperties;
			}
		}

		private Hashtable ArmedProperties()
		{
			if (_armed == null)
			{
				return null;
			}
			return MapRoomProps.For(_armed);
		}

		private void Disarm()
		{
			_armed = null;
			if (MonkeDevNetworkingManager.ExtraRoomProperties == new Func<Hashtable>(ArmedProperties))
			{
				MonkeDevNetworkingManager.ExtraRoomProperties = null;
			}
			if (_captured && MonkeDevNetworkingManager.Manager != null)
			{
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				manager.DefaultQueue = _builtinQueue;
				manager.DefaultRoomLimit = _builtinLimit;
			}
		}

		public bool PlayMap(MapPackage map)
		{
			if (map == null || Busy || !Capture())
			{
				return false;
			}
			return LoadThen(map, delegate
			{
				MonkeDevNetworkingManager.JoinRandomRoom(MapRoomProps.QueueFor(_builtinQueue, map), map.MaxPlayers);
			});
		}

		public bool PlayMapPrivate(MapPackage map, string code)
		{
			if (map == null || string.IsNullOrWhiteSpace(code) || Busy || !Capture())
			{
				return false;
			}
			return LoadThen(map, delegate
			{
				MonkeDevNetworkingManager.JoinPrivateRoom(code.Trim().ToUpperInvariant(), map.MaxPlayers);
			});
		}

		public bool JoinListedRoom(RoomInfo room)
		{
			if (room == null || Busy || !Capture())
			{
				return false;
			}
			string text = MapRoomProps.KeyOf(room);
			if (string.IsNullOrEmpty(text))
			{
				MonkeDevNetworkingManager.JoinRoomByName(room.Name);
				return true;
			}
			MapPackage mapPackage = MapCatalog.Find(text);
			if (mapPackage == null)
			{
				this.Notice?.Invoke("You don't have " + (MapRoomProps.NameOf(room) ?? "that map") + " yet.");
				return false;
			}
			return LoadThen(mapPackage, delegate
			{
				MonkeDevNetworkingManager.JoinRoomByName(room.Name);
			});
		}

		public bool LeaveCustomMap()
		{
			if (host == null || host.Current == null || Busy || !Capture())
			{
				return false;
			}
			Disarm();
			return host.UnloadMap(delegate
			{
				MonkeDevNetworkingManager.JoinRandomRoom(_builtinQueue, _builtinLimit);
			});
		}

		private bool LoadThen(MapPackage map, Action join)
		{
			_joining = map;
			Arm(map);
			if (host.IsLoaded(map.Key) && !host.RuntimePending)
			{
				return host.ReloadMap(delegate(bool ok, string error)
				{
					AfterLoad(ok, error, join);
				}, startRuntime: false);
			}
			return host.LoadMap(map, delegate(bool ok, string error)
			{
				AfterLoad(ok, error, join);
			}, startRuntime: false);
		}

		private void AfterLoad(bool ok, string error, Action join)
		{
			if (ok)
			{
				join();
				return;
			}
			_joining = null;
			Disarm();
			this.Notice?.Invoke(error);
		}

		public override void OnJoinedRoom()
		{
			if (host == null || !Capture())
			{
				return;
			}
			string text = MapRoomProps.KeyOf(PhotonNetwork.CurrentRoom);
			_joining = null;
			if (string.IsNullOrEmpty(text))
			{
				Disarm();
				if (host.Current != null)
				{
					host.UnloadMap();
				}
				return;
			}
			MapPackage mapPackage = MapCatalog.Find(text);
			if (mapPackage == null)
			{
				this.Notice?.Invoke("This room plays " + (MapRoomProps.NameOf(PhotonNetwork.CurrentRoom) ?? "a map") + " you don't have. Back to Sandbox.");
				Disarm();
				if (host.Current != null)
				{
					host.UnloadMap(delegate
					{
						MonkeDevNetworkingManager.JoinRandomRoom(_builtinQueue, _builtinLimit);
					});
				}
				else
				{
					MonkeDevNetworkingManager.JoinRandomRoom(_builtinQueue, _builtinLimit);
				}
			}
			else
			{
				Arm(mapPackage);
				if (!host.IsLoaded(text))
				{
					host.LoadMap(mapPackage);
				}
				else if (host.RuntimePending)
				{
					host.StartRuntime();
				}
				else
				{
					host.ReloadMap();
				}
			}
		}

		private void OnRoomJoinFailed(short code, string message)
		{
			MapPackage joining = _joining;
			if (joining == null)
			{
				return;
			}
			_joining = null;
			this.Notice?.Invoke(code switch
			{
				32765 => "That room is full.", 
				32758 => "That room has closed.", 
				_ => "Couldn't join that room.", 
			});
			Disarm();
			if (host.Current != null && host.Current.Package == joining && host.RuntimePending)
			{
				host.UnloadMap(delegate
				{
					MonkeDevNetworkingManager.JoinRandomRoom(_builtinQueue, _builtinLimit);
				});
			}
			else
			{
				MonkeDevNetworkingManager.JoinRandomRoom(_builtinQueue, _builtinLimit);
			}
		}
	}
}
