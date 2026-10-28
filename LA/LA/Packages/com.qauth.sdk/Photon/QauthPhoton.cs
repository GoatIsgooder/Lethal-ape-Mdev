using System.Threading.Tasks;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace QauthSdk
{
	// Photon sign-in with Qauth. Compiled only when Photon PUN 2 is in the project.
	//
	// With the game's photonAuth = "custom" (set on the Qauth server), Photon asks Qauth
	// (api.qauth.wtf/g/<game>/v1/photon/auth) before letting a player into a room: only a logged-in, not banned player
	// with the matching Meta id gets in, and their Photon UserId is their Meta user id. Otherwise Meta's own (Oculus)
	// Photon auth is used.
	//
	//   await Qauth.LoginAsync();
	//   await QauthPhoton.ConfigureAsync();      // sets PhotonNetwork.AuthValues
	//   PhotonNetwork.ConnectUsingSettings();
	//
	// A Meta user proof only works once: call ConfigureAsync again before every (re)connect, and give Photon Voice its
	// own values with MakeAuthValuesAsync().
	public static class QauthPhoton
	{
		// Photon auth values for this player, or null without a Meta login (editor, PC)
		public static async Task<AuthenticationValues> MakeAuthValuesAsync()
		{
			await Qauth.WaitReady();
			if (Qauth.Platform == null || string.IsNullOrEmpty(Qauth.MetaUserId)) return null;
			string proof = await Qauth.Platform.GetUserProofAsync();
			if (string.IsNullOrEmpty(proof))
			{
				Debug.LogWarning("[Qauth] couldn't get a Meta user proof for Photon");
				return null;
			}
			bool custom = Qauth.PhotonAuthMode == "custom" && Qauth.IsLoggedIn;
			AuthenticationValues auth = new AuthenticationValues(Qauth.MetaUserId) { AuthType = custom ? CustomAuthenticationType.Custom : CustomAuthenticationType.Oculus };
			auth.AddAuthParameter("userid", Qauth.MetaUserId);
			auth.AddAuthParameter("nonce", proof);
			if (custom) auth.AddAuthParameter("token", Qauth.Token);
			return auth;
		}

		// set PhotonNetwork.AuthValues; false when there's no Meta login (the game can still connect without auth if
		// the Photon app allows anonymous players)
		public static async Task<bool> ConfigureAsync()
		{
			AuthenticationValues auth = await MakeAuthValuesAsync();
			if (auth == null) return false;
			PhotonNetwork.AuthValues = auth;
			return true;
		}
	}
}
