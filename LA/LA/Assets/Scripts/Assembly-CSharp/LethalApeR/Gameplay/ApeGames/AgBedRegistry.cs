using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgBedRegistry : MonoBehaviour
	{
		public List<AgBed> beds = new List<AgBed>();

		public static AgBedRegistry Instance { get; private set; }

		public int Count
		{
			get
			{
				if (beds == null)
				{
					return 0;
				}
				return beds.Count;
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public AgBed GetBedForActor(int actor)
		{
			if (beds == null || actor < 1 || beds.Count == 0)
			{
				return null;
			}
			return beds[(actor - 1) % beds.Count];
		}

		public bool TryGetSpawn(int actor, out Vector3 position, out Quaternion rotation, out bool forceLook)
		{
			AgBed bedForActor = GetBedForActor(actor);
			if (bedForActor == null)
			{
				position = default(Vector3);
				rotation = default(Quaternion);
				forceLook = false;
				return false;
			}
			position = bedForActor.SpawnPosition;
			rotation = bedForActor.LookRotation();
			forceLook = bedForActor.forceLook;
			return true;
		}
	}
}
