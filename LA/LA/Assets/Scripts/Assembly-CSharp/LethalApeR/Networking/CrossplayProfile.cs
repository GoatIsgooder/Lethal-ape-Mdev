using Photon.Realtime;

namespace LethalApeR.Networking
{
	public sealed class CrossplayProfile
	{
		public readonly CrossplayMode Mode;

		public readonly string Queue;

		public readonly string RoomVersion;

		public readonly int HubRoomLimit;

		public readonly MatchmakingMode Matchmaking;

		public CrossplayProfile(CrossplayMode mode, string queue, string roomVersion, int hubRoomLimit, MatchmakingMode matchmaking)
		{
			Mode = mode;
			Queue = queue;
			RoomVersion = roomVersion;
			HubRoomLimit = hubRoomLimit;
			Matchmaking = matchmaking;
		}
	}
}
