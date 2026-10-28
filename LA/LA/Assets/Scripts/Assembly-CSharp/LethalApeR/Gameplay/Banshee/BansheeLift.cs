using System;
using GorillaLocomotion;
using LALocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	[DefaultExecutionOrder(90)]
	public sealed class BansheeLift : MonoBehaviour
	{
		[NonSerialized]
		public BansheeDirector director;

		public BansheeGhost ghost;

		public BansheeVignette vignette;

		public AudioClip scream;

		[Range(0f, 1f)]
		public float screamVolume = 1f;

		[Tooltip("Lift speed once it's going (m/s).")]
		public float liftSpeed = 1.2f;

		[Tooltip("Ease in and out of the lift (s).")]
		public float easeTime = 0.45f;

		[Tooltip("Stop this far below anything overhead (m).")]
		public float ceilingClearance = 1f;

		[Tooltip("How far in front of the eyes her face sits during the jumpscare (m).")]
		public float faceDistance = 0.3f;

		[Tooltip("How far her face sits in front of her head bone (m). Her look-at turns the face to the eyes, so the bone goes this much further out along the gaze.")]
		public float faceFromHead = 0.16f;

		[Range(0f, 1f)]
		public float vignetteStrength = 0.6f;

		private float _startedAt;

		private bool _held;

		private bool _ownTeleport;

		private AudioSource _audio;

		public bool Active { get; private set; }

		public void Begin()
		{
			if (!Active)
			{
				Active = true;
				_startedAt = Time.time;
				Hold();
				EnsureAudio();
				if (_audio != null && scream != null)
				{
					_audio.PlayOneShot(scream, screamVolume);
				}
				Buzz(1f, 0.3f);
			}
		}

		public void Release()
		{
			End(stopInPlace: true);
		}

		public void Abort()
		{
			End(stopInPlace: false);
		}

		private void End(bool stopInPlace)
		{
			if (Active)
			{
				Active = false;
				if (ghost != null)
				{
					ghost.overridePose = false;
				}
				if (vignette != null)
				{
					vignette.Amount = 0f;
				}
				Unhold(stopInPlace);
			}
		}

		private void OnDisable()
		{
			End(stopInPlace: false);
		}

		private void Hold()
		{
			if (!_held)
			{
				TeleportInPlace();
				RigHold.Take(this, RigHold.What.All);
				_held = true;
				Player.Teleported -= OnTeleported;
				Player.Teleported += OnTeleported;
			}
		}

		private void Unhold(bool stopInPlace)
		{
			if (_held)
			{
				_held = false;
				Player.Teleported -= OnTeleported;
				RigHold.Give(this);
				if (stopInPlace)
				{
					TeleportInPlace();
				}
			}
		}

		private void TeleportInPlace()
		{
			_ownTeleport = true;
			try
			{
				LAPlayer instance = LAPlayer.Instance;
				if (instance != null && instance.isActiveAndEnabled)
				{
					instance.TeleportPlayerRaw(instance.transform.position, instance.transform.rotation);
				}
				else if (Player.HasInstance)
				{
					Player instance2 = Player.Instance;
					instance2.TeleportPlayerRaw(instance2.transform.position, instance2.transform.rotation);
				}
			}
			finally
			{
				_ownTeleport = false;
			}
		}

		private void OnTeleported(Player rig)
		{
			if (!_ownTeleport && _held)
			{
				Unhold(stopInPlace: false);
				Active = false;
				if (ghost != null)
				{
					ghost.overridePose = false;
				}
				if (vignette != null)
				{
					vignette.Amount = 0f;
				}
			}
		}

		private void FixedUpdate()
		{
			if (_held)
			{
				Rigidbody rigidbody = Body();
				if (rigidbody != null && !rigidbody.isKinematic)
				{
					rigidbody.linearVelocity = Vector3.zero;
				}
			}
		}

		private static Rigidbody Body()
		{
			LAPlayer instance = LAPlayer.Instance;
			if (instance != null && instance.isActiveAndEnabled)
			{
				return instance.Body;
			}
			if (!Player.HasInstance)
			{
				return null;
			}
			return Player.Instance.playerRigidBody;
		}

		private static void MoveRig(Vector3 step)
		{
			LAPlayer instance = LAPlayer.Instance;
			if (instance != null && instance.isActiveAndEnabled)
			{
				instance.MoveBy(step);
				instance.AcceptExternalHeadPosition();
			}
			else if (Player.HasInstance)
			{
				Player instance2 = Player.Instance;
				Vector3 position = step + instance2.transform.position;
				instance2.transform.position = position;
				if (instance2.playerRigidBody != null)
				{
					instance2.playerRigidBody.position = position;
				}
				instance2.AcceptExternalHeadPosition();
			}
		}

		private void LateUpdate()
		{
			if (!Active)
			{
				return;
			}
			float t = Time.time - _startedAt;
			if (t > 8.95f)
			{
				End(stopInPlace: true);
				return;
			}
			Transform eyes = BansheePlayers.LocalEyes();
			if (t < BansheeTimings.JumpscareFor)
			{
				if (ghost != null && eyes != null)
				{
					Vector3 forward = eyes.forward;
					Vector3 flat = new Vector3(forward.x, 0f, forward.z);
					flat = ((flat.sqrMagnitude > 0.0001f) ? flat.normalized : Vector3.forward);
					ghost.overridePose = true;
					ghost.overrideHead = eyes.position + forward * (faceDistance + faceFromHead);
					ghost.overrideFacing = Quaternion.LookRotation(-flat, Vector3.up);
				}
				if (vignette != null)
				{
					vignette.Amount = 0f;
				}
				return;
			}
			if (ghost != null)
			{
				ghost.overridePose = false;
			}
			float lift = t - BansheeTimings.JumpscareFor;
			float speed = ((lift < BansheeTimings.LiftFor) ? (liftSpeed * Ease(lift / easeTime) * Ease((BansheeTimings.LiftFor - lift) / easeTime)) : 0f);
			float step = speed * Time.deltaTime;
			if (step > 0f && BansheePlayers.TryGetLocalHead(out var head))
			{
				if (Physics.SphereCast(head, 0.2f, Vector3.up, out var hitInfo, step + ceilingClearance, -1, QueryTriggerInteraction.Ignore))
				{
					step = Mathf.Max(0f, hitInfo.distance - ceilingClearance);
				}
				if (step > 0f)
				{
					MoveRig(Vector3.up * step);
				}
			}
			if (vignette != null)
			{
				vignette.Amount = Mathf.Clamp01(lift * 2f) * Mathf.Clamp01((6.3f - lift) * 2f) * vignetteStrength;
			}
		}

		private static float Ease(float x)
		{
			x = Mathf.Clamp01(x);
			return x * x * (3f - 2f * x);
		}

		private void EnsureAudio()
		{
			if (!(_audio != null))
			{
				_audio = base.gameObject.AddComponent<AudioSource>();
				_audio.playOnAwake = false;
				_audio.spatialBlend = 0f;
				_audio.spatialize = false;
				_audio.bypassReverbZones = true;
				_audio.priority = 0;
			}
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
	}
}
