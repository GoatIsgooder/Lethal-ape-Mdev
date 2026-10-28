using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using LethalApeR.Social;
using Photon.Pun;
using Photon.Realtime;
using QauthSdk;
using TMPro;
using UnityEngine;

namespace LethalApeR.UI
{
	public class LeaderboardSystem : MonoBehaviourPunCallbacks
	{
		[Header("Auto-wired from prefab hierarchy — leave blank to auto-assign")]
		[SerializeField]
		private TextMeshProUGUI _playersText;

		[SerializeField]
		private TextMeshProUGUI _roomCodeText;

		[SerializeField]
		private TextMeshProUGUI _userIdText;

		[SerializeField]
		private TextMeshProUGUI _pageText;

		[SerializeField]
		private TextMeshProUGUI _gamemodeText;

		[SerializeField]
		private TextMeshProUGUI _countText;

		private int _page;

		private bool _dirty;

		private const int PerPage = 10;

		private const float RefreshInterval = 0.5f;

		private readonly List<LeaderboardButton> _muteButtons = new List<LeaderboardButton>();

		private readonly List<Renderer> _muteButtonRenderers = new List<Renderer>();

		private TextMeshProUGUI _muteLabelsText;

		private MaterialPropertyBlock _mpb;

		private static readonly Color MutedColor = new Color(164f / 255f, 0f, 0f, 1f);

		private static readonly Color UnmutedColor = new Color(0.7f, 0.7f, 0.7f, 1f);

		private static readonly Dictionary<string, string> RoleColors = new Dictionary<string, string>
		{
			{ "OWNER", "#FF4444" },
			{ "DEV", "#FF8C00" },
			{ "MOD", "#44AAFF" },
			{ "VIP", "#FFD700" },
			{ "TESTER", "#44FF88" },
			{ "ADMIN", "#FF44FF" }
		};

		private static readonly Dictionary<string, int> RolePriority = new Dictionary<string, int>
		{
			{ "OWNER", 0 },
			{ "DEV", 1 },
			{ "MOD", 2 },
			{ "ADMIN", 3 },
			{ "VIP", 4 },
			{ "TESTER", 5 }
		};

		private const int MaxLineChars = 18;

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			AutoWire();
		}

		private void Start()
		{
			Refresh();
			StartCoroutine(RefreshLoop());
		}

		private IEnumerator RefreshLoop()
		{
			WaitForSeconds wait = new WaitForSeconds(RefreshInterval);
			while (true)
			{
				yield return wait;
				Refresh();
				_dirty = false;
			}
		}

		public override void OnJoinedRoom()
		{
			Flag();
			Refresh();
		}

		public override void OnLeftRoom()
		{
			Flag();
			Refresh();
		}

		public override void OnDisconnected(DisconnectCause cause)
		{
			Flag();
			Refresh();
		}

		public override void OnPlayerEnteredRoom(Player p)
		{
			Flag();
		}

		public override void OnPlayerLeftRoom(Player p)
		{
			Flag();
			Refresh();
		}

		public override void OnPlayerPropertiesUpdate(Player p, ExitGames.Client.Photon.Hashtable changed)
		{
			Flag();
		}

		public override void OnRoomPropertiesUpdate(ExitGames.Client.Photon.Hashtable changed)
		{
			Flag();
		}

		private void Flag()
		{
			_dirty = true;
		}

		public void NextPage()
		{
			int total = TotalPages();
			_page = (_page + 1) % total;
			Refresh();
		}

		public void PrevPage()
		{
			int total = TotalPages();
			_page = (_page - 1 + total) % total;
			Refresh();
		}

		private int TotalPages()
		{
			int count = GetPlayers().Count;
			return Mathf.Max(1, Mathf.CeilToInt((float)count / (float)PerPage));
		}

