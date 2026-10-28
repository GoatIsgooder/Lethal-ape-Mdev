using UnityEngine;

namespace LethalApeR.Gameplay
{
	public struct BlastInfo
	{
		public Vector3 center;

		public float innerRadius;

		public float radius;

		public float knockbackSpeed;

		public float maxSpeed;

		public float upwardBias;

		public float letGoSeconds;

		public float stunSeconds;

		public float selfScale;

		public float propImpulse;

		public float maxPropSpeed;

		public Object instigator;

		public Object source;
	}
}
