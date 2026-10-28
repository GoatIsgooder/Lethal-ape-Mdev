using System.Collections.Generic;

namespace LethalApe.SDK
{
	public static class ContentTypeNames
	{
		// RE: unsure - array contents come from an InitializeArray data blob not visible in the asm; assumed enum order
		private static readonly MapTags[] AllTags = new MapTags[4]
		{
			MapTags.ParkourRace,
			MapTags.HorrorExploration,
			MapTags.HangoutSocial,
			MapTags.PvpArena
		};

		public static IReadOnlyList<MapTags> Tags => AllTags;

		public static string Id(ContentType type)
		{
			switch (type)
			{
			case ContentType.Map:
				return "map";
			case ContentType.Monster:
				return "monster";
			case ContentType.Weapon:
				return "weapon";
			default:
				return "unknown";
			}
		}

		public static string TagName(MapTags tag)
		{
			switch (tag)
			{
			case MapTags.ParkourRace:
				return "Parkour / Race";
			case MapTags.HorrorExploration:
				return "Horror / Exploration";
			case MapTags.HangoutSocial:
				return "Hangout / Social";
			case MapTags.PvpArena:
				return "PvP / Arena";
			default:
				return string.Empty;
			}
		}

		public static string[] TagNames(MapTags tags)
		{
			List<string> list = new List<string>(AllTags.Length);
			foreach (MapTags tag in AllTags)
			{
				if ((tags & tag) != 0)
				{
					list.Add(TagName(tag));
				}
			}
			return list.ToArray();
		}
	}
}
