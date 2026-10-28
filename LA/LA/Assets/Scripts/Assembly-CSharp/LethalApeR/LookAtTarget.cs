using UnityEngine;

namespace LethalApeR
{
	[ExecuteAlways]
	public class LookAtTarget : MonoBehaviour
	{
		[Tooltip("Transform to look at in PLAY MODE. If null, the script no-ops in play.")]
		public Transform target;

		[Tooltip("In edit mode, look at the active Scene View camera so you can preview the rotation by flying the camera around. Has no effect in play mode (uses 'target' there).")]
		public bool trackSceneViewInEditor = true;

		[Tooltip("Lock pitch/roll so the object only yaws (useful for NPC heads, billboards).")]
		public bool yAxisOnly;

		[Tooltip("0 = instant snap. Higher = smoother slerp toward the target rotation. Ignored in edit mode (snaps).")]
		[Range(0f, 30f)]
		public float smoothSpeed;

		[Tooltip("Offset added to the computed rotation, in degrees. Useful when the model's forward isn't +Z.")]
		public Vector3 rotationOffset;

		private void LateUpdate()
		{
			Apply();
		}

		private void Apply()
		{
			Vector3? lookPoint = ResolveLookPoint();
			if (!lookPoint.HasValue)
			{
				return;
			}
			Vector3 dir = lookPoint.Value - transform.position;
			if (yAxisOnly)
			{
				dir.y = 0f;
			}
			if (dir.sqrMagnitude < 1E-06f)
			{
				return;
			}
			Quaternion rot = Quaternion.LookRotation(dir, Vector3.up) * Quaternion.Euler(rotationOffset);
			if (smoothSpeed > 0f && Application.isPlaying)
			{
				rot = Quaternion.Slerp(transform.rotation, rot, 1f - Mathf.Exp(-smoothSpeed * Time.deltaTime));
			}
			transform.rotation = rot;
		}

		private Vector3? ResolveLookPoint()
		{
			if (target != null)
			{
				return target.position;
			}
			return null;
		}
	}
}
