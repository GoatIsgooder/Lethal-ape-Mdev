using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnAtmosphere : MonoBehaviour
	{
		[Serializable]
		public class Profile
		{
			public Color ambient = new Color(0.4f, 0.4f, 0.42f, 1f);

			public float ambientIntensity = 1f;

			public bool fog = true;

			public FogMode fogMode = FogMode.Linear;

			public Color fogColor = new Color(0.02f, 0.02f, 0.03f, 1f);

			public float fogStart = 4f;

			public float fogEnd = 26f;

			public float fogDensity = 0.04f;

			public Material skybox;

			[Tooltip("Ambience loop source to voice while this profile is active (FnAudioGate, optional).")]
			public FnAudioGate ambience;
		}

		public Profile hub = new Profile
		{
			ambient = new Color(0.55f, 0.52f, 0.48f, 1f),
			fog = false
		};

		public Profile night = new Profile
		{
			ambient = new Color(0.035f, 0.035f, 0.05f, 1f),
			fog = true,
			fogColor = new Color(0.01f, 0.01f, 0.015f, 1f),
			fogStart = 3f,
			fogEnd = 22f
		};

		private FnGame _game;

		private void OnEnable()
		{
			_game = FnGame.Instance;
			if (_game != null)
			{
				_game.RoomKindChanged += Apply;
			}
			Apply((_game != null) ? _game.RoomKind : FnRoomKind.None);
		}

		private void OnDisable()
		{
			if (_game != null)
			{
				_game.RoomKindChanged -= Apply;
			}
		}

		public void Apply(FnRoomKind kind)
		{
			Profile profile = ((kind == FnRoomKind.Night) ? night : hub);
			Profile profile2 = ((kind == FnRoomKind.Night) ? hub : night);
			RenderSettings.ambientMode = AmbientMode.Flat;
			RenderSettings.ambientLight = profile.ambient * profile.ambientIntensity;
			RenderSettings.fog = profile.fog;
			RenderSettings.fogMode = profile.fogMode;
			RenderSettings.fogColor = profile.fogColor;
			RenderSettings.fogStartDistance = profile.fogStart;
			RenderSettings.fogEndDistance = profile.fogEnd;
			RenderSettings.fogDensity = profile.fogDensity;
			if (profile.skybox != null)
			{
				RenderSettings.skybox = profile.skybox;
			}
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				FillClip(hub.ambience, audio.hubAmbienceLoop);
				FillClip(night.ambience, audio.nightAmbienceLoop);
			}
			if (profile2.ambience != null)
			{
				profile2.ambience.Wanted = false;
			}
			if (profile.ambience != null)
			{
				profile.ambience.Wanted = true;
			}
		}

		private static void FillClip(FnAudioGate gate, AudioClip clip)
		{
			if (!(gate == null) && !(clip == null))
			{
				AudioSource component = gate.GetComponent<AudioSource>();
				if (component != null && component.clip == null)
				{
					component.clip = clip;
				}
			}
		}
	}
}
