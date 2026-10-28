using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Cosmetics
{
	public class CosmeticSkinSync : MonoBehaviour
	{
		[Tooltip("Renderer that mirrors the owning player's skin material and colour.")]
		public Renderer targetRenderer;

		private static readonly int ColorProp = Shader.PropertyToID("_Color");

		private MonkeDevNetworkingPlayer _owner;

		private Material _appliedSkin;

		private Color _appliedColor;

		private MaterialPropertyBlock _block;

		private void OnEnable()
		{
			_owner = GetComponentInParent<MonkeDevNetworkingPlayer>();
			if (_owner != null)
			{
				Sync();
			}
		}

		private void LateUpdate()
		{
			if (_owner == null)
			{
				_owner = GetComponentInParent<MonkeDevNetworkingPlayer>();
				if (_owner == null)
				{
					return;
				}
			}
			if (OwnerSkin() != _appliedSkin || _owner.currentPlayerColor != _appliedColor)
			{
				Sync();
			}
		}

		private void Sync()
		{
			if (!(targetRenderer == null) && !(_owner == null))
			{
				Material material = OwnerSkin();
				Color currentPlayerColor = _owner.currentPlayerColor;
				if (material != null)
				{
					SwapFirstSharedMaterial(material);
				}
				if (_block == null)
				{
					_block = new MaterialPropertyBlock();
				}
				targetRenderer.GetPropertyBlock(_block);
				_block.SetColor(ColorProp, currentPlayerColor);
				targetRenderer.SetPropertyBlock(_block);
				_appliedSkin = material;
				_appliedColor = currentPlayerColor;
			}
		}

		private void SwapFirstSharedMaterial(Material skin)
		{
			Material[] sharedMaterials = targetRenderer.sharedMaterials;
			if (sharedMaterials.Length != 0 && !(sharedMaterials[0] == skin))
			{
				sharedMaterials[0] = skin;
				targetRenderer.sharedMaterials = sharedMaterials;
			}
		}

		private Material OwnerSkin()
		{
			if (_owner.playerRenderers != null && _owner.playerRenderers.Count != 0)
			{
				Renderer renderer = _owner.playerRenderers[0];
				if (renderer != null)
				{
					return renderer.sharedMaterial;
				}
			}
			return null;
		}
	}
}
