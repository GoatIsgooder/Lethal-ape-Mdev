using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(Rigidbody))]
	public class BtmThrowable : BtmOrbItem
	{
		[Tooltip("Release speed (m/s) that counts as a throw. Slower = drop back into the orb.")]
		[SerializeField]
		[Min(0.1f)]
		private float throwSpeed = 1.2f;

		[Tooltip("Seconds of flight before a missed throw returns to the orb.")]
		[SerializeField]
		[Min(0.5f)]
		private float maxFlight = 4f;

		[Tooltip("Burst this far off the surface so FX don't clip into it.")]
		[SerializeField]
		private float surfaceLift = 0.04f;

		private const int IgnoreLayers = 9792;

		private Rigidbody _rb;

		private bool _armed;

		private float _armedAt;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
		}

		public override void OnTakenOut()
		{
			_armed = false;
		}

		public override void OnHolstered()
		{
			_armed = false;
		}

		public override bool OnReleased(Vector3 velocity)
		{
			if (velocity.magnitude < throwSpeed)
			{
				return true;
			}
			BtmItemRuntime instance = BtmItemRuntime.Instance;
			if (instance == null || !instance.CanUse(base.Item))
			{
				return true;
			}
			_armed = true;
			_armedAt = Time.time;
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager.Instance.BroadcastThrow(base.Item, _rb.position, velocity);
			}
			return false;
		}

		private void Update()
		{
			if (_armed && (Time.time - _armedAt > maxFlight || base.transform.position.y < -200f))
			{
				_armed = false;
				ReturnToOrb();
			}
		}

		private void OnCollisionEnter(Collision collision)
		{
			if (_armed && ((1 << collision.gameObject.layer) & IgnoreLayers) == 0)
			{
				ContactPoint contact = collision.GetContact(0);
				Burst(contact.point + contact.normal * surfaceLift);
			}
		}

		private void Burst(Vector3 point)
		{
			_armed = false;
			BtmItemRuntime instance = BtmItemRuntime.Instance;
			if (instance != null && instance.UseLocal(base.Item, point))
			{
				Consume();
				Object.Destroy(base.gameObject);
			}
			else
			{
				ReturnToOrb();
			}
		}
	}
}
