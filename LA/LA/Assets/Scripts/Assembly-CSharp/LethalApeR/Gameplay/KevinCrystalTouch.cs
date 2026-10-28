using System;
using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Gameplay
{
	[RequireComponent(typeof(MeshRenderer), typeof(MeshFilter))]
	public class KevinCrystalTouch : MonoBehaviour
	{
		[SerializeField]
		[Tooltip("Hand within this distance of the crystal surface counts as touching (m).")]
		private float touchDistance = 0.12f;

		[SerializeField]
		[Tooltip("Hands further than this from the surface are ignored entirely (m).")]
		private float wakeDistance = 1.5f;

		[SerializeField]
		[Tooltip("While a hand stays on the crystal, a new ripple fires this often (s).")]
		private float holdRippleInterval = 0.45f;

		[SerializeField]
		[Range(0f, 1f)]
		private float touchHaptic = 0.45f;

		[SerializeField]
		[Range(0f, 1f)]
		private float holdHaptic = 0.12f;

		[SerializeField]
		private float hapticDuration = 0.06f;

		[SerializeField]
		[Tooltip("Optional one-shot on first contact (leave Spatialize off unless it needs 3D).")]
		private AudioSource touchAudio;

		private const int AngleBins = 64;

		private const int HeightBins = 32;

		private const int MaxRipples = 4;

		private static readonly int HandsId = Shader.PropertyToID("_KevinHands");

		private static readonly int RipplesId = Shader.PropertyToID("_KevinRipples");

		private static readonly int RippleLifeId = Shader.PropertyToID("_RippleLife");

		private static readonly int CrackLifeId = Shader.PropertyToID("_CrackLife");

		private static readonly int ActiveId = Shader.PropertyToID("_KevinActive");

		private static readonly int RiftAwakeId = Shader.PropertyToID("_RiftAwake");

		private static readonly int RiftCrackId = Shader.PropertyToID("_RiftCrack");

		private static readonly int RiftFlashId = Shader.PropertyToID("_RiftFlash");

		private readonly Vector4[] _hands = new Vector4[2];

		private readonly Vector4[] _ripples = new Vector4[4];

		private readonly bool[] _touching = new bool[2];

		private readonly float[] _nextRipple = new float[2];

		private MeshRenderer _renderer;

		private MaterialPropertyBlock _block;

		private float[] _radius;

		private Vector2 _axis;

		private float _yMin;

		private float _yMax;

		private float _touchLife = 2.4f;

		private int _rippleCursor;

		private bool _idle;

		public float RiftAwake { get; set; }

		public float RiftCrack { get; set; }

		public float RiftFlash { get; set; }

		public bool HasProfile => _radius != null;

		public event Action<int, Vector3> Touched;

		public float DistanceToSurface(Vector3 world)
		{
			if (_radius == null)
			{
				return float.PositiveInfinity;
			}
			Vector3 surfaceWorld;
			return SurfaceDistance(world, out surfaceWorld);
		}

		public void AddRipple(Vector3 world)
		{
			Vector3 surfaceWorld = default(Vector3);
			if (_radius != null)
			{
				SurfaceDistance(world, out surfaceWorld);
				_ripples[_rippleCursor] = new Vector4(surfaceWorld.x, surfaceWorld.y, surfaceWorld.z, Time.timeSinceLevelLoad);
				_idle = false;
				_rippleCursor = (_rippleCursor + 1) % 4;
			}
		}

		private void Awake()
		{
			_renderer = GetComponent<MeshRenderer>();
			_block = new MaterialPropertyBlock();
			Material sharedMaterial = _renderer.sharedMaterial;
			if (sharedMaterial != null)
			{
				float a = (sharedMaterial.HasProperty(RippleLifeId) ? sharedMaterial.GetFloat(RippleLifeId) : 0f);
				float b = (sharedMaterial.HasProperty(CrackLifeId) ? sharedMaterial.GetFloat(CrackLifeId) : 0f);
				_touchLife = Mathf.Max(a, b, 0.1f);
			}
			BuildProfile(GetComponent<MeshFilter>().sharedMesh);
		}

		private void OnDisable()
		{
			for (int i = 0; i < 2; i++)
			{
				_touching[i] = false;
			}
			_idle = false;
		}

		private void LateUpdate()
		{
			if (_radius == null)
			{
				return;
			}
			float timeSinceLevelLoad = Time.timeSinceLevelLoad;
			bool flag;
			if (Player.HasInstance)
			{
				Player instance = Player.Instance;
				flag = UpdateHand(0, instance.leftHandFollower, timeSinceLevelLoad) | UpdateHand(1, instance.rightHandFollower, timeSinceLevelLoad);
			}
			else
			{
				_hands[0] = (_hands[1] = Vector4.zero);
				_touching[0] = (_touching[1] = false);
				flag = false;
			}
			for (int i = 0; i < 4; i++)
			{
				float w = _ripples[i].w;
				if (w > 0f && timeSinceLevelLoad - w < _touchLife)
				{
					flag = true;
				}
			}
			bool flag2 = RiftAwake > 0f || RiftCrack > 0f || RiftFlash > 0f;
			if (flag || flag2 || !_idle)
			{
				_block.SetVectorArray(HandsId, _hands);
				_block.SetVectorArray(RipplesId, _ripples);
				_block.SetFloat(ActiveId, flag ? 1f : 0f);
				_block.SetFloat(RiftAwakeId, RiftAwake);
				_block.SetFloat(RiftCrackId, RiftCrack);
				_block.SetFloat(RiftFlashId, RiftFlash);
				_renderer.SetPropertyBlock(_block);
				_idle = !flag && !flag2;
			}
		}

		private bool UpdateHand(int index, Transform hand, float now)
		{
			Vector3 surfaceWorld = default(Vector3);
			if (hand == null)
			{
				_hands[index] = Vector4.zero;
				_touching[index] = false;
				return false;
			}
			Vector3 position = hand.position;
			float num = SurfaceDistance(position, out surfaceWorld);
			bool flag = num < wakeDistance;
			_hands[index] = (flag ? new Vector4(position.x, position.y, position.z, 1f) : Vector4.zero);
			if (num < touchDistance)
			{
				bool flag2 = _touching[index];
				if (!flag2 || !(_nextRipple[index] > now))
				{
					_ripples[_rippleCursor] = new Vector4(surfaceWorld.x, surfaceWorld.y, surfaceWorld.z, now);
					_rippleCursor = (_rippleCursor + 1) % 4;
					_nextRipple[index] = now + holdRippleInterval;
					Pulse(index, flag2 ? holdHaptic : touchHaptic);
					if (!flag2)
					{
						if (touchAudio != null)
						{
							touchAudio.transform.position = surfaceWorld;
							touchAudio.Play();
						}
						this.Touched?.Invoke(index, surfaceWorld);
					}
				}
			}
			_touching[index] = num < touchDistance;
			return flag;
		}

		private void Pulse(int index, float amplitude)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null) && !(amplitude <= 0f))
			{
				if (index == 0)
				{
					instance.PulseLeft(amplitude, hapticDuration);
				}
				else
				{
					instance.PulseRight(amplitude, hapticDuration);
				}
			}
		}

		private float SurfaceDistance(Vector3 world, out Vector3 surfaceWorld)
		{
			Vector3 vector = transform.InverseTransformPoint(world);
			Vector2 vector2 = new Vector2(vector.x, vector.z);
			Vector2 vector3 = vector2 - _axis;
			float magnitude = vector3.magnitude;
			Vector2 vector4 = ((magnitude > 0.0001f) ? (vector3 / magnitude) : Vector2.right);
			float num = SampleRadius(Mathf.Atan2(vector3.y, vector3.x), vector.y);
			float num2 = magnitude - num;
			float num3 = vector.y - _yMax;
			float num4 = _yMin - vector.y;
			float y = vector.y;
			float num5;
			if (num3 <= 0f && num4 <= 0f)
			{
				vector2 = _axis + vector4 * num;
				num5 = num2;
			}
			else
			{
				float num6 = ((num3 > 0f) ? num3 : num4);
				num5 = num6;
				if (num2 > 0f)
				{
					vector2 = _axis + vector4 * num;
					num5 = Mathf.Sqrt(num2 * num2 + num6 * num6);
				}
				y = ((num3 > 0f) ? _yMax : _yMin);
			}
			surfaceWorld = transform.TransformPoint(new Vector3(vector2.x, y, vector2.y));
			return num5 * transform.lossyScale.x;
		}

		private float SampleRadius(float angle, float y)
		{
			float num = Mathf.Repeat(angle / ((float)Math.PI * 2f), 1f) * 64f;
			float num2 = Mathf.Clamp01((y - _yMin) / Mathf.Max(_yMax - _yMin, 0.0001f)) * 31f;
			int num3 = (int)num;
			int num4 = Mathf.Min((int)num2, 30);
			int num5 = num3 % 64;
			int num6 = (num5 + 1) % 64;
			float t = num - (float)num3;
			float t2 = num2 - (float)num4;
			float a = Mathf.Lerp(_radius[num4 * 64 + num5], _radius[num4 * 64 + num6], t);
			float b = Mathf.Lerp(_radius[(num4 + 1) * 64 + num5], _radius[(num4 + 1) * 64 + num6], t);
			return Mathf.Lerp(a, b, t2);
		}

		private void BuildProfile(Mesh mesh)
		{
			_radius = null;
			if (mesh == null || !mesh.isReadable)
			{
				Debug.LogWarning("[KevinCrystalTouch] " + name + ": mesh must be Read/Write enabled to build the touch profile.", this);
				return;
			}
			Vector3[] vertices = mesh.vertices;
			Color32[] colors = mesh.colors32;
			int[] triangles = mesh.triangles;
			if (colors.Length != vertices.Length)
			{
				Debug.LogWarning("[KevinCrystalTouch] " + name + ": mesh has no crystal mask (vertex colour R).", this);
				return;
			}
			Vector2 zero = Vector2.zero;
			int num = 0;
			_yMin = float.MaxValue;
			_yMax = float.MinValue;
			for (int i = 0; i < vertices.Length; i++)
			{
				if (colors[i].r >= 128)
				{
					Vector3 vector = vertices[i];
					zero += new Vector2(vector.x, vector.z);
					num++;
					_yMin = Mathf.Min(_yMin, vector.y);
					_yMax = Mathf.Max(_yMax, vector.y);
				}
			}
			if (num == 0)
			{
				return;
			}
			_axis = zero / num;
			float[] array = new float[2048];
			for (int j = 0; j < triangles.Length; j += 3)
			{
				int num2 = triangles[j];
				int num3 = triangles[j + 1];
				int num4 = triangles[j + 2];
				if (colors[num2].r < 128 || colors[num3].r < 128 || colors[num4].r < 128)
				{
					continue;
				}
				for (int k = 0; k <= 8; k++)
				{
					for (int l = 0; k + l <= 8; l++)
					{
						float num5 = (float)k / 8f;
						float num6 = (float)l / 8f;
						Vector3 vector2 = vertices[num2] + (vertices[num3] - vertices[num2]) * num5 + (vertices[num4] - vertices[num2]) * num6;
						float num7 = vector2.x - _axis.x;
						float num8 = vector2.z - _axis.y;
						int num9 = (int)(Mathf.Repeat(Mathf.Atan2(num8, num7) / ((float)Math.PI * 2f), 1f) * 64f) % 64;
						int num10 = Mathf.Clamp(Mathf.RoundToInt((vector2.y - _yMin) / (_yMax - _yMin) * 31f), 0, 31);
						int num11 = num10 * 64 + num9;
						array[num11] = Mathf.Max(array[num11], Mathf.Sqrt(num7 * num7 + num8 * num8));
					}
				}
			}
			bool flag = false;
			for (int m = 0; m < 64; m++)
			{
				if (flag)
				{
					break;
				}
				flag = true;
				for (int n = 0; n < 32; n++)
				{
					for (int num12 = 0; num12 < 64; num12++)
					{
						int num13 = n * 64 + num12;
						if (!(array[num13] > 0f))
						{
							float acc = 0f;
							int n2 = 0;
							Accumulate(array, n, num12 - 1, ref acc, ref n2);
							Accumulate(array, n, num12 + 1, ref acc, ref n2);
							Accumulate(array, n - 1, num12, ref acc, ref n2);
							Accumulate(array, n + 1, num12, ref acc, ref n2);
							if (n2 > 0)
							{
								array[num13] = acc / (float)n2;
							}
							else
							{
								flag = false;
							}
						}
					}
				}
			}
			_radius = array;
		}

		private static void Accumulate(float[] radius, int v, int u, ref float acc, ref int n)
		{
			if (v >= 0 && v < 32)
			{
				float num = radius[v * 64 + (u + 64) % 64];
				if (num > 0f)
				{
					acc += num;
					n++;
				}
			}
		}
	}
}
