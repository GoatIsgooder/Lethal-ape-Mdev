using System.Collections.Generic;
using System.Reflection;
using LALocomotion;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmRayPointer : MonoBehaviour
	{
		private sealed class Hand
		{
			public XRNode node;

			public GrabInteractor grab;

			public LAGrabber la;

			public bool hasPointerOffset;

			public Quaternion pointerRot = Quaternion.identity;

			public Vector3 pointerPos;

			public IBtmRayTarget target;

			public Vector3 raw;

			public float distance;

			public bool pressed;

			public Transform Source
			{
				get
				{
					if (la != null)
					{
						return la.transform;
					}
					if (grab != null)
					{
						return grab.transform;
					}
					return null;
				}
			}

			public bool Holding
			{
				get
				{
					if (la != null)
					{
						if (!(la.Held != null))
						{
							return la.Supporting != null;
						}
						return true;
					}
					if (grab != null)
					{
						return grab.IsGrabbing;
					}
					return false;
				}
			}
		}

		private static readonly List<IBtmRayTarget> Targets = new List<IBtmRayTarget>();

		private static int _suppressedFrame = -10;

		[Header("Aim")]
		[SerializeField]
		private float maxDistance = 4.5f;

		[Tooltip("Used only when the device has no pointer pose: extra rotation from the controller's grip pose to where it points.")]
		[SerializeField]
		private Vector3 fallbackAimEuler = new Vector3(35f, 0f, 0f);

		[SerializeField]
		private float originForward = 0.06f;

		[Header("Smoothing (One Euro)")]
		[SerializeField]
		private float minCutoff = 1.4f;

		[SerializeField]
		private float beta = 6f;

		[SerializeField]
		private float derivativeCutoff = 1.2f;

		[Header("Beam")]
		[SerializeField]
		private Material beamMaterial;

		[SerializeField]
		private Color beamColor = new Color(0.55f, 0.75f, 1f, 1f);

		[SerializeField]
		private float beamWidth = 0.004f;

		[SerializeField]
		[Range(4f, 48f)]
		private int beamSegments = 24;

		[Tooltip("How far along the aim the curve's control point sits (fraction of the hit distance).")]
		[SerializeField]
		[Range(0.1f, 0.9f)]
		private float bendHandle = 0.55f;

		[SerializeField]
		private float fadeSpeed = 7f;

		[Header("Input")]
		[SerializeField]
		[Range(0.3f, 1f)]
		private float triggerDown = 0.7f;

		[SerializeField]
		[Range(0f, 0.3f)]
		private float triggerHysteresis = 0.15f;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverHaptic = 0.12f;

		[SerializeField]
		[Range(0f, 1f)]
		private float clickHaptic = 0.35f;

		[SerializeField]
		private AudioClip clickClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float clickVolume = 0.4f;

		private readonly Hand[] _hands = new Hand[2]
		{
			new Hand
			{
				node = XRNode.LeftHand
			},
			new Hand
			{
				node = XRNode.RightHand
			}
		};

		private Hand _active;

		private IBtmRayTarget _hovered;

		private LineRenderer _beam;

		private readonly Vector3[] _points = new Vector3[48];

		private float _alpha;

		private float _nextHandScan;

		private AudioSource _voice;

		private Vector3 _filtered;

		private Vector3 _dFiltered;

		private bool _filterSeeded;

		private Vector3 _cursor;

		private static readonly InputFeatureUsage<Quaternion> PointerRotationA = new InputFeatureUsage<Quaternion>("PointerRotation");

		private static readonly InputFeatureUsage<Quaternion> PointerRotationB = new InputFeatureUsage<Quaternion>("pointerRotation");

		private static readonly InputFeatureUsage<Vector3> PointerPositionA = new InputFeatureUsage<Vector3>("PointerPosition");

		private static readonly InputFeatureUsage<Vector3> PointerPositionB = new InputFeatureUsage<Vector3>("pointerPosition");

		private static bool Suppressed
		{
			get
			{
				int frames = Time.frameCount - _suppressedFrame;
				if (frames >= 0)
				{
					return frames < 2;
				}
				return false;
			}
		}

		public static void Register(IBtmRayTarget target)
		{
			if (!Targets.Contains(target))
			{
				Targets.Add(target);
			}
		}

		public static void Unregister(IBtmRayTarget target)
		{
			Targets.Remove(target);
		}

		public static void SuppressThisFrame()
		{
			_suppressedFrame = Time.frameCount;
		}

		public static bool TryCast(Ray ray, float maxDistance, out IBtmRayTarget target, out Vector3 point, out float distance)
		{
			target = null;
			point = default(Vector3);
			distance = maxDistance;
			foreach (IBtmRayTarget t in Targets)
			{
				if (t != null && t.RayEnabled && t.TryHit(ray, distance, out var hitPoint, out var hitDistance))
				{
					target = t;
					point = hitPoint;
					distance = hitDistance;
				}
			}
			return target != null;
		}

		private void Awake()
		{
			GameObject beamObject = new GameObject("RayBeam");
			beamObject.transform.SetParent(base.transform, worldPositionStays: false);
			_beam = beamObject.AddComponent<LineRenderer>();
			_beam.useWorldSpace = true;
			_beam.positionCount = beamSegments + 1;
			_beam.widthMultiplier = beamWidth;
			_beam.textureMode = LineTextureMode.Tile;
			_beam.alignment = LineAlignment.View;
			_beam.numCapVertices = 2;
			_beam.material = beamMaterial;
			_beam.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			_beam.receiveShadows = false;
			_beam.enabled = false;
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
		}

		private void OnDisable()
		{
			if (_hovered != null)
			{
				_hovered.OnRayExit();
			}
			_hovered = null;
			_active = null;
			if (_beam != null)
			{
				_beam.enabled = false;
			}
		}

		private void Update()
		{
			if (Suppressed)
			{
				if (_hovered != null)
				{
					_hovered.OnRayExit();
				}
				_hovered = null;
				_active = null;
				_alpha = 0f;
				if (_beam != null && _beam.enabled)
				{
					_beam.enabled = false;
				}
				return;
			}
			ResolveHands();
			VRInputController instance = VRInputController.Instance;
			Hand[] hands = _hands;
			foreach (Hand h in hands)
			{
				Cast(h);
			}
			if (_active == null || _active.target == null)
			{
				_active = null;
				hands = _hands;
				foreach (Hand h2 in hands)
				{
					if (h2.target != null && (_active == null || h2.pressed))
					{
						_active = h2;
					}
				}
				_filterSeeded = false;
			}
			hands = _hands;
			foreach (Hand h3 in hands)
			{
				if (h3 != _active && h3.target != null && instance != null && Trigger(h3, instance) >= triggerDown)
				{
					_active = h3;
					_filterSeeded = false;
				}
			}
			IBtmRayTarget target = ((_active != null) ? _active.target : null);
			if (target != _hovered)
			{
				if (_hovered != null)
				{
					_hovered.OnRayExit();
				}
				_hovered = target;
			}
			if (target != null && _active != null)
			{
				_cursor = Filter(_active.raw, Time.deltaTime);
				if (target.OnRayHover(_cursor))
				{
					Pulse(_active, hoverHaptic, 0.012f);
				}
				float value = ((instance != null) ? Trigger(_active, instance) : 0f);
				if (_active.pressed)
				{
					if (value < triggerDown - triggerHysteresis)
					{
						_active.pressed = false;
						target.OnRayPress(pressed: false);
					}
				}
				else if (value >= triggerDown)
				{
					_active.pressed = true;
					target.OnRayPress(pressed: true);
					target.OnRayClick(_cursor);
					Pulse(_active, clickHaptic, 0.03f);
					if (clickClip != null)
					{
						_voice.PlayOneShot(clickClip, clickVolume);
					}
				}
			}
			DrawBeam();
		}

		private void Cast(Hand h)
		{
			h.target = null;
			if (!(h.Source == null) && !h.Holding && Targets.Count != 0)
			{
				if (TryCast(AimRay(h), maxDistance, out var target, out var point, out var distance))
				{
					h.target = target;
					h.raw = point;
					h.distance = distance;
				}
				if (h.target == null)
				{
					h.pressed = false;
				}
			}
		}

		private Ray AimRay(Hand h)
		{
			Transform source = h.Source;
			Quaternion rotation = source.rotation;
			Vector3 position = source.position;
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				h.hasPointerOffset = TryPointerOffset((h.node == XRNode.LeftHand) ? instance.LeftController : instance.RightController, h);
			}
			Quaternion offset;
			if (h.hasPointerOffset)
			{
				position += rotation * h.pointerPos;
				offset = h.pointerRot;
			}
			else
			{
				offset = Quaternion.Euler(fallbackAimEuler);
			}
			Vector3 direction = rotation * offset * Vector3.forward;
			return new Ray(position + direction * originForward, direction);
		}

		private static bool TryPointerOffset(InputDevice device, Hand h)
		{
			if (!device.isValid)
			{
				return false;
			}
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
			h.pointerRot = inverse * pointerRotation;
			h.pointerPos = inverse * (pointerPosition - gripPosition);
			return true;
		}

		private Vector3 Filter(Vector3 x, float dt)
		{
			if (dt <= 0f || !_filterSeeded)
			{
				_filtered = x;
				_dFiltered = Vector3.zero;
				_filterSeeded = true;
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

		private void DrawBeam()
		{
			bool visible = _active != null && _active.target != null;
			_alpha = Mathf.MoveTowards(_alpha, visible ? 1f : 0f, fadeSpeed * Time.deltaTime);
			if (_beam == null)
			{
				return;
			}
			if (_alpha <= 0.001f || _active == null)
			{
				if (_beam.enabled)
				{
					_beam.enabled = false;
				}
				return;
			}
			if (!_beam.enabled)
			{
				_beam.enabled = true;
			}
			Ray ray = AimRay(_active);
			Vector3 origin = ray.origin;
			Vector3 cursor = _cursor;
			Vector3 control = origin + ray.direction * (Vector3.Distance(origin, cursor) * bendHandle);
			int segments = Mathf.Min(beamSegments, _points.Length - 1);
			for (int i = 0; i <= segments; i++)
			{
				float t = (float)i / (float)segments;
				float u = 1f - t;
				_points[i] = origin * (u * u) + control * (2f * u * t) + cursor * (t * t);
			}
			_beam.positionCount = segments + 1;
			_beam.SetPositions(_points);
			float pressScale = (_active.pressed ? 1f : 0.75f);
			_beam.startColor = new Color(beamColor.r, beamColor.g, beamColor.b, 0f);
			_beam.endColor = new Color(beamColor.r, beamColor.g, beamColor.b, _alpha * pressScale);
		}

		private void ResolveHands()
		{
			if (Time.time < _nextHandScan && _hands[0].Source != null && _hands[1].Source != null)
			{
				return;
			}
			_nextHandScan = Time.time + 2f;
			Hand[] hands = _hands;
			foreach (Hand h in hands)
			{
				h.la = null;
				h.grab = null;
			}
			LAGrabber[] grabbers = Object.FindObjectsByType<LAGrabber>(FindObjectsSortMode.None);
			foreach (LAGrabber grabber in grabbers)
			{
				if (grabber.isActiveAndEnabled)
				{
					_hands[(!grabber.isLeft) ? 1 : 0].la = grabber;
				}
			}
			GrabInteractor[] interactors = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			foreach (GrabInteractor interactor in interactors)
			{
				hands = _hands;
				foreach (Hand h2 in hands)
				{
					if (interactor.node == h2.node && (h2.grab == null || interactor.isActiveAndEnabled))
					{
						h2.grab = interactor;
					}
				}
			}
		}

		private static float Trigger(Hand h, VRInputController input)
		{
			if (h.node != XRNode.LeftHand)
			{
				return input.RightTriggerValue;
			}
			return input.LeftTriggerValue;
		}

		private static void Pulse(Hand h, float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(amplitude <= 0f) && !(instance == null))
			{
				if (h.node == XRNode.LeftHand)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}
	}
}
