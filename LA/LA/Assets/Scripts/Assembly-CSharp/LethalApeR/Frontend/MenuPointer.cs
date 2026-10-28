using System;
using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;
using UnityEngine.XR;
using CommonUsages = UnityEngine.XR.CommonUsages;
using InputDevice = UnityEngine.XR.InputDevice;

namespace LethalApeR.Frontend
{
	[DefaultExecutionOrder(50)]
	public sealed class MenuPointer : MonoBehaviour
	{
		private enum Hand
		{
			Left = 0,
			Right = 1
		}

		[SerializeField]
		private MenuRig rig;

		[Header("Aim")]
		[SerializeField]
		private float maxDistance = 8f;

		[Tooltip("Only used when the device reports no pointer pose: rotation from grip pose to pointing direction.")]
		[SerializeField]
		private Vector3 fallbackAimEuler = new Vector3(35f, 0f, 0f);

		[SerializeField]
		private float originForward = 0.05f;

		[Header("Smoothing (One Euro)")]
		[SerializeField]
		private float minCutoff = 1.4f;

		[SerializeField]
		private float beta = 6f;

		[SerializeField]
		private float derivativeCutoff = 1.2f;

		[Header("Input")]
		[SerializeField]
		[Range(0.3f, 1f)]
		private float triggerDown = 0.6f;

		[SerializeField]
		[Range(0f, 0.3f)]
		private float triggerHysteresis = 0.15f;

		[Tooltip("Canvas units the cursor must travel with the trigger held before a press becomes a scroll drag.")]
		[SerializeField]
		private float dragThreshold = 14f;

		[SerializeField]
		private float stickScrollSpeed = 1600f;

		[SerializeField]
		private float wheelScrollStep = 120f;

		[SerializeField]
		[Range(0f, 0.5f)]
		private float stickDeadzone = 0.2f;

		[Header("Feedback")]
		[SerializeField]
		private AudioClip hoverClip;

		[SerializeField]
		private AudioClip clickClip;

		[SerializeField]
		private AudioClip backClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverVolume = 0.2f;

		[SerializeField]
		[Range(0f, 1f)]
		private float clickVolume = 0.45f;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverHaptic = 0.1f;

		[SerializeField]
		[Range(0f, 1f)]
		private float clickHaptic = 0.35f;

		[Header("Visuals")]
		[SerializeField]
		private Material beamMaterial;

		[SerializeField]
		private Material cursorMaterial;

		[SerializeField]
		private Color beamColor = new Color(0.92f, 0.92f, 0.92f, 1f);

		[SerializeField]
		private float beamWidth = 0.003f;

		[SerializeField]
		[Range(4f, 40f)]
		private int beamSegments = 20;

		[SerializeField]
		[Range(0.1f, 0.9f)]
		private float bendHandle = 0.55f;

		[SerializeField]
		private float stubLength = 0.28f;

		[SerializeField]
		[Range(0f, 1f)]
		private float stubAlpha = 0.35f;

		[Tooltip("Cursor diameter in degrees of view, so it reads the same at any distance.")]
		[SerializeField]
		private float cursorDegrees = 0.9f;

		[SerializeField]
		private float originDotSize = 0.012f;

		private static readonly InputFeatureUsage<Quaternion> PointerRotationA = new InputFeatureUsage<Quaternion>("PointerRotation");

		private static readonly InputFeatureUsage<Quaternion> PointerRotationB = new InputFeatureUsage<Quaternion>("pointerRotation");

		private static readonly InputFeatureUsage<Vector3> PointerPositionA = new InputFeatureUsage<Vector3>("PointerPosition");

		private static readonly InputFeatureUsage<Vector3> PointerPositionB = new InputFeatureUsage<Vector3>("pointerPosition");

		private static readonly int RingId = Shader.PropertyToID("_Ring");

		private static readonly int RingWidthId = Shader.PropertyToID("_RingWidth");

		private static readonly int DotRadiusId = Shader.PropertyToID("_DotRadius");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private Hand _active = Hand.Right;

		private bool _leftWasDown;

		private bool _rightWasDown;

		private bool _backWasDown;

		private bool _held;

		private bool _armed;

		private MenuSurface _surface;

		private MenuInteractable _hover;

		private MenuInteractable _press;

