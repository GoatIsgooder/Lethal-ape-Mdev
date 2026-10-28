using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace LethalApeR.SceneFlow
{
	[DefaultExecutionOrder(32767)]
	public sealed class SceneFadeOverlay : MonoBehaviour
	{
		private static SceneFadeOverlay _instance;

		private Canvas _canvas;

		private CanvasGroup _group;

		private RectTransform _rect;

		private Transform _head;

		private Camera _cam;

		private float _alpha;

		public static SceneFadeOverlay Current => _instance;

		public float Alpha
		{
			get
			{
				return _alpha;
			}
			set
			{
				_alpha = Mathf.Clamp01(value);
				if ((bool)_group)
				{
					_group.alpha = _alpha;
				}
				if ((bool)_canvas)
				{
					bool flag = _alpha > 0.001f;
					if (_canvas.enabled != flag)
					{
						_canvas.enabled = flag;
						if (flag)
						{
							SnapToHead();
						}
					}
				}
			}
		}

		public bool IsBlack => _alpha >= 0.999f;

		public static SceneFadeOverlay Ensure()
		{
			if ((bool)_instance)
			{
				return _instance;
			}
			GameObject gameObject = new GameObject("~SceneFadeOverlay", typeof(RectTransform));
			gameObject.layer = 0;
			Object.DontDestroyOnLoad(gameObject);
			_instance = gameObject.AddComponent<SceneFadeOverlay>();
			return _instance;
		}

		private void Awake()
		{
			_instance = this;
			Build();
			AcquireHead();
			SceneManager.sceneLoaded += OnSceneLoaded;
		}

		private void OnDestroy()
		{
			SceneManager.sceneLoaded -= OnSceneLoaded;
			if (_instance == this)
			{
				_instance = null;
			}
		}

		private void Build()
		{
			_canvas = base.gameObject.AddComponent<Canvas>();
			_canvas.renderMode = RenderMode.WorldSpace;
			_canvas.sortingOrder = 32767;
			_canvas.enabled = false;
			_group = base.gameObject.AddComponent<CanvasGroup>();
			_group.alpha = 0f;
			_group.interactable = false;
			_group.blocksRaycasts = false;
			_rect = base.transform as RectTransform;
			if (_rect != null)
			{
				_rect.sizeDelta = new Vector2(1000f, 1000f);
			}
			else
			{
				Debug.LogError("[SceneFadeOverlay] Host GameObject has no RectTransform - build it via Ensure().");
			}
			GameObject gameObject = new GameObject("Black", typeof(RectTransform));
			gameObject.layer = 0;
			RectTransform obj = (RectTransform)gameObject.transform;
			obj.SetParent(base.transform, worldPositionStays: false);
			obj.anchorMin = Vector2.zero;
			obj.anchorMax = Vector2.one;
			obj.offsetMin = Vector2.zero;
			obj.offsetMax = Vector2.zero;
			RawImage rawImage = gameObject.AddComponent<RawImage>();
			rawImage.color = Color.black;
			rawImage.raycastTarget = false;
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			AcquireHead();
			SnapToHead();
		}

		private void AcquireHead()
		{
			_cam = Camera.main;
			_head = (_cam ? _cam.transform : null);
			if ((bool)_canvas)
			{
				_canvas.worldCamera = _cam;
			}
		}

		private void LateUpdate()
		{
			if (_alpha > 0.001f)
			{
				if (!_head)
				{
					AcquireHead();
				}
				SnapToHead();
			}
		}

		private void SnapToHead()
		{
			if (!_head)
			{
				AcquireHead();
				if (!_head)
				{
					return;
				}
			}
			float nearClipPlane = _cam.nearClipPlane;
			float num = Mathf.Tan(_cam.fieldOfView * 0.5f * Mathf.Deg2Rad);
			float num2 = Mathf.Max(nearClipPlane * 1.5f, 0.05f);
			float num3 = Mathf.Max(num2 * num * 8f, 0.4f);
			base.transform.SetPositionAndRotation(_head.position + _head.forward * num2, _head.rotation);
			base.transform.localScale = num3 / 1000f * Vector3.one;
		}

		public IEnumerator FadeTo(float target, float duration)
		{
			target = Mathf.Clamp01(target);
			float from = _alpha;
			if (Mathf.Approximately(from, target) || duration <= 0f)
			{
				Alpha = target;
				yield break;
			}
			float t = 0f;
			while (t < duration)
			{
				t += Time.unscaledDeltaTime;
				Alpha = Mathf.Lerp(from, target, t / duration);
				yield return null;
			}
			Alpha = target;
		}
	}
}
