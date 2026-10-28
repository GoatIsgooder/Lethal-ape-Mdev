using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Backrooms.Ragdoll
{
	public class RagdollBleedoutRing : MonoBehaviour
	{
		[Tooltip("Metres above the head/torso the ring floats.")]
		public float heightOffset = 0.55f;

		[Tooltip("World size of the ring quad.")]
		public float size = 0.32f;

		public Color fullColor = new Color(0.35f, 0.95f, 0.4f, 0.95f);

		public Color lowColor = new Color(1f, 0.18f, 0.15f, 0.98f);

		private const string RingShaderName = "Slop/Rivals/RadialFill";

		private static readonly int FillAmountId = Shader.PropertyToID("_FillAmount");

		private static readonly int FillColorId = Shader.PropertyToID("_FillColor");

		private static readonly int BackColorId = Shader.PropertyToID("_BackColor");

		private static readonly int IconColorId = Shader.PropertyToID("_IconColor");

		private static readonly int AlphaId = Shader.PropertyToID("_Alpha");

		private Transform _anchor;

		private MeshRenderer _quad;

		private MaterialPropertyBlock _mpb;

		private float _fill = 1f;

		private static bool _warned;

		public void Bind(PlayerRagdoll r)
		{
			_anchor = (r != null) ? ((r.head != null) ? r.head : ((r.lowerTorso != null) ? r.lowerTorso : r.transform)) : transform.parent;
			EnsureQuad();
		}

		public void SetFill(float t)
		{
			_fill = Mathf.Clamp01(t);
		}

		private void EnsureQuad()
		{
			if (_quad != null)
			{
				return;
			}
			Shader shader = Shader.Find("Slop/Rivals/RadialFill");
			if (shader == null)
			{
				if (!_warned)
				{
					_warned = true;
					Debug.LogWarning("[RagdollBleedoutRing] Shader 'Slop/Rivals/RadialFill' not found (stripped?). Ring disabled.");
				}
				return;
			}
			GameObject go = GameObject.CreatePrimitive(PrimitiveType.Quad);
			go.name = "BleedoutRing";
			Collider col = go.GetComponent<Collider>();
			if (col != null)
			{
				Object.Destroy(col);
			}
			go.transform.SetParent(transform, false);
			go.transform.localScale = new Vector3(size, size, 1f);
			_quad = go.GetComponent<MeshRenderer>();
			Material mat = new Material(shader);
			mat.renderQueue = 3997;
			_quad.material = mat;
			_quad.shadowCastingMode = ShadowCastingMode.Off;
			_quad.receiveShadows = false;
			_quad.lightProbeUsage = LightProbeUsage.Off;
			_quad.reflectionProbeUsage = ReflectionProbeUsage.Off;
			_mpb = new MaterialPropertyBlock();
			_quad.GetPropertyBlock(_mpb);
			_mpb.SetColor(BackColorId, new Color(0.05f, 0.06f, 0.08f, 0.75f));
			_mpb.SetColor(IconColorId, new Color(0f, 0f, 0f, 0f));
			_quad.SetPropertyBlock(_mpb);
		}

		private void LateUpdate()
		{
			if (_quad == null || _anchor == null)
			{
				return;
			}
			Camera cam = ResolveCamera();
			if (!(cam == null))
			{
				transform.position = _anchor.position + Vector3.up * heightOffset;
				transform.rotation = Quaternion.LookRotation(cam.transform.forward, cam.transform.up);
				_quad.GetPropertyBlock(_mpb);
				_mpb.SetFloat(FillAmountId, _fill);
				_mpb.SetColor(FillColorId, Color.Lerp(lowColor, fullColor, _fill));
				_mpb.SetFloat(AlphaId, 1f);
				_quad.SetPropertyBlock(_mpb);
			}
		}

		private static Camera ResolveCamera()
		{
			GorillaLocomotion.Player player = GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null;
			if (player != null && player.mainCamera != null)
			{
				return player.mainCamera;
			}
			return Camera.main;
		}
	}
}
