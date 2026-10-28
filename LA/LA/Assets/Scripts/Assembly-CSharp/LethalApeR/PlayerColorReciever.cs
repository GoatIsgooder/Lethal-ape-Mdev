using System.Reflection;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class PlayerColorReciever : MonoBehaviour
	{
		public Renderer targetRenderer;

		public int materialIndex;

		public bool applySkins;

		public string colorPropertyName = "_Color";

		public void SetColor(Color newColor)
		{
			if (TryGetSlots(out var slots))
			{
				slots[materialIndex].SetColor(colorPropertyName, newColor);
				targetRenderer.materials = slots;
			}
		}

		public void SetMaterial(Material mat = null, bool isEliminated = false)
		{
			if (applySkins && TryGetSlots(out var slots))
			{
				if (mat != null)
				{
					slots[materialIndex] = mat;
				}
				slots[materialIndex].SetFloat("_isDead", isEliminated ? 1f : 0f);
				targetRenderer.materials = slots;
			}
		}

		private bool TryGetSlots(out Material[] slots)
		{
			if (targetRenderer == null)
			{
				slots = null;
				return false;
			}
			slots = targetRenderer.materials;
			return materialIndex >= 0 && materialIndex < slots.Length;
		}

		private void OnValidate()
		{
			if (targetRenderer == null)
			{
				targetRenderer = GetComponent<Renderer>();
			}
		}
	}
}
