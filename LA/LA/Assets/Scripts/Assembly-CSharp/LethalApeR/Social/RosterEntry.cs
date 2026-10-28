using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Social
{
	public sealed class RosterEntry
	{
		public MonkeDevNetworkingPlayer Player;

		public string UserId;

		public string Name;

		public Color Colour;

		public bool IsLocal;

		public int Actor;

		public bool AcceptsRequests;

		public bool Talking
		{
			get
			{
				if (Player != null && !IsLocal && Player.PhotonVoiceView != null)
				{
					return Player.PhotonVoiceView.IsSpeaking;
				}
				return false;
			}
		}
	}
}
