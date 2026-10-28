using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.Monsters
{
	public class WeepingAngelMonster : BaseMonster
	{
		[Header("Quantum Lock — Detection")]
		[Tooltip("Point on the angel the gaze test aims at. Chest or head reads better than the pivot at its feet. Falls back to this transform.")]
		[SerializeField]
		private Transform aimPoint;

		[Tooltip("Beyond this the angel ignores you entirely and moves freely.")]
		[SerializeField]
		private float detectionRadius = 25f;

		[Tooltip("HALF-angle from the centre of your view. 30 means the angel must be within 30 degrees of where you are actually looking.")]
		[SerializeField]
		[Range(1f, 90f)]
		private float viewHalfAngle = 30f;

		[Tooltip("Geometry that blocks the stare. Set this to walls/environment ONLY — if it includes the angel's own layer the angel blocks itself and never freezes.")]
		[SerializeField]
		private LayerMask obstacleMask;

		[Tooltip("Losing the angel for less than this doesn't count as looking away. Covers tracking jitter and someone walking between you for a frame.")]
		[SerializeField]
		private float lookAwayGrace = 0.35f;

		[Header("Quantum Lock — Break Free")]
		[Tooltip("Seconds of continuous staring before it breaks the lock and charges you.")]
		[SerializeField]
		private float stareToBreakFree = 5f;

		[Tooltip("Seconds it hunts for after breaking free. Looking at it does NOTHING during this window — that is the whole threat.")]
		[SerializeField]
		private float brokenFreeChaseDuration = 20f;

		[Tooltip("How fast the stare timer bleeds off once you look away, as a multiple of real time. 1 = unwinds as slowly as it wound up, 3 = drains three times faster.")]
		[SerializeField]
		[Range(0.1f, 10f)]
		private float stareDecayRate = 2f;

		[Header("Haptics — the countdown")]
		[Tooltip("Pulse both controllers while you stare, speeding up as it fills.")]
		[SerializeField]
		private bool hapticCountdown = true;

		[Tooltip("Seconds between pulses at the START of the stare.")]
		[SerializeField]
		private float hapticSlowInterval = 0.55f;

		[Tooltip("Seconds between pulses just before it breaks free.")]
		[SerializeField]
		private float hapticFastInterval = 0.07f;

		[SerializeField]
		[Range(0f, 1f)]
		private float hapticMinAmplitude = 0.15f;

		[SerializeField]
		[Range(0f, 1f)]
		private float hapticMaxAmplitude = 0.85f;

		[SerializeField]
		private float hapticPulseDuration = 0.05f;

		[Tooltip("One heavy jolt the moment it breaks free.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float hapticBreakAmplitude = 1f;

		[SerializeField]
		private float hapticBreakDuration = 0.35f;

		[Header("Audio")]
		[Tooltip("One-shots: look-at sting, freeze, unfreeze, break-free. Meta XR Audio is the project spatialiser — leave Spatialize OFF unless you want it silent in the Editor.")]
		[SerializeField]
		private AudioSource angelAudio;

		[Tooltip("Played on the local client the instant your gaze lands on the angel.")]
		[SerializeField]
		private AudioClip lookAtClip;

		[SerializeField]
		private AudioClip freezeClip;

		[SerializeField]
		private AudioClip unfreezeClip;

		[Tooltip("Played on EVERY client when the lock breaks — it should be audible to the whole lobby, not just the victim.")]
		[SerializeField]
		private AudioClip breakFreeClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float oneShotVolume = 1f;

		[Tooltip("Optional looping tension bed. Volume and pitch ramp with the countdown on the staring client only. Leave empty to skip.")]
		[SerializeField]
		private AudioSource stareLoopSource;

		[SerializeField]
		private float stareLoopMaxVolume = 0.8f;

		[SerializeField]
		private float stareLoopStartPitch = 0.85f;

		[SerializeField]
		private float stareLoopEndPitch = 1.6f;

		[Header("Visuals")]
		[SerializeField]
		private SkinnedMeshRenderer angelMesh;

		[SerializeField]
		private int freezeBlendShapeIndex;

		[Tooltip("Blend-shape weight per second. 200 = snaps in half a second.")]
		[SerializeField]
		private float blendShapeSpeed = 300f;

		[Tooltip("Enabled only while the angel is quantum-locked. Optional.")]
		[SerializeField]
		private GameObject[] frozenOnlyObjects;

		[Tooltip("Enabled only while it has broken free and is hunting. Optional.")]
		[SerializeField]
		private GameObject[] brokenFreeOnlyObjects;

		private const float FreezeReArmDuration = 0.25f;

		private const int OfflineActor = -2;

		private readonly HashSet<int> _watchers = new HashSet<int>();

		private float _immuneUntil;

		private int _brokenFreeVictim = -1;

		private bool _netFrozen;

		private bool _netImmune;

		private bool _localWatching;

		private bool _reportedWatching;

		private float _lastLookedAtTime = float.NegativeInfinity;

		private float _localStare;

		private float _nextHapticTime;

		private bool _breakRequested;

		private float _blendWeight;

		private bool _visualsFrozen;

		private bool _visualsApplied;

		private bool _brokenVisualsActive;

		private bool _brokenVisualsApplied;

		private bool IsAuthority => PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom;

		private static int LocalActor => (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : OfflineActor;

		public bool IsQuantumLocked => _netFrozen || (_localWatching && !IsImmune);

		public bool IsImmune => _netImmune || Time.time < _immuneUntil;

		public float StareProgress => (stareToBreakFree > 0.0001f) ? Mathf.Clamp01(_localStare / stareToBreakFree) : 0f;

		private void Awake()
		{
			if (angelAudio == null)
			{
				angelAudio = GetComponent<AudioSource>();
			}
			if (IsBlendShapeValid())
			{
				angelMesh.SetBlendShapeWeight(freezeBlendShapeIndex, 0f);
			}
			if (stareLoopSource != null)
			{
				stareLoopSource.loop = true;
				stareLoopSource.volume = 0f;
			}
		}

		private void LateUpdate()
		{
			TickImmunity();
			TickLocalGaze();
			TickMasterLock();
			TickStareFeedback();
			TickVisuals();
		}

		protected override void UpdateDetection()
		{
		}

		private void TickLocalGaze()
		{
			bool watching;
			if (!IsImmune && IsLocalPlayerLooking())
			{
				_lastLookedAtTime = Time.time;
				watching = true;
			}
			else
			{
				watching = _localWatching && Time.time - _lastLookedAtTime < lookAwayGrace;
			}
			if (watching != _localWatching)
			{
				_localWatching = watching;
				if (watching)
				{
					PlayOneShot(lookAtClip);
				}
				ReportWatching(watching);
			}
			if (IsImmune)
			{
				_localStare = 0f;
				return;
			}
			float deltaTime = Time.deltaTime;
			if (watching)
			{
				_localStare += deltaTime;
				if (!_breakRequested && stareToBreakFree > 0f && _localStare >= stareToBreakFree)
				{
					_breakRequested = true;
					RequestBreakFree();
				}
			}
			else
			{
				_localStare = Mathf.Max(0f, _localStare - deltaTime * stareDecayRate);
				if (_localStare <= 0f)
				{
					_breakRequested = false;
				}
			}
		}

		private bool IsLocalPlayerLooking()
		{
			Camera camera = ((GorillaLocomotion.Player.Instance != null) ? GorillaLocomotion.Player.Instance.mainCamera : Camera.main);
			if (camera == null)
			{
				return false;
			}
			Transform target = ((aimPoint != null) ? aimPoint : transform);
			Vector3 origin = camera.transform.position;
			Vector3 toTarget = target.position - origin;
			float distance = toTarget.magnitude;
			if (distance < 0.0001f || distance > detectionRadius)
			{
				return false;
			}
			Vector3 direction = toTarget / distance;
			if (Vector3.Angle(camera.transform.forward, direction) > viewHalfAngle)
			{
				return false;
			}
			if (obstacleMask.value != 0)
			{
				RaycastHit[] hits = Physics.RaycastAll(origin, direction, distance, obstacleMask, QueryTriggerInteraction.Ignore);
				for (int i = 0; i < hits.Length; i++)
				{
					Transform hitTransform = hits[i].transform;
					if (!(hitTransform == null) && !hitTransform.IsChildOf(transform))
					{
						return false;
					}
				}
			}
			return true;
		}

		private void ReportWatching(bool watching)
		{
			_reportedWatching = watching;
			if (IsAuthority)
			{
				ApplyWatcher(LocalActor, watching);
			}
			else if (!(photonView == null) && photonView.ViewID != 0)
			{
				photonView.RPC("RPC_SetWatching", RpcTarget.MasterClient, watching);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_SetWatching(bool watching, PhotonMessageInfo info)
		{
			if (IsAuthority)
			{
				ApplyWatcher((info.Sender != null) ? info.Sender.ActorNumber : (-1), watching);
			}
		}

		private void ApplyWatcher(int actor, bool watching)
		{
			if (actor != -1)
			{
				if (watching)
				{
					_watchers.Add(actor);
				}
				else
				{
					_watchers.Remove(actor);
				}
			}
		}

		private void RequestBreakFree()
		{
			if (IsAuthority)
			{
				MasterBreakFree(LocalActor);
			}
			else if (!(photonView == null) && photonView.ViewID != 0)
			{
				photonView.RPC("RPC_RequestBreakFree", RpcTarget.MasterClient);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_RequestBreakFree(PhotonMessageInfo info)
		{
			if (IsAuthority)
			{
				MasterBreakFree((info.Sender != null) ? info.Sender.ActorNumber : (-1));
			}
		}

		private void MasterBreakFree(int victimActor)
		{
			if (!IsAuthority)
			{
				return;
			}
			float time = Time.time;
			if (victimActor == -1 || time < _immuneUntil)
			{
				return;
			}
			_brokenFreeVictim = victimActor;
			_immuneUntil = Time.time + brokenFreeChaseDuration;
			Transform victim = ResolveVictimTransform(victimActor);
			if (victim != null)
			{
				ForceTarget(victim, brokenFreeChaseDuration);
			}
			if (photonView != null && photonView.ViewID != 0 && PhotonNetwork.InRoom)
			{
				photonView.RPC("RPC_BrokeFree", RpcTarget.All, victimActor);
			}
			else
			{
				OnBrokeFreeLocal(victimActor);
			}
		}

		private void TickMasterLock()
		{
			if (!IsAuthority)
			{
				return;
			}
			if (_watchers.Count > 0)
			{
				_netFrozen = Time.time >= _immuneUntil;
				_netImmune = Time.time < _immuneUntil;
				if (_netFrozen)
				{
					Freeze(FreezeReArmDuration);
				}
			}
			else
			{
				_netFrozen = false;
				_netImmune = Time.time < _immuneUntil;
			}
		}

		private void TickImmunity()
		{
			if (IsAuthority && _brokenFreeVictim != -1 && !(Time.time < _immuneUntil))
			{
				_brokenFreeVictim = -1;
				ClearForcedTarget();
			}
		}

		private static Transform ResolveVictimTransform(int actor)
		{
			IReadOnlyList<Transform> targets = ChaseTargetRegistry.Targets;
			for (int i = 0; i < targets.Count; i++)
			{
				Transform target = targets[i];
				if (target != null && BaseMonster.ResolveActorNumberFromTransform(target) == actor)
				{
					return target;
				}
			}
			if (MonkeDevNetworkingManager.Manager != null)
			{
				List<MonkeDevNetworkingPlayer> players = MonkeDevNetworkingManager.Manager.Players;
				if (players != null)
				{
					for (int j = 0; j < players.Count; j++)
					{
						MonkeDevNetworkingPlayer player = players[j];
						if (!(player == null) && !(player.Head == null) && !(player.photonView == null) && player.photonView.OwnerActorNr == actor)
						{
							return player.Head;
						}
					}
				}
			}
			if (actor == LocalActor && GorillaLocomotion.Player.Instance != null)
			{
				Camera mainCamera = GorillaLocomotion.Player.Instance.mainCamera;
				if (mainCamera != null)
				{
					return mainCamera.transform;
				}
			}
			return null;
		}

		protected override void WriteExtraSync(PhotonStream stream)
		{
			stream.SendNext(_netFrozen);
			stream.SendNext(_netImmune);
		}

		protected override void ReadExtraSync(PhotonStream stream)
		{
			_netFrozen = (bool)stream.ReceiveNext();
			_netImmune = (bool)stream.ReceiveNext();
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			base.OnMasterClientSwitched(newMasterClient);
			_watchers.Clear();
			if (IsAuthority)
			{
				if (_reportedWatching)
				{
					ApplyWatcher(LocalActor, watching: true);
				}
			}
			else if (_reportedWatching)
			{
				ReportWatching(watching: true);
			}
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (IsAuthority && otherPlayer != null)
			{
				_watchers.Remove(otherPlayer.ActorNumber);
				if (_brokenFreeVictim == otherPlayer.ActorNumber)
				{
					_immuneUntil = 0f;
					_brokenFreeVictim = -1;
					ClearForcedTarget();
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_BrokeFree(int victimActor)
		{
			OnBrokeFreeLocal(victimActor);
		}

		private void OnBrokeFreeLocal(int victimActor)
		{
			_netImmune = true;
			_localStare = 0f;
			_breakRequested = false;
			PlayOneShot(breakFreeClip);
			StopStareLoop();
			if (LocalActor == victimActor)
			{
				PulseBoth(hapticBreakAmplitude, hapticBreakDuration);
			}
		}

		private void TickStareFeedback()
		{
			if (!_localWatching || IsImmune || stareToBreakFree <= 0f)
			{
				StopStareLoop();
				return;
			}
			float stareProgress = StareProgress;
			if (stareLoopSource != null)
			{
				if (!stareLoopSource.isPlaying)
				{
					stareLoopSource.Play();
				}
				stareLoopSource.volume = stareProgress * stareLoopMaxVolume;
				stareLoopSource.pitch = Mathf.Lerp(stareLoopStartPitch, stareLoopEndPitch, stareProgress);
			}
			if (hapticCountdown && !(Time.time < _nextHapticTime))
			{
				_nextHapticTime = Time.time + Mathf.Max(0.02f, Mathf.Lerp(hapticSlowInterval, hapticFastInterval, stareProgress));
				PulseBoth(Mathf.Lerp(hapticMinAmplitude, hapticMaxAmplitude, stareProgress), hapticPulseDuration);
			}
		}

		private void StopStareLoop()
		{
			if (!(stareLoopSource == null) && stareLoopSource.isPlaying)
			{
				stareLoopSource.Stop();
				stareLoopSource.volume = 0f;
			}
		}

		private void TickVisuals()
		{
			bool isQuantumLocked = IsQuantumLocked;
			if (!_visualsApplied || _visualsFrozen != isQuantumLocked)
			{
				if (_visualsApplied)
				{
					PlayOneShot(isQuantumLocked ? freezeClip : unfreezeClip);
				}
				_visualsFrozen = isQuantumLocked;
				_visualsApplied = true;
				if (frozenOnlyObjects != null)
				{
					for (int i = 0; i < frozenOnlyObjects.Length; i++)
					{
						if (frozenOnlyObjects[i] != null)
						{
							frozenOnlyObjects[i].SetActive(isQuantumLocked);
						}
					}
				}
			}
			bool isImmune = IsImmune;
			if (!_brokenVisualsApplied || _brokenVisualsActive != isImmune)
			{
				_brokenVisualsActive = isImmune;
				_brokenVisualsApplied = true;
				if (brokenFreeOnlyObjects != null)
				{
					for (int j = 0; j < brokenFreeOnlyObjects.Length; j++)
					{
						if (brokenFreeOnlyObjects[j] != null)
						{
							brokenFreeOnlyObjects[j].SetActive(isImmune);
						}
					}
				}
			}
			if (IsBlendShapeValid())
			{
				float target = (isQuantumLocked ? 100f : 0f);
				if (!Mathf.Approximately(_blendWeight, target))
				{
					_blendWeight = Mathf.MoveTowards(_blendWeight, target, blendShapeSpeed * Time.deltaTime);
					angelMesh.SetBlendShapeWeight(freezeBlendShapeIndex, _blendWeight);
				}
			}
		}

		private void PlayOneShot(AudioClip clip)
		{
			if (!(angelAudio == null) && !(clip == null))
			{
				angelAudio.PlayOneShot(clip, oneShotVolume);
			}
		}

		private bool IsBlendShapeValid()
		{
			if (angelMesh != null && angelMesh.sharedMesh != null && freezeBlendShapeIndex >= 0)
			{
				return freezeBlendShapeIndex < angelMesh.sharedMesh.blendShapeCount;
			}
			return false;
		}

		private static void PulseBoth(float amplitude, float duration)
		{
			amplitude = Mathf.Clamp01(amplitude);
			duration = Mathf.Max(0f, duration);
			if (!(amplitude <= 0f) && !(duration <= 0f))
			{
				VRInputController instance = VRInputController.Instance;
				if (instance != null)
				{
					instance.PulseLeft(amplitude, duration);
					instance.PulseRight(amplitude, duration);
				}
				else
				{
					PulseNode(XRNode.LeftHand, amplitude, duration);
					PulseNode(XRNode.RightHand, amplitude, duration);
				}
			}
		}

		private static void PulseNode(XRNode node, float amplitude, float duration)
		{
			InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(node);
			if (deviceAtXRNode.isValid && deviceAtXRNode.TryGetHapticCapabilities(out var capabilities) && capabilities.supportsImpulse)
			{
				deviceAtXRNode.SendHapticImpulse(0u, amplitude, duration);
			}
		}
	}
}
