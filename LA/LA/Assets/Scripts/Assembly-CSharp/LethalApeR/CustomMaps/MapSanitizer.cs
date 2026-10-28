using System.Collections.Generic;
using LethalApe.SDK;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace LethalApeR.CustomMaps
{
	public static class MapSanitizer
	{
		public struct Report
		{
			public int Removed;

			public int Renderers;

			public int ParticleSystems;

			public int AudioSources;

			public int Animators;

			public bool HasLightProbes;
		}

		public static Report Apply(Scene scene)
		{
			Report report = default(Report);
			List<Component> components = new List<Component>();
			List<Component> doomed = new List<Component>();
			GameObject[] roots = scene.GetRootGameObjects();
			foreach (GameObject root in roots)
			{
				Transform[] transforms = root.GetComponentsInChildren<Transform>(true);
				foreach (Transform t in transforms)
				{
					GameObject go = t.gameObject;
					if (!MapRules.IsAllowedLayer(go.layer))
					{
						go.layer = 0;
					}
					go.GetComponents(components);
					foreach (Component c in components)
					{
						if (c == null)
						{
							continue;
						}
						if (!MapRules.IsAllowedComponent(c))
						{
							doomed.Add(c);
						}
						else if (c is Light light)
						{
							light.enabled = false;
						}
						else if (c is Renderer renderer)
						{
							report.Renderers++;
							renderer.shadowCastingMode = ShadowCastingMode.Off;
							renderer.receiveShadows = false;
							renderer.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
						}
						else if (c is AudioSource audio)
						{
							report.AudioSources++;
							audio.spatialize = false;
							audio.outputAudioMixerGroup = null;
							audio.volume = Mathf.Clamp01(audio.volume);
							audio.priority = Mathf.Max(audio.priority, 160);
						}
						else if (c is Animator animator)
						{
							report.Animators++;
							animator.cullingMode = AnimatorCullingMode.CullCompletely;
							animator.applyRootMotion = false;
						}
						else if (c is ParticleSystem particles)
						{
							report.ParticleSystems++;
							ParticleSystem.MainModule main = particles.main;
							if (main.maxParticles > 256)
							{
								main.maxParticles = 256;
							}
						}
						else if (c is LightProbeGroup)
						{
							report.HasLightProbes = true;
						}
					}
				}
			}
			foreach (Component c in doomed)
			{
				if (!(c == null))
				{
					Debug.LogWarning("[CustomMaps] Removed a disallowed " + c.GetType().Name + " from '" + c.gameObject.name + "'.");
					Object.DestroyImmediate(c);
					report.Removed++;
				}
			}
			return report;
		}

		public static bool WithinBudget(Report r, out string reason)
		{
			reason = null;
			if (r.Renderers > 1564)
			{
				reason = "too many objects";
			}
			else if (r.ParticleSystems > 16)
			{
				reason = "too many particle systems";
			}
			else if (r.AudioSources > 32)
			{
				reason = "too many audio sources";
			}
			else if (r.Animators > 16)
			{
				reason = "too many animators";
			}
			return reason == null;
		}
	}
}
