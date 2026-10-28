using System;
using System.Collections;
using System.IO;
using GorillaLocomotion;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.SceneFlow
{
	[DefaultExecutionOrder(-32768)]
	public sealed class SceneTransition : MonoBehaviour
	{
		public struct Options
		{
			public float fadeOut;

			public float fadeIn;

			public bool leaveRoom;

			public bool viaTransit;

			public static Options Default => new Options
			{
				fadeOut = 0.35f,
				fadeIn = 0.5f,
				leaveRoom = true,
				viaTransit = false
			};
		}

		public const float DefaultFadeOut = 0.35f;

		public const float DefaultFadeIn = 0.5f;

		public const string TransitScene = "Transit";

		private const float NetworkedLoadTimeout = 60f;

		private const float BusyWatchdog = 90f;

		private const int SettleFrames = 6;

		private static SceneTransition _driver;

		private static bool _busy;

		private static float _busySince;

		public static bool IsBusy
		{
			get
			{
				if (_busy)
				{
					return Time.unscaledTime - _busySince < 90f;
				}
				return false;
			}
		}

		private static void SetBusy(bool value)
		{
			_busy = value;
			if (value)
			{
				_busySince = Time.unscaledTime;
			}
		}

		private static SceneTransition Driver()
		{
			if ((bool)_driver)
			{
				return _driver;
			}
			GameObject gameObject = new GameObject("~SceneTransition");
			UnityEngine.Object.DontDestroyOnLoad(gameObject);
			_driver = gameObject.AddComponent<SceneTransition>();
			return _driver;
		}

		public static bool Go(string sceneName)
		{
			return Go(sceneName, Options.Default);
		}

		public static bool Go(string sceneName, Options options)
		{
			if (IsBusy)
			{
				Debug.LogWarning("[SceneTransition] Ignoring '" + sceneName + "' - a transition is already running.");
				return false;
			}
			if (string.IsNullOrWhiteSpace(sceneName))
			{
				Debug.LogError("[SceneTransition] Go called with an empty scene name.");
				return false;
			}
			if (!IsInBuildSettings(sceneName))
			{
				Debug.LogError("[SceneTransition] Scene '" + sceneName + "' is not in Build Settings. Refusing to transition - the player would be left in a dead scene with the room already left.");
				return false;
			}
			SetBusy(value: true);
			Driver().StartCoroutine(Driver().Run(sceneName, options));
			return true;
		}

		public static bool GoNetworked(string sceneName, float fadeOut = 0.35f)
		{
			if (IsBusy || string.IsNullOrWhiteSpace(sceneName))
			{
				return false;
			}
			if (!IsInBuildSettings(sceneName))
			{
				Debug.LogError("[SceneTransition] Networked target '" + sceneName + "' is not in Build Settings.");
				return false;
			}
			SetBusy(value: true);
			Driver().StartCoroutine(Driver().RunNetworked(sceneName, fadeOut));
			return true;
		}

		public static IEnumerator FadeOut(float duration = 0.35f)
		{
			return SceneFadeOverlay.Ensure().FadeTo(1f, duration);
		}

		public static IEnumerator FadeIn(float duration = 0.5f)
		{
			return SceneFadeOverlay.Ensure().FadeTo(0f, duration);
		}

		public static bool IsInBuildSettings(string sceneName)
		{
			if (string.IsNullOrWhiteSpace(sceneName))
			{
				return false;
			}
			int sceneCountInBuildSettings = SceneManager.sceneCountInBuildSettings;
			for (int i = 0; i < sceneCountInBuildSettings; i++)
			{
				string scenePathByBuildIndex = SceneUtility.GetScenePathByBuildIndex(i);
				if (string.Equals(scenePathByBuildIndex, sceneName, StringComparison.OrdinalIgnoreCase))
				{
					return true;
				}
				if (string.Equals(Path.GetFileNameWithoutExtension(scenePathByBuildIndex), sceneName, StringComparison.OrdinalIgnoreCase))
				{
					return true;
				}
			}
			return false;
		}

		private IEnumerator Run(string sceneName, Options o)
		{
			SceneFadeOverlay overlay = SceneFadeOverlay.Ensure();
			bool restoreMovement = FreezePlayer();
			if (o.leaveRoom)
			{
				MonkeDevNetworkingManager.BeginSceneHandoff();
			}
			yield return overlay.FadeTo(1f, o.fadeOut);
			if (o.leaveRoom)
			{
				try
				{
					if (PhotonNetwork.InRoom)
					{
						PhotonNetwork.LeaveRoom();
					}
				}
				catch (Exception exception)
				{
					Debug.LogException(exception);
				}
			}
			ThreadPriority prevPriority = Application.backgroundLoadingPriority;
			Application.backgroundLoadingPriority = ThreadPriority.High;
			if (o.viaTransit && IsInBuildSettings("Transit") && SceneManager.GetActiveScene().name != "Transit")
			{
				yield return DumpToTransit();
			}
			AsyncOperation op = SceneManager.LoadSceneAsync(sceneName);
			if (op == null)
			{
				Debug.LogError("[SceneTransition] LoadSceneAsync('" + sceneName + "') returned null.");
				Application.backgroundLoadingPriority = prevPriority;
				if (o.leaveRoom)
				{
					MonkeDevNetworkingManager.CancelSceneHandoff();
				}
				if (restoreMovement)
				{
					UnfreezePlayer();
				}
				yield return overlay.FadeTo(0f, o.fadeIn);
				SetBusy(value: false);
				yield break;
			}
			op.allowSceneActivation = false;
			while (op.progress < 0.9f)
			{
				yield return null;
			}
			yield return null;
			yield return null;
			op.allowSceneActivation = true;
			while (!op.isDone)
			{
				yield return null;
			}
			Application.backgroundLoadingPriority = prevPriority;
			for (int i = 0; i < 6; i++)
			{
				yield return null;
			}
			yield return overlay.FadeTo(0f, o.fadeIn);
			SetBusy(value: false);
		}

		private IEnumerator DumpToTransit()
		{
			AsyncOperation op = SceneManager.LoadSceneAsync("Transit");
			while (!op.isDone)
			{
				yield return null;
			}
			yield return Resources.UnloadUnusedAssets();
			yield return null;
		}

		private IEnumerator RunNetworked(string sceneName, float fadeOut)
		{
			SceneFadeOverlay overlay = SceneFadeOverlay.Ensure();
			FreezePlayer();
			yield return overlay.FadeTo(1f, fadeOut);
			Application.backgroundLoadingPriority = ThreadPriority.Low;
			PhotonNetwork.LoadLevel(sceneName);
			float waited = 0f;
			while (SceneManager.GetActiveScene().name != sceneName && waited < 60f)
			{
				waited += Time.unscaledDeltaTime;
				yield return null;
			}
			if (SceneManager.GetActiveScene().name != sceneName)
			{
				Debug.LogError(string.Format("[SceneTransition] Networked load of '{0}' did not complete within {1}s - fading back in regardless.", sceneName, 60f));
			}
			for (int i = 0; i < 6; i++)
			{
				yield return null;
			}
			yield return overlay.FadeTo(0f, 0.5f);
			SetBusy(value: false);
		}

		private static bool FreezePlayer()
		{
			Player player = (Player.HasInstance ? Player.Instance : null);
			if (player == null || player.disableMovement)
			{
				return false;
			}
			player.disableMovement = true;
			return true;
		}

		private static void UnfreezePlayer()
		{
			Player player = (Player.HasInstance ? Player.Instance : null);
			if (player != null)
			{
				player.disableMovement = false;
			}
		}
	}
}
