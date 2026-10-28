using System.Collections.Generic;
using System.Linq;
using GorillaLocomotion;
using LethalApeR.Gameplay.Monsters;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR
{
	public sealed class MonsterManager : MonoBehaviour
	{
		[Header("Boredom")]
		[Tooltip("Monsters camping the spawn exits or standing in a clump get bored and wander off.")]
		public bool monsterBoredom = true;

		[Tooltip("How long a bored monster sees nobody, and won't catch anyone who walks into it (s).")]
		public float boredBlindSeconds = 5f;

		[Tooltip("A bored monster walks to a patrol point at least this far from what bored it (m).")]
		public float boredEscapeDistance = 15f;

		[Header("Boredom: spawn camping")]
		[Tooltip("A monster within this distance of the spawn zone (m)...")]
		public float campDistance = 8f;

		[Tooltip("...for this long (s), and not chasing anyone outside spawn, is camping it.")]
		public float campSeconds = 6f;

		[Tooltip("After its blind spell, a monster bored of spawn ignores players inside spawn for this long (s).")]
		public float spawnIgnoreSeconds = 30f;

		[Header("Boredom: bunching")]
		[Tooltip("Monsters this close to one another across the floor (m)...")]
		public float bunchRadius = 4f;

		[Tooltip("...and this close in height (m), so a monster on the floor above doesn't count...")]
		public float bunchHeight = 2f;

		[Tooltip("...this many or more of them...")]
		[Min(2f)]
		public int bunchCount = 3;

		[Tooltip("...for this long (s) is a clump: all but the one closest to its target get bored.")]
		public float bunchSeconds = 3f;

		private const float BoredomInterval = 0.5f;

		private static readonly List<BaseMonster> s_awake = new List<BaseMonster>(64);

		private static int[] s_clump = new int[64];

		private static int[] s_clumpSize = new int[64];

		private float _nextBoredomCheck;

		private float _lastBoredomCheck = -1f;

		public static MonsterManager Instance;

		[Header("Waypoints")]
		public List<WaypointSet> waypointSets = new List<WaypointSet>();

		[Header("Respawn")]
		public Transform defaultRespawnPoint;

		private Dictionary<WaypointSetType, Transform[]> _waypointMap;

		public List<BaseMonster> Monsters { get; private set; } = new List<BaseMonster>();

		private void Update()
		{
			if (!monsterBoredom)
			{
				return;
			}
			if (!PhotonNetwork.IsMasterClient && PhotonNetwork.InRoom)
			{
				if (_lastBoredomCheck >= 0f)
				{
					ResetBoredomCounts();
				}
				_lastBoredomCheck = -1f;
				return;
			}
			float time = Time.time;
			if (!(time < _nextBoredomCheck))
			{
				float dt = ((_lastBoredomCheck < 0f) ? 0f : Mathf.Min(time - _lastBoredomCheck, 1f));
				_nextBoredomCheck = time + 0.5f;
				_lastBoredomCheck = time;
				CollectAwake();
				CheckCamping(dt);
				CheckBunching(dt);
				s_awake.Clear();
			}
		}

		private void CollectAwake()
		{
			s_awake.Clear();
			for (int i = 0; i < Monsters.Count; i++)
			{
				BaseMonster baseMonster = Monsters[i];
				if (baseMonster != null && baseMonster.BoredomEligible)
				{
					s_awake.Add(baseMonster);
				}
				else if (baseMonster != null)
				{
					baseMonster.boredomNearSpawnFor = 0f;
					baseMonster.boredomBunchedFor = 0f;
				}
			}
		}

		private void CheckCamping(float dt)
		{
			for (int i = 0; i < s_awake.Count; i++)
			{
				BaseMonster baseMonster = s_awake[i];
				if (!MonsterExclusionZone.DistanceToNearest(baseMonster.transform.position, out var distance, out var centre) || distance > campDistance || baseMonster.ChasingOutsideSpawn)
				{
					baseMonster.boredomNearSpawnFor = 0f;
					continue;
				}
				baseMonster.boredomNearSpawnFor += dt;
				if (!(baseMonster.boredomNearSpawnFor < campSeconds))
				{
					baseMonster.GetBored(MonsterBoredOf.Spawn, centre, boredBlindSeconds, spawnIgnoreSeconds, boredEscapeDistance);
				}
			}
		}

		private void CheckBunching(float dt)
		{
			int count = s_awake.Count;
			if (count < bunchCount)
			{
				return;
			}
			if (count > s_clump.Length)
			{
				s_clump = new int[count * 2];
				s_clumpSize = new int[count * 2];
			}
			for (int i = 0; i < count; i++)
			{
				s_clump[i] = i;
				s_clumpSize[i] = 0;
			}
			float num = bunchRadius * bunchRadius;
			for (int j = 0; j < count; j++)
			{
				if (s_awake[j].IsBored)
				{
					continue;
				}
				Vector3 position = s_awake[j].transform.position;
				for (int k = j + 1; k < count; k++)
				{
					if (!s_awake[k].IsBored)
					{
						Vector3 position2 = s_awake[k].transform.position;
						if (!(Mathf.Abs(position.y - position2.y) > bunchHeight))
						{
							float num2 = position.x - position2.x;
							float num3 = position.z - position2.z;
							if (!(num2 * num2 + num3 * num3 > num))
							{
								Join(j, k);
							}
						}
					}
				}
			}
			for (int l = 0; l < count; l++)
			{
				if (!s_awake[l].IsBored)
				{
					s_clumpSize[Find(l)]++;
				}
			}
			for (int m = 0; m < count; m++)
			{
				BaseMonster baseMonster = s_awake[m];
				if (!baseMonster.IsBored)
				{
					baseMonster.boredomBunchedFor = ((s_clumpSize[Find(m)] >= bunchCount) ? (baseMonster.boredomBunchedFor + dt) : 0f);
				}
			}
			for (int n = 0; n < count; n++)
			{
				int num4 = Find(n);
				if (s_clumpSize[num4] >= bunchCount && !s_awake[n].IsBored && !(s_awake[n].boredomBunchedFor < bunchSeconds))
				{
					BreakUp(num4, count);
					s_clumpSize[num4] = 0;
				}
			}
		}

		private void BreakUp(int root, int n)
		{
			Vector3 zero = Vector3.zero;
			int num = 0;
			int num2 = -1;
			float num3 = float.MaxValue;
			for (int i = 0; i < n; i++)
			{
				if (!s_awake[i].IsBored && Find(i) == root)
				{
					zero += s_awake[i].transform.position;
					num++;
					float boredomTargetSqrDistance = s_awake[i].BoredomTargetSqrDistance;
					if (boredomTargetSqrDistance < num3 || num2 < 0)
					{
						num3 = boredomTargetSqrDistance;
						num2 = i;
					}
				}
			}
			if (num == 0)
			{
				return;
			}
			zero /= (float)num;
			for (int j = 0; j < n; j++)
			{
				if (j != num2 && !s_awake[j].IsBored && Find(j) == root)
				{
					s_awake[j].GetBored(MonsterBoredOf.Crowd, zero, boredBlindSeconds, 0f, boredEscapeDistance);
				}
			}
			s_awake[num2].boredomBunchedFor = 0f;
		}

		private static int Find(int i)
		{
			while (s_clump[i] != i)
			{
				i = (s_clump[i] = s_clump[s_clump[i]]);
			}
			return i;
		}

		private static void Join(int a, int b)
		{
			a = Find(a);
			b = Find(b);
			if (a != b)
			{
				s_clump[b] = a;
			}
		}

		private void ResetBoredomCounts()
		{
			for (int i = 0; i < Monsters.Count; i++)
			{
				BaseMonster baseMonster = Monsters[i];
				if (!(baseMonster == null))
				{
					baseMonster.boredomNearSpawnFor = 0f;
					baseMonster.boredomBunchedFor = 0f;
				}
			}
		}

		private void Awake()
		{
			Instance = this;
		}

		private void Start()
		{
			BuildWaypointMap();
			Monsters = Object.FindObjectsByType<BaseMonster>(FindObjectsSortMode.None).ToList();
			AssignAllMonsters();
		}

		private void BuildWaypointMap()
		{
			_waypointMap = new Dictionary<WaypointSetType, Transform[]>();
			foreach (WaypointSet waypointSet in waypointSets)
			{
				List<Transform> list = new List<Transform>();
				Transform[] waypoints = waypointSet.waypoints;
				foreach (Transform root in waypoints)
				{
					if ((bool)root)
					{
						Transform[] componentsInChildren = root.GetComponentsInChildren<Transform>();
						if (componentsInChildren.Length == 1)
						{
							list.Add(root);
						}
						else
						{
							list.AddRange(componentsInChildren.Where((Transform t) => (bool)t && t != root));
						}
					}
				}
				_waypointMap[waypointSet.type] = list.Distinct().ToArray();
			}
		}

		private void AssignAllMonsters()
		{
			foreach (BaseMonster monster in Monsters)
			{
				if (!monster)
				{
					continue;
				}
				List<Transform> list = new List<Transform>();
				if (_waypointMap.TryGetValue(monster.waypointSet, out var value))
				{
					list.AddRange(value);
				}
				if (monster.additionalWaypointSets != null)
				{
					WaypointSetType[] additionalWaypointSets = monster.additionalWaypointSets;
					foreach (WaypointSetType waypointSetType in additionalWaypointSets)
					{
						if (waypointSetType != monster.waypointSet && _waypointMap.TryGetValue(waypointSetType, out var value2))
						{
							list.AddRange(value2);
						}
					}
				}
				Transform[] array = list.Distinct().ToArray();
				if (array.Length != 0)
				{
					monster.SetWaypoints(array);
				}
			}
			for (int j = 0; j < Monsters.Count; j++)
			{
				for (int k = j + 1; k < Monsters.Count; k++)
				{
					if ((bool)Monsters[j] && (bool)Monsters[k])
					{
						Monsters[j].IgnoreCollisionWith(Monsters[k]);
					}
				}
			}
		}

		public void RegisterMonster(BaseMonster monster)
		{
			if (!Monsters.Contains(monster))
			{
				Monsters.Add(monster);
			}
		}

		public void UnregisterMonster(BaseMonster monster)
		{
			Monsters.Remove(monster);
		}

		public void RespawnPlayer()
		{
			Player.Instance.TeleportPlayerRaw(defaultRespawnPoint.position, defaultRespawnPoint.rotation, setRotation: true);
		}
	}
}
