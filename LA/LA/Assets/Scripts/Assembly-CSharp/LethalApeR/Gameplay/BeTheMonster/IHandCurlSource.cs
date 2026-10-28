using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public interface IHandCurlSource
	{
		bool TryGetCurl(bool left, out Vector3 curl);
	}
}
