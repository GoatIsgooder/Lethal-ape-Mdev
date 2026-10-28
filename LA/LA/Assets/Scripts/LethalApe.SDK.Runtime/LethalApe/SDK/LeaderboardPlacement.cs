using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Required/Leaderboard")]
	[DisallowMultipleComponent]
	public sealed class LeaderboardPlacement : PlacementMarker
	{
		public override PlacementKind Kind => PlacementKind.Leaderboard;
	}
}
