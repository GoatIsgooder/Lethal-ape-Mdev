using System;
using UnityEngine;

namespace LethalApeR.Audio
{
	[DisallowMultipleComponent]
	[AddComponentMenu("Slop/Acoustic Map Selector")]
	public class AcousticMapSelector : MonoBehaviour
	{
		[Serializable]
		public struct Variant
		{
			[Tooltip("The MetaXRAcousticMap baked for this combination. Meta's type is internal to its assembly, hence Behaviour. Leave the component itself disabled in the scene.")]
			public Behaviour map;

			[Tooltip("Exactly the Watched Roots that were active when this map was baked. The variant is used only while this set, and no other watched root, is active.")]
			public GameObject[] activeRoots;
		}

		[Tooltip("The roots whose active state decides which map is right: every root that carries acoustic geometry and gets toggled, plus any toggled root without geometry so it can switch the maps off.")]
		[SerializeField]
		private GameObject[] watchedRoots = Array.Empty<GameObject>();

		[SerializeField]
		private Variant[] variants = Array.Empty<Variant>();

		[Tooltip("Enable every map once on Start so all of them load with the scene instead of on first use. The loads are async either way; this moves the file read off round start at the cost of keeping every variant resident.")]
		[SerializeField]
		private bool preloadAll = true;

		private int[] _variantMasks = Array.Empty<int>();

		private int _liveMask;

		private bool _liveForced;

		private bool _dirty = true;

		public static bool ForceLive { get; set; }

		public int SelectedVariant { get; private set; } = -1;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			ForceLive = false;
		}

		private void Awake()
		{
			if (watchedRoots.Length > 31)
			{
				Debug.LogError(string.Format("[AcousticMapSelector] {0} watched roots; the mask holds 31.", watchedRoots.Length), this);
			}
			_variantMasks = new int[variants.Length];
			for (int i = 0; i < variants.Length; i++)
			{
				GameObject[] array = variants[i].activeRoots ?? Array.Empty<GameObject>();
				for (int j = 0; j < array.Length; j++)
				{
					int num = Array.IndexOf(watchedRoots, array[j]);
					if (num >= 0)
					{
						_variantMasks[i] |= 1 << num;
					}
					else
					{
						Debug.LogError(string.Format("[AcousticMapSelector] Variant {0} needs '{1}', ", i, (array[j] != null) ? array[j].name : "null") + "which is not a watched root, so it can never be selected.", this);
					}
				}
			}
		}

		private void Start()
		{
			if (preloadAll)
			{
				for (int i = 0; i < variants.Length; i++)
				{
					if (variants[i].map != null)
					{
						variants[i].map.enabled = true;
					}
				}
				_dirty = true;
			}
		}

		private void OnEnable()
		{
			_dirty = true;
		}

		private void OnDisable()
		{
			for (int i = 0; i < variants.Length; i++)
			{
				if (variants[i].map != null)
				{
					variants[i].map.enabled = false;
				}
			}
			SelectedVariant = -1;
		}

		private void LateUpdate()
		{
			int num = 0;
			for (int i = 0; i < watchedRoots.Length; i++)
			{
				if (watchedRoots[i] != null && watchedRoots[i].activeInHierarchy)
				{
					num |= 1 << i;
				}
			}
			if (!_dirty && num == _liveMask && _liveForced == ForceLive)
			{
				return;
			}
			_dirty = false;
			_liveMask = num;
			_liveForced = ForceLive;
			int num2 = -1;
			if (!_liveForced)
			{
				for (int j = 0; j < _variantMasks.Length; j++)
				{
					if (_variantMasks[j] == num && !(variants[j].map == null))
					{
						num2 = j;
						break;
					}
				}
			}
			for (int k = 0; k < variants.Length; k++)
			{
				if (k != num2 && variants[k].map != null)
				{
					variants[k].map.enabled = false;
				}
			}
			if (num2 >= 0)
			{
				variants[num2].map.enabled = true;
			}
			SelectedVariant = num2;
		}
	}
}
