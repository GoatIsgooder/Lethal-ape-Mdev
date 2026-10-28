using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using GorillaLocomotion;
using LALocomotion;
using LethalApeR.Networking;
using LethalApeR.SpiderApe;
using Photon.Pun;
using TMPro;
using UnityEngine;
using Debug = UnityEngine.Debug;

[Obfuscation(Exclude = true)]
public class Mods : MonoBehaviourPunCallbacks
{
	private class MenuAnimState
	{
		public Vector3 originalScale;

		public bool wantsOpen;

		public float progress;

		public bool initialized;
	}

	private enum BlinkPhase
	{
		None = 0,
		Out = 1,
		In = 2
	}

	private sealed class PunchTrack
	{
		public Vector3 Left;

		public Vector3 Right;

		public int SeenFrame = -10;

		public float NextHit;
	}

	private sealed class IcePath
	{
		public const int MaxPoints = 32;

		private const float GrowTime = 0.15f;

		public readonly Vector3[] Points = new Vector3[32];

		public readonly Surface Surface;

		public readonly MeshCollider Collider;

		public float Fade = 1f;

		public float LastUsed;

		public float RiderArc;

		private readonly float[] _width = new float[32];

		private readonly float[] _born = new float[32];

		private readonly float[] _arc = new float[32];

		private readonly Vector3[] _right = new Vector3[32];

		private readonly Vector3[] _normal = new Vector3[32];

		private readonly Vector3[] _forward = new Vector3[32];

		private readonly GameObject _root;

		private readonly Mesh _visual;

		private readonly Mesh _solid;

		private Collider[] _rig;

		private float _thickness = 0.1f;

		private float _arcOffset;

		private bool _framesDirty;

		private bool _solidDirty;

		private readonly List<Vector3> _vertices = new List<Vector3>(264);

		private readonly List<Vector3> _normals = new List<Vector3>(264);

		private readonly List<Vector2> _uvs = new List<Vector2>(264);

		private readonly List<Color32> _colors = new List<Color32>(264);

		private readonly List<int> _triangles = new List<int>(780);

		private readonly List<Vector3> _solidVertices = new List<Vector3>(128);

		private readonly List<int> _solidTriangles = new List<int>(780);

		public int Count { get; private set; }

		public Vector3 Up { get; private set; } = Vector3.up;

		public bool Retiring { get; private set; }

		public bool Visible
		{
			get
			{
				if (_root != null)
				{
					return _root.activeSelf;
				}
				return false;
			}
		}

		public float Length
		{
			get
			{
				RefreshFrames();
				if (Count <= 0)
				{
					return 0f;
				}
				return _arc[Count - 1];
			}
		}

		public Vector3 EndDirection
		{
			get
			{
				if (Count > 1)
				{
					Vector3 vector = Points[Count - 1] - Points[Count - 2];
					if (vector.sqrMagnitude > 1E-08f)
					{
						return vector.normalized;
					}
				}
				return Vector3.forward;
			}
		}

		public IcePath(Material material, PhysicsMaterial frictionless, Collider[] rig)
		{
			_rig = rig;
			_root = new GameObject("~IceSurfPath")
			{
				layer = 0
			};
			_visual = new Mesh
			{
				name = "Ice Surf"
			};
			_visual.MarkDynamic();
			_solid = new Mesh
			{
				name = "Ice Surf Collider"
			};
			_root.AddComponent<MeshFilter>().sharedMesh = _visual;
			MeshRenderer meshRenderer = _root.AddComponent<MeshRenderer>();
			meshRenderer.sharedMaterial = material;
			meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			meshRenderer.receiveShadows = false;
			meshRenderer.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
			meshRenderer.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
			Collider = _root.AddComponent<MeshCollider>();
			Collider.sharedMaterial = frictionless;
			Collider.cookingOptions = MeshColliderCookingOptions.None;
			Collider.enabled = false;
			Surface = _root.AddComponent<Surface>();
			_root.SetActive(false);
		}

		public void SetRig(Collider[] rig)
		{
			_rig = rig ?? Array.Empty<Collider>();
		}

		public void Reset(Vector3 up, float thickness, float now)
		{
			Count = 0;
			Fade = 1f;
			Up = up;
			_thickness = thickness;
			_arcOffset = 0f;
			Retiring = false;
			_framesDirty = true;
			_solidDirty = true;
			LastUsed = now;
			RiderArc = 0f;
			_root.SetActive(true);
		}

		public void Add(Vector3 point, float width, float now)
		{
			if (Count == 32)
			{
				RemoveFront(1);
			}
			Points[Count] = point;
			_width[Count] = width;
			_born[Count] = now;
			Count++;
			_framesDirty = true;
			_solidDirty = true;
		}

		public float TrimBehind(float arcLimit)
		{
			RefreshFrames();
			int num = Count - Mathf.Min(Count, 2);
			int i;
			for (i = 0; i < num && _arc[i + 1] < arcLimit; i++)
			{
			}
			if (i == 0)
			{
				return 0f;
			}
			float result = _arc[i];
			RemoveFront(i);
			return result;
		}

		public void RebuildColliderNow()
		{
			RefreshFrames();
			BuildSolid();
		}

		public void Retire()
		{
			if (Visible && !Retiring)
			{
				Retiring = true;
				Collider.enabled = false;
			}
		}

		public void Hide()
		{
			Count = 0;
			Retiring = false;
			Fade = 1f;
			Collider.enabled = false;
			if (_root != null)
			{
				_root.SetActive(false);
			}
		}

		public void Dispose()
		{
			if (_root != null)
			{
				UnityEngine.Object.Destroy(_root);
			}
			if (_visual != null)
			{
				UnityEngine.Object.Destroy(_visual);
			}
			if (_solid != null)
			{
				UnityEngine.Object.Destroy(_solid);
			}
		}

		public void Locate(Vector3 x, out float arc, out float lateral, out float height, out float halfWidth, out Vector3 normal, out float distanceSqr)
		{
			RefreshFrames();
			halfWidth = 0f;
			height = 0f;
			lateral = 0f;
			arc = 0f;
			normal = Up;
			distanceSqr = float.MaxValue;
			for (int i = 0; i < Count - 1; i++)
			{
				Vector3 vector = Points[i];
				Vector3 vector2 = Points[i + 1] - vector;
				float num = vector2.sqrMagnitude;
				float t = 0f;
				if (num > 1E-08f)
				{
					t = Mathf.Clamp01(Vector3.Dot(x - vector, vector2) / num);
				}
				Vector3 vector3 = x - (vector + vector2 * t);
				float sqrMagnitude = vector3.sqrMagnitude;
				if (sqrMagnitude < distanceSqr)
				{
					distanceSqr = sqrMagnitude;
					arc = Mathf.Lerp(_arc[i], _arc[i + 1], t);
					normal = Vector3.Lerp(_normal[i], _normal[i + 1], t).normalized;
					Vector3 normalized = Vector3.Lerp(_right[i], _right[i + 1], t).normalized;
					lateral = Vector3.Dot(vector3, normalized);
					height = Vector3.Dot(vector3, normal);
					halfWidth = Mathf.Lerp(_width[i], _width[i + 1], t) * 0.5f;
				}
			}
		}

		public bool TryLocateRider(Vector3 x, float margin, out float arc)
		{
			arc = 0f;
			if (Count < 2 || Retiring)
			{
				return false;
			}
			Locate(x, out arc, out var lateral, out var height, out var halfWidth, out var _, out var distanceSqr);
			float num = Mathf.Max(0f, distanceSqr - lateral * lateral - height * height);
			if (Mathf.Abs(lateral) > halfWidth + margin)
			{
				return false;
			}
			if (height > margin)
			{
				return false;
			}
			if (height < 0f - (_thickness + margin))
			{
				return false;
			}
			return num <= margin * margin;
		}

		public bool IsNear(Vector3 x, float margin)
		{
			float arc;
			return TryLocateRider(x, margin, out arc);
		}

		public void Build(float now, float playerArc, float tailKeep, float tailFade)
		{
			RefreshFrames();
			_vertices.Clear();
			_normals.Clear();
			_uvs.Clear();
			_colors.Clear();
			_triangles.Clear();
			if (Count > 1)
			{
				for (int i = 0; i < Count; i++)
				{
					float num = Mathf.SmoothStep(0f, 1f, (now - _born[i]) / 0.15f);
					float num2 = Mathf.SmoothStep(0f, 1f, (playerArc - _arc[i] - tailKeep) / tailFade);
					Color32 color = new Color32(byte.MaxValue, byte.MaxValue, byte.MaxValue, (byte)(Mathf.Clamp01(Fade * (num * (1f - num2))) * 255f));
					Vector3 vector = _right[i] * (_width[i] * 0.5f * (0.3f + 0.7f * num));
					Vector3 vector2 = Points[i] - vector;
					Vector3 vector3 = Points[i] + vector;
					Vector3 vector4 = _normal[i];
					Vector3 vector5 = -vector4 * _thickness;
					float v = _arc[i] + _arcOffset;
					AddVertex(vector2, vector4, 0f, v, color);
					AddVertex(vector3, vector4, 1f, v, color);
					AddVertex(vector2, -_right[i], 0f, v, color);
					AddVertex(vector2 + vector5, -_right[i], 0f, v, color);
					AddVertex(vector3, _right[i], 1f, v, color);
					AddVertex(vector3 + vector5, _right[i], 1f, v, color);
					AddVertex(vector2 + vector5, -vector4, 0f, v, color);
					AddVertex(vector3 + vector5, -vector4, 1f, v, color);
				}
				int count = _vertices.Count;
				AddCap(0, -_forward[0]);
				int count2 = _vertices.Count;
				AddCap(Count - 1, _forward[Count - 1]);
				for (int j = 0; j < Count - 1; j++)
				{
					int num3 = j * 8;
					Quad(num3 + 6, num3 + 7, num3 + 15, num3 + 14);
				}
				for (int k = 0; k < Count - 1; k++)
				{
					int num4 = k * 8;
					Quad(num4 + 10, num4 + 2, num4 + 3, num4 + 11);
					Quad(num4 + 4, num4 + 12, num4 + 13, num4 + 5);
				}
				Quad(count, count + 1, count + 2, count + 3);
				Quad(count2 + 1, count2, count2 + 3, count2 + 2);
				for (int l = 0; l < Count - 1; l++)
				{
					int num5 = l * 8;
					Quad(num5, num5 + 8, num5 + 9, num5 + 1);
				}
			}
			_visual.Clear();
			_visual.SetVertices(_vertices);
			_visual.SetNormals(_normals);
			_visual.SetUVs(0, _uvs);
			_visual.SetColors(_colors);
			_visual.SetTriangles(_triangles, 0);
			if (_solidDirty)
			{
				BuildSolid();
			}
		}

		private void AddVertex(Vector3 position, Vector3 normal, float u, float v, Color32 color)
		{
			_vertices.Add(position);
			_normals.Add(normal);
			_uvs.Add(new Vector2(u, v));
			_colors.Add(color);
		}

		private void AddCap(int point, Vector3 normal)
		{
			int num = point * 8;
			Color32 color = _colors[num];
			float v = _arcOffset + _arc[point];
			AddVertex(_vertices[num], normal, 0f, v, color);
			AddVertex(_vertices[num + 1], normal, 1f, v, color);
			AddVertex(_vertices[num + 5], normal, 1f, v, color);
			AddVertex(_vertices[num + 3], normal, 0f, v, color);
		}

		private void Quad(int a, int b, int c, int d)
		{
			_triangles.Add(a);
			_triangles.Add(b);
			_triangles.Add(c);
			_triangles.Add(a);
			_triangles.Add(c);
			_triangles.Add(d);
		}

		private void BuildSolid()
		{
			_solidDirty = false;
			Collider.sharedMesh = null;
			if (Count < 2 || Retiring)
			{
				Collider.enabled = false;
				return;
			}
			_solidVertices.Clear();
			_solidTriangles.Clear();
			for (int i = 0; i < Count; i++)
			{
				Vector3 vector = _right[i] * (_width[i] * 0.5f);
				Vector3 vector2 = -_normal[i] * _thickness;
				_solidVertices.Add(Points[i] - vector);
				_solidVertices.Add(Points[i] + vector);
				_solidVertices.Add(Points[i] + vector + vector2);
				_solidVertices.Add(Points[i] - vector + vector2);
			}
			for (int j = 0; j < Count - 1; j++)
			{
				int num = j * 4;
				int num2 = num + 4;
				SolidQuad(num, num2, num + 5, num + 1);
				SolidQuad(num2, num, num + 3, num + 7);
				SolidQuad(num + 1, num + 5, num + 6, num + 2);
				SolidQuad(num + 3, num + 2, num + 6, num + 7);
			}
			SolidQuad(0, 1, 2, 3);
			int num3 = (Count - 1) * 4;
			SolidQuad(num3 + 1, num3, num3 + 3, num3 + 2);
			_solid.Clear();
			_solid.SetVertices(_solidVertices);
			_solid.SetTriangles(_solidTriangles, 0);
			Collider.sharedMesh = _solid;
			Collider.enabled = true;
			for (int k = 0; k < _rig.Length; k++)
			{
				if (_rig[k] != null)
				{
					Physics.IgnoreCollision(Collider, _rig[k], true);
				}
			}
		}

		private void SolidQuad(int a, int b, int c, int d)
		{
			_solidTriangles.Add(a);
			_solidTriangles.Add(b);
			_solidTriangles.Add(c);
			_solidTriangles.Add(a);
			_solidTriangles.Add(c);
			_solidTriangles.Add(d);
		}

		private void RemoveFront(int n)
		{
			RefreshFrames();
			_arcOffset += _arc[n];
			int num = Count - n;
			Array.Copy(Points, n, Points, 0, num);
			Array.Copy(_width, n, _width, 0, num);
			Array.Copy(_born, n, _born, 0, num);
			Count = num;
			_framesDirty = true;
			_solidDirty = true;
		}

		private void RefreshFrames()
		{
			if (!_framesDirty)
			{
				return;
			}
			_framesDirty = false;
			if (Count == 0)
			{
				return;
			}
			_arc[0] = 0f;
			for (int i = 1; i < Count; i++)
			{
				_arc[i] = _arc[i - 1] + Vector3.Distance(Points[i - 1], Points[i]);
			}
			for (int j = 0; j < Count; j++)
			{
				Vector3 vector = Vector3.zero;
				if (j > 0)
				{
					vector += (Points[j] - Points[j - 1]).normalized;
				}
				if (j < Count - 1)
				{
					vector += (Points[j + 1] - Points[j]).normalized;
				}
				Vector3 vector2 = Vector3.Cross(Up, vector);
				if (vector2.sqrMagnitude < 1E-06f)
				{
					vector2 = ((j == 0) ? Vector3.Cross(Up, Vector3.forward) : _right[j - 1]);
				}
				vector2 = vector2.normalized;
				_right[j] = vector2;
				_forward[j] = ((vector.sqrMagnitude > 1E-06f) ? vector.normalized : Vector3.Cross(vector2, Up));
				_normal[j] = Vector3.Cross(_forward[j], vector2).normalized;
			}
		}
	}

	public GameObject boosterMenuParent;

	public GameObject DollaMenuParent;

	public GameObject modmenuParent;

	public GameObject superMenuParent;

	public GameObject sizeMenuParent;

	public GameObject proMenuParent;

	public GameObject superSizeMenuParent;

	public GameObject devMenuParent;

	public GameObject tpMenuParent;

	public GameObject soundboardMenuParent;

	public GameObject corruptedMenuParent;

	public GameObject seasonalMenuParent;

	[Header("Size Display")]
	public TMP_Text sizeDisplayText;

	[Header("Platform Spawner Settings")]
	public GameObject platformPrefab;

	[Tooltip("Vertical offset applied to the spawned platform so its top surface ends up below the hand follower instead of intersecting it. Lethal-Ape's prefab had this baked in via a parent/child wrapper (child at y=-0.059). Slop-Game's Platforms.prefab is flat (no wrapper) so without this offset the hand is INSIDE the collider — invisible on the head and breaks GorillaLocomotion's grip detection because there's no 'top of platform' to land on.")]
	public float platformVerticalOffset = 0.06f;

	public Transform leftHandTransform;

	public Transform rightHandTransform;

	private GameObject leftPlatform;

	private GameObject rightPlatform;

	private bool _leftPlatformHeld;

	private bool _rightPlatformHeld;

	public float FlyForce = 2f;

	[Header("Corrupted Menu — Fly")]
	public float slowFlyForce = 1f;

	public float fastFlyForce = 6f;

	public float joystickFlySpeed = 3f;

	[Header("Corrupted Menu — Car Monke")]
	public float carMonkeForce = 4f;

	[Header("Corrupted Menu — Teleport Targets (assign in scene)")]
	public Transform backroomsTarget;

	public Transform hospitalTarget;

	public Transform hauntedForestTarget;

	private bool toggleRGB;

	private bool toggleSpeedBoost;

	private bool toggleExtraSpeedBoost;

	private bool toggleLongArms;

	private bool toggleGhostMonke;

	private bool togglePlatforms;

	private bool toggleFly;

	private bool toggleLowGravity;

	private bool toggleFlipGravity;

	private bool toggleAirSwim;

	private bool toggleInfiniteArms;

	private bool toggleNoSlip;

	private bool toggleSpeedHack;

	private bool toggleSuperJump;

	private bool toggleIronGrip;

	private bool toggleNoFriction;

	private bool toggleInstantStick;

	private bool toggleNoBodyCollider;

	private bool togglePlayerPickup;

	private bool toggleStickyHands;

	private bool toggleDoubleJump;

	private bool toggleDashAbility;

	private bool toggleWallRun;

	private bool toggleGrappleHands;

	private bool togglePlayerESP;

	private bool toggleFreezeOthers;

	private bool toggleSlipperyMode;

	private bool toggleAutoJump;

	private bool toggleSpeedTrails;

	private bool togglePlayerMagnet;

	private bool toggleSuperStrength;

	private bool toggleXRayVision;

	private bool toggleZeroFriction;

	private bool toggleMoonGravity;

	private bool toggleCheckpoint;

	private bool toggleMonsterSkin;

	private bool toggleSlowFly;

	private bool toggleFastFly;

	private bool toggleJoystickFly;

	private bool toggleHighGravity;

	private bool toggleCarMonke;

	private bool toggleStickyPlatforms;

	private bool toggleInvisPlatforms;

	private readonly List<GameObject> _placedPlatforms = new List<GameObject>();

	private bool _leftPlacePlatHeld;

	private bool _rightPlacePlatHeld;

	private bool toggleBulletTime;

	private bool toggleGravityGun;

	private bool toggleLightningHands;

	private bool toggleSpiderClimb;

	private bool toggleJetpack;

	private bool toggleExplosiveTouch;

	private bool toggleIceTouch;

	private bool toggleForcePush;

	private bool toggleNinjaMode;

	private bool toggleVampireMode;

	private bool toggleShieldBubble;

	private bool toggleSuperSpeed;

	private bool toggleGiantMode;

	private bool toggleFlashMode;

	private bool toggleTelekinesis;

	private bool toggleWindGust;

	private bool toggleFireTrail;

	private bool toggleSuperRGB;

	private bool toggleWallClimb;

	private bool toggleBouncyMode;

	private bool toggleInvisible;

	private bool toggleRocketHands;

	private bool toggleMagnetHands;

	private bool toggleSizeRainbow;

	private bool toggleSpinMode;

	private bool toggleEarthquake;

	private bool togglePhaseWalls;

	private bool toggleSuperSlide;

	private bool toggleDiscoMode;

	private Vector3 checkpointPosition;

	private bool hasDoubleJump;

	private float lastDashTime;

	private float dashCooldown = 1f;

	private float lastShockwaveTime;

	private float shockwaveCooldown = 3f;

	private float lastForcePushTime;

	private float forcePushCooldown = 2f;

	private float spinSpeed;

	private float sizeRainbowTime;

	private float earthquakeTimer;

	private List<GameObject> clones = new List<GameObject>();

	private float originalMaxArmLength;

	private float originalVelocityLimit;

	private float originalJumpMultiplier;

	private float originalMaxJumpSpeed;

	private float originalSlideFactor;

	private float originalIceThreshold;

	private float originalFrictionConstant;

	private float originalStickDepth;

	private float originalSlideVelocityLimit;

	private float originalSlideControl;

	private bool originalBodyColliderState;

	private static readonly Collider[] _overlapBuf = new Collider[64];

	private static int _layerGrabbable = -1;

	[Header("Scale Smoothing")]
	public float scaleLerpSpeed = 8f;

	[Header("Menu Animation")]
	[Tooltip("Seconds to scale a menu from 0 → 1 when it opens.")]
	public float menuOpenDuration = 0.18f;

	[Tooltip("Seconds to scale a menu from 1 → 0 before the GameObject is disabled.")]
	public float menuCloseDuration = 0.14f;

	[Header("Menu Buttons")]
	[Tooltip("After a button on a hand menu is pressed, that menu ignores presses for this long (seconds), so a finger brushing two buttons or jittering on one only presses once.")]
	public float menuPressCooldown = 0.35f;

	[Header("Menu Open Haptics")]
	public bool menuHapticsEnabled = true;

	[Range(0f, 1f)]
	public float menuHapticAmplitude = 0.5f;

	[Tooltip("Pulse length in seconds when a menu opens.")]
	public float menuHapticDuration = 0.08f;

	private readonly Dictionary<GameObject, MenuAnimState> _menuAnims = new Dictionary<GameObject, MenuAnimState>();

	public bool ownBoosterMenu;

	public bool ownModMenu;

	public bool ownDollaMenu;

	public bool ownSuperMenu;

