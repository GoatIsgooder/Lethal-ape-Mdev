using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.CustomMaps
{
	public static class MapShaderRemapper
	{
		private static readonly Dictionary<Material, string> Originals = new Dictionary<Material, string>();

		public static void Apply(Scene scene, MapShaderLibrary library, List<Material> createdMaterials)
		{
			Dictionary<Material, bool> decided = new Dictionary<Material, bool>();
			Dictionary<Material, Material> split = new Dictionary<Material, Material>();
			List<Renderer> renderers = new List<Renderer>();
			GameObject[] roots = scene.GetRootGameObjects();
			foreach (GameObject root in roots)
			{
				root.GetComponentsInChildren(true, renderers);
				foreach (Renderer r in renderers)
				{
					bool lightmapped = r.lightmapIndex >= 0 && r.lightmapIndex < 65534;
					Material[] materials = r.sharedMaterials;
					if (materials.Length >= 1)
					{
						bool changed = false;
						for (int i = 0; i < materials.Length; i++)
						{
							Material material = materials[i];
							if (!(material == null))
							{
								Material mapped = Map(material, lightmapped, library, decided, split, createdMaterials);
								if (mapped != material)
								{
									materials[i] = mapped;
									changed = true;
								}
							}
						}
						if (changed)
						{
							r.sharedMaterials = materials;
						}
					}
					if (r is ParticleSystemRenderer particleRenderer && particleRenderer.trailMaterial != null)
					{
						particleRenderer.trailMaterial = Map(particleRenderer.trailMaterial, false, library, decided, split, createdMaterials);
					}
				}
			}
		}

		public static Material RemapSkybox(Material skybox, MapShaderLibrary library)
		{
			if (skybox == null)
			{
				return null;
			}
			skybox.shader = library.Resolve(OriginalName(skybox), false);
			return skybox;
		}

		private static Material Map(Material m, bool lightmapped, MapShaderLibrary library, Dictionary<Material, bool> decided, Dictionary<Material, Material> split, List<Material> created)
		{
			string approved = OriginalName(m);
			bool hasSplit = library.TryGet(approved, out var entry) && entry.probe != null;
			if (decided.TryGetValue(m, out var decidedLightmapped))
			{
				if (!hasSplit || decidedLightmapped == lightmapped)
				{
					return m;
				}
				if (!split.TryGetValue(m, out var copy))
				{
					copy = new Material(m);
					copy.name = m.name + (lightmapped ? " (Baked)" : " (Probe)");
					Remember(copy, approved);
					copy.shader = library.Resolve(approved, lightmapped);
					split[m] = copy;
					created.Add(copy);
				}
				return copy;
			}
			decided[m] = lightmapped;
			Remember(m, approved);
			m.shader = library.Resolve(approved, lightmapped);
			return m;
		}

		private static void Remember(Material m, string approved)
		{
			Originals[m] = approved;
		}

		private static string OriginalName(Material m)
		{
			if (Originals.TryGetValue(m, out var name))
			{
				return name;
			}
			return (m.shader != null) ? m.shader.name : "";
		}

		public static void Forget()
		{
			Originals.Clear();
		}
	}
}