		private MenuSurface _pressSurface;

		private MenuScroll _dragScroll;

		private bool _dragging;

		private bool _pressOutside;

		private Vector2 _pressLocal;

		private Vector3 _cursor;

		private Vector3 _filtered;

		private Vector3 _dFiltered;

		private bool _filterSeeded;

		private Ray _ray;

		private bool _hasRay;

		private float _visible;

		private float _pressVisual;

		private float _lastHoverSound;

		private LineRenderer _beam;

		private Transform _cursorT;

		private Transform _originT;

		private MeshRenderer _cursorR;

		private MeshRenderer _originR;

		private MaterialPropertyBlock _block;

		private AudioSource _voice;

		private readonly Vector3[] _points = new Vector3[41];

		private bool _scripted;

		private Ray _scriptedRay;

		private float _scriptedTrigger;

		private float _scriptedScroll;

		public MenuSurface HoveredSurface => _surface;

		public event Action BackPressed;

		public void DriveScripted(Ray ray, float trigger, float scroll = 0f)
		{
			_scripted = true;
			_scriptedRay = ray;
			_scriptedTrigger = trigger;
			_scriptedScroll = scroll;
		}

		public void ReleaseScripted()
		{
			_scripted = false;
		}

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			BuildVisuals();
			_voice = gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
			if (hoverClip != null)
			{
				hoverClip.LoadAudioData();
			}
			if (clickClip != null)
			{
				clickClip.LoadAudioData();
			}
			if (backClip != null)
			{
				backClip.LoadAudioData();
			}
		}

		private void OnEnable()
		{
			_armed = false;
		}

		private void OnDisable()
		{
			SetHover(null, null);
			if (_press != null)
			{
				_press.SetPressed(false);
			}
			if (_dragScroll != null)
			{
				_dragScroll.EndDrag();
			}
			_press = null;
			_dragScroll = null;
			_dragging = false;
			_held = false;
			_visible = 0f;
			_filterSeeded = false;
			if (_beam != null)
			{
				_beam.enabled = false;
			}
			if (_cursorR != null)
			{
				_cursorR.enabled = false;
			}
			if (_originR != null)
			{
				_originR.enabled = false;
			}
		}

		private void Update()
		{
			float trigger = ReadInput(VRInputController.Instance, out float scroll, out bool back);
			if (back && !_backWasDown)
			{
				if (backClip != null)
				{
					_voice.PlayOneShot(backClip, clickVolume);
				}
				BackPressed?.Invoke();
			}
			_backWasDown = back;
			Cast();
			HandlePress(trigger);
			HandleScroll(scroll);
			DrawVisuals();
		}

		private float ReadInput(VRInputController input, out float scroll, out bool back)
		{
			scroll = 0f;
			back = false;
			if (_scripted)
			{
				_ray = _scriptedRay;
				_hasRay = true;
				scroll = _scriptedScroll;
				return _scriptedTrigger;
			}
			if (rig.IsDesktop)
			{
				_hasRay = rig.TryMouseRay(out _ray);
				Mouse mouse = Mouse.current;
				Keyboard keyboard = Keyboard.current;
				back = keyboard != null && keyboard[Key.Escape].isPressed;
				if (mouse == null)
				{
					return 0f;
				}
				Vector2 wheel = mouse.scroll.ReadValue();
				if (Mathf.Abs(wheel.y) > 0.01f)
				{
					scroll = -Mathf.Sign(wheel.y) * wheelScrollStep;
				}
				return mouse.leftButton.isPressed ? 1f : 0f;
			}
			if (input == null)
			{
				_hasRay = false;
				return 0f;
			}
			float leftTrigger = input.LeftTriggerValue;
			float rightTrigger = input.RightTriggerValue;
			bool leftDown = leftTrigger >= triggerDown;
			bool rightDown = rightTrigger >= triggerDown;
			if (leftDown && _active == Hand.Right && !_leftWasDown && Tracked(Device(input, Hand.Left)))
			{
				SwitchTo(Hand.Left);
			}
			else if (rightDown && _active == Hand.Left && !_rightWasDown && Tracked(Device(input, Hand.Right)))
			{
				SwitchTo(Hand.Right);
			}
			if (!Tracked(Device(input, _active)) && Tracked(Device(input, Other(_active))))
			{
				SwitchTo(Other(_active));
			}
			_leftWasDown = leftDown;
			_rightWasDown = rightDown;
			back = input.LeftSecondaryButton || input.RightSecondaryButton;
			_hasRay = Tracked(Device(input, _active)) && TryAim(input, _active, out _ray);
			float stick = (_active == Hand.Left) ? input.LeftJoystick.y : input.RightJoystick.y;
			if (Mathf.Abs(stick) > stickDeadzone)
			{
				float amount = Mathf.InverseLerp(stickDeadzone, 1f, Mathf.Abs(stick));
				scroll = -Mathf.Sign(stick) * amount * Time.unscaledDeltaTime * stickScrollSpeed;
			}
			return (_active == Hand.Left) ? input.LeftTriggerValue : input.RightTriggerValue;
		}

