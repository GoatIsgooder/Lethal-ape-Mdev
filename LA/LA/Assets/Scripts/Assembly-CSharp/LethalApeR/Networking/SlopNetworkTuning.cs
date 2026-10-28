using Photon.Pun;
using Photon.Voice.Unity;
using UnityEngine;

namespace LethalApeR.Networking
{
	public static class SlopNetworkTuning
	{
		public const int SerializationRate = 8;

		public const int SendRate = 20;

		public const bool EnableVoiceDetection = true;

		public const float VoiceDetectionThreshold = 0.01f;

		public const int VoiceDetectionDelayMs = 500;

		public const float MinCalibratedThreshold = 0.005f;

		public const float MaxCalibratedThreshold = 0.03f;

		private static bool _installed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
		private static void Install()
		{
			if (!_installed)
			{
				_installed = true;
				PhotonNetwork.SendRate = 20;
				PhotonNetwork.SerializationRate = 8;
				PhotonNetwork.UseRpcMonoBehaviourCache = true;
				GameObject gameObject = new GameObject("SlopNetworkTuning");
				gameObject.hideFlags = HideFlags.HideAndDontSave;
				Object.DontDestroyOnLoad(gameObject);
				gameObject.AddComponent<SlopNetworkTuningRunner>();
				Debug.Log(string.Format("[SlopNetworkTuning] SerializationRate={0}Hz SendRate={1}Hz VAD={2}", 8, 20, true));
			}
		}

		public static void ApplyVoiceSettings(Recorder recorder)
		{
			if (!(recorder == null))
			{
				recorder.VoiceDetectionThreshold = 0.01f;
				recorder.VoiceDetectionDelayMs = 500;
				recorder.VoiceDetection = true;
			}
		}

		public static void CalibrateVoiceDetection(Recorder recorder, int durationMs = 2000)
		{
			if (recorder == null || recorder.VoiceDetector == null || recorder.VoiceDetectorCalibrating)
			{
				return;
			}
			recorder.VoiceDetectorCalibrate(durationMs, delegate(float measured)
			{
				float num = Mathf.Clamp(measured, 0.005f, 0.03f);
				recorder.VoiceDetectionThreshold = num;
				Debug.Log(string.Format("[SlopNetworkTuning] VAD calibrated: measured={0:F4} applied={1:F4}", measured, num));
			});
		}
	}
}
