using System;
using UnityEngine;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(RectTransform))]
	public abstract class MenuInteractable : MonoBehaviour
	{
		[SerializeField]
		private bool interactable = true;

		[Tooltip("Optional. Points outside this rect miss, e.g. rows scrolled out of a viewport.")]
		[SerializeField]
		private RectTransform clip;

		private MenuSurface _surface;

		private RectTransform _rect;

		public bool Interactable
		{
			get
			{
				return interactable;
			}
			set
			{
				if (interactable != value)
				{
					interactable = value;
					if (!value)
					{
						SetHover(false);
						SetPressed(false);
					}
					OnInteractableChanged();
				}
			}
		}

		public RectTransform Clip
		{
			get
			{
				return clip;
			}
			set
			{
				clip = value;
			}
		}

		public RectTransform Rect => _rect ? _rect : (_rect = (RectTransform)transform);

		public MenuSurface Surface => _surface;

		public bool Hovered { get; private set; }

		public bool Pressed { get; private set; }

		public virtual bool GivesFeedback => true;

		internal int Depth { get; private set; }

		public event Action Clicked;

		protected virtual void OnEnable()
		{
			_surface = GetComponentInParent<MenuSurface>(true);
			if (_surface == null)
			{
				return;
			}
			_surface.Register(this);
			int depth = 0;
			for (Transform t = transform; t != null && t != _surface.transform; t = t.parent)
			{
				depth++;
			}
			Depth = depth;
		}

		protected virtual void OnDisable()
		{
			if (_surface != null)
			{
				_surface.Unregister(this);
			}
			SetHover(false);
			SetPressed(false);
		}

		public bool Contains(Vector3 worldPoint)
		{
			if (!Inside(Rect, worldPoint))
			{
				return false;
			}
			return clip == null || Inside(clip, worldPoint);
		}

		private static bool Inside(RectTransform rt, Vector3 worldPoint)
		{
			Vector3 local = rt.InverseTransformPoint(worldPoint);
			return rt.rect.Contains(local);
		}

		internal void SetHover(bool on)
		{
			if (Hovered != on)
			{
				Hovered = on;
				OnHoverChanged(on);
			}
		}

		internal void SetPressed(bool on)
		{
			if (Pressed != on)
			{
				Pressed = on;
				OnPressChanged(on);
			}
		}

		internal void Click()
		{
			OnClick();
			Clicked?.Invoke();
		}

		protected virtual void OnHoverChanged(bool on)
		{
		}

		protected virtual void OnPressChanged(bool on)
		{
		}

		protected virtual void OnClick()
		{
		}

		protected virtual void OnInteractableChanged()
		{
		}
	}
}
