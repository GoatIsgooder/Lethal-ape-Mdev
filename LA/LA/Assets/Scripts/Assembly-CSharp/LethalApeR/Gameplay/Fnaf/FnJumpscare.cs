using System.Collections;
using LethalApeR.Gameplay.ApeGames;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnJumpscare : MonoBehaviour
	{
		[Tooltip("Lunge models indexed by FnAnim (Bear, Bunny, Chicken, Endo): a posed head and torso, pivot between the eyes, the face looking along +Z, unlit or emissive (the office is dark), no colliders, normally inactive.")]
		public GameObject[] faces = new GameObject[4];

		[Tooltip("The same, for a Nightmare night (indexed by FnAnim). Empty entries fall back to faces.")]
		public GameObject[] nightmareFaces = new GameObject[4];

		[Tooltip("Where the rush ends: the viewer's eyes to the model's eyes (m). Keep its nearest point (snout, jaw) at least 0.1 m from the viewer; closer is a vergence strain even for a moment.")]
		public float lungeEndDistance = 0.25f;

		[Tooltip("Share of the lunge spent holding at the start distance before the rush.")]
		[Range(0f, 0.5f)]
		public float lungeHold = 0.12f;

		[Tooltip("The face never comes from further above or below level than this (degrees).")]
		[Range(0f, 60f)]
		public float maxLungePitch = 30f;

		[Tooltip("Fade back in once the ghost has risen (s).")]
		public float fadeInSeconds = 0.8f;

		[Range(0f, 1f)]
		public float stingVolume = 1f;

		[Tooltip("Haptic amplitude through the lunge, and the hit at its end.")]
		public Vector2 hapticAmplitude = new Vector2(0.5f, 1f);

		[Tooltip("Context-menu DebugPlay target.")]
		public FnAnim debugAnim = FnAnim.Bunny;

		private FnNight _night;

		private Coroutine _run;

		private GameObject _face;

		private Vector3 _lungeDirection = Vector3.forward;

		private float _lungeDistance;

		private bool _real;

		private bool _froze;

		public static FnJumpscare Instance { get; private set; }

		public static bool Playing { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
			Playing = false;
		}

		private void Awake()
		{
			Instance = this;
			if (faces != null)
			{
				for (int i = 0; i < faces.Length; i++)
				{
					if (faces[i] != null && faces[i].activeSelf)
					{
						faces[i].SetActive(false);
					}
				}
			}
			if (nightmareFaces == null)
			{
				return;
			}
			for (int j = 0; j < nightmareFaces.Length; j++)
			{
				if (nightmareFaces[j] != null && nightmareFaces[j].activeSelf)
				{
					nightmareFaces[j].SetActive(false);
				}
			}
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
			if (_run != null)
			{
				StopCoroutine(_run);
				_run = null;
			}
			ShowFace(null);
			ReleaseRig();
			Playing = false;
			FnLocalFade.ClearNow(this);
			Bind(null);
		}

		private void Update()
		{
			Bind(FnNight.Instance);
			if (Playing && _real && (_night == null || !_night.Active || _night.Phase >= FnPhase.Results))
			{
				Abort();
			}
		}

		private void LateUpdate()
		{
			if (!(_face == null))
			{
				Camera eye = FnPlatform.Eye;
				if (eye != null)
				{
					PlaceFace(eye.transform);
				}
			}
		}

		public static void DebugPlay(FnAnim anim)
		{
			FnJumpscare instance = Instance;
			if (!(instance == null) && !Playing)
			{
				instance.Begin(anim, false);
			}
		}

		[ContextMenu("Debug: Play Jumpscare")]
		private void ContextPlay()
		{
			DebugPlay(debugAnim);
		}

		private void OnCaught(int actor, FnAnim anim, FnCatchCause cause)
		{
			if (actor == FnGame.LocalActor && !Playing && !FnGhost.LocalRisen && !(_night == null) && _night.Active && _night.Phase < FnPhase.Results)
			{
				Begin(anim, true);
			}
		}

		private void Begin(FnAnim anim, bool real)
		{
			if (isActiveAndEnabled)
			{
				if (_run != null)
				{
					StopCoroutine(_run);
				}
				_real = real;
				_run = StartCoroutine(Run(anim));
			}
		}

		private IEnumerator Run(FnAnim anim)
		{
			Playing = true;
			FnSettings s = FnGame.Settings;
			FnPlatform.Freeze(true);
			_froze = true;
			FnAudioBank audio = FnGame.Audio;
			FnAudio.Flat((audio != null) ? audio.jumpscareSting : null, stingVolume, 1f);
			if (!s.comfort.reducedJumpscare)
			{
				yield return Lunge(anim, s.catches);
			}
			yield return FnLocalFade.Out(this, s.catches.caughtFadeSeconds);
			ShowFace(null);
			ReleaseRig();
			if (FnGhost.Instance != null)
			{
				FnGhost.Instance.RiseFromCatch();
			}
			for (float t = 0f; t < s.catches.ghostDelaySeconds; t += Time.unscaledDeltaTime)
			{
				yield return null;
			}
			yield return FnLocalFade.In(this, fadeInSeconds);
			Playing = false;
			_run = null;
		}

		private IEnumerator Lunge(FnAnim anim, FnSettings.CatchSettings c)
		{
			float seconds = Mathf.Clamp(c.lungeSeconds, 0.2f, 1f);
			Camera eye = FnPlatform.Eye;
			GameObject face = FaceFor(anim);
			if (eye != null && face != null)
			{
				Transform transform = eye.transform;
				_lungeDirection = FnGhostRules.LungeDirection(transform.forward, transform.up, maxLungePitch);
				_lungeDistance = c.lungeDistance;
				ShowFace(face);
			}
			AgHaptics.Both(hapticAmplitude.x, seconds);
			for (float elapsed = 0f; elapsed < seconds; elapsed += Time.unscaledDeltaTime)
			{
				_lungeDistance = FnGhostRules.LungeDistance(elapsed / seconds, c.lungeDistance, lungeEndDistance, lungeHold);
				yield return null;
			}
			_lungeDistance = lungeEndDistance;
			AgHaptics.Both(hapticAmplitude.y, 0.3f);
		}

		private void PlaceFace(Transform eye)
		{
			Transform transform = _face.transform;
			Vector3 position = eye.position;
			transform.SetPositionAndRotation(position + _lungeDirection * _lungeDistance, Quaternion.LookRotation(-_lungeDirection, Vector3.up));
		}

		private void ShowFace(GameObject face)
		{
			if (_face == face)
			{
				return;
			}
			if (_face != null)
			{
				_face.SetActive(false);
			}
			_face = face;
			if (!(_face == null))
			{
				Camera eye = FnPlatform.Eye;
				if (eye != null)
				{
					PlaceFace(eye.transform);
				}
				_face.SetActive(true);
			}
		}

		private void ReleaseRig()
		{
			if (_froze)
			{
				_froze = false;
				FnPlatform.Freeze(false);
			}
		}

		private void Abort()
		{
			if (_run != null)
			{
				StopCoroutine(_run);
				_run = null;
			}
			ShowFace(null);
			ReleaseRig();
			Playing = false;
			if (FnLocalFade.IsDarkBy(this))
			{
				StartCoroutine(FnLocalFade.In(this, fadeInSeconds));
			}
		}

		private GameObject FaceFor(FnAnim anim)
		{
			FnNight instance = FnNight.Instance;
			if (instance != null && instance.Difficulty == FnDifficulty.Nightmare && nightmareFaces != null && (int)anim < nightmareFaces.Length && nightmareFaces[(int)anim] != null)
			{
				return nightmareFaces[(int)anim];
			}
			if (faces == null || (int)anim >= faces.Length)
			{
				return null;
			}
			return faces[(int)anim];
		}

		private void Bind(FnNight night)
		{
			if (!(night == _night))
			{
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
		}
	}
}
