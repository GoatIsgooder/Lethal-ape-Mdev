using System;
using System.Text;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Rendering
{
	public static class SlopRenderTuning
	{
		public const bool EnableFoveation = true;

		public const bool UseDynamicFoveation = true;

		public const OVRManager.FoveatedRenderingLevel FoveationLevel = OVRManager.FoveatedRenderingLevel.High;

		public const bool EnableDynamicResolution = true;

		public const float MinResolutionScale = 0.8f;

		public const float MaxResolutionScale = 1f;

		public static float RuntimeScaleOverride = -1f;

		private static bool _installed;

		public static float CurrentViewportScale { get; private set; } = 1f;

		public static bool FoveationSupported { get; private set; }

		public static string LastStatus { get; private set; } = "not applied yet";

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Install()
		{
			if (!_installed)
			{
				_installed = true;
				GameObject go = new GameObject("SlopRenderTuning");
				go.hideFlags = HideFlags.HideAndDontSave;
				UnityEngine.Object.DontDestroyOnLoad(go);
				go.AddComponent<SlopRenderTuningRunner>();
			}
		}

		public static void Apply(OVRManager manager)
		{
			StringBuilder sb = new StringBuilder();
			try
			{
				FoveationSupported = OVRManager.fixedFoveatedRenderingSupported;
				if (FoveationSupported)
				{
					OVRManager.foveatedRenderingLevel = FoveationLevel;
					OVRManager.useDynamicFoveatedRendering = UseDynamicFoveation;
					sb.Append("foveation=");
					sb.Append(FoveationLevel);
					sb.Append("(dynamic) ");
				}
				else
				{
					sb.Append("foveation=unsupported ");
				}
			}
			catch (Exception ex)
			{
				sb.Append("foveation FAILED(");
				sb.Append(ex.Message);
				sb.Append(") ");
			}
			try
			{
				if (manager != null)
				{
					manager.minDynamicResolutionScale = MinResolutionScale;
					manager.maxDynamicResolutionScale = MaxResolutionScale;
					manager.quest2MinDynamicResolutionScale = MinResolutionScale;
					manager.quest2MaxDynamicResolutionScale = MaxResolutionScale;
					manager.quest3MinDynamicResolutionScale = MinResolutionScale;
					manager.quest3MaxDynamicResolutionScale = MaxResolutionScale;
					manager.enableDynamicResolution = EnableDynamicResolution;
					if (XRSettings.eyeTextureResolutionScale > 1f)
					{
						XRSettings.eyeTextureResolutionScale = 1f;
					}
					sb.Append("dynRes=");
					sb.Append(MinResolutionScale.ToString("0.00"));
					sb.Append("..");
					sb.Append(MaxResolutionScale.ToString("0.00"));
					sb.Append(' ');
				}
				else
				{
					sb.Append("dynRes=off ");
				}
			}
			catch (Exception ex2)
			{
				sb.Append("dynRes FAILED(");
				sb.Append(ex2.Message);
				sb.Append(") ");
			}
			sb.Append("eyeScale=");
			sb.Append(XRSettings.eyeTextureResolutionScale.ToString("0.00")).Append(" eyeTex=").Append(XRSettings.eyeTextureWidth)
				.Append('x')
				.Append(XRSettings.eyeTextureHeight);
			LastStatus = sb.ToString();
		}

		internal static void TickOverride()
		{
			if (RuntimeScaleOverride > 0f)
			{
				float target = Mathf.Clamp(RuntimeScaleOverride, 0.5f, 1f);
				if (!Mathf.Approximately(XRSettings.renderViewportScale, target))
				{
					XRSettings.renderViewportScale = target;
				}
			}
			else if (!Mathf.Approximately(XRSettings.renderViewportScale, 1f))
			{
				XRSettings.renderViewportScale = 1f;
			}
			CurrentViewportScale = XRSettings.renderViewportScale;
		}
	}
}
