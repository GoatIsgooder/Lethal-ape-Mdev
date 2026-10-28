using UnityEngine;

namespace LALocomotion
{
	public struct LAShape
	{
		public enum Kind : byte
		{
			Sphere = 0,
			Box = 1,
			Capsule = 2
		}

		public Kind kind;

		public float radius;

		public Vector3 halfExtents;

		public Quaternion rotation;

		public Vector3 axis;

		public float halfSpine;

		public float thickness;

		public static LAShape Sphere(float radius)
		{
			LAShape result = default(LAShape);
			result.kind = Kind.Sphere;
			result.radius = radius;
			result.rotation = Quaternion.identity;
			result.thickness = radius;
			return result;
		}

		public static LAShape Of(Collider c, float fallbackRadius)
		{
			Transform transform = c.transform;
			Vector3 lossyScale = transform.lossyScale;
			Vector3 scale = new Vector3(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z));
			if (c is SphereCollider sphereCollider)
			{
				return Sphere(Mathf.Max(scale.x, Mathf.Max(scale.y, scale.z)) * sphereCollider.radius);
			}
			if (c is BoxCollider boxCollider)
			{
				Vector3 size = boxCollider.size;
				Vector3 halfExtents = new Vector3(Mathf.Abs(lossyScale.x * size.x), Mathf.Abs(lossyScale.y * size.y), Mathf.Abs(lossyScale.z * size.z)) * 0.5f;
				LAShape result = default(LAShape);
				result.kind = Kind.Box;
				result.halfExtents = halfExtents;
				result.rotation = transform.rotation;
				result.thickness = Mathf.Min(halfExtents.x, Mathf.Min(halfExtents.y, halfExtents.z));
				return result;
			}
			if (c is CapsuleCollider capsuleCollider)
			{
				int direction = capsuleCollider.direction;
				float along = (direction == 0) ? scale.x : ((direction == 1) ? scale.y : scale.z);
				float across = (direction == 0) ? Mathf.Max(scale.y, scale.z) : ((direction == 1) ? Mathf.Max(scale.x, scale.z) : Mathf.Max(scale.x, scale.y));
				float radius = across * capsuleCollider.radius;
				float height = Mathf.Max(along * capsuleCollider.height, radius * 2f);
				Vector3 localAxis = (direction == 0) ? Vector3.right : ((direction == 1) ? Vector3.up : Vector3.forward);
				Vector3 axis = transform.rotation * localAxis;
				LAShape result = default(LAShape);
				result.kind = Kind.Capsule;
				result.radius = radius;
				result.rotation = transform.rotation;
				result.axis = axis;
				result.halfSpine = height * 0.5f - radius;
				result.thickness = radius;
				return result;
			}
			return Sphere(fallbackRadius);
		}

		public static Vector3 Center(Collider c)
		{
			if (c is SphereCollider sphereCollider)
			{
				return c.transform.TransformPoint(sphereCollider.center);
			}
			if (c is BoxCollider boxCollider)
			{
				return c.transform.TransformPoint(boxCollider.center);
			}
			if (c is CapsuleCollider capsuleCollider)
			{
				return c.transform.TransformPoint(capsuleCollider.center);
			}
			if (c is MeshCollider meshCollider && meshCollider.sharedMesh != null)
			{
				return c.transform.TransformPoint(meshCollider.sharedMesh.bounds.center);
			}
			return c.transform.position;
		}

		public LAShape Shrunk(float k)
		{
			LAShape result = this;
			result.radius *= k;
			result.halfExtents *= k;
			result.halfSpine *= k;
			return result;
		}

		public int Overlap(Vector3 center, Collider[] results, int mask, QueryTriggerInteraction triggers)
		{
			switch (kind)
			{
			case Kind.Capsule:
				return Physics.OverlapCapsuleNonAlloc(center + axis * halfSpine, center - axis * halfSpine, radius, results, mask, triggers);
			case Kind.Box:
				return Physics.OverlapBoxNonAlloc(center, halfExtents, results, rotation, mask, triggers);
			default:
				return Physics.OverlapSphereNonAlloc(center, radius, results, mask, triggers);
			}
		}

		public bool Sweep(Vector3 origin, Vector3 direction, float distance, int mask, QueryTriggerInteraction triggers, out RaycastHit hit)
		{
			switch (kind)
			{
			case Kind.Capsule:
				return Physics.CapsuleCast(origin + axis * halfSpine, origin - axis * halfSpine, radius, direction, out hit, distance, mask, triggers);
			case Kind.Box:
				return Physics.BoxCast(origin, halfExtents, direction, out hit, rotation, distance, mask, triggers);
			default:
				return Physics.SphereCast(origin, radius, direction, out hit, distance, mask, triggers);
			}
		}
	}
}
