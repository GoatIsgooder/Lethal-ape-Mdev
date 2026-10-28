using System;
using UnityEngine;

namespace LethalApe.SDK
{
	public static class MapRules
	{
		public const float BoundsSize = 200f;

		public const int ClimbableLayer = 0;

		public const int NonClimbableLayer = 2;

		public const float MaxJumpPadSpeed = 25f;

		public const int MaxSignCharacters = 280;

		public const int MaxNameLength = 48;

		public const int MaxDescriptionLength = 600;

		public const int MaxPlayers = 10;

		public const int ThumbnailWidth = 1280;

		public const int ThumbnailHeight = 720;

		public static readonly string[] ApprovedShaders = new string[11]
		{
			"LethalApe/Lit",
			"LethalApe/Lit Cutout",
			"LethalApe/Unlit",
			"LethalApe/Unlit Cutout",
			"LethalApe/Unlit Transparent",
			"LethalApe/Unlit Additive",
			"LethalApe/Water",
			"LethalApe/Particles Alpha",
			"LethalApe/Particles Additive",
			"LethalApe/Skybox Gradient",
			"LethalApe/Skybox Cubemap"
		};

		public static Bounds PlayableBounds => new Bounds(Vector3.zero, new Vector3(BoundsSize, BoundsSize, BoundsSize));

		public static bool IsAllowedLayer(int layer)
		{
			return layer == ClimbableLayer || layer == NonClimbableLayer;
		}

		public static bool IsApprovedShader(string shaderName)
		{
			return !string.IsNullOrEmpty(shaderName) && Array.IndexOf(ApprovedShaders, shaderName) >= 0;
		}

		public static bool IsSkyboxShader(string shaderName)
		{
			return shaderName == "LethalApe/Skybox Gradient" || shaderName == "LethalApe/Skybox Cubemap";
		}

		public static bool IsAllowedComponent(Component component)
		{
			if (component == null)
			{
				return false;
			}
			return component is MapComponent || component is Transform || component is MeshFilter || component is MeshRenderer || component is SkinnedMeshRenderer || component is LODGroup || component is BoxCollider || component is SphereCollider || component is CapsuleCollider || component is MeshCollider || component is Light || component is LightProbeGroup || component is ParticleSystem || component is ParticleSystemRenderer || component is AudioSource || component is Animator || component is LineRenderer || component is TrailRenderer;
		}
	}
}
