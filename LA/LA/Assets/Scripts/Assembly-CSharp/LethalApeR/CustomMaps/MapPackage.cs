using System.IO;
using LethalApe.SDK;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	public sealed class MapPackage
	{
		public readonly MapManifest Manifest;

		public readonly string Folder;

		public readonly MapSource Source;

		public readonly string SourceId;

		private Texture2D _thumbnail;

		public string Key => MapManifest.MapKey(Manifest.mapGuid, Manifest.mapVersion);

		public string Name => Manifest.mapName;

		public string Author => Manifest.author;

		public string Version => Manifest.mapVersion;

		public string Guid => Manifest.mapGuid;

		public int MaxPlayers => (Manifest.maxPlayers < 1) ? 10 : Mathf.Min(Manifest.maxPlayers, 10);

		public string BundlePath => Path.Combine(Folder, string.IsNullOrEmpty(Manifest.bundleFile) ? MapManifest.BundleFileName : Manifest.bundleFile);

		public string ThumbnailPath => Path.Combine(Folder, string.IsNullOrEmpty(Manifest.thumbnailFile) ? MapManifest.ThumbnailFileName : Manifest.thumbnailFile);

		public Texture2D Thumbnail
		{
			get
			{
				if (_thumbnail != null)
				{
					return _thumbnail;
				}
				if (!File.Exists(ThumbnailPath))
				{
					return null;
				}
				Texture2D texture = new Texture2D(2, 2, TextureFormat.RGB24, false);
				texture.name = Name + " Thumbnail";
				texture.wrapMode = TextureWrapMode.Clamp;
				if (texture.LoadImage(File.ReadAllBytes(ThumbnailPath), true))
				{
					_thumbnail = texture;
					return _thumbnail;
				}
				Object.Destroy(texture);
				return null;
			}
		}

		public MapPackage(MapManifest manifest, string folder, MapSource source, string sourceId)
		{
			Manifest = manifest;
			Folder = folder;
			Source = source;
			SourceId = sourceId ?? "";
		}

		public void ReleaseThumbnail()
		{
			if (!(_thumbnail == null))
			{
				Object.Destroy(_thumbnail);
				_thumbnail = null;
			}
		}

		public override string ToString()
		{
			return string.Format("{0} v{1} ({2})", Name, Version, Source);
		}
	}
}
