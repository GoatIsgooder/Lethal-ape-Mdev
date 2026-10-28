using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public interface IMonsterLocomotion
	{
		MonsterLocomotionType Type { get; }

		Vector3 PlanarVelocity { get; }

		float CrouchAmount { get; }

		float LeanAngle { get; }

		void Activate(MonsterDefinition def, BtmConfig cfg, Player player);

		void Tick(float dt);

		void Deactivate();
	}
}
