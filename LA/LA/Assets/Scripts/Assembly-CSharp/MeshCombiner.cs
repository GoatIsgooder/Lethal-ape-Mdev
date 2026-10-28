using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class MeshCombiner : MonoBehaviour
{
	private const int Mesh16BitBufferVertexLimit = 65535;

	[SerializeField]
	private bool createMultiMaterialMesh;

	[SerializeField]
	private bool combineInactiveChildren;

	[SerializeField]
	private bool deactivateCombinedChildren = true;

	[SerializeField]
	private bool deactivateCombinedChildrenMeshRenderers;

	[SerializeField]
	private bool generateUVMap;

	[SerializeField]
	private bool destroyCombinedChildren;

	[SerializeField]
	private string folderPath = "Prefabs/CombinedMeshes";

	[SerializeField]
	[Tooltip("MeshFilters with Meshes which we don't want to combine into one Mesh.")]
	private MeshFilter[] meshFiltersToSkip = new MeshFilter[0];

	public bool CreateMultiMaterialMesh
	{
		get
		{
			return createMultiMaterialMesh;
		}
		set
		{
			createMultiMaterialMesh = value;
		}
	}

	public bool CombineInactiveChildren
	{
		get
		{
			return combineInactiveChildren;
		}
		set
		{
			combineInactiveChildren = value;
		}
	}

	public bool DeactivateCombinedChildren
	{
		get
		{
			return deactivateCombinedChildren;
		}
		set
		{
			deactivateCombinedChildren = value;
			CheckDeactivateCombinedChildren();
		}
	}

	public bool DeactivateCombinedChildrenMeshRenderers
	{
		get
		{
			return deactivateCombinedChildrenMeshRenderers;
		}
		set
		{
			deactivateCombinedChildrenMeshRenderers = value;
			CheckDeactivateCombinedChildren();
		}
	}

	public bool GenerateUVMap
	{
		get
		{
			return generateUVMap;
		}
		set
		{
			generateUVMap = value;
		}
	}

	public bool DestroyCombinedChildren
	{
		get
		{
			return destroyCombinedChildren;
		}
		set
		{
			destroyCombinedChildren = value;
			CheckDestroyCombinedChildren();
		}
	}

	public string FolderPath
	{
		get
		{
			return folderPath;
		}
		set
		{
			folderPath = value;
		}
	}

	private void CheckDeactivateCombinedChildren()
	{
		if (deactivateCombinedChildren || deactivateCombinedChildrenMeshRenderers)
		{
			destroyCombinedChildren = false;
		}
	}

	private void CheckDestroyCombinedChildren()
	{
		if (destroyCombinedChildren)
		{
			deactivateCombinedChildren = false;
			deactivateCombinedChildrenMeshRenderers = false;
		}
	}

	public void CombineMeshes(bool showCreatedMeshInfo)
	{
		Vector3 oldScaleAsChild = transform.localScale;
		int positionInParentHierarchy = transform.GetSiblingIndex();
		Transform parent = transform.parent;
		transform.parent = null;
		Quaternion oldRotation = transform.rotation;
		Vector3 oldPosition = transform.position;
		Vector3 oldScale = transform.localScale;
		transform.rotation = Quaternion.identity;
		transform.position = Vector3.zero;
		transform.localScale = Vector3.one;
		if (!createMultiMaterialMesh)
		{
			CombineMeshesWithSingleMaterial(showCreatedMeshInfo);
		}
		else
		{
			CombineMeshesWithMutliMaterial(showCreatedMeshInfo);
		}
		transform.rotation = oldRotation;
		transform.position = oldPosition;
		transform.localScale = oldScale;
		transform.parent = parent;
		transform.SetSiblingIndex(positionInParentHierarchy);
		transform.localScale = oldScaleAsChild;
	}

	private MeshFilter[] GetMeshFiltersToCombine()
	{
		MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>(combineInactiveChildren);
		meshFiltersToSkip = meshFiltersToSkip.Where((MeshFilter meshFilter) => meshFilter != meshFilters[0]).ToArray();
		meshFiltersToSkip = meshFiltersToSkip.Where((MeshFilter meshFilter) => meshFilter != null).ToArray();
		for (int i = 0; i < meshFiltersToSkip.Length; i++)
		{
			meshFilters = meshFilters.Where((MeshFilter meshFilter) => meshFilter != meshFiltersToSkip[i]).ToArray();
		}
		return meshFilters;
	}

	private void CombineMeshesWithSingleMaterial(bool showCreatedMeshInfo)
	{
		MeshFilter[] meshFilters = GetMeshFiltersToCombine();
		CombineInstance[] combineInstances = new CombineInstance[meshFilters.Length - 1];
		long verticesLength = 0L;
		for (int i = 0; i < meshFilters.Length - 1; i++)
		{
			combineInstances[i].subMeshIndex = 0;
			combineInstances[i].mesh = meshFilters[i + 1].sharedMesh;
			combineInstances[i].transform = meshFilters[i + 1].transform.localToWorldMatrix;
			verticesLength += combineInstances[i].mesh.vertices.Length;
		}
		MeshRenderer[] meshRenderers = GetComponentsInChildren<MeshRenderer>(combineInactiveChildren);
		if (meshRenderers.Length >= 2)
		{
			meshRenderers[0].sharedMaterials = new Material[1];
			meshRenderers[0].sharedMaterial = meshRenderers[1].sharedMaterial;
		}
		else
		{
			meshRenderers[0].sharedMaterials = new Material[0];
		}
		Mesh combinedMesh = new Mesh();
		combinedMesh.name = name;
		if (verticesLength > 65535)
		{
			combinedMesh.indexFormat = IndexFormat.UInt32;
		}
		combinedMesh.CombineMeshes(combineInstances);
		GenerateUV(combinedMesh);
		meshFilters[0].sharedMesh = combinedMesh;
		DeactivateCombinedGameObjects(meshFilters);
		if (showCreatedMeshInfo)
		{
			if (verticesLength <= 65535)
			{
				Debug.Log("<color=#00cc00><b>Mesh \"" + name + "\" was created from " + combineInstances.Length + " children meshes and has " + verticesLength + " vertices.</b></color>");
			}
			else
			{
				Debug.Log("<color=#ff3300><b>Mesh \"" + name + "\" was created from " + combineInstances.Length + " children meshes and has " + verticesLength + " vertices. Some old devices, like Android with Mali-400 GPU, do not support over 65535 vertices.</b></color>");
			}
		}
	}

	private void CombineMeshesWithMutliMaterial(bool showCreatedMeshInfo)
	{
		MeshFilter[] meshFilters = GetMeshFiltersToCombine();
		MeshRenderer[] meshRenderers = new MeshRenderer[meshFilters.Length];
		meshRenderers[0] = GetComponent<MeshRenderer>();
		List<Material> uniqueMaterialsList = new List<Material>();
		for (int i = 0; i < meshFilters.Length - 1; i++)
		{
			meshRenderers[i + 1] = meshFilters[i + 1].GetComponent<MeshRenderer>();
			if (meshRenderers[i + 1] != null)
			{
				Material[] materials = meshRenderers[i + 1].sharedMaterials;
				for (int j = 0; j < materials.Length; j++)
				{
					if (!uniqueMaterialsList.Contains(materials[j]))
					{
						uniqueMaterialsList.Add(materials[j]);
					}
				}
			}
		}
		List<CombineInstance> finalMeshCombineInstancesList = new List<CombineInstance>();
		long verticesLength = 0L;
		for (int k = 0; k < uniqueMaterialsList.Count; k++)
		{
			List<CombineInstance> submeshCombineInstancesList = new List<CombineInstance>();
			for (int l = 0; l < meshFilters.Length - 1; l++)
			{
				if (!(meshRenderers[l + 1] != null))
				{
					continue;
				}
				Material[] submeshMaterials = meshRenderers[l + 1].sharedMaterials;
				for (int m = 0; m < submeshMaterials.Length; m++)
				{
					if (uniqueMaterialsList[k] == submeshMaterials[m])
					{
						CombineInstance combineInstance = new CombineInstance
						{
							subMeshIndex = m,
							mesh = meshFilters[l + 1].sharedMesh,
							transform = meshFilters[l + 1].transform.localToWorldMatrix
						};
						submeshCombineInstancesList.Add(combineInstance);
						verticesLength += combineInstance.mesh.vertices.Length;
					}
				}
			}
			Mesh submesh = new Mesh();
			if (verticesLength > 65535)
			{
				submesh.indexFormat = IndexFormat.UInt32;
			}
			submesh.CombineMeshes(submeshCombineInstancesList.ToArray(), true);
			CombineInstance finalCombineInstance = new CombineInstance
			{
				subMeshIndex = 0,
				mesh = submesh,
				transform = Matrix4x4.identity
			};
			finalMeshCombineInstancesList.Add(finalCombineInstance);
		}
		meshRenderers[0].sharedMaterials = uniqueMaterialsList.ToArray();
		Mesh combinedMesh = new Mesh();
		combinedMesh.name = name;
		if (verticesLength > 65535)
		{
			combinedMesh.indexFormat = IndexFormat.UInt32;
		}
		combinedMesh.CombineMeshes(finalMeshCombineInstancesList.ToArray(), false);
		GenerateUV(combinedMesh);
		meshFilters[0].sharedMesh = combinedMesh;
		DeactivateCombinedGameObjects(meshFilters);
		if (showCreatedMeshInfo)
		{
			if (verticesLength <= 65535)
			{
				Debug.Log("<color=#00cc00><b>Mesh \"" + name + "\" was created from " + (meshFilters.Length - 1) + " children meshes and has " + finalMeshCombineInstancesList.Count + " submeshes, and " + verticesLength + " vertices.</b></color>");
			}
			else
			{
				Debug.Log("<color=#ff3300><b>Mesh \"" + name + "\" was created from " + (meshFilters.Length - 1) + " children meshes and has " + finalMeshCombineInstancesList.Count + " submeshes, and " + verticesLength + " vertices. Some old devices, like Android with Mali-400 GPU, do not support over 65535 vertices.</b></color>");
			}
		}
	}

	private void DeactivateCombinedGameObjects(MeshFilter[] meshFilters)
	{
		for (int i = 0; i < meshFilters.Length - 1; i++)
		{
			if (!destroyCombinedChildren)
			{
				if (deactivateCombinedChildren)
				{
					meshFilters[i + 1].gameObject.SetActive(false);
				}
				if (deactivateCombinedChildrenMeshRenderers)
				{
					MeshRenderer meshRenderer = meshFilters[i + 1].gameObject.GetComponent<MeshRenderer>();
					if (meshRenderer != null)
					{
						meshRenderer.enabled = false;
					}
				}
			}
			else
			{
				Object.DestroyImmediate(meshFilters[i + 1].gameObject);
			}
		}
	}

	private void GenerateUV(Mesh combinedMesh)
	{
	}
}
