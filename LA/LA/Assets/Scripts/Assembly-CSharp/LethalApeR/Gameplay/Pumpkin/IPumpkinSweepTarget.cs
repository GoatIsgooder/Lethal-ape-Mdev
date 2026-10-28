using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	public interface IPumpkinSweepTarget
	{
		bool SweepPumpkin(Vector3 from, Vector3 delta, float radius, ref float first, ref Vector3 normal);
	}
}
