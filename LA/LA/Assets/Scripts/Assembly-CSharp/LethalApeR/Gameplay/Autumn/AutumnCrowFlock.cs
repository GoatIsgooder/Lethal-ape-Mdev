using System.Reflection;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Autumn
{
	[Obfuscation(Exclude = true)]
	[ExecuteAlways]
	[DisallowMultipleComponent]
	[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
	public class AutumnCrowFlock : MonoBehaviour
	{
		[Header("Flock")]
		[Tooltip("Number of crows. Each is 12 verts / 6 tris, so 30 birds is ~180 triangles in a single draw call. Changing this rebuilds the mesh.")]
		[SerializeField]
		[Range(1f, 128f)]
		private int crowCount = 26;

		[Header("Networking")]
		[Tooltip("Drive the flock from Photon's shared clock so every player sees each crow in the same place. Costs one global shader float per frame. Off = local time, which still animates fine but desyncs between clients.")]
		[SerializeField]
		private bool syncAcrossClients = true;

		[Header("Bounds")]
		[Tooltip("Extra metres added around the computed orbit bounds. Too small and the flock pops out at the edge of your view; it costs nothing to be generous.")]
		[SerializeField]
		private float boundsPadding = 8f;

		[Header("Gizmo")]
		[SerializeField]
		private bool drawOrbitGizmo = true;

		private static readonly int TimeOffsetId = Shader.PropertyToID("_SlopCrowTimeOffset");

		private static int _clockFrame = -1;

		private Mesh _mesh;

		private MeshFilter _filter;

		private MeshRenderer _renderer;

		private int _builtForCount = -1;

		private void OnEnable()
		{
			_filter = GetComponent<MeshFilter>();
			_renderer = GetComponent<MeshRenderer>();
			Rebuild();
		}

		private void OnDisable()
		{
			ReleaseMesh();
		}

		private void Update()
		{
			PushSharedClock();
			TickSeasonGate();
		}

		private void PushSharedClock()
		{
			if (syncAcrossClients && _clockFrame != Time.frameCount)
			{
				_clockFrame = Time.frameCount;
				double num = (PhotonNetwork.InRoom ? PhotonNetwork.Time : Time.timeSinceLevelLoadAsDouble);
				float value = (float)(num % 3600.0) - Time.timeSinceLevelLoad;
				Shader.SetGlobalFloat(TimeOffsetId, value);
			}
		}

		private void TickSeasonGate()
		{
			if (!(_renderer == null) && !_renderer.enabled)
			{
				_renderer.enabled = true;
			}
		}

		[ContextMenu("Rebuild Flock")]
		public void Rebuild()
		{
			if (_filter == null)
			{
				_filter = GetComponent<MeshFilter>();
			}
			if (_renderer == null)
			{
				_renderer = GetComponent<MeshRenderer>();
			}
			if (!(_filter == null))
			{
				int num = Mathf.Clamp(crowCount, 1, 128);
				if (_mesh == null || _builtForCount != num)
				{
					ReleaseMesh();
					_mesh = BuildFlockMesh(num);
					_builtForCount = num;
				}
				ApplyBounds();
				_filter.sharedMesh = _mesh;
			}
		}

		private static Mesh BuildFlockMesh(int count)
		{
			Vector3[] array = new Vector3[4]
			{
				new Vector3(0f, -0.165f, -0.58f),
				new Vector3(0f, -0.165f, 0.45f),
				new Vector3(0f, 0.165f, 0.45f),
				new Vector3(0f, 0.165f, -0.58f)
			};
			Vector2[] array2 = new Vector2[4]
			{
				new Vector2(0.004f, 0.68f),
				new Vector2(0.496f, 0.68f),
				new Vector2(0.496f, 0.84f),
				new Vector2(0.004f, 0.84f)
			};
			Vector3[] array3 = new Vector3[4]
			{
				new Vector3(-0.165f, 0f, -0.58f),
				new Vector3(-0.165f, 0f, 0.45f),
				new Vector3(0.165f, 0f, 0.45f),
				new Vector3(0.165f, 0f, -0.58f)
			};
			Vector2[] array4 = new Vector2[4]
			{
				new Vector2(0.504f, 0.68f),
				new Vector2(0.996f, 0.68f),
				new Vector2(0.996f, 0.84f),
				new Vector2(0.504f, 0.84f)
			};
			Vector3[] array5 = new Vector3[4]
			{
				new Vector3(-0.045f, 0f, 0.2875f),
				new Vector3(-0.045f, 0f, -0.2875f),
				new Vector3(-0.62f, 0f, -0.2875f),
				new Vector3(-0.62f, 0f, 0.2875f)
			};
			Vector2[] array6 = new Vector2[4]
			{
				new Vector2(0.004f, 0.004f),
				new Vector2(0.496f, 0.004f),
				new Vector2(0.496f, 0.496f),
				new Vector2(0.004f, 0.496f)
			};
			float[] array7 = new float[4] { 0f, 0f, 1f, 1f };
			int num = count * 16;
			Vector3[] array8 = new Vector3[num];
			Vector2[] array9 = new Vector2[num];
			Vector2[] array10 = new Vector2[num];
			int[] array11 = new int[count * 24];
			int num2 = 0;
			int num3 = 0;
			for (int i = 0; i < count; i++)
			{
				float y = i;
				int num4 = num2;
				for (int j = 0; j < 4; j++)
				{
					array8[num4 + j] = array[j];
					array9[num4 + j] = array2[j];
					array10[num4 + j] = new Vector2(0f, y);
				}
				int num5 = num4 + 4;
				for (int k = 0; k < 4; k++)
				{
					array8[num5 + k] = array3[k];
					array9[num5 + k] = array4[k];
					array10[num5 + k] = new Vector2(0f, y);
				}
				int num6 = num5 + 4;
				for (int l = 0; l < 4; l++)
				{
					array8[num6 + l] = array5[l];
					array9[num6 + l] = array6[l];
					array10[num6 + l] = new Vector2(array7[l], y);
				}
				int num7 = num6 + 4;
				for (int m = 0; m < 4; m++)
				{
					array8[num7 + m] = new Vector3(0f - array5[m].x, array5[m].y, array5[m].z);
					array9[num7 + m] = array6[m];
					array10[num7 + m] = new Vector2(array7[m], y);
				}
				num2 = num7 + 4;
				array11[num3] = num4;
				array11[num3 + 1] = num4 + 1;
				array11[num3 + 2] = num4 + 2;
				array11[num3 + 3] = num4;
				array11[num3 + 4] = num4 + 2;
				array11[num3 + 5] = num4 + 3;
				array11[num3 + 6] = num5;
				array11[num3 + 7] = num5 + 1;
				array11[num3 + 8] = num5 + 2;
				array11[num3 + 9] = num5;
				array11[num3 + 10] = num5 + 2;
				array11[num3 + 11] = num5 + 3;
				array11[num3 + 12] = num6;
				array11[num3 + 13] = num6 + 1;
				array11[num3 + 14] = num6 + 2;
				array11[num3 + 15] = num6;
				array11[num3 + 16] = num6 + 2;
				array11[num3 + 17] = num6 + 3;
				array11[num3 + 18] = num7;
				array11[num3 + 19] = num7 + 2;
				array11[num3 + 20] = num7 + 1;
				array11[num3 + 21] = num7;
				array11[num3 + 22] = num7 + 3;
				array11[num3 + 23] = num7 + 2;
				num3 += 24;
			}
			Mesh mesh = new Mesh();
			mesh.name = "AutumnCrowFlock_" + count;
			mesh.hideFlags = HideFlags.DontSave;
			mesh.SetVertices(array8);
			mesh.SetUVs(0, array9);
			mesh.SetUVs(1, array10);
			mesh.SetTriangles(array11, 0);
			mesh.bounds = new Bounds(Vector3.zero, Vector3.one * 100f);
			mesh.UploadMeshData(markNoLongerReadable: false);
			return mesh;
		}

		private void ApplyBounds()
		{
			if (_mesh == null)
			{
				return;
			}
			Material material = ((_renderer != null) ? _renderer.sharedMaterial : null);
			float num;
			float num2;
			float num3;
			if (material != null)
			{
				num = (material.HasProperty("_RadiusMax") ? material.GetFloat("_RadiusMax") : 60f);
				if (material.HasProperty("_RadiusWobble"))
				{
					num += Mathf.Abs(material.GetFloat("_RadiusWobble"));
				}
				num2 = 10f;
				if (material.HasProperty("_HeightMin"))
				{
					num2 = material.GetFloat("_HeightMin");
				}
				num3 = 30f;
				if (material.HasProperty("_HeightMax"))
				{
					num3 = material.GetFloat("_HeightMax");
				}
				if (material.HasProperty("_BobAmplitude"))
				{
					float num4 = Mathf.Abs(material.GetFloat("_BobAmplitude"));
					num2 -= num4;
					num3 += num4;
				}
			}
			else
			{
				num = 60f;
				num2 = 10f;
				num3 = 30f;
			}
			float num5 = Mathf.Max(0f, boundsPadding);
			float num6 = Mathf.Max(1f, num3 - num2);
			float num7 = (num + num5) * 2f;
			_mesh.bounds = new Bounds(new Vector3(0f, (num3 + num2) * 0.5f, 0f), new Vector3(num7, num6 + num5 * 2f, num7));
		}

		private void ReleaseMesh()
		{
			if (!(_mesh == null))
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
				_builtForCount = -1;
			}
		}
	}
}
