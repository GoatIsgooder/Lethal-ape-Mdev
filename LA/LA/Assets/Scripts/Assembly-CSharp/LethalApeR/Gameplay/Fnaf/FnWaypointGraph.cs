using System.Text;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(-180)]
	public class FnWaypointGraph : MonoBehaviour
	{
		private static readonly string[] RequiredNames = new string[3] { "Stage", "Cove", "Kitchen" };

		private readonly Vector3[] _doorPoint = new Vector3[2];

		private readonly Vector3[] _doorNormal = new Vector3[2];

		private readonly bool[] _doorKnown = new bool[2];

		private int _doorFrame = -1;

		[Tooltip("Level geometry for line of sight: walls and large props. Keep office door panels OFF it (doors block by FnNight state). No triggers.")]
		public LayerMask levelMask = 1;

		[Tooltip("Filled from the direct child waypoints in sibling order when the graph builds (and in the editor). Contract scene table.")]
		public FnWaypoint[] nodes = new FnWaypoint[0];

		[Tooltip("Half the width of an office doorway for the closed-door sight test (m). Walls either side block by ray anyway.")]
		public float doorHalfWidth = 1f;

		private const float Unreachable = 1f / 0f;

		private int _n;

		private Vector3[] _pos = new Vector3[0];

		private float[] _dist = new float[0];

		private short[] _next = new short[0];

		private int[] _adjStart = new int[0];

		private int[] _adj = new int[0];

		private readonly int[] _door = new int[2] { -1, -1 };

		private bool _built;

		public static FnWaypointGraph Instance { get; private set; }

		public int Count
		{
			get
			{
				EnsureBuilt();
				return _n;
			}
		}

		public bool IsBuilt => _built;

		public int Validate(StringBuilder report)
		{
			if (_n == 0)
			{
				report?.AppendLine("No FnWaypoint children.");
				return 1;
			}
			int problems = 0;
			for (int s = 0; s < 2; s++)
			{
				FnDoorSide side = (FnDoorSide)s;
				int count = 0;
				for (int i = 0; i < _n; i++)
				{
					if (nodes[i].officeDoorOutside && nodes[i].side == side)
					{
						count++;
					}
				}
				if (count != 1)
				{
					problems++;
					report?.AppendLine(string.Format("{0} door: {1} officeDoorOutside nodes (need exactly 1).", side, count));
				}
			}
			string[] requiredNames = RequiredNames;
			foreach (string requiredName in requiredNames)
			{
				if (Find(requiredName) < 0)
				{
					problems++;
					report?.AppendLine("No node named '" + requiredName + "'.");
				}
			}
			FnOffice office = FnOffice.Instance;
			for (int j = 0; j < _n; j++)
			{
				if (NeighbourCount(j) == 0)
				{
					problems++;
					report?.AppendLine(string.Format("Node {0} '{1}' has no links.", j, nodes[j].name));
				}
				for (int k = j + 1; k < _n; k++)
				{
					if (!Reachable(j, k))
					{
						problems++;
						report?.AppendLine("'" + nodes[j].name + "' cannot reach '" + nodes[k].name + "'.");
						break;
					}
				}
				if (office != null && office.Contains(_pos[j], 0f))
				{
					problems++;
					report?.AppendLine("Node '" + nodes[j].name + "' is inside the office volume (the office is never in the graph).");
				}
			}
			for (int d = 0; office != null && d < 2; d++)
			{
				FnDoor door = ((d == 0) ? office.westDoor : office.eastDoor);
				if (door == null || door.panel == null)
				{
					continue;
				}
				Collider[] colliders = door.panel.GetComponentsInChildren<Collider>(true);
				foreach (Collider collider in colliders)
				{
					if (((int)levelMask & (1 << collider.gameObject.layer)) != 0)
					{
						problems++;
						report?.AppendLine("Door panel collider '" + collider.name + "' is on levelMask: doors block sight through FnNight's state, keep panels off the mask.");
						break;
					}
				}
			}
			return problems;
		}

		private void OnValidate()
		{
			if (!Application.isPlaying)
			{
				FnWaypoint[] children = DirectChildren();
				if (!SameOrder(children, nodes))
				{
					nodes = children;
				}
			}
		}

		private static bool SameOrder(FnWaypoint[] a, FnWaypoint[] b)
		{
			if (b == null || a.Length != b.Length)
			{
				return false;
			}
			for (int i = 0; i < a.Length; i++)
			{
				if (a[i] != b[i])
				{
					return false;
				}
			}
			return true;
		}

		private void OnDrawGizmos()
		{
			if (nodes == null)
			{
				return;
			}
			FnWaypoint[] array = nodes;
			foreach (FnWaypoint waypoint in array)
			{
				if (waypoint == null)
				{
					continue;
				}
				Vector3 position = waypoint.transform.position + Vector3.up * 0.1f;
				Gizmos.color = (waypoint.officeDoorOutside ? Color.red : (waypoint.perchBase ? Color.cyan : (waypoint.hiding ? Color.magenta : Color.yellow)));
				Gizmos.DrawSphere(position, 0.18f);
				if (waypoint.links == null)
				{
					continue;
				}
				Gizmos.color = new Color(1f, 0.85f, 0.3f, 0.6f);
				for (int j = 0; j < waypoint.links.Length; j++)
				{
					if (waypoint.links[j] != null)
					{
						Gizmos.DrawLine(position, waypoint.links[j].transform.position + Vector3.up * 0.1f);
					}
				}
			}
		}

		public bool Clear(Vector3 from, Vector3 to)
		{
			return !Physics.Linecast(from, to, levelMask, QueryTriggerInteraction.Ignore);
		}

		public bool Sight(Vector3 from, Vector3 to)
		{
			if (ThroughClosedDoor(from, to))
			{
				return false;
			}
			return Clear(from, to);
		}

		public bool Occupied(Vector3 bottom, Vector3 top, float radius)
		{
			return Physics.CheckCapsule(bottom, top, radius, levelMask, QueryTriggerInteraction.Ignore);
		}

		public bool Walkable(Vector3 from, Vector3 to, float radius, float low, float high)
		{
			Vector3 delta = to - from;
			float distance = delta.magnitude;
			if (distance < 0.001f)
			{
				return true;
			}
			float bottom = low + radius;
			float top = Mathf.Max(bottom, high - radius);
			Vector3 mid = Vector3.up * high * 0.5f;
			if (ThroughClosedDoor(from + mid, to + mid))
			{
				return false;
			}
			return !Physics.CapsuleCast(from + Vector3.up * bottom, from + Vector3.up * top, radius, delta / distance, distance, levelMask, QueryTriggerInteraction.Ignore);
		}

		public bool FloorBelow(Vector3 from, float depth, out float y)
		{
			y = 0f;
			if (Physics.Raycast(from, Vector3.down, out var hit, depth, levelMask, QueryTriggerInteraction.Ignore))
			{
				y = hit.point.y;
				return true;
			}
			return false;
		}

		public bool ThroughClosedDoor(Vector3 from, Vector3 to)
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.Active)
			{
				return false;
			}
			RefreshDoors(instance);
			for (int i = 0; i < 2; i++)
			{
				if (_doorKnown[i] && instance.DoorClosed((FnDoorSide)i) && FnAiRules.SegmentCrossesDoor(from, to, _doorPoint[i], _doorNormal[i], doorHalfWidth))
				{
					return true;
				}
			}
			return false;
		}

		private void RefreshDoors(FnNight night)
		{
			if (_doorFrame == Time.frameCount)
			{
				return;
			}
			_doorFrame = Time.frameCount;
			FnOffice office = ((night.office != null) ? night.office : FnOffice.Instance);
			for (int i = 0; i < 2; i++)
			{
				_doorKnown[i] = false;
				if (office == null)
				{
					continue;
				}
				bool west = i == 0;
				Transform doorway = (west ? office.westDoorway : office.eastDoorway);
				FnDoor door = (west ? office.westDoor : office.eastDoor);
				Transform outside = (west ? office.westOutside : office.eastOutside);
				Transform anchor;
				if (doorway != null)
				{
					anchor = doorway;
				}
				else
				{
					if (!(door != null))
					{
						continue;
					}
					anchor = door.transform;
				}
				Vector3 point = anchor.position;
				Vector3 normal = Vector3.zero;
				if (outside != null)
				{
					normal = point - outside.position;
				}
				else if (_door[i] >= 0)
				{
					normal = point - _pos[_door[i]];
				}
				normal.y = 0f;
				if (normal.sqrMagnitude < 0.0001f && door != null)
				{
					normal = Vector3.ProjectOnPlane(door.transform.forward, Vector3.up);
				}
				if (!(normal.sqrMagnitude < 0.0001f))
				{
					_doorPoint[i] = point;
					_doorNormal[i] = normal.normalized;
					_doorKnown[i] = true;
				}
			}
		}

		public int BestEntry(Vector3 p, int goal, float height, int maxRays, out int raysUsed)
		{
			EnsureBuilt();
			raysUsed = 0;
			if (maxRays >= 1)
			{
				Vector3 eye = p + Vector3.up * height;
				float lastWeight = -1f;
				int best = -1;
				float bestCost = float.MaxValue;
				for (int r = 0; r < maxRays; r++)
				{
					int candidate = -1;
					float candidateWeight = float.MaxValue;
					for (int i = 0; i < _n; i++)
					{
						float weight = Weighted(i, p);
						if (weight > lastWeight && weight < candidateWeight)
						{
							candidateWeight = weight;
							candidate = i;
						}
					}
					if (candidate < 0)
					{
						break;
					}
					lastWeight = candidateWeight;
					float remaining = 0f;
					if (goal >= 0 && goal < _n)
					{
						remaining = Distance(candidate, goal);
					}
					float cost = Mathf.Sqrt(candidateWeight) + remaining;
					if (!(cost >= bestCost))
					{
						raysUsed++;
						if (Sight(eye, _pos[candidate] + Vector3.up * height))
						{
							bestCost = cost;
							best = candidate;
						}
					}
				}
				if (best >= 0)
				{
					return best;
				}
			}
			return Nearest(p);
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		private void Awake()
		{
			Instance = this;
			EnsureBuilt();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void EnsureBuilt()
		{
			if (_built)
			{
				return;
			}
			_built = true;
			nodes = DirectChildren();
			_n = Mathf.Min(nodes.Length, 32767);
			_pos = new Vector3[_n];
			for (int i = 0; i < _n; i++)
			{
				nodes[i].Index = i;
				_pos[i] = nodes[i].transform.position;
			}
			BuildAdjacency();
			Solve();
			_door[0] = (_door[1] = -1);
			for (int j = 0; j < _n; j++)
			{
				FnWaypoint waypoint = nodes[j];
				if (waypoint.officeDoorOutside && _door[(uint)waypoint.side] < 0)
				{
					_door[(uint)waypoint.side] = j;
				}
			}
			StringBuilder report = new StringBuilder();
			if (Validate(report) > 0)
			{
				Debug.LogWarning("[FnWaypointGraph] " + report, this);
			}
		}

		private FnWaypoint[] DirectChildren()
		{
			int count = 0;
			for (int i = 0; i < base.transform.childCount; i++)
			{
				if (base.transform.GetChild(i).GetComponent<FnWaypoint>() != null)
				{
					count++;
				}
			}
			FnWaypoint[] result = new FnWaypoint[count];
			int k = 0;
			for (int j = 0; j < base.transform.childCount; j++)
			{
				FnWaypoint waypoint = base.transform.GetChild(j).GetComponent<FnWaypoint>();
				if (waypoint != null)
				{
					result[k++] = waypoint;
				}
			}
			return result;
		}

		private void BuildAdjacency()
		{
			bool[] edge = new bool[_n * _n];
			for (int i = 0; i < _n; i++)
			{
				FnWaypoint[] links = nodes[i].links;
				if (links == null)
				{
					continue;
				}
				foreach (FnWaypoint link in links)
				{
					if (!(link == null))
					{
						int j = link.Index;
						if (j >= 0 && j != i && j < _n && !(nodes[j] != link))
						{
							edge[i * _n + link.Index] = true;
							edge[link.Index * _n + i] = true;
						}
					}
				}
			}
			_adjStart = new int[_n + 1];
			int total = 0;
			for (int a = 0; a < _n; a++)
			{
				_adjStart[a] = total;
				for (int b = 0; b < _n; b++)
				{
					if (edge[a * _n + b])
					{
						total++;
					}
				}
			}
			_adjStart[_n] = total;
			_adj = new int[total];
			int w = 0;
			for (int c = 0; c < _n; c++)
			{
				for (int d = 0; d < _n; d++)
				{
					if (edge[c * _n + d])
					{
						_adj[w++] = d;
					}
				}
			}
		}

		private void Solve()
		{
			_dist = new float[_n * _n];
			_next = new short[_n * _n];
			for (int i = 0; i < _dist.Length; i++)
			{
				_dist[i] = 1f / 0f;
				_next[i] = -1;
			}
			for (int j = 0; j < _n; j++)
			{
				_dist[j * _n + j] = 0f;
				_next[j * _n + j] = (short)j;
				for (int e = _adjStart[j]; e < _adjStart[j + 1]; e++)
				{
					int to = _adj[e];
					_dist[j * _n + to] = Vector3.Distance(_pos[j], _pos[to]);
					_next[j * _n + to] = (short)to;
				}
			}
			for (int k = 0; k < _n; k++)
			{
				for (int a = 0; a < _n; a++)
				{
					float viaK = _dist[a * _n + k];
					if (viaK == 1f / 0f)
					{
						continue;
					}
					for (int b = 0; b < _n; b++)
					{
						float candidate = viaK + _dist[k * _n + b];
						if (candidate < _dist[a * _n + b])
						{
							_dist[a * _n + b] = candidate;
							_next[a * _n + b] = _next[a * _n + k];
						}
					}
				}
			}
		}

		public bool Valid(int node)
		{
			if (node >= 0)
			{
				return node < _n;
			}
			return false;
		}

		public Vector3 Position(int node)
		{
			if (!Valid(node))
			{
				return Vector3.zero;
			}
			return _pos[node];
		}

		public FnWaypoint Node(int node)
		{
			if (!Valid(node))
			{
				return null;
			}
			return nodes[node];
		}

		public int NextHop(int from, int to)
		{
			if (!Valid(from) || !Valid(to))
			{
				return -1;
			}
			return _next[from * _n + to];
		}

		public float Distance(int from, int to)
		{
			if (!Valid(from) || !Valid(to))
			{
				return 1f / 0f;
			}
			return _dist[from * _n + to];
		}

		public bool Reachable(int from, int to)
		{
			if (!Valid(from) || !Valid(to))
			{
				return false;
			}
			return _next[from * _n + to] >= 0;
		}

		public int NeighbourCount(int node)
		{
			if (!Valid(node))
			{
				return 0;
			}
			return _adjStart[node + 1] - _adjStart[node];
		}

		public int Neighbour(int node, int k)
		{
			return _adj[_adjStart[node] + k];
		}

		private float Weighted(int i, Vector3 p)
		{
			Vector3 d = _pos[i] - p;
			return d.x * d.x + d.z * d.z + d.y * (d.y * 4f);
		}

		public int Nearest(Vector3 p)
		{
			EnsureBuilt();
			int best = -1;
			float bestWeight = float.MaxValue;
			for (int i = 0; i < _n; i++)
			{
				float weight = Weighted(i, p);
				if (weight < bestWeight)
				{
					bestWeight = weight;
					best = i;
				}
			}
			return best;
		}

		public int NearestFlagged(Vector3 p, FnNodeFilter filter, float maxHorizontal)
		{
			EnsureBuilt();
			int best = -1;
			float bestSqr = maxHorizontal * maxHorizontal;
			for (int i = 0; i < _n; i++)
			{
				if (nodes[i].Passes(filter))
				{
					float dx = _pos[i].x - p.x;
					float dz = _pos[i].z - p.z;
					float sqr = dx * dx + dz * dz;
					if (!(sqr > bestSqr))
					{
						bestSqr = sqr;
						best = i;
					}
				}
			}
			return best;
		}

		public int Find(string nodeName)
		{
			EnsureBuilt();
			if (string.IsNullOrEmpty(nodeName))
			{
				return -1;
			}
			for (int i = 0; i < _n; i++)
			{
				if (nodes[i].name == nodeName)
				{
					return i;
				}
			}
			return -1;
		}

		public int FindAll(string key, int[] into)
		{
			EnsureBuilt();
			int count = 0;
			for (int i = 0; i < _n; i++)
			{
				if (nodes[i].Matches(key))
				{
					if (into != null && count < into.Length)
					{
						into[count] = i;
					}
					count++;
				}
			}
			return count;
		}

		public int DoorNode(FnDoorSide side)
		{
			EnsureBuilt();
			return _door[(uint)side];
		}

		public int RandomNode(FnNodeFilter filter, int exclude = -1, int exclude2 = -1)
		{
			return RandomNodeWithin(-1, 1f / 0f, 0f, filter, exclude, exclude2);
		}

		public int RandomNodeWithin(int from, float maxDistance, float minDistance, FnNodeFilter filter, int exclude = -1, int exclude2 = -1)
		{
			EnsureBuilt();
			int count = 0;
			for (int i = 0; i < _n; i++)
			{
				if (Eligible(i, from, maxDistance, minDistance, filter, exclude, exclude2))
				{
					count++;
				}
			}
			if (count == 0)
			{
				return -1;
			}
			int pick = Random.Range(0, count);
			for (int j = 0; j < _n; j++)
			{
				if (Eligible(j, from, maxDistance, minDistance, filter, exclude, exclude2))
				{
					if (pick == 0)
					{
						return j;
					}
					pick--;
				}
			}
			return -1;
		}

		private bool Eligible(int i, int from, float maxDistance, float minDistance, FnNodeFilter filter, int exclude, int exclude2)
		{
			if (i == exclude || i == exclude2)
			{
				return false;
			}
			if (!nodes[i].Passes(filter))
			{
				return false;
			}
			if (from < 0)
			{
				return true;
			}
			float distance = _dist[from * _n + i];
			if (distance == 1f / 0f)
			{
				return false;
			}
			if (distance >= minDistance)
			{
				return distance <= maxDistance;
			}
			return false;
		}
	}
}
