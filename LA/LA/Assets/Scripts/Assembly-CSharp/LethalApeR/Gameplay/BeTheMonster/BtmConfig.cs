using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[CreateAssetMenu(fileName = "BtmConfig", menuName = "LethalApeR/BeTheMonster/Btm Config", order = 1)]
	public class BtmConfig : ScriptableObject
	{
		[Header("Legged movement (left stick)")]
		[Tooltip("Top planar speed (m/s) at full stick, before monster scale. Weighty creature ≈ 2.5–4.")]
		public float moveSpeed = 3f;

		[Tooltip("Ramp-UP rate to target speed (m/s²). LOWER = heavier, laggier start.")]
		public float acceleration = 12f;

		[Tooltip("Ramp-DOWN rate to a stop (m/s²). LOWER = more glide / slower settle.")]
		public float deceleration = 16f;

		[Range(0f, 0.5f)]
		[Tooltip("Left-stick magnitude below this is ignored (deadzone).")]
		public float stickDeadzone = 0.15f;

		[Tooltip("Sphere radius used to block walls while moving. ≈0.25 for a person-sized rig.")]
		public float wallCheckRadius = 0.25f;

		[Header("Body lean (read by the IK layer — cosmetic)")]
		[Tooltip("Max degrees the body leans into motion. 0 = no lean. Applied to the avatar by the VRIK chunk.")]
		public float maxLeanAngle = 12f;

		[Tooltip("How fast the lean follows speed. Higher = snappier.")]
		public float leanResponse = 8f;

		[Header("Turning (right stick X = snap turn)")]
		[Tooltip("Degrees per snap.")]
		public float snapTurnAngle = 45f;

		[Range(0f, 1f)]
		[Tooltip("Right-stick X magnitude needed to fire a snap.")]
		public float snapTurnThreshold = 0.6f;

		[Range(0f, 1f)]
		[Tooltip("Right-stick X must drop below this before another snap can fire (re-arm).")]
		public float snapTurnRelease = 0.2f;

		[Header("Crouch (right stick DOWN)")]
		[Range(0f, 1f)]
		[Tooltip("Right-stick Y below −this starts a crouch.")]
		public float crouchThreshold = 0.6f;

		[Tooltip("How fast crouch eases in/out (units/sec on a 0..1 range).")]
		public float crouchResponse = 8f;

		[Range(0f, 1f)]
		[Tooltip("Move-speed multiplier at full crouch (sneak).")]
		public float crouchSpeedMultiplier = 0.45f;

		[Tooltip("How far (m, at scale 1) the head/pelvis lowers at full crouch. Applied by the VRIK layer in the IK chunk — captured now so it's wired.")]
		public float crouchDepth = 0.6f;

		[Header("Foot / leg IK — distance LOD (Quest crowd budget)")]
		[Tooltip("Beyond this distance from the local camera, a creature's leg IK + grounding is weighed out to ZERO (no raycasts). Keeps many monsters cheap on Quest 2/3/3S.")]
		public float legIkActivationRadius = 14f;

		[Tooltip("Soft fade band (m) before the cutoff so IK weight eases out instead of popping.")]
		public float legIkFadeBand = 3f;

		[Tooltip("Ground layers the foot raycasts / Grounder test against. EXCLUDE the creature's own collider layer.")]
		public LayerMask groundMask = -1;

		private void OnValidate()
		{
			if (deceleration < 0.01f)
			{
				deceleration = 0.01f;
			}
			if (acceleration < 0.01f)
			{
				acceleration = 0.01f;
			}
			if (snapTurnRelease > snapTurnThreshold)
			{
				snapTurnRelease = snapTurnThreshold * 0.5f;
			}
			if (legIkFadeBand < 0f)
			{
				legIkFadeBand = 0f;
			}
		}
	}
}
