using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Required/Update Board")]
	[DisallowMultipleComponent]
	public sealed class UpdateBoardPlacement : PlacementMarker
	{
		public override PlacementKind Kind => PlacementKind.UpdateBoard;
	}
}
