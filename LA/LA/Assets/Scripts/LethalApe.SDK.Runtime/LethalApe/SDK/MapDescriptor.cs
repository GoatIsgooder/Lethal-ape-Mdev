using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Map Descriptor")]
	[DisallowMultipleComponent]
	public sealed class MapDescriptor : MapComponent
	{
		[SerializeField]
		[Tooltip("Shown in the in-game map browser.")]
		private string mapName = "My Map";

		[SerializeField]
		[Tooltip("Your creator name.")]
		private string author = "";

		[SerializeField]
		[TextArea(3, 6)]
		[Tooltip("A short description shown with the map.")]
		private string description = "";

		[SerializeField]
		[Tooltip("Categories used for filtering on mod.io and in game.")]
		private MapTags tags;

		[SerializeField]
		[Tooltip("Map version (major.minor.patch). Bumped automatically on every build.")]
		private string version = "1.0.0";

		[SerializeField]
		[Range(1f, 10f)]
		[Tooltip("Room size for rooms playing this map.")]
		private int maxPlayers = 10;

		[SerializeField]
		[HideInInspector]
		private string mapGuid = "";

		[SerializeField]
		[HideInInspector]
		private string thumbnailAssetGuid = "";

		public string MapName => mapName;

		public string Author => author;

		public string Description => description;

		public MapTags Tags => tags;

		public string Version => version;

		public int MaxPlayers => maxPlayers;

		public string MapGuid => mapGuid;

		public string ThumbnailAssetGuid => thumbnailAssetGuid;
	}
}
