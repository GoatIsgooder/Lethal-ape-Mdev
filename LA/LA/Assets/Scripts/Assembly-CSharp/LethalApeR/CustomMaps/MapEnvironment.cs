using LethalApe.SDK;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.CustomMaps
{
	public sealed class MapEnvironment
	{
		private struct Snapshot
		{
			public bool Fog;

			public Color FogColor;

			public FogMode FogMode;

			public float FogDensity;

			public float FogStart;

			public float FogEnd;

			public Material Skybox;

			public AmbientMode AmbientMode;

			public Color AmbientSky;

			public Color AmbientEquator;

			public Color AmbientGround;

			public Color AmbientLight;

			public float AmbientIntensity;

			public bool SunEnabled;

			public Color SunColor;

			public float SunIntensity;

			public Quaternion SunRotation;

			public CameraClearFlags ClearFlags;

			public Color Background;

			public float FarClip;
		}

		private Snapshot _saved;

		private bool _applied;

		private Light _sun;

		private Camera _camera;

		private bool _underwater;

		private Color _mapSky;

		private bool _mapFog;

		private Color _mapFogColor;

		private FogMode _mapFogMode;

		private float _mapFogDensity;

		public void Apply(MapSettings s, Material skybox, Light sun, Camera camera)
		{
			if (!_applied)
			{
				Save(sun, camera);
			}
			_applied = true;
			RenderSettings.fog = s.Fog;
			RenderSettings.fogColor = s.FogColor;
			RenderSettings.fogMode = s.FogMode;
			RenderSettings.fogDensity = s.FogDensity;
			RenderSettings.fogStartDistance = s.FogStart;
			RenderSettings.fogEndDistance = s.FogEnd;
			RenderSettings.skybox = skybox;
			RenderSettings.ambientMode = ((s.AmbientMode == MapAmbientMode.Flat) ? AmbientMode.Flat : AmbientMode.Trilight);
			RenderSettings.ambientSkyColor = s.AmbientSky;
			RenderSettings.ambientEquatorColor = s.AmbientEquator;
			RenderSettings.ambientGroundColor = s.AmbientGround;
			RenderSettings.ambientLight = s.AmbientSky;
			RenderSettings.ambientIntensity = 1f;
			DynamicGI.UpdateEnvironment();
			if (_sun != null)
			{
				_sun.enabled = s.Sun;
				_sun.color = s.SunColor;
				_sun.intensity = s.SunIntensity;
				_sun.transform.rotation = s.SunRotation;
			}
			if (_camera != null)
			{
				_camera.clearFlags = ((skybox != null) ? CameraClearFlags.Skybox : CameraClearFlags.SolidColor);
				_camera.backgroundColor = s.SkyColor;
				_camera.farClipPlane = Mathf.Clamp(s.ViewDistance, 50f, 300f);
			}
			_mapSky = s.SkyColor;
			_mapFog = s.Fog;
			_underwater = false;
			_mapFogColor = s.FogColor;
			_mapFogMode = s.FogMode;
			_mapFogDensity = s.FogDensity;
		}

		public void SetUnderwater(bool underwater, Color color, float density)
		{
			if (!_applied || _underwater == underwater)
			{
				return;
			}
			_underwater = underwater;
			if (underwater)
			{
				RenderSettings.fog = true;
				RenderSettings.fogColor = color;
				RenderSettings.fogMode = FogMode.ExponentialSquared;
				RenderSettings.fogDensity = density;
				if (_camera != null)
				{
					_camera.backgroundColor = color;
				}
			}
			else
			{
				RenderSettings.fog = _mapFog;
				RenderSettings.fogColor = _mapFogColor;
				RenderSettings.fogMode = _mapFogMode;
				RenderSettings.fogDensity = _mapFogDensity;
				if (_camera != null)
				{
					_camera.backgroundColor = _mapSky;
				}
			}
		}

		public void Restore()
		{
			if (!_applied)
			{
				return;
			}
			_applied = false;
			_underwater = false;
			RenderSettings.fog = _saved.Fog;
			RenderSettings.fogColor = _saved.FogColor;
			RenderSettings.fogMode = _saved.FogMode;
			RenderSettings.fogDensity = _saved.FogDensity;
			RenderSettings.fogStartDistance = _saved.FogStart;
			RenderSettings.fogEndDistance = _saved.FogEnd;
			RenderSettings.skybox = _saved.Skybox;
			RenderSettings.ambientMode = _saved.AmbientMode;
			RenderSettings.ambientSkyColor = _saved.AmbientSky;
			RenderSettings.ambientEquatorColor = _saved.AmbientEquator;
			RenderSettings.ambientGroundColor = _saved.AmbientGround;
			RenderSettings.ambientLight = _saved.AmbientLight;
			RenderSettings.ambientIntensity = _saved.AmbientIntensity;
			DynamicGI.UpdateEnvironment();
			if (_sun != null)
			{
				_sun.enabled = _saved.SunEnabled;
				_sun.color = _saved.SunColor;
				_sun.intensity = _saved.SunIntensity;
				_sun.transform.rotation = _saved.SunRotation;
			}
			if (_camera != null)
			{
				_camera.clearFlags = _saved.ClearFlags;
				_camera.backgroundColor = _saved.Background;
				_camera.farClipPlane = _saved.FarClip;
			}
		}

		private void Save(Light sun, Camera camera)
		{
			_sun = sun;
			_camera = camera;
			_saved = new Snapshot
			{
				Fog = RenderSettings.fog,
				FogColor = RenderSettings.fogColor,
				FogMode = RenderSettings.fogMode,
				FogDensity = RenderSettings.fogDensity,
				FogStart = RenderSettings.fogStartDistance,
				FogEnd = RenderSettings.fogEndDistance,
				Skybox = RenderSettings.skybox,
				AmbientMode = RenderSettings.ambientMode,
				AmbientSky = RenderSettings.ambientSkyColor,
				AmbientEquator = RenderSettings.ambientEquatorColor,
				AmbientGround = RenderSettings.ambientGroundColor,
				AmbientLight = RenderSettings.ambientLight,
				AmbientIntensity = RenderSettings.ambientIntensity
			};
			if (sun != null)
			{
				_saved.SunEnabled = sun.enabled;
				_saved.SunColor = sun.color;
				_saved.SunIntensity = sun.intensity;
				_saved.SunRotation = sun.transform.rotation;
			}
			if (camera != null)
			{
				_saved.ClearFlags = camera.clearFlags;
				_saved.Background = camera.backgroundColor;
				_saved.FarClip = camera.farClipPlane;
			}
		}
	}
}
