using System.Collections.Generic;
using System.Text;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class ReadyPadRosterDisplay : MonoBehaviour
	{
		[Tooltip("The pad group this board shows (must match a group id on RivalsReadyPads).")]
		public string groupId = "1v1";

		[Header("One text per side")]
		public TMP_Text teamAText;

		public TMP_Text teamBText;

		[Header("Formatting")]
		[Tooltip("Shown for a pad nobody is standing on.")]
		public string emptySlotText = "WAITING...";

		[Tooltip("Shown for a bot/dummy occupant (solo testing).")]
		public string botName = "BOT";

		[Tooltip("The line drawn between names on 2v2 sides.")]
		public string dividerText = "─────";

		[Tooltip("Tint occupied names with the team color.")]
		public bool tintOccupiedNames = true;

		[Tooltip("Catch-all refresh (covers renames / late joins). Pad changes refresh instantly.")]
		public float refreshInterval = 1f;

		private float _nextRefresh;

		private void OnEnable()
		{
			RivalsReadyPads.OnOccupancyChanged += Refresh;
			Refresh();
		}

		private void OnDisable()
		{
			RivalsReadyPads.OnOccupancyChanged -= Refresh;
		}

		private void Update()
		{
			if (!(Time.time < _nextRefresh))
			{
				Refresh();
			}
		}

		public void Refresh()
		{
			_nextRefresh = Time.time + Mathf.Max(0.25f, refreshInterval);
			RivalsReadyPads instance = RivalsReadyPads.Instance;
			if (instance != null)
			{
				RivalsReadyPads.PadGroup group = instance.GetGroup(groupId);
				if (group != null)
				{
					if (teamAText != null)
					{
						teamAText.text = BuildSide(group.teamAPads, Team.TeamA);
					}
					if (teamBText != null)
					{
						teamBText.text = BuildSide(group.teamBPads, Team.TeamB);
					}
					return;
				}
			}
			if (teamAText != null)
			{
				teamAText.text = "";
			}
			if (teamBText != null)
			{
				teamBText.text = "";
			}
		}

		private string BuildSide(List<ReadyPad> sidePads, Team team)
		{
			StringBuilder stringBuilder = new StringBuilder();
			bool flag = true;
			foreach (ReadyPad sidePad in sidePads)
			{
				if (sidePad == null)
				{
					continue;
				}
				for (int i = 0; i < sidePad.Capacity; i++)
				{
					if (!flag)
					{
						stringBuilder.Append('\n');
						if (!string.IsNullOrEmpty(dividerText))
						{
							stringBuilder.Append(dividerText);
							stringBuilder.Append('\n');
						}
					}
					flag = false;
					stringBuilder.Append((i < sidePad.Occupants.Count) ? NameFor(sidePad.Occupants[i], team) : emptySlotText);
				}
			}
			return stringBuilder.ToString();
		}

		private string NameFor(int actor, Team team)
		{
			string text;
			if (actor < 0)
			{
				text = botName;
			}
			else if (PhotonNetwork.InRoom)
			{
				Player player = PhotonNetwork.CurrentRoom.GetPlayer(actor);
				text = ((player != null && !string.IsNullOrEmpty(player.NickName)) ? player.NickName : string.Format("PLAYER {0}", actor));
			}
			else
			{
				text = PlayerPrefs.GetString("Username", "YOU");
			}
			if (tintOccupiedNames)
			{
				text = "<color=#" + ColorUtility.ToHtmlStringRGB(team.ToColor()) + ">" + text + "</color>";
			}
			return text;
		}
	}
}
