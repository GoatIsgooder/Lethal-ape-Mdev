using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[Serializable]
	public class FnPuppetStyle
	{
		[Header("Stance")]
		[Tooltip("Model root height above the feet while standing on the knuckles.")]
		public float bodyHeight = 0.72f;

		[Tooltip("Planted fists: distance out from the centre line, and forward of the feet.")]
		public float handSpread = 0.46f;

		public float handForward = 0.34f;

		[Tooltip("Wrist height above the floor with the knuckles down.")]
		public float wristHeight = 0.17f;

		public float standLean = 8f;

		[Header("Gait")]
		[Tooltip("Plants per hand per stride cycle of the pose stream (1 = one plant per hand per 1.5 m).")]
		[Range(1f, 2f)]
		public int cadence = 1;

		[Tooltip("Both hands swing together (a bounding gallop) instead of alternating.")]
		public bool gallop;

		public float liftHeight = 0.16f;

		public float walkLean = 14f;

		public float runLean = 24f;

		[Tooltip("Speed at which the run lean is reached (m/s).")]
		public float runSpeed = 3.2f;

		public float bob = 0.035f;

		public float roll = 3f;

		public float twist = 7f;

		[Tooltip("Head pitch nod on every plant (a chicken's peck).")]
		public float plantNod;

		[Header("Servo feel")]
		[Tooltip("0 = smooth, 1 = hard stop-go servo steps on posture and head.")]
		[Range(0f, 1f)]
		public float hitch = 0.55f;

		[Tooltip("Posture channel speed while a servo step is running (degrees or metres*100 per second).")]
		public float servoSpeed = 150f;

		public Vector2 servoHold = new Vector2(0.06f, 0.35f);

		[Header("Personality")]
		[Tooltip("Resting head roll (a cocked head).")]
		public float headTilt;

		[Tooltip("Idle head sway amplitude and period (s).")]
		public float idleSway = 6f;

		public float idleSwayPeriod = 5.5f;

		[Tooltip("Twitches per second, and how hard (degrees).")]
		public float twitchRate;

		public float twitchStrength;

		[Tooltip("High-frequency shake on head and hands (degrees).")]
		public float tremor;

		[Tooltip("How far the eyes turn inside the head (degrees).")]
		public float eyeRange = 22f;

		[Header("Home")]
		public FnPerform perform;

		[Tooltip("Show-loop tempo (beats per minute).")]
		public float tempo = 96f;

		[Header("On camera")]
		[Tooltip("Delay before the head turns to the lens once the feed is on it.")]
		public float stareDelay = 0.6f;

		[Tooltip("Head roll that creeps in while it stares into the lens.")]
		public float stareTilt = 8f;

		[Tooltip("Closer than this to the lens it leans in, face first (m).")]
		public float lensLeanWithin = 2.6f;

		public float lensLean = 18f;

		[Header("Hands")]
		[Tooltip("Knocks with the left fist (the right hand goes flat on the door).")]
		public bool knockLeft;

		public float fistCurl = 72f;

		public float relaxedCurl = 24f;

		public float spreadCurl = -8f;

		public FnPuppetStyle Clone()
		{
			return (FnPuppetStyle)MemberwiseClone();
		}

		public static FnPuppetStyle For(FnAnim anim, FnDifficulty difficulty)
		{
			FnPuppetStyle fnPuppetStyle = Base(anim);
			if (difficulty == FnDifficulty.Nightmare)
			{
				Nightmarish(fnPuppetStyle, anim);
			}
			return fnPuppetStyle;
		}

		private static FnPuppetStyle Base(FnAnim anim)
		{
			FnPuppetStyle fnPuppetStyle = new FnPuppetStyle();
			switch (anim)
			{
			case FnAnim.Bunny:
				fnPuppetStyle.bodyHeight = 0.74f;
				fnPuppetStyle.liftHeight = 0.22f;
				fnPuppetStyle.walkLean = 12f;
				fnPuppetStyle.runLean = 24f;
				fnPuppetStyle.bob = 0.05f;
				fnPuppetStyle.roll = 4f;
				fnPuppetStyle.twist = 9f;
				fnPuppetStyle.hitch = 0.7f;
				fnPuppetStyle.servoSpeed = 220f;
				fnPuppetStyle.servoHold = new Vector2(0.04f, 0.25f);
				fnPuppetStyle.idleSway = 9f;
				fnPuppetStyle.idleSwayPeriod = 3.4f;
				fnPuppetStyle.perform = FnPerform.Guitar;
				fnPuppetStyle.tempo = 124f;
				fnPuppetStyle.stareDelay = 0.3f;
				fnPuppetStyle.stareTilt = 14f;
				fnPuppetStyle.knockLeft = true;
				break;
			case FnAnim.Chicken:
				fnPuppetStyle.bodyHeight = 0.7f;
				fnPuppetStyle.liftHeight = 0.14f;
				fnPuppetStyle.walkLean = 16f;
				fnPuppetStyle.runLean = 26f;
				fnPuppetStyle.bob = 0.04f;
				fnPuppetStyle.roll = 3f;
				fnPuppetStyle.twist = 6f;
				fnPuppetStyle.plantNod = 7f;
				fnPuppetStyle.hitch = 0.5f;
				fnPuppetStyle.idleSway = 5f;
				fnPuppetStyle.idleSwayPeriod = 4.2f;
				fnPuppetStyle.perform = FnPerform.Present;
				fnPuppetStyle.tempo = 104f;
				fnPuppetStyle.stareDelay = 0.8f;
				fnPuppetStyle.stareTilt = 10f;
				break;
			case FnAnim.Endo:
				fnPuppetStyle.bodyHeight = 0.62f;
				fnPuppetStyle.handSpread = 0.5f;
				fnPuppetStyle.handForward = 0.4f;
				fnPuppetStyle.standLean = 18f;
				fnPuppetStyle.gallop = true;
				fnPuppetStyle.liftHeight = 0.26f;
				fnPuppetStyle.walkLean = 22f;
				fnPuppetStyle.runLean = 36f;
				fnPuppetStyle.runSpeed = 4.5f;
				fnPuppetStyle.bob = 0.06f;
				fnPuppetStyle.roll = 2f;
				fnPuppetStyle.twist = 4f;
				fnPuppetStyle.hitch = 0.3f;
				fnPuppetStyle.servoSpeed = 300f;
				fnPuppetStyle.idleSway = 4f;
				fnPuppetStyle.idleSwayPeriod = 2.8f;
				fnPuppetStyle.tremor = 0.4f;
				fnPuppetStyle.perform = FnPerform.Crouch;
				fnPuppetStyle.tempo = 90f;
				fnPuppetStyle.stareDelay = 0.15f;
				fnPuppetStyle.stareTilt = 20f;
				fnPuppetStyle.lensLean = 24f;
				fnPuppetStyle.fistCurl = 60f;
				break;
			default:
				fnPuppetStyle.bodyHeight = 0.72f;
				fnPuppetStyle.liftHeight = 0.14f;
				fnPuppetStyle.walkLean = 14f;
				fnPuppetStyle.runLean = 22f;
				fnPuppetStyle.bob = 0.035f;
				fnPuppetStyle.roll = 3f;
				fnPuppetStyle.twist = 6f;
				fnPuppetStyle.hitch = 0.6f;
				fnPuppetStyle.servoSpeed = 130f;
				fnPuppetStyle.idleSway = 6f;
				fnPuppetStyle.idleSwayPeriod = 6f;
				fnPuppetStyle.perform = FnPerform.Mic;
				fnPuppetStyle.tempo = 96f;
				fnPuppetStyle.stareDelay = 0.6f;
				fnPuppetStyle.stareTilt = 8f;
				break;
			}
			return fnPuppetStyle;
		}

		private static void Nightmarish(FnPuppetStyle s, FnAnim anim)
		{
			s.bodyHeight -= 0.04f;
			s.standLean += 6f;
			s.liftHeight *= 1.2f;
			s.walkLean += 6f;
			s.runLean += 6f;
			s.bob *= 1.3f;
			s.hitch = Mathf.Min(s.hitch + 0.3f, 1f);
			s.servoSpeed *= 1.8f;
			s.servoHold.x *= 0.6f;
			s.servoHold.y *= 1.4f;
			s.headTilt = anim switch
			{
				FnAnim.Bunny => -16f,
				FnAnim.Chicken => 12f,
				FnAnim.Endo => -20f,
				_ => 10f,
			};
			s.twitchRate = ((anim == FnAnim.Bear) ? 0.35f : 0.55f);
			s.twitchStrength = ((anim == FnAnim.Bear) ? 18f : 26f);
			s.tremor = Mathf.Max(s.tremor, 0.9f);
			s.eyeRange = 28f;
			s.stareDelay = 0.05f;
			s.stareTilt = s.stareTilt * 2f + 10f;
			s.lensLean += 8f;
			s.spreadCurl = -18f;
		}
	}
}