		private void SwitchTo(Hand hand)
		{
			if (_active != hand)
			{
				if (_held)
				{
					ReleasePress(false);
				}
				_active = hand;
				_filterSeeded = false;
			}
		}

		private static Hand Other(Hand h)
		{
			return (h == Hand.Left) ? Hand.Right : Hand.Left;
		}

		private static InputDevice Device(VRInputController input, Hand h)
		{
			return (h == Hand.Left) ? input.LeftController : input.RightController;
		}

		private static bool Tracked(InputDevice device)
		{
			if (!device.isValid)
			{
				return false;
			}
			bool tracked;
			return !device.TryGetFeatureValue(CommonUsages.isTracked, out tracked) || tracked;
		}

		private bool TryAim(VRInputController input, Hand hand, out Ray ray)
		{
			Transform t = (hand == Hand.Left) ? rig.LeftHand : rig.RightHand;
			ray = default(Ray);
			if (t == null)
			{
				return false;
			}
			Quaternion rotation = t.rotation;
			Vector3 position = t.position;
			Quaternion aim;
			if (TryPointerOffset(Device(input, hand), out Vector3 offsetPosition, out Quaternion offsetRotation))
			{
				position += rotation * offsetPosition;
				aim = offsetRotation;
			}
			else
			{
				aim = Quaternion.Euler(fallbackAimEuler);
			}
			Vector3 direction = rotation * aim * Vector3.forward;
			ray = new Ray(position + direction * originForward, direction);
			return true;
		}

		private static bool TryPointerOffset(InputDevice device, out Vector3 position, out Quaternion rotation)
		{
			position = Vector3.zero;
			rotation = Quaternion.identity;
			if (!device.TryGetFeatureValue(CommonUsages.deviceRotation, out Quaternion gripRotation) || !device.TryGetFeatureValue(CommonUsages.devicePosition, out Vector3 gripPosition))
			{
				return false;
			}
			if (!device.TryGetFeatureValue(PointerRotationA, out Quaternion pointerRotation) && !device.TryGetFeatureValue(PointerRotationB, out pointerRotation))
			{
				return false;
			}
			if (!device.TryGetFeatureValue(PointerPositionA, out Vector3 pointerPosition) && !device.TryGetFeatureValue(PointerPositionB, out pointerPosition))
			{
				pointerPosition = gripPosition;
			}
			Quaternion inverse = Quaternion.Inverse(gripRotation);
			rotation = inverse * pointerRotation;
			position = inverse * (pointerPosition - gripPosition);
			return true;
		}

		private void Cast()
		{
			MenuSurface hit = null;
			Vector3 point = default(Vector3);
			if (_hasRay)
			{
				float best = maxDistance;
				if (_dragging && _pressSurface != null)
				{
					if (PlanePoint(_pressSurface, _ray, out point))
					{
						hit = _pressSurface;
					}
				}
				else
				{
					List<MenuSurface> all = MenuSurface.All;
					for (int i = 0; i < all.Count; i++)
					{
						if (all[i].TryHit(_ray, best, out Vector3 p, out float distance))
						{
							best = distance;
							hit = all[i];
							point = p;
						}
					}
				}
			}
			if (hit != _surface)
			{
				_filterSeeded = false;
			}
			if (hit != null)
			{
				_cursor = (rig.IsDesktop && !_scripted) ? point : Filter(point, Time.unscaledDeltaTime);
			}
			MenuInteractable item = null;
			MenuSurface modal = MenuSurface.Modal;
			if (hit != null && (modal == null || modal == hit))
			{
				item = hit.Pick(_cursor);
			}
			if (_dragging || (_held && _press != null && item != _press))
			{
				item = null;
			}
			SetHover(hit, item);
		}

