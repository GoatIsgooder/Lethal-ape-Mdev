using LethalApeR.Rendering;
using Photon.Pun;
using UnityEngine;

public class HideLocalPlayerMesh : MonoBehaviour
{
	[Header("Renderer Settings")]
	[SerializeField]
	private Renderer meshRendererToHide;

	[SerializeField]
	[HideInInspector]
	private int visibleLayer = -1;

	private PhotonView _ownerView;

	private void Awake()
	{
		if (meshRendererToHide == null)
		{
			meshRendererToHide = GetComponent<Renderer>();
		}
		if (meshRendererToHide == null)
		{
			Debug.LogWarning("[HideLocalPlayerMesh] No renderer to hide on " + base.name, this);
			return;
		}
		if (visibleLayer < 0)
		{
			visibleLayer = meshRendererToHide.gameObject.layer;
		}
		_ownerView = GetComponentInParent<PhotonView>();
	}

	private void OnEnable()
	{
		SetHidden(_ownerView != null && _ownerView.IsMine);
	}

	private void OnDisable()
	{
		SetHidden(false);
	}

	private void SetHidden(bool hidden)
	{
		if (meshRendererToHide == null)
		{
			return;
		}
		int layer;
		if (hidden)
		{
			layer = MirrorLayer.Index;
			if (layer < 0)
			{
				Debug.LogError("[HideLocalPlayerMesh] Layer 'MIRROR' is missing from the project; " + base.name + " stays visible to its owner", this);
				return;
			}
		}
		else
		{
			layer = visibleLayer;
		}
		meshRendererToHide.gameObject.layer = layer;
	}
}
