using UnityEngine;
using UnityEngine.Audio;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(-100)]
	public class FnGhost : MonoBehaviour
	{
		[Tooltip("Mixer group for the ghost ambience loop.")]
		public AudioMixerGroup output;

		[Range(0f, 1f)]
		public float ambienceVolume = 0.45f;

		[Tooltip("Ghost ambience fade in and out (s).")]
		public float ambienceFadeSeconds = 1.5f;

		[Range(0f, 1f)]
		public float riseVolume = 0.8f;

		[Tooltip("The night says caught but no Caught event arrived: rise in place, without the jumpscare, after this long (s).")]
		public float missedCatchGrace = 1f;

		private FnNight _night;

		private AudioSource _ambience;

		private float _ambienceLevel;

		private float _ghostSince = -1f;

		private bool _caught;

		private bool _debug;

		private bool _motion;

		public static FnGhost Instance { get; private set; }

		public static bool LocalIsGhost { get; private set; }

		public static bool LocalRisen { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
			LocalIsGhost = false;
			LocalRisen = false;
		}

		private void Awake()
		{
			Instance = this;
			_ambience = FnLocalLoop.Create(transform, "GhostAmbience", output);
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnDisable()
		{
			if (LocalRisen)
			{
				Sink();
			}
			_caught = false;
			LocalIsGhost = false;
			_ambienceLevel = 0f;
			_ghostSince = -1f;
			FnLocalLoop.Drive(_ambience, null, 0f);
			Bind(null);
		}

		private void Update()
		{
			Bind(FnNight.Instance);
			Refresh();
			FadeAmbience();
		}

		public bool RiseFromCatch()
		{
			if (!isActiveAndEnabled)
			{
				return false;
			}
			Refresh();
			if (!LocalIsGhost || LocalRisen)
			{
				return false;
			}
			Rise(true);
			return true;
		}

		private void Refresh()
		{
			FnNight night = _night;
			if (night != null && night.Active && night.Phase >= FnPhase.Night && night.Phase < FnPhase.Results)
			{
				LocalIsGhost = _debug || _caught || night.LocalIsGhost;
			}
			else
			{
				_caught = false;
				LocalIsGhost = _debug;
			}
			if (LocalIsGhost)
			{
				if (_ghostSince < 0f)
				{
					_ghostSince = Time.unscaledTime;
				}
				if (!LocalRisen && !FnJumpscare.Playing && (_debug || Time.unscaledTime - _ghostSince >= missedCatchGrace || FnJumpscare.Instance == null))
				{
					Rise(false);
				}
			}
			else
			{
				_ghostSince = -1f;
				if (LocalRisen)
				{
					Sink();
				}
			}
		}

		private void Rise(bool drift)
		{
			LocalRisen = true;
			FnSettings.GhostSettings ghost = FnGame.Settings.ghost;
			FnPlatform.SetGhostMotion(true, ghost.gravity, ghost.drag, drift ? ghost.riseSpeed : 0f);
			_motion = true;
			FnAudioBank audio = FnGame.Audio;
			FnAudio.Flat((audio != null) ? audio.ghostRise : null, riseVolume, 1f);
		}

		private void Sink()
		{
			LocalRisen = false;
			if (_motion)
			{
				_motion = false;
				FnPlatform.SetGhostMotion(false, 0f, 0f, 0f);
			}
		}

		private void FadeAmbience()
		{
			FnAudioBank audio = FnGame.Audio;
			AudioClip clip = (audio != null) ? audio.ghostAmbienceLoop : null;
			float target = (LocalRisen && clip != null) ? ambienceVolume : 0f;
			float rate = Mathf.Max(ambienceVolume, 0.01f) / Mathf.Max(ambienceFadeSeconds, 0.05f);
			_ambienceLevel = Mathf.MoveTowards(_ambienceLevel, target, Time.unscaledDeltaTime * rate);
			FnLocalLoop.Drive(_ambience, clip, _ambienceLevel);
		}

		private void Bind(FnNight night)
		{
			if (night == _night)
			{
				return;
			}
			if (_night != null)
			{
				_night.Caught -= OnCaught;
			}
			_night = night;
			if (_night != null)
			{
				_night.Caught += OnCaught;
			}
		}

		private void OnCaught(int actor, FnAnim anim, FnCatchCause cause)
		{
			if (actor == FnGame.LocalActor)
			{
				_caught = true;
			}
		}

		public static void DebugEnterGhost()
		{
			FnGhost instance = Instance;
			if (!(instance == null) && instance.isActiveAndEnabled)
			{
				instance._debug = true;
				instance.Refresh();
			}
		}

		public static void DebugExitGhost()
		{
			FnGhost instance = Instance;
			if (!(instance == null))
			{
				instance._debug = false;
				instance._caught = false;
				if (instance.isActiveAndEnabled)
				{
					instance.Refresh();
				}
			}
		}

		[ContextMenu("Debug: Enter Ghost")]
		private void ContextEnter()
		{
			DebugEnterGhost();
		}

		[ContextMenu("Debug: Exit Ghost")]
		private void ContextExit()
		{
			DebugExitGhost();
		}
	}
}
