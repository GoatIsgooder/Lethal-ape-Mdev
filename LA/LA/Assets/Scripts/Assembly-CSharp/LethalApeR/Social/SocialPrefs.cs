using System;
using System.Collections.Generic;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.Social
{
	public static class SocialPrefs
	{
		public const string RequestsServerKey = "Social_Requests";

		private const string StatusKey = "Social_Status";

		private const string JoinableKey = "Social_Joinable";

		private const string RequestsKey = "Social_FriendRequests";

		private const string RequestsUnsavedKey = "Social_FriendRequestsUnsaved";

		private const string Open = "1";

		private const string Closed = "0";

		private static bool _loaded;

		private static PresenceStatus _status;

		private static bool _joinable;

		private static bool _requests;

		private static bool _requestsUnsaved;

		private static bool _saving;

		public static PresenceStatus Status
		{
			get
			{
				Load();
				return _status;
			}
			set
			{
				Load();
				if (_status != value)
				{
					_status = value;
					PlayerPrefs.SetInt(StatusKey, (int)value);
					PlayerPrefs.Save();
					SocialPrefs.Changed?.Invoke();
				}
			}
		}

		public static bool Joinable
		{
			get
			{
				Load();
				return _joinable;
			}
			set
			{
				Load();
				if (_joinable != value)
				{
					_joinable = value;
					PlayerPrefs.SetInt(JoinableKey, value ? 1 : 0);
					PlayerPrefs.Save();
					SocialPrefs.Changed?.Invoke();
				}
			}
		}

		public static bool FriendRequests
		{
			get
			{
				Load();
				return _requests;
			}
			set
			{
				Load();
				if (_requests != value)
				{
					_requests = value;
					_requestsUnsaved = true;
					SaveRequestsLocal();
					SaveRequests();
					SocialPrefs.Changed?.Invoke();
				}
			}
		}

		public static event Action Changed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_loaded = false;
			_saving = false;
			SocialPrefs.Changed = null;
		}

		public static async void SyncWithServer()
		{
			if (!Qauth.IsLoggedIn)
			{
				return;
			}
			Load();
			Dictionary<string, QauthSave> result;
			try
			{
				result = await Qauth.Saves.PullAsync();
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[Social] Couldn't read the friend request setting: " + ex.Message);
				return;
			}
			if (_requestsUnsaved)
			{
				SaveRequests();
				return;
			}
			QauthSave value = null;
			bool flag = result == null || !result.TryGetValue(RequestsServerKey, out value) || value == null || value.Data != Closed;
			if (_requests != flag)
			{
				_requests = flag;
				SaveRequestsLocal();
				SocialPrefs.Changed?.Invoke();
			}
		}

		public static void RetryUnsaved()
		{
			Load();
			if (_requestsUnsaved)
			{
				SaveRequests();
			}
		}

		private static async void SaveRequests()
		{
			if (_saving || !Qauth.IsLoggedIn)
			{
				return;
			}
			_saving = true;
			bool sent = _requests;
			QauthPushResult result;
			try
			{
				result = await Qauth.Saves.PushAsync(RequestsServerKey, sent ? Open : Closed, QauthSaves.Now);
			}
			catch (Exception ex)
			{
				_saving = false;
				Debug.LogWarning("[Social] Couldn't save the friend request setting: " + ex.Message);
				return;
			}
			_saving = false;
			if (!result.Ok)
			{
				Debug.LogWarning("[Social] Couldn't save the friend request setting: " + result.Error);
			}
			else if (sent == _requests)
			{
				_requestsUnsaved = false;
				SaveRequestsLocal();
			}
			else
			{
				SaveRequests();
			}
		}

		private static void SaveRequestsLocal()
		{
			PlayerPrefs.SetInt(RequestsKey, _requests ? 1 : 0);
			PlayerPrefs.SetInt(RequestsUnsavedKey, _requestsUnsaved ? 1 : 0);
			PlayerPrefs.Save();
		}

		private static void Load()
		{
			if (!_loaded)
			{
				_loaded = true;
				_status = (PresenceStatus)Mathf.Clamp(PlayerPrefs.GetInt(StatusKey, 0), 0, 2);
				_joinable = PlayerPrefs.GetInt(JoinableKey, 1) == 1;
				_requests = PlayerPrefs.GetInt(RequestsKey, 1) == 1;
				_requestsUnsaved = PlayerPrefs.GetInt(RequestsUnsavedKey, 0) == 1;
			}
		}
	}
}
