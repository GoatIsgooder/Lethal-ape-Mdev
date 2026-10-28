using UnityEngine;

namespace Locomotion.Scripts
{
	[RequireComponent(typeof(Rigidbody))]
	public class MechHandleAnchor : MonoBehaviour
	{
		[Tooltip("Set by MechController each frame. While true the grab system owns the handle and we leave it alone.")]
		[HideInInspector]
		public bool Held;

		[Tooltip("How fast the free handle glides back to neutral (higher = snappier).")]
		public float returnSpeed = 12f;

		private Rigidbody _body;

		private Transform _parent;

		private Vector3 _neutralLocalPos;

		private Quaternion _neutralLocalRot;

		private void Awake()
		{
			_body = GetComponent<Rigidbody>();
			CacheNeutral();
		}

		private void CacheNeutral()
		{
			_parent = transform.parent;
			_neutralLocalPos = transform.localPosition;
			_neutralLocalRot = transform.localRotation;
		}

		private void FixedUpdate()
		{
			if (Held || _body == null)
			{
				return;
			}
			if (transform.parent != _parent)
			{
				return;
			}
			float t = 1f - Mathf.Exp(-returnSpeed * Time.fixedDeltaTime);
			Vector3 targetPos = (_parent != null) ? _parent.TransformPoint(_neutralLocalPos) : _neutralLocalPos;
			Quaternion targetRot = (_parent != null) ? (_parent.rotation * _neutralLocalRot) : _neutralLocalRot;
			Vector3 pos = Vector3.Lerp(_body.position, targetPos, t);
			Quaternion rot = Quaternion.Slerp(_body.rotation, targetRot, t);
			if (_body.isKinematic)
			{
				_body.MovePosition(pos);
				_body.MoveRotation(rot);
			}
			else
			{
				_body.position = pos;
				_body.rotation = rot;
			}
		}
	}
}
