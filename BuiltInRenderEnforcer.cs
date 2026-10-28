using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.Rendering;
using UImGuiBehaviour = UImGui.UImGui;

namespace UImGui.Renderer
{
	// The package only executes ImGui's draw commands from a URP renderer feature (RenderImGui) or an HDRP pass, so on
	// the built-in (standard) render pipeline every window is built but never drawn. This enforces a built-in path:
	// each UImGui camera gets a command buffer that is refilled every frame from that instance's draw commands.
	[DefaultExecutionOrder(10000)]
	internal sealed class BuiltInRenderEnforcer : MonoBehaviour
	{
		private struct Attached
		{
			public Camera Camera;
			public CameraEvent Event;
			public CommandBuffer Buffer;
		}

		private const float RescanSeconds = 0.5f;

		private static readonly FieldInfo CameraField = typeof(UImGuiBehaviour).GetField("_camera", BindingFlags.Instance | BindingFlags.NonPublic);
		private static readonly FieldInfo ContextField = typeof(UImGuiBehaviour).GetField("_context", BindingFlags.Instance | BindingFlags.NonPublic);

		private readonly Dictionary<UImGuiBehaviour, Attached> _attached = new Dictionary<UImGuiBehaviour, Attached>();
		private readonly List<UImGuiBehaviour> _stale = new List<UImGuiBehaviour>();
		private UImGuiBehaviour[] _instances = new UImGuiBehaviour[0];
		private float _nextScan;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Install()
		{
			if (GraphicsSettings.currentRenderPipeline != null)
			{
				return;
			}
			GameObject go = new GameObject("UImGui Built-in Renderer");
			go.hideFlags = HideFlags.HideAndDontSave;
			DontDestroyOnLoad(go);
			go.AddComponent<BuiltInRenderEnforcer>();
		}

		private void LateUpdate()
		{
			if (GraphicsSettings.currentRenderPipeline != null)
			{
				DetachAll();
				return;
			}
			if (Time.unscaledTime >= _nextScan)
			{
				_nextScan = Time.unscaledTime + RescanSeconds;
				_instances = FindObjectsByType<UImGuiBehaviour>(FindObjectsSortMode.None);
			}
			for (int i = 0; i < _instances.Length; i++)
			{
				UImGuiBehaviour imgui = _instances[i];
				if (imgui == null || !imgui.isActiveAndEnabled)
				{
					continue;
				}
				Camera camera = CameraField.GetValue(imgui) as Camera;
				Context context = ContextField.GetValue(imgui) as Context;
				if (camera == null || context == null || context.DrawCommands == null)
				{
					continue;
				}
				// World-space VR panels draw with the scene so they depth-test; the flat overlay goes on top of everything.
				CameraEvent evt = imgui.RendererType == RenderType.VRMesh ? CameraEvent.AfterForwardAlpha : CameraEvent.AfterEverything;
				if (!_attached.TryGetValue(imgui, out Attached attached) || attached.Camera != camera || attached.Event != evt)
				{
					Detach(imgui);
					attached = new Attached { Camera = camera, Event = evt, Buffer = new CommandBuffer { name = "UImGui (built-in)" } };
					camera.AddCommandBuffer(evt, attached.Buffer);
					_attached[imgui] = attached;
				}
				CommandBuffer buffer = attached.Buffer;
				buffer.Clear();
				DrawCommandUtils.BuildCommandBuffer(ref buffer, context.DrawCommands);
			}
			_stale.Clear();
			foreach (KeyValuePair<UImGuiBehaviour, Attached> entry in _attached)
			{
				if (entry.Key == null || !entry.Key.isActiveAndEnabled)
				{
					_stale.Add(entry.Key);
				}
			}
			for (int i = 0; i < _stale.Count; i++)
			{
				Detach(_stale[i]);
			}
		}

		private void OnDestroy()
		{
			DetachAll();
		}

		private void Detach(UImGuiBehaviour imgui)
		{
			if (!_attached.TryGetValue(imgui, out Attached attached))
			{
				return;
			}
			if (attached.Camera != null)
			{
				attached.Camera.RemoveCommandBuffer(attached.Event, attached.Buffer);
			}
			attached.Buffer.Release();
			_attached.Remove(imgui);
		}

		private void DetachAll()
		{
			_stale.Clear();
			_stale.AddRange(_attached.Keys);
			for (int i = 0; i < _stale.Count; i++)
			{
				Detach(_stale[i]);
			}
		}
	}
}
