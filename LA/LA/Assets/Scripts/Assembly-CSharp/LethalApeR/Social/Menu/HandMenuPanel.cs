using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Social.UI;
using UnityEngine;

namespace LethalApeR.Social.Menu
{
	[Obfuscation(Exclude = true)]
	public sealed class HandMenuPanel : MonoBehaviour, IBtmRayTarget
	{
		[SerializeField]
		private RectTransform surface;

		[SerializeField]
		private ScrollWheel playersWheel;

		private readonly List<SocialButton> _buttons = new List<SocialButton>(96);

		private readonly List<RectTransform> _clips = new List<RectTransform>(96);

		private readonly List<SocialListItem> _scratch = new List<SocialListItem>(32);

		private SocialButton _hover;

		private bool _dragging;

		private Vector3 _dragLast;

		private bool _registered;

		public bool Interactive { get; set; }

		public bool Hovered { get; private set; }

		public bool RayEnabled => Interactive && base.isActiveAndEnabled;

		private void Awake()
		{
			SocialListView[] componentsInChildren = GetComponentsInChildren<SocialListView>(true);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].ViewsCreated += Collect;
			}
		}

		public void Collect()
		{
			_buttons.Clear();
			_clips.Clear();
			GetComponentsInChildren(true, _buttons);
			for (int i = 0; i < _buttons.Count; i++)
			{
				SocialListView componentInParent = _buttons[i].GetComponentInParent<SocialListView>(true);
				_clips.Add((componentInParent != null) ? componentInParent.Viewport : null);
			}
		}

		public void Register()
		{
			if (!_registered)
			{
				_registered = true;
				BtmRayPointer.Register(this);
			}
		}

		public void Unregister()
		{
			if (_registered)
			{
				_registered = false;
				BtmRayPointer.Unregister(this);
				((IBtmRayTarget)this).OnRayExit();
			}
		}

		private void OnDisable()
		{
			Unregister();
		}

		bool IBtmRayTarget.TryHit(Ray ray, float maxDistance, out Vector3 point, out float distance)
		{
			point = default(Vector3);
			distance = 0f;
			Vector3 forward = surface.forward;
			Vector3 position = surface.position;
			Vector3 normalized = forward.normalized;
			float num = Vector3.Dot(normalized, ray.direction);
			if (Mathf.Approximately(num, 0f))
			{
				return false;
			}
			float num2 = (Vector3.Dot(position, normalized) - Vector3.Dot(normalized, ray.origin)) / num;
			if (num2 <= 0f || num2 > maxDistance)
			{
				return false;
			}
			point = ray.GetPoint(num2);
			if (!Contains(surface, point))
			{
				return false;
			}
			distance = num2;
			return true;
		}

		bool IBtmRayTarget.OnRayHover(Vector3 worldPoint)
		{
			Hovered = true;
			if (_dragging)
			{
				Vector3 dragLast = _dragLast;
				Vector3 up = surface.up;
				float y = surface.lossyScale.y;
				_dragLast = worldPoint;
				playersWheel.DragBy(Vector3.Dot(worldPoint - dragLast, -up) / Mathf.Max(y, 1E-06f), Time.unscaledDeltaTime);
				return false;
			}
			SocialButton socialButton = Find(worldPoint);
			if (socialButton == _hover)
			{
				return false;
			}
			if (_hover != null)
			{
				_hover.SetHovered(false);
			}
			_hover = socialButton;
			if (_hover != null)
			{
				_hover.SetHovered(true);
			}
			return _hover != null;
		}

		void IBtmRayTarget.OnRayExit()
		{
			Hovered = false;
			if (_hover != null)
			{
				_hover.SetHovered(false);
			}
			_hover = null;
			EndDrag();
		}

		void IBtmRayTarget.OnRayClick(Vector3 worldPoint)
		{
			if (_hover != null)
			{
				_hover.TryPress(PressSource.Ray, false);
			}
			else if (playersWheel != null && playersWheel.isActiveAndEnabled && Contains(playersWheel.Rect, worldPoint))
			{
				_dragging = true;
				_dragLast = worldPoint;
				playersWheel.List.BeginHold();
			}
		}

		void IBtmRayTarget.OnRayPress(bool pressed)
		{
			if (!pressed)
			{
				EndDrag();
			}
		}

		private void EndDrag()
		{
			if (_dragging)
			{
				_dragging = false;
				playersWheel.List.EndHold();
			}
		}

		private SocialButton Find(Vector3 world)
		{
			for (int i = 0; i < _buttons.Count; i++)
			{
				SocialButton socialButton = _buttons[i];
				if (!(socialButton == null) && socialButton.Interactable && Contains(socialButton.Rect, world))
				{
					RectTransform rectTransform = _clips[i];
					if (rectTransform == null || Contains(rectTransform, world))
					{
						return socialButton;
					}
				}
			}
			return null;
		}

		private static bool Contains(RectTransform rect, Vector3 world)
		{
			Vector3 point = rect.InverseTransformPoint(world);
			return rect.rect.Contains(point);
		}
	}
}
