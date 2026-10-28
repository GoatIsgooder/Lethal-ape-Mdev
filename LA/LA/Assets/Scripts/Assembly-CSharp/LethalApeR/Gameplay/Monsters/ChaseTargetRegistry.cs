using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public static class ChaseTargetRegistry
	{
		private static readonly List<Transform> _targets = new List<Transform>();

		public static IReadOnlyList<Transform> Targets => _targets;

		public static void Register(Transform t)
		{
			if (t != null && !_targets.Contains(t))
			{
				_targets.Add(t);
			}
		}

		public static void Unregister(Transform t)
		{
			_targets.Remove(t);
		}
	}
}
