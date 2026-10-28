using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public sealed class FnPoseRing
	{
		private struct Snap
		{
			public int Ts;

			public FnPoseSample Pose;
		}

		public const int Size = 8;

		public const int ExtrapolateMs = 150;

		public const float RestSpeed = 0.05f;

		private readonly Snap[] _snaps = new Snap[8];

		private int _start;

		private int _count;

		public int Count => _count;

		public bool TryNewest(out int ts)
		{
			ts = ((_count > 0) ? _snaps[Index(_count - 1)].Ts : 0);
			return _count > 0;
		}

		private int Index(int k)
		{
			return (_start + k) % 8;
		}

		private void Append(int ts, in FnPoseSample pose)
		{
			if (_count == 8)
			{
				_start = (_start + 1) % 8;
				_count--;
			}
			_snaps[Index(_count)] = new Snap
			{
				Ts = ts,
				Pose = pose
			};
			_count++;
		}

		public void Hold(in FnPoseSample pose, int ts)
		{
			_start = 0;
			_count = 0;
			Append(ts, in pose);
		}

		public void Glide(in FnPoseSample from, in FnPoseSample to, int renderTs, int milliseconds)
		{
			_start = 0;
			_count = 0;
			Append(renderTs, in from);
			Append(renderTs + Mathf.Max(1, milliseconds), in to);
		}

		public void Push(int ts, in FnPoseSample pose, int sendIntervalMs, bool hasDrawn, Vector3 drawn)
		{
			if (_count > 0)
			{
				Snap snap = _snaps[Index(_count - 1)];
				int num = ts - snap.Ts;
				if (num <= 0)
				{
					return;
				}
				if (hasDrawn && (pose.Position - drawn).sqrMagnitude > 9f)
				{
					_start = 0;
					_count = 0;
				}
				else if (num > sendIntervalMs * 2 + 50 && snap.Pose.Speed < 0.05f)
				{
					int num2 = ts - sendIntervalMs;
					if (num2 > snap.Ts)
					{
						Append(num2, in snap.Pose);
					}
				}
			}
			Append(ts, in pose);
		}

		public bool Sample(int renderTs, out FnPoseSample pose, out Vector3 velocity)
		{
			velocity = Vector3.zero;
			pose = default(FnPoseSample);
			if (_count == 0)
			{
				return false;
			}
			for (int num = _count - 1; num >= 0; num--)
			{
				Snap snap = _snaps[Index(num)];
				if (snap.Ts > renderTs)
				{
					continue;
				}
				if (num == _count - 1)
				{
					pose = snap.Pose;
					if (_count < 2 || snap.Pose.Speed < 0.05f)
					{
						return true;
					}
					Snap snap2 = _snaps[Index(num - 1)];
					int num2 = snap.Ts - snap2.Ts;
					if (num2 <= 0 || num2 > 500)
					{
						return true;
					}
					Vector3 vector = (snap.Pose.Position - snap2.Pose.Position) * (1000f / (float)num2);
					int num3 = renderTs - snap.Ts;
					pose.Position = snap.Pose.Position + vector * ((float)Mathf.Min(num3, 150) / 1000f);
					if (num3 <= 150)
					{
						velocity = vector;
					}
					return true;
				}
				Snap snap3 = _snaps[Index(num + 1)];
				int num4 = snap3.Ts - snap.Ts;
				float t = ((num4 > 0) ? Mathf.Clamp01((float)(renderTs - snap.Ts) / (float)num4) : 1f);
				pose.Id = snap.Pose.Id;
				pose.Position = Vector3.LerpUnclamped(snap.Pose.Position, snap3.Pose.Position, t);
				pose.State = snap.Pose.State;
				pose.Flags = snap.Pose.Flags;
				pose.Yaw = Mathf.LerpAngle(snap.Pose.Yaw, snap3.Pose.Yaw, t);
				pose.HeadYaw = Mathf.LerpAngle(snap.Pose.HeadYaw, snap3.Pose.HeadYaw, t);
				pose.HeadPitch = Mathf.Lerp(snap.Pose.HeadPitch, snap3.Pose.HeadPitch, t);
				pose.Speed = Mathf.Lerp(snap.Pose.Speed, snap3.Pose.Speed, t);
				pose.Gait = Mathf.Repeat(snap.Pose.Gait + Mathf.Repeat(snap3.Pose.Gait - snap.Pose.Gait, 1f) * t, 1f);
				if (num4 > 0)
				{
					velocity = (snap3.Pose.Position - snap.Pose.Position) * (1000f / (float)num4);
				}
				return true;
			}
			pose = _snaps[Index(0)].Pose;
			return true;
		}
	}
}
