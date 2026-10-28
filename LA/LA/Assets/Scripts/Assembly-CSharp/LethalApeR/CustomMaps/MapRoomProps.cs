using System;
using ExitGames.Client.Photon;
using Photon.Realtime;

namespace LethalApeR.CustomMaps
{
	public static class MapRoomProps
	{
		public const string MapKey = "lam";

		public const string MapName = "lamn";

		public const string MapAuthor = "lama";

		public const string SourceKey = "lams";

		public static string KeyOf(RoomInfo room)
		{
			if (room?.CustomProperties != null && room.CustomProperties.TryGetValue(MapKey, out var value))
			{
				return value as string;
			}
			return null;
		}

		public static string NameOf(RoomInfo room)
		{
			if (room?.CustomProperties != null && room.CustomProperties.TryGetValue(MapName, out var value))
			{
				return value as string;
			}
			return null;
		}

		public static string QueueOf(RoomInfo room)
		{
			if (room?.CustomProperties != null && room.CustomProperties.TryGetValue("queue", out var value))
			{
				return value as string;
			}
			return null;
		}

		public static Hashtable For(MapPackage map)
		{
			return new Hashtable
			{
				{ MapKey, map.Key },
				{ MapName, map.Name },
				{ MapAuthor, map.Author ?? "" },
				{ SourceKey, (map.Source == MapSource.ModIo) ? ("modio:" + map.SourceId) : "local" }
			};
		}

		public static string QueueFor(string builtinQueue, MapPackage map)
		{
			return builtinQueue + "|" + map.Key;
		}

		public static bool IsSandboxQueue(string queue, string builtinQueue)
		{
			if (string.IsNullOrEmpty(queue))
			{
				return false;
			}
			if (queue == builtinQueue)
			{
				return true;
			}
			return queue.StartsWith(builtinQueue + "|", StringComparison.Ordinal);
		}
	}
}
