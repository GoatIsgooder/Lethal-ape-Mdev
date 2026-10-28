using System.Collections;
using LALocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Gameplay.Monsters;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.Lidar
{
	[RequireComponent(typeof(Grabbable))]
	[RequireComponent(typeof(Rigidbody))]
	public class LidarScanner : MonoBehaviour
	{
		[Header("Transforms")]
		[Tooltip("Ray origin — the cone fires from here along its forward (+Z). Also the PC-test origin. Defaults to this transform.")]
		[SerializeField]
		private Transform muzzle;

		[Header("Scan shape")]
		[Tooltip("Layers the scan cone can hit. Default = everything. Make sure your walls/floor are NOT trigger colliders (those are ignored).")]
		[SerializeField]
		private LayerMask scanMask = -1;

		[Tooltip("How far each ray reaches, in metres. Big Backrooms rooms need a big number or far rays hit nothing.")]
		[SerializeField]
		private float range = 80f;

		[Tooltip("Half-angle of the scan, in degrees. 18 = tight cone, 90 = forward dome, 180 = full sphere of points all around you (the reference look).")]
		[SerializeField]
		[Range(5f, 180f)]
		private float coneHalfAngleDeg = 90f;

		[Tooltip("Number of concentric rings, swept center-out over the scan duration. More rings = denser cloud.")]
		[SerializeField]
		private int rings = 40;

		[Tooltip("Points around the widest ring. Total dots per scan scales with this and 'rings' (kept under 4096).")]
		[SerializeField]
		private int pointsPerRing = 120;

		[Tooltip("How long the expanding sweep takes to fully reveal, in seconds. Spreads the raycasts across frames so there's no physics spike.")]
		[SerializeField]
		private float scanDuration = 0.4f;

		[Header("Dots")]
		[Tooltip("World diameter of each dot, in metres. 0.06–0.10 reads well in a room; smaller dots get hard to see at distance.")]
		[SerializeField]
		private float dotSize = 0.07f;

		[Tooltip("Shared mesh for every dot. Leave null to auto-capture a primitive sphere mesh in Awake.")]
		[SerializeField]
		private Mesh dotMesh;

		[Tooltip("Shared GPU-instanced material (shader 'Slop/LidarDot'). Leave null to create one in Awake.")]
		[SerializeField]
		private Material dotMaterial;

		[Tooltip("Color of every dot (uniform, like the reference LiDAR cloud). Applied to the material in Awake.")]
		[SerializeField]
		private Color nearColor = new Color(0.7f, 0.95f, 1f, 1f);

		[Tooltip("Color of a dot whose ray hit a monster. Those dots glow this (red) and the monster freezes.")]
		[SerializeField]
		private Color monsterColor = new Color(1f, 0.15f, 0.12f, 1f);

		[Header("Monster freeze")]
		[Tooltip("Seconds a monster stays frozen when a scan ray hits it. 0 = don't freeze (still turns the dot red). Host-authoritative + visible to everyone.")]
		[SerializeField]
		private float monsterFreezeDuration = 3f;

		[Header("Lifetime / feel")]
		[Tooltip("How long a dot stays alive before vanishing, in seconds.")]
		[SerializeField]
		private float dotLifetime = 4f;

		[Tooltip("Duration of the fade-out (and pop-out shrink) at the end of a dot's life.")]
		[SerializeField]
		private float fadeOutDur = 1.2f;

		[Tooltip("Pop-in grow time (easeOutBack overshoot) when a dot first appears.")]
		[SerializeField]
		private float popInDur = 0.12f;

		[Header("Cooldown")]
		[Tooltip("Seconds between scans — cannot be spammed. Clamped 1..2s.")]
		[SerializeField]
		[Range(1f, 2f)]
		private float cooldown = 1.5f;

		[Header("Audio (keep AudioSource Spatialize OFF — Meta XR spatializer silences spatialized sources in-editor)")]
		[Tooltip("Played once per scan (PlayOneShot).")]
		[SerializeField]
		private AudioClip scanClip;

		[Tooltip("Optional confirm tick the instant cooldown clears while squeezing.")]
		[SerializeField]
		private AudioClip readyClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float sfxVolume = 1f;

		[Header("Haptics")]
		[Tooltip("Punch amplitude on fire (0..1).")]
		[SerializeField]
		private float fireHaptic = 0.9f;

		[SerializeField]
		private float fireHapticDur = 0.12f;

		[Tooltip("Peak amplitude of the rising charge ramp as the trigger nears the fire threshold.")]
		[SerializeField]
		private float chargeHapticMax = 0.35f;

		[Header("Optional visual")]
		[Tooltip("Optional muzzle glow whose intensity ramps with the trigger charge (null-safe).")]
		[SerializeField]
		private Light muzzleLight;

		[Header("Debug / Testing")]
		[Tooltip("Editor-only: press this key in Play mode to run a full scan off this object's forward — no grab, no VR. Leave at None to disable. (Suggest L.)")]
		[SerializeField]
		private Key testScanKey;

		[Tooltip("Editor-only: show a clickable 'Test Scan' button in the Game view during Play mode. Fires a scan with NO grab, NO headset, NO keyboard — just click it.")]
		[SerializeField]
		private bool showPcTestButton = true;

		[Tooltip("Log ray/hit/dot counts to the Console on every scan. On by default while you're getting it working — it tells you whether rays are hitting anything. Turn off once dots appear.")]
		[SerializeField]
		private bool logScanInfo = true;

		private const int MAX_DOTS = 4096;

		private const int BATCH = 1023;

		private const float TriggerThreshold = 0.5f;

		private readonly Vector3[] _pos = new Vector3[4096];

		private readonly Quaternion[] _rot = new Quaternion[4096];

		private readonly float[] _baseScale = new float[4096];

		private readonly float[] _bornTime = new float[4096];

		private readonly bool[] _isMonster = new bool[4096];

		private int _head;

		private int _count;

		private readonly Matrix4x4[] _batchMatrices = new Matrix4x4[1023];

		private readonly Vector4[] _batchColors = new Vector4[1023];

		private MaterialPropertyBlock _mpb;

		private static readonly int ColorsId = Shader.PropertyToID("_Colors");

		private Rigidbody _rb;

		private Grabbable _grabbable;

		private AudioSource _audio;

		private GrabInteractor[] _interactorsCache;

		private LAGrabbable _la;

		private XRNode _node = XRNode.RightHand;

		private float _nextInteractorRescan;

		private bool _triggerWasDown;

		private float _nextScanTime;

		private bool _isScanning;

		private bool _wasReady;

		private float _nextChargePulse;

		private int _gpuLayer;

		private WaitForSeconds _ringWait;

		private float _cachedRingDelay = -1f;

		public bool IsReady => Time.time >= _nextScanTime && !_isScanning;

		public float CooldownRemaining => Mathf.Max(0f, _nextScanTime - Time.time);

		public Transform Muzzle => (muzzle != null) ? muzzle : base.transform;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_grabbable = GetComponent<Grabbable>();
			_la = GetComponent<LAGrabbable>();
			_audio = GetComponent<AudioSource>();
			if (muzzle == null)
			{
				muzzle = base.transform;
			}
			if (dotMaterial == null)
			{
				Shader shader = Shader.Find("Slop/LidarDot");
				if (shader == null)
				{
					Debug.LogError("[Lidar] Shader 'Slop/LidarDot' not found — dots will not render. Make sure LidarDot.shader imported (Slop/LidarDot).", this);
				}
				else
				{
					dotMaterial = new Material(shader);
				}
			}
			if (dotMaterial != null)
			{
				dotMaterial.enableInstancing = true;
				dotMaterial.SetColor("_Colors", nearColor);
			}
			_mpb = new MaterialPropertyBlock();
			if (dotMesh == null)
			{
				GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere);
				dotMesh = gameObject.GetComponent<MeshFilter>().sharedMesh;
				if (Application.isPlaying)
				{
					Object.Destroy(gameObject);
				}
				else
				{
					Object.DestroyImmediate(gameObject);
				}
			}
			if (!SystemInfo.supportsInstancing)
			{
				Debug.LogWarning("[Lidar] GPU instancing unsupported on this device; dots will still draw but unbatched.", this);
			}
			_gpuLayer = 0;
		}

		private GrabInteractor FindHoldingInteractor()
		{
			bool flag = _interactorsCache == null || _interactorsCache.Length == 0;
			if (!flag)
			{
				for (int i = 0; i < _interactorsCache.Length; i++)
				{
					if (_interactorsCache[i] == null)
					{
						flag = true;
						break;
					}
				}
			}
			if (flag && Time.time >= _nextInteractorRescan)
			{
				_nextInteractorRescan = Time.time + 1f;
				_interactorsCache = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			}
			if (_interactorsCache == null)
			{
				return null;
			}
			for (int j = 0; j < _interactorsCache.Length; j++)
			{
				GrabInteractor grabInteractor = _interactorsCache[j];
				if (!(grabInteractor == null) && grabInteractor.IsGrabbing)
				{
					if (grabInteractor.HeldRigidbody == _rb || grabInteractor.HeldTransform == base.transform)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform != null && grabInteractor.HeldTransform.IsChildOf(base.transform))
					{
						return grabInteractor;
					}
				}
			}
			return null;
		}

		private bool TryLocalHolder(out XRNode node)
		{
			if (_la != null && _la.Holder != null)
			{
				node = (_la.Holder.isLeft ? XRNode.LeftHand : XRNode.RightHand);
				return true;
			}
			GrabInteractor grabInteractor = FindHoldingInteractor();
			node = ((grabInteractor != null) ? grabInteractor.node : _node);
			return grabInteractor != null;
		}

		private float ReadTrigger()
		{
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return 0f;
			}
			if (_node != XRNode.LeftHand)
			{
				return instance.RightTriggerValue;
			}
			return instance.LeftTriggerValue;
		}

		private void Pulse(float amp, float dur)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null) && !(amp <= 0f))
			{
				if (_node == XRNode.LeftHand)
				{
					instance.PulseLeft(amp, dur);
				}
				else
				{
					instance.PulseRight(amp, dur);
				}
			}
		}

		private void Update()
		{
			bool flag = false;
			if (TryLocalHolder(out XRNode node))
			{
				_node = node;
				float num = ReadTrigger();
				flag = num >= 0.5f;
				bool flag2 = flag && !_triggerWasDown;
				bool isReady = IsReady;
				if (isReady)
				{
					if (num > 0.05f && !_wasReady)
					{
						Pulse(0.5f, 0.05f);
						PlayClip(readyClip);
					}
					_wasReady = true;
				}
				else
				{
					_wasReady = false;
				}
				if (isReady && num > 0.05f && num < 0.5f)
				{
					float num2 = Mathf.Clamp01((num - 0.05f) / 0.45f);
					if (Time.time >= _nextChargePulse)
					{
						Pulse(num2 * chargeHapticMax + 0.04f, 0.05f);
						_nextChargePulse = Time.time + 0.05f;
					}
					if ((bool)muzzleLight)
					{
						muzzleLight.intensity = num2;
					}
				}
				else if ((bool)muzzleLight)
				{
					muzzleLight.intensity = 0f;
				}
				if (flag2)
				{
					if (isReady)
					{
						Fire();
					}
					else
					{
						Pulse(0.2f, 0.03f);
					}
				}
			}
			_triggerWasDown = flag;
		}

		private void Fire()
		{
			_nextScanTime = Time.time + Mathf.Clamp(cooldown, 1f, 2f);
			Pulse(fireHaptic, fireHapticDur);
			PlayClip(scanClip);
			StartCoroutine(ScanRoutine(Muzzle.position, Muzzle.rotation));
		}

		[ContextMenu("Test Scan")]
		public void TestScan()
		{
			if (!Application.isPlaying)
			{
				Debug.LogWarning("[Lidar] Test Scan only runs in Play mode (the sweep is a coroutine). Enter Play and try again.", this);
				return;
			}
			PlayClip(scanClip);
			StartCoroutine(ScanRoutine(Muzzle.position, Muzzle.rotation));
		}

		private IEnumerator ScanRoutine(Vector3 origin, Quaternion aimRot)
		{
			_isScanning = true;
			Vector3 fwd = aimRot * Vector3.forward;
			float half = coneHalfAngleDeg * Mathf.Deg2Rad;
			Vector3 lhs = ((Mathf.Abs(Vector3.Dot(fwd, Vector3.up)) > 0.95f) ? Vector3.right : Vector3.up);
			Vector3 tangent = Vector3.Cross(lhs, fwd).normalized;
			Vector3 bitangent = Vector3.Cross(fwd, tangent);
			int sweepHapticEvery = Mathf.Max(1, rings / 4);
			int raysCast = 0;
			int hits = 0;
			float num = scanDuration / (float)Mathf.Max(1, rings);
			if (_ringWait == null || num != _cachedRingDelay)
			{
				_cachedRingDelay = num;
				_ringWait = new WaitForSeconds(num);
			}
			for (int r = 0; r < rings; r++)
			{
				float f = ((float)r + 0.5f) / (float)rings * half;
				float num2 = Mathf.Sin(f);
				float num3 = Mathf.Cos(f);
				int num4 = Mathf.Max(1, Mathf.RoundToInt((float)pointsPerRing * num2) + 1);
				float num5 = Mathf.PI * 2f / (float)num4;
				float num6 = (float)r * 2.3999631f;
				for (int i = 0; i < num4; i++)
				{
					float f2 = num6 + num5 * (float)i;
					Vector3 direction = fwd * num3 + (tangent * Mathf.Cos(f2) + bitangent * Mathf.Sin(f2)) * num2;
					raysCast++;
					if (Physics.Raycast(origin, direction, out RaycastHit hitInfo, range, scanMask, QueryTriggerInteraction.Ignore))
					{
						BaseMonster componentInParent = hitInfo.collider.GetComponentInParent<BaseMonster>();
						bool flag = componentInParent != null;
						if (flag && monsterFreezeDuration > 0f)
						{
							componentInParent.RequestFreeze(monsterFreezeDuration);
						}
						PlaceDot(hitInfo.point, hitInfo.normal, flag);
						hits++;
					}
				}
				if (r % sweepHapticEvery == 0)
				{
					Pulse(0.12f, 0.03f);
				}
				yield return _ringWait;
			}
			if (logScanInfo)
			{
				Debug.Log(string.Format("[Lidar] scan from {0} fwd {1}: {2} rays, {3} hits, {4} dots alive. ", origin, fwd, raysCast, hits, _count) + ((hits == 0) ? "0 HITS — check range, that geometry isn't trigger-only, and that the muzzle points at something within range." : ""), this);
			}
			_isScanning = false;
		}

		private void PlaceDot(Vector3 p, Vector3 normal, bool isMonster)
		{
			_pos[_head] = p + normal * 0.005f;
			_rot[_head] = Quaternion.LookRotation(normal);
			_baseScale[_head] = dotSize * Random.Range(0.85f, 1.15f);
			_bornTime[_head] = Time.time;
			_isMonster[_head] = isMonster;
			_head = (_head + 1) & 0xFFF;
			_count = Mathf.Min(_count + 1, 4096);
		}

		private void LateUpdate()
		{
			if (_count == 0 || dotMesh == null || dotMaterial == null)
			{
				return;
			}
			float time = Time.time;
			int num = 0;
			for (int i = 0; i < _count; i++)
			{
				int num2 = (_head - 1 - i) & 0xFFF;
				float num3 = time - _bornTime[num2];
				if (num3 >= dotLifetime)
				{
					_count = i;
					break;
				}
				float num4 = 1f;
				float num5 = dotLifetime - fadeOutDur;
				if (num3 > num5)
				{
					num4 = Mathf.Clamp01(1f - (num3 - num5) / fadeOutDur);
				}
				float p = Mathf.Clamp01(num3 / popInDur);
				float num6 = EaseOutBack(p) * _baseScale[num2] * num4;
				_batchMatrices[num] = Matrix4x4.TRS(_pos[num2], _rot[num2], new Vector3(num6, num6, num6));
				_batchColors[num] = (_isMonster[num2] ? monsterColor : nearColor);
				num++;
				if (num == 1023)
				{
					Flush(1023);
					num = 0;
				}
			}
			if (num > 0)
			{
				Flush(num);
			}
		}

		private void Flush(int n)
		{
			_mpb.SetVectorArray(ColorsId, _batchColors);
			Graphics.DrawMeshInstanced(dotMesh, 0, dotMaterial, _batchMatrices, n, _mpb, ShadowCastingMode.Off, receiveShadows: false, _gpuLayer, null, LightProbeUsage.Off);
		}

		private void PlayClip(AudioClip clip)
		{
			if (!(clip == null))
			{
				if (_audio != null)
				{
					_audio.PlayOneShot(clip, sfxVolume);
				}
				else
				{
					AudioSource.PlayClipAtPoint(clip, Muzzle.position, sfxVolume);
				}
			}
		}

		private static float EaseOutBack(float p)
		{
			float num = p - 1f;
			return 1f + 2.70158f * num * num * num + 1.70158f * num * num;
		}

		private void OnDrawGizmosSelected()
		{
			Transform transform = ((muzzle != null) ? muzzle : base.transform);
			Gizmos.color = Color.cyan;
			float num = Mathf.Tan(coneHalfAngleDeg * Mathf.Deg2Rad);
			Quaternion quaternion = Quaternion.LookRotation(transform.forward);
			for (int i = 0; i < 12; i++)
			{
				float f = (float)i / 12f * Mathf.PI * 2f;
				Vector3 normalized = new Vector3(Mathf.Cos(f) * num, Mathf.Sin(f) * num, 1f).normalized;
				Vector3 normalized2 = (quaternion * normalized).normalized;
				Gizmos.DrawLine(transform.position, transform.position + normalized2 * range);
			}
		}
	}
}
