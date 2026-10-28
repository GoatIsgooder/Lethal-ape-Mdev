using System;
using UnityEngine;

namespace LethalApeR
{
	[Serializable]
	public struct WaypointSet
	{
		public WaypointSetType type;

		public Transform[] waypoints;
	}
}
