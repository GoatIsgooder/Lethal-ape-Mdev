using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Rivals
{
	public static class RivalsSkyDome
	{
		private static Material _skyMaterial;

		private static bool _usingFallback;

		public static GameObject Build(Transform parent, Vector3 center, float radius)
		{
			GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere);
			gameObject.name = "RivalsSkyDome";
			Object.Destroy(gameObject.GetComponent<SphereCollider>());
			Transform transform = gameObject.transform;
			transform.SetParent(parent, false);
			transform.SetPositionAndRotation(center, Quaternion.identity);
			transform.localScale = Vector3.one * ((radius > 0f) ? (radius * 2f) : 80f);
			EnsureMaterial();
			MeshRenderer component = gameObject.GetComponent<MeshRenderer>();
			component.shadowCastingMode = ShadowCastingMode.Off;
			component.receiveShadows = false;
			component.lightProbeUsage = LightProbeUsage.Off;
			component.reflectionProbeUsage = ReflectionProbeUsage.Off;
			component.allowOcclusionWhenDynamic = false;
			if (_skyMaterial != null)
			{
				component.sharedMaterial = _skyMaterial;
			}
			if (_usingFallback)
			{
				transform.localScale = -transform.localScale;
			}
			return gameObject;
		}

		private static void EnsureMaterial()
		{
			if (_skyMaterial != null)
			{
				return;
			}
			Shader shader = Shader.Find("Slop/Rivals/AuroraSky");
			if (shader != null)
			{
				_skyMaterial = new Material(shader);
				ApplyLook(_skyMaterial);
				_usingFallback = false;
				return;
			}
			Debug.LogWarning("[RivalsSkyDome] Shader 'Slop/Rivals/AuroraSky' not found (stripped from the build?) — using a flat dark dome.");
			Shader shader2 = Shader.Find("Unlit/Color");
			if (shader2 == null)
			{
				Debug.LogWarning("[RivalsSkyDome] 'Unlit/Color' is also missing — the dome will not be visible.");
				return;
			}
			_skyMaterial = new Material(shader2)
			{
				color = new Color(0.012f, 0.016f, 0.045f)
			};
			_usingFallback = true;
		}

		private static void ApplyLook(Material m)
		{
			m.SetColor("_HorizonColor", Hex(38, 20, 10));
			m.SetColor("_ZenithColor", Hex(2, 3, 10));
			m.SetFloat("_GradientPower", 3f);
			m.SetColor("_HorizonGlowColor", Hex(107, 86, 41));
			m.SetFloat("_HorizonGlowStrength", 1.463f);
			m.SetFloat("_StarDensity", 0.518f);
			m.SetFloat("_StarScale", 30f);
			m.SetFloat("_StarBrightness", 1.3f);
			m.SetFloat("_TwinkleSpeed", 1f);
			m.SetFloat("_HeroStarDensity", 0.15f);
			m.SetFloat("_HeroStarScale", 6f);
			m.SetFloat("_AuroraIntensity", 1f);
			m.SetColor("_AuroraBottomColor", Hex(230, 218, 46));
			m.SetColor("_AuroraMidColor", Hex(255, 162, 0));
			m.SetColor("_AuroraTopColor", Hex(0, 0, 0));
			m.SetFloat("_AuroraHeight", 0.32f);
			m.SetFloat("_AuroraExtent", 0.38f);
			m.SetFloat("_AuroraSpeed", 1f);
		}

		private static Color Hex(int r, int g, int b)
		{
			return new Color32((byte)r, (byte)g, (byte)b, byte.MaxValue);
		}
	}
}
