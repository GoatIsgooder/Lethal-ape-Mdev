using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Map Settings")]
	[DisallowMultipleComponent]
	public sealed class MapSettings : MapComponent
	{
		[Header("Fog")]
		[SerializeField]
		private bool fog;

		[SerializeField]
		private Color fogColor = new Color(0.55f, 0.6f, 0.68f);

		[SerializeField]
		private FogMode fogMode = FogMode.ExponentialSquared;

		[SerializeField]
		[Range(0f, 0.2f)]
		private float fogDensity = 0.015f;

		[SerializeField]
		[Min(0f)]
		private float fogStart = 20f;

		[SerializeField]
		[Min(0f)]
		private float fogEnd = 150f;

		[Header("Sky")]
		[SerializeField]
		[Tooltip("A material using LethalApe/Skybox Gradient or LethalApe/Skybox Cubemap. Leave empty for a flat colour.")]
		private Material skybox;

		[SerializeField]
		[Tooltip("Sky colour when no skybox material is set.")]
		private Color skyColor = new Color(0.36f, 0.45f, 0.58f);

		[SerializeField]
		[Range(50f, 300f)]
		[Tooltip("How far players can see, in metres. Shorter is faster on Quest; hide the cut-off with fog.")]
		private float viewDistance = 200f;

		[Header("Ambient light (players and moving objects)")]
		[SerializeField]
		private MapAmbientMode ambientMode = MapAmbientMode.Gradient;

		[SerializeField]
		[ColorUsage(false, true)]
		private Color ambientSky = new Color(0.55f, 0.6f, 0.7f);

		[SerializeField]
		[ColorUsage(false, true)]
		private Color ambientEquator = new Color(0.4f, 0.42f, 0.45f);

		[SerializeField]
		[ColorUsage(false, true)]
		private Color ambientGround = new Color(0.22f, 0.21f, 0.2f);

		[Header("Sun (lights players and moving objects; the map itself uses baked light)")]
		[SerializeField]
		private bool sun = true;

		[SerializeField]
		private Color sunColor = new Color(1f, 0.96f, 0.88f);

		[SerializeField]
		[Range(0f, 3f)]
		private float sunIntensity = 1f;

		[SerializeField]
		private Vector3 sunRotation = new Vector3(50f, -30f, 0f);

		[Header("Players")]
		[SerializeField]
		[Range(0.25f, 2f)]
		[Tooltip("Scales gravity for everyone in the map.")]
		private float gravityMultiplier = 1f;

		[SerializeField]
		[Range(0.5f, 2f)]
		[Tooltip("Scales how fast players can move.")]
		private float speedMultiplier = 1f;

		[SerializeField]
		[Tooltip("Players below this height are sent back to their checkpoint or a spawn point.")]
		private float respawnHeight = -60f;

		[SerializeField]
		[Tooltip("Lets players use Sandbox web-swinging in this map. Turn it off for parkour and race maps, or webs skip your course.")]
		private bool allowWebSwinging = true;

		public bool Fog => fog;

		public Color FogColor => fogColor;

		public FogMode FogMode => fogMode;

		public float FogDensity => fogDensity;

		public float FogStart => fogStart;

		public float FogEnd => fogEnd;

		public Material Skybox => skybox;

		public Color SkyColor => skyColor;

		public float ViewDistance => Mathf.Clamp(viewDistance, 50f, 300f);

		public MapAmbientMode AmbientMode => ambientMode;

		public Color AmbientSky => ambientSky;

		public Color AmbientEquator => ambientEquator;

		public Color AmbientGround => ambientGround;

		public bool Sun => sun;

		public Color SunColor => sunColor;

		public float SunIntensity => sunIntensity;

		public Quaternion SunRotation => Quaternion.Euler(sunRotation);

		public float GravityMultiplier => gravityMultiplier;

		public float SpeedMultiplier => speedMultiplier;

		public float RespawnHeight => respawnHeight;

		public bool AllowWebSwinging => allowWebSwinging;
	}
}
