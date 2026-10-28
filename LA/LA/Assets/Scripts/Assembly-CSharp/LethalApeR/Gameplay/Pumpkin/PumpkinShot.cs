using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	public sealed class PumpkinShot
	{
		public int shooter;

		public int seq;

		public bool left;

		public Vector3 origin;

		public Vector3 breech;

		public Vector3 direction;

		public int serverMs;

		public bool isLocal;

		public PumpkinProjectile projectile;

		public float startedAt;
	}
}
