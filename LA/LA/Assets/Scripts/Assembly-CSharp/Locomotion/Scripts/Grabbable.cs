using UnityEngine;
using UnityEngine.Events;

namespace Locomotion.Scripts
{
	[RequireComponent(typeof(Rigidbody))]
	public class Grabbable : MonoBehaviour, IGrabbable
	{
		public UnityEvent onGrab;

		public UnityEvent onDrop;

		public void OnGrab()
		{
			onGrab?.Invoke();
		}

		public void OnDrop()
		{
			onDrop?.Invoke();
		}

		public void MakeRigidbodyPerfect()
		{
			Rigidbody component = GetComponent<Rigidbody>();
			if (!(component == null))
			{
				component.mass = 1f;
				component.linearDamping = 0.05f;
				component.angularDamping = 20f;
				component.automaticCenterOfMass = true;
				component.automaticInertiaTensor = true;
				component.useGravity = true;
				component.isKinematic = false;
				component.interpolation = RigidbodyInterpolation.Interpolate;
				component.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative;
			}
		}
	}
}
