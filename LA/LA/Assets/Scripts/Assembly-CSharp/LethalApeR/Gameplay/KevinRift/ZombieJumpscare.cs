using System.Collections;
using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.SceneFlow;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class ZombieJumpscare : MonoBehaviour
	{
		private static readonly int JumpscareHash = Animator.StringToHash("Jumpscare");

		[Tooltip("The zombie model the victim sees (an Animator with a 'Jumpscare' state), spawned once and reused.")]
		public GameObject rigPrefab;

		public AudioClip scream;

		[Range(0f, 1f)]
		public float screamVolume = 1f;

		[Tooltip("How far in front of the eyes the rig's root sits (m); the clip itself lunges it in.")]
		public float distance = 0.75f;

		[Tooltip("How far below eye level the rig's root sits (m).")]
		public float drop = 0.55f;

		[Tooltip("Scream to black (s).")]
		public float holdFor = 1.15f;

		public float fadeOut = 0.2f;

		public float fadeIn = 0.45f;

		[Tooltip("How fast the zombie swings round to stay in front when the player turns (deg/s).")]
		public float followYawSpeed = 140f;

		private GameObject _rig;

		private Animator _animator;

		private AudioSource _audio;

		private Transform _head;

		private float _yaw;

		private bool _following;

		public bool Playing { get; private set; }

		public void Play(Vector3 zombiePosition)
		{
			if (!Playing)
			{
				StartCoroutine(Run(zombiePosition));
			}
		}

		private void OnEnable()
		{
			Application.onBeforeRender += Follow;
		}

		private void OnDisable()
		{
			Application.onBeforeRender -= Follow;
			if (Playing)
			{
				Finish();
			}
		}

		private IEnumerator Run(Vector3 zombiePosition)
		{
			Playing = true;
			_head = Head();
			if (_head == null)
			{
				Playing = false;
				yield break;
			}
			RigHold.Take(this, RigHold.What.Movement);
			Vector3 forward = Flat(_head.forward);
			Vector3 toZombie = Flat(zombiePosition - _head.position);
			if (toZombie.sqrMagnitude > 0.0001f && Vector3.Angle(forward, toZombie) < 70f)
			{
				forward = toZombie.normalized;
			}
			_yaw = Quaternion.LookRotation(forward).eulerAngles.y;
			EnsureRig();
			if (_rig != null)
			{
				_following = true;
				Follow();
				_rig.SetActive(true);
				if (_animator != null)
				{
					_animator.Play(JumpscareHash, 0, 0f);
					_animator.Update(0f);
				}
			}
			if (_audio != null && scream != null)
			{
				_audio.PlayOneShot(scream, screamVolume);
			}
			Buzz(1f, 0.25f);
			float t = 0f;
			bool second = false;
			while (t < holdFor)
			{
				t += Time.unscaledDeltaTime;
				if (t > 0.35f && !second)
				{
					second = true;
					Buzz(0.7f, 0.18f);
				}
				yield return null;
			}
			SceneFadeOverlay fade = SceneFadeOverlay.Ensure();
			yield return fade.FadeTo(1f, fadeOut);
			_following = false;
			if (_rig != null)
			{
				_rig.SetActive(false);
			}
			RigHold.Give(this, RigHold.What.All);
			Player player = Player.HasInstance ? Player.Instance : null;
			if (player != null)
			{
				player.JumpscareTeleport(player.transform.position, 0f);
			}
			yield return null;
			yield return fade.FadeTo(0f, fadeIn);
			Playing = false;
		}

		private void Finish()
		{
			_following = false;
			if (_rig != null)
			{
				_rig.SetActive(false);
			}
			RigHold.Give(this, RigHold.What.All);
			if (SceneFadeOverlay.Current != null)
			{
				SceneFadeOverlay.Current.Alpha = 0f;
			}
			Playing = false;
		}

		private void LateUpdate()
		{
			Follow();
		}

		private void Follow()
		{
			if (_following && !(_rig == null) && !(_head == null))
			{
				float target = Quaternion.LookRotation(Flat(_head.forward)).eulerAngles.y;
				_yaw = Mathf.MoveTowardsAngle(_yaw, target, followYawSpeed * Time.unscaledDeltaTime);
				Quaternion rotation = Quaternion.Euler(0f, _yaw, 0f);
				_rig.transform.SetPositionAndRotation(_head.position + rotation * Vector3.forward * distance + Vector3.down * drop, rotation * Quaternion.Euler(0f, 180f, 0f));
			}
		}

		private void EnsureRig()
		{
			if (_rig == null && rigPrefab != null)
			{
				_rig = Instantiate(rigPrefab);
				_rig.name = "Rift Zombie Jumpscare";
				_rig.SetActive(false);
				_animator = _rig.GetComponentInChildren<Animator>(true);
				if (_animator != null)
				{
					_animator.cullingMode = AnimatorCullingMode.AlwaysAnimate;
				}
				DontDestroyOnLoad(_rig);
			}
			if (_audio == null)
			{
				_audio = gameObject.AddComponent<AudioSource>();
				_audio.playOnAwake = false;
				_audio.spatialBlend = 0f;
				_audio.spatialize = false;
				_audio.bypassReverbZones = true;
				_audio.priority = 0;
			}
		}

		private static Transform Head()
		{
			if (Player.HasInstance && Player.Instance.mainCamera != null)
			{
				return Player.Instance.mainCamera.transform;
			}
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform;
			}
			return null;
		}

		private static Vector3 Flat(Vector3 v)
		{
			if (v.x * v.x + v.z * v.z <= 1E-06f)
			{
				return Vector3.forward;
			}
			return new Vector3(v.x, 0f, v.z).normalized;
		}

		private static void Buzz(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				instance.PulseLeft(amplitude, duration);
				instance.PulseRight(amplitude, duration);
			}
		}

		private void OnDestroy()
		{
			if (_rig != null)
			{
				Destroy(_rig);
			}
		}
	}
}
