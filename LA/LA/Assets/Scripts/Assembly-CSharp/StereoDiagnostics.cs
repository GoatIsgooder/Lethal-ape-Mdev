using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.XR;

[DefaultExecutionOrder(-10000)]
[DisallowMultipleComponent]
public class StereoDiagnostics : MonoBehaviour
{
	[Tooltip("Seconds between samples.")]
	[SerializeField]
	private float logInterval = 2f;

	[Tooltip("Survive scene loads so this follows you from the loading screen into MainScene.")]
	[SerializeField]
	private bool persistAcrossScenes = true;

	[Tooltip("How many recent reports to keep in the file. Enough to cover the transition.")]
	[SerializeField]
	private int keepReports = 6;

	private readonly List<XRDisplaySubsystem> _displays = new List<XRDisplaySubsystem>();

	private readonly Queue<string> _history = new Queue<string>();

	private readonly StringBuilder _sb = new StringBuilder(2048);

	private readonly StringBuilder _file = new StringBuilder(8192);

	private float _next;

	private int _reports;

	private int _lastFrame;

	private string _summary = "(no sample yet)";

	public static string ReportPath => Path.Combine(Application.persistentDataPath, "stereodiag.txt");

	private void Awake()
	{
		if (persistAcrossScenes)
		{
			UnityEngine.Object.DontDestroyOnLoad(base.gameObject);
		}
		_lastFrame = Time.frameCount;
	}

	private void Update()
	{
		if (!(Time.unscaledTime < _next))
		{
			_next = Time.unscaledTime + Mathf.Max(0.25f, logInterval);
			_reports++;
			Sample();
			Flush();
		}
	}

	private void Sample()
	{
		int num = Time.frameCount - _lastFrame;
		_lastFrame = Time.frameCount;
		RenderTextureDescriptor eyeTextureDesc = XRSettings.eyeTextureDesc;
		bool flag = false;
		int num2 = -1;
		int num3 = -1;
		_displays.Clear();
		SubsystemManager.GetSubsystems(_displays);
		if (_displays.Count > 0)
		{
			flag = _displays[0].running;
			num2 = _displays[0].GetRenderPassCount();
			if (num2 > 0)
			{
				_displays[0].GetRenderPass(0, out var renderPass);
				num3 = renderPass.renderTargetDesc.volumeDepth;
			}
		}
		Camera[] allCameras = Camera.allCameras;
		Camera camera = null;
		Camera[] array = allCameras;
		foreach (Camera camera2 in array)
		{
			if (camera2.targetTexture == null && camera2.stereoTargetEye != StereoTargetEyeMask.None)
			{
				camera = camera2;
				break;
			}
		}
		_summary = string.Concat(new string[22]
		{
			"scene=",
			SceneManager.GetActiveScene().name,
			"  frames+",
			num.ToString(),
			"\nmode=",
			XRSettings.stereoRenderingMode.ToString(),
			"\neyeTex dim=",
			eyeTextureDesc.dimension.ToString(),
			" volDepth=",
			eyeTextureDesc.volumeDepth.ToString(),
			"\ndisplay running=",
			flag.ToString(),
			" passes=",
			num2.ToString(),
			" passVolDepth=",
			num3.ToString(),
			"\nHMDcam=",
			(camera == null) ? "NONE!" : camera.name,
			" stereoEnabled=",
			(camera == null) ? "-" : camera.stereoEnabled.ToString(),
			"\ncameras=",
			allCameras.Length.ToString()
		});
		_sb.Length = 0;
		_sb.Append("=== #").Append(_reports).Append(' ')
			.Append(SceneManager.GetActiveScene().name)
			.Append(" frame=")
			.Append(Time.frameCount)
			.Append(" (+")
			.Append(num)
			.Append(")\n");
		_sb.Append("XR: active=").Append(XRSettings.isDeviceActive).Append(" dev=")
			.Append(XRSettings.loadedDeviceName)
			.Append(" mode=")
			.Append(XRSettings.stereoRenderingMode)
			.Append(" eye=")
			.Append(XRSettings.eyeTextureWidth)
			.Append('x')
			.Append(XRSettings.eyeTextureHeight)
			.Append('\n');
		_sb.Append("eyeTexDesc: dim=").Append(eyeTextureDesc.dimension).Append(" volDepth=")
			.Append(eyeTextureDesc.volumeDepth)
			.Append(" vrUsage=")
			.Append(eyeTextureDesc.vrUsage)
			.Append(" msaa=")
			.Append(eyeTextureDesc.msaaSamples)
			.Append(" fmt=")
			.Append(eyeTextureDesc.graphicsFormat)
			.Append('\n');
		if (_displays.Count == 0)
		{
			_sb.Append("!! NO XRDisplaySubsystem\n");
		}
		for (int j = 0; j < _displays.Count; j++)
		{
			XRDisplaySubsystem xRDisplaySubsystem = _displays[j];
			int renderPassCount = xRDisplaySubsystem.GetRenderPassCount();
			_sb.Append("Display[").Append(j).Append("] running=")
				.Append(xRDisplaySubsystem.running)
				.Append(" passes=")
				.Append(renderPassCount)
				.Append('\n');
			for (int k = 0; k < renderPassCount; k++)
			{
				xRDisplaySubsystem.GetRenderPass(k, out var renderPass2);
				RenderTextureDescriptor renderTargetDesc = renderPass2.renderTargetDesc;
				_sb.Append("  pass[").Append(k).Append("] dim=")
					.Append(renderTargetDesc.dimension)
					.Append(" volDepth=")
					.Append(renderTargetDesc.volumeDepth)
					.Append(' ')
					.Append(renderTargetDesc.width)
					.Append('x')
					.Append(renderTargetDesc.height)
					.Append(" msaa=")
					.Append(renderTargetDesc.msaaSamples)
					.Append(" params=")
					.Append(renderPass2.GetRenderParameterCount())
					.Append('\n');
			}
		}
		Array.Sort(allCameras, (Camera a, Camera b) => a.depth.CompareTo(b.depth));
		_sb.Append("Cameras (").Append(allCameras.Length).Append("):\n");
		array = allCameras;
		foreach (Camera camera3 in array)
		{
			_sb.Append("  ").Append(camera3.name).Append(" d=")
				.Append(camera3.depth)
				.Append(" en=")
				.Append(camera3.enabled)
				.Append(" stereo=")
				.Append(camera3.stereoEnabled)
				.Append(" eye=")
				.Append(camera3.stereoTargetEye)
				.Append(" rt=")
				.Append((camera3.targetTexture == null) ? "null" : camera3.targetTexture.name)
				.Append(" clear=")
				.Append(camera3.clearFlags)
				.Append(" hdr=")
				.Append(camera3.allowHDR)
				.Append(" msaa=")
				.Append(camera3.allowMSAA)
				.Append('\n');
		}
		Debug.Log(_sb.ToString());
		_history.Enqueue(_sb.ToString());
		while (_history.Count > Mathf.Max(1, keepReports))
		{
			_history.Dequeue();
		}
	}

	private void Flush()
	{
		try
		{
			_file.Length = 0;
			_file.Append("SUMMARY (last sample)\n").Append(_summary).Append("\n\n---- detail ----\n");
			foreach (string item in _history)
			{
				_file.Append(item).Append('\n');
			}
			File.WriteAllText(ReportPath, _file.ToString());
		}
		catch (Exception ex)
		{
			Debug.LogWarning("[StereoDiagnostics] write failed: " + ex.Message);
		}
	}
}
