using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Banshee
{
	public sealed class BansheeVignette : MonoBehaviour
	{
		public Material material;

		[Tooltip("Distance in front of the eyes (m).")]
		public float distance = 0.3f;

		[Tooltip("Clear-view radius at that distance (m).")]
		public float innerRadius = 0.22f;

		public float outerRadius = 0.9f;

		private static readonly int AmountId = Shader.PropertyToID("_Amount");

		private GameObject _ring;

		private MeshRenderer _renderer;

		private MaterialPropertyBlock _block;

		private Camera _eyesCamera;

		private float _amount;

		public float Amount
		{
			get
			{
				return _amount;
			}
			set
			{
				_amount = Mathf.Clamp01(value);
				Apply();
			}
		}

		private void OnEnable()
		{
			Camera.onPreCull += OnPreCullAny;
		}

		private void OnDisable()
		{
			Camera.onPreCull -= OnPreCullAny;
		}

		private void OnPreCullAny(Camera cam)
		{
			if (!(_renderer == null) && _ring.activeSelf)
			{
				_renderer.enabled = cam == _eyesCamera;
			}
		}

		private void Apply()
		{
			bool flag = _amount > 0.001f && material != null;
			if (flag)
			{
				Ensure();
			}
			if (_ring == null)
			{
				return;
			}
			if (_ring.activeSelf != flag)
			{
				_ring.SetActive(flag);
			}
			if (flag)
			{
				if (_block == null)
				{
					_block = new MaterialPropertyBlock();
				}
				_renderer.GetPropertyBlock(_block);
				_block.SetFloat(AmountId, _amount);
				_renderer.SetPropertyBlock(_block);
			}
		}

		private void Ensure()
		{
			Transform transform = BansheePlayers.LocalEyes();
			if (transform == null || (_ring != null && _ring.transform.parent == transform))
			{
				return;
			}
			if (_ring == null)
			{
				_ring = new GameObject("Banshee Vignette");
				_ring.AddComponent<MeshFilter>().sharedMesh = BuildRing(innerRadius, outerRadius, 48);
				_renderer = _ring.AddComponent<MeshRenderer>();
				_renderer.sharedMaterial = material;
				_renderer.shadowCastingMode = ShadowCastingMode.Off;
				_renderer.receiveShadows = false;
				_renderer.lightProbeUsage = LightProbeUsage.Off;
				_renderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			}
			_ring.transform.SetParent(transform, false);
			_ring.transform.localPosition = Vector3.forward * distance;
			_ring.transform.localRotation = Quaternion.identity;
			_ring.layer = transform.gameObject.layer;
			_eyesCamera = transform.GetComponent<Camera>();
		}

		private static Mesh BuildRing(float inner, float outer, int segments)
		{
			Vector3[] array = new Vector3[segments * 2];
			Color[] array2 = new Color[segments * 2];
			int[] array3 = new int[segments * 6];
			for (int i = 0; i < segments; i++)
			{
				float f = (float)i / (float)segments * Mathf.PI * 2f;
				Vector3 vector = new Vector3(Mathf.Cos(f), Mathf.Sin(f), 0f);
				int num = i * 2;
				int num2 = num + 1;
				array[num] = vector * inner;
				array[num2] = vector * outer;
				array2[num] = new Color(0f, 0f, 0f, 0f);
				array2[num2] = new Color(0f, 0f, 0f, 1f);
				int num3 = ((i == segments - 1) ? 0 : (num + 2));
				int num4 = i * 6;
				array3[num4] = num;
				array3[num4 + 1] = num3;
				array3[num4 + 2] = num2;
				array3[num4 + 3] = num3;
				array3[num4 + 4] = num3 + 1;
				array3[num4 + 5] = num2;
			}
			Mesh mesh = new Mesh();
			mesh.name = "Banshee Vignette Ring";
			mesh.vertices = array;
			mesh.colors = array2;
			mesh.triangles = array3;
			mesh.bounds = new Bounds(Vector3.zero, Vector3.one * 100f);
			return mesh;
		}

		private void OnDestroy()
		{
			if (_ring != null)
			{
				Object.Destroy(_ring);
			}
		}
	}
}
