using System.Collections.Generic;

namespace LethalApe.SDK
{
	public static class MapBudgets
	{
		public readonly struct Line
		{
			public readonly string Label;

			public readonly float Value;

			public readonly float Limit;

			public readonly string Unit;

			public bool Over => Value > Limit;

			public float Fraction
			{
				get
				{
					if (Limit > 0f)
					{
						return Value / Limit;
					}
					return (Value > 0f) ? 1f : 0f;
				}
			}

			public Line(string label, float value, float limit, string unit)
			{
				Label = label;
				Value = value;
				Limit = limit;
				Unit = unit;
			}
		}

		public const int Triangles = 300000;

		public const int Renderers = 1500;

		public const int Materials = 48;

		public const float TextureMB = 96f;

		public const int MaxTextureSize = 2048;

		public const int Lightmaps = 4;

		public const int MaxLightmapSize = 2048;

		public const int RealtimeLights = 0;

		public const int ParticleSystems = 16;

		public const int MaxParticlesPerSystem = 256;

		public const float AudioMB = 25f;

		public const int AudioSources = 32;

		public const int MeshColliders = 64;

		public const int MaxMeshColliderTriangles = 10000;

		public const int Animators = 16;

		public const float ZipMB = 150f;

		public const int SpawnPoints = 16;

		public const int LogicTriggers = 64;

		public const int MovingPlatforms = 16;

		public const int Doors = 32;

		public const int Buttons = 64;

		public const int Zones = 128;

		public const int AudioZones = 16;

		public const int TextSigns = 64;

		public const int WaterVolumes = 8;

		public const int RaceCourses = 4;

		public static List<Line> Lines(MapStats s)
		{
			List<Line> list = new List<Line>();
			list.Add(new Line("Triangles", s.triangles, Triangles, ""));
			list.Add(new Line("Renderers", s.renderers, Renderers, ""));
			list.Add(new Line("Materials", s.materials, Materials, ""));
			list.Add(new Line("Texture memory", s.textureMB, TextureMB, "MB"));
			list.Add(new Line("Largest texture", s.maxTextureSize, MaxTextureSize, "px"));
			list.Add(new Line("Lightmaps", s.lightmaps, Lightmaps, ""));
			list.Add(new Line("Largest lightmap", s.maxLightmapSize, MaxLightmapSize, "px"));
			list.Add(new Line("Realtime lights", s.realtimeLights, RealtimeLights, ""));
			list.Add(new Line("Particle systems", s.particleSystems, ParticleSystems, ""));
			list.Add(new Line("Particles per system", s.maxParticles, MaxParticlesPerSystem, ""));
			list.Add(new Line("Audio", s.audioMB, AudioMB, "MB"));
			list.Add(new Line("Audio sources", s.audioSources, AudioSources, ""));
			list.Add(new Line("Mesh colliders", s.meshColliders, MeshColliders, ""));
			list.Add(new Line("Mesh collider triangles", s.maxMeshColliderTriangles, MaxMeshColliderTriangles, ""));
			list.Add(new Line("Animators", s.animators, Animators, ""));
			list.Add(new Line("Spawn points", s.spawnPoints, SpawnPoints, ""));
			list.Add(new Line("Logic triggers", s.logicTriggers, LogicTriggers, ""));
			list.Add(new Line("Moving platforms", s.movingPlatforms, MovingPlatforms, ""));
			list.Add(new Line("Doors", s.doors, Doors, ""));
			list.Add(new Line("Buttons", s.buttons, Buttons, ""));
			list.Add(new Line("Zones", s.zones, Zones, ""));
			list.Add(new Line("Audio zones", s.audioZones, AudioZones, ""));
			list.Add(new Line("Text signs", s.textSigns, TextSigns, ""));
			list.Add(new Line("Water volumes", s.waterVolumes, WaterVolumes, ""));
			list.Add(new Line("Race courses", s.raceCourses, RaceCourses, ""));
			return list;
		}

		public static void Violations(MapStats s, List<string> into)
		{
			foreach (Line line in Lines(s))
			{
				if (line.Over)
				{
					into.Add(line.Label + ": " + Format(line.Value, line.Unit) + " over the limit of " + Format(line.Limit, line.Unit));
				}
			}
		}

		public static string Format(float value, string unit)
		{
			string text = ((unit == "MB") ? value.ToString("0.0") : ((int)value).ToString("N0"));
			if (!string.IsNullOrEmpty(unit))
			{
				return text + " " + unit;
			}
			return text;
		}
	}
}
