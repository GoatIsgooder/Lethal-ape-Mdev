using UnityEngine;

namespace LethalApeR.Frontend
{
	[ExecuteAlways]
	[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
	public sealed class MenuArcRail : MonoBehaviour
	{
		private static readonly int RevealId = Shader.PropertyToID("_Reveal");

		[SerializeField]
		private float fromAngle = -35f;

		[SerializeField]
		private float toAngle = 35f;

		[Tooltip("Metres above (or below) eye height.")]
		[SerializeField]
		private float height = 0.4f;

		[SerializeField]
		[Min(0.001f)]
		private float thickness = 0.014f;

		[SerializeField]
		private float radiusOffset;

		[SerializeField]
		[Range(0.25f, 4f)]
		private float degreesPerSegment = 1f;

		[SerializeField]
		[Range(0f, 1f)]
		private float reveal = 1f;

		private Mesh _mesh;

		private MeshRenderer _renderer;

		private MaterialPropertyBlock _block;

		public float Reveal
		{
			get
			{
				return reveal;
			}
			set
			{
				reveal = Mathf.Clamp01(value);
				PushReveal();
			}
		}

		private void OnEnable()
		{
			Rebuild();
			PushReveal();
		}

		private void OnDisable()
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
			}
		}

		public void Rebuild()
		{
			MenuArc componentInParent = GetComponentInParent<MenuArc>(true);
			if (!componentInParent)
			{
				return;
			}
			if (_mesh == null)
			{
				_mesh = new Mesh
				{
					name = "MenuArcRail",
					hideFlags = HideFlags.DontSave
				};
				GetComponent<MeshFilter>().sharedMesh = _mesh;
			}
			float num = Mathf.Abs(toAngle - fromAngle);
			int num2 = Mathf.Max(2, Mathf.CeilToInt(num / degreesPerSegment));
			Vector3[] array = new Vector3[num2 * 2 + 2];
			float num3 = (fromAngle + toAngle) * 0.5f;
			float x = componentInParent.ArcLength(num) * 0.5f;
			float num4 = thickness * 0.5f;
			Vector3[] array2 = new Vector3[array.Length];
			Vector2[] array3 = new Vector2[array.Length];
			Vector2[] array4 = new Vector2[array.Length];
			int[] array5 = new int[num2 * 6];
			Transform transform = componentInParent.transform;
			for (int i = 0; i <= num2; i++)
			{
				float num5 = Mathf.Lerp(fromAngle, toAngle, (float)i / (float)num2);
				Vector3 vector = componentInParent.LocalPoint(num5, height, radiusOffset);
				Vector3 normalized = new Vector3(vector.x, 0f, vector.z).normalized;
				int num6 = i * 2;
				array[num6] = base.transform.InverseTransformPoint(transform.TransformPoint(new Vector3(vector.x, vector.y - num4, vector.z)));
				array[num6 + 1] = base.transform.InverseTransformPoint(transform.TransformPoint(new Vector3(vector.x, vector.y + num4, vector.z)));
				Vector3 vector2 = base.transform.InverseTransformDirection(transform.TransformDirection(-normalized));
				array2[num6 + 1] = vector2;
				array2[num6] = vector2;
				float x2 = componentInParent.ArcLength(num5 - num3);
				array3[num6] = new Vector2(x2, 0f - num4);
				array3[num6 + 1] = new Vector2(x2, num4);
				array4[num6 + 1] = new Vector2(x, num4);
				array4[num6] = new Vector2(x, num4);
			}
			for (int j = 0; j < num2; j++)
			{
				int num7 = j * 2;
				int num8 = j * 6;
				array5[num8] = num7;
				array5[num8 + 1] = num7 + 1;
				array5[num8 + 2] = num7 + 2;
				array5[num8 + 3] = num7 + 1;
				array5[num8 + 4] = num7 + 3;
				array5[num8 + 5] = num7 + 2;
			}
			_mesh.Clear();
			_mesh.vertices = array;
			_mesh.normals = array2;
			_mesh.uv = array3;
			_mesh.uv2 = array4;
			_mesh.triangles = array5;
			_mesh.RecalculateBounds();
		}

		private void PushReveal()
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
			_block.SetFloat(RevealId, reveal);
			_renderer.SetPropertyBlock(_block);
		}
	}
}
