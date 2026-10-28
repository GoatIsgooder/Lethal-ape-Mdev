using System;

namespace LethalApeR.Gameplay.Fnaf
{
	public struct FnPadState
	{
		private const int ReadyMask = 7;

		private const int NightShift = 4;

		private const int NightMask = 240;

		private const int LockedBit = 256;

		private const int NightmareBit = 512;

		public int Occ0;

		public int Occ1;

		public int Occ2;

		public int Flags;

		public int Deadline;

		public int Count => ((Occ0 != 0) ? 1 : 0) + ((Occ1 != 0) ? 1 : 0) + ((Occ2 != 0) ? 1 : 0);

		public int ReadyCount
		{
			get
			{
				int num = 0;
				for (int i = 0; i < 3; i++)
				{
					if (Ready(i) && Occupant(i) != 0)
					{
						num++;
					}
				}
				return num;
			}
		}

		public int Night
		{
			get
			{
				return Math.Max(1, (Flags & NightMask) >> NightShift);
			}
			set
			{
				Flags = (Flags & ~NightMask) | ((value << NightShift) & NightMask);
			}
		}

		public bool Locked
		{
			get
			{
				return (Flags & LockedBit) != 0;
			}
			set
			{
				Flags = (Flags & ~LockedBit) | (value ? LockedBit : 0);
			}
		}

		public FnDifficulty Difficulty
		{
			get
			{
				if ((Flags & NightmareBit) == 0)
				{
					return FnDifficulty.Default;
				}
				return FnDifficulty.Nightmare;
			}
			set
			{
				Flags = (Flags & ~NightmareBit) | ((value == FnDifficulty.Nightmare) ? NightmareBit : 0);
			}
		}

		public bool Counting => Deadline != 0;

		public int Occupant(int slot)
		{
			return slot switch
			{
				0 => Occ0,
				1 => Occ1,
				2 => Occ2,
				_ => 0,
			};
		}

		public void SetOccupant(int slot, int actor)
		{
			switch (slot)
			{
			case 0:
				Occ0 = actor;
				break;
			case 1:
				Occ1 = actor;
				break;
			case 2:
				Occ2 = actor;
				break;
			}
		}

		public int SlotOf(int actor)
		{
			if (actor == 0)
			{
				return -1;
			}
			if (Occ0 == actor)
			{
				return 0;
			}
			if (Occ1 == actor)
			{
				return 1;
			}
			if (Occ2 == actor)
			{
				return 2;
			}
			return -1;
		}

		public bool Contains(int actor)
		{
			if (actor != 0)
			{
				if (Occ0 != actor && Occ1 != actor)
				{
					return Occ2 == actor;
				}
				return true;
			}
			return false;
		}

		public bool Ready(int slot)
		{
			return ((Flags >> slot) & 1) != 0;
		}

		public void SetReady(int slot, bool ready)
		{
			if (ready)
			{
				Flags |= 1 << slot;
			}
			else
			{
				Flags &= ~(1 << slot);
			}
		}

		public void ClearReadies()
		{
			Flags &= ~ReadyMask;
		}

		public bool Remove(int actor)
		{
			int num = SlotOf(actor);
			if (num < 0)
			{
				return false;
			}
			for (int i = num; i < 2; i++)
			{
				SetOccupant(i, Occupant(i + 1));
				SetReady(i, Ready(i + 1));
			}
			Occ2 = 0;
			SetReady(2, ready: false);
			return true;
		}

		public bool Add(int actor, int size)
		{
			if (actor == 0 || Contains(actor))
			{
				return false;
			}
			int num = Math.Min(size, 3);
			for (int i = 0; i < num; i++)
			{
				if (Occupant(i) == 0)
				{
					SetOccupant(i, actor);
					SetReady(i, ready: false);
					return true;
				}
			}
			return false;
		}

		public int[] ToWire()
		{
			return new int[5] { Occ0, Occ1, Occ2, Flags, Deadline };
		}

		public static FnPadState FromWire(int[] w)
		{
			if (w == null || w.Length < 5)
			{
				return default(FnPadState);
			}
			return new FnPadState
			{
				Occ0 = w[0],
				Occ1 = w[1],
				Occ2 = w[2],
				Flags = w[3],
				Deadline = w[4]
			};
		}

		public bool SameAs(FnPadState o)
		{
			if (Occ0 == o.Occ0 && Occ1 == o.Occ1 && Occ2 == o.Occ2 && Flags == o.Flags)
			{
				return Deadline == o.Deadline;
			}
			return false;
		}
	}
}
