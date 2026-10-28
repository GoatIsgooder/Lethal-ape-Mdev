using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Backrooms.Ragdoll
{
	public class RagdollBloodPool : MonoBehaviour
	{
		[Tooltip("Max world diameter of the pool at full bleed-out.")]
		public float maxSize = 1.6f;

		[Tooltip("How far below the torso to look for the floor.")]
		public float floorProbe = 3f;

		[Tooltip("Layers the floor raycast hits (set to your world/Default mask).")]
		public LayerMask floorMask = -1;

		public Color bloodColor = new Color(0.42f, 0.02f, 0.02f, 1f);

		private const string ShaderName = "Slop/Backrooms/BloodPool";

		private static readonly int GrowId = Shader.PropertyToID("_Grow");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int SeedId = Shader.PropertyToID("_Seed");

		private static readonly int AlphaId = Shader.PropertyToID("_Alpha");

		private Transform _follow;

		private MeshRenderer _quad;

		private MaterialPropertyBlock _mpb;

		private float _grow;

		private float _seed;

		private bool _placedFloor;

		private Vector3 _floorNormal = Vector3.up;

		private static bool _warned;

		public void Bind(PlayerRagdoll r)
		{
			_follow = (r != null) ? ((r.lowerTorso != null) ? r.lowerTorso : r.transform) : transform.parent;
			_seed = (r != null) ? ((float)(Math.Abs(r.GetInstanceID()) % 997)) : 0f;
			floorMask = ~LayerMask.GetMask("Ragdoll", "Player", "ChaseMe", "Hand", "Finger", "RivalsHitbox");
			EnsureQuad();
		}

		public void SetGrow(float t)
		{
			_grow = Mathf.Clamp01(t);
		}

		private void EnsureQuad()
		{
			if (_quad != null)
			{
				return;
			}
			Shader shader = Shader.Find("Slop/Backrooms/BloodPool");
			if (shader == null)
			{
				if (!_warned)
				{
					_warned = true;
					Debug.LogWarning("[RagdollBloodPool] Shader 'Slop/Backrooms/BloodPool' not found (stripped?). Add it to Always-Included Shaders. Pool disabled.");
				}
				return;
			}
			GameObject go = GameObject.CreatePrimitive(PrimitiveType.Quad);
			go.name = "BloodPool";
			Collider col = go.GetComponent<Collider>();
			if (col != null)
			{
				UnityEngine.Object.Destroy(col);
			}
			go.transform.SetParent(transform, false);
			go.transform.localRotation = Quaternion.Euler(90f, 0f, 0f);
			go.transform.localScale = new Vector3(maxSize, maxSize, 1f);
			_quad = go.GetComponent<MeshRenderer>();
			_quad.material = new Material(shader);
			_quad.shadowCastingMode = ShadowCastingMode.Off;
			_quad.receiveShadows = false;
			_quad.lightProbeUsage = LightProbeUsage.Off;
			_quad.reflectionProbeUsage = ReflectionProbeUsage.Off;
			_mpb = new MaterialPropertyBlock();
			_quad.GetPropertyBlock(_mpb);
			_mpb.SetColor(ColorId, bloodColor);
			_mpb.SetFloat(SeedId, _seed);
			_quad.SetPropertyBlock(_mpb);
		}

		private void LateUpdate()
		{
			RaycastHit hit = default(RaycastHit);
			if (_quad == null || _follow == null)
			{
				return;
			}
			Vector3 position = _follow.position;
			if (!_placedFloor || _grow < 0.15f)
			{
				if (Physics.Raycast(position + Vector3.up * 0.2f, Vector3.down, out hit, floorProbe, floorMask, QueryTriggerInteraction.Ignore))
				{
					transform.position = hit.point + Vector3.up * 0.02f;
					_placedFloor = true;
					_floorNormal = hit.normal;
				}
				else
				{
					transform.position = new Vector3(_follow.position.x, _follow.position.y, _follow.position.z);
				}
			}
			transform.rotation = Quaternion.FromToRotation(Vector3.up, _floorNormal);
			_quad.GetPropertyBlock(_mpb);
			_mpb.SetFloat(GrowId, _grow);
			_mpb.SetFloat(AlphaId, Mathf.Clamp01(_grow * 4f));
			_quad.SetPropertyBlock(_mpb);
		}
	}
}
