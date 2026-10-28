using System;
using System.Collections.Generic;
using LethalApe.SDK;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	public static class MapCompatibility
	{
		public static string PlatformName
		{
			get
			{
				if (Application.platform == RuntimePlatform.Android)
				{
					return "Android";
				}
				return Application.platform.ToString();
			}
		}

		public static bool PlatformSupportsCustomMaps => Application.platform == RuntimePlatform.Android;

		public static bool Check(MapManifest m, out string reason)
		{
			reason = null;
			if (m == null)
			{
				reason = "The map's manifest is missing or damaged.";
				return false;
			}
			if (m.formatVersion > SdkInfo.ManifestFormat)
			{
				reason = "This map needs a newer version of the game.";
				return false;
			}
			if (m.contentType != ContentTypeNames.Id(ContentType.Map))
			{
				reason = "This isn't a map.";
				return false;
			}
			if (!TryParseVersion(m.sdkVersion, out Version mapSdk))
			{
				reason = "The map's manifest is incomplete.";
				return false;
			}
			if (NewerThanGame(mapSdk))
			{
				reason = "This map was made with a newer SDK. Update the game to play it.";
				return false;
			}
			if (m.unityVersion != Application.unityVersion)
			{
				reason = "This map was built with Unity " + m.unityVersion + " and can't load in this version of the game.";
				return false;
			}
			if (!string.IsNullOrEmpty(m.buildTarget) && m.buildTarget != PlatformName)
			{
				reason = "This map wasn't built for this platform.";
				return false;
			}
			if (string.IsNullOrEmpty(m.mapGuid) || string.IsNullOrEmpty(m.mapVersion))
			{
				reason = "The map's manifest is incomplete.";
				return false;
			}
			if (m.stats == null)
			{
				reason = "The map's manifest has no stats.";
				return false;
			}
			List<string> violations = new List<string>();
			MapBudgets.Violations(m.stats, violations);
			if (violations.Count > 0)
			{
				reason = "This map is too heavy for Quest: " + violations[0];
				return false;
			}
			return true;
		}

		private static bool NewerThanGame(Version mapSdk)
		{
			if (!TryParseVersion(SdkInfo.Version, out Version game))
			{
				return false;
			}
			if (mapSdk.Major > game.Major)
			{
				return true;
			}
			if (mapSdk.Major == game.Major)
			{
				return mapSdk.Minor > game.Minor;
			}
			return false;
		}

		private static bool TryParseVersion(string text, out Version version)
		{
			version = null;
			if (string.IsNullOrEmpty(text))
			{
				return false;
			}
			int cut = text.IndexOfAny(new char[2] { '-', '+' });
			if (cut >= 0)
			{
				text = text.Substring(0, cut);
			}
			return Version.TryParse(text, out version);
		}
	}
}
