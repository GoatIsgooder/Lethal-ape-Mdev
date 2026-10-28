using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmFlashlight : MonoBehaviour
	{
		private const int Sides = 12;

		private const int MaxPlanes = 4;

		private static readonly Vector3 Palm = new Vector3(-0.046f, 0.066f, -0.004f);

		private static readonly Vector3 Aim = new Vector3(0.093f, 0.973f, -0.213f).normalized;

		private const float GripAhead = 0.044f;

		private const float LensAhead = 0.188f;

		private const float LightInFrontOfWall = 0.06f;

		private const float WallSlack = 1f;

		private const float InsideMargin = 0.35f;

		private const float InsideHaze = 0.4f;

		private const float InsideNearFade = 2.5f;

		private const float GlareGuardInterval = 0.1f;

		private static readonly int LensRadiusId = Shader.PropertyToID("_LensRadius");

		private static readonly int HalfAngleId = Shader.PropertyToID("_HalfAngle");

		private static readonly int LengthId = Shader.PropertyToID("_Length");

		private static readonly int PlanesId = Shader.PropertyToID("_Planes");

		private static readonly int CullId = Shader.PropertyToID("_Cull");

		private static readonly int ZTestId = Shader.PropertyToID("_ZTest");

		private static readonly int IntensityId = Shader.PropertyToID("_Intensity");

		private static readonly int NearFadeId = Shader.PropertyToID("_NearFade");

		private static readonly Vector4 NoPlane = new Vector4(0f, 0f, 0f, -1f);

		private static Material _inside;

		private static Material _insideOf;

		[SerializeField]
		private Transform torch;

		[SerializeField]
		private MeshRenderer torchRenderer;

		[SerializeField]
		private Material torchOff;

		[SerializeField]
		private Material torchOn;

		[SerializeField]
		private Transform lens;

		[SerializeField]
		private Light spot;

		[SerializeField]
		private MeshFilter beamFilter;

		[SerializeField]
		private MeshRenderer beam;

		[Tooltip("The haze as seen from outside the beam. Its copy for inside the beam is made at runtime, so tune this one.")]
		[SerializeField]
		private Material beamFromOutside;

		[SerializeField]
		private Renderer glare;

		[SerializeField]
		private AudioSource click;

		[Tooltip("What cuts the haze and stops the light. The map and its props are Default; players and triggers are not.")]
		[SerializeField]
		private LayerMask occluders = 1;

		[Tooltip("Seconds-to-full of the crossfade when the budget moves a real light between torches.")]
		[SerializeField]
		private float budgetFade = 0.25f;

		private readonly Vector3[] _ring = new Vector3[12];

		private readonly Vector3[] _ray = new Vector3[12];

		private readonly Vector3[] _hitNormal = new Vector3[13];

		private readonly Vector3[] _hitPoint = new Vector3[13];

		private readonly float[] _hitDistance = new float[13];

		private readonly Vector4[] _planes = new Vector4[4];

		private MaterialPropertyBlock _block;

		private Mesh _mesh;

		private float _radius;

		private float _slope;

		private float _length;

		private float _intensity;

		private float _weight;

		private float _scale;

		private float _axisReach;

		private float _probeWait;

		private float _guardWait;

		private float _hazeWeight;

		private float _retreat;

		private bool _lit;

		private bool _holder;

		private bool _blocked;

		private bool _snap;

		private bool _fromInside;

		public int Stamp { get; set; }

		public float LightTarget { get; set; }

		public bool Haze { get; set; }

		public float HazeRank { get; set; }

		public bool Lit => _lit;

		public bool Holder => _holder;

		public bool Blocked => _blocked;

		public bool HasLight => _weight > 0f;

		public Vector3 LensPosition => lens.position;

		public Vector3 Focus => lens.position + lens.forward * (_axisReach * 0.5f);

		public float BeamDistance(Vector3 eye, out Vector3 nearest)
		{
			Vector3 position = lens.position;
			Vector3 forward = lens.forward;
			float num = Mathf.Clamp(Vector3.Dot(eye - position, forward), 0f, _axisReach);
			nearest = position + forward * num;
			if (Inside(lens.InverseTransformPoint(eye)))
			{
				return 0f;
			}
			return Vector3.Distance(eye, nearest);
		}

		private void Awake()
		{
			_radius = beamFromOutside.GetFloat(LensRadiusId);
			_slope = Mathf.Tan(beamFromOutside.GetFloat(HalfAngleId) * Mathf.Deg2Rad);
			_length = beamFromOutside.GetFloat(LengthId);
			for (int i = 0; i < 12; i++)
			{
				float f = (float)i * Mathf.PI * 2f / 12f;
				Vector3 vector = new Vector3(Mathf.Cos(f), Mathf.Sin(f), 0f);
				_ring[i] = vector * _radius;
				_ray[i] = (vector * _slope + Vector3.forward).normalized;
			}
			_mesh = Cone(_radius, _slope, _length);
			beamFilter.sharedMesh = _mesh;
			beam.sharedMaterial = beamFromOutside;
			_block = new MaterialPropertyBlock();
			if (_inside == null || _insideOf != beamFromOutside)
			{
				_inside = new Material(beamFromOutside);
				_inside.name = beamFromOutside.name + " (inside)";
				_inside.SetFloat(CullId, 1f);
				_inside.SetFloat(ZTestId, 8f);
				_inside.SetFloat(IntensityId, beamFromOutside.GetFloat(IntensityId) * InsideHaze);
				_inside.SetFloat(NearFadeId, Mathf.Max(beamFromOutside.GetFloat(NearFadeId), InsideNearFade));
				_insideOf = beamFromOutside;
			}
			_intensity = spot.intensity;
			Quaternion localRotation = Quaternion.LookRotation(Aim, Vector3.forward);
			torch.localRotation = localRotation;
			lens.localRotation = localRotation;
			ResetState();
		}

		private void OnDestroy()
		{
			if (_mesh != null)
			{
				UnityEngine.Object.Destroy(_mesh);
			}
		}

		public void ResetState()
		{
			_weight = 0f;
			_scale = -1f;
			_axisReach = _length;
			_probeWait = 0f;
			_guardWait = 0f;
			_hazeWeight = 0f;
			_retreat = 0f;
			_lit = false;
			_holder = false;
			_blocked = false;
			_snap = false;
			LightTarget = 0f;
			Haze = false;
			HazeRank = float.MaxValue;
			spot.enabled = false;
			spot.intensity = _intensity;
			spot.transform.localPosition = Vector3.zero;
			beam.enabled = false;
			glare.enabled = false;
			torchRenderer.sharedMaterial = torchOff;
			for (int i = 0; i < 4; i++)
			{
				_planes[i] = NoPlane;
			}
			_block.SetVectorArray(PlanesId, _planes);
			beam.SetPropertyBlock(_block);
		}

		public void Follow(Transform hand, float scale)
		{
			base.transform.SetPositionAndRotation(hand.position, hand.rotation);
			if (!(Mathf.Abs(scale - _scale) < 0.001f))
			{
				_scale = scale;
				Vector3 vector = (Palm + Aim * GripAhead) * scale;
				torch.localPosition = vector;
				torch.localScale = Vector3.one * scale;
				lens.localPosition = vector + Aim * (scale * LensAhead);
			}
		}

		public void SetState(bool lit, bool holder, bool withClick)
		{
			_holder = holder;
			if (_lit != lit)
			{
				_lit = lit;
				_snap = true;
				_guardWait = 0f;
				torchRenderer.sharedMaterial = (lit ? torchOn : torchOff);
				if (withClick && click != null)
				{
					click.Play();
				}
			}
		}

		public void Tick(float dt, Vector3 eye, float glareRange)
		{
			if (_lit && GuardDue(dt))
			{
				Guard();
			}
			float num = (_lit ? LightTarget : 0f);
			_weight = ((!_snap && budgetFade > 0f) ? Mathf.MoveTowards(_weight, num, dt / budgetFade) : num);
			bool flag = _weight > 0.001f;
			if (spot.enabled != flag)
			{
				spot.enabled = flag;
			}
			if (_weight > 0.001f)
			{
				spot.intensity = _intensity * _weight;
			}
			float sqrMagnitude = (lens.position - eye).sqrMagnitude;
			bool flag2 = _lit && !_holder && !_blocked && sqrMagnitude < glareRange * glareRange;
			if (glare.enabled != flag2)
			{
				glare.enabled = flag2;
			}
			float num2 = (Haze ? 1f : 0f);
			if (flag2)
			{
				_hazeWeight = ((!_snap && budgetFade > 0f) ? Mathf.MoveTowards(_hazeWeight, num2, dt / budgetFade) : num2);
			}
			else
			{
				_hazeWeight = 0f;
			}
			_snap = false;
			if (!(_hazeWeight > 0.001f))
			{
				if (beam.enabled)
				{
					beam.enabled = false;
				}
				return;
			}
			bool flag3 = beam.enabled;
			if (!flag3)
			{
				beam.enabled = true;
			}
			FaceFrom(eye);
			_probeWait -= dt;
			if (!flag3 || !(_probeWait > 0f))
			{
				_probeWait = ((!beam.isVisible) ? 0.1f : ((sqrMagnitude < 144f) ? 0f : (1f / 36f)));
				Probe();
			}
			_block.SetFloat(IntensityId, beam.sharedMaterial.GetFloat(IntensityId) * _hazeWeight);
			beam.SetPropertyBlock(_block);
		}

		private bool GuardDue(float dt)
		{
			if (_weight > 0f || LightTarget > 0f || Haze)
			{
				return true;
			}
			_guardWait -= dt;
			if (_guardWait > 0f)
			{
				return false;
			}
			_guardWait = 0.1f;
			return true;
		}

		private void Guard()
		{
			Vector3 vector = base.transform.TransformPoint(Palm * _scale);
			Vector3 vector2 = lens.position - vector;
			float magnitude = vector2.magnitude;
			bool flag = false;
			float num = 0f;
			if (magnitude > 0.0001f && Physics.Raycast(vector, vector2 / magnitude, out var hitInfo, magnitude, occluders, QueryTriggerInteraction.Ignore))
			{
				flag = true;
				num = magnitude - hitInfo.distance + LightInFrontOfWall;
			}
			if (_blocked != flag || Mathf.Abs(num - _retreat) > 0.005f)
			{
				_retreat = num;
				spot.transform.localPosition = new Vector3(0f, 0f, 0f - num);
			}
			_blocked = flag;
		}

		private void FaceFrom(Vector3 eye)
		{
			bool flag = Inside(lens.InverseTransformPoint(eye));
			if (_fromInside != flag)
			{
				_fromInside = flag;
				beam.sharedMaterial = (flag ? _inside : beamFromOutside);
			}
		}

		private bool Inside(Vector3 e)
		{
			if (e.z > -InsideMargin && e.z < _length + InsideMargin)
			{
				float num = _radius + Mathf.Max(e.z, 0f) * _slope + InsideMargin;
				return e.x * e.x + e.y * e.y < num * num;
			}
			return false;
		}

		private void Probe()
		{
			Quaternion rotation = lens.rotation;
			Matrix4x4 worldToLocalMatrix = lens.worldToLocalMatrix;
			int hits = 0;
			RaycastHit hitInfo;
			bool flag = Physics.Raycast(lens.position, rotation * Vector3.forward, out hitInfo, _length, occluders, QueryTriggerInteraction.Ignore);
			int num;
			if (flag)
			{
				_axisReach = hitInfo.distance;
				Keep(ref hits, hitInfo, worldToLocalMatrix);
				num = hits;
			}
			else
			{
				_axisReach = _length;
				num = 0;
			}
			for (int i = 0; i < 12; i++)
			{
				if (Physics.Raycast(lens.TransformPoint(_ring[i]), rotation * _ray[i], out hitInfo, _length, occluders, QueryTriggerInteraction.Ignore))
				{
					Keep(ref hits, hitInfo, worldToLocalMatrix);
				}
			}
			for (int j = num + 1; j < hits; j++)
			{
				int num2 = j;
				while (num2 > num && _hitDistance[num2] < _hitDistance[num2 - 1])
				{
					float num3 = _hitDistance[num2 - 1];
					_hitDistance[num2 - 1] = _hitDistance[num2];
					_hitDistance[num2] = num3;
					Vector3 vector = _hitNormal[num2 - 1];
					_hitNormal[num2 - 1] = _hitNormal[num2];
					_hitNormal[num2] = vector;
					vector = _hitPoint[num2 - 1];
					_hitPoint[num2 - 1] = _hitPoint[num2];
					_hitPoint[num2] = vector;
					num2--;
				}
			}
			int k = 0;
			for (int l = 0; l < hits && k < 4; l++)
			{
				Vector3 vector2 = _hitNormal[l];
				Vector3 vector3 = _hitPoint[l];
				if (l >= num && vector2.z < -0.6f && (!flag || _axisReach > vector3.z + WallSlack))
				{
					continue;
				}
				float num4 = Vector3.Dot(vector2, vector3);
				if (num4 > -0.02f)
				{
					continue;
				}
				bool flag2 = false;
				for (int m = 0; m < k; m++)
				{
					Vector4 vector4 = _planes[m];
					if (Mathf.Abs(vector4.w - num4) < 0.25f && vector2.x * vector4.x + vector2.y * vector4.y + vector2.z * vector4.z > 0.96f)
					{
						flag2 = true;
						break;
					}
				}
				if (!flag2)
				{
					_planes[k++] = new Vector4(vector2.x, vector2.y, vector2.z, num4);
				}
			}
			for (; k < 4; k++)
			{
				_planes[k] = NoPlane;
			}
			_block.SetVectorArray(PlanesId, _planes);
		}

		private void Keep(ref int hits, RaycastHit hit, Matrix4x4 toLens)
		{
			_hitNormal[hits] = toLens.MultiplyVector(hit.normal).normalized;
			_hitPoint[hits] = toLens.MultiplyPoint3x4(hit.point);
			_hitDistance[hits] = hit.distance;
			hits++;
		}

		private static Mesh Cone(float radius, float slope, float length)
		{
			Vector3[] array = new Vector3[26];
			float num = radius + slope * length;
			for (int i = 0; i < 12; i++)
			{
				float f = (float)i * Mathf.PI * 2f / 12f;
				Vector3 vector = new Vector3(Mathf.Cos(f), Mathf.Sin(f), 0f) * 1.0352762f;
				array[i] = vector * radius;
				array[i + 12] = vector * num + Vector3.forward * length;
			}
			array[24] = Vector3.zero;
			array[25] = Vector3.forward * length;
			int[] array2 = new int[144];
			int num2 = 0;
			for (int j = 0; j < 12; j++)
			{
				int num3 = ((j != 11) ? (j + 1) : 0);
				array2[num2++] = j;
				array2[num2++] = num3;
				array2[num2++] = num3 + 12;
				array2[num2++] = j;
				array2[num2++] = num3 + 12;
				array2[num2++] = j + 12;
				array2[num2++] = 24;
				array2[num2++] = num3;
				array2[num2++] = j;
				array2[num2++] = 25;
				array2[num2++] = j + 12;
				array2[num2++] = num3 + 12;
			}
			Mesh mesh = new Mesh();
			mesh.name = "FlashlightBeam";
			mesh.vertices = array;
			mesh.triangles = array2;
			mesh.RecalculateBounds();
			return mesh;
		}
	}
}