		private void Refresh()
		{
			List<MonkeDevNetworkingPlayer> players = GetPlayers();
			SortPlayers(players);
			int total = TotalPages();
			_page = Mathf.Clamp(_page, 0, total - 1);
			int start = _page * PerPage;
			StringBuilder sb = new StringBuilder();
			for (int i = start; i < start + PerPage; i++)
			{
				string num = string.Format((i + 1 < 10) ? " {0}." : "{0}.", i + 1);
				if (i < players.Count)
				{
					MonkeDevNetworkingPlayer p = players[i];
					bool isMine = p.photonView.IsMine;
					string name = p.photonView.Owner?.NickName ?? "Player";
					if (string.IsNullOrEmpty(name))
					{
						name = "Player";
					}
					string roleTag = BuildRoleTag(GetRole(p), isMine);
					string nameColor = isMine ? "#FFFFFF" : "#CCCCCC";
					string richLine = "<color=#AAAAAA>" + num + "</color> " + roleTag + "<color=" + nameColor + ">" + EscapeRichText(name) + "</color>";
					int visibleLength = num.Length + StripRichText(roleTag).Length + name.Length + 1;
					sb.AppendLine(FitLine(richLine, visibleLength));
				}
				else
				{
					sb.AppendLine("");
				}
			}
			Set(_playersText, sb.ToString().TrimEnd('\n', '\r'));
			Set(_pageText, string.Format("Page\n{0} / {1}", _page + 1, total));
			if (PhotonNetwork.InRoom)
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				string queue = currentRoom.CustomProperties.ContainsKey("queue") ? currentRoom.CustomProperties["queue"].ToString() : "Default";
				Set(_gamemodeText, "(" + queue + ")");
				Set(_countText, (currentRoom.MaxPlayers > 0) ? string.Format("({0}/{1})", currentRoom.PlayerCount, currentRoom.MaxPlayers) : string.Format("({0})", currentRoom.PlayerCount));
				Set(_roomCodeText, MonkeDevNetworkingManager.SalvageDisplayCode(currentRoom.Name));
			}
			else
			{
				Set(_gamemodeText, "(N/A)");
				Set(_countText, "(0)");
				Set(_roomCodeText, "N/A");
			}
			UpdateMuteButtonColors();
			string id = Qauth.AccountId ?? "";
			if (string.IsNullOrEmpty(id))
			{
				id = PhotonNetwork.LocalPlayer?.UserId ?? "";
			}
			Set(_userIdText, string.IsNullOrEmpty(id) ? "N/A" : id);
		}

		private List<MonkeDevNetworkingPlayer> GetPlayers()
		{
			Dictionary<int, Player> roomPlayers;
			List<MonkeDevNetworkingPlayer> list = new List<MonkeDevNetworkingPlayer>();
			if (MonkeDevNetworkingManager.Manager == null || !PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
			{
				return list;
			}
			roomPlayers = PhotonNetwork.CurrentRoom.Players;
			list = new List<MonkeDevNetworkingPlayer>(MonkeDevNetworkingManager.Manager.Players);
			list.RemoveAll((MonkeDevNetworkingPlayer p) => p == null || p.photonView == null || p.photonView.Owner == null || roomPlayers == null || !roomPlayers.ContainsKey(p.photonView.OwnerActorNr));
			return list;
		}

		private void SortPlayers(List<MonkeDevNetworkingPlayer> players)
		{
			players.Sort(delegate(MonkeDevNetworkingPlayer a, MonkeDevNetworkingPlayer b)
			{
				int rolePriority = GetRolePriority(GetRole(a));
				int rolePriority2 = GetRolePriority(GetRole(b));
				if (rolePriority != rolePriority2)
				{
					return rolePriority.CompareTo(rolePriority2);
				}
				if (a.photonView.IsMine != b.photonView.IsMine)
				{
					return (!a.photonView.IsMine) ? 1 : (-1);
				}
				return a.photonView.OwnerActorNr.CompareTo(b.photonView.OwnerActorNr);
			});
		}

		private static string GetRole(MonkeDevNetworkingPlayer p)
		{
			if (p.photonView.Owner != null && p.photonView.Owner.CustomProperties.TryGetValue("Role", out var value))
			{
				return value?.ToString() ?? "";
			}
			return "";
		}

		private static int GetRolePriority(string role)
		{
			if (string.IsNullOrEmpty(role))
			{
				return 99;
			}
			if (!RolePriority.TryGetValue(role.ToUpper(), out var value))
			{
				return 99;
			}
			return value;
		}

		private static string BuildRoleTag(string role, bool isLocal)
		{
			if (isLocal)
			{
				return "<color=#00FFCC><b>[You]</b></color> ";
			}
			if (string.IsNullOrEmpty(role))
			{
				return "";
			}
			string key = role.ToUpper();
			string value;
			string text = (RoleColors.TryGetValue(key, out value) ? value : "#FFFFFF");
			return "<color=" + text + "><b>[" + role + "]</b></color> ";
		}

		private void SetRendererColor(Renderer rend, Color color)
		{
			_mpb.SetColor("_Color", color);
			_mpb.SetColor("_BaseColor", color);
			rend.SetPropertyBlock(_mpb);
		}

		private static string FitLine(string richLine, int visibleLength)
		{
			if (visibleLength <= MaxLineChars)
			{
				return richLine;
			}
			float num = (float)MaxLineChars / (float)visibleLength;
			int num2 = Mathf.Clamp(Mathf.RoundToInt(num * 100f), 55, 99);
			return string.Format("<size={0}%>{1}</size>", num2, richLine);
		}

		private static string StripRichText(string s)
		{
			StringBuilder sb = new StringBuilder();
			bool inTag = false;
			for (int i = 0; i < s.Length; i++)
			{
				char c = s[i];
				if (c == '<')
				{
					inTag = true;
				}
				else if (c == '>')
				{
					inTag = false;
				}
				else if (!inTag)
				{
					sb.Append(c);
				}
			}
			return sb.ToString();
		}

		private static string EscapeRichText(string s)
		{
			return s.Replace("<", "‹").Replace(">", "›");
		}

		private static void Set(TextMeshProUGUI t, string value)
		{
			if ((bool)t)
			{
				t.text = value;
			}
		}

		private void AutoWire()
		{
			TextMeshProUGUI[] componentsInChildren = GetComponentsInChildren<TextMeshProUGUI>(true);
			foreach (TextMeshProUGUI t in componentsInChildren)
			{
				string name = t.gameObject.name;
				string parentName = t.transform.parent?.name ?? "";
				if (!_playersText && name == "Players Info")
				{
					_playersText = t;
				}
				if (!_roomCodeText && name == "Info" && parentName == "Current Code")
				{
					_roomCodeText = t;
				}
				if (!_userIdText && name == "ID")
				{
					_userIdText = t;
				}
				if (!_pageText && name == "Current Page")
				{
					_pageText = t;
				}
				if (!_gamemodeText && name == "Gamemode")
				{
					_gamemodeText = t;
				}
				if (!_countText && name == "Count")
				{
					_countText = t;
				}
			}
			WireButton("Previous Page", PrevPage);
			WireButton("Next Page", NextPage);
			Transform[] componentsInChildren2 = GetComponentsInChildren<Transform>(true);
			foreach (Transform tr in componentsInChildren2)
			{
				if (tr.name == "Text (TMP)" && tr.parent != null && tr.parent.name == "Mute")
				{
					_muteLabelsText = tr.GetComponent<TextMeshProUGUI>();
					break;
				}
			}
			_muteButtons.Clear();
			_muteButtonRenderers.Clear();
			for (int i = 1; i <= PerPage; i++)
			{
				int slot = i;
				string goName = string.Format("MuteButton[{0}]", slot);
				Transform[] componentsInChildren3 = GetComponentsInChildren<Transform>(true);
				foreach (Transform tr2 in componentsInChildren3)
				{
					if (tr2.name == goName)
					{
						LeaderboardButton button = tr2.GetComponent<LeaderboardButton>() ?? tr2.gameObject.AddComponent<LeaderboardButton>();
						button.OnPressed += delegate
						{
							ToggleMute(slot - 1);
						};
						_muteButtons.Add(button);
						_muteButtonRenderers.Add(tr2.GetComponent<Renderer>());
						break;
					}
				}
			}
		}

		private void ToggleMute(int slotIndex)
		{
			List<MonkeDevNetworkingPlayer> players = GetPlayers();
			SortPlayers(players);
			int index = _page * PerPage + slotIndex;
			if (index < players.Count)
			{
				MonkeDevNetworkingPlayer player = players[index];
				if (!player.photonView.IsMine)
				{
					LocalMutes.Toggle(player.photonView.Owner?.UserId);
					UpdateMuteButtonColors();
				}
			}
		}

		private void UpdateMuteButtonColors()
		{
			List<MonkeDevNetworkingPlayer> players = GetPlayers();
			SortPlayers(players);
			int start = _page * PerPage;
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < PerPage; i++)
			{
				Renderer rend = (i < _muteButtonRenderers.Count) ? _muteButtonRenderers[i] : null;
				int index = start + i;
				bool hasPlayer = index < players.Count;
				bool muted = hasPlayer && LocalMutes.IsMuted(players[index].photonView.Owner?.UserId);
				if ((bool)rend)
				{
					SetRendererColor(rend, (hasPlayer && muted) ? MutedColor : UnmutedColor);
				}
				if (i > 0)
				{
					sb.Append("\n\n");
				}
				sb.Append(muted ? "UNMUTE" : "MUTE");
			}
			if ((bool)_muteLabelsText)
			{
				_muteLabelsText.text = sb.ToString();
			}
		}

		private void WireButton(string goName, Action onClick)
		{
			Transform[] componentsInChildren = GetComponentsInChildren<Transform>(true);
			foreach (Transform t in componentsInChildren)
			{
				if (t.name == goName)
				{
					LeaderboardButton button = t.GetComponent<LeaderboardButton>() ?? t.gameObject.AddComponent<LeaderboardButton>();
					button.OnPressed += onClick;
					break;
				}
			}
		}
	}
}
