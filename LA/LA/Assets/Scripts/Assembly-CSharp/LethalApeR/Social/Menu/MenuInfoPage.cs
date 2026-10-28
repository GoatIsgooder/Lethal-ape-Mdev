using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using LethalApeR.Social.UI;
using TMPro;
using UnityEngine;

namespace LethalApeR.Social.Menu
{
	public sealed class MenuInfoPage : MonoBehaviour
	{
		[SerializeField]
		private PlayerRowView you;

		[SerializeField]
		private TMP_Text roomLabel;

		[SerializeField]
		private TMP_Text versionLabel;

		private string _roomShown;

		private float _next;

		private MonkeDevNetworkingPlayer _portraitOf;

		private void OnEnable()
		{
			_roomShown = null;
			_next = 0f;
			if (versionLabel != null)
			{
				versionLabel.text = "VERSION <color=#F2F2F2>" + Application.version + "</color>";
			}
		}

		private void Update()
		{
			if (Time.unscaledTime < _next)
			{
				return;
			}
			_next = Time.unscaledTime + 0.5f;
			RosterEntry rosterEntry = FindLocal();
			string displayName;
			Color colour;
			if (rosterEntry != null)
			{
				displayName = rosterEntry.Name;
				colour = rosterEntry.Colour;
			}
			else
			{
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				displayName = SocialText.CleanName(PlayerPrefs.GetString("Username", "PLAYER"));
				colour = ((manager != null) ? manager.Colour : Color.white);
			}
			you.SetIdentity(displayName, colour, 1f);
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = rosterEntry?.Player;
			if (monkeDevNetworkingPlayer != _portraitOf)
			{
				_portraitOf = monkeDevNetworkingPlayer;
				you.SetPortrait(monkeDevNetworkingPlayer);
			}
			else if (you.PortraitPending)
			{
				you.RefreshPortrait();
			}
			you.SetTag(null);
			you.SetTalkingSlot(false);
			you.HideButton(0);
			you.HideButton(1);
			you.HideButton(2);
			PresenceStatus status = SocialPrefs.Status;
			you.SetSub(SocialStyle.StatusText(status), SocialStyle.StatusColour(status));
			you.Commit();
			string roomCode = SocialRoster.RoomCode;
			if (!string.Equals(roomCode, _roomShown, StringComparison.Ordinal))
			{
				_roomShown = roomCode;
				roomLabel.text = (string.IsNullOrEmpty(roomCode) ? "NOT IN A ROOM" : ("ROOM <color=#F2F2F2>" + roomCode + "</color>"));
			}
		}

		private static RosterEntry FindLocal()
		{
			IReadOnlyList<RosterEntry> current = SocialRoster.Current;
			for (int i = 0; i < current.Count; i++)
			{
				if (current[i].IsLocal)
				{
					return current[i];
				}
			}
			return null;
		}
	}
}
