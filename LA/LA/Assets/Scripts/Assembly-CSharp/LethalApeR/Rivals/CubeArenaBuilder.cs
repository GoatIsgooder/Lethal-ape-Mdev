using System.Collections.Generic;
using LethalApeR.Rivals.Maps;
using UnityEngine;

namespace LethalApeR.Rivals
{
	[DisallowMultipleComponent]
	public class CubeArenaBuilder : MonoBehaviour
	{
		[Header("Dimensions (metres)")]
		public float length = 44f;

		public float width = 30f;

		public float wallHeight = 6f;

		public float baseDepth = 8f;

		[Header("Layer for built geometry (must be in weapon Hit Masks)")]
		public int geometryLayer;

		[Header("Spawns")]
		[Min(1f)]
		public int spawnsPerTeam = 3;

		[Header("Colors")]
		public Color floorColor = new Color(0.2f, 0.2f, 0.23f);

		public Color wallColor = new Color(0.3f, 0.3f, 0.34f);

		public Color coverColor = new Color(0.42f, 0.42f, 0.47f);

		private const string BuiltRootName = "__ArenaGeometry";

		private readonly Dictionary<Color, Material> _matCache = new Dictionary<Color, Material>();

		[ContextMenu("Build Arena")]
		public void BuildArena()
		{
			ClearArena();
			_matCache.Clear();
			GameObject root = new GameObject(BuiltRootName);
			root.transform.SetParent(transform, false);
			Transform parent = root.transform;
			float halfL = length * 0.5f;
			float halfW = width * 0.5f;
			AddBox(parent, "Floor", new Vector3(0f, -0.5f, 0f), new Vector3(length, 1f, width), floorColor);
			AddBox(parent, "Wall +X", new Vector3(halfL, wallHeight * 0.5f, 0f), new Vector3(1f, wallHeight, width), wallColor);
			AddBox(parent, "Wall -X", new Vector3(-halfL, wallHeight * 0.5f, 0f), new Vector3(1f, wallHeight, width), wallColor);
			AddBox(parent, "Wall +Z", new Vector3(0f, wallHeight * 0.5f, halfW), new Vector3(length, wallHeight, 1f), wallColor);
			AddBox(parent, "Wall -Z", new Vector3(0f, wallHeight * 0.5f, -halfW), new Vector3(length, wallHeight, 1f), wallColor);
			BuildBase(parent, Team.TeamA, -1f, halfL);
			BuildBase(parent, Team.TeamB, 1f, halfL);
			AddBox(parent, "Center Platform", new Vector3(0f, 0.8f, 0f), new Vector3(8f, 1.6f, 8f), coverColor);
			AddRamp(parent, "Center Ramp -X", new Vector3(-6f, 0.8f, 0f), 4f, 8f, 1.6f, -1f);
			AddRamp(parent, "Center Ramp +X", new Vector3(6f, 0.8f, 0f), 4f, 8f, 1.6f, 1f);
			float[] xs = new float[2]
			{
				halfL * 0.45f,
				halfL * 0.25f
			};
			float[] zs = new float[2]
			{
				halfW * 0.5f,
				halfW * -0.5f
			};
			int idx = 0;
			foreach (float x in xs)
			{
				foreach (float z in zs)
				{
					if (!Mathf.Approximately(x, 0f) || !Mathf.Approximately(z, 0f))
					{
						AddBox(parent, string.Format("Cover {0}", idx++), new Vector3(x, 1f, z), new Vector3(2f, 2f, 2f), coverColor);
						AddBox(parent, string.Format("Cover {0}", idx++), new Vector3(-x, 1f, z), new Vector3(2f, 2f, 2f), coverColor);
					}
				}
			}
			float px = halfL - 3f;
			float pz = halfW - 3f;
			float py = wallHeight * 0.5f;
			AddBox(parent, "Pillar 1", new Vector3(px, py, pz), new Vector3(1.5f, wallHeight, 1.5f), wallColor);
			AddBox(parent, "Pillar 2", new Vector3(px, py, -pz), new Vector3(1.5f, wallHeight, 1.5f), wallColor);
			AddBox(parent, "Pillar 3", new Vector3(-px, py, pz), new Vector3(1.5f, wallHeight, 1.5f), wallColor);
			AddBox(parent, "Pillar 4", new Vector3(-px, py, -pz), new Vector3(1.5f, wallHeight, 1.5f), wallColor);
			SetLayerRecursive(root, geometryLayer);
			Debug.Log("[CubeArenaBuilder] Arena built. Move/replace pieces freely; spawns are under each base.", this);
		}

