using System.Collections;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Rendering
{
	internal sealed class SlopRenderTuningRunner : MonoBehaviour
	{
		private static readonly WaitForSeconds Retry = new WaitForSeconds(1f);

		private const int Attempts = 6;

		private static bool _logged;

		private IEnumerator Start()
		{
			for (int i = 0; i < Attempts; i++)
			{
				OVRManager manager = Object.FindAnyObjectByType<OVRManager>();
				SlopRenderTuning.Apply(manager);
				if (manager != null && XRSettings.isDeviceActive)
				{
					break;
				}
				yield return Retry;
			}
			LogOnce();
		}

		private static void LogOnce()
		{
			if (!_logged)
			{
				_logged = true;
				Debug.Log("[SlopRenderTuning] " + SlopRenderTuning.LastStatus);
			}
		}

		private void Update()
		{
			SlopRenderTuning.TickOverride();
		}
	}
}
