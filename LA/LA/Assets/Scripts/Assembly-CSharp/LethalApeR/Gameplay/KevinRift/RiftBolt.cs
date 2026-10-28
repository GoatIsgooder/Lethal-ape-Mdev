using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
	public sealed class RiftBolt : MonoBehaviour
	{
		private const int MainLevels = 6;

		private const int ForkLevels = 3;

		private const int MaxForks = 4;

		private const int MainPoints = 65;

		private const int ForkPoints = 9;

		private const int MaxPoints = 101;

		private static readonly int IntensityId = Shader.PropertyToID("_Intensity");

		private static readonly int FlickerId = Shader.PropertyToID("_Flicker");

		[Tooltip("How far each midpoint can be pushed sideways, as a share of its segment's length.")]
		public float roughness = 0.22f;

		public float width = 0.35f;

		[Tooltip("Brightness over the strike's life (0..1 time): the main hit, then restrikes.")]
		public AnimationCurve intensity = new AnimationCurve(new Keyframe(0f, 0f), new Keyframe(0.03f, 1f), new Keyframe(0.18f, 0.25f), new Keyframe(0.3f, 0.95f), new Keyframe(0.45f, 0.2f), new Keyframe(0.6f, 0.7f), new Keyframe(1f, 0f));

		public float peak = 6f;

		private readonly Vector3[] _points = new Vector3[MaxPoints];

		private readonly Vector3[] _verts = new Vector3[MaxPoints * 2];

		private readonly Vector2[] _uvs = new Vector2[MaxPoints * 2];

		private readonly Color[] _colors = new Color[MaxPoints * 2];

		private readonly int[] _tris = new int[600];

		private readonly Vector3[] _forkScratch = new Vector3[ForkPoints];

		private Mesh _mesh;

		private MeshRenderer _renderer;

		private MaterialPropertyBlock _block;

		private float _age;

		private float _life;

		private float _strength = 1f;

		private int _vertCount;

		private int _triCount;

		public bool Live => _life > 0f && _age < _life;

		private void Awake()
		{
			_renderer = GetComponent<MeshRenderer>();
			_block = new MaterialPropertyBlock();
			_mesh = new Mesh
			{
				name = "Rift Bolt"
			};
			_mesh.MarkDynamic();
			GetComponent<MeshFilter>().sharedMesh = _mesh;
			_renderer.enabled = false;
		}

		public void Strike(Vector3 from, Vector3 to, float duration, float strength = 1f, int forks = 3, float widthScale = 1f)
		{
			if (_mesh == null)
			{
				Awake();
			}
			transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
			transform.localScale = Vector3.one;
			Vector3 viewer = Viewer(from, to);
			_vertCount = 0;
			_triCount = 0;
			int n = Channel(from, to, MainLevels, roughness, _points);
			AddRibbon(_points, n, width * widthScale, 1f, viewer);
			Vector3 dir = to - from;
			float len = dir.magnitude;
			int count = Mathf.Min(forks, MaxForks);
			for (int i = 0; i < count; i++)
			{
				int start = Random.Range(n / 6, n * 4 / 5);
				Vector3 p = _points[start];
				Vector3 side = Vector3.Cross(dir, Random.onUnitSphere).normalized;
				Vector3 forkDir = Vector3.Slerp(dir.normalized, side, Random.Range(0.35f, 0.7f));
				float reach = Random.Range(0.12f, 0.28f);
				int m = Channel(p, p + forkDir * len * reach, ForkLevels, roughness * 1.2f, _forkScratch);
				AddRibbon(_forkScratch, m, width * widthScale * 0.45f, 0.55f, viewer);
			}
			_mesh.Clear();
			_mesh.SetVertices(_verts, 0, _vertCount);
			_mesh.SetUVs(0, _uvs, 0, _vertCount);
			_mesh.SetColors(_colors, 0, _vertCount);
			_mesh.SetTriangles(_tris, 0, _triCount, 0);
			_age = 0f;
			_life = Mathf.Max(duration, 0.05f);
			_strength = strength;
			_renderer.enabled = true;
			Apply(intensity.Evaluate(0f));
		}

		private void Update()
		{
			if (_life <= 0f)
			{
				return;
			}
			_age += Time.deltaTime;
			if (_age >= _life)
			{
				_life = 0f;
				_renderer.enabled = false;
			}
			else
			{
				Apply(intensity.Evaluate(_age / _life));
			}
		}

		private void Apply(float k)
		{
			_renderer.GetPropertyBlock(_block);
			_block.SetFloat(IntensityId, peak * k * _strength);
			_block.SetFloat(FlickerId, 0.35f);
			_renderer.SetPropertyBlock(_block);
		}

		private static int Channel(Vector3 from, Vector3 to, int levels, float rough, Vector3[] into)
		{
			int segments = 1 << levels;
			into[0] = from;
			into[segments] = to;
			for (int step = segments; step > 1; step >>= 1)
			{
				int half = step >> 1;
				for (int i = 0; i + step <= segments; i += step)
				{
					Vector3 a = into[i];
					Vector3 b = into[i + step];
					Vector3 jitter = Random.insideUnitSphere;
					Vector3 seg = b - a;
					float len = seg.magnitude;
					Vector3 offset = Vector3.ProjectOnPlane(jitter, seg.normalized);
					into[i + half] = (a + b) * 0.5f + offset * (len * rough);
				}
			}
			return segments + 1;
		}

		private void AddRibbon(Vector3[] points, int count, float w, float brightness, Vector3 viewer)
		{
			if (count < 2 || _vertCount + count * 2 > _verts.Length)
			{
				return;
			}
			int start = _vertCount;
			int last = count - 1;
			for (int i = 0; i < count; i++)
			{
				Vector3 p = points[i];
				Vector3 tangent = ((i < last) ? (points[i + 1] - p) : (p - points[i - 1])).normalized;
				Vector3 side = Vector3.Cross(tangent, viewer - p);
				side = ((side.sqrMagnitude > 1E-06f) ? side.normalized : Vector3.right);
				float t = (float)i / (float)last;
				float hw = w * 0.5f * Mathf.Lerp(1f, 0.35f, t * t);
				_verts[_vertCount] = p - side * hw;
				_verts[_vertCount + 1] = p + side * hw;
				_uvs[_vertCount] = new Vector2(0f, t);
				_uvs[_vertCount + 1] = new Vector2(1f, t);
				Color c = new Color(1f, 1f, 1f, Mathf.Lerp(1f, 0.6f, t) * brightness);
				_colors[_vertCount] = (_colors[_vertCount + 1] = c);
				_vertCount += 2;
			}
			for (int j = 0; j < last; j++)
			{
				int v = start + j * 2;
				_tris[_triCount++] = v;
				_tris[_triCount++] = v + 2;
				_tris[_triCount++] = v + 1;
				_tris[_triCount++] = v + 1;
				_tris[_triCount++] = v + 2;
				_tris[_triCount++] = v + 3;
			}
		}

		private static Vector3 Viewer(Vector3 from, Vector3 to)
		{
			if (RiftPlayers.TryGetLocal(out var avatar))
			{
				return avatar.head;
			}
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform.position;
			}
			return (from + to) * 0.5f + Vector3.forward * 10f;
		}
	}
}
