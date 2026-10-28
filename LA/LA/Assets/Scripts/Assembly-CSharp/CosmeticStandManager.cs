using System.Collections.Generic;
using UnityEngine;

public class CosmeticStandManager : MonoBehaviour
{
	public GameObject cosmeticStands;

	[SerializeField]
	private int[] savedIndices;

	private CosmeticStand[] _stands;

	private void Start()
	{
		_stands = GetStands();
		if (savedIndices != null && savedIndices.Length == _stands.Length)
		{
			for (int i = 0; i < _stands.Length; i++)
			{
				if (_stands[i] != null)
				{
					_stands[i].Apply(savedIndices[i]);
				}
			}
		}
		else
		{
			AssignRandom();
		}
	}

	private void AssignRandom()
	{
		if (_stands.Length == 0)
		{
			return;
		}
		int num = _stands[0].cosmetics.Length;
		List<int> list = new List<int>();
		for (int i = 0; i < num; i++)
		{
			list.Add(i);
		}
		for (int num2 = list.Count - 1; num2 > 0; num2--)
		{
			int index = Random.Range(0, num2 + 1);
			int index2 = num2;
			(list[index2], list[index]) = (list[index], list[index2]);
		}
		for (int j = 0; j < _stands.Length; j++)
		{
			if (_stands[j] != null)
			{
				_stands[j].Apply(list[j % list.Count]);
			}
		}
	}

	public void Save()
	{
		_stands = GetStands();
		savedIndices = new int[_stands.Length];
		for (int i = 0; i < _stands.Length; i++)
		{
			if (_stands[i] != null)
			{
				savedIndices[i] = _stands[i].ActiveIndex;
			}
		}
		Debug.Log(string.Format("[CosmeticStandManager] Saved {0} stands.", _stands.Length));
	}

	private CosmeticStand[] GetStands()
	{
		if (cosmeticStands == null)
		{
			return new CosmeticStand[0];
		}
		int childCount = cosmeticStands.transform.childCount;
		CosmeticStand[] array = new CosmeticStand[childCount];
		for (int i = 0; i < childCount; i++)
		{
			array[i] = cosmeticStands.transform.GetChild(i).GetComponent<CosmeticStand>();
		}
		return array;
	}
}
