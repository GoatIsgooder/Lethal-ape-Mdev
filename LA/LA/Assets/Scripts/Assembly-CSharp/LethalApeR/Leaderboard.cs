using System;
using System.Text;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR
{
	public class Leaderboard : MonoBehaviourPunCallbacks
	{
		public TMP_Text leaderboardText;

		public TMP_Text roomCodeText;

		public int currentPage;

		public TMP_Text pageText;

		private const int RowsPerPage = 10;

		private const float MinRedrawInterval = 0.1f;

		private readonly StringBuilder _rows = new StringBuilder();

		private float _lastRedraw;

		private static int RoomPlayerCount
		{
			get
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
				{
					return 0;
				}
				return PhotonNetwork.CurrentRoom.PlayerCount;
			}
		}

		private static int PageCount => Math.Max(1, Mathf.CeilToInt((float)RoomPlayerCount / (float)RowsPerPage));

		private void Start()
		{
			ClampPage();
			Redraw();
		}

		public override void OnJoinedRoom()
		{
			Redraw();
		}

		public override void OnLeftRoom()
		{
			Redraw();
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			Redraw();
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			Redraw();
		}

		public override void OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
		{
			Redraw();
		}

		public void NextPage()
		{
			TurnPage(1);
		}

		public void PrevPage()
		{
			TurnPage(-1);
		}

		private void TurnPage(int step)
		{
			currentPage += step;
			ClampPage();
			Redraw();
		}

		private void ClampPage()
		{
			currentPage = Mathf.Clamp(currentPage, 0, PageCount - 1);
		}

		private void Redraw()
		{
			if (!(Time.time - _lastRedraw < MinRedrawInterval))
			{
				_lastRedraw = Time.time;
				ClampPage();
				DrawRoomCode();
				DrawRows();
				if ((bool)pageText)
				{
					pageText.text = string.Format("{0}/{1}", currentPage + 1, PageCount);
				}
			}
		}

		private void DrawRoomCode()
		{
			if ((bool)roomCodeText)
			{
				Room currentRoom = PhotonNetwork.CurrentRoom;
				if (currentRoom == null)
				{
					roomCodeText.text = "";
					return;
				}
				string text = ((currentRoom.IsVisible && currentRoom.IsOpen) ? "<color=#4DFF61>PUBLIC</color>" : "<color=#FF3B3B>PRIVATE</color>");
				roomCodeText.text = text + " CODE: " + currentRoom.Name;
			}
		}

		private void DrawRows()
		{
			if ((bool)leaderboardText)
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.CurrentRoom == null)
				{
					leaderboardText.text = "";
					return;
				}
				Player[] playerList = PhotonNetwork.PlayerList;
				int num = currentPage * RowsPerPage;
				int num2 = Mathf.Min(num + RowsPerPage, playerList.Length);
				_rows.Length = 0;
				for (int i = num; i < num2; i++)
				{
					AppendRow(i + 1, playerList[i]);
				}
				leaderboardText.text = _rows.ToString();
			}
		}

		private void AppendRow(int rank, Player player)
		{
			string text = player.NickName;
			if (string.IsNullOrEmpty(text))
			{
				text = string.Format("Player{0}", player.ActorNumber);
			}
			string text2 = ((player == PhotonNetwork.LocalPlayer) ? "<color=#90FFAD><b>[You]</b></color>" : BadgeFor(player));
			string text3 = ShortId(player);
			if (text2.Length > 0)
			{
				_rows.AppendLine(string.Format("{0}. {1} {2} #{3}", rank, text2, text, text3));
			}
			else
			{
				_rows.AppendLine(string.Format("{0}. {1} #{2}", rank, text, text3));
			}
		}

		private static string ShortId(Player player)
		{
			string text = player?.UserId;
			if (string.IsNullOrEmpty(text))
			{
				return "UNKNOWN";
			}
			if (text.Length <= 6)
			{
				return text;
			}
			return text.Substring(0, 6);
		}

		private static string BadgeFor(Player player)
		{
			if (player == null || player.CustomProperties == null)
			{
				return "";
			}
			if (!player.CustomProperties.TryGetValue("NameTag", out var value) || value == null)
			{
				return "";
			}
			return value.ToString() switch
			{
				"VIP_TAG" => "<color=#FFFE3A>[VIP]</color>", 
				"BETATESTER_TAG" => "<color=#58A7BA>[TESTER]</color>", 
				"MODERATOR_TAG" => "<color=#BF60FF><b>[MOD]</b></color>", 
				"ADMIN_TITLE" => "<color=#FC59FF><b>[ADMIN]</b></color>", 
				"OWNER_TITLE" => "<color=#34D9FF><b>[OWNER]</b></color>", 
				_ => "", 
			};
		}
	}
}
