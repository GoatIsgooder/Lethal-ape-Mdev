using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class MapVoteButton : BaseButton
	{
		[Header("Vote target")]
		[Tooltip("Index into RivalsMap.All. Ignored if 'Map Display Name' is set and matches a map.")]
		public int mapIndex;

		[Tooltip("Optional: resolve the map by display name instead of index (order-independent).")]
		public string mapDisplayName = "";

		public override void OnButtonPressed(bool isLeft)
		{
			int num = mapIndex;
			if (!string.IsNullOrEmpty(mapDisplayName))
			{
				IReadOnlyList<RivalsMap> all = RivalsMap.All;
				for (int i = 0; i < all.Count; i++)
				{
					if (all[i] != null && all[i].displayName == mapDisplayName)
					{
						num = i;
						break;
					}
				}
			}
			if (GamemodeManager.Instance != null)
			{
				GamemodeManager.Instance.CastMapVote(num);
			}
		}
	}
}
