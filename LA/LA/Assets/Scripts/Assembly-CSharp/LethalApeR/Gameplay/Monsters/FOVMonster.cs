using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public class FOVMonster : BaseMonster
	{
		[Header("Running Animation")]
		[Tooltip("Swap in a separate object while this monster is chasing — a run-cycle model, a sprint VFX, whatever. Off by default: monsters without one are untouched and pay nothing.")]
		public bool hasRunningAnimation;

		[Tooltip("Enabled while chasing, disabled the rest of the time. Only used when Has Running Animation is ticked.")]
		public Transform runningAnimation;

		[Tooltip("The walk-cycle object — the exact mirror of Running Animation. Disabled while chasing, enabled the rest of the time. Optional: leave empty if the run object is additive rather than a swap.")]
		public Transform walkingAnimation;

		[Header("Gizmos")]
		[Tooltip("Draw the jumpscare trigger sphere in the Scene view.")]
		public bool drawJumpscareGizmo = true;

		[Tooltip("Color of the jumpscare trigger sphere.")]
		public Color jumpscareGizmoColor = new Color(1f, 0.25f, 0.1f, 0.9f);

		[Tooltip("Draw the FOV detection cone (range + angle) in the Scene view.")]
		public bool drawSightGizmo = true;

		[Tooltip("Color of the sight-range wire sphere.")]
		public Color sightRangeColor = new Color(1f, 0.92f, 0.015f, 1f);

		[Tooltip("Color of the FOV cone wireframe.")]
		public Color sightConeColor = Color.red;

		[Tooltip("How many edge rays to draw around the cone surface (more = smoother).")]
		[Range(4f, 32f)]
		public int sightConeSegments = 12;

		protected virtual void LateUpdate()
		{
			if (hasRunningAnimation && !base.IsJumpscaring)
			{
				SetModelActive(runningAnimation, canSeePlayer);
				SetModelActive(walkingAnimation, !canSeePlayer);
			}
		}

		private static void SetModelActive(Transform model, bool active)
		{
			if (!(model == null) && model.gameObject.activeSelf != active)
			{
				model.gameObject.SetActive(active);
			}
		}

		private void OnDrawGizmos()
		{
			if (drawJumpscareGizmo)
			{
				Gizmos.color = jumpscareGizmoColor;
				Gizmos.DrawWireSphere(base.transform.position, jumpscareTriggerDistance);
			}
			if (drawSightGizmo)
			{
				Transform obj = ((headTransform != null) ? headTransform : base.transform);
				Vector3 position = obj.position;
				Vector3 forward = obj.forward;
				Vector3 right = obj.right;
				Gizmos.color = sightRangeColor;
				Gizmos.DrawWireSphere(position, sightRange);
				Gizmos.color = sightConeColor;
				Gizmos.DrawLine(position, position + forward * sightRange);
				float angle = Mathf.Clamp(sightAngle * 0.5f, 0f, 180f);
				int num = Mathf.Max(sightConeSegments, 4);
				Vector3 from = Vector3.zero;
				for (int i = 0; i <= num; i++)
				{
					Vector3 axis = Quaternion.AngleAxis(360f / (float)num * (float)i, forward) * right;
					Vector3 vector = Quaternion.AngleAxis(angle, axis) * forward;
					Vector3 vector2 = position + vector * sightRange;
					Gizmos.DrawLine(position, vector2);
					if (i > 0)
					{
						Gizmos.DrawLine(from, vector2);
					}
					from = vector2;
				}
			}
		}
	}
}
