using UnityEngine;

namespace LethalApeR.Social
{
	public sealed class FriendInfo
	{
		public string Id;

		public string Name;

		public FriendRelation Relation;

		public bool Online;

		public PresenceStatus Status;

		public bool Joinable;

		public int SceneIndex = -1;

		public Color Colour = new Color(0.55f, 0.55f, 0.6f, 1f);
	}
}
