using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmCutMeshLibrary : ScriptableObject
	{
		[Serializable]
		public struct Entry
		{
			public Mesh source;

			public string resource;

			[Tooltip("Fingerprint of the source mesh when it was baked; a changed mesh is baked again.")]
			public string hash;
		}

		public const string ResourcePath = "BtmCut/BtmCutMeshLibrary";

		public List<Entry> entries = new List<Entry>();
	}
}
