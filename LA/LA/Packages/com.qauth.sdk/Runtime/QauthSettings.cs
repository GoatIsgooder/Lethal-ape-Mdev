using UnityEngine;

namespace QauthSdk
{
	// Project settings for Qauth. Make one with Assets > Create > Qauth > Settings (or Tools > Qauth > Settings) and keep
	// it in a Resources folder named "QauthSettings", or pass settings to Qauth.Configure() yourself.
	[CreateAssetMenu(menuName = "Qauth/Settings", fileName = "QauthSettings")]
	public class QauthSettings : ScriptableObject
	{
		public const string ResourceName = "QauthSettings";

		[Tooltip("The Qauth API, without a trailing slash")]
		public string apiUrl = "https://api.qauth.wtf";

		[Tooltip("This game's id on Qauth (the /g/<id> part). Empty = the default game")]
		public string gameId = "5CKJX";

		[Tooltip("The game's app id on the Meta Quest store (Meta Developer Dashboard > API)")]
		public string metaAppId = "";

		[Tooltip("Log in by itself when the game starts")]
		public bool loginOnStart = true;

		[Tooltip("Quit when Meta says this Meta account doesn't own the game (Meta's VRC.Quest.Security.1). Builds only")]
		public bool quitIfNotEntitled = true;

		[Tooltip("Run Meta's attestation check again this often while the game runs, in minutes (0 = never)")]
		public float recheckMinutes = 30f;

		[Tooltip("How long one web request may take, in seconds")]
		public int requestTimeoutSeconds = 10;

		[Tooltip("How long to wait for Meta's attestation token, in seconds (it can be slow on a headset's first check)")]
		public int attestationTimeoutSeconds = 20;

		[Tooltip("Ask Qauth for staff gifts / kicks this often while logged in, in seconds (0 = off; then call Qauth.Grants yourself)")]
		public float grantsPollSeconds = 10f;

		[Tooltip("While a trade is live, check it this often, in seconds (both trade screens stay in step)")]
		public float tradePollSeconds = 2f;

		[Tooltip("With no trade going, check for incoming trade requests this often, in seconds (0 = off)")]
		public float tradeIdlePollSeconds = 6f;

		// the base every game call goes to: https://api.qauth.wtf/g/<game>
		public string GameBaseUrl => apiUrl.TrimEnd('/') + (string.IsNullOrWhiteSpace(gameId) ? "" : "/g/" + gameId.Trim());
	}
}
