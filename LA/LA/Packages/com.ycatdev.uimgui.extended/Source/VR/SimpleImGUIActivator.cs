using System.Collections;
using UImGui.Platform;
using UImGui.Renderer;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.XR;

namespace UImGui
{
    public class SimpleImGUIActivator : MonoBehaviour
    {
        [SerializeField] private UImGui uImGui;
        [SerializeField] private InputActionProperty editorActivationButton;
        [SerializeField] private float holdDuration;
        private float _time;
        private bool _togglePending;

        private void LateUpdate()
        {
            // Thumbstick click on either controller: OVR first, XR InputDevices as fallback.
            var isVRButtonPressed = OVRInput.Get(OVRInput.Button.PrimaryThumbstick, OVRInput.Controller.LTouch)
                                    || OVRInput.Get(OVRInput.Button.PrimaryThumbstick, OVRInput.Controller.RTouch);

            if (!isVRButtonPressed)
            {
                var leftDevice = InputDevices.GetDeviceAtXRNode(XRNode.LeftHand);
                var rightDevice = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);

                var leftPressed = leftDevice.isValid &&
                                  leftDevice.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primary2DAxisClick, out bool leftClick) &&
                                  leftClick;
                var rightPressed = rightDevice.isValid &&
                                   rightDevice.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primary2DAxisClick, out bool rightClick) &&
                                   rightClick;

                isVRButtonPressed = leftPressed || rightPressed;
            }

            if (isVRButtonPressed)
            {
                if (_time - Time.unscaledTime < 0)
                {
                    ToggleDeferred(true);
                    _time = Time.unscaledTime + holdDuration + 1f;
                }
            }
            else
            {
                _time = Time.unscaledTime + holdDuration;
            }
        }

        private void ToggleDeferred(bool vr)
        {
            if (_togglePending)
                return;

            _togglePending = true;
            StartCoroutine(ToggleAtEndOfFrame(vr));
        }

        private IEnumerator ToggleAtEndOfFrame(bool vr)
        {
            yield return new WaitForEndOfFrame();

            // The shipped build only ever opens the window here; it never disables it.
            if (uImGui != null && !uImGui.enabled)
            {
                uImGui.RendererType = vr ? RenderType.VRMesh : RenderType.Mesh;
                uImGui.PlatformType = vr ? InputType.VRInput : InputType.InputSystem;
                uImGui.enabled = true;
            }

            _togglePending = false;
        }
    }
}
