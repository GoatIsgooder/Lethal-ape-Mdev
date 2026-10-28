using System;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[CreateAssetMenu(menuName = "Slop/Custom Maps/Shader Library", fileName = "MapShaderLibrary")]
	public sealed class MapShaderLibrary : ScriptableObject
	{
		[Serializable]
		public struct Entry
		{
			[Tooltip("The SDK shader name a map material uses, e.g. LethalApe/Lit.")]
			public string approvedName;

			[Tooltip("Used on lightmapped renderers (or always, for shaders without a lit split).")]
			public Shader baked;

			[Tooltip("Used on renderers without a lightmap. Leave empty when the shader has no lit split.")]
			public Shader probe;
		}

		[SerializeField]
		private Entry[] entries = Array.Empty<Entry>();

		[SerializeField]
		[Tooltip("Used for any material whose shader isn't approved.")]
		private Shader fallback;

		public Shader Fallback => fallback;

		public bool TryGet(string approvedName, out Entry entry)
		{
			Entry[] array = entries;
			foreach (Entry e in array)
			{
				if (e.approvedName == approvedName)
				{
					entry = e;
					return true;
				}
			}
			entry = default(Entry);
			return false;
		}

		public Shader Resolve(string approvedName, bool lightmapped)
		{
			if (!TryGet(approvedName, out var entry))
			{
				return fallback;
			}
			if (!lightmapped && entry.probe != null)
			{
				return entry.probe;
			}
			return (entry.baked != null) ? entry.baked : fallback;
		}
	}
}
