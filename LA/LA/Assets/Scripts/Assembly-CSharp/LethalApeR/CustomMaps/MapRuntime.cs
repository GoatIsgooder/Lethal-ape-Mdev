using System.Collections.Generic;
using System.IO;
using ExitGames.Client.Photon;
using GorillaLocomotion;
using LethalApe.SDK;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.SpiderApe;
using Locomotion.Scripts;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[DefaultExecutionOrder(-190)]
	public sealed class MapRuntime : MonoBehaviourPunCallbacks, IOnEventCallback
	{
		private sealed class AudioZoneState
		{
			public AudioZone Zone;

			public AudioSource Source;

			public float Level;

			public bool Inside;

			public float EnteredAt;
		}

		private sealed class ButtonState
		{
			public MapButton Button;

			public bool Toggled;

			public float ReadyAt;

			public float PressedAt = -10f;

			public Vector3 VisualRest;

			public bool Networked;
		}

		private sealed class LadderHold
		{
			public GrabInteractor Hand;

			public Transform Anchor;

			public Vector3 LocalPoint;

			public Vector3 PalmOffset;
		}

		private sealed class DoorState
		{
			public Door Door;

			public Vector3 ClosedPos;

			public Quaternion ClosedRot;

			public Vector3 OpenPos;

			public Quaternion OpenRot;

			public bool Open;

			public int ChangedMs;

			public AudioSource Audio;
		}

		private sealed class TriggerState
		{
			public LogicTrigger Trigger;

			public bool Inside;

			public float ReadyAt;

			public bool Fired;

			public float NextTimer;
		}

		private struct PendingAction
		{
			public float Due;

			public LogicAction Action;

			public int Activator;

			public bool LocalScope;
		}

		private sealed class Tween
		{
			public Transform Target;

			public Vector3 FromPos;

			public Vector3 ToPos;

			public Quaternion FromRot;

			public Quaternion ToRot;

			public float Start;

			public float Duration;
		}

		private enum Op : byte
		{
			RequestTrigger = 1,
			RunTrigger = 2,
			RequestButton = 3,
			ButtonState = 4,
			DoorState = 5,
			PlatformState = 6,
			RequestSnapshot = 7,
			Snapshot = 8,
			RaceResult = 9
		}

		private sealed class PlatformState
		{
			public LethalApe.SDK.MovingPlatform Source;

			public GorillaLocomotion.MovingPlatform Mover;

			public Quaternion BaseRotation;

			public bool Running;

			public double Offset;

			public double Since;
		}

		private sealed class RaceState
		{
			public RaceCourse Course;

			public bool Running;

			public float StartedAt;

			public int NextCheckpoint;

			public bool InStart;

			public bool InFinish;

			public bool[] InCheckpoint;

			public readonly List<RaceResult> Results = new List<RaceResult>();
		}

		private struct RaceResult
		{
			public string Name;

			public int Ms;
		}

		private const string MusicVolumeKey = "AudioManager_Volume_MusicVol";

		private AudioZoneState[] _audioZones;

		private float _musicVolume = 1f;

		private float _nextMusicVolumeRead;

		private const float PressAnimSeconds = 0.18f;

		private ButtonState[] _buttons;

		private const float LadderReach = 0.07f;

		private const float LadderPull = 22f;

		private const float LadderMaxSpeed = 6f;

		private const float LadderReleaseKeep = 0.9f;

		private const float GripDown = 0.7f;

		private const float GripUp = 0.58f;

		private readonly HashSet<Surface> _slippery = new HashSet<Surface>();

		private readonly List<Collider> _ladderColliders = new List<Collider>();

		private readonly LadderHold[] _ladderHolds = new LadderHold[2];

		private readonly bool[] _gripWasDown = new bool[4];

		private GrabInteractor[] _hands = new GrabInteractor[0];

		private float _nextHandScan;

		private Vector3 _ladderVelocity;

		private DoorState[] _doors;

		private TriggerState[] _triggers;

		private readonly List<PendingAction> _pending = new List<PendingAction>();

		private readonly List<Tween> _tweens = new List<Tween>();

		private bool _startedFired;

		private readonly List<GameObject> _tracked = new List<GameObject>();

		private readonly Dictionary<GameObject, int> _trackedIndex = new Dictionary<GameObject, int>();

		private const float MaxPlayerSpeed = 25f;

		private const float LaunchAssertSeconds = 0.3f;

		private const float SwimAcceleration = 2.5f;

		private const float StrokeDeadzone = 0.45f;

		private float _baseSpeedMultiplier = 1f;

		private bool _launching;

		private Vector3 _launchVelocity;

		private float _launchStart;

		private Vector3 _launchFrom;

		private WaterVolume[] _waters;

		private WaterVolume _water;

		private float _submersion;

		private bool _headUnder;

		private bool _wasInWater;

		private AudioLowPassFilter _lowPass;

		private bool _addedLowPass;

		private Vector3 _prevLeft;

		private Vector3 _prevRight;

		private bool _havePrevHands;

		private Vector3 _strokeDelta;

		private SpiderApeWebShooter[] _webShooters;

		private readonly List<SpiderApeWebShooter> _suspendedShooters = new List<SpiderApeWebShooter>(2);

		public const byte EventCode = 131;

		private static readonly RaiseEventOptions ToMaster = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.MasterClient
		};

		private static readonly RaiseEventOptions ToOthers = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.Others
		};

		private bool _ready;

		private float _snapshotRetryAt;

		private float _snapshotGiveUpAt;

		private PlatformState[] _platforms;

		private const float MinLapSeconds = 3f;

		private RaceState[] _races;

		private TextMeshPro _wristText;

		private RaceState _wristRace;

		private int _wristShownTenths = -1;

		private const byte SnapshotVersion = 1;

		private TextSign[] _signList = new TextSign[0];

		private const float ToastSeconds = 3.2f;

		private const float ToastDistance = 1.4f;

		private const float ToastFadeIn = 0.15f;

		private const float ToastFadeOut = 0.4f;

		private readonly Dictionary<TextSign, TextMeshPro> _signs = new Dictionary<TextSign, TextMeshPro>();

		private static float _capHeightPerPoint;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private TextMeshPro _toast;

		private MeshRenderer _toastPanel;

		private Color _toastPanelColor;

		private MaterialPropertyBlock _toastBlock;

		private float _toastShownAt;

		private float _toastUntil;

		private float _toastAlpha = -1f;

		private Vector3 _toastVelocity;

		private KillZone[] _kills;

		private Checkpoint[] _checkpoints;

		private Teleporter[] _teleporters;

		private JumpPad[] _pads;

		private SpeedZone[] _speedZones;

		private GravityZone[] _gravityZones;

		private bool[] _checkpointInside;

		private bool[] _teleporterInside;

		private bool[] _padInside;

		private bool[] _speedInside;

		private bool[] _gravityInside;

		private float[] _teleporterReady;

		private float[] _padReady;

		private Checkpoint _checkpoint;

		private SpeedZone _activeSpeed;

		private GravityZone _activeGravity;

		private Vector3 _head;

		private Vector3 _body;

		private Vector3 _leftHand;

		private Vector3 _rightHand;

		private CustomMapHost _host;

		private LoadedMap _map;

		private MapFeatureAssets _assets;

		private AudioSource _sfx;

		private bool _shutdown;

		private SpawnPoint[] _spawns;

		public LoadedMap Map => _map;

		public string MapKey => _map != null ? _map.Key : "";

		private static bool PlayerCanMove => MapPlayer.Ready && !GorillaLocomotion.Player.Instance.disableMovement;

		private static int LocalActor => PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : 0;

		private static bool IsMaster => !PhotonNetwork.InRoom || PhotonNetwork.IsMasterClient;

		private static int NowMs => PlatformClock.NowMs;

		private void InitAudio()
		{
			AudioZone[] zones = Collect<AudioZone>();
			_audioZones = new AudioZoneState[zones.Length];
			for (int i = 0; i < zones.Length; i++)
			{
				AudioSource source = zones[i].gameObject.AddComponent<AudioSource>();
				source.clip = zones[i].Clip;
				source.loop = true;
				source.playOnAwake = false;
				source.spatialBlend = 0f;
				source.spatialize = false;
				source.volume = 0f;
				source.priority = 64;
				_audioZones[i] = new AudioZoneState
				{
					Zone = zones[i],
					Source = source
				};
			}
		}

		private void ShutdownAudio()
		{
			if (_audioZones == null)
			{
				return;
			}
			for (int i = 0; i < _audioZones.Length; i++)
			{
				AudioZoneState s = _audioZones[i];
				if (s.Source != null)
				{
					s.Source.Stop();
				}
			}
		}

		private void UpdateAudio()
		{
			if (_audioZones.Length == 0)
			{
				return;
			}
			float now = Time.time;
			if (now >= _nextMusicVolumeRead)
			{
				_musicVolume = Mathf.Clamp01(PlayerPrefs.GetFloat(MusicVolumeKey, 100f) / 100f);
				_nextMusicVolumeRead = now + 1f;
			}
			AudioZoneState music = null;
			for (int i = 0; i < _audioZones.Length; i++)
			{
				AudioZoneState s = _audioZones[i];
				bool inside = s.Zone.isActiveAndEnabled && MapPlayer.Ready && s.Zone.Contains(_head);
				if (inside && !s.Inside)
				{
					s.EnteredAt = now;
				}
				s.Inside = inside;
				if (inside && s.Zone.Layer == AudioZoneLayer.Music && (music == null || s.EnteredAt > music.EnteredAt))
				{
					music = s;
				}
			}
			float dt = Time.deltaTime;
			for (int j = 0; j < _audioZones.Length; j++)
			{
				AudioZoneState s = _audioZones[j];
				if (s.Source == null || s.Zone.Clip == null)
				{
					continue;
				}
				float target = (s.Zone.Layer == AudioZoneLayer.Music) ? ((s == music) ? 1f : 0f) : (s.Inside ? 1f : 0f);
				s.Level = Mathf.MoveTowards(s.Level, target, dt / Mathf.Max(s.Zone.FadeSeconds, 0.05f));
				float scale = (s.Zone.Layer == AudioZoneLayer.Music) ? _musicVolume : 1f;
				s.Source.volume = s.Zone.Volume * s.Level * scale;
				if (s.Level > 0f && !s.Source.isPlaying)
				{
					s.Source.Play();
				}
				else if (s.Level <= 0f && s.Source.isPlaying)
				{
					s.Source.Stop();
				}
			}
		}

		private void InitButtons()
		{
			MapButton[] buttons = Collect<MapButton>();
			_buttons = new ButtonState[buttons.Length];
			for (int i = 0; i < buttons.Length; i++)
			{
				MapButton button = buttons[i];
				GameObject go = new GameObject("Press Area");
				go.layer = 2;
				go.transform.SetParent(button.transform, false);
				go.transform.localPosition = button.PressCenter;
				BoxCollider box = go.AddComponent<BoxCollider>();
				box.isTrigger = true;
				Vector3 size = button.PressSize;
				box.size = new Vector3(Mathf.Max(size.x, 0.02f), Mathf.Max(size.y, 0.02f), Mathf.Max(size.z, 0.02f));
				go.AddComponent<MapButtonTrigger>().Bind(this, i);
				_buttons[i] = new ButtonState
				{
					Button = button,
					VisualRest = (button.PressVisual != null) ? button.PressVisual.localPosition : Vector3.zero
				};
			}
		}

		private void ResolveButtonNetworking()
		{
			for (int i = 0; i < _buttons.Length; i++)
			{
				ButtonState s = _buttons[i];
				bool networked = s.Button.Scope == LogicScope.Everyone;
				for (int d = 0; d < _doors.Length; d++)
				{
					MapButton[] doorButtons = _doors[d].Door.Buttons;
					for (int k = 0; k < doorButtons.Length; k++)
					{
						networked |= doorButtons[k] == s.Button;
					}
				}
				for (int t = 0; t < _triggers.Length; t++)
				{
					LogicTrigger trigger = _triggers[t].Trigger;
					if (trigger.Trigger == LogicTriggerType.ButtonPressed && trigger.Button == s.Button)
					{
						networked |= trigger.Scope == LogicScope.Everyone;
					}
				}
				s.Networked = networked;
			}
		}

		public void OnLocalButtonPress(int index, bool isLeft)
		{
			if (index < 0 || _shutdown || index >= _buttons.Length || !PlayerCanMove)
			{
				return;
			}
			ButtonState s = _buttons[index];
			if (Time.time < s.ReadyAt)
			{
				return;
			}
			s.ReadyAt = Time.time + Mathf.Max(s.Button.Cooldown, 0.1f);
			s.PressedAt = Time.time;
			Play((s.Button.PressSound != null) ? s.Button.PressSound : ((_assets != null) ? _assets.buttonClick : null));
			FireButtonTriggers(s.Button, LogicScope.LocalPlayer, LocalActor);
			if (s.Networked)
			{
				if (IsMaster)
				{
					MasterButton(index, LocalActor);
				}
				else
				{
					SendButtonRequest(index);
				}
			}
			else if (s.Button.Toggle)
			{
				s.Toggled = !s.Toggled;
			}
		}

		private void MasterButton(int index, int actor)
		{
			ButtonState s = _buttons[index];
			if (s.Button.Toggle)
			{
				s.Toggled = !s.Toggled;
			}
			SendButtonState(index, s.Toggled, actor);
			for (int i = 0; i < _doors.Length; i++)
			{
				MapButton[] doorButtons = _doors[i].Door.Buttons;
				for (int k = 0; k < doorButtons.Length; k++)
				{
					if (doorButtons[k] == s.Button)
					{
						SetDoor(i, !_doors[i].Open, true);
						break;
					}
				}
			}
			FireButtonTriggers(s.Button, LogicScope.Everyone, actor);
		}

		private void ApplyButtonState(int index, bool toggled, int actor)
		{
			if (index < 0 || index >= _buttons.Length)
			{
				return;
			}
			ButtonState s = _buttons[index];
			s.Toggled = toggled;
			if (actor != LocalActor)
			{
				s.PressedAt = Time.time;
			}
		}

		private void UpdateButtons()
		{
			float now = Time.time;
			for (int i = 0; i < _buttons.Length; i++)
			{
				ButtonState s = _buttons[i];
				Transform visual = s.Button.PressVisual;
				if (visual == null)
				{
					continue;
				}
				float depth = (s.Button.Toggle && s.Toggled) ? 0.6f : 0f;
				float t = (now - s.PressedAt) / PressAnimSeconds;
				if (t < 1f)
				{
					depth = Mathf.Max(depth, Mathf.Sin(Mathf.Clamp01(t) * Mathf.PI));
				}
				visual.localPosition = s.VisualRest + Vector3.back * (depth * s.Button.PressDepth);
			}
		}

		private void InitClimb()
		{
			ClimbSurface[] surfaces = Collect<ClimbSurface>();
			for (int i = 0; i < surfaces.Length; i++)
			{
				ClimbSurface surface = surfaces[i];
				Collider[] colliders = surface.GetComponentsInChildren<Collider>(true);
				for (int j = 0; j < colliders.Length; j++)
				{
					Collider c = colliders[j];
					if (c.isTrigger)
					{
						continue;
					}
					switch (surface.Type)
					{
					case ClimbSurfaceType.Slippery:
						_slippery.Add(SurfaceOn(c.gameObject));
						break;
					case ClimbSurfaceType.Bouncy:
					{
						Surface s = SurfaceOn(c.gameObject);
						float bounce = Mathf.Clamp(surface.Bounce, 1f, 3f);
						s.extraVelMultiplier = bounce;
						s.extraVelMaxMultiplier = bounce;
						break;
					}
					case ClimbSurfaceType.NotClimbable:
						c.gameObject.layer = 2;
						break;
					case ClimbSurfaceType.Ladder:
						_ladderColliders.Add(c);
						break;
					}
				}
			}
		}

		private static Surface SurfaceOn(GameObject go)
		{
			Surface surface = go.GetComponent<Surface>();
			if (surface != null)
			{
				return surface;
			}
			return go.AddComponent<Surface>();
		}

		private void ShutdownClimb()
		{
			_ladderHolds[0] = _ladderHolds[1] = null;
		}

		private void UpdateClimb()
		{
			if (!MapPlayer.Ready)
			{
				return;
			}
			if (_slippery.Count > 0)
			{
				GorillaLocomotion.Player player = GorillaLocomotion.Player.Instance;
				bool left = player.wasLeftHandTouching && player.leftHandSurfaceOverride != null && _slippery.Contains(player.leftHandSurfaceOverride);
				bool right = player.wasRightHandTouching && player.rightHandSurfaceOverride != null && _slippery.Contains(player.rightHandSurfaceOverride);
				if (left || right)
				{
					player.SetMaximumSlipThisFrame();
				}
			}
			if (_ladderColliders.Count > 0)
			{
				UpdateLadderGrips();
			}
		}

		private void UpdateLadderGrips()
		{
			VRInputController input = VRInputController.Instance;
			bool canGrip = PlayerCanMove && input != null;
			GrabInteractor[] hands = Hands();
			for (int i = 0; i < _ladderHolds.Length; i++)
			{
				LadderHold hold = _ladderHolds[i];
				if (hold != null && (!canGrip || hold.Hand == null || hold.Hand.palm == null || hold.Anchor == null || hold.Hand.IsGrabbing || Grip(input, hold.Hand) < GripUp))
				{
					ReleaseLadder(i);
				}
			}
			for (int j = 0; j < hands.Length && j < _gripWasDown.Length; j++)
			{
				GrabInteractor hand = hands[j];
				if (hand == null || hand.palm == null)
				{
					continue;
				}
				if (!canGrip || Grip(input, hand) < GripDown)
				{
					_gripWasDown[j] = false;
					continue;
				}
				bool wasDown = _gripWasDown[j];
				_gripWasDown[j] = true;
				if (!wasDown && !hand.IsGrabbing && !HoldingLadder(hand))
				{
					TryGrabLadder(hand);
				}
			}
		}

		private void TryGrabLadder(GrabInteractor hand)
		{
			Vector3 palm = hand.palm.position;
			foreach (Collider c in _ladderColliders)
			{
				if (c == null || !c.enabled || !c.gameObject.activeInHierarchy)
				{
					continue;
				}
				Vector3 closest = c.ClosestPoint(palm);
				if ((closest - palm).sqrMagnitude > LadderReach * LadderReach)
				{
					continue;
				}
				int slot = (_ladderHolds[0] == null) ? 0 : ((_ladderHolds[1] == null) ? 1 : (-1));
				if (slot < 0)
				{
					return;
				}
				_ladderHolds[slot] = new LadderHold
				{
					Hand = hand,
					Anchor = c.transform,
					LocalPoint = c.transform.InverseTransformPoint(closest),
					PalmOffset = palm - closest
				};
				Haptic(0.2f, 0.04f);
				return;
			}
		}

		private void ReleaseLadder(int slot)
		{
			_ladderHolds[slot] = null;
			if (_ladderHolds[0] == null && _ladderHolds[1] == null)
			{
				Rigidbody body = MapPlayer.Body;
				if (body != null && !body.isKinematic && PlayerCanMove)
				{
					body.linearVelocity = _ladderVelocity * LadderReleaseKeep;
				}
				_ladderVelocity = Vector3.zero;
			}
		}

		private void FixedLadder()
		{
			if (_ladderHolds[0] == null && _ladderHolds[1] == null)
			{
				return;
			}
			Rigidbody body = MapPlayer.Body;
			if (body == null || body.isKinematic || !PlayerCanMove)
			{
				return;
			}
			Vector3 sum = Vector3.zero;
			int count = 0;
			for (int i = 0; i < _ladderHolds.Length; i++)
			{
				LadderHold hold = _ladderHolds[i];
				if (hold != null && !(hold.Hand == null) && !(hold.Hand.palm == null) && !(hold.Anchor == null))
				{
					Vector3 target = hold.Anchor.TransformPoint(hold.LocalPoint) + hold.PalmOffset;
					sum += target - hold.Hand.palm.position;
					count++;
				}
			}
			if (count != 0)
			{
				Vector3 velocity = Vector3.ClampMagnitude(sum / count * LadderPull, LadderMaxSpeed);
				velocity -= Physics.gravity * (CurrentGravityScale() * Time.fixedDeltaTime);
				body.linearVelocity = velocity;
				_ladderVelocity = velocity;
			}
		}

		private bool HoldingLadder(GrabInteractor hand)
		{
			if (_ladderHolds[0] != null && _ladderHolds[0].Hand == hand)
			{
				return true;
			}
			if (_ladderHolds[1] != null)
			{
				return _ladderHolds[1].Hand == hand;
			}
			return false;
		}

		private static float Grip(VRInputController input, GrabInteractor hand)
		{
			if (input == null || hand == null)
			{
				return 0f;
			}
			return (hand.node == UnityEngine.XR.XRNode.LeftHand) ? input.LeftGripValue : input.RightGripValue;
		}

		private GrabInteractor[] Hands()
		{
			if (Time.time < _nextHandScan)
			{
				return _hands;
			}
			bool rescan = _hands.Length == 0;
			for (int i = 0; i < _hands.Length; i++)
			{
				if (_hands[i] == null)
				{
					rescan = true;
					break;
				}
			}
			if (rescan)
			{
				_hands = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			}
			_nextHandScan = Time.time + ((_hands.Length == 0) ? 1f : 2f);
			return _hands;
		}

		private void InitDoors()
		{
			Door[] doors = Collect<Door>();
			_doors = new DoorState[doors.Length];
			for (int i = 0; i < doors.Length; i++)
			{
				Door door = doors[i];
				Transform t = door.transform;
				DoorState s = new DoorState();
				s.Door = door;
				s.ClosedPos = t.localPosition;
				s.ClosedRot = t.localRotation;
				s.OpenPos = t.localPosition + door.OpenPositionOffset;
				s.OpenRot = t.localRotation * Quaternion.Euler(door.OpenRotationOffset);
				s.Open = door.StartOpen;
				s.ChangedMs = NowMs - 100000;
				if (door.GetComponent<Rigidbody>() == null)
				{
					Rigidbody rb = door.gameObject.AddComponent<Rigidbody>();
					rb.isKinematic = true;
					rb.useGravity = false;
					rb.interpolation = RigidbodyInterpolation.None;
				}
				if (door.OpenSound != null || door.CloseSound != null)
				{
					s.Audio = door.gameObject.AddComponent<AudioSource>();
					s.Audio.playOnAwake = false;
					s.Audio.spatialBlend = 1f;
					s.Audio.spatialize = false;
					s.Audio.rolloffMode = AudioRolloffMode.Linear;
					s.Audio.maxDistance = 25f;
				}
				_doors[i] = s;
				Pose(s, 1f);
			}
		}

		private void UpdateDoors()
		{
			int now = NowMs;
			for (int i = 0; i < _doors.Length; i++)
			{
				DoorState s = _doors[i];
				if (s.Door == null)
				{
					continue;
				}
				float duration = Mathf.Max(s.Door.Duration, 0.05f);
				float t = Mathf.Clamp01((float)(now - s.ChangedMs) / (duration * 1000f));
				Pose(s, t);
				if (s.Open && s.Door.AutoCloseSeconds > 0f && IsMaster && (float)(now - s.ChangedMs) > (duration + s.Door.AutoCloseSeconds) * 1000f)
				{
					SetDoor(i, false, true);
				}
			}
		}

		private static void Pose(DoorState s, float t)
		{
			float k = t * t * (3f - 2f * t);
			Transform transform = s.Door.transform;
			if (s.Open)
			{
				transform.localPosition = Vector3.LerpUnclamped(s.ClosedPos, s.OpenPos, k);
				transform.localRotation = Quaternion.SlerpUnclamped(s.ClosedRot, s.OpenRot, k);
			}
			else
			{
				transform.localPosition = Vector3.LerpUnclamped(s.OpenPos, s.ClosedPos, k);
				transform.localRotation = Quaternion.SlerpUnclamped(s.OpenRot, s.ClosedRot, k);
			}
		}

		private void SetDoor(int index, bool open, bool broadcast)
		{
			if (index < 0 || index >= _doors.Length)
			{
				return;
			}
			DoorState s = _doors[index];
			if (s.Open != open)
			{
				int now = NowMs;
				float duration = Mathf.Max(s.Door.Duration, 0.05f) * 1000f;
				float t = Mathf.Clamp01((float)(now - s.ChangedMs) / duration);
				s.Open = open;
				s.ChangedMs = now - Mathf.RoundToInt(duration * (1f - t));
				PlayDoorSound(s);
				if (broadcast)
				{
					SendDoorState(index, s.Open, s.ChangedMs);
				}
			}
		}

		private void ApplyDoorState(int index, bool open, int changedMs, bool sound)
		{
			if (index < 0 || index >= _doors.Length)
			{
				return;
			}
			DoorState s = _doors[index];
			bool wasOpen = s.Open;
			s.ChangedMs = changedMs;
			s.Open = open;
			if (wasOpen != open && sound)
			{
				PlayDoorSound(s);
			}
		}

		private static void PlayDoorSound(DoorState s)
		{
			if (!(s.Audio == null))
			{
				AudioClip clip = s.Open ? s.Door.OpenSound : s.Door.CloseSound;
				if (clip != null)
				{
					s.Audio.PlayOneShot(clip);
				}
			}
		}

		private int DoorIndex(Door door)
		{
			for (int i = 0; i < _doors.Length; i++)
			{
				if (_doors[i].Door == door)
				{
					return i;
				}
			}
			return -1;
		}

		private void InitLogic()
		{
			LogicTrigger[] triggers = Collect<LogicTrigger>();
			_triggers = new TriggerState[triggers.Length];
			float now = Time.time;
			for (int i = 0; i < triggers.Length; i++)
			{
				_triggers[i] = new TriggerState
				{
					Trigger = triggers[i],
					NextTimer = now + Mathf.Max(triggers[i].Interval, 0.5f)
				};
				LogicAction[] actions = triggers[i].Actions;
				if (actions == null)
				{
					continue;
				}
				foreach (LogicAction action in actions)
				{
					if (action != null && action.target != null && !_trackedIndex.ContainsKey(action.target))
					{
						_trackedIndex[action.target] = _tracked.Count;
						_tracked.Add(action.target);
					}
				}
			}
			ResolveButtonNetworking();
		}

		private void StartLogic()
		{
			for (int i = 0; i < _triggers.Length; i++)
			{
				LogicTrigger trigger = _triggers[i].Trigger;
				if (trigger.Trigger == LogicTriggerType.MapStarted)
				{
					if (trigger.Scope == LogicScope.LocalPlayer)
					{
						RunTrigger(i, LocalActor, true);
					}
					else if (IsMaster && !_startedFired)
					{
						MasterRunTrigger(i, -1);
					}
				}
			}
			if (IsMaster)
			{
				_startedFired = true;
			}
		}

		private void UpdateLogicZones()
		{
			for (int i = 0; i < _triggers.Length; i++)
			{
				TriggerState s = _triggers[i];
				if (s.Trigger.Trigger != LogicTriggerType.PlayerEnters && s.Trigger.Trigger != LogicTriggerType.PlayerExits)
				{
					continue;
				}
				if (s.Trigger.isActiveAndEnabled && HeadOrBody(s.Trigger))
				{
					bool wasInside = s.Inside;
					s.Inside = true;
					if (!wasInside && s.Trigger.Trigger == LogicTriggerType.PlayerEnters)
					{
						Fire(i, LocalActor);
					}
				}
				else
				{
					bool wasInside2 = s.Inside;
					s.Inside = false;
					if (wasInside2 && s.Trigger.Trigger == LogicTriggerType.PlayerExits)
					{
						Fire(i, LocalActor);
					}
				}
			}
		}

		private void UpdateLogic()
		{
			float now = Time.time;
			if (_ready)
			{
				for (int i = 0; i < _triggers.Length; i++)
				{
					TriggerState s = _triggers[i];
					if (s.Trigger.Trigger != LogicTriggerType.Timer || now < s.NextTimer)
					{
						continue;
					}
					if (s.Trigger.Scope == LogicScope.Everyone && !IsMaster)
					{
						s.NextTimer = now + s.Trigger.Interval;
						continue;
					}
					s.NextTimer = s.Trigger.Repeat ? (now + Mathf.Max(s.Trigger.Interval, 0.5f)) : float.MaxValue;
					if (s.Trigger.Scope != LogicScope.LocalPlayer)
					{
						MasterRunTrigger(i, -1);
					}
					else
					{
						RunTrigger(i, LocalActor, true);
					}
				}
			}
			for (int j = _pending.Count - 1; j >= 0; j--)
			{
				if (!(now < _pending[j].Due))
				{
					PendingAction pending = _pending[j];
					_pending.RemoveAt(j);
					Execute(pending.Action, pending.Activator, pending.LocalScope);
				}
			}
			for (int k = _tweens.Count - 1; k >= 0; k--)
			{
				Tween tween = _tweens[k];
				if (tween.Target == null)
				{
					_tweens.RemoveAt(k);
					continue;
				}
				float t = (tween.Duration > 0f) ? Mathf.Clamp01((now - tween.Start) / tween.Duration) : 1f;
				float eased = t * t * (3f - 2f * t);
				tween.Target.localPosition = Vector3.LerpUnclamped(tween.FromPos, tween.ToPos, eased);
				tween.Target.localRotation = Quaternion.SlerpUnclamped(tween.FromRot, tween.ToRot, eased);
				if (t >= 1f)
				{
					_tweens.RemoveAt(k);
				}
			}
		}

		private void FireButtonTriggers(MapButton button, LogicScope scope, int actor)
		{
			for (int i = 0; i < _triggers.Length; i++)
			{
				LogicTrigger trigger = _triggers[i].Trigger;
				if (trigger.Trigger == LogicTriggerType.ButtonPressed && !(trigger.Button != button) && trigger.Scope == scope)
				{
					if (scope != LogicScope.LocalPlayer)
					{
						MasterRunTrigger(i, actor);
					}
					else
					{
						Fire(i, actor);
					}
				}
			}
		}

		private void FireRaceTriggers(RaceCourse race)
		{
			for (int i = 0; i < _triggers.Length; i++)
			{
				LogicTrigger trigger = _triggers[i].Trigger;
				if (trigger.Trigger == LogicTriggerType.RaceFinished && trigger.Race == race)
				{
					Fire(i, LocalActor);
				}
			}
		}

		private void Fire(int index, int activator)
		{
			TriggerState s = _triggers[index];
			if ((s.Trigger.OnceOnly && s.Fired) || Time.time < s.ReadyAt)
			{
				return;
			}
			s.ReadyAt = Time.time + s.Trigger.Cooldown;
			if (s.Trigger.Scope == LogicScope.LocalPlayer)
			{
				s.Fired = true;
				RunTrigger(index, activator, true);
			}
			else if (IsMaster)
			{
				MasterRunTrigger(index, activator);
			}
			else
			{
				SendTriggerRequest(index);
			}
		}

		private void MasterRunTrigger(int index, int activator)
		{
			TriggerState s = _triggers[index];
			if (!s.Trigger.OnceOnly || !s.Fired)
			{
				s.Fired = true;
				SendRunTrigger(index, activator);
				RunTrigger(index, activator, false);
			}
		}

		private void RunTrigger(int index, int activator, bool localScope)
		{
			LogicAction[] actions = _triggers[index].Trigger.Actions;
			if (actions == null)
			{
				return;
			}
			float now = Time.time;
			foreach (LogicAction action in actions)
			{
				if (action == null)
				{
					continue;
				}
				if (action.delay > 0f)
				{
					_pending.Add(new PendingAction
					{
						Due = now + action.delay,
						Action = action,
						Activator = activator,
						LocalScope = localScope
					});
				}
				else
				{
					Execute(action, activator, localScope);
				}
			}
		}

		private void Execute(LogicAction a, int activator, bool localScope)
		{
			if (a == null)
			{
				return;
			}
			bool affectsMe = activator < 0 || a.allPlayers || LocalActor == activator;
			switch (a.type)
			{
			case LogicActionType.EnableObject:
				SetActive(a.target, true);
				break;
			case LogicActionType.DisableObject:
				SetActive(a.target, false);
				break;
			case LogicActionType.ToggleObject:
				if (a.target != null)
				{
					SetActive(a.target, !a.target.activeSelf);
				}
				break;
			case LogicActionType.MoveObject:
				if (a.target != null && a.destination != null)
				{
					MoveTo(a.target.transform, a.destination.position, a.destination.rotation, a.duration);
				}
				break;
			case LogicActionType.RotateObject:
				if (a.target != null)
				{
					RotateBy(a.target.transform, a.vector, a.duration);
				}
				break;
			case LogicActionType.PlaySound:
				PlayAt(a.sound, a.volume, a.target);
				break;
			case LogicActionType.TeleportPlayer:
				if (affectsMe && a.destination != null)
				{
					MapPlayer.TeleportFeet(a.destination.position, a.destination.eulerAngles.y);
				}
				break;
			case LogicActionType.LaunchPlayer:
				if (affectsMe)
				{
					Launch(a.vector, false);
				}
				break;
			case LogicActionType.RespawnPlayer:
				if (affectsMe)
				{
					Respawn();
				}
				break;
			case LogicActionType.OpenDoor:
				DoorAction(a.door, true, false, localScope);
				break;
			case LogicActionType.CloseDoor:
				DoorAction(a.door, false, false, localScope);
				break;
			case LogicActionType.ToggleDoor:
				DoorAction(a.door, false, true, localScope);
				break;
			case LogicActionType.StartPlatform:
				PlatformAction(a.platform, true, localScope);
				break;
			case LogicActionType.StopPlatform:
				PlatformAction(a.platform, false, localScope);
				break;
			case LogicActionType.SetSignText:
				if (a.sign != null)
				{
					SetSignText(a.sign, a.text);
				}
				break;
			case LogicActionType.ShowMessage:
				Toast(a.text);
				break;
			}
		}

		private void DoorAction(Door door, bool open, bool toggle, bool localScope)
		{
			int index = DoorIndex(door);
			if (index < 0)
			{
				return;
			}
			if (toggle)
			{
				open = !_doors[index].Open;
			}
			if (localScope || IsMaster)
			{
				SetDoor(index, open, !localScope);
			}
		}

		private void PlatformAction(LethalApe.SDK.MovingPlatform platform, bool run, bool localScope)
		{
			int index = PlatformIndex(platform);
			if (index < 0)
			{
				return;
			}
			if (localScope || IsMaster)
			{
				SetPlatformRunning(index, run, !localScope);
			}
		}

		private void SetActive(GameObject go, bool active)
		{
			if (go == null || go.GetComponent<MapDescriptor>() != null)
			{
				return;
			}
			go.SetActive(active);
		}

		private void MoveTo(Transform target, Vector3 worldPos, Quaternion worldRot, float duration)
		{
			Transform parent = target.parent;
			Vector3 toPos = (parent != null) ? parent.InverseTransformPoint(worldPos) : worldPos;
			Quaternion toRot = (parent != null) ? (Quaternion.Inverse(parent.rotation) * worldRot) : worldRot;
			StartTween(target, toPos, toRot, duration);
		}

		private void RotateBy(Transform target, Vector3 euler, float duration)
		{
			Quaternion endRot = TweenEndRotation(target);
			Vector3 endPos = TweenEndPosition(target);
			StartTween(target, endPos, endRot * Quaternion.Euler(euler), duration);
		}

		private void StartTween(Transform target, Vector3 toPos, Quaternion toRot, float duration)
		{
			_tweens.RemoveAll((Tween t) => t.Target == target);
			_tweens.Add(new Tween
			{
				Target = target,
				FromPos = target.localPosition,
				ToPos = toPos,
				FromRot = target.localRotation,
				ToRot = toRot,
				Start = Time.time,
				Duration = Mathf.Max(0f, duration)
			});
		}

		private Vector3 TweenEndPosition(Transform t)
		{
			foreach (Tween tween in _tweens)
			{
				if (tween.Target == t)
				{
					return tween.ToPos;
				}
			}
			return t.localPosition;
		}

		private Quaternion TweenEndRotation(Transform t)
		{
			foreach (Tween tween in _tweens)
			{
				if (tween.Target == t)
				{
					return tween.ToRot;
				}
			}
			return t.localRotation;
		}

		private void PlayAt(AudioClip clip, float volume, GameObject where)
		{
			if (clip == null)
			{
				return;
			}
			if (where == null)
			{
				Play(clip, volume);
				return;
			}
			GameObject go = new GameObject("Map Sound");
			go.transform.position = where.transform.position;
			UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(go, _map.Scene);
			AudioSource source = go.AddComponent<AudioSource>();
			source.spatialBlend = 1f;
			source.spatialize = false;
			source.rolloffMode = AudioRolloffMode.Linear;
			source.maxDistance = 30f;
			source.clip = clip;
			source.volume = Mathf.Clamp01(volume);
			source.Play();
			Object.Destroy(go, clip.length + 0.1f);
		}

		private void InitMotion()
		{
			if (MapPlayer.Ready)
			{
				_baseSpeedMultiplier = GorillaLocomotion.Player.Instance.speedMultiplier;
			}
			if (MapPlayer.Ready && !_map.Settings.AllowWebSwinging)
			{
				_webShooters = GorillaLocomotion.Player.Instance.GetComponentsInChildren<SpiderApeWebShooter>(true);
			}
			_waters = Collect<WaterVolume>();
			Transform head = MapPlayer.Head;
			if (!(head != null) || _waters.Length == 0)
			{
				return;
			}
			_lowPass = head.GetComponent<AudioLowPassFilter>();
			if (_lowPass == null)
			{
				_lowPass = head.gameObject.AddComponent<AudioLowPassFilter>();
				_addedLowPass = true;
			}
			_lowPass.cutoffFrequency = 900f;
			_lowPass.enabled = false;
		}

		private void ShutdownMotion()
		{
			if (MapPlayer.Ready)
			{
				GorillaLocomotion.Player.Instance.speedMultiplier = _baseSpeedMultiplier;
			}
			RestoreWebs();
			_launching = false;
			if (_host != null)
			{
				_host.Environment.SetUnderwater(false, default(Color), 0f);
			}
			if (_lowPass != null)
			{
				if (_addedLowPass)
				{
					Object.Destroy(_lowPass);
				}
				else
				{
					_lowPass.enabled = false;
				}
			}
		}

		private float CurrentGravityScale()
		{
			float scale = _map.Settings.GravityMultiplier;
			if (_activeGravity != null)
			{
				scale *= Mathf.Clamp(_activeGravity.GravityMultiplier, -1f, 3f);
			}
			if (_water != null)
			{
				scale -= _water.Buoyancy * _submersion;
			}
			return scale;
		}

		private void UpdateMotion()
		{
			if (MapPlayer.Ready)
			{
				if (_launching)
				{
					BreakGrip(GorillaLocomotion.Player.Instance);
				}
				float mapSpeed = _map.Settings.SpeedMultiplier;
				float zoneSpeed = 1f;
				if (_activeSpeed != null)
				{
					zoneSpeed = Mathf.Clamp(_activeSpeed.SpeedMultiplier, 0.25f, 3f);
				}
				GorillaLocomotion.Player.Instance.speedMultiplier = mapSpeed * zoneSpeed * _baseSpeedMultiplier;
				SuspendWebs();
				UpdateStrokes();
			}
		}

		private void SuspendWebs()
		{
			if (_webShooters == null)
			{
				return;
			}
			for (int i = 0; i < _webShooters.Length; i++)
			{
				SpiderApeWebShooter shooter = _webShooters[i];
				if (!(shooter == null) && shooter.enabled)
				{
					shooter.enabled = false;
					if (!_suspendedShooters.Contains(shooter))
					{
						_suspendedShooters.Add(shooter);
					}
				}
			}
		}

		private void RestoreWebs()
		{
			foreach (SpiderApeWebShooter shooter in _suspendedShooters)
			{
				if (shooter != null)
				{
					shooter.enabled = true;
				}
			}
			_suspendedShooters.Clear();
		}

		private void FixedMotion()
		{
			if (!PlayerCanMove)
			{
				return;
			}
			Rigidbody body = MapPlayer.Body;
			if (body == null || body.isKinematic)
			{
				return;
			}
			float gravityScale = CurrentGravityScale();
			if (!Mathf.Approximately(gravityScale, 1f))
			{
				body.AddForce(Physics.gravity * (gravityScale - 1f), ForceMode.Acceleration);
			}
			if (_water != null)
			{
				float dt = Time.fixedDeltaTime;
				Vector3 velocity = body.linearVelocity * Mathf.Max(0f, 1f - dt * (_water.Drag * _submersion));
				velocity = _strokeDelta + velocity;
				body.linearVelocity = Vector3.ClampMagnitude(velocity, 25f);
			}
			_strokeDelta = Vector3.zero;
		}

		private void LateMotion()
		{
			if (!_launching)
			{
				return;
			}
			Rigidbody body = MapPlayer.Body;
			if (!PlayerCanMove || body == null || body.isKinematic)
			{
				_launching = false;
				return;
			}
			float elapsed = Time.time - _launchStart;
			if (elapsed > 0.3f || (GorillaLocomotion.Player.Instance.transform.position - _launchFrom).sqrMagnitude > 400f)
			{
				_launching = false;
				return;
			}
			body.linearVelocity = _launchVelocity + Physics.gravity * (elapsed * CurrentGravityScale());
		}

		private void Launch(Vector3 velocity, bool additive)
		{
			if (!PlayerCanMove)
			{
				return;
			}
			GorillaLocomotion.Player player = GorillaLocomotion.Player.Instance;
			Rigidbody body = player.playerRigidBody;
			if (!(body == null) && !body.isKinematic)
			{
				if (additive)
				{
					velocity += body.linearVelocity;
				}
				velocity = Vector3.ClampMagnitude(velocity, 25f);
				BreakGrip(player);
				body.linearVelocity = velocity;
				_launchVelocity = velocity;
				_launchStart = Time.time;
				_launchFrom = player.transform.position;
				_launching = true;
			}
		}

		private void CancelLaunch()
		{
			_launching = false;
		}

		private static void BreakGrip(GorillaLocomotion.Player player)
		{
			if ((object)player != null)
			{
				player.SetMaximumSlipThisFrame();
				player.wasLeftHandTouching = false;
				player.wasRightHandTouching = false;
				player.wasLeftHandSlide = false;
				player.wasRightHandSlide = false;
			}
		}

		private void UpdateWaterZones()
		{
			_water = null;
			foreach (WaterVolume water in _waters)
			{
				if (water.isActiveAndEnabled && (water.Contains(_body) || water.Contains(_head)))
				{
					_water = water;
					break;
				}
			}
			_submersion = ((_water != null) ? Mathf.Clamp01((_water.TopY - _body.y) / 0.9f + 0.1f) : 0f);
			bool headUnder = _water != null && _head.y < _water.TopY && _water.Contains(_head);
			if (_water != null && !_wasInWater)
			{
				Play((_assets != null) ? _assets.splash : null, 0.8f);
			}
			_wasInWater = _water != null;
			if (_headUnder != headUnder)
			{
				_headUnder = headUnder;
				WaterVolume under = (headUnder ? _water : null);
				_host.Environment.SetUnderwater(headUnder, (under != null) ? under.UnderwaterColor : default(Color), (under != null) ? under.UnderwaterFogDensity : 0f);
				if (_lowPass != null)
				{
					_lowPass.enabled = headUnder;
				}
			}
		}

		private void UpdateStrokes()
		{
			Transform leftHand = MapPlayer.LeftHand;
			Transform rightHand = MapPlayer.RightHand;
			if (leftHand == null || rightHand == null)
			{
				return;
			}
			Vector3 left = leftHand.position;
			Vector3 right = rightHand.position;
			if (_water != null && _havePrevHands && Time.deltaTime > 0f)
			{
				Rigidbody body = MapPlayer.Body;
				Vector3 bodyVelocity = ((body != null) ? body.linearVelocity : Vector3.zero);
				_strokeDelta += (Stroke(left, _prevLeft, bodyVelocity) + Stroke(right, _prevRight, bodyVelocity)) * Time.deltaTime;
			}
			_prevLeft = left;
			_prevRight = right;
			_havePrevHands = true;
		}

		private Vector3 Stroke(Vector3 hand, Vector3 prev, Vector3 bodyVelocity)
		{
			if (!_water.Contains(hand))
			{
				return Vector3.zero;
			}
			Vector3 relative = (hand - prev) / Time.deltaTime - bodyVelocity;
			float magnitude = relative.magnitude;
			if (magnitude < 0.45f)
			{
				return Vector3.zero;
			}
			return -relative * ((1f - 0.45f / magnitude) * (_water.SwimStrength * 2.5f));
		}

		private void InitNet()
		{
			if (PhotonNetwork.InRoom && !PhotonNetwork.IsMasterClient && PhotonNetwork.CurrentRoom.PlayerCount > 1)
			{
				_ready = false;
				_snapshotGiveUpAt = Time.time + 15f;
				RequestSnapshot();
			}
			else
			{
				BecomeReady();
			}
		}

		private void BecomeReady()
		{
			if (!_ready)
			{
				_ready = true;
				StartLogic();
			}
		}

		private void RequestSnapshot()
		{
			_snapshotRetryAt = Time.time + 3f;
			Send(Op.RequestSnapshot, ToMaster);
		}

		private void LateNetTick()
		{
			if (!_ready)
			{
				if (Time.time >= _snapshotGiveUpAt)
				{
					BecomeReady();
				}
				else if (Time.time >= _snapshotRetryAt)
				{
					RequestSnapshot();
				}
			}
		}

		public override void OnMasterClientSwitched(Photon.Realtime.Player newMaster)
		{
			if (!_ready)
			{
				if (PhotonNetwork.IsMasterClient)
				{
					BecomeReady();
				}
				else
				{
					RequestSnapshot();
				}
			}
		}

		public void OnEvent(EventData e)
		{
			if (e.Code != EventCode || _shutdown || !(e.CustomData is object[] data) || data.Length < 2 || !(data[0] is byte op) || !(data[1] is string key) || key != MapKey)
			{
				return;
			}
			int sender = e.Sender;
			switch ((Op)op)
			{
			case Op.RequestSnapshot:
				if (PhotonNetwork.IsMasterClient && _ready)
				{
					Send(Op.Snapshot, new RaiseEventOptions
					{
						TargetActors = new int[1] { sender }
					}, WriteSnapshot());
				}
				return;
			case Op.Snapshot:
				if (!_ready && data.Length >= 3 && data[2] is byte[] blob)
				{
					ApplySnapshot(blob);
					BecomeReady();
				}
				return;
			}
			if (!_ready)
			{
				return;
			}
			switch ((Op)op)
			{
			case Op.RequestTrigger:
			{
				if (PhotonNetwork.IsMasterClient && Int(data, 2, out var index) && index >= 0 && index < _triggers.Length)
				{
					TriggerState t = _triggers[index];
					if (!(Time.time < t.ReadyAt))
					{
						t.ReadyAt = Time.time + t.Trigger.Cooldown;
						MasterRunTrigger(index, sender);
					}
				}
				break;
			}
			case Op.RunTrigger:
			{
				if (Int(data, 2, out var index) && Int(data, 3, out var activator) && index >= 0 && index < _triggers.Length)
				{
					_triggers[index].Fired = true;
					RunTrigger(index, activator, false);
				}
				break;
			}
			case Op.RequestButton:
			{
				if (PhotonNetwork.IsMasterClient && Int(data, 2, out var index) && index >= 0 && index < _buttons.Length)
				{
					MasterButton(index, sender);
				}
				break;
			}
			case Op.ButtonState:
			{
				if (Int(data, 2, out var index) && data.Length >= 5 && data[3] is bool toggled && Int(data, 4, out var actor))
				{
					ApplyButtonState(index, toggled, actor);
				}
				break;
			}
			case Op.DoorState:
			{
				if (Int(data, 2, out var index) && data.Length >= 5 && data[3] is bool open && Int(data, 4, out var changedMs))
				{
					ApplyDoorState(index, open, changedMs, true);
				}
				break;
			}
			case Op.PlatformState:
			{
				if (Int(data, 2, out var index) && data.Length >= 6 && data[3] is bool running && data[4] is double offset && data[5] is double since)
				{
					ApplyPlatformState(index, running, offset, since);
				}
				break;
			}
			case Op.RaceResult:
			{
				if (Int(data, 2, out var index) && index >= 0 && index < _races.Length && data.Length >= 5 && data[3] is string name && Int(data, 4, out var ms))
				{
					AddResult(_races[index], name, ms);
				}
				break;
			}
			}
		}

		private static bool Int(object[] data, int i, out int value)
		{
			value = 0;
			if (data.Length > i && data[i] is int num)
			{
				value = num;
				return true;
			}
			return false;
		}

		private void SendTriggerRequest(int index)
		{
			Send(Op.RequestTrigger, ToMaster, index);
		}

		private void SendRunTrigger(int index, int activator)
		{
			Send(Op.RunTrigger, ToOthers, index, activator);
		}

		private void SendButtonRequest(int index)
		{
			Send(Op.RequestButton, ToMaster, index);
		}

		private void SendButtonState(int index, bool toggled, int actor)
		{
			Send(Op.ButtonState, ToOthers, index, toggled, actor);
		}

		private void SendDoorState(int index, bool open, int changedMs)
		{
			Send(Op.DoorState, ToOthers, index, open, changedMs);
		}

		private void SendPlatformState(int index, PlatformState s)
		{
			Send(Op.PlatformState, ToOthers, index, s.Running, s.Offset, s.Since);
		}

		private void SendRaceResult(int index, string name, int ms)
		{
			Send(Op.RaceResult, ToOthers, index, name, ms);
		}

		private void Send(Op op, RaiseEventOptions options, params object[] args)
		{
			if (PhotonNetwork.InRoom)
			{
				object[] payload = new object[args.Length + 2];
				payload[0] = (byte)op;
				payload[1] = MapKey;
				for (int i = 0; i < args.Length; i++)
				{
					payload[i + 2] = args[i];
				}
				PhotonNetwork.RaiseEvent(EventCode, payload, options, SendOptions.SendReliable);
			}
		}

		private void InitPlatforms()
		{
			LethalApe.SDK.MovingPlatform[] sources = Collect<LethalApe.SDK.MovingPlatform>();
			_platforms = new PlatformState[sources.Length];
			if (sources.Length == 0)
			{
				return;
			}
			Transform root = new GameObject("Platform Waypoints").transform;
			root.SetParent(base.transform, false);
			for (int i = 0; i < sources.Length; i++)
			{
				LethalApe.SDK.MovingPlatform source = sources[i];
				Transform t = source.transform;
				Vector3[] points = source.Points ?? new Vector3[0];
				Matrix4x4 parentMatrix = ((t.parent != null) ? t.parent.localToWorldMatrix : Matrix4x4.identity);
				Transform[] waypoints = new Transform[points.Length];
				for (int j = 0; j < points.Length; j++)
				{
					Transform waypoint = new GameObject("Waypoint").transform;
					waypoint.SetParent(root, false);
					waypoint.position = parentMatrix.MultiplyPoint3x4(t.localPosition + points[j]);
					waypoints[j] = waypoint;
				}
				GorillaLocomotion.MovingPlatform mover = source.GetComponent<GorillaLocomotion.MovingPlatform>();
				if (mover == null)
				{
					mover = source.gameObject.AddComponent<GorillaLocomotion.MovingPlatform>();
				}
				mover.waypoints = waypoints;
				mover.pathMode = GorillaLocomotion.MovingPlatform.PathMode.Waypoints;
				mover.speed = Mathf.Max(0.05f, source.Speed);
				mover.acceleration = Mathf.Max(0.05f, source.Acceleration);
				mover.pingPong = source.PingPong;
				mover.rotate = false;
				mover.externallyDriven = true;
				mover.pauseAtEnds = Mathf.Max(0f, source.PauseAtEnds);
				mover.BuildPath();
				_platforms[i] = new PlatformState
				{
					Source = source,
					Mover = mover,
					BaseRotation = t.rotation,
					Running = source.StartActive
				};
			}
		}

		private static double PlatformTime(PlatformState s, double now)
		{
			return s.Running ? (s.Offset + (now - s.Since)) : s.Offset;
		}

		private void UpdatePlatforms()
		{
			if (_platforms == null || _platforms.Length == 0)
			{
				return;
			}
			double now = PlatformClock.Now;
			foreach (PlatformState s in _platforms)
			{
				if (s.Mover == null)
				{
					continue;
				}
				double t = PlatformTime(s, now);
				s.Mover.MoveNow(s.Mover.PoseAt(t));
				if (s.Source.Rotate)
				{
					Vector3 axis = s.Source.RotationAxis;
					axis = (axis.sqrMagnitude > 0f) ? axis.normalized : Vector3.up;
					float angle = (float)((t * (double)s.Source.RotationSpeed) % 360.0);
					s.Mover.transform.rotation = s.BaseRotation * Quaternion.AngleAxis(angle, axis);
				}
			}
		}

		private void SetPlatformRunning(int index, bool run, bool broadcast)
		{
			if (index < 0 || index >= _platforms.Length)
			{
				return;
			}
			PlatformState s = _platforms[index];
			if (s.Running == run)
			{
				return;
			}
			double now = PlatformClock.Now;
			if (run)
			{
				s.Since = now;
			}
			else
			{
				s.Offset += now - s.Since;
			}
			s.Running = run;
			if (broadcast)
			{
				SendPlatformState(index, s);
			}
		}

		private void ApplyPlatformState(int index, bool running, double offset, double since)
		{
			if (index >= 0 && index < _platforms.Length)
			{
				PlatformState s = _platforms[index];
				s.Offset = offset;
				s.Since = since;
				s.Running = running;
			}
		}

		private int PlatformIndex(LethalApe.SDK.MovingPlatform p)
		{
			for (int i = 0; i < _platforms.Length; i++)
			{
				if (_platforms[i].Source == p)
				{
					return i;
				}
			}
			return -1;
		}

		private void InitRaces()
		{
			RaceCourse[] courses = Collect<RaceCourse>();
			_races = new RaceState[courses.Length];
			for (int i = 0; i < courses.Length; i++)
			{
				_races[i] = new RaceState
				{
					Course = courses[i],
					InCheckpoint = new bool[(courses[i].Checkpoints != null) ? courses[i].Checkpoints.Length : 0]
				};
				RefreshResultsSign(_races[i]);
			}
		}

		private void ShutdownRace()
		{
			if (_wristText != null)
			{
				Object.Destroy(_wristText.gameObject);
			}
		}

		private void UpdateRaceGates()
		{
			float now = Time.time;
			for (int i = 0; i < _races.Length; i++)
			{
				RaceState r = _races[i];
				RaceCourse c = r.Course;
				bool inStart = c.StartGate != null && c.StartGate.isActiveAndEnabled && HeadOrBody(c.StartGate);
				bool inFinish = c.FinishGate != null && c.FinishGate.isActiveAndEnabled && HeadOrBody(c.FinishGate);
				bool enteredStart = inStart && !r.InStart;
				bool enteredFinish = inFinish && !r.InFinish;
				r.InStart = inStart;
				r.InFinish = inFinish;
				RaceGate[] checkpoints = c.Checkpoints;
				bool allCheckpoints = checkpoints == null || r.NextCheckpoint >= checkpoints.Length;
				bool lapLongEnough = c.StartGate != c.FinishGate || now - r.StartedAt > MinLapSeconds;
				if (allCheckpoints && lapLongEnough && enteredFinish && r.Running)
				{
					Finish(r, now);
					if (c.StartGate == c.FinishGate)
					{
						StartRun(r, now);
					}
					continue;
				}
				if (enteredStart)
				{
					StartRun(r, now);
				}
				if (checkpoints == null || !r.Running)
				{
					continue;
				}
				for (int j = 0; j < checkpoints.Length; j++)
				{
					bool inside = checkpoints[j] != null && checkpoints[j].isActiveAndEnabled && HeadOrBody(checkpoints[j]);
					if (inside && !r.InCheckpoint[j] && j == r.NextCheckpoint)
					{
						r.NextCheckpoint++;
						Play((_assets != null) ? _assets.raceCheckpoint : null);
						Haptic(0.2f, 0.05f);
					}
					r.InCheckpoint[j] = inside;
				}
			}
		}

		private void StartRun(RaceState r, float now)
		{
			bool wasRunning = r.Running;
			r.StartedAt = now;
			r.Running = true;
			r.NextCheckpoint = 0;
			if (!wasRunning)
			{
				Play((_assets != null) ? _assets.raceStart : null);
			}
			if (r.Course.WristTimer)
			{
				ShowWristTimer(r);
			}
		}

		private void Finish(RaceState r, float now)
		{
			r.Running = false;
			int ms = Mathf.RoundToInt((now - r.StartedAt) * 1000f);
			string name = (PhotonNetwork.InRoom && !string.IsNullOrEmpty(PhotonNetwork.LocalPlayer.NickName)) ? PhotonNetwork.LocalPlayer.NickName : "You";
			Play((_assets != null) ? _assets.raceFinish : null);
			Haptic(0.6f, 0.2f);
			Toast(r.Course.RaceName + ": " + FormatTime(ms));
			AddResult(r, name, ms);
			SendRaceResult(RaceIndex(r), name, ms);
			if (_wristRace == r)
			{
				HideWristTimer();
			}
			FireRaceTriggers(r.Course);
		}

		private void AddResult(RaceState r, string name, int ms)
		{
			if (string.IsNullOrEmpty(name) || ms <= 0)
			{
				return;
			}
			if (name.Length > 16)
			{
				name = name.Substring(0, 16);
			}
			int existing = r.Results.FindIndex((RaceResult x) => x.Name == name);
			if (existing >= 0)
			{
				if (r.Results[existing].Ms <= ms)
				{
					return;
				}
				r.Results.RemoveAt(existing);
			}
			r.Results.Add(new RaceResult
			{
				Name = name,
				Ms = ms
			});
			r.Results.Sort((RaceResult a, RaceResult b) => a.Ms.CompareTo(b.Ms));
			if (r.Results.Count > 10)
			{
				r.Results.RemoveRange(10, r.Results.Count - 10);
			}
			RefreshResultsSign(r);
		}

		private void RefreshResultsSign(RaceState r)
		{
			TextSign sign = r.Course.ResultsSign;
			if (sign == null)
			{
				return;
			}
			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			sb.Append("<b>");
			sb.Append(string.IsNullOrEmpty(r.Course.RaceName) ? "Best Times" : r.Course.RaceName).Append("</b>\n");
			if (r.Results.Count == 0)
			{
				sb.Append("<color=#FFFFFF99>No times yet</color>");
			}
			int count = Mathf.Min(r.Course.ResultsShown, r.Results.Count);
			for (int i = 0; i < count; i++)
			{
				sb.Append(i + 1).Append(". ").Append(Escape(r.Results[i].Name)).Append("  <color=#5195F9>")
					.Append(FormatTime(r.Results[i].Ms))
					.Append("</color>\n");
			}
			SetSignText(sign, sb.ToString());
		}

		private static string Escape(string s)
		{
			return s.Replace("<", "(").Replace(">", ")");
		}

		private static string FormatTime(int ms)
		{
			float seconds = (float)(ms % 60000) / 1000f;
			if (ms >= 60000)
			{
				return string.Format("{0}:{1:00.00}", ms / 60000, seconds);
			}
			return string.Format("{0:0.00}s", seconds);
		}

		private int RaceIndex(RaceState r)
		{
			return System.Array.IndexOf(_races, r);
		}

		private void UpdateRace()
		{
			if (_wristText == null || _wristRace == null)
			{
				return;
			}
			if (!_wristRace.Running)
			{
				HideWristTimer();
				return;
			}
			Transform hand = MapPlayer.LeftHand;
			Transform head = MapPlayer.Head;
			if (hand == null || head == null)
			{
				return;
			}
			Transform t = _wristText.transform;
			t.position = hand.position + Vector3.up * 0.09f;
			Vector3 look = t.position - head.position;
			if (look.sqrMagnitude > 0.0001f)
			{
				t.rotation = Quaternion.LookRotation(look, Vector3.up);
			}
			int tenths = Mathf.FloorToInt((Time.time - _wristRace.StartedAt) * 10f);
			if (tenths != _wristShownTenths)
			{
				_wristShownTenths = tenths;
				_wristText.SetText("{0:1}", (float)tenths / 10f);
			}
		}

		private void ShowWristTimer(RaceState r)
		{
			_wristRace = r;
			_wristShownTenths = -1;
			if (_wristText == null)
			{
				_wristText = CreateText("Race Timer", null, 0.022f, TextAlignmentOptions.Center, new Vector2(0.2f, 0.05f));
			}
			_wristText.gameObject.SetActive(true);
		}

		private void HideWristTimer()
		{
			_wristRace = null;
			if (_wristText != null)
			{
				_wristText.gameObject.SetActive(false);
			}
		}

		private byte[] WriteSnapshot()
		{
			using (MemoryStream ms = new MemoryStream(256))
			{
				using (BinaryWriter w = new BinaryWriter(ms))
				{
					w.Write(SnapshotVersion);
					w.Write(_doors.Length);
					foreach (DoorState d in _doors)
					{
						w.Write(d.Open);
						w.Write(d.ChangedMs);
					}
					w.Write(_platforms.Length);
					foreach (PlatformState p in _platforms)
					{
						w.Write(p.Running);
						w.Write(p.Offset);
						w.Write(p.Since);
					}
					w.Write(_buttons.Length);
					foreach (ButtonState b in _buttons)
					{
						w.Write(b.Toggled);
					}
					w.Write(_tracked.Count);
					foreach (GameObject go in _tracked)
					{
						bool alive = go != null;
						w.Write(alive);
						if (alive)
						{
							w.Write(go.activeSelf);
							Transform t = go.transform;
							Write(w, TweenEndPosition(t));
							Write(w, TweenEndRotation(t));
						}
					}
					w.Write(_signList.Length);
					foreach (TextSign sign in _signList)
					{
						w.Write(SignText(sign) ?? "");
					}
					w.Write(_triggers.Length);
					foreach (TriggerState tr in _triggers)
					{
						w.Write(tr.Fired);
					}
					w.Write(_races.Length);
					foreach (RaceState r in _races)
					{
						w.Write(r.Results.Count);
						foreach (RaceResult res in r.Results)
						{
							w.Write(res.Name ?? "");
							w.Write(res.Ms);
						}
					}
					w.Write(_startedFired);
					return ms.ToArray();
				}
			}
		}

		private void ApplySnapshot(byte[] blob)
		{
			try
			{
				using (MemoryStream ms = new MemoryStream(blob))
				{
					using (BinaryReader r = new BinaryReader(ms))
					{
						if (r.ReadByte() != SnapshotVersion)
						{
							return;
						}
						int doorCount = r.ReadInt32();
						for (int i = 0; i < doorCount; i++)
						{
							bool open = r.ReadBoolean();
							int changedMs = r.ReadInt32();
							if (i < _doors.Length)
							{
								ApplyDoorState(i, open, changedMs, false);
							}
						}
						int platformCount = r.ReadInt32();
						for (int j = 0; j < platformCount; j++)
						{
							bool running = r.ReadBoolean();
							double offset = r.ReadDouble();
							double since = r.ReadDouble();
							if (j < _platforms.Length)
							{
								ApplyPlatformState(j, running, offset, since);
							}
						}
						int buttonCount = r.ReadInt32();
						for (int k = 0; k < buttonCount; k++)
						{
							bool toggled = r.ReadBoolean();
							if (k < _buttons.Length)
							{
								_buttons[k].Toggled = toggled;
							}
						}
						int trackedCount = r.ReadInt32();
						for (int l = 0; l < trackedCount; l++)
						{
							if (!r.ReadBoolean())
							{
								continue;
							}
							bool active = r.ReadBoolean();
							Vector3 pos = ReadVector(r);
							Quaternion rot = ReadQuaternion(r);
							if (l < _tracked.Count && !(_tracked[l] == null))
							{
								GameObject go = _tracked[l];
								go.transform.localPosition = pos;
								go.transform.localRotation = rot;
								SetActive(go, active);
							}
						}
						int signCount = r.ReadInt32();
						for (int m = 0; m < signCount; m++)
						{
							string text = r.ReadString();
							if (m < _signList.Length)
							{
								SetSignText(_signList[m], text);
							}
						}
						int triggerCount = r.ReadInt32();
						for (int n = 0; n < triggerCount; n++)
						{
							bool fired = r.ReadBoolean();
							if (n < _triggers.Length)
							{
								_triggers[n].Fired = fired;
							}
						}
						int raceCount = r.ReadInt32();
						for (int num = 0; num < raceCount; num++)
						{
							int resultCount = r.ReadInt32();
							for (int num2 = 0; num2 < resultCount; num2++)
							{
								string name = r.ReadString();
								int resultMs = r.ReadInt32();
								if (num < _races.Length)
								{
									AddResult(_races[num], name, resultMs);
								}
							}
						}
						_startedFired = r.ReadBoolean();
					}
				}
			}
			catch (EndOfStreamException)
			{
				Debug.LogWarning("[CustomMaps] Snapshot was cut short; keeping what was applied.");
			}
		}

		private static void Write(BinaryWriter w, Vector3 v)
		{
			w.Write(v.x);
			w.Write(v.y);
			w.Write(v.z);
		}

		private static void Write(BinaryWriter w, Quaternion q)
		{
			w.Write(q.x);
			w.Write(q.y);
			w.Write(q.z);
			w.Write(q.w);
		}

		private static Vector3 ReadVector(BinaryReader r)
		{
			return new Vector3(r.ReadSingle(), r.ReadSingle(), r.ReadSingle());
		}

		private static Quaternion ReadQuaternion(BinaryReader r)
		{
			return new Quaternion(r.ReadSingle(), r.ReadSingle(), r.ReadSingle(), r.ReadSingle());
		}

		private void InitSigns()
		{
			_signList = Collect<TextSign>();
			foreach (TextSign sign in _signList)
			{
				TextMeshPro tmp = CreateText("Sign Text", sign.transform, sign.LetterHeight, Align(sign.Alignment), sign.Size);
				tmp.color = sign.TextColor;
				tmp.transform.localRotation = Quaternion.Euler(0f, 180f, 0f);
				tmp.SetText(Clip(sign.Text));
				if (sign.Style == SignStyle.Panel)
				{
					CreatePanel(sign.transform, sign.Size, -0.012f, true, (_assets != null) ? _assets.panelMaterial : null);
				}
				_signs[sign] = tmp;
			}
		}

		private void SetSignText(TextSign sign, string value)
		{
			if (sign != null && _signs.TryGetValue(sign, out var tmp) && tmp != null)
			{
				tmp.SetText(Clip(value));
			}
		}

		private string SignText(TextSign sign)
		{
			if (sign != null && _signs.TryGetValue(sign, out var tmp) && tmp != null)
			{
				return tmp.text;
			}
			return "";
		}

		private static string Clip(string s)
		{
			if (string.IsNullOrEmpty(s))
			{
				return "";
			}
			if (s.Length > 560)
			{
				return s.Substring(0, 560);
			}
			return s;
		}

		private static TextAlignmentOptions Align(SignAlignment a)
		{
			return a switch
			{
				SignAlignment.Left => TextAlignmentOptions.MidlineLeft,
				SignAlignment.Right => TextAlignmentOptions.MidlineRight,
				_ => TextAlignmentOptions.Midline,
			};
		}

		private TextMeshPro CreateText(string name, Transform parent, float letterHeight, TextAlignmentOptions align, Vector2 size)
		{
			GameObject go = new GameObject(name, typeof(RectTransform));
			if (parent != null)
			{
				go.transform.SetParent(parent, false);
			}
			else
			{
				UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(go, _map.Scene);
			}
			go.layer = 2;
			TextMeshPro tmp = go.AddComponent<TextMeshPro>();
			if (_assets != null && _assets.font != null)
			{
				tmp.font = _assets.font;
			}
			tmp.alignment = align;
			tmp.textWrappingMode = TextWrappingModes.Normal;
			tmp.overflowMode = TextOverflowModes.Ellipsis;
			tmp.richText = true;
			tmp.fontSize = FontSizeFor(tmp, letterHeight);
			tmp.rectTransform.sizeDelta = size;
			tmp.color = Color.white;
			MeshRenderer renderer = tmp.GetComponent<MeshRenderer>();
			renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			renderer.receiveShadows = false;
			return tmp;
		}

		private static float FontSizeFor(TextMeshPro tmp, float letterHeight)
		{
			if (!(_capHeightPerPoint > 0f))
			{
				tmp.fontSize = 10f;
				tmp.SetText("H");
				tmp.ForceMeshUpdate();
				float capHeight = 0.007f;
				float height = tmp.textBounds.size.y;
				if (height > 0f && !float.IsNaN(height))
				{
					capHeight = height / 10f;
				}
				_capHeightPerPoint = capHeight;
			}
			return Mathf.Clamp(letterHeight / _capHeightPerPoint, 0.5f, 400f);
		}

		private MeshRenderer CreatePanel(Transform parent, Vector2 size, float localZ, bool facePlusZ, Material material)
		{
			if (material == null)
			{
				return null;
			}
			GameObject go = GameObject.CreatePrimitive(PrimitiveType.Quad);
			Object.Destroy(go.GetComponent<Collider>());
			go.name = "Panel";
			go.layer = 2;
			go.transform.SetParent(parent, false);
			go.transform.localPosition = new Vector3(0f, 0f, localZ);
			go.transform.localRotation = facePlusZ ? Quaternion.Euler(0f, 180f, 0f) : Quaternion.identity;
			go.transform.localScale = new Vector3(size.x + 0.08f, size.y + 0.08f, 1f);
			MeshRenderer renderer = go.GetComponent<MeshRenderer>();
			renderer.sharedMaterial = material;
			renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			renderer.receiveShadows = false;
			return renderer;
		}

		private void Toast(string message)
		{
			if (string.IsNullOrEmpty(message))
			{
				return;
			}
			if (_toast == null)
			{
				_toast = CreateText("Map Message", null, 0.028f, TextAlignmentOptions.Center, new Vector2(0.9f, 0.22f));
				_toastPanel = CreatePanel(_toast.transform, new Vector2(0.9f, 0.16f), 0.01f, false, (_assets != null) ? _assets.toastPanelMaterial : null);
				if (_toastPanel != null)
				{
					_toastPanelColor = _toastPanel.sharedMaterial.GetColor(ColorId);
				}
				_toast.gameObject.SetActive(false);
			}
			if (!_toast.gameObject.activeSelf)
			{
				PlaceToast(true);
				_toastShownAt = Time.time;
				_toast.gameObject.SetActive(true);
			}
			if (message.Length > 120)
			{
				message = message.Substring(0, 120);
			}
			_toast.SetText(message);
			_toastUntil = Time.time + ToastSeconds;
			SetToastAlpha(ToastAlpha());
			Play((_assets != null) ? _assets.message : null, 0.6f);
		}

		private void UpdateToast()
		{
			if (_toast == null || !_toast.gameObject.activeSelf)
			{
				return;
			}
			if (Time.time > _toastUntil)
			{
				_toast.gameObject.SetActive(false);
				return;
			}
			PlaceToast(false);
			SetToastAlpha(ToastAlpha());
		}

		private float ToastAlpha()
		{
			float fadeIn = Mathf.Clamp01((Time.time - _toastShownAt) / ToastFadeIn);
			float fadeOut = Mathf.Clamp01((_toastUntil - Time.time) / ToastFadeOut);
			return Mathf.Min(fadeIn, fadeOut);
		}

		private void SetToastAlpha(float alpha)
		{
			if (_toastAlpha == alpha)
			{
				return;
			}
			_toastAlpha = alpha;
			_toast.alpha = alpha;
			if (!(_toastPanel == null))
			{
				if (_toastBlock == null)
				{
					_toastBlock = new MaterialPropertyBlock();
				}
				_toastBlock.SetColor(ColorId, new Color(_toastPanelColor.r, _toastPanelColor.g, _toastPanelColor.b, _toastPanelColor.a * alpha));
				_toastPanel.SetPropertyBlock(_toastBlock);
			}
		}

		private void PlaceToast(bool snap)
		{
			Transform head = MapPlayer.Head;
			if (head == null)
			{
				return;
			}
			Vector3 forward = head.forward;
			Vector3 flat = ((forward.x * forward.x + forward.z * forward.z < 0.0001f) ? Vector3.forward : new Vector3(forward.x, 0f, forward.z));
			Vector3 target = head.position + flat.normalized * ToastDistance + Vector3.down * 0.15f;
			Transform t = _toast.transform;
			if (snap)
			{
				_toastVelocity = Vector3.zero;
			}
			else
			{
				target = Vector3.SmoothDamp(t.position, target, ref _toastVelocity, 0.25f);
			}
			t.position = target;
			Vector3 look = t.position - head.position;
			if (look.sqrMagnitude > 0.0001f)
			{
				t.rotation = Quaternion.LookRotation(look, Vector3.up);
			}
		}

		private void ShutdownToast()
		{
			if (_toast != null)
			{
				Object.Destroy(_toast.gameObject);
			}
		}

		private void InitZones()
		{
			_kills = Collect<KillZone>();
			_checkpoints = Collect<Checkpoint>();
			_teleporters = Collect<Teleporter>();
			_pads = Collect<JumpPad>();
			_speedZones = Collect<SpeedZone>();
			_gravityZones = Collect<GravityZone>();
			_checkpointInside = new bool[_checkpoints.Length];
			_teleporterInside = new bool[_teleporters.Length];
			_teleporterReady = new float[_teleporters.Length];
			_padInside = new bool[_pads.Length];
			_padReady = new float[_pads.Length];
			_speedInside = new bool[_speedZones.Length];
			_gravityInside = new bool[_gravityZones.Length];
		}

		private void ClearCheckpoint()
		{
			_checkpoint = null;
		}

		private bool SamplePlayer()
		{
			if (!MapPlayer.Ready)
			{
				return false;
			}
			GorillaLocomotion.Player player = GorillaLocomotion.Player.Instance;
			_head = player.headCollider.transform.position;
			_body = ((player.bodyCollider != null) ? player.bodyCollider.transform.TransformPoint(player.bodyCollider.center) : (_head + Vector3.down * 0.4f));
			_leftHand = ((player.leftHandTransform != null) ? player.leftHandTransform.position : _body);
			_rightHand = ((player.rightHandTransform != null) ? player.rightHandTransform.position : _body);
			return true;
		}

		private bool HeadOrBody(ZoneComponent z)
		{
			return z.Contains(_head) || z.Contains(_body);
		}

		private bool AnyPoint(ZoneComponent z)
		{
			return HeadOrBody(z) || z.Contains(_leftHand) || z.Contains(_rightHand);
		}

		private void UpdateZones()
		{
			if (!SamplePlayer() || !PlayerCanMove)
			{
				return;
			}
			float now = Time.time;
			float respawnHeight = _map.Settings.RespawnHeight;
			if (_head.y < respawnHeight || _body.y < respawnHeight)
			{
				Respawn();
				return;
			}
			KillZone[] kills = _kills;
			foreach (KillZone kill in kills)
			{
				if (kill.isActiveAndEnabled && HeadOrBody(kill))
				{
					Respawn();
					return;
				}
			}
			for (int i = 0; i < _checkpoints.Length; i++)
			{
				Checkpoint checkpoint = _checkpoints[i];
				bool inside = checkpoint.isActiveAndEnabled && HeadOrBody(checkpoint);
				if (inside && !_checkpointInside[i] && _checkpoint != checkpoint)
				{
					_checkpoint = checkpoint;
					Play((_assets != null) ? _assets.checkpoint : null);
					Haptic(0.25f, 0.08f);
					Toast("Checkpoint");
				}
				_checkpointInside[i] = inside;
			}
			for (int j = 0; j < _teleporters.Length; j++)
			{
				Teleporter teleporter = _teleporters[j];
				if (teleporter.isActiveAndEnabled && HeadOrBody(teleporter))
				{
					bool wasInside = _teleporterInside[j];
					_teleporterInside[j] = true;
					if (wasInside || now < _teleporterReady[j] || teleporter.Destination == null)
					{
						continue;
					}
					_teleporterReady[j] = now + Mathf.Max(0.25f, teleporter.Cooldown);
					Transform destination = teleporter.Destination;
					MapPlayer.TeleportFeet(destination.position, destination.eulerAngles.y, teleporter.KeepMomentum);
					Play((_assets != null) ? _assets.teleport : null);
					Haptic(0.3f, 0.1f);
					for (int k = 0; k < _teleporters.Length; k++)
					{
						_teleporterInside[k] = true;
					}
					return;
				}
				_teleporterInside[j] = false;
			}
			for (int l = 0; l < _pads.Length; l++)
			{
				JumpPad pad = _pads[l];
				if (pad.isActiveAndEnabled && AnyPoint(pad))
				{
					bool wasInside = _padInside[l];
					_padInside[l] = true;
					if (!wasInside && !(now < _padReady[l]))
					{
						_padReady[l] = now + Mathf.Max(0.1f, pad.Cooldown);
						Launch(pad.WorldLaunchVelocity, pad.Additive);
						Play((_assets != null) ? _assets.jumpPad : null);
						Haptic(0.5f, 0.1f);
					}
				}
				else
				{
					_padInside[l] = false;
				}
			}
			_activeSpeed = LatestInside(_speedZones, _speedInside, _activeSpeed);
			_activeGravity = LatestInside(_gravityZones, _gravityInside, _activeGravity);
			UpdateWaterZones();
			UpdateLogicZones();
			UpdateRaceGates();
		}

		private T LatestInside<T>(T[] zones, bool[] insideFlags, T current) where T : ZoneComponent
		{
			T latest = null;
			bool currentInside = false;
			for (int i = 0; i < zones.Length; i++)
			{
				T zone = zones[i];
				bool inside = zone.isActiveAndEnabled && HeadOrBody(zone);
				if (inside)
				{
					if (!insideFlags[i])
					{
						latest = zone;
					}
					currentInside |= zone == current;
				}
				insideFlags[i] = inside;
			}
			if (latest != null)
			{
				return latest;
			}
			if (currentInside)
			{
				return current;
			}
			for (int j = 0; j < zones.Length; j++)
			{
				if (insideFlags[j])
				{
					return zones[j];
				}
			}
			return null;
		}

		public static MapRuntime Create(LoadedMap map, CustomMapHost host)
		{
			GameObject go = new GameObject("__MapRuntime");
			UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(go, map.Scene);
			MapRuntime runtime = go.AddComponent<MapRuntime>();
			runtime.Init(map, host);
			return runtime;
		}

		private void Init(LoadedMap map, CustomMapHost host)
		{
			_map = map;
			_host = host;
			_assets = host.FeatureAssets;
			_sfx = base.gameObject.AddComponent<AudioSource>();
			_sfx.playOnAwake = false;
			_sfx.spatialBlend = 0f;
			_sfx.spatialize = false;
			_spawns = Collect<SpawnPoint>();
			InitMotion();
			InitPlatforms();
			InitDoors();
			InitButtons();
			InitSigns();
			InitRaces();
			InitLogic();
			InitAudio();
			InitClimb();
			InitZones();
			InitNet();
		}

		private T[] Collect<T>() where T : Component
		{
			List<T> list = new List<T>();
			GameObject[] roots = _map.Scene.GetRootGameObjects();
			foreach (GameObject root in roots)
			{
				list.AddRange(root.GetComponentsInChildren<T>(true));
			}
			return list.ToArray();
		}

		private void Update()
		{
			if (!_shutdown)
			{
				UpdatePlatforms();
				UpdateClimb();
				UpdateZones();
				UpdateMotion();
				UpdateDoors();
				UpdateButtons();
				UpdateLogic();
				UpdateRace();
				UpdateAudio();
				UpdateToast();
				LateNetTick();
			}
		}

		private void FixedUpdate()
		{
			if (!_shutdown)
			{
				FixedMotion();
				FixedLadder();
			}
		}

		private void LateUpdate()
		{
			if (!_shutdown)
			{
				LateMotion();
			}
		}

		public void Shutdown()
		{
			if (!_shutdown)
			{
				_shutdown = true;
				ShutdownMotion();
				ShutdownAudio();
				ShutdownClimb();
				ShutdownRace();
				ShutdownToast();
				if (this != null && base.gameObject != null)
				{
					Object.Destroy(base.gameObject);
				}
			}
		}

		public void SendToSpawn()
		{
			SpawnPoint spawn = _host.PickSpawn(_spawns);
			if (spawn != null)
			{
				MapPlayer.TeleportFeet(spawn.transform.position, spawn.transform.eulerAngles.y);
			}
			_checkpoint = null;
		}

		public void Respawn()
		{
			if (_checkpoint != null)
			{
				Transform point = _checkpoint.RespawnPoint;
				MapPlayer.TeleportFeet(point.position, point.eulerAngles.y);
			}
			else
			{
				SpawnPoint spawn = _host.PickSpawn(_spawns);
				if (spawn != null)
				{
					MapPlayer.TeleportFeet(spawn.transform.position, spawn.transform.eulerAngles.y);
				}
			}
			_launching = false;
			Play((_assets != null) ? _assets.respawn : null);
			Haptic(0.35f, 0.12f);
		}

		private void Play(AudioClip clip, float volumeScale = 1f)
		{
			if (!(clip == null) && !(_sfx == null))
			{
				_sfx.PlayOneShot(clip, ((_assets != null) ? _assets.sfxVolume : 0.7f) * volumeScale);
			}
		}

		private static void Haptic(float amplitude, float seconds)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				instance.PulseLeft(amplitude, seconds);
				instance.PulseRight(amplitude, seconds);
			}
		}
	}
}
