using LALocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.Camcorder
{
	public class Camcorder : MonoBehaviour
	{
		public enum CamButton
		{
			None = 0,
			Primary = 1,
			Secondary = 2
		}

		[Header("Rig")]
		[Tooltip("Renderer carrying the NightVision material. Auto-found in children if empty.")]
		[SerializeField]
		private Renderer screenRenderer;

		[Tooltip("Material slot of the screen on that renderer. -1 = auto-detect the slot using the NightVision shader.")]
		[SerializeField]
		private int screenMaterialIndex = -1;

		[Tooltip("Where the camcorder lens sits, +Z pointing where it films. Falls back to this transform.")]
		[SerializeField]
		private Transform cameraAnchor;

		[Header("Render (Quest budget)")]
		[Tooltip("RenderTexture resolution. 512 looks crisp on the screen; drop to 384/256 if a map is heavy.")]
		[SerializeField]
		private int textureSize = 512;

		[Tooltip("Vertical FOV of the camcorder lens at 1x.")]
		[SerializeField]
		private float fieldOfView = 55f;

		[Tooltip("Magnification. Lens FOV = fieldOfView / zoom.")]
		[Min(1f)]
		[SerializeField]
		private float zoom = 1f;

		[SerializeField]
		private float nearClip = 0.05f;

		[SerializeField]
		private float farClip = 300f;

		[Tooltip("What the camcorder films. Exclude UI/overlay layers so they don't show on the screen.")]
		[SerializeField]
		private LayerMask cullingMask = -1;

		[Tooltip("1 = render every frame. 2 halves the extra-camera cost (slightly steppy feed).")]
		[Min(1f)]
		[SerializeField]
		private int renderEveryNthFrame = 2;

		[Header("Power / Night Vision")]
		[Tooltip("Screen on at start.")]
		[SerializeField]
		private bool startPowered = true;

		[Tooltip("Night-vision mode on at start (vs plain camcorder feed).")]
		[SerializeField]
		private bool startNightVision = true;

		[Tooltip("How fast power and NV fade in/out (1/seconds).")]
		[SerializeField]
		private float fadeSpeed = 6f;

		[Tooltip("Held button that toggles night vision on/off (A/X). Set to None to disable.")]
		[SerializeField]
		private CamButton nightVisionButton = CamButton.Primary;

		[Tooltip("Held button that toggles power on/off (B/Y). Set to None to disable.")]
		[SerializeField]
		private CamButton powerButton = CamButton.Secondary;

		[Header("IR Illuminator (see in the dark)")]
		[Tooltip("Adds a hidden light that ONLY the camcorder's own render sees. It's switched on just for the manual camera render and off again immediately, so dark areas light up on the NV screen while the room stays pitch black to your eyes — like a real IR camcorder.")]
		[SerializeField]
		private bool useIlluminator = true;

		[Tooltip("How far the illuminator reaches (metres).")]
		[SerializeField]
		private float illuminatorRange = 14f;

		[Tooltip("Brightness of the illuminator. Raise if dark areas are still too dim on screen.")]
		[SerializeField]
		private float illuminatorIntensity = 3f;

		[Tooltip("0 = point flood (lights everything around the lens evenly). >0 = a spot BEAM of this cone angle aimed where the lens points.")]
		[SerializeField]
		private float illuminatorSpotAngle;

		[Tooltip("Only illuminate while night vision is ON (so plain-camcorder mode stays a normal exposed feed).")]
		[SerializeField]
		private bool illuminatorOnlyInNV = true;

		[Header("Battery (optional)")]
		[Tooltip("Battery 0..1. Drives extra grain + flicker as it drains; 1 = full.")]
		[Range(0f, 1f)]
		[SerializeField]
		private float battery = 1f;

		[Tooltip("Battery drained per second while powered. 0 = never drains.")]
		[SerializeField]
		private float batteryDrainPerSec;

		[Header("Feedback")]
		[Tooltip("Keep AudioSource Spatialize OFF (Meta XR spatializer silences spatialized sources in-editor).")]
		[SerializeField]
		private AudioClip toggleClip;

		[SerializeField]
		private AudioClip powerClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float sfxVolume = 1f;

		[SerializeField]
		[Range(0f, 1f)]
		private float toggleHaptic = 0.4f;

		[Header("Debug / Testing")]
		[Tooltip("Render + show the screen even when nothing is holding the camcorder (for PC testing / fixed mounts). Costs the camera render every Nth frame while on.")]
		[SerializeField]
		private bool testForceRender;

		[Tooltip("Editor-only: press to toggle night vision with NO grab/VR. None to disable.")]
		[SerializeField]
		private Key testToggleKey;

		[Tooltip("Editor-only: show a clickable 'Night Vision' button in the Game view during Play mode.")]
		[SerializeField]
		private bool showPcTestButton = true;

		private Camera _cam;

		private Light _ir;

		private RenderTexture _rt;

		private MaterialPropertyBlock _mpb;

		private Rigidbody _rb;

		private AudioSource _audio;

		private GrabInteractor[] _interactorsCache;

		private LAGrabbable _la;

		private XRNode _node = XRNode.RightHand;

		private float _nextInteractorRescan;

		private float _nextPeriodicRescan;

		private int _screenSlot;

		private float _baseEmission = 2.6f;

		private bool _power;

		private bool _nv;

		private float _powerFade;

		private float _nvFade;

		private float _appliedFov = -1f;

		private bool _primaryWas;

		private bool _secondaryWas;

		private const string ShaderName = "SlopGame/NightVision";

		private static readonly int MainTexId = Shader.PropertyToID("_MainTex");

		private static readonly int NightVisionId = Shader.PropertyToID("_NightVision");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionStrength");

		private static readonly int BatteryId = Shader.PropertyToID("_Battery");

		public bool IsPowered => _power;

		public bool NightVisionOn => _nv;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_la = GetComponent<LAGrabbable>();
			_audio = GetComponent<AudioSource>();
			_mpb = new MaterialPropertyBlock();
			if (cameraAnchor == null)
			{
				cameraAnchor = base.transform;
			}
			ResolveScreen();
			_power = startPowered;
			_nv = startNightVision;
			_powerFade = (_power ? 1f : 0f);
			_nvFade = (_nv ? 1f : 0f);
			GameObject cameraObject = new GameObject("CamcorderCamera");
			cameraObject.transform.SetParent(cameraAnchor, false);
			_cam = cameraObject.AddComponent<Camera>();
			_cam.enabled = false;
			_cam.stereoTargetEye = StereoTargetEyeMask.None;
			_cam.allowMSAA = false;
			_cam.allowHDR = false;
			_cam.nearClipPlane = nearClip;
			if (useIlluminator)
			{
				GameObject irObject = new GameObject("CamcorderIR");
				irObject.transform.SetParent(_cam.transform, false);
				_ir = irObject.AddComponent<Light>();
				_ir.enabled = false;
				_ir.shadows = LightShadows.None;
				_ir.renderMode = LightRenderMode.ForcePixel;
				_ir.color = Color.white;
				_ir.range = Mathf.Max(0.5f, illuminatorRange);
				_ir.intensity = Mathf.Max(0f, illuminatorIntensity);
				if (illuminatorSpotAngle > 0f)
				{
					_ir.type = LightType.Spot;
					_ir.spotAngle = Mathf.Clamp(illuminatorSpotAngle, 1f, 179f);
				}
				else
				{
					_ir.type = LightType.Point;
				}
			}
		}

		private void OnDisable()
		{
			_powerFade = 0f;
			PushScreenState();
			ReleaseTexture();
		}

		private void OnDestroy()
		{
			ReleaseTexture();
			if (_cam != null)
			{
				Object.Destroy(_cam.gameObject);
			}
		}

		private void Update()
		{
			if (!TryLocalHolder(out var node))
			{
				_primaryWas = false;
				_secondaryWas = false;
				return;
			}
			_node = node;
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				bool prim = ((_node == XRNode.LeftHand) ? instance.LeftPrimaryButton : instance.RightPrimaryButton);
				bool sec = ((_node == XRNode.LeftHand) ? instance.LeftSecondaryButton : instance.RightSecondaryButton);
				if (Pressed(nightVisionButton, prim, sec, _primaryWas, _secondaryWas))
				{
					ToggleNightVision();
				}
				if (Pressed(powerButton, prim, sec, _primaryWas, _secondaryWas))
				{
					TogglePower();
				}
				_primaryWas = prim;
				_secondaryWas = sec;
			}
		}

		private bool Pressed(CamButton b, bool prim, bool sec, bool primWas, bool secWas)
		{
			return b switch
			{
				CamButton.Primary => prim && !primWas,
				CamButton.Secondary => sec && !secWas,
				_ => false,
			};
		}

		private void LateUpdate()
		{
			if (_power && batteryDrainPerSec > 0f)
			{
				battery = Mathf.Max(0f, battery - batteryDrainPerSec * Time.deltaTime);
			}
			_powerFade = Mathf.MoveTowards(_powerFade, _power ? 1f : 0f, fadeSpeed * Time.deltaTime);
			_nvFade = Mathf.MoveTowards(_nvFade, _nv ? 1f : 0f, fadeSpeed * Time.deltaTime);
			if (_powerFade > 0.01f && (testForceRender || IsHeld()))
			{
				bool hadTexture = _rt != null && _rt.IsCreated();
				EnsureTexture();
				_cam.cullingMask = cullingMask;
				_cam.farClipPlane = farClip;
				float fov = Mathf.Clamp(fieldOfView / Mathf.Max(1f, zoom), 1f, 120f);
				if (!Mathf.Approximately(fov, _appliedFov))
				{
					_cam.fieldOfView = fov;
					_appliedFov = fov;
				}
				if (!hadTexture || Time.frameCount % Mathf.Max(1, renderEveryNthFrame) == 0)
				{
					if (_ir != null && (!illuminatorOnlyInNV || _nvFade > 0.05f))
					{
						_ir.enabled = true;
					}
					_cam.Render();
					if (_ir != null)
					{
						_ir.enabled = false;
					}
				}
			}
			PushScreenState();
		}

		[ContextMenu("Toggle Night Vision")]
		public void ToggleNightVision()
		{
			_nv = !_nv;
			PlayClip(toggleClip);
			Pulse(toggleHaptic, 0.04f);
		}

		[ContextMenu("Toggle Power")]
		public void TogglePower()
		{
			_power = !_power;
			PlayClip((powerClip != null) ? powerClip : toggleClip);
			Pulse(toggleHaptic, 0.06f);
		}

		private bool IsHeld()
		{
			if (_la != null && _la.IsHeld)
			{
				return true;
			}
			return FindHoldingInteractor() != null;
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

		private GrabInteractor FindHoldingInteractor()
		{
			bool needsScan = _interactorsCache == null || _interactorsCache.Length == 0;
			if (!needsScan)
			{
				for (int i = 0; i < _interactorsCache.Length; i++)
				{
					if (_interactorsCache[i] == null)
					{
						needsScan = true;
						break;
					}
				}
			}
			if ((needsScan || Time.time >= _nextPeriodicRescan) && Time.time >= _nextInteractorRescan)
			{
				_nextInteractorRescan = Time.time + 0.5f;
				_nextPeriodicRescan = Time.time + 2f;
				_interactorsCache = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			}
			GrabInteractor[] interactorsCache = _interactorsCache;
			if (interactorsCache == null)
			{
				return null;
			}
			foreach (GrabInteractor grabInteractor in interactorsCache)
			{
				if (!(grabInteractor == null) && grabInteractor.IsGrabbing)
				{
					if (_rb != null && grabInteractor.HeldRigidbody == _rb)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform == base.transform)
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

		private void ResolveScreen()
		{
			if (screenRenderer == null)
			{
				Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>(true);
				foreach (Renderer renderer in componentsInChildren)
				{
					if (FindSlot(renderer) >= 0)
					{
						screenRenderer = renderer;
						break;
					}
				}
				if (screenRenderer == null)
				{
					screenRenderer = GetComponentInChildren<Renderer>();
				}
			}
			if (screenRenderer == null)
			{
				Debug.LogWarning("[Camcorder] No screen renderer found — assign one with a NightVision material.", this);
				return;
			}
			int slot = screenMaterialIndex;
			if (slot < 0)
			{
				slot = FindSlot(screenRenderer);
				if (slot < 0)
				{
					Shader shader = Shader.Find("SlopGame/NightVision");
					if (shader != null)
					{
						Material[] materials = screenRenderer.materials;
						if (materials.Length == 0)
						{
							materials = new Material[1];
						}
						materials[0] = new Material(shader);
						screenRenderer.materials = materials;
						Debug.Log("[Camcorder] No 'SlopGame/NightVision' material on '" + screenRenderer.name + "' — auto-created one on slot 0.", this);
					}
					else
					{
						Debug.LogError("[Camcorder] Shader 'SlopGame/NightVision' not found and no screen material — screen will not show. Make sure NightVision.shader imported.", this);
					}
					slot = 0;
				}
			}
			_screenSlot = Mathf.Min(slot, Mathf.Max(0, screenRenderer.sharedMaterials.Length - 1));
			Material material = ((_screenSlot < screenRenderer.sharedMaterials.Length) ? screenRenderer.sharedMaterials[_screenSlot] : null);
			if (material != null && material.HasProperty(EmissionId))
			{
				_baseEmission = material.GetFloat(EmissionId);
			}
		}

		private static int FindSlot(Renderer r)
		{
			Material[] sharedMaterials = r.sharedMaterials;
			for (int i = 0; i < sharedMaterials.Length; i++)
			{
				if (sharedMaterials[i] != null && sharedMaterials[i].shader != null && sharedMaterials[i].shader.name == "SlopGame/NightVision")
				{
					return i;
				}
			}
			return -1;
		}

		private void PushScreenState()
		{
			if (!(screenRenderer == null))
			{
				screenRenderer.GetPropertyBlock(_mpb, _screenSlot);
				if (_rt != null)
				{
					_mpb.SetTexture(MainTexId, _rt);
				}
				_mpb.SetFloat(NightVisionId, _nvFade);
				_mpb.SetFloat(EmissionId, _powerFade * _baseEmission);
				_mpb.SetFloat(BatteryId, Mathf.Clamp01(battery));
				screenRenderer.SetPropertyBlock(_mpb, _screenSlot);
			}
		}

		private void EnsureTexture()
		{
			if (_rt == null)
			{
				int size = Mathf.Clamp(textureSize, 64, 2048);
				_rt = new RenderTexture(size, size, 16, RenderTextureFormat.Default)
				{
					name = "CamcorderRT",
					useMipMap = false,
					filterMode = FilterMode.Bilinear
				};
			}
			if (!_rt.IsCreated())
			{
				_rt.Create();
			}
			if (_cam != null && _cam.targetTexture != _rt)
			{
				_cam.targetTexture = _rt;
			}
		}

		private void ReleaseTexture()
		{
			if (_cam != null)
			{
				_cam.targetTexture = null;
			}
			if (_rt != null)
			{
				_rt.Release();
				Object.Destroy(_rt);
				_rt = null;
			}
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
					AudioSource.PlayClipAtPoint(clip, base.transform.position, sfxVolume);
				}
			}
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
	}
}
