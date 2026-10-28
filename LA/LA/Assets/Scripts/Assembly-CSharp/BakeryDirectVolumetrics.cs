using UnityEngine;
using UnityEngine.XR;

[ExecuteInEditMode]
[ImageEffectAllowedInSceneView]
[RequireComponent(typeof(Camera))]
public class BakeryDirectVolumetrics : MonoBehaviour
{
	public enum DebugMode
	{
		Off = 0,
		ShowFroxelSlice = 1
	}

	[Header("References")]
	public Shader compositeShader;

	public ComputeShader froxelCompute;

	public BakeryVolume bakeryVolume;

	[Header("Fog")]
	[Range(0.001f, 0.5f)]
	public float extinction = 0.02f;

	[Range(0f, 1f)]
	public float scatteringAlbedo = 0.9f;

	[Range(0.01f, 20f)]
	public float intensity = 1f;

	[Header("Anisotropic Scattering (L1)")]
	[Tooltip("Use Bakery L1 SH bands to recover dominant light direction. Required for visible cones / shafts.")]
	public bool useDirectionalSH = true;

	[Tooltip("Henyey-Greenstein anisotropy. 0 = isotropic. 0.6-0.8 = forward scattering (shafts visible looking toward lights).")]
	[Range(-0.95f, 0.95f)]
	public float anisotropy = 0.7f;

	[Tooltip("How much of the directional SH contribution to mix in. 0 = old L0-only look, 1 = full directional.")]
	[Range(0f, 1f)]
	public float directionalScale = 1f;

	[Header("Real-time Per-Light Cones")]
	[Tooltip("Drop the actual fixture Light components here. Each contributes a localized fog cone that falls off to zero outside the light's range, so distant rooms stay dark.")]
	public Light[] volumetricLights = new Light[0];

	[Tooltip("Master multiplier for real-time light contribution.")]
	[Range(0f, 50f)]
	public float realtimeStrength = 2f;

	[Tooltip("HG anisotropy for real-time lights. 0.7-0.85 gives tight visible cones around each fixture.")]
	[Range(-0.95f, 0.95f)]
	public float realtimeAnisotropy = 0.75f;

	[Header("Range")]
	[Range(0.1f, 5f)]
	public float fogNear = 0.3f;

	[Range(5f, 500f)]
	public float fogFar = 60f;

	[Tooltip("Exponential depth packing. 1 = linear, 2 = quadratic (recommended), higher = more density near camera.")]
	[Range(1f, 4f)]
	public float zPower = 2f;

	[Header("Height Falloff")]
	public float fogBaseHeight;

	[Range(0f, 2f)]
	public float heightFalloff = 0.25f;

	[Header("Density Noise")]
	[Range(0f, 1f)]
	public float noiseStrength = 0.6f;

	public float noiseCellSize = 2.5f;

	public Vector3 noiseScrollDir = new Vector3(0.1f, 0.03f, 0.07f);

	[Range(0f, 5f)]
	public float noiseSpeed = 0.3f;

	[Header("Froxel Grid")]
	[Tooltip("Screen divisor. Quest 2: 12. Quest 3: 10. Lower = sharper but costly.")]
	[Range(4f, 16f)]
	public int xyDownscale = 10;

	[Tooltip("Depth slices. With reprojection + zPower=2, 32 looks like ~64 linear.")]
	[Range(16f, 128f)]
	public int depthSlices = 32;

	[Header("Temporal")]
	public bool temporalJitter = true;

	public bool temporalReprojection = true;

	[Tooltip("Fraction of CURRENT frame blended into history each frame (Frostbite ~0.05).")]
	[Range(0.01f, 1f)]
	public float historyBlend = 0.05f;

	[Header("Debug")]
	public DebugMode debugMode;

	private Material compositeMat;

	private Camera cam;

	private int kernelFill;

	private int prevGridX;

	private int prevGridY;

	private int prevGridZ;

	private int frameCounter;

	private int lastJitterFrame = -1;

	private Vector2 cachedJitXY;

	private float cachedJitterZ;

	private const int MAX_VOLUMETRIC_LIGHTS = 32;

	private static readonly Vector4[] _lightPosRange = new Vector4[32];

	private static readonly Vector4[] _lightColor = new Vector4[32];

	private RenderTexture[,] froxelRT = new RenderTexture[2, 2];

	private int[] pingPong = new int[2];

	private bool[] historyValid = new bool[2];

	private Matrix4x4[] prevView = new Matrix4x4[2]
	{
		Matrix4x4.identity,
		Matrix4x4.identity
	};

	private Matrix4x4[] prevViewProj = new Matrix4x4[2]
	{
		Matrix4x4.identity,
		Matrix4x4.identity
	};

