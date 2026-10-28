using System;
using System.Collections.Generic;
using System.Linq;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmMonsterPicker
	{
		public const int PlayersPerMonster = 5;

		public const int MaxRemembered = 48;

		public static int MonsterCount(int players, int cap)
		{
			return Math.Max(1, Math.Min(players / PlayersPerMonster, Math.Max(1, cap)));
		}

		public static int[] Pick(IList<int> actors, IList<string> keys, IDictionary<string, int> turns, ICollection<int> lastMonsters, int count, Random rng)
		{
			if (actors == null || keys == null || actors.Count != keys.Count)
			{
				throw new ArgumentException("actors and keys must line up");
			}
			if (count < 1 || actors.Count == 0)
			{
				return Array.Empty<int>();
			}
			int take = Math.Min(count, actors.Count);
			int min = int.MaxValue;
			foreach (string key in keys)
			{
				if (turns.TryGetValue(key, out int value) && value < min)
				{
					min = value;
				}
			}
			int baseline = min == int.MaxValue ? 0 : min;
			foreach (string key in keys)
			{
				if (!turns.ContainsKey(key))
				{
					turns[key] = baseline;
				}
			}
			List<int> pool = new List<int>(actors.Count);
			for (int i = 0; i < actors.Count; i++)
			{
				if (lastMonsters == null || !lastMonsters.Contains(actors[i]))
				{
					pool.Add(i);
				}
			}
			if (pool.Count < take)
			{
				pool.Clear();
				for (int j = 0; j < actors.Count; j++)
				{
					pool.Add(j);
				}
			}
			for (int k = pool.Count - 1; k > 0; k--)
			{
				int r = rng.Next(k + 1);
				(pool[k], pool[r]) = (pool[r], pool[k]);
			}
			int[] picked = pool.OrderBy((int i) => turns[keys[i]]).Take(take).ToArray();
			int[] result = new int[picked.Length];
			for (int m = 0; m < picked.Length; m++)
			{
				result[m] = actors[picked[m]];
				turns[keys[picked[m]]]++;
			}
			return result;
		}

		public static void Forget(IDictionary<string, int> turns, ICollection<string> present, int max)
		{
			if (turns.Count <= max)
			{
				return;
			}
			List<string> stale = turns.Keys.Where((string k) => !present.Contains(k)).ToList();
			for (int i = 0; i < stale.Count && turns.Count > max; i++)
			{
				turns.Remove(stale[i]);
			}
		}
	}
}
