using System.Collections.Generic;
using UnityEngine;

namespace LALocomotion
{
	public sealed class LAContact
	{
		public readonly Collider collider;

		public Vector3 resolved;

		public bool touching;

		public bool wasTouching;

		public Collider lastHit;

		public Vector3 lastNormal = Vector3.up;

		internal Transform rideTransform;

		internal Vector3 rideLocal;

		internal Quaternion rideRotation;

		internal bool ghost;

		internal readonly List<Collider> ghostIgnores = new List<Collider>();

		internal bool Present
		{
			get
			{
				if (collider != null && collider.enabled)
				{
					return collider.gameObject.activeInHierarchy;
				}
				return false;
			}
		}

		// RE: unsure - asm dump stops after the ghost check; the fall-through is assumed to be Present
		internal bool Live => !ghost && Present;

		internal LAContact(Collider collider, Vector3 position)
		{
			this.collider = collider;
			resolved = position;
		}

		internal void Reset(Vector3 position)
		{
			resolved = position;
			touching = false;
			wasTouching = false;
			lastHit = null;
			lastNormal = Vector3.up;
			rideTransform = null;
		}
	}
}