	private void OnEnable()
	{
		cam = GetComponent<Camera>();
		cam.depthTextureMode |= DepthTextureMode.Depth;
		if (compositeShader == null)
		{
			compositeShader = Shader.Find("Hidden/BakeryDirectVolumetricFog");
		}
		if (compositeShader != null && compositeMat == null)
		{
			compositeMat = new Material(compositeShader);
		}
		if (froxelCompute != null)
		{
			kernelFill = froxelCompute.FindKernel("FillAndAccumulate");
		}
		historyValid[0] = false;
		historyValid[1] = false;
	}

	private void OnDisable()
	{
		DestroyMat();
		DestroyAllRTs();
	}

	private void DestroyMat()
	{
		if (!(compositeMat == null))
		{
			if (Application.isPlaying)
			{
				Object.Destroy(compositeMat);
			}
			else
			{
				Object.DestroyImmediate(compositeMat);
			}
			compositeMat = null;
		}
	}

	private void DestroyRT(ref RenderTexture rt)
	{
		if (!(rt == null))
		{
			rt.Release();
			if (Application.isPlaying)
			{
				Object.Destroy(rt);
			}
			else
			{
				Object.DestroyImmediate(rt);
			}
			rt = null;
		}
	}

	private void DestroyAllRTs()
	{
		for (int i = 0; i < 2; i++)
		{
			for (int j = 0; j < 2; j++)
			{
				DestroyRT(ref froxelRT[i, j]);
			}
		}
		historyValid[0] = false;
		historyValid[1] = false;
	}

	private RenderTexture CreateFroxelRT(int gx, int gy, int gz)
	{
		RenderTexture renderTexture = new RenderTexture(gx, gy, 0, RenderTextureFormat.ARGBHalf);
		renderTexture.dimension = UnityEngine.Rendering.TextureDimension.Tex3D;
		renderTexture.volumeDepth = gz;
		renderTexture.enableRandomWrite = true;
		renderTexture.filterMode = FilterMode.Bilinear;
		renderTexture.wrapMode = TextureWrapMode.Clamp;
		renderTexture.Create();
		return renderTexture;
	}

	private void EnsureEyeRTs(int eye, int gx, int gy, int gz)
	{
		if (prevGridX != gx || prevGridY != gy || prevGridZ != gz)
		{
			DestroyAllRTs();
			prevGridX = gx;
			prevGridY = gy;
			prevGridZ = gz;
		}
		for (int i = 0; i < 2; i++)
		{
			if (froxelRT[eye, i] == null)
			{
				froxelRT[eye, i] = CreateFroxelRT(gx, gy, gz);
				historyValid[eye] = false;
			}
		}
	}

	private static Matrix4x4 BuildFrustumCorners(Matrix4x4 viewMatrix, Matrix4x4 proj)
	{
		Matrix4x4 inverse = viewMatrix.inverse;
		Matrix4x4 result = default(Matrix4x4);
		result.SetRow(0, inverse.MultiplyVector(new Vector3((proj.m02 + -1f) / proj.m00, (proj.m12 + -1f) / proj.m11, -1f)));
		result.SetRow(1, inverse.MultiplyVector(new Vector3((proj.m02 + 1f) / proj.m00, (proj.m12 + -1f) / proj.m11, -1f)));
		result.SetRow(2, inverse.MultiplyVector(new Vector3((proj.m02 + -1f) / proj.m00, (proj.m12 + 1f) / proj.m11, -1f)));
		result.SetRow(3, inverse.MultiplyVector(new Vector3((proj.m02 + 1f) / proj.m00, (proj.m12 + 1f) / proj.m11, -1f)));
		return result;
	}

	private int EyeIndex()
	{
		if (cam.stereoActiveEye != Camera.MonoOrStereoscopicEye.Right)
		{
			return 0;
		}
		return 1;
	}

	private bool IsSinglePassInstanced()
	{
		if (XRSettings.enabled)
		{
			if (XRSettings.stereoRenderingMode != XRSettings.StereoRenderingMode.SinglePassInstanced)
			{
				return XRSettings.stereoRenderingMode == XRSettings.StereoRenderingMode.SinglePassMultiview;
			}
			return true;
		}
		return false;
	}

	private static Vector2 R2(int n)
	{
		return new Vector2(Mathf.Repeat(0.5f + 0.7548776f * (float)n, 1f), Mathf.Repeat(0.5f + 0.56984025f * (float)n, 1f));
	}

	private void OnPreRender()
	{
		if (bakeryVolume != null)
		{
			bakeryVolume.SetGlobalParams();
		}
	}

