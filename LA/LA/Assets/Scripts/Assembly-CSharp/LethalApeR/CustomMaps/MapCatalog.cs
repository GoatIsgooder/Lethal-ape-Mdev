using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Threading.Tasks;
using LethalApe.SDK;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	public static class MapCatalog
	{
		private sealed class Found
		{
			public MapManifest Manifest;

			public string Folder;

			public string Origin;
		}

		private sealed class ScanResult
		{
			public readonly List<Found> Found = new List<Found>();

			public readonly List<string> Problems = new List<string>();
		}

		private static readonly List<MapPackage> _maps = new List<MapPackage>();

		private static readonly List<MapPackage> _allVersions = new List<MapPackage>();

		private static readonly List<string> _problems = new List<string>();

		private static bool _scanning;

		private static bool _rescanQueued;

		public static IReadOnlyList<MapPackage> Maps => _maps;

		public static IReadOnlyList<string> Problems => _problems;

		public static bool Scanning => _scanning;

		public static bool HasScanned { get; private set; }

		public static string LocalFolder => Path.Combine(Application.persistentDataPath, SdkInfo.LocalMapsFolder);

		private static string CacheFolder => Path.Combine(Application.persistentDataPath, "CustomMapsCache");

		public static event Action Changed;

		public static MapPackage Find(string key)
		{
			if (string.IsNullOrEmpty(key))
			{
				return null;
			}
			foreach (MapPackage map in _allVersions)
			{
				if (map.Key == key)
				{
					return map;
				}
			}
			return null;
		}

		public static async void Refresh()
		{
			if (_scanning)
			{
				_rescanQueued = true;
				return;
			}
			_scanning = true;
			Changed?.Invoke();
			List<string> roots = new List<string> { LocalFolder };
			string cache = CacheFolder;
			ScanResult result;
			try
			{
				result = await Task.Run(() => Scan(roots, cache));
			}
			catch (Exception ex)
			{
				Debug.LogException(ex);
				result = new ScanResult();
				result.Problems.Add("Couldn't read the maps folder: " + ex.Message);
			}
			foreach (MapPackage map in _allVersions)
			{
				map.ReleaseThumbnail();
			}
			_allVersions.Clear();
			_maps.Clear();
			_problems.Clear();
			foreach (Found found in result.Found)
			{
				MapPackage package = new MapPackage(found.Manifest, found.Folder, MapSource.Local, found.Origin);
				_allVersions.Add(package);
				int index = _maps.FindIndex((MapPackage m) => m.Guid == package.Guid);
				if (index < 0)
				{
					_maps.Add(package);
				}
				else if (CompareVersions(package.Version, _maps[index].Version) > 0)
				{
					_maps[index] = package;
				}
			}
			_problems.AddRange(result.Problems);
			_maps.Sort((MapPackage a, MapPackage b) => string.Compare(a.Name, b.Name, StringComparison.OrdinalIgnoreCase));
			_scanning = false;
			HasScanned = true;
			Changed?.Invoke();
			if (_rescanQueued)
			{
				_rescanQueued = false;
				Refresh();
			}
		}

		private static ScanResult Scan(List<string> roots, string cache)
		{
			ScanResult result = new ScanResult();
			HashSet<string> seen = new HashSet<string>();
			foreach (string root in roots)
			{
				if (string.IsNullOrEmpty(root) || !Directory.Exists(root))
				{
					continue;
				}
				string[] files = Directory.GetFiles(root, "*.zip", SearchOption.AllDirectories);
				foreach (string zip in files)
				{
					TryAdd(result, seen, () => FromZip(zip, cache), zip);
				}
				string[] directories = Directory.GetDirectories(root, "*", SearchOption.AllDirectories);
				foreach (string dir in directories)
				{
					if (File.Exists(Path.Combine(dir, MapManifest.FileName)))
					{
						TryAdd(result, seen, () => FromFolder(dir), dir);
					}
				}
			}
			PruneCache(cache, result);
			return result;
		}

		private static void PruneCache(string cache, ScanResult result)
		{
			if (!Directory.Exists(cache))
			{
				return;
			}
			HashSet<string> keep = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
			foreach (Found found in result.Found)
			{
				keep.Add(Path.GetFullPath(found.Folder));
			}
			string[] directories = Directory.GetDirectories(cache);
			foreach (string dir in directories)
			{
				try
				{
					if (!keep.Contains(Path.GetFullPath(dir)))
					{
						Directory.Delete(dir, true);
					}
				}
				catch (IOException)
				{
				}
				catch (UnauthorizedAccessException)
				{
				}
			}
		}

		private static void TryAdd(ScanResult result, HashSet<string> seen, Func<Found> load, string origin)
		{
			string reason = null;
			try
			{
				Found found = load();
				if (found != null && seen.Add(found.Manifest.Key))
				{
					if (MapCompatibility.Check(found.Manifest, out reason))
					{
						result.Found.Add(found);
					}
					else
					{
						result.Problems.Add(Path.GetFileName(origin) + ": " + reason);
					}
				}
			}
			catch (Exception ex)
			{
				result.Problems.Add(Path.GetFileName(origin) + ": " + ex.Message);
			}
		}

		private static Found FromFolder(string dir)
		{
			MapManifest manifest = JsonUtility.FromJson<MapManifest>(File.ReadAllText(Path.Combine(dir, MapManifest.FileName)));
			if (manifest == null || !File.Exists(Path.Combine(dir, MapManifest.BundleFileName)))
			{
				return null;
			}
			return new Found
			{
				Manifest = manifest,
				Folder = dir,
				Origin = dir
			};
		}

		private static Found FromZip(string zipPath, string cache)
		{
			using (ZipArchive zip = ZipFile.OpenRead(zipPath))
			{
				ZipArchiveEntry manifestEntry = zip.GetEntry(MapManifest.FileName);
				if (manifestEntry == null)
				{
					throw new InvalidDataException("no manifest.json in the zip");
				}
				MapManifest manifest;
				using (StreamReader reader = new StreamReader(manifestEntry.Open(), Encoding.UTF8))
				{
					manifest = JsonUtility.FromJson<MapManifest>(reader.ReadToEnd());
				}
				if (manifest == null || string.IsNullOrEmpty(manifest.mapGuid))
				{
					throw new InvalidDataException("unreadable manifest.json");
				}
				string folder = Path.Combine(cache, Sanitize(manifest.Key));
				string marker = Path.Combine(folder, ".complete");
				if (!File.Exists(marker) || File.ReadAllText(marker) != Stamp(zipPath))
				{
					if (Directory.Exists(folder))
					{
						Directory.Delete(folder, true);
					}
					Directory.CreateDirectory(folder);
					string[] names = new string[3]
					{
						MapManifest.FileName,
						MapManifest.BundleFileName,
						MapManifest.ThumbnailFileName
					};
					foreach (string name in names)
					{
						ZipArchiveEntry entry = zip.GetEntry(name);
						if (entry != null)
						{
							entry.ExtractToFile(Path.Combine(folder, name), true);
						}
						else if (name != MapManifest.ThumbnailFileName)
						{
							throw new InvalidDataException("the zip is missing " + name);
						}
					}
					File.WriteAllText(marker, Stamp(zipPath));
				}
				return new Found
				{
					Manifest = manifest,
					Folder = folder,
					Origin = zipPath
				};
			}
		}

		private static int CompareVersions(string a, string b)
		{
			if (Version.TryParse(a, out Version va) && Version.TryParse(b, out Version vb))
			{
				return va.CompareTo(vb);
			}
			return string.CompareOrdinal(a, b);
		}

		private static string Stamp(string file)
		{
			FileInfo info = new FileInfo(file);
			return info.Length.ToString() + ":" + info.LastWriteTimeUtc.Ticks.ToString();
		}

		private static string Sanitize(string key)
		{
			char[] invalid = Path.GetInvalidFileNameChars();
			foreach (char c in invalid)
			{
				key = key.Replace(c, '_');
			}
			return key;
		}
	}
}
