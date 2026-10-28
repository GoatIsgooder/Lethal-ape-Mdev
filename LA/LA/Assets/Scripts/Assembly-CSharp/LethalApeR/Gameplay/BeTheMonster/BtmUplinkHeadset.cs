using System;
using System.Reflection;
using GorillaLocomotion;
using Photon.Pun;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Interaction.Toolkit.Interactors;
using UnityEngine.XR.Interaction.Toolkit.Transformers;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(Rigidbody), typeof(XRGrabInteractable))]
	public class BtmUplinkHeadset : XRBaseGrabTransformer
	{
		private enum State
		{
			Docked = 0,
			Held = 1,
			Free = 2,
			Seating = 3,
			Jacking = 4
		}

		[Header("Rig")]
		[SerializeField]
		private BtmTetherCable cable;

		[Tooltip("Where the cable meets the headset (child of the headset).")]
		[SerializeField]
		private Transform plug;

		[Tooltip("Resting pose on the hook.")]
		[SerializeField]
		private Transform cradle;

		[Tooltip("Colliders of the station itself; the headset passes through them.")]
		[SerializeField]
		private Transform station;

		[SerializeField]
		private Transform spool;

		[SerializeField]
		[Min(0.01f)]
		private float spoolRadius = 0.07f;

		[Header("Cable")]
		[SerializeField]
		[Min(0.1f)]
		private float dockLength = 0.6f;

		[SerializeField]
		[Min(0.3f)]
		private float maxLength = 2.1f;

		[Tooltip("How far past full length your hand can go before the headset rips out of it.")]
		[SerializeField]
		[Min(0.05f)]
		private float breakSlack = 0.4f;

		[SerializeField]
		[Range(1f, 1.5f)]
		private float slack = 1.12f;

		[SerializeField]
		[Min(0f)]
		private float reelDelay = 0.6f;

		[SerializeField]
		[Min(0.1f)]
		private float reelSpeed = 1.6f;

		[SerializeField]
		[Min(0.05f)]
		private float seatSeconds = 0.4f;

		[SerializeField]
		[Min(1f)]
		private float giveUpSeconds = 8f;

		[Header("Wearing")]
		[Tooltip("Headset centre within this distance of the eyes counts as 'put on'.")]
		[SerializeField]
		[Min(0.05f)]
		private float wearDistance = 0.2f;

		[Tooltip("Must also face roughly the same way as the eyes (dot of forwards).")]
		[SerializeField]
		[Range(-1f, 1f)]
		private float wearFacing = 0.3f;

		[SerializeField]
		[Min(0.02f)]
		private float jackSeconds = 0.14f;

		[Tooltip("Players in a live round (alive survivors, monsters) can't leave the map through this.")]
		[SerializeField]
		private bool blockDuringOwnRound = true;

		[Header("Look")]
		[SerializeField]
		private Renderer statusLamp;

		[SerializeField]
		private string lampColorProperty = "_EmissionColor";

		[SerializeField]
		private Color readyColor = new Color(1.6f, 1.248f, 0.48f, 1.6f);

		[SerializeField]
		private Color heldColor = new Color(2.2f, 1.98f, 1.32f, 2.2f);

		[SerializeField]
		private Color blockedColor = new Color(1.6f, 0.32f, 0.24f, 1.6f);

		[Header("Audio (2D, no spatializer)")]
		[SerializeField]
		private AudioClip grabClip;

		[SerializeField]
		private AudioClip dockClip;

		[SerializeField]
		private AudioClip snapClip;

		[SerializeField]
		private AudioClip deniedClip;

		[SerializeField]
		private AudioSource reelLoop;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.7f;

		private Rigidbody _rb;

		private XRGrabInteractable _grab;

		private Collider[] _colliders;

		private State _state;

		private Vector3 _plugLocal;

		private Vector3 _homePos;

		private Quaternion _homeRot;

		private float _reelLength;

		private float _freeSince;

		private float _seatT;

		private Vector3 _seatFromPos;

		private Quaternion _seatFromRot;

		private float _handOver;

		private InteractorHandedness _hand;

		private float _nextBuzz;

		private float _deniedUntil;

		private Player _ignoredFor;

		private float _nextIgnoreCheck;

		private float _spoolAngle;

		private float _lastSpoolLength;

		private MaterialPropertyBlock _mpb;

		private int _lampId;

		private AudioSource _voice;

		private readonly Vector3[] _trackPos = new Vector3[6];

		private readonly float[] _trackTime = new float[6];

		private int _trackCount;

		private bool _applyThrow;

		private Vector3 _throwVelocity;

		private Vector3 _jackFrom;

		private Quaternion _jackFromRot;

		private float _jackT;

		private bool _jackStarted;

		protected override RegistrationMode registrationMode => RegistrationMode.Single;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_grab = GetComponent<XRGrabInteractable>();
			_colliders = GetComponentsInChildren<Collider>(true);
			_mpb = new MaterialPropertyBlock();
			_lampId = Shader.PropertyToID(lampColorProperty);
			_plugLocal = ((plug != null) ? transform.InverseTransformPoint(plug.position) : Vector3.zero);
			_homePos = ((cradle != null) ? cradle : transform).position;
			_homeRot = ((cradle != null) ? cradle : transform).rotation;
			_voice = gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
			if (reelLoop != null)
			{
				reelLoop.loop = true;
				reelLoop.playOnAwake = false;
				reelLoop.spatialize = false;
				reelLoop.volume = 0f;
			}
			_grab.selectEntered.AddListener(OnGrabbed);
			_grab.selectExited.AddListener(OnReleased);
		}

		protected override void Start()
		{
			base.Start();
			if (station != null)
			{
				Collider[] componentsInChildren = station.GetComponentsInChildren<Collider>(true);
				foreach (Collider collider in componentsInChildren)
				{
					if (Array.IndexOf(_colliders, collider) < 0)
					{
						Collider[] colliders = _colliders;
						foreach (Collider collider2 in colliders)
						{
							Physics.IgnoreCollision(collider2, collider, true);
						}
					}
				}
			}
			Dock(true);
		}

		protected override void OnDestroy()
		{
			if (_grab != null)
			{
				_grab.selectEntered.RemoveListener(OnGrabbed);
				_grab.selectExited.RemoveListener(OnReleased);
			}
			base.OnDestroy();
		}

		public override void Process(XRGrabInteractable grabInteractable, XRInteractionUpdateOrder.UpdatePhase updatePhase, ref Pose targetPose, ref Vector3 localScale)
		{
			if (!(cable == null) && !(cable.Anchor == null))
			{
				Vector3 position = cable.Anchor.position;
				Vector3 vector = targetPose.position + targetPose.rotation * _plugLocal - position;
				float magnitude = vector.magnitude;
				_handOver = magnitude - maxLength;
				if (magnitude > maxLength)
				{
					targetPose.position -= vector / magnitude * _handOver;
				}
			}
		}

		private void OnGrabbed(SelectEnterEventArgs args)
		{
			if (_state != State.Jacking)
			{
				_state = State.Held;
				_hand = args.interactorObject.handedness;
				_handOver = 0f;
				_trackCount = 0;
				_applyThrow = false;
				Play(grabClip, 0.8f);
				Pulse(0.3f, 0.05f);
				if (cable != null)
				{
					cable.Wake();
				}
			}
		}

		private void OnReleased(SelectExitEventArgs args)
		{
			if (_state == State.Held && !_grab.isSelected)
			{
				_rb.isKinematic = false;
				_rb.useGravity = true;
				_throwVelocity = TrackedVelocity();
				_applyThrow = true;
				_state = State.Free;
				_freeSince = Time.time;
				_reelLength = ((cable != null) ? Mathf.Clamp(cable.Length, dockLength, maxLength) : dockLength);
			}
		}

		private void Update()
		{
			IgnorePlayerColliders();
			bool blocked = IsBlocked();
			UpdateLamp(blocked);
			switch (_state)
			{
			case State.Held:
				UpdateHeld(blocked);
				break;
			case State.Free:
				UpdateReelAudio((Time.time - _freeSince < reelDelay) ? 0f : 1f);
				break;
			case State.Seating:
				UpdateSeat();
				break;
			case State.Jacking:
				UpdateJack();
				break;
			default:
				UpdateReelAudio(0f);
				break;
			}
			UpdateSpool();
		}

		private void UpdateHeld(bool blocked)
		{
			Track();
			if (cable != null)
			{
				Vector3 position = cable.Anchor.position;
				Vector3 position2 = ((plug != null) ? plug : transform).position;
				cable.Length = Mathf.Clamp(Vector3.Distance(position, position2) * slack + 0.05f, dockLength, maxLength);
				cable.Pulse = 1f;
			}
			UpdateReelAudio(0.35f);
			if (_handOver > breakSlack)
			{
				Snap();
				return;
			}
			if (_handOver > 0f && Time.time >= _nextBuzz)
			{
				_nextBuzz = Time.time + 0.06f;
				Pulse(Mathf.Clamp01(_handOver / breakSlack) * 0.37f + 0.08f, 0.06f);
			}
			if (IsWorn())
			{
				if (blocked)
				{
					Deny();
				}
				else
				{
					Jack();
				}
			}
		}

		private void FixedUpdate()
		{
			if (_applyThrow && !_rb.isKinematic)
			{
				_applyThrow = false;
				_rb.linearVelocity = Vector3.ClampMagnitude(_throwVelocity, 8f);
			}
			if (_state != State.Free || cable == null)
			{
				return;
			}
			float fixedDeltaTime = Time.fixedDeltaTime;
			float num = Time.time - _freeSince;
			if (num >= reelDelay)
			{
				_reelLength = Mathf.MoveTowards(_reelLength, dockLength, reelSpeed * fixedDeltaTime);
			}
			cable.Length = _reelLength;
			cable.Pulse = Mathf.MoveTowards(cable.Pulse, 0f, fixedDeltaTime * 2f);
			Vector3 position = cable.Anchor.position;
			Vector3 vector = _rb.position + _rb.rotation * _plugLocal;
			Vector3 vector2 = vector - position;
			float magnitude = vector2.magnitude;
			if (magnitude > 0.0001f && magnitude > _reelLength)
			{
				Vector3 vector3 = vector2 / magnitude;
				_rb.position -= vector3 * (magnitude - _reelLength);
				float num2 = Vector3.Dot(_rb.GetPointVelocity(vector), vector3);
				if (num2 > 0f)
				{
					_rb.AddForceAtPosition(-vector3 * (num2 * _rb.mass), vector, ForceMode.Impulse);
				}
			}
			if ((_reelLength <= dockLength + 0.02f && magnitude <= dockLength + 0.1f) || num > giveUpSeconds || _rb.position.y < position.y - 6f)
			{
				BeginSeat();
			}
		}

		private void BeginSeat()
		{
			_state = State.Seating;
			_seatT = 0f;
			_seatFromPos = transform.position;
			_seatFromRot = transform.rotation;
			_rb.isKinematic = true;
		}

		private void UpdateSeat()
		{
			_seatT += Time.deltaTime / seatSeconds;
			float num = Mathf.SmoothStep(0f, 1f, _seatT);
			transform.SetPositionAndRotation(Vector3.Lerp(_seatFromPos, _homePos, num), Quaternion.Slerp(_seatFromRot, _homeRot, num));
			if (cable != null)
			{
				cable.Length = Mathf.Lerp(cable.Length, dockLength, num);
			}
			UpdateReelAudio(1f - num);
			if (_seatT >= 1f)
			{
				Dock(false);
			}
		}

		private void Dock(bool silent)
		{
			_state = State.Docked;
			if (!_grab.enabled)
			{
				_grab.enabled = true;
			}
			_rb.isKinematic = true;
			transform.SetPositionAndRotation(_homePos, _homeRot);
			if (cable != null)
			{
				cable.Length = dockLength;
				cable.Pulse = 0f;
				cable.ResetShape();
			}
			if (!silent)
			{
				Play(dockClip, 0.9f);
			}
		}

		private void Jack()
		{
			BtmTechTreeRoom instance = BtmTechTreeRoom.Instance;
			if (!(instance == null) && !instance.IsTransitioning)
			{
				_state = State.Jacking;
				ForceRelease();
				_grab.enabled = false;
				_rb.isKinematic = true;
				_jackFrom = transform.position;
				_jackFromRot = transform.rotation;
				_jackT = 0f;
				_jackStarted = false;
				if (VRInputController.Instance != null)
				{
					VRInputController.Instance.PulseLeft(0.5f, 0.12f);
					VRInputController.Instance.PulseRight(0.5f, 0.12f);
				}
				instance.Enter();
			}
		}

		private void UpdateJack()
		{
			_jackT += Time.deltaTime;
			Transform transform = HeadTransform();
			if (transform != null && _jackT <= jackSeconds)
			{
				float num = Mathf.SmoothStep(0f, 1f, _jackT / jackSeconds);
				Vector3 b = transform.position + transform.forward * 0.06f;
				base.transform.SetPositionAndRotation(Vector3.Lerp(_jackFrom, b, num), Quaternion.Slerp(_jackFromRot, transform.rotation, num));
			}
			BtmTechTreeRoom instance = BtmTechTreeRoom.Instance;
			if (instance != null && instance.IsTransitioning)
			{
				_jackStarted = true;
			}
			if ((_jackStarted && (instance == null || !instance.IsTransitioning)) || _jackT > 2f)
			{
				Dock(true);
			}
		}

		private void Deny()
		{
			if (!(Time.time < _deniedUntil))
			{
				_deniedUntil = Time.time + 1.2f;
				Play(deniedClip, 1f);
				Pulse(0.6f, 0.22f);
			}
		}

		private void Snap()
		{
			ForceRelease();
			Play(snapClip, 1f);
			Pulse(0.9f, 0.12f);
		}

		private void ForceRelease()
		{
			if (!_grab.isSelected)
			{
				return;
			}
			XRInteractionManager interactionManager = _grab.interactionManager;
			if (interactionManager == null)
			{
				return;
			}
			int num = _grab.interactorsSelecting.Count;
			while (num > 0)
			{
				num--;
				interactionManager.SelectExit(_grab.interactorsSelecting[num], (IXRSelectInteractable)_grab);
			}
		}

		private bool IsWorn()
		{
			Transform transform = HeadTransform();
			if (transform == null)
			{
				return false;
			}
			if ((base.transform.position - transform.position).sqrMagnitude > wearDistance * wearDistance)
			{
				return false;
			}
			return Vector3.Dot(base.transform.forward, transform.forward) >= wearFacing;
		}

		private static Transform HeadTransform()
		{
			if (!Player.HasInstance || !(Player.Instance.headCollider != null))
			{
				return null;
			}
			return Player.Instance.headCollider.transform;
		}

		private bool IsBlocked()
		{
			if (!blockDuringOwnRound)
			{
				return false;
			}
			BTMGameManager instance = BTMGameManager.Instance;
			if (instance == null || !instance.roomProperties.roundActive)
			{
				return false;
			}
			if (PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (Array.IndexOf(instance.roomProperties.currentMonsters ?? Array.Empty<int>(), actorNumber) >= 0)
			{
				return true;
			}
			return BTMGameManager.IsLocalSurvivor();
		}

		private void IgnorePlayerColliders()
		{
			if (!Player.HasInstance || Player.Instance == _ignoredFor || Time.time < _nextIgnoreCheck)
			{
				return;
			}
			_nextIgnoreCheck = Time.time + 1f;
			_ignoredFor = Player.Instance;
			Collider[] componentsInChildren = Player.Instance.GetComponentsInChildren<Collider>(true);
			foreach (Collider collider in componentsInChildren)
			{
				if (!collider.isTrigger)
				{
					Collider[] colliders = _colliders;
					foreach (Collider collider2 in colliders)
					{
						Physics.IgnoreCollision(collider2, collider, true);
					}
				}
			}
		}

		private void Track()
		{
			if (_trackCount == _trackPos.Length)
			{
				Array.Copy(_trackPos, 1, _trackPos, 0, _trackCount - 1);
				Array.Copy(_trackTime, 1, _trackTime, 0, _trackTime.Length - 1);
				_trackCount--;
			}
			_trackPos[_trackCount] = transform.position;
			_trackTime[_trackCount] = Time.time;
			_trackCount++;
		}

		private Vector3 TrackedVelocity()
		{
			int num = _trackCount - 1;
			if (num > 0)
			{
				float num2 = _trackTime[num] - _trackTime[0];
				if (num2 > 0.0001f)
				{
					return (_trackPos[num] - _trackPos[0]) / num2;
				}
			}
			return Vector3.zero;
		}

		private void UpdateLamp(bool blocked)
		{
			if (!(statusLamp == null))
			{
				Color value = (blocked ? blockedColor : ((_state != State.Held) ? readyColor : (heldColor * (Mathf.Sin(Time.time * 9f) * 0.2f + 0.8f))));
				statusLamp.GetPropertyBlock(_mpb);
				_mpb.SetColor(_lampId, value);
				statusLamp.SetPropertyBlock(_mpb);
			}
		}

		private void UpdateSpool()
		{
			if (!(spool == null) && !(cable == null))
			{
				float length = cable.Length;
				float num = length - _lastSpoolLength;
				_lastSpoolLength = length;
				_spoolAngle += num / spoolRadius * 57.29578f;
				spool.localRotation = Quaternion.Euler(_spoolAngle, 0f, 0f);
			}
		}

		private void UpdateReelAudio(float target)
		{
			if (reelLoop == null || reelLoop.clip == null)
			{
				return;
			}
			float num = 0f;
			if (cable != null)
			{
				num = Mathf.Abs(cable.Length - _lastSpoolLength) / Mathf.Max(Time.deltaTime, 0.0001f);
			}
			float target2 = Mathf.Clamp01(num / reelSpeed) * target * volume * 0.5f;
			reelLoop.volume = Mathf.MoveTowards(reelLoop.volume, target2, Time.deltaTime * 2f);
			reelLoop.pitch = 0.85f + Mathf.Clamp01(num / reelSpeed) * 0.4f;
			if (reelLoop.volume > 0.001f && !reelLoop.isPlaying)
			{
				reelLoop.Play();
			}
			else if (reelLoop.volume <= 0.001f && reelLoop.isPlaying)
			{
				reelLoop.Stop();
			}
		}

		private void Pulse(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				if (_hand == InteractorHandedness.Left)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		private void Play(AudioClip clip, float scale)
		{
			if (clip != null)
			{
				_voice.PlayOneShot(clip, volume * scale);
			}
		}
	}
}
