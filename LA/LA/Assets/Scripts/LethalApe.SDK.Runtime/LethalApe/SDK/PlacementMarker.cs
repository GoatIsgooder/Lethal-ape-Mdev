using UnityEngine;

namespace LethalApe.SDK
{
	public abstract class PlacementMarker : MapComponent
	{
		public abstract PlacementKind Kind { get; }

		public Vector3 Size => PlacementSpecs.Size(Kind);

		public Bounds LocalBounds => PlacementSpecs.LocalBounds(Kind);
	}
}
