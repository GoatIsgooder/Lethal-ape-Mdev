using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;
using UnityEngine.XR.Management;
using CommonUsages = UnityEngine.XR.CommonUsages;
using InputDevice = UnityEngine.XR.InputDevice;

namespace LethalApeR.Frontend
{
	[DefaultExecutionOrder(-50)]
	public sealed class MenuRig : MonoBehaviour
	{
		[SerializeField]
		private Camera headCamera;

		[SerializeField]
		private Transform cameraOffset;

		[SerializeField]
		private Transform leftHand;

		[SerializeField]
		private Transform rightHand;

		[Tooltip("Pose drivers on the head and hands. Turned off on desktop.")]
		[SerializeField]
		private Behaviour[] trackingDrivers;

		[Tooltip("Eye height used on desktop, and when the runtime refuses floor-level tracking.")]
		[SerializeField]
		private float fallbackEyeHeight = 1.6f;

		[Header("Desktop")]
		[SerializeField]
		private float lookDegreesPerPixel = 0.15f;

		[SerializeField]
		private float desktopFieldOfView = 70f;

		private const float HeadsetGraceSeconds = 4f;

		private const float HeadsetLostSeconds = 0.5f;

		private static readonly List<XRInputSubsystem> Subsystems = new List<XRInputSubsystem>();

		private readonly List<XRInputSubsystem> _subscribed = new List<XRInputSubsystem>();

		private bool _originConfigured;

		private float _yaw;

		private float _pitch;

		private float _awaitHeadsetUntil;

		private float _inactiveSince = -1f;

		public Camera Head => headCamera;

		public Transform LeftHand => leftHand;

		public Transform RightHand => rightHand;

		public bool IsDesktop { get; private set; }

		public bool HeadTracked
		{
			get
			{
				bool tracked = false;
				if (IsDesktop)
				{
					return true;
				}
				InputDevice device = InputDevices.GetDeviceAtXRNode(XRNode.Head);
				if (!device.isValid)
				{
					return false;
				}
				return !device.TryGetFeatureValue(CommonUsages.isTracked, out tracked) || tracked;
			}
		}

		public bool AwaitingHeadset => IsDesktop && Time.unscaledTime < _awaitHeadsetUntil;

		public event Action Recentered;

		public event Action ModeChanged;

		private void Awake()
		{
			if (XRSettings.isDeviceActive)
			{
				return;
			}
			if (HeadsetRuntimeLoaded())
			{
				_awaitHeadsetUntil = Time.unscaledTime + HeadsetGraceSeconds;
			}
			EnterDesktop();
		}

		private static bool HeadsetRuntimeLoaded()
		{
			XRGeneralSettings instance = XRGeneralSettings.Instance;
			if (instance != null && instance.Manager != null)
			{
				return instance.Manager.activeLoader != null;
			}
			return false;
		}

		private void EnterDesktop()
		{
			bool wasDesktop = IsDesktop;
			IsDesktop = true;
			_inactiveSince = -1f;
			SetDrivers(false);
			cameraOffset.localPosition = Vector3.up * fallbackEyeHeight;
			headCamera.transform.localPosition = Vector3.zero;
			headCamera.transform.localRotation = Quaternion.identity;
			headCamera.fieldOfView = desktopFieldOfView;
			_yaw = 0f;
			_pitch = 0f;
			if (!wasDesktop)
			{
				ModeChanged?.Invoke();
				Recentered?.Invoke();
			}
		}

		private void EnterVr()
		{
			IsDesktop = false;
			_originConfigured = false;
			_awaitHeadsetUntil = 0f;
			_inactiveSince = -1f;
			SetDrivers(true);
			Debug.Log(string.Format("[MenuRig] Headset active {0:0.00}s in: menu switched from desktop to VR.", Time.unscaledTime));
			ModeChanged?.Invoke();
			Recentered?.Invoke();
		}

		private void SetDrivers(bool on)
		{
			if (trackingDrivers == null)
			{
				return;
			}
			for (int i = 0; i < trackingDrivers.Length; i++)
			{
				Behaviour behaviour = trackingDrivers[i];
				if (behaviour != null)
				{
					behaviour.enabled = on;
				}
			}
		}

		private void OnDestroy()
		{
			foreach (XRInputSubsystem item in _subscribed)
			{
				item.trackingOriginUpdated -= OnOriginUpdated;
			}
			_subscribed.Clear();
		}

		private void Update()
		{
			bool isDeviceActive = XRSettings.isDeviceActive;
			if (isDeviceActive && IsDesktop)
			{
				EnterVr();
			}
			else if (!IsDesktop)
			{
				if (isDeviceActive)
				{
					_inactiveSince = -1f;
				}
				else
				{
					float unscaledTime = Time.unscaledTime;
					if (_inactiveSince < 0f)
					{
						_inactiveSince = unscaledTime;
					}
					else if (unscaledTime - _inactiveSince >= HeadsetLostSeconds)
					{
						EnterDesktop();
					}
				}
			}
			if (IsDesktop)
			{
				DesktopLook();
			}
			else if (!_originConfigured)
			{
				ConfigureOrigin();
			}
		}

		private void ConfigureOrigin()
		{
			SubsystemManager.GetSubsystems(Subsystems);
			if (Subsystems.Count == 0)
			{
				return;
			}
			bool floor = false;
			foreach (XRInputSubsystem subsystem in Subsystems)
			{
				if (subsystem.running)
				{
					subsystem.TrySetTrackingOriginMode(TrackingOriginModeFlags.Floor);
					floor |= subsystem.GetTrackingOriginMode() == TrackingOriginModeFlags.Floor;
					if (!_subscribed.Contains(subsystem))
					{
						subsystem.trackingOriginUpdated += OnOriginUpdated;
						_subscribed.Add(subsystem);
					}
				}
			}
			if (_subscribed.Count != 0)
			{
				cameraOffset.localPosition = (floor ? Vector3.zero : (Vector3.up * fallbackEyeHeight));
				_originConfigured = true;
			}
		}

		private void OnOriginUpdated(XRInputSubsystem subsystem)
		{
			Recentered?.Invoke();
		}

		public bool TryMouseRay(out Ray ray)
		{
			ray = default(Ray);
			if (!IsDesktop)
			{
				return false;
			}
			Mouse current = Mouse.current;
			if (current == null)
			{
				return false;
			}
			if (headCamera == null)
			{
				return false;
			}
			ray = headCamera.ScreenPointToRay(current.position.ReadValue());
			return true;
		}

		private void DesktopLook()
		{
			Mouse current = Mouse.current;
			if (current != null && current.rightButton.isPressed)
			{
				Vector2 delta = current.delta.ReadValue();
				_yaw += delta.x * lookDegreesPerPixel;
				_pitch = Mathf.Clamp(_pitch - delta.y * lookDegreesPerPixel, -80f, 80f);
				headCamera.transform.localRotation = Quaternion.Euler(_pitch, _yaw, 0f);
			}
		}
	}
}
