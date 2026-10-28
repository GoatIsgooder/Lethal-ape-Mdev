using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Vehicles
{
	public interface IVehicleSeatHost
	{
		Transform transform { get; }

		void OnDriverSeated();

		void OnDriverLeft();

		bool IsOwnCollider(Collider c);

		void CollectColliderRoots(List<Transform> roots);
	}
}
