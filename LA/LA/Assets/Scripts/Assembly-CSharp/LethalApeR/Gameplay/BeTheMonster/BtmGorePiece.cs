using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmGorePiece : MonoBehaviour
	{
		private const float StillSpeed = 0.12f;

		private const float StillSeconds = 0.35f;

		private BtmChainsawGore _gore;

		private BtmCutRemains _remains;

		private Rigidbody _body;

		private float _poolSize;

		private bool _splatted;

		private bool _pooled;

		private float _still;

		public void Init(BtmChainsawGore gore, BtmCutRemains remains, float poolSize)
		{
			_gore = gore;
			_remains = remains;
			_body = GetComponent<Rigidbody>();
			_poolSize = Mathf.Clamp(poolSize, 0.2f, 1.2f);
		}

		public void Rearm()
		{
			_splatted = false;
			_pooled = false;
			_still = 0f;
		}

		private void OnCollisionEnter(Collision collision)
		{
			if (_splatted || !_gore || (bool)collision.rigidbody)
			{
				return;
			}
			float magnitude = collision.relativeVelocity.magnitude;
			if (!(magnitude < _gore.SplatSpeed))
			{
				_splatted = true;
				ContactPoint contact = collision.GetContact(0);
				_gore.Splat(contact.point, contact.normal, magnitude, _remains);
			}
		}

		private void FixedUpdate()
		{
			if (_pooled || !_gore || !_body || _body.isKinematic)
			{
				return;
			}
			if (_body.linearVelocity.sqrMagnitude < StillSpeed * StillSpeed)
			{
				_still += Time.fixedDeltaTime;
				if (_still >= StillSeconds)
				{
					_pooled = true;
					_gore.Pool(_body.worldCenterOfMass, _poolSize);
				}
			}
			else
			{
				_still = 0f;
			}
		}
	}
}
