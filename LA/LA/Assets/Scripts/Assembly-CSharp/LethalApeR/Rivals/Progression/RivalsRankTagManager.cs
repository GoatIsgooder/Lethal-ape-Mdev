using System.Collections;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using LethalApeR.Rivals.UI;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	public class RivalsRankTagManager : MonoBehaviourPunCallbacks
	{
		[Header("Art")]
		[Tooltip("Rank icon set. Optional — without it tags show colored rank text only.")]
		public RivalsRankIcons rankIcons;

		[Header("Behaviour")]
		[Tooltip("Also show a tag above the LOCAL player's own nameplate (mostly for mirrors — remotes always see your tag regardless).")]
		public bool showLocalPlayerTag;

		[Tooltip("Seconds between scans for newly spawned players.")]
		public float scanInterval = 2f;

		[Header("Layout (multiples of the nameplate's font size)")]
		[Tooltip("Level text size relative to the name text.")]
		public float textScale = 0.65f;

		[Tooltip("Gap between the name and the rank line, in name line-heights.")]
		public float lineGap = 1.1f;

		[Tooltip("Rank icon height, in name line-heights.")]
		public float iconSize = 1.2f;

		private void Start()
		{
			RivalsXpPanel.RankIcons = rankIcons;
			StartCoroutine(ScanLoop());
		}

		private IEnumerator ScanLoop()
		{
			WaitForSeconds wait = new WaitForSeconds(Mathf.Max(0.5f, scanInterval));
			while (true)
			{
				AttachMissingTags();
				yield return wait;
			}
		}

		private void AttachMissingTags()
		{
			MonkeDevNetworkingPlayer[] players = Object.FindObjectsOfType<MonkeDevNetworkingPlayer>();
			foreach (MonkeDevNetworkingPlayer player in players)
			{
				if (!(player == null) && !(player.GetComponent<RivalsRankTag>() != null) && !(player.GetComponentInChildren<RivalsNameplate>(true) != null) && (showLocalPlayerTag || !(player.photonView != null) || !player.photonView.IsMine))
				{
					player.gameObject.AddComponent<RivalsRankTag>().Init(player, rankIcons, textScale, lineGap, iconSize);
				}
			}
		}

		public override void OnPlayerPropertiesUpdate(Player targetPlayer, ExitGames.Client.Photon.Hashtable changedProps)
		{
			if (changedProps == null || (!changedProps.ContainsKey(RivalsProgression.LevelProp) && !changedProps.ContainsKey(RivalsRanked.RpProp)))
			{
				return;
			}
			RivalsRankTag[] tags = Object.FindObjectsOfType<RivalsRankTag>();
			foreach (RivalsRankTag tag in tags)
			{
				if (tag != null)
				{
					tag.Refresh();
				}
			}
		}
	}
}
