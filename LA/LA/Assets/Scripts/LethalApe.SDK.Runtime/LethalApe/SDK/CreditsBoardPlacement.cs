using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Required/Credits Board")]
	[DisallowMultipleComponent]
	public sealed class CreditsBoardPlacement : PlacementMarker
	{
		public override PlacementKind Kind => PlacementKind.CreditsBoard;
	}
}
