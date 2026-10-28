using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgWatcherController : MonoBehaviour
	{
		[Header("Head")]
		[SerializeField]
		private Transform headPivot;

		[Header("Pose targets (optional; a wired transform's POSITION + ROTATION is that pose)")]
		[SerializeField]
		private Transform awayTarget;

		[SerializeField]
		private Transform facingTarget;

		[SerializeField]
		private float facingYawOffset;

		[Header("Turn tween")]
		[SerializeField]
		private float turnDuration = 0.28f;

		[SerializeField]
		private AnimationCurve turnEase = DefaultEase();

		[Header("Head SFX (null-safe; plays on the green→red turn)")]
		[SerializeField]
		private AudioSource turnSfx;

		[Header("Eye light per light state (null-safe)")]
		[SerializeField]
		private Light eyeLight;

		[SerializeField]
		private Color eyeGreen = new Color(0.1f, 0.9f, 0.25f, 1f);

		[SerializeField]
		private Color eyeRed = new Color(0.95f, 0.12f, 0.12f, 1f);

		[Header("Optional material swap per light state (null-safe)")]
		[SerializeField]
		private Renderer lightSwapRenderer;

		[SerializeField]
		private Material greenMaterial;

		[SerializeField]
		private Material redMaterial;

		[Header("Round (wire Round_0's AgRoundRedLight, either direction resolves the pair)")]
		[SerializeField]
		private AgRoundRedLight round;

		private Vector3 _awayPosition;

		private Quaternion _awayRotation;

		private Vector3 _facingPosition;

		private Quaternion _facingRotation;

		private Vector3 _fromPosition;

		private Quaternion _fromRotation;

		private Vector3 _toPosition;

		private Quaternion _toRotation;

		private float _tweenElapsed;

		private float _tweenDuration;

		private AgLightState _lightState;

		private bool _lightApplied;

		public static AgWatcherController Instance { get; private set; }

		private void Awake()
		{
			Instance = this;
			if (headPivot == null)
			{
				headPivot = base.transform;
			}
			if (round != null)
			{
				round.RegisterWatcher(this);
			}
			ResolvePoses();
			_tweenDuration = 0f;
			_toPosition = _awayPosition;
			_toRotation = _awayRotation;
			headPivot.SetPositionAndRotation(_awayPosition, _awayRotation);
			ConfigureSfx(turnSfx);
			ApplyLightVisuals(AgLightState.Green);
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Update()
		{
			if (!(_tweenDuration <= 0f))
			{
				_tweenElapsed += Time.deltaTime;
				float num = Mathf.Clamp01(_tweenElapsed / _tweenDuration);
				float t = ((turnEase != null) ? turnEase.Evaluate(num) : num);
				headPivot.SetPositionAndRotation(Vector3.LerpUnclamped(_fromPosition, _toPosition, t), Quaternion.SlerpUnclamped(_fromRotation, _toRotation, t));
				if (num >= 1f)
				{
					headPivot.SetPositionAndRotation(_toPosition, _toRotation);
					_tweenDuration = 0f;
				}
			}
		}

		private void ResolvePoses()
		{
			if (awayTarget != null)
			{
				_awayPosition = awayTarget.position;
				_awayRotation = awayTarget.rotation;
			}
			else
			{
				_awayPosition = headPivot.position;
				_awayRotation = headPivot.rotation;
			}
			if (facingTarget != null)
			{
				_facingPosition = facingTarget.position;
				_facingRotation = facingTarget.rotation;
				return;
			}
			_facingPosition = _awayPosition;
			RandomizeSpawnPoint randomizeSpawnPoint = ((round != null) ? round.playersTp : null);
			if (randomizeSpawnPoint != null)
			{
				Vector3 vector = randomizeSpawnPoint.transform.position - _awayPosition;
				vector.y = 0f;
				if (vector.sqrMagnitude > 0.0001f)
				{
					_facingRotation = Quaternion.LookRotation(vector.normalized, Vector3.up) * Quaternion.Euler(0f, facingYawOffset, 0f);
					return;
				}
			}
			_facingRotation = _awayRotation * Quaternion.Euler(0f, facingYawOffset + 180f, 0f);
		}

		public void ApplyLightState(AgLightState state)
		{
			if (!base.gameObject.activeInHierarchy)
			{
				_lightApplied = false;
			}
			else
			{
				if (_lightApplied && _lightState == state)
				{
					return;
				}
				bool lightApplied = _lightApplied;
				_lightState = state;
				_lightApplied = true;
				Vector3 vector = ((state == AgLightState.Red) ? _facingPosition : _awayPosition);
				Quaternion quaternion = ((state == AgLightState.Red) ? _facingRotation : _awayRotation);
				if (lightApplied && turnDuration > 0f)
				{
					_fromPosition = headPivot.position;
					_fromRotation = headPivot.rotation;
					_toPosition = vector;
					_toRotation = quaternion;
					_tweenElapsed = 0f;
					_tweenDuration = turnDuration;
					if (state == AgLightState.Red)
					{
						if (turnSfx != null)
						{
							turnSfx.Play();
						}
						AgHaptics.Both(0.4f, 0.09f);
					}
				}
				else
				{
					_tweenDuration = 0f;
					_toPosition = vector;
					_toRotation = quaternion;
					headPivot.SetPositionAndRotation(vector, quaternion);
				}
				ApplyLightVisuals(state);
			}
		}

		private void ApplyLightVisuals(AgLightState state)
		{
			if (eyeLight != null)
			{
				eyeLight.color = ((state == AgLightState.Green) ? eyeGreen : eyeRed);
			}
			if (lightSwapRenderer != null)
			{
				Material material = ((state == AgLightState.Green) ? greenMaterial : redMaterial);
				if (material != null)
				{
					lightSwapRenderer.sharedMaterial = material;
				}
			}
		}

		public void ResetToPost()
		{
			_lightState = AgLightState.Green;
			_lightApplied = false;
			_toPosition = _awayPosition;
			_toRotation = _awayRotation;
			_tweenDuration = 0f;
			if (headPivot != null)
			{
				headPivot.SetPositionAndRotation(_awayPosition, _awayRotation);
			}
			ApplyLightVisuals(AgLightState.Green);
			if (turnSfx != null && turnSfx.isPlaying)
			{
				turnSfx.Stop();
			}
		}

		private static void ConfigureSfx(AudioSource src)
		{
			if (!(src == null))
			{
				src.spatialize = false;
				src.spatialBlend = 1f;
				src.playOnAwake = false;
				src.loop = false;
			}
		}

		private static AnimationCurve DefaultEase()
		{
			AnimationCurve animationCurve = new AnimationCurve(new Keyframe(0f, 0f), new Keyframe(0.6f, 1.08f), new Keyframe(1f, 1f));
			animationCurve.SmoothTangents(1, 0f);
			return animationCurve;
		}
	}
}
