using System;
using LethalApeR.Gameplay.Fnaf;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmGhostRules
	{
		public static bool IsDead(int actor, bool roundActive, int[] originalSurvivors, int[] alive, int[] escaped, int[] monsters)
		{
			if (actor <= 0 || !roundActive)
			{
				return false;
			}
			if (!Has(originalSurvivors, actor) || Has(alive, actor) || Has(escaped, actor))
			{
				return false;
			}
			return !Has(monsters, actor);
		}

		public static BtmGhostViewer Viewer(int actor, bool roundActive, int[] alive, int[] monsters)
		{
			if (!roundActive)
			{
				return BtmGhostViewer.Plain;
			}
			if (Has(monsters, actor))
			{
				return BtmGhostViewer.Monster;
			}
			if (!Has(alive, actor))
			{
				return BtmGhostViewer.Plain;
			}
			return BtmGhostViewer.Survivor;
		}

		public static bool PresentsAsGhost(bool dead, bool inMap, bool inSpawn)
		{
			return dead && inMap && !inSpawn;
		}

		public static bool InMap(Bounds map, Vector3 head, float margin)
		{
			map.Expand(margin * 2f);
			return map.Contains(head);
		}

		public static bool SkeletonVisible(BtmGhostViewer viewer, float distance, float hideBeyond)
		{
			switch (viewer)
			{
			case BtmGhostViewer.Plain:
				return true;
			case BtmGhostViewer.Survivor:
				return distance <= hideBeyond;
			default:
				return false;
			}
		}

		public static bool NameVisible(BtmGhostViewer viewer)
		{
			return viewer == BtmGhostViewer.Plain;
		}

		public static FnVoiceMode VoiceMode(bool speakerDead, BtmGhostViewer viewer, float distance, float silentBeyond)
		{
			if (!speakerDead || viewer == BtmGhostViewer.Plain)
			{
				return FnVoiceMode.Plain;
			}
			if (viewer == BtmGhostViewer.Monster || !(distance < silentBeyond))
			{
				return FnVoiceMode.Silent;
			}
			return FnVoiceMode.Scrambled;
		}

		public static bool CollidersOff(bool presentsAsGhost, bool isOwner)
		{
			return presentsAsGhost && !isOwner;
		}

		public static bool HasPanel(bool roundActive, bool localDead)
		{
			return roundActive && localDead;
		}

		public static int FollowCandidates(int[] alive, int self, int[] into)
		{
			int count = 0;
			if (alive == null || into == null)
			{
				return 0;
			}
			for (int i = 0; i < alive.Length; i++)
			{
				if (count >= into.Length)
				{
					break;
				}
				int actor = alive[i];
				if (actor > 0 && actor != self && Array.IndexOf(into, actor, 0, count) < 0)
				{
					int j = count;
					while (j > 0 && into[j - 1] > actor)
					{
						into[j] = into[j - 1];
						j--;
					}
					into[j] = actor;
					count++;
				}
			}
			return count;
		}

		public static bool Has(int[] list, int actor)
		{
			if (list != null)
			{
				return Array.IndexOf(list, actor) >= 0;
			}
			return false;
		}
	}
}
