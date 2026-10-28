using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public interface IBtmRayTarget
	{
		bool RayEnabled { get; }

		bool TryHit(Ray ray, float maxDistance, out Vector3 point, out float distance);

		bool OnRayHover(Vector3 worldPoint);

		void OnRayExit();

		void OnRayClick(Vector3 worldPoint);

		void OnRayPress(bool pressed);
	}
}
