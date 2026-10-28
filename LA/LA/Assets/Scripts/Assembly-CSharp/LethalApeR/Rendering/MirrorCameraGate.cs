using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Rendering
{
	[RequireComponent(typeof(Camera))]
	[DisallowMultipleComponent]
	[AddComponentMenu("Slop/Mirror Camera Gate")]
	public class MirrorCameraGate : MonoBehaviour
	{
		[Header("Proximity")]
		[Tooltip("The mirror wakes up while the local player's head is within this many metres. A 512x512 reflection is unreadable well before this in a headset.")]
		[SerializeField]
		private float activeDistance = 6f;

		[Tooltip("Extra distance past Active Distance before it goes back to sleep. Stops it cycling when you stand exactly on the boundary.")]
		[SerializeField]
		private float hysteresis = 1.5f;

		[Tooltip("Seconds between distance checks. The mirror does not need to know where you are every frame; the fade is what makes the transition smooth, not the poll rate.")]
		[SerializeField]
		private float checkInterval = 0.1f;

		[Header("Fade")]
		[Tooltip("Seconds to wake up. Slightly longer than the fade out so walking up to it feels like the reflection resolving rather than a light switch.")]
		[SerializeField]
		private float fadeInDuration = 0.5f;

		[Tooltip("Seconds to go back to sleep once you walk away.")]
		[SerializeField]
		private float fadeOutDuration = 0.35f;

		[Tooltip("Shape of the fade. Ease in/out reads far better than linear on a large flat surface -- linear makes the midpoint look like a rendering fault.")]
		[SerializeField]
		private AnimationCurve fadeCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

		[Tooltip("FALLBACK ONLY -- used when the surface material is a plain Standard shader with no _Fade property. On Slop/MirrorFade the dormant look is the proto parallax pane instead, and these are ignored.")]
		[SerializeField]
		private Color inactiveTint = new Color(0.16f, 0.17f, 0.2f, 1f);

		[Tooltip("FALLBACK ONLY. Emission while asleep on a plain Standard surface.")]
		[SerializeField]
		private Color inactiveEmission = Color.black;

		[Tooltip("Below 1, emission fades in AHEAD of albedo, so the glass appears to power on before the image resolves. 1 = both together.")]
		[Range(0.3f, 1f)]
		[SerializeField]
		private float emissionLead = 0.7f;

		[Header("Render throttle")]
		[Tooltip("Frames between renders when you are up close. 1 = every frame. Keep at 1 -- close up you notice a halved mirror when you move your hands.")]
		[SerializeField]
		private int nearRenderInterval = 1;

		[Tooltip("Frames between renders in the outer part of the radius. 2 halves the cost and is essentially invisible at that distance.")]
		[SerializeField]
		private int farRenderInterval = 2;

		[Tooltip("Fraction of Active Distance treated as 'near'. Inside this you get the near interval, beyond it the far interval.")]
		[Range(0.1f, 1f)]
		[SerializeField]
		private float nearFraction = 0.5f;

		[Header("Culling")]
		[Tooltip("LEAVE OFF. A mirror camera sits at the reflected position, usually inside the wall, where baked occlusion data says everything is hidden -- it culls your own reflection. See the class summary.")]
		[SerializeField]
		private bool useOcclusionCulling;

		[Tooltip("Copy the main camera's culling mask onto the mirror. A reflection should not show layers the player's own eyes cannot see, and the mirrors ship set to Everything. The MIRROR layer (the player's own face pieces) is kept.")]
		[SerializeField]
		private bool matchMainCameraCullingMask = true;

		[Tooltip("Layers to drop from the mirror on top of whatever mask it ends up with.")]
		[SerializeField]
		private LayerMask alsoExcludeLayers = 0;

		[Tooltip("Override the far clip plane. 0 leaves it as authored. This is the cheapest real culling a mirror has -- it only ever needs to see its own room.")]
		[SerializeField]
		private float farClipOverride;

		[Header("Surface")]
		[Tooltip("The renderer showing this camera's RenderTexture. Left empty it is found automatically by matching the RenderTexture against nearby materials.")]
		[SerializeField]
		private Renderer mirrorSurface;

		[Header("Diagnostics (read-only)")]
		[SerializeField]
		private float fade;

		[SerializeField]
		private bool awake;

		private Camera _cam;

		private Transform _listener;

		private MaterialPropertyBlock _mpb;

		private float _nextCheck;

		private int _frameCounter;

		private float _sqrDist = float.MaxValue;

		private Color _baseColor = Color.white;

		private Color _baseEmission = Color.white;

		private bool _surfaceResolved;

		private int _originalCullingMask;

		private bool _originalOcclusion;

		private bool _originalEnabled;

		private float _originalFarClip;

		private bool _captured;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private static readonly int FadeId = Shader.PropertyToID("_Fade");

		private static readonly int FadeEmissionId = Shader.PropertyToID("_FadeEmission");

		private bool _useFadeProperty;

		private void Awake()
		{
			_cam = GetComponent<Camera>();
		}

		private void OnEnable()
		{
			if (_cam == null)
			{
				_cam = GetComponent<Camera>();
			}
			if (_cam == null)
			{
				return;
			}
			if (!_captured)
			{
				_originalCullingMask = _cam.cullingMask;
				_originalOcclusion = _cam.useOcclusionCulling;
				_originalEnabled = _cam.enabled;
				_originalFarClip = _cam.farClipPlane;
				_captured = true;
			}
			ApplyCameraSettings();
			ResolveSurface();
			_listener = null;
			_nextCheck = 0f;
			awake = false;
			fade = 0f;
			ApplyFade(0f);
			_cam.enabled = false;
		}

		private void OnDisable()
		{
			if (_cam != null && _captured)
			{
				_cam.cullingMask = _originalCullingMask;
				_cam.useOcclusionCulling = _originalOcclusion;
				_cam.farClipPlane = _originalFarClip;
				_cam.enabled = _originalEnabled;
			}
			if (mirrorSurface != null)
			{
				mirrorSurface.SetPropertyBlock(null);
			}
		}

		private void ApplyCameraSettings()
		{
			_cam.useOcclusionCulling = useOcclusionCulling;
			int mask = _originalCullingMask;
			if (matchMainCameraCullingMask)
			{
				Camera main = Camera.main;
				if (main != null && main != _cam)
				{
					mask = main.cullingMask | (_originalCullingMask & MirrorLayer.Mask);
				}
			}
			_cam.cullingMask = mask & ~(int)alsoExcludeLayers;
			if (farClipOverride > 0f)
			{
				_cam.farClipPlane = farClipOverride;
			}
		}

		private void ResolveSurface()
		{
			if (_surfaceResolved && mirrorSurface != null)
			{
				return;
			}
			_surfaceResolved = true;
			if (mirrorSurface == null && _cam != null && _cam.targetTexture != null)
			{
				Transform root = (transform.parent != null) ? transform.parent : transform;
				Renderer[] renderers = root.GetComponentsInChildren<Renderer>(true);
				for (int i = 0; i < renderers.Length; i++)
				{
					if (mirrorSurface != null)
					{
						break;
					}
					Material[] mats = renderers[i].sharedMaterials;
					if (mats == null)
					{
						continue;
					}
					for (int j = 0; j < mats.Length; j++)
					{
						Material m = mats[j];
						if (!(m == null) && ((m.HasProperty(ColorId) && m.GetTexture("_MainTex") == _cam.targetTexture) || (m.HasProperty("_EmissionMap") && m.GetTexture("_EmissionMap") == _cam.targetTexture)))
						{
							mirrorSurface = renderers[i];
							break;
						}
					}
				}
			}
			if (mirrorSurface == null)
			{
				Debug.LogWarning("[MirrorCameraGate] " + name + ": no renderer found showing this camera's RenderTexture. Gating still works; fade is disabled. Assign Mirror Surface manually to restore it.", this);
				return;
			}
			Material shared = mirrorSurface.sharedMaterial;
			if (shared != null)
			{
				_useFadeProperty = shared.HasProperty(FadeId);
				if (shared.HasProperty(ColorId))
				{
					_baseColor = shared.GetColor(ColorId);
				}
				if (shared.HasProperty(EmissionId))
				{
					_baseEmission = shared.GetColor(EmissionId);
				}
			}
			_mpb = new MaterialPropertyBlock();
		}

		private void LateUpdate()
		{
			if (_cam == null)
			{
				return;
			}
			if (Time.unscaledTime >= _nextCheck)
			{
				_nextCheck = Time.unscaledTime + Mathf.Max(checkInterval, 0.02f);
				awake = EvaluateRange();
			}
			float target = (awake ? 1f : 0f);
			float duration = (awake ? fadeInDuration : fadeOutDuration);
			fade = ((duration > 0f) ? Mathf.MoveTowards(fade, target, Time.unscaledDeltaTime / duration) : target);
			ApplyFade(fade);
			if (fade <= 0f)
			{
				if (_cam.enabled)
				{
					_cam.enabled = false;
				}
				return;
			}
			if (fade >= 1f)
			{
				float near = activeDistance * nearFraction;
				int interval = Mathf.Max(1, (_sqrDist > near * near) ? farRenderInterval : nearRenderInterval);
				if (interval > 1)
				{
					_frameCounter++;
					bool render = _frameCounter % interval == 0;
					if (_cam.enabled != render)
					{
						_cam.enabled = render;
					}
					return;
				}
			}
			if (!_cam.enabled)
			{
				_cam.enabled = true;
			}
		}

		private bool EvaluateRange()
		{
			if (_listener == null)
			{
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				_listener = (manager != null) ? manager.Head : null;
				if (_listener == null)
				{
					Camera main = Camera.main;
					_listener = (main != null) ? main.transform : null;
				}
				if (_listener == null)
				{
					return false;
				}
			}
			_sqrDist = (transform.position - _listener.position).sqrMagnitude;
			float range = (awake ? (activeDistance + hysteresis) : activeDistance);
			return _sqrDist <= range * range;
		}

		private void ApplyFade(float f)
		{
			if (mirrorSurface == null || _mpb == null)
			{
				return;
			}
			float albedo = ((fadeCurve != null) ? fadeCurve.Evaluate(Mathf.Clamp01(f)) : Mathf.Clamp01(f));
			float emission = Mathf.Pow(albedo, Mathf.Max(emissionLead, 0.01f));
			mirrorSurface.GetPropertyBlock(_mpb);
			if (_useFadeProperty)
			{
				_mpb.SetFloat(FadeId, albedo);
				_mpb.SetFloat(FadeEmissionId, emission);
			}
			else
			{
				_mpb.SetColor(ColorId, Color.Lerp(inactiveTint, _baseColor, albedo));
				_mpb.SetColor(EmissionId, Color.Lerp(inactiveEmission, _baseEmission, emission));
			}
			mirrorSurface.SetPropertyBlock(_mpb);
		}

		[ContextMenu("Apply Recommended Settings")]
		private void ApplyRecommended()
		{
			activeDistance = 6f;
			hysteresis = 1.5f;
			checkInterval = 0.1f;
			fadeInDuration = 0.5f;
			fadeOutDuration = 0.35f;
			fadeCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);
			farClipOverride = 0f;
			inactiveTint = new Color(0.16f, 0.17f, 0.2f, 1f);
			inactiveEmission = Color.black;
			emissionLead = 0.7f;
			nearFraction = 0.5f;
			nearRenderInterval = 1;
			farRenderInterval = 2;
			useOcclusionCulling = false;
			matchMainCameraCullingMask = true;
		}

		private void OnValidate()
		{
			activeDistance = Mathf.Max(0f, activeDistance);
			hysteresis = Mathf.Max(0f, hysteresis);
			checkInterval = Mathf.Max(0.02f, checkInterval);
			fadeInDuration = Mathf.Max(0f, fadeInDuration);
			fadeOutDuration = Mathf.Max(0f, fadeOutDuration);
			farClipOverride = Mathf.Max(0f, farClipOverride);
			nearRenderInterval = Mathf.Max(1, nearRenderInterval);
			farRenderInterval = Mathf.Max(1, farRenderInterval);
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(0.3f, 0.9f, 0.6f, 1f);
			Gizmos.DrawWireSphere(transform.position, activeDistance);
			Gizmos.color = new Color(0.3f, 0.9f, 0.6f, 0.25f);
			Gizmos.DrawWireSphere(transform.position, activeDistance + hysteresis);
			Gizmos.color = new Color(1f, 0.85f, 0.2f, 0.4f);
			Gizmos.DrawWireSphere(transform.position, activeDistance * nearFraction);
		}
	}
}
