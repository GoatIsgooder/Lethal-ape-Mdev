using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmWireMeshes
	{
		private sealed class MeshBuilder
		{
			private readonly List<Vector3> _v = new List<Vector3>();

			private readonly List<Vector3> _n = new List<Vector3>();

			private readonly List<int> _t = new List<int>();

			public void Tube(Vector3 a, Vector3 b, float r, int segs)
			{
				Vector3 dir = (b - a).normalized;
				Vector3 up = Mathf.Abs(dir.y) < 0.9f ? Vector3.up : Vector3.right;
				Vector3 side = Vector3.Cross(dir, up).normalized;
				Vector3 up2 = Vector3.Cross(dir, side);
				int start = _v.Count;
				for (int i = 0; i <= segs; i++)
				{
					float ang = i * Mathf.PI * 2f / segs;
					Vector3 n = side * Mathf.Cos(ang) + up2 * Mathf.Sin(ang);
					_v.Add(a + n * r);
					_n.Add(n);
					_v.Add(b + n * r);
					_n.Add(n);
				}
				for (int i = 0; i < segs; i++)
				{
					int k = start + i * 2;
					_t.Add(k);
					_t.Add(k + 2);
					_t.Add(k + 1);
					_t.Add(k + 1);
					_t.Add(k + 2);
					_t.Add(k + 3);
				}
			}

			public void Node(Vector3 c, float r)
			{
				Vector3[] dirs = new Vector3[6]
				{
					Vector3.up,
					Vector3.down,
					Vector3.left,
					Vector3.right,
					Vector3.forward,
					Vector3.back
				};
				int start = _v.Count;
				for (int i = 0; i < dirs.Length; i++)
				{
					_v.Add(c + dirs[i] * r);
					_n.Add(dirs[i]);
				}
				int[] tris = new int[24]
				{
					0, 4, 3, 0, 3, 5, 0, 5, 2, 0, 2, 4,
					1, 3, 4, 1, 5, 3, 1, 2, 5, 1, 4, 2
				};
				for (int i = 0; i < tris.Length; i++)
				{
					_t.Add(start + tris[i]);
				}
			}

			public void Quad(Vector3 a, Vector3 b, Vector3 c, Vector3 d, Vector3 n)
			{
				QuadSmooth(a, b, c, d, n, n, n, n);
			}

			public void QuadSmooth(Vector3 a, Vector3 b, Vector3 c, Vector3 d, Vector3 na, Vector3 nb, Vector3 nc, Vector3 nd)
			{
				int start = _v.Count;
				_v.Add(a);
				_v.Add(b);
				_v.Add(c);
				_v.Add(d);
				_n.Add(na);
				_n.Add(nb);
				_n.Add(nc);
				_n.Add(nd);
				_t.Add(start);
				_t.Add(start + 1);
				_t.Add(start + 2);
				_t.Add(start);
				_t.Add(start + 2);
				_t.Add(start + 3);
			}

			public Mesh Build(string name)
			{
				Mesh mesh = new Mesh();
				mesh.name = name;
				mesh.SetVertices(_v);
				mesh.SetNormals(_n);
				mesh.SetTriangles(_t, 0);
				mesh.RecalculateBounds();
				return mesh;
			}
		}

		private static Mesh _dodecahedron;

		private static Mesh _hexNut;

		public static Mesh Dodecahedron(float tubeRadius = 0.035f)
		{
			if (_dodecahedron != null)
			{
				return _dodecahedron;
			}
			List<Vector3> pts = new List<Vector3>();
			for (int x = -1; x <= 1; x += 2)
			{
				for (int y = -1; y <= 1; y += 2)
				{
					for (int z = -1; z <= 1; z += 2)
					{
						pts.Add(new Vector3(x, y, z));
					}
				}
			}
			for (int i = -1; i <= 1; i += 2)
			{
				for (int j = -1; j <= 1; j += 2)
				{
					pts.Add(new Vector3(0f, i * 0.618034f, j * 1.618034f));
					pts.Add(new Vector3(i * 0.618034f, j * 1.618034f, 0f));
					pts.Add(new Vector3(i * 1.618034f, 0f, j * 0.618034f));
				}
			}
			for (int k = 0; k < pts.Count; k++)
			{
				pts[k] = pts[k] * 0.57735026f;
			}
			MeshBuilder mb = new MeshBuilder();
			for (int a = 0; a < pts.Count; a++)
			{
				for (int b = a + 1; b < pts.Count; b++)
				{
					if (Mathf.Abs(Vector3.Distance(pts[a], pts[b]) - 0.7136442f) < 0.01f)
					{
						mb.Tube(pts[a], pts[b], tubeRadius, 6);
					}
				}
			}
			foreach (Vector3 p in pts)
			{
				mb.Node(p, tubeRadius * 1.9f);
			}
			_dodecahedron = mb.Build("BtmCageDodecahedron");
			return _dodecahedron;
		}

		public static Mesh HexNut()
		{
			if (_hexNut != null)
			{
				return _hexNut;
			}
			Vector3[] outer = new Vector3[12];
			Vector3[] inner = new Vector3[12];
			for (int i = 0; i < 12; i++)
			{
				int k = i / 2;
				float a0 = k * Mathf.PI * 2f / 6f;
				float a1 = (k + 1) * Mathf.PI * 2f / 6f;
				float t = (i % 2) * 0.5f;
				Vector3 p0 = new Vector3(Mathf.Cos(a0) * 0.5773503f, 0f, Mathf.Sin(a0) * 0.5773503f);
				Vector3 p1 = new Vector3(Mathf.Cos(a1) * 0.5773503f, 0f, Mathf.Sin(a1) * 0.5773503f);
				outer[i] = Vector3.Lerp(p0, p1, t);
				float ai = i * Mathf.PI * 2f / 12f;
				inner[i] = new Vector3(Mathf.Cos(ai) * 0.28f, 0f, Mathf.Sin(ai) * 0.28f);
			}
			MeshBuilder mb = new MeshBuilder();
			Vector3 h = Vector3.up * 0.225f;
			for (int i = 0; i < 12; i++)
			{
				int j = (i + 1) % 12;
				mb.Quad(outer[i] + h, outer[j] + h, inner[j] + h, inner[i] + h, Vector3.up);
				mb.Quad(inner[i] - h, inner[j] - h, outer[j] - h, outer[i] - h, Vector3.down);
				Vector3 n = new Vector3((outer[i].x + outer[j].x) * 0.5f, 0f, (outer[i].z + outer[j].z) * 0.5f).normalized;
				mb.Quad(outer[j] - h, outer[j] + h, outer[i] + h, outer[i] - h, n);
				mb.QuadSmooth(inner[i] - h, inner[i] + h, inner[j] + h, inner[j] - h, -inner[i].normalized, -inner[i].normalized, -inner[j].normalized, -inner[j].normalized);
			}
			_hexNut = mb.Build("BtmSalvageNut");
			return _hexNut;
		}
	}
}
