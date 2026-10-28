using UnityEngine;

namespace LethalApeR.Frontend
{
	public sealed class MenuScroll : MenuInteractable
	{
		[SerializeField]
		private RectTransform content;

		[Header("Scrollbar")]
		[SerializeField]
		private RectTransform track;

		[SerializeField]
		private RectTransform thumb;

		[SerializeField]
		private CanvasGroup scrollbarGroup;

		[SerializeField]
		[Min(8f)]
		private float minThumb = 48f;

		[Header("Feel")]
		[SerializeField]
		[Min(0f)]
		private float deceleration = 5f;

		[SerializeField]
		[Range(0f, 1f)]
		private float overscrollResistance = 0.35f;

		[SerializeField]
		[Min(1f)]
		private float springBack = 12f;

		private float _offset;

		private float _velocity;

		private float _contentHeight;

		private bool _dragging;

		private float _dragStartPointer;

		private float _dragStartOffset;

		private float _lastPointer;

		private float _lastPointerTime;

		private float _barAlpha;

		public override bool GivesFeedback => false;

		public float Offset => _offset;

		public float Max => Mathf.Max(0f, _contentHeight - base.Rect.rect.height);

		public bool CanScroll => Max > 0.5f;

		public void SetContentHeight(float height, bool resetToTop)
		{
			_contentHeight = Mathf.Max(0f, height);
			if (content != null)
			{
				content.sizeDelta = new Vector2(content.sizeDelta.x, _contentHeight);
			}
			if (resetToTop)
			{
				_offset = 0f;
			}
			_offset = Mathf.Clamp(_offset, 0f, Max);
			Apply();
		}

		public void Nudge(float delta)
		{
			if (CanScroll && !_dragging)
			{
				_velocity = 0f;
				_offset = Mathf.Clamp(_offset + delta, 0f, Max);
				Apply();
			}
		}

		public void BeginDrag(float pointerY)
		{
			_dragging = true;
			_velocity = 0f;
			_dragStartPointer = pointerY;
			_dragStartOffset = _offset;
			_lastPointer = pointerY;
			_lastPointerTime = Time.unscaledTime;
		}

		public void Drag(float pointerY)
		{
			if (_dragging)
			{
				_offset = Soften(_dragStartOffset + (pointerY - _dragStartPointer));
				float unscaledTime = Time.unscaledTime;
				float num = unscaledTime - _lastPointerTime;
				if (num > 0.0001f)
				{
					float b = (pointerY - _lastPointer) / num;
					_lastPointer = pointerY;
					_lastPointerTime = unscaledTime;
					_velocity = Mathf.Lerp(_velocity, b, 0.5f);
				}
				Apply();
			}
		}

		public void EndDrag()
		{
			_dragging = false;
			if (Time.unscaledTime - _lastPointerTime > 0.08f)
			{
				_velocity = 0f;
			}
		}

		private float Soften(float raw)
		{
			float max = Max;
			if (raw < 0f)
			{
				return raw * overscrollResistance;
			}
			if (raw > max)
			{
				return max + (raw - max) * overscrollResistance;
			}
			return raw;
		}

		private void Update()
		{
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			if (!_dragging)
			{
				float offset = _offset;
				float max = Max;
				if (Mathf.Abs(_velocity) > 1f)
				{
					_offset += _velocity * unscaledDeltaTime;
					_velocity *= Mathf.Exp(-deceleration * unscaledDeltaTime);
					if (_offset < 0f || _offset > max)
					{
						_velocity *= Mathf.Exp(-springBack * unscaledDeltaTime);
					}
				}
				else
				{
					_velocity = 0f;
				}
				float num = Mathf.Clamp(_offset, 0f, max);
				if (!Mathf.Approximately(_offset, num))
				{
					_offset = Mathf.Lerp(_offset, num, 1f - Mathf.Exp(-springBack * unscaledDeltaTime));
				}
				if (Mathf.Abs(_offset - num) < 0.05f)
				{
					_offset = num;
				}
				if (_offset != offset)
				{
					Apply();
				}
			}
			float num2 = (CanScroll ? 1f : 0f);
			if (!Mathf.Approximately(_barAlpha, num2))
			{
				_barAlpha = Mathf.MoveTowards(_barAlpha, num2, unscaledDeltaTime * 6f);
				if (scrollbarGroup != null)
				{
					scrollbarGroup.alpha = _barAlpha;
				}
			}
		}

		private void Apply()
		{
			if (content != null)
			{
				content.anchoredPosition = new Vector2(content.anchoredPosition.x, _offset);
			}
			if (!(track == null) && !(thumb == null))
			{
				float height = track.rect.height;
				float height2 = base.Rect.rect.height;
				float num = ((_contentHeight > 0f) ? Mathf.Clamp01(height2 / _contentHeight) : 1f);
				float num2 = Mathf.Max(minThumb, height * num);
				float max = Max;
				float num3 = ((max > 0f) ? Mathf.Clamp01(_offset / max) : 0f);
				thumb.sizeDelta = new Vector2(thumb.sizeDelta.x, num2);
				thumb.anchoredPosition = new Vector2(thumb.anchoredPosition.x, (0f - num3) * (height - num2));
			}
		}
	}
}
