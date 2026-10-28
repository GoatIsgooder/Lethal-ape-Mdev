using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

namespace UImGui.VR
{
    public class VirtualXRInput
    {
        private readonly HandCursorMode _handCursorMode;
        private readonly List<InputDevice> _devices = new List<InputDevice>();

        private InputDevice _leftController;
        private InputDevice _rightController;

        public HandCursorMode HandCursorMode => _handCursorMode;

        // Cursor (pointer) hand and navigation hand are always opposite controllers.
        private OVRInput.Controller CursorController =>
            IsCursorLeftHand ? OVRInput.Controller.LTouch : OVRInput.Controller.RTouch;

        private OVRInput.Controller NavController =>
            IsNavLeftHand ? OVRInput.Controller.LTouch : OVRInput.Controller.RTouch;

        private bool IsCursorLeftHand => _handCursorMode == HandCursorMode.Left;
        private bool IsNavLeftHand => _handCursorMode != HandCursorMode.Left;

        public VirtualXRInput(HandCursorMode handCursorMode)
        {
            _handCursorMode = handCursorMode;
        }

        private static bool IsOvrControllerConnected(OVRInput.Controller controller)
        {
            return OVRInput.IsControllerConnected(controller);
        }

        private void RefreshXRControllersIfNeeded()
        {
            if (!_leftController.isValid || !_rightController.isValid)
            {
                _leftController = GetXRController(true);
                _rightController = GetXRController(false);
            }
        }

        private InputDevice GetXRController(bool isLeft)
        {
            _devices.Clear();

            var characteristics = isLeft
                ? InputDeviceCharacteristics.HeldInHand | InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Left
                : InputDeviceCharacteristics.HeldInHand | InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Right;
            InputDevices.GetDevicesWithCharacteristics(characteristics, _devices);

            if (_devices.Count > 0)
                return _devices[0];

            return InputDevices.GetDeviceAtXRNode(isLeft ? XRNode.LeftHand : XRNode.RightHand);
        }

        private InputDevice GetCursorDevice()
        {
            RefreshXRControllersIfNeeded();
            return IsCursorLeftHand ? _leftController : _rightController;
        }

        private InputDevice GetNavDevice()
        {
            RefreshXRControllersIfNeeded();
            return IsNavLeftHand ? _leftController : _rightController;
        }

        private Vector3 GetControllerPositionFromXR(bool isLeft)
        {
            RefreshXRControllersIfNeeded();
            var device = isLeft ? _leftController : _rightController;
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.devicePosition, out Vector3 position))
                return position;

            return Vector3.zero;
        }

        private Quaternion GetControllerRotationFromXR(bool isLeft)
        {
            RefreshXRControllersIfNeeded();
            var device = isLeft ? _leftController : _rightController;
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.deviceRotation, out Quaternion rotation))
                return rotation;

            return Quaternion.identity;
        }

        public Vector3 GetCursorPosition()
        {
            if (IsOvrControllerConnected(CursorController))
                return OVRInput.GetLocalControllerPosition(CursorController);

            return GetControllerPositionFromXR(IsCursorLeftHand);
        }

        public Quaternion GetCursorRotation()
        {
            if (IsOvrControllerConnected(CursorController))
                return OVRInput.GetLocalControllerRotation(CursorController);

            return GetControllerRotationFromXR(IsCursorLeftHand);
        }

        public bool IsPressButtonPressed()
        {
            if (IsOvrControllerConnected(CursorController))
                return OVRInput.Get(OVRInput.Axis1D.PrimaryIndexTrigger, CursorController) > 0.5f;

            var device = GetCursorDevice();
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.triggerButton, out bool pressed))
                return pressed;
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.trigger, out float value))
                return value > 0.5f;

            return false;
        }

        public bool IsSecondaryPressButtonPressed()
        {
            if (IsOvrControllerConnected(CursorController))
                return OVRInput.Get(OVRInput.Axis1D.PrimaryHandTrigger, CursorController) > 0.5f;

            var device = GetCursorDevice();
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.gripButton, out bool pressed))
                return pressed;
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.grip, out float value))
                return value > 0.5f;

            return false;
        }

        public Vector2 GetScroll()
        {
            if (IsOvrControllerConnected(CursorController))
                return OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick, CursorController);

            var device = GetCursorDevice();
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.primary2DAxis, out Vector2 axis))
                return axis;

            return Vector2.zero;
        }

        public bool IsPrimaryButtonPressed()
        {
            if (IsOvrControllerConnected(NavController))
                return OVRInput.Get(OVRInput.Button.One, NavController);

            var device = GetNavDevice();
            return device.isValid && device.TryGetFeatureValue(CommonUsages.primaryButton, out bool pressed) && pressed;
        }

        public float GetPrimaryButtonValue()
        {
            return IsPrimaryButtonPressed() ? 1f : 0f;
        }

        public bool IsSecondaryButtonPressed()
        {
            if (IsOvrControllerConnected(NavController))
                return OVRInput.Get(OVRInput.Button.Two, NavController);

            var device = GetNavDevice();
            return device.isValid && device.TryGetFeatureValue(CommonUsages.secondaryButton, out bool pressed) && pressed;
        }

        public float GetSecondaryButtonValue()
        {
            return IsSecondaryButtonPressed() ? 1f : 0f;
        }

        public Vector2 GetThumbstick()
        {
            if (IsOvrControllerConnected(NavController))
                return OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick, NavController);

            var device = GetNavDevice();
            if (device.isValid && device.TryGetFeatureValue(CommonUsages.primary2DAxis, out Vector2 axis))
                return axis;

            return Vector2.zero;
        }
    }
}
