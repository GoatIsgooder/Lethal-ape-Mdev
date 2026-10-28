using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnGhostRules
	{
		public const int NoTarget = 0;

		public static bool GhostVisible(bool viewerIsGhost, bool viewerInResultsOrOutsideNight)
		{
			return viewerIsGhost || viewerInResultsOrOutsideNight;
		}

		public static float CatchLinger(float lungeSeconds, float caughtFadeSeconds)
		{
			return Mathf.Max(0f, lungeSeconds) + Mathf.Max(0f, caughtFadeSeconds);
		}

		public static bool PresentsAsGhost(bool caught, double secondsSinceCaught, float linger)
		{
			return caught && secondsSinceCaught >= (double)linger;
		}

		public static FnAvatarLook AvatarLook(bool presentsAsGhost, bool viewerIsGhost, bool viewerInResultsOrOutsideNight)
		{
			if (!presentsAsGhost || viewerInResultsOrOutsideNight)
			{
				return FnAvatarLook.Ape;
			}
			if (!viewerIsGhost)
			{
				return FnAvatarLook.Hidden;
			}
			return FnAvatarLook.Skeleton;
		}

		public static bool CollidersOff(bool presentsAsGhost, bool isOwner)
		{
			return presentsAsGhost && !isOwner;
		}

		public static float GibberishGain(float distance, float fullWithin, float silentBeyond)
		{
			if (distance <= fullWithin)
			{
				return 1f;
			}
			if (distance >= silentBeyond)
			{
				return 0f;
			}
			return 1f - (distance - fullWithin) / (silentBeyond - fullWithin);
		}

		public static bool ScrambleActive(bool ownerIsGhost, bool localIsAlive, float distance, float silentBeyond, bool whispersEnabled)
		{
			return ownerIsGhost && localIsAlive && whispersEnabled && distance < silentBeyond;
		}

		public static FnVoiceMode VoiceMode(bool ownerIsGhost, bool localIsAlive, float distance, float silentBeyond, bool whispersEnabled)
		{
			if (!ownerIsGhost || !localIsAlive)
			{
				return FnVoiceMode.Plain;
			}
			if (whispersEnabled && distance < silentBeyond)
			{
				return FnVoiceMode.Scrambled;
			}
			return FnVoiceMode.Silent;
		}

		public static int AnimTarget(FnAnim anim)
		{
			return -1 - (int)anim;
		}

		public static bool IsAnimTarget(int target)
		{
			return target < 0;
		}

		public static FnAnim AnimOf(int target)
		{
			return (FnAnim)(-1 - target);
		}

		public static int FollowCandidates(int[] living, int livingCount, int animAvailableMask, int self, int[] into)
		{
			if (into == null)
			{
				return 0;
			}
			int count = 0;
			if (living != null)
			{
				int n = Math.Min(livingCount, living.Length);
				for (int i = 0; i < n && count < into.Length; i++)
				{
					int actor = living[i];
					if (actor <= 0 || actor == self || IndexOf(into, count, actor) >= 0)
					{
						continue;
					}
					int j = count;
					while (j > 0 && into[j - 1] > actor)
					{
						into[j] = into[j - 1];
						j--;
					}
					into[j] = actor;
					count++;
				}
			}
			for (int k = 0; k < 4 && count < into.Length; k++)
			{
				if (((animAvailableMask >> k) & 1) != 0)
				{
					into[count++] = AnimTarget((FnAnim)k);
				}
			}
			return count;
		}

		public static int NextFollowTarget(int[] candidates, int count, int current)
		{
			if (candidates == null || count < 1)
			{
				return 0;
			}
			int n = Math.Min(count, candidates.Length);
			long currentKey = ((current == 0) ? long.MinValue : OrderKey(current));
			int next = 0;
			long nextKey = long.MaxValue;
			int first = 0;
			long firstKey = long.MaxValue;
			for (int i = 0; i < n; i++)
			{
				int c = candidates[i];
				if (c == 0)
				{
					continue;
				}
				long key = OrderKey(c);
				if (key < firstKey)
				{
					firstKey = key;
					first = c;
				}
				if (key > currentKey && key < nextKey)
				{
					nextKey = key;
					next = c;
				}
			}
			if (next == 0)
			{
				return first;
			}
			return next;
		}

		private static long OrderKey(int target)
		{
			if (target > 0)
			{
				return target;
			}
			return 2147483647L - target;
		}

		private static int IndexOf(int[] a, int count, int value)
		{
			for (int i = 0; i < count; i++)
			{
				if (a[i] == value)
				{
					return i;
				}
			}
			return -1;
		}

		public static float FollowRoom(float backDistance, float hitDistance, float wallMargin)
		{
			if (hitDistance < 0f)
			{
				return backDistance;
			}
			return Mathf.Clamp(hitDistance - wallMargin, 0f, backDistance);
		}

		public static Vector3 FollowPoint(Vector3 targetHead, Vector3 targetForward, float backDistance, float hitDistance, float wallMargin)
		{
			Vector3 flat = FlatForward(targetForward);
			return targetHead - flat * FollowRoom(backDistance, hitDistance, wallMargin);
		}

		public static Vector3 FlatForward(Vector3 forward)
		{
			Vector3 flat = new Vector3(forward.x, 0f, forward.z);
			if (flat.sqrMagnitude > 1E-06f)
			{
				return flat.normalized;
			}
			return Vector3.forward;
		}

		public static float Yaw(Vector3 flat)
		{
			return Mathf.Atan2(flat.x, flat.z) * Mathf.Rad2Deg;
		}

		public static int FreestSpawn(Vector3[] spawns, int spawnCount, Vector3[] others, int otherCount, int preferred, float clearRadius)
		{
			if (spawns == null || spawnCount < 1)
			{
				return -1;
			}
			spawnCount = Math.Min(spawnCount, spawns.Length);
			otherCount = ((others != null) ? Math.Min(otherCount, others.Length) : 0);
			if (preferred >= 0 && preferred < spawnCount && NearestSqr(spawns[preferred], others, otherCount) > clearRadius * clearRadius)
			{
				return preferred;
			}
			int best = 0;
			float bestSqr = -1f;
			for (int i = 0; i < spawnCount; i++)
			{
				float sqr = NearestSqr(spawns[i], others, otherCount);
				if (sqr > bestSqr)
				{
					bestSqr = sqr;
					best = i;
				}
			}
			return best;
		}

		private static float NearestSqr(Vector3 p, Vector3[] others, int count)
		{
			float best = float.MaxValue;
			for (int i = 0; i < count; i++)
			{
				float dx = others[i].x - p.x;
				float dz = others[i].z - p.z;
				float sqr = dx * dx + dz * dz;
				if (sqr < best)
				{
					best = sqr;
				}
			}
			return best;
		}

		public static string PanelLabel(string raw, int maxChars)
		{
			if (raw == null || maxChars < 1 || raw.Length == 0)
			{
				return "";
			}
			char[] buffer = new char[Math.Min(raw.Length, maxChars)];
			int n = 0;
			for (int i = 0; i < raw.Length && n < buffer.Length; i++)
			{
				char c = raw[i];
				if (c >= 'a' && c <= 'z')
				{
					c = (char)(c - 32);
				}
				if (c >= ' ' && c <= '~' && (c != ' ' || (n != 0 && buffer[n - 1] != ' ')))
				{
					buffer[n++] = c;
				}
			}
			while (n > 0 && buffer[n - 1] == ' ')
			{
				n--;
			}
			return new string(buffer, 0, n);
		}

		public static Vector3 LungeDirection(Vector3 eyeForward, Vector3 eyeUp, float maxPitchDegrees)
		{
			Vector3 flat;
			if (eyeForward.x * eyeForward.x + eyeForward.z * eyeForward.z < 0.0001f)
			{
				flat = new Vector3(eyeUp.x, 0f, eyeUp.z) * ((eyeForward.y < 0f) ? 1f : (-1f));
			}
			else
			{
				flat = new Vector3(eyeForward.x, 0f, eyeForward.z);
			}
			flat = ((flat.sqrMagnitude > 1E-06f) ? flat.normalized : Vector3.forward);
			float pitch = Mathf.Asin(Mathf.Clamp(eyeForward.normalized.y, -1f, 1f)) * Mathf.Rad2Deg;
			float limit = Mathf.Clamp(maxPitchDegrees, 0f, 89f);
			pitch = Mathf.Clamp(pitch, 0f - limit, limit);
			float rad = pitch * Mathf.Deg2Rad;
			return flat * Mathf.Cos(rad) + Vector3.up * Mathf.Sin(rad);
		}

		public static float LungeDistance(float t, float from, float to, float hold)
		{
			float k = Mathf.Clamp01((t - hold) / Mathf.Max(0.001f, 1f - hold));
			return Mathf.Lerp(from, to, k * k);
		}

		public static bool IsThreatState(FnAiState state)
		{
			if (state != FnAiState.Dormant)
			{
				return state != FnAiState.PoweredDown;
			}
			return false;
		}

		public static bool ChasingYou(FnAiState state, int target, int self)
		{
			if (state == FnAiState.Chase && target == self)
			{
				return self > 0;
			}
			return false;
		}

		public static float ProximityThreat(float distance, float fullWithin, float nearWithin)
		{
			if (distance >= nearWithin)
			{
				return 0f;
			}
			if (distance <= fullWithin)
			{
				return 1f;
			}
			return 1f - (distance - fullWithin) / (nearWithin - fullWithin);
		}

		public static int BeatIndex(double seconds, float hz)
		{
			return (int)Math.Floor(Math.Max(seconds, 0.0) * (double)Math.Max(hz, 0.1f));
		}
	}
}
