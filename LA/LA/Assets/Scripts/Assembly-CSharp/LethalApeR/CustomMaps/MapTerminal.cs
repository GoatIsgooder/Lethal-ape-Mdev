using System;
using System.Collections.Generic;
using Photon.Realtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.CustomMaps
{
	[DisallowMultipleComponent]
	public sealed class MapTerminal : MonoBehaviour
	{
		private enum Filter
		{
			All = 0,
			BuiltIn = 1,
			Custom = 2
		}

		private enum Tab
		{
			Servers = 0,
			Maps = 1
		}

		private static readonly Color Bg = Hex(0x0A0A0F);

		private static readonly Color Panel = Hex(0x141419);

		private static readonly Color Raised = Hex(0x1B1B22);

		private static readonly Color Accent = Hex(0x3B82F6);

		private static readonly Color AccentHover = Hex(0x5195F9);

		private static readonly Color TextColor = Color.white;

		private static readonly Color TextDim = new Color(1f, 1f, 1f, 0.6f);

		private static readonly Color TextFaint = new Color(1f, 1f, 1f, 0.35f);

		private static readonly Color ErrorColor = Hex(0xE66666);

		private static readonly Color OkColor = Hex(0x66E666);

		private static readonly Color WarnColor = Hex(0xFFBF59);

		private const float PressDepth = 40f;

		private const int CardsPerPage = 6;

		private const float CardW = 420f;

		private const float CardH = 300f;

		private MapPackage _selected;

		private readonly List<MapPackage> _maps = new List<MapPackage>();

		private const string CodeAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

		private const int RowsPerPage = 6;

		private const float RowHeight = 78f;

		private Filter _filter;

		private int _page;

		private readonly List<RoomInfo> _visibleRooms = new List<RoomInfo>();

		[SerializeField]
		private TMP_FontAsset font;

		[SerializeField]
		[Tooltip("Screen size in metres.")]
		private Vector2 screenSize = new Vector2(1.4f, 0.9f);

		[SerializeField]
		[Tooltip("The room list connects while a player's head is this close.")]
		private float activateDistance = 4f;

		[SerializeField]
		private AudioSource clickSource;

		private static MapTerminal _instance;

		private Canvas _canvas;

		private RectTransform _screen;

		private RectTransform _body;

		private TextMeshProUGUI _status;

		private TerminalButton _serversTab;

		private TerminalButton _mapsTab;

		private Tab _tab;

		private float _statusUntil;

		private bool _near;

		private float _farSince;

		private float _retryAt;

		private readonly RoomBrowserClient _browser = new RoomBrowserClient();

		private float W => screenSize.x * 1000f;

		private float H => screenSize.y * 1000f;

		private static Color Hex(int rgb)
		{
			return new Color((float)((rgb >> 16) & 0xFF) / 255f, (float)((rgb >> 8) & 0xFF) / 255f, (float)(rgb & 0xFF) / 255f, 1f);
		}

		private static RectTransform Place(RectTransform rt, float x, float y, float w, float h)
		{
			rt.anchorMax = new Vector2(0f, 1f);
			rt.anchorMin = new Vector2(0f, 1f);
			rt.pivot = new Vector2(0f, 1f);
			rt.anchoredPosition = new Vector2(x, 0f - y);
			rt.sizeDelta = new Vector2(w, h);
			return rt;
		}

		private static RectTransform NewRect(Transform parent, string name)
		{
			GameObject gameObject = new GameObject(name, typeof(RectTransform));
			gameObject.layer = parent.gameObject.layer;
			gameObject.transform.SetParent(parent, false);
			return (RectTransform)gameObject.transform;
		}

		private static Image Box(Transform parent, string name, float x, float y, float w, float h, Color color)
		{
			Image image = Place(NewRect(parent, name), x, y, w, h).gameObject.AddComponent<Image>();
			image.color = color;
			image.raycastTarget = false;
			return image;
		}

		private TextMeshProUGUI Label(Transform parent, string text, float x, float y, float w, float h, float size, Color color, TextAlignmentOptions align = TextAlignmentOptions.MidlineLeft, bool bold = false)
		{
			TextMeshProUGUI textMeshProUGUI = Place(NewRect(parent, "Text"), x, y, w, h).gameObject.AddComponent<TextMeshProUGUI>();
			if (font != null)
			{
				textMeshProUGUI.font = font;
			}
			textMeshProUGUI.fontSize = size;
			textMeshProUGUI.color = color;
			textMeshProUGUI.alignment = align;
			textMeshProUGUI.textWrappingMode = TextWrappingModes.Normal;
			textMeshProUGUI.overflowMode = TextOverflowModes.Ellipsis;
			textMeshProUGUI.raycastTarget = false;
			textMeshProUGUI.fontStyle = bold ? FontStyles.Bold : FontStyles.Normal;
			textMeshProUGUI.text = text;
			return textMeshProUGUI;
		}

		private TerminalButton Button(Transform parent, string text, float x, float y, float w, float h, Action onPress, Color? normal = null, float textSize = 30f)
		{
			Image image = Box(parent, "Button " + text, x, y, w, h, normal ?? Raised);
			GameObject gameObject = image.gameObject;
			if (!string.IsNullOrEmpty(text))
			{
				Label(gameObject.transform, text, 0f, 0f, w, h, textSize, TextColor, TextAlignmentOptions.Center, true);
			}
			BoxCollider boxCollider = gameObject.AddComponent<BoxCollider>();
			boxCollider.isTrigger = true;
			boxCollider.center = new Vector3(w * 0.5f, h * -0.5f, -20f);
			boxCollider.size = new Vector3(w, h, 40f);
			gameObject.layer = 2;
			TerminalButton terminalButton = gameObject.AddComponent<TerminalButton>();
			terminalButton.Init(onPress, image, normal ?? Raised, AccentHover);
			return terminalButton;
		}

		private static void Clear(Transform t)
		{
			for (int num = t.childCount - 1; num >= 0; num--)
			{
				UnityEngine.Object.Destroy(t.GetChild(num).gameObject);
			}
		}

		private void BuildMaps()
		{
			Button(_body, "RESCAN", W - 250f, 10f, 210f, 60f, MapCatalog.Refresh, null, 24f);
			Label(_body, "Maps on this headset", 40f, 10f, 700f, 60f, 26f, TextDim);
			if (MapCatalog.Scanning && !MapCatalog.HasScanned)
			{
				Label(_body, "Looking for maps...", 40f, 110f, W - 80f, 70f, 30f, TextDim);
				return;
			}
			CollectMaps();
			if (_maps.Count == 0)
			{
				Label(_body, "No custom maps yet.\nBuild one with the map SDK and use Send to Quest to try it here.", 40f, 110f, W - 80f, 140f, 30f, TextDim);
				ShowProblems(260f);
				return;
			}
			int num = Mathf.Max(1, (_maps.Count + 5) / 6);
			_page = Mathf.Clamp(_page, 0, num - 1);
			for (int i = 0; i < 6; i++)
			{
				int num2 = _page * 6 + i;
				if (num2 >= _maps.Count)
				{
					break;
				}
				Card(_maps[num2], 40f + (float)(i % 3) * 450f, 90f + (float)(i / 3) * 320f);
			}
			float num3 = H - 205f;
			if (num > 1)
			{
				Pager(num, num3 - 70f);
			}
			else
			{
				ShowProblems(num3 - 60f);
			}
		}

		private void CollectMaps()
		{
			_maps.Clear();
			Dictionary<string, MapPackage> dictionary = new Dictionary<string, MapPackage>();
			foreach (MapPackage map in MapCatalog.Maps)
			{
				if (!dictionary.TryGetValue(map.Guid, out MapPackage value) || CompareVersions(value.Version, map.Version) < 0)
				{
					dictionary[map.Guid] = map;
				}
			}
			_maps.AddRange(dictionary.Values);
			_maps.Sort((MapPackage a, MapPackage b) => string.Compare(a.Name, b.Name, StringComparison.OrdinalIgnoreCase));
		}

		private static int CompareVersions(string a, string b)
		{
			string[] array = (a ?? "").Split('.');
			string[] array2 = (b ?? "").Split('.');
			for (int i = 0; i < 3; i++)
			{
				int result;
				int num = ((i < array.Length && int.TryParse(array[i], out result)) ? result : 0);
				int result2;
				int value = ((i < array2.Length && int.TryParse(array2[i], out result2)) ? result2 : 0);
				if (num != value)
				{
					return num.CompareTo(value);
				}
			}
			return 0;
		}

		private void Card(MapPackage map, float x, float y)
		{
			Transform transform = Button(_body, null, x, y, 420f, 300f, delegate
			{
				_selected = map;
				Rebuild();
			}, Panel).transform;
			Thumbnail(transform, map, 12f, 12f, 396f, 222.75f);
			Label(transform, map.Name, 14f, 240.75f, 392f, 32f, 26f, TextColor, TextAlignmentOptions.MidlineLeft, true);
			Label(transform, "by " + map.Author + "  |  v" + map.Version, 14f, 272.75f, 392f, 24f, 18f, TextFaint);
		}

		private void Thumbnail(Transform parent, MapPackage map, float x, float y, float w, float h)
		{
			RawImage rawImage = Place(NewRect(parent, "Thumbnail"), x, y, w, h).gameObject.AddComponent<RawImage>();
			rawImage.raycastTarget = false;
			Texture2D thumbnail = map.Thumbnail;
			rawImage.texture = thumbnail;
			rawImage.color = ((thumbnail != null) ? Color.white : Raised);
		}

		private void BuildMapDetail(MapPackage map)
		{
			Button(_body, "< BACK", 40f, 10f, 180f, 60f, delegate
			{
				_selected = null;
				Rebuild();
			}, null, 24f);
			Thumbnail(_body, map, 40f, 90f, 640f, 360f);
			float w = W - 720f - 40f;
			Label(_body, map.Name, 720f, 90f, w, 60f, 40f, TextColor, TextAlignmentOptions.MidlineLeft, true);
			Label(_body, "by " + map.Author, 720f, 150f, w, 36f, 24f, TextDim);
			string text = ((map.Manifest.tags != null && map.Manifest.tags.Length != 0) ? string.Join("  |  ", map.Manifest.tags) : "No tags");
			Label(_body, text, 720f, 188f, w, 32f, 20f, AccentHover);
			string text2 = map.Manifest.description;
			if (string.IsNullOrEmpty(text2))
			{
				text2 = "No description.";
			}
			Label(_body, text2, 720f, 228f, w, 150f, 22f, TextDim, TextAlignmentOptions.TopLeft).overflowMode = TextOverflowModes.Ellipsis;
			Label(_body, string.Format("v{0}  |  up to {1} players  |  {2}", map.Version, map.MaxPlayers, (map.Source == MapSource.Local) ? "local" : "mod.io"), 720f, 390f, w, 30f, 18f, TextFaint);
			bool interactable = !(CustomMapRoomBinder.Instance == null) && !CustomMapRoomBinder.Instance.Busy;
			Button(_body, "PLAY", 40f, 470f, 300f, 90f, delegate
			{
				Play(map);
			}, Accent, 34f).Interactable = interactable;
			Button(_body, "PRIVATE ROOM", 360f, 470f, 320f, 90f, delegate
			{
				PlayPrivate(map);
			}, null, 28f).Interactable = interactable;
			Label(_body, "Play joins an open room on this map or starts one. Private Room makes a code you can share.", 720f, 470f, W - 760f, 90f, 20f, TextFaint);
		}

		private void Play(MapPackage map)
		{
			CustomMapRoomBinder instance = CustomMapRoomBinder.Instance;
			if (instance != null && instance.PlayMap(map))
			{
				SetStatus("Loading " + map.Name + "...", TextDim, 6f);
			}
		}

		private void PlayPrivate(MapPackage map)
		{
			CustomMapRoomBinder instance = CustomMapRoomBinder.Instance;
			if (!(instance == null))
			{
				char[] array = new char[5];
				for (int i = 0; i < array.Length; i++)
				{
					array[i] = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"[UnityEngine.Random.Range(0, "ABCDEFGHJKLMNPQRSTUVWXYZ23456789".Length)];
				}
				string text = new string(array);
				if (instance.PlayMapPrivate(map, text))
				{
					SetStatus("Private room <color=#5195F9>" + text + "</color>. Friends can join with that code on the Computer.", TextColor, 12f);
				}
			}
		}

		private void ShowProblems(float y)
		{
			IReadOnlyList<string> problems = MapCatalog.Problems;
			if (problems.Count != 0)
			{
				string text = ((problems.Count == 1) ? ("1 map couldn't be used: " + problems[0]) : string.Format("{0} maps couldn't be used. First: {1}", problems.Count, problems[0]));
				Label(_body, text, 40f, y, W - 80f, 50f, 18f, WarnColor);
			}
		}

		private void BuildServers()
		{
			Button(_body, "ALL", 40f, 10f, 150f, 60f, delegate
			{
				SetFilter(Filter.All);
			}, (_filter == Filter.All) ? Accent : Raised, 24f);
			Button(_body, "BUILT-IN", 205f, 10f, 200f, 60f, delegate
			{
				SetFilter(Filter.BuiltIn);
			}, (_filter == Filter.BuiltIn) ? Accent : Raised, 24f);
			Button(_body, "CUSTOM", 420f, 10f, 190f, 60f, delegate
			{
				SetFilter(Filter.Custom);
			}, (_filter == Filter.Custom) ? Accent : Raised, 24f);
			Button(_body, "REFRESH", W - 250f, 10f, 210f, 60f, delegate
			{
				_browser.Stop();
				_browser.Start();
				Rebuild();
			}, null, 24f);
			switch (_browser.State)
			{
			case RoomBrowserClient.Status.Offline:
				Label(_body, "Walk up to the screen to see rooms.", 40f, 110f, W - 80f, 70f, 30f, TextDim);
				return;
			case RoomBrowserClient.Status.Waiting:
				Label(_body, "Connecting to the game servers...", 40f, 110f, W - 80f, 70f, 30f, TextDim);
				return;
			case RoomBrowserClient.Status.Connecting:
				Label(_body, "Finding rooms...", 40f, 110f, W - 80f, 70f, 30f, TextDim);
				return;
			case RoomBrowserClient.Status.Failed:
				Label(_body, _browser.Error ?? "Couldn't load the room list.", 40f, 110f, W - 80f, 70f, 30f, ErrorColor);
				return;
			}
			CollectRooms();
			if (_visibleRooms.Count == 0)
			{
				Label(_body, (_filter == Filter.Custom) ? "Nobody is playing a custom map right now. Start one from My Maps!" : "No open rooms right now.", 40f, 110f, W - 80f, 70f, 30f, TextDim);
				return;
			}
			int num = Mathf.Max(1, (_visibleRooms.Count + 5) / 6);
			_page = Mathf.Clamp(_page, 0, num - 1);
			float num2 = 90f;
			for (int i = _page * 6; i < _visibleRooms.Count && i < _page * 6 + 6; i++)
			{
				RoomRow(_visibleRooms[i], num2);
				num2 += 86f;
			}
			if (num > 1)
			{
				Pager(num, H - 205f - 70f);
			}
		}

		private void SetFilter(Filter filter)
		{
			_filter = filter;
			_page = 0;
			Rebuild();
		}

		private void CollectRooms()
		{
			_visibleRooms.Clear();
			string builtinQueue = ((CustomMapRoomBinder.Instance != null) ? CustomMapRoomBinder.Instance.BuiltinQueue : "Sandbox");
			foreach (RoomInfo room in _browser.Rooms)
			{
				if (MapRoomProps.IsSandboxQueue(MapRoomProps.QueueOf(room), builtinQueue))
				{
					Filter filter = (string.IsNullOrEmpty(MapRoomProps.KeyOf(room)) ? Filter.Custom : Filter.BuiltIn);
					if (_filter != filter)
					{
						_visibleRooms.Add(room);
					}
				}
			}
			_visibleRooms.Sort((RoomInfo a, RoomInfo b) => (a.PlayerCount != b.PlayerCount) ? b.PlayerCount.CompareTo(a.PlayerCount) : string.CompareOrdinal(a.Name, b.Name));
		}

		private void RoomRow(RoomInfo room, float y)
		{
			string text = MapRoomProps.KeyOf(room);
			bool flag = string.IsNullOrEmpty(text);
			bool flag2 = flag || MapCatalog.Find(text) != null;
			bool flag3 = Photon.Pun.PhotonNetwork.InRoom && Photon.Pun.PhotonNetwork.CurrentRoom.Name == room.Name;
			bool flag4 = room.MaxPlayers > 0 && room.PlayerCount >= room.MaxPlayers;
			TerminalButton terminalButton = Button(_body, null, 40f, y, W - 80f, 78f, delegate
			{
				Join(room);
			}, Panel);
			terminalButton.Interactable = flag2 && !flag3 && !flag4;
			Transform transform = terminalButton.transform;
			string text2 = (flag ? "Sandbox" : (MapRoomProps.NameOf(room) ?? "Custom Map"));
			Label(transform, text2, 24f, 0f, 560f, 78f, 32f, TextColor, TextAlignmentOptions.MidlineLeft, true);
			float num = (flag ? 180f : 160f);
			Color color = (flag ? Raised : new Color(Accent.r, Accent.g, Accent.b, 0.25f));
			Label(Box(transform, "Badge", 610f, 20f, num, 38f, color).transform, flag ? "BUILT-IN" : "CUSTOM", 0f, 0f, num, 38f, 20f, flag ? TextDim : AccentHover, TextAlignmentOptions.Center, true);
			string text3;
			Color color2;
			if (flag3)
			{
				text3 = "YOU'RE HERE";
				color2 = OkColor;
			}
			else if (!flag2 || flag4)
			{
				text3 = (flag2 ? "FULL" : "NOT INSTALLED");
				color2 = WarnColor;
			}
			else
			{
				text3 = LethalApeR.Networking.MonkeDevNetworkingManager.SalvageDisplayCode(room.Name);
				color2 = TextFaint;
			}
			Label(transform, text3, 810f, 0f, 250f, 78f, 22f, color2);
			Label(transform, string.Format("{0}/{1}", room.PlayerCount, room.MaxPlayers), W - 80f - 170f, 0f, 150f, 78f, 30f, TextColor, TextAlignmentOptions.MidlineRight, true);
		}

		private void Join(RoomInfo room)
		{
			CustomMapRoomBinder instance = CustomMapRoomBinder.Instance;
			if (!(instance == null) && instance.JoinListedRoom(room))
			{
				SetStatus("Joining " + (MapRoomProps.NameOf(room) ?? "Sandbox") + "…", TextDim, 4f);
			}
		}

		private void Pager(int pages, float y)
		{
			Button(_body, "<", W * 0.5f - 190f, y, 110f, 60f, delegate
			{
				_page = Mathf.Max(0, _page - 1);
				Rebuild();
			}, null, 34f).Interactable = _page > 0;
			Label(_body, string.Format("{0} / {1}", _page + 1, pages), W * 0.5f - 70f, y, 140f, 60f, 26f, TextDim, TextAlignmentOptions.Center);
			Button(_body, ">", W * 0.5f + 80f, y, 110f, 60f, delegate
			{
				_page++;
				Rebuild();
			}, null, 34f).Interactable = _page < pages - 1;
		}

		private void Awake()
		{
			_instance = this;
			BuildShell();
		}

		private void OnEnable()
		{
			MapCatalog.Changed += OnCatalogChanged;
			_browser.Updated += OnBrowserUpdated;
			if (CustomMapRoomBinder.Instance != null)
			{
				CustomMapRoomBinder.Instance.Notice += ShowNotice;
			}
			if (CustomMapHost.Instance != null)
			{
				CustomMapHost.Instance.LoadFailed += ShowError;
			}
			Rebuild();
		}

		private void OnDisable()
		{
			MapCatalog.Changed -= OnCatalogChanged;
			_browser.Updated -= OnBrowserUpdated;
			if (CustomMapRoomBinder.Instance != null)
			{
				CustomMapRoomBinder.Instance.Notice -= ShowNotice;
			}
			if (CustomMapHost.Instance != null)
			{
				CustomMapHost.Instance.LoadFailed -= ShowError;
			}
			_browser.Stop();
		}

		private void OnDestroy()
		{
			if (_instance == this)
			{
				_instance = null;
			}
			_browser.Stop();
		}

		public static void Click()
		{
			if (_instance != null && _instance.clickSource != null && _instance.clickSource.clip != null)
			{
				_instance.clickSource.PlayOneShot(_instance.clickSource.clip);
			}
		}

		private void Update()
		{
			Transform head = MapPlayer.Head;
			if (head != null && (head.position - transform.position).sqrMagnitude < activateDistance * activateDistance)
			{
				if (!_near)
				{
					_near = true;
					if (_tab == Tab.Servers)
					{
						_browser.Start();
					}
				}
			}
			else if (_near)
			{
				_near = false;
				_farSince = Time.time;
			}
			if (_near && (_browser.State == RoomBrowserClient.Status.Failed || _browser.State == RoomBrowserClient.Status.Waiting) && _tab == Tab.Servers && Photon.Pun.PhotonNetwork.IsConnectedAndReady && Time.time >= _retryAt)
			{
				_retryAt = Time.time + 8f;
				_browser.Start();
			}
			if (!_near && _browser.State != RoomBrowserClient.Status.Offline && Time.time - _farSince > 20f)
			{
				_browser.Stop();
			}
			_browser.Service();
			if (_status != null && _statusUntil > 0f && Time.time > _statusUntil)
			{
				_statusUntil = 0f;
				RefreshStatus();
			}
		}

		private void BuildShell()
		{
			GameObject go = new GameObject("Screen", typeof(RectTransform));
			go.transform.SetParent(transform, false);
			go.transform.localRotation = Quaternion.Euler(0f, 180f, 0f);
			go.transform.localScale = Vector3.one * 0.001f;
			_canvas = go.AddComponent<Canvas>();
			_canvas.renderMode = RenderMode.WorldSpace;
			_screen = (RectTransform)go.transform;
			_screen.sizeDelta = screenSize * 1000f;
			_screen.pivot = new Vector2(0.5f, 0.5f);
			Box(_screen, "Background", 0f, 0f, W, H, Bg);
			Box(_screen, "Header", 0f, 0f, W, 110f, Panel);
			Box(_screen, "Header Line", 0f, 110f, W, 3f, new Color(Accent.r, Accent.g, Accent.b, 0.35f));
			Label(_screen, "SANDBOX <color=#3B82F6>MAPS</color>", 40f, 20f, 600f, 70f, 46f, TextColor, TextAlignmentOptions.MidlineLeft, bold: true).richText = true;
			_serversTab = Button(_screen, "SERVERS", W - 560f, 25f, 250f, 62f, () => SwitchTab(Tab.Servers), null, 26f);
			_mapsTab = Button(_screen, "MY MAPS", W - 290f, 25f, 250f, 62f, () => SwitchTab(Tab.Maps), null, 26f);
			_body = Place(NewRect(_screen, "Body"), 0f, 125f, W, H - 205f);
			Box(_screen, "Footer", 0f, H - 72f, W, 72f, Panel);
			_status = Label(_screen, "", 40f, H - 64f, W - 80f, 56f, 24f, TextDim);
		}

		private void SwitchTab(Tab tab)
		{
			_tab = tab;
			if (tab == Tab.Maps)
			{
				if (!MapCatalog.Scanning)
				{
					MapCatalog.Refresh();
				}
			}
			else if (tab == Tab.Servers && _near)
			{
				_browser.Start();
			}
			_selected = null;
			_page = 0;
			Rebuild();
		}

		private void Rebuild()
		{
			if (_body == null)
			{
				return;
			}
			Clear(_body);
			_serversTab.SetColors((_tab == Tab.Servers) ? Accent : Raised, AccentHover);
			_mapsTab.SetColors((_tab == Tab.Maps) ? Accent : Raised, AccentHover);
			if (!MapCompatibility.PlatformSupportsCustomMaps)
			{
				Label(_body, "Custom maps are Quest-only for now.", 40f, 40f, W - 80f, 80f, 32f, TextDim);
				return;
			}
			if (_tab == Tab.Servers)
			{
				BuildServers();
			}
			else if (_selected != null)
			{
				BuildMapDetail(_selected);
			}
			else
			{
				BuildMaps();
			}
			RefreshStatus();
		}

		private void OnCatalogChanged()
		{
			if (_tab == Tab.Maps)
			{
				Rebuild();
			}
		}

		private void OnBrowserUpdated()
		{
			if (_tab == Tab.Servers)
			{
				Rebuild();
			}
		}

		private void ShowNotice(string message)
		{
			SetStatus(message, WarnColor, 6f);
		}

		private void ShowError(string message)
		{
			SetStatus(message, ErrorColor, 8f);
		}

		private void SetStatus(string text, Color color, float seconds)
		{
			if (!(_status == null))
			{
				_status.text = text;
				_status.color = color;
				_statusUntil = Time.time + seconds;
			}
		}

		private void RefreshStatus()
		{
			if (_status == null || _statusUntil > 0f)
			{
				return;
			}
			_status.color = TextDim;
			if (CustomMapRoomBinder.Instance != null && CustomMapRoomBinder.Instance.Busy)
			{
				_status.text = "Joining…";
				return;
			}
			if (Photon.Pun.PhotonNetwork.InRoom)
			{
				string code = LethalApeR.Networking.MonkeDevNetworkingManager.SalvageDisplayCode(Photon.Pun.PhotonNetwork.CurrentRoom.Name);
				if (code != null)
				{
					_status.text = "You're in room <color=#5195F9>" + code + "</color>";
					return;
				}
			}
			_status.text = "Not in a room";
		}
	}
}
