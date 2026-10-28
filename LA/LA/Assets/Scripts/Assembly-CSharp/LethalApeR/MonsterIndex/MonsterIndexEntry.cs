using System;
using UnityEngine;

namespace LethalApeR.MonsterIndex
{
	[Serializable]
	public sealed class MonsterIndexEntry
	{
		[Tooltip("Stable key: the gallery stand's name. The builder matches entries by it.")]
		public string id;

		public string displayName;

		[TextArea(3, 8)]
		public string description;

		[Tooltip("As on the plaques: usually 100 to 999 (Crazed's is FILECORRUPTED).")]
		public string danger = "500";

		[Tooltip("Left out of the index (unreleased monsters, Coming Soon stands).")]
		public bool hidden;

		[Tooltip("FeatureGates key: the entry stays out of the index while that gate is closed (a monster shipped dark). Empty = always.")]
		public string featureGate;

		[Header("From the game (refreshed by every build that finds the monster)")]
		[Tooltip("Where it spawns, from its waypoint sets.")]
		public string[] areas = Array.Empty<string>();

		[Tooltip("Its chase speed, metres a second.")]
		public float chaseSpeed;

		[Tooltip("The plaque's own 'appears' line, shown when the spawn areas aren't known.")]
		public string appears;

		[Header("Figure")]
		[Tooltip("Baked from: the model prefab. The builder prefers the gallery's statue when it's in the open scene, since some statues only differ by their material overrides.")]
		public GameObject source;

		[Tooltip("The pose: this clip sampled at Pose Time (the statue's walk, mid-stride by default).")]
		public AnimationClip poseClip;

		public float poseTime;

		[Tooltip("Degrees it's turned at rest, so it faces you when it rises out of the plinth.")]
		public float facing;

		[Header("Baked by the builder")]
		public Mesh figure;

		public Material[] figureMaterials = Array.Empty<Material>();

		public Rect thumbnailRect;

		[Tooltip("Every AI monster that plays it, for the catalog (Slender and its scene copy are both the twins).")]
		public string[] monsterNames = Array.Empty<string>();
	}
}
