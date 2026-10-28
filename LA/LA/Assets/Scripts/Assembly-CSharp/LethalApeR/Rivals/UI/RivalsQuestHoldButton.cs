using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Rivals.UI
{
	public class RivalsQuestHoldButton : MonoBehaviour
	{
		[Tooltip("Seconds of continuous hand contact required to claim.")]
		public float holdDuration = 2f;

		[Tooltip("How fast the fill decays back to 0 once contact is lost. Higher = faster.")]
		public float decayRate = 1.5f;

		[Tooltip("Haptic amplitude at fill = 0.")]
		public float hapticMin = 0.05f;

		[Tooltip("Haptic amplitude at fill = 1.")]
		public float hapticMax = 0.9f;

		[HideInInspector]
		public RivalsQuestBoardRow owner;

		private Renderer _fillRenderer;

		private bool _useFillProperty;

		private float _fillFullWidth;

		private float _fillLeftEdgeX;

		private float _handLastSeenTime = -1f;

		private bool _handIsLeft;

		private float _fill;

		private float _appliedFill = -1f;

		private bool _claimed;

		private static readonly int FillPropertyId = Shader.PropertyToID("_FillAmount");

		private MaterialPropertyBlock _mpb;

		private void Start()
		{
			if (_fillRenderer == null && owner != null)
			{
				Transform fill = owner.transform.Find("Fill");
				Renderer r = ((fill != null) ? fill.GetComponent<Renderer>() : null);
				if (r != null)
				{
					SetFillRenderer(r, RivalsQuestBoardBootstrap.MakeFillMaterialPublic());
				}
			}
		}

		public void SetFillRenderer(Renderer r, Material fillMaterial)
		{
			_fillRenderer = r;
			_useFillProperty = fillMaterial != null && r != null;
			if (r == null)
			{
				return;
			}
			if (_useFillProperty)
			{
				r.material = fillMaterial;
			}
			else
			{
				r.material.color = new Color(1f, 0.84f, 0.2f, 1f);
				_fillFullWidth = r.transform.localScale.x;
				_fillLeftEdgeX = r.transform.localPosition.x + _fillFullWidth * -0.5f;
			}
			_appliedFill = -1f;
			ApplyFillVisual();
		}

		public void ResetForBind()
		{
			_claimed = false;
			_handLastSeenTime = -1f;
			_fill = 0f;
			_appliedFill = -1f;
			if (_fillRenderer != null)
			{
				_fillRenderer.enabled = true;
			}
			ApplyFillVisual();
		}

		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				_handLastSeenTime = Time.time;
				_handIsLeft = FingertipHand.IsLeft(other);
			}
		}

		private void OnTriggerStay(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				_handLastSeenTime = Time.time;
				_handIsLeft = FingertipHand.IsLeft(other);
			}
		}

		private void Update()
		{
			float grace = Mathf.Max(Time.fixedDeltaTime * 1.5f, 0.04f);
			if (Time.time - _handLastSeenTime < grace && !_claimed && owner != null && owner.IsClaimable)
			{
				_fill = Mathf.MoveTowards(_fill, 1f, Time.deltaTime / Mathf.Max(holdDuration, 0.01f));
				SendHaptic(Mathf.Lerp(hapticMin, hapticMax, _fill), 0.05f, _handIsLeft);
				if (_fill >= 1f)
				{
					FireClaim();
				}
			}
			else if (_fill > 0f)
			{
				_fill = Mathf.MoveTowards(_fill, 0f, Time.deltaTime * decayRate);
			}
			ApplyFillVisual();
			if (_claimed && _fill <= 0f && _fillRenderer != null && _fillRenderer.enabled)
			{
				_fillRenderer.enabled = false;
			}
		}

		private void FireClaim()
		{
			if (owner == null || !owner.TryClaim())
			{
				_fill = 0f;
				return;
			}
			_claimed = true;
			_fill = 1f;
			SendHaptic(1f, 0.25f, _handIsLeft);
		}

		private void ApplyFillVisual()
		{
			if (_fillRenderer == null || Mathf.Approximately(_fill, _appliedFill))
			{
				return;
			}
			_appliedFill = _fill;
			if (_useFillProperty)
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				_fillRenderer.GetPropertyBlock(_mpb);
				_mpb.SetFloat(FillPropertyId, _fill);
				_fillRenderer.SetPropertyBlock(_mpb);
				return;
			}
			Transform t = _fillRenderer.transform;
			float width = Mathf.Max(_fillFullWidth * _fill, 0.001f);
			Vector3 scale = t.localScale;
			scale.x = width;
			t.localScale = scale;
			Vector3 pos = t.localPosition;
			pos.x = _fillLeftEdgeX + width * 0.5f;
			t.localPosition = pos;
			_fillRenderer.enabled = _fill > 0.001f;
		}

		private static void SendHaptic(float amplitude, float duration, bool isLeft)
		{
			InputDevice device = InputDevices.GetDeviceAtXRNode(isLeft ? XRNode.LeftHand : XRNode.RightHand);
			if (device.isValid)
			{
				device.SendHapticImpulse(0u, Mathf.Clamp01(amplitude), duration);
			}
		}
	}
}
