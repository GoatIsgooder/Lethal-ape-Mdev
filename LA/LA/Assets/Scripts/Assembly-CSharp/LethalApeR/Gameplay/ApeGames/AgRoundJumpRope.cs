using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoundJumpRope : AgRoundBase
	{
		[SerializeField]
		private AgRopeSpinner spinner;

		public override int RoundIndex => 1;

		public override void OnRoundPrepare(AgRoundProperties p)
		{
			base.OnRoundPrepare(p);
			if (spinner != null)
			{
				spinner.ResetForRound();
			}
		}

		public override void LocalTick(double elapsed, AgRoundProperties p)
		{
			if (!(spinner == null) && p != null)
			{
				spinner.Tick(p.startTime);
			}
		}
	}
}
