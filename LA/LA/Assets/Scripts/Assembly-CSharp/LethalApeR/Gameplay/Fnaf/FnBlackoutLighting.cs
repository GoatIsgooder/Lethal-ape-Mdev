using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnBlackoutLighting : MonoBehaviour
	{
		private static readonly int Volume0Id = Shader.PropertyToID("_Volume0");

		private static readonly int Volume1Id = Shader.PropertyToID("_Volume1");

		private static readonly int Volume2Id = Shader.PropertyToID("_Volume2");

		private static readonly int VolumeMaskId = Shader.PropertyToID("_VolumeMask");

		private static readonly int GlobalVolumeMinId = Shader.PropertyToID("_GlobalVolumeMin");

		private static readonly int GlobalVolumeInvSizeId = Shader.PropertyToID("_GlobalVolumeInvSize");

		private static readonly int GlobalVolumeVoxelSizeId = Shader.PropertyToID("_GlobalVolumeVoxelSize");

		[Tooltip("Power-out lightmaps (colour), in the scene's lightmap order. Filled by Tools ▸ FNAF ▸ Bake Lighting.")]
		public Texture2D[] blackoutColor = new Texture2D[0];

		[Tooltip("Power-out MonoSH direction maps, same order.")]
		public Texture2D[] blackoutDir = new Texture2D[0];

		[Tooltip("Power-out light probes: 27 floats (SH L2, RGB) per probe, in the scene's probe order.")]
		[HideInInspector]
		public float[] blackoutProbes = new float[0];

		[Tooltip("The lights that die with the power; their emissive panels switch off in a blackout.")]
		public Transform powerRoot;

		[Tooltip("Reflection probes under this rig keep their power-on cubemaps; in a blackout their intensity drops to this fraction.")]
		[Range(0f, 1f)]
		public float blackoutReflection = 0.08f;

		[Tooltip("The party room's volume bake: the global volume in hub rooms. Filled by Tools ▸ FNAF ▸ Bake Lighting.")]
		public FnBakedVolume hubVolume = new FnBakedVolume();

		[Tooltip("The night map's volume bake, power-on and power-out: the global volume in night rooms.")]
		public FnBakedVolume nightVolume = new FnBakedVolume();

		private LightmapData[] _powered;

		private LightmapData[] _dark;

		private SphericalHarmonicsL2[] _poweredProbes;

		private SphericalHarmonicsL2[] _darkProbes;

		private Renderer[] _fixtures;

		private ReflectionProbe[] _reflections;

		private float[] _reflectionIntensity;

		private bool _isDark;

		public bool IsDark => _isDark;

		public bool HasBlackoutBake => blackoutColor != null && blackoutColor.Length != 0;

		private void OnEnable()
		{
			ApplyVolume();
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			bool flag = instance != null && instance.InNightRoom && instance.Blackout;
			if (_isDark != flag)
			{
				Apply(flag);
			}
			ApplyVolume();
		}

		private void OnDisable()
		{
			if (_isDark)
			{
				Apply(false);
			}
		}

		private void Apply(bool dark)
		{
			_isDark = dark;
			if (_fixtures == null && powerRoot != null)
			{
				_fixtures = powerRoot.GetComponentsInChildren<Renderer>(true);
			}
			if (_fixtures != null)
			{
				for (int i = 0; i < _fixtures.Length; i++)
				{
					if (_fixtures[i] != null)
					{
						_fixtures[i].enabled = !dark;
					}
				}
			}
			DimReflections(dark);
			if (blackoutColor == null || blackoutColor.Length == 0)
			{
				return;
			}
			if (dark)
			{
				_powered = LightmapSettings.lightmaps;
				if (_dark == null || _dark.Length != _powered.Length)
				{
					_dark = new LightmapData[_powered.Length];
					for (int j = 0; j < _powered.Length; j++)
					{
						_dark[j] = new LightmapData
						{
							lightmapColor = ((j < blackoutColor.Length && blackoutColor[j] != null) ? blackoutColor[j] : _powered[j].lightmapColor),
							lightmapDir = ((j < blackoutDir.Length && blackoutDir[j] != null) ? blackoutDir[j] : _powered[j].lightmapDir),
							shadowMask = _powered[j].shadowMask
						};
					}
				}
				LightmapSettings.lightmaps = _dark;
			}
			else if (_powered != null)
			{
				LightmapSettings.lightmaps = _powered;
			}
			SwapProbes(dark);
		}

		private void ApplyVolume()
		{
			FnGame instance = FnGame.Instance;
			bool flag = instance == null || instance.RoomKind != FnRoomKind.Night;
			FnBakedVolume fnBakedVolume = (flag ? hubVolume : nightVolume);
			if (fnBakedVolume == null || !fnBakedVolume.IsBaked)
			{
				return;
			}
			bool flag2 = flag || !_isDark || !fnBakedVolume.HasDark;
			Texture3D texture3D = (flag2 ? fnBakedVolume.sh0 : fnBakedVolume.darkSh0);
			if (!(Shader.GetGlobalTexture(Volume0Id) == texture3D))
			{
				Shader.SetGlobalTexture(Volume0Id, texture3D);
				Shader.SetGlobalTexture(Volume1Id, flag2 ? fnBakedVolume.sh1 : fnBakedVolume.darkSh1);
				Shader.SetGlobalTexture(Volume2Id, flag2 ? fnBakedVolume.sh2 : fnBakedVolume.darkSh2);
				Shader.SetGlobalTexture(VolumeMaskId, null);
				Shader.SetGlobalVector(GlobalVolumeMinId, new Vector4(fnBakedVolume.min.x, fnBakedVolume.min.y, fnBakedVolume.min.z, 0f));
				Shader.SetGlobalVector(GlobalVolumeInvSizeId, new Vector4(1f / fnBakedVolume.size.x, 1f / fnBakedVolume.size.y, 1f / fnBakedVolume.size.z, 0f));
				Shader.SetGlobalVector(GlobalVolumeVoxelSizeId, new Vector4(1f / (float)texture3D.width, 1f / (float)texture3D.height, 1f / (float)texture3D.depth, 0f));
			}
		}

		private void DimReflections(bool dark)
		{
			if (_reflections == null)
			{
				_reflections = GetComponentsInChildren<ReflectionProbe>(true);
				_reflectionIntensity = new float[_reflections.Length];
				for (int i = 0; i < _reflections.Length; i++)
				{
					_reflectionIntensity[i] = _reflections[i].intensity;
				}
			}
			for (int j = 0; j < _reflections.Length; j++)
			{
				if (_reflections[j] != null)
				{
					_reflections[j].intensity = (dark ? (_reflectionIntensity[j] * blackoutReflection) : _reflectionIntensity[j]);
				}
			}
		}

		private void SwapProbes(bool dark)
		{
			LightProbes lightProbes = LightmapSettings.lightProbes;
			if (lightProbes == null)
			{
				return;
			}
			int count = lightProbes.count;
			if (blackoutProbes == null || count * 27 != blackoutProbes.Length)
			{
				return;
			}
			if (dark)
			{
				_poweredProbes = lightProbes.bakedProbes;
				if (_darkProbes == null || count != _darkProbes.Length)
				{
					_darkProbes = new SphericalHarmonicsL2[count];
					for (int i = 0; i < count; i++)
					{
						SphericalHarmonicsL2 sphericalHarmonicsL = default(SphericalHarmonicsL2);
						for (int j = 0; j < 3; j++)
						{
							for (int k = 0; k < 9; k++)
							{
								sphericalHarmonicsL[j, k] = blackoutProbes[i * 27 + j * 9 + k];
							}
						}
						_darkProbes[i] = sphericalHarmonicsL;
					}
				}
				lightProbes.bakedProbes = _darkProbes;
			}
			else if (_poweredProbes != null)
			{
				lightProbes.bakedProbes = _poweredProbes;
			}
		}
	}
}
