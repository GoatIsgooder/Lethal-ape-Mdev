using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Cosmetics
{
	public class VerityCompanion : MonoBehaviour
	{
		[Serializable]
		public struct VoiceLine
		{
			public float start;

			public float end;
		}

		private enum State
		{
			Grounded = 0,
			Hopping = 1,
			Flying = 2
		}

		private const float MeshRadius = 1f;

		[Header("Wiring")]
		public Transform orb;

		[Tooltip("The pet's renderer. A SkinnedMeshRenderer with a 'Flat' blend shape gets true squash; anything else gets the scale fallback.")]
		public Renderer body;

		public AudioSource voice;

		public AudioClip voiceClip;

		public VoiceLine[] lines = new VoiceLine[4]
		{
			new VoiceLine
			{
				start = 0.15f,
				end = 3.95f
			},
			new VoiceLine
			{
				start = 4.62f,
				end = 7f
			},
			new VoiceLine
			{
				start = 8.5f,
				end = 11.85f
			},
			new VoiceLine
			{
				start = 12.76f,
				end = 15.4f
			}
		};

		public int greetingLine;

		[Header("Ground")]
		[Tooltip("When on, groundMask is replaced by GorillaLocomotion.Player.locomotionEnabledLayers on enable.")]
		public bool useLocomotionLayers = true;

		public LayerMask groundMask = 1;

		public float ringRadius = 0.45f;

		public Vector3 groundOffset = new Vector3(0.35f, 0f, 0.3f);

		public Vector3 hoverOffset = new Vector3(0.27f, -0.1f, 0.25f);

		public float groundProbe = 3f;

		[Header("Hopping")]
		public float hopDistance = 0.4f;

		public float settleDistance = 0.12f;

		public float maxHopLength = 0.8f;

		public float hopHeight = 0.14f;

		public float hopTime = 0.28f;

		public Vector2 idleHopDelay = new Vector2(2.5f, 6f);

		[Header("Flying")]
		public float flyDistance = 3f;

		public float landDistance = 0.9f;

		public float flyHeight = 0.8f;

		public float flyFrequency = 1.4f;

		public float flyDamping = 0.8f;

		public float teleportDistance = 20f;

		public float lostGroundTime = 1.5f;

		[Header("Squash & Stretch")]
		public float squashFrequency = 5f;

		public float squashDamping = 0.22f;

		public float stretchPerSpeed = 25f;

		public float maxStretch = 110f;

		public float maxSquash = 75f;

		public float hopKick = 900f;

		public float landKick = 1800f;

		public float talkStretch = 260f;

		public float wearerVoiceStretch = 60f;

		public float leanPerSpeed = 18f;

		public float maxLean = 30f;

		[Header("Look")]
		public float lookRadius = 2.5f;

		public float turnSpeed = 6f;

		[Header("Pokes")]
		public float pokeRadius = 0.06f;

		public float pokeHop = 0.35f;

		public float pokeImpulse = 1.6f;

		public float pokeLineCooldown = 2.5f;

		[Header("Gaze")]
		public float gazeSeconds = 1f;

		public float gazeAngle = 10f;

		public float gazeDistance = 6f;

		public float gazeCooldown = 8f;

		[Header("Chatter")]
		public float chatterInterval = 40f;

		public int chatterOdds = 3;

		private readonly float[] _samples = new float[64];

		private readonly Transform[] _handsInside = new Transform[8];

		private int _handsInsideCount;

		private MonkeDevNetworkingPlayer _player;

		private JawMaster67[] _jaws = Array.Empty<JawMaster67>();

		private SkinnedMeshRenderer _skinned;

		private Transform _anchor;

		private int _flatIndex = -1;

		private State _state;

		private Vector3 _pos;

		private Vector3 _prevPos;

		private Vector3 _vel;

		private Vector3 _flyVel;

		private Vector3 _hopFrom;

		private Vector3 _hopTo;

		private float _hopT;

		private float _hopDuration;

		private float _hopArc;

		private float _nextIdleHop;

		private Vector3 _home;

		private bool _hasGround;

		private bool _hasPose;

		private bool _wasHidden;

		private float _nextProbe;

		private float _noGroundTime;

		private float _weight;

		private float _weightVel;

		private float _appliedWeight = float.NaN;

		private float _scale;

		private float _scaleVel;

		private Quaternion _look = Quaternion.identity;

		private Quaternion _lastYaw = Quaternion.identity;

		private Transform _lookAt;

		private Transform _faceTarget;

		private float _faceUntil;

		private float _nextLookScan;

		private float _glancePhase;

		private float _gazeTime;

		private float _nextGazeLine;

		private bool _gazeFired;

		private float _wearerVoice;

		private float _talk;

		private float _lineEnd;

		private float _greetAt;

		private float _nextPokeLine;

		private int _lastLine = -1;

		private long _chatterSlot = long.MinValue;

		private bool IsLocalWearer => _player && _player.photonView && _player.photonView.IsMine;

		private int OwnerActor
		{
			get
			{
				if (!_player || !_player.photonView)
				{
					return 0;
				}
				return _player.photonView.OwnerActorNr;
			}
		}

		private float AnchorScale => Mathf.Max(_anchor.lossyScale.x, 0.01f);

		private float RestRadius
		{
			get
			{
				if (!body)
				{
					return 0.09f;
				}
				return base.transform.lossyScale.x * body.transform.localScale.x;
			}
		}

		private bool Grounded
		{
			get
			{
				if (!_hasGround)
				{
					return _noGroundTime < lostGroundTime;
				}
				return true;
			}
		}

		private void Awake()
		{
			_player = GetComponentInParent<MonkeDevNetworkingPlayer>();
			_anchor = ((_player && _player.Head) ? _player.Head : (base.transform.parent ? base.transform.parent : base.transform));
			_skinned = body as SkinnedMeshRenderer;
			if (_skinned && _skinned.sharedMesh)
			{
				_flatIndex = _skinned.sharedMesh.GetBlendShapeIndex("Flat");
			}
			if (_skinned && _flatIndex < 0)
			{
				Debug.LogWarning("[Verity] '" + base.name + "' body is skinned but its mesh has no 'Flat' blend shape; using the scale squash fallback.", this);
			}
			if (_player)
			{
				_jaws = _player.GetComponentsInChildren<JawMaster67>(true);
			}
			_glancePhase = UnityEngine.Random.value * 9f;
		}

		private void OnEnable()
		{
			if (useLocomotionLayers)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (instance != null)
				{
					groundMask = instance.locomotionEnabledLayers;
				}
			}
			_lastYaw = AnchorYaw();
			_look = _lastYaw;
			_noGroundTime = 0f;
			_hasPose = false;
			ProbeGround();
			Respawn();
			_weight = 0f;
			_weightVel = 0f;
			_appliedWeight = float.NaN;
			_handsInsideCount = 0;
			_chatterSlot = long.MinValue;
			_gazeTime = 0f;
			_gazeFired = false;
			_greetAt = (IsLocalWearer ? (Time.time + 0.6f) : 0f);
			if (voiceClip && voiceClip.loadState == AudioDataLoadState.Unloaded)
			{
				voiceClip.LoadAudioData();
			}
			ApplyTransform();
		}

		private void OnDisable()
		{
			if (voice)
			{
				voice.Stop();
			}
			_wearerVoice = 0f;
			_talk = 0f;
			ApplyWeight(0f);
		}

		private void LateUpdate()
		{
			if (!orb)
			{
				return;
			}
			float dt = Mathf.Min(Time.deltaTime, VerityMath.MaxStep);
			if (dt <= 0f)
			{
				return;
			}
			if (body && !body.enabled)
			{
				_wasHidden = true;
				return;
			}
			if (_wasHidden)
			{
				_wasHidden = false;
				_hasPose = false;
				ProbeGround();
				Respawn();
			}
			float unit = AnchorScale;
			if (!_hasGround)
			{
				_noGroundTime += dt;
			}
			if (Time.time >= _nextProbe)
			{
				ProbeGround();
			}
			UpdateMovement(dt, unit);
			_vel = (_pos - _prevPos) / dt;
			_prevPos = _pos;
			VerityMath.Spring(ref _scale, ref _scaleVel, 1f, 3.5f, 0.35f, dt);
			_wearerVoice = ReadWearerVoice();
			UpdateVoice();
			DetectPokes();
			UpdateGaze(dt, unit);
			UpdateLook(dt);
			UpdateChatter();
			UpdateSquash(dt, unit);
			ApplyTransform();
		}

		private void UpdateMovement(float dt, float unit)
		{
			bool grounded = Grounded;
			Vector3 home = (grounded ? _home : HoverPoint());
			VerityMove move = VerityMath.ChooseMove(Vector3.Distance(_pos, home) / unit, grounded, hopDistance, flyDistance, teleportDistance);
			if (move == VerityMove.Teleport)
			{
				Respawn();
				return;
			}
			switch (_state)
			{
			case State.Grounded:
				if (move == VerityMove.Hop)
				{
					StartHop(HopTarget(home, unit), hopHeight * unit);
				}
				else if (move == VerityMove.Fly)
				{
					TakeOff(unit);
				}
				else if (Time.time >= _nextIdleHop)
				{
					StartHop(_pos, hopHeight * 0.5f * unit);
				}
				break;
			case State.Hopping:
				_hopT += dt / _hopDuration;
				_pos = VerityMath.HopArc(_hopFrom, _hopTo, _hopArc, _hopT);
				if (_hopT >= 1f)
				{
					Land();
				}
				else if (move == VerityMove.Fly && Vector3.Distance(_pos, home) > flyDistance * 1.5f * unit)
				{
					TakeOff(unit);
				}
				break;
			case State.Flying:
			{
				Vector3 target = (grounded ? (home + Vector3.up * (flyHeight * unit)) : home);
				VerityMath.Spring(ref _pos, ref _flyVel, target, flyFrequency, flyDamping, dt);
				if (_hasGround && FlatDistance(_pos, _home) < landDistance * unit)
				{
					StartHop(_home, hopHeight * 0.3f * unit);
				}
				break;
			}
			}
		}

		private void Respawn()
		{
			Vector3 point = (Grounded ? _home : HoverPoint());
			_prevPos = point;
			_pos = point;
			_vel = Vector3.zero;
			_flyVel = Vector3.zero;
			_state = ((!Grounded) ? State.Flying : State.Grounded);
			_scale = 0f;
			_scaleVel = 0f;
			_hasPose = true;
			_nextIdleHop = Time.time + UnityEngine.Random.Range(idleHopDelay.x, idleHopDelay.y);
		}

		private void TakeOff(float unit)
		{
			_state = State.Flying;
			_flyVel = _vel + Vector3.up * (unit * 1.5f);
			_weightVel += hopKick;
		}

		private void StartHop(Vector3 to, float arc)
		{
			_hopFrom = _pos;
			_hopTo = to;
			_hopArc = arc;
			_hopT = 0f;
			_hopDuration = VerityMath.HopDuration(Vector3.Distance(_hopFrom, to) / AnchorScale, hopTime);
			_state = State.Hopping;
			_weightVel += hopKick;
		}

		private void Land()
		{
			_pos = _hopTo;
			_state = State.Grounded;
			_weightVel += landKick;
			_nextIdleHop = Time.time + UnityEngine.Random.Range(idleHopDelay.x, idleHopDelay.y);
			float unit = AnchorScale;
			if (_hasGround && Vector3.Distance(_pos, _home) > unit * settleDistance)
			{
				StartHop(HopTarget(_home, unit), unit * hopHeight);
			}
		}

		private Vector3 HopTarget(Vector3 target, float unit)
		{
			Vector3 point = VerityMath.ClampHop(_pos, target, maxHopLength * unit);
			if ((point - target).sqrMagnitude < 1E-06f)
			{
				return target;
			}
			return GroundAt(point, unit);
		}

		private Vector3 GroundAt(Vector3 point, float unit)
		{
			if (Physics.Raycast(point + Vector3.up * (unit * 0.5f), Vector3.down, out var hitInfo, unit * 1.5f, groundMask, QueryTriggerInteraction.Ignore))
			{
				return hitInfo.point + Vector3.up * RestRadius;
			}
			return point;
		}

		private void ProbeGround()
		{
			_nextProbe = Time.time + 0.15f;
			float unit = AnchorScale;
			Vector3 near = ((!_hasPose) ? _anchor.position : ((_state == State.Hopping) ? _hopTo : _pos));
			Vector3 origin = VerityMath.ClosestOnRing(_anchor.position, near, unit * ringRadius, AnchorYaw() * groundOffset);
			if (Physics.Raycast(origin, Vector3.down, out var hitInfo, unit * groundProbe, groundMask, QueryTriggerInteraction.Ignore))
			{
				_home = hitInfo.point + Vector3.up * RestRadius;
				_hasGround = true;
				_noGroundTime = 0f;
			}
			else
			{
				_hasGround = false;
			}
		}

		private Vector3 HoverPoint()
		{
			return _anchor.position + AnchorYaw() * (hoverOffset * AnchorScale);
		}

		private Quaternion AnchorYaw()
		{
			Vector3 forward = Vector3.ProjectOnPlane(_anchor.forward, Vector3.up);
			if (forward.sqrMagnitude > 0.01f)
			{
				_lastYaw = Quaternion.LookRotation(forward, Vector3.up);
			}
			return _lastYaw;
		}

		private static float FlatDistance(Vector3 a, Vector3 b)
		{
			float dx = a.x - b.x;
			float dz = a.z - b.z;
			return Mathf.Sqrt(dx * dx + dz * dz);
		}

		private void DetectPokes()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null || !body)
			{
				return;
			}
			float reach = RestRadius + pokeRadius * AnchorScale;
			float sqrReach = reach * reach;
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer player = players[i];
				if (player)
				{
					CheckHand(player.LeftHand, player, sqrReach);
					CheckHand(player.RightHand, player, sqrReach);
				}
			}
		}

		private void CheckHand(Transform hand, MonkeDevNetworkingPlayer owner, float sqrReach)
		{
			if (!hand)
			{
				return;
			}
			Vector3 away = _pos - hand.position;
			int idx = IndexOfHandInside(hand);
			float sqrMagnitude = away.sqrMagnitude;
			if (idx >= 0)
			{
				if (sqrMagnitude > sqrReach * 1.69f)
				{
					RemoveHandInside(idx);
				}
			}
			else if (sqrMagnitude < sqrReach)
			{
				AddHandInside(hand);
				OnPoked(away, owner);
			}
		}

		private int IndexOfHandInside(Transform hand)
		{
			for (int i = 0; i < _handsInsideCount; i++)
			{
				if (_handsInside[i] == hand)
				{
					return i;
				}
			}
			return -1;
		}

		private void AddHandInside(Transform hand)
		{
			if (_handsInsideCount < _handsInside.Length)
			{
				_handsInside[_handsInsideCount++] = hand;
			}
		}

		private void RemoveHandInside(int idx)
		{
			_handsInsideCount--;
			_handsInside[idx] = _handsInside[_handsInsideCount];
			_handsInside[_handsInsideCount] = null;
		}

		private void OnPoked(Vector3 away, MonkeDevNetworkingPlayer poker)
		{
			float unit = AnchorScale;
			Vector3 flat = Vector3.ProjectOnPlane(away, Vector3.up);
			if (_state == State.Flying)
			{
				Vector3 dir = ((away.sqrMagnitude > 1E-06f) ? away.normalized : Vector3.up);
				_flyVel += dir * (unit * pokeImpulse);
			}
			else
			{
				Vector3 to = _pos;
				if (flat.sqrMagnitude > 1E-06f)
				{
					to = GroundAt(_pos + flat.normalized * (unit * pokeHop), unit);
				}
				if (_state == State.Hopping)
				{
					to = GroundAt(_hopTo + flat.normalized * (unit * pokeHop), unit);
				}
				StartHop(to, unit * (hopHeight * 1.4f));
			}
			_weightVel += landKick;
			if (poker && poker != _player && poker.Head)
			{
				_faceTarget = poker.Head;
				_faceUntil = Time.time + 3f;
			}
			if (!(Time.time < _nextPokeLine))
			{
				_nextPokeLine = Time.time + pokeLineCooldown;
				Say(VerityMath.PickLine(VerityMath.Seed(VerityMath.TimeSlot(SharedTime(), 1.0), OwnerActor), lines.Length, _lastLine));
			}
		}

		private void UpdateGaze(float dt, float unit)
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Transform head = (manager ? manager.Head : null);
			if (!head)
			{
				return;
			}
			if (!VerityMath.IsLookingAt(head.position, head.forward, _pos, RestRadius, gazeAngle, gazeDistance * unit))
			{
				_gazeTime = 0f;
				_gazeFired = false;
				return;
			}
			_gazeTime += dt;
			if (_gazeFired || _gazeTime < gazeSeconds || Time.time < _nextGazeLine || (voice && voice.isPlaying))
			{
				return;
			}
			_gazeFired = true;
			_nextGazeLine = Time.time + gazeCooldown;
			_faceTarget = ((manager.LocalPlayer && manager.LocalPlayer.Head) ? manager.LocalPlayer.Head : head);
			_faceUntil = Time.time + 3f;
			if (_state == State.Grounded)
			{
				StartHop(_pos, hopHeight * 0.8f * unit);
			}
			Say(VerityMath.PickLine((uint)UnityEngine.Random.Range(int.MinValue, int.MaxValue), lines.Length, _lastLine));
		}

		private void UpdateLook(float dt)
		{
			if (Time.time >= _nextLookScan)
			{
				_nextLookScan = Time.time + 0.25f;
				_lookAt = FindNearestOtherHead();
			}
			Transform target = ((_faceTarget && Time.time < _faceUntil) ? _faceTarget : null);
			Quaternion want = AnchorYaw();
			if (!target && _state != State.Grounded)
			{
				Vector3 flat = new Vector3(_vel.x, 0f, _vel.z);
				want = ((flat.sqrMagnitude > 0.01f) ? Quaternion.LookRotation(flat, Vector3.up) : _look);
			}
			else
			{
				if (!target)
				{
					target = _lookAt;
				}
				if (!target && _player && Mathf.Repeat(Time.time + _glancePhase, 9f) < 2.5f)
				{
					target = _player.Head;
				}
				if (target)
				{
					Vector3 toTarget = target.position - _pos;
					if (toTarget.sqrMagnitude > 0.0001f)
					{
						want = Quaternion.LookRotation(toTarget, Vector3.up);
					}
				}
			}
			_look = Quaternion.Slerp(_look, want, 1f - Mathf.Exp((0f - turnSpeed) * dt));
		}

		private Transform FindNearestOtherHead()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return null;
			}
			float best = lookRadius * AnchorScale;
			best *= best;
			Transform result = null;
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer player = players[i];
				if (player && !(player == _player) && player.Head)
				{
					float sqrMagnitude = (player.Head.position - _pos).sqrMagnitude;
					if (sqrMagnitude < best)
					{
						best = sqrMagnitude;
						result = player.Head;
					}
				}
			}
			return result;
		}

		private float ReadWearerVoice()
		{
			float max = 0f;
			for (int i = 0; i < _jaws.Length; i++)
			{
				JawMaster67 jaw = _jaws[i];
				if (jaw && jaw.isActiveAndEnabled)
				{
					max = Mathf.Max(max, jaw.NormalizedVolume);
				}
			}
			return max;
		}

		private void UpdateVoice()
		{
			if (_greetAt > 0f && Time.time >= _greetAt && CanSpeak())
			{
				_greetAt = 0f;
				Say(greetingLine);
				if (_player && _player.Head)
				{
					_faceTarget = _player.Head;
					_faceUntil = Time.time + 3f;
				}
			}
			_talk = 0f;
			if (voice && voice.isPlaying)
			{
				if (_lineEnd > 0f && voice.time >= _lineEnd)
				{
					voice.Stop();
					return;
				}
				voice.GetOutputData(_samples, 0);
				_talk = VerityMath.Rms(_samples);
			}
		}

		private void UpdateChatter()
		{
			if (chatterInterval <= 0f || lines.Length == 0)
			{
				return;
			}
			long slot = VerityMath.TimeSlot(SharedTime() + (double)OwnerActor * 3.7, chatterInterval);
			if (slot == _chatterSlot)
			{
				return;
			}
			long previous = _chatterSlot;
			_chatterSlot = slot;
			if (previous != long.MinValue && (!voice || !voice.isPlaying))
			{
				uint seed = VerityMath.Seed(slot, OwnerActor);
				if (VerityMath.Hash(seed ^ 0xA5A5A5A5u) % (uint)Mathf.Max(1, chatterOdds) == 0)
				{
					Say(VerityMath.PickLine(seed, lines.Length, _lastLine));
				}
			}
		}

		private bool CanSpeak()
		{
			if (!voice || !voiceClip)
			{
				return false;
			}
			if (voiceClip.loadState == AudioDataLoadState.Loaded)
			{
				return true;
			}
			if (voiceClip.loadState == AudioDataLoadState.Unloaded)
			{
				voiceClip.LoadAudioData();
			}
			return false;
		}

		private void Say(int index)
		{
			if (index >= 0 && index < lines.Length && CanSpeak())
			{
				VoiceLine voiceLine = lines[index];
				_lastLine = index;
				_lineEnd = ((voiceLine.end > voiceLine.start) ? voiceLine.end : 0f);
				voice.clip = voiceClip;
				voice.time = Mathf.Clamp(voiceLine.start, 0f, voiceClip.length - 0.01f);
				voice.Play();
			}
		}

		private void UpdateSquash(float dt, float unit)
		{
			float speed = 0f;
			if (_state == State.Hopping)
			{
				speed = Mathf.Abs(_vel.y);
			}
			else if (_state == State.Flying)
			{
				speed = _vel.magnitude;
			}
			float target = Mathf.Sin(Time.time * 1.7f) * 6f + VerityMath.StretchWeight(speed / unit, stretchPerSpeed, maxStretch) - Mathf.Max(_talk * talkStretch, _wearerVoice * wearerVoiceStretch);
			VerityMath.Spring(ref _weight, ref _weightVel, target, squashFrequency, squashDamping, dt);
			if (_weight < 0f - maxStretch)
			{
				_weight = 0f - maxStretch;
				_weightVel = 0f;
			}
			else if (_weight > maxSquash)
			{
				_weight = maxSquash;
				_weightVel = 0f;
			}
			ApplyWeight(_weight);
		}

		private Quaternion Lean()
		{
			if (_state == State.Grounded)
			{
				return Quaternion.identity;
			}
			Vector3 flat = new Vector3(_vel.x, 0f, _vel.z) / AnchorScale;
			float speed = flat.magnitude;
			if (speed < 0.001f)
			{
				return Quaternion.identity;
			}
			return Quaternion.AngleAxis(Mathf.Min(speed * leanPerSpeed, maxLean), Vector3.Cross(Vector3.up, flat / speed));
		}

		private void ApplyTransform()
		{
			if (!orb)
			{
				return;
			}
			float scale = Mathf.Max(0f, _scale);
			Vector3 position = _pos;
			if (_state == State.Grounded)
			{
				position += Vector3.up * (RestRadius * (scale * VerityMath.GroundedExtent(_weight) - 1f));
			}
			orb.SetPositionAndRotation(position, Lean() * _look);
			if (_flatIndex >= 0)
			{
				orb.localScale = Vector3.one * scale;
				return;
			}
			float extent = VerityMath.GroundedExtent(_weight);
			float side = scale * (1f / Mathf.Sqrt(extent));
			orb.localScale = new Vector3(side, scale * extent, side);
		}

		private void ApplyWeight(float weight)
		{
			if (_flatIndex >= 0 && (bool)_skinned && !(Mathf.Abs(weight - _appliedWeight) < 0.25f))
			{
				_appliedWeight = weight;
				_skinned.SetBlendShapeWeight(_flatIndex, weight);
			}
		}

		private static double SharedTime()
		{
			if (PhotonNetwork.IsConnected)
			{
				return PhotonNetwork.Time;
			}
			return Time.timeAsDouble;
		}
	}
}
