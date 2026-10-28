using System.Collections;
using Photon.Voice.Unity;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Networking
{
	internal sealed class SlopNetworkTuningRunner : MonoBehaviour
	{
		private static readonly WaitForSeconds RetryDelay = new WaitForSeconds(1f);

		private const int RetryAttempts = 8;

		private Coroutine _applyRoutine;

		private void OnEnable()
		{
			SceneManager.sceneLoaded += OnSceneLoaded;
			Restart();
		}

		private void OnDisable()
		{
			SceneManager.sceneLoaded -= OnSceneLoaded;
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			Restart();
		}

		private void Restart()
		{
			if (_applyRoutine != null)
			{
				StopCoroutine(_applyRoutine);
			}
			_applyRoutine = StartCoroutine(ApplyWhenRecorderExists());
		}

		private IEnumerator ApplyWhenRecorderExists()
		{
			for (int i = 0; i < 8; i++)
			{
				Recorder recorder = Object.FindAnyObjectByType<Recorder>(FindObjectsInactive.Include);
				if (recorder != null)
				{
					SlopNetworkTuning.ApplyVoiceSettings(recorder);
					break;
				}
				yield return RetryDelay;
			}
			_applyRoutine = null;
		}
	}
}
