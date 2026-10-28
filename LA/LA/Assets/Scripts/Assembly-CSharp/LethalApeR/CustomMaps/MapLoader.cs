using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using LethalApe.SDK;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace LethalApeR.CustomMaps
{
	public static class MapLoader
	{
		public static IEnumerator Load(MapPackage package, MapShaderLibrary shaders, Action<LoadedMap, string> done)
		{
			if (!MapCompatibility.Check(package.Manifest, out var reason))
			{
				done(null, reason);
				yield break;
			}
			if (!File.Exists(package.BundlePath))
			{
				done(null, "The map's files are missing. Reinstall it.");
				yield break;
			}
			AssetBundleCreateRequest bundleRequest = AssetBundle.LoadFromFileAsync(package.BundlePath, package.Manifest.bundleCrc);
			yield return bundleRequest;
			AssetBundle bundle = bundleRequest.assetBundle;
			if (bundle == null)
			{
				done(null, "The map's files are damaged. Reinstall it.");
				yield break;
			}
			string[] scenePaths = bundle.GetAllScenePaths();
			if (scenePaths.Length != 1)
			{
				bundle.Unload(true);
				done(null, "The map file doesn't contain exactly one scene.");
				yield break;
			}
			string scenePath = scenePaths[0];
			if (SceneUtility.GetBuildIndexByScenePath(scenePath) >= 0)
			{
				bundle.Unload(true);
				done(null, "The map's scene name clashes with a game scene. Rename it in the SDK and rebuild.");
				yield break;
			}
			AsyncOperation op = SceneManager.LoadSceneAsync(scenePath, LoadSceneMode.Additive);
			if (op == null)
			{
				bundle.Unload(true);
				done(null, "The map's scene couldn't be opened.");
				yield break;
			}
			yield return op;
			Scene scene = SceneManager.GetSceneByPath(scenePath);
			if (!scene.IsValid() || !scene.isLoaded)
			{
				bundle.Unload(true);
				done(null, "The map's scene failed to load.");
				yield break;
			}
			LoadedMap map = new LoadedMap
			{
				Package = package,
				Bundle = bundle,
				Scene = scene
			};
			map.Sanitized = MapSanitizer.Apply(scene);
			if (!MapSanitizer.WithinBudget(map.Sanitized, out var over))
			{
				yield return Unload(map);
				done(null, "This map is too heavy for Quest (" + over + ").");
				yield break;
			}
			GameObject[] roots = scene.GetRootGameObjects();
			foreach (GameObject root in roots)
			{
				if (map.Descriptor == null)
				{
					map.Descriptor = root.GetComponentInChildren<MapDescriptor>(true);
				}
				if (map.Settings == null)
				{
					map.Settings = root.GetComponentInChildren<MapSettings>(true);
				}
			}
			if (map.Descriptor == null || map.Settings == null)
			{
				yield return Unload(map);
				done(null, "This map is missing its Map Descriptor.");
				yield break;
			}
			MapShaderRemapper.Apply(scene, shaders, map.CreatedMaterials);
			SetProbeUsage(scene, map.Sanitized.HasLightProbes);
			MapNavMesh navMesh = map.Descriptor.GetComponent<MapNavMesh>();
			if (navMesh != null && navMesh.Data != null)
			{
				map.NavMesh = NavMesh.AddNavMeshData(navMesh.Data);
			}
			LightProbes.TetrahedralizeAsync();
			done(map, null);
		}

		public static IEnumerator Unload(LoadedMap map)
		{
			if (map.NavMesh.valid)
			{
				map.NavMesh.Remove();
			}
			if (map.Scene.IsValid() && map.Scene.isLoaded)
			{
				AsyncOperation op = SceneManager.UnloadSceneAsync(map.Scene);
				if (op != null)
				{
					yield return op;
				}
			}
			foreach (Material m in map.CreatedMaterials)
			{
				if (m != null)
				{
					UnityEngine.Object.Destroy(m);
				}
			}
			map.CreatedMaterials.Clear();
			MapShaderRemapper.Forget();
			if (map.Bundle != null)
			{
				map.Bundle.Unload(true);
			}
			map.Bundle = null;
			LightProbes.TetrahedralizeAsync();
			yield return Resources.UnloadUnusedAssets();
		}

		private static void SetProbeUsage(Scene scene, bool mapHasProbes)
		{
			if (mapHasProbes)
			{
				return;
			}
			List<Renderer> renderers = new List<Renderer>();
			GameObject[] roots = scene.GetRootGameObjects();
			foreach (GameObject root in roots)
			{
				root.GetComponentsInChildren(true, renderers);
				foreach (Renderer r in renderers)
				{
					if (r.lightmapIndex < 0 || r.lightmapIndex >= 65534)
					{
						r.lightProbeUsage = LightProbeUsage.Off;
					}
				}
			}
		}
	}
}
