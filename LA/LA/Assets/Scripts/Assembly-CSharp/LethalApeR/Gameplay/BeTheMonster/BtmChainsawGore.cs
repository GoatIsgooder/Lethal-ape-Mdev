using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DisallowMultipleComponent]
	public sealed class BtmChainsawGore : MonoBehaviour
	{
		[Serializable]
		public class BoneCut
		{
			public float radius = 0.02f;

			public int count = 1;

			public float spacing;

			[Tooltip("Real bone geometry to stand in the cut. Without one the cut falls back to a flat marrow disc.")]
			public Mesh mesh;

			[Tooltip("How far the stub sticks out of the cut face, in metres.")]
			public float stickOut = 0.03f;

			[Tooltip("How wide the stub ends up across the bone, in metres. 0 sizes it off the cut face it sits in.")]
			public float meshWidth;

			[Tooltip("How long the stub is along the bone, in metres. 0 keeps the mesh's own proportions.")]
			public float meshLength;

			[Tooltip("How deep the stub is into the body, in metres. 0 keeps it as deep as it is wide.")]
			public float meshDepth;
		}

		public struct Piece
		{
			public Rigidbody Body;

			public List<BtmMeshSlicer.CapIsland> Islands;

			public bool Front;
		}

		public sealed class Skeleton
		{
			public Vector3 Torso;

			public Vector3 Head;

			public Vector3? Neck;

			public readonly Vector3?[] Upper = new Vector3?[2];

			public readonly Vector3?[] Lower = new Vector3?[2];

			public readonly Vector3?[] Hand = new Vector3?[2];

			public float Size;

			public static Skeleton Of(BtmRig rig)
			{
				Skeleton skeleton = new Skeleton
				{
					Torso = rig.Torso.position,
					Head = rig.Head.position,
					Neck = rig.Neck ? rig.Neck.position : null,
					Size = rig.Size
				};
				for (int i = 0; i < 2; i++)
				{
					skeleton.Upper[i] = rig.Upper[i] ? rig.Upper[i].position : null;
					skeleton.Lower[i] = rig.Lower[i] ? rig.Lower[i].position : null;
					skeleton.Hand[i] = rig.Hand[i] ? rig.Hand[i].position : null;
				}
				return skeleton;
			}

			public void Shift(Vector3 by)
			{
				Torso += by;
				Head += by;
				Neck += by;
				for (int i = 0; i < 2; i++)
				{
					Upper[i] += by;
					Lower[i] += by;
					Hand[i] += by;
				}
			}
		}

		public struct BoneCrossing
		{
			public Vector3 Point;

			public float Radius;

			public Vector3 Direction;

			public Mesh Mesh;

			public float StickOut;

			public float Width;

			public float Length;

			public float Depth;
		}

		private const float ApeSize = 0.48f;

		[Header("Blood")]
		[SerializeField]
		private BtmBloodBurst cutSprayPrefab;

		[SerializeField]
		private BtmBloodBurst spurtPrefab;

		[SerializeField]
		private int maxSpurts = 4;

		[SerializeField]
		private float minSpurtArea = 0.002f;

		[SerializeField]
		private AudioClip[] spillClips;

		[Header("Bones")]
		[Tooltip("The marrow disc's material: vertex coloured.")]
		[SerializeField]
		private Material boneMaterial;

		[Tooltip("For real bone meshes, which carry no vertex colour.")]
		[SerializeField]
		private Material boneMeshMaterial;

		[Tooltip("How much of a cut face a bone shaft spans when its width is left at 0.")]
		[SerializeField]
		[Range(0.1f, 1f)]
		private float boneFaceFraction = 0.5f;

		[SerializeField]
		private BoneCut spine = new BoneCut
		{
			radius = 0.026f
		};

		[SerializeField]
		private BoneCut neck = new BoneCut
		{
			radius = 0.018f
		};

		[SerializeField]
		private BoneCut upperArmLeft = new BoneCut
		{
			radius = 0.016f
		};

		[SerializeField]
		private BoneCut upperArmRight = new BoneCut
		{
			radius = 0.016f
		};

		[SerializeField]
		private BoneCut forearmLeft = new BoneCut
		{
			radius = 0.011f,
			count = 2,
			spacing = 0.024f
		};

		[SerializeField]
		private BoneCut forearmRight = new BoneCut
		{
			radius = 0.011f,
			count = 2,
			spacing = 0.024f
		};

		[Header("Guts")]
		[SerializeField]
		private Material gutsMaterial;

		[SerializeField]
		private int lowerStrands = 2;

		[SerializeField]
		private int upperStrands = 1;

		[SerializeField]
		private Vector2 strandLength = new Vector2(0.45f, 0.8f);

		[SerializeField]
		private float strandRadius = 0.02f;

		[SerializeField]
		private float spillSpeed = 1.6f;

		[SerializeField]
		private float minGutArea = 0.01f;

		[Header("Landing")]
		[SerializeField]
		private float splatSpeed = 1.4f;

		[SerializeField]
		private int maxSplashes = 2;

		[SerializeField]
		private float poolScale = 1.6f;

		private static Mesh _boneDisc;

		private readonly List<BoneCrossing> _crossings = new List<BoneCrossing>();

		private readonly List<(Piece piece, BtmMeshSlicer.CapIsland island)> _faces = new List<(Piece piece, BtmMeshSlicer.CapIsland island)>();

		private BtmGore _gore;

		public float SplatSpeed => splatSpeed;

		private void Awake()
		{
			_gore = GetComponent<BtmGore>();
		}

		public void CollectMaterials(List<Material> into)
		{
			if (boneMaterial)
			{
				into.Add(boneMaterial);
			}
			if (boneMeshMaterial)
			{
				into.Add(boneMeshMaterial);
			}
			if (gutsMaterial)
			{
				into.Add(gutsMaterial);
			}
		}

		public void Decorate(List<Piece> pieces, Plane plane, Vector3 center, Skeleton skeleton, BtmCutRemains remains)
		{
			bool fx = !_gore || _gore.InFxRange(center);
			if (_gore)
			{
				if (fx)
				{
					_gore.Burst(cutSprayPrefab, center, plane.normal);
				}
				_gore.Play(spillClips, center);
			}
			_faces.Clear();
			foreach (Piece piece in pieces)
			{
				foreach (BtmMeshSlicer.CapIsland island in piece.Islands)
				{
					_faces.Add((piece, island));
				}
			}
			_faces.Sort((x, y) => y.island.Area.CompareTo(x.island.Area));
			float scale = skeleton.Size / ApeSize;
			if (fx)
			{
				Spurts();
			}
			Bones(plane, skeleton, scale);
			Guts(scale);
			foreach (Piece piece in pieces)
			{
				Vector3 size = piece.Body.GetComponent<MeshFilter>().sharedMesh.bounds.size;
				piece.Body.gameObject.AddComponent<BtmGorePiece>().Init(this, remains, Mathf.Max(size.x, Mathf.Max(size.y, size.z)) * 0.6f);
			}
		}

		public void DecorateNeck(Plane plane, Skeleton skeleton, Rigidbody head, Matrix4x4 headFromCut, List<BtmMeshSlicer.CapIsland> headFaces, Transform stump, Matrix4x4 stumpFromCut, List<BtmMeshSlicer.CapIsland> stumpFaces, BtmCutRemains remains)
		{
			Vector3 at = stump ? stump.position : head.worldCenterOfMass;
			bool fx = !_gore || _gore.InFxRange(at);
			if (_gore)
			{
				if (fx && stump)
				{
					_gore.Burst(cutSprayPrefab, at, stump.forward);
				}
				_gore.Play(spillClips, at);
			}
			if (fx && spurtPrefab && _gore)
			{
				if (stump && stumpFaces.Count > 0)
				{
					_gore.Burst(spurtPrefab, stump.TransformPoint(stumpFaces[0].Center), stump.TransformDirection(stumpFaces[0].Facing), stump);
				}
				if (headFaces.Count > 0)
				{
					Transform headTransform = head.transform;
					_gore.Burst(spurtPrefab, headTransform.TransformPoint(headFaces[0].Center), headTransform.TransformDirection(headFaces[0].Facing), headTransform);
				}
			}
			if (boneMaterial && skeleton.Neck.HasValue)
			{
				_crossings.Clear();
				Cross(plane, skeleton.Neck, skeleton.Head, neck, skeleton.Size / ApeSize, _crossings);
				foreach (BoneCrossing crossing in _crossings)
				{
					if (headFaces.Count > 0)
					{
						ShowBone(head.transform, headFaces[0], headFromCut.MultiplyPoint3x4(crossing.Point), headFromCut.MultiplyVector(crossing.Direction), crossing);
					}
					if (stump && stumpFaces.Count > 0)
					{
						ShowBone(stump, stumpFaces[0], stumpFromCut.MultiplyPoint3x4(crossing.Point), stumpFromCut.MultiplyVector(crossing.Direction), crossing);
					}
				}
			}
			Vector3 size = head.TryGetComponent<MeshFilter>(out MeshFilter filter) && filter.sharedMesh ? filter.sharedMesh.bounds.size : Vector3.one * 0.2f;
			head.gameObject.AddComponent<BtmGorePiece>().Init(this, remains, Mathf.Max(size.x, Mathf.Max(size.y, size.z)) * 0.6f);
		}

		public void Splat(Vector3 point, Vector3 normal, float speed, BtmCutRemains remains)
		{
			if (!_gore || !_gore.InFxRange(point))
			{
				return;
			}
			if (remains)
			{
				_gore.Splat(point, normal, speed, ref remains.Splashes, maxSplashes);
				return;
			}
			int splashes = maxSplashes;
			_gore.Splat(point, normal, speed, ref splashes, maxSplashes);
		}

		public void Pool(Vector3 center, float size)
		{
			if (_gore && _gore.InFxRange(center))
			{
				_gore.Pool(center, size * poolScale * UnityEngine.Random.Range(0.85f, 1.15f));
			}
		}

		public static void FindBoneCrossings(Plane plane, Skeleton skeleton, float scale, BoneCut spineCut, BoneCut neckCut, BoneCut[] upperArmCuts, BoneCut[] forearmCuts, List<BoneCrossing> crossings)
		{
			crossings.Clear();
			Cross(plane, skeleton.Torso, skeleton.Neck ?? skeleton.Head, spineCut, scale, crossings);
			if (skeleton.Neck.HasValue)
			{
				Cross(plane, skeleton.Neck, skeleton.Head, neckCut, scale, crossings);
			}
			for (int i = 0; i < 2; i++)
			{
				Cross(plane, skeleton.Upper[i], skeleton.Lower[i], upperArmCuts[i], scale, crossings);
				Cross(plane, skeleton.Lower[i], skeleton.Hand[i], forearmCuts[i], scale, crossings);
			}
		}

		private static void Cross(Plane plane, Vector3? from, Vector3? to, BoneCut cut, float scale, List<BoneCrossing> crossings)
		{
			if (!from.HasValue || cut == null || !to.HasValue)
			{
				return;
			}
			Vector3 a = from.Value;
			Vector3 b = to.Value;
			float da = plane.GetDistanceToPoint(a);
			float db = plane.GetDistanceToPoint(b);
			if (da * db > 0f || Mathf.Approximately(da, db))
			{
				return;
			}
			float t = Mathf.Clamp01(da / (da - db));
			Vector3 along = b - a;
			Vector3 side = Vector3.Cross(plane.normal, along);
			if (side.sqrMagnitude < 1E-08f)
			{
				side = Vector3.Cross(plane.normal, (Mathf.Abs(plane.normal.y) < 0.9f) ? Vector3.up : Vector3.right);
			}
			side = side.normalized;
			int count = Mathf.Max(1, cut.count);
			Vector3 direction = along.normalized;
			Vector3 point = a + along * t;
			for (int i = 0; i < count; i++)
			{
				float offset = (i - (count - 1) * 0.5f) * cut.spacing * scale;
				crossings.Add(new BoneCrossing
				{
					Point = point + side * offset,
					Radius = cut.radius * scale,
					Direction = direction,
					Mesh = cut.mesh,
					StickOut = cut.stickOut * scale,
					Width = cut.meshWidth * scale,
					Length = cut.meshLength * scale,
					Depth = cut.meshDepth * scale
				});
			}
		}

		private void Bones(Plane plane, Skeleton skeleton, float scale)
		{
			if (!boneMaterial)
			{
				return;
			}
			FindBoneCrossings(plane, skeleton, scale, spine, neck, new BoneCut[2] { upperArmLeft, upperArmRight }, new BoneCut[2] { forearmLeft, forearmRight }, _crossings);
			foreach (BoneCrossing crossing in _crossings)
			{
				ShowBone(crossing, front: true);
				ShowBone(crossing, front: false);
			}
		}

		private void ShowBone(BoneCrossing crossing, bool front)
		{
			Rigidbody best = null;
			BtmMeshSlicer.CapIsland bestFace = default(BtmMeshSlicer.CapIsland);
			float bestScore = float.MaxValue;
			foreach ((Piece piece, BtmMeshSlicer.CapIsland island) in _faces)
			{
				if (piece.Front != front)
				{
					continue;
				}
				Vector3 faceCenter = piece.Body.transform.TransformPoint(island.Center);
				float score = Vector3.Distance(faceCenter, crossing.Point) / Mathf.Max(island.Radius, 0.001f);
				if (score < 1f && score < bestScore)
				{
					best = piece.Body;
					bestFace = island;
					bestScore = score;
				}
			}
			if (best)
			{
				Transform t = best.transform;
				ShowBone(t, bestFace, t.InverseTransformPoint(crossing.Point), t.InverseTransformDirection(crossing.Direction), crossing);
			}
		}

		private void ShowBone(Transform t, BtmMeshSlicer.CapIsland face, Vector3 local, Vector3 along, BoneCrossing crossing)
		{
			GameObject bone = new GameObject("Bone");
			bone.layer = t.gameObject.layer;
			bone.transform.SetParent(t, false);
			Vector3 onFace = local - face.Facing * Vector3.Dot(face.Facing, local - face.Center);
			if (crossing.Mesh)
			{
				Vector3 up = (Vector3.Dot(along, face.Facing) < 0f) ? (-along) : along;
				Vector3 size = crossing.Mesh.bounds.size;
				int axis = (size.x > size.y && size.x > size.z) ? 0 : ((size.y > size.z) ? 1 : 2);
				float length = size[axis];
				int a = (axis + 1) % 3;
				int b = (axis + 2) % 3;
				float across = Mathf.Max(size[a], size[b]);
				float width = (crossing.Width > 0f) ? crossing.Width : (boneFaceFraction * (2f * Mathf.Sqrt(Mathf.Max(face.Area, 1E-06f) / Mathf.PI)));
				float widthScale = (across > 1E-06f) ? (width / across) : crossing.Radius;
				float lengthScale = (crossing.Length > 0f && length > 1E-06f) ? (crossing.Length / length) : widthScale;
				Vector3 meshAxis = (axis == 0) ? Vector3.right : ((axis == 1) ? Vector3.up : Vector3.forward);
				int wide = (size[a] >= size[b]) ? a : b;
				int deep = (size[a] >= size[b]) ? b : a;
				float depthScale = (crossing.Depth > 0f && size[deep] > 1E-06f) ? (crossing.Depth / size[deep]) : widthScale;
				Vector3 scale = Vector3.zero;
				scale[axis] = lengthScale;
				scale[wide] = widthScale;
				scale[deep] = depthScale;
				bone.transform.SetLocalPositionAndRotation(onFace + face.Facing * (crossing.StickOut - length * lengthScale * 0.5f), Quaternion.FromToRotation(meshAxis, up));
				bone.transform.localScale = scale;
				bone.AddComponent<MeshFilter>().sharedMesh = crossing.Mesh;
			}
			else
			{
				bone.transform.SetLocalPositionAndRotation(onFace + face.Facing * 0.002f, Quaternion.LookRotation(face.Facing, Vector3.up));
				bone.transform.localScale = Vector3.one * crossing.Radius;
				bone.AddComponent<MeshFilter>().sharedMesh = BoneDisc();
			}
			MeshRenderer meshRenderer = bone.AddComponent<MeshRenderer>();
			meshRenderer.sharedMaterial = (crossing.Mesh && boneMeshMaterial) ? boneMeshMaterial : boneMaterial;
			meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
		}

		private void Spurts()
		{
			if (!spurtPrefab || !_gore)
			{
				return;
			}
			int spurts = 0;
			foreach ((Piece piece, BtmMeshSlicer.CapIsland island) in _faces)
			{
				if (spurts++ >= maxSpurts || island.Area < minSpurtArea)
				{
					break;
				}
				Transform t = piece.Body.transform;
				_gore.Burst(spurtPrefab, t.TransformPoint(island.Center), t.TransformDirection(island.Facing), t);
			}
		}

		private void Guts(float scale)
		{
			if (!gutsMaterial)
			{
				return;
			}
			(Piece piece, BtmMeshSlicer.CapIsland island)? back = null;
			(Piece piece, BtmMeshSlicer.CapIsland island)? front = null;
			foreach ((Piece piece, BtmMeshSlicer.CapIsland island) face in _faces)
			{
				if (face.island.Area < minGutArea * scale * scale)
				{
					break;
				}
				if (face.piece.Front)
				{
					if (!front.HasValue)
					{
						front = face;
					}
				}
				else if (!back.HasValue)
				{
					back = face;
				}
			}
			bool frontIsUpper = !front.HasValue || !back.HasValue || front.Value.piece.Body.worldCenterOfMass.y >= back.Value.piece.Body.worldCenterOfMass.y;
			if (front.HasValue)
			{
				Spill(front.Value.piece, front.Value.island, frontIsUpper ? upperStrands : lowerStrands, scale);
			}
			if (back.HasValue)
			{
				Spill(back.Value.piece, back.Value.island, frontIsUpper ? lowerStrands : upperStrands, scale);
			}
		}

		private void Spill(Piece piece, BtmMeshSlicer.CapIsland island, int strands, float scale)
		{
			LayerMask floors = _gore ? _gore.floors : ((LayerMask)1);
			for (int i = 0; i < strands; i++)
			{
				Vector3 sideways = Vector3.ProjectOnPlane(UnityEngine.Random.onUnitSphere, island.Facing).normalized;
				float offset = UnityEngine.Random.Range(0f, island.Radius * 0.35f);
				float length = UnityEngine.Random.Range(strandLength.x, strandLength.y);
				float share = (i == 0) ? 1f : 0.7f;
				BtmGutRope.Spawn(piece.Body.transform, island.Center + sideways * offset, island.Facing, length * scale * share, strandRadius * scale * UnityEngine.Random.Range(0.85f, 1.15f), 10, gutsMaterial, floors, spillSpeed * UnityEngine.Random.Range(0.6f, 1.2f));
			}
		}

		private static Mesh BoneDisc()
		{
			if (_boneDisc)
			{
				return _boneDisc;
			}
			float[] radii = new float[3] { 0.42f, 0.56f, 1f };
			Color32[] rings = new Color32[3]
			{
				new Color32(120, 20, 18, byte.MaxValue),
				new Color32(226, 214, 188, byte.MaxValue),
				new Color32(196, 180, 152, byte.MaxValue)
			};
			List<Vector3> vertices = new List<Vector3> { Vector3.zero };
			List<Color32> colors = new List<Color32>
			{
				new Color32(70, 8, 8, byte.MaxValue)
			};
			for (int r = 0; r < radii.Length; r++)
			{
				for (int i = 0; i < 14; i++)
				{
					float angle = i * Mathf.PI * 2f / 14f;
					vertices.Add(new Vector3(Mathf.Cos(angle), Mathf.Sin(angle), 0f) * radii[r]);
					colors.Add(rings[r]);
				}
			}
			List<int> triangles = new List<int>();
			for (int i = 0; i < 14; i++)
			{
				int next = (i + 1) % 14;
				triangles.AddRange(new int[3] { 0, i + 1, next + 1 });
				for (int r = 1; r < radii.Length; r++)
				{
					int inner = 1 + (r - 1) * 14;
					int outer = 1 + r * 14;
					triangles.AddRange(new int[6] { inner + i, outer + i, outer + next, inner + i, outer + next, inner + next });
				}
			}
			_boneDisc = new Mesh
			{
				name = "Bone Cut"
			};
			_boneDisc.SetVertices(vertices);
			_boneDisc.SetColors(colors);
			Vector3[] normals = new Vector3[vertices.Count];
			for (int i = 0; i < normals.Length; i++)
			{
				normals[i] = Vector3.forward;
			}
			_boneDisc.SetNormals(normals);
			_boneDisc.SetUVs(0, new Vector2[vertices.Count]);
			_boneDisc.SetTriangles(triangles, 0);
			_boneDisc.RecalculateBounds();
			return _boneDisc;
		}
	}
}
