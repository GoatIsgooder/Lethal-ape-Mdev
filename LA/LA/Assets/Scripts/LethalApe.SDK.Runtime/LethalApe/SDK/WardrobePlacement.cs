using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Required/Wardrobe")]
	[DisallowMultipleComponent]
	public sealed class WardrobePlacement : PlacementMarker
	{
		public override PlacementKind Kind => PlacementKind.Wardrobe;
	}
}
