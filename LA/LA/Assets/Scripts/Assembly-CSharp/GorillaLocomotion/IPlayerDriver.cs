using UnityEngine;

namespace GorillaLocomotion
{
	public interface IPlayerDriver
	{
		float Scale { get; }

		bool IsRidingPlatform { get; }

		Vector3 RidingVelocity { get; }

		void TeleportRig(Vector3 position, Quaternion rotation, bool setRotation, bool resetVelocity);

		void AcceptExternalHeadPosition();

		void TurnRig(float degrees);

		void ReinitializeRig();

		void SlipThisFrame();
	}
}
