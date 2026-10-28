using System.Collections.Generic;
using LethalApe.Assets.Scripts;
using LethalApe.SDK;
using Photon.Pun;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.CustomMaps
{
	public static class MapPlacementResolver
	{
		public static void Spawn(LoadedMap map, PlacementPrefabSet set)
		{
			if (set == null)
			{
				Debug.LogError("[CustomMaps] No PlacementPrefabSet assigned on CustomMapHost.");
				return;
			}
			List<PlacementMarker> markers = new List<PlacementMarker>();
			GameObject[] roots = map.Scene.GetRootGameObjects();
			foreach (GameObject root in roots)
			{
				markers.AddRange(root.GetComponentsInChildren<PlacementMarker>(true));
			}
			HashSet<PlacementKind> seen = new HashSet<PlacementKind>();
			foreach (PlacementMarker marker in markers)
			{
				if (!seen.Add(marker.Kind))
				{
					continue;
				}
				if (!set.TryGet(marker.Kind, out var entry))
				{
					Debug.LogWarning(string.Format("[CustomMaps] No prefab for placement {0}.", marker.Kind));
					continue;
				}
				Transform t = marker.transform;
				Quaternion yaw = Quaternion.Euler(0f, t.eulerAngles.y, 0f);
				Vector3 position = t.position + yaw * entry.localPosition;
				Quaternion rotation = yaw * Quaternion.Euler(entry.localEuler);
				GameObject go = Object.Instantiate(entry.prefab, position, rotation);
				go.name = entry.prefab.name;
				SceneManager.MoveGameObjectToScene(go, map.Scene);
				AfterSpawn(marker.Kind, go);
			}
		}

		private static void AfterSpawn(PlacementKind kind, GameObject go)
		{
			if (kind != PlacementKind.ComputerStation)
			{
				return;
			}
			Computer computer = go.GetComponentInChildren<Computer>(true);
			if (computer != null && PhotonNetwork.InRoom)
			{
				computer.OnJoinedRoom();
			}
			TextMeshPro[] texts = go.GetComponentsInChildren<TextMeshPro>(true);
			foreach (TextMeshPro text in texts)
			{
				if (text.gameObject.name == "Username || Build")
				{
					text.text = (PhotonNetwork.LocalPlayer != null && !string.IsNullOrEmpty(PhotonNetwork.LocalPlayer.NickName)) ? PhotonNetwork.LocalPlayer.NickName : PlayerPrefs.GetString("Username", "");
				}
			}
		}
	}
}
