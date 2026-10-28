using System;
using UnityEngine;

namespace UImGui.VR
{
    [Serializable]
    public class WorldSpaceTransformerConfig
    {
        public ControllerInputMode controllerInputMode = ControllerInputMode.CalculateFromInputSystem;

        public Transform rightControllerMirrorTransform;
        public Transform leftControllerMirrorTransform;

        public Transform trackingSpace;
        public Camera camera;

        // When set, the panel is anchored to this transform instead of floating in front of the camera.
        public Transform panelFollowTransform;
        public bool usePanelFollowTransformRotation;
        public Vector3 panelFollowPositionOffset = Vector3.zero;
        public Vector3 panelFollowRotationOffsetEuler = Vector3.zero;

        // Extra rotation applied to the controller pose before casting the pointer ray.
        public Vector3 pointerRotationOffsetEuler = Vector3.zero;

        public float cursorSmoothTime = 0.1f;
        // Values <= 0 fall back to the pixel-perfect distance computed from the camera FOV.
        public float distanceFromCamera = 1.25f;
        public Vector3 panelOffsetFromHead = new Vector3(0f, -0.2f, 0f);
        public float minDistanceFromCamera = 1f;
        public float maxDistanceFromCamera = 3.5f;
        public float followingSpeed = 7f;
        public float lookAngleThresholdToFollow = 25f;
        public float pixelsPerUnit = 1000f;
    }
}