		private static bool PlanePoint(MenuSurface surface, Ray ray, out Vector3 point)
		{
			RectTransform rt = surface.Rect;
			float denom = Vector3.Dot(ray.direction, rt.forward);
			point = default(Vector3);
			if (Mathf.Abs(denom) < 0.0001f)
			{
				return false;
			}
			float t = Vector3.Dot(rt.position - ray.origin, rt.forward) / denom;
			if (t <= 0f)
			{
				return false;
			}
			point = ray.GetPoint(t);
			return true;
		}

		private void SetHover(MenuSurface surface, MenuInteractable item)
		{
			if (surface != _surface)
			{
				if (_surface != null)
				{
					_surface.SetHovered(false);
				}
				_surface = surface;
				if (_surface != null)
				{
					_surface.SetHovered(true);
				}
			}
			if (item == _hover)
			{
				return;
			}
			if (_hover != null)
			{
				_hover.SetHover(false);
			}
			_hover = item;
			if (_hover == null)
			{
				return;
			}
			_hover.SetHover(true);
			if (_hover.GivesFeedback && !_held)
			{
				Pulse(hoverHaptic, 0.012f);
				if (hoverClip != null && Time.unscaledTime - _lastHoverSound > 0.06f)
				{
					_voice.PlayOneShot(hoverClip, hoverVolume);
					_lastHoverSound = Time.unscaledTime;
				}
			}
		}

		private void HandlePress(float trigger)
		{
			if (!_armed)
			{
				if (trigger < triggerDown - triggerHysteresis)
				{
					_armed = true;
				}
			}
			else if (_held)
			{
				if (trigger < triggerDown - triggerHysteresis)
				{
					ReleasePress(true);
				}
				else
				{
					HoldPress();
				}
			}
			else if (trigger >= triggerDown)
			{
				_held = true;
				BeginPress();
			}
		}

		private void BeginPress()
		{
			_press = null;
			_dragScroll = null;
			_pressSurface = _surface;
			_dragging = false;
			_pressOutside = false;
			MenuSurface modal = MenuSurface.Modal;
			if (modal != null && _surface != modal)
			{
				_pressOutside = true;
				return;
			}
			if (_surface == null)
			{
				return;
			}
			_pressLocal = Local(_surface.Rect, _cursor);
			_press = _hover;
			if (_press != null)
			{
				_press.SetPressed(true);
				if (_press.GivesFeedback)
				{
					Pulse(hoverHaptic * 1.5f, 0.015f);
				}
			}
			_dragScroll = ScrollFor(_press, _surface);
		}

		private void HoldPress()
		{
			if (_pressSurface == null || _dragScroll == null || !_dragScroll.CanScroll)
			{
				return;
			}
			if (!_dragging)
			{
				if (Mathf.Abs(Local(_pressSurface.Rect, _cursor).y - _pressLocal.y) < dragThreshold)
				{
					return;
				}
				if (!_dragScroll.Contains(_pressSurface.Rect.TransformPoint(_pressLocal)))
				{
					return;
				}
				_dragging = true;
				if (_press != null)
				{
					_press.SetPressed(false);
				}
				_press = null;
				_dragScroll.BeginDrag(Local(_dragScroll.Rect, _cursor).y);
			}
			_dragScroll.Drag(Local(_dragScroll.Rect, _cursor).y);
		}

		private void ReleasePress(bool allowClick)
		{
			_held = false;
			if (_pressOutside)
			{
				_pressOutside = false;
				if (allowClick && MenuSurface.Modal != null)
				{
					if (backClip != null)
					{
						_voice.PlayOneShot(backClip, clickVolume);
					}
					MenuSurface.Modal.RaiseClickedOutside();
				}
				return;
			}
			if (_dragging && _dragScroll != null)
			{
				_dragScroll.EndDrag();
			}
			else if (allowClick && _press != null && _press == _hover && _press.Interactable)
			{
				if (_press.GivesFeedback)
				{
					Pulse(clickHaptic, 0.03f);
					if (clickClip != null)
					{
						_voice.PlayOneShot(clickClip, clickVolume);
					}
				}
				_press.Click();
			}
			if (_press != null)
			{
				_press.SetPressed(false);
			}
			_press = null;
			_dragScroll = null;
			_dragging = false;
		}

