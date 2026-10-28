using System;
using LethalApe.SDK;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[CreateAssetMenu(menuName = "Slop/Custom Maps/Placement Prefab Set", fileName = "PlacementPrefabSet")]
	public sealed class PlacementPrefabSet : ScriptableObject
	{
		[Serializable]
		public struct Entry
		{
			public PlacementKind kind;

			public GameObject prefab;

			public Vector3 localPosition;

			public Vector3 localEuler;

			[Tooltip("Measured footprint of the prefab in placement space; compared against the SDK box size.")]
			public Vector3 measuredSize;
		}

		[SerializeField]
		private Entry[] entries = Array.Empty<Entry>();

		public Entry[] Entries => entries;

		public bool TryGet(PlacementKind kind, out Entry entry)
		{
			Entry[] array = entries;
			foreach (Entry e in array)
			{
				if (e.kind == kind && e.prefab != null)
				{
					entry = e;
					return true;
				}
			}
			entry = default(Entry);
			return false;
		}
	}
}
