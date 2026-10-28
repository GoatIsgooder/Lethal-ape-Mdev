using System.Collections.Generic;
using GorillaLocomotion;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.Combat
{
	public class DamageNumbers : MonoBehaviour
	{
		private class Entry
		{
			public GameObject go;

			public TextMeshPro tmp;

			public Object victim;

			public Vector3 origin;

			public float born;

			public float total;

			public bool headshot;

			public float lastAlpha;
		}

		[Header("Text (wired by the scaffolder)")]
		[Tooltip("Font for the numbers. Defaults to the TMP default font.")]
		[SerializeField]
		private TMP_FontAsset font;

		[Tooltip("Font material using the Distance Field OVERLAY shader so numbers draw over everything. Falls back to a runtime clone if empty.")]
		[SerializeField]
		private Material overlayMaterial;

		[Header("Look")]
		public Color bodyColor = Color.white;

		public Color headshotColor = new Color(1f, 0.84f, 0.2f, 1f);

		[Tooltip("Headshot numbers scale up by this much.")]
		public float headshotScale = 1.35f;

		[Header("Motion")]
		[Tooltip("Seconds a number lives (timer restarts when damage merges in).")]
		public float life = 0.8f;

		[Tooltip("World meters the number floats upward over its life.")]
		public float rise = 0.4f;

		[Tooltip("Hits on the SAME target within this window add into the existing number.")]
		public float mergeWindow = 0.35f;

		[Header("Size")]
		[Tooltip("Base local scale of a number.")]
		public float baseScale = 0.35f;

		[Tooltip("Scale multiplies with distance so far numbers stay readable (clamped below).")]
		public float distanceScale = 0.1f;

		public float minScaleMul = 0.5f;

		public float maxScaleMul = 4f;

		[Tooltip("Hard cap on simultaneous numbers — stalest is recycled past this.")]
		public int maxActive = 16;

		private readonly List<Entry> _active = new List<Entry>();

		private readonly Stack<Entry> _pool = new Stack<Entry>();

		private Material _runtimeOverlay;

		private bool _warnedNoOverlay;

		public static DamageNumbers Instance { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnEnable()
		{
			RivalsEvents.OnLocalHitDealt += HandleHit;
		}

		private void OnDisable()
		{
			RivalsEvents.OnLocalHitDealt -= HandleHit;
			for (int num = _active.Count - 1; num >= 0; num--)
			{
				Release(_active[num]);
			}
		}

		private void HandleHit(DamageInfo info, Object victim)
		{
			float resolvedAmount = info.ResolvedAmount;
			if (resolvedAmount <= 0f)
			{
				return;
			}
			if (victim != null)
			{
				for (int i = 0; i < _active.Count; i++)
				{
					Entry entry = _active[i];
					if (!(entry.victim != victim) && Time.time - entry.born <= mergeWindow)
					{
						entry.total += resolvedAmount;
						entry.headshot |= info.IsHeadshot;
						entry.born = Time.time;
						entry.origin = info.HitPoint;
						ApplyText(entry);
						return;
					}
				}
			}
			Show(info.HitPoint, resolvedAmount, info.IsHeadshot, victim);
		}

		public void Show(Vector3 worldPos, float amount, bool headshot, Object victim = null)
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
				entry.victim = victim;
				entry.origin = worldPos;
				entry.born = Time.time;
				entry.total = amount;
				entry.headshot = headshot;
				entry.lastAlpha = -1f;
				entry.go.SetActive(true);
				ApplyText(entry);
				_active.Add(entry);
			}
		}

		private void ApplyText(Entry e)
		{
			e.tmp.text = Mathf.Max(1, Mathf.RoundToInt(e.total)).ToString();
			e.tmp.color = (e.headshot ? headshotColor : bodyColor);
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
					continue;
				}
				float num3 = 1f - (1f - num2) * (1f - num2);
				Vector3 vector2 = entry.origin + Vector3.up * (num3 * rise);
				entry.go.transform.position = vector2;
				if (camera != null)
				{
					Vector3 vector3 = vector2 - vector;
					float sqrMagnitude = vector3.sqrMagnitude;
					if (sqrMagnitude > 1E-06f)
					{
						entry.go.transform.rotation = Quaternion.LookRotation(vector3, Vector3.up);
					}
					float num4 = Mathf.Clamp(Mathf.Sqrt(sqrMagnitude) * distanceScale, minScaleMul, maxScaleMul);
					float num5 = (entry.headshot ? headshotScale : 1f);
					entry.go.transform.localScale = Vector3.one * (num4 * baseScale * num5);
				}
				float num6 = 1f - Mathf.SmoothStep(0f, 1f, (num2 - 0.55f) / 0.45f);
				if (!Mathf.Approximately(entry.lastAlpha, num6))
				{
					entry.lastAlpha = num6;
					entry.tmp.alpha = num6;
				}
			}
		}

		private static Camera ResolveCamera()
		{
			Player player = (Player.HasInstance ? Player.Instance : null);
			if (player != null && player.mainCamera != null)
			{
				return player.mainCamera;
			}
			return Camera.main;
		}

		private Entry Build()
		{
			GameObject gameObject = new GameObject("DamageNumber");
			gameObject.transform.SetParent(base.transform, worldPositionStays: false);
			TextMeshPro textMeshPro = gameObject.AddComponent<TextMeshPro>();
			if (font != null)
			{
				textMeshPro.font = font;
			}
			Material material = ResolveOverlayMaterial(textMeshPro);
			if (material != null)
			{
				textMeshPro.fontSharedMaterial = material;
			}
			textMeshPro.fontSize = 8f;
			textMeshPro.alignment = TextAlignmentOptions.Center;
			textMeshPro.textWrappingMode = TextWrappingModes.NoWrap;
			textMeshPro.overflowMode = TextOverflowModes.Overflow;
			textMeshPro.rectTransform.sizeDelta = new Vector2(4f, 2f);
			return new Entry
			{
				go = gameObject,
				tmp = textMeshPro
			};
		}

		private Material ResolveOverlayMaterial(TextMeshPro tmp)
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
				if (!_warnedNoOverlay)
				{
					_warnedNoOverlay = true;
					Debug.LogWarning("[DamageNumbers] No overlay font material assigned and the TMP overlay shader isn't available — numbers will render with normal depth.", this);
				}
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
			e.victim = null;
			if (e.go != null)
			{
				e.go.SetActive(false);
				_pool.Push(e);
			}
		}
	}
}
