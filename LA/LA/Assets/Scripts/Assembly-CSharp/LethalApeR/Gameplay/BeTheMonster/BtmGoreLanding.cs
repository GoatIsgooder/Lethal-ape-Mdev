using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmGoreLanding : MonoBehaviour
	{
		private const float SplatSpeed = 1.4f;

		private const float StillSpeed = 0.12f;

		private const float StillSeconds = 0.35f;

		private BtmCorpse _corpse;

		private Rigidbody _body;

		private float _poolSize;

		private bool _splatted;

		private bool _pooled;

		private float _still;

		public void Init(BtmCorpse corpse, float poolSize)
		{
			_corpse = corpse;
			_body = GetComponent<Rigidbody>();
			_poolSize = Mathf.Clamp(poolSize, 0.25f, 1.6f);
		}

		public void Rearm()
		{
			_splatted = false;
			_pooled = false;
			_still = 0f;
		}

		private void OnCollisionEnter(Collision collision)
		{
			if (!_splatted && (bool)_corpse && !collision.rigidbody)
			{
				float magnitude = collision.relativeVelocity.magnitude;
				if (!(magnitude < SplatSpeed))
				{
					_splatted = true;
					ContactPoint contact = collision.GetContact(0);
					_corpse.Landed(contact.point, contact.normal, magnitude);
				}
			}
		}

		private void FixedUpdate()
		{
			if (_pooled || !_corpse || !_body || _body.isKinematic)
			{
				return;
			}
			if (_body.linearVelocity.sqrMagnitude < StillSpeed * StillSpeed)
			{
				_still += Time.fixedDeltaTime;
				if (!(_still < StillSeconds))
				{
					_pooled = true;
					_corpse.Pool(_body.worldCenterOfMass, _poolSize);
				}
			}
			else
			{
				_still = 0f;
			}
		}
	}
}