	public bool ownSizeMenu;

	public bool ownProMenu;

	public bool ownSuperSizeMenu;

	public bool ownDevMenu;

	public bool ownTpMenu;

	public bool ownSoundboardMenu;

	public bool ownCorruptedMenu;

	public bool ownSeasonalMenu;

	[Space(10f)]
	public bool modsAllowed;

	private bool previousModsAllowed = true;

	private static Vector3 _projectGravity = new Vector3(0f, -9.81f, 0f);

	private static float _projectFixedDeltaTime = 1f / 72f;

	private bool _originalsStored;

	private bool _ambientSaved;

	private Color _sceneAmbient;

	private MonkeDevNetworkingPlayer leftGrabbedPlayer;

	private MonkeDevNetworkingPlayer rightGrabbedPlayer;

	[Header("Seasonal Mods")]
	[Tooltip("Iron Monke pushes you away from where your palms face, like Iron Man's repulsors. Untick to be pulled toward where they face instead.")]
	public bool ironMonkeRepulsor = true;

	[Tooltip("Iron Monke thrust per hand at full grip, in m/s². Gravity is 9.81, so hovering takes both hands.")]
	public float ironMonkeThrust = 10f;

	public float birdFlapPower = 4.5f;

	public float airplaneSpeed = 12f;

	[Tooltip("Size Trigger speed: at full trigger your size multiplies by e^rate every second.")]
	public float sizeTriggerRate = 0.9f;

	[Tooltip("Super Gravity swings between this many times normal gravity pulling down and the same pulling up.")]
	public float superGravityStrength = 1.3f;

	public float superGravityPeriod = 2f;

	[Tooltip("Punch Mod knockback per m/s of the incoming punch.")]
	public float punchKnockback = 1.6f;

	public float slideMaxSpeed = 12f;

	[Tooltip("Ice Surfing: riding the ice you're laying carries you along it, quickly up to this speed (m/s).")]
	public float iceSurfStartSpeed = 6f;

	[Tooltip("Ice Surfing: then keeps building toward this the longer you ride without letting go (m/s).")]
	public float iceSurfTopSpeed = 13f;

	[Tooltip("Ice Surfing: seconds of riding to build from start speed to top speed.")]
	public float iceSurfBuildTime = 3f;

	[Tooltip("Ice Surfing: how hard the ice pulls you up to speed (m/s²). Gravity is 9.81.")]
	public float iceSurfAcceleration = 8f;

	[Tooltip("Ice Surfing: hard cap on the ice, downhill included (m/s). Clamped under 28, where Player's anti-teleport starts snapping the rig back.")]
	public float iceSurfMaxSpeed = 18f;

	private bool toggleWebSwing;

	private bool togglePunchMod;

	private bool toggleIronMonke;

	private bool toggleBirdFly;

	private bool toggleRagdoll;

	private bool toggleInfVelocity;

	private bool toggleSizeTrigger;

	private bool toggleUpsideDown;

	private bool toggleAirplaneMode;

	private bool toggleWallStick;

	private bool toggleZeroGravity;

	private bool toggleSlippyFloor;

	private bool toggleIceSurfing;

	private bool toggleSuperGravity;

	private const float ModMaxSpeed = 28f;

	private const float InfJumpSpeed = 1000f;

	private const float ToggleDebounce = 0.25f;

	private const float GripOn = 0.6f;

	private const float GripOff = 0.35f;

	private const float BlinkOutTime = 0.09f;

	private const float BlinkInTime = 0.16f;

	private const float RagdollMaxSpin = 10f;

	private const float RagdollSpinDamping = 0.6f;

	private const float WallAimRange = 9f;

	private const float WallSearchRadius = 3.5f;

	private const float WallHoldRange = 2.6f;

	private const float WallLostGrace = 0.4f;

	private const float IronMaxSpeed = 20f;

	private const float BirdStrokeDeadzone = 0.8f;

	private const float BirdUpstrokeBite = 0.2f;

	private const float BirdMaxClimb = 7f;

	private const float BirdForwardShare = 0.35f;

	private const float BirdGlideLift = 3f;

	private const float BirdGlideDrive = 1.2f;

	private const float BirdGlideSpeed = 9f;

	private const float BirdMaxSpeed = 14f;

	private const float AirplaneResponse = 2.5f;

	private const float AirplaneMaxAccel = 18f;

	private const float PunchMinSpeed = 2.2f;

	private const float PunchMaxKnockback = 14f;

	private const float PunchLift = 2.5f;

	private const float PunchCooldown = 0.45f;

	private const float SlideCarveRate = 140f;

	private const float SlideCarveMinSpeed = 0.3f;

	private const float SlideHandPushGain = 2f;

	private const float IceHandGap = 0.005f;

	private const float IceGroundGap = 0.02f;

	private const float IceSegment = 0.15f;

	private const float IceWidth = 0.4f;

	private const float IceThickness = 0.03f;

	private const float IcePadBack = 0.15f;

	private const float IceTip = 0.3f;

	private const float IceTipPerSpeed = 0.03f;

	private const float IceMaxTurn = 25f;

	private const float IceMaxRise = 35f;

	private const float IceMaxDrop = 50f;

	private const float IcePitchDeadband = 6f;

	private const float IceTailKeep = 1f;

	private const float IceTailFade = 0.6f;

	private const float IceOnMargin = 0.15f;

	private const float IceRiderMargin = 0.45f;

	private const float IceUnusedGrace = 0.6f;

	private const float IceRetireTime = 0.35f;

	private readonly Dictionary<string, float> _toggleTimes = new Dictionary<string, float>();

	private readonly RaycastHit[] _seasonalHits = new RaycastHit[8];

	private ModsPreLocomotion _preLocomotion;

	private bool _seasonalAllowed = true;

	private float _lastHandTouchTime;

	private float _gripBreakUntil;

	private bool _maxSlipLastFrame;

	private bool _iceSlipFrame;

	private float _bodyInitialHeight = 0.5f;

	private Vector3 _leftHandLocal;

	private Vector3 _rightHandLocal;

	private Vector3 _leftHandDelta;

	private Vector3 _rightHandDelta;

	private Vector3 _leftHandVelocity;

	private Vector3 _rightHandVelocity;

	private bool _handsSampled;

	private bool _leftGripDown;

	private bool _rightGripDown;

	private bool _leftGripPressed;

	private bool _rightGripPressed;

	private BlinkPhase _blinkPhase;

	private float _blinkTime;

	private bool _gravityFlipped;

	private bool _rigOwned;

	private bool _ragdolled;

	private bool _ragdollButtonDown;

	private RigidbodyConstraints _savedConstraints = RigidbodyConstraints.FreezeRotation;

	private float _savedMaxAngular;

	private float _savedAngularDamping = 0.05f;

	private bool _wallStuck;

	private Vector3 _wallNormal = Vector3.up;

	private float _wallLostTime;

	private float _tPose;

	private float _airplaneBlend;

	private float _birdHapticTimer;

	private float _ironHapticLeft;

	private float _ironHapticRight;

	private int _sizeShown = -1;

	private bool _sizeAtLimit;

	private float _superGravityTime;

	private bool _slideContact;

	private Vector3 _slideNormal = Vector3.up;

	private float _slidePush;

	private bool _bodyFrictionless;

	private PhysicsMaterial _frictionless;

	private PhysicsMaterial _bodyMaterial;

	private PhysicsMaterial _headMaterial;

	private readonly List<Collider> _frictionlessHands = new List<Collider>();

	private readonly List<PhysicsMaterial> _handMaterials = new List<PhysicsMaterial>();

	private readonly List<Collider> _handScratch = new List<Collider>();

	private bool _iceSurfing;

	private float _iceSurfTime;

	private readonly Dictionary<MonkeDevNetworkingPlayer, PunchTrack> _punchTracks = new Dictionary<MonkeDevNetworkingPlayer, PunchTrack>();

	private readonly List<MonkeDevNetworkingPlayer> _punchStale = new List<MonkeDevNetworkingPlayer>();

	private SpiderApeWebShooter[] _webShooters;

	private bool _webDefault;

	private bool _webShowPending;

	private readonly IcePath[] _icePaths = new IcePath[4];

	private readonly IcePath[] _iceLaying = new IcePath[2];

	private readonly float[] _iceNeutralPitch = new float[2];

	private Material _iceMaterial;

	private bool _iceShaderMissing;

	public static Mods Instance { get; private set; }

	private static int LayerGrabbable
	{
		get
		{
			if (_layerGrabbable < 0)
			{
				_layerGrabbable = LayerMask.NameToLayer("Grabbable");
			}
			return _layerGrabbable;
		}
	}

	public bool IsFlyEnabled => toggleFly;

	public bool IsPlatformsEnabled => togglePlatforms;

	public bool IsLowGravityEnabled => toggleLowGravity;

	public bool IsSpeedBoostEnabled => toggleSpeedBoost;

	public bool IsNoclipEnabled => toggleNoBodyCollider;

	public bool IsLongArmsEnabled => toggleLongArms;

	public bool IsPlayerPickupEnabled => togglePlayerPickup;

	public bool IsMonsterSkinEnabled => toggleMonsterSkin;

	private bool LeftPrimary
	{
		get
		{
			if (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null)
			{
				return LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.LeftPrimaryButton;
			}
			return false;
		}
	}

	private bool RightPrimary
	{
		get
		{
			if (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null)
			{
				return LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.RightPrimaryButton;
			}
			return false;
		}
	}

	private bool LeftSecondary
	{
		get
		{
			if (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null)
			{
				return LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.LeftSecondaryButton;
			}
			return false;
		}
	}

	private bool RightSecondary
	{
		get
		{
			if (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null)
			{
				return LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.RightSecondaryButton;
			}
			return false;
		}
	}

	private float LeftTrigger
	{
		get
		{
			if (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null)
			{
				return LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.LeftTriggerValue;
			}
			return 0f;
		}
	}

	private float RightTrigger
	{
		get
		{
			if (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null)
			{
				return LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.RightTriggerValue;
			}
			return 0f;
		}
	}

	private Vector3 LeftVelocity => (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null) ? LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.LeftControllerVelocity : Vector3.zero;

	private Vector3 RightVelocity => (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null) ? LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.RightControllerVelocity : Vector3.zero;

	private float LeftGrip => (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null) ? LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.LeftGripValue : 0f;

	private float RightGrip => (LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance != null) ? LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance.RightGripValue : 0f;

	private Vector3 DesiredRigUp
	{
		get
		{
			if (!toggleUpsideDown)
			{
				return Vector3.up;
			}
			return Vector3.down;
		}
	}

	private bool CustomGravityActive => toggleZeroGravity || toggleSuperGravity || _gravityFlipped || _wallStuck;

	private PhysicsMaterial Frictionless
	{
		get
		{
			if (_frictionless == null)
			{
				_frictionless = new PhysicsMaterial("Mods Frictionless")
				{
					dynamicFriction = 0f,
					staticFriction = 0f,
					bounciness = 0f,
					frictionCombine = PhysicsMaterialCombine.Minimum,
					bounceCombine = PhysicsMaterialCombine.Minimum
				};
			}
			return _frictionless;
		}
	}

