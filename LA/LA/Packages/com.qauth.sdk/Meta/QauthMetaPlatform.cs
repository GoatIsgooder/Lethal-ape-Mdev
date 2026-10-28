using System;
using System.Threading.Tasks;
using Oculus.Platform;
using Oculus.Platform.Models;
using UnityEngine;

namespace QauthSdk
{
	// Qauth's Meta side with the Meta XR Platform SDK (v55+ for attestation). Compiled only when that SDK is in the
	// project, and registered as Qauth.Platform by itself before any scene loads.
	public sealed class QauthMetaPlatform : IQauthPlatform
	{
		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
		private static void Register()
		{
			if (Qauth.Platform == null) Qauth.Platform = new QauthMetaPlatform();
		}

		public async Task<QauthIdentity> InitializeAsync(string appId)
		{
			QauthIdentity id = new QauthIdentity();
			// Quest builds always; the editor only with a Meta test user (Meta > Platform > Edit Settings: Use Standalone Platform)
			bool editorTestUser = UnityEngine.Application.isEditor && PlatformSettings.UseStandalonePlatform;
			if (!editorTestUser && (UnityEngine.Application.isEditor || UnityEngine.Application.platform != RuntimePlatform.Android))
			{
				id.Error = UnityEngine.Application.isEditor ? "editor: no Meta test user set up" : "no Meta login on this platform";
				return id;
			}
#if UNITY_EDITOR
			if (editorTestUser && string.IsNullOrEmpty(StandalonePlatformSettings.OculusPlatformTestUserAccessToken))
			{
				id.Error = "editor: no Meta test user signed in (Meta > Platform > Edit Settings)";
				return id;
			}
#endif
			if (!Core.IsInitialized())
			{
				Message<PlatformInitialize> init;
				try
				{
					init = await Run(Core.AsyncInitialize(string.IsNullOrEmpty(appId) ? null : appId));
				}
				catch (Exception e)
				{
					// the Meta SDK throws (not an error message) for missing standalone credentials
					id.Error = "Meta SDK didn't start: " + e.Message;
					return id;
				}
				if (init.IsError)
				{
					id.Error = "Meta SDK didn't start: " + init.GetError().Message;
					return id;
				}
			}
			id.Initialized = true;
			Message entitlement = await RunPlain(Entitlements.IsUserEntitledToApplication());
			if (entitlement.IsError)
			{
				id.Error = "this Meta account doesn't own the game: " + entitlement.GetError().Message;
				return id;
			}
			id.Entitled = true;
			Message<User> user = await Run(Users.GetLoggedInUser());
			if (user.IsError || user.Data == null)
			{
				id.Error = "couldn't read the Meta user: " + (user.IsError ? user.GetError().Message : "none");
				return id;
			}
			id.MetaUserId = user.Data.ID.ToString();
			id.Username = !string.IsNullOrEmpty(user.Data.OculusID) ? user.Data.OculusID : user.Data.DisplayName;
			return id;
		}

		public async Task<string> GetUserProofAsync()
		{
			Message<UserProof> proof = await Run(Users.GetUserProof());
			return proof.IsError || proof.Data == null ? null : proof.Data.Value;
		}

		public async Task<string> GetIntegrityTokenAsync(string nonce)
		{
			Message<string> token = await Run(DeviceApplicationIntegrity.GetIntegrityToken(nonce));
			if (token.IsError) throw new Exception(token.GetError().Message);
			return token.Data;
		}

		// Meta SDK requests -> awaitable (callbacks come on the main thread through the SDK's callback runner)
		private static Task<Message<T>> Run<T>(Request<T> request)
		{
			TaskCompletionSource<Message<T>> tcs = new TaskCompletionSource<Message<T>>();
			if (request == null) tcs.SetException(new Exception("Meta SDK request could not be sent"));
			else request.OnComplete(m => tcs.TrySetResult(m));
			return tcs.Task;
		}

		private static Task<Message> RunPlain(Request request)
		{
			TaskCompletionSource<Message> tcs = new TaskCompletionSource<Message>();
			if (request == null) tcs.SetException(new Exception("Meta SDK request could not be sent"));
			else request.OnComplete(m => tcs.TrySetResult(m));
			return tcs.Task;
		}
	}
}
