using System.Collections;
using System.Reflection;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmTechTreeRoom : MonoBehaviour
	{
		[SerializeField]
		private Transform arrivalPoint;

		[Tooltip("Where leaving the room puts you. Falls back to the round manager's lobby spawn.")]
		[SerializeField]
		private Transform lobbyReturnPoint;

		[Tooltip("Local-space box of the room; anyone whose head is inside counts as 'in the tree'.")]
		[SerializeField]
		private Bounds localBounds = new Bounds(new Vector3(0f, 6f, 0f), new Vector3(24f, 16f, 24f));

		[Tooltip("Falling below this local height puts you back on the hub floor.")]
		[SerializeField]
		private float voidHeight = -4f;

		[Tooltip("Only counts as a fall if you were inside the room this recently (seconds).")]
		[SerializeField]
		[Min(0.5f)]
		private float fallMemory = 4f;

		[Header("Transition")]
		[SerializeField]
		[Min(0.05f)]
		private float fadeOut = 0.25f;

		[SerializeField]
		[Min(0f)]
		private float holdBlack = 0.15f;

		[SerializeField]
		[Min(0.05f)]
		private float fadeIn = 0.35f;

		[SerializeField]
		private AudioClip enterClip;

		[SerializeField]
		private AudioClip exitClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float transitionVolume = 0.6f;

		[Header("Fog (scene fog is global: applied while inside, the scene's own settings restored on exit)")]
		[SerializeField]
		private bool fogInside = true;

		[SerializeField]
		private Color fogColor = new Color(0.045f, 0.05f, 0.06f, 1f);

		[SerializeField]
		[Range(0f, 0.1f)]
		private float fogDensity = 0.022f;

		[Header("Ambience (2D, only while inside)")]
		[SerializeField]
		private AudioSource ambience;

		[SerializeField]
		[Range(0f, 1f)]
		private float ambienceVolume = 0.35f;

		private Coroutine _transition;

		private Transform _transitionTarget;

		private bool _selfTeleport;

		private bool _overridden;

		private AudioSource _voice;

		private const float TeleportJump = 8f;

		private bool _entered;

		private Vector3 _lastHead;

		private float _insideUntil = -1f;

		private bool _fogApplied;

		private bool _prevFog;

		private Color _prevFogColor;

		private FogMode _prevFogMode;

		private float _prevFogDensity;

		public static BtmTechTreeRoom Instance { get; private set; }

		public bool IsTransitioning => _transition != null;

		public bool IsEntering
		{
			get
			{
				if (_transition != null)
				{
					return _transitionTarget == arrivalPoint;
				}
				return false;
			}
		}

		public bool LocalPlayerInside
		{
			get
			{
				if (_entered && Player.HasInstance)
				{
					return Contains(HeadPosition());
				}
				return false;
			}
		}

		public static bool LocalInTree { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
			if (ambience != null)
			{
				ambience.spatialize = false;
				ambience.spatialBlend = 0f;
				ambience.loop = true;
				ambience.volume = 0f;
			}
		}

		private void OnEnable()
		{
			Player.Teleported += HandleRigTeleported;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
				LocalInTree = false;
			}
		}

		public bool Contains(Vector3 worldPoint)
		{
			return localBounds.Contains(base.transform.InverseTransformPoint(worldPoint));
		}

		public void Enter()
		{
			if (_transition == null && !(arrivalPoint == null))
			{
				_transition = StartCoroutine(Teleport(arrivalPoint, enterClip));
			}
		}

		public void Exit()
		{
			if (_transition != null)
			{
				return;
			}
			Transform target = lobbyReturnPoint;
			if (target == null && BTMGameManager.Instance != null && BTMGameManager.Instance.roomSettings.spawnPoint != null)
			{
				target = BTMGameManager.Instance.roomSettings.spawnPoint.transform;
			}
			if (!(target == null))
			{
				_transition = StartCoroutine(Teleport(target, exitClip));
			}
		}

		private IEnumerator Teleport(Transform target, AudioClip clip)
		{
			_transitionTarget = target;
			_overridden = false;
			if (clip != null)
			{
				_voice.PlayOneShot(clip, transitionVolume);
			}
			BtmScreenFx fx = BtmScreenFx.Instance;
			float t;
			for (t = 0f; t < 1f; t += Time.deltaTime / fadeOut)
			{
				if (fx != null)
				{
					fx.SetFade(t);
				}
				yield return null;
			}
			if (fx != null)
			{
				fx.SetFade(1f);
			}
			if (Player.HasInstance && !_overridden)
			{
				_selfTeleport = true;
				try
				{
					Player.Instance.TeleportPlayerRaw(target.position, Quaternion.Euler(0f, target.eulerAngles.y, 0f), true, true);
				}
				finally
				{
					_selfTeleport = false;
				}
				_entered = target == arrivalPoint;
				_lastHead = HeadPosition();
			}
			yield return new WaitForSeconds(holdBlack);
			for (t = 1f; t > 0f; t -= Time.deltaTime / fadeIn)
			{
				if (fx != null)
				{
					fx.SetFade(t);
				}
				yield return null;
			}
			if (fx != null)
			{
				fx.SetFade(0f);
			}
			_transition = null;
			_transitionTarget = null;
		}

		private void HandleRigTeleported(Player player)
		{
			if (!_selfTeleport)
			{
				Vector3 vector = HeadPosition();
				if ((vector - _lastHead).sqrMagnitude > TeleportJump * TeleportJump || !Contains(vector))
				{
					_entered = false;
					_insideUntil = -1f;
					_lastHead = vector;
					if (_transition != null)
					{
						_overridden = true;
					}
				}
			}
		}

		private void Update()
		{
			if (!Player.HasInstance)
			{
				return;
			}
			Vector3 vector = HeadPosition();
			Vector3 point = base.transform.InverseTransformPoint(vector);
			if (_transition == null && (vector - _lastHead).sqrMagnitude > TeleportJump * TeleportJump)
			{
				_entered = false;
			}
			bool flag = _entered && localBounds.Contains(point);
			LocalInTree = flag || IsTransitioning;
			if (fogInside && _fogApplied != flag)
			{
				ApplyFog(flag);
			}
			if (ambience != null)
			{
				float target = (flag ? ambienceVolume : 0f);
				ambience.volume = Mathf.MoveTowards(ambience.volume, target, Time.deltaTime * 0.5f);
				if (ambience.volume > 0f && !ambience.isPlaying)
				{
					ambience.Play();
				}
				else if (ambience.volume <= 0f && ambience.isPlaying)
				{
					ambience.Stop();
				}
			}
			if (!_entered)
			{
				_insideUntil = -1f;
			}
			_lastHead = vector;
			if (flag)
			{
				_insideUntil = Time.time + fallMemory;
			}
			Vector3 center = localBounds.center;
			Vector3 extents = localBounds.extents;
			if (Time.time <= _insideUntil && Mathf.Abs(point.x - center.x) <= extents.x && Mathf.Abs(point.z - center.z) <= extents.z && point.y < voidHeight && _transition == null && arrivalPoint != null)
			{
				_insideUntil = -1f;
				_transition = StartCoroutine(Teleport(arrivalPoint, null));
			}
		}

		private void ApplyFog(bool on)
		{
			if (on)
			{
				_prevFog = RenderSettings.fog;
				_prevFogColor = RenderSettings.fogColor;
				_prevFogMode = RenderSettings.fogMode;
				_prevFogDensity = RenderSettings.fogDensity;
				RenderSettings.fog = true;
				RenderSettings.fogColor = fogColor;
				RenderSettings.fogMode = FogMode.ExponentialSquared;
				RenderSettings.fogDensity = fogDensity;
			}
			else
			{
				RenderSettings.fog = _prevFog;
				RenderSettings.fogColor = _prevFogColor;
				RenderSettings.fogMode = _prevFogMode;
				RenderSettings.fogDensity = _prevFogDensity;
			}
			_fogApplied = on;
		}

		private void OnDisable()
		{
			Player.Teleported -= HandleRigTeleported;
			if (_fogApplied)
			{
				ApplyFog(false);
			}
			LocalInTree = false;
			if (_transition != null)
			{
				_transition = null;
				_transitionTarget = null;
				if (BtmScreenFx.Instance != null)
				{
					BtmScreenFx.Instance.SetFade(0f);
				}
			}
		}

		private static Vector3 HeadPosition()
		{
			Player instance = Player.Instance;
			return ((instance.headCollider != null) ? instance.headCollider.transform : instance.transform).position;
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.matrix = base.transform.localToWorldMatrix;
			Gizmos.color = new Color(1f, 0.65f, 0.2f, 0.5f);
			Gizmos.DrawWireCube(localBounds.center, localBounds.size);
		}
	}
}
