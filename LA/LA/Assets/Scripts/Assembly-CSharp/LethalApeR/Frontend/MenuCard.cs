using UnityEngine;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(MenuSurface), typeof(CanvasGroup), typeof(Canvas))]
	public sealed class MenuCard : MonoBehaviour
	{
		[SerializeField]
		private MenuArcItem arcItem;

		[SerializeField]
		private MenuFrame frame;

		[SerializeField]
		private Color borderIdle = new Color(0.7f, 0.7f, 0.7f, 1f);

		[SerializeField]
		private Color borderHover = new Color(1f, 1f, 1f, 1f);

		[Tooltip("Metres toward the viewer while hovered.")]
		[SerializeField]
		private float hoverLift = 0.012f;

		[Tooltip("Metres the card rises through during its intro.")]
		[SerializeField]
		private float introRise = 0.035f;

		[SerializeField]
		private float introSeconds = 0.5f;

		[SerializeField]
		[Range(0f, 1f)]
		private float dimmedAlpha = 0.22f;

		[SerializeField]
		[Min(1f)]
		private float speed = 12f;

		private MenuSurface _surface;

		private CanvasGroup _group;

		private Canvas _canvas;

		private float _baseRadius;

		private float _baseHeight;

		private float _hover;

		private float _dim;

		private float _intro;

		private float _introStart = float.MaxValue;

		private bool _dimmed;

		private bool _initialised;

		public bool Dimmed
		{
			get
			{
				return _dimmed;
			}
			set
			{
				_dimmed = value;
			}
		}

		public bool Shown => _intro >= 1f;

		private void Awake()
		{
			Init();
		}

		private void Init()
		{
			if (!_initialised)
			{
				_initialised = true;
				_surface = GetComponent<MenuSurface>();
				_group = GetComponent<CanvasGroup>();
				_canvas = GetComponent<Canvas>();
				if (arcItem == null)
				{
					arcItem = GetComponent<MenuArcItem>();
				}
				_baseRadius = arcItem.radiusOffset;
				_baseHeight = arcItem.height;
			}
		}

		public void Hide()
		{
			Init();
			_intro = 0f;
			_introStart = float.MaxValue;
			Apply();
		}

		public void Show(float delay)
		{
			_introStart = Time.unscaledTime + delay;
		}

		private void Update()
		{
			float k = 1f - Mathf.Exp((0f - speed) * Time.unscaledDeltaTime);
			float intro = _intro;
			float hover = _hover;
			float dim = _dim;
			if (_intro < 1f && Time.unscaledTime >= _introStart)
			{
				_intro = Mathf.Clamp01((Time.unscaledTime - _introStart) / Mathf.Max(0.01f, introSeconds));
			}
			float hoverTarget = ((_surface.Hovered && !_dimmed && Shown) ? 1f : 0f);
			_hover = Approach(_hover, hoverTarget, k);
			_dim = Approach(_dim, _dimmed ? 1f : 0f, k);
			if (intro != _intro || hover != _hover || dim != _dim)
			{
				Apply();
			}
		}

		private static float Approach(float value, float target, float k)
		{
			value = Mathf.Lerp(value, target, k);
			if (!(Mathf.Abs(value - target) < 0.002f))
			{
				return value;
			}
			return target;
		}

		private void Apply()
		{
			float eased = 1f - Mathf.Pow(1f - _intro, 3f);
			float alpha = eased * Mathf.Lerp(1f, dimmedAlpha, _dim);
			_group.alpha = alpha;
			if (_canvas.enabled != alpha > 0.002f)
			{
				_canvas.enabled = alpha > 0.002f;
			}
			_surface.Raycastable = _intro > 0.6f;
			arcItem.radiusOffset = _baseRadius - _hover * hoverLift;
			arcItem.height = _baseHeight - (1f - eased) * introRise;
			arcItem.Apply();
			if (frame != null)
			{
				frame.Border = Color.Lerp(borderIdle, borderHover, _hover);
			}
		}
	}
}
