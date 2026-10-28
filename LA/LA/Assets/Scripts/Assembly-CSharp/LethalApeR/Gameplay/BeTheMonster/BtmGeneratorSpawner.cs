using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using LALocomotion;
using Locomotion.Scripts;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmGeneratorSpawner : MonoBehaviourPunCallbacks
	{
		private const string GeneratorPrefabResourcePath = "Prefabs/Interactables/BTM/Generator";

		[Tooltip("The generator prefab. Falls back to Resources/Prefabs/Interactables/BTM/Generator when empty.")]
		[SerializeField]
		private GameObject generatorPrefab;

		private readonly Dictionary<int, BtmGenerator> _spawned = new Dictionary<int, BtmGenerator>();

		private static readonly List<int> DesiredScratch = new List<int>(8);

		public override void OnEnable()
		{
			base.OnEnable();
			Reconcile();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			DespawnAll();
		}

		public override void OnJoinedRoom()
		{
			Reconcile();
		}

		public override void OnLeftRoom()
		{
			DespawnAll();
		}

		public override void OnRoomPropertiesUpdate(Hashtable propertiesThatChanged)
		{
			if (propertiesThatChanged != null && propertiesThatChanged.Count > 0)
			{
				foreach (object key in propertiesThatChanged.Keys)
				{
					if (!RoundProps.GeneratorProgressKey.Equals(key))
					{
						Reconcile();
						return;
					}
				}
				return;
			}
			Reconcile();
		}

		private void Reconcile()
		{
			DesiredScratch.Clear();
			MapData map = null;
			if (RoundProps.TryRead(out RoundProperties props) && props.roundActive && props.generatorSpawnPoints != null && props.generatorSpawnPoints.Length != 0)
			{
				map = ResolveMap(props.currentMap);
				if (map != null && map.mapObject != null)
				{
					DesiredScratch.AddRange(props.generatorSpawnPoints);
				}
			}
			if (_spawned.Count > 0)
			{
				List<int> stale = null;
				foreach (KeyValuePair<int, BtmGenerator> item in _spawned)
				{
					if (item.Value == null || !DesiredScratch.Contains(item.Key))
					{
						if (stale == null)
						{
							stale = new List<int>(4);
						}
						stale.Add(item.Key);
					}
				}
				if (stale != null)
				{
					foreach (int id in stale)
					{
						if (_spawned.TryGetValue(id, out BtmGenerator existing) && existing != null)
						{
							ReleaseHandsHolding(existing.gameObject);
							Object.Destroy(existing.gameObject);
						}
						_spawned.Remove(id);
					}
				}
			}
			if (map == null || DesiredScratch.Count == 0)
			{
				return;
			}
			BtmGeneratorSpawnPoint[] points = null;
			foreach (int pointId in DesiredScratch)
			{
				if (_spawned.ContainsKey(pointId))
				{
					continue;
				}
				if (points == null)
				{
					points = map.mapObject.GetComponentsInChildren<BtmGeneratorSpawnPoint>(true);
				}
				BtmGeneratorSpawnPoint point = FindPoint(points, pointId);
				if (point == null)
				{
					Debug.LogError(string.Format("[BtmGeneratorSpawner] Round wants generator at point {0}, but map '{1}' has no BtmGeneratorSpawnPoint with that id.", pointId, props.currentMap));
					continue;
				}
				GameObject prefab = ((generatorPrefab != null) ? generatorPrefab : Resources.Load<GameObject>("Prefabs/Interactables/BTM/Generator"));
				if (prefab == null)
				{
					Debug.LogError("[BtmGeneratorSpawner] No generator prefab assigned and Resources/Prefabs/Interactables/BTM/Generator not found.");
					break;
				}
				GameObject go = Object.Instantiate(prefab, point.transform.position, point.transform.rotation, point.transform);
				go.name = string.Format("Generator_{0}", pointId);
				BtmGenerator generator = go.GetComponent<BtmGenerator>();
				if (generator == null)
				{
					Debug.LogError("[BtmGeneratorSpawner] Generator prefab has no BtmGenerator on its root!");
					Object.Destroy(go);
				}
				else
				{
					generator.generatorId = pointId;
					_spawned[pointId] = generator;
				}
			}
		}

		private static MapData ResolveMap(string sceneId)
		{
			BTMGameManager instance = BTMGameManager.Instance;
			if (instance == null)
			{
				return null;
			}
			if (instance.roomSettings == null || string.IsNullOrEmpty(sceneId) || instance.roomSettings.maps == null)
			{
				return null;
			}
			foreach (MapData map in instance.roomSettings.maps)
			{
				if (map != null && map.sceneId == sceneId)
				{
					return map;
				}
			}
			return null;
		}

		private static BtmGeneratorSpawnPoint FindPoint(BtmGeneratorSpawnPoint[] points, int pointId)
		{
			for (int i = 0; i < points.Length; i++)
			{
				BtmGeneratorSpawnPoint point = points[i];
				if (point != null && point.pointId == pointId)
				{
					return point;
				}
			}
			return null;
		}

		private void DespawnAll()
		{
			foreach (KeyValuePair<int, BtmGenerator> item in _spawned)
			{
				if (!(item.Value == null))
				{
					ReleaseHandsHolding(item.Value.gameObject);
					Object.Destroy(item.Value.gameObject);
				}
			}
			_spawned.Clear();
		}

		private static void ReleaseHandsHolding(GameObject root)
		{
			GrabInteractor[] interactors = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			foreach (GrabInteractor interactor in interactors)
			{
				if (!(interactor == null) && interactor.IsGrabbing && !(interactor.HeldTransform == null) && interactor.HeldTransform.IsChildOf(root.transform))
				{
					interactor.ForceRelease();
				}
			}
			LAGrabber[] grabbers = Object.FindObjectsByType<LAGrabber>(FindObjectsSortMode.None);
			foreach (LAGrabber grabber in grabbers)
			{
				if (grabber != null)
				{
					grabber.ReleaseHandleUnder(root.transform);
				}
			}
		}
	}
}
