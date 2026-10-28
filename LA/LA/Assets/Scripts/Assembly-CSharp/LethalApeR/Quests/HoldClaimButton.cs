using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Quests
{
	public class HoldClaimButton : BaseButton
	{
		[Header("Hold")]
		[Tooltip("Seconds the hand must be in contact for the claim to fire.")]
		[SerializeField]
		private float holdDuration = 2f;

		[Tooltip("How fast the fill bar decays back to 0 once contact is lost. Higher = faster decay.")]
		[SerializeField]
		private float decayRate = 1.5f;

		[Header("Visual Fill")]
		[Tooltip("Renderer whose material's _FillAmount float (or shaderProperty below) we drive 0→1 left→right.")]
		[SerializeField]
		private Renderer fillRenderer;

		[SerializeField]
		private string fillShaderProperty = "_FillAmount";

		[Header("Haptics")]
		[Tooltip("Haptic amplitude at fill = 0 (right when contact begins).")]
		[SerializeField]
		private float hapticMin = 0.05f;

		[Tooltip("Haptic amplitude at fill = 1 (right before claim fires).")]
		[SerializeField]
		private float hapticMax = 0.9f;

		[Header("Reward Effect")]
		[SerializeField]
		private Transform particleSpawnPoint;

		private QuestEntry _owner;

		private float _handLastSeenTime = -1f;

		private bool _handIsLeft;

		private float _fill;

		private bool _claimedThisSession;

		private static readonly int FillPropertyId = Shader.PropertyToID("_FillAmount");

		private MaterialPropertyBlock _mpb;

		private int _fillPropertyIdResolved;

		public void Bind(QuestEntry owner)
		{
			_owner = owner;
			_claimedThisSession = false;
			_fill = 0f;
			_handLastSeenTime = -1f;
			if (fillRenderer != null)
			{
				fillRenderer.enabled = true;
			}
			ApplyFillVisual();
		}

		private void OnTriggerStay(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				_handLastSeenTime = Time.time;
				_handIsLeft = FingertipHand.IsLeft(other);
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("HandTag"))
			{
				_handLastSeenTime = Time.time;
				_handIsLeft = FingertipHand.IsLeft(other);
			}
		}

		private void Update()
		{
			float num = Mathf.Max(Time.fixedDeltaTime * 1.5f, 0.04f);
			if (Time.time - _handLastSeenTime < num && !_claimedThisSession && _owner != null && _owner.IsClaimable)
			{
				_fill = Mathf.MoveTowards(_fill, 1f, Time.deltaTime / Mathf.Max(holdDuration, 0.01f));
				SendRampingHaptic(Mathf.Lerp(hapticMin, hapticMax, _fill), 0.05f, _handIsLeft);
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
			if (_claimedThisSession && _fill <= 0f && fillRenderer != null && fillRenderer.enabled)
			{
				fillRenderer.enabled = false;
			}
		}

		private void FireClaim()
		{
			_claimedThisSession = true;
			_fill = 1f;
			ApplyFillVisual();
			if (_owner != null)
			{
				Vector3 particleWorldPosition = ((particleSpawnPoint != null) ? particleSpawnPoint.position : base.transform.position);
				_owner.OnHoldCompleted(particleWorldPosition);
			}
			SendRampingHaptic(1f, 0.25f, _handIsLeft);
		}

		private void ApplyFillVisual()
		{
			if (!(fillRenderer == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				if (_fillPropertyIdResolved == 0)
				{
					_fillPropertyIdResolved = (string.IsNullOrEmpty(fillShaderProperty) ? FillPropertyId : Shader.PropertyToID(fillShaderProperty));
				}
				fillRenderer.GetPropertyBlock(_mpb);
				_mpb.SetFloat(_fillPropertyIdResolved, _fill);
				fillRenderer.SetPropertyBlock(_mpb);
			}
		}

		private static void SendRampingHaptic(float amplitude, float duration, bool isLeft)
		{
			InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(isLeft ? XRNode.LeftHand : XRNode.RightHand);
			if (deviceAtXRNode.isValid)
			{
				deviceAtXRNode.SendHapticImpulse(0u, Mathf.Clamp01(amplitude), duration);
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
		}
	}
}