		private void HandleScroll(float scroll)
		{
			if (Mathf.Approximately(scroll, 0f) || _surface == null || _dragging)
			{
				return;
			}
			MenuSurface modal = MenuSurface.Modal;
			if (modal != null && _surface != modal)
			{
				return;
			}
			MenuScroll target = ScrollFor(_hover, _surface);
			if (target != null)
			{
				target.Nudge(scroll);
			}
		}

		private static MenuScroll ScrollFor(MenuInteractable item, MenuSurface surface)
		{
			MenuScroll scroll = (item != null) ? item.GetComponentInParent<MenuScroll>() : null;
			if (scroll == null && surface != null)
			{
				scroll = surface.GetComponentInChildren<MenuScroll>();
			}
			return scroll;
		}

		private static Vector2 Local(RectTransform rt, Vector3 world)
		{
			return rt.InverseTransformPoint(world);
		}

		private Vector3 Filter(Vector3 x, float dt)
		{
			if (dt <= 0f || !_filterSeeded)
			{
				_filtered = x;
				_filterSeeded = true;
				_dFiltered = Vector3.zero;
				return x;
			}
			Vector3 dx = (x - _filtered) / dt;
			_dFiltered = Vector3.Lerp(_dFiltered, dx, Alpha(derivativeCutoff, dt));
			float cutoff = minCutoff + beta * _dFiltered.magnitude;
			_filtered = Vector3.Lerp(_filtered, x, Alpha(cutoff, dt));
			return _filtered;
		}

		private static float Alpha(float cutoff, float dt)
		{
			float tau = 1f / (2f * Mathf.PI * cutoff);
			return 1f / (1f + tau / dt);
		}

		private void Pulse(float amplitude, float duration)
		{
			VRInputController input = VRInputController.Instance;
			if (input == null || amplitude <= 0f || rig.IsDesktop)
			{
				return;
			}
			if (_active == Hand.Left)
			{
				input.PulseLeft(amplitude, duration);
			}
			else
			{
				input.PulseRight(amplitude, duration);
			}
		}

		private void BuildVisuals()
		{
			GameObject beam = new GameObject("Beam");
			beam.transform.SetParent(transform, false);
			_beam = beam.AddComponent<LineRenderer>();
			_beam.useWorldSpace = true;
			_beam.alignment = LineAlignment.View;
			_beam.textureMode = LineTextureMode.Stretch;
			_beam.numCapVertices = 0;
			_beam.widthMultiplier = beamWidth;
			_beam.sharedMaterial = beamMaterial;
			_beam.shadowCastingMode = ShadowCastingMode.Off;
			_beam.receiveShadows = false;
			_beam.sortingOrder = 99;
			_beam.enabled = false;
			Mesh quad = BuildQuad();
			_cursorT = BuildMarker("Cursor", quad, out _cursorR);
			_originT = BuildMarker("Origin", quad, out _originR);
		}

		private Transform BuildMarker(string name, Mesh quad, out MeshRenderer renderer)
		{
			GameObject marker = new GameObject(name);
			marker.transform.SetParent(transform, false);
			marker.AddComponent<MeshFilter>().sharedMesh = quad;
			renderer = marker.AddComponent<MeshRenderer>();
			renderer.sharedMaterial = cursorMaterial;
			renderer.shadowCastingMode = ShadowCastingMode.Off;
			renderer.receiveShadows = false;
			renderer.sortingOrder = 100;
			renderer.enabled = false;
			return marker.transform;
		}

		private static Mesh BuildQuad()
		{
			Mesh mesh = new Mesh();
			mesh.name = "MenuPointerQuad";
			mesh.hideFlags = HideFlags.DontSave;
			mesh.vertices = new Vector3[4]
			{
				new Vector3(-0.5f, -0.5f, 0f),
				new Vector3(-0.5f, 0.5f, 0f),
				new Vector3(0.5f, 0.5f, 0f),
				new Vector3(0.5f, -0.5f, 0f)
			};
			mesh.uv = new Vector2[4]
			{
				new Vector2(0f, 0f),
				new Vector2(0f, 1f),
				new Vector2(1f, 1f),
				new Vector2(1f, 0f)
			};
			mesh.triangles = new int[6] { 0, 1, 2, 2, 3, 0 };
			mesh.RecalculateBounds();
			return mesh;
		}

