using UnityEngine;

namespace LethalApe.SDK
{
	public static class PlacementSpecs
	{
		// RE: unsure - array contents come from an InitializeArray data blob not visible in the asm; assumed enum order
		public static readonly PlacementKind[] All = new PlacementKind[6]
		{
			PlacementKind.Leaderboard,
			PlacementKind.CreditsBoard,
			PlacementKind.UpdateBoard,
			PlacementKind.ComputerStation,
			PlacementKind.Wardrobe,
			PlacementKind.LeaveMap
		};

		public static Vector3 Size(PlacementKind kind)
		{
			switch (kind)
			{
			case PlacementKind.Leaderboard:
				return new Vector3(1.28f, 1.93f, 0.13f);
			case PlacementKind.CreditsBoard:
				return new Vector3(2.81f, 1.85f, 0.19f);
			case PlacementKind.UpdateBoard:
				return new Vector3(2.77f, 1.82f, 0.19f);
			case PlacementKind.ComputerStation:
				return new Vector3(1.75f, 1.18f, 0.96f);
			case PlacementKind.Wardrobe:
				return new Vector3(1.49f, 1.33f, 0.82f);
			case PlacementKind.LeaveMap:
				return new Vector3(0.6f, 1.08f, 0.4f);
			default:
				return Vector3.one;
			}
		}

		public static Bounds LocalBounds(PlacementKind kind)
		{
			Vector3 size = Size(kind);
			return new Bounds(new Vector3(0f, size.y * 0.5f, 0f), size);
		}

		public static string DisplayName(PlacementKind kind)
		{
			switch (kind)
			{
			case PlacementKind.Leaderboard:
				return "Leaderboard";
			case PlacementKind.CreditsBoard:
				return "Credits Board";
			case PlacementKind.UpdateBoard:
				return "Update Board";
			case PlacementKind.ComputerStation:
				return "Computer + Table";
			case PlacementKind.Wardrobe:
				return "Wardrobe";
			case PlacementKind.LeaveMap:
				return "Leave Custom Map";
			default:
				return kind.ToString();
			}
		}
	}
}
