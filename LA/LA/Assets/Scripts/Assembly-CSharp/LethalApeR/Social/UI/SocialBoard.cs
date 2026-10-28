using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Social.UI
{
	public sealed class SocialBoard : MonoBehaviour
	{
		private const int TabLobby = 0;

		private const int TabFriends = 1;

		private const int TabSettings = 2;

		[Header("Parts")]
		[SerializeField]
		private Canvas canvas;

		[SerializeField]
		private SocialButton[] tabs = new SocialButton[3];

		[SerializeField]
		private GameObject[] pages = new GameObject[3];

		[SerializeField]
		private TMP_Text title;

		[SerializeField]
		private RectTransform chip;

		[SerializeField]
		private TMP_Text chipLabel;

		[SerializeField]
		private Image chipDot;

		[SerializeField]
		private TMP_Text roomLabel;

		[SerializeField]
		private SocialListView lobbyList;

		[SerializeField]
		private SocialListView friendsList;

		[Header("Distance (metres)")]
		[Tooltip("Stops drawing past this. Keep it just past the shaders' _FadeFar, where it's already invisible.")]
		[SerializeField]
		private float hideBeyond = 4.1f;

		[SerializeField]
		private float showWithin = 3.9f;

		private LobbyAdapter _lobby;

		private FriendsAdapter _friends;

		private int _tab = -1;

		private bool _shown = true;

		private float _nextDistanceCheck;

		private float _nextHeader;

		private int _countShown = -1;

		private int _capacityShown = -1;

		private int _onlineShown = -1;

		private string _countText;

		private string _roomCodeText;

		private string _onlineText;

		private string _roomNameShown;

		private string _chipText;

		private string _chipTitle;

		private bool _chipDotOn;

		private string _roomText;

		private float _chipBaseX;

		private bool _chipMeasured;

		private void Awake()
		{
			_lobby = new LobbyAdapter(lobbyList);
			_friends = new FriendsAdapter(friendsList);
			lobbyList.Warm(0, 9);
			friendsList.Warm(0, 9);
			for (int i = 0; i < tabs.Length; i++)
			{
				int index = i;
				tabs[i].Pressed += delegate
				{
					Select(index);
				};
			}
		}

		private void Start()
		{
			Select(0);
		}

		private void OnDisable()
		{
			if (_lobby != null)
			{
				_lobby.Detach();
			}
			if (_friends != null)
			{
				_friends.Detach();
			}
			_tab = -1;
		}

		private void OnEnable()
		{
			if (_lobby != null && _tab < 0)
			{
				Select(0);
			}
		}

		public void Select(int index)
		{
			if (_tab == index)
			{
				return;
			}
			_tab = index;
			for (int i = 0; i < pages.Length; i++)
			{
				if (pages[i] != null && pages[i].activeSelf != (i == index))
				{
					pages[i].SetActive(i == index);
				}
				tabs[i].SetLook((i == index) ? ButtonLook.TabSelected : ButtonLook.Tab);
			}
			if (index == 0)
			{
				_lobby.Attach();
				_friends.Detach();
			}
			else
			{
				_lobby.Detach();
				if (index == 1)
				{
					_friends.Attach();
				}
				else
				{
					_friends.Detach();
				}
			}
			_nextHeader = 0f;
		}

		private void Update()
		{
			float now = Time.unscaledTime;
			if (now >= _nextDistanceCheck)
			{
				_nextDistanceCheck = now + 0.15f;
				UpdateVisibility();
			}
			if (!_shown)
			{
				return;
			}
			switch (_tab)
			{
			case 0:
				_lobby.Tick();
				break;
			case 1:
				_friends.Tick();
				break;
			}
			if (now >= _nextHeader)
			{
				_nextHeader = now + 0.25f;
				UpdateHeader();
			}
		}

		private void UpdateVisibility()
		{
			Transform head = Head();
			if (!(head == null))
			{
				float distance = Vector3.Distance(head.position, base.transform.position);
				bool show = distance < (_shown ? hideBeyond : showWithin);
				if (show != _shown)
				{
					_shown = show;
					if (canvas != null)
					{
						canvas.enabled = show;
					}
				}
			}
		}

		private static Transform Head()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager != null && manager.Head != null)
			{
				return manager.Head;
			}
			Camera main = Camera.main;
			if (!(main != null))
			{
				return null;
			}
			return main.transform;
		}

		private void UpdateHeader()
		{
			FriendsService friends = FriendsService.Instance;
			tabs[1].SetBadge((friends != null) ? friends.Incoming.Count : 0);
			switch (_tab)
			{
			case 0:
			{
				SetTitle("LOBBY");
				int count = SocialRoster.PlayerCount;
				int capacity = SocialRoster.Capacity;
				Room room = PhotonNetwork.CurrentRoom;
				string roomName = ((room != null && PhotonNetwork.InRoom) ? room.Name : null);
				if (count != _countShown || capacity != _capacityShown || (object)roomName != _roomNameShown)
				{
					_roomNameShown = roomName;
					_countShown = count;
					_capacityShown = capacity;
					_countText = ((roomName != null) ? ((capacity >= 1) ? (count + "/" + capacity) : count.ToString()) : "OFFLINE");
					string code = SocialRoster.RoomCode;
					_roomCodeText = ((!string.IsNullOrEmpty(code)) ? ("ROOM <color=#F2F2F2>" + code + "</color>") : "");
				}
				SetChip(_countText, null);
				SetRoom(_roomCodeText);
				break;
			}
			case 1:
			{
				SetTitle("FRIENDS");
				int online = _friends.OnlineCount;
				if (online != _onlineShown || _onlineText == null)
				{
					_onlineShown = online;
					_onlineText = online + " ONLINE";
				}
				SetChip(_onlineText, SocialStyle.Online);
				SetRoom("");
				break;
			}
			default:
				SetTitle("SETTINGS");
				SetChip(null, null);
				SetRoom("");
				break;
			}
		}

		private void SetTitle(string text)
		{
			if (!string.Equals(title.text, text))
			{
				title.text = text;
			}
		}

		private void SetChip(string text, Color? dot)
		{
			bool empty = string.IsNullOrEmpty(text);
			if (chip.gameObject.activeSelf == empty)
			{
				chip.gameObject.SetActive(!empty);
			}
			if (empty)
			{
				return;
			}
			bool hasDot = dot.HasValue && chipDot != null;
			if (!string.Equals(text, _chipText) || _chipDotOn != hasDot || !string.Equals(title.text, _chipTitle))
			{
				_chipText = text;
				_chipDotOn = hasDot;
				_chipTitle = title.text;
				chipLabel.text = text;
				if (!_chipMeasured)
				{
					_chipMeasured = true;
					_chipBaseX = chipLabel.rectTransform.anchoredPosition.x;
				}
				if (chipDot != null)
				{
					chipDot.gameObject.SetActive(hasDot);
					if (hasDot)
					{
						chipDot.color = dot.Value;
					}
				}
				float labelX = (hasDot ? (_chipBaseX + 16f) : _chipBaseX);
				chipLabel.rectTransform.anchoredPosition = new Vector2(labelX, chipLabel.rectTransform.anchoredPosition.y);
				float labelWidth = chipLabel.GetPreferredValues(text).x;
				chip.sizeDelta = new Vector2(labelX + labelWidth + _chipBaseX, chip.sizeDelta.y);
				float titleX = title.rectTransform.anchoredPosition.x;
				float titleWidth = title.GetPreferredValues(title.text).x;
				chip.anchoredPosition = new Vector2(titleX + titleWidth + 14f, chip.anchoredPosition.y);
			}
		}

		private void SetRoom(string text)
		{
			if (!(roomLabel == null) && !string.Equals(text, _roomText))
			{
				_roomText = text;
				roomLabel.text = text;
			}
		}
	}
}
