using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Frontend
{
	public class MenuButton : MenuInteractable
	{
		[Header("Frame")]
		[SerializeField]
		private MenuFrame frame;

		[SerializeField]
		private Color frameFillIdle = new Color(1f, 1f, 1f, 0f);

		[SerializeField]
		private Color frameFillHover = new Color(1f, 1f, 1f, 0.08f);

		[SerializeField]
		private Color frameBorderIdle = new Color(0.45f, 0.45f, 0.45f, 1f);

		[SerializeField]
		private Color frameBorderHover = new Color(1f, 1f, 1f, 1f);

		[Header("Tint")]
		[SerializeField]
		private Graphic[] tinted;

		[SerializeField]
		private Color tintIdle = new Color(0.8f, 0.8f, 0.8f, 1f);

		[SerializeField]
		private Color tintHover = new Color(1f, 1f, 1f, 1f);

		[SerializeField]
		private Color tintDisabled = new Color(0.35f, 0.35f, 0.35f, 1f);

		[Header("Motion")]
		[Tooltip("Moves toward the viewer on hover, in canvas units.")]
		[SerializeField]
		private RectTransform lift;

		[SerializeField]
		private float liftAmount;

		[SerializeField]
		private CanvasGroup revealOnHover;

		[SerializeField]
		[Min(1f)]
		private float speed = 14f;

		private float _hover;

		private float _press;

		private float _enabled = 1f;

		private bool _settled;

		private Vector3 _liftBase;

		public float Hover01 => _hover;

		public float Press01 => _press;

		protected virtual void Awake()
		{
			if (lift != null)
			{
				_liftBase = lift.localPosition;
			}
			_enabled = (base.Interactable ? 1f : 0f);
			ApplyVisuals();
		}

		protected override void OnEnable()
		{
			base.OnEnable();
			_settled = false;
		}

		protected override void OnDisable()
		{
			base.OnDisable();
			_hover = 0f;
			_press = 0f;
			ApplyVisuals();
		}

		protected override void OnHoverChanged(bool on)
		{
			_settled = false;
		}

		protected override void OnPressChanged(bool on)
		{
			_settled = false;
		}

		protected override void OnInteractableChanged()
		{
			_settled = false;
		}

		protected virtual void Update()
		{
			if (!_settled)
			{
				float k = 1f - Mathf.Exp((0f - speed) * Time.unscaledDeltaTime);
				float hoverTarget = (base.Hovered ? 1f : 0f);
				float pressTarget = (base.Pressed ? 1f : 0f);
				float enabledTarget = (base.Interactable ? 1f : 0f);
				_hover = Approach(_hover, hoverTarget, k);
				_press = Approach(_press, pressTarget, k * 1.6f);
				_enabled = Approach(_enabled, enabledTarget, k);
				ApplyVisuals();
				_settled = _hover == hoverTarget && _press == pressTarget && _enabled == enabledTarget;
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

		protected virtual void ApplyVisuals()
		{
			if (frame != null)
			{
				frame.Fill = Color.Lerp(frameFillIdle, frameFillHover, _hover);
				frame.Border = Color.Lerp(frameBorderIdle, frameBorderHover, _hover);
			}
			if (tinted != null && tinted.Length != 0)
			{
				Color color = Color.Lerp(Color.Lerp(tintIdle, tintHover, _hover), tintDisabled, 1f - _enabled);
				for (int i = 0; i < tinted.Length; i++)
				{
					if (tinted[i] != null)
					{
						tinted[i].color = color;
					}
				}
			}
			if (lift != null)
			{
				lift.localPosition = _liftBase + Vector3.back * (liftAmount * (_hover + _press * -0.6f));
			}
			if (revealOnHover != null)
			{
				revealOnHover.alpha = _hover;
			}
		}
	}
}
