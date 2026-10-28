using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using TMPro;
using UnityEngine.UI;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class BTMMapVoteButton : BaseButton
	{
		public TMP_Text MapNameText;

		public TMP_Text VoteText;

		public Image MapPreview;

		public string mapId { get; private set; }

		public bool isInitialized { get; private set; }

		public void Init(MapData data)
		{
			MapNameText.text = data.displayName;
			MapPreview.sprite = data.mapPreview;
			ShowVoteCount(0);
			mapId = data.sceneId;
			isInitialized = true;
		}

		public void SetVotes(int count)
		{
			ShowVoteCount(isInitialized ? count : 0);
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (isInitialized)
			{
				BTMGameManager.SetMapVote(mapId);
			}
		}

		private void ShowVoteCount(int votes)
		{
			VoteText.text = votes.ToString();
		}
	}
}
