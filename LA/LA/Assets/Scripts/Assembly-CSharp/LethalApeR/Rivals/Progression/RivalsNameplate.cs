using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Rivals.Progression
{
	public class RivalsNameplate : MonoBehaviourPunCallbacks
	{
		[Header("Wiring (assign on the prefab)")]
		[Tooltip("The 'Rivals' object — enabled only in the Rivalry gamemode with a known level.")]
		public GameObject displayRoot;

		[Tooltip("TMP text that shows the number level (works with UI and 3D TMP).")]
		public TMP_Text levelText;

		[Tooltip("UI Image that shows the rank icon.")]
		public Image rankImage;

		[Tooltip("Rank icon set (one sprite per rank, Rookie→Champion).")]
		public RivalsRankIcons rankIcons;

		[Header("Options")]
		[Tooltip("Text in front of the level number, e.g. 'LVL '.")]
		public string levelPrefix = "";

		[Tooltip("Tint the level text with the rank color.")]
		public bool tintLevelText;

		[Tooltip("Also show on your own player (you can't see your own head tag in VR; remotes always see it either way).")]
		public bool showOnLocalPlayer;

		[Tooltip("Seconds between refreshes (prop updates also refresh instantly).")]
		public float refreshInterval = 2f;

		private float _nextRefresh;

		private void Start()
		{
			if (displayRoot != null && (displayRoot == base.gameObject || base.transform.IsChildOf(displayRoot.transform)))
			{
				Debug.LogWarning("[RivalsNameplate] This component is on (or under) its own Display Root — once disabled it can never re-enable. Move it to PlayerName or the prefab root.", this);
			}
			Refresh();
		}

		private void Update()
		{
			if (!(Time.time < _nextRefresh))
			{
				Refresh();
			}
		}

		public override void OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
		{
			if (changedProps != null && (changedProps.ContainsKey(RivalsProgression.LevelProp) || changedProps.ContainsKey(RivalsRanked.RpProp)) && base.photonView != null && targetPlayer != null && base.photonView.Owner != null && targetPlayer.ActorNumber == base.photonView.Owner.ActorNumber)
			{
				Refresh();
			}
		}

		public void Refresh()
		{
			_nextRefresh = Time.time + Mathf.Max(0.5f, refreshInterval);
			if (displayRoot == null)
			{
				return;
			}
			if (GamemodeManager.Instance == null)
			{
				displayRoot.SetActive(false);
				return;
			}
			PhotonView view = base.photonView;
			bool isLocal = view == null || view.IsMine;
			if (isLocal && !showOnLocalPlayer)
			{
				displayRoot.SetActive(false);
				return;
			}
			int level;
			bool hasLevel;
			if (isLocal && RivalsProgression.Instance != null)
			{
				level = RivalsProgression.Instance.Level;
				hasLevel = true;
			}
			else
			{
				hasLevel = RivalsProgression.TryGetLevel((view != null) ? view.Owner : null, out level);
			}
			if (!hasLevel || level <= 0)
			{
				displayRoot.SetActive(false);
				return;
			}
			displayRoot.SetActive(true);
			RivalsRank rank;
			if (isLocal)
			{
				rank = RivalsRanked.Rank;
			}
			else
			{
				int rp;
				rank = (RivalsRanked.TryGetRp((view != null) ? view.Owner : null, out rp) ? RankDefs.RankForRp(rp) : RankDefs.RankForLevel(level));
			}
			if (levelText != null)
			{
				levelText.text = levelPrefix + level;
				if (tintLevelText)
				{
					Color color = RankDefs.RankColor(rank);
					color.a = 1f;
					levelText.color = color;
				}
			}
			if (rankImage != null)
			{
				Sprite sprite = ((rankIcons != null) ? rankIcons.GetIcon(rank) : null);
				rankImage.sprite = sprite;
				rankImage.enabled = sprite != null;
			}
		}
	}
}
