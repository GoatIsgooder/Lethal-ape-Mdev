using System.Collections.Generic;
using LethalApeR.Networking;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace SoreBones.BakeryStreaming
{
	[AddComponentMenu("Bakery/Volume Prop Receiver")]
	[DisallowMultipleComponent]
	public class BakeryVolumePropReceiver : MonoBehaviour
	{
		private static readonly int Volume0ID = Shader.PropertyToID("_Volume0");

		private static readonly int Volume1ID = Shader.PropertyToID("_Volume1");

		private static readonly int Volume2ID = Shader.PropertyToID("_Volume2");

		private static readonly int Volume3ID = Shader.PropertyToID("_Volume3");

		private static readonly int VolumeMaskID = Shader.PropertyToID("_VolumeMask");

		private static readonly int VolumeMinID = Shader.PropertyToID("_VolumeMin");

		private static readonly int VolumeInvSizeID = Shader.PropertyToID("_VolumeInvSize");

		private static readonly List<BakeryVolume> Volumes = new List<BakeryVolume>();

		private static bool _volumesDirty = true;

		[Header("Setup")]
		[Tooltip("Include child renderers.")]
		[SerializeField]
		private bool includeChildren = true;

		[Tooltip("Sample the volume at this transform instead of this object. Auto-set to PhotonVRPlayer.Head so a root-mounted receiver follows the moving head.")]
		[SerializeField]
		private Transform positionOverride;

		[Tooltip("Static props assign once and stop updating. Disable for props that move between volumes.")]
		[SerializeField]
		private bool isStatic = true;

		[Header("Movable")]
		[Tooltip("Seconds between volume checks for movable props.")]
		[SerializeField]
		[Range(0.1f, 2f)]
		private float reassignInterval = 0.5f;

		public Renderer[] _renderers;

		private MaterialPropertyBlock _mpb;

		private BakeryVolume _assignedVolume;

		private float _nextCheckTime;

		private bool _assigned;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
		private static void Init()
		{
			SceneManager.sceneLoaded += delegate
			{
				_volumesDirty = true;
			};
			SceneManager.sceneUnloaded += delegate
			{
				_volumesDirty = true;
			};
		}

		public static void RefreshVolumes()
		{
			_volumesDirty = true;
		}

		private static BakeryVolume GetVolumeFor(Vector3 position)
		{
			if (_volumesDirty)
			{
				Volumes.Clear();
				Volumes.AddRange(Object.FindObjectsByType<BakeryVolume>(FindObjectsInactive.Include, FindObjectsSortMode.None));
				_volumesDirty = false;
			}
			BakeryVolume result = null;
			float num = float.MaxValue;
			for (int i = 0; i < Volumes.Count; i++)
			{
				BakeryVolume bakeryVolume = Volumes[i];
				if (!(bakeryVolume == null) && !(bakeryVolume.bakedTexture0 == null))
				{
					float num2 = Vector3.Distance(position, bakeryVolume.bounds.ClosestPoint(position));
					float num3 = (bakeryVolume.bounds.Contains(position) ? (0f - num2) : num2) - (float)bakeryVolume.multiVolumePriority * 100f;
					if (num3 < num)
					{
						num = num3;
						result = bakeryVolume;
					}
				}
			}
			return result;
		}

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			_renderers = (includeChildren ? GetComponentsInChildren<Renderer>(true) : GetComponents<Renderer>());
			if (!positionOverride)
			{
				MonkeDevNetworkingPlayer componentInParent = GetComponentInParent<MonkeDevNetworkingPlayer>();
				if ((bool)componentInParent && (bool)componentInParent.Head)
				{
					positionOverride = componentInParent.Head;
					isStatic = false;
				}
			}
		}

		private void Update()
		{
			if (_assigned && isStatic)
			{
				base.enabled = false;
			}
			else if (!(Time.time < _nextCheckTime))
			{
				_nextCheckTime = Time.time + reassignInterval;
				TryAssign();
			}
		}

		public void ForceReassign()
		{
			_assignedVolume = null;
			TryAssign();
		}

		private void TryAssign()
		{
			BakeryVolume volumeFor = GetVolumeFor((positionOverride ? positionOverride : base.transform).position);
			if (!(volumeFor == _assignedVolume))
			{
				Apply(volumeFor);
				_assignedVolume = volumeFor;
				_assigned = true;
			}
		}

		private void Apply(BakeryVolume volume)
		{
			for (int i = 0; i < _renderers.Length; i++)
			{
				Renderer renderer = _renderers[i];
				if (renderer == null)
				{
					continue;
				}
				Vector3 min = volume.GetMin();
				Vector3 size = volume.bounds.size;
				Vector3 vector = new Vector3(1f / size.x, 1f / size.y, 1f / size.z);
				int num = SafeSlotCount(renderer);
				for (int j = 0; j < num; j++)
				{
					renderer.GetPropertyBlock(_mpb, j);
					_mpb.SetTexture(Volume0ID, volume.bakedTexture0);
					if (volume.bakedTexture1 != null)
					{
						_mpb.SetTexture(Volume1ID, volume.bakedTexture1);
					}
					if (volume.bakedTexture2 != null)
					{
						_mpb.SetTexture(Volume2ID, volume.bakedTexture2);
					}
					if (volume.bakedTexture3 != null)
					{
						_mpb.SetTexture(Volume3ID, volume.bakedTexture3);
					}
					if (volume.bakedMask != null)
					{
						_mpb.SetTexture(VolumeMaskID, volume.bakedMask);
					}
					_mpb.SetVector(VolumeMinID, min);
					_mpb.SetVector(VolumeInvSizeID, vector);
					renderer.SetPropertyBlock(_mpb, j);
				}
			}
		}

		private static int SafeSlotCount(Renderer r)
		{
			Material[] sharedMaterials = r.sharedMaterials;
			if (sharedMaterials == null)
			{
				return 0;
			}
			int num = sharedMaterials.Length;
			if (num < 2)
			{
				return num;
			}
			if (r is SkinnedMeshRenderer skinnedMeshRenderer)
			{
				if (!(skinnedMeshRenderer.sharedMesh != null))
				{
					return 0;
				}
				return Mathf.Min(num, skinnedMeshRenderer.sharedMesh.subMeshCount);
			}
			if (r is MeshRenderer)
			{
				if (!r.TryGetComponent<MeshFilter>(out var component) || !(component.sharedMesh != null))
				{
					return 0;
				}
				return Mathf.Min(num, component.sharedMesh.subMeshCount);
			}
			return 1;
		}
	}
}
