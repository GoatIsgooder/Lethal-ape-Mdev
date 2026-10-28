using System;

namespace UImGui.VR
{
    [Serializable]
    public class VRConfiguration
    {
        public HandCursorMode handCursorMode = HandCursorMode.Right;
        public ImguiVRManipulator vrManipulator;
        public WorldSpaceTransformerConfig worldSpaceConfig;
    }
}