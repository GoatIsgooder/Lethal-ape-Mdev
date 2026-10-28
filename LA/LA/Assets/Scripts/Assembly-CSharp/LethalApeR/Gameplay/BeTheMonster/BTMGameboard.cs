using System.Collections.Generic;
using System.Linq;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BTMGameboard : MonoBehaviourPunCallbacks
	{
		public TMP_Text btmActiveText;

		public TMP_Text btmInactiveText;

		public Transform btmMapVoteParent;

		public TMP_Text btmCountdown;

		public Transform btmMapVoteContainer;

		public Transform mapVoteTemplatePrefab;

		private readonly List<BTMMapVoteButton> _mapVoteButtons = new List<BTMMapVoteButton>();

		private bool _mapVotingBuilt;

		public const float VoteButtonSpacing = 0.55f;

		private const float MaxCardScale = 1.25f;

		private void Start()
		{
			btmActiveText.gameObject.SetActive(false);
			btmInactiveText.gameObject.SetActive(true);
			btmMapVoteParent.gameObject.SetActive(false);
			btmInactiveText.text = "<color=#FFD54F><b>JOIN A PUBLIC ROOM</b></color>\n\n\n<alpha=#AA>Cannot start right now\n\n\n<b>";
		}

		public override void OnDisable()
		{
			foreach (BTMMapVoteButton mapVoteButton in _mapVoteButtons)
			{
				mapVoteButton.SetVotes(0);
			}
		}

		private void Update()
		{
			if (BTMGameManager.Instance.roomProperties.queue == "BeTheMonster" && PhotonNetwork.InRoom)
			{
				UpdateBoard(BTMGameManager.Instance.roomProperties);
			}
		}

		private void UpdateBoard(RoundProperties roundProperties)
		{
			if (!roundProperties.roundActive)
			{
				UpdateInactiveText();
				return;
			}
			UpdateActiveText(roundProperties);
			btmActiveText.gameObject.SetActive(true);
			btmInactiveText.gameObject.SetActive(false);
			btmMapVoteParent.gameObject.SetActive(false);
			_mapVotingBuilt = false;
		}

		private void UpdateActiveText(RoundProperties roundProperties)
		{
			int num = (int)RoundProps.GetRemainingTime();
			int num2 = roundProperties.activePlayers.Length;
			int num3 = ((roundProperties.originalActivePlayers != null && roundProperties.originalActivePlayers.Length > 0) ? roundProperties.originalActivePlayers.Length : num2);
			string text = "<b><size=120%>BE THE <color=#E53935>MONSTER</color></size></b>\n\n<alpha=#AA>Round in progress\n\n" + string.Format("<b>Time Remaining</b>\n<color=#FFD54F>{0}</color> sec\n\n", num);
			text += "<b>Monsters</b>\n";
			text = roundProperties.currentMonsters.Select((int monsterActorId) => MonkeDevNetworkingManager.Manager.GetPlayerByActorId(monsterActorId)).Where((MonkeDevNetworkingPlayer plr) => plr).Aggregate(text, (string current, MonkeDevNetworkingPlayer plr) => current + plr.photonView.Owner.NickName + "\n");
			text += string.Format("\n<b>Survivors</b>\n{0}/{1}", num2, num3);
			if (BTMGameManager.Instance != null && BTMGameManager.Instance.TryGetGeneratorProgress(out var powered, out var total))
			{
				text += string.Format("\n\n<b>Generators</b>\n<color=#7CFC8E>{0}</color>/{1}", powered, total);
			}
			btmActiveText.text = text;
		}

		private void UpdateInactiveText()
		{
			btmInactiveText.gameObject.SetActive(true);
			btmActiveText.gameObject.SetActive(false);
			if (PhotonNetwork.CurrentRoom.PlayerCount > 1)
			{
				int num = (int)RoundProps.GetRemainingIntermissionDuration();
				if (RoundProps.IsVotingActive())
				{
					UpdateMapVoting();
					return;
				}
				_mapVotingBuilt = false;
				btmMapVoteParent.gameObject.SetActive(false);
				if (num > 0)
				{
					btmInactiveText.text = string.Format("<color=#FFD54F><b>PLEASE WAIT</b></color>\n\n\n<alpha=#AA>Intermission\n\n\n<b>Wait </b>\n<color=#FFB300>{0}</color> seconds", num);
					return;
				}
				btmInactiveText.text = "<color=#FFD54F><b>STARTING ROUND...</b></color>\n\n\n<alpha=#AA>Loading\n\n\n<b>";
				_mapVotingBuilt = false;
				btmMapVoteParent.gameObject.SetActive(false);
			}
			else
			{
				btmInactiveText.text = "<color=#FFD54F><b>NEED 2 OR MORE PLAYERS</b></color>\n\n\n<alpha=#AA>Cannot start right now\n\n\n<b>";
				btmMapVoteParent.gameObject.SetActive(false);
			}
		}

		private void UpdateMapVoting()
		{
			btmActiveText.gameObject.SetActive(false);
			btmInactiveText.gameObject.SetActive(false);
			btmMapVoteParent.gameObject.SetActive(true);
			btmCountdown.text = ((int)RoundProps.GetRemainingVotingDuration()).ToString();
			if (_mapVotingBuilt)
			{
				RefreshVoteCounts();
				return;
			}
			string[] votingMaps = RoundProps.GetVotingMaps();
			if (votingMaps.Length == 0)
			{
				return;
			}
			foreach (Transform item in btmMapVoteContainer)
			{
				Object.Destroy(item.gameObject);
			}
			_mapVoteButtons.Clear();
			foreach (string mapId in votingMaps)
			{
				MapData mapData = BTMGameManager.Instance.roomSettings.maps.Find((MapData _) => _.sceneId == mapId);
				if (mapData != null)
				{
					BTMMapVoteButton componentInChildren = Object.Instantiate(mapVoteTemplatePrefab, btmMapVoteContainer, false).GetComponentInChildren<BTMMapVoteButton>();
					if ((bool)componentInChildren)
					{
						componentInChildren.Init(mapData);
						_mapVoteButtons.Add(componentInChildren);
					}
				}
			}
			LayoutVoteRow(btmMapVoteContainer);
			if (_mapVoteButtons.Count != 0)
			{
				_mapVotingBuilt = true;
				RefreshVoteCounts();
			}
		}

		public static void LayoutVoteRow(Transform container)
		{
			if (container == null)
			{
				return;
			}
			if (container is RectTransform area && container.TryGetComponent<HorizontalOrVerticalLayoutGroup>(out var component))
			{
				component.enabled = false;
				FitGrid(area, component.spacing, component.padding);
			}
			else if (!container.TryGetComponent<LayoutGroup>(out var _))
			{
				int childCount = container.childCount;
				float num = (float)(childCount - 1) / 2f;
				for (int i = 0; i < childCount; i++)
				{
					container.GetChild(i).localPosition = new Vector3(((float)i - num) * 0.55f, 0f, 0f);
				}
			}
		}

		private static void FitGrid(RectTransform area, float gap, RectOffset padding)
		{
			int childCount = area.childCount;
			if (childCount < 1)
			{
				return;
			}
			float num = 0f;
			float num2 = 0f;
			for (int i = 0; i < childCount; i++)
			{
				if (area.GetChild(i) is RectTransform rectTransform)
				{
					num = Mathf.Max(num, rectTransform.rect.width);
					num2 = Mathf.Max(num2, rectTransform.rect.height);
				}
			}
			if (num <= 0f || num2 <= 0f)
			{
				return;
			}
			float num3 = area.rect.width - (float)padding.horizontal;
			float num4 = area.rect.height - (float)padding.vertical;
			float num5 = 0f;
			int num6 = 1;
			for (int j = 1; j <= childCount; j++)
			{
				int num7 = (childCount + j - 1) / j;
				float num8 = Mathf.Min((num3 - (float)(num7 - 1) * gap) / (num * (float)num7), (num4 - (float)(j - 1) * gap) / (num2 * (float)j));
				if (num8 > num5 + 0.0001f)
				{
					num5 = num8;
					num6 = j;
				}
			}
			float num9 = Mathf.Clamp(num5, 0.05f, 1.25f);
			float num10 = num * num9 + gap;
			float num11 = num2 * num9 + gap;
			int num12 = (childCount + num6 - 1) / num6;
			float num13 = (float)(padding.left - padding.right) / 2f;
			float num14 = (float)(padding.bottom - padding.top) / 2f;
			float num15 = (float)(num6 - 1) / 2f;
			for (int k = 0; k < childCount; k++)
			{
				if (area.GetChild(k) is RectTransform rectTransform2)
				{
					int num16 = k / num12;
					int num17 = k % num12;
					int num18 = ((num16 == num6 - 1) ? (childCount - num16 * num12) : num12);
					rectTransform2.anchorMin = (rectTransform2.anchorMax = new Vector2(0.5f, 0.5f));
					rectTransform2.localScale = new Vector3(num9, num9, 1f);
					rectTransform2.anchoredPosition = new Vector2(num13 + num10 * ((float)num17 - (float)(num18 - 1) / 2f), num14 + num11 * (num15 - (float)num16));
				}
			}
		}

		private void RefreshVoteCounts()
		{
			Dictionary<string, int> dictionary = new Dictionary<string, int>();
			Player[] playerList = PhotonNetwork.PlayerList;
			foreach (Player player in playerList)
			{
				if (player.CustomProperties.TryGetValue("mv", out var value) && value is string key && !dictionary.TryAdd(key, 1))
				{
					dictionary[key]++;
				}
			}
			foreach (BTMMapVoteButton mapVoteButton in _mapVoteButtons)
			{
				mapVoteButton.SetVotes(dictionary.GetValueOrDefault(mapVoteButton.mapId));
			}
		}

		public override void OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
		{
			if (changedProps.ContainsKey("mv"))
			{
				RefreshVoteCounts();
			}
		}

		public override void OnRoomPropertiesUpdate(Hashtable propertiesThatChanged)
		{
			if (propertiesThatChanged.ContainsKey("vm0") || propertiesThatChanged.ContainsKey("vm1") || propertiesThatChanged.ContainsKey("vm2"))
			{
				_mapVotingBuilt = false;
			}
		}
	}
}
