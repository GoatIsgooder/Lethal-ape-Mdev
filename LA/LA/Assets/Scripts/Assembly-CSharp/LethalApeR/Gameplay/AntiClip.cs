using UnityEngine;

namespace LethalApeR.Gameplay
{
	[RequireComponent(typeof(Rigidbody))]
	public class AntiClip : MonoBehaviour
	{
		public LayerMask surfaceLayers;

		[Min(0f)]
		public float skinWidth = 0.02f;

		private Rigidbody _rb;

		private Collider _col;

		private Vector3 _prevPosition;

		private static readonly Collider[] _overlapBuffer = new Collider[8];

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_col = GetComponentInChildren<Collider>();
		}

		private void OnEnable()
		{
			_prevPosition = base.transform.position;
		}

		private void FixedUpdate()
		{
			if (!_rb.isKinematic)
			{
				SweepCheck();
				OverlapResolve();
			}
			_prevPosition = base.transform.position;
		}

		private void SweepCheck()
		{
			Vector3 vector = base.transform.position - _prevPosition;
			float magnitude = vector.magnitude;
			if (!(magnitude < 0.001f))
			{
				float radius = Mathf.Max(ColliderRadius() - skinWidth, 0.001f);
				Vector3 vector2 = vector / magnitude;
				if (Physics.SphereCast(_prevPosition, radius, vector2, out var hitInfo, magnitude + skinWidth, surfaceLayers, QueryTriggerInteraction.Ignore))
				{
					base.transform.position = _prevPosition + vector2 * Mathf.Max(hitInfo.distance - skinWidth, 0f);
					Physics.SyncTransforms();
					CancelVelocityInto(hitInfo.normal);
				}
			}
		}

		private void OverlapResolve()
		{
			if (_col == null)
			{
				return;
			}
			Vector3 position = base.transform.position;
			float num = ColliderRadius();
			int num2 = Physics.OverlapSphereNonAlloc(position, num + skinWidth, _overlapBuffer, surfaceLayers, QueryTriggerInteraction.Ignore);
			for (int i = 0; i < num2; i++)
			{
				Collider collider = _overlapBuffer[i];
				if (!(collider == null) && !(collider == _col) && !collider.isTrigger && Physics.ComputePenetration(_col, _col.transform.position, _col.transform.rotation, collider, collider.transform.position, collider.transform.rotation, out var direction, out var distance))
				{
					base.transform.position += direction * (distance + skinWidth * 0.5f);
					Physics.SyncTransforms();
					CancelVelocityInto(direction);
				}
			}
		}

		private void CancelVelocityInto(Vector3 normal)
		{
			float num = Vector3.Dot(normal, _rb.linearVelocity);
			if (num < 0f)
			{
				_rb.linearVelocity -= normal * num;
			}
		}

		private float ColliderRadius()
		{
			if (_col == null)
			{
				return 0.05f;
			}
			Vector3 lossyScale = base.transform.lossyScale;
			Collider col = _col;
			if (!(col is SphereCollider sphereCollider))
			{
				if (!(col is CapsuleCollider capsuleCollider))
				{
					if (col is BoxCollider boxCollider)
					{
						return Mathf.Min(Mathf.Abs(lossyScale.x) * boxCollider.size.x, Mathf.Abs(lossyScale.y) * boxCollider.size.y, Mathf.Abs(lossyScale.z) * boxCollider.size.z) * 0.5f;
					}
					return 0.05f;
				}
				return capsuleCollider.radius * Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.z));
			}
			return sphereCollider.radius * Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z));
		}
	}
}
