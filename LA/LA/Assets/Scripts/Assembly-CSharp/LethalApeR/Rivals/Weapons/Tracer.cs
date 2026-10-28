using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	public class Tracer : MonoBehaviour
	{
		private Vector3 _from;

		private Vector3 _to;

		private float _duration;

		private float _elapsed;

		private bool _flying;

		private LineRenderer _line;

		private Rigidbody _rb;

		private const float MaxLifetime = 3f;

		public void Fly(Vector3 from, Vector3 to, float speed)
		{
			_from = from;
			_to = to;
			_elapsed = 0f;
			_flying = true;
			_duration = ((speed > 0.01f) ? Mathf.Max(Vector3.Distance(from, to) / speed, 0.02f) : 0.04f);
			_rb = GetComponent<Rigidbody>();
			if (_rb != null)
			{
				_rb.isKinematic = true;
				_rb.detectCollisions = false;
				_rb.useGravity = false;
				_rb.interpolation = RigidbodyInterpolation.None;
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(includeInactive: true);
			foreach (Collider collider in componentsInChildren)
			{
				if (collider != null)
				{
					collider.enabled = false;
				}
			}
			TrailRenderer componentInChildren = GetComponentInChildren<TrailRenderer>(includeInactive: true);
			if (componentInChildren != null)
			{
				componentInChildren.Clear();
				componentInChildren.emitting = true;
			}
			_line = GetComponent<LineRenderer>();
			if (_line != null)
			{
				_line.positionCount = 2;
				_line.SetPosition(0, from);
				_line.SetPosition(1, to);
			}
			base.transform.position = from;
			Vector3 vector = to - from;
			if (vector.sqrMagnitude > 1E-06f)
			{
				base.transform.rotation = Quaternion.LookRotation(vector.normalized);
			}
		}

		private void Update()
		{
			if (_flying)
			{
				_elapsed += Time.deltaTime;
				float num = ((_duration > 0f) ? Mathf.Clamp01(_elapsed / _duration) : 1f);
				if (_line == null)
				{
					base.transform.position = Vector3.LerpUnclamped(_from, _to, num);
				}
				if (num >= 1f || _elapsed >= 3f)
				{
					_flying = false;
					Object.Destroy(base.gameObject);
				}
			}
		}
	}
}
