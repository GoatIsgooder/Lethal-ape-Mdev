using UnityEngine;

namespace LethalApeR.Rivals.Economy
{
	[CreateAssetMenu(fileName = "EconomyConfig", menuName = "LethalApeR/Rivals/Economy Config")]
	public class EconomyConfig : ScriptableObject
	{
		[Header("Combat awards")]
		[Tooltip("Coins granted to the killer for a kill.")]
		[Min(0f)]
		public int coinsPerKill = 50;

		[Tooltip("Coins granted for assisting a kill (damaged the victim recently).")]
		[Min(0f)]
		public int coinsPerAssist = 20;

		[Header("Round / match awards")]
		[Tooltip("Coins granted to each member of the winning team at round end.")]
		[Min(0f)]
		public int coinsPerRoundWin = 100;

		[Tooltip("Coins granted to each member of the team that wins the match.")]
		[Min(0f)]
		public int coinsPerMatchWin = 250;

		[Header("Objectives")]
		[Tooltip("Coins granted for completing a map objective (capture, etc.).")]
		[Min(0f)]
		public int coinsPerObjective = 75;

		[Header("Starting balance")]
		[Tooltip("Coins a brand-new player starts with on first launch.")]
		[Min(0f)]
		public int startingBalance;
	}
}
