using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Frontend
{
	[DefaultExecutionOrder(100)]
	public sealed class MenuBlur : MonoBehaviour
	{
		private static readonly int SnapshotId = Shader.PropertyToID("_Snapshot");

		private static readonly int AmountId = Shader.PropertyToID("_Amount");

		private static readonly int CenterId = Shader.PropertyToID("_Center");

		private static readonly int SourceId = Shader.PropertyToID("_Source");

		private static readonly int ConeId = Shader.PropertyToID("_Cone");

		private static readonly int LodId = Shader.PropertyToID("_Lod");

		private static readonly int SpreadId = Shader.PropertyToID("_Spread");

		private static readonly int TintId = Shader.PropertyToID("_Tint");

		private const int ConvolveLayer = 31;

		private const float MaxBlurDegrees = 18f;

		private const float MinBlurDegrees = 0.25f;

		[SerializeField]
		private MenuRig rig;

		[SerializeField]
		private Material material;

		[SerializeField]
		private Material convolveMaterial;

		[Header("Look")]
		[Tooltip("How blurred the background gets. 0 is sharp, 1 is a heavy blur. Live while a popup is open.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float blurAmount = 0.3f;

		[Tooltip("How much darker the background gets. 0 leaves it as is, 1 is black. Live while a popup is open.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float darken = 0.35f;

		[Header("Quality")]
		[SerializeField]
		[Range(64f, 512f)]
		private int resolution = 256;

		[SerializeField]
		[Range(32f, 256f)]
		private int blurResolution = 128;

		[SerializeField]
		private float radius = 1f;

		[SerializeField]
		private float fadeSeconds = 0.25f;

		[Tooltip("Everything under these stays sharp: left out of the snapshot and drawn over the blur (the ape, the pointer).")]
		[SerializeField]
		private Transform[] keepSharp;

		private static readonly int[] FaceBatches = new int[3] { 3, 12, 48 };

		private readonly List<Renderer> _hidden = new List<Renderer>();

		private RenderTexture _cube;

		private RenderTexture _blurred;

		private Camera _capture;

		private MeshRenderer _sphere;

		private MeshRenderer _convolve;

		private MaterialPropertyBlock _block;

		private Coroutine _snapshot;

		private Vector3 _eye;

		private float _amount;

		private bool _wanted;

		private bool _reblur;

		public bool Ready { get; private set; }

		public bool Showing => _amount > 0.001f;

		public float BlurAmount
		{
			get
			{
				return blurAmount;
			}
			set
			{
				value = Mathf.Clamp01(value);
				if (!Mathf.Approximately(blurAmount, value))
				{
					blurAmount = value;
					_reblur = true;
				}
			}
		}

		public float Darken
		{
			get
			{
				return darken;
			}
			set
			{
				darken = Mathf.Clamp01(value);
			}
		}

		private float BlurDegrees => Mathf.Lerp(MinBlurDegrees, MaxBlurDegrees, blurAmount);

		private void OnValidate()
		{
			_reblur = true;
		}

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			Mesh mesh = BuildSphere();
			_sphere = SphereRenderer("Blur Sphere", mesh, material, base.gameObject.layer);
			_convolve = SphereRenderer("Blur Pass", mesh, convolveMaterial, ConvolveLayer);
			GameObject go = new GameObject("Blur Capture");
			go.transform.SetParent(base.transform, false);
			_capture = go.AddComponent<Camera>();
			_capture.enabled = false;
			_capture.clearFlags = CameraClearFlags.SolidColor;
			_capture.backgroundColor = Color.black;
			_capture.nearClipPlane = 0.05f;
			_capture.farClipPlane = 60f;
			_capture.allowHDR = false;
			_capture.allowMSAA = false;
			_capture.stereoTargetEye = StereoTargetEyeMask.None;
		}

		private MeshRenderer SphereRenderer(string name, Mesh mesh, Material mat, int layer)
		{
			GameObject go = new GameObject(name);
			go.layer = layer;
			go.transform.SetParent(base.transform, false);
			go.AddComponent<MeshFilter>().sharedMesh = mesh;
			MeshRenderer meshRenderer = go.AddComponent<MeshRenderer>();
			meshRenderer.sharedMaterial = mat;
			meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
			meshRenderer.receiveShadows = false;
			meshRenderer.lightProbeUsage = LightProbeUsage.Off;
			meshRenderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			meshRenderer.enabled = false;
			return meshRenderer;
		}

		private void OnDestroy()
		{
			Free(_cube);
			Free(_blurred);
		}

		private static void Free(RenderTexture rt)
		{
			if (!(rt == null))
			{
				rt.Release();
				Destroy(rt);
			}
		}

		private static RenderTexture Cube(int size, bool mips, string name)
		{
			RenderTexture renderTexture = new RenderTexture(size, size, 16, RenderTextureFormat.ARGB32);
			renderTexture.dimension = TextureDimension.Cube;
			renderTexture.useMipMap = mips;
			renderTexture.autoGenerateMips = false;
			renderTexture.name = name;
			renderTexture.Create();
			return renderTexture;
		}

		public void Show()
		{
			if (!_wanted)
			{
				_wanted = true;
				Ready = false;
				if (_snapshot != null)
				{
					StopCoroutine(_snapshot);
				}
				_snapshot = StartCoroutine(Snapshot());
			}
		}

		public void Hide()
		{
			_wanted = false;
			if (_snapshot != null)
			{
				StopCoroutine(_snapshot);
			}
			_snapshot = null;
		}

		private IEnumerator Snapshot()
		{
			if (_cube == null)
			{
				_cube = Cube(resolution, true, "MenuBlurSnapshot");
			}
			if (_blurred == null)
			{
				_blurred = Cube(blurResolution, false, "MenuBlurBlurred");
			}
			_eye = rig.Head.transform.position;
			_capture.transform.position = _eye;
			_capture.cullingMask = ~(1 << ConvolveLayer);
			int[] faceBatches = FaceBatches;
			foreach (int faceMask in faceBatches)
			{
				HideSharp();
				_capture.RenderToCubemap(_cube, faceMask);
				RestoreSharp();
				yield return null;
			}
			_cube.GenerateMips();
			Convolve();
			_snapshot = null;
			Ready = true;
		}

		private void Convolve()
		{
			_reblur = false;
			_convolve.transform.SetPositionAndRotation(_eye, Quaternion.identity);
			_convolve.transform.localScale = Vector3.one * radius * 2f;
			_convolve.GetPropertyBlock(_block);
			_block.SetTexture(SourceId, _cube);
			_block.SetVector(CenterId, _eye);
			_block.SetFloat(ConeId, BlurDegrees);
			_block.SetFloat(LodId, SourceMip());
			_convolve.SetPropertyBlock(_block);
			_convolve.enabled = true;
			_capture.transform.position = _eye;
			_capture.cullingMask = 1 << ConvolveLayer;
			_capture.RenderToCubemap(_blurred, 63);
			_convolve.enabled = false;
			_capture.cullingMask = ~(1 << ConvolveLayer);
		}

		private void HideSharp()
		{
			_hidden.Clear();
			if (_sphere.enabled)
			{
				_hidden.Add(_sphere);
			}
			if (keepSharp != null)
			{
				Transform[] array = keepSharp;
				foreach (Transform root in array)
				{
					if (!(root != null))
					{
						continue;
					}
					Renderer[] componentsInChildren = root.GetComponentsInChildren<Renderer>();
					foreach (Renderer renderer in componentsInChildren)
					{
						if (renderer.enabled)
						{
							_hidden.Add(renderer);
						}
					}
				}
			}
			foreach (Renderer item in _hidden)
			{
				item.enabled = false;
			}
		}

		private void RestoreSharp()
		{
			foreach (Renderer item in _hidden)
			{
				if (item != null)
				{
					item.enabled = true;
				}
			}
			_hidden.Clear();
		}

		private void LateUpdate()
		{
			float target = ((_wanted && Ready) ? 1f : 0f);
			_amount = Mathf.MoveTowards(_amount, target, Time.unscaledDeltaTime / Mathf.Max(0.01f, fadeSeconds));
			if (_sphere.enabled != Showing)
			{
				_sphere.enabled = Showing;
			}
			if (Showing)
			{
				if (_reblur && Ready && _snapshot == null)
				{
					Convolve();
				}
				Vector3 position = rig.Head.transform.position;
				_sphere.transform.SetPositionAndRotation(position, Quaternion.identity);
				_sphere.transform.localScale = Vector3.one * radius * 2f;
				_sphere.GetPropertyBlock(_block);
				_block.SetTexture(SnapshotId, _blurred);
				_block.SetFloat(LodId, 0f);
				_block.SetFloat(SpreadId, 0.01f);
				float tint = 1f - darken;
				_block.SetColor(TintId, new Color(tint, tint, tint, 1f));
				_block.SetFloat(AmountId, Mathf.SmoothStep(0f, 1f, _amount));
				_block.SetVector(CenterId, position);
				_sphere.SetPropertyBlock(_block);
			}
		}

		private float SourceMip()
		{
			return Mathf.Max(0f, (float)Math.Log((float)resolution / 90f * (BlurDegrees * 0.22155674f), 2.0));
		}

		private static Mesh BuildSphere()
		{
			Vector3[] vertices = new Vector3[561];
			for (int i = 0; i <= 16; i++)
			{
				float lat = (float)i * Mathf.PI / 16f;
				float sinLat = Mathf.Sin(lat);
				float cosLat = Mathf.Cos(lat);
				for (int j = 0; j <= 32; j++)
				{
					float lon = (float)j * (Mathf.PI * 2f) / 32f;
					vertices[i * 33 + j] = new Vector3(sinLat * Mathf.Cos(lon), cosLat, sinLat * Mathf.Sin(lon)) * 0.5f;
				}
			}
			int[] triangles = new int[3072];
			int n = 0;
			for (int k = 0; k < 16; k++)
			{
				for (int l = 0; l < 32; l++)
				{
					int a = k * 33 + l;
					int b = a + 33;
					triangles[n++] = a;
					triangles[n++] = b;
					triangles[n++] = a + 1;
					triangles[n++] = a + 1;
					triangles[n++] = b;
					triangles[n++] = b + 1;
				}
			}
			Mesh mesh = new Mesh();
			mesh.name = "MenuBlurSphere";
			mesh.hideFlags = HideFlags.DontSave;
			mesh.vertices = vertices;
			mesh.triangles = triangles;
			mesh.bounds = new Bounds(Vector3.zero, Vector3.one * 2f);
			return mesh;
		}
	}
}
