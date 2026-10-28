using System;
using UnityEngine;

namespace LethalApeR.Rendering
{
	[DisallowMultipleComponent]
	[AddComponentMenu(null)]
	public class SlopCombinedMeshGroup : MonoBehaviour
	{
		public enum SourceDisposal
		{
			DisableRenderer = 0,
			StripRenderComponents = 1,
			DeactivateGameObject = 2,
			DeleteGameObject = 3
		}

		[Serializable]
		public struct SourceRecord
		{
			public string globalId;

			public string scenePath;

			public string objectName;

			public string parentPath;

			public int disposal;

			public string meshRef;

			public string[] materialRefs;

			public bool rendererWasEnabled;

			public bool gameObjectWasActive;

			public Vector3 localPosition;

			public Quaternion localRotation;

			public Vector3 localScale;

			public int layer;

			public int staticFlags;

			public int shadowCastingMode;

			public bool receiveShadows;

			public bool staticShadowCaster;

			public int lightProbeUsage;

			public int reflectionProbeUsage;

			public int motionVectorMode;

			public int receiveGI;

			public uint renderingLayerMask;

			public int lightmapIndex;

			public Vector4 lightmapScaleOffset;

			public int bakeryId;
		}

		[Tooltip("Human readable label for this combine pass.")]
		public string combineLabel;

		[Tooltip("Everything needed to put the source renderers back.")]
		public SourceRecord[] sources = Array.Empty<SourceRecord>();

		[Tooltip("Asset paths of the meshes generated for this group, so Uncombine can clean them up.")]
		public string[] generatedMeshPaths = Array.Empty<string>();

		[Tooltip("Set when the combine registered its output renderers with Bakery's ftLightmapsStorage.")]
		public bool registeredWithBakery;
	}
}
