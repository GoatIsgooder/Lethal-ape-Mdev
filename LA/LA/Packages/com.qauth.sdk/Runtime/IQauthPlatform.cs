using System.Threading.Tasks;

namespace QauthSdk
{
	// Who the player is, from Meta.
	public sealed class QauthIdentity
	{
		public bool Initialized; // the platform SDK started (false in the editor without a test user, or on PC)
		public string MetaUserId;
		public string Username; // Meta username (Oculus ID), or display name
		public bool Entitled; // Meta says this account owns the game
		public string Error; // set when something failed (then the other fields may be empty)
	}

	// The Meta side of logging in. The Qauth.Meta assembly provides one for the Meta XR Platform SDK and registers it
	// by itself; set Qauth.Platform to your own for tests or another store.
	public interface IQauthPlatform
	{
		// start the platform SDK, check the entitlement and read the logged-in user
		Task<QauthIdentity> InitializeAsync(string appId);

		// a fresh one-time proof that the Meta user id is really this player (Users.GetUserProof)
		Task<string> GetUserProofAsync();

		// Meta's attestation token bound to the server's nonce (DeviceApplicationIntegrity.GetIntegrityToken); throws or
		// returns null when Meta couldn't give one
		Task<string> GetIntegrityTokenAsync(string nonce);
	}
}
