using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	[CreateAssetMenu(fileName = "RankIcons", menuName = "Rivals/Rank Icons")]
	public class RivalsRankIcons : ScriptableObject
	{
		[Tooltip("One sprite per rank: Rookie, Bronze, Silver, Gold, Platinum, Diamond, Master, Elite, Legend, Champion.")]
		public Sprite[] icons = new Sprite[10];

		public Sprite GetIcon(RivalsRank rank)
		{
			if (rank < RivalsRank.Rookie || icons == null || (int)rank >= icons.Length)
			{
				return null;
			}
			return icons[(int)rank];
		}

		private void OnValidate()
		{
			if (icons != null && icons.Length != 10)
			{
				Debug.LogWarning(string.Format("[RivalsRankIcons] Expected {0} icons (one per rank), found {1}.", 10, icons.Length), this);
			}
		}
	}
}