		private void DrawVisuals()
		{
			float dt = Time.unscaledDeltaTime;
			bool onSurface = _surface != null;
			_visible = Mathf.MoveTowards(_visible, _hasRay ? 1f : 0f, 8f * dt);
			_pressVisual = Mathf.MoveTowards(_pressVisual, _held ? 1f : 0f, 12f * dt);
			Transform head = (rig.Head != null) ? rig.Head.transform : null;
			if (onSurface)
			{
				_cursorR.enabled = _visible > 0.01f;
				if (_visible > 0.01f)
				{
					Vector3 normal = _surface.Rect.forward;
					float distance = (head != null) ? Vector3.Distance(head.position, _cursor) : 2f;
					float size = Mathf.Tan(cursorDegrees * 0.5f * Mathf.Deg2Rad);
					_cursorT.SetPositionAndRotation(_cursor - normal * 0.004f, _surface.Rect.rotation);
					_cursorT.localScale = Vector3.one * (2f * distance * size);
					bool live = _hover != null && _hover.GivesFeedback;
					_cursorR.GetPropertyBlock(_block);
					_block.SetFloat(RingId, Mathf.Lerp(0.72f, 0.5f, _pressVisual));
					_block.SetFloat(RingWidthId, live ? 0.16f : 0.12f);
					_block.SetFloat(DotRadiusId, Mathf.Lerp(0.2f, 0.28f, _pressVisual));
					_block.SetColor(ColorId, new Color(1f, 1f, 1f, (live ? 1f : 0.7f) * _visible));
					_cursorR.SetPropertyBlock(_block);
				}
			}
			else
			{
				_cursorR.enabled = false;
			}
			if ((!rig.IsDesktop || _scripted) && _hasRay && _visible > 0.01f)
			{
				_beam.enabled = true;
				int segments = Mathf.Min(beamSegments, _points.Length - 1);
				Vector3 origin = _ray.origin;
				Color color = beamColor;
				if (onSurface)
				{
					Vector3 end = _cursor;
					float handle = Vector3.Distance(origin, end) * bendHandle;
					Vector3 control = origin + _ray.direction * handle;
					for (int i = 0; i <= segments; i++)
					{
						float t = (float)i / (float)segments;
						float u = 1f - t;
						_points[i] = u * u * origin + 2f * u * t * control + t * t * end;
					}
					_beam.positionCount = segments + 1;
					_beam.SetPositions(_points);
					_beam.startColor = new Color(color.r, color.g, color.b, _visible * 0.05f);
					_beam.endColor = new Color(color.r, color.g, color.b, Mathf.Lerp(0.55f, 0.9f, _pressVisual) * _visible);
				}
				else
				{
					_points[0] = origin;
					_points[1] = origin + _ray.direction * stubLength;
					_beam.positionCount = 2;
					_beam.SetPositions(_points);
					_beam.startColor = new Color(color.r, color.g, color.b, stubAlpha * _visible);
					_beam.endColor = new Color(color.r, color.g, color.b, 0f);
				}
				_originR.enabled = true;
				Vector3 facing = (head != null) ? (origin - head.position) : _ray.direction;
				if (facing.sqrMagnitude <= 1E-06f)
				{
					facing = Vector3.forward;
				}
				_originT.SetPositionAndRotation(origin, Quaternion.LookRotation(facing, Vector3.up));
				_originT.localScale = Vector3.one * originDotSize;
				_originR.GetPropertyBlock(_block);
				_block.SetFloat(RingId, 0.7f);
				_block.SetFloat(RingWidthId, 0f);
				_block.SetFloat(DotRadiusId, 0.85f);
				_block.SetColor(ColorId, new Color(1f, 1f, 1f, _visible * 0.85f));
				_originR.SetPropertyBlock(_block);
			}
			else
			{
				_beam.enabled = false;
				_originR.enabled = false;
			}
		}
	}
}
