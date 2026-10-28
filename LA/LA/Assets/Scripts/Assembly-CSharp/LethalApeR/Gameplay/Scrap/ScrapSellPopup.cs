using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ScrapSellPopup : MonoBehaviour
	{
		private class Entry
		{
			public GameObject go;

			public TextMeshPro tmp;

			public Vector3 origin;

			public float born;
		}

		[Header("Text")]
		[SerializeField]
		private TMP_FontAsset font;

		[Tooltip("Distance Field OVERLAY material so the number draws over everything. Falls back to a runtime clone if empty.")]
		[SerializeField]
		private Material overlayMaterial;

		[SerializeField]
		private Color color = new Color(0.5f, 1f, 0.55f, 1f);

		[Tooltip("{0} is the payout.")]
		[SerializeField]
		private string format = "+{0:N0}";

		[Header("Motion")]
		[SerializeField]
		private float life = 1.1f;

		[SerializeField]
		private float rise = 0.6f;

		[SerializeField]
		private float baseScale = 0.5f;

		[SerializeField]
		private int maxActive = 8;

		private readonly List<Entry> _active = new List<Entry>();

		private readonly Stack<Entry> _pool = new Stack<Entry>();

		private Material _runtimeOverlay;

		private void OnEnable()
		{
			ScrapEvents.OnScrapSold += HandleScrapSold;
		}

		private void OnDisable()
		{
			ScrapEvents.OnScrapSold -= HandleScrapSold;
			for (int num = _active.Count - 1; num >= 0; num--)
			{
				Release(_active[num]);
			}
		}

		private void HandleScrapSold(int payout, Vector3 worldPos, int sellerActor)
		{
			if (_active.Count >= Mathf.Max(1, maxActive))
			{
				int index = 0;
				for (int i = 1; i < _active.Count; i++)
				{
					if (_active[i].born < _active[index].born)
					{
						index = i;
					}
				}
				Release(_active[index]);
			}
			Entry entry = ((_pool.Count > 0) ? _pool.Pop() : Build());
			if (entry != null)
			{
				entry.origin = worldPos;
				entry.born = Time.time;
				entry.tmp.text = string.Format(format, payout);
				entry.tmp.color = color;
				entry.tmp.alpha = 1f;
				entry.go.SetActive(true);
				_active.Add(entry);
			}
		}

		private void Update()
		{
			if (_active.Count == 0)
			{
				return;
			}
			Camera camera = ResolveCamera();
			Vector3 vector = ((camera != null) ? camera.transform.position : Vector3.zero);
			for (int num = _active.Count - 1; num >= 0; num--)
			{
				Entry entry = _active[num];
				float num2 = (Time.time - entry.born) / Mathf.Max(life, 0.05f);
				if (num2 >= 1f)
				{
					Release(entry);
				}
				else
				{
					float num3 = 1f - (1f - num2) * (1f - num2);
					Vector3 vector2 = entry.origin + Vector3.up * (num3 * rise);
					entry.go.transform.position = vector2;
					if (camera != null)
					{
						Vector3 forward = vector2 - vector;
						if (forward.sqrMagnitude > 1E-06f)
						{
							entry.go.transform.rotation = Quaternion.LookRotation(forward, Vector3.up);
						}
					}
					entry.go.transform.localScale = Vector3.one * baseScale;
					entry.tmp.alpha = 1f - Mathf.SmoothStep(0f, 1f, (num2 - 0.5f) * 2f);
				}
			}
		}

		private static Camera ResolveCamera()
		{
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
			if (player != null && player.mainCamera != null)
			{
				return player.mainCamera;
			}
			return Camera.main;
		}

		private Entry Build()
		{
			GameObject gameObject = new GameObject("ScrapPayout");
			gameObject.transform.SetParent(base.transform, false);
			TextMeshPro textMeshPro = gameObject.AddComponent<TextMeshPro>();
			if (font != null)
			{
				textMeshPro.font = font;
			}
			Material material = ResolveOverlay(textMeshPro);
			if (material != null)
			{
				textMeshPro.fontSharedMaterial = material;
			}
			textMeshPro.fontSize = 8f;
			textMeshPro.alignment = TextAlignmentOptions.Center;
			textMeshPro.textWrappingMode = TextWrappingModes.NoWrap;
			textMeshPro.rectTransform.sizeDelta = new Vector2(6f, 2f);
			return new Entry
			{
				go = gameObject,
				tmp = textMeshPro
			};
		}

		private Material ResolveOverlay(TextMeshPro tmp)
		{
			if (overlayMaterial != null)
			{
				return overlayMaterial;
			}
			if (_runtimeOverlay != null)
			{
				return _runtimeOverlay;
			}
			Shader shader = Shader.Find("TextMeshPro/Mobile/Distance Field Overlay");
			if (shader == null)
			{
				shader = Shader.Find("TextMeshPro/Distance Field Overlay");
			}
			if (shader == null)
			{
				return null;
			}
			Material material = ((tmp.font != null) ? tmp.font.material : tmp.fontSharedMaterial);
			if (material == null)
			{
				return null;
			}
			_runtimeOverlay = new Material(material)
			{
				shader = shader
			};
			return _runtimeOverlay;
		}

		private void Release(Entry e)
		{
			_active.Remove(e);
			if (e != null)
			{
				if (e.go != null)
				{
					e.go.SetActive(false);
				}
				_pool.Push(e);
			}
		}
	}
}