		[ContextMenu("Clear Arena")]
		public void ClearArena()
		{
			for (int i = transform.childCount - 1; i >= 0; i--)
			{
				Transform child = transform.GetChild(i);
				if (child.name == BuiltRootName)
				{
					if (Application.isPlaying)
					{
						Object.Destroy(child.gameObject);
					}
					else
					{
						Object.DestroyImmediate(child.gameObject);
					}
				}
			}
		}

		private void BuildBase(Transform parent, Team team, float sign, float halfL)
		{
			Color teamColor = team.ToColor();
			float x = (halfL - baseDepth * 0.5f - 0.5f) * sign;
			GameObject baseGo = AddBox(parent, string.Format("Base {0}", team), new Vector3(x, 0.6f, 0f), new Vector3(baseDepth, 1.2f, width - 4f), Lerp(coverColor, teamColor, 0.5f));
			float rampX = x - (baseDepth * 0.5f + 2f) * sign;
			AddRamp(parent, string.Format("Base Ramp {0}", team), new Vector3(rampX, 0.6f, 0f), 4f, width - 4f, 1.2f, sign);
			for (int i = 0; i < spawnsPerTeam; i++)
			{
				float zMin = (width - 8f) * -0.5f;
				float zMax = (width - 8f) * 0.5f;
				float z = 0f;
				if (spawnsPerTeam > 1)
				{
					z = Mathf.Lerp(zMin, zMax, (float)i / (float)(spawnsPerTeam - 1));
				}
				GameObject spawn = new GameObject(string.Format("Spawn {0} {1}", team, i));
				spawn.transform.SetParent(baseGo.transform, false);
				spawn.transform.position = new Vector3(x, 1.25f, z);
				spawn.transform.rotation = Quaternion.LookRotation(new Vector3(-sign, 0f, 0f), Vector3.up);
				spawn.AddComponent<SpawnPoint>().team = team;
			}
		}

		private GameObject AddBox(Transform parent, string name, Vector3 localPos, Vector3 size, Color color)
		{
			GameObject go = GameObject.CreatePrimitive(PrimitiveType.Cube);
			go.name = name;
			go.transform.SetParent(parent, false);
			go.transform.localPosition = localPos;
			go.transform.localScale = size;
			ApplyColor(go, color);
			return go;
		}

		private void AddRamp(Transform parent, string name, Vector3 localPos, float run, float rampWidth, float rise, float dirSign)
		{
			GameObject go = GameObject.CreatePrimitive(PrimitiveType.Cube);
			go.name = name;
			go.transform.SetParent(parent, false);
			go.transform.localScale = new Vector3(Mathf.Sqrt(run * run + rise * rise), 0.4f, rampWidth);
			float angle = Mathf.Atan2(rise, run) * Mathf.Rad2Deg;
			go.transform.localPosition = localPos;
			go.transform.localRotation = Quaternion.Euler(0f, 0f, angle * dirSign);
			ApplyColor(go, coverColor);
		}

		private void ApplyColor(GameObject go, Color color)
		{
			Renderer renderer = go.GetComponent<Renderer>();
			if (renderer == null)
			{
				return;
			}
			if (!_matCache.TryGetValue(color, out var mat))
			{
				Shader shader = Shader.Find("Standard");
				mat = new Material((shader != null) ? shader : renderer.sharedMaterial.shader);
				mat.color = color;
				_matCache[color] = mat;
			}
			renderer.sharedMaterial = mat;
		}

		private static Color Lerp(Color a, Color b, float t)
		{
			t = Mathf.Clamp01(t);
			return new Color(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t, a.a + (b.a - a.a) * t);
		}

		private static void SetLayerRecursive(GameObject go, int layer)
		{
			go.layer = layer;
			foreach (Transform child in go.transform)
			{
				SetLayerRecursive(child.gameObject, layer);
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = Color.yellow;
			Gizmos.matrix = transform.localToWorldMatrix;
			Gizmos.DrawWireCube(new Vector3(0f, wallHeight * 0.5f, 0f), new Vector3(length, wallHeight, width));
		}
	}
}
