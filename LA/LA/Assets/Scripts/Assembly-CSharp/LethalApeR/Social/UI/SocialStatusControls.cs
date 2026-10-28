using Photon.Pun;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Social.UI
{
	public sealed class SocialStatusControls : MonoBehaviour
	{
		[SerializeField]
		private SocialButton online;

		[SerializeField]
		private SocialButton away;

		[SerializeField]
		private SocialButton appearOffline;

		[SerializeField]
		private SocialButton joinOn;

		[SerializeField]
		private SocialButton joinOff;

		[SerializeField]
		private SocialButton requestsOn;

		[SerializeField]
		private SocialButton requestsOff;

		[SerializeField]
		private TMP_Text preview;

		[SerializeField]
		private Image previewDot;

		[Tooltip("Put in front of the preview, e.g. \"FRIENDS SEE YOU \" when there's no separate label.")]
		[SerializeField]
		private string previewPrefix = "";

		private bool _wasInRoom;

		private void Awake()
		{
			online.Pressed += delegate
			{
				SocialPrefs.Status = PresenceStatus.Online;
			};
			away.Pressed += delegate
			{
				SocialPrefs.Status = PresenceStatus.Away;
			};
			appearOffline.Pressed += delegate
			{
				SocialPrefs.Status = PresenceStatus.AppearOffline;
			};
			joinOn.Pressed += delegate
			{
				SocialPrefs.Joinable = true;
			};
			joinOff.Pressed += delegate
			{
				SocialPrefs.Joinable = false;
			};
			requestsOn.Pressed += delegate
			{
				SocialPrefs.FriendRequests = true;
			};
			requestsOff.Pressed += delegate
			{
				SocialPrefs.FriendRequests = false;
			};
		}

		private void OnEnable()
		{
			SocialPrefs.Changed += Refresh;
			Refresh();
		}

		private void OnDisable()
		{
			SocialPrefs.Changed -= Refresh;
		}

		private void Update()
		{
			if (PhotonNetwork.InRoom != _wasInRoom)
			{
				Refresh();
			}
		}

		private void Refresh()
		{
			PresenceStatus status = SocialPrefs.Status;
			bool joinable = SocialPrefs.Joinable;
			online.SetLook((status == PresenceStatus.Online) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			away.SetLook((status == PresenceStatus.Away) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			appearOffline.SetLook((status == PresenceStatus.AppearOffline) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			joinOn.SetLook(joinable ? ButtonLook.SegmentOn : ButtonLook.Segment);
			joinOff.SetLook((!joinable) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			bool friendRequests = SocialPrefs.FriendRequests;
			requestsOn.SetLook(friendRequests ? ButtonLook.SegmentOn : ButtonLook.Segment);
			requestsOff.SetLook((!friendRequests) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			_wasInRoom = PhotonNetwork.InRoom;
			if (!(preview == null))
			{
				string text;
				if (status == PresenceStatus.AppearOffline)
				{
					text = "OFFLINE";
				}
				else
				{
					text = ((status == PresenceStatus.Away) ? "AWAY" : "ONLINE");
					if (_wasInRoom)
					{
						text += (joinable ? ", IN A ROOM, JOINABLE" : ", IN A ROOM");
					}
				}
				preview.text = previewPrefix + text;
				if (previewDot != null)
				{
					previewDot.color = SocialStyle.StatusColour(status);
				}
			}
		}
	}
}