	[ImageEffectOpaque]
	private void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		if (compositeMat == null || froxelCompute == null || bakeryVolume == null || bakeryVolume.bakedTexture0 == null)
		{
			Graphics.Blit(src, dst);
			return;
		}
		int gx = Mathf.Max(1, src.width / xyDownscale);
		int gy = Mathf.Max(1, src.height / xyDownscale);
		int gz = depthSlices;
		Vector2 jitXY;
		float jitterZ;
		if (temporalJitter)
		{
			int frameCount = Time.frameCount;
			if (frameCount != lastJitterFrame)
			{
				Vector2 vector = R2(frameCounter);
				cachedJitXY = new Vector2(vector.x - 0.5f, vector.y - 0.5f);
				cachedJitterZ = Mathf.Repeat((float)frameCounter * 0.7548777f, 1f) - 0.5f;
				frameCounter++;
				lastJitterFrame = frameCount;
			}
			jitXY = cachedJitXY;
			jitterZ = cachedJitterZ;
		}
		else
		{
			jitXY = Vector2.zero;
			jitterZ = 0f;
		}
		RenderTexture value;
		RenderTexture value2;
		if (IsSinglePassInstanced())
		{
			Matrix4x4 stereoViewMatrix = cam.GetStereoViewMatrix(Camera.StereoscopicEye.Left);
			Matrix4x4 stereoProjectionMatrix = cam.GetStereoProjectionMatrix(Camera.StereoscopicEye.Left);
			Matrix4x4 stereoViewMatrix2 = cam.GetStereoViewMatrix(Camera.StereoscopicEye.Right);
			Matrix4x4 stereoProjectionMatrix2 = cam.GetStereoProjectionMatrix(Camera.StereoscopicEye.Right);
			value = DispatchEye(0, gx, gy, gz, stereoViewMatrix, stereoProjectionMatrix, jitXY, jitterZ);
			value2 = DispatchEye(1, gx, gy, gz, stereoViewMatrix2, stereoProjectionMatrix2, jitXY, jitterZ);
		}
		else
		{
			Camera.MonoOrStereoscopicEye stereoActiveEye = cam.stereoActiveEye;
			int num = ((stereoActiveEye == Camera.MonoOrStereoscopicEye.Right) ? 1 : 0);
			Matrix4x4 view;
			Matrix4x4 proj;
			if (stereoActiveEye == Camera.MonoOrStereoscopicEye.Left || stereoActiveEye == Camera.MonoOrStereoscopicEye.Right)
			{
				view = cam.GetStereoViewMatrix((Camera.StereoscopicEye)num);
				proj = cam.GetStereoProjectionMatrix((Camera.StereoscopicEye)num);
			}
			else
			{
				view = cam.worldToCameraMatrix;
				proj = cam.projectionMatrix;
			}
			value = (value2 = DispatchEye(num, gx, gy, gz, view, proj, jitXY, jitterZ));
		}
		compositeMat.SetTexture("_FroxelTex", value);
		compositeMat.SetTexture("_FroxelTexRight", value2);
		compositeMat.SetFloat("_FogNear", fogNear);
		compositeMat.SetFloat("_FogRangeInv", 1f / Mathf.Max(fogFar - fogNear, 0.001f));
		compositeMat.SetFloat("_ZPowerInv", 1f / Mathf.Max(zPower, 1f));
		Graphics.Blit(src, dst, compositeMat, 0);
	}

	private RenderTexture DispatchEye(int eye, int gx, int gy, int gz, Matrix4x4 view, Matrix4x4 proj, Vector2 jitXY, float jitterZ)
	{
		EnsureEyeRTs(eye, gx, gy, gz);
		int num = pingPong[eye];
		int num2 = 1 - num;
		RenderTexture renderTexture = froxelRT[eye, num];
		RenderTexture renderTexture2 = froxelRT[eye, num2];
		Matrix4x4 matrix4x = BuildFrustumCorners(view, proj);
		Vector3 vector = view.inverse.GetColumn(3);
		bool flag = temporalReprojection && historyValid[eye] && renderTexture2 != null;
		froxelCompute.SetTexture(kernelFill, "_FroxelOutput", renderTexture);
		froxelCompute.SetTexture(kernelFill, "_Vol0", bakeryVolume.bakedTexture0);
		bool flag2 = useDirectionalSH && bakeryVolume.bakedTexture1 != null && bakeryVolume.bakedTexture2 != null;
		froxelCompute.SetTexture(kernelFill, "_Vol1", flag2 ? bakeryVolume.bakedTexture1 : bakeryVolume.bakedTexture0);
		froxelCompute.SetTexture(kernelFill, "_Vol2", flag2 ? bakeryVolume.bakedTexture2 : bakeryVolume.bakedTexture0);
		froxelCompute.SetFloat("_HasL1", flag2 ? 1f : 0f);
		froxelCompute.SetFloat("_Anisotropy", anisotropy);
		froxelCompute.SetFloat("_DirectionalScale", directionalScale);
		int num3 = 0;
		if (volumetricLights != null)
		{
			for (int i = 0; i < volumetricLights.Length; i++)
			{
				if (num3 >= 32)
				{
					break;
				}
				Light light = volumetricLights[i];
				if (!(light == null) && light.enabled && light.gameObject.activeInHierarchy)
				{
					Vector3 position = light.transform.position;
					Color color = light.color;
					float num4 = light.intensity;
					_lightPosRange[num3] = new Vector4(position.x, position.y, position.z, light.range);
					_lightColor[num3] = new Vector4(color.r * num4, color.g * num4, color.b * num4, 1f);
					num3++;
				}
			}
		}
		for (int j = num3; j < 32; j++)
		{
			_lightPosRange[j] = Vector4.zero;
			_lightColor[j] = Vector4.zero;
		}
		froxelCompute.SetVectorArray("_LightsPosRange", _lightPosRange);
		froxelCompute.SetVectorArray("_LightsColor", _lightColor);
		froxelCompute.SetInt("_LightCount", num3);
		froxelCompute.SetFloat("_RealtimeStrength", realtimeStrength);
		froxelCompute.SetFloat("_RealtimeAnisotropy", realtimeAnisotropy);
		froxelCompute.SetTexture(kernelFill, "_FroxelHistory", flag ? renderTexture2 : renderTexture);
		froxelCompute.SetVector("_CamPos", vector);
		froxelCompute.SetVector("_VolumeMin", bakeryVolume.GetMin());
		Vector3 size = bakeryVolume.bounds.size;
		froxelCompute.SetVector("_VolumeInvSize", new Vector3(1f / size.x, 1f / size.y, 1f / size.z));
		froxelCompute.SetVector("_FrustumBL", new Vector3(matrix4x.m00, matrix4x.m01, matrix4x.m02));
		froxelCompute.SetVector("_FrustumBR", new Vector3(matrix4x.m10, matrix4x.m11, matrix4x.m12));
		froxelCompute.SetVector("_FrustumTL", new Vector3(matrix4x.m20, matrix4x.m21, matrix4x.m22));
		froxelCompute.SetVector("_FrustumTR", new Vector3(matrix4x.m30, matrix4x.m31, matrix4x.m32));
		froxelCompute.SetFloat("_Near", fogNear);
		froxelCompute.SetFloat("_Far", fogFar);
		froxelCompute.SetFloat("_Extinction", extinction);
		froxelCompute.SetFloat("_ScatteringAlbedo", scatteringAlbedo);
		froxelCompute.SetFloat("_Intensity", intensity);
		froxelCompute.SetFloat("_Jitter", jitterZ);
		froxelCompute.SetVector("_JitterXY", jitXY);
		froxelCompute.SetFloat("_ZPower", Mathf.Max(zPower, 1f));
		froxelCompute.SetFloat("_HeightFalloff", heightFalloff);
		froxelCompute.SetFloat("_FogBaseHeight", fogBaseHeight);
		float num5 = 1f / Mathf.Max(noiseCellSize, 0.001f);
		froxelCompute.SetVector("_NoiseScale", new Vector3(num5, num5, num5));
		froxelCompute.SetVector("_NoiseScroll", noiseScrollDir * noiseSpeed);
		froxelCompute.SetFloat("_NoiseStrength", noiseStrength);
		froxelCompute.SetFloat("_NoiseTime", Application.isPlaying ? Time.time : Time.realtimeSinceStartup);
		froxelCompute.SetMatrix("_PrevView", prevView[eye]);
		froxelCompute.SetMatrix("_PrevViewProj", prevViewProj[eye]);
		froxelCompute.SetFloat("_HistoryBlend", historyBlend);
		froxelCompute.SetFloat("_HistoryValid", flag ? 1f : 0f);
		froxelCompute.SetInt("_GridX", gx);
		froxelCompute.SetInt("_GridY", gy);
		froxelCompute.SetInt("_GridZ", gz);
		froxelCompute.Dispatch(kernelFill, Mathf.CeilToInt((float)gx / 8f), Mathf.CeilToInt((float)gy / 8f), 1);
		prevView[eye] = view;
		prevViewProj[eye] = proj * view;
		pingPong[eye] = num2;
		historyValid[eye] = true;
		return renderTexture;
	}

	private void OnDrawGizmosSelected()
	{
		if (!(bakeryVolume == null))
		{
			Gizmos.color = new Color(0f, 1f, 0.5f, 0.3f);
			Gizmos.DrawWireCube(bakeryVolume.bounds.center, bakeryVolume.bounds.size);
		}
	}
}
