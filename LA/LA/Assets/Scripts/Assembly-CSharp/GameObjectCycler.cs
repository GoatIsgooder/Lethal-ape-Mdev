using System.Collections.Generic;
using UnityEngine;

public class GameObjectCycler : MonoBehaviour
{
	[Tooltip("Seconds to wait before switching to the next GameObject.")]
	public float cycleSeconds = 30f;

	[Tooltip("Objects to cycle through, in order.")]
	public List<GameObject> objects = new List<GameObject>();

	[Tooltip("Index to start on.")]
	public int startIndex;

	[Tooltip("If true, only the current object is active and the rest are disabled.")]
	public bool exclusive = true;

	[Tooltip("Loop back to the first object after the last one.")]
	public bool loop = true;

	private int _current;

	private float _timer;

	private void OnEnable()
	{
		_current = Mathf.Clamp(startIndex, 0, Mathf.Max(0, objects.Count - 1));
		_timer = 0f;
		Apply();
	}

	private void Update()
	{
		if (objects.Count == 0)
		{
			return;
		}
		_timer += Time.deltaTime;
		if (_timer >= cycleSeconds)
		{
			_timer -= cycleSeconds;
			Next();
		}
	}

	public void Next()
	{
		if (objects.Count == 0)
		{
			return;
		}
		int next = _current + 1;
		if (next >= objects.Count)
		{
			if (!loop)
			{
				return;
			}
			next = 0;
		}
		_current = next;
		Apply();
	}

	private void Apply()
	{
		for (int i = 0; i < objects.Count; i++)
		{
			if (objects[i] == null)
			{
				continue;
			}
			if (exclusive)
			{
				objects[i].SetActive(i == _current);
			}
			else if (i == _current)
			{
				objects[i].SetActive(true);
			}
		}
	}
}
