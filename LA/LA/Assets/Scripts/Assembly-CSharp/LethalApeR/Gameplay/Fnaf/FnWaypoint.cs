using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnWaypoint : MonoBehaviour
	{
		[Tooltip("Walkable straight-line connections. Links are bidirectional: listing a node on either end is enough.")]
		public FnWaypoint[] links = new FnWaypoint[0];

		[Header("Office")]
		[Tooltip("The hall spot just outside an office door. Exactly one per side. No edge may enter the office.")]
		public bool officeDoorOutside;

		public FnDoorSide side;

		[Header("Roles")]
		[Tooltip("Floor spot below a climbable perch: an animatronic waits here for a perched guard.")]
		public bool perchBase;

		[Tooltip("A corner guards hide in: searching animatronics check these first.")]
		public bool hiding;

		[Tooltip("Extra names this node answers to in favouriteNodes (e.g. every kitchen node tagged \"Kitchen\").")]
		public string[] tags = new string[0];

		public int Index { get; internal set; } = -1;

		public bool Matches(string key)
		{
			if (string.IsNullOrEmpty(key))
			{
				return false;
			}
			if (base.name == key)
			{
				return true;
			}
			if (tags == null)
			{
				return false;
			}
			for (int i = 0; i < tags.Length; i++)
			{
				if (tags[i] == key)
				{
					return true;
				}
			}
			return false;
		}

		public bool Passes(FnNodeFilter filter)
		{
			switch (filter)
			{
			case FnNodeFilter.Patrol:
				return !officeDoorOutside;
			case FnNodeFilter.Hiding:
				if (hiding)
				{
					return !officeDoorOutside;
				}
				return false;
			case FnNodeFilter.PerchBase:
				return perchBase;
			case FnNodeFilter.DoorOutside:
				return officeDoorOutside;
			default:
				return true;
			}
		}

		private void OnDrawGizmosSelected()
		{
			if (links == null)
			{
				return;
			}
			Gizmos.color = new Color(1f, 0.8f, 0.2f, 1f);
			for (int i = 0; i < links.Length; i++)
			{
				if (links[i] != null)
				{
					Gizmos.DrawLine(base.transform.position + Vector3.up * 0.05f, links[i].transform.position + Vector3.up * 0.05f);
				}
			}
		}
	}
}
