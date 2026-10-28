using System.Collections.Generic;
using LethalApe.SDK;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

namespace LethalApeR.CustomMaps
{
	public sealed class LoadedMap
	{
		public MapPackage Package;

		public AssetBundle Bundle;

		public Scene Scene;

		public MapDescriptor Descriptor;

		public MapSettings Settings;

		public NavMeshDataInstance NavMesh;

		public readonly List<Material> CreatedMaterials = new List<Material>();

		public MapSanitizer.Report Sanitized;

		public string Key => Package.Key;
	}
}
