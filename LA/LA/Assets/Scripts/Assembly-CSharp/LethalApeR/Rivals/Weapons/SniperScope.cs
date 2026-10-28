using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	public class SniperScope : MonoBehaviour
	{
		[Header("Rig")]
		[Tooltip("Renderer carrying the ScopeLens material — a dedicated lens quad OR the gun mesh itself when the lens is a submesh/material slot. Auto-found in children if empty.")]
		[SerializeField]
		private Renderer lensRenderer;

		[Tooltip("Material slot of the lens on that renderer. -1 = auto-detect the slot using the ScopeLens shader (handles multi-material gun meshes).")]
		[SerializeField]
		private int lensMaterialIndex = -1;

		[Tooltip("Where the scope camera sits, +Z downrange. Falls back to this transform.")]
		[SerializeField]
		private Transform cameraAnchor;

		[Header("Zoom")]
		[Tooltip("Magnification. Scope camera FOV = reference FOV / zoom.")]
		[Min(1f)]
		public float zoom = 6f;

		[Tooltip("The FOV that counts as 1x (roughly the headset's vertical FOV).")]
		public float referenceFov = 90f;

		[Header("Render (Quest budget)")]
		[Tooltip("Render texture resolution — 384 reads sharp through the lens without hurting frame time.")]
		public int textureSize = 384;

		public float farClip = 400f;

		[Tooltip("What the scope sees. Exclude UI/overlay layers if they ever show up in it.")]
		public LayerMask cullingMask = -1;

		[Tooltip("1 = scope updates every frame. 2 halves the scope's GPU cost (slightly steppy pan).")]
		[Min(1f)]
		public int renderEveryNthFrame = 1;

		[Header("Activation (eye behind the glass)")]
		[Tooltip("How far BEHIND the scope-front anchor the eye may sit (meters, scaled by player size).")]
		public float activateDistance = 0.9f;

		[Tooltip("Max sideways distance from the scope axis — cheek-weld slop (meters, scaled by player size).")]
		public float activateLateral = 0.18f;

		[Tooltip("Max angle between the eye's gaze and the scope axis (degrees).")]
		public float activateAngle = 45f;

		[Tooltip("How fast the glass fades between dark and live (1/seconds).")]
		public float fadeSpeed = 8f;

		[Header("Testing")]
		[Tooltip("Force the scope live regardless of eye position — for testing before the gun is grabbable. Costs the full scope render every frame while on; turn OFF for real builds.")]
		public bool testForceActive;

		private Camera _cam;

		private RenderTexture _rt;

		private MaterialPropertyBlock _mpb;

		private Weapon _weapon;

		private float _active;

		private float _appliedFov = -1f;

		private int _lensSlot;

		private const string LensShaderName = "LethalApeR/Rivals/ScopeLens";

		private static readonly int MainTexId = Shader.PropertyToID("_MainTex");

		private static readonly int ActiveId = Shader.PropertyToID("_Active");

		private void Awake()
		{
			ResolveLens();
			_weapon = GetComponentInParent<Weapon>();
			if (cameraAnchor == null)
			{
				cameraAnchor = base.transform;
			}
			GameObject gameObject = new GameObject("ScopeCamera");
			gameObject.transform.SetParent(cameraAnchor, worldPositionStays: false);
			_cam = gameObject.AddComponent<Camera>();
			_cam.enabled = false;
			_cam.stereoTargetEye = StereoTargetEyeMask.None;
			_cam.allowMSAA = false;
			_cam.allowHDR = false;
			_cam.nearClipPlane = 0.05f;
		}

		private void OnDisable()
		{
			_active = 0f;
			PushLensState();
			ReleaseTexture();
		}

		private void OnDestroy()
		{
			ReleaseTexture();
		}

		private void LateUpdate()
		{
			float target = (testForceActive ? 1f : (EyeBehindScope() ? 1f : 0f));
			_active = Mathf.MoveTowards(_active, target, fadeSpeed * Time.deltaTime);
			if (_active > 0.01f)
			{
				bool flag = _rt == null;
				EnsureTexture();
				_cam.farClipPlane = farClip;
				_cam.cullingMask = cullingMask;
				float num = Mathf.Clamp(referenceFov / Mathf.Max(zoom, 1f), 1f, 120f);
				if (!Mathf.Approximately(num, _appliedFov))
				{
					_cam.fieldOfView = num;
					_appliedFov = num;
				}
				if (flag || Time.frameCount % Mathf.Max(1, renderEveryNthFrame) == 0)
				{
					_cam.Render();
				}
			}
			PushLensState();
		}

		private bool EyeBehindScope()
		{
			if (cameraAnchor == null)
			{
				return false;
			}
			if (_weapon != null && !_weapon.IsHeld)
			{
				return false;
			}
			Player player = (Player.HasInstance ? Player.Instance : null);
			Transform transform = ((player != null && player.mainCamera != null) ? player.mainCamera.transform : ((Camera.main != null) ? Camera.main.transform : null));
			if (transform == null)
			{
				return false;
			}
			float num = 1f;
			if (player != null)
			{
				num = Mathf.Max(player.CurrentScale, 0.01f);
			}
			Vector3 forward = cameraAnchor.forward;
			Vector3 vector = transform.position - cameraAnchor.position;
			float num2 = Vector3.Dot(forward, vector);
			if (num2 > -0.05f * num)
			{
				return false;
			}
			if (num2 < (0f - activateDistance) * num)
			{
				return false;
			}
			Vector3 vector2 = vector - forward * num2;
			float num3 = activateLateral * num;
			if (vector2.sqrMagnitude > num3 * num3)
			{
				return false;
			}
			return Vector3.Angle(forward, transform.forward) <= activateAngle;
		}

		private void ResolveLens()
		{
			if (lensRenderer == null)
			{
				Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>(includeInactive: true);
				foreach (Renderer renderer in componentsInChildren)
				{
					if (FindLensSlot(renderer) >= 0)
					{
						lensRenderer = renderer;
						break;
					}
				}
				if (lensRenderer == null)
				{
					lensRenderer = GetComponentInChildren<Renderer>();
				}
			}
			if (lensRenderer == null)
			{
				Debug.LogWarning("[SniperScope] No lens renderer found — assign one with a ScopeLens material.", this);
				return;
			}
			int num = lensMaterialIndex;
			if (num < 0)
			{
				num = FindLensSlot(lensRenderer);
				if (num < 0)
				{
					Debug.LogWarning("[SniperScope] '" + lensRenderer.name + "' has no material using 'LethalApeR/Rivals/ScopeLens' — using slot 0.", this);
					num = 0;
				}
			}
			_lensSlot = Mathf.Min(num, Mathf.Max(0, lensRenderer.sharedMaterials.Length - 1));
		}

		private static int FindLensSlot(Renderer r)
		{
			Material[] sharedMaterials = r.sharedMaterials;
			for (int i = 0; i < sharedMaterials.Length; i++)
			{
				if (sharedMaterials[i] != null && sharedMaterials[i].shader != null && sharedMaterials[i].shader.name == "LethalApeR/Rivals/ScopeLens")
				{
					return i;
				}
			}
			return -1;
		}

		private void PushLensState()
		{
			if (!(lensRenderer == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				lensRenderer.GetPropertyBlock(_mpb, _lensSlot);
				_mpb.SetFloat(ActiveId, _active);
				if (_rt != null)
				{
					_mpb.SetTexture(MainTexId, _rt);
				}
				lensRenderer.SetPropertyBlock(_mpb, _lensSlot);
			}
		}

		private void EnsureTexture()
		{
			if (!(_rt != null))
			{
				int num = Mathf.Clamp(textureSize, 64, 1024);
				RenderTexture renderTexture = new RenderTexture(num, num, 16, RenderTextureFormat.Default);
				renderTexture.name = "SniperScopeRT";
				renderTexture.useMipMap = false;
				renderTexture.filterMode = FilterMode.Bilinear;
				_rt = renderTexture;
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
	}
}
