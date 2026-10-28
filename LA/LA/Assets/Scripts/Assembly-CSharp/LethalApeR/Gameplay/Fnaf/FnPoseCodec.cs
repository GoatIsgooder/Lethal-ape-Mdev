using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnPoseCodec
	{
		[StructLayout((LayoutKind)2)]
		private struct FloatBits
		{
			[FieldOffset(0)]
			public float F;

			[FieldOffset(0)]
			public uint U;
		}

		public const byte Format = 1;

		public const int HeaderSize = 8;

		public const int PoseSize = 22;

		public const int MaxPoses = 4;

		public const int MaxPacketSize = 96;

		public const byte FlagEyesLit = 1;

		public const byte FlagFrozen = 2;

		public const byte FlagLunging = 4;

		public const byte FlagSprinting = 8;

		public const byte FlagPoweredDown = 16;

		public const byte FlagJumpCharge = 32;

		public const byte FlagAirborne = 64;

		public static int PacketSize(int count)
		{
			return 8 + count * 22;
		}

		public static void WriteHeader(byte[] b, int count, int serverTimestamp, ushort sequence)
		{
			b[0] = 1;
			b[1] = (byte)count;
			int o = 2;
			WriteInt(b, ref o, serverTimestamp);
			WriteUShort(b, ref o, sequence);
		}

		public static bool ReadHeader(byte[] b, out int count, out int serverTimestamp, out ushort sequence)
		{
			count = 0;
			serverTimestamp = 0;
			sequence = 0;
			if (b == null || b.Length < 8 || b[0] != 1)
			{
				return false;
			}
			count = b[1];
			if (count < 1 || count > 4 || PacketSize(count) > b.Length)
			{
				return false;
			}
			int o = 2;
			serverTimestamp = ReadInt(b, ref o);
			sequence = ReadUShort(b, ref o);
			return true;
		}

		public static void WritePose(byte[] b, int index, in FnPoseSample p)
		{
			int o = 8 + index * 22;
			b[o++] = p.Id;
			WriteFloat(b, ref o, p.Position.x);
			WriteFloat(b, ref o, p.Position.y);
			WriteFloat(b, ref o, p.Position.z);
			WriteUShort(b, ref o, YawToWire(p.Yaw));
			b[o++] = (byte)HeadYawToWire(p.HeadYaw);
			b[o++] = (byte)HeadPitchToWire(p.HeadPitch);
			b[o++] = (byte)p.State;
			b[o++] = SpeedToWire(p.Speed);
			b[o++] = p.Flags;
			WriteUShort(b, ref o, GaitToWire(p.Gait));
		}

		public static void ReadPose(byte[] b, int index, out FnPoseSample p)
		{
			p = default(FnPoseSample);
			int o = 8 + index * 22;
			p.Id = b[o++];
			p.Position = new Vector3(ReadFloat(b, ref o), ReadFloat(b, ref o), ReadFloat(b, ref o));
			p.Yaw = WireToYaw(ReadUShort(b, ref o));
			p.HeadYaw = WireToHeadYaw((sbyte)b[o++]);
			p.HeadPitch = WireToHeadPitch((sbyte)b[o++]);
			p.State = (FnAiState)b[o++];
			p.Speed = WireToSpeed(b[o++]);
			p.Flags = b[o++];
			p.Gait = WireToGait(ReadUShort(b, ref o));
		}

		public static bool SequenceNewer(ushort candidate, ushort last)
		{
			return (short)(candidate - last) > 0;
		}

		public static ushort YawToWire(float yawDegrees)
		{
			if (!float.IsFinite(yawDegrees))
			{
				return 0;
			}
			return (ushort)Math.Round((double)yawDegrees / 360.0 * 65536.0);
		}

		public static float WireToYaw(ushort raw)
		{
			return (float)(int)raw * (360f / 65536f);
		}

		public static sbyte HeadYawToWire(float degrees)
		{
			if (float.IsNaN(degrees))
			{
				return 0;
			}
			return (sbyte)Mathf.Clamp((int)Math.Round(Mathf.DeltaAngle(0f, degrees) / 180f * 127f), -127, 127);
		}

		public static float WireToHeadYaw(sbyte raw)
		{
			return (float)raw * (180f / 127f);
		}

		public static sbyte HeadPitchToWire(float degrees)
		{
			if (float.IsNaN(degrees))
			{
				return 0;
			}
			return (sbyte)Mathf.Clamp((int)Math.Round(Mathf.Clamp(degrees, -90f, 90f) / 90f * 127f), -127, 127);
		}

		public static float WireToHeadPitch(sbyte raw)
		{
			return (float)raw * (90f / 127f);
		}

		public static byte SpeedToWire(float metresPerSecond)
		{
			if (metresPerSecond <= 0f)
			{
				return 0;
			}
			return (byte)Mathf.Clamp((int)Math.Round(metresPerSecond * 20f), 0, 255);
		}

		public static float WireToSpeed(byte raw)
		{
			return (float)(int)raw / 20f;
		}

		public static ushort GaitToWire(float phase)
		{
			if (!float.IsFinite(phase))
			{
				return 0;
			}
			return (ushort)Mathf.Clamp((int)Math.Round(Mathf.Repeat(phase, 1f) * 65535f), 0, 65535);
		}

		public static float WireToGait(ushort raw)
		{
			return (float)(int)raw / 65535f;
		}

		private static void WriteFloat(byte[] b, ref int o, float v)
		{
			uint u = new FloatBits
			{
				F = v
			}.U;
			b[o++] = (byte)u;
			b[o++] = (byte)(u >> 8);
			b[o++] = (byte)(u >> 16);
			b[o++] = (byte)(u >> 24);
		}

		private static float ReadFloat(byte[] b, ref int o)
		{
			FloatBits floatBits = new FloatBits
			{
				U = (uint)(b[o] | (b[o + 1] << 8) | (b[o + 2] << 16) | (b[o + 3] << 24))
			};
			o += 4;
			return floatBits.F;
		}

		private static void WriteInt(byte[] b, ref int o, int v)
		{
			b[o++] = (byte)v;
			b[o++] = (byte)(v >> 8);
			b[o++] = (byte)(v >> 16);
			b[o++] = (byte)(v >> 24);
		}

		private static int ReadInt(byte[] b, ref int o)
		{
			int result = b[o] | (b[o + 1] << 8) | (b[o + 2] << 16) | (b[o + 3] << 24);
			o += 4;
			return result;
		}

		private static void WriteUShort(byte[] b, ref int o, ushort v)
		{
			b[o++] = (byte)v;
			b[o++] = (byte)(v >> 8);
		}

		private static ushort ReadUShort(byte[] b, ref int o)
		{
			ushort result = (ushort)(b[o] | (b[o + 1] << 8));
			o += 2;
			return result;
		}
	}
}
