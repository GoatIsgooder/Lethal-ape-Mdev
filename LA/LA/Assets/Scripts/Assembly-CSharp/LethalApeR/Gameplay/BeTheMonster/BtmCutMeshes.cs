using System.Collections.Generic;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmCutMeshes
	{
		private static readonly Dictionary<Mesh, string> Paths = new Dictionary<Mesh, string>();

		private static readonly Dictionary<Mesh, BtmCutMesh> Loaded = new Dictionary<Mesh, BtmCutMesh>();

		private static readonly HashSet<Mesh> Pending = new HashSet<Mesh>();

		private static readonly HashSet<Mesh> Reported = new HashSet<Mesh>();

		private static readonly List<Renderer> Scratch = new List<Renderer>();

		private static bool _indexed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Paths.Clear();
			Loaded.Clear();
			Pending.Clear();
			Reported.Clear();
			_indexed = false;
		}

		public static BtmCutMesh Get(Mesh source)
		{
			if (!source)
			{
				return null;
			}
			if (Loaded.TryGetValue(source, out var value) && value != null)
			{
				return value;
			}
			string text = PathOf(source);
			if (text != null)
			{
				value = Parse(Resources.Load<TextAsset>(text));
			}
			else if (source.isReadable)
			{
				value = BtmCutMesh.From(source);
			}
			else
			{
				Report(source);
			}
			if (value != null)
			{
				Loaded[source] = value;
			}
			return value;
		}

		public static void Preload(MonkeDevNetworkingPlayer player)
		{
			Transform transform = ((player && player.Head) ? player.Head.Find("PlayerModels") : null);
			if (!transform)
			{
				return;
			}
			transform.GetComponentsInChildren(false, Scratch);
			foreach (Renderer item in Scratch)
			{
				if (item is SkinnedMeshRenderer skinnedMeshRenderer && skinnedMeshRenderer.enabled)
				{
					Preload(skinnedMeshRenderer.sharedMesh);
				}
			}
			Scratch.Clear();
		}

		private static void Preload(Mesh source)
		{
			if (!source || Loaded.ContainsKey(source) || Pending.Contains(source))
			{
				return;
			}
			string text = PathOf(source);
			if (text == null)
			{
				return;
			}
			Pending.Add(source);
			ResourceRequest request = Resources.LoadAsync<TextAsset>(text);
			request.completed += delegate
			{
				Pending.Remove(source);
				if (!Loaded.ContainsKey(source))
				{
					BtmCutMesh btmCutMesh = Parse(request.asset as TextAsset);
					if (btmCutMesh != null)
					{
						Loaded[source] = btmCutMesh;
					}
				}
			};
		}

		public static void Release()
		{
			Loaded.Clear();
		}

		private static BtmCutMesh Parse(TextAsset asset)
		{
			if (!asset)
			{
				return null;
			}
			BtmCutMesh result = BtmCutMesh.FromBytes(asset.bytes);
			Resources.UnloadAsset(asset);
			return result;
		}

		private static string PathOf(Mesh source)
		{
			if (!_indexed)
			{
				_indexed = true;
				BtmCutMeshLibrary btmCutMeshLibrary = Resources.Load<BtmCutMeshLibrary>(BtmCutMeshLibrary.ResourcePath);
				if (btmCutMeshLibrary)
				{
					foreach (BtmCutMeshLibrary.Entry entry in btmCutMeshLibrary.entries)
					{
						if (entry.source && !string.IsNullOrEmpty(entry.resource))
						{
							Paths[entry.source] = entry.resource;
						}
					}
				}
			}
			if (!Paths.TryGetValue(source, out var value))
			{
				return null;
			}
			return value;
		}

		private static void Report(Mesh source)
		{
			if (Reported.Add(source))
			{
				Debug.LogWarning("[BtmCutMeshes] No cut data for '" + source.name + "', so a chainsaw drops whoever wears it whole instead of cutting them. Run Tools > Be The Monster > Chainsaw > Bake Cut Meshes.");
			}
		}
	}
}
