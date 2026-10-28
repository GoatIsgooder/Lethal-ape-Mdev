using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.Opposer
{
	public class OpposerGameMode : MonoBehaviour
	{
		public static OpposerGameMode Instance;

		public List<OpposerPlayer> allPlayers = new List<OpposerPlayer>();

		private void Awake()
		{
			Instance = this;
		}

		public void OnPlayerDeath(OpposerPlayer victim, OpposerPlayer killer)
		{
		}
	}
}
