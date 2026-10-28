using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public static class AgHaptics
	{
		public static void Left(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				instance.PulseLeft(amplitude, duration);
			}
		}

		public static void Right(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				instance.PulseRight(amplitude, duration);
			}
		}

		public static void Both(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				instance.PulseLeft(amplitude, duration);
				instance.PulseRight(amplitude, duration);
			}
		}
	}
}
