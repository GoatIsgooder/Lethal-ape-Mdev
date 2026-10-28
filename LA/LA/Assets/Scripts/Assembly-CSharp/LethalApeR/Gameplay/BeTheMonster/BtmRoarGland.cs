using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Rivals;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(Rigidbody))]
	public class BtmRoarGland : BtmOrbItem
	{
		[SerializeField]
		[Range(0.3f, 1f)]
		private float fistThreshold = 0.75f;

		[SerializeField]
		[Min(0.1f)]
		private float squeezeSeconds = 0.45f;

		[SerializeField]
		[Min(0.1f)]
		private float relaxSeconds = 0.3f;

		[SerializeField]
		private Transform visual;

		[SerializeField]
		private float maxSwell = 1.35f;

		[SerializeField]
		private float shudder = 0.012f;

		[Tooltip("Unparented and played at the moment of the crush.")]
		[SerializeField]
		private ParticleSystem crushBurst;

		private Rigidbody _rb;

		private float _squeeze;

		private Vector3 _visualScale = Vector3.one;

		private Vector3 _visualPos;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			if (visual != null)
			{
				_visualScale = visual.localScale;
				_visualPos = visual.localPosition;
			}
		}

		public override bool OnReleased(Vector3 velocity)
		{
			return true;
		}

		public override void OnHolstered()
		{
			_squeeze = 0f;
			ApplyVisual();
		}

		private void Update()
		{
			BtmHand btmHand = ((base.Orbs != null) ? base.Orbs.HandHolding(_rb) : null);
			VRInputController instance = VRInputController.Instance;
			if (btmHand == null || instance == null)
			{
				if (_squeeze > 0f)
				{
					_squeeze = 0f;
					ApplyVisual();
				}
				return;
			}
			float num = (btmHand.isLeft ? instance.LeftTriggerValue : instance.RightTriggerValue);
			if (BtmItemRuntime.Instance != null && BtmItemRuntime.Instance.CanUse(base.Item) && num >= fistThreshold)
			{
				_squeeze += Time.deltaTime / squeezeSeconds;
				float amplitude = Mathf.Lerp(0.08f, 0.6f, _squeeze);
				if (btmHand.isLeft)
				{
					instance.PulseLeft(amplitude, Time.deltaTime * 1.5f);
				}
				else
				{
					instance.PulseRight(amplitude, Time.deltaTime * 1.5f);
				}
			}
			else
			{
				_squeeze = Mathf.Max(0f, _squeeze - Time.deltaTime / relaxSeconds);
			}
			if (_squeeze >= 1f)
			{
				Crush(btmHand.isLeft);
			}
			else
			{
				ApplyVisual();
			}
		}

		private void ApplyVisual()
		{
			if (!(visual == null))
			{
				float num = _squeeze * _squeeze;
				visual.localScale = _visualScale * Mathf.Lerp(1f, maxSwell, num);
				visual.localPosition = _visualPos + ((num > 0f) ? (Random.insideUnitSphere * shudder * num) : Vector3.zero);
			}
		}

		private void Crush(bool left)
		{
			_squeeze = 0f;
			Vector3 position = ((Player.HasInstance && Player.Instance.headCollider != null) ? Player.Instance.headCollider.transform : base.transform).position;
			if (BtmItemRuntime.Instance == null || !BtmItemRuntime.Instance.UseLocal(base.Item, position))
			{
				ApplyVisual();
				return;
			}
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				if (left)
				{
					instance.PulseLeft(1f, 0.18f);
				}
				else
				{
					instance.PulseRight(1f, 0.18f);
				}
			}
			if (crushBurst != null)
			{
				crushBurst.transform.SetParent(null, worldPositionStays: true);
				crushBurst.Play();
				Object.Destroy(crushBurst.gameObject, 2f);
			}
			RivalsWeaponOrbs.ForceDropIfHeld(base.gameObject);
			Consume();
			Object.Destroy(base.gameObject);
		}
	}
}
