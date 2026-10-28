using System;

namespace LethalApe.SDK
{
	[Serializable]
	public sealed class MapManifest
	{
		public const string FileName = "manifest.json";

		public const string BundleFileName = "map.bundle";

		public const string ThumbnailFileName = "thumbnail.png";

		public int formatVersion;

		public string contentType;

		public string sdkVersion;

		public string unityVersion;

		public string buildTarget;

		public string mapGuid;

		public string mapName;

		public string author;

		public string description;

		public string[] tags;

		public string mapVersion;

		public int maxPlayers;

		public string bundleFile;

		public uint bundleCrc;

		public long bundleBytes;

		public string thumbnailFile;

		public string builtUtc;

		public MapStats stats;

		public string Key => MapKey(mapGuid, mapVersion);

		public static string MapKey(string guid, string version)
		{
			return guid + "@" + version;
		}
	}
}