	[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
	private static void ReadProjectPhysics()
	{
		_projectGravity = Physics.gravity;
		_projectFixedDeltaTime = Time.fixedDeltaTime;
	}

	private void Awake()
	{
		Instance = this;
		_preLocomotion = GetComponent<ModsPreLocomotion>();
		if (_preLocomotion == null)
		{
			_preLocomotion = base.gameObject.AddComponent<ModsPreLocomotion>();
		}
		_preLocomotion.Bind(this);
		AddMenuPressGates();
		LAGrabber.GrabBlocked = GripModOwnsGrip;
	}

	private bool GripModOwnsGrip(LAGrabber hand)
	{
		if (togglePlatforms || toggleStickyPlatforms || toggleInvisPlatforms || togglePlayerPickup || toggleSpiderClimb || toggleGravityGun || toggleWallStick || toggleIceSurfing || toggleIronMonke)
		{
			return IsAllowedToUseMods();
		}
		return false;
	}

	private void AddMenuPressGates()
	{
		GameObject[] array = new GameObject[12] { boosterMenuParent, DollaMenuParent, modmenuParent, superMenuParent, sizeMenuParent, proMenuParent, superSizeMenuParent, devMenuParent, tpMenuParent, soundboardMenuParent, corruptedMenuParent, seasonalMenuParent };
		foreach (GameObject gameObject in array)
		{
			if (!(gameObject == null))
			{
				LethalApeR.MenuPressGate menuPressGate = gameObject.GetComponent<LethalApeR.MenuPressGate>();
				if (menuPressGate == null)
				{
					menuPressGate = gameObject.AddComponent<LethalApeR.MenuPressGate>();
				}
				menuPressGate.Cooldown = menuPressCooldown;
			}
		}
	}

	private void Start()
	{
		SafeSetActive(superMenuParent, state: false);
		SafeSetActive(DollaMenuParent, state: false);
		SafeSetActive(modmenuParent, state: false);
		SafeSetActive(boosterMenuParent, state: false);
		SafeSetActive(sizeMenuParent, state: false);
		SafeSetActive(proMenuParent, state: false);
		SafeSetActive(superSizeMenuParent, state: false);
		SafeSetActive(devMenuParent, state: false);
		SafeSetActive(tpMenuParent, state: false);
		SafeSetActive(soundboardMenuParent, state: false);
		SafeSetActive(corruptedMenuParent, state: false);
		SafeSetActive(seasonalMenuParent, state: false);
		if (LethalApeR.PlayFab.PlayFabManager.Instance != null)
		{
			LethalApeR.PlayFab.PlayFabManager.Instance.OnLoggedIn += CheckIfOwn;
			LethalApeR.PlayFab.PlayFabManager.Instance.OnInventoryUpdated += CheckIfOwn;
		}
		if (LethalApeR.PlayFab.LocalProfileManager.Instance != null)
		{
			LethalApeR.PlayFab.LocalProfileManager.Instance.OnProfileLoaded += CheckIfOwn;
		}
		InvokeRepeating("CheckIfOwn", 5f, 2f);
		CheckIfOwn();
		StoreOriginalValues();
		InitSeasonalMods();
		if (Player.Instance != null)
		{
			Player.Instance.scaleSpeed = scaleLerpSpeed;
		}
	}

	private void OnDestroy()
	{
		if (LethalApeR.PlayFab.PlayFabManager.Instance != null)
		{
			LethalApeR.PlayFab.PlayFabManager.Instance.OnLoggedIn -= CheckIfOwn;
			LethalApeR.PlayFab.PlayFabManager.Instance.OnInventoryUpdated -= CheckIfOwn;
		}
		if (LethalApeR.PlayFab.LocalProfileManager.Instance != null)
		{
			LethalApeR.PlayFab.LocalProfileManager.Instance.OnProfileLoaded -= CheckIfOwn;
		}
		if (LAGrabber.GrabBlocked == new Func<LAGrabber, bool>(GripModOwnsGrip))
		{
			LAGrabber.GrabBlocked = null;
		}
		ShutdownSeasonalMods();
	}

	private void Update()
	{
		if (MonkeDevNetworkingManager.Manager.LocalPlayer == null)
		{
			return;
		}
		if (!IsAllowedToUseMods())
		{
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(DollaMenuParent, state: false);
			SafeSetActive(boosterMenuParent, state: false);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(sizeMenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
			SafeSetActive(superSizeMenuParent, state: false);
			SafeSetActive(devMenuParent, state: false);
			SafeSetActive(tpMenuParent, state: false);
			SafeSetActive(soundboardMenuParent, state: false);
			SafeSetActive(corruptedMenuParent, state: false);
			SafeSetActive(seasonalMenuParent, state: false);
			if (previousModsAllowed)
			{
				ResetAllMods();
			}
			previousModsAllowed = false;
			return;
		}
		previousModsAllowed = true;
		bool leftPrimary = LeftPrimary;
		bool rightPrimary = RightPrimary;
		if (ownDevMenu)
		{
			SafeSetActive(devMenuParent, leftPrimary);
			SafeSetActive(seasonalMenuParent, state: false);
			SafeSetActive(corruptedMenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(DollaMenuParent, state: false);
			SafeSetActive(boosterMenuParent, state: false);
		}
		else if (ownSeasonalMenu)
		{
			SafeSetActive(seasonalMenuParent, leftPrimary);
			SafeSetActive(corruptedMenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(DollaMenuParent, state: false);
			SafeSetActive(boosterMenuParent, state: false);
		}
		else if (ownCorruptedMenu)
		{
			SafeSetActive(corruptedMenuParent, leftPrimary);
			SafeSetActive(proMenuParent, state: false);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(DollaMenuParent, state: false);
			SafeSetActive(boosterMenuParent, state: false);
		}
		else if (ownProMenu)
		{
			SafeSetActive(proMenuParent, leftPrimary);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(DollaMenuParent, state: false);
			SafeSetActive(boosterMenuParent, state: false);
		}
		else if (ownSuperMenu)
		{
			SafeSetActive(superMenuParent, leftPrimary);
			SafeSetActive(boosterMenuParent, state: false);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
		}
		else if (ownModMenu)
		{
			SafeSetActive(modmenuParent, leftPrimary);
			SafeSetActive(boosterMenuParent, state: false);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
		}
		else if (ownDollaMenu)
		{
			SafeSetActive(DollaMenuParent, leftPrimary);
			SafeSetActive(boosterMenuParent, state: false);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
		}
		else if (ownBoosterMenu)
		{
			SafeSetActive(boosterMenuParent, leftPrimary);
			SafeSetActive(modmenuParent, state: false);
			SafeSetActive(superMenuParent, state: false);
			SafeSetActive(proMenuParent, state: false);
		}
		if (ownSoundboardMenu)
		{
			SafeSetActive(soundboardMenuParent, rightPrimary);
			SafeSetActive(superSizeMenuParent, state: false);
			SafeSetActive(sizeMenuParent, state: false);
		}
		else if (ownSuperSizeMenu)
		{
			SafeSetActive(soundboardMenuParent, state: false);
			SafeSetActive(superSizeMenuParent, rightPrimary);
			SafeSetActive(sizeMenuParent, state: false);
		}
		else if (ownSizeMenu)
		{
			SafeSetActive(soundboardMenuParent, state: false);
			SafeSetActive(superSizeMenuParent, state: false);
			SafeSetActive(sizeMenuParent, rightPrimary);
		}
		if (ownTpMenu)
		{
			SafeSetActive(tpMenuParent, RightSecondary);
		}
		HandlePlatforms();
		HandleGhostMonkey();
		HandleFly();
		HandleCorruptedMovement();
		HandleNoBodyCollider();
		HandlePlayerPickup();
		HandleContinuousEffects();
	}

	private void FixedUpdate()
	{
		SeasonalFixedStep();
		if (!(MonkeDevNetworkingManager.Manager.LocalPlayer == null) && IsAllowedToUseMods())
		{
			HandleAirSwim();
		}
	}

	public void ToggleSlowFly()
	{
		if (!IsAllowedToUseMods())
		{
			toggleSlowFly = false;
			return;
		}
		toggleSlowFly = !toggleSlowFly;
		if (toggleSlowFly)
		{
			toggleFastFly = false;
			toggleJoystickFly = false;
		}
	}

	public void ToggleFastFly()
	{
		if (!IsAllowedToUseMods())
		{
			toggleFastFly = false;
			return;
		}
		toggleFastFly = !toggleFastFly;
		if (toggleFastFly)
		{
			toggleSlowFly = false;
			toggleJoystickFly = false;
		}
	}

	public void ToggleJoystickFly()
	{
		if (!IsAllowedToUseMods())
		{
			toggleJoystickFly = false;
			return;
		}
		toggleJoystickFly = !toggleJoystickFly;
		if (toggleJoystickFly)
		{
			toggleSlowFly = false;
			toggleFastFly = false;
		}
	}

	public void ToggleHighGravity()
	{
		if (!IsAllowedToUseMods())
		{
			Physics.gravity = _projectGravity;
			toggleHighGravity = false;
			return;
		}
		toggleHighGravity = !toggleHighGravity;
		if (toggleHighGravity)
		{
			toggleMoonGravity = false;
			toggleLowGravity = false;
			toggleFlipGravity = false;
			Physics.gravity = new Vector3(0f, -24.81f, 0f);
		}
		else
		{
			Physics.gravity = _projectGravity;
		}
	}

	public void ToggleCarMonke()
	{
		if (!IsAllowedToUseMods())
		{
			toggleCarMonke = false;
		}
		else
		{
			toggleCarMonke = !toggleCarMonke;
		}
	}

	public void ToggleStickyPlatforms()
	{
		if (!IsAllowedToUseMods())
		{
			toggleStickyPlatforms = false;
			ClearPlacedPlatforms();
			return;
		}
		toggleStickyPlatforms = !toggleStickyPlatforms;
		if (!toggleStickyPlatforms && !toggleInvisPlatforms)
		{
			ClearPlacedPlatforms();
		}
	}

	public void ToggleInvisPlatforms()
	{
		if (!IsAllowedToUseMods())
		{
			toggleInvisPlatforms = false;
			ClearPlacedPlatforms();
			return;
		}
		toggleInvisPlatforms = !toggleInvisPlatforms;
		if (!toggleStickyPlatforms && !toggleInvisPlatforms)
		{
			ClearPlacedPlatforms();
		}
	}

	public void TeleportToShop()
	{
		if (IsAllowedToUseMods() && Player.Instance != null)
		{
			Player.Instance.TpToShop(null);
		}
	}

	public void TeleportToCaves()
	{
		if (IsAllowedToUseMods() && Player.Instance != null)
		{
			Player.Instance.TpToCaveEnterenceShop(null);
		}
	}

	public void TeleportToFloodedMap()
	{
		if (IsAllowedToUseMods() && Player.Instance != null)
		{
			Player.Instance.TpToFloodedMap(null);
		}
	}

	public void TeleportToGarage()
	{
		if (IsAllowedToUseMods() && Player.Instance != null)
		{
			Player.Instance.TpToGuarage(null);
		}
	}

	public void TeleportToBackrooms()
	{
		TeleportToCorruptedTarget(backroomsTarget, "Backrooms");
	}

	public void TeleportToHospital()
	{
		TeleportToCorruptedTarget(hospitalTarget, "Hospital");
	}

	public void TeleportToHauntedForest()
	{
		TeleportToCorruptedTarget(hauntedForestTarget, "Haunted Forest");
	}

	private void TeleportToCorruptedTarget(Transform t, string label)
	{
		if (IsAllowedToUseMods() && !(Player.Instance == null))
		{
			if (t == null)
			{
				Debug.LogWarning("[Mods] '" + label + "' teleport target not assigned on the Mods component.");
			}
			else
			{
				Player.Instance.TeleportPlayerTransform(t);
			}
		}
	}

	private void HandleCorruptedMovement()
	{
		Player instance = Player.Instance;
		LethalApeR.Gameplay.BeTheMonster.VRInputController instance2 = LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance;
		if (instance == null || instance2 == null)
		{
			return;
		}
		Transform transform = instance.headCollider.transform;
		if (toggleSlowFly && instance2.RightSecondaryButton)
		{
			instance.playerRigidBody.AddForce(transform.forward * slowFlyForce, ForceMode.VelocityChange);
		}
		if (toggleFastFly && instance2.RightSecondaryButton)
		{
			instance.playerRigidBody.AddForce(transform.forward * fastFlyForce, ForceMode.VelocityChange);
		}
		if (toggleJoystickFly)
		{
			Vector3 forward = transform.forward;
			Vector3 normalized = new Vector3(forward.x, 0f, forward.z).normalized;
			Vector3 right = transform.right;
			Vector3 normalized2 = new Vector3(right.x, 0f, right.z).normalized;
			Vector2 leftJoystick = instance2.LeftJoystick;
			Vector3 vector = normalized2 * leftJoystick.x + normalized * leftJoystick.y;
			vector += Vector3.up * instance2.RightJoystick.y;
			if (vector.sqrMagnitude > 0.01f)
			{
				instance.playerRigidBody.AddForce(vector.normalized * joystickFlySpeed, ForceMode.VelocityChange);
			}
		}
		if (toggleCarMonke && instance2.RightSecondaryButton)
		{
			Vector3 vector2 = CarMonkeHandDirection();
			if (vector2.sqrMagnitude > 0.0001f)
			{
				instance.playerRigidBody.AddForce(vector2.normalized * carMonkeForce, ForceMode.VelocityChange);
			}
		}
		if (toggleStickyPlatforms || toggleInvisPlatforms)
		{
			bool invisible = toggleInvisPlatforms;
			TryPlacePlatform(instance2.LeftGripValue > 0.5f, instance.leftHandFollower, ref _leftPlacePlatHeld, invisible);
			TryPlacePlatform(instance2.RightGripValue > 0.5f, instance.rightHandFollower, ref _rightPlacePlatHeld, invisible);
		}
	}

	private void TryPlacePlatform(bool gripped, Transform hand, ref bool wasGripped, bool invisible)
	{
		if (gripped && !wasGripped && hand != null && platformPrefab != null)
		{
			Vector3 position = hand.position + Vector3.down * platformVerticalOffset;
			GameObject gameObject = Instantiate(platformPrefab, position, Quaternion.identity);
			Rigidbody component = gameObject.GetComponent<Rigidbody>();
			if (component != null)
			{
				component.isKinematic = true;
				component.useGravity = false;
			}
			if (invisible)
			{
				Renderer[] componentsInChildren = gameObject.GetComponentsInChildren<Renderer>(includeInactive: true);
				for (int i = 0; i < componentsInChildren.Length; i++)
				{
					componentsInChildren[i].enabled = false;
				}
			}
			gameObject.SetActive(value: true);
			_placedPlatforms.Add(gameObject);
			if (_placedPlatforms.Count > 60)
			{
				if (_placedPlatforms[0] != null)
				{
					Destroy(_placedPlatforms[0]);
				}
				_placedPlatforms.RemoveAt(0);
			}
		}
		wasGripped = gripped;
	}

	private Vector3 CarMonkeHandDirection()
	{
		Transform transform = ((leftHandTransform != null) ? leftHandTransform : Player.Instance.leftHandFollower);
		Transform transform2 = ((rightHandTransform != null) ? rightHandTransform : Player.Instance.rightHandFollower);
		Vector3 zero = Vector3.zero;
		if (transform != null)
		{
			zero += transform.forward;
		}
		if (transform2 != null)
		{
			zero += transform2.forward;
		}
		return zero;
	}

	private void ClearPlacedPlatforms()
	{
		for (int i = 0; i < _placedPlatforms.Count; i++)
		{
			if (_placedPlatforms[i] != null)
			{
				Destroy(_placedPlatforms[i]);
			}
		}
		_placedPlatforms.Clear();
	}

	private void LateUpdate()
	{
		TickMenuAnimations();
		SeasonalLateStep();
	}

	private void SafeSetActive(GameObject go, bool state)
	{
		if (go == null)
		{
			return;
		}
		MenuAnimState menuAnim = GetMenuAnim(go);
		if (!menuAnim.initialized)
		{
			menuAnim.originalScale = go.transform.localScale;
			menuAnim.wantsOpen = state;
			menuAnim.progress = (state ? 1f : 0f);
			menuAnim.initialized = true;
			bool activeSelf = go.activeSelf;
			if (state)
			{
				if (!activeSelf)
				{
					go.SetActive(value: true);
				}
				go.transform.localScale = menuAnim.originalScale;
			}
			else
			{
				if (activeSelf)
				{
					go.SetActive(value: false);
				}
				go.transform.localScale = Vector3.zero;
			}
		}
		else if (menuAnim.wantsOpen != state)
		{
			menuAnim.wantsOpen = state;
			if (state)
			{
				if (!go.activeSelf)
				{
					go.transform.localScale = Vector3.zero;
					go.SetActive(value: true);
				}
				if (menuHapticsEnabled)
				{
					SendMenuOpenHaptic();
				}
			}
		}
	}

	private void SendMenuOpenHaptic()
	{
		LethalApeR.Gameplay.BeTheMonster.VRInputController instance = LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance;
		if (!(instance == null))
		{
			bool flag = LeftPrimary || LeftSecondary;
			bool flag2 = RightPrimary || RightSecondary;
			bool flag3 = !flag && !flag2;
			if (flag || flag3)
			{
				instance.PulseLeft(menuHapticAmplitude, menuHapticDuration);
			}
			if (flag2 || flag3)
			{
				instance.PulseRight(menuHapticAmplitude, menuHapticDuration);
			}
		}
	}

	private MenuAnimState GetMenuAnim(GameObject go)
	{
		if (!_menuAnims.TryGetValue(go, out var value))
		{
			value = new MenuAnimState();
			_menuAnims[go] = value;
		}
		return value;
	}

	private void TickMenuAnimations()
	{
		if (_menuAnims.Count == 0)
		{
			return;
		}
		float deltaTime = Time.deltaTime;
		foreach (KeyValuePair<GameObject, MenuAnimState> menuAnim in _menuAnims)
		{
			GameObject key = menuAnim.Key;
			MenuAnimState value = menuAnim.Value;
			if (key == null)
			{
				continue;
			}
			float num = (value.wantsOpen ? 1f : 0f);
			if (Mathf.Approximately(value.progress, num))
			{
				if (!value.wantsOpen && key.activeSelf)
				{
					key.SetActive(value: false);
				}
				continue;
			}
			float num2 = 1f / Mathf.Max(0.001f, value.wantsOpen ? menuOpenDuration : menuCloseDuration);
			value.progress = Mathf.MoveTowards(value.progress, num, deltaTime * num2);
			float num3 = Mathf.SmoothStep(0f, 1f, value.progress);
			key.transform.localScale = value.originalScale * num3;
			if (!value.wantsOpen && value.progress <= 0f && key.activeSelf)
			{
				key.SetActive(value: false);
			}
		}
	}

	private bool HasAccessToFeature(string feature)
	{
		if (ownDevMenu || ownSeasonalMenu || ownCorruptedMenu || ownProMenu || ownSuperMenu || ownModMenu)
		{
			return true;
		}
		if (ownDollaMenu)
		{
			if (!(feature == "SpeedBoost") && !(feature == "LongArms") && !(feature == "RGB"))
			{
				return feature == "Fly";
			}
			return true;
		}
		if (ownBoosterMenu)
		{
			if (!(feature == "SpeedBoost") && !(feature == "LongArms"))
			{
				return feature == "RGB";
			}
			return true;
		}
		return false;
	}

	private bool IsAllowedToUseMods()
	{
		modsAllowed = LethalApeR.Gameplay.BeTheMonster.BTMGameManager.Instance == null && !InBeTheMonsterRoom();
		return modsAllowed;
	}

	private static bool InBeTheMonsterRoom()
	{
		object value = null;
		var currentRoom = PhotonNetwork.CurrentRoom;
		if (currentRoom == null || currentRoom.CustomProperties == null)
		{
			return false;
		}
		if (!currentRoom.CustomProperties.TryGetValue("queue", out value))
		{
			return false;
		}
		return (value as string) == "BeTheMonster";
	}

	public static void TurnOffEverywhere()
	{
		// RE: unsure - single enum arg value 1 to FindObjectsByType<Mods>; could be FindObjectsInactive.Include overload from 6000.4
		Mods[] array = FindObjectsByType<Mods>(FindObjectsSortMode.InstanceID);
		foreach (Mods mods in array)
		{
			mods.ResetAllMods();
			mods.previousModsAllowed = false;
		}
		RestoreProjectPhysics();
	}

	public static void RestoreProjectPhysics()
	{
		Physics.gravity = _projectGravity;
		Time.timeScale = 1f;
		Time.fixedDeltaTime = _projectFixedDeltaTime;
	}

	private void StoreOriginalValues()
	{
		Player instance = Player.Instance;
		if (!(instance == null))
		{
			originalMaxArmLength = instance.maxArmLength;
			originalVelocityLimit = instance.velocityLimit;
			originalJumpMultiplier = instance.jumpMultiplier;
			originalMaxJumpSpeed = instance.maxJumpSpeed;
			originalSlideFactor = instance.defaultSlideFactor;
			originalIceThreshold = instance.iceThreshold;
			originalFrictionConstant = instance.frictionConstant;
			originalStickDepth = instance.stickDepth;
			originalSlideVelocityLimit = instance.slideVelocityLimit;
			originalSlideControl = instance.slideControl;
			originalBodyColliderState = instance.bodyCollider.gameObject.activeSelf;
			_originalsStored = true;
		}
	}

	private void CheckIfOwn()
	{
		if (!(LethalApeR.PlayFab.LocalProfileManager.Instance == null))
		{
			ownBoosterMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("REVIEWMENU");
			ownDollaMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("DOLLAMENU");
			ownModMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("MODMENU");
			ownSuperMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("SUPERMENU");
			ownSizeMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("SMNU");
			ownProMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("PROMENU");
			ownSuperSizeMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("SSZMNU");
			ownDevMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("DEVMENU");
			ownTpMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("TPMENU");
			ownSoundboardMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("SOUNDBOARDMENU");
			ownCorruptedMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("CRPTMENU");
			ownSeasonalMenu = LethalApeR.PlayFab.LocalProfileManager.Instance.OwnsItem("SEASONMENU");
		}
	}

	private void SetScale(float scale)
	{
		if (!(Player.Instance == null))
		{
			Player.Instance.targetScale = Mathf.Clamp(scale, 0.1f, 5f);
		}
	}

	private void UpdateSizeDisplay()
	{
		if (sizeDisplayText != null && Player.Instance != null)
		{
			sizeDisplayText.text = string.Format("Size: {0:F2}", Player.Instance.targetScale);
		}
	}

	private void HandleContinuousEffects()
	{
		if (!IsAllowedToUseMods())
		{
			return;
		}
		Player instance = Player.Instance;
		if (instance == null)
		{
			return;
		}
		if (toggleDoubleJump)
		{
			if (Physics.Raycast(instance.transform.position, Vector3.down, 0.5f))
			{
				hasDoubleJump = true;
			}
			else if (hasDoubleJump && LeftPrimary && RightPrimary)
			{
				instance.playerRigidBody.AddForce(Vector3.up * 15f, ForceMode.VelocityChange);
				hasDoubleJump = false;
			}
		}
		if (toggleDashAbility && LeftSecondary && RightSecondary && Time.time - lastDashTime > dashCooldown)
		{
			instance.playerRigidBody.AddForce(instance.headCollider.transform.forward * 20f, ForceMode.VelocityChange);
			lastDashTime = Time.time;
		}
		bool flag = false;
		if (toggleWallRun)
		{
			bool flag2 = Physics.Raycast(instance.transform.position, -instance.transform.right, 1f);
			bool flag3 = Physics.Raycast(instance.transform.position, instance.transform.right, 1f);
			if (flag2 || flag3)
			{
				Vector3 linearVelocity = instance.playerRigidBody.linearVelocity;
				if (linearVelocity.magnitude > 2f)
				{
					instance.playerRigidBody.AddForce(Vector3.up * 2f, ForceMode.Force);
					flag = true;
				}
			}
		}
		if (toggleGrappleHands)
		{
			if (LeftTrigger > 0.5f && leftHandTransform != null && Physics.Raycast(leftHandTransform.position, leftHandTransform.forward, out var hitInfo, 20f))
			{
				instance.playerRigidBody.AddForce((hitInfo.point - instance.transform.position).normalized * 10f);
			}
			if (RightTrigger > 0.5f && rightHandTransform != null && Physics.Raycast(rightHandTransform.position, rightHandTransform.forward, out var hitInfo2, 20f))
			{
				instance.playerRigidBody.AddForce((hitInfo2.point - instance.transform.position).normalized * 10f);
			}
		}
		if (toggleAutoJump && Physics.Raycast(instance.transform.position, Vector3.down, 0.3f))
		{
			instance.playerRigidBody.AddForce(Vector3.up * 8f, ForceMode.Impulse);
		}
		if (togglePlayerMagnet)
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			List<MonkeDevNetworkingPlayer> list = manager?.Players;
			if (list != null)
			{
				MonkeDevNetworkingPlayer localPlayer = manager.LocalPlayer;
				for (int i = 0; i < list.Count; i++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = list[i];
					if (!(monkeDevNetworkingPlayer == null) && !(monkeDevNetworkingPlayer == localPlayer))
					{
						Rigidbody component = monkeDevNetworkingPlayer.GetComponent<Rigidbody>();
						if (component != null)
						{
							component.AddForce((instance.transform.position - monkeDevNetworkingPlayer.transform.position).normalized * 5f);
						}
					}
				}
			}
		}
		if (toggleFreezeOthers)
		{
			MonkeDevNetworkingManager manager2 = MonkeDevNetworkingManager.Manager;
			List<MonkeDevNetworkingPlayer> list2 = manager2?.Players;
			if (list2 != null)
			{
				MonkeDevNetworkingPlayer localPlayer2 = manager2.LocalPlayer;
				for (int j = 0; j < list2.Count; j++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer2 = list2[j];
					if (!(monkeDevNetworkingPlayer2 == null) && !(monkeDevNetworkingPlayer2 == localPlayer2))
					{
						Rigidbody component2 = monkeDevNetworkingPlayer2.GetComponent<Rigidbody>();
						if (component2 != null)
						{
							component2.linearVelocity = Vector3.zero;
							component2.angularVelocity = Vector3.zero;
						}
					}
				}
			}
		}
		if (toggleStickyHands)
		{
			instance.stickDepth = 0f;
		}
		if (toggleSuperStrength)
		{
			instance.velocityLimit = 999f;
		}
		bool flag4 = false;
		if (toggleSpiderClimb && (LeftGrip > 0.5f || RightGrip > 0.5f) && Physics.Raycast(instance.transform.position, instance.transform.forward, 1.5f))
		{
			instance.playerRigidBody.linearVelocity = instance.transform.up * 3f;
			flag4 = true;
		}
		if (toggleJetpack && LeftTrigger > 0.3f && RightTrigger > 0.3f)
		{
			instance.playerRigidBody.AddForce(Vector3.up * 15f);
		}
		if (toggleLightningHands)
		{
			if (LeftTrigger > 0.8f && leftHandTransform != null && Physics.Raycast(leftHandTransform.position, leftHandTransform.forward, out var hitInfo3, 20f))
			{
				hitInfo3.collider.GetComponent<Rigidbody>()?.AddForce((hitInfo3.point - leftHandTransform.position).normalized * 20f, ForceMode.Impulse);
			}
			if (RightTrigger > 0.8f && rightHandTransform != null && Physics.Raycast(rightHandTransform.position, rightHandTransform.forward, out var hitInfo4, 20f))
			{
				hitInfo4.collider.GetComponent<Rigidbody>()?.AddForce((hitInfo4.point - rightHandTransform.position).normalized * 20f, ForceMode.Impulse);
			}
		}
		if (toggleGravityGun && LeftTrigger > 0.5f && leftHandTransform != null && Physics.Raycast(leftHandTransform.position, leftHandTransform.forward, out var hitInfo5, 30f))
		{
			Rigidbody component3 = hitInfo5.collider.GetComponent<Rigidbody>();
			if (component3 != null)
			{
				Vector3 vector = ((LeftGrip > 0.5f) ? (leftHandTransform.position - component3.position) : (component3.position - leftHandTransform.position));
				component3.AddForce(vector.normalized * 15f);
			}
		}
		if (toggleExplosiveTouch)
		{
			int num = Physics.OverlapSphereNonAlloc(instance.transform.position, 1f, _overlapBuf);
			for (int k = 0; k < num; k++)
			{
				MonkeDevNetworkingPlayer componentInParent = _overlapBuf[k].GetComponentInParent<MonkeDevNetworkingPlayer>();
				if (componentInParent != null && componentInParent != MonkeDevNetworkingManager.Manager.LocalPlayer)
				{
					Rigidbody component4 = componentInParent.GetComponent<Rigidbody>();
					if (component4 != null)
					{
						component4.AddForce((component4.position - instance.transform.position).normalized * 25f, ForceMode.Impulse);
					}
				}
			}
		}
		if (toggleIceTouch)
		{
			int num2 = Physics.OverlapSphereNonAlloc(instance.transform.position, 1f, _overlapBuf);
			for (int l = 0; l < num2; l++)
			{
				MonkeDevNetworkingPlayer componentInParent2 = _overlapBuf[l].GetComponentInParent<MonkeDevNetworkingPlayer>();
				if (componentInParent2 != null && componentInParent2 != MonkeDevNetworkingManager.Manager.LocalPlayer)
				{
					Rigidbody component5 = componentInParent2.GetComponent<Rigidbody>();
					if (component5 != null)
					{
						component5.linearVelocity = Vector3.zero;
						component5.angularVelocity = Vector3.zero;
					}
				}
			}
		}
		if (toggleNinjaMode)
		{
			instance.velocityLimit = 30f;
			MonkeDevNetworkingManager.Manager.LocalPlayer.canTrack = false;
		}
		if (toggleVampireMode)
		{
			MonkeDevNetworkingManager manager3 = MonkeDevNetworkingManager.Manager;
			List<MonkeDevNetworkingPlayer> list3 = manager3?.Players;
			if (list3 != null)
			{
				MonkeDevNetworkingPlayer localPlayer3 = manager3.LocalPlayer;
				Vector3 position = instance.transform.position;
				for (int m = 0; m < list3.Count; m++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer3 = list3[m];
					if (!(monkeDevNetworkingPlayer3 == null) && !(monkeDevNetworkingPlayer3 == localPlayer3) && (position - monkeDevNetworkingPlayer3.transform.position).sqrMagnitude < 25f)
					{
						monkeDevNetworkingPlayer3.GetComponent<Rigidbody>()?.AddForce((position - monkeDevNetworkingPlayer3.transform.position).normalized * 3f);
					}
				}
			}
		}
		if (toggleTelekinesis && RightPrimary && Physics.Raycast(instance.headCollider.transform.position, instance.headCollider.transform.forward, out var hitInfo6, 15f))
		{
			Rigidbody component6 = hitInfo6.collider.GetComponent<Rigidbody>();
			if (component6 != null)
			{
				Vector3 vector2 = instance.headCollider.transform.position + instance.headCollider.transform.forward * 5f;
				component6.AddForce((vector2 - component6.position).normalized * 10f);
			}
		}
		if (toggleWindGust)
		{
			int num3 = Physics.OverlapSphereNonAlloc(instance.transform.position, 8f, _overlapBuf);
			for (int n = 0; n < num3; n++)
			{
				Rigidbody component7 = _overlapBuf[n].GetComponent<Rigidbody>();
				if (component7 != null && component7 != instance.playerRigidBody)
				{
					component7.AddForce(instance.headCollider.transform.forward * 5f);
				}
			}
		}
		if (toggleFlashMode && LeftSecondary && RightSecondary)
		{
			instance.playerRigidBody.linearVelocity = instance.headCollider.transform.forward * 40f;
		}
		bool flag5 = false;
		if (toggleWallClimb && Physics.Raycast(instance.transform.position, instance.transform.forward, 1f))
		{
			instance.playerRigidBody.linearVelocity = new Vector3(0f, 2f, 0f);
			flag5 = true;
		}
		if (toggleRocketHands)
		{
			if (LeftTrigger > 0.5f && leftHandTransform != null)
			{
				instance.playerRigidBody.AddForce(-leftHandTransform.forward * 20f * LeftTrigger);
			}
			if (RightTrigger > 0.5f && rightHandTransform != null)
			{
				instance.playerRigidBody.AddForce(-rightHandTransform.forward * 20f * RightTrigger);
			}
		}
		if (toggleMagnetHands)
		{
			int num4 = Physics.OverlapSphereNonAlloc(instance.transform.position, 5f, _overlapBuf);
			int layerGrabbable = LayerGrabbable;
			for (int num5 = 0; num5 < num4; num5++)
			{
				Collider collider = _overlapBuf[num5];
				if (collider.gameObject.layer == layerGrabbable)
				{
					collider.attachedRigidbody?.AddForce((instance.transform.position - collider.transform.position).normalized * 10f);
				}
			}
		}
		if (toggleSizeRainbow)
		{
			sizeRainbowTime += Time.deltaTime * 2f;
			SetScale(Mathf.PingPong(sizeRainbowTime, 2f) + 0.5f);
			UpdateSizeDisplay();
		}
		if (toggleSpinMode)
		{
			instance.transform.Rotate(0f, spinSpeed * Time.deltaTime, 0f);
		}
		if (toggleEarthquake)
		{
			earthquakeTimer += Time.deltaTime;
			if (earthquakeTimer > 0.1f)
			{
				if (Camera.main != null)
				{
					Camera.main.transform.position += new Vector3(UnityEngine.Random.Range(-0.1f, 0.1f), UnityEngine.Random.Range(-0.1f, 0.1f), 0f);
				}
				earthquakeTimer = 0f;
			}
		}
		bool flag6 = !(flag || flag4 || flag5 || toggleAirSwim);
		if (instance.playerRigidBody.useGravity != flag6 && !LethalApeR.Gameplay.RigHold.Anyone(LethalApeR.Gameplay.RigHold.What.Gravity))
		{
			instance.playerRigidBody.useGravity = flag6;
		}
	}

	private void HandleGhostMonkey()
	{
		if (IsAllowedToUseMods())
		{
			if (toggleGhostMonke)
			{
				if (MonkeDevNetworkingManager.Manager.LocalPlayer != null)
				{
					MonkeDevNetworkingManager.Manager.LocalPlayer.canTrack = !LeftSecondary;
				}
			}
			else if (MonkeDevNetworkingManager.Manager.LocalPlayer != null)
			{
				MonkeDevNetworkingManager.Manager.LocalPlayer.canTrack = true;
			}
		}
		else
		{
			if (MonkeDevNetworkingManager.Manager.LocalPlayer != null)
			{
				MonkeDevNetworkingManager.Manager.LocalPlayer.canTrack = true;
			}
			toggleGhostMonke = false;
		}
	}

	private void HandleFly()
	{
		if (IsAllowedToUseMods() && toggleFly)
		{
			Player instance = Player.Instance;
			if (!(instance == null) && RightSecondary)
			{
				instance.playerRigidBody.AddForce(instance.headCollider.transform.forward * FlyForce, ForceMode.VelocityChange);
			}
		}
	}

	private void HandleAirSwim()
	{
		if (IsAllowedToUseMods() && toggleAirSwim && (LeftVelocity.magnitude > 3.5f || RightVelocity.magnitude > 3.5f))
		{
			Player.Instance.playerRigidBody.AddRelativeForce((LeftVelocity + RightVelocity) * -50f, ForceMode.Force);
		}
	}

	private void HandleNoBodyCollider()
	{
		if (IsAllowedToUseMods() && toggleNoBodyCollider && Player.Instance.bodyCollider.gameObject.activeSelf)
		{
			Player.Instance.bodyCollider.gameObject.SetActive(false);
		}
	}

	private void HandlePlatforms()
	{
		if (!IsAllowedToUseMods() || !togglePlatforms)
		{
			if (leftPlatform != null && leftPlatform.activeSelf)
			{
				leftPlatform.SetActive(false);
			}
			if (rightPlatform != null && rightPlatform.activeSelf)
			{
				rightPlatform.SetActive(false);
			}
			_leftPlatformHeld = false;
			_rightPlatformHeld = false;
			if (togglePlatforms)
			{
				togglePlatforms = false;
			}
		}
		else
		{
			if (platformPrefab == null || Player.Instance == null)
			{
				return;
			}
			if (leftPlatform == null)
			{
				leftPlatform = UnityEngine.Object.Instantiate(platformPrefab);
				leftPlatform.transform.SetParent(null, worldPositionStays: true);
				Rigidbody component = leftPlatform.GetComponent<Rigidbody>();
				if (component != null)
				{
					component.isKinematic = true;
					component.useGravity = false;
				}
				leftPlatform.SetActive(false);
			}
			if (rightPlatform == null)
			{
				rightPlatform = UnityEngine.Object.Instantiate(platformPrefab);
				rightPlatform.transform.SetParent(null, worldPositionStays: true);
				Rigidbody component2 = rightPlatform.GetComponent<Rigidbody>();
				if (component2 != null)
				{
					component2.isKinematic = true;
					component2.useGravity = false;
				}
				rightPlatform.SetActive(false);
			}
			float leftGrip = LeftGrip;
			float rightGrip = RightGrip;
			if (leftGrip > 0.5f)
			{
				if (!_leftPlatformHeld)
				{
					leftPlatform.transform.position = Player.Instance.leftHandFollower.position + Vector3.down * platformVerticalOffset;
					leftPlatform.transform.rotation = Quaternion.identity;
					leftPlatform.SetActive(true);
					_leftPlatformHeld = true;
				}
			}
			else if (_leftPlatformHeld)
			{
				leftPlatform.SetActive(false);
				_leftPlatformHeld = false;
			}
			if (rightGrip > 0.5f)
			{
				if (!_rightPlatformHeld)
				{
					rightPlatform.transform.position = Player.Instance.rightHandFollower.position + Vector3.down * platformVerticalOffset;
					rightPlatform.transform.rotation = Quaternion.identity;
					rightPlatform.SetActive(true);
					_rightPlatformHeld = true;
				}
			}
			else if (_rightPlatformHeld)
			{
				rightPlatform.SetActive(false);
				_rightPlatformHeld = false;
			}
		}
	}

	private void HandlePlayerPickup()
	{
		if (!IsAllowedToUseMods() || !togglePlayerPickup)
		{
			if (leftGrabbedPlayer != null)
			{
				leftGrabbedPlayer.ReleasePlayer();
				leftGrabbedPlayer = null;
			}
			if (rightGrabbedPlayer != null)
			{
				rightGrabbedPlayer.ReleasePlayer();
				rightGrabbedPlayer = null;
			}
		}
		else
		{
			if (leftHandTransform == null || rightHandTransform == null)
			{
				return;
			}
			float leftGrip = LeftGrip;
			float rightGrip = RightGrip;
			if (leftGrip > 0.67f)
			{
				if (leftGrabbedPlayer == null)
				{
					int num = Physics.OverlapSphereNonAlloc(leftHandTransform.position, 0.3f, _overlapBuf);
					for (int i = 0; i < num; i++)
					{
						MonkeDevNetworkingPlayer componentInParent = _overlapBuf[i].GetComponentInParent<MonkeDevNetworkingPlayer>();
						if (componentInParent != null && componentInParent != MonkeDevNetworkingManager.Manager.LocalPlayer)
						{
							componentInParent.GrabPlayer(MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.OwnerActorNr, isLeftHand: true);
							leftGrabbedPlayer = componentInParent;
							break;
						}
					}
				}
			}
			else if (leftGrabbedPlayer != null)
			{
				leftGrabbedPlayer.ReleasePlayer();
				leftGrabbedPlayer = null;
			}
			if (rightGrip > 0.67f)
			{
				if (!(rightGrabbedPlayer == null))
				{
					return;
				}
				int num2 = Physics.OverlapSphereNonAlloc(rightHandTransform.position, 0.3f, _overlapBuf);
				for (int j = 0; j < num2; j++)
				{
					MonkeDevNetworkingPlayer componentInParent2 = _overlapBuf[j].GetComponentInParent<MonkeDevNetworkingPlayer>();
					if (componentInParent2 != null && componentInParent2 != MonkeDevNetworkingManager.Manager.LocalPlayer)
					{
						componentInParent2.GrabPlayer(MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.OwnerActorNr, isLeftHand: false);
						rightGrabbedPlayer = componentInParent2;
						break;
					}
				}
			}
			else if (rightGrabbedPlayer != null)
			{
				rightGrabbedPlayer.ReleasePlayer();
				rightGrabbedPlayer = null;
			}
		}
	}

	public void ToggleRGB()
	{
		if (!IsAllowedToUseMods())
		{
			toggleRGB = false;
		}
		else if (HasAccessToFeature("RGB"))
		{
			toggleRGB = !toggleRGB;
			MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.RPC("SetRGBMonkey", RpcTarget.AllBuffered, toggleRGB);
		}
	}

	public void ToggleSpeedBoost()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.jumpMultiplier = originalJumpMultiplier;
			toggleSpeedBoost = false;
		}
		else if (HasAccessToFeature("SpeedBoost"))
		{
			toggleSpeedBoost = !toggleSpeedBoost;
			if (toggleSpeedBoost)
			{
				Player.Instance.jumpMultiplier = originalJumpMultiplier * 2f;
				toggleExtraSpeedBoost = false;
			}
			else
			{
				Player.Instance.jumpMultiplier = originalJumpMultiplier;
			}
		}
	}

	public void ToggleExtraSpeedBoost()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.jumpMultiplier = originalJumpMultiplier;
			toggleExtraSpeedBoost = false;
			return;
		}
		toggleExtraSpeedBoost = !toggleExtraSpeedBoost;
		if (toggleExtraSpeedBoost)
		{
			Player.Instance.jumpMultiplier = originalJumpMultiplier * 5f;
			toggleSpeedBoost = false;
		}
		else
		{
			Player.Instance.jumpMultiplier = originalJumpMultiplier;
		}
	}

	public void ToggleLongArms()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.rightHandOffset = Vector3.zero;
			Player.Instance.leftHandOffset = Vector3.zero;
			toggleLongArms = false;
		}
		else if (HasAccessToFeature("LongArms"))
		{
			toggleLongArms = !toggleLongArms;
			if (toggleLongArms)
			{
				Player.Instance.rightHandOffset = new Vector3(0f, 0f, 0.25f);
				Player.Instance.leftHandOffset = new Vector3(0f, 0f, 0.25f);
			}
			else
			{
				Player.Instance.rightHandOffset = Vector3.zero;
				Player.Instance.leftHandOffset = Vector3.zero;
			}
		}
	}

	public void ToggleFly()
	{
		if (!IsAllowedToUseMods())
		{
			toggleFly = false;
		}
		else if (HasAccessToFeature("Fly"))
		{
			toggleFly = !toggleFly;
		}
	}

	public void ToggleGhostMonkey()
	{
		if (IsAllowedToUseMods())
		{
			toggleGhostMonke = !toggleGhostMonke;
		}
		else
		{
			toggleGhostMonke = false;
		}
	}

	public void ToggleLowGravity()
	{
		if (!IsAllowedToUseMods())
		{
			Physics.gravity = _projectGravity;
			toggleLowGravity = false;
			return;
		}
		toggleLowGravity = !toggleLowGravity;
		if (toggleLowGravity)
		{
			toggleFlipGravity = false;
			Physics.gravity = new Vector3(0f, -6.81f, 0f);
		}
		else
		{
			Physics.gravity = _projectGravity;
		}
	}

	public void ToggleFlipGravity()
	{
		if (!IsAllowedToUseMods())
		{
			Physics.gravity = _projectGravity;
			toggleFlipGravity = false;
			return;
		}
		toggleFlipGravity = !toggleFlipGravity;
		if (toggleFlipGravity)
		{
			toggleLowGravity = false;
		}
		Physics.gravity = -Physics.gravity;
	}

	public void ToggleAirSwim()
	{
		bool flag = LethalApeR.Gameplay.RigHold.Anyone(LethalApeR.Gameplay.RigHold.What.Gravity);
		if (!IsAllowedToUseMods())
		{
			if (!flag)
			{
				Player.Instance.playerRigidBody.useGravity = true;
			}
			toggleAirSwim = false;
			return;
		}
		toggleAirSwim = !toggleAirSwim;
		if (!flag)
		{
			Player.Instance.playerRigidBody.useGravity = !toggleAirSwim;
		}
	}

	public void TogglePlatforms()
	{
		if (IsAllowedToUseMods())
		{
			togglePlatforms = !togglePlatforms;
		}
		else
		{
			togglePlatforms = false;
		}
	}

	public void ToggleInfiniteArms()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.maxArmLength = originalMaxArmLength;
			toggleInfiniteArms = false;
			return;
		}
		toggleInfiniteArms = !toggleInfiniteArms;
		if (toggleInfiniteArms)
		{
			Player.Instance.maxArmLength = 999f;
		}
		else
		{
			Player.Instance.maxArmLength = originalMaxArmLength;
		}
	}

	public void ToggleNoSlip()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.iceThreshold = originalIceThreshold;
			toggleNoSlip = false;
		}
		else
		{
			toggleNoSlip = !toggleNoSlip;
			Player.Instance.iceThreshold = (toggleNoSlip ? 0f : originalIceThreshold);
		}
	}

	public void ToggleSpeedHack()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.velocityLimit = originalVelocityLimit;
			toggleSpeedHack = false;
			return;
		}
		toggleSpeedHack = !toggleSpeedHack;
		if (toggleSpeedHack)
		{
			Player.Instance.velocityLimit = 999f;
		}
		else
		{
			Player.Instance.velocityLimit = originalVelocityLimit;
		}
	}

	public void ToggleSuperJump()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.maxJumpSpeed = originalMaxJumpSpeed;
			toggleSuperJump = false;
			return;
		}
		toggleSuperJump = !toggleSuperJump;
		if (toggleSuperJump)
		{
			Player.Instance.maxJumpSpeed = 50f;
		}
		else
		{
			Player.Instance.maxJumpSpeed = originalMaxJumpSpeed;
		}
	}

	public void ToggleIronGrip()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.defaultSlideFactor = originalSlideFactor;
			toggleIronGrip = false;
		}
		else
		{
			toggleIronGrip = !toggleIronGrip;
			Player.Instance.defaultSlideFactor = (toggleIronGrip ? 0f : originalSlideFactor);
		}
	}

	public void ToggleNoFriction()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.frictionConstant = originalFrictionConstant;
			toggleNoFriction = false;
		}
		else
		{
			toggleNoFriction = !toggleNoFriction;
			Player.Instance.frictionConstant = (toggleNoFriction ? 0f : originalFrictionConstant);
		}
	}

	public void ToggleInstantStick()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.stickDepth = originalStickDepth;
			toggleInstantStick = false;
		}
		else
		{
			toggleInstantStick = !toggleInstantStick;
			Player.Instance.stickDepth = (toggleInstantStick ? 0f : originalStickDepth);
		}
	}

	public void ToggleNoBodyCollider()
	{
		if (IsAllowedToUseMods())
		{
			toggleNoBodyCollider = !toggleNoBodyCollider;
			return;
		}
		Player.Instance.bodyCollider.gameObject.SetActive(originalBodyColliderState);
		toggleNoBodyCollider = false;
	}

	public void TogglePlayerPickup()
	{
		if (IsAllowedToUseMods())
		{
			togglePlayerPickup = !togglePlayerPickup;
		}
		else
		{
			togglePlayerPickup = false;
		}
	}

	public void ToggleStickyHands()
	{
		if (IsAllowedToUseMods())
		{
			toggleStickyHands = !toggleStickyHands;
		}
		else
		{
			toggleStickyHands = false;
		}
	}

	public void ToggleDoubleJump()
	{
		if (IsAllowedToUseMods())
		{
			toggleDoubleJump = !toggleDoubleJump;
		}
		else
		{
			toggleDoubleJump = false;
		}
	}

	public void ToggleDashAbility()
	{
		if (IsAllowedToUseMods())
		{
			toggleDashAbility = !toggleDashAbility;
		}
		else
		{
			toggleDashAbility = false;
		}
	}

	public void ToggleWallRun()
	{
		if (IsAllowedToUseMods())
		{
			toggleWallRun = !toggleWallRun;
		}
		else
		{
			toggleWallRun = false;
		}
	}

	public void ToggleGrappleHands()
	{
		if (IsAllowedToUseMods())
		{
			toggleGrappleHands = !toggleGrappleHands;
		}
		else
		{
			toggleGrappleHands = false;
		}
	}

	public void TogglePlayerESP()
	{
		if (IsAllowedToUseMods())
		{
			togglePlayerESP = !togglePlayerESP;
		}
		else
		{
			togglePlayerESP = false;
		}
	}

	public void ToggleFreezeOthers()
	{
		if (IsAllowedToUseMods())
		{
			toggleFreezeOthers = !toggleFreezeOthers;
		}
		else
		{
			toggleFreezeOthers = false;
		}
	}

	public void ToggleSlipperyMode()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.iceThreshold = originalIceThreshold;
			toggleSlipperyMode = false;
			return;
		}
		toggleSlipperyMode = !toggleSlipperyMode;
		if (toggleSlipperyMode)
		{
			Player.Instance.iceThreshold = 999f;
		}
		else
		{
			Player.Instance.iceThreshold = originalIceThreshold;
		}
	}

	public void ToggleAutoJump()
	{
		if (IsAllowedToUseMods())
		{
			toggleAutoJump = !toggleAutoJump;
		}
		else
		{
			toggleAutoJump = false;
		}
	}

	public void ToggleSpeedTrails()
	{
		if (IsAllowedToUseMods())
		{
			toggleSpeedTrails = !toggleSpeedTrails;
		}
		else
		{
			toggleSpeedTrails = false;
		}
	}

	public void TogglePlayerMagnet()
	{
		if (IsAllowedToUseMods())
		{
			togglePlayerMagnet = !togglePlayerMagnet;
		}
		else
		{
			togglePlayerMagnet = false;
		}
	}

	public void ToggleSuperStrength()
	{
		if (IsAllowedToUseMods())
		{
			toggleSuperStrength = !toggleSuperStrength;
		}
		else
		{
			toggleSuperStrength = false;
		}
	}

	public void ToggleXRayVision()
	{
		if (IsAllowedToUseMods())
		{
			toggleXRayVision = !toggleXRayVision;
		}
		else
		{
			toggleXRayVision = false;
		}
	}

	public void ToggleZeroFriction()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.frictionConstant = originalFrictionConstant;
			toggleZeroFriction = false;
			return;
		}
		toggleZeroFriction = !toggleZeroFriction;
		if (toggleZeroFriction)
		{
			Player.Instance.frictionConstant = 0.001f;
		}
		else
		{
			Player.Instance.frictionConstant = originalFrictionConstant;
		}
	}

	public void ToggleMoonGravity()
	{
		if (!IsAllowedToUseMods())
		{
			Physics.gravity = _projectGravity;
			toggleMoonGravity = false;
			return;
		}
		toggleMoonGravity = !toggleMoonGravity;
		if (toggleMoonGravity)
		{
			Physics.gravity = new Vector3(0f, -1.62f, 0f);
		}
		else
		{
			Physics.gravity = _projectGravity;
		}
	}

	public void TeleportForward()
	{
		if (IsAllowedToUseMods())
		{
			Vector3 forward = Player.Instance.headCollider.transform.forward;
			forward.y = 0f;
			Vector3 vector = forward.normalized * 5f;
			Player.Instance.TeleportPlayerRaw(Player.Instance.transform.position + vector, Player.Instance.transform.rotation);
		}
	}

	public void SetCheckpoint()
	{
		if (IsAllowedToUseMods())
		{
			checkpointPosition = Player.Instance.transform.position;
			toggleCheckpoint = true;
		}
	}

	public void TeleportToCheckpoint()
	{
		if (IsAllowedToUseMods() && toggleCheckpoint)
		{
			Player.Instance.TeleportPlayerRaw(checkpointPosition, Player.Instance.transform.rotation);
		}
	}

	public void TeleportToSpawn()
	{
		if (IsAllowedToUseMods() && !(Player.Instance == null))
		{
			if (Player.Instance.spawnPosition != null)
			{
				Player.Instance.TeleportPlayerRaw(Player.Instance.spawnPosition.position, Quaternion.identity);
			}
			else
			{
				Player.Instance.TeleportPlayerRaw(Player.Instance.transform.position + Vector3.up * 2f, Quaternion.identity);
			}
		}
	}

	public void ToggleTeleportToRandom()
	{
		if (!IsAllowedToUseMods())
		{
			return;
		}
		List<MonkeDevNetworkingPlayer> list = MonkeDevNetworkingManager.Manager?.Players;
		if (list == null)
		{
			return;
		}
		MonkeDevNetworkingPlayer localPlayer = MonkeDevNetworkingManager.Manager.LocalPlayer;
		int num = 0;
		for (int i = 0; i < list.Count; i++)
		{
			if (list[i] != null && list[i] != localPlayer)
			{
				num++;
			}
		}
		if (num == 0)
		{
			return;
		}
		int num2 = UnityEngine.Random.Range(0, num);
		for (int j = 0; j < list.Count; j++)
		{
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = list[j];
			if (!(monkeDevNetworkingPlayer == null) && !(monkeDevNetworkingPlayer == localPlayer))
			{
				if (num2 == 0)
				{
					Player.Instance.TeleportPlayerRaw(monkeDevNetworkingPlayer.transform.position + Vector3.up * 2f, Player.Instance.transform.rotation);
					break;
				}
				num2--;
			}
		}
	}

	public void LaunchPlayerUp()
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.playerRigidBody.AddForce(Vector3.up * 30f, ForceMode.VelocityChange);
		}
	}

	public void FreezePlayer()
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.playerRigidBody.linearVelocity = Vector3.zero;
			Player.Instance.playerRigidBody.angularVelocity = Vector3.zero;
		}
	}

	public void ResetRotation()
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.transform.rotation = Quaternion.identity;
			Player.Instance.InitializeValues();
		}
	}

	public void ToggleBulletTime()
	{
		if (!IsAllowedToUseMods())
		{
			Time.timeScale = 1f;
			Time.fixedDeltaTime = _projectFixedDeltaTime;
			toggleBulletTime = false;
			return;
		}
		toggleBulletTime = !toggleBulletTime;
		Time.timeScale = (toggleBulletTime ? 0.3f : 1f);
		if (toggleBulletTime)
		{
			Time.fixedDeltaTime = _projectFixedDeltaTime * Time.timeScale;
		}
		else
		{
			Time.fixedDeltaTime = _projectFixedDeltaTime;
		}
	}

	public void ToggleGravityGun()
	{
		if (IsAllowedToUseMods())
		{
			toggleGravityGun = !toggleGravityGun;
		}
		else
		{
			toggleGravityGun = false;
		}
	}

	public void ToggleLightningHands()
	{
		if (IsAllowedToUseMods())
		{
			toggleLightningHands = !toggleLightningHands;
		}
		else
		{
			toggleLightningHands = false;
		}
	}

	public void ToggleSpiderClimb()
	{
		if (IsAllowedToUseMods())
		{
			toggleSpiderClimb = !toggleSpiderClimb;
		}
		else
		{
			toggleSpiderClimb = false;
		}
	}

	public void ToggleJetpack()
	{
		if (IsAllowedToUseMods())
		{
			toggleJetpack = !toggleJetpack;
		}
		else
		{
			toggleJetpack = false;
		}
	}

	public void ToggleExplosiveTouch()
	{
		if (IsAllowedToUseMods())
		{
			toggleExplosiveTouch = !toggleExplosiveTouch;
		}
		else
		{
			toggleExplosiveTouch = false;
		}
	}

	public void ToggleIceTouch()
	{
		if (IsAllowedToUseMods())
		{
			toggleIceTouch = !toggleIceTouch;
		}
		else
		{
			toggleIceTouch = false;
		}
	}

	public void ToggleForcePush()
	{
		if (IsAllowedToUseMods())
		{
			toggleForcePush = !toggleForcePush;
		}
		else
		{
			toggleForcePush = false;
		}
	}

	public void ActivateShockwave()
	{
		if (!IsAllowedToUseMods() || Time.time - lastShockwaveTime < shockwaveCooldown)
		{
			return;
		}
		lastShockwaveTime = Time.time;
		int num = Physics.OverlapSphereNonAlloc(Player.Instance.transform.position, 10f, _overlapBuf);
		for (int i = 0; i < num; i++)
		{
			Rigidbody component = _overlapBuf[i].GetComponent<Rigidbody>();
			if (component != null && component != Player.Instance.playerRigidBody)
			{
				Vector3 normalized = (component.transform.position - Player.Instance.transform.position).normalized;
				component.AddForce(normalized * 50f, ForceMode.Impulse);
			}
		}
	}

	public void ActivateForcePush()
	{
		if (!IsAllowedToUseMods() || Time.time - lastForcePushTime < forcePushCooldown)
		{
			return;
		}
		lastForcePushTime = Time.time;
		Vector3 forward = Player.Instance.headCollider.transform.forward;
		RaycastHit[] array = Physics.SphereCastAll(Player.Instance.headCollider.transform.position, 2f, forward, 15f);
		foreach (RaycastHit raycastHit in array)
		{
			Rigidbody component = raycastHit.collider.GetComponent<Rigidbody>();
			if (component != null && component != Player.Instance.playerRigidBody)
			{
				component.AddForce(forward * 30f, ForceMode.Impulse);
			}
		}
	}

	public void ToggleNinjaMode()
	{
		if (IsAllowedToUseMods())
		{
			toggleNinjaMode = !toggleNinjaMode;
		}
		else
		{
			toggleNinjaMode = false;
		}
	}

	public void ToggleVampireMode()
	{
		if (IsAllowedToUseMods())
		{
			toggleVampireMode = !toggleVampireMode;
		}
		else
		{
			toggleVampireMode = false;
		}
	}

	public void ToggleShieldBubble()
	{
		if (IsAllowedToUseMods())
		{
			toggleShieldBubble = !toggleShieldBubble;
		}
		else
		{
			toggleShieldBubble = false;
		}
	}

	public void ToggleSuperSpeed()
	{
		if (!IsAllowedToUseMods())
		{
			Player.Instance.jumpMultiplier = originalJumpMultiplier;
			Player.Instance.velocityLimit = originalVelocityLimit;
			toggleSuperSpeed = false;
			return;
		}
		toggleSuperSpeed = !toggleSuperSpeed;
		if (toggleSuperSpeed)
		{
			Player.Instance.jumpMultiplier = 5f;
			Player.Instance.velocityLimit = 50f;
		}
		else
		{
			Player.Instance.jumpMultiplier = originalJumpMultiplier;
			Player.Instance.velocityLimit = originalVelocityLimit;
		}
	}

	public void ToggleGiantMode()
	{
		if (!IsAllowedToUseMods())
		{
			SetScale(1f);
			toggleGiantMode = false;
		}
		else
		{
			toggleGiantMode = !toggleGiantMode;
			SetScale(toggleGiantMode ? 3f : 1f);
		}
	}

	public void ToggleFlashMode()
	{
		if (IsAllowedToUseMods())
		{
			toggleFlashMode = !toggleFlashMode;
		}
		else
		{
			toggleFlashMode = false;
		}
	}

	public void ToggleTelekinesis()
	{
		if (IsAllowedToUseMods())
		{
			toggleTelekinesis = !toggleTelekinesis;
		}
		else
		{
			toggleTelekinesis = false;
		}
	}

	public void ToggleWindGust()
	{
		if (IsAllowedToUseMods())
		{
			toggleWindGust = !toggleWindGust;
		}
		else
		{
			toggleWindGust = false;
		}
	}

	public void ToggleFireTrail()
	{
		if (IsAllowedToUseMods())
		{
			toggleFireTrail = !toggleFireTrail;
		}
		else
		{
			toggleFireTrail = false;
		}
	}

	public void MeteorShower()
	{
		if (IsAllowedToUseMods())
		{
			StartCoroutine(MeteorShowerCoroutine());
		}
	}

	private IEnumerator MeteorShowerCoroutine()
	{
		for (int i = 0; i < 10; i++)
		{
			Vector3 position = Player.Instance.transform.position + new Vector3(UnityEngine.Random.Range(-10f, 10f), 20f, UnityEngine.Random.Range(-10f, 10f));
			GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere);
			gameObject.transform.position = position;
			gameObject.transform.localScale = Vector3.one * 0.5f;
			gameObject.AddComponent<Rigidbody>().AddForce(Vector3.down * 20f, ForceMode.Impulse);
			UnityEngine.Object.Destroy(gameObject, 5f);
			yield return new WaitForSeconds(0.3f);
		}
	}

	public void SpawnClone()
	{
		if (IsAllowedToUseMods())
		{
			GameObject gameObject = new GameObject("PlayerClone");
			gameObject.transform.position = Player.Instance.transform.position;
			gameObject.transform.rotation = Player.Instance.transform.rotation;
			gameObject.AddComponent<Rigidbody>().mass = 10f;
			clones.Add(gameObject);
			if (clones.Count > 5)
			{
				UnityEngine.Object.Destroy(clones[0]);
				clones.RemoveAt(0);
			}
		}
	}

	public void DestroyAllClones()
	{
		if (!IsAllowedToUseMods())
		{
			return;
		}
		foreach (GameObject clone in clones)
		{
			if (clone != null)
			{
				UnityEngine.Object.Destroy(clone);
			}
		}
		clones.Clear();
	}

	public void ToggleSuperRGB()
	{
		if (IsAllowedToUseMods())
		{
			toggleSuperRGB = !toggleSuperRGB;
			if (toggleSuperRGB)
			{
				StartCoroutine(SuperRGBEffect());
			}
		}
		else
		{
			MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.RPC("SetRGBMonkey", RpcTarget.All, false);
			toggleSuperRGB = false;
		}
	}

	private IEnumerator SuperRGBEffect()
	{
		while (toggleSuperRGB)
		{
			MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.RPC("SetRGBMonkey", RpcTarget.All, true);
			yield return new WaitForSeconds(0.05f);
			MonkeDevNetworkingManager.Manager.LocalPlayer.photonView.RPC("SetRGBMonkey", RpcTarget.All, false);
			yield return new WaitForSeconds(0.05f);
		}
	}

	public void ToggleWallClimb()
	{
		if (IsAllowedToUseMods())
		{
			toggleWallClimb = !toggleWallClimb;
		}
		else
		{
			toggleWallClimb = false;
		}
	}

	public void ToggleBouncyMode()
	{
		if (IsAllowedToUseMods())
		{
			toggleBouncyMode = !toggleBouncyMode;
			if (toggleBouncyMode)
			{
				StartCoroutine(BouncyEffect());
			}
		}
		else
		{
			toggleBouncyMode = false;
		}
	}

	private IEnumerator BouncyEffect()
	{
		while (toggleBouncyMode)
		{
			if (Physics.Raycast(Player.Instance.transform.position, Vector3.down, 0.5f))
			{
				Player.Instance.playerRigidBody.AddForce(Vector3.up * 15f, ForceMode.Impulse);
			}
			yield return new WaitForSeconds(0.1f);
		}
	}

	public void ToggleInvisible()
	{
		if (IsAllowedToUseMods())
		{
			toggleInvisible = !toggleInvisible;
			MonkeDevNetworkingManager.Manager.LocalPlayer.canTrack = !toggleInvisible;
		}
		else
		{
			MonkeDevNetworkingManager.Manager.LocalPlayer.canTrack = true;
			toggleInvisible = false;
		}
	}

	public void ToggleRocketHands()
	{
		if (IsAllowedToUseMods())
		{
			toggleRocketHands = !toggleRocketHands;
		}
		else
		{
			toggleRocketHands = false;
		}
	}

	public void ToggleMagnetHands()
	{
		if (IsAllowedToUseMods())
		{
			toggleMagnetHands = !toggleMagnetHands;
		}
		else
		{
			toggleMagnetHands = false;
		}
	}

	public void ToggleSizeRainbow()
	{
		if (IsAllowedToUseMods())
		{
			toggleSizeRainbow = !toggleSizeRainbow;
			return;
		}
		SetScale(1f);
		toggleSizeRainbow = false;
	}

	public void ToggleSpinMode()
	{
		if (IsAllowedToUseMods())
		{
			toggleSpinMode = !toggleSpinMode;
			spinSpeed = (toggleSpinMode ? 360f : 0f);
		}
		else
		{
			toggleSpinMode = false;
			spinSpeed = 0f;
		}
	}

	public void ToggleEarthquake()
	{
		if (IsAllowedToUseMods())
		{
			toggleEarthquake = !toggleEarthquake;
		}
		else
		{
			toggleEarthquake = false;
		}
	}

	public void TogglePhaseWalls()
	{
		if (IsAllowedToUseMods())
		{
			togglePhaseWalls = !togglePhaseWalls;
			Collider[] array = UnityEngine.Object.FindObjectsOfType<Collider>();
			foreach (Collider collider in array)
			{
				if (collider.gameObject.layer == LayerMask.NameToLayer("Default"))
				{
					collider.isTrigger = togglePhaseWalls;
				}
			}
			return;
		}
		Collider[] array2 = UnityEngine.Object.FindObjectsOfType<Collider>();
		foreach (Collider collider2 in array2)
		{
			if (collider2.gameObject.layer == LayerMask.NameToLayer("Default"))
			{
				collider2.isTrigger = false;
			}
		}
		togglePhaseWalls = false;
	}

	public void ToggleSuperSlide()
	{
		if (IsAllowedToUseMods())
		{
			toggleSuperSlide = !toggleSuperSlide;
			Player.Instance.defaultSlideFactor = (toggleSuperSlide ? 99f : originalSlideFactor);
		}
		else
		{
			Player.Instance.defaultSlideFactor = originalSlideFactor;
			toggleSuperSlide = false;
		}
	}

	public void ToggleDiscoMode()
	{
		if (IsAllowedToUseMods())
		{
			toggleDiscoMode = !toggleDiscoMode;
			if (toggleDiscoMode)
			{
				if (!_ambientSaved)
				{
					_sceneAmbient = RenderSettings.ambientLight;
					_ambientSaved = true;
				}
				StartCoroutine(DiscoEffect());
				return;
			}
		}
		StopDisco();
	}

	private void StopDisco()
	{
		toggleDiscoMode = false;
		if (_ambientSaved)
		{
			RenderSettings.ambientLight = _sceneAmbient;
		}
		_ambientSaved = false;
	}

	private IEnumerator DiscoEffect()
	{
		while (toggleDiscoMode)
		{
			RenderSettings.ambientLight = new Color(UnityEngine.Random.value, UnityEngine.Random.value, UnityEngine.Random.value, 1f);
			yield return new WaitForSeconds(0.2f);
		}
	}

	public void ToggleMonsterSkin()
	{
		string value = null;
		if (LethalApeR.Gameplay.BeTheMonster.BTMGameManager.Instance != null)
		{
			toggleMonsterSkin = false;
			return;
		}
		if (!IsAllowedToUseMods())
		{
			DisableMonsterSkinMod();
			return;
		}
		toggleMonsterSkin = !toggleMonsterSkin;
		MonkeDevNetworkingPlayer localPlayer = MonkeDevNetworkingManager.Manager.LocalPlayer;
		if (localPlayer == null || localPlayer.gameModePlayer == null)
		{
			return;
		}
		GameModePlayer gameModePlayer = localPlayer.gameModePlayer;
		if (!toggleMonsterSkin)
		{
			DisableMonsterSkinMod();
			return;
		}
		gameModePlayer.SetMonsterRigsActive(true);
		gameModePlayer.apeRig.SetActive(false);
		value = "";
		MonkeDevNetworkingManager.Manager.Cosmetics.TryGetValue("MonsterSkin", out value);
		if (gameModePlayer.availableMonsters != null)
		{
			for (int i = 0; i < gameModePlayer.availableMonsters.Length; i++)
			{
				GameModePlayer.MonsterEntry monsterEntry = gameModePlayer.availableMonsters[i];
				if (!(monsterEntry.MonsterGameObject == null))
				{
					bool active = ((!string.IsNullOrEmpty(value)) ? (monsterEntry.MonsterName == value) : (i == 0));
					monsterEntry.MonsterGameObject.SetActive(active);
				}
			}
		}
		localPlayer.photonView.RPC("RPC_SetMonsterSkinMod", RpcTarget.OthersBuffered, true, value);
	}

	private void DisableMonsterSkinMod()
	{
		toggleMonsterSkin = false;
		MonkeDevNetworkingPlayer localPlayer = MonkeDevNetworkingManager.Manager.LocalPlayer;
		if (localPlayer == null || localPlayer.gameModePlayer == null)
		{
			return;
		}
		GameModePlayer gameModePlayer = localPlayer.gameModePlayer;
		if (!(LethalApeR.Gameplay.BeTheMonster.BTMGameManager.Instance == null))
		{
			return;
		}
		gameModePlayer.SetMonsterRigsActive(false);
		gameModePlayer.apeRig.SetActive(true);
		GameModePlayer.MonsterEntry[] availableMonsters = gameModePlayer.availableMonsters;
		if (availableMonsters != null)
		{
			foreach (GameModePlayer.MonsterEntry monsterEntry in availableMonsters)
			{
				if (monsterEntry.MonsterGameObject != null)
				{
					monsterEntry.MonsterGameObject.SetActive(false);
				}
			}
		}
		localPlayer.photonView.RPC("RPC_SetMonsterSkinMod", RpcTarget.OthersBuffered, false, "");
	}

	public void EnableMonsterSkin()
	{
		if (!toggleMonsterSkin)
		{
			ToggleMonsterSkin();
		}
	}

	public void DisableMonsterSkin()
	{
		if (toggleMonsterSkin)
		{
			ToggleMonsterSkin();
		}
	}

	public void SetMonsterSkin(bool enabled)
	{
		if (enabled)
		{
			if (!toggleMonsterSkin)
			{
				ToggleMonsterSkin();
			}
		}
		else if (toggleMonsterSkin)
		{
			ToggleMonsterSkin();
		}
	}

	public void SetSize(float size)
	{
		if (IsAllowedToUseMods())
		{
			SetScale(size);
			UpdateSizeDisplay();
		}
		else
		{
			SetScale(1f);
		}
	}

	public void IncreaseSize()
	{
		if (IsAllowedToUseMods())
		{
			SetScale(Mathf.Clamp(Player.Instance.targetScale + 0.1f, 0.1f, 5.15f));
			UpdateSizeDisplay();
		}
		else
		{
			SetScale(1f);
		}
	}

	public void DecreaseSize()
	{
		if (IsAllowedToUseMods())
		{
			SetScale(Mathf.Clamp(Player.Instance.targetScale - 0.1f, 0.5f, 5f));
			UpdateSizeDisplay();
		}
		else
		{
			SetScale(1f);
		}
	}

	public void SetSmolMonkey()
	{
		SetSize(0.5f);
	}

	public void SetBigMonkey()
	{
		SetSize(2f);
	}

	public void SetNormalMonkey()
	{
		SetSize(1f);
	}

	public void SetExtraBig()
	{
		SetSize(2f);
	}

	public void SetBig()
	{
		SetSize(1.5f);
	}

	public void SetNormal()
	{
		SetSize(1f);
	}

	public void SetSmall()
	{
		SetSize(0.5f);
	}

	public void SetExtraSmall()
	{
		SetSize(0.25f);
	}

	public void SetMaxArmLength(float v)
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.maxArmLength = Mathf.Clamp(v, 0.1f, 100f);
		}
	}

	public void SetVelocityLimit(float v)
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.velocityLimit = Mathf.Clamp(v, 1f, 999f);
		}
	}

	public void SetJumpMultiplier(float v)
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.jumpMultiplier = Mathf.Clamp(v, 0.1f, 10f);
		}
	}

	public void SetMaxJumpSpeed(float v)
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.maxJumpSpeed = Mathf.Clamp(v, 1f, 100f);
		}
	}

	public void SetFrictionConstant(float v)
	{
		if (IsAllowedToUseMods())
		{
			Player.Instance.frictionConstant = Mathf.Clamp(v, 0f, 10f);
		}
	}

	public void ToggleWebSwing()
	{
		if (!IsAllowedToUseMods())
		{
			ResetWebSwing();
		}
		else if (Debounced("ToggleWebSwing"))
		{
			if (!ResolveWebShooters())
			{
				Debug.LogWarning("[Mods] Web Swing: this scene's Player has no SpiderApeWebShooter. Run Tools > Spider-Ape > Set Up Web Swinging (Active Scene) on it first.");
			}
			else
			{
				SetWebSwing(!toggleWebSwing);
			}
		}
	}

	public void TogglePunchMod()
	{
		if (IsAllowedToUseMods())
		{
			if (!Debounced("TogglePunchMod"))
			{
				return;
			}
			togglePunchMod = !togglePunchMod;
		}
		else
		{
			togglePunchMod = false;
		}
		_punchTracks.Clear();
	}

	public void ToggleIronMonke()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleIronMonke"))
			{
				toggleIronMonke = !toggleIronMonke;
			}
		}
		else
		{
			toggleIronMonke = false;
		}
	}

	public void ToggleBirdFly()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleBirdFly"))
			{
				toggleBirdFly = !toggleBirdFly;
			}
		}
		else
		{
			toggleBirdFly = false;
		}
	}

	public void ToggleRagdoll()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleRagdoll"))
			{
				toggleRagdoll = !toggleRagdoll;
				if (!toggleRagdoll)
				{
					EndRagdoll(instant: false);
				}
			}
		}
		else
		{
			toggleRagdoll = false;
			EndRagdoll(instant: true);
		}
	}

	public void ToggleInfVelocity()
	{
		if (IsAllowedToUseMods())
		{
			if (!Debounced("ToggleInfVelocity"))
			{
				return;
			}
			toggleInfVelocity = !toggleInfVelocity;
			if (toggleInfVelocity)
			{
				if (Player.Instance != null)
				{
					Player.Instance.maxJumpSpeed = 1000f;
				}
				return;
			}
		}
		else
		{
			toggleInfVelocity = false;
		}
		RestoreJumpCap();
	}

	public void ToggleSizeTrigger()
	{
		if (IsAllowedToUseMods())
		{
			if (!Debounced("ToggleSizeTrigger"))
			{
				return;
			}
			toggleSizeTrigger = !toggleSizeTrigger;
			if (toggleSizeTrigger)
			{
				toggleSizeRainbow = false;
				toggleGiantMode = false;
				return;
			}
		}
		else
		{
			toggleSizeTrigger = false;
		}
		SetScale(1f);
		UpdateSizeDisplay();
	}

	public void ToggleUpsideDown()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleUpsideDown"))
			{
				toggleUpsideDown = !toggleUpsideDown;
				if (_ragdolled)
				{
					EndRagdoll(instant: false);
				}
				else
				{
					ReorientRig(instant: false);
				}
			}
		}
		else
		{
			toggleUpsideDown = false;
			ReorientRig(instant: true);
		}
	}

	public void ToggleAirplaneMode()
	{
		if (IsAllowedToUseMods())
		{
			if (!Debounced("ToggleAirplaneMode"))
			{
				return;
			}
			toggleAirplaneMode = !toggleAirplaneMode;
		}
		else
		{
			toggleAirplaneMode = false;
		}
		_airplaneBlend = 0f;
	}

	public void ToggleWallStick()
	{
		if (IsAllowedToUseMods())
		{
			if (!Debounced("ToggleWallStick"))
			{
				return;
			}
			toggleWallStick = !toggleWallStick;
			if (toggleWallStick)
			{
				return;
			}
		}
		else
		{
			toggleWallStick = false;
		}
		ReleaseWall(feedback: false);
	}

	public void ToggleZeroGravity()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleZeroGravity"))
			{
				toggleZeroGravity = !toggleZeroGravity;
				if (toggleZeroGravity)
				{
					toggleSuperGravity = false;
				}
			}
		}
		else
		{
			toggleZeroGravity = false;
		}
	}

	public void ToggleSlippyFloor()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleSlippyFloor"))
			{
				toggleSlippyFloor = !toggleSlippyFloor;
			}
		}
		else
		{
			toggleSlippyFloor = false;
		}
	}

	public void ToggleIceSurfing()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleIceSurfing") && (toggleIceSurfing || EnsureIceMaterial()))
			{
				toggleIceSurfing = !toggleIceSurfing;
				if (!toggleIceSurfing)
				{
					RetireIcePaths(immediate: false);
				}
			}
		}
		else
		{
			toggleIceSurfing = false;
			RetireIcePaths(immediate: true);
		}
	}

	public void ToggleSuperGravity()
	{
		if (IsAllowedToUseMods())
		{
			if (Debounced("ToggleSuperGravity"))
			{
				toggleSuperGravity = !toggleSuperGravity;
				_superGravityTime = 0f;
				if (toggleSuperGravity)
				{
					toggleZeroGravity = false;
				}
			}
		}
		else
		{
			toggleSuperGravity = false;
		}
	}

	private bool Debounced(string key)
	{
		float unscaledTime = Time.unscaledTime;
		if (_toggleTimes.TryGetValue(key, out var value) && unscaledTime - value < ToggleDebounce)
		{
			return false;
		}
		_toggleTimes[key] = unscaledTime;
		return true;
	}

	private void InitSeasonalMods()
	{
		Player instance = Player.Instance;
		if (instance != null && instance.bodyCollider != null && instance.bodyCollider.height > 0f)
		{
			_bodyInitialHeight = instance.bodyCollider.height;
		}
		ResolveWebShooters();
	}

	public void PreLocomotionStep()
	{
		Player instance = Player.Instance;
		if (instance == null || instance.playerRigidBody == null || instance.leftHandTransform == null || instance.rightHandTransform == null)
		{
			return;
		}
		if (!IsAllowedToUseMods())
		{
			if (_seasonalAllowed)
			{
				ResetSeasonalMods();
			}
			_seasonalAllowed = false;
			return;
		}
		_seasonalAllowed = true;
		float deltaTime = Time.deltaTime;
		SampleHands(instance, deltaTime);
		TickBlink(instance);
		UpdateGripLatches();
		ReconcileWebSwing(instance);
		if (instance.wasLeftHandTouching || instance.wasRightHandTouching)
		{
			_lastHandTouchTime = Time.time;
		}
		if (toggleInfVelocity && instance.maxJumpSpeed != InfJumpSpeed)
		{
			instance.maxJumpSpeed = InfJumpSpeed;
		}
		if (toggleSizeTrigger)
		{
			TickSizeTrigger(instance, deltaTime);
		}
		if (!RigFree(instance))
		{
			if (_ragdolled)
			{
				StopRagdollPhysics(instance);
			}
			ReleaseWall(feedback: false);
			_airplaneBlend = 0f;
			return;
		}
		TickRagdollButton(instance);
		TickRigOrientation(instance);
		TickWallStickGrip(instance);
		TickArmPose(instance, deltaTime);
		TickBirdFly(instance, deltaTime);
		TickIronMonkeHaptics(deltaTime);
		if (toggleIceSurfing)
		{
			TickIceGrips(instance);
		}
		_iceSlipFrame = HandsNearIce(instance);
		if (Time.time < _gripBreakUntil)
		{
			BreakGrip(instance);
			_maxSlipLastFrame = true;
		}
		else if (toggleSlippyFloor || _iceSlipFrame || IronMonkeThrusting())
		{
			instance.SetMaximumSlipThisFrame();
			_maxSlipLastFrame = true;
		}
		else
		{
			if (_maxSlipLastFrame)
			{
				ClearSlideFlags(instance);
			}
			_maxSlipLastFrame = false;
		}
	}

	private static void ClearSlideFlags(Player p)
	{
		p.wasLeftHandSlide = false;
		p.wasRightHandSlide = false;
	}

	private void SeasonalFixedStep()
	{
		if (!_seasonalAllowed)
		{
			return;
		}
		Player instance = Player.Instance;
		if (instance == null || instance.playerRigidBody == null || !RigFree(instance))
		{
			return;
		}
		Rigidbody playerRigidBody = instance.playerRigidBody;
		float fixedDeltaTime = Time.fixedDeltaTime;
		float currentScale = instance.CurrentScale;
		if (toggleSuperGravity)
		{
			TickSuperGravityPhase(fixedDeltaTime);
		}
		if (_wallStuck)
		{
			TickWallStickHold(instance, fixedDeltaTime);
		}
		Vector3 vector;
		if (CustomGravityActive)
		{
			vector = CustomGravity();
			if (playerRigidBody.useGravity)
			{
				playerRigidBody.AddForce((vector - Physics.gravity) * currentScale, ForceMode.Acceleration);
			}
		}
		else
		{
			vector = Physics.gravity;
		}
		if (toggleIronMonke)
		{
			TickIronMonkeThrust(instance, playerRigidBody);
		}
		if (_airplaneBlend > 0f)
		{
			TickAirplaneThrust(instance, playerRigidBody, playerRigidBody.useGravity ? (vector * currentScale) : Vector3.zero);
		}
		if (_slideContact)
		{
			float num = Vector3.Dot(playerRigidBody.linearVelocity, _slideNormal);
			if (num < 0f)
			{
				playerRigidBody.linearVelocity = playerRigidBody.linearVelocity - num * _slideNormal;
			}
		}
	}

	private void SeasonalLateStep()
	{
		if (!_seasonalAllowed)
		{
			return;
		}
		Player instance = Player.Instance;
		if (!(instance == null) && !(instance.playerRigidBody == null))
		{
			float deltaTime = Time.deltaTime;
			bool num = RigFree(instance);
			SetBodyFrictionless(instance, toggleSlippyFloor || (toggleIceSurfing && _iceSlipFrame));
			if (num)
			{
				TickSlide(instance, deltaTime);
				TickIceSurfing(instance, deltaTime, free: true);
				if (togglePunchMod)
				{
					TickPunch(instance, deltaTime);
				}
				AlignBodyWithRig(instance);
			}
			else
			{
				ResetSlideState();
				TickIceSurfing(instance, deltaTime, free: false);
			}
		}
	}

	private void ResetSeasonalMods()
	{
		if (toggleInfVelocity)
		{
			toggleInfVelocity = false;
			RestoreJumpCap();
		}
		if (toggleSizeTrigger)
		{
			toggleSizeTrigger = false;
			SetScale(1f);
			UpdateSizeDisplay();
		}
		togglePunchMod = false;
		toggleIronMonke = false;
		toggleBirdFly = false;
		toggleRagdoll = false;
		toggleUpsideDown = false;
		toggleAirplaneMode = false;
		toggleWallStick = false;
		toggleZeroGravity = false;
		toggleSlippyFloor = false;
		toggleIceSurfing = false;
		toggleSuperGravity = false;
		_punchTracks.Clear();
		_gripBreakUntil = 0f;
		_superGravityTime = 0f;
		_tPose = 0f;
		_airplaneBlend = 0f;
		ReleaseWall(feedback: false);
		ResetSlideState();
		EndRagdoll(instant: true);
		ClearBlink();
		Player instance = Player.Instance;
		if (instance != null && instance.playerRigidBody != null)
		{
			if (_rigOwned)
			{
				OrientRig(instance, Vector3.up);
			}
			if (_maxSlipLastFrame)
			{
				ClearSlideFlags(instance);
			}
			SetBodyFrictionless(instance, on: false);
		}
		_maxSlipLastFrame = false;
		_iceSlipFrame = false;
		_gravityFlipped = false;
		_rigOwned = false;
		RetireIcePaths(immediate: true);
		ResetWebSwing();
	}

	private void ShutdownSeasonalMods()
	{
		ClearBlink();
		Player instance = Player.Instance;
		if (instance != null && instance.bodyCollider != null)
		{
			SetBodyFrictionless(instance, on: false);
		}
		DisposeIcePaths();
		if (_iceMaterial != null)
		{
			UnityEngine.Object.Destroy(_iceMaterial);
		}
		if (_frictionless != null)
		{
			UnityEngine.Object.Destroy(_frictionless);
		}
	}

	private void RestoreJumpCap()
	{
		if (Player.Instance != null)
		{
			Player.Instance.maxJumpSpeed = (toggleSuperJump ? 50f : originalMaxJumpSpeed);
		}
	}

	private static bool RigFree(Player p)
	{
		if (!p.playerRigidBody.isKinematic)
		{
			return !p.disableMovement;
		}
		return false;
	}

	private static Vector3 FlatForward(Player p, Vector3 up)
	{
		Transform transform = p.headCollider.transform;
		Vector3 vector = Vector3.ProjectOnPlane(transform.forward, up);
		if (vector.sqrMagnitude < 0.0001f)
		{
			vector = Vector3.ProjectOnPlane(transform.up, up);
		}
		return vector.normalized;
	}

	private static void BreakGrip(Player p)
	{
		p.SetMaximumSlipThisFrame();
		p.wasLeftHandTouching = false;
		p.wasRightHandTouching = false;
		ClearSlideFlags(p);
	}

	private void BreakGripFor(float seconds)
	{
		_gripBreakUntil = Mathf.Max(_gripBreakUntil, Time.time + seconds);
	}

	private static void PulseBoth(float amplitude, float duration)
	{
		LethalApeR.Gameplay.BeTheMonster.VRInputController instance = LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance;
		if (!(instance == null))
		{
			instance.PulseLeft(amplitude, duration);
			instance.PulseRight(amplitude, duration);
		}
	}

	private static void PulseHand(bool right, float amplitude, float duration)
	{
		LethalApeR.Gameplay.BeTheMonster.VRInputController instance = LethalApeR.Gameplay.BeTheMonster.VRInputController.Instance;
		if (!(instance == null))
		{
			if (right)
			{
				instance.PulseRight(amplitude, duration);
			}
			else
			{
				instance.PulseLeft(amplitude, duration);
			}
		}
	}

	private void SampleHands(Player p, float dt)
	{
		Transform parent = p.leftHandTransform.parent;
		Vector3 localPosition = p.leftHandTransform.localPosition;
		Vector3 localPosition2 = p.rightHandTransform.localPosition;
		if (parent == null || dt <= 0f || !_handsSampled)
		{
			_leftHandDelta = (_rightHandDelta = (_leftHandVelocity = (_rightHandVelocity = Vector3.zero)));
		}
		else
		{
			_leftHandDelta = RigDelta(parent, localPosition - _leftHandLocal);
			_rightHandDelta = RigDelta(parent, localPosition2 - _rightHandLocal);
			_leftHandVelocity = _leftHandDelta / dt;
			_rightHandVelocity = _rightHandDelta / dt;
		}
		_leftHandLocal = localPosition;
		_rightHandLocal = localPosition2;
		_handsSampled = parent != null;
	}

	private static Vector3 RigDelta(Transform rig, Vector3 local)
	{
		if (local.sqrMagnitude > 0.09f)
		{
			return Vector3.zero;
		}
		return rig.TransformVector(local);
	}

	private void UpdateGripLatches()
	{
		float leftGrip = LeftGrip;
		float num = (_leftGripDown ? GripOff : GripOn);
		float num2 = (_rightGripDown ? GripOff : GripOn);
		float rightGrip = RightGrip;
		_leftGripPressed = leftGrip > num && !_leftGripDown;
		_rightGripPressed = rightGrip > num2 && !_rightGripDown;
		_rightGripDown = rightGrip > num2;
		_leftGripDown = leftGrip > num;
	}

	private void ReorientRig(bool instant)
	{
		Player instance = Player.Instance;
		if (instance == null || instance.playerRigidBody == null)
		{
			return;
		}
		LethalApeR.SceneFlow.SceneFadeOverlay current = LethalApeR.SceneFlow.SceneFadeOverlay.Current;
		if (instant || (_blinkPhase == BlinkPhase.None && current != null && current.Alpha > 0.001f))
		{
			ClearBlink();
			OrientRig(instance, DesiredRigUp);
		}
		else if (!RigFree(instance))
		{
			_rigOwned = true;
		}
		else if (_blinkPhase != BlinkPhase.Out)
		{
			float blinkTime = 0f;
			if (_blinkPhase == BlinkPhase.In && current != null)
			{
				blinkTime = current.Alpha * BlinkOutTime;
			}
			_blinkTime = blinkTime;
			_blinkPhase = BlinkPhase.Out;
		}
	}

	private void TickBlink(Player p)
	{
		if (_blinkPhase == BlinkPhase.None)
		{
			return;
		}
		LethalApeR.SceneFlow.SceneFadeOverlay sceneFadeOverlay = LethalApeR.SceneFlow.SceneFadeOverlay.Ensure();
		_blinkTime += Time.unscaledDeltaTime;
		if (_blinkPhase == BlinkPhase.Out)
		{
			sceneFadeOverlay.Alpha = Mathf.Clamp01(_blinkTime / BlinkOutTime);
			if (!(_blinkTime < BlinkOutTime))
			{
				OrientRig(p, DesiredRigUp);
				_blinkPhase = BlinkPhase.In;
				_blinkTime = 0f;
			}
		}
		else
		{
			sceneFadeOverlay.Alpha = 1f - Mathf.Clamp01(_blinkTime / BlinkInTime);
			if (_blinkTime >= BlinkInTime)
			{
				_blinkPhase = BlinkPhase.None;
			}
		}
	}

	private void ClearBlink()
	{
		if (_blinkPhase != BlinkPhase.None)
		{
			_blinkPhase = BlinkPhase.None;
			LethalApeR.SceneFlow.SceneFadeOverlay current = LethalApeR.SceneFlow.SceneFadeOverlay.Current;
			if (current != null)
			{
				current.Alpha = 0f;
			}
		}
	}

	private void OrientRig(Player p, Vector3 targetUp)
	{
		_gravityFlipped = (_rigOwned = targetUp.y < -0.5f);
		Transform transform = p.transform;
		Vector3 up = transform.up;
		float num = Vector3.Angle(up, targetUp);
		if (!(num < 0.1f))
		{
			Vector3 vector = Vector3.Cross(up, targetUp);
			if (vector.sqrMagnitude < 1E-06f)
			{
				vector = FlatForward(p, up);
			}
			if (!p.playerRigidBody.isKinematic)
			{
				p.playerRigidBody.angularVelocity = Vector3.zero;
			}
			transform.RotateAround(p.headCollider.transform.position, vector.normalized, num);
			p.InitializeValues();
		}
	}

	private void TickRigOrientation(Player p)
	{
		if (_ragdolled || _blinkPhase != BlinkPhase.None || (!toggleUpsideDown && !_rigOwned))
		{
			return;
		}
		if (Vector3.Angle(p.transform.up, DesiredRigUp) > 5f)
		{
			ReorientRig(instant: false);
		}
		else if (!toggleUpsideDown)
		{
			_rigOwned = false;
		}
	}

	private void TickRagdollButton(Player p)
	{
		bool rightPrimary = RightPrimary;
		bool num = rightPrimary && !_ragdollButtonDown;
		_ragdollButtonDown = rightPrimary;
		if (num && toggleRagdoll)
		{
			if (_ragdolled)
			{
				EndRagdoll(instant: false);
			}
			else
			{
				BeginRagdoll(p);
			}
		}
	}

	private void BeginRagdoll(Player p)
	{
		if (_blinkPhase == BlinkPhase.Out)
		{
			ClearBlink();
			OrientRig(p, DesiredRigUp);
		}
		Rigidbody playerRigidBody = p.playerRigidBody;
		_savedConstraints = playerRigidBody.constraints;
		_savedMaxAngular = playerRigidBody.maxAngularVelocity;
		_savedAngularDamping = playerRigidBody.angularDamping;
		_ragdolled = true;
		_rigOwned = true;
		playerRigidBody.constraints = RigidbodyConstraints.None;
		playerRigidBody.maxAngularVelocity = RagdollMaxSpin;
		playerRigidBody.angularDamping = RagdollSpinDamping;
		Vector3 up = p.transform.up;
		Vector3 vector = Vector3.ProjectOnPlane(playerRigidBody.linearVelocity, up);
		Vector3 vector2 = ((vector.sqrMagnitude > 0.25f) ? Vector3.Cross(up, vector) : Vector3.ProjectOnPlane(UnityEngine.Random.onUnitSphere, up));
		if (vector2.sqrMagnitude > 1E-06f)
		{
			playerRigidBody.angularVelocity = vector2.normalized * Mathf.Clamp(vector.magnitude * 0.3f + 0.8f, 0.8f, 4f);
		}
		PulseBoth(0.5f, 0.1f);
	}

	private void StopRagdollPhysics(Player p)
	{
		_ragdolled = false;
		Rigidbody playerRigidBody = p.playerRigidBody;
		if (!playerRigidBody.isKinematic)
		{
			playerRigidBody.angularVelocity = Vector3.zero;
		}
		playerRigidBody.constraints = _savedConstraints;
		playerRigidBody.maxAngularVelocity = _savedMaxAngular;
		playerRigidBody.angularDamping = _savedAngularDamping;
	}

	private void EndRagdoll(bool instant)
	{
		if (_ragdolled)
		{
			Player instance = Player.Instance;
			if (instance == null || instance.playerRigidBody == null)
			{
				_ragdolled = false;
				return;
			}
			StopRagdollPhysics(instance);
			ReorientRig(instant);
		}
	}

	private void AlignBodyWithRig(Player p)
	{
		Vector3 vector = (_wallStuck ? _wallNormal : p.transform.up);
		if (!_ragdolled && !_wallStuck && vector.y > 0.5f)
		{
			return;
		}
		CapsuleCollider bodyCollider = p.bodyCollider;
		if (bodyCollider == null || !bodyCollider.gameObject.activeSelf)
		{
			return;
		}
		float num = Mathf.Max(p.CurrentScale, 0.1f);
		float num2 = bodyCollider.radius * num;
		float num3 = _bodyInitialHeight * num;
		Vector3 position = p.headCollider.transform.position;
		int num4 = Physics.SphereCastNonAlloc(position, num2, -vector, _seasonalHits, Mathf.Max(num3 - num2, 0f), p.locomotionEnabledLayers.value, QueryTriggerInteraction.Ignore);
		for (int i = 0; i < num4; i++)
		{
			float distance = _seasonalHits[i].distance;
			if (distance > 0f && num2 + distance < num3)
			{
				num3 = num2 + distance;
			}
		}
		bodyCollider.height = num3 / num;
		bodyCollider.transform.SetPositionAndRotation(position - vector * (num3 * 0.5f), Quaternion.FromToRotation(Vector3.up, vector));
	}

	private void TickWallStickGrip(Player p)
	{
		if (!toggleWallStick)
		{
			return;
		}
		if (_leftGripPressed || _rightGripPressed)
		{
			bool rightGripPressed = _rightGripPressed;
			if (TryFindWall(p, out var best))
			{
				StickToWall(p, best, rightGripPressed);
			}
			else
			{
				PulseHand(rightGripPressed, 0.12f, 0.03f);
			}
		}
		else if (_wallStuck && !_leftGripDown && !_rightGripDown)
		{
			ReleaseWall(feedback: true);
		}
	}

	private bool TryFindWall(Player p, out RaycastHit best)
	{
		best = default(RaycastHit);
		float num = Mathf.Max(p.CurrentScale, 0.1f);
		int value = p.locomotionEnabledLayers.value;
		Vector3 up = p.transform.up;
		Transform transform = p.headCollider.transform;
		if (Physics.SphereCast(transform.position, num * 0.12f, transform.forward, out best, num * WallAimRange, value, QueryTriggerInteraction.Ignore) && Vector3.Dot(up, best.normal) < 0.7f)
		{
			return true;
		}
		Vector3 origin = p.headCollider.transform.position - up * (num * 0.3f);
		Vector3 vector = FlatForward(p, up);
		float maxDistance = num * WallSearchRadius;
		bool result = false;
		float num2 = float.MaxValue;
		for (int i = -1; i < 2; i++)
		{
			float f = (float)i * 25f * ((float)Math.PI / 180f);
			for (int j = 0; j < 12; j++)
			{
				Vector3 direction = up * Mathf.Sin(f) + Quaternion.AngleAxis((float)j * 30f, up) * vector * Mathf.Cos(f);
				if (Physics.Raycast(origin, direction, out var hitInfo, maxDistance, value, QueryTriggerInteraction.Ignore) && !(Mathf.Abs(Vector3.Dot(up, hitInfo.normal)) > 0.6f) && hitInfo.distance < num2)
				{
					num2 = hitInfo.distance;
					best = hitInfo;
					result = true;
				}
			}
		}
		return result;
	}

	private void StickToWall(Player p, RaycastHit hit, bool right)
	{
		_wallStuck = true;
		_wallNormal = hit.normal;
		_wallLostTime = 0f;
		float num = Mathf.Max(0.1f, p.CurrentScale);
		Vector3 vector = p.headCollider.transform.position - p.transform.up * (0.3f * num);
		Vector3 vector2 = hit.point - vector;
		float magnitude = vector2.magnitude;
		if (magnitude > 0.4f * num)
		{
			float num2 = Mathf.Clamp(magnitude * 1.6f / num + 3.5f, 4f, 11f);
			p.playerRigidBody.linearVelocity = vector2 / magnitude * (num2 * Mathf.Clamp(num, 0.5f, 2f));
			BreakGripFor(0.12f);
		}
		PulseHand(right, 0.55f, 0.1f);
	}

	private void TickWallStickHold(Player p, float dt)
	{
		float num = Mathf.Max(0.1f, p.CurrentScale);
		if (Physics.SphereCast(p.headCollider.transform.position, num * 0.1f, -_wallNormal, out var hitInfo, num * 2.6f, p.locomotionEnabledLayers, QueryTriggerInteraction.Ignore))
		{
			_wallNormal = Vector3.Slerp(_wallNormal, hitInfo.normal, 1f - Mathf.Exp(-10f * dt)).normalized;
			_wallLostTime = 0f;
			return;
		}
		_wallLostTime += dt;
		if (_wallLostTime > 0.4f)
		{
			ReleaseWall(true);
		}
	}

	private void ReleaseWall(bool feedback)
	{
		if (_wallStuck)
		{
			_wallStuck = false;
			if (feedback)
			{
				PulseBoth(0.2f, 0.05f);
			}
		}
	}

	private void TickArmPose(Player p, float dt)
	{
		if (!toggleAirplaneMode && !toggleBirdFly)
		{
			_tPose = 0f;
			_airplaneBlend = 0f;
			return;
		}
		_tPose = TPoseAmount(p);
		if (!toggleAirplaneMode)
		{
			_airplaneBlend = 0f;
			return;
		}
		float num = ((Time.time - _lastHandTouchTime > 0.1f && _tPose > 0.5f) ? 1f : 0f);
		float airplaneBlend = _airplaneBlend;
		_airplaneBlend = Mathf.MoveTowards(_airplaneBlend, num, ((num > _airplaneBlend) ? 4f : 5f) * dt);
		if (airplaneBlend < 0.5f && _airplaneBlend >= 0.5f)
		{
			PulseBoth(0.3f, 0.07f);
		}
	}

	private float TPoseAmount(Player p)
	{
		Transform parent = p.leftHandTransform.parent;
		if (parent == null || !_handsSampled)
		{
			return 0f;
		}
		Vector3 vector = parent.InverseTransformPoint(p.headCollider.transform.position);
		Vector3 vector2 = parent.InverseTransformDirection(p.headCollider.transform.right);
		vector2.y = 0f;
		if (vector2.sqrMagnitude < 0.0001f)
		{
			return 0f;
		}
		vector2 = vector2.normalized;
		float num = _leftHandLocal.y - vector.y;
		if (num < -0.6f || num > 0.3f)
		{
			return 0f;
		}
		float num2 = _rightHandLocal.y - vector.y;
		if (num2 < -0.6f || num2 > 0.3f)
		{
			return 0f;
		}
		float num3 = Vector3.Dot(_leftHandLocal - vector, vector2);
		float num4 = Vector3.Dot(_rightHandLocal - vector, vector2);
		return Mathf.InverseLerp(0.35f, 0.55f, Mathf.Min(-num3, num4));
	}

	private void TickAirplaneThrust(Player p, Rigidbody rb, Vector3 gravityOnBody)
	{
		Vector3 vector = (p.headCollider.transform.forward * airplaneSpeed - rb.linearVelocity) * 2.5f;
		vector = Vector3.ClampMagnitude(vector, 18f);
		rb.AddForce((vector - gravityOnBody) * _airplaneBlend, ForceMode.Acceleration);
	}

	private void TickBirdFly(Player p, float dt)
	{
		if (dt <= 0f || !toggleBirdFly)
		{
			return;
		}
		_birdHapticTimer -= dt;
		if (Time.time - _lastHandTouchTime < 0.2f)
		{
			return;
		}
		Rigidbody playerRigidBody = p.playerRigidBody;
		float s = Mathf.Max(0.1f, p.CurrentScale);
		Vector3 up = p.transform.up;
		Vector3 vector = FlatForward(p, up);
		Vector3 linearVelocity = playerRigidBody.linearVelocity;
		Vector3 vector2 = FlapAccel(_leftHandVelocity, up, s) + FlapAccel(_rightHandVelocity, up, s);
		float num = Vector3.Dot(vector2, up);
		float num2 = Vector3.Dot(linearVelocity, up);
		if (num > 0f)
		{
			float num3 = Mathf.Clamp01((7f - num2) * 0.5f);
			vector2 += up * (num * (num3 - 1f)) + vector * (num * num3 * 0.35f);
			if (num > 12f && _birdHapticTimer <= 0f)
			{
				_birdHapticTimer = 0.12f;
				PulseBoth(0.18f, 0.05f);
			}
		}
		if (num2 < 0f && _tPose > 0f)
		{
			vector2 += up * (-num2 * 3f * _tPose);
			if (Vector3.Dot(vector, linearVelocity) < 9f)
			{
				vector2 += vector * (-num2 * 1.2f * _tPose);
			}
		}
		float magnitude = vector2.magnitude;
		if (!(magnitude < 0.0001f))
		{
			float num4 = Mathf.Clamp01((14f - Vector3.Dot(linearVelocity, vector2 / magnitude)) / 3f);
			playerRigidBody.linearVelocity = linearVelocity + vector2 * num4 * dt;
		}
	}

	private Vector3 FlapAccel(Vector3 handVelocity, Vector3 up, float s)
	{
		Vector3 vector = handVelocity / s;
		float magnitude = vector.magnitude;
		if (magnitude < 0.8f)
		{
			return Vector3.zero;
		}
		Vector3 vector2 = vector / magnitude;
		float num = (Mathf.Min(magnitude, 7f) - 0.8f) * birdFlapPower;
		float num2 = ((Vector3.Dot(vector2, up) < 0f) ? 1f : 0.2f);
		return -vector2 * (num2 * num);
	}

	private static float IronThrottle(float grip)
	{
		return Mathf.Clamp01((grip - 0.2f) / 0.7f);
	}

	private bool IronMonkeThrusting()
	{
		if (!toggleIronMonke)
		{
			return false;
		}
		if (!(IronThrottle(LeftGrip) > 0f))
		{
			return IronThrottle(RightGrip) > 0f;
		}
		return true;
	}

	private void TickIronMonkeThrust(Player p, Rigidbody rb)
	{
		PalmThrust(rb, p.leftHandTransform.right, IronThrottle(LeftGrip));
		PalmThrust(rb, -p.rightHandTransform.right, IronThrottle(RightGrip));
	}

	private void PalmThrust(Rigidbody rb, Vector3 palm, float throttle)
	{
		if (!(throttle <= 0f))
		{
			Vector3 vector = (ironMonkeRepulsor ? (-palm) : palm);
			float num = Mathf.Clamp01((20f - Vector3.Dot(vector, rb.linearVelocity)) * 0.25f);
			rb.AddForce(vector * (ironMonkeThrust * throttle * num), ForceMode.Acceleration);
		}
	}

	private void TickIronMonkeHaptics(float dt)
	{
		if (toggleIronMonke)
		{
			IronHaptic(false, IronThrottle(LeftGrip), ref _ironHapticLeft, dt);
			IronHaptic(true, IronThrottle(RightGrip), ref _ironHapticRight, dt);
		}
	}

	private static void IronHaptic(bool right, float throttle, ref float timer, float dt)
	{
		if (throttle <= 0f)
		{
			timer = 0f;
			return;
		}
		timer -= dt;
		if (!(timer > 0f))
		{
			timer = 0.09f;
			PulseHand(right, throttle * 0.3f + 0.1f, 0.1f);
		}
	}

	private void TickSizeTrigger(Player p, float dt)
	{
		float num = TriggerAxis(RightTrigger) - TriggerAxis(LeftTrigger);
		if (Mathf.Abs(num) < 0.001f)
		{
			_sizeAtLimit = false;
			return;
		}
		float targetScale = p.targetScale;
		float num2 = Mathf.Clamp(targetScale * Mathf.Exp(num * sizeTriggerRate * dt), 0.1f, 5f);
		bool flag = Mathf.Approximately(num2, targetScale);
		if (flag)
		{
			if (!_sizeAtLimit)
			{
				PulseHand(num > 0f, 0.35f, 0.06f);
			}
			_sizeAtLimit = flag;
			return;
		}
		_sizeAtLimit = flag;
		SetScale(num2);
		int num3 = Mathf.RoundToInt(num2 * 100f);
		if (num3 != _sizeShown)
		{
			_sizeShown = num3;
			UpdateSizeDisplay();
		}
	}

	private static float TriggerAxis(float value)
	{
		return Mathf.Clamp01((value - 0.08f) / 0.92f);
	}

	private float SuperGravityWave()
	{
		float num = Mathf.PI * 2f / Mathf.Max(0.25f, superGravityPeriod);
		return Mathf.Cos(_superGravityTime * num);
	}

	private Vector3 CustomGravity()
	{
		Vector3 gravity = Physics.gravity;
		if (_wallStuck)
		{
			return -_wallNormal * gravity.magnitude;
		}
		if (toggleZeroGravity)
		{
			gravity = Vector3.zero;
		}
		else if (toggleSuperGravity)
		{
			gravity *= superGravityStrength * SuperGravityWave();
		}
		if (_gravityFlipped)
		{
			gravity = -gravity;
		}
		return gravity;
	}

	private void TickSuperGravityPhase(float dt)
	{
		float num = Mathf.Sign(SuperGravityWave());
		_superGravityTime += dt;
		if (Mathf.Sign(SuperGravityWave()) != num)
		{
			PulseBoth(0.3f, 0.06f);
		}
	}

	private void SetBodyFrictionless(Player p, bool on)
	{
		if (_bodyFrictionless == on)
		{
			if (on)
			{
				KeepHandsFrictionless(p);
			}
			return;
		}
		_bodyFrictionless = on;
		if (on)
		{
			if (p.bodyCollider != null)
			{
				_bodyMaterial = p.bodyCollider.sharedMaterial;
				p.bodyCollider.sharedMaterial = Frictionless;
			}
			if (p.headCollider != null)
			{
				_headMaterial = p.headCollider.sharedMaterial;
				p.headCollider.sharedMaterial = Frictionless;
			}
			KeepHandsFrictionless(p);
		}
		else
		{
			if (p.bodyCollider != null)
			{
				p.bodyCollider.sharedMaterial = _bodyMaterial;
			}
			if (p.headCollider != null)
			{
				p.headCollider.sharedMaterial = _headMaterial;
			}
			RestoreHandMaterials();
		}
	}

	private void KeepHandsFrictionless(Player p)
	{
		LAPlayer lAPlayer = p.Driver as LAPlayer;
		if (lAPlayer == null)
		{
			return;
		}
		_handScratch.Clear();
		lAPlayer.CollectHandColliders(_handScratch);
		for (int i = 0; i < _handScratch.Count; i++)
		{
			Collider collider = _handScratch[i];
			if (!(collider == null) && !_frictionlessHands.Contains(collider))
			{
				_frictionlessHands.Add(collider);
				_handMaterials.Add(collider.sharedMaterial);
				collider.sharedMaterial = Frictionless;
			}
		}
	}

	private void RestoreHandMaterials()
	{
		for (int i = 0; i < _frictionlessHands.Count; i++)
		{
			if (_frictionlessHands[i] != null)
			{
				_frictionlessHands[i].sharedMaterial = _handMaterials[i];
			}
		}
		_frictionlessHands.Clear();
		_handMaterials.Clear();
	}

	private bool IsIce(Surface surface)
	{
		if (toggleSlippyFloor)
		{
			return true;
		}
		if (toggleIceSurfing)
		{
			if (_iceSlipFrame)
			{
				return true;
			}
			if (surface != null)
			{
				return IsIcePathSurface(surface);
			}
		}
		return false;
	}

	private void ResetSlideState()
	{
		_slideContact = false;
		_slidePush = 0f;
		_iceSurfing = false;
		_iceSurfTime = 0f;
	}

	private void TickSlide(Player p, float dt)
	{
		_slideContact = false;
		if (dt <= 0f || (!toggleSlippyFloor && !toggleIceSurfing))
		{
			_slidePush = 0f;
			EndIceSurf(dt);
			return;
		}
		bool flag = p.wasLeftHandTouching && IsIce(p.leftHandSurfaceOverride);
		bool flag2 = p.wasRightHandTouching && IsIce(p.rightHandSurfaceOverride);
		if (!flag && !flag2)
		{
			_slidePush = 0f;
			EndIceSurf(dt);
			return;
		}
		Vector3 vector = Vector3.zero;
		if (flag)
		{
			vector += p.leftHandSlideNormal;
		}
		if (flag2)
		{
			vector += p.rightHandSlideNormal;
		}
		Vector3 vector2 = ((vector.sqrMagnitude > 0.0001f) ? vector.normalized : p.transform.up);
		Rigidbody playerRigidBody = p.playerRigidBody;
		float num = Mathf.Max(0.1f, p.CurrentScale);
		Vector3 linearVelocity = playerRigidBody.linearVelocity;
		if (flag)
		{
			linearVelocity -= Vector3.ProjectOnPlane(_leftHandDelta, vector2) * 2f;
		}
		if (flag2)
		{
			linearVelocity -= Vector3.ProjectOnPlane(_rightHandDelta, vector2) * 2f;
		}
		Vector3 vector3 = Vector3.Project(linearVelocity, vector2);
		Vector3 vt = linearVelocity - vector3;
		Vector3 vector4 = Vector3.zero;
		if (flag)
		{
			vector4 += Vector3.ProjectOnPlane(p.leftHandTransform.forward, vector2);
		}
		if (flag2)
		{
			vector4 += Vector3.ProjectOnPlane(p.rightHandTransform.forward, vector2);
		}
		float magnitude = vt.magnitude;
		if (magnitude > 0.3f && vector4.sqrMagnitude > 0.01f)
		{
			Vector3 normalized = vector4.normalized;
			Vector3 vector5 = vt / magnitude;
			if (Vector3.Dot(vector5, normalized) > -0.2f)
			{
				vt = Vector3.RotateTowards(vector5, normalized, SlideCarveRate * Mathf.Deg2Rad * dt, 0f) * magnitude;
			}
		}
		if (toggleIceSurfing)
		{
			DriveIceSurf(flag, flag2, vector2, dt, ref vt);
		}
		else
		{
			EndIceSurf(dt);
		}
		float num2 = (toggleIceSurfing ? Mathf.Clamp(iceSurfMaxSpeed, slideMaxSpeed, 28f) : slideMaxSpeed);
		float magnitude2 = vt.magnitude;
		if (magnitude2 > num2)
		{
			vt *= num2 / magnitude2;
		}
		float num3 = 0f;
		if (flag)
		{
			num3 = Mathf.Max(0f, 0f - Vector3.Dot(vector2, _leftHandVelocity));
		}
		if (flag2)
		{
			num3 = Mathf.Max(num3, 0f - Vector3.Dot(vector2, _rightHandVelocity));
		}
		_slidePush = Mathf.Lerp(_slidePush, num3, 1f - Mathf.Exp(-dt / 0.045f));
		if (_slidePush > num * p.velocityLimit)
		{
			float num4 = Mathf.Min(num * p.maxJumpSpeed, _slidePush * p.jumpMultiplier);
			if (num4 > Vector3.Dot(vector2, vector3))
			{
				vector3 = vector2 * num4;
			}
		}
		playerRigidBody.linearVelocity = vt + vector3;
		_slideContact = true;
		_slideNormal = vector2;
	}

	private void DriveIceSurf(bool left, bool right, Vector3 n, float dt, ref Vector3 vt)
	{
		Vector3 vector = Vector3.zero;
		if (left && _iceLaying[0] != null)
		{
			vector += Vector3.ProjectOnPlane(_iceLaying[0].EndDirection, n);
		}
		if (right && _iceLaying[1] != null)
		{
			vector += Vector3.ProjectOnPlane(_iceLaying[1].EndDirection, n);
		}
		if (vector.sqrMagnitude < 0.0001f)
		{
			EndIceSurf(dt);
			return;
		}
		Vector3 normalized = vector.normalized;
		float num = Mathf.Max(0f, iceSurfStartSpeed);
		float num2 = Mathf.Max(num, iceSurfTopSpeed);
		float num3 = Mathf.Max(0.01f, iceSurfBuildTime);
		float num4 = Vector3.Dot(normalized, vt);
		if (!_iceSurfing)
		{
			_iceSurfTime = Mathf.Max(_iceSurfTime, num3 * Mathf.InverseLerp(num, num2, num4));
		}
		_iceSurfing = true;
		_iceSurfTime = Mathf.Min(_iceSurfTime + dt, num3);
		float num5 = Mathf.Lerp(num, num2, _iceSurfTime / num3);
		if (num4 < num5)
		{
			vt += normalized * Mathf.Min(Mathf.Max(0f, iceSurfAcceleration) * dt, num5 - num4);
		}
	}

	private void EndIceSurf(float dt)
	{
		_iceSurfing = false;
		_iceSurfTime = Mathf.Max(0f, _iceSurfTime - Mathf.Max(0f, dt));
	}

	private void TickPunch(Player p, float dt)
	{
		MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
		if (manager == null || dt <= 0f)
		{
			return;
		}
		List<MonkeDevNetworkingPlayer> players = manager.Players;
		if (players == null)
		{
			return;
		}
		MonkeDevNetworkingPlayer localPlayer = manager.LocalPlayer;
		Rigidbody playerRigidBody = p.playerRigidBody;
		float num = Mathf.Max(0.1f, p.CurrentScale);
		Vector3 position = p.headCollider.transform.position;
		Vector3 chest = position - p.transform.up * (num * 0.55f);
		int frameCount = Time.frameCount;
		for (int i = 0; i < players.Count; i++)
		{
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
			if (monkeDevNetworkingPlayer == null || monkeDevNetworkingPlayer == localPlayer || !monkeDevNetworkingPlayer.isActiveAndEnabled || monkeDevNetworkingPlayer.NetworkHidden || monkeDevNetworkingPlayer.LeftHand == null || monkeDevNetworkingPlayer.RightHand == null)
			{
				continue;
			}
			if (!_punchTracks.TryGetValue(monkeDevNetworkingPlayer, out var value))
			{
				value = new PunchTrack();
				_punchTracks[monkeDevNetworkingPlayer] = value;
			}
			Vector3 position2 = monkeDevNetworkingPlayer.LeftHand.position;
			Vector3 position3 = monkeDevNetworkingPlayer.RightHand.position;
			if (value.SeenFrame == frameCount - 1 && Time.time >= value.NextHit)
			{
				float num2 = ((monkeDevNetworkingPlayer.Head != null) ? Mathf.Max(0.1f, monkeDevNetworkingPlayer.Head.localScale.x) : 1f);
				float reach = num * 0.24f + num2 * 0.07f;
				if (TryPunch(p, playerRigidBody, value.Left, position2, position, chest, reach, dt) || TryPunch(p, playerRigidBody, value.Right, position3, position, chest, reach, dt))
				{
					value.NextHit = Time.time + 0.45f;
				}
			}
			value.Left = position2;
			value.Right = position3;
			value.SeenFrame = frameCount;
		}
		if (frameCount % 128 != 0)
		{
			return;
		}
		_punchStale.Clear();
		foreach (KeyValuePair<MonkeDevNetworkingPlayer, PunchTrack> punchTrack in _punchTracks)
		{
			if (punchTrack.Key == null || frameCount - punchTrack.Value.SeenFrame > 120)
			{
				_punchStale.Add(punchTrack.Key);
			}
		}
		for (int j = 0; j < _punchStale.Count; j++)
		{
			_punchTracks.Remove(_punchStale[j]);
		}
	}

	private bool TryPunch(Player p, Rigidbody rb, Vector3 previous, Vector3 fist, Vector3 head, Vector3 chest, float reach, float dt)
	{
		Vector3 vector = fist - previous;
		if (vector.sqrMagnitude > 2.25f)
		{
			return false;
		}
		Vector3 vector2 = ClosestPointOnSegment(head, chest, fist);
		if ((vector2 - fist).sqrMagnitude > reach * reach)
		{
			return false;
		}
		Vector3 vector3 = vector / dt - rb.linearVelocity;
		float magnitude = vector3.magnitude;
		if (magnitude < 2.2f)
		{
			return false;
		}
		Vector3 vector4 = vector3 / magnitude;
		Vector3 vector5 = vector2 - previous;
		if (vector5.sqrMagnitude > 1E-06f && Vector3.Dot(vector4, vector5.normalized) < 0.2f)
		{
			return false;
		}
		Vector3 up = p.transform.up;
		Vector3 vector6 = vector4 * Mathf.Clamp(Mathf.Min(magnitude, 15f) * punchKnockback, 4f, 14f);
		float num = Vector3.Dot(up, vector6);
		if (num < 2.5f && Vector3.Dot(vector4, up) > -0.5f)
		{
			vector6 += up * (2.5f - Mathf.Max(0f, num));
		}
		rb.linearVelocity = Vector3.ClampMagnitude(vector6 + rb.linearVelocity, 28f);
		BreakGripFor(0.15f);
		PulseBoth(0.9f, 0.14f);
		return true;
	}

	private static Vector3 ClosestPointOnSegment(Vector3 a, Vector3 b, Vector3 point)
	{
		Vector3 vector = b - a;
		float sqrMagnitude = vector.sqrMagnitude;
		if (sqrMagnitude < 1E-08f)
		{
			return a;
		}
		float num = Mathf.Clamp01(Vector3.Dot(vector, point - a) / sqrMagnitude);
		return a + vector * num;
	}

	private bool ResolveWebShooters()
	{
		if (_webShooters != null)
		{
			return true;
		}
		Player instance = Player.Instance;
		if (instance == null)
		{
			return false;
		}
		SpiderApeWebShooter[] componentsInChildren = instance.GetComponentsInChildren<SpiderApeWebShooter>(true);
		if (componentsInChildren.Length == 0)
		{
			return false;
		}
		_webShooters = componentsInChildren;
		_webDefault = false;
		for (int i = 0; i < componentsInChildren.Length; i++)
		{
			if (componentsInChildren[i].gameObject.activeSelf)
			{
				_webDefault = true;
			}
		}
		toggleWebSwing = _webDefault;
		return true;
	}

	private void SetWebSwing(bool on)
	{
		toggleWebSwing = on;
		if (on)
		{
			_webShowPending = true;
			return;
		}
		_webShowPending = false;
		if (SpiderApeSwing.Instance != null)
		{
			SpiderApeSwing.Instance.DetachAll();
		}
		ShowWebShooters(false);
	}

	private void ReconcileWebSwing(Player p)
	{
		if (_webShooters == null)
		{
			return;
		}
		if (!toggleWebSwing)
		{
			ShowWebShooters(false);
		}
		else if (_webShowPending && RigFree(p))
		{
			ShowWebShooters(true);
			_webShowPending = false;
		}
	}

	private void ShowWebShooters(bool show)
	{
		for (int i = 0; i < _webShooters.Length; i++)
		{
			SpiderApeWebShooter spiderApeWebShooter = _webShooters[i];
			if (spiderApeWebShooter != null && spiderApeWebShooter.gameObject.activeSelf != show)
			{
				spiderApeWebShooter.gameObject.SetActive(show);
			}
		}
	}

	private void ResetWebSwing()
	{
		if (_webShooters == null)
		{
			toggleWebSwing = false;
			return;
		}
		SetWebSwing(_webDefault);
		if (_webDefault && Player.Instance != null && Player.Instance.playerRigidBody != null)
		{
			ReconcileWebSwing(Player.Instance);
		}
	}

	private bool EnsureIceMaterial()
	{
		if (_iceMaterial != null)
		{
			return true;
		}
		if (_iceShaderMissing)
		{
			return false;
		}
		Shader shader = Resources.Load<Shader>("Mods/IceSurf");
		if (shader == null || !shader.isSupported)
		{
			_iceShaderMissing = true;
			Debug.LogError("[Mods] Ice Surfing: Resources/Mods/IceSurf.shader is missing or unsupported, the mod stays off.");
			return false;
		}
		_iceMaterial = new Material(shader)
		{
			name = "Ice Surf (runtime)"
		};
		return true;
	}

	private IcePath AcquireIcePath()
	{
		if (!EnsureIceMaterial())
		{
			return null;
		}
		for (int i = 0; i < _icePaths.Length; i++)
		{
			if (_icePaths[i] == null)
			{
				IcePath icePath = new IcePath(_iceMaterial, Frictionless, RigColliders());
				_icePaths[i] = icePath;
				return icePath;
			}
			if (!_icePaths[i].Visible)
			{
				_icePaths[i].SetRig(RigColliders());
				return _icePaths[i];
			}
		}
		IcePath icePath2 = null;
		for (int j = 0; j < _icePaths.Length; j++)
		{
			IcePath icePath3 = _icePaths[j];
			if (!IsLaid(icePath3) && (icePath2 == null || (icePath3.Retiring != icePath2.Retiring && icePath3.Retiring) || (icePath3.Retiring == icePath2.Retiring && icePath3.LastUsed < icePath2.LastUsed)))
			{
				icePath2 = icePath3;
			}
		}
		if (icePath2 != null)
		{
			icePath2.Hide();
			icePath2.SetRig(RigColliders());
		}
		return icePath2;
	}

	private bool IsLaid(IcePath path)
	{
		if (path == null)
		{
			return false;
		}
		if (_iceLaying[0] != path)
		{
			return _iceLaying[1] == path;
		}
		return true;
	}

	private static Collider[] RigColliders()
	{
		Player p = Player.Instance;
		if (p == null)
		{
			return Array.Empty<Collider>();
		}
		LAPlayer la = p.Driver as LAPlayer;
		if (la == null)
		{
			return new Collider[2] { p.bodyCollider, p.headCollider };
		}
		List<Collider> list = new List<Collider>();
		list.Add(p.bodyCollider);
		list.Add(p.headCollider);
		la.CollectHandColliders(list);
		return list.ToArray();
	}

	private void RetireIcePath(IcePath path)
	{
		path.Retire();
		if (_iceLaying[0] == path)
		{
			_iceLaying[0] = null;
		}
		if (_iceLaying[1] == path)
		{
			_iceLaying[1] = null;
		}
	}

	private void RetireIcePaths(bool immediate)
	{
		_iceLaying[0] = (_iceLaying[1] = null);
		for (int i = 0; i < _icePaths.Length; i++)
		{
			if (_icePaths[i] != null)
			{
				if (immediate)
				{
					_icePaths[i].Hide();
				}
				else
				{
					_icePaths[i].Retire();
				}
			}
		}
	}

	private void DisposeIcePaths()
	{
		_iceLaying[0] = (_iceLaying[1] = null);
		for (int i = 0; i < _icePaths.Length; i++)
		{
			if (_icePaths[i] != null)
			{
				_icePaths[i].Dispose();
			}
			_icePaths[i] = null;
		}
	}

	private bool IsIcePathSurface(Surface surface)
	{
		for (int i = 0; i < _icePaths.Length; i++)
		{
			if (_icePaths[i] != null && _icePaths[i].Surface == surface)
			{
				return true;
			}
		}
		return false;
	}

	private bool IsIcePathCollider(Collider collider)
	{
		for (int i = 0; i < _icePaths.Length; i++)
		{
			if (_icePaths[i] != null && _icePaths[i].Collider == collider)
			{
				return true;
			}
		}
		return false;
	}

	private IcePath IceTrackAt(Vector3 point, float margin)
	{
		for (int i = 0; i < _icePaths.Length; i++)
		{
			IcePath path = _icePaths[i];
			if (path != null && path.Visible && path.TryLocateRider(point, margin, out var _))
			{
				return path;
			}
		}
		return null;
	}

	private static Transform Hand(Player p, int hand)
	{
		if (hand != 0)
		{
			return p.rightHandTransform;
		}
		return p.leftHandTransform;
	}

	private static Vector3 ReachedHandPosition(Player p, int hand)
	{
		Transform tracked = Hand(p, hand);
		Vector3 offset = (hand != 0) ? p.rightHandOffset : p.leftHandOffset;
		Vector3 head = p.headCollider.transform.position;
		Vector3 target = tracked.position + tracked.rotation * offset * p.CurrentScale;
		Vector3 reach = (target - head) * p.armReachMultiplier;
		float maxReach = p.maxArmLength * p.CurrentScale * p.armReachMultiplier;
		return head + Vector3.ClampMagnitude(reach, maxReach);
	}

	private static float Pitch(Vector3 direction, Vector3 up)
	{
		return Mathf.Asin(Mathf.Clamp(Vector3.Dot(direction.normalized, up), -1f, 1f)) * Mathf.Rad2Deg;
	}

	private bool HandsNearIce(Player p)
	{
		if (!toggleIceSurfing)
		{
			return false;
		}
		float s = Mathf.Max(p.CurrentScale, 0.1f);
		float margin = s * 0.3f;
		for (int i = 0; i < _icePaths.Length; i++)
		{
			IcePath path = _icePaths[i];
			if (path != null && path.Visible && !path.Retiring)
			{
				if (p.wasLeftHandTouching && path.Surface == p.leftHandSurfaceOverride)
				{
					return true;
				}
				if (p.wasRightHandTouching && path.Surface == p.rightHandSurfaceOverride)
				{
					return true;
				}
				if (path.TryLocateRider(p.leftHandTransform.position, margin, out var _))
				{
					return true;
				}
				if (path.TryLocateRider(p.rightHandTransform.position, margin, out var _))
				{
					return true;
				}
			}
		}
		return false;
	}

	private void TickIceGrips(Player p)
	{
		TickIceGrip(p, 0, _leftGripDown, _leftGripPressed);
		TickIceGrip(p, 1, _rightGripDown, _rightGripPressed);
	}

	private void TickIceGrip(Player p, int hand, bool down, bool pressed)
	{
		if (!down)
		{
			_iceLaying[hand] = null;
			return;
		}
		IcePath laying = _iceLaying[hand];
		if (laying != null && laying.Visible && !laying.Retiring)
		{
			return;
		}
		_iceLaying[hand] = null;
		float s = Mathf.Max(p.CurrentScale, 0.1f);
		Vector3 up = p.transform.up;
		Vector3 top = ReachedHandPosition(p, hand) - up * (s * (p.minimumRaycastDistance + IceHandGap));
		IcePath path = IceTrackAt(top, s * IceOnMargin);
		if (path != null)
		{
			if (!IsLaid(path) && Vector3.Dot(up, path.Up) > 0.9f)
			{
				_iceLaying[hand] = path;
				_iceNeutralPitch[hand] = Pitch(Hand(p, hand).forward, up) - Pitch(path.EndDirection, up);
			}
		}
		else if (pressed)
		{
			StartIceTrack(p, hand, top, up, s);
		}
	}

	private void StartIceTrack(Player p, int hand, Vector3 top, Vector3 up, float s)
	{
		IcePath path = AcquireIcePath();
		if (path == null)
		{
			return;
		}
		Transform tracked = Hand(p, hand);
		Vector3 forward = Vector3.ProjectOnPlane(tracked.forward, up);
		if (forward.sqrMagnitude < 0.02f)
		{
			forward = Vector3.ProjectOnPlane(p.playerRigidBody.linearVelocity, up);
		}
		if (forward.sqrMagnitude < 0.02f)
		{
			forward = FlatForward(p, up);
		}
		forward = forward.normalized;
		if (GroundUnder(p, top, up, s, out var height))
		{
			float lift = s * IceGroundGap + height - Vector3.Dot(top, up);
			if (lift > 0f && lift < s * 0.2f)
			{
				top += up * lift;
			}
		}
		float now = Time.time;
		path.Reset(up, s * IceThickness, now);
		float width = s * IceWidth;
		float back = s * IcePadBack;
		path.Add(top - forward * back, width, now);
		path.Add(top, width, now);
		path.Add(top + forward * (s * IceTip), width, now);
		path.RiderArc = back;
		path.RebuildColliderNow();
		_iceLaying[hand] = path;
		_iceNeutralPitch[hand] = Pitch(tracked.forward, up);
		PulseHand(hand == 1, 0.25f, 0.05f);
	}

	private void TickIceSurfing(Player p, float dt, bool free)
	{
		float s = Mathf.Max(p.CurrentScale, 0.1f);
		if (toggleIceSurfing && free)
		{
			Vector3 up = p.transform.up;
			ExtendIceTrack(p, 0, up, s);
			ExtendIceTrack(p, 1, up, s);
		}
		else
		{
			_iceLaying[0] = (_iceLaying[1] = null);
		}
		float now = Time.time;
		for (int i = 0; i < _icePaths.Length; i++)
		{
			IcePath path = _icePaths[i];
			if (path == null || !path.Visible)
			{
				continue;
			}
			if (path.Retiring)
			{
				path.Fade -= dt / IceRetireTime;
				if (path.Fade <= 0f)
				{
					path.Hide();
					continue;
				}
			}
			else if (FrontRider(p, path, s, out var arc))
			{
				path.LastUsed = now;
				path.RiderArc = arc - path.TrimBehind(arc - s * (IceTailKeep + IceTailFade));
			}
			else if (now - path.LastUsed > IceUnusedGrace)
			{
				RetireIcePath(path);
			}
			path.Build(now, path.RiderArc, s * IceTailKeep, s * IceTailFade);
		}
	}

	private void ExtendIceTrack(Player p, int hand, Vector3 up, float s)
	{
		IcePath path = _iceLaying[hand];
		if (path == null)
		{
			return;
		}
		if (!path.Visible || path.Retiring || Vector3.Dot(up, path.Up) < 0.9f)
		{
			_iceLaying[hand] = null;
			return;
		}
		Transform tracked = Hand(p, hand);
		Vector3 top = tracked.position - up * (p.minimumRaycastDistance * s);
		float margin = s * IceOnMargin;
		if (!path.TryLocateRider(top, margin, out var arc))
		{
			return;
		}
		float tip = (p.playerRigidBody.linearVelocity.magnitude * IceTipPerSpeed + IceTip) * s;
		Vector3 direction = IceHandDirection(hand, tracked, up, path);
		Vector3 target = top + direction * tip;
		float minStepSqr = margin * margin * 0.25f;
		for (int i = 0; i < 4 && path.Length - arc < tip; i++)
		{
			Vector3 delta = target - path.Points[path.Count - 1];
			Vector3 desired = (delta.sqrMagnitude > minStepSqr) ? delta.normalized : direction;
			if (!ExtendIcePath(p, path, desired, up, s))
			{
				break;
			}
		}
	}

	private Vector3 IceHandDirection(int hand, Transform tracked, Vector3 up, IcePath path)
	{
		Vector3 forward = tracked.forward;
		Vector3 flat = Vector3.ProjectOnPlane(forward, up);
		if (flat.sqrMagnitude < 0.02f)
		{
			flat = Vector3.ProjectOnPlane(path.EndDirection, up);
		}
		if (flat.sqrMagnitude < 1E-06f)
		{
			return path.EndDirection;
		}
		flat = flat.normalized;
		float pitch = Pitch(forward, up) - _iceNeutralPitch[hand];
		float bend = Mathf.Max(Mathf.Abs(pitch) - IcePitchDeadband, 0f);
		float angle = Mathf.Clamp((pitch < 0f) ? (0f - bend) : bend, 0f - IceMaxDrop, IceMaxRise) * Mathf.Deg2Rad;
		return flat * Mathf.Cos(angle) + up * Mathf.Sin(angle);
	}

	private bool ExtendIcePath(Player p, IcePath path, Vector3 desired, Vector3 up, float s)
	{
		Vector3 last = path.Points[path.Count - 1];
		Vector3 direction = Vector3.RotateTowards(path.EndDirection, desired, IceMaxTurn * Mathf.Deg2Rad, 0f);
		float segment = s * IceSegment;
		Vector3 next = last + direction * segment;
		if (IceBlocked(p, last, next, up, s))
		{
			return false;
		}
		if (GroundUnder(p, next, up, s, out var height))
		{
			float lift = s * IceGroundGap + height - Vector3.Dot(next, up);
			if (lift > segment * 0.8f)
			{
				return false;
			}
			if (lift > 0f)
			{
				next += up * lift;
			}
		}
		path.Add(next, s * IceWidth, Time.time);
		return true;
	}

	private bool FrontRider(Player p, IcePath path, float s, out float arc)
	{
		arc = float.MinValue;
		Vector3 drop = path.Up * (p.minimumRaycastDistance * s);
		float margin = s * IceRiderMargin;
		bool found = false;
		if (path.TryLocateRider(p.leftHandTransform.position - drop, margin, out var a))
		{
			found = true;
			arc = Mathf.Max(arc, a);
		}
		if (path.TryLocateRider(p.rightHandTransform.position - drop, margin, out a))
		{
			found = true;
			arc = Mathf.Max(arc, a);
		}
		if (p.bodyCollider != null && p.bodyCollider.enabled && p.bodyCollider.gameObject.activeInHierarchy)
		{
			Bounds bounds = p.bodyCollider.bounds;
			if (path.TryLocateRider(bounds.center - path.Up * bounds.extents.y, margin, out a))
			{
				found = true;
				arc = Mathf.Max(arc, a);
			}
		}
		return found;
	}

	private bool GroundUnder(Player p, Vector3 point, Vector3 up, float s, out float height)
	{
		height = 0f;
		int hits = Physics.RaycastNonAlloc(point + up * s, -up, _seasonalHits, s * 2f, p.locomotionEnabledLayers, QueryTriggerInteraction.Ignore);
		if (hits <= 0)
		{
			return false;
		}
		float best = float.MaxValue;
		for (int i = 0; i < hits; i++)
		{
			RaycastHit hit = _seasonalHits[i];
			if (hit.distance > 0f && hit.distance < best && !(Vector3.Dot(up, hit.normal) < 0.5f) && !IsIcePathCollider(hit.collider))
			{
				best = hit.distance;
				height = Vector3.Dot(up, hit.point);
			}
		}
		return best < float.MaxValue;
	}

	private bool IceBlocked(Player p, Vector3 from, Vector3 to, Vector3 up, float s)
	{
		Vector3 delta = to - from;
		float distance = delta.magnitude;
		if (distance < 0.0001f)
		{
			return false;
		}
		Vector3 direction = delta / distance;
		int hits = Physics.SphereCastNonAlloc(from + up * (s * 0.35f), s * 0.18f, direction, _seasonalHits, distance, p.locomotionEnabledLayers, QueryTriggerInteraction.Ignore);
		for (int i = 0; i < hits; i++)
		{
			RaycastHit hit = _seasonalHits[i];
			if (hit.distance > 0f && Vector3.Dot(up, hit.normal) < 0.5f && !IsIcePathCollider(hit.collider))
			{
				return true;
			}
		}
		return false;
	}

	public override void OnJoinedRoom()
	{
		if (!IsAllowedToUseMods())
		{
			ResetAllMods();
		}
	}

	private void ResetAllMods()
	{
		toggleRGB = false;
		toggleSpeedBoost = false;
		toggleExtraSpeedBoost = false;
		toggleLongArms = false;
		toggleGhostMonke = false;
		togglePlatforms = false;
		toggleFly = false;
		toggleLowGravity = false;
		toggleFlipGravity = false;
		toggleAirSwim = false;
		toggleInfiniteArms = false;
		toggleNoSlip = false;
		toggleSpeedHack = false;
		toggleSuperJump = false;
		toggleIronGrip = false;
		toggleNoFriction = false;
		toggleInstantStick = false;
		toggleNoBodyCollider = false;
		togglePlayerPickup = false;
		toggleStickyHands = false;
		toggleDoubleJump = false;
		toggleDashAbility = false;
		toggleWallRun = false;
		toggleGrappleHands = false;
		togglePlayerESP = false;
		toggleFreezeOthers = false;
		toggleSlipperyMode = false;
		toggleAutoJump = false;
		toggleSpeedTrails = false;
		togglePlayerMagnet = false;
		toggleSuperStrength = false;
		toggleXRayVision = false;
		toggleZeroFriction = false;
		toggleMoonGravity = false;
		toggleMonsterSkin = false;
		toggleSlowFly = false;
		toggleFastFly = false;
		toggleJoystickFly = false;
		toggleHighGravity = false;
		toggleCarMonke = false;
		toggleStickyPlatforms = false;
		toggleInvisPlatforms = false;
		toggleBulletTime = false;
		toggleGravityGun = false;
		toggleLightningHands = false;
		toggleSpiderClimb = false;
		toggleJetpack = false;
		toggleExplosiveTouch = false;
		toggleIceTouch = false;
		toggleForcePush = false;
		toggleNinjaMode = false;
		toggleVampireMode = false;
		toggleShieldBubble = false;
		toggleSuperSpeed = false;
		toggleGiantMode = false;
		toggleFlashMode = false;
		toggleTelekinesis = false;
		toggleWindGust = false;
		toggleFireTrail = false;
		toggleSuperRGB = false;
		toggleWallClimb = false;
		toggleBouncyMode = false;
		toggleInvisible = false;
		toggleRocketHands = false;
		toggleMagnetHands = false;
		toggleSizeRainbow = false;
		toggleSpinMode = false;
		toggleEarthquake = false;
		togglePhaseWalls = false;
		toggleSuperSlide = false;
		toggleDiscoMode = false;
		ClearPlacedPlatforms();
		ResetSeasonalMods();
		StopAllCoroutines();
		StopDisco();
		Physics.gravity = _projectGravity;
		Time.timeScale = 1f;
		Time.fixedDeltaTime = _projectFixedDeltaTime;
		spinSpeed = 0f;
		Player p = Player.Instance;
		if (p != null && _originalsStored)
		{
			p.velocityLimit = originalVelocityLimit;
			p.maxJumpSpeed = originalMaxJumpSpeed;
			p.jumpMultiplier = originalJumpMultiplier;
			p.maxArmLength = originalMaxArmLength;
			p.rightHandOffset = Vector3.zero;
			p.leftHandOffset = Vector3.zero;
			p.defaultSlideFactor = originalSlideFactor;
			p.iceThreshold = originalIceThreshold;
			p.stickDepth = originalStickDepth;
			p.slideVelocityLimit = originalSlideVelocityLimit;
			p.frictionConstant = originalFrictionConstant;
			p.slideControl = originalSlideControl;
			p.bodyCollider.gameObject.SetActive(originalBodyColliderState);
		}
		if (p != null && p.playerRigidBody != null && !LethalApeR.Gameplay.RigHold.Anyone(LethalApeR.Gameplay.RigHold.What.Gravity))
		{
			p.playerRigidBody.useGravity = true;
		}
		MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
		if (manager != null && manager.LocalPlayer != null && !manager.LocalPlayer.IsBeingGrabbed)
		{
			manager.LocalPlayer.canTrack = true;
		}
		SetScale(1f);
		UpdateSizeDisplay();
	}
}
