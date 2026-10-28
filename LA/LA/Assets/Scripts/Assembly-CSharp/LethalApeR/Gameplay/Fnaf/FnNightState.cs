using System;
using ExitGames.Client.Photon;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public sealed class FnNightState
	{
		public bool HasPhase;

		public FnPhase Phase;

		public double PhaseStart;

		public double PhaseEnd;

		public double NightStart;

		public float HourSeconds = 70f;

		public int Night = 1;

		public FnDifficulty Difficulty;

		public int TeamSize = 1;

		public int Arrived;

		public string[] Roster = Array.Empty<string>();

		public int[] GuardActors = Array.Empty<int>();

		public string[] GuardNames = Array.Empty<string>();

		public string[] GuardBuilds = Array.Empty<string>();

		public byte[] GuardStatus = Array.Empty<byte>();

		public double[] GuardTimes = Array.Empty<double>();

		public float Power = 100f;

		public double PowerStamp;

		public float PowerRate;

		public double Blackout;

		public double BlackoutEnd;

		public byte Doors;

		public byte Jams;

		public byte Lights;

		public double LureReady;

		public byte FuseUses;

		public byte[] FuseOrder = new byte[3];

		public byte FuseProgress;

		public byte[] BatteryStates = Array.Empty<byte>();

		public int[] BatteryArgs = Array.Empty<int>();

		public float[] BatteryDrops = Array.Empty<float>();

		public byte BatteriesDelivered;

		public byte Outcome;

		public float PowerAt(double now)
		{
			double num = now - PowerStamp;
			if (num < -2147483.648)
			{
				num += 4294967.296;
			}
			else if (num > 2147483.648)
			{
				num -= 4294967.296;
			}
			return Mathf.Clamp(Power - PowerRate * (float)Math.Max(0.0, num), 0f, 100f);
		}

		public int SlotOfActor(int actor)
		{
			if (actor > 0)
			{
				for (int i = 0; i < GuardActors.Length; i++)
				{
					if (GuardActors[i] == actor)
					{
						return i;
					}
				}
			}
			return -1;
		}

		public int SlotOfUser(string userId)
		{
			if (string.IsNullOrEmpty(userId))
			{
				return -1;
			}
			for (int i = 0; i < Roster.Length; i++)
			{
				if (Roster[i] == userId)
				{
					return i;
				}
			}
			return -1;
		}

		public FnGuardStatus StatusOf(int slot)
		{
			if (slot < 0 || slot >= GuardStatus.Length)
			{
				return FnGuardStatus.Absent;
			}
			return (FnGuardStatus)GuardStatus[slot];
		}

		public FnNightState Clone()
		{
			FnNightState obj = (FnNightState)MemberwiseClone();
			obj.Roster = (string[])Roster.Clone();
			obj.GuardActors = (int[])GuardActors.Clone();
			obj.GuardNames = (string[])GuardNames.Clone();
			obj.GuardBuilds = (string[])GuardBuilds.Clone();
			obj.GuardStatus = (byte[])GuardStatus.Clone();
			obj.GuardTimes = (double[])GuardTimes.Clone();
			obj.FuseOrder = (byte[])FuseOrder.Clone();
			obj.BatteryStates = (byte[])BatteryStates.Clone();
			obj.BatteryArgs = (int[])BatteryArgs.Clone();
			obj.BatteryDrops = (float[])BatteryDrops.Clone();
			return obj;
		}

		public void Read(Hashtable p)
		{
			if (p == null)
			{
				return;
			}
			if (p.ContainsKey("fnPh"))
			{
				Phase = (FnPhase)FnProps.GetByte(p, "fnPh");
				HasPhase = true;
			}
			if (p.ContainsKey("fnPS"))
			{
				PhaseStart = FnProps.GetDouble(p, "fnPS");
			}
			if (p.ContainsKey("fnPE"))
			{
				PhaseEnd = FnProps.GetDouble(p, "fnPE");
			}
			if (p.ContainsKey("fnNS"))
			{
				NightStart = FnProps.GetDouble(p, "fnNS");
			}
			if (p.ContainsKey("fnHs"))
			{
				HourSeconds = Mathf.Max(1f, FnProps.GetFloat(p, "fnHs", 70f));
			}
			if (p.ContainsKey("fnN"))
			{
				Night = Mathf.Clamp(FnProps.GetByte(p, "fnN", 1), 1, 15);
			}
			if (p.ContainsKey("fnDf"))
			{
				Difficulty = ((FnProps.GetByte(p, "fnDf") == 1) ? FnDifficulty.Nightmare : FnDifficulty.Default);
			}
			if (p.ContainsKey("fnTS"))
			{
				TeamSize = Mathf.Clamp(FnProps.GetByte(p, "fnTS", 1), 1, 3);
			}
			if (p.ContainsKey("fnAC"))
			{
				Arrived = FnProps.GetByte(p, "fnAC");
			}
			if (p.ContainsKey("fnRos"))
			{
				Roster = FnProps.GetArray<string[]>(p, "fnRos") ?? Array.Empty<string>();
			}
			if (p.ContainsKey("fnGA"))
			{
				GuardActors = FnProps.GetArray<int[]>(p, "fnGA") ?? Array.Empty<int>();
			}
			if (p.ContainsKey("fnGN"))
			{
				GuardNames = FnProps.GetArray<string[]>(p, "fnGN") ?? Array.Empty<string>();
			}
			if (p.ContainsKey("fnGB"))
			{
				GuardBuilds = FnProps.GetArray<string[]>(p, "fnGB") ?? Array.Empty<string>();
			}
			if (p.ContainsKey("fnGS"))
			{
				GuardStatus = FnProps.GetArray<byte[]>(p, "fnGS") ?? Array.Empty<byte>();
			}
			if (p.ContainsKey("fnGT"))
			{
				GuardTimes = FnProps.GetArray<double[]>(p, "fnGT") ?? Array.Empty<double>();
			}
			if (p.ContainsKey("fnPw"))
			{
				Power = FnProps.GetFloat(p, "fnPw", 100f);
			}
			if (p.ContainsKey("fnPwT"))
			{
				PowerStamp = FnProps.GetDouble(p, "fnPwT");
			}
			if (p.ContainsKey("fnPwR"))
			{
				PowerRate = FnProps.GetFloat(p, "fnPwR");
			}
			if (p.ContainsKey("fnBo"))
			{
				Blackout = FnProps.GetDouble(p, "fnBo");
			}
			if (p.ContainsKey("fnBoE"))
			{
				BlackoutEnd = FnProps.GetDouble(p, "fnBoE");
			}
			if (p.ContainsKey("fnDr"))
			{
				Doors = FnProps.GetByte(p, "fnDr");
			}
			if (p.ContainsKey("fnDj"))
			{
				Jams = FnProps.GetByte(p, "fnDj");
			}
			if (p.ContainsKey("fnLt"))
			{
				Lights = FnProps.GetByte(p, "fnLt");
			}
			if (p.ContainsKey("fnLr"))
			{
				LureReady = FnProps.GetDouble(p, "fnLr");
			}
			if (p.ContainsKey("fnFz"))
			{
				FuseUses = FnProps.GetByte(p, "fnFz");
			}
			if (p.ContainsKey("fnFzO"))
			{
				byte[] array = FnProps.GetArray<byte[]>(p, "fnFzO");
				if (array != null && array.Length == 3)
				{
					FuseOrder = array;
				}
			}
			if (p.ContainsKey("fnFzP"))
			{
				FuseProgress = FnProps.GetByte(p, "fnFzP");
			}
			if (p.ContainsKey("fnBtS"))
			{
				BatteryStates = FnProps.GetArray<byte[]>(p, "fnBtS") ?? Array.Empty<byte>();
			}
			if (p.ContainsKey("fnBtA"))
			{
				BatteryArgs = FnProps.GetArray<int[]>(p, "fnBtA") ?? Array.Empty<int>();
			}
			if (p.ContainsKey("fnBtD"))
			{
				BatteryDrops = FnProps.GetArray<float[]>(p, "fnBtD") ?? Array.Empty<float>();
			}
			if (p.ContainsKey("fnBtN"))
			{
				BatteriesDelivered = FnProps.GetByte(p, "fnBtN");
			}
			if (p.ContainsKey("fnOut"))
			{
				Outcome = FnProps.GetByte(p, "fnOut");
			}
		}
	}
}
