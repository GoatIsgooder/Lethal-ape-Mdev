using System.Collections.Generic;
using LethalApeR.Rivals.Maps;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class RivalsMap : MonoBehaviour
	{
		[Tooltip("Shown on the vote board.")]
		public string displayName = "Map";

		[Tooltip("Optional vote-board thumbnail.")]
		public Sprite thumbnail;

		[Tooltip("Child geometry toggled on when this map is chosen. If null, falls back to the first child, else this object.")]
		public GameObject geometryRoot;

		private static readonly List<RivalsMap> _all = new List<RivalsMap>();

		public static IReadOnlyList<RivalsMap> All => _all;

		private GameObject Root
		{
			get
			{
				if (geometryRoot != null)
				{
					return geometryRoot;
				}
				if (base.transform.childCount <= 0)
				{
					return base.gameObject;
				}
				return base.transform.GetChild(0).gameObject;
			}
		}

		private void Awake()
		{
			if (!_all.Contains(this))
			{
				_all.Add(this);
			}
		}

		private void OnDestroy()
		{
			_all.Remove(this);
		}

		public void SetActiveMap(bool on)
		{
			GameObject root = Root;
			if (root != null && root != base.gameObject)
			{
				root.SetActive(on);
			}
			else if (root == base.gameObject)
			{
				root.SetActive(on);
			}
		}

		public List<SpawnPoint> GetSpawns(Team team)
		{
			List<SpawnPoint> list = new List<SpawnPoint>();
			SpawnPoint[] componentsInChildren = GetComponentsInChildren<SpawnPoint>(true);
			foreach (SpawnPoint spawnPoint in componentsInChildren)
			{
				if (spawnPoint != null && (spawnPoint.team == team || spawnPoint.team == Team.None))
				{
					list.Add(spawnPoint);
				}
			}
			return list;
		}

		public static RivalsMap Get(int index)
		{
			if (index < 0 || index >= _all.Count)
			{
				return null;
			}
			return _all[index];
		}
	}
}
