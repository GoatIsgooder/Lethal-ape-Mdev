using System;
using System.Collections.Generic;

namespace LethalApeR.Networking
{
	public sealed class LodRanker : IComparer<int>
	{
		private float[] _sqr = new float[32];

		private int[] _order = new int[32];

		private int[] _rank = new int[32];

		private int _count;

		public int Count => _count;

		public void Begin(int capacity)
		{
			_count = 0;
			if (_sqr.Length < capacity)
			{
				int num = _sqr.Length;
				while (num < capacity)
				{
					num *= 2;
				}
				_sqr = new float[num];
				_order = new int[num];
				_rank = new int[num];
			}
		}

		public int Add(float sqrDistance)
		{
			int num = _count++;
			_sqr[num] = sqrDistance;
			_order[num] = num;
			return num;
		}

		public void Sort()
		{
			Array.Sort(_order, 0, _count, this);
			for (int i = 0; i < _count; i++)
			{
				_rank[_order[i]] = i;
			}
		}

		public int RankOf(int slot)
		{
			return _rank[slot];
		}

		int IComparer<int>.Compare(int a, int b)
		{
			return _sqr[a].CompareTo(_sqr[b]);
		}
	}
}
