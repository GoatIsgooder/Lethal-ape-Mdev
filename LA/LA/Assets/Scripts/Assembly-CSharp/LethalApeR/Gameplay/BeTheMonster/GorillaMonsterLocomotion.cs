using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class GorillaMonsterLocomotion : IMonsterLocomotion
	{
		public MonsterLocomotionType Type => default(MonsterLocomotionType);

		public Vector3 PlanarVelocity => Vector3.zero;

		public float CrouchAmount => 0f;

		public float LeanAngle => 0f;

		public void Activate(MonsterDefinition def, BtmConfig cfg, Player player)
		{
		}

		public void Tick(float dt)
		{
		}

		public void Deactivate()
		{
		}
	}
}
