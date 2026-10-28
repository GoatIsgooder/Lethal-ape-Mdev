using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Required/Computer + Table")]
	[DisallowMultipleComponent]
	public sealed class ComputerStationPlacement : PlacementMarker
	{
		public override PlacementKind Kind => PlacementKind.ComputerStation;
	}
}
