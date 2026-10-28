using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmMeshSlicer
	{
		public sealed class Half
		{
			public readonly List<Vector3> Positions = new List<Vector3>();

			public readonly List<Vector3> Normals = new List<Vector3>();

			public readonly List<Vector2> Uvs = new List<Vector2>();

			public readonly List<int> Surface = new List<int>();

			public readonly List<int> Cap = new List<int>();

			public readonly List<Source> Sources = new List<Source>();

			public bool IsEmpty => Surface.Count == 0;

			public void Clear()
			{
				Positions.Clear();
				Normals.Clear();
				Uvs.Clear();
				Surface.Clear();
				Cap.Clear();
				Sources.Clear();
			}
		}

		public struct Source
		{
			public int A;

			public int B;

			public float T;
		}

		public struct CapIsland
		{
			public Vector3 Center;

			public Vector3 Facing;

			public float Area;

			public float Radius;
		}

		private struct CapPoint
		{
			public Vector3 Position;

			public Vector2 Uv;

			public bool Locked;
		}

		private const float WeldGrid = 0.0001f;

		private const int MaxCapSplits = 2;

		private const float MinCapFacetArea = 0.00022f;

		private const float InteriorRelief = 0.6f;

		private const float TearFrequency = 26f;

		public static void Slice(IReadOnlyList<Vector3> positions, IReadOnlyList<Vector3> normals, IReadOnlyList<Vector2> uvs, IReadOnlyList<int> triangles, Plane plane, Half front, Half back, Rect capUvRect = default(Rect), float roughness = 0f, bool caps = true, IReadOnlyList<bool> backOnly = null)
		{
			front.Clear();
			back.Clear();
			int count = positions.Count;
			bool hasUvs = uvs != null && uvs.Count == count;
			bool hasBackOnly = backOnly != null && backOnly.Count == count;
			float[] distance = new float[count];
			int[] frontMap = new int[count];
			int[] backMap = new int[count];
			for (int i = 0; i < count; i++)
			{
				distance[i] = plane.GetDistanceToPoint(positions[i]);
				if (hasBackOnly && backOnly[i] && distance[i] >= 0f)
				{
					distance[i] = -1E-05f;
				}
				frontMap[i] = -1;
				backMap[i] = -1;
			}
			Dictionary<long, (int, int)> cuts = new Dictionary<long, (int, int)>();
			List<(int a, int b)> frontSegments = new List<(int a, int b)>();
			List<(int a, int b)> backSegments = new List<(int a, int b)>();
			for (int j = 0; j + 2 < triangles.Count; j += 3)
			{
				int a = triangles[j];
				int b = triangles[j + 1];
				int c = triangles[j + 2];
				bool fa = distance[a] >= 0f;
				bool fb = distance[b] >= 0f;
				bool fc = distance[c] >= 0f;
				if (fa && fb && fc)
				{
					front.Surface.Add(Keep(front, frontMap, a));
					front.Surface.Add(Keep(front, frontMap, b));
					front.Surface.Add(Keep(front, frontMap, c));
					continue;
				}
				if (!fa && !fb && !fc)
				{
					back.Surface.Add(Keep(back, backMap, a));
					back.Surface.Add(Keep(back, backMap, b));
					back.Surface.Add(Keep(back, backMap, c));
					continue;
				}
				int lone;
				int p;
				int q;
				if (fa != fb && fa != fc)
				{
					lone = a;
					p = b;
					q = c;
				}
				else if (fb != fa && fb != fc)
				{
					lone = b;
					p = c;
					q = a;
				}
				else
				{
					lone = c;
					p = a;
					q = b;
				}
				(int, int) cp = Cut(lone, p);
				(int, int) cq = Cut(lone, q);
				if (distance[lone] >= 0f)
				{
					front.Surface.AddRange(new int[3]
					{
						Keep(front, frontMap, lone),
						cp.Item1,
						cq.Item1
					});
					back.Surface.AddRange(new int[6]
					{
						cp.Item2,
						Keep(back, backMap, p),
						Keep(back, backMap, q),
						cp.Item2,
						Keep(back, backMap, q),
						cq.Item2
					});
				}
				else
				{
					back.Surface.AddRange(new int[3]
					{
						Keep(back, backMap, lone),
						cp.Item2,
						cq.Item2
					});
					front.Surface.AddRange(new int[6]
					{
						cp.Item1,
						Keep(front, frontMap, p),
						Keep(front, frontMap, q),
						cp.Item1,
						Keep(front, frontMap, q),
						cq.Item1
					});
				}
				frontSegments.Add((cp.Item1, cq.Item1));
				backSegments.Add((cp.Item2, cq.Item2));
			}
			if (caps)
			{
				if (capUvRect.width <= 0f || capUvRect.height <= 0f)
				{
					capUvRect = new Rect(0f, 0f, 1f, 1f);
				}
				BuildCap(front, frontSegments, -plane.normal, capUvRect, plane.normal, roughness);
				BuildCap(back, backSegments, plane.normal, capUvRect, plane.normal, roughness);
			}
			static int Add(Half half, Vector3 position, Vector3 normal, Vector2 uv, Source source)
			{
				half.Positions.Add(position);
				half.Normals.Add(normal);
				half.Uvs.Add(uv);
				half.Sources.Add(source);
				return half.Positions.Count - 1;
			}
			(int, int) Cut(int a, int b)
			{
				long key = ((a < b) ? (((long)a << 32) | (uint)b) : (((long)b << 32) | (uint)a));
				if (cuts.TryGetValue(key, out var value))
				{
					return value;
				}
				float t = distance[a] / (distance[a] - distance[b]);
				Vector3 position = Vector3.Lerp(positions[a], positions[b], t);
				if (roughness > 0f)
				{
					position += plane.normal * (Tear(position) * roughness);
				}
				Vector3 normal = Vector3.Lerp(normals[a], normals[b], t).normalized;
				Vector2 uv = (hasUvs ? Vector2.Lerp(uvs[a], uvs[b], t) : Vector2.zero);
				Source source = new Source
				{
					A = a,
					B = b,
					T = t
				};
				int item = Add(front, position, normal, uv, source);
				int item2 = Add(back, position, normal, uv, source);
				value = (item, item2);
				cuts[key] = value;
				return value;
			}
			int Keep(Half half, int[] map, int index)
			{
				if (map[index] < 0)
				{
					map[index] = Add(half, positions[index], normals[index], hasUvs ? uvs[index] : Vector2.zero, new Source
					{
						A = index,
						B = index,
						T = 0f
					});
				}
				return map[index];
			}
		}

		public static void SplitIslands(Half half, List<Half> pieces, int minTriangles = 12)
		{
			pieces.Clear();
			int count = half.Positions.Count;
			int[] parent = new int[count];
			for (int i = 0; i < count; i++)
			{
				parent[i] = i;
			}
			Dictionary<Vector3Int, int> byPoint = new Dictionary<Vector3Int, int>();
			for (int j = 0; j < count; j++)
			{
				Vector3Int key = Vector3Int.RoundToInt(half.Positions[j] / WeldGrid);
				if (byPoint.TryGetValue(key, out var value))
				{
					Union(j, value);
				}
				else
				{
					byPoint[key] = j;
				}
			}
			List<int>[] array = new List<int>[2] { half.Surface, half.Cap };
			foreach (List<int> triangles in array)
			{
				for (int k = 2; k < triangles.Count; k += 3)
				{
					Union(triangles[k - 2], triangles[k - 1]);
					Union(triangles[k - 1], triangles[k]);
				}
			}
			Dictionary<int, Half> byRoot = new Dictionary<int, Half>();
			int[] remap = new int[count];
			for (int l = 0; l < count; l++)
			{
				remap[l] = -1;
			}
			Copy(half.Surface, cap: false);
			Copy(half.Cap, cap: true);
			foreach (Half piece in byRoot.Values)
			{
				if (piece.Surface.Count / 3 >= minTriangles)
				{
					pieces.Add(piece);
				}
			}
			void Copy(List<int> triangles, bool cap)
			{
				for (int m = 2; m < triangles.Count; m += 3)
				{
					int root = Find(triangles[m - 2]);
					if (!byRoot.TryGetValue(root, out var piece))
					{
						piece = new Half();
						byRoot[root] = piece;
					}
					List<int> target = (cap ? piece.Cap : piece.Surface);
					target.Add(Map(piece, triangles[m - 2]));
					target.Add(Map(piece, triangles[m - 1]));
					target.Add(Map(piece, triangles[m]));
				}
			}
			int Find(int i)
			{
				while (parent[i] != i)
				{
					parent[i] = parent[parent[i]];
					i = parent[i];
				}
				return i;
			}
			int Map(Half piece, int i)
			{
				if (remap[i] < 0)
				{
					remap[i] = piece.Positions.Count;
					piece.Positions.Add(half.Positions[i]);
					piece.Normals.Add(half.Normals[i]);
					piece.Uvs.Add(half.Uvs[i]);
				}
				return remap[i];
			}
			void Union(int a, int b)
			{
				int ra = Find(a);
				int rb = Find(b);
				if (ra != rb)
				{
					parent[ra] = rb;
				}
			}
		}

		public static void CapIslands(Half piece, List<CapIsland> islands)
		{
			islands.Clear();
			List<int> cap = piece.Cap;
			int triangleCount = cap.Count / 3;
			if (triangleCount == 0)
			{
				return;
			}
			int[] parent = new int[triangleCount];
			for (int i = 0; i < triangleCount; i++)
			{
				parent[i] = i;
			}
			Dictionary<Vector3Int, int> byPoint = new Dictionary<Vector3Int, int>();
			for (int t = 0; t < triangleCount; t++)
			{
				for (int k = 0; k < 3; k++)
				{
					Vector3Int key = Vector3Int.RoundToInt(piece.Positions[cap[t * 3 + k]] / WeldGrid);
					if (byPoint.TryGetValue(key, out var value))
					{
						int ra = Find(t);
						int rb = Find(value);
						if (ra != rb)
						{
							parent[ra] = rb;
						}
					}
					else
					{
						byPoint[key] = t;
					}
				}
			}
			Dictionary<int, int> rootIndex = new Dictionary<int, int>();
			for (int t2 = 0; t2 < triangleCount; t2++)
			{
				Vector3 a = piece.Positions[cap[t2 * 3]];
				Vector3 b = piece.Positions[cap[t2 * 3 + 1]];
				Vector3 c = piece.Positions[cap[t2 * 3 + 2]];
				int root = Find(t2);
				if (!rootIndex.TryGetValue(root, out var index))
				{
					index = (rootIndex[root] = islands.Count);
					islands.Add(new CapIsland
					{
						Facing = piece.Normals[cap[t2 * 3]]
					});
				}
				float area = Vector3.Cross(b - a, c - a).magnitude * 0.5f;
				CapIsland island = islands[index];
				island.Center += (a + b + c) / 3f * area;
				island.Area += area;
				islands[index] = island;
			}
			for (int j = 0; j < islands.Count; j++)
			{
				CapIsland island2 = islands[j];
				if (island2.Area > 0f)
				{
					island2.Center /= island2.Area;
				}
				islands[j] = island2;
			}
			for (int l = 0; l < cap.Count; l++)
			{
				int index2 = rootIndex[Find(l / 3)];
				CapIsland island3 = islands[index2];
				Vector3 position = piece.Positions[cap[l]];
				island3.Radius = Mathf.Max(island3.Radius, Vector3.Distance(position, island3.Center));
				islands[index2] = island3;
			}
			islands.Sort((CapIsland x, CapIsland y) => y.Area.CompareTo(x.Area));
			int Find(int i)
			{
				while (parent[i] != i)
				{
					parent[i] = parent[parent[i]];
					i = parent[i];
				}
				return i;
			}
		}

		private static float Hash(Vector3 cell)
		{
			float h = Mathf.Sin(Vector3.Dot(cell, new Vector3(127.1f, 311.7f, 74.7f))) * 43758.5453f;
			return h - Mathf.Floor(h);
		}

		private static float ValueNoise(Vector3 p)
		{
			Vector3 i = new Vector3(Mathf.Floor(p.x), Mathf.Floor(p.y), Mathf.Floor(p.z));
			Vector3 f = p - i;
			Vector3 u = new Vector3(f.x * f.x * (3f - 2f * f.x), f.y * f.y * (3f - 2f * f.y), f.z * f.z * (3f - 2f * f.z));
			float a = Hash(i);
			float b = Hash(i + Vector3.right);
			float c = Hash(i + Vector3.up);
			float d = Hash(i + Vector3.right + Vector3.up);
			float e = Hash(i + Vector3.forward);
			float g = Hash(i + Vector3.right + Vector3.forward);
			float h = Hash(i + Vector3.up + Vector3.forward);
			float k = Hash(i + Vector3.one);
			return Mathf.Lerp(Mathf.Lerp(Mathf.Lerp(a, b, u.x), Mathf.Lerp(c, d, u.x), u.y), Mathf.Lerp(Mathf.Lerp(e, g, u.x), Mathf.Lerp(h, k, u.x), u.y), u.z);
		}

		private static float Tear(Vector3 position)
		{
			Vector3 p = position * TearFrequency;
			return (ValueNoise(p) * 0.55f + ValueNoise(p * 2.7f) * 0.3f + ValueNoise(p * 7.1f) * 0.15f) * 2f - 1f;
		}

		private static void BuildCap(Half half, List<(int a, int b)> segments, Vector3 facing, Rect uvRect, Vector3 planeNormal, float roughness)
		{
			if (segments.Count == 0)
			{
				return;
			}
			int[] parent = new int[segments.Count];
			for (int i = 0; i < parent.Length; i++)
			{
				parent[i] = i;
			}
			Dictionary<Vector3Int, int> byPoint = new Dictionary<Vector3Int, int>();
			for (int j = 0; j < segments.Count; j++)
			{
				Link(j, half.Positions[segments[j].a]);
				Link(j, half.Positions[segments[j].b]);
			}
			Dictionary<int, (Vector3 sum, int count)> loops = new Dictionary<int, (Vector3 sum, int count)>();
			for (int k = 0; k < segments.Count; k++)
			{
				int root = Find(k);
				loops.TryGetValue(root, out var loop);
				loops[root] = (loop.sum + half.Positions[segments[k].a] + half.Positions[segments[k].b], loop.count + 2);
			}
			Vector3 axis = ((Mathf.Abs(facing.y) < 0.9f) ? Vector3.up : Vector3.right);
			Vector3 tangent = Vector3.Cross(facing, axis).normalized;
			Vector3 bitangent = Vector3.Cross(facing, tangent);
			int vertexCount = half.Positions.Count;
			Dictionary<Vector3Int, int> capVertices = new Dictionary<Vector3Int, int>();
			Dictionary<int, Vector3> centers = new Dictionary<int, Vector3>();
			for (int l = 0; l < segments.Count; l++)
			{
				int root2 = Find(l);
				if (!centers.ContainsKey(root2))
				{
					(Vector3 sum, int count) tuple = loops[root2];
					Vector3 center = tuple.sum / tuple.count;
					if (roughness > 0f)
					{
						center += planeNormal * (Tear(center) * roughness);
					}
					centers[root2] = center;
				}
			}
			Dictionary<int, int> splits = new Dictionary<int, int>();
			if (roughness > 0f)
			{
				for (int m = 0; m < segments.Count; m++)
				{
					int root3 = Find(m);
					Vector3 center2 = centers[root3];
					Vector3 a = half.Positions[segments[m].a];
					Vector3 b = half.Positions[segments[m].b];
					float area = Vector3.Cross(a - center2, b - center2).magnitude * 0.5f;
					int depth = 0;
					while (depth < MaxCapSplits && area > MinCapFacetArea)
					{
						depth++;
						area *= 0.25f;
					}
					splits.TryGetValue(root3, out var current);
					splits[root3] = Mathf.Max(current, depth);
				}
			}
			for (int n = 0; n < segments.Count; n++)
			{
				int root4 = Find(n);
				Vector3 center3 = centers[root4];
				Vector3 a2 = half.Positions[segments[n].a];
				Vector3 b2 = half.Positions[segments[n].b];
				if ((a2 - b2).sqrMagnitude < 1E-08f)
				{
					continue;
				}
				if (Vector3.Dot(Vector3.Cross(a2 - center3, b2 - center3), facing) >= 0f)
				{
					Vector3 swap = a2;
					a2 = b2;
					b2 = swap;
				}
				Vector2 centerUv = uvRect.center;
				Vector2 uvB = Rim(b2 - center3);
				Vector2 uvA = Rim(a2 - center3);
				if (roughness > 0f)
				{
					Split(new CapPoint
					{
						Position = center3,
						Uv = centerUv,
						Locked = false
					}, new CapPoint
					{
						Position = b2,
						Uv = uvB,
						Locked = true
					}, new CapPoint
					{
						Position = a2,
						Uv = uvA,
						Locked = true
					}, 0, splits[root4]);
				}
				else
				{
					Facet(center3, centerUv, b2, uvB, a2, uvA);
				}
			}
			for (int num = vertexCount; num < half.Normals.Count; num++)
			{
				Vector3 normal = half.Normals[num];
				half.Normals[num] = ((normal.sqrMagnitude < 1E-16f) ? facing : normal.normalized);
			}
			int CapVertex(Vector3 position, Vector2 uv)
			{
				Vector3Int key = Vector3Int.RoundToInt(position / WeldGrid);
				if (!capVertices.TryGetValue(key, out var index))
				{
					half.Positions.Add(position);
					half.Normals.Add(Vector3.zero);
					half.Uvs.Add(uv);
					index = half.Positions.Count - 1;
					capVertices[key] = index;
				}
				return index;
			}
			void Facet(Vector3 p0, Vector2 t0, Vector3 p1, Vector2 t1, Vector3 p2, Vector2 t2)
			{
				int i0 = CapVertex(p0, t0);
				int i1 = CapVertex(p1, t1);
				int i2 = CapVertex(p2, t2);
				if (i0 != i1 && i1 != i2 && i2 != i0)
				{
					Vector3 faceNormal = Vector3.Cross(p1 - p0, p2 - p0);
					if (Vector3.Dot(faceNormal, facing) < 0f)
					{
						faceNormal = -faceNormal;
					}
					half.Normals[i0] += faceNormal;
					half.Normals[i1] += faceNormal;
					half.Normals[i2] += faceNormal;
					half.Cap.Add(i0);
					half.Cap.Add(i1);
					half.Cap.Add(i2);
				}
			}
			int Find(int i)
			{
				while (parent[i] != i)
				{
					parent[i] = parent[parent[i]];
					i = parent[i];
				}
				return i;
			}
			void Link(int segment, Vector3 point)
			{
				Vector3Int key = Vector3Int.RoundToInt(point / WeldGrid);
				if (byPoint.TryGetValue(key, out var other))
				{
					parent[Find(segment)] = Find(other);
				}
				else
				{
					byPoint[key] = segment;
				}
			}
			CapPoint Mid(CapPoint x, CapPoint y, int depth)
			{
				Vector3 position = (x.Position + y.Position) * 0.5f;
				Vector2 uv = Vector2.Lerp(x.Uv, y.Uv, 0.5f);
				if (x.Locked && y.Locked)
				{
					return new CapPoint
					{
						Position = position,
						Uv = uv,
						Locked = true
					};
				}
				float relief = roughness * InteriorRelief * Mathf.Pow(2f, -depth);
				return new CapPoint
				{
					Position = position + planeNormal * (relief * Tear(position)),
					Uv = uv,
					Locked = false
				};
			}
			Vector2 Rim(Vector3 offset)
			{
				Vector2 direction = new Vector2(Vector3.Dot(offset, tangent), Vector3.Dot(offset, bitangent));
				if (direction.sqrMagnitude < 1E-12f)
				{
					return uvRect.center;
				}
				return uvRect.center + direction.normalized * (uvRect.size * 0.5f);
			}
			void Split(CapPoint x, CapPoint y, CapPoint z, int depth, int splitCount)
			{
				if (depth < splitCount)
				{
					CapPoint xy = Mid(x, y, depth);
					CapPoint yz = Mid(y, z, depth);
					CapPoint zx = Mid(z, x, depth);
					Split(x, xy, zx, depth + 1, splitCount);
					Split(xy, y, yz, depth + 1, splitCount);
					Split(zx, yz, z, depth + 1, splitCount);
					Split(xy, yz, zx, depth + 1, splitCount);
				}
				else
				{
					Facet(x.Position, x.Uv, y.Position, y.Uv, z.Position, z.Uv);
				}
			}
		}
	}
}
