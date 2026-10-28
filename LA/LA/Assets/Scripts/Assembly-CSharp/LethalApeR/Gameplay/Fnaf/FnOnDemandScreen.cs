using System;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(200)]
	public class FnOnDemandScreen : MonoBehaviour
	{
		[Tooltip("Disabled orthographic camera framing the content. Its culling mask holds only the content's layer; its background colour is the picture's (alpha 0 for an overlay).")]
		public Camera screenCamera;

		[Tooltip("The monitor whose glass shows the picture.")]
		public Renderer glass;

		[Tooltip("Material slot of the glass on that renderer (the LA CRT's screen submesh is slot 1).")]
		public int glassMaterialIndex = 1;

		[Tooltip("The glass material's texture that receives the picture.")]
		public string textureProperty = "_MainTex";

		[Tooltip("Picture size in pixels. Keep the glass's aspect (the LA CRT's is 30.5 x 25.2 cm).")]
		public Vector2Int resolution = new Vector2Int(512, 424);

		private RenderTexture _rt;

		private MaterialPropertyBlock _mpb;

		private RenderPipeline.StandardRequest _request;

		private TMP_Text[] _texts = Array.Empty<TMP_Text>();

		private int _textureId;

		private bool _dirty = true;

		public void MarkDirty()
		{
			_dirty = true;
		}

		private void Awake()
		{
			_textureId = Shader.PropertyToID(string.IsNullOrEmpty(textureProperty) ? "_MainTex" : textureProperty);
			_texts = GetComponentsInChildren<TMP_Text>(true);
			if (!(screenCamera == null))
			{
				screenCamera.enabled = false;
				screenCamera.orthographic = true;
				screenCamera.clearFlags = CameraClearFlags.Color;
				screenCamera.stereoTargetEye = StereoTargetEyeMask.None;
				screenCamera.allowMSAA = false;
				screenCamera.allowHDR = false;
				screenCamera.allowDynamicResolution = false;
				screenCamera.useOcclusionCulling = false;
				screenCamera.depthTextureMode = DepthTextureMode.None;
				screenCamera.renderingPath = RenderingPath.Forward;
			}
		}

		private void OnEnable()
		{
			_dirty = true;
		}

		private void OnValidate()
		{
			resolution = new Vector2Int(Mathf.Clamp(resolution.x, 64, 2048), Mathf.Clamp(resolution.y, 64, 2048));
			int max = ((glass != null) ? (glass.sharedMaterials.Length - 1) : 0);
			glassMaterialIndex = Mathf.Clamp(glassMaterialIndex, 0, Mathf.Max(0, max));
		}

		private void OnDestroy()
		{
			if (screenCamera != null && screenCamera.targetTexture == _rt)
			{
				screenCamera.targetTexture = null;
			}
			if (!(_rt == null))
			{
				_rt.Release();
				UnityEngine.Object.Destroy(_rt);
				_rt = null;
			}
		}

		private void LateUpdate()
		{
			if (!(screenCamera == null) && !(glass == null) && (_dirty || !(_rt != null) || !_rt.IsCreated()))
			{
				Draw();
			}
		}

		private void Draw()
		{
			EnsureTexture();
			for (int i = 0; i < _texts.Length; i++)
			{
				if (_texts[i] != null && _texts[i].havePropertiesChanged)
				{
					_texts[i].ForceMeshUpdate();
				}
			}
			screenCamera.aspect = (float)_rt.width / (float)_rt.height;
			bool fog = RenderSettings.fog;
			RenderSettings.fog = false;
			try
			{
				Render();
			}
			finally
			{
				RenderSettings.fog = fog;
			}
			_dirty = false;
		}

		private void Render()
		{
			if (GraphicsSettings.currentRenderPipeline != null)
			{
				if (_request == null)
				{
					_request = new RenderPipeline.StandardRequest();
				}
				_request.destination = _rt;
				if (RenderPipeline.SupportsRenderRequest(screenCamera, _request))
				{
					RenderPipeline.SubmitRenderRequest(screenCamera, _request);
					return;
				}
			}
			screenCamera.Render();
		}

		private void EnsureTexture()
		{
			if (_rt == null)
			{
				RenderTexture renderTexture = new RenderTexture(resolution.x, resolution.y, 0, RenderTextureFormat.ARGB32);
				renderTexture.name = "FnOnDemandScreen " + base.name;
				renderTexture.antiAliasing = 1;
				renderTexture.useMipMap = true;
				renderTexture.autoGenerateMips = true;
				renderTexture.filterMode = FilterMode.Trilinear;
				renderTexture.anisoLevel = 4;
				renderTexture.wrapMode = TextureWrapMode.Clamp;
				_rt = renderTexture;
			}
			if (!_rt.IsCreated())
			{
				_rt.Create();
			}
			if (screenCamera.targetTexture != _rt)
			{
				screenCamera.targetTexture = _rt;
			}
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			glass.GetPropertyBlock(_mpb, glassMaterialIndex);
			if (!(_mpb.GetTexture(_textureId) == _rt))
			{
				_mpb.SetTexture(_textureId, _rt);
				glass.SetPropertyBlock(_mpb, glassMaterialIndex);
			}
		}
	}
}
