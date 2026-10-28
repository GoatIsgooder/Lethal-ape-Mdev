using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmCutMesh
	{
		public struct Frame
		{
			public float Weight;

			public int[] Indices;

			public Vector3[] Deltas;

			public Vector3[] NormalDeltas;
		}

		public struct Shape
		{
			public string Name;

			public Frame[] Frames;
		}

		private struct Reader
		{
			private readonly byte[] _bytes;

			private int _at;

			public bool Ok;

			public Reader(byte[] bytes)
			{
				_bytes = bytes;
				_at = 0;
				Ok = true;
			}

			private bool Take(int length)
			{
				if (length < 0 || _at + length > _bytes.Length)
				{
					Ok = false;
					return false;
				}
				return Ok;
			}

			public int Int()
			{
				if (!Take(4))
				{
					return 0;
				}
				int result = BitConverter.ToInt32(_bytes, _at);
				_at += 4;
				return result;
			}

			public float Float()
			{
				if (!Take(4))
				{
					return 0f;
				}
				float result = BitConverter.ToSingle(_bytes, _at);
				_at += 4;
				return result;
			}

			public byte[] Bytes(int length)
			{
				if (!Take(length))
				{
					return System.Array.Empty<byte>();
				}
				byte[] result = new byte[length];
				Buffer.BlockCopy(_bytes, _at, result, 0, length);
				_at += length;
				return result;
			}

			public T[] Array<T>(int length) where T : struct
			{
				int size = Marshal.SizeOf<T>() * length;
				if (!Take(size))
				{
					return System.Array.Empty<T>();
				}
				T[] result = MemoryMarshal.Cast<byte, T>(new ReadOnlySpan<byte>(_bytes, _at, size)).ToArray();
				_at += size;
				return result;
			}

			public void Align()
			{
				_at = (_at + 3) & -4;
			}
		}

		private const int Magic = 1414873922;

		private const int Version = 1;

		public const int BakeFormat = 2;

		private const float MinDeltaSqr = 1E-10f;

		private const float MinNormalDeltaSqr = 0.0004f;

		public Vector3[] Positions;

		public Vector3[] Normals;

		public Vector2[] Uvs;

		public int[][] Triangles;

		public byte[] BonesPerVertex;

		public BoneWeight1[] Weights;

		public Matrix4x4[] Bindposes;

		public Shape[] Shapes;

		public int VertexCount => Positions.Length;

		public static BtmCutMesh From(Mesh mesh)
		{
			int vertexCount = mesh.vertexCount;
			BtmCutMesh result = new BtmCutMesh
			{
				Positions = mesh.vertices,
				Normals = mesh.normals,
				Uvs = mesh.uv,
				Triangles = new int[mesh.subMeshCount][],
				BonesPerVertex = mesh.GetBonesPerVertex().ToArray(),
				Weights = mesh.GetAllBoneWeights().ToArray(),
				Bindposes = mesh.bindposes,
				Shapes = new Shape[mesh.blendShapeCount]
			};
			if (result.Normals.Length != vertexCount)
			{
				result.Normals = new Vector3[vertexCount];
			}
			if (result.Uvs.Length != vertexCount)
			{
				result.Uvs = Array.Empty<Vector2>();
			}
			for (int i = 0; i < mesh.subMeshCount; i++)
			{
				result.Triangles[i] = ((mesh.GetTopology(i) == MeshTopology.Triangles) ? mesh.GetTriangles(i) : Array.Empty<int>());
			}
			Vector3[] deltas = new Vector3[vertexCount];
			Vector3[] normalDeltas = new Vector3[vertexCount];
			List<int> indices = new List<int>();
			for (int j = 0; j < result.Shapes.Length; j++)
			{
				Frame[] frames = new Frame[mesh.GetBlendShapeFrameCount(j)];
				for (int k = 0; k < frames.Length; k++)
				{
					mesh.GetBlendShapeFrameVertices(j, k, deltas, normalDeltas, null);
					indices.Clear();
					for (int l = 0; l < vertexCount; l++)
					{
						if (deltas[l].sqrMagnitude > MinDeltaSqr || normalDeltas[l].sqrMagnitude > MinNormalDeltaSqr)
						{
							indices.Add(l);
						}
					}
					Frame frame = new Frame
					{
						Weight = mesh.GetBlendShapeFrameWeight(j, k),
						Indices = indices.ToArray(),
						Deltas = new Vector3[indices.Count],
						NormalDeltas = new Vector3[indices.Count]
					};
					for (int m = 0; m < indices.Count; m++)
					{
						frame.Deltas[m] = deltas[indices[m]];
						frame.NormalDeltas[m] = normalDeltas[indices[m]];
					}
					frames[k] = frame;
				}
				result.Shapes[j] = new Shape
				{
					Name = mesh.GetBlendShapeName(j),
					Frames = frames
				};
			}
			return result;
		}

		public byte[] ToBytes()
		{
			using (MemoryStream memoryStream = new MemoryStream())
			{
				using (BinaryWriter binaryWriter = new BinaryWriter(memoryStream))
				{
					binaryWriter.Write(Magic);
					binaryWriter.Write(Version);
					binaryWriter.Write(Positions.Length);
					binaryWriter.Write((Uvs.Length == Positions.Length) ? 1 : 0);
					WriteArray(binaryWriter, Positions);
					WriteArray(binaryWriter, Normals);
					if (Uvs.Length == Positions.Length)
					{
						WriteArray(binaryWriter, Uvs);
					}
					binaryWriter.Write(Triangles.Length);
					int[][] triangles = Triangles;
					foreach (int[] array in triangles)
					{
						binaryWriter.Write(array.Length);
						WriteArray(binaryWriter, array);
					}
					binaryWriter.Write(BonesPerVertex.Length);
					binaryWriter.Write(BonesPerVertex);
					Pad(binaryWriter);
					binaryWriter.Write(Weights.Length);
					BoneWeight1[] weights = Weights;
					for (int j = 0; j < weights.Length; j++)
					{
						BoneWeight1 boneWeight = weights[j];
						binaryWriter.Write(boneWeight.boneIndex);
						binaryWriter.Write(boneWeight.weight);
					}
					binaryWriter.Write(Bindposes.Length);
					WriteArray(binaryWriter, Bindposes);
					binaryWriter.Write(Shapes.Length);
					for (int k = 0; k < Shapes.Length; k++)
					{
						Shape shape = Shapes[k];
						byte[] bytes = Encoding.UTF8.GetBytes(shape.Name ?? "");
						binaryWriter.Write(bytes.Length);
						binaryWriter.Write(bytes);
						Pad(binaryWriter);
						binaryWriter.Write(shape.Frames.Length);
						Frame[] frames = shape.Frames;
						for (int l = 0; l < frames.Length; l++)
						{
							Frame frame = frames[l];
							binaryWriter.Write(frame.Weight);
							binaryWriter.Write(frame.Indices.Length);
							WriteArray(binaryWriter, frame.Indices);
							WriteArray(binaryWriter, frame.Deltas);
							WriteArray(binaryWriter, frame.NormalDeltas);
						}
					}
					binaryWriter.Flush();
					return memoryStream.ToArray();
				}
			}
		}

		public static BtmCutMesh FromBytes(byte[] bytes)
		{
			Reader reader = new Reader(bytes);
			if (reader.Int() != Magic || reader.Int() != Version)
			{
				return null;
			}
			int length = reader.Int();
			int hasUvs = reader.Int();
			BtmCutMesh result = new BtmCutMesh();
			result.Positions = reader.Array<Vector3>(length);
			result.Normals = reader.Array<Vector3>(length);
			result.Uvs = ((hasUvs != 0) ? reader.Array<Vector2>(length) : Array.Empty<Vector2>());
			result.Triangles = new int[reader.Int()][];
			for (int i = 0; i < result.Triangles.Length; i++)
			{
				result.Triangles[i] = reader.Array<int>(reader.Int());
			}
			result.BonesPerVertex = reader.Bytes(reader.Int());
			reader.Align();
			result.Weights = new BoneWeight1[reader.Int()];
			for (int j = 0; j < result.Weights.Length; j++)
			{
				result.Weights[j] = new BoneWeight1
				{
					boneIndex = reader.Int(),
					weight = reader.Float()
				};
			}
			result.Bindposes = reader.Array<Matrix4x4>(reader.Int());
			result.Shapes = new Shape[reader.Int()];
			for (int k = 0; k < result.Shapes.Length; k++)
			{
				string name = Encoding.UTF8.GetString(reader.Bytes(reader.Int()));
				reader.Align();
				Frame[] frames = new Frame[reader.Int()];
				for (int l = 0; l < frames.Length; l++)
				{
					float weight = reader.Float();
					int count = reader.Int();
					frames[l] = new Frame
					{
						Weight = weight,
						Indices = reader.Array<int>(count),
						Deltas = reader.Array<Vector3>(count),
						NormalDeltas = reader.Array<Vector3>(count)
					};
				}
				result.Shapes[k] = new Shape
				{
					Name = name,
					Frames = frames
				};
			}
			if (!reader.Ok)
			{
				return null;
			}
			return result;
		}

		private static void WriteArray<T>(BinaryWriter w, T[] values) where T : struct
		{
			w.Write(MemoryMarshal.AsBytes(new Span<T>(values)));
		}

		private static void Pad(BinaryWriter w)
		{
			while ((w.BaseStream.Position & 3) != 0L)
			{
				w.Write((byte)0);
			}
		}
	}
}
