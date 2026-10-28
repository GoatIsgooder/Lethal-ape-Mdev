using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Required/Leave Custom Map")]
	[DisallowMultipleComponent]
	public sealed class LeaveMapPlacement : PlacementMarker
	{
		public override PlacementKind Kind => PlacementKind.LeaveMap;
	}
}
