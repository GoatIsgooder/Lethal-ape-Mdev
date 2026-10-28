using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay
{
	public static class Blast
	{
		private const int Capacity = 128;

		private static readonly Collider[] Overlaps = new Collider[128];

		private static readonly List<IBlastReceiver> Receivers = new List<IBlastReceiver>(8);

		private static readonly List<Rigidbody> Bodies = new List<Rigidbody>(16);

		private static readonly List<Vector3> BodyPoints = new List<Vector3>(16);

		private static readonly List<float> BodyDistances = new List<float>(16);

		public static int Explode(in BlastInfo blast, int overlapMask, int occluderMask)
		{
			if (blast.radius <= 0f)
			{
				return 0;
			}
			Vector3 center = blast.center;
			int count = Physics.OverlapSphereNonAlloc(center, blast.radius, Overlaps, overlapMask, QueryTriggerInteraction.Collide);
			Receivers.Clear();
			Bodies.Clear();
			BodyPoints.Clear();
			BodyDistances.Clear();
			for (int i = 0; i < count; i++)
			{
				Collider collider = Overlaps[i];
				if (collider == null)
				{
					continue;
				}
				IBlastReceiver receiver = collider.GetComponentInParent<IBlastReceiver>();
				if (receiver != null)
				{
					if (!Receivers.Contains(receiver))
					{
						Receivers.Add(receiver);
					}
					continue;
				}
				Rigidbody body = collider.attachedRigidbody;
				if (collider.isTrigger || body == null || body.isKinematic)
				{
					continue;
				}
				Vector3 point = ClosestPoint(collider, center);
				float distance = Vector3.Distance(point, center);
				int index = Bodies.IndexOf(body);
				if (index >= 0)
				{
					if (distance < BodyDistances[index])
					{
						BodyPoints[index] = point;
						BodyDistances[index] = distance;
					}
				}
				else
				{
					Bodies.Add(body);
					BodyPoints.Add(point);
					BodyDistances.Add(distance);
				}
			}
			Array.Clear(Overlaps, 0, count);
			int hits = 0;
			for (int j = 0; j < Receivers.Count; j++)
			{
				IBlastReceiver receiver2 = Receivers[j];
				if (receiver2 is UnityEngine.Object obj && obj == null)
				{
					continue;
				}
				Vector3 to = receiver2.BlastPivot - center;
				float length = to.magnitude;
				float distance2 = Mathf.Max(0f, length - receiver2.BlastBodyRadius);
				float strength = Strength(in blast, distance2);
				if (strength <= 0f || Occluded(center, to, length, occluderMask, receiver2, null))
				{
					continue;
				}
				Vector3 direction = PushDirection(to, length, blast.upwardBias);
				BlastHit hit = new BlastHit
				{
					strength = strength,
					direction = direction,
					distance = distance2,
					isSelf = (blast.instigator != null && (object)receiver2 == blast.instigator)
				};
				receiver2.OnBlast(in blast, in hit);
				hits++;
			}
			for (int k = 0; k < Bodies.Count; k++)
			{
				Rigidbody body2 = Bodies[k];
				if (body2 == null)
				{
					continue;
				}
				float strength2 = Strength(in blast, BodyDistances[k]);
				Vector3 point2 = BodyPoints[k];
				if (strength2 <= 0f)
				{
					continue;
				}
				Vector3 to2 = point2 - center;
				if (!Occluded(center, to2, to2.magnitude, occluderMask, null, body2))
				{
					Vector3 worldCenterOfMass = body2.worldCenterOfMass;
					float speed = Mathf.Min(blast.maxPropSpeed, strength2 * blast.propImpulse / Mathf.Max(body2.mass, 0.01f));
					Vector3 toCenterOfMass = worldCenterOfMass - center;
					Vector3 push = PushDirection(toCenterOfMass, toCenterOfMass.magnitude, blast.upwardBias);
					body2.AddForce(push * speed, ForceMode.VelocityChange);
					body2.AddTorque(UnityEngine.Random.onUnitSphere * (speed * 1.5f), ForceMode.VelocityChange);
					hits++;
				}
			}
			Receivers.Clear();
			Bodies.Clear();
			return hits;
		}

		public static float Strength(in BlastInfo blast, float distance)
		{
			if (distance <= blast.innerRadius)
			{
				return 1f;
			}
			float range = blast.radius - blast.innerRadius;
			if (range <= 0.0001f)
			{
				return 0f;
			}
			return Mathf.Clamp01(1f - (distance - blast.innerRadius) / range);
		}

		private static Vector3 PushDirection(Vector3 to, float length, float upwardBias)
		{
			Vector3 direction = ((length > 0.001f) ? (to / length) : Vector3.up);
			direction += Vector3.up * upwardBias;
			if (!(direction.sqrMagnitude > 1E-06f))
			{
				return Vector3.up;
			}
			return direction.normalized;
		}

		private static bool Occluded(Vector3 center, Vector3 to, float length, int occluderMask, IBlastReceiver receiver, Rigidbody body)
		{
			if (length < 0.05f || occluderMask == 0)
			{
				return false;
			}
			if (!Physics.Raycast(center, to / length, out var hitInfo, length, occluderMask, QueryTriggerInteraction.Ignore))
			{
				return false;
			}
			if (body != null && hitInfo.rigidbody == body)
			{
				return false;
			}
			if (receiver != null && hitInfo.collider.GetComponentInParent<IBlastReceiver>() == receiver)
			{
				return false;
			}
			return true;
		}

		private static Vector3 ClosestPoint(Collider c, Vector3 point)
		{
			if (c is BoxCollider || c is SphereCollider || c is CapsuleCollider || (c is MeshCollider meshCollider && meshCollider.convex))
			{
				return c.ClosestPoint(point);
			}
			return c.bounds.ClosestPoint(point);
		}
	}
}
