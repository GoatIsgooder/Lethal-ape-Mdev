using System;
using System.Collections.Generic;
using System.Reflection;
using LALocomotion;
using LethalApeR.Networking;
using Photon.Pun;
using SlopGame;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DefaultExecutionOrder(10360)]
	[Obfuscation(Exclude = true)]
	public class BtmLumberjackAxe : MonoBehaviour, IHandCurlSource
	{
		private struct EdgeSample
		{
			public float Time;

			public Vector3 Position;
		}

		private struct HandSample
		{
			public float Time;

			public Vector3 Position;
		}

		private struct Pass
		{
			public Vector3 From;

			public Vector3 To;

			public float Radius;
		}

		public enum AxeState : byte
		{
			Held = 0,
			Flying = 1,
			Stuck = 2,
			Returning = 3
		}

		private const float ChopRepeatSeconds = 2f;

		private readonly EdgeSample[] _edgeHistory = new EdgeSample[32];

		private int _edgeCount;

		private int _edgeNewest;

		private Vector3 _chopEdgeFrom;

		private Vector3 _chopHeadFrom;

		private bool _chopReady;

		private readonly Dictionary<int, float> _choppedAt = new Dictionary<int, float>(4);

		private Transform _flight;

		private Transform _flightModel;

		private Vector3 _axeScale = Vector3.one;

		[Header("Sound")]
		[SerializeField]
		private AudioClip throwClip;

		[Tooltip("One turn of the axe, looped while it flies. Pitched with the spin.")]
		[SerializeField]
		private AudioClip spinLoop;

		[SerializeField]
		private AudioClip[] stickClips = Array.Empty<AudioClip>();

		[SerializeField]
		private AudioClip ripClip;

		[SerializeField]
		private AudioClip catchClip;

		[SerializeField]
		private AudioClip chopClip;

		[Tooltip("Settings for the one-shots (pooled through AudioSystem). Spatialize must stay 0.")]
		[SerializeField]
		private AudioSource oneShotTemplate;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.9f;

		[SerializeField]
		[Range(0f, 1f)]
		private float spinVolume = 0.75f;

		[Header("Trail")]
		[Tooltip("Additive streak off the edge while it flies. Leave empty for none.")]
		[SerializeField]
		private Material trailMaterial;

		[SerializeField]
		private Color trailColour = new Color(1f, 0.78f, 0.62f, 0.5f);

		private const float SpinPitchBase = 900f;

		private TrailRenderer _trail;

		private AudioSource _spin;

		private float _secondPulseAt = -1f;

		private const float ArmSeconds = 0.08f;

		private const float RecallTrigger = 0.55f;

		private const float RecallAfterThrow = 0.2f;

		private const float ThrowAfterCatch = 0.25f;

		private const float VelocityWindow = 0.09f;

		private const float HistorySeconds = 0.2f;

		private const string HintText = "<color=#E8A040><b>YOU ARE THE LUMBERJACK</b>\n<size=50%>Swing it into them: chop\nGRIP, swing and let go: throw the axe\nHold TRIGGER: call it back</color>";

		private readonly List<HandSample> _handSamples = new List<HandSample>(24);

		private readonly HashSet<int> _victims = new HashSet<int>();

		private readonly Dictionary<MonkeDevNetworkingPlayer, CapsuleCollider> _bodies = new Dictionary<MonkeDevNetworkingPlayer, CapsuleCollider>();

		private readonly List<Vector3> _targets = new List<Vector3>(8);

		private readonly List<Vector3> _targetVelocities = new List<Vector3>(8);

		private bool _gripping;

		private float _gripSince;

		private double _thrownAt;

		private LAGrabber _blockedGrabber;

		private double _hintRound = -1.0;

		private readonly Pass[] _passes = new Pass[2];

		private int _passCount;

		private int _passFrame = -1;

		private Vector3 _passNormal;

		[Header("Rig")]
		[SerializeField]
		private MonkeDevNetworkingPlayer player;

		[SerializeField]
		private GameModePlayer gameModePlayer;

		[Tooltip("The axe in the hand (BloodyAxe under hand.R). It stays put and hides while the axe is out.")]
		[SerializeField]
		private Transform axe;

		[Tooltip("How closed the axe hand's fingers are round the handle (0 open .. 1 the ape's full fist): x thumb, y index, z the rest. Fitted by the builder: each closes until it meets the handle.")]
		[SerializeField]
		private Vector3 holdCurl = new Vector3(0.75f, 0.75f, 0.75f);

		[Header("World")]
		[Tooltip("What a thrown axe bites into.")]
		[SerializeField]
		private LayerMask worldMask = 1;

		public static readonly List<BtmLumberjackAxe> Owned = new List<BtmLumberjackAxe>(1);

		private AxeState _state;

		private bool _ready;

		private Vector3 _balanceLocal;

		private Vector3 _handleLocal = Vector3.forward;

		private Vector3 _edgeLocal = Vector3.right;

		private Vector3 _edgeTipLocal;

		private Vector3 _headLocal;

		private float _headHalfHeightLocal = 0.05f;

		private Renderer[] _heldRenderers = Array.Empty<Renderer>();

		private Vector3 _position;

		private Quaternion _rotation = Quaternion.identity;

		private double _throwTime;

		private Vector3 _origin;

		private Vector3 _velocity;

		private Quaternion _startRotation = Quaternion.identity;

		private Vector3 _spinAxis = Vector3.right;

		private float _spinRate;

		private double _returnTime;

		private Vector3 _returnFrom;

		private Quaternion _returnRotation = Quaternion.identity;

		private float _returnSeconds = 1f;

		private Vector3 _returnAxis = Vector3.right;

		private float _returnSpin;

		private float _caughtAt = -10f;

		private float Scale
		{
			get
			{
				BTMGameManager instance = BTMGameManager.Instance;
				if (!gameModePlayer || !instance)
				{
					return 1f;
				}
				return Mathf.Max(0.2f, gameModePlayer.RoundScale(instance.roomSettings.monsterSize));
			}
		}

		private bool CanAct
		{
			get
			{
				if (BTMGameManager.Instance && BtmMonsterHand.LocalIsLiveMonster() && gameModePlayer && gameModePlayer.isMonster)
				{
					return !gameModePlayer.isEliminated;
				}
				return false;
			}
		}

		private void TickChop()
		{
			if (_state != AxeState.Held || !CanAct)
			{
				_chopReady = false;
				return;
			}
			Vector3 edge = axe.TransformPoint(_edgeTipLocal);
			Vector3 head = axe.TransformPoint(_headLocal);
			bool chopReady = _chopReady;
			if (!chopReady)
			{
				_edgeCount = 0;
			}
			Vector3 chopEdgeFrom = _chopEdgeFrom;
			Vector3 chopHeadFrom = _chopHeadFrom;
			_chopEdgeFrom = edge;
			_chopHeadFrom = head;
			_chopReady = true;
			Vector3 swing;
			float speed = RecordEdge(Time.time, edge, out swing);
			if (!chopReady)
			{
				return;
			}
			float scale = Scale;
			float maxStep = BtmAxeRules.ChopMaxStep * scale;
			if ((edge - chopEdgeFrom).sqrMagnitude > maxStep * maxStep)
			{
				_edgeCount = 1;
				return;
			}
			if (speed < BtmAxeRules.ChopMinSpeed * scale)
			{
				return;
			}
			Vector3 handle = axe.TransformDirection(_handleLocal);
			Vector3 normal = BtmAxeRules.ChopNormal(handle, swing, Vector3.Cross(handle, axe.TransformDirection(_edgeLocal)));
			float radius = axe.TransformVector(_handleLocal * _headHalfHeightLocal).magnitude;
			BeginPasses(normal);
			AddPass(chopEdgeFrom, edge, radius);
			AddPass(chopHeadFrom, head, radius);
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			BTMGameManager instance = BTMGameManager.Instance;
			if (!manager || !instance)
			{
				return;
			}
			int viewID = player.photonView.ViewID;
			for (int i = 0; i < manager.Players.Count; i++)
			{
				MonkeDevNetworkingPlayer p = manager.Players[i];
				if (!BtmMonsterHand.IsLiveSurvivor(p))
				{
					continue;
				}
				int viewID2 = p.photonView.ViewID;
				if (_choppedAt.TryGetValue(viewID2, out var value) && Time.time - value < ChopRepeatSeconds)
				{
					continue;
				}
				CapsuleCollider capsuleCollider = BodyOf(p);
				if (!capsuleCollider)
				{
					continue;
				}
				BtmGrabReach.Segment(capsuleCollider, out var a, out var b, out var bodyRadius);
				float reach = radius + bodyRadius;
				if (!(BtmGrabReach.SegmentDistanceSqr(chopEdgeFrom, edge, a, b) <= reach * reach) && BtmGrabReach.SegmentDistanceSqr(chopHeadFrom, head, a, b) > reach * reach)
				{
					continue;
				}
				_choppedAt[viewID2] = Time.time;
				instance.photonView.RPC("RPC_AxeKill", RpcTarget.All, viewID2, viewID, normal, ClosestOnSegment(a, b, edge), swing.normalized);
				Pulse(1f, 0.15f);
			}
		}

		private float RecordEdge(float now, Vector3 edge, out Vector3 swing)
		{
			_edgeNewest = (_edgeNewest + 1) % _edgeHistory.Length;
			_edgeHistory[_edgeNewest] = new EdgeSample
			{
				Time = now,
				Position = edge
			};
			if (_edgeCount < _edgeHistory.Length)
			{
				_edgeCount++;
			}
			int index = -1;
			for (int i = 1; i < _edgeCount; i++)
			{
				index = (_edgeNewest - i + _edgeHistory.Length) % _edgeHistory.Length;
				if (now - _edgeHistory[index].Time >= BtmAxeRules.ChopSpeedWindow)
				{
					break;
				}
			}
			swing = Vector3.zero;
			if (index < 0)
			{
				return 0f;
			}
			float dt = now - _edgeHistory[index].Time;
			if (dt < 0.03f)
			{
				return 0f;
			}
			swing = edge - _edgeHistory[index].Position;
			return swing.magnitude / dt;
		}

		private void TickFlying()
		{
			float t = Mathf.Max(0f, (float)(PhotonNetwork.Time - _throwTime));
			Vector3 position = BtmAxeRules.ThrowPosition(_origin, _velocity, t);
			Vector3 heading = BtmAxeRules.ThrowHeading(_velocity, t);
			Vector3 step = position - _position;
			float distance = step.magnitude;
			if (distance > 0.0001f && Physics.SphereCast(_position, Scale * BtmAxeRules.HeadRadius, step / distance, out var hitInfo, distance, worldMask, QueryTriggerInteraction.Ignore))
			{
				Stick(hitInfo, heading);
				return;
			}
			_position = position;
			_rotation = BtmAxeRules.Spin(_startRotation, _spinAxis, _spinRate, t);
			if (t > BtmAxeRules.MaxFlightSeconds && IsMine)
			{
				Recall();
			}
			else if (t > 5.5f && !IsMine)
			{
				ResetToHand(true);
			}
		}

		private void Stick(RaycastHit hit, Vector3 heading)
		{
			Vector3 into = (heading.normalized - hit.normal).normalized;
			if (into.sqrMagnitude < 1E-06f)
			{
				into = -hit.normal;
			}
			Quaternion rotation = _rotation;
			Vector3 blade = Vector3.ProjectOnPlane(_rotation * _edgeLocal, _spinAxis);
			Vector3 want = Vector3.ProjectOnPlane(into, _spinAxis);
			if (blade.sqrMagnitude > 1E-06f && want.sqrMagnitude > 1E-06f && Vector3.Dot(blade.normalized, want.normalized) > -0.999f)
			{
				rotation = Quaternion.FromToRotation(blade, want) * rotation;
			}
			Vector3 tip = rotation * Vector3.Scale(_edgeTipLocal - _balanceLocal, _axeScale);
			_rotation = rotation;
			_position = hit.point + into * (Scale * BtmAxeRules.BiteDepth) - tip;
			_state = AxeState.Stuck;
			DrawFlight();
			Landed(hit.point);
			if (IsMine && BTMGameManager.Instance)
			{
				BTMGameManager.Instance.photonView.RPC("RPC_AxeStick", RpcTarget.Others, _position, _rotation);
			}
		}

		private void TickReturning()
		{
			float t = Mathf.Max(0f, (float)(PhotonNetwork.Time - _returnTime));
			float u = t / _returnSeconds;
			Vector3 heldPosition = HeldPosition;
			_position = BtmAxeRules.ReturnPosition(_returnFrom, heldPosition, u);
			Quaternion spun = Quaternion.AngleAxis(t * _returnSpin, _returnAxis) * _returnRotation;
			float k = Mathf.Clamp01((u - 0.7f) / 0.3f);
			_rotation = Quaternion.Slerp(spun, HeldRotation, k * k * (3f - 2f * k));
			float catchRadius = Scale * BtmAxeRules.CatchRadius;
			if (u >= 1f || (u > 0.5f && (_position - heldPosition).sqrMagnitude <= catchRadius * catchRadius))
			{
				if (IsMine)
				{
					CatchOwn();
				}
				else
				{
					Caught();
				}
			}
		}

		private void DrawFlight()
		{
			if (_flight)
			{
				_flight.SetPositionAndRotation(_position, _rotation);
			}
		}

		private void ShowFlight(bool shown)
		{
			if (shown)
			{
				EnsureFlight();
				if (_flight)
				{
					_axeScale = axe.lossyScale;
					_flightModel.localScale = _axeScale;
					_flightModel.localPosition = -Vector3.Scale(_balanceLocal, _axeScale);
					ShowHeld(false);
					if (!_flight.gameObject.activeSelf)
					{
						_flight.gameObject.SetActive(true);
						if (_trail)
						{
							_trail.Clear();
						}
					}
				}
			}
			else if (_flight && _flight.gameObject.activeSelf)
			{
				_flight.gameObject.SetActive(false);
			}
		}

		private void EnsureFlight()
		{
			if ((bool)_flight || !axe)
			{
				return;
			}
			MeshFilter component = axe.GetComponent<MeshFilter>();
			MeshRenderer component2 = axe.GetComponent<MeshRenderer>();
			if ((bool)component && (bool)component2)
			{
				int layer = axe.gameObject.layer;
				GameObject gameObject = new GameObject(((bool)player ? player.name : base.name) + " thrown axe");
				gameObject.layer = layer;
				gameObject.SetActive(false);
				_flight = gameObject.transform;
				GameObject gameObject2 = new GameObject("Model");
				gameObject2.layer = layer;
				gameObject2.transform.SetParent(_flight, false);
				gameObject2.AddComponent<MeshFilter>().sharedMesh = component.sharedMesh;
				MeshRenderer meshRenderer = gameObject2.AddComponent<MeshRenderer>();
				meshRenderer.sharedMaterials = component2.sharedMaterials;
				meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
				meshRenderer.receiveShadows = false;
				meshRenderer.lightProbeUsage = component2.lightProbeUsage;
				meshRenderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
				meshRenderer.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
				_flightModel = gameObject2.transform;
				BuildFlightFx(gameObject, gameObject2.transform);
			}
		}

		private void BuildFlightFx(GameObject root, Transform model)
		{
			_spin = root.AddComponent<AudioSource>();
			_spin.clip = spinLoop;
			_spin.loop = true;
			_spin.playOnAwake = false;
			_spin.spatialize = false;
			_spin.spatialBlend = 1f;
			_spin.rolloffMode = AudioRolloffMode.Linear;
			_spin.minDistance = 1.5f;
			_spin.maxDistance = 24f;
			_spin.dopplerLevel = 0.35f;
			_spin.priority = 64;
			_spin.volume = volume * spinVolume;
			if (oneShotTemplate)
			{
				_spin.outputAudioMixerGroup = oneShotTemplate.outputAudioMixerGroup;
			}
			if (trailMaterial)
			{
				GameObject gameObject = new GameObject("Edge Trail");
				gameObject.layer = model.gameObject.layer;
				gameObject.transform.SetParent(model, false);
				gameObject.transform.localPosition = _edgeTipLocal;
				_trail = gameObject.AddComponent<TrailRenderer>();
				_trail.sharedMaterial = trailMaterial;
				_trail.time = 0.12f;
				_trail.minVertexDistance = 0.04f;
				_trail.widthMultiplier = 0.07f;
				_trail.widthCurve = new AnimationCurve(new Keyframe(0f, 1f), new Keyframe(1f, 0f));
				Gradient gradient = new Gradient();
				gradient.SetKeys(new GradientColorKey[2]
				{
					new GradientColorKey(trailColour, 0f),
					new GradientColorKey(trailColour, 1f)
				}, new GradientAlphaKey[2]
				{
					new GradientAlphaKey(trailColour.a, 0f),
					new GradientAlphaKey(0f, 1f)
				});
				_trail.colorGradient = gradient;
				_trail.numCapVertices = 0;
				_trail.alignment = LineAlignment.View;
				_trail.shadowCastingMode = ShadowCastingMode.Off;
				_trail.receiveShadows = false;
				_trail.lightProbeUsage = LightProbeUsage.Off;
				_trail.reflectionProbeUsage = ReflectionProbeUsage.Off;
				_trail.emitting = false;
			}
		}

		private void Thrown(Vector3 origin)
		{
			PlayAt(throwClip, origin, 0.9f);
			StartSpin(_spinRate);
		}

		private void Landed(Vector3 point)
		{
			StopSpin();
			if (stickClips != null && stickClips.Length != 0)
			{
				PlayAt(stickClips[UnityEngine.Random.Range(0, stickClips.Length)], point, 1f);
			}
		}

		private void Recalled(Vector3 from, bool ripped)
		{
			if (ripped)
			{
				PlayAt(ripClip, from, 1f);
			}
			StartSpin(Mathf.Abs(_returnSpin));
		}

		private void CaughtFx()
		{
			StopSpin();
			PlayAt(catchClip, HeldPosition, 0.9f);
			if (IsMine)
			{
				Pulse(1f, 0.1f);
				_secondPulseAt = Time.time + 0.11f;
			}
		}

		private void StartSpin(float degreesPerSecond)
		{
			if (_trail)
			{
				_trail.widthMultiplier = Scale * 0.07f;
				_trail.emitting = true;
			}
			if ((bool)_spin && (bool)spinLoop)
			{
				_spin.pitch = Mathf.Clamp(degreesPerSecond / SpinPitchBase, 0.8f, 1.35f);
				if (!_spin.isPlaying)
				{
					_spin.Play();
				}
			}
		}

		private void StopSpin()
		{
			if (_trail)
			{
				_trail.emitting = false;
			}
			if ((bool)_spin && _spin.isPlaying)
			{
				_spin.Stop();
			}
		}

		private void StopFx()
		{
			StopSpin();
			_secondPulseAt = -1f;
		}

		private void TickFx()
		{
			if (_secondPulseAt > 0f && Time.time >= _secondPulseAt)
			{
				_secondPulseAt = -1f;
				Pulse(0.5f, 0.08f);
			}
			if (IsMine && _state == AxeState.Returning && Time.frameCount % 4 == 0)
			{
				float num = Mathf.Clamp01((float)(PhotonNetwork.Time - _returnTime) / _returnSeconds);
				Pulse(0.3f * num * num + 0.08f, 0.05f);
			}
		}

		private void PlayAt(AudioClip clip, Vector3 point, float loudness)
		{
			if (clip)
			{
				AudioSystem.PlayClipAt(clip, point, volume * loudness, oneShotTemplate);
			}
		}

		private void Pulse(float amplitude, float duration)
		{
			if (IsMine)
			{
				VRInputController instance = VRInputController.Instance;
				if (instance)
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		private void TickOwnerInput()
		{
			VRInputController instance = VRInputController.Instance;
			if (!instance || !CanAct)
			{
				UpdateHandBlock(false);
				_gripping = false;
				return;
			}
			UpdateHandBlock(_state == AxeState.Held);
			ShowHint();
			bool gripping = _gripping;
			_gripping = BtmGrabReach.Gripping(gripping, instance.RightGripValue);
			if (!gripping && _gripping)
			{
				_gripSince = Time.time;
				if (_state == AxeState.Held)
				{
					Pulse(0.12f, 0.03f);
				}
			}
			else if (gripping && !_gripping && _state == AxeState.Held && Time.time - _gripSince >= ArmSeconds && Time.time - _caughtAt >= ThrowAfterCatch)
			{
				TryThrow();
			}
			if (instance.RightTriggerValue >= RecallTrigger && (_state == AxeState.Flying || _state == AxeState.Stuck) && PhotonNetwork.Time - _thrownAt >= RecallAfterThrow)
			{
				Recall();
			}
		}

		private void ResetOwnerInput()
		{
			_gripping = false;
			_handSamples.Clear();
			_victims.Clear();
			_bodies.Clear();
			_chopReady = false;
			_passFrame = -1;
			_choppedAt.Clear();
		}

		private void TrackHand()
		{
			Transform hand = (player ? player.RightHand : null);
			if ((bool)hand)
			{
				float time = Time.time;
				_handSamples.Add(new HandSample
				{
					Time = time,
					Position = hand.position
				});
				while (_handSamples.Count > 2 && time - _handSamples[0].Time > HistorySeconds)
				{
					_handSamples.RemoveAt(0);
				}
			}
		}

		private Vector3 HandVelocity()
		{
			float time = Time.time;
			Vector3 sumPosition = Vector3.zero;
			float sumTime = 0f;
			int count = 0;
			for (int i = 0; i < _handSamples.Count; i++)
			{
				if (!(time - _handSamples[i].Time > VelocityWindow))
				{
					sumTime += _handSamples[i].Time;
					sumPosition += _handSamples[i].Position;
					count++;
				}
			}
			if (count > 1)
			{
				float meanTime = sumTime / (float)count;
				Vector3 meanPosition = sumPosition / count;
				Vector3 numerator = Vector3.zero;
				float denominator = 0f;
				for (int j = 0; j < _handSamples.Count; j++)
				{
					if (!(time - _handSamples[j].Time > VelocityWindow))
					{
						float dt = _handSamples[j].Time - meanTime;
						numerator += (_handSamples[j].Position - meanPosition) * dt;
						denominator += dt * dt;
					}
				}
				if (denominator > 1E-08f)
				{
					return numerator / denominator;
				}
			}
			return Vector3.zero;
		}

		private void TryThrow()
		{
			Vector3 velocity = BtmAxeRules.ThrowVelocity(HandVelocity(), Scale);
			if (!(velocity == Vector3.zero))
			{
				Vector3 heldPosition = HeldPosition;
				CollectTargets();
				velocity = BtmAxeRules.Assist(heldPosition, velocity, _targets, _targetVelocities);
				Quaternion heldRotation = HeldRotation;
				_thrownAt = PhotonNetwork.Time;
				StartFlight(heldPosition, heldRotation, velocity, _thrownAt);
				BTMGameManager.Instance.photonView.RPC("RPC_AxeThrow", RpcTarget.Others, heldPosition, heldRotation, velocity);
				Pulse(0.7f, 0.1f);
			}
		}

		private void Recall()
		{
			if (_state == AxeState.Flying || _state == AxeState.Stuck)
			{
				Vector3 position = _position;
				Quaternion rotation = _rotation;
				StartReturn(position, rotation, PhotonNetwork.Time);
				if (BTMGameManager.Instance)
				{
					BTMGameManager.Instance.photonView.RPC("RPC_AxeRecall", RpcTarget.Others, position, rotation);
				}
				Pulse(0.35f, 0.06f);
			}
		}

		private void CatchOwn()
		{
			Caught();
			if (BTMGameManager.Instance)
			{
				BTMGameManager.Instance.photonView.RPC("RPC_AxeCaught", RpcTarget.Others);
			}
		}

		private void CollectTargets()
		{
			_targets.Clear();
			_targetVelocities.Clear();
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (!manager)
			{
				return;
			}
			BtmGore instance = BtmGore.Instance;
			for (int i = 0; i < manager.Players.Count; i++)
			{
				MonkeDevNetworkingPlayer p = manager.Players[i];
				if (BtmMonsterHand.IsLiveSurvivor(p))
				{
					CapsuleCollider capsuleCollider = BodyOf(p);
					if ((bool)capsuleCollider)
					{
						BtmGrabReach.Segment(capsuleCollider, out var a, out var b, out var _);
						_targets.Add((a + b) * 0.5f);
						_targetVelocities.Add(instance ? instance.VelocityOf(p) : Vector3.zero);
					}
				}
			}
		}

		private void Sweep(Vector3 from, Vector3 to)
		{
			if (!BTMGameManager.Instance || !BtmMonsterHand.LocalIsLiveMonster())
			{
				return;
			}
			Vector3 step = to - from;
			if (step.sqrMagnitude < 1E-08f)
			{
				return;
			}
			float radius = Scale * BtmAxeRules.BladeRadius;
			Vector3 normal = BtmAxeRules.CutNormal((_state == AxeState.Returning) ? _returnAxis : _spinAxis, step);
			BeginPasses(normal);
			AddPass(from, to, radius);
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (!manager)
			{
				return;
			}
			int viewID = player.photonView.ViewID;
			for (int i = 0; i < manager.Players.Count; i++)
			{
				MonkeDevNetworkingPlayer p = manager.Players[i];
				if (!BtmMonsterHand.IsLiveSurvivor(p))
				{
					continue;
				}
				int viewID2 = p.photonView.ViewID;
				if (_victims.Contains(viewID2))
				{
					continue;
				}
				CapsuleCollider capsuleCollider = BodyOf(p);
				if ((bool)capsuleCollider)
				{
					BtmGrabReach.Segment(capsuleCollider, out var a, out var b, out var bodyRadius);
					float reach = radius + bodyRadius;
					if (!(BtmGrabReach.SegmentDistanceSqr(from, to, a, b) > reach * reach))
					{
						_victims.Add(viewID2);
						Vector3 hit = ClosestOnSegment(a, b, (from + to) * 0.5f);
						BTMGameManager.Instance.photonView.RPC("RPC_AxeKill", RpcTarget.All, viewID2, viewID, normal, hit, step.normalized);
						Pulse(0.9f, 0.15f);
					}
				}
			}
		}

		public AxeState State => _state;

		public bool IsOut => _state != AxeState.Held;

		private bool IsMine => player != null && player.photonView != null && player.photonView.IsMine;

		private Vector3 HeldPosition => axe ? axe.TransformPoint(_balanceLocal) : transform.position;

		private Quaternion HeldRotation => axe ? axe.rotation : transform.rotation;

		private void BeginPasses(Vector3 normal)
		{
			_passCount = 0;
			_passFrame = Time.frameCount;
			_passNormal = normal;
		}

		private void AddPass(Vector3 from, Vector3 to, float radius)
		{
			if (_passCount < _passes.Length)
			{
				_passes[_passCount++] = new Pass
				{
					From = from,
					To = to,
					Radius = radius
				};
			}
		}

		public bool Cleaves(Vector3 a, Vector3 b, float radius, out Vector3 normal)
		{
			normal = _passNormal;
			if (_passFrame != Time.frameCount)
			{
				return false;
			}
			for (int i = 0; i < _passCount; i++)
			{
				Pass pass = _passes[i];
				float num = pass.Radius + radius;
				if (BtmGrabReach.SegmentDistanceSqr(pass.From, pass.To, a, b) <= num * num)
				{
					return true;
				}
			}
			return false;
		}

		private CapsuleCollider BodyOf(MonkeDevNetworkingPlayer p)
		{
			if (_bodies.TryGetValue(p, out CapsuleCollider value) && (bool)value)
			{
				return value;
			}
			value = null;
			CapsuleCollider[] componentsInChildren = p.GetComponentsInChildren<CapsuleCollider>(true);
			foreach (CapsuleCollider capsuleCollider in componentsInChildren)
			{
				if (capsuleCollider.CompareTag("BTMKillTrigger"))
				{
					value = capsuleCollider;
					break;
				}
			}
			_bodies[p] = value;
			return value;
		}

		private static Vector3 ClosestOnSegment(Vector3 a, Vector3 b, Vector3 point)
		{
			Vector3 vector = b - a;
			float sqrMagnitude = vector.sqrMagnitude;
			if (sqrMagnitude < 1E-08f)
			{
				return a;
			}
			float num = Mathf.Clamp01(Vector3.Dot(point - a, vector) / sqrMagnitude);
			return a + vector * num;
		}

		private void UpdateHandBlock(bool block)
		{
			if (!block)
			{
				ReleaseHandBlock();
				return;
			}
			BtmHand btmHand = BtmHands.Of(false);
			LAGrabber lAGrabber = ((btmHand != null) ? btmHand.La : null);
			if (!(lAGrabber == _blockedGrabber))
			{
				ReleaseHandBlock();
				if ((bool)lAGrabber)
				{
					lAGrabber.BlockGrabs(this);
					_blockedGrabber = lAGrabber;
				}
			}
		}

		private void ReleaseHandBlock()
		{
			if ((bool)_blockedGrabber)
			{
				_blockedGrabber.UnblockGrabs(this);
			}
			_blockedGrabber = null;
		}

		private void ShowHint()
		{
			BTMGameManager instance = BTMGameManager.Instance;
			if ((bool)instance && !instance.roomProperties.startTime.Equals(_hintRound))
			{
				_hintRound = instance.roomProperties.startTime;
				if ((bool)BtmSelectedRole.Instance)
				{
					BtmSelectedRole.Instance.ShowNotice(HintText);
				}
			}
		}

		private void Awake()
		{
			if (!player)
			{
				player = GetComponentInParent<MonkeDevNetworkingPlayer>();
			}
			if (!gameModePlayer)
			{
				gameModePlayer = GetComponentInParent<GameModePlayer>();
			}
			if (!axe)
			{
				Debug.LogError("[BtmLumberjackAxe] " + base.name + ": no axe assigned, the throw is off.", this);
				return;
			}
			_heldRenderers = axe.GetComponentsInChildren<Renderer>(true);
			MeasureAxe();
			_ready = true;
		}

		private void OnEnable()
		{
			LAPlayer.Teleported += OnTeleported;
			if (_ready && IsMine && !Owned.Contains(this))
			{
				Owned.Add(this);
			}
		}

		private void OnDisable()
		{
			LAPlayer.Teleported -= OnTeleported;
			Owned.Remove(this);
			ReleaseHandBlock();
			ResetToHand(true);
			ResetOwnerInput();
		}

		private void OnDestroy()
		{
			if ((bool)_flight)
			{
				UnityEngine.Object.Destroy(_flight.gameObject);
			}
		}

		private void LateUpdate()
		{
			if (!_ready)
			{
				return;
			}
			if (IsMine)
			{
				TrackHand();
				TickOwnerInput();
				TickChop();
			}
			Vector3 position = _position;
			if (_state == AxeState.Flying)
			{
				TickFlying();
			}
			else if (_state == AxeState.Returning)
			{
				TickReturning();
			}
			if (_state == AxeState.Flying || _state == AxeState.Returning)
			{
				DrawFlight();
				if (IsMine)
				{
					Sweep(position, _position);
				}
			}
			TickFx();
		}

		private void MeasureAxe()
		{
			MeshFilter component = axe.GetComponent<MeshFilter>();
			Mesh mesh = (component ? component.sharedMesh : null);
			if (!mesh || mesh.subMeshCount == 0)
			{
				_balanceLocal = Vector3.zero;
				return;
			}
			Material[] array = (axe.GetComponent<Renderer>() ? axe.GetComponent<Renderer>().sharedMaterials : null);
			int num = ((mesh.subMeshCount > 1) ? 1 : 0);
			if (array != null)
			{
				for (int i = 0; i < array.Length && i < mesh.subMeshCount; i++)
				{
					if ((bool)array[i] && array[i].name.IndexOf("Metal", StringComparison.OrdinalIgnoreCase) >= 0)
					{
						num = i;
					}
				}
			}
			int index = ((num == 0 && mesh.subMeshCount > 1) ? 1 : 0);
			Bounds bounds = mesh.GetSubMesh(num).bounds;
			Bounds bounds2 = mesh.GetSubMesh(index).bounds;
			Vector3 extents = bounds2.extents;
			Vector3 vector = ((extents.x >= extents.y && extents.x >= extents.z) ? Vector3.right : ((extents.y >= extents.z) ? Vector3.up : Vector3.forward));
			Vector3 vector2 = bounds.center - bounds2.center;
			Vector3 vector3 = vector2 - vector * Vector3.Dot(vector2, vector);
			Vector3 vector4 = ((vector3.sqrMagnitude > 1E-08f) ? vector3.normalized : Vector3.Cross(vector, Vector3.up).normalized);
			Vector3 extents2 = bounds.extents;
			_handleLocal = vector;
			_edgeLocal = vector4;
			_headLocal = bounds.center;
			float num2 = Mathf.Abs(vector4.x) * extents2.x + Mathf.Abs(vector4.y) * extents2.y + Mathf.Abs(vector4.z) * extents2.z;
			_edgeTipLocal = bounds.center + vector4 * num2;
			_headHalfHeightLocal = Mathf.Abs(Vector3.Dot(extents2, vector));
			_balanceLocal = bounds2.center + vector2 * 0.6f;
		}

		public void ReceiveThrow(Vector3 origin, Quaternion rotation, Vector3 velocity, double sentAt)
		{
			if (_ready)
			{
				StartFlight(origin, rotation, velocity, sentAt);
			}
		}

		public void ReceiveStick(Vector3 position, Quaternion rotation)
		{
			if (_ready && _state != AxeState.Returning && (_state != AxeState.Held || !(Time.time - _caughtAt < 0.5f)))
			{
				AxeState state = _state;
				_position = position;
				_rotation = rotation;
				_state = AxeState.Stuck;
				ShowFlight(true);
				DrawFlight();
				if (state != AxeState.Stuck)
				{
					Landed(position);
				}
			}
		}

		public void ReceiveRecall(Vector3 from, Quaternion rotation, double sentAt)
		{
			if (_ready)
			{
				StartReturn(from, rotation, sentAt);
			}
		}

		public void ReceiveCaught()
		{
			if (_ready && _state != AxeState.Held)
			{
				Caught();
			}
		}

		public bool TryGetCurl(bool left, out Vector3 curl)
		{
			curl = Vector3.zero;
			if (left || !_ready)
			{
				return false;
			}
			if (_state == AxeState.Held)
			{
				curl = holdCurl;
				return true;
			}
			return _state == AxeState.Returning;
		}

		public void Chopped(Vector3 point)
		{
			PlayAt(chopClip, point, 1f);
		}

		private void StartFlight(Vector3 origin, Quaternion rotation, Vector3 velocity, double sentAt)
		{
			_throwTime = sentAt;
			_state = AxeState.Flying;
			_origin = origin;
			_startRotation = rotation;
			_velocity = velocity;
			_spinAxis = BtmAxeRules.SpinAxis(velocity);
			_spinRate = velocity.magnitude * 22f + 560f;
			_position = origin;
			_rotation = rotation;
			_victims.Clear();
			ShowFlight(true);
			DrawFlight();
			PlayAt(throwClip, origin, 0.9f);
			StartSpin(_spinRate);
		}

		private void StartReturn(Vector3 from, Quaternion rotation, double sentAt)
		{
			AxeState state = _state;
			_state = AxeState.Returning;
			_returnTime = sentAt;
			_returnFrom = from;
			_returnRotation = rotation;
			_position = from;
			_rotation = rotation;
			Vector3 vector = HeldPosition - from;
			_returnSeconds = Mathf.Clamp(vector.magnitude / 21f, 0.32f, 1.25f);
			_returnAxis = BtmAxeRules.SpinAxis(vector);
			_returnSpin = -1022f;
			ShowFlight(true);
			DrawFlight();
			Recalled(from, state == AxeState.Stuck);
		}

		private void Caught()
		{
			_state = AxeState.Held;
			_caughtAt = Time.time;
			ShowFlight(false);
			ShowHeld(true);
			CaughtFx();
		}

		private void ResetToHand(bool silent)
		{
			_state = AxeState.Held;
			ShowFlight(false);
			ShowHeld(true);
			if (!silent)
			{
				CaughtFx();
			}
			StopSpin();
			_secondPulseAt = -1f;
		}

		private void ShowHeld(bool shown)
		{
			Renderer[] heldRenderers = _heldRenderers;
			foreach (Renderer renderer in heldRenderers)
			{
				if ((bool)renderer)
				{
					renderer.forceRenderingOff = !shown;
				}
			}
		}

		private void OnTeleported(LAPlayer rig)
		{
			_handSamples.Clear();
			_chopReady = false;
		}
	}
}
