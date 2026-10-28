using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public abstract class AgRoundBase : MonoBehaviour
	{
		public GameObject roundRoot;

		public RandomizeSpawnPoint playersTp;

		public RandomizeSpawnPoint secondaryTp;

		public abstract int RoundIndex { get; }

		public virtual void OnRoundPrepare(AgRoundProperties p)
		{
			if ((bool)roundRoot)
			{
				roundRoot.SetActive(value: true);
			}
		}

		public virtual void OnRoundCleanup()
		{
			if ((bool)roundRoot)
			{
				roundRoot.SetActive(value: false);
			}
		}

		public virtual void LocalTick(double elapsed, AgRoundProperties p)
		{
		}

		public virtual void MasterTick(double elapsed, AgRoundProperties p)
		{
		}

		public virtual bool MasterWantsEarlyEnd(AgRoundProperties p)
		{
			return false;
		}

		public virtual RandomizeSpawnPoint GetSpawnFor(int actor, AgRoundProperties p)
		{
			return playersTp;
		}
	}
}
