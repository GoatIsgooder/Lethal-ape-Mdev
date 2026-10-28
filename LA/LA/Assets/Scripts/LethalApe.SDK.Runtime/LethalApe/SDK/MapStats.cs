using System;

namespace LethalApe.SDK
{
	[Serializable]
	public sealed class MapStats
	{
		public int triangles;

		public int renderers;

		public int materials;

		public int textures;

		public float textureMB;

		public int maxTextureSize;

		public int lightmaps;

		public int maxLightmapSize;

		public int realtimeLights;

		public int particleSystems;

		public int maxParticles;

		public float audioMB;

		public int audioSources;

		public int meshColliders;

		public int maxMeshColliderTriangles;

		public int animators;

		public float navMeshArea;

		public int spawnPoints;

		public int logicTriggers;

		public int movingPlatforms;

		public int doors;

		public int buttons;

		public int zones;

		public int audioZones;

		public int textSigns;

		public int waterVolumes;

		public int raceCourses;
	}
}
