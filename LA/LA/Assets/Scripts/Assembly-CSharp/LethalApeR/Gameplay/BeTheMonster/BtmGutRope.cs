using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmGutRope : MonoBehaviour
	{
		private const int Sides = 7;

		private const float Step = 1f / 60f;

		private const int Iterations = 6;

		private const float Damping = 0.985f;

		private readonly List<Vector3> _vertices = new List<Vector3>();

		private readonly List<Vector3> _normals = new List<Vector3>();

		private readonly List<Vector2> _uvs = new List<Vector2>();

		private Transform _piece;

		private Vector3 _localAnchor;

		private Vector3 _localOut;

		private Vector3[] _points;

		private Vector3[] _previous;

		private float _segment;

		private float _radius;

		private float _clock;

		private int _floors;

		private bool _resting;

		private Mesh _mesh;

		public IReadOnlyList<Vector3> Points => _points;

		public static BtmGutRope Spawn(Transform piece, Vector3 localAnchor, Vector3 localOut, float length, float radius, int links, Material material, LayerMask floors, float spillSpeed)
		{
			GameObject gameObject = new GameObject("Guts");
			gameObject.layer = piece.gameObject.layer;
			gameObject.transform.SetParent(piece, false);
			BtmGutRope btmGutRope = gameObject.AddComponent<BtmGutRope>();
			btmGutRope.Init(piece, localAnchor, localOut, length, radius, Mathf.Max(links, 2), material, floors, spillSpeed);
			return btmGutRope;
		}

		private void Init(Transform piece, Vector3 localAnchor, Vector3 localOut, float length, float radius, int links, Material material, LayerMask floors, float spillSpeed)
		{
			_piece = piece;
			_localAnchor = localAnchor;
			_localOut = localOut.normalized;
			_segment = length / (float)links;
			_radius = radius;
			_floors = floors;
			Vector3 vector = piece.TransformPoint(localAnchor);
			Vector3 vector2 = piece.TransformDirection(_localOut);
			_points = new Vector3[links + 1];
			_previous = new Vector3[links + 1];
			for (int i = 0; i <= links; i++)
			{
				_points[i] = vector + vector2 * (_segment * 0.7f * (float)i);
				_previous[i] = _points[i] - vector2 * (spillSpeed * Step * (float)i / (float)links);
			}
			_mesh = new Mesh();
			_mesh.name = "Guts";
			_mesh.MarkDynamic();
			base.gameObject.AddComponent<MeshFilter>().sharedMesh = _mesh;
			MeshRenderer meshRenderer = base.gameObject.AddComponent<MeshRenderer>();
			meshRenderer.sharedMaterial = material;
			meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
			BuildMesh();
		}

		private void LateUpdate()
		{
			_clock += Mathf.Min(Time.deltaTime, 0.1f);
			while (_clock >= Step)
			{
				_clock -= Step;
				Simulate(Step);
			}
			BuildMesh();
		}

		private void OnDestroy()
		{
			if ((bool)_mesh)
			{
				Destroy(_mesh);
			}
		}

		public void Simulate(float deltaTime)
		{
			if (!_piece)
			{
				return;
			}
			Vector3 vector = _piece.TransformPoint(_localAnchor);
			if (_resting && (vector - _points[0]).sqrMagnitude < 1E-06f)
			{
				return;
			}
			Vector3 outward = _piece.TransformDirection(_localOut);
			Integrate(_points, _previous, vector, Physics.gravity * (deltaTime * deltaTime), Damping);
			Constrain(_points, vector, outward, _segment, Iterations);
			PhysicsScene physicsScene = base.gameObject.scene.GetPhysicsScene();
			float num = 0f;
			for (int i = 1; i < _points.Length; i++)
			{
				Vector3 vector2 = _points[i];
				Vector3 vector3 = _previous[i];
				Vector3 vector4 = vector2 - vector3;
				float magnitude = vector4.magnitude;
				num = Mathf.Max(num, magnitude);
				if (!(magnitude < 1E-05f) && physicsScene.Raycast(_previous[i], vector4 / magnitude, out var hitInfo, magnitude + _radius, _floors, QueryTriggerInteraction.Ignore))
				{
					_points[i] = hitInfo.point + hitInfo.normal * _radius;
					_previous[i] += (_points[i] - _previous[i]) * 0.6f;
				}
			}
			_resting = num < 0.0001f;
		}

		public static void Integrate(Vector3[] points, Vector3[] previous, Vector3 anchor, Vector3 pull, float damping)
		{
			previous[0] = anchor;
			points[0] = anchor;
			for (int i = 1; i < points.Length; i++)
			{
				Vector3 vector = points[i];
				Vector3 vector2 = vector - previous[i];
				previous[i] = vector;
				points[i] += pull + vector2 * damping;
			}
		}

		public static void Constrain(Vector3[] points, Vector3 anchor, Vector3 outward, float segment, int iterations)
		{
			Vector3 vector = anchor + outward * segment;
			for (int i = 0; i < iterations; i++)
			{
				points[0] = anchor;
				points[1] += (vector - points[1]) * 0.5f;
				for (int j = 0; j + 1 < points.Length; j++)
				{
					Vector3 vector2 = points[j + 1] - points[j];
					float magnitude = vector2.magnitude;
					if (!(magnitude < 1E-06f))
					{
						Vector3 vector3 = vector2 * ((magnitude - segment) / magnitude);
						if (j == 0)
						{
							points[1] -= vector3;
							continue;
						}
						points[j] += vector3 * 0.5f;
						points[j + 1] -= vector3 * 0.5f;
					}
				}
			}
		}

		private void BuildMesh()
		{
			int num = _points.Length;
			Matrix4x4 worldToLocalMatrix = base.transform.worldToLocalMatrix;
			_vertices.Clear();
			_normals.Clear();
			_uvs.Clear();
			Vector3 normalized = (_points[1] - _points[0]).normalized;
			Vector3 rhs = ((Mathf.Abs(normalized.y) < 0.9f) ? Vector3.up : Vector3.right);
			Vector3 vector = Vector3.Cross(normalized, rhs).normalized;
			float num2 = 0f;
			for (int i = 0; i < num; i++)
			{
				if (i > 0)
				{
					num2 += Vector3.Distance(_points[i], _points[i - 1]);
				}
				Vector3 vector2 = _points[Mathf.Min(i + 1, num - 1)] - _points[Mathf.Max(i - 1, 0)];
				if (vector2.sqrMagnitude > 1E-10f)
				{
					normalized = vector2.normalized;
				}
				Vector3 vector3 = Vector3.ProjectOnPlane(vector, normalized);
				if (vector3.sqrMagnitude > 1E-08f)
				{
					vector = vector3.normalized;
				}
				Vector3 vector4 = Vector3.Cross(normalized, vector);
				float num3 = ((i == num - 1) ? 0.35f : 1f) * (_radius * (1f + Mathf.Sin(num2 / (_radius * 2.6f) * Mathf.PI) * 0.22f));
				for (int j = 0; j <= Sides; j++)
				{
					float f = (float)j * Mathf.PI * 2f / 7f;
					Vector3 vector5 = vector * Mathf.Cos(f) + vector4 * Mathf.Sin(f);
					_vertices.Add(worldToLocalMatrix.MultiplyPoint3x4(_points[i] + vector5 * num3));
					_normals.Add(worldToLocalMatrix.MultiplyVector(vector5));
					_uvs.Add(new Vector2((float)j / 7f, num2 / (_radius * 8f)));
				}
			}
			int vertexCount = _mesh.vertexCount;
			_mesh.SetVertices(_vertices);
			_mesh.SetNormals(_normals);
			_mesh.SetUVs(0, _uvs);
			if (vertexCount == 0)
			{
				Color32[] array = new Color32[_vertices.Count];
				for (int k = 0; k < array.Length; k++)
				{
					array[k] = new Color32(byte.MaxValue, byte.MaxValue, byte.MaxValue, byte.MaxValue);
				}
				_mesh.SetColors(array);
				List<int> list = new List<int>();
				for (int l = 1; l < num; l++)
				{
					for (int m = 0; m < Sides; m++)
					{
						int num4 = (l - 1) * (Sides + 1) + m;
						int num5 = num4 + Sides + 1;
						list.AddRange(new int[6]
						{
							num4,
							num4 + 1,
							num5,
							num4 + 1,
							num5 + 1,
							num5
						});
					}
				}
				_mesh.SetTriangles(list, 0);
			}
			_mesh.RecalculateBounds();
		}
	}
}
