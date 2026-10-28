using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
	public class BtmTetherCable : MonoBehaviour
	{
		[SerializeField]
		private Transform anchor;

		[SerializeField]
		private Transform end;

		[SerializeField]
		[Min(0.1f)]
		private float length = 0.9f;

		[SerializeField]
		[Range(6f, 48f)]
		private int segments = 22;

		[SerializeField]
		[Min(0.001f)]
		private float radius = 0.008f;

		[SerializeField]
		[Range(3f, 12f)]
		private int sides = 6;

		[Header("Simulation")]
		[SerializeField]
		[Min(30f)]
		private float stepRate = 90f;

		[SerializeField]
		[Range(1f, 5f)]
		private int maxStepsPerFrame = 3;

		[SerializeField]
		[Range(1f, 30f)]
		private int iterations = 12;

		[SerializeField]
		[Range(0f, 0.2f)]
		private float damping = 0.03f;

		[SerializeField]
		private LayerMask collisionMask = 1;

		[SerializeField]
		[Min(0.001f)]
		private float collisionRadius = 0.012f;

		[Tooltip("Stiffness against bending (keeps it from kinking like string).")]
		[SerializeField]
		[Range(0f, 1f)]
		private float bendStiffness = 0.12f;

		[Header("Pulses (Slop/BtmCable)")]
		[SerializeField]
		[Range(0f, 1f)]
		private float pulse;

		private static readonly int PulseId = Shader.PropertyToID("_Pulse");

		private Vector3[] _pos;

		private Vector3[] _prev;

		private Mesh _mesh;

		private Vector3[] _verts;

		private Vector3[] _normals;

		private Vector2[] _uvs;

		private float _accum;

		private float _sleepTimer;

		private bool _asleep;

		private Vector3 _lastAnchor;

		private Vector3 _lastEnd;

		private MeshRenderer _renderer;

		private MaterialPropertyBlock _mpb;

		private bool _subscribed;

		public float Length
		{
			get
			{
				return length;
			}
			set
			{
				value = Mathf.Max(value, 0.05f);
				if (Mathf.Abs(value - length) > 0.0001f)
				{
					Wake();
				}
				length = value;
			}
		}

		public float Pulse
		{
			get
			{
				return pulse;
			}
			set
			{
				pulse = Mathf.Clamp01(value);
			}
		}

		public float Tension
		{
			get
			{
				if (!(anchor != null) || !(end != null))
				{
					return 0f;
				}
				return Vector3.Distance(anchor.position, end.position) / Mathf.Max(length, 0.01f);
			}
		}

		public Transform Anchor => anchor;

		private void Awake()
		{
			_renderer = GetComponent<MeshRenderer>();
			_mpb = new MaterialPropertyBlock();
			Allocate();
			ResetShape();
		}

		private void OnEnable()
		{
			if (!_subscribed)
			{
				Application.onBeforeRender += BuildMesh;
				_subscribed = true;
			}
			Wake();
		}

		private void OnDisable()
		{
			if (_subscribed)
			{
				Application.onBeforeRender -= BuildMesh;
				_subscribed = false;
			}
		}

		private void Allocate()
		{
			int count = segments + 1;
			int ring = sides + 1;
			_pos = new Vector3[count];
			_prev = new Vector3[count];
			int vertCount = ring * count;
			_verts = new Vector3[vertCount];
			_normals = new Vector3[vertCount];
			_uvs = new Vector2[vertCount];
			int[] tris = new int[segments * sides * 6];
			int t = 0;
			for (int s = 0; s < segments; s++)
			{
				for (int j = 0; j < sides; j++)
				{
					int a = s * ring + j;
					int b = a + ring;
					tris[t++] = a;
					tris[t++] = b;
					tris[t++] = a + 1;
					tris[t++] = a + 1;
					tris[t++] = b;
					tris[t++] = b + 1;
				}
			}
			_mesh = new Mesh
			{
				name = "TetherCable"
			};
			_mesh.MarkDynamic();
			_mesh.vertices = _verts;
			_mesh.normals = _normals;
			_mesh.uv = _uvs;
			_mesh.triangles = tris;
			GetComponent<MeshFilter>().sharedMesh = _mesh;
			base.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
			base.transform.localScale = Vector3.one;
		}

		public void ResetShape()
		{
			if (anchor == null || end == null || _pos == null)
			{
				return;
			}
			Vector3 a = anchor.position;
			Vector3 b = end.position;
			float dist = Vector3.Distance(a, b);
			float sag = Mathf.Sqrt(Mathf.Max(0f, length * length - dist * dist)) * 0.5f;
			for (int i = 0; i <= segments; i++)
			{
				float t = (float)i / (float)segments;
				Vector3 p = Vector3.Lerp(a, b, t) + Vector3.down * (sag * 4f * t * (1f - t));
				_pos[i] = p;
				_prev[i] = p;
			}
			Wake();
			_lastAnchor = a;
			_lastEnd = b;
		}

		public void Wake()
		{
			_asleep = false;
			_sleepTimer = 0f;
		}

		private void LateUpdate()
		{
			if (anchor == null || end == null)
			{
				return;
			}
			Vector3 position = anchor.position;
			Vector3 position2 = end.position;
			if ((position - _lastAnchor).sqrMagnitude > 1E-08f || (position2 - _lastEnd).sqrMagnitude > 1E-08f)
			{
				Wake();
			}
			if (!_asleep)
			{
				float h = 1f / stepRate;
				_accum = Mathf.Min(_accum + Time.deltaTime, h * (float)maxStepsPerFrame);
				int steps = Mathf.FloorToInt(_accum / h);
				_accum -= h * (float)steps;
				for (int i = 1; i <= steps; i++)
				{
					float t = (float)i / (float)steps;
					Step(h, Vector3.Lerp(_lastAnchor, position, t), Vector3.Lerp(_lastEnd, position2, t));
				}
				if (steps == 0)
				{
					Pin(position, position2);
				}
				float maxSq = 0f;
				for (int j = 0; j <= segments; j++)
				{
					maxSq = Mathf.Max(maxSq, (_pos[j] - _prev[j]).sqrMagnitude);
				}
				if (maxSq < 1E-09f)
				{
					_sleepTimer += Time.deltaTime;
					if (_sleepTimer > 0.6f)
					{
						_asleep = true;
					}
				}
				else
				{
					_sleepTimer = 0f;
				}
			}
			_lastAnchor = position;
			_lastEnd = position2;
			if (_renderer.isVisible || pulse > 0f)
			{
				_renderer.GetPropertyBlock(_mpb);
				_mpb.SetFloat(PulseId, pulse);
				_renderer.SetPropertyBlock(_mpb);
			}
		}

		private void Pin(Vector3 a, Vector3 b)
		{
			_prev[0] = a;
			_pos[0] = a;
			_prev[segments] = b;
			_pos[segments] = b;
		}

		private void Step(float dt, Vector3 a, Vector3 b)
		{
			Vector3 accel = Physics.gravity * (dt * dt);
			float keep = 1f - damping;
			for (int i = 1; i < segments; i++)
			{
				Vector3 p = _pos[i];
				Vector3 velocity = (p - _prev[i]) * keep;
				_prev[i] = p;
				_pos[i] = accel + (p + velocity);
			}
			_prev[0] = a;
			_pos[0] = a;
			_pos[segments] = b;
			_prev[segments] = b;
			for (int j = 0; j < iterations; j++)
			{
				float rest = length / (float)segments;
				for (int k = 0; k < segments; k++)
				{
					Vector3 delta = _pos[k + 1] - _pos[k];
					float mag = delta.magnitude;
					if (mag < 1E-06f)
					{
						continue;
					}
					float diff = (mag - rest) / mag;
					if (diff < 0f)
					{
						diff *= 0.1f;
					}
					float w0 = ((k == 0) ? 0f : 1f);
					float w1 = ((k + 1 == segments) ? 0f : 1f);
					float wSum = w0 + w1;
					if (!(wSum <= 0f))
					{
						_pos[k] += delta * (w0 * diff / wSum);
						_pos[k + 1] -= delta * (diff * w1 / wSum);
					}
				}
				if (bendStiffness > 0f)
				{
					for (int l = 1; l < segments - 1; l++)
					{
						Vector3 mid = (_pos[l - 1] + _pos[l + 1]) * 0.5f;
						_pos[l] += (mid - _pos[l]) * (bendStiffness * 0.5f);
					}
				}
			}
			if ((int)collisionMask == 0)
			{
				return;
			}
			for (int m = 1; m < segments; m++)
			{
				Vector3 from = _prev[m];
				Vector3 to = _pos[m];
				Vector3 move = to - from;
				float moveDist = move.magnitude;
				if (moveDist < 1E-05f)
				{
					if (Physics.CheckSphere(to, collisionRadius, collisionMask, QueryTriggerInteraction.Ignore))
					{
						_pos[m] = _prev[m];
					}
					continue;
				}
				Vector3 dir = move / moveDist;
				if (Physics.SphereCast(from, collisionRadius, dir, out var hitInfo, moveDist, collisionMask, QueryTriggerInteraction.Ignore))
				{
					Vector3 hitPos = from + dir * Mathf.Max(0f, hitInfo.distance - 0.001f);
					_pos[m] = hitPos + Vector3.ProjectOnPlane(to - hitPos, hitInfo.normal) * 0.6f;
					Vector3 vel = Vector3.ProjectOnPlane(_pos[m] - _prev[m], hitInfo.normal);
					_prev[m] = _pos[m] + vel * -0.5f;
				}
			}
		}

		private void BuildMesh()
		{
			if (_mesh == null || anchor == null || end == null || !base.isActiveAndEnabled || (!_renderer.isVisible && _asleep))
			{
				return;
			}
			_pos[0] = anchor.position;
			_pos[segments] = end.position;
			int ring = sides + 1;
			Vector3 tangent = (_pos[1] - _pos[0]).normalized;
			Vector3 rhs = ((Mathf.Abs(tangent.y) > 0.9f) ? Vector3.right : Vector3.up);
			Vector3 normal = Vector3.Cross(tangent, rhs).normalized;
			Vector3 min = _pos[0];
			Vector3 max = _pos[0];
			float along = 0f;
			for (int i = 0; i <= segments; i++)
			{
				if (i > 0)
				{
					along += Vector3.Distance(_pos[i], _pos[i - 1]);
				}
				Vector3 forward = ((i < segments) ? (_pos[i + 1] - _pos[i]) : (_pos[i] - _pos[i - 1]));
				Vector3 back = forward;
				if (i > 0)
				{
					back = _pos[i] - _pos[i - 1];
				}
				Vector3 sum = forward.normalized + back.normalized;
				if (sum.sqrMagnitude > 1E-08f)
				{
					tangent = sum.normalized;
				}
				normal = Vector3.ProjectOnPlane(normal, tangent);
				if (normal.sqrMagnitude < 1E-08f)
				{
					normal = Vector3.Cross(tangent, Vector3.up);
				}
				normal = normal.normalized;
				Vector3 binormal = Vector3.Cross(tangent, normal);
				for (int j = 0; j < ring; j++)
				{
					float f = (float)j * Mathf.PI * 2f / (float)sides;
					Vector3 radial = normal * Mathf.Cos(f) + binormal * Mathf.Sin(f);
					int idx = i * ring + j;
					_verts[idx] = _pos[i] + radial * radius;
					_normals[idx] = radial;
					_uvs[idx] = new Vector2(along, (float)j / (float)sides);
				}
				min = Vector3.Min(min, _pos[i]);
				max = Vector3.Max(max, _pos[i]);
			}
			_mesh.vertices = _verts;
			_mesh.normals = _normals;
			_mesh.uv = _uvs;
			_mesh.bounds = new Bounds((min + max) * 0.5f, max - min + Vector3.one * (radius * 4f));
		}

		private void OnDestroy()
		{
			if (_mesh != null)
			{
				Object.Destroy(_mesh);
			}
		}
	}
}
