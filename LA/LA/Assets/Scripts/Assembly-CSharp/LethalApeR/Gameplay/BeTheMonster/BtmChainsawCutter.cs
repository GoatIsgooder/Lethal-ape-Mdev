using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using LethalApeR.Networking;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DisallowMultipleComponent]
	public sealed class BtmChainsawCutter : MonoBehaviour
	{
		private sealed class Draped
		{
			public SkinnedMeshRenderer Renderer;

			public bool IsBody;

			public Material[] Materials;

			public MaterialPropertyBlock[] Looks;

			public BtmCutMesh Data;

			public Vector3[] Posed;

			public Vector3[] PosedNormals;

			public Vector3[] Bind;

			public Vector3[] BindNormals;

			public Matrix4x4[] Skinning;

			public bool[] Headish;

			public int[] FirstWeight;

			public bool[] BackOnly;

			public readonly List<(int sub, BtmMeshSlicer.Half front, BtmMeshSlicer.Half back)> Parts = new List<(int sub, BtmMeshSlicer.Half front, BtmMeshSlicer.Half back)>();

			public bool HasFront;

			public bool HasBack;

			public Remade Remade;
		}

		private sealed class Remade
		{
			public Vector3[] Positions;

			public Vector3[] Normals;

			public Vector2[] Uvs;

			public Color32[] Colors;

			public byte[] BonesPerVertex;

			public BoneWeight1[] Weights;

			public List<int>[] Submeshes;

			public bool Meat;

			public bool Blood;

			public Mesh Mesh;
		}

		private sealed class Neck
		{
			public BtmCorpse Corpse;

			public string Name;

			public Plane Plane;

			public BtmChainsawGore.Skeleton Skeleton;

			public Vector3 HeadAt;

			public Quaternion HeadTurn;

			public Transform StumpBone;

			public Matrix4x4 StumpBoneFromWorld;

			public Quaternion StumpBoneTurn;

			public readonly List<Draped> Draped = new List<Draped>();

			public Draped Capped;

			public int CappedSub;

			public BtmCutPiece.Prepared Head;

			public Draped HeadSkin;

			public int HeadSub;

			public readonly List<(BtmCutPiece.PreparedShell shell, Draped from, int sub)> Shells = new List<(BtmCutPiece.PreparedShell shell, Draped from, int sub)>();

			public readonly List<BtmMeshSlicer.CapIsland> StumpFaces = new List<BtmMeshSlicer.CapIsland>();

			public BtmCutRemains Remains;

			public Rigidbody HeadBody;

			public BtmBodyPart HeadPart;

			public readonly List<Mesh> Stumps = new List<Mesh>();
		}

		private sealed class Surface
		{
			public string Name;

			public Vector3[] Positions;

			public Vector3[] Normals;

			public Vector2[] Uvs;

			public int[] Triangles;

			public Material Material;

			public MaterialPropertyBlock Look;

			public ShadowCastingMode Shadows;

			public bool ReceiveShadows;

			public LightProbeUsage Probes;

			public ReflectionProbeUsage Reflections;
		}

		private sealed class Worn
		{
			public string Name;

			public Mesh Mesh;

			public Material[] Materials;

			public MaterialPropertyBlock[] Looks;

			public Vector3 Position;

			public Quaternion Rotation;

			public Vector3 Scale;

			public Bounds Bounds;

			public ShadowCastingMode Shadows;

			public bool ReceiveShadows;

			public LightProbeUsage Probes;

			public ReflectionProbeUsage Reflections;
		}

		private sealed class Throw
		{
			public Rigidbody Body;

			public Vector3 Velocity;

			public Vector3 Angular;
		}

		private sealed class Sliced
		{
			public readonly List<(BtmCutPiece.Prepared piece, bool front, float share)> Pieces = new List<(BtmCutPiece.Prepared piece, bool front, float share)>();

			public readonly List<(BtmCutPiece.PreparedShell shell, int host, Surface surface)> Shells = new List<(BtmCutPiece.PreparedShell shell, int host, Surface surface)>();
		}

		private sealed class Job
		{
			public MonkeDevNetworkingPlayer Victim;

			public Action Revealed;

			public string Name;

			public Plane Plane;

			public Vector3 Center;

			public Vector3 Carried;

			public float At;

			public Surface Body;

			public readonly List<Surface> Outfit = new List<Surface>();

			public readonly List<Worn> Rigid = new List<Worn>();

			public BtmChainsawGore.Skeleton Skeleton;

			public BtmCutRemains Remains;

			public readonly List<BtmChainsawGore.Piece> Pieces = new List<BtmChainsawGore.Piece>();

			public readonly List<BtmCutPiece.Prepared> Prepared = new List<BtmCutPiece.Prepared>();

			public readonly List<Throw> Throws = new List<Throw>();
		}

		private const double NeckMillisecondsPerFrame = 1.5;

		private const float HeadWeighted = 0.5f;

		[Header("Head Pop")]
		[Tooltip("Where the neck tears, from the bottom of the neck (0) to the bottom of the head (1).")]
		[SerializeField]
		[Range(0.1f, 0.9f)]
		private float neckTearAt = 0.5f;

		[Tooltip("How hard the head comes off, up out of the neck, in m/s.")]
		[SerializeField]
		private float popSpeed = 3.2f;

		[Tooltip("How far off straight up it can go, in m/s sideways.")]
		[SerializeField]
		private float popScatter = 0.9f;

		[SerializeField]
		private float popSpin = 9f;

		[SerializeField]
		private float headMass = 2.6f;

		private readonly Queue<Neck> _necks = new Queue<Neck>();

		private readonly BtmCutPiece.Settings _neckSettings = new BtmCutPiece.Settings();

		private Coroutine _neckWorker;

		private Neck _currentNeck;

		private const float MaxInheritedSpeed = 14f;

		private const double ShellMillisecondsPerFrame = 1.5;

		private const float HideBodySeconds = 3f;

		[Header("Look")]
		[SerializeField]
		private Material capMaterial;

		[Tooltip("The meat disc on the cap material's texture.")]
		[SerializeField]
		private Rect capUvRect = new Rect(0.518f, 0.524f, 0.43f, 0.45f);

		[SerializeField]
		private Material woundMaterial;

		[Tooltip("How far the cut wanders off the flat plane, in metres. 0 is a clean planar slice.")]
		[SerializeField]
		private float cutRoughness = 0.022f;

		[SerializeField]
		private float soakDepth = 0.12f;

		[SerializeField]
		private BtmChainsawGore gore;

		[SerializeField]
		private AudioClip[] cutClips;

		[Header("Physics")]
		[SerializeField]
		private float bodyMass = 12f;

		[SerializeField]
		private float separationSpeed = 1.8f;

		[SerializeField]
		private float spreadSpeed = 1.2f;

		[SerializeField]
		private float liftSpeed = 1.4f;

		[SerializeField]
		private float spin = 5f;

		[Header("Budget")]
		[Tooltip("Cut bodies lying around at once; the oldest sinks away to make room.")]
		[SerializeField]
		[Min(1f)]
		private int maxCuts = 3;

		[SerializeField]
		private float lifetime = 15f;

		private readonly Queue<Job> _jobs = new Queue<Job>();

		private readonly List<Vector3> _positions = new List<Vector3>();

		private readonly List<Vector3> _normals = new List<Vector3>();

		private readonly List<Renderer> _renderers = new List<Renderer>();

		private readonly List<SkinnedMeshRenderer> _skinned = new List<SkinnedMeshRenderer>();

		private readonly List<MeshRenderer> _rigid = new List<MeshRenderer>();

		private readonly List<Material> _materials = new List<Material>();

		private readonly List<Matrix4x4> _skinning = new List<Matrix4x4>();

		private readonly List<BtmCutRemains> _cuts = new List<BtmCutRemains>();

		private readonly BtmCutPiece.Settings _settings = new BtmCutPiece.Settings();

		private BtmGore _gore;

		private Coroutine _worker;

		private Job _current;

		private int _count;

		private const int MaxPiecesPerSide = 4;

		private const float MinPieceShare = 0.015f;

		public static BtmChainsawCutter Instance { get; private set; }

		public bool Decapitate(BtmCorpse corpse)
		{
			if (!corpse)
			{
				return false;
			}
			BtmRig rig = corpse.Rig;
			if (rig == null || !rig.Valid || !rig.Body || !rig.Neck)
			{
				return false;
			}
			if (!Gather(corpse.transform, rig.Body))
			{
				return false;
			}
			Vector3 up = rig.Head.position - rig.Neck.position;
			if (up.sqrMagnitude < 1E-08f)
			{
				return false;
			}
			Neck neck = new Neck();
			neck.Corpse = corpse;
			neck.Name = corpse.name;
			neck.Plane = new Plane(up.normalized, Vector3.Lerp(rig.Neck.position, rig.Head.position, neckTearAt));
			neck.Skeleton = BtmChainsawGore.Skeleton.Of(rig);
			neck.HeadAt = rig.Head.position;
			neck.HeadTurn = rig.Head.rotation;
			neck.StumpBone = rig.Neck;
			neck.StumpBoneFromWorld = rig.Neck.worldToLocalMatrix;
			neck.StumpBoneTurn = rig.Neck.rotation;
			foreach (SkinnedMeshRenderer smr in _skinned)
			{
				Transform[] bones = smr.bones;
				if (bones.Length == 0)
				{
					continue;
				}
				BtmCutMesh mesh = BtmCutMeshes.Get(smr.sharedMesh);
				if (mesh == null || mesh.Bindposes.Length == 0)
				{
					continue;
				}
				Draped draped = new Draped();
				draped.Renderer = smr;
				draped.IsBody = smr == rig.Body;
				draped.Data = mesh;
				draped.Bind = new Vector3[mesh.Positions.Length];
				draped.BindNormals = new Vector3[mesh.Positions.Length];
				if (!Skin(smr, mesh, draped.Bind, draped.BindNormals))
				{
					continue;
				}
				draped.Posed = _positions.ToArray();
				draped.PosedNormals = _normals.ToArray();
				draped.Skinning = _skinning.ToArray();
				draped.Headish = new bool[mesh.Bindposes.Length];
				for (int i = 0; i < draped.Headish.Length && i < bones.Length; i++)
				{
					draped.Headish[i] = (bool)bones[i] && (bones[i] == rig.Neck || bones[i] == rig.Head || bones[i].IsChildOf(rig.Head));
				}
				draped.Materials = smr.sharedMaterials;
				draped.Looks = new MaterialPropertyBlock[draped.Materials.Length];
				for (int j = 0; j < draped.Looks.Length; j++)
				{
					draped.Looks[j] = Look(smr, j);
				}
				neck.Draped.Add(draped);
			}
			if (neck.Draped.Count == 0)
			{
				return false;
			}
			_necks.Enqueue(neck);
			if (_neckWorker == null && base.isActiveAndEnabled)
			{
				_neckWorker = StartCoroutine(WorkNecks());
			}
			return true;
		}

		private void CancelNecks()
		{
			if (_neckWorker != null)
			{
				StopCoroutine(_neckWorker);
			}
			_neckWorker = null;
			if (_currentNeck != null)
			{
				Discard(_currentNeck);
			}
			_currentNeck = null;
			_necks.Clear();
		}

		private IEnumerator WorkNecks()
		{
			while (_necks.Count > 0)
			{
				_currentNeck = _necks.Dequeue();
				IEnumerator steps = ProcessNeck(_currentNeck);
				while (true)
				{
					try
					{
						if (!steps.MoveNext())
						{
							break;
						}
					}
					catch (Exception exception)
					{
						Debug.LogException(exception, this);
						Discard(_currentNeck);
						break;
					}
					yield return null;
				}
				_currentNeck = null;
			}
			_neckWorker = null;
		}

		private IEnumerator ProcessNeck(Neck job)
		{
			Rect capUv = capUvRect;
			float roughness = cutRoughness;
			bool wound = woundMaterial != null;
			float depth = soakDepth;
			Task tearing = Task.Run(delegate
			{
				TearNeck(job, capUv, roughness, wound, depth);
			});
			while (!tearing.IsCompleted)
			{
				yield return null;
			}
			if (tearing.Exception != null)
			{
				throw tearing.Exception.GetBaseException();
			}
			if (job.Head == null || !Alive(job))
			{
				Discard(job);
				yield break;
			}
			double since = Time.realtimeSinceStartupAsDouble;
			GameObject remains = new GameObject("BTM Head " + job.Name);
			remains.layer = BtmCorpse.RagdollLayer;
			job.Remains = remains.AddComponent<BtmCutRemains>();
			job.Remains.gameObject.SetActive(false);
			BuildHead(job);
			foreach (Draped draped in job.Draped)
			{
				if (draped.Remade == null)
				{
					continue;
				}
				if (Busy(since))
				{
					yield return null;
					if (!Alive(job))
					{
						Discard(job);
						yield break;
					}
					since = Time.realtimeSinceStartupAsDouble;
				}
				draped.Remade.Mesh = BuildStump(draped);
				job.Stumps.Add(draped.Remade.Mesh);
			}
			foreach (var (shell, draped, sub) in job.Shells)
			{
				if (Busy(since))
				{
					yield return null;
					if (!Alive(job))
					{
						Discard(job);
						yield break;
					}
					since = Time.realtimeSinceStartupAsDouble;
				}
				MeshRenderer drawn = BtmCutPiece.BuildShell(shell, draped.Renderer.name + " Cut", (sub < draped.Materials.Length) ? draped.Materials[sub] : null, (sub < draped.Looks.Length) ? draped.Looks[sub] : null, woundMaterial, job.Remains.transform);
				Dress(drawn, draped.Renderer);
				job.HeadPart.Own(drawn.GetComponent<MeshFilter>().sharedMesh);
			}
			RevealNeck(job);
		}

		private static bool Busy(double since)
		{
			return (Time.realtimeSinceStartupAsDouble - since) * 1000.0 >= NeckMillisecondsPerFrame;
		}

		private static bool Alive(Neck job)
		{
			if ((bool)job.Corpse)
			{
				return !job.Corpse.Retiring;
			}
			return false;
		}

		private static void Discard(Neck job)
		{
			if ((bool)job.Remains)
			{
				UnityEngine.Object.Destroy(job.Remains.gameObject);
			}
			job.Remains = null;
			foreach (Mesh stump in job.Stumps)
			{
				if ((bool)stump)
				{
					UnityEngine.Object.Destroy(stump);
				}
			}
			job.Stumps.Clear();
		}

		private static void Dress(Renderer drawn, Renderer like)
		{
			drawn.shadowCastingMode = like.shadowCastingMode;
			drawn.receiveShadows = like.receiveShadows;
			drawn.lightProbeUsage = like.lightProbeUsage;
			drawn.reflectionProbeUsage = like.reflectionProbeUsage;
		}

		private static void TearNeck(Neck job, Rect capUv, float roughness, bool wound, float soakDepth)
		{
			foreach (Draped draped in job.Draped)
			{
				Weigh(draped);
				int[][] triangles = draped.Data.Triangles;
				for (int sub = 0; sub < triangles.Length; sub++)
				{
					if (triangles[sub].Length == 0)
					{
						draped.Parts.Add((sub, null, null));
						continue;
					}
					BtmMeshSlicer.Half front = new BtmMeshSlicer.Half();
					BtmMeshSlicer.Half back = new BtmMeshSlicer.Half();
					BtmMeshSlicer.Slice(draped.Posed, draped.PosedNormals, draped.Data.Uvs, triangles[sub], job.Plane, front, back, default(Rect), roughness, caps: false, draped.BackOnly);
					draped.Parts.Add((sub, front, back));
					draped.HasFront |= !front.IsEmpty;
					draped.HasBack |= !back.IsEmpty;
				}
			}
			int best = 0;
			int cappedSub = -1;
			Draped capped = null;
			foreach (Draped draped2 in job.Draped)
			{
				foreach (var (sub2, front2, back2) in draped2.Parts)
				{
					if (front2 == null || front2.IsEmpty || back2.IsEmpty)
					{
						continue;
					}
					int score = (draped2.IsBody && sub2 == 0) ? int.MaxValue : front2.Surface.Count;
					if (score > best)
					{
						best = score;
						cappedSub = sub2;
						capped = draped2;
					}
				}
			}
			BtmMeshSlicer.Half head = null;
			Draped headSkin = capped;
			int headSub = cappedSub;
			if (capped != null)
			{
				BtmMeshSlicer.Half front3 = new BtmMeshSlicer.Half();
				BtmMeshSlicer.Half back3 = new BtmMeshSlicer.Half();
				BtmMeshSlicer.Slice(capped.Posed, capped.PosedNormals, capped.Data.Uvs, capped.Data.Triangles[cappedSub], job.Plane, front3, back3, capUv, roughness, caps: true, capped.BackOnly);
				for (int i = 0; i < capped.Parts.Count; i++)
				{
					if (capped.Parts[i].sub == cappedSub)
					{
						capped.Parts[i] = (cappedSub, front3, back3);
					}
				}
				BtmMeshSlicer.CapIslands(back3, job.StumpFaces);
				job.Capped = capped;
				job.CappedSub = cappedSub;
				foreach (var (sub4, front4, _) in capped.Parts)
				{
					if (sub4 == cappedSub)
					{
						head = front4;
					}
				}
			}
			if (head == null)
			{
				int largest = 0;
				foreach (Draped draped3 in job.Draped)
				{
					foreach (var (sub5, front5, _) in draped3.Parts)
					{
						if (front5 != null && front5.Surface.Count > largest)
						{
							headSub = sub5;
							largest = front5.Surface.Count;
							head = front5;
							headSkin = draped3;
						}
					}
				}
			}
			if (head == null || head.IsEmpty)
			{
				return;
			}
			job.Head = BtmCutPiece.Prepare(head, job.Plane, wound, soakDepth);
			job.HeadSkin = headSkin;
			job.HeadSub = headSub;
			foreach (Draped draped4 in job.Draped)
			{
				foreach (var (sub6, front6, _) in draped4.Parts)
				{
					if (front6 != null && !front6.IsEmpty && front6 != head)
					{
						job.Shells.Add((BtmCutPiece.PrepareShell(front6, job.Plane, job.Head, wound, soakDepth), draped4, sub6));
					}
				}
				if (draped4.HasFront && draped4.HasBack)
				{
					draped4.Remade = Remake(draped4, (draped4 == capped) ? cappedSub : (-1), job.Plane, job.StumpFaces, wound, soakDepth);
				}
			}
		}

		private static void Weigh(Draped draped)
		{
			int count = draped.Data.VertexCount;
			byte[] bones = draped.Data.BonesPerVertex;
			BoneWeight1[] weights = draped.Data.Weights;
			draped.FirstWeight = new int[count + 1];
			draped.BackOnly = new bool[count];
			int at = 0;
			for (int i = 0; i < count; i++)
			{
				draped.FirstWeight[i] = at;
				float head = 0f;
				if (i < bones.Length)
				{
					int n = bones[i];
					for (int k = 0; k < n && at < weights.Length; k++, at++)
					{
						int bone = weights[at].boneIndex;
						if (bone >= 0 && bone < draped.Headish.Length && draped.Headish[bone])
						{
							head += weights[at].weight;
						}
					}
				}
				draped.BackOnly[i] = head < HeadWeighted;
			}
			draped.FirstWeight[count] = at;
		}

		private static Remade Remake(Draped draped, int cappedSub, Plane plane, List<BtmMeshSlicer.CapIsland> stumpFaces, bool wound, float soakDepth)
		{
			int subs = draped.Data.Triangles.Length;
			List<Vector3> positions = new List<Vector3>();
			List<Vector3> normals = new List<Vector3>();
			List<Vector2> uvs = new List<Vector2>();
			List<Color32> colors = new List<Color32>();
			List<byte> bonesPerVertex = new List<byte>();
			List<BoneWeight1> weights = new List<BoneWeight1>();
			List<int>[] submeshes = new List<int>[subs + 2];
			for (int i = 0; i < submeshes.Length; i++)
			{
				submeshes[i] = new List<int>();
			}
			List<int> meat = submeshes[subs];
			List<int> blood = submeshes[subs + 1];
			List<BoneWeight1> influences = new List<BoneWeight1>(8);
			List<int> rim = new List<int>();
			List<BoneWeight1[]> rimWeights = new List<BoneWeight1[]>();
			bool tinted = false;
			foreach (var (sub, _, back) in draped.Parts)
			{
				if (back == null || back.IsEmpty)
				{
					continue;
				}
				int sourced = back.Sources.Count;
				int start = positions.Count;
				List<Color32> soak = null;
				List<int> soaked = null;
				if (wound && stumpFaces.Count > 0)
				{
					BtmCutPiece.SoakSkin(back, plane, stumpFaces, soakDepth, out soak, out soaked);
				}
				rim.Clear();
				rimWeights.Clear();
				for (int v = 0; v < back.Positions.Count; v++)
				{
					influences.Clear();
					Vector3 bind;
					Vector3 bindNormal;
					if (v < sourced)
					{
						BtmMeshSlicer.Source source = back.Sources[v];
						AddWeights(draped, source.A, 1f - source.T, influences);
						if (source.B != source.A)
						{
							AddWeights(draped, source.B, source.T, influences);
						}
						Settle(influences);
						if (source.A == source.B)
						{
							bind = draped.Bind[source.A];
							bindNormal = draped.BindNormals[source.A];
						}
						else
						{
							Unskin(draped, influences, back.Positions[v], back.Normals[v], Vector3.Lerp(draped.Bind[source.A], draped.Bind[source.B], source.T), Vector3.Lerp(draped.BindNormals[source.A], draped.BindNormals[source.B], source.T), out bind, out bindNormal);
							rim.Add(v);
							rimWeights.Add(influences.ToArray());
						}
					}
					else
					{
						int nearest = NearestRim(back, rim, back.Positions[v]);
						if (nearest >= 0)
						{
							influences.AddRange(rimWeights[nearest]);
						}
						Unskin(draped, influences, back.Positions[v], back.Normals[v], (nearest >= 0) ? positions[rim[nearest] + start] : Vector3.zero, Vector3.up, out bind, out bindNormal);
					}
					positions.Add(bind);
					normals.Add(bindNormal);
					uvs.Add(back.Uvs[v]);
					colors.Add((soak != null) ? soak[v] : default(Color32));
					bonesPerVertex.Add((byte)influences.Count);
					weights.AddRange(influences);
				}
				foreach (int index in back.Surface)
				{
					submeshes[sub].Add(index + start);
				}
				if (sub == cappedSub)
				{
					foreach (int index2 in back.Cap)
					{
						meat.Add(index2 + start);
					}
				}
				if (soaked != null)
				{
					foreach (int index3 in soaked)
					{
						blood.Add(index3 + start);
					}
					tinted = true;
				}
			}
			return new Remade
			{
				Positions = positions.ToArray(),
				Normals = normals.ToArray(),
				Uvs = uvs.ToArray(),
				Colors = (tinted ? colors.ToArray() : null),
				BonesPerVertex = bonesPerVertex.ToArray(),
				Weights = weights.ToArray(),
				Submeshes = submeshes,
				Meat = (meat.Count > 0),
				Blood = (blood.Count > 0)
			};
		}

		private static void AddWeights(Draped draped, int vertex, float share, List<BoneWeight1> into)
		{
			if (share <= 0f)
			{
				return;
			}
			BoneWeight1[] weights = draped.Data.Weights;
			for (int w = draped.FirstWeight[vertex]; w < draped.FirstWeight[vertex + 1]; w++)
			{
				BoneWeight1 weight = weights[w];
				bool merged = false;
				for (int i = 0; i < into.Count; i++)
				{
					if (into[i].boneIndex == weight.boneIndex)
					{
						BoneWeight1 existing = into[i];
						existing.weight += weight.weight * share;
						into[i] = existing;
						merged = true;
						break;
					}
				}
				if (!merged)
				{
					into.Add(new BoneWeight1
					{
						weight = weight.weight * share,
						boneIndex = weight.boneIndex
					});
				}
			}
		}

		private static void Settle(List<BoneWeight1> weights)
		{
			for (int i = 1; i < weights.Count; i++)
			{
				BoneWeight1 item = weights[i];
				int j = i;
				while (j > 0 && weights[j - 1].weight < item.weight)
				{
					weights[j] = weights[j - 1];
					j--;
				}
				weights[j] = item;
			}
			if (weights.Count > 4)
			{
				weights.RemoveRange(4, weights.Count - 4);
			}
			float total = 0f;
			foreach (BoneWeight1 weight in weights)
			{
				total += weight.weight;
			}
			if (total > 1E-06f)
			{
				for (int k = 0; k < weights.Count; k++)
				{
					BoneWeight1 value = weights[k];
					value.weight /= total;
					weights[k] = value;
				}
			}
			else
			{
				weights.Clear();
			}
		}

		private static void Unskin(Draped draped, List<BoneWeight1> influences, Vector3 posed, Vector3 posedNormal, Vector3 fallback, Vector3 fallbackNormal, out Vector3 bind, out Vector3 bindNormal)
		{
			bind = fallback;
			bindNormal = fallbackNormal;
			if (influences.Count == 0)
			{
				return;
			}
			Matrix4x4 sum = default(Matrix4x4);
			foreach (BoneWeight1 influence in influences)
			{
				if (influence.boneIndex >= 0 && influence.boneIndex < draped.Skinning.Length)
				{
					AddWeighted(ref sum, draped.Skinning[influence.boneIndex], influence.weight);
				}
			}
			sum.m33 = 1f;
			if (InverseAffine(sum, out Matrix4x4 inverse))
			{
				bind = inverse.MultiplyPoint3x4(posed);
				Vector3 normal = inverse.MultiplyVector(posedNormal);
				bindNormal = ((normal.sqrMagnitude > 1E-12f) ? normal.normalized : fallbackNormal);
			}
		}

		private static bool InverseAffine(Matrix4x4 m, out Matrix4x4 r)
		{
			float c0 = m.m11 * m.m22 - m.m12 * m.m21;
			float c1 = m.m12 * m.m20 - m.m10 * m.m22;
			float c2 = m.m10 * m.m21 - m.m11 * m.m20;
			float det = m.m00 * c0 + m.m01 * c1 + m.m02 * c2;
			r = Matrix4x4.identity;
			if (Mathf.Abs(det) < 1E-12f)
			{
				return false;
			}
			float inv = 1f / det;
			r.m00 = c0 * inv;
			r.m10 = c1 * inv;
			r.m20 = c2 * inv;
			r.m01 = (m.m02 * m.m21 - m.m01 * m.m22) * inv;
			r.m11 = (m.m00 * m.m22 - m.m02 * m.m20) * inv;
			r.m21 = (m.m01 * m.m20 - m.m00 * m.m21) * inv;
			r.m02 = (m.m01 * m.m12 - m.m02 * m.m11) * inv;
			r.m12 = (m.m02 * m.m10 - m.m00 * m.m12) * inv;
			r.m22 = (m.m00 * m.m11 - m.m01 * m.m10) * inv;
			r.m03 = 0f - (r.m00 * m.m03 + r.m01 * m.m13 + r.m02 * m.m23);
			r.m13 = 0f - (r.m10 * m.m03 + r.m11 * m.m13 + r.m12 * m.m23);
			r.m23 = 0f - (r.m20 * m.m03 + r.m21 * m.m13 + r.m22 * m.m23);
			r.m30 = 0f;
			r.m31 = 0f;
			r.m32 = 0f;
			r.m33 = 1f;
			return true;
		}

		private static int NearestRim(BtmMeshSlicer.Half half, List<int> rim, Vector3 point)
		{
			int best = -1;
			float closest = float.MaxValue;
			for (int i = 0; i < rim.Count; i++)
			{
				float distance = (half.Positions[rim[i]] - point).sqrMagnitude;
				if (distance < closest)
				{
					closest = distance;
					best = i;
				}
			}
			return best;
		}

		private void BuildHead(Neck job)
		{
			Draped skin = job.HeadSkin;
			int sub = job.HeadSub;
			_neckSettings.Skin = ((sub < skin.Materials.Length) ? skin.Materials[sub] : null);
			_neckSettings.Meat = capMaterial;
			_neckSettings.Wound = woundMaterial;
			_neckSettings.Look = ((sub < skin.Looks.Length) ? skin.Looks[sub] : null);
			_neckSettings.SoakDepth = soakDepth;
			_neckSettings.Layer = BtmCorpse.RagdollLayer;
			_neckSettings.CollideWith = (1 << BtmCorpse.RagdollLayer) | 1;
			Rigidbody head = BtmCutPiece.Build(job.Head, job.Name + " Head", _neckSettings, headMass);
			head.transform.SetParent(job.Remains.transform, worldPositionStays: true);
			if (head.TryGetComponent<MeshRenderer>(out var drawn))
			{
				Dress(drawn, skin.Renderer);
			}
			job.HeadBody = head;
			job.HeadPart = job.Remains.Add(head);
			int victim = (job.Corpse.Part ? job.Corpse.Part.Victim : (-1));
			job.HeadPart.Init(victim, BtmBodyPart.HeadKey, new Rigidbody[1] { head }, _gore ? _gore.droppedSeconds : 10f, job.Head.Bounds.size.magnitude);
		}

		private Mesh BuildStump(Draped draped)
		{
			int subs = draped.Data.Triangles.Length;
			Remade remade = draped.Remade;
			Mesh mesh = new Mesh();
			mesh.name = draped.Renderer.sharedMesh.name + " Stump";
			if (remade.Positions.Length >= 65536)
			{
				mesh.indexFormat = IndexFormat.UInt32;
			}
			mesh.SetVertices(remade.Positions);
			mesh.SetNormals(remade.Normals);
			mesh.SetUVs(0, remade.Uvs);
			if (remade.Colors != null)
			{
				mesh.SetColors(remade.Colors);
			}
			mesh.bindposes = draped.Data.Bindposes;
			using (Unity.Collections.NativeArray<byte> bonesPerVertex = new Unity.Collections.NativeArray<byte>(remade.BonesPerVertex, Unity.Collections.Allocator.Temp))
			{
				using Unity.Collections.NativeArray<BoneWeight1> weights = new Unity.Collections.NativeArray<BoneWeight1>(remade.Weights, Unity.Collections.Allocator.Temp);
				mesh.SetBoneWeights(bonesPerVertex, weights);
			}
			mesh.subMeshCount = subs + (remade.Meat ? 1 : 0) + (remade.Blood ? 1 : 0);
			int next = 0;
			for (int i = 0; i < subs; i++)
			{
				mesh.SetTriangles(remade.Submeshes[i], i, calculateBounds: false);
				next = i + 1;
			}
			if (remade.Meat)
			{
				mesh.SetTriangles(remade.Submeshes[subs], next++, calculateBounds: false);
			}
			if (remade.Blood)
			{
				mesh.SetTriangles(remade.Submeshes[subs + 1], next, calculateBounds: false);
			}
			mesh.RecalculateBounds();
			mesh.RecalculateTangents();
			return mesh;
		}

		private void RevealNeck(Neck job)
		{
			BtmCorpse corpse = job.Corpse;
			BtmRig rig = corpse.Rig;
			Transform head = rig.Head;
			Quaternion turn = head.rotation * Quaternion.Inverse(job.HeadTurn);
			job.Remains.transform.SetPositionAndRotation(head.position - turn * job.HeadAt, turn);
			Vector3 velocity = corpse.HeadVelocity;
			Vector3 up = (head.position - rig.Neck.position).normalized;
			foreach (Draped draped in job.Draped)
			{
				SkinnedMeshRenderer renderer = draped.Renderer;
				if (!renderer)
				{
					continue;
				}
				if (draped.Remade != null && (bool)draped.Remade.Mesh)
				{
					Restump(renderer, draped, draped.Remade);
				}
				else if (draped.HasFront && !draped.HasBack)
				{
					renderer.enabled = false;
				}
			}
			corpse.LoseHead(job.HeadBody, job.Stumps);
			job.Stumps.Clear();
			job.Remains.Init(_gore ? _gore.corpseSeconds : 20f);
			job.Remains.gameObject.SetActive(value: true);
			Vector3 side = Vector3.ProjectOnPlane(UnityEngine.Random.onUnitSphere, up);
			side = ((side.sqrMagnitude > 1E-06f) ? side.normalized : Vector3.zero);
			job.HeadBody.linearVelocity = velocity + up * popSpeed + side * (popScatter * UnityEngine.Random.Range(0.3f, 1f));
			job.HeadBody.angularVelocity = UnityEngine.Random.onUnitSphere * (popSpin * UnityEngine.Random.Range(0.6f, 1f));
			if ((bool)gore)
			{
				DecorateNeck(job);
			}
		}

		private void Restump(SkinnedMeshRenderer smr, Draped draped, Remade remade)
		{
			int subs = draped.Data.Triangles.Length;
			List<Material> materials = new List<Material>(subs + 2);
			for (int i = 0; i < subs; i++)
			{
				materials.Add((draped.Materials.Length != 0) ? draped.Materials[Mathf.Min(i, draped.Materials.Length - 1)] : null);
			}
			if (remade.Meat)
			{
				materials.Add(capMaterial);
			}
			if (remade.Blood)
			{
				materials.Add(woundMaterial);
			}
			smr.SetPropertyBlock(null);
			for (int j = 0; j < draped.Materials.Length; j++)
			{
				smr.SetPropertyBlock(null, j);
			}
			smr.sharedMesh = remade.Mesh;
			smr.sharedMaterials = materials.ToArray();
			for (int k = 0; k < subs; k++)
			{
				MaterialPropertyBlock look = ((draped.Looks.Length != 0) ? draped.Looks[Mathf.Min(k, draped.Looks.Length - 1)] : null);
				if (look != null)
				{
					smr.SetPropertyBlock(look, k);
				}
			}
		}

		private void DecorateNeck(Neck job)
		{
			Matrix4x4 headFromCut = Matrix4x4.Translate(-job.Head.Pivot);
			Matrix4x4 stumpFromCut = Matrix4x4.identity;
			List<BtmMeshSlicer.CapIsland> stumpFaces = new List<BtmMeshSlicer.CapIsland>(job.StumpFaces.Count);
			Transform stump = null;
			if (job.StumpFaces.Count > 0 && (bool)job.StumpBone)
			{
				BtmMeshSlicer.CapIsland first = job.StumpFaces[0];
				Quaternion turn = Quaternion.LookRotation(first.Facing, (Mathf.Abs(first.Facing.y) < 0.9f) ? Vector3.up : Vector3.forward);
				GameObject go = new GameObject("Neck Stump");
				go.layer = BtmCorpse.RagdollLayer;
				Transform t = go.transform;
				t.SetParent(job.StumpBone, worldPositionStays: false);
				t.localPosition = job.StumpBoneFromWorld.MultiplyPoint3x4(first.Center);
				t.localRotation = Quaternion.Inverse(job.StumpBoneTurn) * turn;
				Vector3 scale = job.StumpBone.lossyScale;
				t.localScale = new Vector3(1f / Mathf.Max(Mathf.Abs(scale.x), 0.0001f), 1f / Mathf.Max(Mathf.Abs(scale.y), 0.0001f), 1f / Mathf.Max(Mathf.Abs(scale.z), 0.0001f));
				stumpFromCut = Matrix4x4.Rotate(Quaternion.Inverse(turn)) * Matrix4x4.Translate(-first.Center);
				foreach (BtmMeshSlicer.CapIsland face in job.StumpFaces)
				{
					stumpFaces.Add(new BtmMeshSlicer.CapIsland
					{
						Center = stumpFromCut.MultiplyPoint3x4(face.Center),
						Facing = stumpFromCut.MultiplyVector(face.Facing).normalized,
						Area = face.Area,
						Radius = face.Radius
					});
				}
				stump = t;
			}
			gore.DecorateNeck(job.Plane, job.Skeleton, job.HeadBody, headFromCut, job.Head.Islands, stump, stumpFromCut, stumpFaces, job.Remains);
		}

		private void Awake()
		{
			if ((bool)Instance && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
			_gore = GetComponent<BtmGore>();
		}

		private void OnDisable()
		{
			CancelJobs();
			CancelNecks();
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
			ClearCuts();
		}

		public void CollectMaterials(List<Material> into)
		{
			if ((bool)capMaterial)
			{
				into.Add(capMaterial);
			}
			if ((bool)woundMaterial)
			{
				into.Add(woundMaterial);
			}
			if ((bool)gore)
			{
				gore.CollectMaterials(into);
			}
		}

		public void ClearCuts()
		{
			CancelJobs();
			CancelNecks();
			foreach (BtmCutRemains cut in _cuts)
			{
				if ((bool)cut)
				{
					UnityEngine.Object.Destroy(cut.gameObject);
				}
			}
			_cuts.Clear();
		}

		private void CancelJobs()
		{
			if (_worker != null)
			{
				StopCoroutine(_worker);
			}
			_worker = null;
			if (_current != null && (bool)_current.Remains)
			{
				UnityEngine.Object.Destroy(_current.Remains.gameObject);
			}
			_current = null;
			_jobs.Clear();
		}

		public bool Cut(MonkeDevNetworkingPlayer victim, Vector3 cutNormal)
		{
			if (!victim || !victim.Head || victim.photonView == null)
			{
				return false;
			}
			Vector3 carried = (_gore ? Vector3.ClampMagnitude(_gore.VelocityOf(victim), MaxInheritedSpeed) : Vector3.zero);
			return Cut(victim.Head.Find("PlayerModels"), BtmRig.FindBody(victim), cutNormal, victim.name + " " + victim.photonView.ViewID, carried, victim, null);
		}

		public bool CutModel(Transform models, SkinnedMeshRenderer body, Vector3 cutNormal, string name, Action revealed)
		{
			return Cut(models, body, cutNormal, name, Vector3.zero, null, revealed);
		}

		private bool Cut(Transform models, SkinnedMeshRenderer body, Vector3 cutNormal, string name, Vector3 carried, MonkeDevNetworkingPlayer victim, Action revealed)
		{
			if (cutNormal.sqrMagnitude < 1E-06f || !models || !body || !body.transform.IsChildOf(models))
			{
				return false;
			}
			BtmRig rig = BtmRig.Resolve(body);
			if (!rig.Valid || !Gather(models, body))
			{
				return false;
			}
			BtmCutMesh mesh = BtmCutMeshes.Get(body.sharedMesh);
			if (!Skin(body, mesh) || mesh.Triangles.Length == 0)
			{
				return false;
			}
			Vector3 top = (rig.Neck ? rig.Neck : rig.Head).position;
			Vector3 center = Vector3.Lerp(rig.Torso.position, top, 0.5f);
			Plane plane = new Plane(cutNormal.normalized, center);
			if (!Straddles(plane))
			{
				return false;
			}
			Job job = new Job
			{
				Victim = victim,
				Revealed = revealed,
				Name = name,
				Plane = plane,
				Center = center,
				Carried = carried,
				At = Time.time,
				Skeleton = BtmChainsawGore.Skeleton.Of(rig),
				Body = Capture(body, mesh, 0)
			};
			foreach (SkinnedMeshRenderer smr in _skinned)
			{
				BtmCutMesh worn = BtmCutMeshes.Get(smr.sharedMesh);
				int first = ((smr == body) ? 1 : 0);
				if (worn == null || worn.Triangles.Length <= first || !Skin(smr, worn))
				{
					continue;
				}
				smr.GetSharedMaterials(_materials);
				for (int i = first; i < worn.Triangles.Length && i < _materials.Count; i++)
				{
					if ((bool)_materials[i] && worn.Triangles[i].Length != 0)
					{
						job.Outfit.Add(Capture(smr, worn, i));
					}
				}
			}
			_materials.Clear();
			foreach (MeshRenderer renderer in _rigid)
			{
				Transform t = renderer.transform;
				renderer.GetSharedMaterials(_materials);
				Worn item = new Worn
				{
					Name = renderer.name,
					Mesh = renderer.GetComponent<MeshFilter>().sharedMesh,
					Materials = _materials.ToArray(),
					Looks = new MaterialPropertyBlock[_materials.Count],
					Position = t.position,
					Rotation = t.rotation,
					Scale = t.lossyScale,
					Bounds = renderer.bounds,
					Shadows = renderer.shadowCastingMode,
					ReceiveShadows = renderer.receiveShadows,
					Probes = renderer.lightProbeUsage,
					Reflections = renderer.reflectionProbeUsage
				};
				for (int j = 0; j < item.Looks.Length; j++)
				{
					item.Looks[j] = Look(renderer, j);
				}
				job.Rigid.Add(item);
			}
			_materials.Clear();
			_jobs.Enqueue(job);
			if (_worker == null && base.isActiveAndEnabled)
			{
				_worker = StartCoroutine(Work());
			}
			return true;
		}

		private bool Gather(Transform models, SkinnedMeshRenderer body)
		{
			_skinned.Clear();
			_rigid.Clear();
			HashSet<Renderer> lowerLods = BtmCorpse.LowerLods(models);
			models.GetComponentsInChildren(false, _renderers);
			bool complete = true;
			foreach (Renderer renderer in _renderers)
			{
				if (!BtmCorpse.Shows(renderer, lowerLods) || renderer.forceRenderingOff)
				{
					continue;
				}
				if (renderer is SkinnedMeshRenderer skinned)
				{
					if ((bool)skinned.sharedMesh)
					{
						if (BtmCutMeshes.Get(skinned.sharedMesh) == null)
						{
							complete = false;
							break;
						}
						_skinned.Add(skinned);
					}
				}
				else if (renderer is MeshRenderer rigid && rigid.TryGetComponent<MeshFilter>(out var filter) && (bool)filter.sharedMesh)
				{
					_rigid.Add(rigid);
				}
			}
			_renderers.Clear();
			if (complete)
			{
				return _skinned.Contains(body);
			}
			return false;
		}

		private bool Straddles(Plane plane)
		{
			bool front = false;
			bool back = false;
			foreach (Vector3 position in _positions)
			{
				if (plane.GetSide(position))
				{
					front = true;
				}
				else
				{
					back = true;
				}
				if (front && back)
				{
					return true;
				}
			}
			return false;
		}

		private Surface Capture(SkinnedMeshRenderer from, BtmCutMesh mesh, int sub)
		{
			from.GetSharedMaterials(_materials);
			Material material = ((_materials.Count > sub) ? _materials[sub] : null);
			return new Surface
			{
				Name = from.name,
				Positions = _positions.ToArray(),
				Normals = _normals.ToArray(),
				Uvs = mesh.Uvs,
				Triangles = mesh.Triangles[sub],
				Material = material,
				Look = Look(from, sub),
				Shadows = from.shadowCastingMode,
				ReceiveShadows = from.receiveShadows,
				Probes = from.lightProbeUsage,
				Reflections = from.reflectionProbeUsage
			};
		}

		private static MaterialPropertyBlock Look(Renderer r, int index)
		{
			MaterialPropertyBlock block = new MaterialPropertyBlock();
			r.GetPropertyBlock(block, index);
			if (block.isEmpty && r.HasPropertyBlock())
			{
				r.GetPropertyBlock(block);
			}
			if (!block.isEmpty)
			{
				return block;
			}
			return null;
		}

		private bool Skin(SkinnedMeshRenderer smr, BtmCutMesh mesh, Vector3[] bindPositions = null, Vector3[] bindNormals = null)
		{
			if (mesh == null)
			{
				return false;
			}
			int count = mesh.VertexCount;
			if (count == 0)
			{
				return false;
			}
			_positions.Clear();
			_positions.AddRange(mesh.Positions);
			_normals.Clear();
			_normals.AddRange(mesh.Normals);
			BlendShapes(smr, mesh);
			if (bindPositions != null)
			{
				_positions.CopyTo(bindPositions);
			}
			if (bindNormals != null)
			{
				_normals.CopyTo(bindNormals);
			}
			Transform[] bones = smr.bones;
			Matrix4x4[] bindposes = mesh.Bindposes;
			byte[] bonesPerVertex = mesh.BonesPerVertex;
			Matrix4x4 world = smr.transform.localToWorldMatrix;
			if (bones.Length == 0 || bindposes.Length == 0 || bonesPerVertex.Length != count)
			{
				for (int i = 0; i < count; i++)
				{
					_positions[i] = world.MultiplyPoint3x4(_positions[i]);
					_normals[i] = world.MultiplyVector(_normals[i]).normalized;
				}
				return true;
			}
			_skinning.Clear();
			for (int j = 0; j < bindposes.Length; j++)
			{
				_skinning.Add((j < bones.Length && (bool)bones[j]) ? (bones[j].localToWorldMatrix * bindposes[j]) : world);
			}
			BoneWeight1[] weights = mesh.Weights;
			int cursor = 0;
			for (int k = 0; k < count; k++)
			{
				int influences = bonesPerVertex[k];
				Matrix4x4 sum;
				if (influences == 0)
				{
					sum = world;
				}
				else
				{
					sum = default(Matrix4x4);
					int end = cursor + influences;
					while (cursor < end && cursor < weights.Length)
					{
						BoneWeight1 weight = weights[cursor];
						AddWeighted(ref sum, (weight.boneIndex < _skinning.Count) ? _skinning[weight.boneIndex] : world, weight.weight);
						cursor++;
					}
				}
				_positions[k] = sum.MultiplyPoint3x4(_positions[k]);
				_normals[k] = sum.MultiplyVector(_normals[k]).normalized;
			}
			return true;
		}

		private void BlendShapes(SkinnedMeshRenderer smr, BtmCutMesh mesh)
		{
			int count = (smr.sharedMesh ? smr.sharedMesh.blendShapeCount : 0);
			for (int i = 0; i < mesh.Shapes.Length && i < count; i++)
			{
				float weight = smr.GetBlendShapeWeight(i);
				if (Mathf.Abs(weight) < 0.01f)
				{
					continue;
				}
				BtmCutMesh.Frame[] frames = mesh.Shapes[i].Frames;
				if (frames.Length == 0)
				{
					continue;
				}
				int below = -1;
				for (int j = 0; j < frames.Length; j++)
				{
					if (frames[j].Weight <= weight)
					{
						below = j;
					}
				}
				if (below < 0)
				{
					Blend(in frames[0], weight / Mathf.Max(frames[0].Weight, 0.0001f));
					continue;
				}
				if (below == frames.Length - 1)
				{
					Blend(in frames[below], weight / Mathf.Max(frames[below].Weight, 0.0001f));
					continue;
				}
				float from = frames[below].Weight;
				float t = (weight - from) / Mathf.Max(frames[below + 1].Weight - from, 0.0001f);
				Blend(in frames[below], 1f - t);
				Blend(in frames[below + 1], t);
			}
		}

		private void Blend(in BtmCutMesh.Frame frame, float amount)
		{
			int[] indices = frame.Indices;
			for (int i = 0; i < indices.Length; i++)
			{
				int vertex = indices[i];
				if (vertex < _positions.Count)
				{
					_positions[vertex] += frame.Deltas[i] * amount;
					_normals[vertex] += frame.NormalDeltas[i] * amount;
				}
			}
		}

		private static void AddWeighted(ref Matrix4x4 sum, Matrix4x4 m, float weight)
		{
			sum.m00 += m.m00 * weight;
			sum.m01 += m.m01 * weight;
			sum.m02 += m.m02 * weight;
			sum.m03 += m.m03 * weight;
			sum.m10 += m.m10 * weight;
			sum.m11 += m.m11 * weight;
			sum.m12 += m.m12 * weight;
			sum.m13 += m.m13 * weight;
			sum.m20 += m.m20 * weight;
			sum.m21 += m.m21 * weight;
			sum.m22 += m.m22 * weight;
			sum.m23 += m.m23 * weight;
		}

		private IEnumerator Work()
		{
			while (_jobs.Count > 0)
			{
				_current = _jobs.Dequeue();
				IEnumerator steps = Process(_current);
				while (true)
				{
					try
					{
						if (!steps.MoveNext())
						{
							break;
						}
					}
					catch (Exception exception)
					{
						Debug.LogException(exception, this);
						Fail(_current);
						break;
					}
					yield return null;
				}
				_current = null;
			}
			_worker = null;
		}

		private IEnumerator Process(Job job)
		{
			Sliced sliced = new Sliced();
			Rect capUv = capUvRect;
			float roughness = cutRoughness;
			bool wound = woundMaterial != null;
			float depth = soakDepth;
			Task slicing = Task.Run(() => SliceAll(job, sliced, capUv, roughness, wound, depth));
			while (!slicing.IsCompleted)
			{
				yield return null;
			}
			if (slicing.Exception != null)
			{
				throw slicing.Exception.GetBaseException();
			}
			if (sliced.Pieces.Count == 0)
			{
				Fail(job);
				yield break;
			}
			GameObject remains = new GameObject("BTM Chainsaw Cut " + job.Name);
			remains.layer = BtmCorpse.RagdollLayer;
			job.Remains = remains.AddComponent<BtmCutRemains>();
			job.Remains.gameObject.SetActive(false);
			Surface body = job.Body;
			_settings.Skin = body.Material;
			_settings.Meat = capMaterial;
			_settings.Wound = woundMaterial;
			_settings.Look = body.Look;
			_settings.SoakDepth = soakDepth;
			_settings.Layer = BtmCorpse.RagdollLayer;
			_settings.CollideWith = (1 << BtmCorpse.RagdollLayer) | 1;
			foreach (var (piece, front, share) in sliced.Pieces)
			{
				Build(job, piece, front, share, body);
				yield return null;
			}
			double start = Time.realtimeSinceStartupAsDouble;
			foreach (var (shell, host, surface) in sliced.Shells)
			{
				Dress(job, shell, host, surface);
				if ((Time.realtimeSinceStartupAsDouble - start) * 1000.0 >= ShellMillisecondsPerFrame)
				{
					yield return null;
					start = Time.realtimeSinceStartupAsDouble;
				}
			}
			CarryRigid(job);
			Reveal(job);
		}

		private static void SliceAll(Job job, Sliced into, Rect capUv, float roughness, bool wound, float soakDepth)
		{
			Surface body = job.Body;
			BtmMeshSlicer.Half front = new BtmMeshSlicer.Half();
			BtmMeshSlicer.Half back = new BtmMeshSlicer.Half();
			BtmMeshSlicer.Slice(body.Positions, body.Normals, body.Uvs, body.Triangles, job.Plane, front, back, capUv, roughness);
			if (front.IsEmpty || back.IsEmpty)
			{
				return;
			}
			float total = (float)body.Triangles.Length / 3f;
			List<BtmMeshSlicer.Half> islands = new List<BtmMeshSlicer.Half>();
			List<BtmMeshSlicer.Half> pieces = new List<BtmMeshSlicer.Half>();
			for (int i = 0; i < 2; i++)
			{
				bool isFront = i == 0;
				BtmMeshSlicer.SplitIslands(isFront ? front : back, islands, 1);
				Group(islands, total, pieces);
				foreach (BtmMeshSlicer.Half piece in pieces)
				{
					into.Pieces.Add((BtmCutPiece.Prepare(piece, job.Plane, wound, soakDepth), isFront, (float)piece.Surface.Count / 3f / total));
				}
			}
			foreach (Surface surface in job.Outfit)
			{
				BtmMeshSlicer.Half shellFront = new BtmMeshSlicer.Half();
				BtmMeshSlicer.Half shellBack = new BtmMeshSlicer.Half();
				BtmMeshSlicer.Slice(surface.Positions, surface.Normals, surface.Uvs, surface.Triangles, job.Plane, shellFront, shellBack, default(Rect), roughness, caps: false);
				for (int j = 0; j < 2; j++)
				{
					bool isFront2 = j == 0;
					BtmMeshSlicer.Half side = (isFront2 ? shellFront : shellBack);
					if (side.IsEmpty)
					{
						continue;
					}
					BtmMeshSlicer.SplitIslands(side, islands, 1);
					foreach (BtmMeshSlicer.Half shell in islands)
					{
						int host = Nearest(into.Pieces, Centroid(shell), isFront2);
						if (host >= 0)
						{
							into.Shells.Add((BtmCutPiece.PrepareShell(shell, job.Plane, into.Pieces[host].piece, wound, soakDepth), host, surface));
						}
					}
				}
			}
		}

		private static void Group(List<BtmMeshSlicer.Half> islands, float total, List<BtmMeshSlicer.Half> pieces)
		{
			pieces.Clear();
			islands.Sort((BtmMeshSlicer.Half x, BtmMeshSlicer.Half y) => y.Surface.Count.CompareTo(x.Surface.Count));
			List<Bounds> bounds = new List<Bounds>();
			float whole = Mathf.Max(total, 1f);
			foreach (BtmMeshSlicer.Half island in islands)
			{
				if (pieces.Count == 0 || (pieces.Count < MaxPiecesPerSide && (float)island.Surface.Count / 3f / whole >= MinPieceShare))
				{
					pieces.Add(island);
					bounds.Add(BoundsOf(island));
					continue;
				}
				Vector3 center = BoundsOf(island).center;
				int best = 0;
				for (int i = 1; i < bounds.Count; i++)
				{
					if (bounds[i].SqrDistance(center) < bounds[best].SqrDistance(center))
					{
						best = i;
					}
				}
				Merge(pieces[best], island);
			}
		}

		private static Bounds BoundsOf(BtmMeshSlicer.Half half)
		{
			Bounds result = new Bounds(half.Positions[0], Vector3.zero);
			foreach (Vector3 position in half.Positions)
			{
				result.Encapsulate(position);
			}
			return result;
		}

		private static void Merge(BtmMeshSlicer.Half into, BtmMeshSlicer.Half from)
		{
			int offset = into.Positions.Count;
			into.Positions.AddRange(from.Positions);
			into.Normals.AddRange(from.Normals);
			into.Uvs.AddRange(from.Uvs);
			foreach (int index in from.Surface)
			{
				into.Surface.Add(index + offset);
			}
			foreach (int index2 in from.Cap)
			{
				into.Cap.Add(index2 + offset);
			}
		}

		private void Build(Job job, BtmCutPiece.Prepared piece, bool front, float share, Surface body)
		{
			Vector3 normal = (front ? job.Plane.normal : (-job.Plane.normal));
			string name = job.Name + " Chainsaw Piece " + ++_count;
			Rigidbody rb = BtmCutPiece.Build(piece, name, _settings, bodyMass * share);
			rb.transform.SetParent(job.Remains.transform, true);
			if (rb.TryGetComponent<MeshRenderer>(out var renderer))
			{
				renderer.shadowCastingMode = body.Shadows;
				renderer.receiveShadows = body.ReceiveShadows;
				renderer.lightProbeUsage = body.Probes;
				renderer.reflectionProbeUsage = body.Reflections;
			}
			Vector3 away = Vector3.ProjectOnPlane(piece.Pivot - job.Center, normal);
			job.Throws.Add(new Throw
			{
				Body = rb,
				Velocity = job.Carried + normal * separationSpeed + away.normalized * spreadSpeed + Vector3.up * liftSpeed,
				Angular = UnityEngine.Random.onUnitSphere * spin
			});
			job.Pieces.Add(new BtmChainsawGore.Piece
			{
				Body = rb,
				Islands = piece.Islands,
				Front = front
			});
			job.Prepared.Add(piece);
			job.Remains.Add(rb);
		}

		private void Dress(Job job, BtmCutPiece.PreparedShell shell, int host, Surface surface)
		{
			if (job.Pieces.Count > host && (bool)job.Pieces[host].Body)
			{
				MeshRenderer renderer = BtmCutPiece.BuildShell(shell, surface.Name + " Cut", surface.Material, surface.Look, woundMaterial, job.Pieces[host].Body.transform);
				renderer.shadowCastingMode = surface.Shadows;
				renderer.receiveShadows = surface.ReceiveShadows;
				renderer.lightProbeUsage = surface.Probes;
				renderer.reflectionProbeUsage = surface.Reflections;
				job.Pieces[host].Body.GetComponent<BtmBodyPart>().Own(renderer.GetComponent<MeshFilter>().sharedMesh);
			}
		}

		private void CarryRigid(Job job)
		{
			foreach (Worn worn in job.Rigid)
			{
				if (!worn.Mesh)
				{
					continue;
				}
				int host = Nearest(job.Prepared, worn.Bounds.center);
				if (host < 0 || !job.Pieces[host].Body)
				{
					continue;
				}
				Transform parent = job.Pieces[host].Body.transform;
				GameObject go = new GameObject(worn.Name + " Cut");
				go.layer = parent.gameObject.layer;
				go.transform.SetParent(parent, false);
				go.transform.SetPositionAndRotation(worn.Position, worn.Rotation);
				Vector3 scale = parent.lossyScale;
				go.transform.localScale = new Vector3(worn.Scale.x / scale.x, worn.Scale.y / scale.y, worn.Scale.z / scale.z);
				go.AddComponent<MeshFilter>().sharedMesh = worn.Mesh;
				MeshRenderer renderer = go.AddComponent<MeshRenderer>();
				renderer.sharedMaterials = worn.Materials;
				renderer.shadowCastingMode = worn.Shadows;
				renderer.receiveShadows = worn.ReceiveShadows;
				renderer.lightProbeUsage = worn.Probes;
				renderer.reflectionProbeUsage = worn.Reflections;
				for (int i = 0; i < worn.Looks.Length; i++)
				{
					if (worn.Looks[i] != null)
					{
						renderer.SetPropertyBlock(worn.Looks[i], i);
					}
				}
			}
		}

		private void Reveal(Job job)
		{
			Vector3 shift = job.Carried * Mathf.Min(Time.time - job.At, 0.5f);
			job.Remains.transform.position += shift;
			job.Center += shift;
			job.Skeleton.Shift(shift);
			job.Plane = new Plane(job.Plane.normal, job.Center);
			Retire();
			NameParts(job);
			job.Remains.Init(lifetime);
			job.Remains.gameObject.SetActive(true);
			foreach (Throw t in job.Throws)
			{
				if ((bool)t.Body)
				{
					t.Body.linearVelocity = t.Velocity;
					t.Body.angularVelocity = t.Angular;
				}
			}
			_cuts.Add(job.Remains);
			if ((bool)job.Victim)
			{
				BtmGhost ghost = job.Victim.GetComponent<BtmGhost>();
				if ((bool)ghost)
				{
					ghost.HoldBodyHidden(job.Skeleton.Torso, HideBodySeconds);
				}
			}
			job.Revealed?.Invoke();
			if ((bool)gore)
			{
				gore.Decorate(job.Pieces, job.Plane, job.Center, job.Skeleton, job.Remains);
			}
			if ((bool)_gore)
			{
				_gore.Play(cutClips, job.Center);
			}
		}

		private void NameParts(Job job)
		{
			int victim = ((bool)job.Victim && job.Victim.photonView != null) ? job.Victim.photonView.OwnerActorNr : (-1);
			float dropSeconds = (_gore ? _gore.droppedSeconds : 10f);
			int count = job.Pieces.Count;
			int[] bones = new int[count];
			float[] sizes = new float[count];
			for (int i = 0; i < count; i++)
			{
				Rigidbody body = job.Pieces[i].Body;
				if (!body)
				{
					continue;
				}
				bones[i] = NearestBone(job.Skeleton, body.transform.position);
				float size = 0f;
				if (body.TryGetComponent<MeshFilter>(out var filter) && (bool)filter.sharedMesh)
				{
					size = filter.sharedMesh.bounds.size.magnitude;
				}
				sizes[i] = size;
			}
			for (int j = 0; j < count; j++)
			{
				Rigidbody body2 = job.Pieces[j].Body;
				if (!body2)
				{
					continue;
				}
				int rank = 0;
				for (int k = 0; k < count; k++)
				{
					if (k != j && (bool)job.Pieces[k].Body && bones[k] == bones[j] && (sizes[k] > sizes[j] || (k < j && sizes[k] == sizes[j])))
					{
						rank++;
					}
				}
				body2.GetComponent<BtmBodyPart>().Init(victim, BtmBodyPart.PieceKey(bones[j], rank), new Rigidbody[1] { body2 }, dropSeconds, sizes[j]);
			}
		}

		private static int NearestBone(BtmChainsawGore.Skeleton skeleton, Vector3 point)
		{
			float closest = (skeleton.Torso - point).sqrMagnitude;
			int best = 0;
			Try(skeleton.Neck, 1);
			Try(skeleton.Head, 2);
			for (int i = 0; i < 2; i++)
			{
				Try(skeleton.Upper[i], 3 + i * 3);
				Try(skeleton.Lower[i], 4 + i * 3);
				Try(skeleton.Hand[i], 5 + i * 3);
			}
			return best;
			void Try(Vector3? bone, int index)
			{
				if (bone.HasValue)
				{
					float d = (bone.Value - point).sqrMagnitude;
					if (d < closest)
					{
						closest = d;
						best = index;
					}
				}
			}
		}

		private void Fail(Job job)
		{
			if ((bool)job.Remains)
			{
				UnityEngine.Object.Destroy(job.Remains.gameObject);
			}
			if ((bool)_gore && (bool)job.Victim)
			{
				_gore.DropCorpse(job.Victim, job.Center - job.Plane.normal);
			}
		}

		private static Vector3 Centroid(BtmMeshSlicer.Half part)
		{
			Vector3 sum = Vector3.zero;
			foreach (Vector3 position in part.Positions)
			{
				sum += position;
			}
			return sum / Mathf.Max(part.Positions.Count, 1);
		}

		private static int Nearest(List<(BtmCutPiece.Prepared piece, bool front, float share)> pieces, Vector3 point, bool? front)
		{
			int best = -1;
			float closest = float.MaxValue;
			float closestCenter = float.MaxValue;
			for (int i = 0; i < pieces.Count; i++)
			{
				if (front.HasValue && pieces[i].front != front.Value)
				{
					continue;
				}
				Bounds bounds = pieces[i].piece.Bounds;
				float d = bounds.SqrDistance(point);
				if (!(d > closest))
				{
					float centerDistance = (bounds.center - point).sqrMagnitude;
					if (!Mathf.Approximately(d, closest) || centerDistance < closestCenter)
					{
						closest = d;
						best = i;
						closestCenter = centerDistance;
					}
				}
			}
			return best;
		}

		private static int Nearest(List<BtmCutPiece.Prepared> pieces, Vector3 point)
		{
			int best = -1;
			float closest = float.MaxValue;
			float closestCenter = float.MaxValue;
			for (int i = 0; i < pieces.Count; i++)
			{
				Bounds bounds = pieces[i].Bounds;
				float d = bounds.SqrDistance(point);
				if (!(d > closest))
				{
					float centerDistance = (bounds.center - point).sqrMagnitude;
					if (!Mathf.Approximately(d, closest) || centerDistance < closestCenter)
					{
						closest = d;
						best = i;
						closestCenter = centerDistance;
					}
				}
			}
			return best;
		}

		private void Retire()
		{
			for (int i = _cuts.Count - 1; i >= 0; i--)
			{
				if (!_cuts[i])
				{
					_cuts.RemoveAt(i);
				}
			}
			while (_cuts.Count >= maxCuts)
			{
				_cuts[0].Retire();
				_cuts.RemoveAt(0);
			}
		}
	}
}
