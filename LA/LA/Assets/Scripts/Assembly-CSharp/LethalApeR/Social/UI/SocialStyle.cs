using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LethalApeR.Social.UI
{
	public static class SocialStyle
	{
		public static readonly Color Board = Hex(0x0A0A0B);

		public static readonly Color Row = Hex(0x111113);

		public static readonly Color Wheel = Hex(0x141416);

		public static readonly Color Tile = Hex(0x1A1A1D);

		public static readonly Color Edge = Hex(0x2A2A2E);

		public static readonly Color Button = Hex(0x26262A);

		public static readonly Color ButtonOff = Hex(0x18181B);

		public static readonly Color White = Hex(0xF2F2F2);

		public static readonly Color Ink = Hex(0x0A0A0B);

		public static readonly Color TextSoft = Hex(0xD4D4DA);

		public static readonly Color TextMuted = Hex(0xA1A1A8);

		public static readonly Color TextFaint = Hex(0x8E8E96);

		public static readonly Color TextOff = Hex(0x7C7C85);

		public static readonly Color TextGone = Hex(0x5C5C63);

		public static readonly Color Danger = Hex(0xFF5C5C);

		public static readonly Color Confirm = Hex(0xC62F2F);

		public static readonly Color Online = Hex(0x4ADE80);

		public static readonly Color Away = Hex(0xF5B544);

		public static readonly Color Offline = Hex(0x5C5C63);

		private static AudioSource _audio;

		public static Color Hex(int rgb)
		{
			return new Color((float)((rgb >> 16) & 0xFF) / 255f, (float)((rgb >> 8) & 0xFF) / 255f, (float)(rgb & 0xFF) / 255f, 1f);
		}

		public static Color StatusColour(PresenceStatus status)
		{
			return status switch
			{
				PresenceStatus.Online => Online,
				PresenceStatus.Away => Away,
				_ => Offline,
			};
		}

		public static string StatusText(PresenceStatus status)
		{
			return status switch
			{
				PresenceStatus.Online => "ONLINE",
				PresenceStatus.Away => "AWAY",
				_ => "OFFLINE",
			};
		}

		public static void PlayPress()
		{
			Play((SocialAssets.Instance != null) ? SocialAssets.Instance.pressClip : null, 0.55f);
		}

		public static void Play(AudioClip clip, float volume)
		{
			if (!(clip == null))
			{
				if (_audio == null)
				{
					GameObject obj = new GameObject("[Social] UI Audio");
					Object.DontDestroyOnLoad(obj);
					_audio = obj.AddComponent<AudioSource>();
					_audio.playOnAwake = false;
					_audio.spatialBlend = 0f;
					_audio.spatialize = false;
					_audio.bypassReverbZones = true;
				}
				_audio.PlayOneShot(clip, volume);
			}
		}

		public static void Pulse(bool leftHand, float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				if (leftHand)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}
	}
}
