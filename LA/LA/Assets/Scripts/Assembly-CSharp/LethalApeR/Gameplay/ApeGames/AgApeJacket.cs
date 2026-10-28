using System;
using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgApeJacket : MonoBehaviour
	{
		[Header("Jacket")]
		[Tooltip("Skinned mesh for the jacket (LA_PlayerModelAsset(2)).")]
		[SerializeField]
		private Mesh jacketMesh;

		[Tooltip("Jacket material (New Material 4).")]
		[SerializeField]
		private Material jacketMaterial;

		[SerializeField]
		private string jacketObjectName = "ApeJacket";

		[Header("Rig lookup")]
		[Tooltip("Name prefix of the live ape's skinned renderer, used as the bone donor.")]
		[SerializeField]
		private string donorNamePrefix = "LAR_Ape_LOD0";

		[Tooltip("Any renderer under a transform with this name is the corpse rig, never the donor.")]
		[SerializeField]
		private string corpseRootName = "DeadApe";

		[Tooltip("Seconds between attempts while the nested rig has not spawned in yet.")]
		[SerializeField]
		private float retryInterval = 0.25f;

		private SkinnedMeshRenderer _jacket;

		private float _nextTry;

		private void OnEnable()
		{
			_nextTry = 0f;
		}

		private void LateUpdate()
		{
			if (!(_jacket != null) && !(Time.unscaledTime < _nextTry))
			{
				_nextTry = Time.unscaledTime + Mathf.Max(retryInterval, 0.05f);
				Build();
			}
		}

		private void Build()
		{
			if (jacketMesh == null || jacketMaterial == null)
			{
				return;
			}
			SkinnedMeshRenderer skinnedMeshRenderer = FindDonor();
			if (!(skinnedMeshRenderer == null))
			{
				GameObject gameObject = new GameObject(jacketObjectName);
				gameObject.transform.SetParent(skinnedMeshRenderer.transform.parent, false);
				gameObject.layer = skinnedMeshRenderer.gameObject.layer;
				SkinnedMeshRenderer skinnedMeshRenderer2 = gameObject.AddComponent<SkinnedMeshRenderer>();
				skinnedMeshRenderer2.sharedMesh = jacketMesh;
				skinnedMeshRenderer2.sharedMaterial = jacketMaterial;
				skinnedMeshRenderer2.bones = skinnedMeshRenderer.bones;
				skinnedMeshRenderer2.rootBone = skinnedMeshRenderer.rootBone;
				skinnedMeshRenderer2.localBounds = skinnedMeshRenderer.localBounds;
				skinnedMeshRenderer2.quality = skinnedMeshRenderer.quality;
				skinnedMeshRenderer2.updateWhenOffscreen = skinnedMeshRenderer.updateWhenOffscreen;
				skinnedMeshRenderer2.shadowCastingMode = skinnedMeshRenderer.shadowCastingMode;
				skinnedMeshRenderer2.receiveShadows = skinnedMeshRenderer.receiveShadows;
				skinnedMeshRenderer2.lightProbeUsage = skinnedMeshRenderer.lightProbeUsage;
				skinnedMeshRenderer2.reflectionProbeUsage = skinnedMeshRenderer.reflectionProbeUsage;
				skinnedMeshRenderer2.probeAnchor = skinnedMeshRenderer.probeAnchor;
				RegisterWithLodGroup(skinnedMeshRenderer, skinnedMeshRenderer2);
				_jacket = skinnedMeshRenderer2;
			}
		}

		private static void RegisterWithLodGroup(Renderer donor, Renderer jacket)
		{
			LODGroup componentInParent = donor.GetComponentInParent<LODGroup>();
			if (componentInParent == null)
			{
				return;
			}
			LOD[] lODs = componentInParent.GetLODs();
			if (lODs == null || lODs.Length == 0)
			{
				return;
			}
			for (int i = 0; i < lODs.Length; i++)
			{
				Renderer[] renderers = lODs[i].renderers;
				int num = ((renderers != null) ? renderers.Length : 0);
				for (int j = 0; j < num; j++)
				{
					if (renderers[j] == jacket)
					{
						return;
					}
				}
				Renderer[] array = new Renderer[num + 1];
				for (int k = 0; k < num; k++)
				{
					array[k] = renderers[k];
				}
				array[num] = jacket;
				lODs[i].renderers = array;
			}
			componentInParent.SetLODs(lODs);
		}

		private SkinnedMeshRenderer FindDonor()
		{
			SkinnedMeshRenderer[] componentsInChildren = GetComponentsInChildren<SkinnedMeshRenderer>(true);
			foreach (SkinnedMeshRenderer skinnedMeshRenderer in componentsInChildren)
			{
				if (!(skinnedMeshRenderer == null) && !(skinnedMeshRenderer == _jacket) && skinnedMeshRenderer.name.StartsWith(donorNamePrefix, StringComparison.Ordinal) && skinnedMeshRenderer.bones != null && skinnedMeshRenderer.bones.Length != 0 && !(skinnedMeshRenderer.rootBone == null) && !IsUnder(skinnedMeshRenderer.transform, corpseRootName))
				{
					return skinnedMeshRenderer;
				}
			}
			return null;
		}

		private static bool IsUnder(Transform t, string ancestorName)
		{
			if (string.IsNullOrEmpty(ancestorName))
			{
				return false;
			}
			while (t != null)
			{
				if (t.name == ancestorName)
				{
					return true;
				}
				t = t.parent;
			}
			return false;
		}
	}
}
