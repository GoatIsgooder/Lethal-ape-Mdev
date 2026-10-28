using System.Reflection;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmScreenFx : MonoBehaviour
	{
		[SerializeField]
		private Material edgeMaterial;

		[Tooltip("Distance in front of the eyes. Inside the near plane would clip it.")]
		[SerializeField]
		private float distance = 0.3f;

		[Tooltip("Radius (at Distance) where the edge effect begins. ~0.2 leaves the central 35 degrees untouched.")]
		[SerializeField]
		private float innerRadius = 0.2f;

		[SerializeField]
		private float outerRadius = 0.8f;

		[SerializeField]
		[Range(8f, 128f)]
		private int segments = 64;

		[SerializeField]
		[Min(0.01f)]
		private float edgeResponse = 10f;

		[Header("Stun pulse")]
		[SerializeField]
		[Range(0f, 0.8f)]
		private float flashPeak = 0.6f;

		[SerializeField]
		[Min(0.01f)]
		private float flashRise = 0.05f;

		[SerializeField]
		[Min(0.01f)]
		private float flashFall = 0.4f;

		[SerializeField]
		private Color flashColor = new Color(1f, 0.98f, 0.94f, 1f);

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int StrengthId = Shader.PropertyToID("_Strength");

		private static readonly int FlashModeId = Shader.PropertyToID("_FlashMode");

		private Transform _rig;

		private MeshRenderer _edge;

		private MeshRenderer _flash;

		private Material _edgeMat;

		private Material _flashMat;

		private Camera _boundCamera;

		private Color _targetColor;

		private float _targetStrength;

		private Color _color;

		private float _strength;

		private float _flashStart = -10f;

		private float _fade;

		public static BtmScreenFx Instance { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
			if (_rig != null)
			{
				Object.Destroy(_rig.gameObject);
			}
			if (_edgeMat != null)
			{
				Object.Destroy(_edgeMat);
			}
			if (_flashMat != null)
			{
				Object.Destroy(_flashMat);
			}
		}

		public void SetEdge(Color tint, float strength)
		{
			if (strength > 0.001f)
			{
				_targetColor = tint;
			}
			_targetStrength = Mathf.Clamp01(strength);
		}

		public void Flash()
		{
			_flashStart = Time.time;
		}

		public void SetFade(float alpha)
		{
			_fade = Mathf.Clamp01(alpha);
		}

		public void ClearAll()
		{
			_targetStrength = 0f;
			_strength = 0f;
			_fade = 0f;
			_flashStart = -10f;
			if (_edge != null)
			{
				_edge.enabled = false;
			}
			if (_flash != null)
			{
				_flash.enabled = false;
			}
		}

		private void LateUpdate()
		{
			float elapsed = Time.time - _flashStart;
			bool flashing = elapsed < flashRise + flashFall || _fade > 0f;
			if (_targetStrength > 0f || _strength > 0.001f || flashing)
			{
				if (!EnsureRig())
				{
					return;
				}
				float k = 1f - Mathf.Exp(-edgeResponse * Time.deltaTime);
				_strength = Mathf.Lerp(_strength, _targetStrength, k);
				_color = Color.Lerp(_color, _targetColor, k);
				_edge.enabled = _strength > 0.001f;
				if (_edge.enabled)
				{
					_edgeMat.SetColor(ColorId, _color);
					_edgeMat.SetFloat(StrengthId, _strength);
				}
				_flash.enabled = flashing;
				if (_fade > 0f)
				{
					_flashMat.SetColor(ColorId, Color.black);
					_flashMat.SetFloat(StrengthId, _fade);
				}
				else if (flashing)
				{
					float t = ((!(elapsed < flashRise)) ? (1f - Mathf.SmoothStep(0f, 1f, (elapsed - flashRise) / flashFall)) : (elapsed / flashRise));
					_flashMat.SetColor(ColorId, flashColor);
					_flashMat.SetFloat(StrengthId, flashPeak * Mathf.Clamp01(t));
				}
			}
			else
			{
				if (_edge != null && _edge.enabled)
				{
					_edge.enabled = false;
				}
				if (_flash != null && _flash.enabled)
				{
					_flash.enabled = false;
				}
			}
		}

		private bool EnsureRig()
		{
			Camera main = Camera.main;
			if (main == null || edgeMaterial == null)
			{
				return false;
			}
			if (_rig != null && _boundCamera == main)
			{
				return true;
			}
			if (_rig != null)
			{
				Object.Destroy(_rig.gameObject);
			}
			_boundCamera = main;
			_rig = new GameObject("BtmScreenFx").transform;
			_rig.SetParent(main.transform, false);
			_rig.localPosition = new Vector3(0f, 0f, distance);
			_rig.localRotation = Quaternion.identity;
			_edgeMat = new Material(edgeMaterial);
			_edgeMat.SetFloat(FlashModeId, 0f);
			_edge = MakeRenderer("Edge", BuildRing(innerRadius, outerRadius, segments), _edgeMat);
			_flashMat = new Material(edgeMaterial);
			_flashMat.SetFloat(FlashModeId, 1f);
			_flashMat.SetColor(ColorId, flashColor);
			_flashMat.renderQueue = edgeMaterial.renderQueue + 1;
			_flash = MakeRenderer("Flash", BuildRing(0f, outerRadius, segments), _flashMat);
			return true;
		}

		private MeshRenderer MakeRenderer(string name, Mesh mesh, Material mat)
		{
			GameObject gameObject = new GameObject(name);
			gameObject.layer = _rig.gameObject.layer;
			gameObject.transform.SetParent(_rig, false);
			gameObject.AddComponent<MeshFilter>().sharedMesh = mesh;
			MeshRenderer meshRenderer = gameObject.AddComponent<MeshRenderer>();
			meshRenderer.sharedMaterial = mat;
			meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
			meshRenderer.receiveShadows = false;
			meshRenderer.lightProbeUsage = LightProbeUsage.Off;
			meshRenderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			meshRenderer.enabled = false;
			return meshRenderer;
		}

		private static Mesh BuildRing(float inner, float outer, int segs)
		{
			Vector3[] array = new Vector3[segs * 2 + 2];
			Vector2[] array2 = new Vector2[array.Length];
			int[] array3 = new int[segs * 6];
			for (int i = 0; i <= segs; i++)
			{
				float num = (float)i / (float)segs;
				float f = num * Mathf.PI * 2f;
				Vector3 vector = new Vector3(Mathf.Cos(f), Mathf.Sin(f), 0f);
				array[i * 2] = vector * inner;
				array[i * 2 + 1] = vector * outer;
				array2[i * 2] = new Vector2(0f, num);
				array2[i * 2 + 1] = new Vector2(1f, num);
			}
			for (int j = 0; j < segs; j++)
			{
				int num2 = j * 6;
				int num3 = j * 2;
				array3[num2] = num3;
				array3[num2 + 1] = num3 + 1;
				array3[num2 + 2] = num3 + 3;
				array3[num2 + 3] = num3;
				array3[num2 + 4] = num3 + 3;
				array3[num2 + 5] = num3 + 2;
			}
			Mesh mesh = new Mesh();
			mesh.name = "BtmScreenRing";
			mesh.vertices = array;
			mesh.uv = array2;
			mesh.triangles = array3;
			mesh.bounds = new Bounds(Vector3.zero, Vector3.one * outer * 4f);
			return mesh;
		}
	}
}
