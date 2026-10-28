using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[CreateAssetMenu(fileName = "Monster_", menuName = "LethalApeR/BeTheMonster/Monster Definition", order = 2)]
	public class MonsterDefinition : ScriptableObject
	{
		[Header("Identity")]
		public string displayName = "New Monster";

		[Header("Locomotion")]
		public MonsterLocomotionType locomotion = MonsterLocomotionType.Legged;

		public MonsterRigType rigType;

		[Header("Body")]
		[Tooltip("Full-body avatar prefab the player wears as this monster (the rig the IK drives). For Gorilla forms this can be an arm-skin instead.")]
		public GameObject bodyPrefab;

		[Tooltip("Uniform scale of the PLAYER RIG while embodied (drives Player.targetScale). Keep 1 unless you want the whole world/collision to feel bigger — the VISIBLE body size is handled by bodyHeightMeters below.")]
		[Min(0.05f)]
		public float scale = 1f;

		[Tooltip("Target rendered height of the monster body in metres (head→foot world AABB). The body auto-scales to this on equip. ~1.8 = player-ish, higher = a looming monster.")]
		[Min(0.2f)]
		public float bodyHeightMeters = 1.9f;

		[Header("Body collider (locomotion capsule height while embodied)")]
		[Tooltip("Standing collider height in metres. Gus = 1.572163.")]
		[Min(0.1f)]
		public float colliderStandHeight = 1.6f;

		[Tooltip("Fully-crouched collider height in metres. Gus = 0.7115713.")]
		[Min(0.1f)]
		public float colliderCrouchHeight = 0.8f;

		[Header("VRIK head target (corrects the head-bone orientation)")]
		[Tooltip("Head IK-target offset from the camera CENTER (camera-space: x=right, y=up, z=forward). 0 = head bone sits exactly on your camera with zero orbit. Nudge +Z to push the face forward off your eyes.")]
		public Vector3 headPositionOffset = Vector3.zero;

		[Tooltip("Head IK-target rotation offset (degrees) if the monster's gaze ends up tilted relative to your view.")]
		public Vector3 headRotationOffset = Vector3.zero;

		[Header("Body offset (torso / pelvis relative to your view)")]
		[Tooltip("Shifts the monster's BODY relative to your view (camera-space: x=right, y=up, z=forward). 0 = the body hangs at its natural spot below the head.")]
		public Vector3 bodyPositionOffset = Vector3.zero;

		[Range(0f, 1f)]
		[Tooltip("How firmly the body is PINNED in place (so it doesn't move with your head). 1 = body stays fully planted, only the head moves; lower = the body follows your head more.")]
		public float bodyFollowWeight = 1f;

		[Header("Legs / procedural stepping (quad + multi-leg; bipeds use VRIK)")]
		[Tooltip("How many legs the procedural stepper drives. Ignored for Biped (VRIK owns those legs).")]
		[Min(0f)]
		public int legCount;

		[Tooltip("How far (m, at scale 1) a foot may stray from its rest target before it takes a step.")]
		public float stepTriggerDistance = 0.35f;

		[Tooltip("Seconds a single step takes to swing to its new spot.")]
		public float stepDuration = 0.18f;

		[Tooltip("Peak height (m) of the foot arc mid-step.")]
		public float stepHeight = 0.18f;

		[Header("Per-monster overrides (optional; ≤0 = use BtmConfig)")]
		[Tooltip("Override BtmConfig.moveSpeed for this form. 0 = use the config value.")]
		public float moveSpeedOverride;
	}
}
