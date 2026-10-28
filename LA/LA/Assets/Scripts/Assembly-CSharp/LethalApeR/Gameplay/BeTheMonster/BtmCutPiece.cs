using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmCutPiece
	{
		public sealed class Settings
		{
			public Material Skin;

			public Material Meat;

			public Material Wound;

			public MaterialPropertyBlock Look;

			public float SoakDepth = 0.12f;

			public int Layer;

			public LayerMask CollideWith;
		}

		public sealed class Prepared
		{
			public BtmMeshSlicer.Half Piece;

			public Vector3 Pivot;

			public Bounds Bounds;

			public readonly List<BtmMeshSlicer.CapIsland> Islands = new List<BtmMeshSlicer.CapIsland>();

			public List<Color32> Soak;

			public List<int> Soaked;

			public readonly List<Vector3> HullPoints = new List<Vector3>();

			public readonly List<int> HullTriangles = new List<int>();
		}

		public sealed class PreparedShell
		{
			public BtmMeshSlicer.Half Shell;

			public List<Color32> Soak;

			public List<int> Soaked;
		}

		private const float CoreHalfSize = 0.01f;

		private const float MaxDepenetrationSpeed = 1.5f;

		private const int MaxHullSamples = 1500;

		private static readonly Vector3[] Directions = SpreadDirections(120);

		public static Prepared Prepare(BtmMeshSlicer.Half piece, Plane cut, bool wound, float soakDepth)
		{
			Prepared prepared = new Prepared();
			prepared.Piece = piece;
			List<BtmMeshSlicer.CapIsland> islands = prepared.Islands;
			BtmMeshSlicer.CapIslands(piece, islands);
			if (wound)
			{
				SoakSkin(piece, cut, islands, soakDepth, out prepared.Soak, out prepared.Soaked);
			}
			Bounds bounds = new Bounds(piece.Positions[0], Vector3.zero);
			foreach (Vector3 position in piece.Positions)
			{
				bounds.Encapsulate(position);
			}
			Vector3 center = bounds.center;
			for (int i = 0; i < piece.Positions.Count; i++)
			{
				piece.Positions[i] -= center;
			}
			for (int j = 0; j < islands.Count; j++)
			{
				BtmMeshSlicer.CapIsland island = islands[j];
				island.Center -= center;
				islands[j] = island;
			}
			prepared.Pivot = center;
			prepared.Bounds = bounds;
			Hull(piece.Positions, prepared.HullPoints, prepared.HullTriangles);
			return prepared;
		}

		public static PreparedShell PrepareShell(BtmMeshSlicer.Half shell, Plane cut, Prepared host, bool wound, float soakDepth)
		{
			PreparedShell prepared = new PreparedShell();
			prepared.Shell = shell;
			if (wound)
			{
				List<BtmMeshSlicer.CapIsland> islands = new List<BtmMeshSlicer.CapIsland>(host.Islands.Count);
				foreach (BtmMeshSlicer.CapIsland island in host.Islands)
				{
					BtmMeshSlicer.CapIsland world = island;
					world.Center = island.Center + host.Pivot;
					islands.Add(world);
				}
				SoakSkin(shell, cut, islands, soakDepth, out prepared.Soak, out prepared.Soaked);
			}
			for (int i = 0; i < shell.Positions.Count; i++)
			{
				shell.Positions[i] -= host.Pivot;
			}
			return prepared;
		}

		internal static void SoakSkin(BtmMeshSlicer.Half piece, Plane cut, List<BtmMeshSlicer.CapIsland> islands, float depth, out List<Color32> soak, out List<int> soaked)
		{
			soak = null;
			soaked = null;
			if (depth <= 0f || islands.Count == 0)
			{
				return;
			}
			int count = piece.Positions.Count;
			soak = new List<Color32>(count);
			soaked = new List<int>();
			bool[] onCap = new bool[count];
			foreach (int index in piece.Cap)
			{
				onCap[index] = true;
			}
			for (int i = 0; i < count; i++)
			{
				if (onCap[i])
				{
					soak.Add(new Color32(byte.MaxValue, 0, 0, byte.MaxValue));
					continue;
				}
				Vector3 position = piece.Positions[i];
				float distance = Mathf.Abs(cut.GetDistanceToPoint(position));
				if (distance < depth)
				{
					float nearest = float.MaxValue;
					foreach (BtmMeshSlicer.CapIsland island in islands)
					{
						Vector3 offset = Vector3.ProjectOnPlane(position - island.Center, cut.normal);
						nearest = Mathf.Min(nearest, offset.magnitude - island.Radius);
					}
					distance = Mathf.Max(distance, nearest);
				}
				float amount = Mathf.Clamp01(1f - distance / depth);
				soak.Add(new Color32(0, 0, 0, (byte)(amount * 255f)));
			}
			for (int j = 0; j + 2 < piece.Surface.Count; j += 3)
			{
				int a = piece.Surface[j];
				int b = piece.Surface[j + 1];
				int c = piece.Surface[j + 2];
				if (soak[a].a != 0 || soak[b].a != 0 || soak[c].a != 0)
				{
					soaked.Add(a);
					soaked.Add(b);
					soaked.Add(c);
				}
			}
			soaked.AddRange(piece.Cap);
		}

		private static void Hull(List<Vector3> points, List<Vector3> hullPoints, List<int> hullTriangles)
		{
			Vector3 centroid = Vector3.zero;
			foreach (Vector3 point in points)
			{
				centroid += point;
			}
			int count = points.Count;
			int stride = Mathf.Max(1, count / MaxHullSamples);
			HashSet<int> picked = new HashSet<int>();
			Vector3[] directions = Directions;
			foreach (Vector3 direction in directions)
			{
				float best = float.NegativeInfinity;
				int bestIndex = 0;
				for (int i = 0; i < points.Count; i += stride)
				{
					float d = Vector3.Dot(direction, points[i]);
					if (d > best)
					{
						best = d;
						bestIndex = i;
					}
				}
				picked.Add(bestIndex);
			}
			centroid /= (float)count;
			foreach (int index in picked)
			{
				hullPoints.Add(points[index]);
			}
			for (int j = 0; j < 8; j++)
			{
				hullPoints.Add(centroid + new Vector3(((j & 1) * 2 - 1) * CoreHalfSize, (((j >> 1) & 1) * 2 - 1) * CoreHalfSize, (((j >> 2) & 1) * 2 - 1) * CoreHalfSize));
			}
			for (int k = 2; k < hullPoints.Count; k++)
			{
				hullTriangles.Add(0);
				hullTriangles.Add(k - 1);
				hullTriangles.Add(k);
			}
		}

		private static Vector3[] SpreadDirections(int count)
		{
			Vector3[] directions = new Vector3[count];
			for (int i = 0; i < count; i++)
			{
				float y = 1f - (i + 0.5f) * 2f / count;
				float radius = Mathf.Sqrt(1f - y * y);
				float theta = i * 2.3999631f;
				directions[i] = new Vector3(Mathf.Cos(theta) * radius, y, Mathf.Sin(theta) * radius);
			}
			return directions;
		}

		public static Rigidbody Build(Prepared prepared, string name, Settings settings, float mass, Scene scene = default(Scene))
		{
			BtmMeshSlicer.Half piece = prepared.Piece;
			bool soaked = (bool)settings.Wound && prepared.Soak != null;
			Mesh mesh = new Mesh();
			mesh.name = name;
			if (piece.Positions.Count >= 65536)
			{
				mesh.indexFormat = IndexFormat.UInt32;
			}
			mesh.SetVertices(piece.Positions);
			mesh.SetNormals(piece.Normals);
			mesh.SetUVs(0, piece.Uvs);
			if (soaked)
			{
				mesh.SetColors(prepared.Soak);
				mesh.subMeshCount = 3;
				mesh.SetTriangles(piece.Surface, 0);
				mesh.SetTriangles(piece.Cap, 1);
				mesh.SetTriangles(prepared.Soaked, 2);
			}
			else
			{
				mesh.subMeshCount = 2;
				mesh.SetTriangles(piece.Surface, 0);
				mesh.SetTriangles(piece.Cap, 1);
			}
			mesh.RecalculateBounds();
			mesh.RecalculateTangents();
			GameObject go = new GameObject(name);
			go.layer = settings.Layer;
			if (scene.IsValid())
			{
				SceneManager.MoveGameObjectToScene(go, scene);
			}
			go.transform.position = prepared.Pivot;
			Mesh hull = new Mesh();
			hull.name = name + " Hull";
			hull.SetVertices(prepared.HullPoints);
			hull.SetTriangles(prepared.HullTriangles, 0);
			MeshCollider collider = go.AddComponent<MeshCollider>();
			collider.convex = true;
			collider.sharedMesh = hull;
			collider.includeLayers = settings.CollideWith;
			collider.excludeLayers = ~settings.CollideWith;
			go.AddComponent<MeshFilter>().sharedMesh = mesh;
			MeshRenderer renderer = go.AddComponent<MeshRenderer>();
			Material meat = (settings.Meat ? settings.Meat : settings.Skin);
			renderer.sharedMaterials = (soaked ? new Material[3] { settings.Skin, meat, settings.Wound } : new Material[2] { settings.Skin, meat });
			if (settings.Look != null && !settings.Look.isEmpty)
			{
				renderer.SetPropertyBlock(settings.Look, 0);
			}
			Rigidbody body = go.AddComponent<Rigidbody>();
			body.mass = Mathf.Max(mass, 0.5f);
			body.interpolation = RigidbodyInterpolation.Interpolate;
			body.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative;
			body.linearDamping = 0.05f;
			body.angularDamping = 0.25f;
			body.maxDepenetrationVelocity = MaxDepenetrationSpeed;
			return body;
		}

		public static MeshRenderer BuildShell(PreparedShell prepared, string name, Material material, MaterialPropertyBlock look, Material wound, Transform host)
		{
			BtmMeshSlicer.Half shell = prepared.Shell;
			bool soaked = (bool)wound && prepared.Soak != null;
			Mesh mesh = new Mesh();
			mesh.name = name;
			if (shell.Positions.Count >= 65536)
			{
				mesh.indexFormat = IndexFormat.UInt32;
			}
			mesh.SetVertices(shell.Positions);
			mesh.SetNormals(shell.Normals);
			mesh.SetUVs(0, shell.Uvs);
			if (soaked)
			{
				mesh.SetColors(prepared.Soak);
				mesh.subMeshCount = 2;
				mesh.SetTriangles(shell.Surface, 0);
				mesh.SetTriangles(prepared.Soaked, 1);
			}
			else
			{
				mesh.subMeshCount = 1;
				mesh.SetTriangles(shell.Surface, 0);
			}
			mesh.RecalculateBounds();
			mesh.RecalculateTangents();
			GameObject go = new GameObject(name);
			go.layer = host.gameObject.layer;
			go.transform.SetParent(host, false);
			go.AddComponent<MeshFilter>().sharedMesh = mesh;
			MeshRenderer renderer = go.AddComponent<MeshRenderer>();
			renderer.sharedMaterials = (soaked ? new Material[2] { material, wound } : new Material[1] { material });
			if (look != null && !look.isEmpty)
			{
				renderer.SetPropertyBlock(look, 0);
			}
			return renderer;
		}
	}
}
