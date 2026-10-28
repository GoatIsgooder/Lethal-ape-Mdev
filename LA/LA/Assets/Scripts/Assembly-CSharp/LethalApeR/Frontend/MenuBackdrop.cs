using UnityEngine;

namespace LethalApeR.Frontend
{
	[ExecuteAlways]
	[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
	public sealed class MenuBackdrop : MonoBehaviour
	{
		private static readonly int FadeId = Shader.PropertyToID("_Fade");

		private static readonly int CellId = Shader.PropertyToID("_Cell");

		[SerializeField]
		[Min(2f)]
		private float radius = 9f;

		[SerializeField]
		private float wallBottom = -0.25f;

		[SerializeField]
		private float wallTop = 7f;

		[SerializeField]
		[Range(24f, 256f)]
		private int segments = 120;

		[SerializeField]
		[Range(0f, 1f)]
		private float fade = 1f;

		private Mesh _mesh;

		private MeshRenderer _renderer;

		private MaterialPropertyBlock _block;

		public float Fade
		{
			get
			{
				return fade;
			}
			set
			{
				fade = Mathf.Clamp01(value);
				PushFade();
			}
		}

		private void OnEnable()
		{
			Rebuild();
			PushFade();
		}

		private void OnDisable()
		{
			if (_mesh != null)
			{
				if (Application.isPlaying)
				{
					Object.Destroy(_mesh);
				}
				else
				{
					Object.DestroyImmediate(_mesh);
				}
				_mesh = null;
			}
		}

		private void Rebuild()
		{
			if (_mesh == null)
			{
				_mesh = new Mesh();
				_mesh.name = "MenuBackdrop";
				_mesh.hideFlags = HideFlags.DontSave;
				GetComponent<MeshFilter>().sharedMesh = _mesh;
			}
			int wallCount = segments * 2;
			int center = wallCount + 2;
			Vector3[] vertices = new Vector3[center + segments + 2];
			Vector2[] uv = new Vector2[vertices.Length];
			Vector2[] uv2 = new Vector2[vertices.Length];
			int[] triangles = new int[segments * 9];
			Material sharedMaterial = GetComponent<MeshRenderer>().sharedMaterial;
			float cell = 0.34f;
			if (sharedMaterial != null && sharedMaterial.HasProperty(CellId))
			{
				cell = Mathf.Max(0.01f, sharedMaterial.GetFloat(CellId));
			}
			float uScale = Mathf.Max(1f, Mathf.Round(radius * (Mathf.PI * 2f) / cell)) * cell;
			for (int i = 0; i <= segments; i++)
			{
				float t = (float)i / (float)segments;
				float angle = t * Mathf.PI * 2f + Mathf.PI;
				Vector3 dir = new Vector3(Mathf.Sin(angle), 0f, Mathf.Cos(angle));
				int v = i * 2;
				vertices[v] = dir * radius + Vector3.up * wallBottom;
				vertices[v + 1] = dir * radius + Vector3.up * wallTop;
				float u = uScale * t;
				uv[v] = new Vector2(u, wallBottom);
				uv[v + 1] = new Vector2(u, wallTop);
				int f = wallCount + 3 + i;
				Vector3 p = dir * radius;
				vertices[f] = p;
				uv[f] = new Vector2(p.x, p.z);
				uv2[f] = Vector2.right;
			}
			vertices[center] = Vector3.zero;
			uv[center] = Vector2.zero;
			uv2[center] = Vector2.right;
			int n = 0;
			for (int j = 0; j < segments; j++)
			{
				int b = j * 2;
				triangles[n++] = b;
				triangles[n++] = b + 1;
				triangles[n++] = b + 2;
				triangles[n++] = b + 1;
				triangles[n++] = b + 3;
				triangles[n++] = b + 2;
			}
			for (int k = 0; k < segments; k++)
			{
				triangles[n++] = center;
				triangles[n++] = wallCount + 3 + k;
				triangles[n++] = wallCount + 4 + k;
			}
			_mesh.Clear();
			_mesh.vertices = vertices;
			_mesh.uv = uv;
			_mesh.uv2 = uv2;
			_mesh.triangles = triangles;
			_mesh.bounds = new Bounds(Vector3.up * (wallTop + wallBottom) * 0.5f, new Vector3(radius * 2f, wallTop - wallBottom, radius * 2f));
		}

		private void PushFade()
		{
			if (_renderer == null)
			{
				_renderer = GetComponent<MeshRenderer>();
			}
			if (_block == null)
			{
				_block = new MaterialPropertyBlock();
			}
			_renderer.GetPropertyBlock(_block);
			_block.SetFloat(FadeId, fade);
			_renderer.SetPropertyBlock(_block);
		}
	}
}
