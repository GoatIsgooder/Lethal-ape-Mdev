using System;
using System.Collections.Generic;
using LALocomotion;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Pumpkin
{
	public static class PumpkinRig
	{
		private sealed class RoomAvatars : IPumpkinAvatarSource
		{
			public static readonly RoomAvatars Shared = new RoomAvatars();

			public void Collect(List<PumpkinAvatar> into)
			{
				into.Clear();
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				if (manager == null)
				{
					return;
				}
				List<MonkeDevNetworkingPlayer> players = manager.Players;
				if (players == null)
				{
					return;
				}
				for (int i = 0; i < players.Count; i++)
				{
					if (TryMake(players[i], out var avatar))
					{
						into.Add(avatar);
					}
				}
			}

			public bool TryFind(int actor, out PumpkinAvatar avatar)
			{
				avatar = default(PumpkinAvatar);
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				if (manager != null && actor > 0)
				{
					return TryMake(manager.GetPlayerByActorId(actor), out avatar);
				}
				return false;
			}

			private static bool TryMake(MonkeDevNetworkingPlayer np, out PumpkinAvatar avatar)
			{
				avatar = default(PumpkinAvatar);
				if (np == null || !np.isActiveAndEnabled || np.NetworkHidden || np.Head == null || np.LeftHand == null || np.RightHand == null)
				{
					return false;
				}
				PhotonView photonView = np.photonView;
				if (photonView == null || photonView.ViewID == 0 || photonView.IsMine)
				{
					return false;
				}
				avatar.actor = photonView.OwnerActorNr;
				avatar.head = np.Head;
				avatar.leftHand = np.LeftHand;
				avatar.rightHand = np.RightHand;
				avatar.scale = Mathf.Max(0.1f, np.Head.localScale.x);
				return true;
			}
		}

		public const float AvatarHeadRadius = 0.2f;

		public const float AvatarTorsoTop = 0.25f;

		public const float AvatarTorsoBottom = 0.8f;

		public const float AvatarTorsoRadius = 0.2f;

		public static IPumpkinAvatarSource AvatarSourceOverride { get; set; }

		public static IPumpkinAvatarSource Avatars => AvatarSourceOverride ?? RoomAvatars.Shared;

		public static UnityEngine.Object LocalInstigator => LAPlayer.Instance;

		public static Func<bool, Transform> SyncedHandOverride { get; set; }

		public static bool IsPinnedTo(Collider c)
		{
			LAPlayer instance = LAPlayer.Instance;
			if (instance != null && instance.isActiveAndEnabled)
			{
				return instance.IsPinnedTo(c);
			}
			return false;
		}

		public static bool PinnedHand(Collider c, out bool left)
		{
			left = false;
			LAPlayer instance = LAPlayer.Instance;
			if (instance == null || !instance.isActiveAndEnabled || c == null)
			{
				return false;
			}
			if (instance.IsPinnedTo(c, true))
			{
				left = true;
				return true;
			}
			return instance.IsPinnedTo(c, false);
		}

		public static Transform SyncedHand(bool left)
		{
			if (SyncedHandOverride != null)
			{
				return SyncedHandOverride(left);
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return null;
			}
			return left ? manager.LeftHand : manager.RightHand;
		}

		public static bool TryGetLocalBody(out PumpkinBody body)
		{
			body = default(PumpkinBody);
			LAPlayer instance = LAPlayer.Instance;
			if (instance == null || !instance.isActiveAndEnabled || instance.headCollider == null)
			{
				return false;
			}
			body.head = instance.HeadPosition;
			body.headRadius = instance.HeadRadius;
			CapsuleCollider bodyCollider = instance.bodyCollider;
			if (bodyCollider != null && bodyCollider.enabled)
			{
				CapsuleSegment(bodyCollider, out body.torsoTop, out body.torsoBottom, out body.torsoRadius);
				return true;
			}
			body.torsoTop = body.head;
			body.torsoBottom = body.head;
			body.torsoRadius = 0f;
			return true;
		}

		private static void CapsuleSegment(CapsuleCollider c, out Vector3 a, out Vector3 b, out float radius)
		{
			Transform transform = c.transform;
			Vector3 lossyScale = transform.lossyScale;
			Vector3 axis;
			float along;
			float across;
			switch (c.direction)
			{
			case 0:
				axis = Vector3.right;
				along = Mathf.Abs(lossyScale.x);
				across = Mathf.Max(Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z));
				break;
			case 2:
				axis = Vector3.forward;
				along = Mathf.Abs(lossyScale.z);
				across = Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y));
				break;
			default:
				axis = Vector3.up;
				along = Mathf.Abs(lossyScale.y);
				across = Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.z));
				break;
			}
			radius = across * c.radius;
			float half = Mathf.Max(0f, along * c.height * 0.5f - radius);
			Vector3 center = transform.TransformPoint(c.center);
			Vector3 dir = transform.TransformDirection(axis) * half;
			a = center + dir;
			b = center - dir;
		}

		public static bool Sweep(Vector3 from, Vector3 delta, float radius, in PumpkinBody body, out float t, out Vector3 normal)
		{
			bool hit = SweepCapsule(from, delta, radius, body.head, body.head, body.headRadius, out t, out normal);
			if (body.torsoRadius > 0f && SweepCapsule(from, delta, radius, body.torsoTop, body.torsoBottom, body.torsoRadius, out var t2, out var n2))
			{
				if (!hit || t2 < t)
				{
					t = t2;
					normal = n2;
				}
				hit = true;
			}
			return hit;
		}

		public static float DistanceTo(in PumpkinBody body, Vector3 point)
		{
			float d = Vector3.Distance(point, body.head) - body.headRadius;
			if (body.torsoRadius > 0f)
			{
				d = Mathf.Min(d, Vector3.Distance(point, ClosestOnSegment(point, body.torsoTop, body.torsoBottom)) - body.torsoRadius);
			}
			return Mathf.Max(0f, d);
		}

		private static bool SweepCapsule(Vector3 from, Vector3 delta, float radius, Vector3 a, Vector3 b, float capRadius, out float t, out Vector3 normal)
		{
			t = 0f;
			float r = radius + capRadius;
			float r2 = r * r;
			normal = Vector3.zero;
			if ((from - ClosestOnSegment(from, a, b)).sqrMagnitude <= r2)
			{
				normal = Away(from, a, b, delta);
				return true;
			}
			if (delta.sqrMagnitude < 1E-12f)
			{
				return false;
			}
			ClosestBetweenSegments(from, from + delta, a, b, out var s, out var _);
			Vector3 p = from + delta * s;
			if ((p - ClosestOnSegment(p, a, b)).sqrMagnitude > r2)
			{
				return false;
			}
			float lo = 0f;
			float hi = s;
			for (int i = 0; i < 12; i++)
			{
				float mid = (lo + hi) * 0.5f;
				Vector3 q = from + delta * mid;
				if ((q - ClosestOnSegment(q, a, b)).sqrMagnitude > r2)
				{
					lo = mid;
				}
				else
				{
					hi = mid;
				}
			}
			t = hi;
			normal = Away(from + delta * hi, a, b, delta);
			return true;
		}

		private static Vector3 Away(Vector3 p, Vector3 a, Vector3 b, Vector3 delta)
		{
			Vector3 off = p - ClosestOnSegment(p, a, b);
			if (off.sqrMagnitude > 1E-08f)
			{
				return off.normalized;
			}
			if (delta.sqrMagnitude > 1E-08f)
			{
				return -delta.normalized;
			}
			return Vector3.up;
		}

		public static Vector3 ClosestOnSegment(Vector3 p, Vector3 a, Vector3 b)
		{
			Vector3 ab = b - a;
			float len2 = Vector3.Dot(ab, ab);
			if (len2 < 1E-10f)
			{
				return a;
			}
			float t = Mathf.Clamp01(Vector3.Dot(p - a, ab) / len2);
			return a + ab * t;
		}

		private static void ClosestBetweenSegments(Vector3 p1, Vector3 q1, Vector3 p2, Vector3 q2, out float s, out float u)
		{
			Vector3 d1 = q1 - p1;
			Vector3 d2 = q2 - p2;
			Vector3 r = p1 - p2;
			float a = Vector3.Dot(d1, d1);
			float e = Vector3.Dot(d2, d2);
			float f = Vector3.Dot(d2, r);
			if (a <= 1E-10f && e <= 1E-10f)
			{
				s = 0f;
				u = 0f;
				return;
			}
			if (a <= 1E-10f)
			{
				s = 0f;
				u = Mathf.Clamp01(f / e);
				return;
			}
			float c = Vector3.Dot(d1, r);
			if (e <= 1E-10f)
			{
				u = 0f;
				s = Mathf.Clamp01(-c / a);
				return;
			}
			float bb = Vector3.Dot(d1, d2);
			float denom = a * e - bb * bb;
			s = denom > 1E-10f ? Mathf.Clamp01((bb * f - c * e) / denom) : 0f;
			u = (bb * s + f) / e;
			if (u < 0f)
			{
				u = 0f;
				s = Mathf.Clamp01(-c / a);
			}
			else if (u > 1f)
			{
				u = 1f;
				s = Mathf.Clamp01((bb - c) / a);
			}
		}
	}
}
