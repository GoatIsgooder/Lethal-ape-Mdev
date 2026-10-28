using System;
using TMPro;
using UnityEngine;

public class CosmeticStand : MonoBehaviour
{
	public GameObject[] cosmetics;

	public TextMeshPro nameText;

	private int _activeIndex = -1;

	public int ActiveIndex => _activeIndex;

	public event Action OnStandChanged;

	public string GetActiveItemID()
	{
		for (int i = 0; i < cosmetics.Length; i++)
		{
			if (cosmetics[i] != null && cosmetics[i].activeSelf)
			{
				return cosmetics[i].name;
			}
		}
		if (_activeIndex >= 0 && _activeIndex < cosmetics.Length && cosmetics[_activeIndex] != null)
		{
			return cosmetics[_activeIndex].name;
		}
		return string.Empty;
	}

	public void Apply(int index)
	{
		_activeIndex = index;
		for (int i = 0; i < cosmetics.Length; i++)
		{
			if (cosmetics[i] != null)
			{
				cosmetics[i].SetActive(i == index);
			}
		}
		if (nameText != null)
		{
			nameText.text = ((index >= 0 && index < cosmetics.Length && cosmetics[index] != null) ? cosmetics[index].name : string.Empty);
		}
		this.OnStandChanged?.Invoke();
	}
}
