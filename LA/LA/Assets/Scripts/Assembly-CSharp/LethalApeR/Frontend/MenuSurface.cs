using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(RectTransform))]
	public sealed class MenuSurface : MonoBehaviour
	{
		public static readonly List<MenuSurface> All = new List<MenuSurface>();

		[SerializeField]
		private bool raycastable = true;

		private readonly List<MenuInteractable> _items = new List<MenuInteractable>();

		private RectTransform _rect;

		public static MenuSurface Modal { get; set; }

		public bool Raycastable
		{
			get
			{
				return raycastable;
			}
			set
			{
				raycastable = value;
			}
		}

		public bool Hovered { get; private set; }

		public RectTransform Rect => _rect ? _rect : (_rect = (RectTransform)transform);

		public event Action<bool> HoverChanged;

		public event Action ClickedOutside;

		private void OnEnable()
		{
			All.Add(this);
		}

		private void OnDisable()
		{
			All.Remove(this);
			if (Modal == this)
			{
				Modal = null;
			}
			SetHovered(false);
		}

		public bool TryHit(Ray ray, float maxDistance, out Vector3 point, out float distance)
		{
			point = default(Vector3);
			distance = 0f;
			if (!raycastable)
			{
				return false;
			}
			RectTransform rect = Rect;
			Vector3 forward = rect.forward;
			float num = Vector3.Dot(ray.direction, forward);
			if (num <= 0.0001f)
			{
				return false;
			}
			distance = Vector3.Dot(forward, rect.position - ray.origin) / num;
			if (distance <= 0f || distance > maxDistance)
			{
				return false;
			}
			point = ray.GetPoint(distance);
			Vector3 vector = rect.InverseTransformPoint(point);
			return rect.rect.Contains(vector);
		}

		public MenuInteractable Pick(Vector3 worldPoint)
		{
			MenuInteractable menuInteractable = null;
			for (int i = 0; i < _items.Count; i++)
			{
				MenuInteractable menuInteractable2 = _items[i];
				if (menuInteractable2.isActiveAndEnabled && menuInteractable2.Interactable && (!(menuInteractable != null) || menuInteractable2.Depth >= menuInteractable.Depth) && menuInteractable2.Contains(worldPoint))
				{
					menuInteractable = menuInteractable2;
				}
			}
			return menuInteractable;
		}

		internal void Register(MenuInteractable item)
		{
			if (!_items.Contains(item))
			{
				_items.Add(item);
			}
		}

		internal void Unregister(MenuInteractable item)
		{
			_items.Remove(item);
		}

		internal void SetHovered(bool on)
		{
			if (Hovered != on)
			{
				Hovered = on;
				HoverChanged?.Invoke(on);
			}
		}

		internal void RaiseClickedOutside()
		{
			ClickedOutside?.Invoke();
		}
	}
}
