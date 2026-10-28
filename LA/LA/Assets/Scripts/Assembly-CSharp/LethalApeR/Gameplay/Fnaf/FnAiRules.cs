using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnAiRules
	{
		public const int MaxLevel = 20;

		public const float CatchHeightTolerance = 0.3f;

		public const float SlackBase = 0.5f;

		public const float SlackPingFactor = 1.5f;

		public const float SlackFixedSeconds = 0.1f;

		public const float NoiseClampMeters = 3f;

		public const float SnapDistance = 3f;

		private const double WrapSeconds = 4294967.296;

		public const int MaxKnockBursts = 6;

		public const float KnockRaiseSeconds = 0.16f;

		public const float KnockStrikeSeconds = 0.07f;

		public const float SlamWindupSeconds = 0.3f;

		public const float SlamStrikeSeconds = 0.06f;

		public const float JumpGravity = 22f;

		public const float MinJumpRise = 0.3f;

		public static double Elapsed(double now, double stamp)
		{
			double num = now - stamp;
			if (num < -WrapSeconds * 0.5)
			{
				num += WrapSeconds;
			}
			else if (num > WrapSeconds * 0.5)
			{
				num -= WrapSeconds;
			}
			return num;
		}

		public static bool Due(double now, double stamp)
		{
			return Elapsed(now, stamp) >= 0.0;
		}

		public static int Level(int[] nightLevels, int night, int hour, int arrivedCount, int[] bumpHours, int teamOffsetPerExtraGuard, int cap, int difficultyBonus = 0)
		{
			if (nightLevels == null || nightLevels.Length == 0)
			{
				return 0;
			}
			int num = nightLevels[Mathf.Clamp(night - 1, 0, nightLevels.Length - 1)];
			if (num < 1)
			{
				return 0;
			}
			if (bumpHours != null)
			{
				for (int i = 0; i < bumpHours.Length; i++)
				{
					if (hour >= bumpHours[i])
					{
						num++;
					}
				}
			}
			num += Mathf.Max(0, teamOffsetPerExtraGuard) * Mathf.Max(0, arrivedCount - 1) + Mathf.Max(0, difficultyBonus);
			return Mathf.Clamp(num, 0, Mathf.Clamp(cap, 0, MaxLevel));
		}

		public static bool MovementRoll(int level, int roll1To20)
		{
			if (level > 0 && roll1To20 > 0)
			{
				return roll1To20 <= level;
			}
			return false;
		}

		public static float LevelT(int level)
		{
			return Mathf.Clamp01((float)level / (float)MaxLevel);
		}

		public static float ByLevel(Vector2 range, int level)
		{
			return Mathf.Lerp(range.x, range.y, LevelT(level));
		}

		public static float WalkSpeed(int level, Vector2 range, float scale = 1f)
		{
			return Mathf.Max(0.1f, ByLevel(range, level) * Mathf.Max(0f, scale));
		}

		public static float RunSpeed(int level, Vector2 range, float scale = 1f)
		{
			return Mathf.Max(0.1f, ByLevel(range, level) * Mathf.Max(0f, scale));
		}

		public static float WarningSeconds(int level, Vector2 range, float scale = 1f)
		{
			return Mathf.Max(0.25f, ByLevel(range, level) * Mathf.Max(0f, scale));
		}

		public static float OfficeCooldownSeconds(int level, Vector2 range, float scale = 1f)
		{
			return Mathf.Max(0f, ByLevel(range, level) * Mathf.Max(0f, scale));
		}

		public static float MaxChaseSeconds(int level, Vector2 range)
		{
			return Mathf.Max(1f, ByLevel(range, level));
		}

		public static float SightRange(int level, Vector2 range, bool targetLit, float darkSightFactor)
		{
			float num = (targetLit ? 1f : Mathf.Clamp01(darkSightFactor));
			return Mathf.Max(0f, ByLevel(range, level)) * num;
		}

		public static bool IsInsideCone(Vector3 origin, Vector3 forward, Vector3 point, float range, float halfAngleDeg, out float distance)
		{
			Vector3 vector = point - origin;
			distance = vector.magnitude;
			if (range <= 0f || distance > range)
			{
				return false;
			}
			if (distance < 0.0001f)
			{
				return true;
			}
			Vector3 lhs = ((forward.sqrMagnitude > 1E-08f) ? forward.normalized : Vector3.forward);
			float num = Mathf.Cos(Mathf.Clamp(halfAngleDeg, 0f, 180f) * Mathf.Deg2Rad);
			return Vector3.Dot(lhs, vector / distance) >= num;
		}

		public static float SpotRateMultiplier(float distance, float range, float closeRangeBoost)
		{
			if (range <= 0.0001f)
			{
				return 1f;
			}
			float t = 1f - Mathf.Clamp01(distance / range);
			return Mathf.Lerp(1f, Mathf.Max(1f, closeRangeBoost), t);
		}

		public static float StepSuspicion(float suspicion, bool seen, float rateMultiplier, float secondsToSpot, float secondsToForget, float dt)
		{
			if (dt > 0f)
			{
				if (seen)
				{
					if (secondsToSpot <= 0.0001f)
					{
						return 1f;
					}
					suspicion += Mathf.Max(0f, rateMultiplier) * dt / secondsToSpot;
				}
				else
				{
					if (secondsToForget <= 0.0001f)
					{
						return 0f;
					}
					suspicion -= dt / secondsToForget;
				}
			}
			return Mathf.Clamp01(suspicion);
		}

		public static bool SpotComplete(float suspicion)
		{
			return suspicion >= 1f;
		}

		public static bool ChaseLost(float suspicion, float releaseThreshold, float unseenSeconds, float loseSightSeconds)
		{
			if (unseenSeconds < loseSightSeconds)
			{
				return false;
			}
			return suspicion < Mathf.Clamp01(releaseThreshold);
		}

		public static bool InBeam(Vector3 handPosition, Vector3 handForward, Vector3 point, float range, float halfAngleDeg)
		{
			float distance;
			return IsInsideCone(handPosition, handForward, point, range, halfAngleDeg, out distance);
		}

		public static int KnockBursts(int level, Vector2 range, bool fromChase, float roll)
		{
			float num = ByLevel(range, level);
			int num2 = Mathf.FloorToInt(num);
			int num3 = num2 + (fromChase ? 1 : 0);
			if (num - (float)num2 > roll)
			{
				num3++;
			}
			return Mathf.Clamp(num3, 1, MaxKnockBursts);
		}

		public static float RapInterval(FnAnim anim, bool heavy)
		{
			if (heavy)
			{
				if (anim != FnAnim.Endo)
				{
					return 0.62f;
				}
				return 0.34f;
			}
			return anim switch
			{
				FnAnim.Bear => 0.27f,
				FnAnim.Bunny => 0.19f,
				FnAnim.Chicken => 0.23f,
				_ => 0.3f,
			};
		}

		public static float RapContact(FnAnim anim, bool heavy, int rap)
		{
			float num = (heavy ? (SlamWindupSeconds + SlamStrikeSeconds) : (KnockRaiseSeconds + KnockStrikeSeconds));
			return num + RapInterval(anim, heavy) * (float)Mathf.Max(0, rap);
		}

		public static float KnockSeconds(FnAnim anim, bool heavy, int raps)
		{
			return RapContact(anim, heavy, Mathf.Max(1, raps) - 1) + (heavy ? 0.45f : 0.25f);
		}

		public static bool CatchableState(FnAiState state)
		{
			if (state != FnAiState.Dormant && state != FnAiState.Retreat)
			{
				return state != FnAiState.PoweredDown;
			}
			return false;
		}

		public static float HorizontalDistance(Vector3 a, Vector3 b)
		{
			float num = a.x - b.x;
			float num2 = a.z - b.z;
			return Mathf.Sqrt(num * num + num2 * num2);
		}

		public static bool InCatchCapsule(Vector3 animFeet, Vector3 head, float radius, float height)
		{
			float num = head.y - animFeet.y;
			if (num < 0f || num > height)
			{
				return false;
			}
			return HorizontalDistance(animFeet, head) <= radius;
		}

		public static float LatencySlack(float animSpeed, float guardSpeed, float pingMs, float maxSlack)
		{
			float num = (Mathf.Max(0f, animSpeed) + Mathf.Max(0f, guardSpeed)) * (Mathf.Max(0f, pingMs) * SlackPingFactor / 1000f + SlackFixedSeconds);
			return Mathf.Min(Mathf.Max(0f, maxSlack), num) + SlackBase;
		}

		public static FnCatchVerdict ValidateCatch(FnAiState state, bool reporterAlive, Vector3 reportedHead, Vector3 masterHead, Vector3 animFeet, float animSpeed, float guardSpeed, float pingMs, float reachRadius, float reachHeight, float headTolerance, float maxSlack)
		{
			if (!CatchableState(state))
			{
				return FnCatchVerdict.BadState;
			}
			if (!reporterAlive)
			{
				return FnCatchVerdict.NotAlive;
			}
			if ((reportedHead - masterHead).sqrMagnitude > headTolerance * headTolerance)
			{
				return FnCatchVerdict.HeadMismatch;
			}
			if (HorizontalDistance(masterHead, animFeet) > LatencySlack(animSpeed, guardSpeed, pingMs, maxSlack) + reachRadius)
			{
				return FnCatchVerdict.TooFar;
			}
			if (masterHead.y - animFeet.y > reachHeight + CatchHeightTolerance)
			{
				return FnCatchVerdict.TooHigh;
			}
			return FnCatchVerdict.Accept;
		}

		public static bool DoorShields(FnAiState state, bool headInOffice)
		{
			return state == FnAiState.DoorBang && headInOffice;
		}

		public static bool IsPerched(float headY, float floorY, float reachHeight)
		{
			return headY - floorY > reachHeight;
		}

		public static Vector3 ExtrapolateFeet(Vector3 feet, Vector3 velocity, float seconds)
		{
			return feet + velocity * Mathf.Max(0f, seconds);
		}

		public static float JumpRise(float headY, float floorY, float headAboveFeet)
		{
			return Mathf.Max(0f, headY - floorY - headAboveFeet);
		}

		public static float JumpFlightSeconds(float rise)
		{
			return Mathf.Sqrt(2f * Mathf.Max(0f, rise) / JumpGravity);
		}

		public static float JumpAirSeconds(float rise, float hang)
		{
			if (rise <= 0f)
			{
				return 0f;
			}
			return Mathf.Max(0f, hang) + 2f * JumpFlightSeconds(rise);
		}

		public static float JumpHeight(float rise, float hang, float t)
		{
			if (rise <= 0f || t <= 0f)
			{
				return 0f;
			}
			float num = JumpFlightSeconds(rise);
			if (t < num)
			{
				float num2 = num - t;
				return rise - 0.5f * JumpGravity * num2 * num2;
			}
			float num3 = t - (Mathf.Max(0f, hang) + num);
			if (num3 <= 0f)
			{
				return rise;
			}
			if (num3 >= num)
			{
				return 0f;
			}
			return rise - 0.5f * JumpGravity * num3 * num3;
		}

		public static float JumpPeakBetween(float rise, float hang, float from, float to)
		{
			if (to <= 0f || rise <= 0f || to < from)
			{
				return 0f;
			}
			float num = JumpFlightSeconds(rise);
			if (num <= to && Mathf.Max(0f, hang) + num >= from)
			{
				return rise;
			}
			return Mathf.Max(JumpHeight(rise, hang, from), JumpHeight(rise, hang, to));
		}

		public static float JumpReportWindow(float pingMs, float interpolationSeconds)
		{
			return Mathf.Max(0f, interpolationSeconds) + Mathf.Max(0f, pingMs) * SlackPingFactor / 1000f + SlackFixedSeconds;
		}

		public static float JumpWindupSeconds(int level, Vector2 range)
		{
			return Mathf.Max(0.3f, ByLevel(range, level));
		}

		public static float HearingRadius(float radius, float hearingMultiplier, bool blocked, float wallFactor)
		{
			float num = (blocked ? Mathf.Clamp01(wallFactor) : 1f);
			return Mathf.Max(0f, radius) * Mathf.Max(0f, hearingMultiplier) * num;
		}

		public static bool Hears(float distance, float radius, float hearingMultiplier, bool blocked, float wallFactor)
		{
			return HearingRadius(radius, hearingMultiplier, blocked, wallFactor) >= distance;
		}

		public static bool NeedsWallTest(float distance, float radius, float hearingMultiplier, float wallFactor)
		{
			float num = Mathf.Max(0f, radius) * Mathf.Max(0f, hearingMultiplier);
			if (num < distance)
			{
				return false;
			}
			return num * Mathf.Clamp01(wallFactor) < distance;
		}

		public static float ClientNoiseRadius(FnNoise kind, float reported, float footstepRadius, float voiceMaxRadius)
		{
			if (reported <= 0f)
			{
				return 0f;
			}
			return kind switch
			{
				FnNoise.Footsteps => Mathf.Min(reported, Mathf.Max(0f, footstepRadius)),
				FnNoise.Voice => Mathf.Min(reported, Mathf.Max(0f, voiceMaxRadius)),
				_ => 0f,
			};
		}

		public static Vector3 ClampNear(Vector3 point, Vector3 anchor, float maxDistance)
		{
			Vector3 vector = point - anchor;
			float magnitude = vector.magnitude;
			if (magnitude <= maxDistance || magnitude < 1E-06f)
			{
				return point;
			}
			return anchor + vector * (maxDistance / magnitude);
		}

		public static bool IsFinite(Vector3 v)
		{
			if (!float.IsNaN(v.x) && !float.IsNaN(v.y) && !float.IsNaN(v.z) && !float.IsInfinity(v.x) && !float.IsInfinity(v.y))
			{
				return !float.IsInfinity(v.z);
			}
			return false;
		}

		public static bool TakeToken(ref float tokens, ref double lastRefill, double now, float perSecond)
		{
			double num = now - lastRefill;
			lastRefill = now;
			float num2 = Mathf.Max(0f, perSecond);
			float a = Mathf.Max(1f, num2);
			float num3 = ((num > 60.0 || num < 0.0) ? 60f : ((float)num));
			tokens = Mathf.Min(a, tokens + num2 * num3);
			if (tokens >= 1f)
			{
				tokens -= 1f;
				return true;
			}
			return false;
		}

		public static float CoveFillSeconds(float movementInterval, int level, int stages, float scale = 1f)
		{
			if (level < 1)
			{
				return float.PositiveInfinity;
			}
			float num = Mathf.Max(0.5f, movementInterval) * (float)Mathf.Max(1, stages) * (float)MaxLevel / (float)Mathf.Min(level, MaxLevel);
			return Mathf.Max(0f, scale) * num;
		}

		public static float StepCove(float progress, bool watched, float fillSeconds, float decaySeconds, float dt)
		{
			if (dt > 0f)
			{
				if (watched)
				{
					if (decaySeconds <= 0.0001f)
					{
						return 0f;
					}
					progress -= dt / decaySeconds;
				}
				else if (!float.IsInfinity(fillSeconds))
				{
					if (fillSeconds <= 0.0001f)
					{
						return 1f;
					}
					progress += dt / fillSeconds;
				}
			}
			return Mathf.Clamp01(progress);
		}

		public static float StepRepel(float timer, bool lit, float dt)
		{
			dt = Mathf.Max(0f, dt);
			if (lit)
			{
				return timer + dt;
			}
			return Mathf.Max(0f, timer - dt * 2f);
		}

		public static float YawOf(Vector3 direction)
		{
			return Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
		}

		public static void LookAngles(Vector3 eye, Vector3 point, float bodyYaw, float maxYaw, float maxPitch, out float yaw, out float pitch)
		{
			Vector3 vector = point - eye;
			float num = Mathf.Sqrt(vector.x * vector.x + vector.z * vector.z);
			yaw = 0f;
			if (num > 0.0001f)
			{
				yaw = Mathf.Clamp(Mathf.DeltaAngle(bodyYaw, Mathf.Atan2(vector.x, vector.z) * Mathf.Rad2Deg), 0f - maxYaw, maxYaw);
			}
			pitch = Mathf.Clamp(Mathf.Atan2(vector.y, num) * Mathf.Rad2Deg, 0f - maxPitch, maxPitch);
		}

		public static Vector3 LookDirection(float bodyYaw, float headYaw, float headPitch)
		{
			return Quaternion.Euler(0f - headPitch, bodyYaw + headYaw, 0f) * Vector3.forward;
		}

		public static Vector3 DoorStandPoint(Vector3 outside, Vector3 doorway, float depth, float lateral)
		{
			Vector3 vector = doorway - outside;
			vector.y = 0f;
			if (vector.sqrMagnitude < 1E-06f)
			{
				return outside;
			}
			vector = vector.normalized;
			return doorway - vector * Mathf.Max(0f, depth) + Vector3.Cross(Vector3.up, vector) * lateral;
		}

		public static bool SegmentCrossesDoor(Vector3 from, Vector3 to, Vector3 doorPoint, Vector3 doorNormal, float halfWidth)
		{
			float num = Vector3.Dot(from - doorPoint, doorNormal);
			float num2 = Vector3.Dot(to - doorPoint, doorNormal);
			if (num > 0f && num2 > 0f)
			{
				return false;
			}
			if (num < 0f && num2 < 0f)
			{
				return false;
			}
			if (Mathf.Abs(num - num2) < 1E-06f)
			{
				return false;
			}
			float num3 = num / (num - num2);
			Vector3 vector = from + (to - from) * num3 - doorPoint;
			Vector3 vector2 = vector - doorNormal * Vector3.Dot(doorNormal, vector);
			if (vector2.x * vector2.x + vector2.z * vector2.z > halfWidth * halfWidth)
			{
				return false;
			}
			if (vector.y < 4f)
			{
				return vector.y > -1.5f;
			}
			return false;
		}

		public static bool InViewFrustum(Vector3 localPoint, float verticalFovDeg, float aspect, float near, float far, float margin)
		{
			if (localPoint.z <= near || localPoint.z > far)
			{
				return false;
			}
			float num = Mathf.Tan(Mathf.Clamp(verticalFovDeg, 1f, 179f) * 0.5f * Mathf.Deg2Rad) * Mathf.Clamp(margin, 0.1f, 1f);
			if (Mathf.Abs(localPoint.x) > localPoint.z * (Mathf.Max(0.1f, aspect) * num))
			{
				return false;
			}
			return Mathf.Abs(localPoint.y) <= localPoint.z * num;
		}

		public static float AdvanceGait(float gait, float distance, float strideLength)
		{
			return Mathf.Repeat(gait + Mathf.Max(0f, distance) / Mathf.Max(0.1f, strideLength), 1f);
		}

		public static float GaitDelta(float from, float to)
		{
			return Mathf.Repeat(to - from, 1f);
		}
	}
}
