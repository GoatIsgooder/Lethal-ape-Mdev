using UnityEngine;
using UnityEngine.XR;

[RequireComponent(typeof(Camera))]
[ExecuteAlways]
[DisallowMultipleComponent]
public class BackroomsFlickerScreenDarken : MonoBehaviour
{
	public enum DebugView
	{
		Off = 0,
		WorldPosition = 1,
		DarkenMask = 2
	}

	[Tooltip("Off = normal. World Position should show smooth colour gradients LOCKED to the room (not swimming with your head) — if they swim or mirror, reconstruction is wrong. Darken Mask shows where it dims (black = full dim).")]
	public DebugView debug;

	[Tooltip("Leave null to auto-find Hidden/Backrooms/FlickerScreenDarken.")]
	public Shader shader;

	private Camera _cam;

	private Material _mat;

	private static readonly int IdInvVP = Shader.PropertyToID("_FlkInvVP");

	private static readonly int IdInvVPRight = Shader.PropertyToID("_FlkInvVPRight");

	private static readonly int IdDebug = Shader.PropertyToID("_FlkScreenDebug");

	private void OnEnable()
	{
		_cam = GetComponent<Camera>();
		_cam.depthTextureMode |= DepthTextureMode.Depth;
		BackroomsFlickerManager.Ensure();
	}

	private void OnDisable()
	{
		if (_mat != null)
		{
			if (Application.isPlaying)
			{
				Object.Destroy(_mat);
			}
			else
			{
				Object.DestroyImmediate(_mat);
			}
			_mat = null;
		}
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		if (BackroomsFlickerGroup.Groups.Count <= 0 && BackroomsFlickerLight.Active.Count <= 0)
		{
			Graphics.Blit(src, dst);
			return;
		}
		if (shader == null)
		{
			shader = Shader.Find("Hidden/Backrooms/FlickerScreenDarken");
		}
		if (shader == null || !shader.isSupported)
		{
			Graphics.Blit(src, dst);
			return;
		}
		if (_mat == null)
		{
			_mat = new Material(shader)
			{
				hideFlags = HideFlags.HideAndDontSave
			};
		}
		if (_cam.stereoEnabled)
		{
			if (XRSettings.stereoRenderingMode != XRSettings.StereoRenderingMode.MultiPass)
			{
				_mat.SetMatrix(IdInvVP, InvViewProj(_cam.GetStereoViewMatrix(Camera.StereoscopicEye.Left), _cam.GetStereoProjectionMatrix(Camera.StereoscopicEye.Left)));
				_mat.SetMatrix(IdInvVPRight, InvViewProj(_cam.GetStereoViewMatrix(Camera.StereoscopicEye.Right), _cam.GetStereoProjectionMatrix(Camera.StereoscopicEye.Right)));
			}
			else
			{
				Camera.StereoscopicEye eye = ((_cam.stereoActiveEye == Camera.MonoOrStereoscopicEye.Right) ? Camera.StereoscopicEye.Right : Camera.StereoscopicEye.Left);
				_mat.SetMatrix(IdInvVP, InvViewProj(_cam.GetStereoViewMatrix(eye), _cam.GetStereoProjectionMatrix(eye)));
			}
		}
		else
		{
			_mat.SetMatrix(IdInvVP, InvViewProj(_cam.worldToCameraMatrix, _cam.projectionMatrix));
		}
		_mat.SetFloat(IdDebug, (float)debug);
		Graphics.Blit(src, dst, _mat);
	}

	private static Matrix4x4 InvViewProj(Matrix4x4 view, Matrix4x4 proj)
	{
		return (GL.GetGPUProjectionMatrix(proj, renderIntoTexture: true) * view).inverse;
	}
}
