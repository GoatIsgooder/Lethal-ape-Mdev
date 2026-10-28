using System.Collections.Generic;
using LethalApeR.Gameplay.Monsters;
using TMPro;
using UnityEngine;

public class TrackMonst : MonoBehaviour
{
	[SerializeField]
	private TMP_Text displayText;

	[SerializeField]
	private float updateInterval = 1f;

	public List<FOVMonster> _cachedMonsters = new List<FOVMonster>();

	private Transform self;

	private FOVMonster closest;

	private float closestDistance;

	private void Start()
	{
		self = transform;
		_cachedMonsters.Clear();
		_cachedMonsters.AddRange(Object.FindObjectsByType<FOVMonster>(FindObjectsSortMode.None));
		InvokeRepeating("Refresh", 0f, updateInterval);
	}

	private void Refresh()
	{
		LocateClosest();
		WriteReadout();
	}

	private void LocateClosest()
	{
		closest = null;
		if (_cachedMonsters.Count == 0)
		{
			return;
		}
		Vector3 position = self.position;
		float best = float.MaxValue;
		for (int i = _cachedMonsters.Count - 1; i >= 0; i--)
		{
			FOVMonster monster = _cachedMonsters[i];
			if (monster == null)
			{
				_cachedMonsters.RemoveAt(i);
				continue;
			}
			float sqr = (position - monster.transform.position).sqrMagnitude;
			if (sqr < best)
			{
				closest = monster;
				best = sqr;
			}
		}
		closestDistance = (closest != null) ? Mathf.Sqrt(best) : 0f;
	}

	private void WriteReadout()
	{
		if (!(displayText == null))
		{
			displayText.text = (closest != null) ? string.Format("Tracking: {0}\nDistance: {1:F2}m", closest.name, closestDistance) : "No monsters found";
		}
	}
}
