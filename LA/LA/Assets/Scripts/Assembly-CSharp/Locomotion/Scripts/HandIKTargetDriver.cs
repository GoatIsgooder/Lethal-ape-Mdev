using UnityEngine;

namespace Locomotion.Scripts
{
	[DefaultExecutionOrder(-100)]
	public class HandIKTargetDriver : MonoBehaviour
	{
		[Header("Output")]
		[Tooltip("The transform the arm IK component targets. Pose-follows the held object while grabbing.")]
		public Transform ikTarget;

		[Header("Rest source")]
		[Tooltip("Controller-tracked transform the IK target follows when nothing is held.")]
		public Transform kinematicSource;

		private Transform _attachParent;

		private Vector3 _attachLocalPos;

		private Quaternion _attachLocalRot;

		public bool IsAttached { get; private set; }

		private void LateUpdate()
		{
			if (ikTarget == null)
			{
				return;
			}
			if (IsAttached)
			{
				if (!(_attachParent == null))
				{
					ikTarget.SetPositionAndRotation(_attachParent.TransformPoint(_attachLocalPos), _attachParent.rotation * _attachLocalRot);
					return;
				}
				IsAttached = false;
				_attachParent = null;
			}
			if (kinematicSource != null)
			{
				ikTarget.SetPositionAndRotation(kinematicSource.position, kinematicSource.rotation);
			}
		}

		public void AttachTo(Transform parent)
		{
			if (!(ikTarget == null) && !(parent == null))
			{
				if (kinematicSource != null)
				{
					ikTarget.SetPositionAndRotation(kinematicSource.position, kinematicSource.rotation);
				}
				_attachParent = parent;
				_attachLocalPos = parent.InverseTransformPoint(ikTarget.position);
				_attachLocalRot = Quaternion.Inverse(parent.rotation) * ikTarget.rotation;
				IsAttached = true;
			}
		}

		public void Detach()
		{
			IsAttached = false;
			_attachParent = null;
			if (ikTarget != null && kinematicSource != null)
			{
				ikTarget.SetPositionAndRotation(kinematicSource.position, kinematicSource.rotation);
			}
		}

		private void OnDisable()
		{
			if (IsAttached)
			{
				Detach();
			}
		}
	}
}
