using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	[CreateAssetMenu(menuName = "Slop/Pumpkin Launcher Kind", fileName = "Pumpkin Launcher Kind")]
	public class PumpkinLauncherKind : ScriptableObject
	{
		[Tooltip("Sent to other players to name this launcher. Keep it stable once shipped.")]
		public string id = "pumpkin";

		[Tooltip("Other players' copies of a held launcher are built from this prefab.")]
		public PumpkinLauncher prefab;
	}
}
